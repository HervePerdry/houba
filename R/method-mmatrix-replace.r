# ------------------ replacement is an R object --------------------

replace_value_mmatrix <- function(x, i, j, value) {
  if(x@readonly) stop("Read-only object")
  if(!is.numeric(i)) {
    I <- match(i, x@dimnames[[1]]) - 1L
  } else {
    if(any(i < 0)) i <- (1:x@dim[1])[i]
    I <- as.integer(i) - 1L
  }

  if(!is.numeric(j)) { 
    J <- match(j, x@dimnames[[2]]) - 1L
  } else {
    if(any(j < 0)) j <- (1:x@dim[2])[j]
    J <- as.integer(j) - 1L
  }

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
setMethod("[<-", c(x = "mmatrix", i = "numericOrCharacter", j = "numericOrCharacter", value = "numericOrArray"),
  function(x, i, j, ..., value) {
    if(...length() > 0) stop("Bad number of dimensions")
    replace_value_mmatrix(x, i, j, value)
  }
)

#' @rdname extract 
setMethod("[<-", c(x = "mmatrix", i = "missing", j = "numericOrCharacter", value = "numericOrArray"),
  function(x, i, j, ..., value) {
    if(...length() > 0) stop("Bad number of dimensions")
    replace_value_mmatrix(x, 1:nrow(x), j, value)
  }
)

#' @rdname extract 
setMethod("[<-", c(x = "mmatrix", i = "numericOrCharacter", j = "missing", value = "numericOrArray"),
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
setMethod("[<-", c(x = "mmatrix", i = "missing", j = "missing", value = "numericOrArray"),
  function(x, i, j, ..., value) {
    if(...length() > 0) stop("Bad number of dimensions")
    copy_values(x, value)
  }
)


# --------------------------------- replacement is an mmatrix or an mvector

replace_value_mmatrix_mm <- function(x, i, j, value) {
  if(x@readonly) stop("Read-only object")
  if(!is.numeric(i)) {
    I <- match(i, x@dimnames[[1]]) - 1L
  } else {
    if(any(i < 0)) i <- (1:x@dim[1])[i]
    I <- as.integer(i) - 1L
  }

  if(!is.numeric(j)) { 
    J <- match(j, x@dimnames[[2]]) - 1L
  } else {
    if(any(j < 0)) j <- (1:x@dim[2])[j]
    J <- as.integer(j) - 1L
  }

  set_values_mmatrix_mm(x@ptr, x@datatype, I, J, value@ptr, value@datatype)
  x
}

#' @rdname extract 
setMethod("[<-", c(x = "mmatrix", i = "numericOrCharacter", j = "numericOrCharacter", value = "memoryMapped"),
  function(x, i, j, ..., value) {
    if(...length() > 0) stop("Bad number of dimensions")
    replace_value_mmatrix_mm(x, i, j, value)
  }
)

#' @rdname extract 
setMethod("[<-", c(x = "mmatrix", i = "missing", j = "numericOrCharacter", value = "memoryMapped"),
  function(x, i, j, ..., value) {
    if(...length() > 0) stop("Bad number of dimensions")
    replace_value_mmatrix_mm(x, 1:nrow(x), j, value)
  }
)

#' @rdname extract 
setMethod("[<-", c(x = "mmatrix", i = "numericOrCharacter", j = "missing", value = "memoryMapped"),
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
