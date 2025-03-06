#import "../callouts.typ": *
#import "@preview/mannot:0.2.2":* 

= Training Recipe
#plan[
+ what we expect from an instruction tuned. model
  - human aligned , signals learnt in pretraining as we saw from @section_instruct_models

+ what more needs to be done:
  - design a curriculum learning.
  - Train on a medical instruct dataset . not frequently available with the latest (also smallest) multimodall llm.
  - briefly talk about the influence of the size of the dataset set up @section_scaling

+ summarize section
]

#figure(
  rect(inset: 12pt,fill: my_colors.alt_fg,radius: 5pt)[
#include "../../graphs/training_recipe_flow_chart.typ"],
caption: [Methodology]

) <fig_methodology>



// #todo[we will write this after we are done with section 4]
// Our main methodology that went into training our model is sumarized in @fig_methodology. We start with sourcing publically available radiological datasets and then take steps towards preprocessing the data to ensure its well conditioned for our model to be trained on.

// We then perform 2 stage finetuning on our datasets before moving onto evaluation where we examine model perfomance on our training dataset and ablation studies on data curation and our finetuning choices. We then follow it with performings diagnostics on our model with saliency analysis to take a step towards understanding model capabilities and limitations.

Our main methodology that goes into all the stages of the model development can be summarized from @fig_methodology, We begin by sourcing publicly available radiological datasets and curating the data to ensure it is well-conditioned for training. We then take steps through multiple preprocessing steps to ensure the data is well conditioned for our model to be train on.  

Next, we perform a two-stage fine-tuning process to optimize our model performance. The first stage finetuning can be seen as making the model learn preliminaries required before move onto the second stage, while the second stage training instruction sets contains examples to improve model's rigour and generalization capability.

After fine-tuning, we move on to evaluation, where we check model's genralizability score using standard natural language metrics and accuracy. We conduct ablation studies to assess the impact of our data curation and fine-tuning choices. Finally, we perform diagnostics with saliency analysis to gain insights over the model’s capability and limitation.

// This includes saliency analysis to examine decision-making patterns and identify strengths and limitations. These diagnostic steps help us better understand how the model interprets inputs and guide potential improvements for future iterations.

// #glorem(num:180)


//-------------------



== Data Curation <section_curation>
#plan[
  + Finetuning a medical model not only needs a big network.
    - But also a big dataset ensures enough examples of variety.
    - Dataset being big also benefits if not all the examples have fuzzy labels. The dataset probably contains enough good signal to combat fuzzy labels.
    - This is more important since pretraining datasets does not include medical content.
    - A medical datasets demand more rigorous pre-processing compared to those datasets that involve medical content.
    - The preprocessing step involves de-duplication, de-identification, and ensuring a fair representation of population as much as we can so that the model does not learn harmful model biases.
    - A good practice of dataset curation comes from @Singhal2023 which trains on an instruction tuned @flan_palm with roughly 540 Billion parameter.
      - They train and evaluate their model on self curated dataset like MultimedQA which samples from publically available datasets (@MedQA, @LiveQA, @MedMCQA, @MedMCQA, @PubMedQA, @MedicationQA)
    - In this section we describe our data curation technique to train a model capable of answering open ended radiological questions.
      - we carefully work with datasets that already contained pre-processed data that do not require us to perform de-identification or bias issues.
      - But we mostly focus on extracting good signals for model to learn by generating question answer pairs that is more convenient for a model to learn instead of captioning which often remains inferior . 
      
    
+ summarize @section_datamix @section_synthetic @section_annealing 
	
]



Fine-tuning a medical VLM not only requires a large network but also a vast amount of high-quality data to ensure sufficient variety and coverage. A large dataset is particularly beneficial even if some examples contain noisy or fuzzy labels, as big datasets often provide enough reliable signal to counteract such inconsistencies. This is especially critical in the medical domain, where training datasets such as @pelka2018roco are curated by sampling from open-access databases like @PMC_Open_Access and then developes pipelines for automated extraction and filtration to generate annotated labels. While these annotations may sometimes contain fuzzy labels, the overall curation process ensures a diverse and representative dataset.

