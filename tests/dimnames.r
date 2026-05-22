require(houba)

x <- mvector("int", 5, names = letters[1:5])
x["b"] <- 12
stopifnot( x[2] == x["b"] && x[2] == 12 )

x <- mmatrix("int", 10, 10)
rownames(x) <- letters[1:10]
colnames(x) <- LETTERS[1:10]
x["d", "C"] <- 5
stopifnot( x["d", "C"] == 5 )

x <- marray("int", 2:4)
x[] <- 1:24
dimnames(x) <- list( letters[1:2], letters[1:3], LETTERS[1:4] )
stopifnot( x["a", "b", "C"] == x[1, 2, 3] )


