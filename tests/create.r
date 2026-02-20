# Various tests about object creation and manipulation
require(houba)

# float mmatrix ------------------------
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

A[5] <- pi
stopifnot( all(abs(as.vector(A[,1] - c(12, 0, 1.34, 0, pi, 0, 0, 0, 0, 0))) < 1e-6) )

# int mmatrix ---------------------------
B <- mmatrix("int", 10, 20)
b <- as.matrix(B)
stopifnot(typeof(b) == "integer")

# assignement and subsetting
B[1,1] <- 12
B[3,] <- 1.34
stopifnot( all(as.matrix(B[1:3, 1:2]) == c(12L, 0L, 1L, 0L, 0L, 1L)) )

B[5] <- 2
stopifnot( all(as.vector(B[5, 1:3]) == c(2L, 0L, 0L)) )

# assignement with other mmatrix values
houba(max.size = 0) # force non conversion to R 
B[2,] <- A[3,]
stopifnot( all(as.vector(B[2, 1:4]) == c(1L, 1L, 1L, 1L)) )

B[5] <- A[3]
stopifnot( all(as.vector(B[5, 1:3]) == c(1L, 0L, 0L)) )

# double mvector -------------------------
V <- mvector("double", 10)
v <- as.vector(V)
V[1:4] <- pi
stopifnot( all(as.vector(V[3:6]) == c(pi, pi, 0, 0)) ) 

# int array --------------------------
C <- marray("int", 2:4)
C[,,1] <- 7
C[,2,] <- B[5]
C[1] <- 8
C[2] <- B[1]
stopifnot( all(as.array(C[,,1]) == c(8L, 12L, 1L, 1L, 7L, 7L)) )

# just one test for an object in memory
C <- marray("int", 2:4, "")
C[,,1] <- 7
C[,2,] <- B[5]
C[1] <- 8
C[2] <- B[1]
stopifnot( all(as.array(C[,,1]) == c(8L, 12L, 1L, 1L, 7L, 7L)) )


# int16 mmatrix ----------------------
C <- mmatrix("short", 10, 20)
C[] <- sample.int(200)

# create descriptor file 
dsc <- descriptor.file(C)

# linking it to other object
D <- read.descriptor(dsc)
stopifnot( all(as.matrix(C) == as.matrix(D)))

# descriptor for mvector ----------------
dsc <- descriptor.file(V)

# reading it
Vbis <- read.descriptor(dsc, FALSE) #so NOT read-only

# modified V through Vbis
Vbis[,] <- pi
flush(Vbis)
stopifnot( all(as.vector(V) == pi) )
