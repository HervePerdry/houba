extract_marray <- function(x, L, drop = TRUE) {
  d <- length(L)
  if(d != length(x@dim)) stop("Incorrect number of dimensions\n")
  tsize <- 1L # target size
  for(i in seq_along(L)) {
    if(!is.numeric(L[[i]])) {
      L[[i]] <- match(L[[i]], x@dimnames[[i]])
    } else {
      L[[i]] <- as.integer(L[[i]])
      if(any(L[[i]] < 0)) {
        L[[i]] <- (1:x@dim[i])[ L[[i]] ]
      }
    }
    tsize <- tsize * length(L[[i]])
  }
  L0 <- L
  L <- lapply(L, \(x) x- 1L)
  dims <- sapply(L, length)
  if(x@file == "") { # array is in memory: target in memory
    T <- marray(x@datatype, dims, "")
    extract_marray_to_marray(x@ptr, x@datatype, L, T@ptr)
    dimnames(T) <- dimnames_extract(x@dimnames, L0)
    drop_dimensions(T, drop)
  } else if(tsize > houba("max.size")) {
    T <- marray(x@datatype, dims)
    extract_marray_to_marray(x@ptr, x@datatype, L, T@ptr)
    dimnames(T) <- dimnames_extract(x@dimnames, L0)
    drop_dimensions(T, drop)
  } else {
    if(x@datatype == "float" | x@datatype == "double") {
      T <- array(NA_real_, dims)
    } else if(x@datatype == "integer" | x@datatype == "short") {
      T <- array(NA_integer_, dims)
    } else {
      stop("Unsupported data type")
    }
    extract_marray_to_R(x@ptr, x@datatype, L, T)
    dimnames(T) <- dimnames_extract(x@dimnames, L0)
    if(drop) drop(T) else T
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
setMethod("[", c(x = "marray", i = "numericOrCharacter", j = "numericOrCharacter", drop = "ANY"),
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
setMethod("[", c(x = "marray", i = "missing", j = "numericOrCharacter", drop = "ANY"),
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
setMethod("[", c(x = "marray", i = "numericOrCharacter", j = "missing", drop = "ANY"),
  function(x, i, j, ..., drop) {
    if(nargs() == 2L) { # appel de type x[i]
      extract_mmatrix_as_mvector(x, i)
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

