#' Get or set the (dimension) names of a memory-mapped object
#'
#' @param x A memory-mapped object.
#' @param value A list of character vectors (one for each dimension) or \code{NULL}.
#'
#' @return Return values are similar to the base methods.
#' 
#' @rdname dimnames
#' @export
setReplaceMethod("dimnames", c(x = "mmatrix", value = "listOrNULL"),
  function(x, value) {
    value <- dimnames_check(value, dim(x))
    x@dimnames <- value
    return(x)
  }
)

#' @name dimnames
#' @rdname dimnames
#'
#' @export
setMethod("dimnames", signature(x = "mmatrix"), function(x) x@dimnames)

