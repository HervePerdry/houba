#include "MMatrix.h"
#include <cstdint> // for int16_t
#include <Rcpp.h>

// ------- values est un R vector -------------
// [[Rcpp::export]]
void setdims(SEXP pM, std::string datatype, Rcpp::IntegerVector value) {
  if (datatype == "float") { 
    Rcpp::XPtr<houba::MMatrix<float>> instanc(pM);
    instanc->setDim(value);
  } else if (datatype == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> instanc(pM);
    instanc->setDim(value);
  } else if (datatype == "integer") {
    Rcpp::XPtr<houba::MMatrix<int>> instanc(pM);
    instanc->setDim(value);
  } else if (datatype == "short") {
    Rcpp::XPtr<houba::MMatrix<int16_t>> instanc(pM);
    instanc->setDim(value);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

