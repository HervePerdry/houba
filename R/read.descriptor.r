#' Read big memory descriptor file
#' 
#' @param basename basename of the file 
#' @param readonly \code{TRUE} by default, specifies if the object should be readonly
#' 
#' @details Creates a \code{mmatrix} or a \code{mvector} by reading a 'bigmemory' descriptor file.
#' The descriptor file name is obtained by appending ".desc" to the basename.
#' 
#' @seealso \link{add.descriptor.file}
#' 
#' @export
read.descriptor <- function(basename, readonly) {
    desc <- path.expand(paste0(basename, ".desc"))
    if(!file.exists(basename)) stop("file ", basename, " not found")
    if(!file.exists(desc)) stop("file ", desc, " not found")

    if(missing(readonly)) readonly <- TRUE

    z <- scan(desc, character(), Inf, quote = "", quiet = TRUE)
    parsed_desc <- eval(parse(text = paste( c( "(", z[ -(1:3) ] ), collapse = " " )))

    datatype <- parsed_desc$type
    file <- parsed_desc$file
    if (file != basename) {
        file = basename
    }
    dim <- as.integer(c(parsed_desc$nrow, parsed_desc$ncol))
    # I chose to send basename (and not file) bcos a check was made on it
    ptr <- link_mmatrix(datatype, basename, dim[1], dim[2])
    if (isnullptr(ptr)) stop("Failed to map the memory mapped object !")
    # if matrix with 1 col, I open it as a mvector
    if (dim[2] == 1L) {
        new("mvector", ptr = ptr, file = basename, length = dim[1], datatype = datatype, readonly = readonly)
    } else {
        new("mmatrix", ptr = ptr, file = basename, dim = dim, datatype = datatype, readonly = readonly)
    }
}