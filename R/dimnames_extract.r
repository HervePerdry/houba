
# L : une liste d'indice pour faire l'extraction
dimnames_extract <- function(dimnames, L) {
  if(is.null(dimnames)) return(NULL)

  if(length(dimnames) != length(L))
    stop("lengthes mismatch")

  R <- vector("list", length(dimnames))
  for(i in seq_along(dimnames)) {
    R[[i]] <- dimnames[[i]][ L[[i]] ]
  }
  R
} 
