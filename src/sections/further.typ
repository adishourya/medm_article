#import "../callouts.typ": * 

= Discussion
#plan[
+ ablation studies with Depth-Wise Convolutions in Vision Transformers for Efficient Training on Small Datasets @zhang2024depthwiseconvolutionsvisiontransformers.


+ Although its hard to encode all the clinician diagnosis of a sample to a dataset. effort should be made on encoding the salient regions of the image.(this is so that we can have saliency based learning objective)
  - build dataset and train with saliency aware objective @aware_saliency

    
+ Most of the ablation studies @li2023llavamedtraininglargelanguageandvision focuses on increasing the number of layers in its LLM allowing it to better filter such bad signals from image features. (query from image patch to saliency on token from the last few layers.)

  - LLava Med saw improvement across all pathologies while evaluating accuracy .

  - However, we lack ablation studies on employing specialized vision tower. Although the SigLip Vision tower is shape optimal for most of the general domain tasks.Detecting abnormalities in radiological images need the model to learn both local and global image features.
  
]
