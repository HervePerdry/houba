#' @rdname dimnames
#' @export
setReplaceMethod("names", c(x = "mvector", value = "characterOrNULL"),
  function(x, value) {
    value <- names_check(value, length(x))
    x@names <- value
    return(x)
  }
)

#' @rdname dimnames
#'
#' @export
setMethod("names", signature(x = "mvector"), function(x) x@names)

