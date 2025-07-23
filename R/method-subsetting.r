extract_mmatrix <- function(x, i, j, drop = TRUE) {
  I <- as.integer(i) - 1L
  J <- as.integer(j) - 1L
  # target size
  tsize <- length(I) * length(J)
  if(tsize > houba("max.size")) {
    T <- mmatrix(x@datatype, length(I), length(J))
    extract_mmatrix_to_mmatrix(x@ptr, x@datatype, I, J, T@ptr)
    T
  } else {
    if(x@datatype == "float" | x@datatype == "double") {
      T <- matrix(NA_real_, length(I), length(J))
    } else if(x@datatype == "int" | x@datatype == "short") {
      T <- matrix(NA_integer_, length(I), length(J))
    } else {
      stop("Unsupported data type")
    }
    extract_mmatrix_to_R(x@ptr, x@datatype, I, J, T)
    if(drop & (nrow(T) == 1 | ncol(T) == 1)) 
      as.vector(T)
    else
      T
  }
}

extract_mvector <- function(x, i) {
  I <- as.integer(i) - 1L
  # target size
  tsize <- length(I) 
  if(tsize > houba("max.size")) {
    T <- mvector(x@datatype, tsize)
    extract_mvector_to_mvector(x@ptr, x@datatype, I, T@ptr)
    T
  } else {
    if(x@datatype == "float" | x@datatype == "double") {
      T <- numeric(tsize)
    } else if(x@datatype == "int" | x@datatype == "short") {
      T <- integer(tsize)
    } else {
      stop("Unsupported data type")
    }
    extract_mvector_to_R(x@ptr, x@datatype, I, T)
    T
  }
}

#' @rdname extract 
setMethod("[", c(x = "mmatrix", i = "numeric", j = "numeric", drop = "ANY"),
  function(x, i, j, ..., drop) {
    if(...length() > 0) stop("Bad number of dimensions")
    extract_mmatrix(x, i, j, drop)
  }
)

#' @rdname extract 
setMethod("[", c(x = "mmatrix", i = "missing", j = "numeric", drop = "ANY"),
  function(x, i, j, ..., drop) {
    if(...length() > 0) stop("Bad number of dimensions")
    extract_mmatrix(x, 1:nrow(x), j, drop)
  }
)

#' @rdname extract 
setMethod("[", c(x = "mmatrix", i = "numeric", j = "missing", drop = "ANY"),
  function(x, i, j, ..., drop) {
    if(nargs() == 2L) { # appel de type x[i]
      extract_mvector(x, i)
    } else {
      if(...length() > 0) stop("Bad number of dimensions")
      extract_mmatrix(x, i, 1:ncol(x), drop)
    }
  }
)

#' @rdname extract 
setMethod("[", c(x = "mmatrix", i = "missing", j = "missing", drop = "ANY"),
  function(x, i, j, ..., drop) {
    if(...length() > 0) stop("Bad number of dimensions")
    extract_mmatrix(x, 1:nrow(x), 1:ncol(x), drop)
  }
)

# -------------- methode pour les vecteurs, j toujours missing
              
#' @rdname extract 
setMethod("[", c(x = "mvector", i = "numeric", j = "missing", drop = "ANY"),
  function(x, i, j, ..., drop) {
    if(...length() > 0) stop("Bad number of dimensions")
    extract_mvector(x, i)
  }
)

# ceci fait une copie (selon la valeur de houba("max.size"))... pourquoi pas.

#' @rdname extract
setMethod("[", c(x = "mvector", i = "missing", j = "missing", drop = "ANY"),
  function(x, i, j, ..., drop) {
    if(...length() > 0) stop("Bad number of dimensions")
    extract_mvector(x, 1:x@length)
  }
)

