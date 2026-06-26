#' @rdname dimnames-mmap
#' @export
setReplaceMethod("dimnames", c(x = "mmatrix", value = "listOrNULL"),
  function(x, value) {
    value <- dimnames_check(value, dim(x))
    x@dimnames <- value
    return(x)
  }
)

#' @rdname dimnames-mmap
#' @export
setMethod("dimnames", signature(x = "mmatrix"), function(x) x@dimnames)

