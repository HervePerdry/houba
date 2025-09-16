require(houba)

a <- array( 1:24, c(2,3,4) )
A <- as.marray(a)
b <- as.array(A) 
stopifnot( all(dim(b) == 2:4) )
stopifnot( all(a == b) )

b <- as.vector(A)
stopifnot( is.null(dim(b)) )
stopifnot( all(a == b) )

dim(a) <- dim(A) <- c(4,6)
b <- as.matrix(A)
stopifnot( all(dim(b) == c(4,6)) )
stopifnot( all(a == b) )

b <- as.vector(A)
stopifnot( is.null(dim(b)) )
stopifnot( all(a == b) )

dim(A) <- NULL
b <- as.vector(A)
stopifnot( is.null(dim(b)) )
stopifnot( all(a == b) )


