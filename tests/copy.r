require(houba)

a <- as.mvector(1:4)
b <- copy(a)
stopifnot( all(b[] == 1:4) )


A <- mvector("double", 3)
copy.values(A, 1:3)
B <- mvector("double", 6)
copy.values(B, A)
stopifnot( all(B[] == 1:3) )

