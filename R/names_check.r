
names_check <- function(names, length.x) {
  if(is.null(names)) return(NULL)

  if(length(names) > length.x)
    stop("length of 'names' [", length(names), "] must match that of vector [", length.x, "]")

  # pour compléter par des NA si trop court
  names <- names[seq_len(length.x)]
  # on convertit en character
  as.character(names)
} 
