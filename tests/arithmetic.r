# trying to cover many methods -- not all of them
require(houba)

x <- as.mvector(2**(1:4))
y <- 2*x
x <- x/2
x <- x + c(1,2) / y - y / c(1, 2)
x <- -x * c(64, 128)
stopifnot( all(x[] == c(176, 224, 764, 1016)) )
stopifnot( all((x / (y * 0.25))[] == c(176, 112, 191, 127)) )
stopifnot( all((x * y / 64)[] == c(11, 28, 191, 508)) )
stopifnot( all(((x - 1:2) + 2:1)[] == c(177, 223, 765, 1015) ) )
stopifnot( all(((2:1 + x) - 1:2)[] == c(177, 223, 765, 1015) ) )

x <- as.mvector(2**(1:4))
dim(x) <- c(2,2)
y <- 2*x
x <- x/2
x <- x + c(1,2) / y - y / c(1, 2)
x <- -x * c(64, 128)
stopifnot( all(x[] == c(176, 224, 764, 1016)) )
stopifnot( all((x / (y * 0.25))[] == c(176, 112, 191, 127)) )
stopifnot( all((x * y / 64)[] == c(11, 28, 191, 508)) )
stopifnot( all(((x - 1:2) + 2:1)[] == c(177, 223, 765, 1015) ) )
stopifnot( all(((2:1 + x) - 1:2)[] == c(177, 223, 765, 1015) ) )

x <- as.mvector(2**(1:4))
dim(x) <- c(2,1,2)
y <- 2*x
x <- x/2
x <- x + c(1,2) / y - y / c(1, 2)
x <- -x * c(64, 128)
stopifnot( all(x[] == c(176, 224, 764, 1016)) )
stopifnot( all((x / (y * 0.25))[] == c(176, 112, 191, 127)) )
stopifnot( all((x * y / 64)[] == c(11, 28, 191, 508)) )
stopifnot( all(((x - 1:2) + 2:1)[] == c(177, 223, 765, 1015) ) )
stopifnot( all(((2:1 + x) - 1:2)[] == c(177, 223, 765, 1015) ) )

