# Overview

**houba** provides manipulation of large data through memory-mapped files, supporting vectors,
matrices, and arrays. This allows to work with large datasets by keeping them on disk.

**houba** defines three S4 classes:

- `mvector` for memory-mapped vectors
- `mmatrix` for memory-mapped matrices  
- `marray` for memory-mapped arrays

Currently, it supports `float`, `double`, `integer` and `char` data types.

**houba** allows to extract sub-vectors or sub-matrices, and to make assignments.
It also performs component wise arithmetic operations (currently no matrix arithmetic).
In-place arithmetic operations are supported. `rowSums`, `colSums`, `rowMeans`, `colMeans` 
methods are defined for memory-mapped matrices.

A minimal compatibility with the **bigmemory** package is provided through descriptor files.

**NOTE 1** A current limitation of **houba** is that it relies on R integers for indices, thus
vectors of length larger than 2,147,483,647 can't be manipulated. Same limitations apply to
matrices and arrays dimensions.

**NOTE 2** **houba** relies on the C++ header only library mio by vimpunk, which is under
MIT Licence : <https://github.com/vimpunk/mio>.

# Creating memory-mapped objects


## Creating objects associated to new files

To create zero-filled objects, associated with new files, use
`mvector`, `mmatrix` and `marray`.

Here we create a memory-mapped vector of length 100, associated with a temporary file:


``` r
A <- mvector(datatype = "double", length = 100)
A
```

```
## A mvector of length 100 
## data type:  double 
## File: /tmp/RtmpC8LyiQ/mmatrix20969658b5ec60 
## --- excerpt
## [1] 0 0 0 0 0
```

We can specify the filename for the backing file. Here we create a memory-mapped matrix:

``` r
filename <- file.path(tempdir(), "integers120")
B <- mmatrix(datatype = "integer", nrow = 12, ncol = 10, filename = filename)
B
```

```
## A mmatrix with 12 rows and 10 cols
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/integers120 
## --- excerpt
##      [,1] [,2] [,3] [,4] [,5]
## [1,]    0    0    0    0    0
## [2,]    0    0    0    0    0
## [3,]    0    0    0    0    0
## [4,]    0    0    0    0    0
## [5,]    0    0    0    0    0
```

Similarly, 
`marray("float", c(10, 20, 3))` a 10 by 20 by 3 array.

## Conversion from an R object

The methods `as.mvector`, `as.mmatrix` and `as.marray` allow to create a file
corresponding to the content of a R object.


``` r
# Convert regular R objects to memory-mapped objects
a <- matrix(1:20, 4, 5)
A <- as.mmatrix(a, datatype = "float")
A
```

```
## A mmatrix with 4 rows and 5 cols
## data type:  float 
## File: /tmp/RtmpC8LyiQ/mmatrix209696407b7edd 
## --- excerpt
##      [,1] [,2] [,3] [,4] [,5]
## [1,]    1    5    9   13   17
## [2,]    2    6   10   14   18
## [3,]    3    7   11   15   19
## [4,]    4    8   12   16   20
```

If `datatype` is not provided, the method will use `integer` of `double`,
depending on the type of the R object.


``` r
v <- 1:10
V <- as.mvector(v)
V
```

```
## A mvector of length 10 
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/mmatrix20969634136258 
## --- excerpt
## [1] 1 2 3 4 5
```

These methods also have an argument `filename`.

## Conversion to an R object

You can recover a R object using `as.vector`, `as.matrix` and `as.array`:


``` r
as.vector(V)
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```

## Mapping pre-existing files

An existing file can be mapped, as long as is has the good size.
Here we use the file mapped in `B` created above.


``` r
C <- mvector("int", 120, filename)
C
```

```
## A read-only mvector of length 120 
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/integers120 
## --- excerpt
## [1] 0 0 0 0 0
```

Providing an incompatible size will raise an error.

``` r
D <- mvector("int", 100, filename)
```

```
## Error: The file size doesn't match the matrix size
```

The mvector `C` is read-only, this is the default when mapping an existing file. 
You can change this by providing the argument `readonly = FALSE` to `mvector`.

As `C` and `B` are mapping the same files, modifying one object should modify the other:

``` r
B[1:4] <- 1:4
C
```

```
## A read-only mvector of length 120 
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/integers120 
## --- excerpt
## [1] 1 2 3 4 0
```

