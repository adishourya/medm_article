#import "../callouts.typ": * 
= Model Architecture


== Instruct Models <section_instruct_models>
#plan[
  + what we expect from already pre-trained models.
    + to be very good at next token prediction .pretrained on large diverse organic datasets which is a key for transfer learning.
    + most of the models that get deployed also go through human feedback. which helps them align better and be safe.
    + Most offer same like phi-3 and paligemma.!
    + pick LVLM that show great results at transfer.
    + we picked paligemma-448 and paligemma-896 model for all of our experiments.
]
Large Multimodal models usually get trained in stages. The first step of training is usually referred to as *pre-training* where we train the model on a big corpus like @changpinyo2021cc12m @sharma2018conceptual @DBLP:journals1 @DBLP:journals2 . These datasets are usually called Instruct datasets. Models tuned on such datasets are in turn called *Instruct models* which act as the backbone for our application.One of the primary expectations of these models is to perform exceptionally well in next-token prediction at pre-training .This core functionality enables the model to generate coherent and contextually appropriate responses depending on the nature of the prompt

Pre-training on large and diverse datasets is essential, as it allows these models to capture and learn diverse signals across variety of domains which enables us to do *transfer learning* .The performance of the instruction tuned model is also measured on how well they perform in downstream applications without needing extensive task specific training.

Models besides being trained on parallel image-text interleave data also get supervised on serialized chat data which covers various topics to reflect human preferences on different aspects such as instruction following, truthfulness, honesty and helpfulness. Most of the models developed by large organizations undergo robust internal evaluations to measure toxicity, profanity, and other potential issues in the generated captions.Its a common practice to further train on datasets such as the FairFace dataset @karkkainenfairface with the intentions that the model does not capture biases originating from Race, Gender or Age. 


For our experiments, we select *Paligemma-mix-448* and *Paligemma-mix-896* @beyer2024paligemma as our base model across all of our experiments as they have demonstrated to be extremely versatile on transfer across many tasks and.By leveraging these models, we aim to obtain the current boundaries of what we can achieve fine tuning the instruction tuned LVLMs in terms of both accuracy and safety in medical domains.

#coherence[
  + repeated use of large diverse dataset.
]

== Model Architercture <section_model_architecture>
#plan[
+ Model Diagram (describe components) , phi3 technical report does not have a diagram #emoji.face.not but it still the same architecture. :
+ #todo[add lora finetune legend ?]
]

#figure(
image("../../our_images/model/model2.svg"),
caption: [Model Architecture for Generalist LVLMs @beyer2024paligemma],
placement: auto,
)<figure_model>

Most LVLMs consist of a Vision Tower, a projector, a connector, and a mini language model, typically following the architecture outlined in @figure_model. Paligemma specifically uses a SigLIP @zhai2023sigmoidlosslanguageimage image-based Vision Tower, with roughly 400 million parameters, and the Gemma-2B @gemmateam2024gemma2improvingopen as its mini language model. Notably, during the multimodal pretraining stage of the model, no weights are frozen in time, allowing all parameters to adjust during backpropagation.

We now present further details about the main components of the architecture.

+ *Vision Tower*: The Vision Tower is typically based on a decoder-only transformer architecture @vaswani2023attentionneed @dosovitskiy2021imageworth16x16words. Pretraining starts on a publicly available checkpoint of a shape-optimal Vision Transformer @alabdulmohsin2024gettingvitshapescaling,as it is crucial for effectively scaling the model.Selecting a model that was pretrained contrastively on a large scale via the sigmoid loss is typical as the architecture demonstrates state-of-the-art performance when applied to classification tasks, ensuring the model can achieve good results in vision-based applications. At a high level, the Vision Tower takes one or more images as input and works auto-regressively by applying self-attention across image patches to produce an output, commonly referred to as *image features*. It is important to note that this output is independent of any text instruction that may accompany the input image.



  // we will probe a bit more into the image features when we look into the saliency in @section_saliency.
+ *Projector*: A projection layer is necessary to align the output dimensionality of the vision tower with the token dimension of the language model's vocabulary, which is required for concatenation. While the projection can be implemented using multiple layers, the ablation study by @beyer2024paligemma found no significant advantage in employing multiple layers. Consequently,most VLMs use a single-layer projection.

 
+ *Concatenation*: The text prefix associated with the image is tokenized (here with @kudo2018sentencepiecesimplelanguageindependent ) and concatenated with the projected features from the vision tower. In practice, the prompt is often padded or truncated to align with the input dimension requirements of the language model.
 
+ *LLM*: With the concatenated features as input, a decoder-only transformer is employed as the language model. The first token is generated by attending fully to both the image features and the prefix token. Subsequent tokens are then generated autoregressively, relying on previously generated content and the concatinated features.

// Typically transferring is done with a frozen vision tower. But ...

// overview and model architecture should be around 500 words (looks nice)
// #lorem(500)