// Curating medical datasets demands more rigorous preprocessing compared to those that involove general-domain content, involving steps such as de-duplication, de-identification, and ensuring fair representation of the population to minimize model learning harmful biases. 

// Another notable practice of effective dataset curation comes from @Singhal2023, which fine-tunes an instruction-tuned @flan_palm model with roughly 540 billion parameters. Their approach involves training and evaluating the model on self-curated datasets like MultimedQA, which samples from publicly available datasets @MedQA, @LiveQA, @MedMCQA, @PubMedQA, @MedicationQA to compile the largest dataset and achieves a new state of the art model by surpassing models like () by over 17% on popular benchmark .  for ... #todo[and suggest that it achieves a new state of the art model compared to cite]. MultimedQA now serves as a new benchmark for evaluating models that are trained for answering professional and consumer-level medical questions.

In this section, we describe our data curation techniques to train a model capable of answering open-ended radiological questions. We carefully work with datasets that already contain pre-processed data, eliminating the need for additional steps like de-identification or upsampling to ensure fairness. Our primary focus is on extracting high-quality signals for the model to learn visual concepts effectively. To achieve this, we generate question-answer pairs, which are more conducive to learning when compared to captioning-based approaches.

=== Determining the Data Mix <section_datamix>
#plan[
+ To develop a VLM it is essential to carefully determine the proportion of different pathologies in our data mix.
  - lack in scale in certain pathologies or conditions might lead to inadequate performance when inference in the wild.
  - its important to understand the training mix to get a reasonable expectation of model performance come evaluation time.
  
  - we focus on 2 kinds of datasets:
    - datasets that contain image caption pairs:
      - medpix,roco
      for both the datasets we levarage llms to generate question pairs from captions and then show improvement with annealing.
      
    - datasets that has compiled examples of image question answer pairs
      - pmc vqa
    - we do not end up sampling from datasets like @johnson2019mimiccxrjpglargepubliclyavailable ; although that has the next highest volume of images (when compared to @li2023llavamedtraininglargelanguageandvision) mostly because at present the focus of our modelling and datasets like roco does not require us to do upsampling on chest xray. 
    
      - the other types of dataset that we look into contains a lot of volume but not a lot of text.
      - for finetuning datasets trained on pmc vqa we also design a basic curriculum learning; where we do stage wise finetuning.
      
  - we examine some of the datasets that has high volume of images and text data. which focuses on variety of radiology subjects. 
    - our model focusing exclusively on chest x-ray is still currently under development.
 
  ]

#let roco_path_table = table(
  columns: 2,
  [Unified Medical Language Term], [Images],
   [Fluid], [1779],
   [Neoplasms], [1705],
   [Cystic], [1469],
   [Heart], [1288],
   [Liver], [1244],
   [Pathological Dilatation], [1084],
   [Entire bony skeleton], [1077],
   [Brain], [1058],
   [Pleural effusion disorder], [1049],
   [Nodule], [1032],
)

// #roco_path_table
#figure(
include "../../graphs/bar_instruct.typ",
caption: [Value Counts of conditions across candidate datamixes],
placement: bottom,
)

To develop a medical question-answering model, it is essential to carefully determine the proportion of different pathologies in the dataset. A lack of sufficient representation for certain conditions can lead to poor generalizability, limiting the model's ability to perform well across diverse real-world cases. 

Moreover, understanding the composition of the training mix is crucial for setting realistic expectations regarding model performance during evaluation. To assess the quality of commonly used data mixtures, we rely on scaling law experiments, discussed in @section_scaling.

Below, we examine several widely used data mixtures that were considered for training our VLM.

