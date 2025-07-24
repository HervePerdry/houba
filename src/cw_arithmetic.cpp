#include "MMatrix.h"
#include <cstdint> // for int16_t
#include <Rcpp.h>

// --- inverse et opposé 

// [[Rcpp::export]]
void cw_inverse(SEXP pM, std::string datatype) {
  if (datatype == "float") {
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    instanc->cw_inverse();
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    instanc->cw_inverse();
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    instanc->cw_inverse();
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    instanc->cw_inverse();
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

// [[Rcpp::export]]
void cw_opposite(SEXP pM, std::string datatype) {
  if (datatype == "float") {
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    instanc->cw_opposite();
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    instanc->cw_opposite();
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    instanc->cw_opposite();
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    instanc->cw_opposite();
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

// ------------ sum minus prod div, deuxième opérateur : objet R --------------------

// [[Rcpp::export]]
void cw_sum(SEXP pM, std::string datatype, SEXP e2_) {
  if (datatype == "float") {
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    Rcpp::NumericVector e2(e2_);
    instanc->cw_sum(e2);
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    Rcpp::NumericVector e2(e2_);
    instanc->cw_sum(e2);
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    Rcpp::IntegerVector e2(e2_);
    instanc->cw_sum(e2);
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    Rcpp::IntegerVector e2(e2_);
    instanc->cw_sum(e2);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

// [[Rcpp::export]]
void cw_minus(SEXP pM, std::string datatype, SEXP e2_) {
  if (datatype == "float") {
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    Rcpp::NumericVector e2(e2_);
    instanc->cw_minus(e2);
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    Rcpp::NumericVector e2(e2_);
    instanc->cw_minus(e2);
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    Rcpp::IntegerVector e2(e2_);
    instanc->cw_minus(e2);
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    Rcpp::IntegerVector e2(e2_);
    instanc->cw_minus(e2);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

// [[Rcpp::export]]
void cw_prod(SEXP pM, std::string datatype, SEXP e2_) {
  if (datatype == "float") {
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    Rcpp::NumericVector e2(e2_);
    instanc->cw_prod(e2);
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    Rcpp::NumericVector e2(e2_);
    instanc->cw_prod(e2);
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    Rcpp::IntegerVector e2(e2_);
    instanc->cw_prod(e2);
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    Rcpp::IntegerVector e2(e2_);
    instanc->cw_prod(e2);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

// [[Rcpp::export]]
void cw_div(SEXP pM, std::string datatype, SEXP e2_) {
  if (datatype == "float") {
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    Rcpp::NumericVector e2(e2_);
    instanc->cw_div(e2);
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    Rcpp::NumericVector e2(e2_);
    instanc->cw_div(e2);
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    Rcpp::IntegerVector e2(e2_);
    instanc->cw_div(e2);
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    Rcpp::IntegerVector e2(e2_);
    instanc->cw_div(e2);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

// ------------ sum minus prod div, deuxième opérateur : mmatrix --------------------

// sum
template <typename T>
inline void _cw_sum_(T instanc, SEXP e2, std::string type) {
  if(type == "float") {
    Rcpp::XPtr<MMatrix<float>> val(e2);
    instanc->cw_sum(*val);
  } else if(type == "double") {
    Rcpp::XPtr<MMatrix<double>> val(e2);
    instanc->cw_sum(*val);
  } else if(type == "int") {
    Rcpp::XPtr<MMatrix<int>> val(e2);
    instanc->cw_sum(*val);
  } else if (type == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> val(e2);
    instanc->cw_sum(*val);
  } else {
    throw std::runtime_error("Unsupported datatype for values for now !");
  }
}

// [[Rcpp::export]]
void cw_sum_mm(SEXP pM, std::string datatype, SEXP e2, std::string e2type) {
  if (datatype == "float") {
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    _cw_sum_(instanc, e2, e2type);
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    _cw_sum_(instanc, e2, e2type);
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    _cw_sum_(instanc, e2, e2type);
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    _cw_sum_(instanc, e2, e2type);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}


// minus
template <typename T>
inline void _cw_minus_(T instanc, SEXP e2, std::string type) {
  if(type == "float") {
    Rcpp::XPtr<MMatrix<float>> val(e2);
    instanc->cw_minus(*val);
  } else if(type == "double") {
    Rcpp::XPtr<MMatrix<double>> val(e2);
    instanc->cw_minus(*val);
  } else if(type == "int") {
    Rcpp::XPtr<MMatrix<int>> val(e2);
    instanc->cw_minus(*val);
  } else if (type == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> val(e2);
    instanc->cw_minus(*val);
  } else {
    throw std::runtime_error("Unsupported datatype for values for now !");
  }
}

// [[Rcpp::export]]
void cw_minus_mm(SEXP pM, std::string datatype, SEXP e2, std::string e2type) {
  if (datatype == "float") {
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    _cw_minus_(instanc, e2, e2type);
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    _cw_minus_(instanc, e2, e2type);
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    _cw_minus_(instanc, e2, e2type);
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    _cw_minus_(instanc, e2, e2type);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}


// prod
template <typename T>
inline void _cw_prod_(T instanc, SEXP e2, std::string type) {
  if(type == "float") {
    Rcpp::XPtr<MMatrix<float>> val(e2);
    instanc->cw_prod(*val);
  } else if(type == "double") {
    Rcpp::XPtr<MMatrix<double>> val(e2);
    instanc->cw_prod(*val);
  } else if(type == "int") {
    Rcpp::XPtr<MMatrix<int>> val(e2);
    instanc->cw_prod(*val);
  } else if (type == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> val(e2);
    instanc->cw_prod(*val);
  } else {
    throw std::runtime_error("Unsupported datatype for values for now !");
  }
}

// [[Rcpp::export]]
void cw_prod_mm(SEXP pM, std::string datatype, SEXP e2, std::string e2type) {
  if (datatype == "float") {
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    _cw_prod_(instanc, e2, e2type);
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    _cw_prod_(instanc, e2, e2type);
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    _cw_prod_(instanc, e2, e2type);
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    _cw_prod_(instanc, e2, e2type);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

// div
template <typename T>
inline void _cw_div_(T instanc, SEXP e2, std::string type) {
  if(type == "float") {
    Rcpp::XPtr<MMatrix<float>> val(e2);
    instanc->cw_div(*val);
  } else if(type == "double") {
    Rcpp::XPtr<MMatrix<double>> val(e2);
    instanc->cw_div(*val);
  } else if(type == "int") {
    Rcpp::XPtr<MMatrix<int>> val(e2);
    instanc->cw_div(*val);
  } else if (type == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> val(e2);
    instanc->cw_div(*val);
  } else {
    throw std::runtime_error("Unsupported datatype for values for now !");
  }
}

// [[Rcpp::export]]
void cw_div_mm(SEXP pM, std::string datatype, SEXP e2, std::string e2type) {
  if (datatype == "float") {
    Rcpp::XPtr<MMatrix<float>> instanc(pM);
    _cw_div_(instanc, e2, e2type);
  } else if (datatype == "double") {
    Rcpp::XPtr<MMatrix<double>> instanc(pM);
    _cw_div_(instanc, e2, e2type);
  } else if (datatype == "int") {
    Rcpp::XPtr<MMatrix<int>> instanc(pM);
    _cw_div_(instanc, e2, e2type);
  } else if (datatype == "short") {
    Rcpp::XPtr<MMatrix<int16_t>> instanc(pM);
    _cw_div_(instanc, e2, e2type);
  } else {
    throw std::runtime_error("Unsupported datatype for now !");
  }
}

