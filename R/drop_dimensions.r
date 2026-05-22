
# x = marray ou mmatrix 
# on pourrait faire des méthodes "drop" mais est-ce bien raisonnable ?
drop_dimensions <- function(x, drop) {
  if(drop) {
    w <- which(x@dim == 1L)
    if(length(w) == length(x@dim)) { # un seul élément !
      dim(x) <- NULL    # ceci crée un mvector (non nommé)
      return(x)
    }
    x@dim <- x@dim[-w]
    if(!is.null(x@dimnames)) x@dimnames <- x@dimnames[-w]
    if(length(x@dim == 1)) { # une matrice avec une seule dimension ne doit pas exister
      nn <- if(is.null(x@dimnames)) NULL else x@dimnames[[1]]
      dim(x) <- NULL  # crée un mvector
      x@names <- nn   # on utilise les noms qu'on a récupérés
    }
  }
  x
}
