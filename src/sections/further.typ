#import "../callouts.typ": * 

= Discussion
#plan[
  + ablation studies with Depth-Wise Convolutions in Vision Transformers for Efficient Training on Small Datasets @zhang2024depthwiseconvolutionsvisiontransformers.
  + Most of the ablation studies are on different sizes of mini LLMs. (But not much on using specialized vision tower for the given task.)
  + Although its hard to encode all the clinician diagnosis of a sample to a dataset. effort should be made on encoding the salient regions of the image.(this is so that we can have saliency based learning objective)
    - build dataset and train with saliency aware objective
]
