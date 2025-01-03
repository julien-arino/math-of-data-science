---
marp: true
title: MATH 2740 Mathematics of Data Science - Introduction
description: Presentation of the course and setting up R
theme: uncover
paginate: false
_paginate: false
---

<!-- theme: default -->
<!-- auto-scaling: true -->

![bg opacity:0.2](FIGS_slides/Gemini_Generated_Image_pqj7q8pqj7q8pqj7.jpeg)

# <!-- fit --> MATH 2740 Mathematics of Data Science

# Some information about the course (Fall 2024)

Julien Arino ([julien.arino@umanitoba.ca](mailto:julien.arino@umanitoba.ca))

Department of Mathematics
University of Manitoba

---

# Foreword

- "Numerical dates" are in the form YYYY-MM-DD (e.g, today is 2024-09-05)
- Times are 24h (HHMM)
- Units are SI

In case you want to know, some of the slides in the course are html5 generated from `markdown` files using [marp](https://marp.app/). Others are pure $\LaTeX$. All (including source code) are available on GitHub [here](https://github.com/julien-arino/math2740-of-data-science)

---

# Getting in touch

- [julien.arino@umanitoba.ca](mailto:julien.arino@umanitoba.ca)

- Please use your `myumanitoba` email address. Use a tag such as `[MATH 2740]` in your subject line, if you want to be read..

- There's an entry in the university address book with a phone for me.. don't bother: we don't have office phones anymore! (It will just take several years for this to be reflected in the address book)

---

# Office hours

- Because of the ongoing renovation of Machray Hall, I am sharing an office with 8 other colleagues. Next door are offices shared by another 8 and 4 colleagues

- It is therefore not possible for me to see you in my office

- I have booked 236 St Paul's College from 1600 to 1700 on Tuesday and Thursday for office hours

---

# Course website - UMLearn

- All information about the course is posted on UMLearn

- It is **your responsibility** to check the UMLearn site regularly: *Announcements* is how I normally communicate with you about the course

- (Remember to hit the link at the top of the page that says *MATH-2740-A01 - Mathematics of Data Science*, sometimes UMLearn takes you directly to Content, which is not where Announcements are)

---

# Lectures

- TR 1130-1245 in 204 Armes

- Videos for the course as I taught it in 2021 are available on as a [YouTube playlist](https://www.youtube.com/playlist?list=PLfRaznSpWo2vQAn1jVyueTuAiryDaxkH3). There is no guarantee that that the content will be the same this year, but there will be commonalities for sure

---

# Tutorials

- It is strongly recommended to attend tutorials, as this is where you will review some of the mathematical content

- Tutorials are as follows

| Section | Day and time | Location |
|---------|--------------|----------|
| B01 | W 0830-0920 | 301 Biological Sciences |
| B02 | W 0930-1020 | 301 Biological Sciences |
| B03 | W 1130-1220 | 301 Biological Sciences |

---

# Evaluation through assignments only
- Evaluation is through assignments only (no tests, no final examination!)
- One assignment per week (posted Friday at 1200, due the following Friday at 1200, except Friday before reading week, which is due the Friday after reading week)
- Assignments will be mathematical OR (not XOR) computational. If both, (assignment complete $\iff$ **both** parts are handed back)
- The mark will consist of the average of the marks on the **best 10** assignments
- In the mathematical part, it is possible that not all questions will be marked. If you do not submit an answer to a question that is marked, you will receive **zero** for that question
- There will be **no** tolerance for late assignments and there will not be any make-up for missed assignments: any assignment not returned by the deadline will result in a mark of **zero**

---

# Self-declaration of absences

- You can self-declare an absence of less than 120 hours (5 days) instead of providing a doctor's note

- If a self-declared absence overlaps with the due date and time of Friday at 1200
    - submit the [form](https://forms.office.com/r/HSXE50PefN) **prior** to the deadline
    - This modifies *your* deadline for *that* assignment

- **I will not accept self-declarations after the deadline**: if at 1200 Friday, I have not received a self-declaration form XOR the assignment, you get a mark of zero on that assignment

- Self-declarations are intended for very occasional and unforeseen circumstances $\implies$ I **will not accept more than two** during the term 

---

# Returning assignments (mathematics part)

- The mathematical part of the assignment goes to Crowdmark
    - Ensure legibility
    - Answer questions in order
    - Correct results without explanation will lose marks!

- Not all questions will be marked
    - the questions that are marked is unknown (to you) until solutions of the assignment are posted
    - If you don't answer a question that is in the list of marked questions, you will receive no marks for that question

---

# Computer work

- Being able to use computers is an integral part of being a data scientist, so in this course, we use computers a lot

- The two main languages in data science are `R` and `Python`. Typically, `R` is used more by people in Stats, while `Python` is more CS

- There is great value in both and knowing both is a plus, but for simplicity, here we use `R`. Computer assignments will need to be handed back in `R` (Python $\Rightarrow$ 0)

---

# CS students, beware! 

- Use Rmarkdown, Sweave or jupyter notebook to generate a **notebook**

- Notebooks mix formatted text and code. They are executable and should be submitted as source, not as pdf or html or whatever. So only files in .Rmd, .Rnw and .ipynb are accepted

- Notebooks are not straight code. Submitting straight R code in a notebook with commented code $\Rightarrow$ 0)

---

# Returning assignments (computer part)

- Computer part of the assignment goes to UMLearn
    - `R` language only (Python $\Rightarrow$ 0)
    - Needs to be a jupyter notebook (.ipynb), a RMarkdown file (.Rmd) or a Sweave (.Rnw) file
    - Single file
    - Can submit several times but only the latest file will be used

- Your code must run! It must also use the "Be friendly to others" method in [these slides](https://julien-arino.github.io/R-for-modellers/SLIDES/vignette-03-installing-using-packages.html#/be-friendly-to-others)


---

# Returning assignments


- In both cases, explain what you are doing. Math or code without explanation will lose marks

- If an assignment has both a mathematical and a computer part, the assignment is complete if and only if both parts are handed back

- Incomplete assignment $\Rightarrow$ 0

---

# Academic dishonesty

- Feel free to discuss work with others, but solutions must be your own!

- Markers will be on the lookout for this

- Paraphrasing my computer code = academic dishonesty !

- [stack overflow](https://stackoverflow.com/) is a fantastic resource but if you use a solution from there, cite it (in a notebook, that's easy)

- ChatGPT, GitHub Copilot, etc. are wonderful tools, but you must use them wisely. Pure unaltered LLM production $\Rightarrow$ AD 

- FYI: my PhD student who is marking your computer code and some of your math has been working with LLMs for quite a while now. Their LLM detection radar is finely tuned

---

# Jupyter notebooks on [syzygy.ca](https://syzygy.ca)

- To facilitate computer work, we will use `R` within `jupyter` notebooks on [syzygy.ca](https://syzygy.ca) 

- I will provide a whole lecture on using jupyter notebooks and [syzygy.ca](https://syzygy.ca), for now just know that this is a development environment that runs on the web and to which you have access as UM students

- I am also allowing the return of computer assignments as RMarkdown (Rmd) files. The lecture on jupyter will also cover this

- There is a page on UMLearn on how to connect to [syzygy.ca](https://syzygy.ca), how to install `R` or jupyter notebooks on your computer

# Setting things up for the course
Julien Arino ([julien.arino@umanitoba.ca](mailto:julien.arino@umanitoba.ca))

Department of Mathematics & Data Science Nexus
University of Manitoba

Canadian Centre for Disease Modelling
NSERC-PHAC EID Modelling Consortium - CANMOD, OMNI/RÉUNIS & MfPH

---

# We will be programming quite a bit

As already indicated, Data Science is a very hands-on discipline. We will be programming quite a bit in this course

Indeed, we can work out some of the examples "by hand", but to make things interesting, we typically need to consider larger examples where hand calculations are not pleasant or not even feasible

---

# R versus Python

Slightly different take on life :smiley:

In short: `Python` is more CS, `R` is more Stats/Math

Both are good languages for data science

In this course, assignments **must** use `R`

---

# R was originally for stats but is now more

- Open source version of S
- Appeared in 1993
- Now version 4.3
- One major advantage in my view: uses a lot of C and Fortran code. E.g., `deSolve`:
> The functions provide an interface to the FORTRAN functions 'lsoda', 'lsodar', 'lsode', 'lsodes' of the 'ODEPACK' collection, to the FORTRAN functions 'dvode', 'zvode' and 'daspk' and a C-implementation of solvers of the 'Runge-Kutta' family with fixed or variable time steps
- Very active community on the web, easy to find solutions (same true of Python, I just prefer R)

---

# Getting your computer ready for the course

All computer coding will be in `R`; assignments will also need to be returned in `R`. For this reason, you will need to find a way to run `R`. Below are some methods, from the easiest to the most challenging.

Note that all options described below are Open Source (completely free). 

---

# In short...

- Terminal version, not very friendly
- Nicer terminal: [radian](https://github.com/randy3k/radian)
- Execute R scripts by using `Rscript name_of_script.R`. Useful to run code in `cron`, for instance
- Use IDEs:
    - [RStudio](https://www.rstudio.com/products/rstudio/) has become the reference
    - [RKWard](https://invent.kde.org/education/rkward) is useful if you are for instance using an ARM processor (Raspberry Pi, some Chromebooks..)
- Integrate into jupyter notebooks

---

## Use syzygy.ca

[syzygy.ca](https://syzygy.ca) is a resource provided by the [Pacific Institute for the Mathematical Sciences](https://www.pims.math.ca/) to students in various universities including ours. From the [webpage](https://syzygy.ca), click the blue *Launch* button at the top right and select UManitoba, click *Log in* on the following page and use your regular University of Manitoba log in information.

This will take you to a Jupyter notebook page, from which you can start notebooks.

The advantage with this method is that all you need is a web browser and access to the internet. The problem with this method is that you need access to the internet. Also, these are shared VMs, there can be downtime, access issues, etc.

---

## Install `R` and RStudio

This is probably the best option if you intend to go a little further than what we will do in the course. `R` is available on most platforms, while `RStudio` is available on most platforms except for Linux ARM devices (but can be compiled there)

Visit [https://www.r-project.org/](https://www.r-project.org/)

Choose your version: Windows or Mac. Under Linux, you can install directly from your package manager (e.g., `sudo apt install R-base` for Debian-based distros)


To install RStudio, see [here](https://www.rstudio.com/products/rstudio/)

---

## Install Jupyter and Jupyter notebook

This is the most complex way, but will give you access to locally hosted (on your machine) Jupyter notebooks, which you can use for both `R` and `Python`.

You will first need to install `Python` from [here](https://www.python.org/). Once `Python` is installed, you will need to install `Jupyter` and Jupyter notebooks by following the instructions [here](https://jupyter.org/install). Then install `R` as indicated above (with this solution, you do not need to install RStudio). Then finally activate `R` support in Jupyter notebooks by following the instructions [here](https://github.com/IRkernel/IRkernel).

As an option, you may want to install [RISE](https://rise.readthedocs.io/en/stable/), if you want to use jupyter notebook to give a presentation, as is done for instance in Slides 04.

---

# Going further

- [RStudio server](https://www.rstudio.com/products/rstudio/#rstudio-server): run RStudio on a Linux server and connect via a web interface
- Shiny: easily create an interactive web site running R code
- [Shiny server](https://www.rstudio.com/products/shiny/shiny-server/): run Shiny apps on a Linux server
- Rmarkdown: markdown that incorporates R commands. Useful for generating reports in html or pdf, can make slides as well..
- RSweave: LaTeX incorporating R commands. Useful for generating reports. Not used as much as Rmarkdown these days

---

# R is a scripted language

- Interactive
- Allows you to work in real time
    - Be careful: what is in memory might involve steps not written down in a script
    - If you want to reproduce your steps, it is good to write all the steps down in a script and to test from time to time running using `Rscript`: this will ensure that all that is required to run is indeed loaded to memory when it needs to, i.e., that it is not already there..

---

<!-- _backgroundImage: "linear-gradient(to bottom, #f1c40f, 20%, white)" -->
# <!--fit-->(Basic) Programming in R

---

# Assignment

Two ways:

```R
X <- 10
```

or

```R
X = 10
```

First version is preferred by R purists.. I don't really care

---

# Lists

A very useful data structure, quite flexible and versatile. Empty list: `L <- list()`. Convenient for things like parameters. For instance

```R
L <- list()
L$a <- 10
L$b <- 3
L[["another_name"]] <- "Plouf plouf"
```

```R
> L[1]
$a
[1] 10
> L[[2]]
[1] 3
> L$a
[1] 10
> L[["b"]]
[1] 3
> L$another_name
[1] "Plouf plouf"
```

---

# Vectors

```R
x = 1:10
y <- c(x, 12)
> y
 [1]  1  2  3  4  5  6  7  8  9 10 12
z = c("red", "blue")
> z
[1] "red"  "blue"
z = c(z, 1)
> z
[1] "red"  "blue" "1"
```
Note that in `z`, since the first two entries are characters, the added entry is also a character. Contrary to lists, vectors have all entries of the same type

---

# Matrices

Matrix (or vector) of zeros
```R
A <- mat.or.vec(nr = 2, nc = 3)
```

Matrix with prescribed entries

```R
B <- matrix(c(1,2,3,4), nr = 2, nc = 2)
> B
     [,1] [,2]
[1,]    1    3
[2,]    2    4
C <- matrix(c(1,2,3,4), nr = 2, nc = 2, byrow = TRUE)
> C
     [,1] [,2]
[1,]    1    2
[2,]    3    4
```

Remark that here and elsewhere, naming the arguments (e.g., `nr = 2`) allows to use arguments in any order

---

# Matrix operations

Probably the biggest annoyance in R compared to other languages

- The notation `A*B` is the *Hadamard product* $A\circ B$ (what would be denoted `A.*B` in matlab), not the standard matrix multiplication
- Matrix multiplication is written `A %*% B`

---

# Vector operations

Vector addition is also frustrating. Say you write `x=1:10`, i.e., make the vector
```R
> x
 [1]  1  2  3  4  5  6  7  8  9 10
```
Then `x+1` gives
```R
> x+1
 [1]  2  3  4  5  6  7  8  9 10 11
 ```
 i.e., adds 1 to all entries in the vector

 Beware of this in particular when addressing sets of indices in lists, vectors or matrices

---

# For the matlab-ers here

- R does not have the keyword `end` to access the last entry in a matrix/vector/list..
- Use `length` (lists or vectors), `nchar` (character chains), `dim` (matrices.. careful, of course returns 2 values)

---

# Flow control

```R
if (condition is true) {
  list of stuff to do
}
```

Even if `list of stuff to do` is a single instruction, best to use curly braces

```R
if (condition is true) {
  list of stuff to do
} else if (another condition) {
  ...
} else {
  ...
}
```

---

# For loops

`for` applies to lists or vectors

```R
for (i in 1:10) {
  something using integer i
}
for (j in c(1,3,4)) {
  something using integer j
}
for (n in c("truc", "muche", "chose")) {
  something using string n
}
for (m in list("truc", "muche", "chose", 1, 2)) {
  something using string n or integer n, depending
}
```

---

# lapply

Very useful function (a few others in the same spirit: `sapply`, `vapply`, `mapply`)

Applies a function to each entry in a list/vector/matrix. Because there is a parallel version (`parLapply`) that we will see later, worth learning

```R
l = list()
for (i in 1:10) {
        l[[i]] = runif(i)
}
lapply(X = l, FUN = mean)
```

or, to make a vector

```R
unlist(lapply(X = l, FUN = mean))
```

or

```R
sapply(X = l, FUN = mean)
```

---

# "Advanced" lapply

Can "pick up" nontrivial list entries

```R
l = list()
for (i in 1:10) {
        l[[i]] = list()
        l[[i]]$a = runif(i)
        l[[i]]$b = runif(2*i)
}
sapply(X = l, FUN = function(x) length(x$b))
```

gives

```R
[1]  2  4  6  8 10 12 14 16 18 20
```

Just recall: the argument to the function you define is a list entry (`l[[1]]`, `l[[2]]`, etc., here)

---

# <!--fit-->Avoid parameter variation loops with expand.grid

```R
# Suppose we want to vary 3 parameters
variations = list(
    p1 = seq(1, 10, length.out = 10),
    p2 = seq(0, 1, length.out = 10),
    p3 = seq(-1, 1, length.out = 10)
)

# Create the list
tmp = expand.grid(variations)
PARAMS = list()
for (i in 1:dim(tmp)[1]) {
    PARAMS[[i]] = list()
    for (k in 1:length(variations)) {
        PARAMS[[i]][[names(variations)[k]]] = tmp[i, k]     
    }
}
```

There is still a loop, but you can split this list, use it on different machines, etc. And can use `parLapply`

