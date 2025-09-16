# very limited testing, there are so many cases to cover

require(houba)

a <- matrix(1:6, 2, 3)
A <- as.mmatrix(a)
A[2,] <- A[1,] * 2
A[,3] <- A[,1] + 5
stopifnot( all(A[] == c(1, 2, 3, 6, 6, 7)) )

houba(max.size = 0) # test replacement by memory mapped objects
A <- as.mmatrix(a)
A[2,] <- A[1,] * 2
A[,3] <- A[,1] + 5
stopifnot( all( as.vector(A) == c(1, 2, 3, 6, 6, 7)) )


