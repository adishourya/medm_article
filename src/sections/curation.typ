 physionet download speed#import "../callouts.typ": * 


== Data Curation <section_curation>
#plan[
	+ instruct dataset 1 to gain conceptual understanding like cc12m @changpinyo2021cc12m
	+ Task specific instruct dataset 2 like roco @pelka2018roco
	+ Popular tempelates for generating questions
	+ as base models are usually not pretrained on medical corpus.questions generated with base models usually give away the main subject of the answers.
	+ make arguments on being careful while prompting. and why currently we can only have shorter length questions when curating open ended questions as they give away the subject of the answers often.
	#todo[add examples]
	
]
#lorem(200)

#oasis-align(
  // align:right
figure(
  [```py
		def generate_mcq_with_ollama(caption):
		# Construct the prompt for ollama for mcq based questions
		prompt = f"""
		Ask 5 questions about the content and generate four options for each question. The questions should be answerable with the information provided in the caption, and the four options should include one correct and three incorrect options, with the position of the correct option randomized. The output should use the following template: i:‘the question index’ question:‘the generate question’ choice: ‘A:option content B:option content C:option content D:option content’ answer: The correct option(A\B\C\D).
		"""

		response = ollama.chat(model='llama3.1', messages=[
				{
						'role': 'user',
						'content': prompt
				}
		])

		# Return the generated text from the response
		return response['message']['content'].strip()

	
		```],caption: []),
  [#lorem(200)],
)


#lorem(100)

#tip[
	- #lorem(10)
	- #lorem(10)
	- #lorem(10)
	- #lorem(10)
]

//-------------------



== Determining the Data Mix
#plan[
	// #comment[this is wrong]
	+ show that it only works when enough diversity in the training sample
	+ treemap of the dataset.
	+ (did not work with medpix @siragusa2024medpix20comprehensivemultimodal alone)
	#todo[adjust depth of treemaps... depth 2 should be readable]

]
#lorem(200)

#wrap-content(figure(
    image("../our_images/data/treemap_medpix.png",width: 250pt),
    // rect(width: 250pt,height: 250pt),
    caption:[Labeled])
,[#lorem(300)])

#wrap-content(align:right,
  figure(    image("../our_images/data/treemap_medpix.png",width: 200pt),
    // rect(width: 250pt,height: 250pt),
    caption:[Labeled])
,[#lorem(300)])





//-------------------


== Annealing with In-house High-quality Data
#plan[
+ Mixing Medpix low vol / High Quality or self hosted finetuning db
]
#lorem(100)
