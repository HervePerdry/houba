require(houba)
x <- mvector("int", 6)
dim(x) <- 2:3
stopifnot( is(x, "mmatrix") )
dim(x) <- c(2,1,3)
stopifnot( is(x, "marray") )
dim(x) <- NULL
stopifnot( is(x, "mvector") )

