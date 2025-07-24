require(houba)

# float matrix
A <- mmatrix("float", 10, 20)
a <- as.matrix(A)
stopifnot(typeof(a) == "double")

# set max size
houba(max.size = 10)
stopifnot( typeof(A[1:10]) == "double" )
stopifnot( typeof(A[1:11]) == "S4" )

# assignement and subsetting
A[1,1] <- 12
A[3,] <- 1.34
stopifnot( all(abs(as.matrix(A[1:3, 1:2] - c(12, 0, 1.34, 0, 0, 1.34))) < 1e-6)  )

# int matrix
B <- mmatrix("int", 10, 20)
b <- as.matrix(B)
stopifnot(typeof(b) == "integer")

# assignement and subsetting
B[1,1] <- 12
B[3,] <- 1.34
stopifnot( all(as.matrix(B[1:3, 1:2] == c(12L, 0L, 1L, 0L, 0L, 1L))) )

# assignement with other mmatrix values
houba(max.size = 0) # force non conversion to R 
B[2,] <- A[3,]
stopifnot( all(as.vector(B[2, 1:4]) == c(1L, 1L, 1L, 1L)) )

# double vector
V <- mvector("double", 10)
v <- as.vector(V)
V[1:4] <- pi
stopifnot( all(as.vector(V[3:6]) == c(pi, pi, 0, 0)) ) 


# int_16 matrix
C <- mmatrix("short", 10, 20)
C[1, ] <- 1
C[2, ] <- 2
C[3, ] <- 3
add.descriptor.file(C)

D <- read.descriptor(C@file)
stopifnot( all(as.matrix(C) == as.matrix(D)))

#descriptor for mvector
add.descriptor.file(V)
Vbis <- read.descriptor(V@file, FALSE) #so NOT read-only
Vbis[,] <- 0
#modified V in place through Vbis
stopifnot( all(as.vector(V) == 0) )
