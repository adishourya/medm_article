#set page(width: 500pt, height: 300pt)
#set text(size: 2pt)
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
        (name: "Fluid", value: 1779),
        (name: "Neoplasms", value: 1705),
        (name: "Cystic", value: 1469),
        (name: "Heart", value: 1288),
        (name: "Liver", value: 1244),
        (name: "Pathological \nDilatation", value: 1084),
        (name: "Entire \nbony \nskeleton", value: 1077),
        (name: "Brain", value: 1058),
        (name: "Pleural \neffusion\n disorder", value: 1049),
        (name: "Nodule", value: 1032),
      ),
    ),
  ),
))

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
        
//         (name: "a", value: 80636124),
//         (name: "b", value: 65511098)
//     ),
    
      
//     )
//   )
// ))

