#import "../callouts.typ": *
#import "../code_blocks/code.typ" : *


= Appendix
- there are lots of prompt techniques we can talk about
- for text based base llms from @li2023llavamedtraininglargelanguageandvision
#figure(prompt1,caption:[]) <prompt_template1>


- to generate caption pairs from @li2023llavamedtraininglargelanguageandvision


#figure(
  prompt2,caption:[]
) <prompt_template2>


- we can show bad examples base text only llms make . 
	

- table for cxcr-jpg
#import "../code_blocks/tables.typ" : cxr_table_conditions_table

#cxr_table_conditions_table

#tasks[
  #todo[Before End of Feb]
  - Major Tasks:
  #line(length: 100% , stroke : (dash:"dotted", thickness:0.5pt))
    - #text(size:13pt)[Writing the sections of the article]
      - Questions from sections
      
  #line(length: 100% , stroke : (dash:"loosely-dotted", thickness:0.5pt))
        - data mix
          - medpix efficiently encodes medical content into 2 modalities and doctor notes (help generating questions) and has reasoning . which makes it great to anneal and generate questions.cxr jpg has high volume in both images and dataset; and does extensive label validation . we occasionally also have more than 1 viewpos of the subject . The questions are although open ended answers are not long. but cover a lot of attribute such as verify , identify , choose (mcq).
          - But Roco has fuzzy labels [roco limitation section].
            - we can cite Pubmedclip. But PMC-vqa(15M) does not cite roco.
          #comment[roco pipeline limitation]
            
  #line(length: 100% , stroke : (dash:"loosely-dotted", thickness:0.5pt))
        - Synthetic Data generation 
          - LLava med and PMC vqa used chatgpt to generate question answer pairs. I used Llama3.1
          - Mostly Because Chatgpt must have also been pretrained on medical content . But that is not disclosed.And we know llama has not been extensively pretrained on medical content.
          - I wanted to use only publically available for free (models, dataset) so that individual researchers could reproduce. But our method does not scale well. cant make filter enough data to anneal cxr.
          - How do i say that while generating open ended questions from llama aim for small generations as llama has not been pretrained on medical content.
          #comment[pmc vqa uses chatgpt but still has to do manual validation ; although they dont say how they do manual validation. so we dont necessarily have to describe our procedure in too much detail]
          
  #line(length: 100% , stroke : (dash:"loosely-dotted", thickness:0.5pt))
        - scaling law
          - better to anneal then to perform scaling law on smaller datasets [llama]
            - our results corroborate with the above but,
            - how do i present this without contradicting medpix abstract section.
            #comment[we will only cite annealing]
            
          - We evaluated test loss for ROCO and roco+medpix with sufficient compute and parameter size.
          - But we do not have enough compute for cxr jpg.
            - if i try to continue training . i will also have to save optimizer states . But that i wont be able to keep in persistant folder (risky!).
            #comment[this goes into our limitation]
            
  #line(length: 100% , stroke : (dash:"dotted", thickness:0.5pt))
  - Minor Tasks:
    - Readme github with images
    - tool as a submodule in main repository
    - Second Examiner #comment[no second examiner]
]

#let bone1_generation = [Yes, there is a visible fracture in the image. The fracture is a crack in the bone, which is a result of the impact or force that caused the bone to break. The broken bone is visible as a jagged edge on the side of the metal object, which is a bone fragment.]



#let bone1_saliency_figure = grid(columns: 3,
figure(image("../../our_images/saliency/bone1.jpg"),caption:[]),

grid(rows: 2, columns: 2,
figure(image("../../our_images/saliency/bone1_patch.png"),caption:[]),
rect[saliency text],

figure(image("../../our_images/saliency/bone1_raw.png"),caption:[]),
rect[head number , layer number]
)
)

#bone1_saliency_figure

