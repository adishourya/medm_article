#import "@preview/plotst:0.2.0" :*
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

#let roco_count_axis = axis(min:0,max:2000,step:500, location: "bottom", title:"Counts",helper_lines: true)

// Combine the axes and the data and feed it to the plot render function.
#let roco_plot = plot(axes: (roco_count_axis, roco_label_axis), data: roco_data)


// slake dataset
#let slake_data = (
  (4760, "Chest"),
  (4340, "Abdomen"),
  (3220, "Head"),
  (840, "Pelvic"),
  (840, "Neck"),
)

// Create the necessary axes
#let slake_label_axis = axis(
  values: ("","Chest", "Abdomen", "Head", "Pelvic", "Neck"),
  location: "left",
  show_markings: true,
)

#let slake_count_axis = axis(
  min: 0,
  max: 5000,
  step: 1000,
  location: "bottom",
  title: "Counts",
  helper_lines: true,
)

// Combine the axes and the data and feed it to the plot render function.
#let slake_plot = plot(
  axes: (slake_count_axis, slake_label_axis),
  data:(slake_data)
)



// cxr table


// cxr table
#let mimic_data = (
  (87272, "Pleural Effusion"),
  (79069, "No Finding"),
  (70634, "Support Devices"),
  (65833, "Edema"),
  (59185, "Pneumonia"),
  (58425, "Lung Opacity"),
  (5831, "Fracture"),
  (53848, "Pneumothorax"),
  (57666, "Atelectasis"),
  (66802, "Cardiomegaly"),
  (23076, "Consolidation"),
  (21837, "Enlarged Cardiomediastinum"),
  (8287, "Lung Lesion"),
  (2902, "Pleural Other")
)

// Create the necessary axes

#let mimic_label_axis = axis(
  values: ("", "Pleural Effusion","No Finding", "Support Devices", "Edema", "Pneumonia", "Lung Opacity", "Pneumothorax", "Atelectasis", "Cardiomegaly", "Consolidation", "Enlarged Cardiomediastinum", "Lung Lesion", "Fracture","Pleural Other"),
  location: "left",
  show_markings: true,
)

#let mimic_count_axis = axis(min: 0, max: 90000, step: 25000, location: "bottom", title: "Counts", helper_lines: true)

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

#let pmc_count_axis = axis(min: 0, max: 5000, step: 1000, location: "bottom", title: "Counts", helper_lines: true)

// Combine the axes and the data and feed it to the plot render function
#let pmc_plot = plot(axes: (pmc_count_axis, pmc_label_axis), data: pmc_data)


// medpix table
#let medpix_data = (
  (631, "Brain and Neuro"),
  (270, "Musculoskeletal"),
  (200, "Gastrointestinal"),
  (222, "Chest, Pulmonary"),
  (151, "Genitourinary"),
  (93, "Head and Neck"),
  (85, "Spine"),
  (73, "Vascular"),
  (65, "Cardiovascular"),
  (56, "Eye and Orbit"),
  (66, "Generalized"),
  (47, "Abdomen"),
  (39, "Others"),
)

// Create the necessary axes
#let medpix_label_axis = axis(
  values: ("", "Brain and Neuro", "Musculoskeletal", "Gastrointestinal", "Chest, Pulmonary", "Genitourinary", "Head and Neck", "Spine", "Vascular", "Cardiovascular", "Eye and Orbit", "Generalized", "Abdomen", "Others"),
  location: "left",
  show_markings: true,
)

#let medpix_count_axis = axis(min: 0, max: 700, step: 200, location: "bottom", title: "Counts", helper_lines: true)

// Generate the plot
#let medpix_plot = plot(axes: (medpix_count_axis, medpix_label_axis), data: medpix_data)




// Render the bar chart


#grid(
  columns: 3,
bar_chart(roco_plot, (100%, 25%), fill: my_colors.accent4, bar_width: 70%, rotated: true,caption:[ROCO v2.0 @pelka2018roco contains 82K QA pairs]),

bar_chart(slake_plot, (100%, 25%), fill: my_colors.accent3, bar_width: 70%, rotated: true,caption:[ SLAKE @liu2021slakesemanticallylabeledknowledgeenhanceddataset contains 614 images , total:14K QA pairs]),

bar_chart(pmc_plot, (100%, 25%), fill: my_colors.accent10, bar_width: 70%, rotated: true,caption:[PMC-VQA @zhang2024pmcvqavisualinstructiontuning 's Rough Distribution of the answer labels]),

)

