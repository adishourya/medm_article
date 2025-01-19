#import "../callouts.typ": * 

= Discussion
#plan[
+ ablation studies with Depth-Wise Convolutions in Vision Transformers for Efficient Training on Small Datasets @zhang2024depthwiseconvolutionsvisiontransformers.


+ Although its hard to encode all the clinician diagnosis of a sample to a dataset. effort should be made on encoding the salient regions of the image.(this is so that we can have saliency based learning objective)
  - build dataset and train with saliency aware objective @aware_saliency

    
+ Most of the ablation studies @li2023llavamedtraininglargelanguageandvision focuses on increasing the number of layers in its LLM allowing it to better filter such bad signals from image features. (query from image patch to saliency on token from the last few layers.)

  - LLava Med saw improvement across all pathologies while evaluating accuracy .

  - However, we lack ablation studies on employing specialized vision tower. Although the SigLip Vision tower is shape optimal for most of the general domain tasks.Detecting abnormalities in radiological images need the model to learn both local and global image features.
  
  - Convolutional kernels excel at capturing fine details in images, a capability lacking in ViT models.Since Majority of the interest in Visual Question Answering in Radiology is detecting abnormalities in the image which requires the model learning signals from both distant and local features.
  
  - The number of operations required to relate signals from two arbitrary input or output positions grows in the distance between positions, linearly for Convolutional based sequence to sequence models @gehring2017convolutionalsequencesequencelearning @annotatedtransformer. This makes it more difficult to learn dependencies between distant positions. In the Transformer this is reduced to a constant number of operations.This made it easier to learn global signals from distant inputs even in earlier layers.
]
