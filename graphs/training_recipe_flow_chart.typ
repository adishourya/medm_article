#import "@preview/fletcher:0.5.3" as fletcher: diagram, node, edge
#import fletcher.shapes: house, hexagon, diamond
#import "../src/template.typ": my_colors
#import "../src/callouts.typ": *

#set text(size:8pt)

#let cur_color = my_colors.accent1
#let cur_nodes = cur_color.lighten(90%)

#let ft_color = my_colors.accent3
#let ft_nodes = ft_color.lighten(95%)

#let eval_color = my_colors.accent6
#let eval_nodes = eval_color.lighten(95%)

#let node_pos = (
  "curation": (0,0),
  "genqa": (0.6,0),
  "filter": (1.2,0),
  "anneal": (1.8,0),
  "fft": (2.6,0),
  "sft": (3.2,0),
  "eval": (4.0,0),
  "diag": (4.9,0),
)

#diagram(
 node-stroke: 1pt,
 node-corner-radius:5pt,
 
 node(node_pos.curation,
 fill:cur_nodes,
 stroke:cur_color,
 [Collect\ DataMix],
 shape:circle,
 name: <A>),
 
 edge("->",stroke:0.75pt+cur_color.darken(30%)),
 
 node(node_pos.genqa,
 fill:cur_nodes,
 stroke:cur_color,
 [Generate\ QA pairs],
 name: <B>),
 
 // edge("->"),
 edge("->",stroke:0.75pt+cur_color.darken(30%)),
 node(node_pos.filter,
 fill:cur_nodes,
 stroke:cur_color,
 [Filter\ QA pairs],
 shape:rect,
 name: <C>),
 
 edge("->",stroke:0.75pt+cur_color.darken(30%)),
 node(node_pos.anneal,
 fill:cur_nodes,
 stroke:cur_color,
 [Perform\ Annealing],
 name: <anneal>),
 
 node(fill:cur_color.lighten(45%),
 stroke:(dash:"dashed",paint:cur_color),
 width:14em,height:8.5em,
 align(bottom)[#text(size:8pt,weight: 200)[*Data Curation*]],
 enclose: (<A>, <B>, <C>,<anneal>), name: <group>
),
 
 edge("->",stroke:1pt+cur_color.darken(30%)),

 node(node_pos.fft,
 fill:ft_nodes,
 stroke:ft_color,
 [First\ Stage FT.], shape:rect, name: <D>),
 
 edge("->",stroke:0.75pt+ft_color.darken(30%)),

 node(node_pos.sft,
 fill:ft_nodes,
 stroke:ft_color,
 [Second\ Stage FT.], shape:rect, name: <E>),


 node(fill:ft_color.lighten(55%),
 stroke: (dash:"dashed",paint:ft_color),
 width:14em,height:8.5em,
 align(bottom)[#text(size:8pt,weight: 200)[*Fine Tuning*]],
 enclose: (<D>, <E> ), name: <group>
),
 
 // edge("->",stroke:cur_color),
 edge("->",(4.5,0),stroke:1pt+ft_color.darken(5%)),
 
 node(node_pos.eval,
 fill:eval_nodes,
 stroke:eval_color,
 [Evaluation\ Metrics], shape:rect, name: <F>),

 edge("->",stroke:0.75pt+eval_color),

 node(node_pos.diag,
 fill:eval_nodes,
 stroke:eval_color,
 [Perform\ Diagnostics], shape:rect, name: <G>),
 
 node(fill:eval_color.lighten(55%),
 stroke: (dash:"dashed",paint:eval_color),
 width:10em,height:8.5em,
 align(bottom)[#text(size:8pt,weight: 200)[*Examine*]],
 enclose: (<F>, <G> ), name: <group>
),
)