- *SLAKE @liu2021slakesemanticallylabeledknowledgeenhanceddataset*, contains detailed semantic annotations labeled by practicing physicians, covering a wide range of the human anatomy. This serves as an excellent preliminary radiological knowledge base for fine-tuning a medical VLM such as ours. While models like @beyer2024paligemma demonstrate reasonable zero-shot performance in recognizing some body parts most likely due to their exposure to similar examples from open-web datasets during pre-training but this capability remains imperfect in the instruct model.

  To address this limitation, we finetune on SLAKE as the initial stage of our fine-tuning curriculum. Specifically, we save a checkpoint after training the model on SLAKE for five epochs, and this checkpoint serves as the starting point for further training for all of our subsequent models. This approach aligns with the curriculum learning strategy outlined in @srinivasan2022curriculumlearningdataefficientvisionlanguage, which highlights the importance of first enabling a model to recognize simpler visual concepts before advancing to more complex structures.

  

- *PMC-VQA* dataset @zhang2024pmcvqavisualinstructiontuning is constructed by sampling from @lin2023pmcclip and is designed to facilitate medical visual question answering. It includes multiple-choice and fill-in-the-blank-style questions, providing a structured approach to assessing model performance. The dataset is generated and filtered using a large language model like @OpenAI_ChatGPT, a process we further discus in @section_synthetic. To evaluate its effectiveness, the authors train *MedVInT-TE* and *MedVInT-TD* on PMC-VQA, achieving performance scores comparable to the current state-of-the-art @li2023llavamedtraininglargelanguageandvision on benchmark datasets like @lau2018dataset_vqarad , @BenAbacha2019VQAMed_imagechief
 


- *Radiology Objects in Context (ROCOv2)* dataset @pelka2018roco derives from @PMC_Open_Access and contains 79,789 radiological image-caption pairs. It has been extensively used in medical AI research like @ImageCLEF2023Overview for tasks such as image captioning, multi-class classification, and vision-language model pretraining. With an average caption length of approximately 20 words per example, ROCOv2 offers a rich and structured source of radiological image-text data, making it particularly suitable for developing and refining open-ended vision-language models in the medical domain.


- *MedPix 2.0 @siragusa2024medpix20comprehensivemultimodal* is similar to @pelka2018roco, in utilizing a semi-automatic pipeline to extract radiological image-text pairs. It incorporates a manual curation process by sampling from MedPix® @MedPix to remove noisy labels. This curation effort spans over 12,000 cases, each containing images, diagnoses, and treatment information. Among all of our available datasets, this data mixture offers one of the most comprehensive collections of both textual and visual radiological concepts, making it particularly well-suited for annealing a technique we explore further in @section_annealing.




// - *PMC-15M @li2023llavamedtraininglargelanguageandvision*: A large-scale dataset with 15 million biomedical image-text pairs extracted from PubMed Central. It is significantly larger than previous public datasets like MIMIC-CXR and includes a diverse range of biomedical images, though it is not publicly released.

// - *MIMIC-sXR-JPG @johnson2019mimiccxrjpglargepubliclyavailable*: This dataset contains 377,110 chest X-rays from 227,827 imaging studies, labeled with 14 annotations derived from NLP-applied radiology reports. It is publicly available and supports medical computer vision research but focuses primarily on chest X-rays, requiring additional datasets for comprehensive radiology question answering.

// #glorem(num:150) 

The *PMC-VQA* dataset provides direct image-question-answer pairs, making it suitable for fine-tuning a medical VQA model without the need for any preprocessing. Whereas *ROCOv2* and *MedPix 2.0* contain image-caption pairs, requiring additional processing to be useful for VQA training. We take inspiration from @zhang2024pmcvqavisualinstructiontuning and generate synthetic question-answer pairs from these datasets using a large language model. However, raw synthetic data may contain noise or inconsistencies, necessitating a filtering step to ensure high-quality supervision. Only after this refinement process can the resulting dataset effectively support training a medical VQA model. We discuss this synthesis and filtering process in the next section. #footnote[PMC-15M @li2023llavamedtraininglargelanguageandvision is unavailable to the public at the time of writing.]

// The CheXpert team performed rigorous label validation, as detailed in @johnson2019mimiccxrjpglargepubliclyavailable. They manually annotated 687 stratified radiology reports using CheXpert categories, ensuring diverse pathology coverage. Validation included tasks such as mention extraction, negation detection, and uncertainty detection, with precision, recall, and F1 scores evaluating algorithm performance. Following this, we conducted scaling tests to assess how well the data mix supports model scalability.


