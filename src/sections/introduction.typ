#import "../callouts.typ":* 
= Introduction <section_introduction>


#plan[
- #comment[example comment]
- #todo[example todo]

+ quick introduction to llms and how llms (AI) are used in medical domain.

+ cite(phi4, paligemma) smaller models (SLMs) continue to get better from advancements, including the use of curation of high-quality organic data, and post-training innovations. . cite(paligemma) s trained to be a versatile and broadly knowledgeable base model that is effective to transfer. It achieves strong performance on a wide variety of open-world tasks as much as 40 .SLMS continues to push the frontier of size vs quality

+ This with other advancements (cite examples mixed precision training , lora finetuning , quantized inference) has allowed individual researchers to finetune and to run models on lesser demanding hardwares.

+ recent improvement (briefly mention how models are getting smaller for the better) in performance in general domain does not always reflect in medical llms (inflated interest)

+ challenges : cost of labeling; parallel image caption medical data (compare to cc12m and sometimes good chunk of the internet) and intrinsic difficulties in representation learning in challenging medical imagery
+ advent of multi-modality was really beneficial in medical AI as is its hard to encode all context in just 1 modality . @ryai_2019180031
+ Current Instruction tuned models does well on zero shot on unseen tasks (give examples) but not really in medical domain.But these models are highly transferable (quote paligemma and others)
+ Cemented position of ai as inferior to clinicians.
+ bar for medical is higher than others not just for accuracy but also in privacy and mitigating bias (mention most publically available datasets caution against deployment).Alignment is an active area of research
+ Carefully designing metrics and consensus axis for evaluation. (briefly mention standard nlp-metrics is ill conditioned.) 


]

In recent years, significant advancements have been made in adapting Large Language Models (*LLMs*), which have already proven quite successful in general-purpose tasks, to specialized medical domains. Efforts by individual researchers @photomzroco2023 @vansonsbeek2023openendedmedicalvisualquestion and major organizations have resulted in notable models, such as Med-PaLM @Singhal2023, a text-based medical expert capable of answering both consumer and professional medical questions, and LLaVA-Med @li2023llavamedtraininglargelanguageandvision, a Large Vision-Language Model (*LVLM*) that can process open-ended queries involving biomedical images.

In addition to these advancements, there has been significant progress in improving model performance, consistency, and accessibility. This has enabled individual researchers to perform not just inference but also to fine-tune models for cheap.These, along with other advancements, continue to bring attention back to  Medical LLMs. However, much of this interest is possibly inflated.As most of the publically available instruction tuned models are trained on datasets that lack sufficient medical content. //The instruct models are often trained on high-quality organic datasets with vast data volumes, which sometimes is even a good chunk of the internet, while being diverse,they lack sufficient medical content.
Although post-training innovations have enabled these models to perform well on a range of downstream tasks, they still struggle when applied to the specialized and complex demands of medical AI.

One of the primary reasons for this gap is the significant cost associated with generating labeled medical datasets, along with the complexities involved in encoding medical data, and the inherent challenges of recognizing intricate patterns in healthcare contexts which sometimes even leads to disagreement amongst clinicians. As a result, many generalist models fall short when applied to specialized medical tasks, as they lack the domain-specific expertise and alignment #comment[alignment/sensitivity?] required to handle the nuanced nature of medical data.


The advent of multimodal models has partially addressed the latter part of the
challenge, allowing the integration of multimodal datasets without
constraining labelers to encode medical records into a single modality. 
While parallel high-quality image-caption pairs are readily available in large volumes for general domains @changpinyo2021cc12m, @sharma2018conceptual, such resources are scarce in the medical domain, further limiting the application of multimodal approaches in healthcare.


To improve upon generalist models,we turn to fine-tuning modern instruct models with a sufficiently narrow focus, offering the potential for more promising results. Besides demanding large, high-quality datasets Medical AI also needs robust safeguards against model biases. Models trained on biased data could lead to harmful decision-making, particularly if deployed for public use. Mitigating Biases remains an active area of research, with many public datasets cautioning against the deployment of models trained solely on their data.

Despite these hurdles, the potential of medical AI continues to inspire
progress. While its practical usage in clinical settings remains limited,
researchers and practitioners strive to push the boundaries of what is
achievable, carefully refining the technology and exploring their upper bound with each iteration.

#coherence[
  - formally present instruct models before referring to it.
]
