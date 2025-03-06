#import "../callouts.typ" : *

= Evaluation and Results <section_evaluation>
#plan[

  To evaluate medical generation gets quite tricky.
natural language fluency rogue. is not the desired metric.
edit distance. does not help us either as the length of generation is not an indicator of truthness.

we present them regardless for.

calculating accuracy has more than a few methods:
 - to answer pmc style questions is easier .
  - but the expectation of accuracy is determined by number of choices.
  - ideally we can increase number of choices.but this is mostly an unfeasible setting.(as the quality of choices may degrade).

leverage llm to be the judge of your answer by benchmarking them on open ended questions.
  - This too is slightly ill conditioned.

  
Methods of Evaluation
- One of the other methods to calculate accuracy is to make the model answer multiple choice questions.
But Model trained on multiple choice questions sometimes learn the underlying distributions of the right answer choice.And the expectation of accuracy is often overestimated if the number of choices are small.
- to deal with it people do inference 5 times for each example in the test set and then dock a point if we get a different answer 3/5 times.

- For open ended question answering we generate answers on the test split with max generation of 128 and topK as 40 and use ollama as a validation tool . similar to the methodology followed in @Singhal2023.

For evaluating our models we perform.
  - 
		
]

#let evaluation_example_figure = align(left)[#rect(height: 120pt,width:100%,radius:5pt,fill:gradient.linear(green.lighten(85%),white,red.lighten(85%)).sharp(3,smoothness:99%))[#grid(
  columns:(0.7fr,1.3fr,0.15fr,0.7fr,1.3fr),

  // first example image
  rect(height:100%,width:100%,radius: 5pt,fill:green.lighten(95%),stroke: 0.7pt+green)[
    #rect(height:80pt,width:100%,radius:5pt,stroke:none)[#image("../../our_images/evaluation/roco_44266.jpeg",height:70pt)]
    #v(-1.2em)
    #par(leading:2pt)[#text(size:6pt)[#emoji.child: Does the lesion described in the image cross the midline?]] 
  ],
  

// first example generation
  rect(height:100%,width:100%,radius: 5pt,fill:green.lighten(95%),stroke:1pt+my_colors.accent8)[
    #text(size:6pt)[
    Generation #emoji.robot: #text(fill:blue)[_*Coronal CT Image shows the lesion crossing the midline.*_]\
    True Answer #emoji.policeofficer: #text(fill:my_colors.accent6.darken(60%))[*Coronal CT after intrvenous contrast injection: expnaisve cervical process showing that the medial border of the mass crosses the midline.*]\
    #line(length:100%,stroke:(dash:"dashed",thickness:0.5pt))
    
    Bleu: $4.8 e-150$ \
    RougeL: $0.235$ \
    Accuracy #icon("chatgpt"): #icon("tick")
  ]
  ],
  // empty for column gutter 
  [],

  // second example
  rect(height:100%,width:100%,radius: 5pt,fill:red.lighten(95%),stroke:0.7pt+red)[
    #rect(height:80pt,width:100%,stroke:none)[#image("../../our_images/evaluation/roco_29769.jpeg",height: 70pt)]
    #v(-1.2em)
    #par(leading:2pt)[#text(size:6pt)[#emoji.child:What appears to be the issue given an arrow indicated at the image?]] 
  ],

  rect(height:100%,width:100%,radius: 5pt,fill:red.lighten(95%),stroke:1pt+red)[
    #text(size:6pt)[
    Generation #emoji.robot: #text(fill:blue)[_*Postoperative upper gastrointestinal tract image showing slight narrowing of the gastro epigastrium.*_]\
    True Answer #emoji.policeofficer: #text(fill:my_colors.accent6.darken(60%))[*Postoperative UGI showing slight narrowing at mid body of stomach (arrow).*]\
    #line(length:100%,stroke:(dash:"dashed",thickness:0.5pt))
    Bleu: $1.88 e-78$ \
    RougeL: $0.263$ \
    Accuracy #icon("chatgpt"): #icon("cross")
  ]
  ],
  // [hi]  
)
] ]

#figure(evaluation_example_figure,caption:[Generation and Evaluation on test samples from @pelka2018roco])

#let eval_section = [
  
  == Our methodology
  
  - For closed set questions like in PMC-VQA @xmcmic_pmc_vqa we report accuracy.
  
    - To deal with the current limitation of accuaracy we take inspiration from @zhang2024pmcvqavisualinstructiontuning do inference 5 times #footnote[not yet done!] and dock a point if the generation has different answer label 3/5 times.

  - To evaluate open ended questions from our tests set (@pelka2018roco,@MedPix) we use template #footnote[add prompt] to evaluate our generation from @OpenAI_ChatGPT.
  
]

== limitations of standard evaluation metrics
Before presenting our evaluation strategy, it is essential to highlight the shortcomings of standard NLP metrics and conventional accuracy calculations in fairly assessing generative models.  

- *Multiple-Choice Accuracy Bias*: Many accuracy calculations for VLMs rely on multiple-choice questions, making scoring straightforward. However, this approach is inherently flawed, as expected accuracy is directly influenced by the number of answer choices. A possible solution is to increase the number of choices, but this is often infeasible, especially for complex medical queries. While human annotation can enhance multiple choices quality, automated scoring remains an over-estimate of the true accuracy. 

  Multiple-choice evaluation methods also suffers from model stochasticity. Since generative models can produce different outputs for the same prompt across multiple runs, accuracy scores may vary significantly on the same test set.
  
  // Besides accuracy being over-estimate calculation. They can also suffer from model's stochasticness. That is we can get different accuracy score on the same test set over multiple generation