// #wrap-content(figure(
// 		// cxr_table_conditions_table,
//   figure(image("../../our_images/data/treemap_cxr.png",width: 250pt)),
// 		// rect(width: 250pt,height: 250pt),
// 		caption:[Labeled])
// ,[#glorem(num:300)])


=== Generating Question Answer Pairs <section_synthetic>
#plan[
  + we take inspiration from 
  + as base models are usually not pretrained on medical corpus.questions generated with base models usually give away the main subject of the answers.
  + Evaluation for parallel text pairs needs to be human evaluated.
  
  + we develop simpler question answer pairs because we believe it first needs to align with the medical concept and so on.
]

#let qa_section = [
  
//  - while training a vlm as captioning task still remains an active area of research. Medical Visual Modelling is often driven by specific diagnostic questions rather than general observations. This makes VQA particularly relevant in the medical domain, where the focus is on answering targeted, clinically meaningful queries rather than generating diverse but less granular descriptions.
  
//  -  The concept of training a VLM with VQA as its primary objective stems from the notion that posing insightful questions can push the model to engage with more abstract visual concepts than a captioning task would.
 

//   - we take inspiration from  @zhu2023chatgptasksblip2answers, @zhang2024pmcvqavisualinstructiontuning,
//   @li2023llavamedtraininglargelanguageandvision to create question answer pairs from text alone by leveraging a large language model.

//   - The generation process requires no manual annotation. And can be geared towards answering open or close ended questions.
//   - we use @prompt_caption to generate question answer pairs for @photomzroco2023 to train our VLM model.
//   - refer to appendix to find more such prompting templates.
  
//   - both implementations use @OpenAI_ChatGPT to generate questions.
//   - Chatgpt generates great question answer pairs and their performing of generating good question answer pairs can be evaluated but we cannot calculate expectation as they do not disclose their pre-training dataset.
//     - to calculate expectation for all pathalogies and body part requires extensive testing.
//     - before generation
  
//   - we use @touvron2023llamaopenefficientfoundation to generate our question answer pairs mainly for 2 reasons
//     - generating large volume for cheap
//     - and discuss common pitfall for question answer pairs generated by a llm that has not been 
//     - we discuss some of the pitfalls in @section_limit_discuss

While training a VLM with a captioning task is an active area of research, modeling medical VLM often focuses on specific diagnostic queries rather than broad observations. This makes VQA particularly relevant for the medical domain, as it prioritizes answering clinically meaningful questions. The concept of training a VLM with VQA as its primary objective stems from the idea that posing insightful questions challenges the model to engage with more abstract visual concepts. 
#linebreak()
We leverage several techniques to generate synthetic question-answer pairs from text alone using large language models, drawing inspiration from @zhu2023chatgptasksblip2answers, @zhang2024pmcvqavisualinstructiontuning, and @li2023llavamedtraininglargelanguageandvision. The generation process requires no self made annotations and can be tailored to generate for both open and close-ended questions.For an example, we use @prompt_caption to generate question answer pairs from @siragusa2024medpix20comprehensivemultimodal to train our VLM. We use @touvron2023llamaopenefficientfoundation to generate our question-answer pairs mainly for two reasons: firstly, to generate question-answer pairs at scale at a low cost, making it feasible for small and individual research groups.And secondly, because the pretraining datamix for @touvron2023llamaopenefficientfoundation is known, allowing us to inspect common pitfalls associated with language models that have not been pretrained on extensive medical content, which is the case for most LLMs that are publicly available. We discuss some of such pitfalls in @section_limit_discuss.
]

#import "../code_blocks/code.typ":mcq_llama

#let prompt_caption = [#figure(mcq_llama,caption: [])<prompt_caption>]

#wrap-content(align:top+right,
prompt_caption,
// [#glorem(num:180)]
[#qa_section]
)





// this cant be floated. its too wide.(150-200 words looks good)
//-------------------


