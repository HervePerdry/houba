#include "MMatrix.h"
#include <cstdint> // for int16_t
#include <Rcpp.h>
#include "list2vec.h"

// pM est un pointeur une houba::MMatrix de type donné par datatype
// ici values est un R vector de type Numeric ou Integer
// [[Rcpp::export]]
void set_values_marray(SEXP pM, std::string datatype, Rcpp::List L, SEXP values) {
  std::vector<Rcpp::IntegerVector> IND;
  list2vec(L, IND);
  if (datatype == "float") { 
    Rcpp::XPtr<houba::MMatrix<float>> instanc(pM);
    Rcpp::NumericVector val(values);
    instanc->set_values_array(IND, val);
  } else if (datatype == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> instanc(pM);
    Rcpp::NumericVector val(values);
    instanc->set_values_array(IND, val);
  } else if (datatype == "integer") {
    Rcpp::XPtr<houba::MMatrix<int>> instanc(pM);
    Rcpp::IntegerVector val(values);
    instanc->set_values_array(IND, val);
  } else if (datatype == "short") {
    Rcpp::XPtr<houba::MMatrix<int16_t>> instanc(pM);
    Rcpp::IntegerVector val(values);
    instanc->set_values_array(IND, val);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}


// ici values est un pointeur vers une marray de même type que pM
// [[Rcpp::export]]
void set_values_marray_ma(SEXP pM, std::string datatype, Rcpp::List L, SEXP values, std::string valtype) {
  std::vector<Rcpp::IntegerVector> IND;
  list2vec(L, IND);
  if (datatype == "float") { 
    Rcpp::XPtr<houba::MMatrix<float>> instanc(pM);
    if(valtype == "float") {
      Rcpp::XPtr<houba::MMatrix<float>> val(values);
      instanc->set_values_array(IND, *val);
    } else if(valtype == "double") {
      Rcpp::XPtr<houba::MMatrix<double>> val(values);
      instanc->set_values_array(IND, *val);
    } else if(valtype == "integer") {
      Rcpp::XPtr<houba::MMatrix<int>> val(values);
      instanc->set_values_array(IND, *val);
    } else if (valtype == "short") {
      Rcpp::XPtr<houba::MMatrix<int16_t>> val(values);
      instanc->set_values_array(IND, *val);
    } else {
      throw std::runtime_error("Unsupported datatype for values for now !");
    }
  } else if (datatype == "double") {
    Rcpp::XPtr<houba::MMatrix<double>> instanc(pM);
    if(valtype == "float") {
      Rcpp::XPtr<houba::MMatrix<float>> val(values);
      instanc->set_values_array(IND, *val);
    } else if(valtype == "double") {
      Rcpp::XPtr<houba::MMatrix<double>> val(values);
      instanc->set_values_array(IND, *val);
    } else if(valtype == "integer") {
      Rcpp::XPtr<houba::MMatrix<int>> val(values);
      instanc->set_values_array(IND, *val);
    } else if (valtype == "short") {
      Rcpp::XPtr<houba::MMatrix<int16_t>> val(values);
      instanc->set_values_array(IND, *val);
    } else {
      throw std::runtime_error("Unsupported datatype for values for now !");
    }
  } else if (datatype == "integer") {
    Rcpp::XPtr<houba::MMatrix<int>> instanc(pM);
    if(valtype == "float") {
      Rcpp::XPtr<houba::MMatrix<float>> val(values);
      instanc->set_values_array(IND, *val);
    } else if(valtype == "double") {
      Rcpp::XPtr<houba::MMatrix<double>> val(values);
      instanc->set_values_array(IND, *val);
    } else if(valtype == "integer") {
      Rcpp::XPtr<houba::MMatrix<int>> val(values);
      instanc->set_values_array(IND, *val);
    } else if (valtype == "short") {
      Rcpp::XPtr<houba::MMatrix<int16_t>> val(values);
      instanc->set_values_array(IND, *val);
    } else {
      throw std::runtime_error("Unsupported datatype for values for now !");
    }
  } else if (datatype == "short") {
    Rcpp::XPtr<houba::MMatrix<int16_t>> instanc(pM);
    if(valtype == "float") {
      Rcpp::XPtr<houba::MMatrix<float>> val(values);
      instanc->set_values_array(IND, *val);
    } else if(valtype == "double") {
      Rcpp::XPtr<houba::MMatrix<double>> val(values);
      instanc->set_values_array(IND, *val);
    } else if(valtype == "integer") {
      Rcpp::XPtr<houba::MMatrix<int>> val(values);
      instanc->set_values_array(IND, *val);
    } else if (valtype == "short") {
      Rcpp::XPtr<houba::MMatrix<int16_t>> val(values);
      instanc->set_values_array(IND, *val);
    } else {
      throw std::runtime_error("Unsupported datatype for values for now !");
    }
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}


