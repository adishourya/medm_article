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
      - also they disclose their datasets that they have pretrained on.
      - it has been pretrained on open web datasets that may include some radiological images . so we might expect the model to have good zero shot performance on .
]
Large Multimodal models usually get trained in stages. The first step of training is usually referred to as *pre-training* where we train the model on a big corpus like @changpinyo2021cc12m @sharma2018conceptual @DBLP:journals1 @DBLP:journals2 to develop a *Base Model*. The Base Model in itself does not hold much utility to end-users as their sole objective has been to accurately predict the next token . To make the base model more useful to hold conversation we further train them on *Instruct Datasets* which aligns the model to make them suitable to hold conversations. .*Instruct models* act as the backbone for our application. This core functionality enables the model to generate coherent and contextually appropriate responses depending on the nature of the prompt.

// Pre-training on large and diverse datasets is essential, as it allows these models to capture and learn diverse signals across variety of domains which enables us to do *transfer learning* . The performance of the instruction tuned model is also measured on how well they perform in downstream applications without needing extensive task specific training.

Pre-training on large and diverse datasets is essential, as it allows these models to capture and learn diverse signals across a variety of domains, by enabling *transfer learning*. A technique where they are further trained on smaller, domain-specific datasets to refine their knowledge for a particular task. The effectiveness of an instruction-tuned model is often evaluated based on its performance in downstream applications without requiring extensive task-specific training, demonstrating its ability to generalize. 

Models besides being trained on parallel image-text interleave data also get supervised on serialized chat data which covers various topics to reflect human preferences on different aspects such as instruction following, truthfulness, honesty and helpfulness. Most of the models that are deployed undergo robust internal evaluations to measure toxicity, profanity, and other potential issues in the generated captions.Its a common practice to further train on datasets such as the FairFace dataset @karkkainenfairface with the intentions that the model does not capture biases originating from Race, Gender or Age. 


// We select *Paligemma-mix-448* and *Paligemma-mix-896* @beyer2024paligemma as our base model across all of our experiments #comment[also publically available . and pretrained on disclosed datastet like @pretrain_pali_changpinyo-etal-2022-may @pretrain_pali_piergiovanni2022pretrainingimagelanguagetransformersopenvocabulary @pretrain_pali_sharma-etal-2018-conceptual @pretrain_pali_Srinivasan_2021  ] as they have demonstrated to be extremely versatile on transfer across many tasks and.By leveraging these models, we aim to obtain the current boundaries of what we can achieve fine tuning the instruction tuned LVLMs in terms of both accuracy and safety in medical domains.

We select *PaliGemma-mix-448* @beyer2024paligemma as our base models across all of our experiments. These models are particularly well-suited for our study, as they have been pretrained on a diverse and well-curated collection of publicly available datasets @pretrain_pali_changpinyo-etal-2022-may, @pretrain_pali_piergiovanni2022pretrainingimagelanguagetransformersopenvocabulary, @pretrain_pali_sharma-etal-2018-conceptual, @pretrain_pali_Srinivasan_2021. This transparency in pretraining data stands in contrast with other approaches where such details are often undisclosed. This enables a better understanding of the model's zero shot capabilities and limitations.

The model demonstrates to be extremely versatile on transfer across many tasks.By leveraging these models, we aim to obtain the current boundaries of what we can achieve fine tuning lightweight VLM in terms of both accuracy and safety in medical domains.


#coherence[
  + repeated use of large diverse dataset.
]

== Model Architercture <section_model_architecture>
#plan[
+ Model Diagram (describe components) , phi3 technical report does not have a diagram #emoji.face.not but it still the same architecture. :
+ #todo[add lora finetune legend ?]
]

#figure(
// image("../../our_images/model/model2.svg"),
include("../../graphs/model_arch.typ"),
caption: [Model Architecture for Generalist VLMs @beyer2024paligemma],
placement: auto,
)<figure_model>

Most lightweight VLMs consist of a Vision Tower, a projector, a connector, and a mini language model, typically following the architecture outlined in @figure_model. For example, Paligemma specifically uses a SigLIP @zhai2023sigmoidlosslanguageimage  Vision Tower, with roughly 400 million parameters, and the Gemma-2B @gemmateam2024gemma2improvingopen as its mini language model. Notably, during the multimodal pretraining stage of the model, no weights are frozen in time, allowing all parameters to learn during backpropagation.

We now present further details about the main components of the architecture.

+ *Vision Tower*: The Vision Tower is typically based on a decoder-only transformer architecture @vaswani2023attentionneed @dosovitskiy2021imageworth16x16words. Pretraining starts on a publicly available checkpoint of a shape-optimal Vision Transformer @alabdulmohsin2024gettingvitshapescaling,as it is crucial for effectively scaling the model.Selecting a model that was pretrained contrastively on a large scale via the sigmoid loss is typical as the architecture demonstrates state-of-the-art performance when applied to classification tasks, ensuring the model can achieve good results in vision-based applications. At a high level, the Vision Tower takes one or more images as input and applies self-attention across image patches in a non causal manner to produce an output, commonly referred to as *image features*. It is important to note that this output is independent of any text instruction that may accompany the input image.



  // we will probe a bit more into the image features when we look into the saliency in @section_saliency.
+ *Projector*: A projection layer is necessary to align the output dimensionality of the vision tower with the token dimension of the language model's vocabulary, which is required for concatenation. While the projection can be implemented using multiple layers, the ablation study by @beyer2024paligemma found no significant advantage in employing multiple layers. Consequently,most VLMs use a single-layer projection.

 
+ *Concatenation*: The text prefix associated with the image is tokenized (here with @kudo2018sentencepiecesimplelanguageindependent ) and concatenated with the projected features from the vision tower. In practice, the prompt is often padded or truncated to align with the input dimension requirements of the language model.
 
+ *LLM*: With the concatenated features as input, a decoder-only transformer is employed as the language model. The first token is generated by attending fully to both the image features and the prefix token. Subsequent tokens are then generated autoregressively, relying on previously generated content and the concatinated features.

// Typically transferring is done with a frozen vision tower. But ...

// overview and model architecture should be around 500 words (looks nice)
// #lorem(500)