=== Annealing and Filtering <section_annealing>
#plan[
- Filtering question answer pairs generated by llm is extremely important.
  // - our approach on filtering is similar to @PMC_Open_Access
  - we then use an LLM to generate question answer pairs using propmt templates to generate literature based and image based question answer pairs.
  - To filter the data we perform human based classification. 
  - But instead of training a classifier to filter out bad examples from the datamix we do manual filtering.
  
  - our approach of filtering data does not scale for  large free text data mixes. we discuss some of the limitations. we discuss some of these limitations in @section_limit_discuss.
  
  - Annealing:
  - Describe Annealing with high quality data.
  - Ablation studies from llama:
  
    - Empirically, they find that annealing on small amounts of high-quality code and mathematical data can boost the performance of pre-trained models on key benchmarks.
    
    - Ablations studies from @llama finds that annealing improved the performance of a pre-trained Llama 3 8B model on the GSM8k and MATH validation sets by 24.0% and 6.4%, respectively. [you dont have to describe the datasets]

    - However, the improvements on the 405B model are negligible, suggesting that our flagship model has strong in-context learning and reasoning capabilities and does not require specific in-domain training samples to obtain strong performance.

  - Annealing can be used for :

    - since our VLM totals around 4B. it remains interesting to see the performance improvement with annealing.
    
  -  since Using annealing to evaluate new data sources is more eﬃcient than performing scaling law experiments for every small dataset.
  
  - we start with selecting the pathalogies that are the most common in the data mix that we are going to anneal with . with a minimum threshold of a 100 examples. The purpose deviates from upsampling rare examples in the datamix to improve variety but to enrich the existing examples.

  - refer to figure @fig_filtering and @fig_flowchart_annealing .

  - we use Medpix v2.0 @siragusa2024medpix20comprehensivemultimodal
  to anneal our datasets. since the volume of the dataset is pretty low. And contains excellent source of information for both case study and associated literature.

  - Annealing at finetuning
    
  
]

