// #set page(width: 500pt, height: 200pt)
// #import "@preview/echarm:0.2.0" as echarm

// #echarm.render(width: 100%, height: 100%, options: (
//   series: (
//     (
//       name: "Treemap",
//       type: "treemap",
//       roam: false,
//       label: ("show":true
//       ),
//       itemStyle: (
//         borderColor: "#fff",
//         borderWidth: 1,
//         borderRadius: 2,
//       ),
//       data:(
        
//         (name: "a", value: 80636124,
//       children:(
//         (name:"a1",value:1),
//         (name:"a2",value:2),
//       )
//     ),
        
//         (name: "b", value: 65511098,
//       children:(
//         (name:"b1",value:123),
//         (name:"b2",value:123),
//     )
//     ),
    
//       )
//     )
//   )
// ))

#set page(width: 330pt, height: 500pt)
#import "@preview/echarm:0.2.0" as echarm

#echarm.render(width: 100%, height: 100%, options: (
  series: (
    (
      name: "Treemap",
      type: "treemap",
      roam: false,
      label: ("show": true),
      itemStyle: (
        borderColor: "#fff",
        borderWidth: 1,
        borderRadius: 2,
      ),
      data: (
        (name: "Neural Effusion", value: 58188,
          children: (
            (name: "Positive", value: 50000),
            (name: "Negative", value: 30000)
          )
        ),
        (name: "Cardiomegaly", value: 39094,
          children: (
            (name: "Positive", value: 50000),
            (name: "Negative", value: 30000)
          )
        ),
        (name: "Edema", value: 26455,
          children: (
            (name: "Positive", value: 50000),
            (name: "Negative", value: 30000)
          )
        )
      )
    )
  )
))