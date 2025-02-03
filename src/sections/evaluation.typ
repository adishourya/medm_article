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




#let nlp_eval_table = figure(
table(
  columns: 4,
  [Metrics],[roco],[roco+medpix],[pmc-vqa],
  [rouge-s],[0.325 #sym.plus.minus 0.132],[0.334 #sym.plus.minus 0.122],[-],
  [rouge-m],[0.179 #sym.plus.minus 0.124],[0.181 #sym.plus.minus 0.124],[-],
  [rouge-l],[0.278 #sym.plus.minus 0.120],[0.304 #sym.plus.minus 0.180],[-],
  [Bleu]   ,[0.059 #sym.plus.minus 0.090],[0.077 #sym.plus.minus 0.065],[-],
  [*Accuracy*],[63/200],[71/200],[?],
),caption:[results #sym.plus.minus 1 standard deviation])

#wrap-content(nlp_eval_table,[#glorem(num:250)])

#glorem(num:100)
