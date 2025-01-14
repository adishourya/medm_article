#set page(width: auto, height: auto, margin: 5mm, fill: white)
#let original = read("../icons/llm.svg")
#let changed = original.replace(
  "#000000", // black
  "#ffffff",
)

#image.decode(original)
#image.decode(changed)



// #changed