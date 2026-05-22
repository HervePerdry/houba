mk.descriptor.file <- function(path, nrow, ncol, type, dimnames) {
  dir <- dirname(path)
  fil <- basename(path)
  if(dir == tempdir()) warning("Creating a descriptor file for an object stored in tmp directory")

  if(is.null(dimnames)) {
    rownames <- NULL
    colnames <- NULL 
  } else {
    rownames <- dimnames[[1]]
    colnames <- dimnames[[2]]
  }

  d <- sprintf("new(\"big.matrix.descriptor\", description = list(sharedType = \"FileBacked\",\n filename = \"%s\", ", fil)
  d <- paste0(d, sprintf("dirname = \"%s/\",\n ", dir))
  d <- paste0(d, sprintf("totalRows = %dL, totalCols = %dL,\n ", nrow, ncol))
  d <- paste0(d, sprintf("rowOffset = c(0, %dL), colOffset = c(0, %dL),\n ", nrow, ncol))
  d <- paste0(d, sprintf("nrow = %d, ncol = %d,\n ", nrow, ncol))
  d <- paste0(d, sprintf("rowNames = %s,\n ", dput2string(rownames)))
  d <- paste0(d, sprintf("colNames = %s,\n ", dput2string(colnames)))
  d <- paste0(d, sprintf("type = \"%s\", separated = FALSE))\n", type))

  desc.file <- paste0(path, ".desc")
  if(file.exists(desc.file)) {
    warning(desc.file, " already exists.")
    return(invisible(desc.file))
  }
  cat(d, file = desc.file)
  invisible(desc.file)
}

