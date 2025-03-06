// use #comment[comment here] <- to add comments
// use #todo[todo text here]  <- to add todo
//--------------------------------

#import "template.typ" : *
#show: my_template


// Title

#let title = [
	*Adapting Lightweight Multimodal Language Models #linebreak()
	for Radiological Visual Question Answering #linebreak()
	A Practical Approach*
]

// current limitations of adapting generalist VLM for radiological visual
// linguistic tasks ?

#show_title(title)


// authors
#grid(columns: (1fr,1fr),

  align(center)[Chang Sun #link(<affiliation_a>,super[a])
  #h(-0.2em)#super[,]#h(-0.2em)
  #link(<affiliation_a>,super[b])\
  #text(size:8pt,
  "chang.sun@maastrichtuniversity.nl")],
  
  align(center)[Aditya Shourya #link(<affiliation_b>,super[b])
  #h(-0.2em)#super[,]#h(-0.2em)
  #link(<affiliation_star>,super[c])\
  #text(size:8pt,
  "a.shourya@student.maastrichtuniversity.nl")]
)


#text(5pt,style: "italic",
[#super([a]) Institute of Data Science, Faculty of Science and Engineering, Maastricht University, Maastricht, The Netherlands])<affiliation_a>

#text(5pt,style:"italic",
[#super([b]) Department of Advanced Computing Sciences, Faculty of Science and Engineering, Maastricht University, Maastricht, The Netherlands
])<affiliation_b>

#text(5pt,style:"italic",
[#super([c]) work done during an internship at #super[a]])<affiliation_star>




// abstract
#let abstract = [
  Recent advancements in vision-language models have significantly enhanced the performance of medical visual question answering (MedVQA). However, challenges remain at each stage of development, including dataset curation, fine-tuning, evaluation, and identifying cases where the model might be ill-conditioned for use. In this study, we fine-tune a lightweight, generalist multimodal model for MedVQA, capable of answering both open and closed-ended queries. Our results show that even a smaller model can demonstrate substantial reasoning capabilities. Although it is not comparable to the current state-of-the-art models, it establishes a new benchmark within its size class. We provide a detailed account of the challenges and common pitfalls encountered during the entirety of model development.  Additionally, we introduce a ready-to-use diagnostic tool based on saliency analysis, which aids current expert evaluation techniques and helps providing diagnostic indicators for poor generation quality. Our ablation studies highlight the importance of existing robust dataset curation techniques, such as annealing and multi-stage fine-tuning, to improve model performance.
  
]
#show_abstract(abstract)


// Advancements in vision-language models  have significantly improved medical visual question answering. However, challenges remain in generating effective dataset for finetuning, and evaluation methodologies. In this work, we finetune a lightweight  generalist multimodal model for MedVQA for both open and close ended queries, demonstrating that even a smaller model can achieve reasoning capabilities. While our model does not match state-of-the-art performance, it sets a new benchmark for model of its size class. We detail and compile pitfalls for each stage of model traning and evaluation. We develop a plug and play diagnostic tool based on saliency analysis to aid human evaluation and identifying indicators and reasons for bad generation. Our ablation studies reinforce the need for popular robust dataset curation techniques like annealing and multi stage finetuning

// Recent advancements in vision-language models have significantly enhanced the performance of medical visual question answering (MedVQA). However, challenges remain at each stage of development, including dataset curation, fine-tuning, evaluation, and identifying cases where the model might be ill-conditioned for use. In this study, we fine-tune a lightweight, generalist multimodal model for MedVQA, capable of handling both open- and closed-ended queries. Our results show that even a smaller model can demonstrate substantial reasoning capabilities. Although it does not yet reach state-of-the-art performance, it establishes a new benchmark within its size class. We provide a detailed account of the challenges and common pitfalls encountered during model development, from curation to evaluation. 
// Additionally, we introduce a ready-to-use diagnostic tool based on saliency analysis, which can aid during human evaluation and helps providing indicators for poor generation quality. Our ablation studies highlight the importance of robust dataset curation techniques, such as annealing and multi-stage fine-tuning, to improve model performance.


// #set par.line(numbering:n => text(purple,size:5pt)[#n])

// #columns(1)[

//-------------------
#include "sections/introduction.typ"

//-------------------
#include "sections/overview.typ"

//-------------------
#include "sections/architecture.typ"

//-------------------
#include "sections/training.typ"

//-------------------
#include "sections/scaling.typ"

//-------------------
#include "sections/evaluation.typ"

//-------------------
#include "sections/saliency.typ"

//-------------------
// #include "sections/experiments.typ"

//-------------------
#include "sections/further.typ"

//-------------------
#include "sections/conclusion.typ"


#let icon(name) = {
	let path = "../icons/" + name + ".svg"
	box(
		height: .7em,
		inset: (x: 0.05em, y: -0.22em),
		image(path, 
		height: 1.15em
		)
	)
}

= Data Availability
+ Medpix @siragusa2024medpix20comprehensivemultimodal for annealing data : #emoji.face.hug 
 #link("https://huggingface.co/datasets/adishourya/MEDPIX-ShortQA")

+ Synthetically generated question answer pairs for ROCO V2.0 @pelka2018roco can be found here:
  - Train split #emoji.face.hug #link("https://huggingface.co/datasets/adishourya/ROCO-QA-Train")
  - Valid and Test split #emoji.face.hug #link("https://huggingface.co/datasets/adishourya/ROCO-QA")
 
= Code Availability
- All the code that went into finetuning our models and their model card can be found in our #icon("github-mark") #link("https://github.com/adishourya/MedM") main repository.

- our fork of @stan2024lvlminterpretinterpretabilitytoollarge can be found here: #icon("github-mark") #link("https://github.com/adishourya/lvlm-interpret")



// ]

#bibliography("refs.bib",style: "institute-of-electrical-and-electronics-engineers")
// #bibliography("refs.bib",style: "harvard-cite-them-right")
// #bibliography("refs.bib",style: "mla")
// #bibliography("refs.bib",style: "american-physics-society")

#include "sections/appendix.typ"