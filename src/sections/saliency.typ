#import "../callouts.typ": * 
#import "@preview/mannot:0.2.0": * // for annotating equations

= Inspecting Saliency Maps <section_saliency>
#plan[

+ Hallucinations -> spurious signals -> ill conditioned metrics (trust evaluation?)

+ we need more data ? but which ? more images or more questions sampled from the images
+ But they are expensive. we can identify signals from a poorly scaled model.
+ justify saliency in self attention as they are just the queries and the weights and we can inspect relation from both ways (image to response , response to image , question to image , image to question)
+ human alignment scores from lay user .(helpfulness and so on) . experts to do saliency evaluation
+ @Mondal_covid_explainability did a tsne plot on the last layer to show how clustered the feature maps are on chest x ray images . [pneumonia vs others]
  
// (accuracy questions can be sampled from an ill conditioned dataset.)
// - For an example on a badly scaled model we saw muted mean image to answer and high mean question to answer response on samples of open ended questions on a VQA Task.(need further testing :: I did only few examples).


  
  // (eg :@zhang2024depthwiseconvolutionsvisiontransformers).
  
// there are models that have saliency aware objective training @aware_saliency. we often use saliency aware segmentation @Saporta2022.
//   - since these models do not have saliency aware training . inspecting saliency adhoc is essential
#todo[!*Add extensive example set in appendix* ]
]

In our early model experiments, we observed generations indicative of what is commonly referred to as model hallucinations @xu2024hallucinationinevitableinnatelimitation when trained on an insufficient volume of image question answer pairs. This suggests that the LLMs can learn spurious signals from image features or text input IDs for a given pathology when scaling is inadequate. As noted by @Singhal2023, most natural language metrics are poorly suited for evaluating medical question answering, and accuracy alone fails to capture the intermediate biases #comment[or be overestimated depending on the methodology to calculate accuracy] that the models learn.We believe that a subjective inspection of Saliency maps should be an axis of evaluation before a model is publically made available like the works in @Mondal_covid_explainability.  


To mitigate this, one approach is to keep text input IDs constant or independent of the image, ensuring that the model primarily learns from image features. However, this approach has not led to good performance for visual question answering (VQA) on open-ended questions in general domains @kolling2020componentanalysisvisualquestion. This suggests that a larger volume of images or more sampled questions with adequate noise in the text input IDs is required for effective fine-tuning.But both of the approaches are constrained by high cost of labeling.  

We believe more efforts can be made on detecting the source of bad signals by analyzing saliency maps. Although saliency is not the same as explainability @bertrand2022saliency, experts can often identify diagnostic indicators, as saliency in self-attention is fundamentally tied to the weights of queries  and keys learnt by the layers of the model @Mondal_covid_explainability.

// For an example in our early stage model experiments we saw unusually high question to answer mean response from the LLM compared to Image to Answer in a poorly scaled model.

// For medical VQA, model generated answers are often assigned alignment scores during human evaluation,we believe we need a similar alignment score for saliency analysis a subjective metric based on neighborhood hit rate @Saporta2022 evaluated by medical experts.

// Interpretability analysis has been in more demand lately in the medical field for applications like COVID-19 analysis and pathological retinal image categorization, among others.


In our experiments, we follow from the works of @stan2024lvlminterpretinterpretabilitytoollarge, @chefer_rollout and conduct saliency analysis on the intermediate layers of the LLM. As prior to the concatenation layer, there is no interaction between the text input IDs and the image features. In many fine-tuning schemes for VLMs in general domains, the weights of the vision tower are typically frozen, and only the weights of the LLM are trained. This approach ensures that the image features, up to the projection layer, remain unchanged, with the expectation that the attention heads of the LLM will learn to filter and select  only the relevant signals to guide the generation process. We visualize and analyze the interactions between the text input IDs, image features, and response tokens that occurs exclusively within the attention heads of the LLM.

We later visualize our saliency on the image features of a fine-tuned SIGLIP with methods like attention rollout @abnar2020quantifyingattentionflowtransformers which makes efforts on quantifying flow of attention across layers of a transformer model.

== Raw Attentions <section_rawattention>
#plan[

+ Convolutional kernels excel at capturing fine details in images, a capability lacking in attention based models.Since Majority of the interest in Visual Question Answering in Radiology is detecting abnormalities in the image which requires the model learning signals from both distant and local features.

+ The number of operations required to relate signals from two arbitrary input or output positions grows in the distance between positions, linearly for Convolutional based sequence to sequence models @gehring2017convolutionalsequencesequencelearning @annotatedtransformer. This makes it more difficult to learn dependencies between distant positions. In the Transformer this is reduced to a constant number of operations.This made it easier to learn global signals from distant inputs even in earlier layers.

  - Thereby the saliency maps on the earlier layers often looks noisy

