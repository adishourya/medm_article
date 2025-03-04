#import "../callouts.typ": * 

= Discussion and Limitation <section_limit_discuss>
#plan[
  - *Question-Answer pair generation*:
  - LLMs like @touvron2023llamaopenefficientfoundation does not generate good open ended queries when generating lengthy answers
  - subsequently filteration process @fig_filtering suffers from the same issue. Thats why we perform manual filtering approach.

- *More Ablation studies needed across vision towers*:
  - solving local feature issues
  - current ablation studies focuses on the size of the LLM.
  - and we gain more local features just by increasing vision tower input size
  - But that is not enough. Vision tower suffer from resolution and does not perform well on chest x-rays which demand .
  - make arguments for using @zhang2024depthwiseconvolutionsvisiontransformers.

+ ablation studies with Depth-Wise Convolutions in Vision Transformers for Efficient Training on Small Datasets @zhang2024depthwiseconvolutionsvisiontransformers.


+ Although its hard to encode all the clinician diagnosis of a sample to a dataset. effort should be made on encoding the salient regions of the image.(this is so that we can have saliency based learning objective)
  - build dataset and train with saliency aware objective @aware_saliency

    
+ Most of the ablation studies @li2023llavamedtraininglargelanguageandvision focuses on increasing the number of layers in its LLM allowing it to better filter such bad signals from image features. (query from image patch to saliency on token from the last few layers.)

  - LLava Med saw improvement across all pathologies while evaluating accuracy .

  - However, we lack ablation studies on employing specialized vision tower. Although the SigLip Vision tower is shape optimal for most of the general domain tasks.Detecting abnormalities in radiological images need the model to learn both local and global image features.

]

Despite the improvements introduced in our methodology, several limitations remain, highlighting areas for future research and refinement.

- *Question-Answer Pair Generation*: LLMs such as LLaMA @touvron2023llamaopenefficientfoundation, struggle to generate high-quality open-ended queries, particularly when producing lengthy answers. This limitation extends to our automated filtering process @fig_filtering, which inherits the same issues. To mitigate this, we resorted to a manual filtering approach, ensuring higher-quality question-answer pairs which comes at the cost of increased time for data curation.

- *Ablation Studies on Vision Towers*: Existing ablation studies largely focus on scaling the LLM while sometimes overlooking critical aspects needed of the vision tower for radiological visual question answering. Although increasing the input resolution improves local feature extraction, it might still remain insufficient. We found our VLM struggle with images, such as chest X-rays, where fine-grained details are crucial. Notably, @eslami2021doesclipbenefitvisual found that a CNN-based ResNet model outperformed self-attention-based vision towers in scenarios requiring strong local feature context. Future work could explore depth-wise convolutions in Vision Transformers @zhang2024depthwiseconvolutionsvisiontransformers to enhance feature extraction efficiency, particularly for small dataset training.