#figure(
grid(columns: (1fr,0.95fr),

[#figure(include"../../graphs/bar_medpix.typ",caption: [Selecting Pathologies for Annealing (here @siragusa2024medpix20comprehensivemultimodal)])<fig_filtering>]
,
[#figure(rect(fill:my_colors.alt_fg.lighten(30%),radius: 8pt,inset:10pt)[#include"../../graphs/filtering_flowchart.typ"],caption: [Generation and Filtering for Annealing a given Datamix (here @pelka2018roco)])<fig_flowchart_annealing>],

),
placement: bottom
)


// Annealing is a structured approach to fine-tuning models by gradually incorporating small amounts of high-quality data. Splicing existing data mix with high quality samples allows models to learn signals that might otherwise be difficult to capture. Empirical ablation studies from @touvron2023llamaopenefficientfoundation on Llama models found effectiveness of this approach. The Llama 3 8B model, for instance, demonstrated significant improvement in domain-specific tasks such as 24% improvement on grade scholl math problems @cobbe2021gsm8k  and about 6.4% improvement on challenging competition mathematics problems @hendrycksmath2021. However, in larger models like the 405B variant, improvements were minimal, suggesting that extensive pre-training already equips such models with strong in-context learning abilities. Given that our vision-language model (VLM) is around 4B parameters, it remains instersting to see if annealing can enhance its performance.  


// A key aspect of effective annealing is systematic filtering, ensuring that only high-quality data is used. As illustrated in Figure @fig_flowchart_annealing, we begin with a medical corpus, filtering data based on pathologies to ensure relevance. This systemic filtering on cases approach contrasts with traditional upsampling strategies, which focus on increasing the variety of rare cases. Instead, our goal is to enrich the common pathology cases (see @fig_filtering), ensuring that the model learns from a high-quality, well-curated dataset rather than an overly diverse but lower-quality data mix. The filtered dataset is then processed using a large language model (LLM) to generate literature-based  and image-related questions with the expectations that understanding literature might also aid when answering image related questions. These questions finally undergo subjective human evaluation to be considered for the datamix.  

// We use Medpix v2.0 (@siragusa2024medpix20comprehensivemultimodal) as our source to anneal ROCO v2.0. Despite its limited volume, Medpix v2.0 provides an excellent combination of case studies and literature, making it ideal for enhancing the model’s medical reasoning and domain knowledge.



*Annealing* is a data curation techniques aimed at improving model's overall performance by splicing small amounts of high quality data in existing data mix. With the objective that it increases models expectation to capture known to be good signals that might otherwise be difficult to detect in a diverse data containing both good but also some fuzzily labeled examples. Ablation studies by @touvron2023llamaopenefficientfoundation found that Llama 8B model exhibited a 24% improvement on grade-school-level mathematical problem-solving @cobbe2021gsm8k and a 6.4% increase in performance on competition-level mathematical reasoning tasks @hendrycksmath2021 after annealing. However, these gains were significantly less pronounced in larger models, such as the Llama 3 405B @touvron2023llamaopenefficientfoundation, indicating that larger model has higher capabilities of being robust to bad examples in the datamix during pre-training. Given that our VLM has approximately 4B parameters, it serves as an interesting approach to inspect the yielded benifits from annealing. We leverage Medpix v2.0 @siragusa2024medpix20comprehensivemultimodal as our primary dataset for annealing ROCO v2.0. Although Medpix v2.0 has a relatively limited volume, it serves as a highly valuable source of both case studies and literature, making it particularly well-suited for enhancing the model’s medical reasoning and domain-specific knowledge acquisition. 


A critical component of effective annealing is systematic *filtering*, which ensures that only high-quality and domain-relevant data is incorporated into the dataset. As illustrated in Figure @fig_flowchart_annealing, the process begins with a medical corpus, which is filtered based on pathological relevance to maintain specificity. Unlike conventional upsampling strategies that primarily aim to increase the variety of rare cases, our approach prioritizes enriching common pathology cases (see Figure @fig_filtering). After sampling on selected pathologies, we process the captions using @touvron2023llamaopenefficientfoundation LLama3 8B  to generate Literature based and Image-related questions using specific prompt template for each. The underlying idea of including literature based questions in the datamix is that a stronger grasp of medical literature may enhance image-based reasoning capabilities, thereby improving the model’s multimodal understanding. The generated questions then undergo subjective human evaluation as the last step before completing our data curation process.  

Although our filtration technique ensures that only high-quality samples are added to the data mix, but it does not scale efficiently when dealing with large volumes of annealing data. As the dataset size increases,human labelling to filter data becomes infeasible for small research groups. We discuss some of these limitations further in @section_limit_discuss.


// This strategy ensures that the model is trained on a highly curated, high-quality dataset, rather than an arbitrarily diverse data mix that may dilute meaningful learning signals.  

// By incorporating this carefully curated dataset, we aim to optimize the efficiency of annealing while maintaining stringent data quality standards. This process enables us to refine our vision-language model in a way that ensures both accuracy and depth of knowledge, ultimately contributing to more robust medical AI applications.  

// Our approach to annealing, which integrates high-quality data through a structured filtering mechanism, presents a promising paradigm for improving model performance. The extent to which these gains manifest in our specific VLM remains to be seen, yet given the demonstrable benefits observed in previous studies, this remains a highly pertinent research direction.





// - *Filtering* #glorem(num:190)
// - *Annealing* #glorem(num:190)

// === Designing Curriculum Learning <section_curriculum>
// #plan[
//   - Medpix has extensive doctor notes . and those are great intermediate reasoning to learn. 
//   - Curriculum learning @srinivasan2022curriculumlearningdataefficientvisionlanguage
//   - our filteration was hand labelled small generations on the earlier epoch
//   - llava med also does this but does not give out examples at all.
  
// ]
// #glorem(num:180)



== Finetuning and Scaling Law  <section_scaling>
#plan[
	+ overview of scaling law @kaplan2020scalinglawsneurallanguage

1. Task- and Data-Dependence: 

	 - @zhang2024when suggests the scaling properties for LLM fine-tuning are highly task- and data-dependent. This means that the optimal fine-tuning method and the scaling behavior can vary depending on the specific task and the characteristics of the fine-tuning dataset.i.e we can have scaling exponents differ depending on the question templates. 

2. Different Scaling Laws for Different Tasks:
	 - The paper proposes a multiplicative joint scaling law (Equation 1) that describes the relationship between fine-tuning data size and other scaling factors (like model size, pretraining data size, etc.). However, it also notes that the scaling exponents (e.g., \(\alpha\), \(\beta\)) and other parameters in the scaling law can vary depending on the task and the dataset.
  
	 - This implies that if you have two different types of fine-tuning datasets (e.g., one with small multiple-choice questions and another with difficult open-ended questions), you might need to fit different scaling laws for each dataset, as the relationship between data size and performance could differ.

3. Empirical Evidence:
	 - The paper provides empirical evidence that the scaling behavior varies across different tasks (e.g., machine translation vs. summarization) and datasets. For instance, the scaling exponents for model size (\(\alpha_m\)) and pretraining data size (\(\alpha_p\)) differ across tasks, indicating that the impact of these factors on fine-tuning performance is not uniform.
	 - This suggests that if one dataset contains simple questions and another contains complex open-ended questions, the scaling laws for these datasets might indeed require different lines of fit to accurately capture their respective scaling behaviors.

Yes, the paper suggests that the scaling law for fine-tuning LLMs depends on the type of data you train on. If you have two different fine-tuning datasets with significantly different characteristics (e.g., small multiple-choice questions vs. difficult open-ended questions), you would likely need to fit different scaling laws for each dataset, as the relationship between data size, model size, and performance could vary based on the complexity and nature of the tasks.
 	
]

