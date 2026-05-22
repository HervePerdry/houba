#' @rdname dimnames
#' @aliases dimnames<-,marray-method
#' @export
setReplaceMethod("dimnames", c(x = "marray", value = "listOrNULL"),
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
setMethod("dimnames", signature(x = "marray"), function(x) x@dimnames)

