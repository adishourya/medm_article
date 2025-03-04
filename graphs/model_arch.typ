
#import "@preview/fletcher:0.5.3" as fletcher: diagram, node, edge

#import fletcher.shapes: house, hexagon, diamond, trapezium
#import "../src/template.typ": my_colors
#import "../src/callouts.typ": *

#import "../src/template.typ": my_colors 


// #set page(width: auto,height: auto)

#set text(size:8pt)

#let image_color = my_colors.accent3.lighten(50%)
#let text_color = my_colors.accent10.lighten(40%)
#let llm_color = my_colors.accent11.lighten(50%)

#let node_pos = (
  "image": (0,0),
  "question":(0,0.7),
  "input_label":(0,1.3),
  
  "vit":(1.1,0),
  "projection": (2.1,0),

  "tokenizer":(1.1,0.7),

  "concat1":(3,-0.4),
  "concat2":(3,0.7),
  "concat_label":(3,1.6),

  "llm":(4,-0.5),
  "generation":(4,0.5),
  "gen_label":(4,1)
)


#diagram(
 node-stroke: 1pt,
 node-corner-radius:5pt,

 node(node_pos.image,
height:10em,
width:10em,
[#image("model_chest.jpg",height: 7em,width: 8em)],
fill:my_colors.alt_fg,
stroke:(dash:"dashed",thickness:2pt,paint:image_color),
name:"img"
),

 node(node_pos.question,
height:6em,
width:12em,
[#text(size:5pt)[#emoji.man: What is the finding shown on this chest radiograph taken after an endoscopic procedure?]],
fill:my_colors.alt_fg,
stroke:(dash:"dashed",thickness:2pt,paint:text_color),
name:"ques"
),


node(fill:my_colors.alt_fg.darken(5%),
stroke:(thickness:1pt),
 width:5em,height:20em,
 // align(bottom)[#text(size:5pt)[Input Image and Text prompt]],
 enclose: (<img>, <ques>),
 name: <img_ques>
),



 node(node_pos.vit,
height:8em,
width:15em,
[Vision Tower],
fill:image_color,
stroke:image_color.darken(10%),
name:"vit"
),



 node(node_pos.projection,
 height:10em,
 width:5em,
 fill:white.darken(5%),
 stroke:1pt+white.darken(25%),
 [#rotate(-90deg)[#text(size:6pt)[Projection\ head]]],
shape:trapezium.with(dir:left,angle:55deg),
name:"proj"
),



 node(node_pos.tokenizer,
height:5em,
width:16em,
[`["what","is".. "procedure","?"]`\ #v(-2em) Tokenizer],
fill:text_color,
stroke:text_color,
name:"tok"
),

 node(node_pos.concat1,
height:12em,
width:4em,
 [#rotate(-90deg)[#text(size:5pt)[Image Features]]],
// [image features],
fill:image_color.lighten(50%),
stroke:image_color.darken(10%),
name:"c1"
),

 node(node_pos.concat2,
height:12em,
width:4em,
 [#rotate(-90deg)[#text(size:5pt)[Text\ Features]]],
fill:text_color.lighten(50%),
stroke:text_color.darken(10%),
name:"c2"
),

node(fill:gradient.linear(image_color,text_color,angle:90deg).sharp(2,smoothness:80%),
stroke:none,
 width:5em,height:5em,
 enclose: (<c1>, <c2>), name: <group>
),

 

 node(node_pos.llm,
height:8em,
width:8em,
[#emoji.robot LLM],
fill:llm_color,
stroke:llm_color,
),

 node(node_pos.generation,
height:10em,
width:12em,
align(left)[#par(leading: 3pt)[_Chest radiograph obtained after endoscopic submucosal dissection showing left pleural fluid with subsegmental collapse of the left lower lobe._]],
fill:llm_color.lighten(50%),
stroke:llm_color.darken(50%)
),


 node(node_pos.concat_label,
height:3.5em,
width:6em,
stroke:none,
[#text(size:5pt)[Concatinated Features]],
fill:my_colors.alt_fg
),


 node(node_pos.gen_label,
height:2em,
width:8em,
stroke:none,
[#text(size:5pt)[Model Generation]],
fill:my_colors.alt_fg
),


 node(node_pos.input_label,
height:3em,
width:8em,
stroke:none,
[#text(size:5pt)[Input Image and\ Text Prompt]],
fill:my_colors.alt_fg
),

// edges
edge(node_pos.image,node_pos.vit,"->",[#text(size:4pt,fill:image_color)[Image]],stroke:1pt+image_color),

edge(node_pos.vit,node_pos.projection,"->",stroke:1pt+image_color),

edge((2,-0.4),node_pos.concat1,"->",stroke:1pt+image_color),

edge(node_pos.question,node_pos.tokenizer,"->",stroke:1pt+text_color,[#text(size:5pt,fill:text_color)[Text]]),


edge(node_pos.tokenizer,node_pos.concat2,"->",stroke:1pt+text_color),

edge((3,-0.5),node_pos.llm,"->",[#text(size:5pt)[concat features]],stroke:(thickness:1pt,paint:black)),

edge(node_pos.llm,node_pos.generation,"->",[#text(size:5pt)[Generation]],stroke:1pt+llm_color)

)