#let lora_config = figure(table(
  columns: 2,
  [Lora Config #icon("lora")],[value],
  [`r`],[12],
  [`lora_alpha`],[32],
  [`target_modules`],
  [`{q,k,v,o}_proj,
{up,down}_proj`],
  [`task_type`],[`causal_lm`],
),caption: [])

#rect(fill: my_colors.alt_fg,radius: 5pt)[
  #text(size: 5pt)[#icon("lora") Lora @hu2021loralowrankadaptationlarge Finetuning Hyperparameters for all of our models: #box()[`r:12 , lora_alpha:32 , target_modules = {q,j,v,o,up,down}_proj , task_type : "causal_lm"`
// $r$:12,#h(0.5em) 
// $"lora_alpha"$:32,#h(0.5em)
// $"target_modules"$:{q,k,v,o,up,down}\_proj,#h(0.5em)
// $"task_type"$:causal_lm #h(0.5em)
]]
#v(-0.5em)
#grid(columns: (1fr,1fr),column-gutter:1pt,
[#figure(
    rect(fill: white,radius: 5pt)[
      #include "../../graphs/test_losses.typ"],
		caption: [Evaluation loss for answering Open Ended Questions]) <fig_openended> ],
  [#figure(
    rect(fill:white,radius: 5pt)[
    #include "../../graphs/test_losses_closed.typ"]
  ,caption: [Evaluation loss for answering Closed Based Questions]) <fig_closeended>]
)
#align(right)[#text(size: 5pt)[#super[\*]Mtokens: Million Tokens ]]
]

// #set table(
//   stroke:none,
//   gutter: 0.1em,
//   fill: (x, y) =>{ 
//     if x==0 and y==0 {my_colors.accent1.lighten(40%)}
//     else if x == 0 and y > 0 {gray.lighten(90%)} 
//     else if y==0 {gray.lighten(50%)} 
//     else {my_colors.alt_fg.lighten(20%)}},
//   inset: (right: 1.5em),
//   )


