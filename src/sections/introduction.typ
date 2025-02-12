#import "../callouts.typ":* 
= Introduction #icon("tick") <section_introduction>

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

#comment[The current introduction is ok but we need a better flow - start with background and problem statements and then what the research challenges are, why they are still challenges (the research gaps), why the research challenges are significant, then what we propose to solve it (if possible, also indicate why/how our approaches are different from the previous work. Then a paragraph about the main contributions of this work, and paper structure. )]

#coherence[
  - formally present instruct models before referring to it.
]