- @huang2019attentionattentionimagecaptioning

+ In early layers, attention may focus more on local or simple relationships (e.g., pixel-level features in images), while in later layers, attention can capture higher-level semantics, such as object relationships or complex reasoning.
+ To inspect relationship is as easy as collecting queries from the interested token and plot saliency on the keys from the any of the input ids that is patched image feature,prompt or the response token bidirectionally.
]


#let response_equation = $
  markul("A", tag: #<A>)
  // "Attention"
  = "softmax"((
    markrect(Q, tag: #<q1> , color:#green , radius: #20%, padding:#.1em)
    mark(K , tag:#<k1> ,color:#red , radius:#20%)^T
    )/ sqrt(d_k)
  )V

  "or"
  
  "softmax"((
    markrect(Q, tag: #<q2> , color:#red , radius: #20%, padding:#.1em)
    mark(K , tag:#<k2> ,color:#blue , radius:#20%)^T
    )/ sqrt(d_k)
  )V
  
  #annot(<A>, pos: bottom, yshift: 0.5em)[#text(size:5pt)[Scaled Dot Product Attention]]
  #annot(<q1>, pos: top+left , yshift: 1.2em)[query from selected response tokens]
  #annot(<k1>, pos: bottom+right, yshift : 3.2em)[keys from image patches]
  
  #annot(<q2>, pos: top+left , yshift: 1.2em)[query from image patch]
  #annot(<k2>, pos: bottom+right, yshift : 3.2em)[keys from response]
$


#let response_text = "Yes the Bone appears to be broken as there is a broken bone sticking out of the side of the leg"

#let saliency_response = (0%,30%,-5%,15%,40%,15%,-10%,40%,20%,35%,32%,13%,20%,0%,30%,20%,15%,0%,25%,40%,10%)
// #saliency_response


#let sailent_text = {
let word_count = 0
let count_broken = 0
for word in response_text.split(){
  if word_count ==10 {
    linebreak()
  }
  if (saliency_response.at(word_count) < 15%) {
    
  text(size:8pt,fill:blue.darken(saliency_response.at(word_count)))[#underline[#word] ]}
  else{
  text(size:8pt,fill:blue.darken(saliency_response.at(word_count)))[#word ]}
    
    word_count +=1
  }
  }


#let raw_fig =  [#figure(
  rect(radius:5pt,stroke:black,fill:my_colors.alt_fg,

  [#text(size:8pt)[Layer 16 Head 8]] +
  v(-0.6em)+
  image("../../our_images/saliency/bone1_raw.png",height: 100pt, width:100pt)
  + v(-0.5em)
  +[#text(size:6pt,style:"italic")[#emoji.child: Does the bone appear to be fractured?]]
  + v(-0.8em)
  +[#line(stroke:(dash:"dashed",thickness:0.3pt),length: 110pt)]
  + v(-1.9em)
  +[#text(size:6pt,style:"italic",fill:green)[#linebreak()#emoji.robot: Yes the bone appe... leg <\end_of_turn\>]]
),
caption:[Interested Region])<fig_raw_attention_image>]

#let raw_attention_text = [#figure(rect(fill:my_colors.alt_fg , outset:1pt,radius: 5pt,[#text(size:5pt)[#emoji.robot: ]]+[#sailent_text] +[#linebreak() #text(size:5pt)[\<end_of_turn\>]]),caption: [Saliency on response tokens])<fig_rawattention_text>]

#let raw_attention_fig = [#grid(rows:2,row-gutter: 8pt,
raw_fig,
raw_attention_text)]

#let raw_section = [
  // #glorem(num:120)

  // - We can use raw attentions to perform saliency analysis by examining the interactions between queries and keys, which can be interpreted as the affinity or relevance of a token with the rest. This relation ultimately guides the model's generation.
  
  // - In earlier layers, attention can be noisy compared to convolutional based models where saliency looks a bit more contiguous. This is mostly because capturing relationships between features requires $O(n)$ operations for convolutional sequence to sequence models, while self-attention mechanisms can achieve this in constant time $O(1)$ making them more efficient and scalable.Although self attention sufferes from low resolution which was solved with the advent of multihead attention @vaswani2023attentionneed @annotatedtransformer.
  
  // - However, like convolutional models, self-attention-based models learn higher levels of abstraction as we propogate through the layers.
  
  // - Inspecting the relation is easy as it can be seen as collecting queries from target tokens and visualizing their atthention over the keys of other tokens in same or differnt modality.
  
  
  // - In @fig_raw_attention_image we inspect a single head of attention where we collect all the response tokens as the target query token and plot the average saliency over the image .

  // - but we can also select image patches from image . (here we select image patches in red) and the plot the saliency on the keys of the response id at @fig_rawattention_text

  We can use raw attention to perform saliency analysis by examining the interactions between queries and keys, this interaction can be seen as attempting to search for affinity or relevance of an interesting token with the rest. This relation is important as a collection of such relations ultimately guides the model's generation. In earlier layers, attention can be noisy compared to convolutional-based models, where saliency appears more contiguous. This is primarily because capturing relationships between features requires  $O(n)$ operations for convolutional sequence-to-sequence models, while self-attention mechanisms can achieve this in constant time $O(1)$, making them more efficient and scalable @annotatedtransformer. However, self-attention suffers from low resolution, which was addressed with the advent of multi-head attention @vaswani2023attentionneed
  
  Inspecting these relationships is easy as it only involves collecting queries from target tokens and visualizing their attention over the keys of other tokens, either within the same or across different modalities. In @fig_raw_attention_image, we inspect a single head of attention by collecting #text(fill:green)[all response tokens] as the target query and plotting the average saliency over the #text(fill:red)[image] (higher saliency highlighted in red) .Like convolutional models, self-attention-based models learn higher levels of abstraction as they propagate through the layers. So it becomes interesting to search for such relations in the last few layers , here we inspect 8th attention head of the penultimate layer. Additionally, we can select specific #text(fill:red)[image patches like the brightest spot] in @fig_raw_attention_image as query and plot the saliency on the keys of the #text(fill:blue)[response tokens], as shown in @fig_rawattention_text. (higher saliency highlighted in blue, top 7 tokens underlined).


  
#v(1.5em)
#response_equation <equation_response>
]

#wrap-content(raw_attention_fig,raw_section, align:top+right)




== Attention Rollout <section_attentionflow>
#plan[
  
+ Models based on self attention often highlight disjointed patches @zhang2024depthwiseconvolutionsvisiontransformers rather than contiguous areas because:

  - non-contiguous attention regions might align poorly with human interpretability, especially in medical imaging, where contiguous regions are often more meaningful (e.g., a tumor boundary).

  - Convolutional based models make better saliency methods like GradCam @Selvaraju_2019  but newer methods have made significant attempts to provide better diagnostics for inspecting saliency @abnar2020quantifyingattentionflowtransformers allow to show attention flow.
  
]

#let rollout_section = [

In Transformer-based models, raw attention weights do not always provide meaningful insights into token importance as we saw before. As information propagates through multiple layers, embeddings become increasingly mixed. This is because self-attention does not inherently preserve token identity across layers; rather, it continuously blends representations from multiple input tokens. As a result, by the time we reach higher layers, individual token contributions become obscure, and raw attention weights fail to capture the original token relationship @chefer_rollout . Moreover, raw attention saliency maps often appear noisy and less interpretable compared to methods like @Selvaraju_2019, @jacobgilpytorchcam, which provide more structured visualizations of important regions.

To address this issue, we look into recent methods like @chefer_rollout, @gildenblat_vit_explain. Attention Rollout tries to recursively aggregate attention across layers while also accommodating for skip connections. Our interest in using @chefer_rollout as a diagnostic tool mostly comes as an inspiration from @Mondal_covid_explainability, where medical experts leveraged saliency-based explainability methods like Attention Rollout to study chest X-rays and CT scans for disease classification in COVID-19 and pneumonia cases. Furthermore, their analysis also identified cases where a well scaled model struggled in correctly classifying the disease. This further confirms our belief that saliency inspection from a practicing radiologist should be considered an essential axis of evaluation for vision-language models, particularly in medical question answering.#footnote[#text(size:7pt)[our experiments with employing Attention Rollout and Attention Flow @chefer_rollout in visual question answering is still ongoing]]

]

#let rollout_fig = [
  #grid(rows:  2,row-gutter: 12pt,
  
  figure(rect(radius: 5pt,fill:my_colors.alt_fg.lighten(50%))[
    #image("../../our_images/saliency/roco_31069.jpg",height: 100pt,width:100pt)
    #v(-0.5em)
    #text(size:6pt,style: "italic")[#emoji.child: can you spot a fracture on the bone?]
    ],caption:[Test Input Example from @pelka2018roco]),
    
  figure(rect(radius: 5pt,fill:my_colors.alt_fg)[
    #text(size:8pt)[Rollout from the last 4 layers]
    #v(-0.5em)
    #image("../../our_images/saliency/rollout_roco31069.png",height: 100pt,width:100pt)
    #v(-0.5em)
    #text(size:6pt)[#emoji.robot: Yes there is a fracture on the bone #linebreak()
    in the image \<end_of_turn\>]
    ],caption:[Generation and Rollout Saliency]),
  
  )]

 // INFO:utils_attn:Mean Attention between the image and the token ['Yes', ',', 'there', 'is', 'a', 'fracture', 'on', 'the', 'bone', 'in', 'the', 'image', '.', '<end_of_turn>']
 


#wrap-content(rollout_fig,rollout_section, align:top+right)



