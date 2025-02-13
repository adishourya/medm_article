#import "@preview/fletcher:0.5.3" as fletcher: diagram, node, edge
#import fletcher.shapes: house, hexagon, diamond
#import "../src/template.typ": my_colors
#import "../src/callouts.typ": *

#set text(size:8pt)

#let cur_color = my_colors.accent13
#let cur_nodes = cur_color.lighten(90%)

#let ft_color = my_colors.accent14
#let ft_nodes = ft_color.lighten(95%)

#let eval_color = my_colors.accent8
#let eval_nodes = eval_color.lighten(95%)

#let node_pos = (
  "curation": (0,0),
  "genqa": (0.7,0),
  "filter": (1.4,0),
  "fft": (2.5,0),
  "sft": (3.2,0),
  "eval": (4.3,-0.25),
  "diag": (4.3,0.25),
)

#diagram(
 node-stroke: 1pt,
 node-corner-radius:5pt,
 
 node(node_pos.curation,
 fill:cur_nodes,
 stroke:cur_color,
 [Collect\ DataMix],
 name: <A>),
 
 edge("->"),
 
 node(node_pos.genqa,
 fill:cur_nodes,
 stroke:cur_color,
 [Generate\ QA pairs],
 name: <B>),
 
 edge("->"),
 node(node_pos.filter,
 fill:cur_nodes,
 stroke:cur_color,
 [Filter\ QA pairs],
 name: <C>),
 
 node(fill:cur_color.lighten(75%),
 stroke:(dash:"dashed",paint:cur_color),
 width:14em,height:8.5em,
 align(bottom)[#text(size:8pt,weight: 200)[*Data Curation*]],
 enclose: (<A>, <B>, <C>), name: <group>
),
 
 edge("->"),

 node(node_pos.fft,
 fill:ft_nodes,
 stroke:ft_color,
 [First\ Stage FT.], shape:rect, name: <D>),
 
 edge("->"),

 node(node_pos.sft,
 fill:ft_nodes,
 stroke:ft_color,
 [Second\ Stage FT.], shape:rect, name: <E>),


 node(fill:ft_color.lighten(85%),
 stroke: (dash:"dashed",paint:ft_color),
 width:14em,height:8.5em,
 align(bottom)[#text(size:8pt,weight: 200)[*Fine Tuning*]],
 enclose: (<D>, <E> ), name: <group>
),
 
 // edge("->",stroke:cur_color),
 edge("->",(4.5,0)),
 
 node(node_pos.eval,
 fill:eval_nodes,
 stroke:eval_color,
 [Evaluation\ Metrics], shape:rect, name: <F>),

 edge("->"),

 node(node_pos.diag,
 fill:eval_nodes,
 stroke:eval_color,
 [Perform\ Diagnostics], shape:rect, name: <G>),
 
 node(fill:eval_color.lighten(95%),
 stroke: (dash:"dashed",paint:eval_color),
 width:10em,height:14em,
 align(bottom)[#text(size:8pt,weight: 200)[*Examine*]],
 enclose: (<F>, <G> ), name: <group>
),
)
