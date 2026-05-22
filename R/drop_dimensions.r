
# x = marray ou mmatrix 
# on pourrait faire des méthodes "drop" mais est-ce bien nécessaire ?
drop_dimensions <- function(x, drop) {
  if(!drop) return(x)

  w <- which(x@dim == 1L)
  if(length(w) == 0) return(x) # rien à dropper

  if(length(w) == length(x@dim)) { # c'est un array ou une matrice avec un seul élément !
    dim(x) <- NULL    # ceci crée un mvector (non nommé)
    return(x)
  }

  # on commence par récupérer les dimnames
  dimnames <- if(is.null(x@dimnames)) NULL else x@dimnames[-w]

  # on modifie la dimension. Cette façon de faire supprime les noms
  # mais se charge de dégrader l'objet en mmatrix ou mvector au besoin
  dim(x) <- x@dim[-w] 
    
  # s'il n'y a pas de noms on peut s'arrêter là
  if(is.null(dimnames)) return(x)

  # sinon on remet les noms en place
  if(length(dimnames) == 1) # on a un vecteur
    x@names <- dimnames[[1]]
  else
    x@dimnames <- dimnames

  x
}
