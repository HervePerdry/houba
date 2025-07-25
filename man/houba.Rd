% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/houba.r
\name{houba}
\alias{houba}
\title{Options for package houba}
\usage{
houba(...)
}
\arguments{
\item{...}{options to be defined, using 'name = value', or name(s) of 
option(s) to get.}
}
\description{
Options for package houba
}
\details{
\code{houba()} sends back the list of all options. \code{houba(option = value)} 
sets the option value. \code{houba("option")} sends back the value of an option.

Currently the only supported option is "max.size". Use \code{houba("max.size")} to
to get its value and, for example, \code{houba(max.size = 1e3)}, to set it to 1000.

When subsetting an mvector or an mmatrix, if the size of the resulting object 
is greater than `max.size`, then the result will be a memory mapped object (mvector or mmatrix),
else if will be a R object (vector or matrix).
The default value is 1e6.
Set `max.size` to `0` to always get a memory mapped object and to `Inf` to always get a R object.
}
\examples{
houba("maxsize")

}
