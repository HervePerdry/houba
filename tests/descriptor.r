library(houba)

# int16 mmatrix ----------------------
C <- mmatrix("short", 10, 20)
C[] <- sample.int(200)

# create descriptor file 
dsc <- descriptor.file(C)

# linking it to other object
D <- read.descriptor(dsc)
stopifnot( all(as.matrix(C) == as.matrix(D)))

# avec des rownames / colnames -----------
E <- mmatrix("short", 10, 20)
E[] <- sample.int(200)
rownames(E) <- sprintf("L%02d", 1:10)
colnames(E) <- sprintf("C%02d", 1:20)

# create descriptor file 
dsc <- descriptor.file(E)

# linking it to other object
F <- read.descriptor(dsc)
stopifnot( all(as.matrix(E) == as.matrix(F)))
stopifnot( all(rownames(E) == rownames(F)) )
stopifnot( all(colnames(E) == colnames(F)) )


# descriptor for mvector ----------------
V <- mvector("double", 5)
V[] <- 11:15 / 100

dsc <- descriptor.file(V)

# reading it
Vbis <- read.descriptor(dsc, FALSE) #so NOT read-only

# modify V through Vbis
Vbis[] <- pi
flush(Vbis)
stopifnot( all(as.vector(V) == pi) )

# and for marray -----------------

x <- marray("int", 2:4)
x[] <- 1:24
dimnames(x) <- list( letters[1:2], letters[1:3], LETTERS[1:4] )

dsc <- descriptor.file(x)
y <- read.descriptor(dsc)

stopifnot( all(as.array(x) == as.array(y)) )
stopifnot( all.equal(dimnames(x), dimnames(y)) )


