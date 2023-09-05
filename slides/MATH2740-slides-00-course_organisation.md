---
marp: true
title: MATH 2740 Mathematics of Data Science - Introduction
description: Presentation of the course
theme: uncover
paginate: false
_paginate: false
---

<!-- theme: default -->
<!-- auto-scaling: true -->


# <!-- fit --> MATH 2740 Mathematics of Data Science

# Some information about the course (Fall 2023)

Julien Arino ([julien.arino@umanitoba.ca](mailto:julien.arino@umanitoba.ca))

Department of Mathematics & Data Science Nexus
University of Manitoba

Canadian Centre for Disease Modelling
NSERC-PHAC EID Modelling Consortium - CANMOD, OMNI/RÉUNIS & MfPH

---

# Foreword

- "Numerical dates" are in the form YYYY-MM-DD (e.g, today is 2022-09-08)
- Times are 24h
- Units are SI

In case you want to know, some of the slides in the course are html5 generated from `markdown` files using [marp](https://marp.app/). Others are pure $\LaTeX$. All (including source code) are available on GitHub [here](https://github.com/julien-arino/math2740-of-data-science)

---

# Getting in touch

- [julien.arino@umanitoba.ca](mailto:julien.arino@umanitoba.ca)

- Please use your `myumanitoba` email address. Use a tag such as `[MATH 2740]` in your subject line, if you want to be read..

- There's an entry in the university address book with a phone for me.. don't bother!

- I am physically present on campus on lecture days and some other days, but **do not** come to see me outside of office hours without an appointment!
    - Office hours: TR 14:00-16:00
- My office hours are for both courses I teach (MATH 2740 and MATH 4370/7370) and might get busy. If things do get busy, I will limit each person to 10 minutes at a time, so come with your questions prepared!

---

# Course website - UMLearn

- All information about the course is posted on UMLearn
- It is your responsibility to check the UMLearn site regularly: all announcements about the course is made there as News items
- (Remember to hit the link at the top of the page that says *MATH-2740-A01 - Mathematics of Data Science*, sometimes UMLearn takes you directly to Content, which is not where the announcements are)

---

# Lectures

- TR 11:30-12:45 in 204 Armes

- Videos for the course as I taught it in 2021 are available on as a [YouTube playlist](https://www.youtube.com/playlist?list=PLfRaznSpWo2vQAn1jVyueTuAiryDaxkH3). There is no guarantee that that the content will be the same this year, but there will be commonalities for sure

---

# Tutorials

- It is strongly recommended to attend tutorials, as this is where you will review some of the mathematical content

- Tutorials are as follows

| Section | Day and time | Location |
|---------|--------------|----------|
| B01 | W 8:30-9:20 | 114 St John's College |
| B02 | W 9:30-10:20 | 315 Buller |
| B03 | W 11:30-12:20 | 315 Buller |

---

# Evaluation through assignments only
- Evaluation is through assignments only (no tests, no final examination!)
- One assignment per week (posted Friday at 12:00, due the following Friday at 12:00, except Friday before reading week, which is due the Friday after reading week)
- Assignments will be mathematical OR (not XOR) computational. If both, (assignment complete $\iff$ **both** parts are handed back)
- The mark will consist of the average of the marks on the **best 10** assignments
- In the mathematical part, it is possible that not all questions will be marked. If you do not submit an answer to a question that is marked, you will receive **zero** for that question
- There will be **no** tolerance for late assignments and there will not be any make-up for missed assignments: any assignment not returned by the deadline will result in a mark of **zero**

---

# Self-declaration of absences

- You can self-declare an absence of less than 120 hours (5 days) instead of providing a doctor's note
- If a self-declared absence overlaps with the due date and time of Friday at 12:00
    - send me [the form](https://umanitoba.ca/sites/default/files/2022-09/Self%20Declaration%20Fillable%20Form-%20FINAL%20for%20Website.pdf) and submit the [simplified form](https://forms.office.com/r/HSXE50PefN) **prior** to the deadline
    - I will modify *your* deadline for *that* assignment so you can still submit on time
- **I will not accept self-declarations after the deadline**: if at 12:00 Friday, I have not received a self-declaration form XOR the assignment, you get a mark of zero on that assignment
- Self-declarations are intended for very occasional and unforeseen circumstances $\implies$ I **will not accept more than two** during the term 

---

# Computer work

- Being able to use computers is an integral part of being a data scientist, so in this course, we use computers a lot
- The two main languages in data science are `R` and `Python`. Typically, `R` is used more by people in Stats, while `Python` is more CS
- There is great value in both and knowing both is a plus, but for simplicity, here we use `R`. Computer assignments will need to be handed back in `R` (Python $\Rightarrow$ 0)

---

# Returning assignments

- Mathematical part of the assignment goes to Crowdmark
    - Ensure legibility
    - Answer questions in order
- Computer part of the assignment goes to UMLearn
    - `R` language only (Python $\Rightarrow$ 0)
    - Needs to be a jupyter notebook (.ipynb) or an RMarkdown file (.Rmd)
    - Single file
    - Can submit several times but only the latest file will be used
- In both cases, explain what you are doing. Math or code without explanation will lose marks
- If an assignment has both a mathematical and a computer part, the assignment is complete if and only if both parts are handed back. Incomplete assignment $\Rightarrow$ 0

---

# Academic dishonesty

- Feel free to discuss work with others, but solutions must be your own !
- Markers will be on the lookout for this
- Paraphrasing my computer code = academic dishonesty !
- [stack overflow](https://stackoverflow.com/) is a fantastic resource but if you use a solution from there, cite it (in a notebook, that's easy)

---

# Jupyter notebooks on [syzygy.ca](https://syzygy.ca)

- To facilitate computer work, we will use `R` within `jupyter` notebooks on [syzygy.ca](https://syzygy.ca) 
- I will provide a whole lecture on using jupyter notebooks and [syzygy.ca](https://syzygy.ca), for now just know that this is a development environment that runs on the web and to which you have access as U of M students
- I am also allowing the return of computer assignments as RMarkdown (Rmd) files. The lecture on jupyter will also cover this
- There is a page on UMLearn on how to connect to [syzygy.ca](https://syzygy.ca), how to install `R` or jupyter notebooks on your computer