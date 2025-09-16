require(houba)

a <- matrix(1:6, 2, 3)
A <- as.mmatrix(a)
stopifnot( all(apply(A, 1, var) == 4) ) 
stopifnot( all(apply(A, 2, var) == 0.5) )

houba(max.size = 0)
B <- apply(A, 1, var)
stopifnot( is(B, "mvector") )
stopifnot( all(as.vector(B) == 4) ) 

B <- apply(A, 2, var)
stopifnot( is(B, "mvector") )
stopifnot( all(as.vector(B) == 0.5) ) 
