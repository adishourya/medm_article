#import "../callouts.typ": *

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
include "../../graphs/training_recipe_flow_chart.typ",
caption: [Methodology]

)


// #todo[we will write this after we are done with section 4]
#glorem(num:100)


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
caption: []
)

To develop a medical question-answering model, it is essential to carefully determine the proportion of different pathologies in the dataset. A lack of sufficient representation for certain conditions can lead to poor generalizability, limiting the model's ability to perform well across diverse real-world cases. 

Moreover, understanding the composition of the training mix is crucial for setting realistic expectations regarding model performance during evaluation. To assess the quality of commonly used data mixtures, we rely on scaling law experiments, discussed in @section_scaling.

Below, we examine several widely used data mixtures that were considered for training our VLM.

- *SLAKE @liu2021slakesemanticallylabeledknowledgeenhanceddataset*, contains detailed semantic annotations labeled by practicing physicians, covering a wide range of the human anatomy. This serves as an excellent preliminary radiological knowledge base for fine-tuning a medical VLM such as ours. While models like @beyer2024paligemma demonstrate reasonable zero-shot performance in recognizing some body parts most likely due to their exposure to similar examples from open-web datasets during pre-training but this capability remains imperfect in the instruct model.

  To address this limitation, we finetune on SLAKE as the initial stage of our fine-tuning curriculum. Specifically, we save a checkpoint after training the model on SLAKE for five epochs, and this checkpoint serves as the starting point for further training for all of our subsequent models. This approach aligns with the curriculum learning strategy outlined in @srinivasan2022curriculumlearningdataefficientvisionlanguage, which highlights the importance of first enabling a model to recognize simpler visual concepts before advancing to more complex structures. #footnote[!! _currently we have only done this with our pmc model._]

  

- *PMC-VQA* dataset @zhang2024pmcvqavisualinstructiontuning is constructed by sampling from @lin2023pmcclip and is designed to facilitate medical visual question answering. It includes multiple-choice and fill-in-the-blank-style questions, providing a structured approach to assessing model performance. The dataset is generated and filtered using a large language model like @OpenAI_ChatGPT, a process we further discus in @section_synthetic. To evaluate its effectiveness, the authors train *MedVInT-TE* and *MedVInT-TD* on PMC-VQA, achieving performance scores comparable to the current state-of-the-art @li2023llavamedtraininglargelanguageandvision on benchmark datasets like @lau2018dataset_vqarad , @BenAbacha2019VQAMed_imagechief
 


- *Radiology Objects in Context (ROCOv2)* dataset @pelka2018roco derives from @PMC_Open_Access and contains 79,789 radiological image-caption pairs. It has been extensively used in medical AI research like @ImageCLEF2023Overview for tasks such as image captioning, multi-class classification, and vision-language model pretraining. With an average caption length of approximately 20 words per example, ROCOv2 offers a rich and structured source of radiological image-text data, making it particularly suitable for developing and refining open-ended vision-language models in the medical domain.


- *MedPix 2.0 @siragusa2024medpix20comprehensivemultimodal* is similar to @pelka2018roco, in utilizing a semi-automatic pipeline to extract radiological image-text pairs. It incorporates a manual curation process by sampling from MedPix® @MedPix to remove noisy labels. This curation effort spans over 12,000 cases, each containing images, diagnoses, and treatment information. Among all of our available datasets, this data mixture offers one of the most comprehensive collections of both textual and visual radiological concepts, making it particularly well-suited for annealing a technique we explore further in @section_annealing.




// - *PMC-15M @li2023llavamedtraininglargelanguageandvision*: A large-scale dataset with 15 million biomedical image-text pairs extracted from PubMed Central. It is significantly larger than previous public datasets like MIMIC-CXR and includes a diverse range of biomedical images, though it is not publicly released.

// - *MIMIC-sXR-JPG @johnson2019mimiccxrjpglargepubliclyavailable*: This dataset contains 377,110 chest X-rays from 227,827 imaging studies, labeled with 14 annotations derived from NLP-applied radiology reports. It is publicly available and supports medical computer vision research but focuses primarily on chest X-rays, requiring additional datasets for comprehensive radiology question answering.

// #glorem(num:150) 

