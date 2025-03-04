#import "@preview/plotst:0.2.0": *
#import "../src/template.typ": my_colors

#set text(size: 6pt)

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

#let medpix_count_axis = axis(min: 0, max: 700, step: 200, location: "bottom", title: "Count", helper_lines: true)

// Generate the plot
#let medpix_plot = plot(axes: (medpix_count_axis, medpix_label_axis), data: medpix_data)

// Render the bar chart
#bar_chart(medpix_plot, (250pt, 300pt), fill: (my_colors.accent8,)*5 + (gray.lighten(40%),)*8, bar_width: 70%, rotated: true, caption: [MedPix v2.0 @siragusa2024medpix20comprehensivemultimodal Data count])
