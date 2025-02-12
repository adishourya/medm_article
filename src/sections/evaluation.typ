#import "../callouts.typ" : *

= Evaluation and Results <section_evaluation>
#plan[
	#emoji.star for both evaluation and results
	+ summarize experiments
	+   towards deployable LLM based radiology reports
		- LLM based reports so that we can make better and open datasets.
		- explainability easier to filter out bad examples through heval

  
Methods of Evaluation
- One of the other methods to calculate accuracy is to make the model answer multiple choice questions. But Model trained on multiple choice questions sometimes learn the underlying distributions of the right answer choice.And the expectation of accuracy is often overestimated if the number of choices are small.
- For open ended question answering we generate answers on the test split with max generation of 128 and topK as 40 and use ollama as a validation tool . similar to the methodology followed in @Singhal2023.
		
]

#let evaluation_example_figure = align(left)[#rect(height:120pt,width:100%,radius:5pt,fill:white)[#grid(
  columns:(0.7fr,1.3fr,0.05fr,0.7fr,1.3fr),

  // first example image
  rect(height:100%,width:100%,radius: 5pt,fill:my_colors.alt_fg,stroke: 1pt)[
    #rect(height:80pt,width:100%,radius:5pt,stroke:none)[#image("../../our_images/evaluation/roco_44266.jpeg",height:70pt)]
    #v(-1em)
    #par(leading:2pt)[#text(size:6pt)[#emoji.child: Does the lesion described in the image cross the midline?]] 
  ],
  

// first example generation
  rect(height:100%,width:100%,radius: 5pt,fill:my_colors.alt_fg.lighten(20%))[
    #text(size:6pt)[
    Generation: #text(fill:blue)[_Coronal CT Image shows the lesion crossing the midline._]\
    True Answer: #text(fill:green.darken(30%))[Coronal CT after intrvenous contrast injection: expnaisve cervical process showing that the medial border of the mass crosses the midline.]\
    #line(length:100%,stroke:(dash:"dashed",thickness:0.5pt))
    
    Bleu: $4.8 e-150$ \
    RougeL: $0.235$ \
    Accuracy #icon("chatgpt"): #icon("tick")
  ]
  ],
  // empty for column gutter 
  [],

  // second example
  rect(height:100%,width:100%,radius: 5pt,fill:my_colors.alt_bg.lighten(88%),stroke:1pt)[
    #rect(height:80pt,width:100%,stroke:none)[#image("../../our_images/evaluation/roco_29769.jpeg",height: 70pt)]
    #v(-1em)
    #par(leading:2pt)[#text(size:6pt)[#emoji.child:What appears to be the issue given an arrow indicated at the image?]] 
  ],

  rect(height:100%,width:100%,radius: 5pt,fill:my_colors.alt_bg.lighten(88%))[
    #text(size:6pt)[
    Generation: #text(fill:blue)[_Postoperative upper gastrointestinal tract image showing slight narrowing of the gastro epigastrium._]\
    True Answer: #text(fill:green.darken(30%))[Postoperative UGI showing slight narrowing at mid body of stomach (arrow).]\
    #line(length:100%,stroke:(dash:"dashed",thickness:0.5pt))
    Bleu: $1.88 e-78$ \
    RougeL: $0.263$ \
    Accuracy #icon("chatgpt"): #icon("cross")
  ]
  ],
  
)]]

#figure(evaluation_example_figure,caption:[])


#let nlp_eval_table =figure(
table(
  columns: 6,
  [Metrics],[SLAKE],[Medpix],[roco],[roco + medpix],[pmc-vqa],
  
  [rouge-s],[-],[0.311 #sym.plus.minus 0.255],[0.325 #sym.plus.minus 0.132],[0.334 #sym.plus.minus 0.122],[-],
  
  [rouge-m],[-],[0.167 #sym.plus.minus 0.082],[0.179 #sym.plus.minus 0.124],[0.181 #sym.plus.minus 0.124],[-],
  
  [rouge-l],[-],[0.308 #sym.plus.minus 0.125],[0.278 #sym.plus.minus 0.120],[0.304 #sym.plus.minus 0.180],[-],
  
  [Bleu]   ,[-],[0.055 #sym.plus.minus 0.111],[0.059 #sym.plus.minus 0.090],[0.077 #sym.plus.minus 0.065],[-],
  
  [*Accuracy*],[?],[34/200 ()],[63/200 ()],[71/200 ()],[? ()]
  
),caption:[results #sym.plus.minus 1 standard deviation])

#glorem(num:400)
#nlp_eval_table

