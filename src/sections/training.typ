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

#todo[we will write this after we are done with section 4]


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


Fine-tuning a medical model not only requires a large network but also a high-quality, high-volume dataset to ensure sufficient variety and coverage. A large dataset is particularly beneficial even if some examples contain noisy or fuzzy labels, as the volume of data often provides enough reliable signal to counteract such inconsistencies. This is especially critical in the medical domain, where pretraining datasets typically lack sufficient medical content. Development of a state of the art medical model often starts with a new state of the art curated dataset. 

Curating medical datasets demands more rigorous preprocessing compared to general-domain datasets, involving steps such as de-duplication, de-identification, and ensuring fair representation of the population to minimize model learning harmful biases. A notable practice of effective dataset curation comes from @Singhal2023, which fine-tunes an instruction-tuned @flan_palm model with roughly 540 billion parameters. Their approach involves training and evaluating the model on self-curated datasets like MultimedQA, which samples from publicly available datasets such as @MedQA, @LiveQA, @MedMCQA, @PubMedQA, and @MedicationQA. MultimedQA now serves as a new benchmark for evaluating models that are trained for answering professional and consumer-level medical questions.

In this section, we describe our data curation techniques to train a model capable of answering open-ended radiological questions. We carefully work with datasets that already contain pre-processed data, eliminating the need for additional steps like de-identification or addressing bias issues. Our primary focus is on extracting high-quality signals for the model to learn visual concepts effectively. To achieve this, we generate question-answer pairs, which are more conducive to learning compared to captioning-based approaches that often yield inferior results.





=== Determining the Data Mix <section_datamix>
#plan[
	// #comment[this is wrong]
+ To obtain a promising model it is essential to carefully determine the proportion of different pathologies in our data mix.
  - lack in scale in certain pathologies might lead to inadequate performance when inferenced in the wild.
  - its important to understand the training mix to get a reasonable expectation at evaluation time.
  - we examine some of the datasets that has high volume. 
 
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

Similar datasets for vision-language modeling in radiology include:

- *MIMIC-CXR-JPG @johnson2019mimiccxrjpglargepubliclyavailable*: This dataset contains 377,110 chest X-rays from 227,827 imaging studies, labeled with 14 annotations derived from NLP-applied radiology reports. It is publicly available and supports medical computer vision research but focuses primarily on chest X-rays, requiring additional datasets for comprehensive radiology question answering.

- *PMC-15M @li2023llavamedtraininglargelanguageandvision*: A large-scale dataset with 15 million biomedical image-text pairs extracted from PubMed Central. It is significantly larger than previous public datasets like MIMIC-CXR and includes a diverse range of biomedical images, though it is not publicly released.

- *PMC-VQA @zhang2024pmcvqavisualinstructiontuning*: Created from 381K image-caption pairs from PMC-OA @lin2023pmcclip, generating 1.49M question-answer pairs. It is filtered to 226,946 pairs and includes a variety of radiological images, with a high-quality sample of 2,000 manually verified Q&A pairs.

- *Radiology Object in COntext (ROCOv2) @pelka2018roco*: A multimodal dataset with 79,789 radiological images from the PMC Open Access subset, including 35,705 new images and additional anatomical and directional concepts for X-rays. The dataset is used for tasks like captioning, multi-label classification, and pre-training vision-language models for radiology.

- *MedPix @siragusa2024medpix20comprehensivemultimodal*: A free, open-access database with over 12,000 clinical cases that include images, diagnoses, and treatment information. MedPix 2.0, built as a MongoDB instance, enhances data querying for AI training, though raw data access is restricted.

#coherence(title:[Question?])[
  - how do i write about why i selected these datasets.
    - medpix #emoji.checkmark , physionets cxr-jpg #emoji.checkmark , roco ?
    - roco limitations : Really big list :such as  A fundamental limitation is represented by faulty or fuzzy original captions that serve as ground truth. 
]


The CheXpert team performed rigorous label validation, as detailed in @johnson2019mimiccxrjpglargepubliclyavailable. They manually annotated 687 stratified radiology reports using CheXpert categories, ensuring diverse pathology coverage. Validation included tasks such as mention extraction, negation detection, and uncertainty detection, with precision, recall, and F1 scores evaluating algorithm performance. Following this, we conducted scaling tests to assess how well the data mix supports model scalability.


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
[#glorem(num:350)])





// this cant be floated. its too wide.(150-200 words looks good)
//-------------------


=== Annealing with High-quality Data <section_annealing>
#plan[
+ Mixing Medpix low vol / High Quality to generate larger volume of data.
]


#wrap-content(
  include("../../graphs/bar_medpix.typ"),
  glorem(num:180)
)


#wrap-content(
  align:right,
  figure(
    rect(stroke: none,fill:my_colors.alt_fg,radius: 5pt, outset: 2pt)[
  #include("../../graphs/filtering_flowchart.typ")
],
  caption: [#todo[incomplete!]]),
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

#let lora_config = table(
  columns: 2,
  [lora config #icon("lora")],[value],
  [r],[12],
  [lora_alpha],[32],
  [target_modules],
  [`{q,k,v,o}_proj,
{up,down}_proj`],
  [task_type],[`causal_lm`],
)

#wrap-content(align:top+right,lora_config,[#glorem(num:80)])

#wrap-content(align:left,figure(
		include "../../graphs/test_losses.typ",
		caption: [our results currently],
		// placement: auto,
		// scope: "parent"
	),[#glorem(num:130)])

 





