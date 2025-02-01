#import "../callouts.typ" : *

= Evaluation and Results <section_evaluation>
#plan[
	#emoji.star for both evaluation and results
	+ summarize experiments
	+   towards deployable LLM based radiology reports
		- LLM based reports so that we can make better and open datasets.
		- explainability easier to filter out bad examples through heval
		
]




#let nlp_eval_table = figure(
table(
  columns: 4,
  [Metrics],[roco],[roco+medpix],[cxr-jpg],
  [rouge-s],[0.325 #sym.plus.minus 0.132],[0.334 #sym.plus.minus 0.122],[],
  [rouge-m],[0.179 #sym.plus.minus 0.124],[0.181 #sym.plus.minus 0.124],[],
  [rouge-l],[0.278 #sym.plus.minus 0.120],[0.304 #sym.plus.minus 0.180],[],
  [Bleu]   ,[0.059 #sym.plus.minus 0.090],[0.077 #sym.plus.minus 0.065],[],
  [*Accuracy*],[0.315],[0.366],[],
),caption:[results #sym.plus.minus 1 standard deviation])

#oasis-align(nlp_eval_table,[#glorem(num:50)])

#glorem(num:100)