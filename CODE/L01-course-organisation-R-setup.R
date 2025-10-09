## ----set-lecture-number,echo=FALSE--------------------------------------------
lecture_number = "01"


## ----set-options,echo=FALSE,warning=FALSE,message=FALSE-----------------------
# Source the code common to all lectures
source("common-code.R")


## ----set-slide-background,echo=FALSE,results='asis'---------------------------
# Are we plotting for a dark background? Setting is in common-code.R, but
# cat command must run here.
cat(input_setup)


## ----assignment1, eval=FALSE--------------------------------------------------
# X <- 10


## ----assignment2, eval=FALSE--------------------------------------------------
# X = 10


## ----lists_example1, echo=FALSE-----------------------------------------------
L <- list()
L$a <- 10
L$b <- 3
L[["another_name"]] <- "Plouf plouf"


## ----lists_example2-----------------------------------------------------------
L[1]
L[[2]]
L$a
L[["b"]]
L$another_name


## ----vectors_example, eval=FALSE----------------------------------------------
# x = 1:10
# y <- c(x, 12)
# y
# z = c("red", "blue")
# z
# z = c(z, 1)
# z


## ----matrix_zeros, eval=FALSE-------------------------------------------------
# A <- mat.or.vec(nr = 2, nc = 3)


## ----matrix_prescribed, eval=FALSE--------------------------------------------
# B <- matrix(c(1,2,3,4), nr = 2, nc = 2)
# B
# #      [,1] [,2]
# # [1,]    1    3
# # [2,]    2    4
# C <- matrix(c(1,2,3,4), nr = 2, nc = 2, byrow = TRUE)
# C
# #      [,1] [,2]
# # [1,]    1    2
# # [2,]    3    4


## ----vector_ops1, eval=FALSE--------------------------------------------------
# x
# #  [1]  1  2  3  4  5  6  7  8  9 10


## ----vector_ops2, eval=FALSE--------------------------------------------------
# x+1
# #  [1]  2  3  4  5  6  7  8  9 10 11


## ----flow_control, eval=FALSE-------------------------------------------------
# # if (condition is true) {
# #   list of stuff to do
# # }


## ----flow_control_extended, eval=FALSE----------------------------------------
# # if (condition is true) {
# #   list of stuff to do
# # } else if (another condition) {
# #   ...
# # } else {
# #   ...
# # }


## ----for_loops, eval=FALSE----------------------------------------------------
# # for (i in 1:10) {
# #   something using integer i
# # }
# # for (j in c(1,3,4)) {
# #   something using integer j
# # }
# # for (n in c("truc", "muche", "chose")) {
# #   something using string n
# # }
# # for (m in list("truc", "muche", "chose", 1, 2)) {
# #   something using string n or integer n, depending
# # }


## ----lapply_example1, eval=FALSE----------------------------------------------
# l = list()
# for (i in 1:10) {
#         l[[i]] = runif(i)
# }
# lapply(X = l, FUN = mean)


## ----lapply_example2, eval=FALSE----------------------------------------------
# unlist(lapply(X = l, FUN = mean))


## ----lapply_example3, eval=FALSE----------------------------------------------
# sapply(X = l, FUN = mean)


## ----lapply_advanced, eval=FALSE----------------------------------------------
# l = list()
# for (i in 1:10) {
#         l[[i]] = list()
#         l[[i]]$a = runif(i)
#         l[[i]]$b = runif(2*i)
# }
# sapply(X = l, FUN = function(x) length(x$b))


## ----lapply_advanced_result, eval=FALSE---------------------------------------
# # [1]  2  4  6  8 10 12 14 16 18 20


## ----expand_grid, eval=FALSE--------------------------------------------------
# # Suppose we want to vary 3 parameters
# variations = list(
#     p1 = seq(1, 10, length.out = 10),
#     p2 = seq(0, 1, length.out = 10),
#     p3 = seq(-1, 1, length.out = 10)
# )
# 
# # Create the list
# tmp = expand.grid(variations)
# PARAMS = list()
# for (i in 1:dim(tmp)[1]) {
#     PARAMS[[i]] = list()
#     for (k in 1:length(variations)) {
#         PARAMS[[i]][[names(variations)[k]]] = tmp[i, k]
#     }
# }


## ----convert-Rnw-to-R,warning=FALSE,message=FALSE,echo=FALSE,results='hide'----
rmd_chunks_to_r_temp()