However this may not work always well, depending on your system, or when
a file is mapped through several R sessions. The function `flush` makes sure
all changes are written on disk:


``` r
B[1:4] <- 2:5
flush(B)
C
```

```
## A read-only mvector of length 120 
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/integers120 
## --- excerpt
## [1] 2 3 4 5 0
```

## Descriptor Files

Descriptor files aim to provide a minimal compatibility 
with the **bigmemory** package. 

### Basic usage

To create a descriptor file associated is a mapped file, use `descriptor.file`. We 
illustrate it here on the matrix `B` created above.


``` r
B
```

```
## A mmatrix with 12 rows and 10 cols
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/integers120 
## --- excerpt
##      [,1] [,2] [,3] [,4] [,5]
## [1,]    2    0    0    0    0
## [2,]    3    0    0    0    0
## [3,]    4    0    0    0    0
## [4,]    5    0    0    0    0
## [5,]    0    0    0    0    0
```

``` r
dsc <- descriptor.file(B)
```

```
## Warning in mk.descriptor.file(object@file, object@dim[1], object@dim[2], : Creating
## a descriptor file for an object stored in tmp directory
```

Descriptor files can be read with `read.descriptor`:


``` r
D <- read.descriptor(dsc)
D
```

```
## A read-only mmatrix with 12 rows and 10 cols
## data type:  integer 
## File: /tmp/RtmpC8LyiQ//integers120 
## --- excerpt
##      [,1] [,2] [,3] [,4] [,5]
## [1,]    2    0    0    0    0
## [2,]    3    0    0    0    0
## [3,]    4    0    0    0    0
## [4,]    5    0    0    0    0
## [5,]    0    0    0    0    0
```

### Compatibility with bigmemory

The descriptor files created by **houba** can be read with the package **bigmemory**:

We first load the package and read the descriptor file:

``` r
library(bigmemory)
desc <- dget(dsc)
```

We then attach the file:

``` r
bm <- attach.big.matrix(desc)
```

The resulting object maps the same datafile:

``` r
bm[,1]
```

```
##  [1] 2 3 4 5 0 0 0 0 0 0 0 0
```

Note that alhougj **houba** allows to create descriptor files for marrays, these won't be 
accepted by **bigmemory** which doesn't handle arrays.

## Restoring Broken Pointers

When restoring data from a previous session, pointers to external objects are broken,
making objects unsuable. 
If the underlying data file still exists, you can use `restore` to overcome the problem.

Here we simulate this behaviour on the matrix `B`, using `save.image`.


``` r
B
```

```
## A mmatrix with 12 rows and 10 cols
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/integers120 
## --- excerpt
##      [,1] [,2] [,3] [,4] [,5]
## [1,]    2    0    0    0    0
## [2,]    3    0    0    0    0
## [3,]    4    0    0    0    0
## [4,]    5    0    0    0    0
## [5,]    0    0    0    0    0
```

``` r
rdata_file <- tempfile(fileext = ".rda")
save.image(rdata_file)
```

Now we erase `B`:

``` r
rm(B)
```

And we load the saved image:

``` r
load(rdata_file)
B
```

```
## A mmatrix with a broken external ptr ! Try using restore()
```

The pointer in `B` is broken, but can be restored as this:

``` r
B <- restore(B)
B
```

```
## A mmatrix with 12 rows and 10 cols
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/integers120 
## --- excerpt
##      [,1] [,2] [,3] [,4] [,5]
## [1,]    2    0    0    0    0
## [2,]    3    0    0    0    0
## [3,]    4    0    0    0    0
## [4,]    5    0    0    0    0
## [5,]    0    0    0    0    0
```

## Copying objects

You can create a copy with `copy`. This will also create a new file. 


``` r
C <- copy(B)
C
```

```
## A mmatrix with 12 rows and 10 cols
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/mmatrix209696401d3360 
## --- excerpt
##      [,1] [,2] [,3] [,4] [,5]
## [1,]    2    0    0    0    0
## [2,]    3    0    0    0    0
## [3,]    4    0    0    0    0
## [4,]    5    0    0    0    0
## [5,]    0    0    0    0    0
```

This function have an argument `filename`. It can in particular be used to save
data that are stored in a temporary file.

# Data manipulation 

## Changing dimensions

The dimensions of an object can be accessed through `dim`.


``` r
a <- matrix(1:12, 3, 4)
A <- as.mmatrix(a)
A
```

