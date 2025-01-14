// use #comment[comment here] <- to add comments
// use #todo[todo text here]  <- to add todo
//--------------------------------

#import "callouts.typ": *
#import "template.typ" : *
#show: my_template


// Title

#let title = [
	*Adapting Generalist Multimodal Language Models for #linebreak()
	Radiological Visual-Linguistic Tasks #linebreak()
	A Practical Approach*
]

#show_title(title)



// authors
#grid(columns: (1fr,1fr),

  align(center)[Chang Sun #link(<affiliation_a>,super[a])
  #h(-0.25em)#super[,]#h(-0.25em)
  #link(<affiliation_a>,super[b])\
  #text(size:8pt,
  "chang.sun@maastrichtuniversity.nl")],
  
  align(center)[me #link(<affiliation_b>,super[b])\
  #text(size:8pt,
  "my_email")]
)


#text(5pt,style: "italic",
[#super([a]) Institute of Data Science, Faculty of Science and Engineering, Maastricht University, Maastricht, The Netherlands])<affiliation_a>

#text(5pt,style:"italic",
[#super([b]) Department of Advanced Computing Sciences, Faculty of Science and Engineering, Maastricht University, Maastricht, The Netherlands
])<affiliation_b>



// abstract
#let abstract = [#lorem(150)]
#show_abstract(abstract)


// #columns(1)[

// #comment[ All the sections are taken from llama3 @touvron2023llamaopenefficientfoundation ; (except for experiments @section_saliency) these are the ones that i feel i can talk about in detail]

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
#include "sections/experiments.typ"

//-------------------
#include "sections/evaluation.typ"

//-------------------
#include "sections/conclusion.typ"

//-------------------

//-------------------




// ]
// -- end column

// #pagebreak()

#bibliography("refs.bib",style: "institute-of-electrical-and-electronics-engineers")

#include "sections/appendix.typ"