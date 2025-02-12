#import "@preview/fletcher:0.5.3" as fletcher: diagram, node, edge
#import fletcher.shapes: house, hexagon,diamond
#import "../src/template.typ": my_colors
#import "../src/callouts.typ": * 

// #set page(width: auto, height: auto, margin: 5mm, fill: white)
#set text(font: "Space Mono",size:8pt)




#let edge_values = (
  [#rect[#icon("llm") Medical Finetuned\ Text only LLM]],
)


#let blob(pos, label, tint: white, ..args) = node(
	pos, 
   align(center, label),
	// width: 26mm,
   width:auto,
	fill: tint.lighten(60%),
	stroke: 1pt + tint.darken(20%),
	corner-radius: 2pt,
	..args,
)

#let nodes = (
  corpus : (0,0),
  filter0: (0,1),
  llm : (0,2),
  bucket0 : (-0.2,3.5),
  bucket1 : (0.2,3.5),
  filter : (0,4.8),
  bin : (0.35,4.8),
  final : (0,6.2)
)

#let node_values = (
  corpus : [Medical\ Corpus],
  pathology:[Filter on pathologies],
  llm : [#emoji.robot LLM],
  literature : [Literature Based\ Question],
  related_image : [Question Related\ to Image],
  filter: [Pass human evaluation],
  bin : [#emoji.bin\ Discard],
  final : [Filtered\ QA Pairs],
)

#let annots = (
  [#text(size:6pt)[Template\ @prompt_template1]],
  [#text(size:6pt)[Template\ @prompt_template2]],
)



#diagram(
	spacing: 8pt,
	cell-size: (10cm, 12mm),
	edge-stroke: 1pt,
	edge-corner-radius: 2pt,
	mark-scale: 70%,

   // nodes
	blob(nodes.corpus,node_values.corpus, tint: my_colors.accent.lighten(50%), shape: house),
	blob(nodes.filter0,node_values.pathology, tint:my_colors.accent3.lighten(50%)),
	blob(nodes.llm,node_values.llm, tint: white),
	blob(nodes.bucket0,node_values.literature, tint: gray.darken(10%)),
	blob(nodes.bucket1,node_values.related_image,tint:gray.lighten(30%)),
	blob(nodes.filter,node_values.filter,tint:my_colors.accent3.lighten(50%),shape:hexagon),
   node(nodes.bin,node_values.bin),
	blob(nodes.final,node_values.final, tint: green.lighten(30%), shape:house),

   //annot
   node((0.28,2.5),annots.at(0)),
   node((-0.28,2.5),annots.at(1)),


   // edges
   // edge(nodes.corpus,edge_values.at(0)),
   edge(nodes.corpus,nodes.filter0),
   edge(nodes.filter0,nodes.llm,stroke:(thickness:1.5pt,paint:my_colors.accent4)),
   edge((0,2),(-0.2,2),"-"),
   edge((-0.2,2),nodes.bucket0,[],"-|>"),
   // edge(nodes.llm, nodes.bucket0,[Template\ @prompt_template1],"--|>"),
   
   edge((0,2),(0.2,2),"-"),
   edge((0.2,2), nodes.bucket1,[],"-|>"),
   // edge(nodes.llm, nodes.bucket1,[Template\ @prompt_template2],"--|>"),
   
   edge(nodes.bucket0, (0,4),[],"-"),
   edge(nodes.bucket1, (0,4),[],"-"),

   edge((0,4),nodes.filter,"-|>"),
   
   edge(nodes.filter, nodes.bin,[else],"-|>"),
   edge(nodes.filter,nodes.final,[if],"-|>")
)

