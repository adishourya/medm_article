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

In our early model experiments, we observed generations indicative of what is commonly referred to as model hallucinations @xu2024hallucinationinevitableinnatelimitation when trained on an insufficient volume of image question answer pairs. This suggests that the LLMs can learn spurious signals from image features or text input IDs for a given pathology when scaling is inadequate. As noted by @Singhal2023, most natural language metrics are poorly suited for evaluating medical question answering, and accuracy alone fails to capture the intermediate biases that such models learn.We believe that a subjective inspection of Saliency maps should be an axis of evaluation before a model is publically made available.  


To mitigate this, one approach is to keep text input IDs constant or independent of the image, ensuring that the model primarily learns from image features. However, this approach has not led to good performance for visual question answering (VQA) on open-ended questions in general domains @kolling2020componentanalysisvisualquestion. This suggests that a larger volume of images or more sampled questions with adequate noise in the text input IDs is required for effective fine-tuning.But both of the approaches are constrained by high cost of labeling.  

We believe more efforts can be made on detecting the source of bad signals by analyzing saliency maps. Although saliency is not the same as explainability @bertrand2022saliency, experts can often identify diagnostic indicators, as saliency in self-attention is fundamentally tied to the weights of queries  and keys learnt by the layers of the model @Mondal_covid_explainability.

// For an example in our early stage model experiments we saw unusually high question to answer mean response from the LLM compared to Image to Answer in a poorly scaled model.

// For medical VQA, model generated answers are often assigned alignment scores during human evaluation,we believe we need a similar alignment score for saliency analysis a subjective metric based on neighborhood hit rate @Saporta2022 evaluated by medical experts.

// Interpretability analysis has been in more demand lately in the medical field for applications like COVID-19 analysis and pathological retinal image categorization, among others.


In our experiments, we follow from the works of @stan2024lvlminterpretinterpretabilitytoollarge, @chefer_rollout and conduct saliency analysis on the intermediate layers of the LLM. As prior to the concatenation layer, there is no interaction between the text input IDs and the image features. In many fine-tuning schemes for VLMs in general domains, the weights of the vision tower are typically frozen, and only the layers of the LLM are trained. This approach ensures that the image features, up to the projection layer, remain unchanged, with the expectation that the attention heads of the LLM will learn to filter and select  only the relevant signals to guide the generation process. However, in our work, we fine-tune all layers of the model, including the vision tower. Despite this, it remains intriguing to visualize and analyze the interactions between the text input IDs, image features, and response tokens, which occur exclusively within the attention mechanisms of the LLM.

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
    markrect(Q, tag: #<q1> , color:#red , radius: #20%, padding:#.1em)
    mark(K , tag:#<k1> ,color:#green , radius:#20%)^T
    )/ sqrt(d_k)
  )V

  "or"
  
  "softmax"((
    markrect(Q, tag: #<q2> , color:#green , radius: #20%, padding:#.1em)
    mark(K , tag:#<k2> ,color:#red , radius:#20%)^T
    )/ sqrt(d_k)
  )V
  
  #annot(<A>, pos: bottom, yshift: 0.5em)[#text(size:5pt)[Scaled Dot Product Attention]]
  #annot(<q1>, pos: top+left , yshift: 1.2em)[query from selected response tokens]
  #annot(<k1>, pos: bottom+right, yshift : 3.2em)[keys from image patches]
  
  #annot(<q2>, pos: top+left , yshift: 1.2em)[query from image patch]
  #annot(<k2>, pos: bottom+right, yshift : 3.2em)[keys from response]
$


#let response_text = "Yes the Bone appears to be broken as there is a broken bone sticking out of the side of the leg"

#let sailent_text = {
let word_count = 0
let count_broken = 0
// #let salient_text = { 
for word in response_text.split(){
  if word_count ==10 {
    linebreak()
  }
  if word == "broken" and count_broken == 0{
    text(size:6pt,fill:red.darken(10%),style: "italic",[*#word*]) + " "
    count_broken +=1
    word_count +=1
  }
  else if word == "broken" and count_broken ==1{
    text(size:6pt,fill:red.lighten(20%),style: "oblique", [*#word*]) + " "
    word_count +=1
  }
  else{
    text(size:6pt,fill:my_colors.cmap_color,word) + " "
    word_count +=1
  }
}
}

#let raw_fig =  figure(rect([Layer 16 Head 8]+ image("../../our_images/saliency/bone1_raw.png",height: 100pt, width:100pt)),caption:[Interested Region])

#let raw_attention_fig = grid(rows:2,row-gutter: 8pt,
raw_fig,
figure(rect(fill:my_colors.alt_fg , radius: 5pt,[#sailent_text]),caption:[Saliency on Response Tokens]),
)

#let raw_section = [
  #glorem(num:120)
  // In our experiments we do saliency analysis on the intermediate layers of the LLM. As there is no interaction of text input IDS and the image features before the concatination layer.In many of the finetuning schemes of a VLM in general domain the weights of the vision tower are frozen and only the layers of the llms are trained i.e the image features before the projection layer reamins unchanged. with the intentions of llm heads filtering and picking the right signals to arrive at the generation.Although we finetune all the layers of our model including the vision tower it remains interesting to visualize the interaction between text input ids , image features and the response tokens which happens only in the attention head of the LLM.
#response_equation <equation_response>
]

#wrap-content(raw_attention_fig,raw_section, align:top+right)




== Attention Rollout and Attention Flow <section_attentionflow>
#plan[
  
+ Models based on self attention often highlight disjointed patches @zhang2024depthwiseconvolutionsvisiontransformers rather than contiguous areas because:

  - non-contiguous attention regions might align poorly with human interpretability, especially in medical imaging, where contiguous regions are often more meaningful (e.g., a tumor boundary).

  - Convolutional based models make better saliency methods like GradCam @Selvaraju_2019  but newer methods have made significant attempts to provide better diagnostics for inspecting saliency @abnar2020quantifyingattentionflowtransformers allow to show attention flow.
  
]
#let rollout_fig = figure(rect(height: 100pt, width:100pt)[Rollout Image],caption:[Attention Rollout])
#wrap-content(rollout_fig,glorem(num:160), align:top+right)



