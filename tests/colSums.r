require(houba)
a <- matrix(1:24, 4, 6)
A <- as.mmatrix(a, "float")

stopifnot( all(colSums(A) == colSums(a)) )
stopifnot( all(colMeans(A) == colMeans(a)) )
stopifnot( all(rowSums(A) == rowSums(a)) )
stopifnot( all(rowMeans(A) == rowMeans(a)) )

houba(max.size = 2)
B <- colSums(A)
stopifnot( is(B, "mvector"))
stopifnot( all(as.vector(B) == colSums(a)) )

B <- colMeans(A)
stopifnot( is(B, "mvector"))
stopifnot( all(as.vector(B) == colMeans(a)) )

B <- rowSums(A)
stopifnot( is(B, "mvector"))
stopifnot( all(as.vector(B) == rowSums(a)) )

B <- rowMeans(A)
stopifnot( is(B, "mvector"))
stopifnot( all(as.vector(B) == rowMeans(a)) )

