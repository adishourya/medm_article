#import "@preview/cetz:0.3.1": canvas, draw
#import "@preview/cetz-plot:0.1.0": plot
#import "../src/template.typ": my_colors 

#set text(size:8pt)

// #let plot_colors = (my_colors.accent3,my_colors.accent8,my_colors.accent9)
#let plot_colors = (rgb("#5A5B9F"), rgb("#f07178"), rgb("#4c566a"))
// #let plot_colors = (rgb("#779ecb"), rgb("#77dd77"), rgb("#ffb366"))
// #D3BFFF , #F07178 , #81D4FF , #BCE67D , #D94E70
// #let plot_colors = color.map.magma
#let color1 = plot_colors.at(0)
#let color2 = plot_colors.at(1)
#let color3 = plot_colors.at(2)

// #let style1 = (stroke:(paint: color1, thickness: 0.2pt, dash: "dashed"))
#let style1 = (stroke:(paint: color1, thickness: 1.2pt,cap:"round"))
#let style2 = (stroke:(paint:color2,thickness:1.2pt,cap:"round"))
#let style3 = (stroke:(paint:color3,thickness:0.75pt,cap:"round"))
// #let style3 = (stroke:(paint: color3, thickness: 0.6pt, dash: ("dot",2pt,5pt,2pt)))

// Training loss data converted from steps to epochs
#let cxr_epochs = (
  (0.03, 2.1792),
  (0.06, 1.1378),
  (0.10, 0.787),
  (0.13, 0.6318),
  (0.16, 0.5459),
  (0.19, 0.4975),
  (0.22, 0.4692),
  (0.26, 0.4468),
  (0.29, 0.439),
  (0.32, 0.4264),
  (0.35, 0.4172),
  (0.38, 0.4163),
  (0.41, 0.4036),
  (0.45, 0.3965),
  (0.48, 0.3895),
  (0.51, 0.3887),
  (0.54, 0.3795),
  (0.58, 0.3851),
  (0.61, 0.385),
  (0.64, 0.3736),
  (0.67, 0.3736),
  (0.70, 0.3641),
  (0.74, 0.3723),
  (0.77, 0.3616),
  (0.80, 0.3665),
  (0.83, 0.3773),
  (0.86, 0.3611),
  (0.90, 0.3594),
  (0.93, 0.3663),
  (0.96, 0.3537),
  (1.00, 0.3579),
  (2.00, 0.3216)  // Final loss value
);

#let pmc_epochs = (
  (0.05, 2.3245),
  (0.10, 0.6688),
  (0.16, 0.4822),
  (0.21, 0.4389),
  (0.26, 0.4207),
  (0.31, 0.4068),
  (0.37, 0.3867),
  (0.42, 0.3769),
  (0.47, 0.365),
  (0.52, 0.3524),
  (0.58, 0.3476),
  (0.63, 0.3331),
  (0.68, 0.3317),
  (0.74, 0.3183),
  (0.79, 0.3087),
  (0.84, 0.3053),
  (0.89, 0.2933),
  (0.95, 0.2782),
  (1.00, 0.2765),
  (2.00, 0.2585),
  (3.00, 0.2515),
  (4.00, 0.2142)  // Final loss value
);

#let slake_epochs = (
  (0.05, 2.3245),
  (1,0.8626),
  (2,0.5307),
  (3,0.4006),
  (4,0.3209),
  (5,0.278),
  
);

#canvas({
   draw.set-style(legend:())
  import draw: *

  set-style(axes: (stroke: 0pt, tick: (stroke: 0pt)),
            legend: (stroke: 0.1pt+black, orientation: ttb, item: (spacing: 0.1), scale: 100%))

  plot.plot(size:(7,8),
    x-tick-step: 0.5,
    y-grid: true,
    x-grid: false,
    y-tick-step: 0.30,
    y-min:0.15,
    // y-min: -20,
    // y-min:0,
    y-max: 3,
    x-max:5,
    y-mode:"log",
    y-base:2,
  
    x-label:"Epochs",
    y-label:"Eval Loss",
    // legend:"inner-north",
    legend: "inner-north-east",
    {

      plot.add(cxr_epochs,label:[#text(size:6pt)[MIMIC-CXR-JPG-VQA @johnson2019mimiccxrjpglargepubliclyavailable ]],style:style1)
      
      plot.add(pmc_epochs,label:[#text(size:6pt)[PMC-VQA @zhang2024pmcvqavisualinstructiontuning]],style:style2)
      
      plot.add(slake_epochs,label:[#text(size:6pt)[SLAKE @liu2021slakesemanticallylabeledknowledgeenhanceddataset]],style:style3)
      
       plot.annotate({
        content(
          (2.0, 0.98,.2), [#text("Semantic label Questions\n 11 Mtokens",size: 7pt,style: "italic",fill: color3)]
        )
      })

       plot.annotate({
        content(
          (1.75, 0.42,.2), [#text("Short Answer Questions\n 224 Mtokens",size: 7pt,style: "italic",fill: color1)]
        )
      })
      
       plot.annotate({
        content(
          (4.25, 0.215,.2), [#text("MCQ Questions\n 117Mtokens",size: 7pt,style: "italic",fill: color2)]
        )
      })

      // plot.add-hline(0.2,style:(stroke:black))
    })
})