```
## A mmatrix with 3 rows and 4 cols
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/mmatrix20969679727409 
## --- excerpt
##      [,1] [,2] [,3] [,4]
## [1,]    1    4    7   10
## [2,]    2    5    8   11
## [3,]    3    6    9   12
```

``` r
dim(A)
```

```
## [1] 3 4
```

You can change the dimensions:

``` r
dim(A) <- c(4, 3)
A
```

```
## A mmatrix with 4 rows and 3 cols
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/mmatrix20969679727409 
## --- excerpt
##      [,1] [,2] [,3]
## [1,]    1    5    9
## [2,]    2    6   10
## [3,]    3    7   11
## [4,]    4    8   12
```

Setting the dimensions to `NULL` creates a mvector:

``` r
dim(A) <- NULL
A
```

```
## A mvector of length 12 
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/mmatrix20969679727409 
## --- excerpt
## [1] 1 2 3 4 5
```

Similarly, you can obtain an marray:

``` r
dim(A) <- c(2,2,3)
A
```

```
## A marray with dimensions 2 2 3 
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/mmatrix20969679727409
```

## Accessing values

You can access elements of a memory-mapped object just as regular objects.

Let us create a memory-mapped matrix

``` r
a <- matrix( sample(0:99, 2500, TRUE), 50, 50)
A <- as.mmatrix(a)
```

Acessing a single element:

``` r
A[1,1]
```

```
## [1] 10
```

Accessing a row:

``` r
A[1,]
```

```
##  [1] 10 70 89 62 27 47 34 12 55 36 70  0 36 45 64 79  9 31 57 15 81 57 76 51 11 76 19
## [28] 18 68 12 58 21 47 66 30 14  3 65  1 12 80 45 31 85 91 36 78 26 30 61
```

The result here is a R object. This behaviour actually depends on its size!
The default is to return a R object if the result's size is less than 
one million, and else to return a memory-mapped object.  

This can be changed through the option `max.size`, as follows:

``` r
houba(max.size = 20)
```

```
## $max.size
## [1] 20
```

And now, accessing to the first row will sends a new memory-mapped object:

``` r
A[1,]
```

```
## A mmatrix with 1 rows and 50 cols
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/mmatrix2096966d57bac5 
## --- excerpt
## [1] 10 70 89 62 27
```

## Assigning values

Again, you can use R syntax to assign values:


``` r
A[1,1] <- 0
A[2,] <- 10
A
```

```
## A mmatrix with 50 rows and 50 cols
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/mmatrix2096962941bc93 
## --- excerpt
##      [,1] [,2] [,3] [,4] [,5]
## [1,]    0   70   89   62   27
## [2,]   10   10   10   10   10
## [3,]   46   16   92   54   87
## [4,]   41   80   70    7   62
## [5,]   42   11   30   24   97
```

Assignement with another memory-mapped object is also possible:

``` r
V <- as.mvector(1:50, "int")
A[3,] <- V
A
```

```
## A mmatrix with 50 rows and 50 cols
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/mmatrix2096962941bc93 
## --- excerpt
##      [,1] [,2] [,3] [,4] [,5]
## [1,]    0   70   89   62   27
## [2,]   10   10   10   10   10
## [3,]    1    2    3    4    5
## [4,]   41   80   70    7   62
## [5,]   42   11   30   24   97
```

There is no type promotion. Assigning a floating point value to an integer object
will cast it to integer:


``` r
A[1,1] <- pi
A[1,1]
```

```
## [1] 3
```

## Arithmetic Operations

Arithmetic operations are available with the usual R syntax.


``` r
a <- matrix( sample.int(16), 4, 4)
A <- as.mmatrix(a, datatype = "float")
A <- 1 + 2*A
A
```

```
## A mmatrix with 4 rows and 4 cols
## data type:  float 
## File: /tmp/RtmpC8LyiQ/mmatrix20969675408905 
## --- excerpt
##      [,1] [,2] [,3] [,4]
## [1,]   31    5   15   19
## [2,]   27   33   17   13
## [3,]   29   23    7   21
## [4,]   25   11    3    9
```

Memory-mapped objects can be used for both operands:

``` r
B <- A + 2
C <- A / B
C
```

