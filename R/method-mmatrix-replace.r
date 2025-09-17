# ------------------ replacement is an R object --------------------

replace_value_mmatrix <- function(x, i, j, value) {
  if(x@readonly) stop("Read-only object")
  I <- as.integer(i) - 1L
  J <- as.integer(j) - 1L
  if(x@datatype == "float" | x@datatype == "double") {
    val <- as.double(value)
  } else if(x@datatype == "integer" | x@datatype == "short") {
    val <- as.integer(value)
  } else {
    stop("Unsupported data type")
  }
  set_values_mmatrix(x@ptr, x@datatype, I, J, value)
  x
}

#' @rdname extract 
setMethod("[<-", c(x = "mmatrix", i = "numeric", j = "numeric", value = "numeric"),
  function(x, i, j, ..., value) {
    if(...length() > 0) stop("Bad number of dimensions")
    replace_value_mmatrix(x, i, j, value)
  }
)

#' @rdname extract 
setMethod("[<-", c(x = "mmatrix", i = "missing", j = "numeric", value = "numeric"),
  function(x, i, j, ..., value) {
    if(...length() > 0) stop("Bad number of dimensions")
    replace_value_mmatrix(x, 1:nrow(x), j, value)
  }
)

#' @rdname extract 
setMethod("[<-", c(x = "mmatrix", i = "numeric", j = "missing", value = "numeric"),
  function(x, i, j, ..., value) {
    if(nargs() == 3L) { # appel x[i] <- value
      replace_value_mvector(x, i, value)
    } else {
      if(...length() > 0) stop("Bad number of dimensions")
      replace_value_mmatrix(x, i, 1:ncol(x), value)
    }
  }
)

#' @rdname extract 
setMethod("[<-", c(x = "mmatrix", i = "missing", j = "missing", value = "numeric"),
  function(x, i, j, ..., value) {
    if(...length() > 0) stop("Bad number of dimensions")
    copy_values(x, value)
  }
)


# --------------------------------- replacement is an mmatrix or an mvector

replace_value_mmatrix_mm <- function(x, i, j, value) {
  if(x@readonly) stop("Read-only object")
  I <- as.integer(i) - 1L
  J <- as.integer(j) - 1L
  set_values_mmatrix_mm(x@ptr, x@datatype, I, J, value@ptr, value@datatype)
  x
}

#' @rdname extract 
setMethod("[<-", c(x = "mmatrix", i = "numeric", j = "numeric", value = "memoryMapped"),
  function(x, i, j, ..., value) {
    if(...length() > 0) stop("Bad number of dimensions")
    replace_value_mmatrix_mm(x, i, j, value)
  }
)

#' @rdname extract 
setMethod("[<-", c(x = "mmatrix", i = "missing", j = "numeric", value = "memoryMapped"),
  function(x, i, j, ..., value) {
    if(...length() > 0) stop("Bad number of dimensions")
    replace_value_mmatrix_mm(x, 1:nrow(x), j, value)
  }
)

#' @rdname extract 
setMethod("[<-", c(x = "mmatrix", i = "numeric", j = "missing", value = "memoryMapped"),
  function(x, i, j, ..., value) {
    if(nargs() == 3L) { # appel x[i] <- value
      replace_value_mvector_mm(x, i, value)
    } else {
      if(...length() > 0) stop("Bad number of dimensions")
      replace_value_mmatrix_mm(x, i, 1:ncol(x), value)
    }
  }
)

#' @rdname extract 
setMethod("[<-", c(x = "mmatrix", i = "missing", j = "missing", value = "memoryMapped"),
  function(x, i, j, ..., value) {
    if(...length() > 0) stop("Bad number of dimensions")
    copy_values_mm(x, value)
  }
)
