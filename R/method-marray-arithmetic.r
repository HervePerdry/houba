same.dim <- function(d1, d2) {
  if(length(d1) == length(d2))
    all(d1 == d2)
  else
    FALSE
}

#' @title Arithmetic Operators
#'
#' @description Arithmetic operators for memory mapped objects
#'
#' @name Arithmetic
#' @rdname Arithmetic
#' @aliases Arithmetic
#'
#' @param e1 first operand
#' @param e2 second operand
#'
#' @details The usual operations are performed. Values are recycled if necessary.
#' There's no type promotion: if one of the operands is a R object and the other
#' is a memory-mapped object, the result will be a memory mapped object with same
#' data type as the operand. If both operand are memory mapped objects with different
#' data types, the result will be a memory mapped object with the same data type than
#' the left operand.
#'
#' @return an object of class mvector, mmatrix or marray depending on 
#' the operand classes.
#'
#' @examples x <- as.mvector(2**(1:4))
#' y <- 2*x
#' x <- x/2
#' x + c(1,2) / y
#' @seealso \link{inplace}
#'
NULL

#' @rdname Arithmetic
setMethod("+", c(e1 = "mmatrixOrMarray", e2 = "mvectorOrNumeric"), 
  function(e1, e2) {
    a <- copy(e1)
    inplace.sum(a, e2)
    a
  }
)

#' @rdname Arithmetic
setMethod("+", c(e1 = "mvectorOrNumeric", e2 = "mmatrixOrMarray"),
  function(e1, e2) {
    a <- copy(e2)
    inplace.sum(a, e1)
    a
  }
)

#' @rdname Arithmetic
setMethod("+", c(e1 = "mmatrixOrMarray", e2 = "array"), 
  function(e1, e2) {
    if(!same.dim(e1@dim, dim(e2))) stop("non-conformable arrays")
    a <- copy(e1)
    inplace.sum(a, e2)
    a
  }
)

#' @rdname Arithmetic
setMethod("+", c(e1 = "array", e2 = "mmatrixOrMarray"),
  function(e1, e2) {
    if(!same.dim(dim(e1), e2@dim)) stop("non-conformable arrays")
    a <- copy(e2)
    inplace.sum(a, e1)
    a
  }
)

#' @rdname Arithmetic
setMethod("+", c(e1 = "mmatrixOrMarray", e2 = "mmatrixOrMarray"), 
  function(e1, e2) {
    if(!same.dim(e1@dim, e2@dim)) stop("non-conformable arrays")
    a <- copy(e1)
    inplace.sum(a, e2)
    a
  }
)

## ---- substraction  ----

#' @rdname Arithmetic
setMethod("-", c(e1 = "mmatrixOrMarray", e2 = "mvectorOrNumeric"), 
  function(e1, e2) {
    a <- copy(e1)
    inplace.minus(a, e2)
    a
  }
)

#' @rdname Arithmetic
setMethod("-", c(e1 = "mvectorOrNumeric", e2 = "mmatrix"),
  function(e1, e2) {
    a <- mmatrix(e2@datatype, e2@dim[1], e2@dim[2])
    copy.values(a, e1)
    inplace.minus(a, e2)
    a
  }
)

#' @rdname Arithmetic
setMethod("-", c(e1 = "mvectorOrNumeric", e2 = "marray"),
  function(e1, e2) {
    a <- marray(e2@datatype, e2@dim)
    copy.values(a, e1)
    inplace.minus(a, e2)
    a
  }
)

#' @rdname Arithmetic
setMethod("-", c(e1 = "mmatrixOrMarray", e2 = "array"), 
  function(e1, e2) {
    if(!same.dim(e1@dim, dim(e2))) stop("non-conformable arrays")
    a <- copy(e1)
    inplace.minus(a, e2)
    a
  }
)

#' @rdname Arithmetic
setMethod("-", c(e1 = "matrix", e2 = "mmatrix"), 
  function(e1, e2) {
    if(!same.dim(e1@dim, dim(e2))) stop("non-conformable arrays")
    a <- mmatrix(e2@datatype, e2@dim)
    copy_values(a, e1)
    inplace.minus(a, e2)
    a
  }
)

#' @rdname Arithmetic
setMethod("-", c(e1 = "array", e2 = "marray"), 
  function(e1, e2) {
    if(!same.dim(e1@dim, dim(e2))) stop("non-conformable arrays")
    a <- marray(e2@datatype, e2@dim)
    copy_values(a, e1)
    inplace.minus(a, e2)
    a
  }
)

