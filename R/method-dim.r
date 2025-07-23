#' Change object dimensions
#'
#' @rdname dim
#' @name dim
#'
#' @param x a memory mapped object
#' @param value or \code{NULL} new dimensions
#'
#' @details The new dimensions must match the object size. This function can
#' change the class of the object, e.g. from mvector to mmatrix or the reverse.
#'
#' @details If the value is \code{NULL}, then \code{x} is translated to a \code{mvector}.
#' @examples x <- mvector("int", 6)
#' x[] <- 1:6
#' x
#' dim(x) <- 2:3
#' x
#' dim(x) <- NULL
#' x
#'
NULL

#' @rdname dim
setReplaceMethod("dim", c(x = "memoryMapped", value = "numeric"), 
  function(x, value) { 
    value <- as.integer(value)
    if(length(value) == 1L) { # vecteur
      value <- c(value, 1L)
      setdims(x@ptr, x@datatype, value)
      new("mvector", ptr = x@ptr, file = x@file, length = value[1], datatype = x@datatype, readonly = x@readonly)
    } else if(length(value) == 2L) { # matrix
      setdims(x@ptr, x@datatype, value)
      new("mmatrix", ptr = x@ptr, file = x@file, dim = value, datatype = x@datatype, readonly = x@readonly)
    } else if(length(value) > 2L) {
      setdims(x@ptr, x@datatype, value)
      new("marray", ptr = x@ptr, file = x@file, dim = value, datatype = x@datatype, readonly = x@readonly)
    }
  }
)

#' @rdname dim
setReplaceMethod("dim", c(x = "memoryMapped", value = "NULL"), 
  function(x, value) {
    if(is(x, "mvector")) return(x)
    value <- c(as.integer(prod(x@dim)), 1L)
    setdims(x@ptr, x@datatype, value)
    new("mvector", ptr = x@ptr, file = x@file, length = value[1], datatype = x@datatype, readonly = x@readonly)
  }
)

