#' @rdname names
#' @export
setReplaceMethod("names", c(x = "mvector", value = "characterOrNULL"),
  function(x, value) {
    value <- names_check(value, length(x))
    x@names <- value
    return(x)
  }
)

#' @rdname names
#'
#' @export
setMethod("names", signature(x = "mvector"), function(x) x@names)