#' @rdname Arithmetic
setMethod("-", c(e1 = "mmatrixOrMarray", e2 = "mmatrixOrMarray"), 
  function(e1, e2) {
    if(!same.dim(e1@dim, e2@dim)) stop("non-conformable arrays")
    a <- copy(e1)
    inplace.minus(a, e2)
    a
  }
)

## ---- unary minus ----

#' @rdname Arithmetic
setMethod("-", c(e1 = "mmatrixOrMarray", e2 = "missing"), 
  function(e1, e2) {
    a <- copy(e1) 
    inplace.opposite(a)
    a
  }
)

## ---- multiplication ----

#' @rdname Arithmetic
setMethod("*", c(e1 = "mmatrixOrMarray", e2 = "mvectorOrNumeric"), 
  function(e1, e2) {
    a <- copy(e1)
    inplace.prod(a, e2)
    a
  }
)

#' @rdname Arithmetic
setMethod("*", c(e1 = "mvectorOrNumeric", e2 = "mmatrixOrMarray"),
  function(e1, e2) {
    a <- copy(e2)
    inplace.prod(a, e1)
    a
  }
)

#' @rdname Arithmetic
setMethod("*", c(e1 = "mmatrixOrMarray", e2 = "array"), 
  function(e1, e2) {
    if(!same.dim(e1@dim, dim(e2))) stop("non-conformable arrays")
    a <- copy(e1)
    inplace.prod(a, e2)
    a
  }
)

#' @rdname Arithmetic
setMethod("*", c(e1 = "array", e2 = "mmatrixOrMarray"),
  function(e1, e2) {
    if(!same.dim(dim(e1), e2@dim)) stop("non-conformable arrays")
    a <- copy(e2)
    inplace.prod(a, e1)
    a
  }
)

#' @rdname Arithmetic
setMethod("*", c(e1 = "mmatrixOrMarray", e2 = "mmatrixOrMarray"), 
  function(e1, e2) {
    if(!same.dim(e1@dim, e2@dim)) stop("non-conformable arrays")
    a <- copy(e1)
    inplace.prod(a, e2)
    a
  }
)

## ---- division  ----

#' @rdname Arithmetic
setMethod("/", c(e1 = "mmatrixOrMarray", e2 = "mvectorOrNumeric"), 
  function(e1, e2) {
    a <- copy(e1)
    inplace.div(a, e2)
    a
  }
)

#' @rdname Arithmetic
setMethod("/", c(e1 = "mvectorOrNumeric", e2 = "mmatrix"),
  function(e1, e2) {
    a <- mmatrix(e2@datatype, e2@dim[1], e2@dim[2])
    copy.values(a, e1)
    inplace.div(a, e2)
    a
  }
)

#' @rdname Arithmetic
setMethod("/", c(e1 = "mvectorOrNumeric", e2 = "marray"),
  function(e1, e2) {
    a <- marray(e2@datatype, e2@dim)
    copy.values(a, e1)
    inplace.div(a, e2)
    a
  }
)

#' @rdname Arithmetic
setMethod("/", c(e1 = "mmatrixOrMarray", e2 = "array"), 
  function(e1, e2) {
    if(!same.dim(e1@dim, dim(e2))) stop("non-conformable arrays")
    a <- copy(e1)
    inplace.div(a, e2)
    a
  }
)

#' @rdname Arithmetic
setMethod("/", c(e1 = "matrix", e2 = "mmatrix"), 
  function(e1, e2) {
    if(!same.dim(e1@dim, dim(e2))) stop("non-conformable arrays")
    a <- mmatrix(e2@datatype, e2@dim)
    copy_values(a, e1)
    inplace.div(a, e2)
    a
  }
)

#' @rdname Arithmetic
setMethod("/", c(e1 = "array", e2 = "marray"), 
  function(e1, e2) {
    if(!same.dim(e1@dim, dim(e2))) stop("non-conformable arrays")
    a <- marray(e2@datatype, e2@dim)
    copy_values(a, e1)
    inplace.div(a, e2)
    a
  }
)

#' @rdname Arithmetic
setMethod("/", c(e1 = "mmatrixOrMarray", e2 = "mmatrixOrMarray"), 
  function(e1, e2) {
    if(!same.dim(e1@dim, e2@dim)) stop("non-conformable arrays")
    a <- copy(e1)
    inplace.div(a, e2)
    a
  }
)


