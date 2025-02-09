#import "@preview/plotst:0.2.0":*
#import "../src/template.typ": my_colors

#set text(size: 6pt)

#let roco_data = (
  (1779, "Fluid"),
  (1705, "Nepoplasm"),
  (1469, "Cystic"),
  (1288, "Heart"),
  (1084, "Pathalogical Distillation"),
  (1288, "Entire Body"),
  (1288, "Brain"),
  (1288, "Pleural effusion disorder"),
  (1288, "Nodule"),
)

// Create the necessary axes
#let roco_label_axis = axis(
  values: ("", "Fluid", "Nepoplasm", "Cystic", "Heart", "Pathalogical Distillation", "Entire Body", "Brain", "Pleural effusion disorder", "Nodule"),
  location: "left",
  // title:"pathologies",
  show_markings: true,
)

#let roco_count_axis = axis(min:0,max:2000,step:500, location: "bottom", title:"count",helper_lines: true)

// Combine the axes and the data and feed it to the plot render function.
#let roco_plot = plot(axes: (roco_count_axis, roco_label_axis), data: roco_data)

// cxr table
#let mimic_data = (
  (57666, "Atelectasis"),
  (66802, "Cardiomegaly"),
  (23076, "Consolidation"),
  (65833, "Edema"),
  (21837, "Enlarged Cardiomediastinum"),
  (5831, "Fracture"),
  (8287, "Lung Lesion"),
  (58425, "Lung Opacity"),
  (79069, "No Finding"),
  (87272, "Pleural Effusion"),
  (2902, "Pleural Other"),
  (59185, "Pneumonia"),
  (53848, "Pneumothorax"),
  (70634, "Support Devices"),
)

// Create the necessary axes
#let mimic_label_axis = axis(
  values: ("", "Atelectasis", "Cardiomegaly", "Consolidation", "Edema", "Enlarged Cardiomediastinum", "Fracture", "Lung Lesion", "Lung Opacity", "No Finding", "Pleural Effusion", "Pleural Other", "Pneumonia", "Pneumothorax", "Support Devices"),
  location: "left",
  show_markings: true,
)

#let mimic_count_axis = axis(min: 0, max: 90000, step: 25000, location: "bottom", title: "Total Counts", helper_lines: true)

// Combine the axes and the data and feed it to the plot render function
#let mimic_plot = plot(axes: (mimic_count_axis, mimic_label_axis), data: mimic_data)

// PMC-VQA Data
#let pmc_data = (
  (4036, "MRI"),
  (3158, "CT scan"),
  (2415, "X-ray"),
  (690, "Ultrasound"),
  (590, "Abdomen"),
  (456, "Chest"),
  (328, "Brain"),
  (298, "Liver"),
  (298, "Head"),
  (253, "PET scan"),
  (784, "Others"),
)

// Create the necessary axes
#let pmc_label_axis = axis(
  values: ("", "MRI", "CT scan", "X-ray", "Ultrasound", "Abdomen", "Chest", "Brain", "Liver", "Head", "PET scan", "Others"),
  location: "left",
  show_markings: true,
)

#let pmc_count_axis = axis(min: 0, max: 5000, step: 1000, location: "bottom", title: "Total Counts", helper_lines: true)

// Combine the axes and the data and feed it to the plot render function
#let pmc_plot = plot(axes: (pmc_count_axis, pmc_label_axis), data: pmc_data)




// Render the bar chart


#grid(
  columns: 3,
bar_chart(roco_plot, (100%, 25%), fill: my_colors.accent4, bar_width: 70%, rotated: true,caption:[roco bar]),

bar_chart(mimic_plot, (100%, 25%), fill: my_colors.accent3, bar_width: 70%, rotated: true,caption:[mimic_plot]),

bar_chart(pmc_plot, (100%, 25%), fill: my_colors.accent10, bar_width: 70%, rotated: true,caption:[mimic_plot]),

)