The *PMC-VQA* dataset provides direct image-question-answer pairs, making it suitable for fine-tuning a medical VQA model without the need for any preprocessing. Whereas *ROCOv2* and *MedPix 2.0* contain image-caption pairs, requiring additional processing to be useful for VQA training. We take inspiration from @zhang2024pmcvqavisualinstructiontuning and generate synthetic question-answer pairs from these datasets using a large language model. However, raw synthetic data may contain noise or inconsistencies, necessitating a filtering step to ensure high-quality supervision. Only after this refinement process can the resulting dataset effectively support training a medical VQA model. We discuss this synthesis and filtering process in the next section. #footnote[our experiments with @johnson2019mimiccxrjpglargepubliclyavailable is currently in development] #footnote[PMC-15M @li2023llavamedtraininglargelanguageandvision is unavailable to the public at the time of writing.]

// The CheXpert team performed rigorous label validation, as detailed in @johnson2019mimiccxrjpglargepubliclyavailable. They manually annotated 687 stratified radiology reports using CheXpert categories, ensuring diverse pathology coverage. Validation included tasks such as mention extraction, negation detection, and uncertainty detection, with precision, recall, and F1 scores evaluating algorithm performance. Following this, we conducted scaling tests to assess how well the data mix supports model scalability.


// #wrap-content(figure(
// 		// cxr_table_conditions_table,
//   figure(image("../../our_images/data/treemap_cxr.png",width: 250pt)),
// 		// rect(width: 250pt,height: 250pt),
// 		caption:[Labeled])
// ,[#glorem(num:300)])


=== Synthetic Data <section_synthetic>
#plan[
+ as base models are usually not pretrained on medical corpus.questions generated with base models usually give away the main subject of the answers.
+ make arguments on being careful while prompting. and why currently we can only have shorter length questions when curating open ended questions as they give away the subject of the answers often. #todo[add examples]
+ Evaluation for parallel text pairs needs to be human evaluated.

+ Popular tempelates for generating vqa and mcq later for accuracy evaluation. [appendix]
+ we develop simpler question answer pairs because we believe it first needs to align with the medical concept and so on.
]

#import "../code_blocks/code.typ":mcq_llama  

#wrap-content(align:top+left,
figure(mcq_llama,caption:[]),
[#glorem(num:200)])





// this cant be floated. its too wide.(150-200 words looks good)
//-------------------


=== Annealing with High-quality Data <section_annealing>
#plan[
+ Mixing Medpix low vol / High Quality to generate larger volume of data.
]


#wrap-content(
  figure(include("../../graphs/bar_medpix.typ"),caption: []),
  glorem(num:180)
)


#wrap-content(
  align:right,
  figure(
    rect(stroke: none,fill:my_colors.alt_fg.lighten(50%),radius: 5pt, outset: 2pt)[
  #include("../../graphs/filtering_flowchart.typ")
],
  caption: []),
  [#glorem(num:200)]
)

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
		- show that the power law applicable to transformer based architecture also extends to finetuning with lora
		
	+ we will have experiments for (3) datasets.
		+ i.e enough compute , enough scale , data needed before overfitting

	+ currently its epochs we need to calculate tokens processed (i.e images in training set x (28^2))

		+ For large models trained with a limited dataset with early stopping:
		- that is we assume that our model is big enough , and we have enough compute . then new tokens needed to get the desired evaluation loss
		- $L = (D_c/ D)^(alpha)$ ; $alpha_d = 0.095$ ; $D_c = 5.4 * 10^13$ tokens;
    - But not this!. we will have to use @zhang2024when.  which requires us to fit a line. no precalculated constants. 
			- But this Dc is calculated for full pretrain. we need for finetuning [we will assume the base model size also followed scaling law]. so it should be considerably smaller than 10^13.and our results would only be approximate as we only have 3 datasets.
			- remember : pmc15m @zhang2024pmcvqavisualinstructiontuning is double the size of mimic-cxr @johnson2019mimiccxrjpglargepubliclyavailable.
			// #comment[add number of images in each line graph]
	
		]

#let lora_config = figure(table(
  columns: 2,
  [lora config #icon("lora")],[value],
  [r],[12],
  [lora_alpha],[32],
  [target_modules],
  [`{q,k,v,o}_proj,
{up,down}_proj`],
  [task_type],[`causal_lm`],
),caption: [])

#wrap-content(align:top+right,lora_config,[#glorem(num:80)])

#wrap-content(align:left,figure(
		include "../../graphs/test_losses.typ",
		caption: [our results currently],
		// placement: auto,
		// scope: "parent"
	),[#glorem(num:130)])

 





