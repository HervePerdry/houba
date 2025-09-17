#' Read big memory descriptor file
#' 
#' @param descriptor name of descriptor file 
#' @param readonly \code{TRUE} by default, specifies if the object should be readonly
#' 
#' @details Creates a memory-mapped object by reading a 'bigmemory'-like descriptor file.
#' 
#' @seealso \link{descriptor.file}
#'
#' @return a mvector or a mmatrix
#'
#' @examples A <- mmatrix("short", 10, 20)
#' A[] <- sample.int(200)
#' 
#' # create descriptor file 
#' dsc <- descriptor.file(A)
#' 
#' # linking file to other object
#' B <- read.descriptor(dsc, readonly = FALSE)
#' all(as.matrix(A) == as.matrix(B)) # TRUE
#' 
#' B[1:10] <- 0
#' all(A[1:10] == 0) # TRUE
#'
#' @export
read.descriptor <- function(descriptor, readonly) {
  desc <- path.expand(descriptor)
  if(!file.exists(desc)) stop("file ", desc, " not found")

  if(missing(readonly)) readonly <- TRUE

  z <- scan(desc, character(), Inf, quote = "", quiet = TRUE)
  parsed_desc <- eval(parse(text = paste( c( "(", z[ -(1:3) ] ), collapse = " " )))

  datatype <- parsed_desc$type
  file <- file.path( parsed_desc$dirname, parsed_desc$filename )

  if("dim" %in% names(parsed_desc)) 
    dim <- as.integer(parsed_desc$dim)
  else
    dim <- as.integer(c(parsed_desc$nrow, parsed_desc$ncol))
 
  ptr <- link_marray(datatype, file, dim)

  if (isnullptr(ptr)) stop("Failed to map the memory mapped object !")
  # if matrix with 1 col, I open it as a mvector
  if(length(dim) > 2) {
    new("marray", ptr = ptr, file = file, dim = dim, datatype = datatype, readonly = readonly)
  } else if(dim[2] == 1L) {
    new("mvector", ptr = ptr, file = file, length = dim[1], datatype = datatype, readonly = readonly)
  } else {
    new("mmatrix", ptr = ptr, file = file, dim = dim, datatype = datatype, readonly = readonly)
  }
}
