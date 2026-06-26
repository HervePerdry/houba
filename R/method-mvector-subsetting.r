extract_mvector <- function(x, i) {
  if(!is.numeric(i)) {
    i <- match(i, x@names)
  } else {
    if(any(i < 0)) i <- seq_along(x)[i]
  }

  I <- as.integer(i) - 1L
  # target size
  tsize <- length(I) 
  if(x@file == "") {
    T <- mvector(x@datatype, tsize, "")
    extract_mvector_to_mvector(x@ptr, x@datatype, I, T@ptr)
    names(T) <- names_extract(x@names, i)
    T
  } else if(tsize > houba("max.size")) {
    T <- mvector(x@datatype, tsize)
    extract_mvector_to_mvector(x@ptr, x@datatype, I, T@ptr)
    names(T) <- names_extract(x@names, i)
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
    names(T) <- names_extract(x@names, i)
    T
  }
}

# -------------- methodes pour les vecteurs, j toujours missing
            
#' @rdname extract 
setMethod("[", c(x = "mvector", i = "numericOrCharacter", j = "missing", drop = "ANY"),
  function(x, i, j, ..., drop) {
    if(...length() > 0) stop("Bad number of dimensions")
    extract_mvector(x, i)
  }
)


# x[] fait une copie (selon la valeur de houba("max.size"))... pourquoi pas.
#' @rdname extract
setMethod("[", c(x = "mvector", i = "missing", j = "missing", drop = "ANY"),
  function(x, i, j, ..., drop) {
    if(...length() > 0) stop("Bad number of dimensions")
    extract_mvector(x, 1:x@length)
  }
)

