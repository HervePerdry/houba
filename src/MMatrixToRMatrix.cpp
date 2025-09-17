#include "MMatrix.h"
#include <Rcpp.h>

// I have to use SEXP as an argument because I don't 
// know which type houba::MMatrix is templated into...

// [[Rcpp::export]]
SEXP MMatrixToRMatrix(SEXP pM, std::string datatype) {
  if (datatype == "float") { 
    // comment faire un check plus délicat sur la validité du ptr vers la houba::MMatrix ?
    Rcpp::XPtr<houba::MMatrix<float>> instanc(pM);
    unsigned int ncol = instanc->ncol();
    unsigned int nrow = instanc->nrow();
    Rcpp::NumericMatrix R(nrow, ncol);

    for(unsigned int i = 0; i < nrow; i++) {
      for (unsigned int j = 0; j < ncol; ++j) {
        R(i, j) = (*instanc)(i, j); 
      }
    }
    return R;
  } else if (datatype == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> instanc(pM);
    unsigned int ncol = instanc->ncol();
    unsigned int nrow = instanc->nrow();
    Rcpp::NumericMatrix R(nrow, ncol);

    for(unsigned int i = 0; i < nrow; i++) {
      for (unsigned int j = 0; j < ncol; ++j) {
        R(i, j) = (*instanc)(i, j);
      }
    }
    return R;
  } else if (datatype == "integer") {
    Rcpp::XPtr<houba::MMatrix<int>> instanc(pM);
    unsigned int ncol = instanc->ncol();
    unsigned int nrow = instanc->nrow();
    Rcpp::IntegerMatrix R(nrow, ncol);

    for(unsigned int i = 0; i < nrow; i++) {
      for (unsigned int j = 0; j < ncol; ++j) {
        R(i, j) = (*instanc)(i, j); 
      }
    }
    return R;
  } else if (datatype == "short") {
    Rcpp::XPtr<houba::MMatrix<int16_t>> instanc(pM);
    unsigned int ncol = instanc->ncol();
    unsigned int nrow = instanc->nrow();
    Rcpp::IntegerMatrix R(nrow, ncol);

    for(unsigned int i = 0; i < nrow; i++) {
      for (unsigned int j = 0; j < ncol; ++j) {
        R(i, j) = (*instanc)(i, j); 
      }
    }
    return R;
  } else {
    throw std::runtime_error("Unsupported datatypes for now ! This mmatrix will not be translated.");
  }
}
