require(houba)

a <- mvector("int", 2)
a[2] <- 1
stopifnot( a[2] == 1 )

a <- mmatrix("float", 6, 3)
a[] <- 1:18
stopifnot( all(a[1,] == c(1, 7, 13)) )

a <- marray("double", 2:4)
a[] <- 1:24
stopifnot( all(a[2,1,] == c(2, 8, 14, 20)) )

