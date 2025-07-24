#include "MMatrix.h"
#include <Rcpp.h>

// ici values est un R vector
// [[Rcpp::export]]
void set_values_mmatrix(SEXP pM, std::string datatype, Rcpp::IntegerVector I, Rcpp::IntegerVector J, SEXP values) {
  if (datatype == "float") { 
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    Rcpp::NumericVector val(values);
    instanc->set_values_matrix(I, J, val);
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    Rcpp::NumericVector val(values);
    instanc->set_values_matrix(I, J, val);
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    Rcpp::IntegerVector val(values);
    instanc->set_values_matrix(I, J, val);
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    Rcpp::IntegerVector val(values);
    instanc->set_values_matrix(I, J, val);
   }
  else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

// ---- values est un pointeur vers une mmatrix

template <typename T> 
inline void set_val(T instanc, Rcpp::IntegerVector I, Rcpp::IntegerVector J, SEXP values, std::string valtype) {
  if(valtype == "float") {
    Rcpp::XPtr<MMatrix<float>> val(values);
    instanc->set_values_matrix(I, J, *val);
  } else if(valtype == "double") {
    Rcpp::XPtr<MMatrix<double>> val(values);
    instanc->set_values_matrix(I, J, *val);
  } else if(valtype == "int") {
    Rcpp::XPtr<MMatrix<int>> val(values);
    instanc->set_values_matrix(I, J, *val);
  } else if (valtype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> val(values);
    instanc->set_values_matrix(I, J, *val);
  } else {
    throw std::runtime_error("Unsupported datatype for values for now !");
  }
}


// [[Rcpp::export]]
void set_values_mmatrix_mm(SEXP pM, std::string datatype, Rcpp::IntegerVector I, Rcpp::IntegerVector J, SEXP values, std::string valtype) {
  if (datatype == "float") { 
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    set_val(instanc, I, J, values, valtype);
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    set_val(instanc, I, J, values, valtype);
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    set_val(instanc, I, J, values, valtype);
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    set_val(instanc, I, J, values, valtype);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}


