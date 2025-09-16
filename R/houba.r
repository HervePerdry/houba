#' Options for package houba
#'
#' @param ... options to be defined, using 'name = value', or name(s) of 
#' option(s) to get.
#'
#' @details \code{houba()} sends back the list of all options. \code{houba(option = value)} 
#' sets the option value. \code{houba("option")} sends back the value of an option.
#'
#' @details Currently the only supported option is "max.size". Use \code{houba("max.size")} to
#' to get its value and, for example, \code{houba(max.size = 1e3)}, to set it to 1000.
#'
#' @details When subsetting an mvector or an mmatrix, if the size of the resulting object 
#' is greater than `max.size`, then the result will be a memory mapped object (mvector or mmatrix),
#' else if will be a R object (vector or matrix).
#' The default value is 1e6.
#' Set `max.size` to `0` to always get a memory mapped object and to `Inf` to always get a R object.
#'
#' @return a named list with options values, or a single option value.
#'
#' @examples houba()
#' houba("maxsize")
#'
#' @export
houba <- function(...) {
  L <- list(...)
  if(length(L) == 0) return(as.list(houba.hop))
  naL <- names(L)
  R <- list()
  if(is.null(naL)) {
    for(x in unlist(L)) R[[x]] <- houba.hop[[x]]
    if(length(R) == 1) return(unlist(R)) else return(R)
  }
  naOpts <- ls(envir = houba.hop)
  for(i in seq_along(naL)) {
    if(naL[i] != "") {
      if(!(naL[i] %in% naOpts)) {
        warning(naL[i], " is not a known option")
        next
      }
      assign(naL[i], unname(L[[i]]), envir = houba.hop)
      R[[ naL[i] ]] <- L[[i]]
    } else {
      R[[ L[[i]] ]] <- houba.hop[[ L[[i]] ]]
    }
  }
  R
}

houba.hop <- new.env()
assign("max.size", 1e6, envir = houba.hop)
