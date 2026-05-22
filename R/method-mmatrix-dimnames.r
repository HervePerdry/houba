#' Get or set the dimension names of a mmatrix object
#'
#' @param x A mmatrix object.
#' @param value A list of character vectors (one for each dimension) or \code{NULL}.
#'
#' @name dimnames-set
#' @rdname dimnames
#'
#' @aliases dimnames<-,mmatrix-method
#' 
#' @return Return values are similar to the base methods.
#' 
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
#' @aliases dinames,mmatrix-method
#'
#' @export
setMethod("dimnames", signature(x = "mmatrix"), function(x) x@dimnames)

