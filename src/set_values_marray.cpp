#include "MMatrix.h"
#include <iostream>
#include <cstdint> // for int16_t
#include <Rcpp.h>
#include "list2vec.h"

// ici values est un R vector
// [[Rcpp::export]]
void set_values_marray(SEXP pM, std::string datatype, Rcpp::List L, SEXP values) {
  std::vector<Rcpp::IntegerVector> IND;
  list2vec(L, IND);
  if (datatype == "float") { 
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    Rcpp::NumericVector val(values);
    instanc->set_values_array(IND, val);
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    Rcpp::NumericVector val(values);
    instanc->set_values_array(IND, val);
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    Rcpp::IntegerVector val(values);
    instanc->set_values_array(IND, val);
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    Rcpp::IntegerVector val(values);
    instanc->set_values_array(IND, val);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

// ici values est un pointeur vers une marray
// [[Rcpp::export]]
void set_values_marray_ma(SEXP pM, std::string datatype, Rcpp::List L, SEXP values, std::string valtype) {
  std::vector<Rcpp::IntegerVector> IND;
  list2vec(L, IND);
  if (datatype == "float") { 
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    if(valtype == "float") {
      Rcpp::XPtr<MMatrix<float>> val(values);
      instanc->set_values_array(IND, *val);
    } else if(valtype == "double") {
      Rcpp::XPtr<MMatrix<double>> val(values);
      instanc->set_values_array(IND, *val);
    } else if(valtype == "int") {
      Rcpp::XPtr<MMatrix<int>> val(values);
      instanc->set_values_array(IND, *val);
    } else if (valtype == "short") {
      Rcpp::XPtr<MMatrix<int16_t>> val(values);
      instanc->set_values_array(IND, *val);
    } else {
      throw std::runtime_error("Unsupported datatype for values for now !");
    }
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    if(valtype == "float") {
      Rcpp::XPtr<MMatrix<float>> val(values);
      instanc->set_values_array(IND, *val);
    } else if(valtype == "double") {
      Rcpp::XPtr<MMatrix<double>> val(values);
      instanc->set_values_array(IND, *val);
    } else if(valtype == "int") {
      Rcpp::XPtr<MMatrix<int>> val(values);
      instanc->set_values_array(IND, *val);
    } else if (valtype == "short") {
      Rcpp::XPtr<MMatrix<int16_t>> val(values);
      instanc->set_values_array(IND, *val);
    } else {
      throw std::runtime_error("Unsupported datatype for values for now !");
    }
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    if(valtype == "float") {
      Rcpp::XPtr<MMatrix<float>> val(values);
      instanc->set_values_array(IND, *val);
    } else if(valtype == "double") {
      Rcpp::XPtr<MMatrix<double>> val(values);
      instanc->set_values_array(IND, *val);
    } else if(valtype == "int") {
      Rcpp::XPtr<MMatrix<int>> val(values);
      instanc->set_values_array(IND, *val);
    } else if (valtype == "short") {
      Rcpp::XPtr<MMatrix<int16_t>> val(values);
      instanc->set_values_array(IND, *val);
    } else {
      throw std::runtime_error("Unsupported datatype for values for now !");
    }
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    if(valtype == "float") {
      Rcpp::XPtr<MMatrix<float>> val(values);
      instanc->set_values_array(IND, *val);
    } else if(valtype == "double") {
      Rcpp::XPtr<MMatrix<double>> val(values);
      instanc->set_values_array(IND, *val);
    } else if(valtype == "int") {
      Rcpp::XPtr<MMatrix<int>> val(values);
      instanc->set_values_array(IND, *val);
    } else if (valtype == "short") {
      Rcpp::XPtr<MMatrix<int16_t>> val(values);
      instanc->set_values_array(IND, *val);
    } else {
      throw std::runtime_error("Unsupported datatype for values for now !");
    }
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}


