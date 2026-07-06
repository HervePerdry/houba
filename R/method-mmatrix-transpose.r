#' Matrix Transpose
#'
#' @export
setGeneric("transpose", function(x, filename) standardGeneric("transpose"))

#' @export
setMethod("transpose", "mmatrix", function(x, filename) {
    if(!missing(filename) && file.exists("filename"))
      stop("file ", filename, " already exists!")
    # if in memory, stay in memory
    if(x@file == "") filename <- ""
    T <- mmatrix(x@datatype, nrow = ncol(x), ncol = nrow(x), filename = filename)
    transpose_to(x@ptr, x@datatype, T@ptr)
    rownames(T) <- colnames(x)
    colnames(T) <- rownames(x)
    T
  }
)

#' @export
setMethod("t", c(x = "mmatrix"), function(x) transpose(x))