```
## A mmatrix with 4 rows and 4 cols
## data type:  float 
## File: /tmp/RtmpC8LyiQ/mmatrix20969658a02306 
## --- excerpt
##           [,1]      [,2]      [,3]      [,4]
## [1,] 0.9393939 0.7142857 0.8823529 0.9047619
## [2,] 0.9310345 0.9428571 0.8947368 0.8666667
## [3,] 0.9354839 0.9200000 0.7777778 0.9130435
## [4,] 0.9259259 0.8461539 0.6000000 0.8181818
```

### There's no type promotion in houba
There is no type promotion. If the two operands have different types, the type of the result is
the type of the left operand.

Let's create to vectors with type `float` and `integer`:

``` r
A <- as.mvector( seq(0, 1, length = 11), datatype = "float" )
B <- as.mvector( 0:10, datatype = "integer" )
```

Now `A + B` has type `float`:


``` r
A + B
```

```
## A mvector of length 11 
## data type:  float 
## File: /tmp/RtmpC8LyiQ/mmatrix209696173e5f03 
## --- excerpt
## [1] 0.0 1.1 2.2 3.3 4.4
```

and `B + A` has type `integer`:


``` r
B + A
```

```
## A mvector of length 11 
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/mmatrix209696267c0a31 
## --- excerpt
## [1] 0 1 2 3 4
```

## In-Place Arithmetic Operations

We can modify the data without creating copies:


``` r
V <- as.mvector(1:20, "float")
W <- as.mvector(sample.int(20))

inplace.sum(V, 1)          # Add 1 to all elements
inplace.prod(V, W)         # Multiply elements of V by elements of W
inplace.minus(V, c(1,2))   # Subtract c(1,2) from all elements (recycling)
inplace.div(V, 4)          # Divide all elements by 4
inplace.opposite(V)        # Take opposite of all elements
inplace.inverse(V)         # Take reciprocal of all elements

V
```

```
## A mvector of length 20 
## data type:  float 
## File: /tmp/RtmpC8LyiQ/mmatrix2096962f672597 
## --- excerpt
## [1] -0.12903225 -0.14285715 -0.21052632 -0.04545455 -0.06153846
```

# Row and columns operations

**houba** provides analogs to `rowSums`, `rowMeans`, `colSums`, `colMeans`, and `apply`, 
for memory-mapped matrices (but not for memory mapped arrays).

## Sums and means


``` r
a <- matrix( sample.int(100), 10, 10)
A <- as.mmatrix(a)

# Row sums and meands
rowSums(A)
```

```
##  [1] 411 468 509 477 524 546 654 509 442 510
```

``` r
rowMeans(A)
```

```
##  [1] 41.1 46.8 50.9 47.7 52.4 54.6 65.4 50.9 44.2 51.0
```

Here the result is a R object, because its size does not exceed the value
of the option `max.size`. In the contrary case, it will be a memory-mapped
object:


``` r
houba(max.size = 5)
```

```
## $max.size
## [1] 5
```

``` r
rowSums(A)
```

```
## A mvector of length 10 
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/mmatrix20969654afe646 
## --- excerpt
## [1] 411 468 509 477 524
```

## Applying Functions

The `apply` method will extract row or lines to R objects. Again, the type of the
result depends on the `max.size` option.

If the size of the result is larger than `max.size`, a memory mapped object is returned:

``` r
houba(max.size = 5)
```

```
## $max.size
## [1] 5
```

``` r
apply(A, 1, sd)
```

```
## A mvector of length 10 
## data type:  double 
## File: /tmp/RtmpC8LyiQ/mmatrix20969647963084 
## --- excerpt
## [1] 30.63930 31.90890 26.38371 30.17376 25.98803
```
The data type of this object will be `double` or `integer`, depending on the 
values returned by the function. For example, the `sum` function will return
integers:

``` r
apply(A, 1, sum)
```

```
## A mvector of length 10 
## data type:  integer 
## File: /tmp/RtmpC8LyiQ/mmatrix209696298aae32 
## --- excerpt
## [1] 411 468 509 477 524
```

And if the size of the result is smaller than `max.size`, a R object is returned:

``` r
houba(max.size = 1e6)
```

```
## $max.size
## [1] 1e+06
```

``` r
apply(A, 1, sd)
```

```
##  [1] 30.63930 31.90890 26.38371 30.17376 25.98803 27.48818 28.96818 33.40808 31.33617
## [10] 29.84032
```

# Contributing to houba

You may e-mail the author if for bug reports, feature requests,
or contributions. The source of the package is on [github](https://github.com/HervePerdry/houba).

Houba, hop! 




