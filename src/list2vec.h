#include <Rcpp.h>

// L = Rcpp::List dont tous les éléments sont des Rcpp::IntegerVector
// R = std::vector de Rcpp::IntegerVector

// copie L dans R et renvoie la dimension du résultat
inline Rcpp::IntegerVector list2vec_dim(Rcpp::List L, std::vector<Rcpp::IntegerVector> & R) {
  R.clear();
  R.reserve(L.size());
  std::vector<int> dim;
  dim.reserve(L.size());
  for(Rcpp::IntegerVector I : L) {
    R.push_back(I);
    dim.push_back(I.size());
  }
  return Rcpp::wrap(dim);
}

// copie L dans R, pas de calcul de dimensions
inline void list2vec(Rcpp::List L, std::vector<Rcpp::IntegerVector> & R) {
  R.clear();
  R.reserve(L.size());
  for(Rcpp::IntegerVector I : L) {
    R.push_back(I);
  }
}

