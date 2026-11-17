---
trigger: model_decision
description: "Rules for creating and editing tests, practice exams and exams"
---

# Tests and exams

- **Exams draw from practice exams**: Every exam must strictly use a subset of the questions from the corresponding practice exam(s). Do not write new questions from scratch for an exam unless explicitly instructed otherwise.
- **Ask how many questions to include**: Before assembling or generating an exam, always ask the user how many questions from the corresponding practice exam(s) should be used (unless the number was already specified).
- **Course and proof questions**: Always check that any proof or course questions (definitions, theorems, propositions, algorithms) are marked as `importantdefinition`, `importanttheorem`, `importantproposition`, `importantproof` (or similar `important*` environments) in the lecture notes, or (for proofs) as `[importantcolour]` in the slides.
