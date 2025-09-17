# ---------------- replacement is an R object

replace_value_mvector <- function(x, i, value) {
  if(x@readonly) stop("Read-only object")
  I <- as.integer(i) - 1L
  if(x@datatype == "float" | x@datatype == "double") val <- as.double(value)
  if(x@datatype == "integer" | x@datatype == "short" ) val <- as.integer(value)
  set_values_mmatrix(x@ptr, x@datatype, I, 0L, value)
  x
}

#' @rdname extract 
setMethod("[<-", c(x = "mvector", i = "numeric", j = "missing", value = "numeric"),
  function(x, i, j, ..., value) replace_value_mvector(x, i, value)
)

#' @rdname extract 
setMethod("[<-", c(x = "mvector", i = "missing", j = "missing", value = "numeric"),
  function(x, i, j, ..., value) copy_values(x, value)
)

# -------------------- replacement is a mvector / mmatrix

replace_value_mvector_mm <- function(x, i, value) {
  if(x@readonly) stop("Read-only object")
  I <- as.integer(i) - 1L
  set_values_mmatrix_mm(x@ptr, x@datatype, I, 0L, value@ptr, value@datatype)
  x
}

#' @rdname extract 
setMethod("[<-", c(x = "mvector", i = "numeric", j = "missing", value = "memoryMapped"),
  function(x, i, j, ..., value) replace_value_mvector_mm(x, i, value)
)

#' @rdname extract 
setMethod("[<-", c(x = "mvector", i = "missing", j = "missing", value = "memoryMapped"),
  function(x, i, j, ..., value) copy_values_mm(x, value)
)
