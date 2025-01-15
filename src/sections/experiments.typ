#import "../callouts.typ": *

= Other Experiments <section_experiments>
== Explainability with Saliency Maps <section_saliency>
#plan[

	// #figure(
	//   grid(columns: 2,column-gutter: 12pt,
	//   image("../others/gradcam.png"),image("../others/saliencymaps.png")
	// ),
	//   placement: auto,
	//   scope:"parent",
	//   caption: [LEFT : Method, Right something like this for our vision tower implementation @jacobgilpytorchcam ; paper @Selvaraju_2019]
	// )



+ pubmedclip @eslami2021doesclipbenefitvisual also had this idea but they didnt do it . they kept it in their discussion section.
+ attention based saliency maps to highlight the most influential region in image
+ there are implementation for attention based mapping. I havent found attention + lora based saliency mapping . 

+ we will probably have to formaly present more than 1 method of saliency maps
+ since there is a lot of arguments/debate over the choice of true evaluation metrics. we believe when we first start out a report should have explainabilty section for H-evals.
+ Raw attentions / Attention rollout / Attention flow

]

#glorem(num:100)

#grid(
  columns: (1fr,1fr,1fr),
  figure(rect(height: 100pt, width:100pt),caption:[Raw Attentions]),
  figure(rect(height: 100pt, width:100pt),caption:[Rollout Attentions]),
  figure(rect(height: 100pt, width:100pt),caption:[Flow Attentions]),
)

=== Raw Attentions
#glorem(num:100)

=== Attention Rollout
#glorem(num:100)

=== Attention Flow
#glorem(num:100)



== Chain of Thought prompting
#plan[
	- cot ++ showed no effect on medpalm . but medpalm was text only qa. we can do ablation studies on vqa
]
#glorem(num:100)
//-------------------

== Few shot prompting at evaluataion

#plan[
	+ briefly explain and show examples.
]
#glorem(num:100)