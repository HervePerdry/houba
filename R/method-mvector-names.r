#' @rdname dimnames-mmap
#' @export
setReplaceMethod("names", c(x = "mvector", value = "characterOrNULL"),
  function(x, value) {
    value <- names_check(value, length(x))
    x@names <- value
    return(x)
  }
)

#' @rdname dimnames-mmap
#' @export
setMethod("names", signature(x = "mvector"), function(x) x@names)

