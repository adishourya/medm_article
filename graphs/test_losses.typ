#import "@preview/cetz:0.3.1": canvas, draw
#import "@preview/cetz-plot:0.1.0": plot
#import "../src/callouts.typ":*

#set text(size:8pt)

#let plot_colors = color.map.viridis
#let color1 = plot_colors.at(0)
#let color2 = plot_colors.at(3)
#let color3 = plot_colors.at(5)
#let style1 = (stroke:(paint: color1,dash:"dashed", thickness: 1pt, cap: "round"))
#let style2 = (stroke:(paint: color2, thickness: 1pt, cap: "round"))
#let style3 = (stroke:(paint: color3, thickness: 1pt, cap: "round"))
// #let style1 = (stroke:1pt+color1)
// #let style2 = (stroke:1pt+color2)
// #let style3 = (stroke:1pt+color3)



// #let legend_color = gradient.linear(..color.map.viridis)
#let legend_color = black


// #let medpix_eval = (
//   (0,4.3),
//   (1, 2.6276),
//   (2, 2.4716),
//   (3, 2.4070),
//   (4, 2.3871),
//   (5, 2.3929),
//   (6, 2.4194),
//   (7, 2.4726),
//   (8, 2.5062),   
//   (9, 2.5492),
//   (10, 2.6080),
// );

#let medpix_eval = (
  (0,4.3),
  (1, 2.6276),
  (2, 2.4716),
  (3, 2.4070),
  (4, 2.3871),
  (5, 2.3929),
  // (6, 2.4194),
  // (7, 2.4726),
  // (8, 2.5062),   
  // (9, 2.5492),
  // (10, 2.6080),
);


// roco evaluation
#let roco_eval = (
  (0,4.3),
  (1, 2.1582),
  (2, 2.0904),
  (3, 2.0631),
  (4, 2.0488),
  (5, 2.0409),
  (6, 2.0344),
  (7, 2.0336),
  (8, 2.0353),   
  (9, 2.0369),
  (10, 2.0471) 
);

// // roco evaluation
// #let roco_eval = (
//   (0,4.3),
//   (1, 2.1582),
//   (2, 2.0904),
//   (3, 2.0631),
//   (4, 2.0488),
//   (5, 2.0409),
//   (6, 2.0344),
//   (7, 2.0336),
//   // (8, 2.0353),   
//   // (9, 2.0369),
//   // (10, 2.0471) 
// );

#let roco_medpix_anneal = (
  (0,4.3),
  (1, 2.0539),
  (2, 1.9498),
  (3, 1.8831),
  (4, 1.8628),
  (5, 1.8501),
  (6, 1.8481),
  (7, 1.8476),
  (8, 1.8379),   
  (9, 1.8272),
  (10, 1.8381) 
);



// SELECT 
//     SUM(array_length(string_split(question, ' '))) AS total_question_words,
//     SUM(array_length(string_split(answer, ' '))) AS total_answer_words
// FROM train;


#let tokens_roco = calc.round( ((65.4 * 1000 * (448/16) * (448/16) ) + 1981921 + 735751)/ 1000000)

#let tokens_medpix = calc.round(tokens_roco/2.35)


#canvas({
   draw.set-style(legend:())
  import draw: *

  // Set-up a thin axis style
  set-style(axes: (stroke: 0pt, tick: (stroke: 0pt)),
            legend: (stroke: 0.1pt+legend_color, orientation: ttb, item: (spacing: 0.1), scale: 100%))

  plot.plot(size:(7,8),
    // axis-style:"school-book",
    x-tick-step: 1,
    y-grid: true,
    x-grid: false,
    y-tick-step: 0.15, 
    y-min: 1.5, y-max: 5,
    y-mode:"log",
    y-base:2,
  
    x-label:"Epochs",
    y-label:"Eval Loss",
    legend: "inner-north-east",
    // legend:"inner-north",
    // set-origin((0,0)),
    // legend:"north",
    {

      plot.add(medpix_eval,label:[#text(size:6pt)[Medpix v2.0 @siragusa2024medpix20comprehensivemultimodal]],style:style1)
      
      plot.add(roco_eval,label:[#text(size:6pt)[ROCO v2.0 @pelka2018roco]],style:style2)
      
      plot.add(roco_medpix_anneal,label:[#text(size:6pt)[{ROCO+Medpix} v2.0 Annealed]],style:style3)

      plot.annotate({
        content(
          (8.5, 1.55,.2), [#text("sufficient compute",size: 7pt,style: "italic",fill: black)]
        )
      })
      
      plot.annotate({
        content(
          (7.5, 1.9), [
            #text([#tokens_roco Mtokens] ,size: 7pt,style: "italic",fill: color2)
            #text(size:7pt,style: "italic",fill: color3, [ *+ 7 Mtokens*])
          ]
        )
      })
      

      plot.annotate({
        content(
          (6.1, 2.1), [
            #text([#tokens_roco Mtokens] ,size: 7pt,style: "italic",fill: color2)
            // #text(size:7pt,style: "italic",fill: color3, [\+ 7 x$10^6$ \token\s])
          ]
        )
      })

      plot.annotate({
        content(
          (4.5, 2.45), [#text([#tokens_medpix Mtoken\s],size: 7pt,style: "italic",fill: color1)]
        )
      })


      
      
      // plot.add-hline(1.68,style:(stroke:black))
    })
})
