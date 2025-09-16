copy_values <- function(x, value) {
  if(x@readonly) stop("Read-only object")
  if(x@datatype %in% integer_types) 
    val <- as.integer(value)
  else
    val <- as.double(value)
  copy_values_(x@ptr, x@datatype, value)
  invisible(x)
}

copy_values_mm <- function(x, value) {
  if(x@readonly) stop("Read-only object")
  copy_values_mm_(x@ptr, x@datatype, value@ptr, value@datatype)
  invisible(x)
}
