#import "../callouts.typ":* 

= Overview <section_overview>
#plan[
- #comment[we will write this at the end!]
- summarize the flow of the document and the need for the sections
- whats not the focus of our document:
- improving state of the art on literature based question answering. SOTA models get somewhere around 67.6% accuracy on MedQA (US Medical Licensing Exam-style questions) which is considerably inferior to clinicians.And we suspect clinicians would be better at intricate questions at least for few more years.
- trimming out private details whilst curating dataset (privacy issues) we assume we have filtered medical corpus 
- we focus on (Key Contribution) :
- approximate dataset mix (volume) to get desired test loss
- compile techniques for generating question answer pairs for medical image text corpus.
- ablation studies effect of cot++ and few shot prompting on vqa.
- and then we will release both model and data (except cxr)
- #todo[better argument for using 4b model like paligemma while medpalm uses 540B and llava uses 8B]
- *all while using freely accessible models and datasets*
  - llava : model #emoji.checkmark data #emoji.crossmark
  - medpalm : model #emoji.crossmark data (script #emoji.checkmark , multimodality #emoji.crossmark)
- so our article can also focus on how to prepare and what to expect when better instruct dataset releases 
- And Evaluation


]

// #text(fill:white.darken(40%), lorem(400))
#glorem(num:650)
