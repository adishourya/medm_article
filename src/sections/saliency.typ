#import "../callouts.typ": * 

= Inspecting Saliency Maps <section_saliency>
#plan[

+ Hallucinations -> spurious signals -> ill conditioned metrics (trust evaluation?)

+ we need more data ? but which ? more images or more questions sampled from the images
+ But they are expensive. we can identify signals from a poorly scaled model.
+ justify saliency in self attention as they are just the queries and the weights and we can inspect relation from both ways (image to response , response to image , question to image , image to question)
+ human alignment scores from lay user .(helpfulness and so on) . experts to do saliency evaluation
  
// (accuracy questions can be sampled from an ill conditioned dataset.)
// - For an example on a badly scaled model we saw muted mean image to answer and high mean question to answer response on samples of open ended questions on a VQA Task.(need further testing :: I did only few examples).


  
  // (eg :@zhang2024depthwiseconvolutionsvisiontransformers).
  
// there are models that have saliency aware objective training @aware_saliency. we often use saliency aware segmentation @Saporta2022.
//   - since these models do not have saliency aware training . inspecting saliency adhoc is essential
#todo[!*Add extensive example set in appendix* ]
]

In our early model experiments, we observed generations indicative of what is commonly referred to as model hallucinations @xu2024hallucinationinevitableinnatelimitation when trained on a mix of organically and synthetically generated question labels. This suggests that the LLMs can learn spurious signals from image features or text input IDs for a given pathology when scaling is inadequate. As noted by @Singhal2023, most natural language metrics are poorly suited for evaluating medical question answering, and accuracy alone fails to capture the intermediate biases that such models learn.  


To mitigate this, one approach is to keep text input IDs constant or independent of the image, ensuring that the model primarily learns from image features. However, this approach has not led to good performance for visual question answering (VQA) on open-ended questions in general domains @kolling2020componentanalysisvisualquestion. This suggests that a larger volume of images or more sampled questions with adequate noise in the text input IDs is required for effective fine-tuning.But both of the approaches are constrained by the high cost of labeling.  

But more efforts can be made on detecting the source of bad signals by analyzing saliency maps. Although saliency is not the same as explainability @bertrand2022saliency, experts can often identify diagnostic indicators, as saliency in self-attention is fundamentally tied to the weights of queries  and keys learnt by the layers of the model. For medical VQA, model generated answers are often assigned alignment scores during human evaluation,we believe we need a similar alignment score for saliency analysis a subjective metric based on neighborhood hit rate @Saporta2022 evaluated by medical experts.

// Interpretability analysis has been in more demand lately in the medical field for applications like COVID-19 analysis and pathological retinal image categorization, among others.

We follow from the works of @stan2024lvlminterpretinterpretabilitytoollarge to inspect raw attentions and mean saliency analysis and newer methods like Attention rollout @abnar2020quantifyingattentionflowtransformers which makes efforts on quantifying flow of attention across layers.

== Raw Attentions <section_rawattention>
#plan[
  + To inspect relationship its as easy as collecting queries from the interested region and plot saliency on the keys from the input ids or the response.
  
  // Heatmaps that show average attentions between image to- kens and query tokens as well as answer tokens enables the user to better understand the global behavior of raw atten- tions.

  // between image patches and the selected tokens to obtain insight on how the model at- tends to the image when generating each token. Conversely, Figure 2b shows how a user can select image patches and visualize the degree to which each output tokens attends to that specific location.
]

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

#let raw_attention_fig = grid(rows:2,row-gutter: 8pt,
figure(rect(height: 100pt, width: 100pt)[Some Chest X-Ray],caption:[Interested Region]),
figure(rect(fill:my_colors.alt_fg , radius: 5pt,[#sailent_text]),caption:[Salient Response Tokens]),
)

#wrap-content(raw_attention_fig,glorem(num:160), align:bottom+right)


== Attention Rollout and Attention Flow <section_attentionflow>
#plan[
  
+ Models based on self attention often highlight disjointed patches @zhang2024depthwiseconvolutionsvisiontransformers rather than contiguous areas because:

  - non-contiguous attention regions might align poorly with human interpretability, especially in medical imaging, where contiguous regions are often more meaningful (e.g., a tumor boundary).

  - Convolutional based models make better saliency methods like GradCam @Selvaraju_2019  but newer methods have made significant attempts to provide better diagnostics for inspecting saliency @abnar2020quantifyingattentionflowtransformers allow to show attention flow.
  
]
#let rollout_fig = figure(rect(height: 100pt, width:100pt)[Rollout Image],caption:[Attention Rollout])
#wrap-content(rollout_fig,glorem(num:160), align:top+right)



