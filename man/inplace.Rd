% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/inplace.r
\name{inplace}
\alias{inplace}
\alias{inplace.inverse}
\alias{inplace.opposite}
\alias{inplace.sum}
\alias{inplace.sum,memoryMapped,numeric-method}
\alias{inplace.sum,memoryMapped,memoryMapped-method}
\alias{inplace.minus}
\alias{inplace.minus,memoryMapped,numeric-method}
\alias{inplace.minus,memoryMapped,memoryMapped-method}
\alias{inplace.prod}
\alias{inplace.prod,memoryMapped,numeric-method}
\alias{inplace.prod,memoryMapped,memoryMapped-method}
\alias{inplace.div}
\alias{inplace.div,memoryMapped,numeric-method}
\alias{inplace.div,memoryMapped,memoryMapped-method}
\title{In-place arithmetic operations}
\usage{
inplace.inverse(x)

inplace.opposite(x)

inplace.sum(x, y)

\S4method{inplace.sum}{memoryMapped,numeric}(x, y)

\S4method{inplace.sum}{memoryMapped,memoryMapped}(x, y)

inplace.minus(x, y)

\S4method{inplace.minus}{memoryMapped,numeric}(x, y)

\S4method{inplace.minus}{memoryMapped,memoryMapped}(x, y)

inplace.prod(x, y)

\S4method{inplace.prod}{memoryMapped,numeric}(x, y)

\S4method{inplace.prod}{memoryMapped,memoryMapped}(x, y)

inplace.div(x, y)

\S4method{inplace.div}{memoryMapped,numeric}(x, y)

\S4method{inplace.div}{memoryMapped,memoryMapped}(x, y)
}
\arguments{
\item{x}{a memory mapped object}

\item{y}{a R object or a memory mapped object}
}
\description{
In-place arithmetic operations
}
\details{
These functions will modify \code{x} in-place, performing
the operation indicated by their name.
}
\examples{
# 
}
