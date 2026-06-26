
dimnames_check <- function(dimnames, dim.x) {
  if(is.null(dimnames)) return(NULL)

  if(length(dimnames) > length(dim.x))
    stop("length of 'dimnames' [", length(dimnames), "] must match that of 'dim' [", length(dim.x), "]")

  for(i in seq_along(dimnames)) {
    if(!is.null(dimnames[[i]]) && length(dimnames[[i]]) != dim.x[i])
      stop("length of 'dimnames' [", i, "] not equal to array extent")
  }

  # pour compléter par des NULL si trop court
  length(dimnames) <- length(dim.x)
  # on convertit en character
  lapply(dimnames, \(x) if(is.null(x)) x else as.character(x))
} 
