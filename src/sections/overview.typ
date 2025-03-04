#import "../callouts.typ":* 

= Overview <section_overview>
#plan[
- #comment[we will write this at the end!]

- SOTA models get somewhere around 67.6% accuracy on MedQA (US Medical Licensing Exam-style questions) which is considerably inferior to clinicians.And we suspect clinicians would be better at intricate questions at least for few more years.

- medpalm 2022: ablation study :
#quote[
Firstly, we observed strong scaling performance with accuracy improving by approximately 2x as we scale the PaLM models from 8-billion to 540-billion. The performance of the PaLM 8-billion on MedQA was only slightly better than random performance
] -2022

then llava med made state of the art vqa model with 8b model only a year later.
so such kind of ablation studies in llms usally expire much quickly.


- and vision language model is deemed an even harder task.

- summarize the flow of the document and the need for the sections
- whats not the focus of our document:

  - improving or getting comparable results compared to the state of the art vision question answering model.
  
  - not to make the best dataset but demonstrate common practices and perform ablation with and without.

  - To demonstrate this in an open source small research group friendly way.
  
- we focus on (Key Contribution) :
  - Performing VQA on radiological question answering on small models but highly versatile model.
  - Develop a diagnostic tool with saliency analysis in mind to examine model's capabilities and limitation.#footnote[A fork of @stan2024lvlminterpretinterpretabilitytoollarge]
  - Lay a framework for future studies to perform quick ablation studies.

]



// #text(fill:white.darken(40%), lorem(400))

#let study = [

Our methodology builds upon recent advancements in medical visual and text-based question-answering, drawing insights from prior work in dataset curation, fine-tuning strategies, and evaluation frameworks. Several studies have introduced comprehensive pipelines that span data collection, model training, and rigorous assessment, highlighting the evolving capabilities of large language and vision-language models in the medical domain. Below, we summarize key contributions from related works that have informed our approach.

  - *MedVInT-T(D,E) @zhang2024pmcvqavisualinstructiontuning :* presents a complete pipeline for medical visual question-answering , starting from data curation to model fine-tuning and evaluation design. Their approach involves finetuning a VLM Model on a self curated dataset @xmcmic_pmc_vqa which contains multiple-choice style questions to cover variety of radioloical images and short fill in the blank style questions with the expectations to develop ability of also answering open ended queries. The model, fine-tuned on public benchmarks performs on par with existing MedVQA systems. Additionally, they manually verify a sample of test set results to make the models robust from current limitations of popular evaluation framework. A limitation we discuss in more detail in @section_evaluation.

  - *Medpalm @Singhal2023 :* like @zhang2024pmcvqavisualinstructiontuning, introduces a comprehensive framework from scratch. They curate a new dataset, HealthSearchQA sampling from existing medical QA datasets to cover both professional and consumer medical queries. They then fine-tune Flan-PaLM @flan_palm on this dataset, achieving a new state-of-the-art model evaluated by both professional and layman on an extensive set of evaluation and alignment axes.
  
  
  - *LLava-Med @li2023llavamedtraininglargelanguageandvision* :curates its own dataset from PubMed Central @pubmedcentral  and, unlike previous approaches, prepares few-shot instruction training data using GPT-4 @OpenAI_ChatGPT and performs multi stage finetuning with a *cost-effective* approach to achieve state-of-the-art performance in medical visual question answering, demonstrating strong multimodal understanding and instruction-following capabilities.

   // The model is fine-tuned efficiently with a cost-effective and rapid training strategy.
  
]

== Related Study
// #glorem(num:300)
#study



== Key Contributions
With our article we aim at building upon prior work in medical Visual question-answering, providing the following key contributions:

+ *Reassessing Model Scaling Trends*: @Singhal2023 demonstrated that scaling PaLM @flan_palm models from 8B to 540B led to nearly a twofold accuracy improvement. However, their 8B model performed only slightly better than random perfomance on their benchmarking dataset. But, More recently, @li2023llavamedtraininglargelanguageandvision achieved state-of-the-art results with just 8B parameters, showing that smaller models can now exhibit strong reasoning capabilities. To examine the longevity of such scaling-based ablation studies, we evaluate performance on an even smaller 2.8B LLM @gemmateam2024gemma2improvingopen based model with @beyer2024paligemma.

+ *Comprehensive Framework*: Like previous studies, we develop a complete pipeline covering data curation, fine-tuning, evaluation, and diagnostics. Additionally, we highlight common pitfalls at each stage of model training and assessment.

+ *Diagnostic Tool for Model Evaluation*:For human evaluation stage, we draw inspiration from @stan2024lvlminterpretinterpretabilitytoollarge, and present a ready-to-use diagnostic tool with saliency analysis to help assess model capabilities and limitations. We believe that this tool can serve as a supplementary aid for practicing radiologists during evaluation.

// == Section Overview
// #glorem(num:50)
