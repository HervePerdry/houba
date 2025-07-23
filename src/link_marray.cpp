#include "MMatrix.h"
#include <stdexcept> // for std::runtime_error
#include <Rcpp.h>

// [[Rcpp::export]]
SEXP link_marray(std::string datatype, std::string file, Rcpp::IntegerVector dim) {
  std::vector<size_t> dim_;
  for(size_t d : dim) dim_.push_back(d);

  if(datatype == "float") {
    Rcpp::XPtr<MMatrix<float>> MMatrix_ptr(new MMatrix<float>(file, dim_));
    return MMatrix_ptr;
  } else if(datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> MMatrix_ptr(new MMatrix<double>(file, dim_));
    return MMatrix_ptr;
  } else if(datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> MMatrix_ptr(new MMatrix<int>(file, dim_));
    return MMatrix_ptr;
  } else if(datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> MMatrix_ptr(new MMatrix<int16_t>(file, dim_));
    return MMatrix_ptr;
  } else {
    throw std::runtime_error("Type of mmatrix (" + datatype + ") is unimplemented");
  }
}
