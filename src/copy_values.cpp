#include "MMatrix.h"
#include <iostream>
#include <cstdint> // for int16_t
#include <Rcpp.h>

// ------- values est un R vector -------------
// [[Rcpp::export]]
void copy_values_(SEXP pM, std::string datatype, SEXP values) {
  if (datatype == "float") { 
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    Rcpp::NumericVector val(values);
    instanc->copy_values(val);
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    Rcpp::NumericVector val(values);
    instanc->copy_values(val);
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    Rcpp::IntegerVector val(values);
    instanc->copy_values(val);
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    Rcpp::IntegerVector val(values);
    instanc->copy_values(val);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

// --- values est un pointeur vers une mmatrix ---------

// d'abord un template pour éviter la répétition de code
// [TODO : généraliser ça, il y a plein d'endroits où un truc du genre est copié collé]
template<typename T> 
inline void copy_val(T instanc, SEXP values, std::string valtype) {
  if(valtype == "float") {
    Rcpp::XPtr<MMatrix<float>> val(values);
    instanc->copy_values(*val);
  } else if(valtype == "double") {
    Rcpp::XPtr<MMatrix<double>> val(values);
    instanc->copy_values(*val);
  } else if(valtype == "int") {
    Rcpp::XPtr<MMatrix<int>> val(values);
    instanc->copy_values(*val);
  } else if (valtype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> val(values);
    instanc->copy_values(*val);
  } else {
    throw std::runtime_error("Unsupported datatype for values for now !");
  }
}

// [[Rcpp::export]]
void copy_values_mm_(SEXP pM, std::string datatype, SEXP values, std::string valtype) {
  if (datatype == "float") { 
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    copy_val(instanc, values, valtype);
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    copy_val(instanc, values, valtype);
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    copy_val(instanc, values, valtype);
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    copy_val(instanc, values, valtype);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

