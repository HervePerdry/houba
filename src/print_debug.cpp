#include "MMatrix.h"
#include <Rcpp.h>

// [[Rcpp::export]]
void print_debug(SEXP pM, std::string datatype) {
    //check if pM == null
    if (datatype == "float") { 
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    Rcpp::Rcout << instanc->getVerbosout();
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    Rcpp::Rcout << instanc->getVerbosout();
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    Rcpp::Rcout << instanc->getVerbosout();
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    Rcpp::Rcout << instanc->getVerbosout();
  } else {
    throw std::runtime_error("Unsupported datatypes for now !");
  }
}
