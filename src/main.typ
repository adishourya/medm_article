// use #comment[comment here] <- to add comments
// use #todo[todo text here]  <- to add todo
//--------------------------------

#import "template.typ" : *
#show: my_template


// Title

#let title = [
	*Adapting Lightweight Multimodal Language Models for #linebreak()
	Radiological Visual Question Answering #linebreak()
	A Practical Approach*
]

// current limitations of adapting generalist VLM for radiological visual
// linguistic tasks ?

#show_title(title)


// authors
#grid(columns: (1fr,1fr),

  align(center)[Chang Sun #link(<affiliation_a>,super[a])
  #h(-0.3em)#super[,]#h(-0.3em)
  #link(<affiliation_a>,super[b])\
  #text(size:8pt,
  "chang.sun@maastrichtuniversity.nl")],
  
  align(center)[me #link(<affiliation_b>,super[b])
  #h(-0.3em)#super[,]#h(-0.3em)
  #link(<affiliation_star>,super[#sym.dagger])\
  #text(size:8pt,
  "my_email")]
)


#text(5pt,style: "italic",
[#super([a]) Institute of Data Science, Faculty of Science and Engineering, Maastricht University, Maastricht, The Netherlands])<affiliation_a>

#text(5pt,style:"italic",
[#super([b]) Department of Advanced Computing Sciences, Faculty of Science and Engineering, Maastricht University, Maastricht, The Netherlands
])<affiliation_b>

#text(5pt,style:"italic",
[#super([#sym.dagger]) work done during an internship at #super[a]])<affiliation_star>



// abstract
#let abstract = [#lorem(150)]
#show_abstract(abstract)

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
- Medpix for annealing data : #emoji.face.hug 
  #link("https://huggingface.co/datasets/adishourya/MEDPIX-ShortQA")

- Synthetically generated question answer pairs of @pelka2018roco can be found here:
  - Train split #emoji.face.hug #link("https://huggingface.co/datasets/adishourya/ROCO-QA-Train")
  - Valid and Test split #emoji.face.hug #link("https://huggingface.co/datasets/adishourya/ROCO-QA")
 
= Code Availability
- All the code that went into finetuning our models and their model card can be found in our #icon("github-mark") #link("https://github.com/adishourya/MedM") main repository.

- our fork of @stan2024lvlminterpretinterpretabilitytoollarge can be found here: #icon("github-mark") #link("https://github.com/adishourya/lvlm-interpret")



// ]

#bibliography("refs.bib",style: "institute-of-electrical-and-electronics-engineers")

#include "sections/appendix.typ"