#include "MMatrix.h"
#include <stdexcept> // for std::runtime_error
#include <Rcpp.h>

// [[Rcpp::export]]
SEXP link_marray(std::string datatype, std::string file, Rcpp::IntegerVector dim) {
  std::vector<size_t> dim_;
  for(size_t d : dim) dim_.push_back(d);

  if(datatype == "float") {
    Rcpp::XPtr<houba::MMatrix<float>> MMatrix_ptr(new houba::MMatrix<float>(file, dim_));
    return MMatrix_ptr;
  } else if(datatype == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> MMatrix_ptr(new houba::MMatrix<double>(file, dim_));
    return MMatrix_ptr;
  } else if(datatype == "integer") {
    Rcpp::XPtr<houba::MMatrix<int>> MMatrix_ptr(new houba::MMatrix<int>(file, dim_));
    return MMatrix_ptr;
  } else if(datatype == "short") {
    Rcpp::XPtr<houba::MMatrix<int16_t>> MMatrix_ptr(new houba::MMatrix<int16_t>(file, dim_));
    return MMatrix_ptr;
  } else {
    throw std::runtime_error("Type of mmatrix (" + datatype + ") is unimplemented");
  }
}
