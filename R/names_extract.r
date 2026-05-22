
# I : un vecteur d'indices pour faire l'extraction
names_extract <- function(names, I) {
  if(is.null(names)) return(NULL)
  names[I]
} 
