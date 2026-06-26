# very limited testing, there are so many cases to cover

require(houba)

## vectors --------------------------------------------------------------
houba(max.size = 1000)

a <- 1:6
A <- as.mvector(a)
A[2] <- A[1] * 2
A[3] <- A[1] + 5
stopifnot( all(A[] == c(1, 2, 6, 4, 5, 6)) )

# negative indices
stopifnot(A[-1] == A[2:6])

A[-(1:2)] <- 3:6
stopifnot( all(A[] == 1:6) ) 

houba(max.size = 0) # test replacement by memory mapped objects

A[2] <- A[1] * 2
A[3] <- A[1] + 5
stopifnot( all(as.vector(A) == c(1, 2, 6, 4, 5, 6)) )

A[-2] <- A[1:5] 
stopifnot( all(as.vector(A) == c(1, 2, 2, 6, 4, 5)) )

## matrices ---------------------------------------------------------------
houba(max.size = 1000)

a <- matrix(1:6, 2, 3)
A <- as.mmatrix(a)
A[2,] <- A[1,] * 2
A[,3] <- A[,1] + 5
stopifnot( all(A[] == c(1, 2, 3, 6, 6, 7)) )

# negative indices
stopifnot(A[-1,] == A[2, ])

# replacement by whole matrices
A[,1:2] <- A[,1:2] + 1
stopifnot( all(A[] == c(2, 3, 4, 7, 6, 7)) )

houba(max.size = 0) # test replacement by memory mapped objects
A <- as.mmatrix(a)
A[2,] <- A[1,] * 2
A[,3] <- A[,1] + 5
stopifnot( all( as.vector(A) == c(1, 2, 3, 6, 6, 7)) )

A[-1,] <- A[-1, ] + 1
stopifnot( all(as.vector(A) == c(1, 3, 3, 7, 6, 8)) )

## arrays ---------------------------------------------------------------
houba(max.size = 1000)

a <- array(1:24, 2:4)
A <- as.marray(a)

A[2,,] <- A[1,,] * 5
a[2,,] <- a[1,,] * 5
stopifnot( all(A[] == a) )

# negative indices
stopifnot(A[-1,,] == A[2,,])

houba(max.size = 0) # test replacement by memory mapped objects
A <- as.marray(array(1:24, 2:4))

A[2,,] <- A[1,,] * 5
stopifnot( all( as.array(A) == a) )



