#let mcq_llama = [
```py
def generate_qapairs(caption):
  # Construct the prompt for ollama for mcq based questions
  prompt = f"""
  Based on the following medical image captions generate appropriate and insightful question for the caption. Treat this caption as the ground truth to generate your question: {caption}
  """
  response = ollama.chat(model='llama3.1',
      messages=[ {
          'role': 'user',
          'content': prompt } ])
  
  # Return the generated text from the response
  return response['message']['content'].strip()

```
]

#let prompt1 = [
 
```py
prompt =f """
You are provided with a text description (Figure Caption) of a figure image from a biomedical
research paper. In some cases, you may have additional text (Figure Context) that mentions
the image. Unfortunately, you don’t have access to the actual image.
Below are requirements for generating the questions and answers in the conversation:
- Avoid quoting or referring to specific facts, terms, abbreviations, dates, numbers, or names, as these may reveal the conversation is based on the text information, rather than the image itself. Focus on the visual aspects of the image that can be inferred without the text information.
- Do not use phrases like "mentioned", "caption", "context" in the conversation. Instead, refer to the information as being "in the image."
- Ensure that questions are diverse and cover a range of visual aspects of the image.
- The conversation should include at least 2-3 turns of questions and answers about the visual aspects of the image.
- Answer responsibly, avoiding overconfidence, and do not provide medical advice or diagnostic information. Encourage the user to consult a healthcare professional for advice.
""" 

``` 
]

#let prompt2 = [
 
```py
# for brief descriptions
brief_prompt = np.random.choice([
	"Describe the image concisely.",
	"Provide a brief description of the given image.",
	"Offer a succinct explanation of the picture presented.",
	"Summarize the visual content of the image.",
	"Give a short and clear explanation of the subsequent image.",
	"Share a concise interpretation of the image provided.",
	"Present a compact description of the photo’s key features.",
	"Relay a brief, clear account of the picture shown.",
	"Render a clear and concise summary of the photo.",
	"Write a terse but informative summary of the picture.",
	"Create a compact narrative representing the image presented."  
])
# for detailed prompts
detailed_prompts = np.random.choice([
"Describe the following image in detail",
"Provide a detailed description of the given image",
"Give an elaborate explanation of the image you see",
"Share a comprehensive rundown of the presented image",
"Offer a thorough analysis of the image",
"Explain the various aspects of the image before you",
"Clarify the contents of the displayed image with great detail",
"Characterize the image using a well-detailed description",
"Break down the elements of the image in a detailed manner",
"Walk through the important details of the image",
"Portray the image with a rich, descriptive narrative",
"Narrate the contents of the image with precision",
"Analyze the image in a comprehensive and detailed manner",
"Illustrate the image through a descriptive explanation",
"Examine the image closely and share its details",
"Write an exhaustive depiction of the given image"
])
``` 
]