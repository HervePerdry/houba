mk.array.descriptor.file <- function(path, dim, type, dimnames) {
  dir <- dirname(path)
  fil <- basename(path)
  if(dir == tempdir()) warning("Creating a descriptor file for an object stored in tmp directory")

  d <- sprintf("new(\"big.matrix.descriptor\", description = list(filename = \"%s\", ", fil)
  d <- paste0(d, sprintf("dirname = \"%s\",\n ", dir))
  d <- paste0(d, "dim = c(") 
  d <- paste0(d, paste(dim, collapse = ", "))
  d <- paste0(d, "), ")
  d <- paste0(d, sprintf("dimnames = %s,\n ", dput2string(dimnames)))
  d <- paste0(d, sprintf("type = \"%s\"))\n", type))

  desc.file <- paste0(path, ".desc")
  if(file.exists(desc.file)) {
    warning(desc.file, " already exists, won't erase")
    return(invisible(NULL))
  }
  cat(d, file = desc.file)
  invisible(desc.file)
}
