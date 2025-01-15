#import "../callouts.typ": *

= Training Recipe
#plan[
+ what we expect from an instruction tuned. model
  - human aligned , signals learnt in pretraining as we saw from @section_instruct_models

+ what more needs to be done
  - Train on a medical instruct dataset . not frequently available with the latest (also smallest) multimodall llm.
  - briefly talk about the influence of the size of the dataset set up @section_scaling

+ summarize section
]

#todo[we will write this after we are done with section 4]


//-------------------



== Data Curation <section_curation>
#plan[
+ Most soa models start with dataset curation and often end up with the largest voulme of high quality medical data.
+ most instruct models are made from human labelers. But some models like @abdin2024phi also train on synthetic data. 
+ instruct dataset 1 to gain conceptual understanding like cc12m @changpinyo2021cc12m
+ Task specific instruct dataset 2 like roco @pelka2018roco , @johnson2019mimiccxrjpglargepubliclyavailable.
+ need for validation of labels in medical instruct dataset
+ summarize @section_datamix @section_synthetic @section_annealing 
	
]
#glorem(num:100)


=== Determining the Data Mix <section_datamix>
#plan[
	// #comment[this is wrong]
	+ show that it only works when enough diversity in the training sample
	+ treemap of the dataset.
	+ (did not work with medpix @siragusa2024medpix20comprehensivemultimodal alone)
	#todo[adjust depth of treemaps... depth 2 should be readable]

]

- Determining the proportion of different pathologies in a medical instruction dataset is critical before fine-tuning a model. Our approach to analyzing this data mix involved leveraging results from their label validation and conducting scaling law @kaplan2020scalinglawsneurallanguage experiments (see @section_scaling).

- we mainly worked with three high quality datasets : @siragusa2024medpix20comprehensivemultimodal , @pelka2018roco , @johnson2019mimiccxrjpglargepubliclyavailable.

- The focus of all three datasets is radiology. but looking at the mix the number of examples are far too less when compared to instruct datasets that are available for general domain task.

- Performing scaling experiments show that the model cannot be reliable when solely trained on such datasets .That include but variety but not much volume.

- @johnson2019mimiccxrjpglargepubliclyavailable was a better datasets as the mix focuses only on chest x-ray images. with huge volume.

#coherence(title:[Question?])[
  - how do i write about why i selected these datasets.
    - medpix #emoji.checkmark , physionets cxr-jpg #emoji.checkmark , roco ?
    - roco limitations : Really big list :such as  A fundamental limitation is represented by faulty or fuzzy original captions that serve as ground truth. 
]


The CheXpert team performed rigorous label validation, as detailed in @johnson2019mimiccxrjpglargepubliclyavailable. They manually annotated 687 stratified radiology reports using CheXpert categories, ensuring diverse pathology coverage. Validation included tasks such as mention extraction, negation detection, and uncertainty detection, with precision, recall, and F1 scores evaluating algorithm performance. Following this, we conducted scaling tests to assess how well the data mix supports model scalability.


#wrap-content(figure(
		// cxr_table_conditions_table,
  figure(image("../../our_images/data/treemap_cxr.png",width: 250pt)),
		// rect(width: 250pt,height: 250pt),
		caption:[Labeled])
,[#glorem(num:300)])


=== Synthetic Data <section_synthetic>
#plan[
+ as base models are usually not pretrained on medical corpus.questions generated with base models usually give away the main subject of the answers.
+ make arguments on being careful while prompting. and why currently we can only have shorter length questions when curating open ended questions as they give away the subject of the answers often. #todo[add examples]
+ Evaluation for parallel text pairs needs to be human evaluated.

+ Popular tempelates for generating vqa and mcq later for accuracy evaluation. [appendix]
+ we develop simpler question answer pairs because we believe it first needs to align with the medical concept and so on.
]

#import "../code_blocks/code.typ":mcq_llama  
#oasis-align(
figure(
  [#mcq_llama],caption: []),
	[#glorem(num:120)],
)

#glorem(num:100)

// #tip[
//   - Use a finetuned model to generate questions.
//   - Instruction tuned models need excessive templating. And still does not generate conceptual question answer pairs
// ]



// this cant be floated. its too wide.(150-200 words looks good)
//-------------------


=== Annealing with High-quality Data <section_annealing>
#plan[
+ Mixing Medpix low vol / High Quality to generate larger volume of data.
]
#glorem(num:100)

#wrap-content(align:right,
	figure(    image("../../our_images/data/treemap_medpix2.png",width: 250pt),
		// rect(width: 250pt,height: 250pt),
		caption:[Labeled])
,[#glorem(num:200)])

#wrap-content(
  align:right,
  figure(
  // rect(width: 250pt,height: 300pt)[#todo[Add Filtering flow chart]],
  include("../../graphs/filtering_flowchart.typ"),
  // include("../../graphs/test_losses.typ"),
  caption: [#todo[incomplete!]]),
  [#glorem(num:200)]
)



== Finetunining <section_finetuning>
#plan[
  + Formally describe LORA
]
#glorem(num:300)



== Scaling Law  <section_scaling>
#plan[
	+ overview of scaling law @kaplan2020scalinglawsneurallanguage
		- show that the power law applicable to transformer based architecture also extends to finetuning with lora
		
	+ we will have experiments for (3) datasets.
		+ i.e enough compute , enough scale , data needed before overfitting

	+ currently its epochs we need to calculate tokens processed (i.e images in training set x (28^2))

		+ For large models trained with a limited dataset with early stopping:
		- that is we assume that our model is big enough , and we have enough compute . then new tokens needed to get the desired evaluation loss
		- $L = (D_c/ D)^(alpha)$ ; $alpha_d = 0.095$ ; $D_c = 5.4 * 10^13$ tokens;
			- But this Dc is calculated for full pretrain. we need for finetuning [we will assume the base model size also followed scaling law]. so it should be considerably smaller than 10^13.and our results would only be approximate as we only have 3 datasets.
			- remember : pmc15m @zhang2024pmcvqavisualinstructiontuning is double the size of mimic-cxr @johnson2019mimiccxrjpglargepubliclyavailable.
			#comment[add number of images in each line graph]
	
		]

// #include "sample.typ"

#wrap-content(align:left,figure(
		include "../../graphs/test_losses.typ",
		caption: [our results currently],
		// placement: auto,
		// scope: "parent"
	),[#glorem(num:200)])








#glorem(num:100)