#let equation_finetune = $
  // markul(tilde(L), tag: #<A>)
  tilde(L)(X,D_f)
  // "Attention"
  = marktc(A,tag:#<a>,color:#my_colors.accent15)
  *
  1/X^marktc(alpha,tag:#<alp>,color:#my_colors.accent15)
  *
  1/marktc(D_f,tag:#<vol>,color:#olive)^marktc(beta,tag:#<bet>,color:#my_colors.accent15)
  + marktc(E,tag:#<e>,color:#my_colors.accent15)

  
  // #annot(<A>, pos: bottom, yshift: 0.8em)[#text(size:5pt)[Scaled Dot Product Attention]]
$

#let finetuning_text=[
in our approach we carry this out in two stages. As discussed very briefly in @section_datamix, we begin by fine-tuning using the SLAKE dataset @liu2021slakesemanticallylabeledknowledgeenhanceddataset before training them on (@pelka2018roco , @MedPix , @PMC_Open_Access , @johnson2019mimiccxrjpglargepubliclyavailable) separately as distinct instruction sets. We employ LoRA @hu2021loralowrankadaptationlarge, a low-rank adapting method, to perform parameter efficient finetuning @xu2023parameterefficientfinetuningmethodspretrained of our models specifically by targeting the attention heads of both the vision tower and the large language model.This allows us to significantly lower computational and storage costs.This deviates from traditional approaches were only the last few layers or all of the model's parameter were trained to adapt the base model to a new domain. Figures @fig_openended and @fig_closeended records ours evaluation loss across epochs of training. We discuss about their evaluation in @section_evaluation. 

For answering open ended questions we see evaluation loss decrease with increasing tokens in @fig_openended. But the pattern breaks for answering close ended questions refer @fig_closeended. We discuss the effect of task dependence on finetuning below. 
]

#let scaling_section = [
scaling properties for LLM fine-tuning are highly task and data-dependent @zhang2024when. This means that the optimal fine-tuning method and the scaling behavior can vary depending on the characteristics of the fine-tuning dataset.Specifically we can have #text(fill:my_colors.accent15)[scaling exponents] differ depending on the question-answer templates of our datamix. Since @pelka2018roco and @MedPix contains open ended questions with caption length averaging around $20$.The task dependence is not aparent.And mostly can be fitted by  training on more but similar datamix with higher volume (As #text(fill: olive)[$D_f$ is only volume dependent] in @equation_finetune).

#equation_finetune <equation_finetune>
The task dependence becomes easier to analyze in dataset mixes for close-ended questions, especially when different templates are used for question-answer pairs,like in @fig_closeended. Typically, a higher-volume dataset is expected to yield greater improvements in fewer epochs. However, this trend does not hold when comparing @johnson2019mimiccxrjpglargepubliclyavailable to @xmcmic_pmc_vqa. Despite having less data, @xmcmic_pmc_vqa shows greater learning gains in fewer epochs, primarily because it consists mostly of multiple-choice questions, which have a lower expected loss compared to the template used in @johnson2019mimiccxrjpglargepubliclyavailable. This observation suggests that different scaling laws are needed for such datasets.

Unfortunately, here we do not have enough data to fit a line to predict our loss on open ended questions when trained on higher volume in @fig_openended. But we can see an improvement in generalizability of annealing; since its more prudent to perform annealing than to do scaling law experiments on small datasets like @MedPix . 
    
]

  // - The task dependence gets easier to inspect in datamixes for close ended questions with different templates for question answer pairs.
  
  // - the natural expectation with higher volume dataset is to see higher gains in fewer epochs but thats not the case when compared @johnson2019mimiccxrjpglargepubliclyavailable to @xmcmic_pmc_vqa.
  
  // - Although @xmcmic_pmc_vqa has less data it sees more gain in fewer epochs mostly because it mostly contains multiple choice question. The expected loss of multiple choice questions is smaller when compared to @johnson2019mimiccxrjpglargepubliclyavailable template.
  
  // - Thus suggesting we need different scaling laws for such datasets.


// *Finetuning*: #glorem(num:175)
*Finetuning*: #finetuning_text
#linebreak()
// *Scaling Law for Finetuning*: #glorem(num:175)
*Scaling Law for Finetuning*: #scaling_section

// #wrap-content(align:bottom+right,lora_config,[#glorem(num:350)])

// #wrap-content(align:left,figure(
// 		include "../../graphs/test_losses.typ",
// 		caption: [our results currently],
// 		// placement: auto,
// 		// scope: "parent"
// 	),[#glorem(num:350)])

 





