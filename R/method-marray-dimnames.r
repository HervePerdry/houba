#' Get or set the (dimension) names of a memory-mapped object
#'
#' @rdname dimnames-mmap
#'
#' @param x A memory-mapped object.
#' @param value A list of character vectors (one for each dimension) or \code{NULL}.
#'
#' @return Return values are similar to the base methods.
#' 
#' @export
setReplaceMethod("dimnames", c(x = "marray", value = "listOrNULL"),
  function(x, value) {
    value <- dimnames_check(value, dim(x))
    x@dimnames <- value
    return(x)
  }
)

#' @rdname dimnames-mmap
#' @export
setMethod("dimnames", signature(x = "marray"), function(x) x@dimnames)