- *Limitations of Standard NLP Metrics*: Metrics like BLEU @papineni2002bleu and ROUGE @lin-2004-rouge, while widely used in NLP, are poorly suited for evaluating open-ended medical responses. These metrics primarily measure n-gram overlap, which fails to capture factuality or reasoning correctness. Since, open ended questions inherently can be answered in multiple valid ways, a low score does not necessarily indicate a poor response, but more importantly a high score does not ensure clinical reliability.  

- Despite their limitations, we present these metrics for completeness while emphasizing the need for more robust evaluation strategies in @table_annealing.


== Our Evaluation Methodology  

- *Closed-Set Question Evaluation*: For multiple-choice questions, such as those in @xmcmic_pmc_vqa, we report accuracy as the primary metric.  

  - To address the limitations of standard accuracy calculations, we draw inspiration from @zhang2024pmcvqavisualinstructiontuning and perform inference five times. If the model generates different answer labels in at least three out of five runs, we dock a point to account for inconsistency.  

- *Open-Ended Question Evaluation*: For free-form responses in datasets such as @pelka2018roco and @MedPix, we leverage llm based evaluation. Specifically, we use a predefined template to systematically assess model generations via @OpenAI_ChatGPT.  

== Ablation studies across annealing
- We observed a performance improvement with annealing, even when using a small volume of annealing data, as shown in @table_annealing. While larger annealing datasets may further enhance robustness, our results indicate that even modest annealing can yield benefits for cheap. 


// #linebreak()
// #glorem(num:100)

#set table(
  stroke:none,
  gutter: 0.1em,
  fill: (x, y) =>{ 
    if x==0 and y==0 {my_colors.accent10.lighten(40%)}
    else if x == 0 and y > 0 {gray.lighten(80%)} 
    else if y==0 {gray.lighten(60%)} 
    else {my_colors.alt_fg.lighten(40%)}},
  inset: (right: 1.5em),
  )

#let nlp_eval_table_noprestage =figure(
table(
  columns: 4,
  [Metrics],[Medpix v2.0],[ROCO v2.0],[ROCO v2.0 + Medpix v2.0],
  
  [rouge-s],[0.311 #sym.plus.minus 0.255],[0.325 #sym.plus.minus 0.132],[0.334 #sym.plus.minus 0.122],
  
  [rouge-m],[0.167 #sym.plus.minus 0.082],[0.179 #sym.plus.minus 0.124],[0.181 #sym.plus.minus 0.124],
  
  [rouge-l],[0.308 #sym.plus.minus 0.125],[0.278 #sym.plus.minus 0.120],[0.304 #sym.plus.minus 0.180],
  
  [Bleu]   ,[0.055 #sym.plus.minus 0.111],[0.059 #sym.plus.minus 0.090],[0.077 #sym.plus.minus 0.065],
  
  [*Accuracy*],[34/200 *(82/200)*],[63/200 *(113/200)*],[71/200 *(113/200)*],
  
),caption:[results with no pre-stage finetuning #sym.plus.minus 1 standard deviation (*LLava-Med* @li2023llavamedtraininglargelanguageandvision as baseline)])



#let nlp_eval_table_withprestage =figure(
table(
  columns: 6,
  [Metrics],[SLAKE],[Medpix v2.0],[ROCO v2.0],[ROCO v2.0 + Medpix v2.0],[PMC-VQA],
  
  [rouge-s],[-],[? #sym.plus.minus ?],[? #sym.plus.minus ?],[? #sym.plus.minus ?],[-],
  
  [rouge-m],[-],[? #sym.plus.minus ?],[? #sym.plus.minus ?],[? #sym.plus.minus ?],[-],
  
  [rouge-l],[-],[? #sym.plus.minus ?],[? #sym.plus.minus ?],[? #sym.plus.minus ?],[-],
  
  [Bleu]   ,[-],[? #sym.plus.minus ?],[? #sym.plus.minus ?],[? #sym.plus.minus ?],[-],
  
  [*Accuracy*],[68/100 *(87/100)*],[? *(82/200)*],[? *(113/200)*],[? *(113/200)*],[0.31046]
  
),caption:[results with pre-stage #sym.plus.minus 1 standard deviation (*LLava-Med* @li2023llavamedtraininglargelanguageandvision as baseline) #footnote[we will transpose the results later]])


#nlp_eval_table_noprestage <table_annealing>
#set table(
  stroke:none,
  gutter: 0.1em,
  fill: (x, y) =>{ 
    if x==0 and y==0 {my_colors.accent3.lighten(40%)}
    else if x == 0 and y > 0 {gray.lighten(80%)} 
    else if y==0 {gray.lighten(60%)} 
    else {my_colors.alt_fg.lighten(40%)}},
  inset: (right: 1.5em),
  )

#linebreak()  
// - #text(fill: gray)[We observed (no/a?) significant improvement when performing the first stage of fine-tuning with semantic label examples from @liu2021slakesemanticallylabeledknowledgeenhanceddataset, as shown in @table_prestage, highlighting the effectiveness of prepending semantically enriched data for model performance enhancement.]
// -
// #linebreak()
// #nlp_eval_table_withprestage <table_prestage>

