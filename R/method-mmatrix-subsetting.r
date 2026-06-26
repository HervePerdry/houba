extract_mmatrix <- function(x, i, j, drop = TRUE) {
  if(!is.numeric(i)) i <- match(i, x@dimnames[[1]])
  if(!is.numeric(j)) j <- match(j, x@dimnames[[2]])
  if(any(i < 0)) i <- (1:x@dim[1])[i]
  if(any(j < 0)) j <- (1:x@dim[2])[j]

  I <- as.integer(i) - 1L
  J <- as.integer(j) - 1L
  # target size
  tsize <- length(I) * length(J)
  if(x@file == "") { # it's memory so... keep it so
    T <- mmatrix(x@datatype, length(I), length(J), "")
    extract_mmatrix_to_mmatrix(x@ptr, x@datatype, I, J, T@ptr)
    dimnames(T) <- dimnames_extract(x@dimnames, list(i, j))
    drop_dimensions(T, drop)
  } else if(tsize > houba("max.size")) { # it's on disk, and large -> new file
    T <- mmatrix(x@datatype, length(I), length(J))
    extract_mmatrix_to_mmatrix(x@ptr, x@datatype, I, J, T@ptr)
    dimnames(T) <- dimnames_extract(x@dimnames, list(i, j))
    drop_dimensions(T, drop)
  } else { # it's on disk, and small -> convert to R object
    if(x@datatype == "float" | x@datatype == "double") {
      T <- matrix(NA_real_, length(I), length(J))
    } else if(x@datatype == "integer" | x@datatype == "short") {
      T <- matrix(NA_integer_, length(I), length(J))
    } else {
      stop("Unsupported data type")
    }
    extract_mmatrix_to_R(x@ptr, x@datatype, I, J, T)
    dimnames(T) <- dimnames_extract(x@dimnames, list(i, j))
    if(drop) drop(T) else T
  }
}

# ceci est un duplicat de extract_mvector sauf pour la gestion des noms...
# cette variante est appelée quand on fait x[1:2] sur une matrice, par exemple
extract_mmatrix_as_mvector <- function(x, i) {
  if(any(i < 0)) i <- (1:length(x))[i]
  I <- as.integer(i) - 1L
  # target size
  tsize <- length(I) 
  if(x@file == "") {
    T <- mvector(x@datatype, tsize, "")
    extract_mvector_to_mvector(x@ptr, x@datatype, I, T@ptr)
    T
  } else if(tsize > houba("max.size")) {
    T <- mvector(x@datatype, tsize)
    extract_mvector_to_mvector(x@ptr, x@datatype, I, T@ptr)
    T
  } else {
    if(x@datatype == "float" | x@datatype == "double") {
      T <- numeric(tsize)
    } else if(x@datatype == "integer" | x@datatype == "short") {
      T <- integer(tsize)
    } else {
      stop("Unsupported data type")
    }
    extract_mvector_to_R(x@ptr, x@datatype, I, T)
    T
  }
}

#' @rdname extract 
setMethod("[", c(x = "mmatrix", i = "numericOrCharacter", j = "numericOrCharacter", drop = "ANY"),
  function(x, i, j, ..., drop) {
    if(...length() > 0) stop("Bad number of dimensions")
    extract_mmatrix(x, i, j, drop)
  }
)

#' @rdname extract 
setMethod("[", c(x = "mmatrix", i = "missing", j = "numericOrCharacter", drop = "ANY"),
  function(x, i, j, ..., drop) {
    if(...length() > 0) stop("Bad number of dimensions")
    extract_mmatrix(x, 1:nrow(x), j, drop)
  }
)

#' @rdname extract 
setMethod("[", c(x = "mmatrix", i = "numericOrCharacter", j = "missing", drop = "ANY"),
  function(x, i, j, ..., drop) {
    if(nargs() == 2L) { # appel de type x[i]
      extract_mmatrix_as_mvector(x, i)
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



