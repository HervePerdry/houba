#include "MMatrix.h"
#include <Rcpp.h>
#include "apply.h"
class trans {
  public:
    template<typename T>
    inline void operator()(Rcpp::XPtr<houba::MMatrix<T>> mat, Rcpp::XPtr<houba::MMatrix<T>> result) {

      // tester la transposition par block pour "maximize cache locality"
      // cf https://stackoverflow.com/questions/5200338/a-cache-efficient-matrix-transpose-program
      // avec éventuellement un #pragma omp parallel for collapse(2) 
      // pour qu'openmp collapse les deux boucles sur les blocks
      // J'AI TESTE (sans openmp), avec des blocs 32x32 : ça ne fonctionne pas bien du tout. 
      // J'ai dû louper quelque chose ? Ou bien la logique ne s'applique pas avec des mmap ?
      // autre solution : possible de le faire faire par Eigen avec des Map Matrix ?
      // voir aussi https://en.wikipedia.org/wiki/Cache-oblivious_algorithm

      unsigned int nr = mat->nrow();
      unsigned int nc = mat->ncol();
      if(nr != result->ncol() || nc != result->nrow())
        throw std::runtime_error("Dimensions mismatch");

      T * p_result = &((*result)[0]);
      T * p_mat = &((*mat)[0]);

      for(unsigned int i = 0; i < nr; i++) { // lignes de mat, cols de target
        for(unsigned int j = 0; j < nc; j++) { // cols de mat, rows de target
          // result[j, i] = mat[i, j]  
          p_result[j + i * nc] = p_mat[i + j * nr];
        }
      }
    }
};


// on suppose que pM et result on le meme type
// [[Rcpp::export]]
void transpose_to(SEXP pM, std::string datatype, SEXP result) {
  trans x;
  apply_mmatrix(pM, datatype, result, x);
}

