#import "../callouts.typ": * 

= Inspecting Saliency Maps <section_saliency>
#plan[

+ In our scaling experiments @section_scaling we saw over fitting in our earlier model when we lacked data to finetune.Which indicates that the LLM can learn spurious signals from image features or text input ids for a given pathology if badly scaled (even if text input ids were organically labeled).Most natural language metrics are ill conditioned to @Singhal2023 and accuracy fail to fairly represent bias on such models.

    (leading accuracy to not always be the best metric)
  - we can keep text input ids constant or independent of the image to make sure that the model learns mostly from image features but that has not lead to good performance for visual question answering on open ended questions.
  
  - That implies we needed more volume in images or more noise in the text input ids.
  
  - But each of them is an expensive labelling task. we could make more efforts in detecting the source of bad signals by inspecting source of saliency.Although saliency is not the same as explainability @bertrand2022saliency and we lack method to gain a holistic view.exeperts can sometimes find indicators when used saliency as a diagnostic tool.
  
  - For example on a badly scaled model we saw muted mean image to answer and high mean question to answer response on an open ended questions on a medical image. (need further testing :: I did only few examples).


+ Most of the ablation studies from @li2023llavamedtraininglargelanguageandvision focuses on increasing the number of layers in its LLM allowing it to better filter such bad signals from image features. (query from image patch to saliency on token from the last few layers.)

  -  we lack focus on employing specialized vision tower. Although the SigLip Vision tower is shape optimal for most of the general domain tasks.Detecting abnormalities in radiological images need the model to learn both local and global image features (eg :@zhang2024depthwiseconvolutionsvisiontransformers).
  - self attention 


there are models that have saliency aware objective training @aware_saliency. we often use saliency aware segmentation @Saporta2022.
  - since these models do not have saliency aware training . inspecting saliency adhoc is essential
  
  - many vqa answers at human evaluation time get alignment scores.

  - we feel the need for subjective evaluation of both the vision tower and LLM both in conjunction and independently. (with metrics like hit rate from medical experts)
  


+ Models based on self attention often highlight disjointed patches @zhang2024depthwiseconvolutionsvisiontransformers rather than contiguous areas because:

  - The number of operations required to relate signals from two arbitrary input or output positions grows in the distance between positions, linearly for Convolutional based sequence to sequence models @gehring2017convolutionalsequencesequencelearning @annotatedtransformer. This makes it more difficult to learn dependencies between distant positions. In the Transformer this is reduced to a constant number of operations.This made it easier to learn global signals from distant inputs even in earlier layers.
  
  - Convolutional kernels excel at capturing fine details in images, a capability lacking in ViT models.Since Majority of the interest in Visual Question Answering in Radiology is detecting abnormalities in the image which requires the model learning signals from both distant and local features.

  - Majority of the questions in Radiology datasets involve detecting abnormalities in the input image . Which requires to learn local features . 

  - Convolutional based models make better saliency methods like GradCam @Selvaraju_2019  but newer methods have made significant attempts to provide better diagnostics for inspecting saliency @abnar2020quantifyingattentionflowtransformers allow to show attention flow.

  - non-contiguous attention regions might align poorly with human interpretability, especially in medical imaging, where contiguous regions are often more meaningful (e.g., a tumor boundary).

- Adaptive metrics for self attention :
  - metrics like hit rate in the neighbourhood of true saliency @Saporta2022
  - human evaluation for raw attentions from both vision tower and llm.

- !*Add extensive examples in appendix*
]



== Raw Attentions
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


== Attention Rollout and Attention Flow 
#glorem(num:100)


