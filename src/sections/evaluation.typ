#import "../callouts.typ" : *

= Evaluation and Results <section_evaluation>
#plan[
	#emoji.star for both evaluation and results
	+ summarize experiments
	+   towards deployable LLM based radiology reports
		- LLM based reports so that we can make better and open datasets.
		- explainability easier to filter out bad examples through heval
		
]

#set table(
stroke: none,
gutter: 0.1em,
fill: (x, y) =>{ 
  if x==0 and y==0 {my_colors.accent}
  else if x == 0 and y < 5 {gray.darken(50%)} 
  else if x == 0 and y == 5 {black} 
  else if y==0 {gray} 
  else {rgb("#eceff4")}},
inset: (right: 1.5em),
)

#show table.cell: it => {
  if it.x == 0 or it.y ==0 {
    set text(white)
    strong(it)}
    
  else if it.x==3 and it.y==5{
    set text(red)
    strong(it)
  }

  else if it.body == [] {
    // Replace empty cells with 'N/A'
    pad(..it.inset)[_N/A_]
  } else {
    it
  }
}



#let nlp_eval_table = figure(
table(
  columns: 4,
  [Metrics],[roco],[roco+medpix],[cxr-jpg],
  [rouge-s],[0.4 #sym.plus.minus 0.03],[],[],
  [rouge-m],[0.1],[],[],
  [rouge-l],[0.3],[],[],
  [Bleu],[0.1],[],[],
  [Accuracy],[],[],[],
),caption:[nlp metrics results])

#oasis-align(nlp_eval_table,[#lorem(60)])

#lorem(100)