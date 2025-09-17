#include "MMatrix.h"
#include <Rcpp.h>

// [[Rcpp::export]]
void print_debug(SEXP pM, std::string datatype) {
  //check if pM == null
  if (datatype == "float") { 
    Rcpp::XPtr<houba::MMatrix<float>> instanc(pM);
    Rcpp::Rcout << instanc->getVerbosout();
  } else if (datatype == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> instanc(pM);
    Rcpp::Rcout << instanc->getVerbosout();
  } else if (datatype == "integer") {
    Rcpp::XPtr<houba::MMatrix<int>> instanc(pM);
    Rcpp::Rcout << instanc->getVerbosout();
  } else if (datatype == "short") {
    Rcpp::XPtr<houba::MMatrix<int16_t>> instanc(pM);
    Rcpp::Rcout << instanc->getVerbosout();
  } else {
    throw std::runtime_error("Unsupported datatypes for now !");
  }
}
