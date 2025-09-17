extract_marray <- function(x, L, drop = TRUE) {
  d <- length(L)
  if(d != length(x@dim)) stop("Incorrect number of dimensions\n")
  tsize <- 1L # target size
  for(i in seq_along(L)) {
    L[[i]] <- as.integer(L[[i]]) - 1L
    tsize <- tsize * length(L[[i]])
  }
  dims <- sapply(L, length)
  if(tsize > houba("max.size")) {
    T <- marray(x@datatype, dims)
    extract_marray_to_marray(x@ptr, x@datatype, L, T@ptr)
    T
  } else {
    if(x@datatype == "float" | x@datatype == "double") {
      T <- array(NA_real_, dims)
    } else if(x@datatype == "integer" | x@datatype == "short") {
      T <- array(NA_integer_, dims)
    } else {
      stop("Unsupported data type")
    }
    extract_marray_to_R(x@ptr, x@datatype, L, T)
    if(drop & any(dims == 1)) {
      dims <- dims[ dims > 1 ]
      if(length(dim) > 0) 
        array(as.vector(T), dims)
      else 
        as.vector(T)
    } else {
      T
    }
  }
}


# a function to test if ...elt(k) objects are missing
myMissing <- function(x) { 
  r <- try( x, TRUE ); 
  if(is(r, "try-error")) {
    condition <- attr(r, "condition")
    if(is(condition, "missingArgError")) 
      TRUE
    else 
      stop(condition)
  } else {
    FALSE 
  }
}

#' @rdname extract 
setMethod("[", c(x = "marray", i = "numeric", j = "numeric", drop = "ANY"),
  function(x, i, j, ..., drop) {
    if(...length() != length(x@dim) - 2L)
      stop("Incorrect number of dimensions")
    L <- vector("list", length(x@dim))
    L[[1]] <- i
    L[[2]] <- j
    for(k in seq_len(...length())) {
      if(myMissing(...elt(k))) 
        L[[k + 2L]] <- 1:x@dim[k + 2L]
      else 
        L[[k + 2L]] <- ...elt(k)
    }
    extract_marray(x, L, drop)
  }
)

#' @rdname extract 
setMethod("[", c(x = "marray", i = "missing", j = "numeric", drop = "ANY"),
  function(x, i, j, ..., drop) { 
    if(...length() != length(x@dim) - 2L)
      stop("Incorrect number of dimensions")
    L <- vector("list", length(x@dim))
    L[[1]] <- 1:x@dim[1]
    L[[2]] <- j
    for(k in seq_len(...length())) {
      if(myMissing(...elt(k))) 
        L[[k + 2L]] <- 1:x@dim[k + 2L]
      else 
        L[[k + 2L]] <- ...elt(k)
    }
    extract_marray(x, L, drop)
  }
)

#' @rdname extract 
setMethod("[", c(x = "marray", i = "numeric", j = "missing", drop = "ANY"),
  function(x, i, j, ..., drop) {
    if(nargs() == 2L) { # appel de type x[i]
      extract_mvector(x, i)
    } else {
      if(...length() != length(x@dim) - 2L)
        stop("Incorrect number of dimensions")
      L <- vector("list", length(x@dim))
      L[[1]] <- i
      L[[2]] <- 1:x@dim[2]
      for(k in seq_len(...length())) {
        if(myMissing(...elt(k))) 
          L[[k + 2L]] <- 1:x@dim[k + 2L]
        else 
          L[[k + 2L]] <- ...elt(k)
      }
      extract_marray(x, L, drop)
    }
  }
)

#' @rdname extract 
setMethod("[", c(x = "marray", i = "missing", j = "missing", drop = "ANY"),
  function(x, i, j, ..., drop) { 
    # length = 0 correspond à un appel x[]
    if(...length() != 0 & ...length() != length(x@dim) - 2L)
      stop("Incorrect number of dimensions")
    L <- vector("list", length(x@dim))
    L[[1]] <- 1:x@dim[1]
    L[[2]] <- 1:x@dim[2]
    if(...length() == 0) { # x[]
      for(k in seq_len(length(x@dim) - 2L))
        L[[k + 2L]] <- 1:x@dim[k + 2L]
    } else {
      for(k in seq_len(...length())) {
        if(myMissing(...elt(k))) 
          L[[k + 2L]] <- 1:x@dim[k + 2L]
        else 
          L[[k + 2L]] <- ...elt(k)
      } 
    }
    extract_marray(x, L, drop)
  }
)

