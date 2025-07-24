#ifndef MMATRIX_METHOD_H
#define MMATRIX_METHOD_H

#include <fstream> // for ofstream, loading the file
#include <sstream> // for verbosout
#include <stdexcept>
#include <system_error> // for std::error_code

#include "mio.hpp"

// Helper function for the c°
template <typename T>
void MMatrix<T>::FileHandler(std::string path, size_t matrix_size, bool verbose, bool authorize_resize) {
  /* FIRST : check if file exists, if it does not, create one of the good size*/
    const char * path_c = path.c_str();
    FILE *check = fopen(path_c, "rb"); // open en readonly 

    if (!check)
    {
        if (verbose_) verbosout_ << "The file " << path << " does not exist, creating one ...  ";
        std::ofstream newfile(path, std::ios::binary); // to load with \0
        if (!newfile || !newfile.is_open())
        {
            throw std::runtime_error("Failed to open the file;");
        }
        /* Writing a null byte to the end of the file
        after using seekp to the before last byte will
        ensure we have a non-empty file of the desired size
        without loading it into memory */
        newfile.seekp(matrix_size - 1);
        newfile.put('\0');
        // mio will reopen it
        newfile.close();
        if (verbose_) verbosout_ << "Done !" << std::endl;
    }
    else {
        if (verbose_) {
            verbosout_ << "Using and potentially overwritting already existing " << path << std::endl;
        }
        fclose(check);

        // from https://stackoverflow.com/questions/238603/how-can-i-get-a-files-size-in-c
        struct stat buf;
        if (stat(path_c, &buf) != 0) {
            throw std::runtime_error("Failed to analyse file: " + path);
        }
        off_t file_size = buf.st_size;
        if (file_size != matrix_size) {
            if (!authorize_resize) throw std::runtime_error("The file size doesn't match the matrix size ! Use the \"authorise_resize\" to force a resize.");
            if (verbose) {
                verbosout_ << "Resizing file from " << file_size << " to " << matrix_size << " bytes." << std::endl;
            }

            if (matrix_size > file_size) {
                std::fstream resize_file(path, std::ios::binary | std::ios::in | std::ios::out );
                if (!resize_file.is_open()) {
                    throw std::runtime_error("Failed to reopen file for resizing.");
                }
                //same as creating one with good size
                resize_file.seekp(matrix_size - 1);
                resize_file.put('\0');
                resize_file.close();
            } else {
                // trim it down
                if (truncate(path_c, matrix_size) != 0) {
                    throw std::runtime_error("Failed to truncate file: " + path);
                }
            }
        }
    }

    std::error_code error;
    matrix_file_ = mio::make_mmap_sink(path, 0, mio::map_entire_file, error);
    
    if (error)
    {
        std::string errMsg = "Error code " + std::to_string(error.value())
            + ", Failed to map the file : " + error.message();
        throw std::runtime_error(errMsg);
    }

    if (matrix_file_.empty() || matrix_file_.data() == nullptr) {
        throw std::runtime_error("Memory mapping failed: no data mapped.");
    }

    data_ptr_ = reinterpret_cast<T *>(matrix_file_.data());

    if (verbose_) {
        verbosout_ << "An MMatrix was successfuly created.\nfrom file :" << path << "\n and with "<< dim_.size() << " dims : [" 
        << nrow_  << ", " << ncol_ << "] (nrow, ncol) \n";
    }
}

// Constructor HARDCODED FOR A 2 DIM MMATRIX ! opening the file containing the matrix if path exists, also resizing it accordingly, else
// creating one. 
// TODO : check if logical sense for nrow first and ncol last ?
template <typename T>
MMatrix<T>::MMatrix(std::string path, size_t nrow, size_t ncol, bool verbose, bool authorize_resize)
    : ncol_(ncol), nrow_(nrow), path_(path), verbose_(verbose), dim_{nrow, ncol}
{
    size_ = ncol * nrow;
    if (!size_) throw std::invalid_argument("Ncol or Nrow is equal to 0, cannot map an empty file !");
    size_t matrix_size = size_ * sizeof(T);
    FileHandler(path, matrix_size, verbose, authorize_resize);
}


// constructor for array
template <typename T>
MMatrix<T>::MMatrix(std::string path, std::vector<size_t> dims, bool verbose, bool authorize_resize) 
// ! if it is not a matrix (dim.size != 2) ncol & nrow ARE NOT USED !!!
: ncol_(0), nrow_(0), path_(path), dim_{dims}, verbose_(verbose)
{
    size_ = 1;
    for (size_t d : dims) {
        size_ *= d;
    }
    if (!size_) throw std::invalid_argument("One of your dimension is equal to 0, cannot map an empty file !");
    size_t matrix_size = size_ * sizeof(T);

    if (dim_.size() == 2) {
        if (verbose_ == true) verbosout_ << "You are creating a matrix (2dims) with the array style c°.\n";
        nrow_ = dim_[0];
        ncol_ = dim_[1];
    }
    FileHandler(path, matrix_size, verbose, authorize_resize);
}

// Destructor flushing changes to disk before unmapping
template <typename T>
MMatrix<T>::~MMatrix()
{
    if (verbose_ == true) verbosout_ << "Unmapping mmatrix " << path_ << std::endl;
    std::error_code error;
    if (matrix_file_.is_mapped())
    {
        matrix_file_.sync(error);
        if (error)
        {
            // here no exception not to disturb the unstacking
            verbosout_ << "ERROR : in MMatrix destructor : Failed to unsync the file " << path_ << ": " << error.message()
                      << '\n';
        }
        matrix_file_.unmap();
    }
}

// Getters for nrow, ncol, size, path, data_ptr, dim, verbose
template <typename T>
size_t MMatrix<T>::nrow() const
{
    return nrow_;
}
template <typename T>
size_t MMatrix<T>::ncol() const
{
    return ncol_;
}
template <typename T>
size_t MMatrix<T>::size() const
{
    return size_;
}
template <typename T>
std::string MMatrix<T>::path() const
{
    return path_;
}
template <typename T>
T *MMatrix<T>::data() const
{
    return data_ptr_;
}
template <typename T>
std::vector<size_t> MMatrix<T>::dim() const {
    return dim_;
}
template <typename T>
bool MMatrix<T>::verbose() const
{
    return verbose_;
}
template <typename T>
std::string MMatrix<T>::getVerbosout() const {
    return verbosout_.str();
}


// Setter for dimension
template <typename T>
template <typename intVec>
void MMatrix<T>::setDim(intVec newdims) {
  // check if new dimensions are compatible with file size
  size_t size = 1;
  for (size_t d : newdims) {
    size *= d;
  }
  if(size != size_)  
    throw std::runtime_error("Dimensions product does not match the size of object"); 
  // resize !
  dim_.clear();
  for(size_t d : newdims) dim_.push_back(d);
  if(dim_.size() == 2) {
    nrow_ = dim_[0];
    ncol_ = dim_[1];
  } else {
    nrow_ = 0;
    ncol_ = 0;
  }
}

// ----------------- operator [] --------------------------
// Operator [] gives back the data at index, UNSAFE.
template <typename T>
T &MMatrix<T>::operator[](size_t ind)
{
    return data_ptr_[ind];
}

template <typename T>
const T &MMatrix<T>::operator[](size_t ind) const
{
    return data_ptr_[ind];
}

// ----------------- operator () --------------------------
// data at row i, col j
template <typename T>
T &MMatrix<T>::operator()(size_t i, size_t j)
{
    return data_ptr_[(j * nrow_) + i];
}

template <typename T>
const T &MMatrix<T>::operator()(size_t i, size_t j) const
{
    return data_ptr_[(j * nrow_) + i];
}

// for arrays
template <typename T>
template <typename intVec>
T &MMatrix<T>::operator()(const intVec & index) {
    int k = index[0];
    int l = 1;
    for(size_t i = 1; i < dim_.size(); i++) {
      l *= dim_[i-1];
      k += l * index[i];
    }
    return data_ptr_[k];
}

template <typename T>
template <typename intVec>
const T &MMatrix<T>::operator()(const intVec & index) const {
    int k = index[0];
    int l = 1;
    for(size_t i = 1; i < dim_.size(); i++) {
      l *= dim_[i-1];
      k += l * index[i];
    }
    return data_ptr_[k];
}


// -------------------- at ---------------------
// Same as operators [] and () but safe, with bound checking.
// Can be used with one (like []) or two parameters.
template <typename T>
T &MMatrix<T>::at(size_t ind) const
{
    if (ind >= size_)
    {
        throw std::out_of_range("Index out of range");
    }
    return data_ptr_[ind];
}

template <typename T>
T &MMatrix<T>::at(size_t i, size_t j) const
{
    // so will fail if more than 2 dims
    if (!ncol_ || !nrow_ || i >= nrow_ || j >= ncol_ )
        throw std::out_of_range("Index out of range");
    return data_ptr_[(j * nrow_) + i];
}

template <typename T>
template <typename intVec>
T &MMatrix<T>::at(const intVec & index) const {
    if (index.size() != dim_.size()) {
        throw std::invalid_argument("Index given does not match matrix dimensions.");
    }
    // should also do a check with this.size() ?
    if(index[0] >= dim_[0]) throw std::out_of_range("Index out of range");
    int k = index[0];
    int l = 1;
    for(size_t i = 1; i < dim_.size(); i++) {
      if(index[i] >= dim_[i]) throw std::out_of_range("Index out of range");
      l *= dim_[i-1];
      k += l * index[i];
    }
    return data_ptr_[k];
}

// ------------------- copy values ---------------------
template <typename T>
template <typename Tvec>
void MMatrix<T>::copy_values(Tvec & values) {
  size_t vs = values.size();
  for(size_t i = 0; i < size_; i++) {
    if(i >= size_) throw std::out_of_range("Index out of range");
    data_ptr_[i] = values[ i % vs ];
  }
}
 

// ------------------- set values ---------------------
// matrix
template <typename T>
template <typename intVec, typename Tvec>
void MMatrix<T>::set_values_matrix(const intVec & I, const intVec & J, Tvec & values) {
  if(!ncol_ || !nrow_)
    throw std::runtime_error("Not a matrix");

  size_t vs = values.size();

  size_t k = 0;
  for(size_t j : J) {
    if(j >= ncol_) throw std::out_of_range("Index out of range");
    size_t offset = j*nrow_;
    for(size_t i : I) {
      if(i >= nrow_) throw std::out_of_range("Index out of range");
      data_ptr_[offset + i] = values[ (k++) % vs ];
    }
  }
}

// array
template <typename T>
template <typename intVec, typename Tvec>
void MMatrix<T>::set_values_array(const std::vector<intVec> & I, Tvec & values) {
  if(I.size() != dim_.size())
    throw std::runtime_error("Bad number of dimensions");

  size_t vs = values.size();

  std::vector<size_t> ind;
  indices(I, ind);
  size_t k = 0;
  for(size_t i : ind) {
    if(i >= size_) throw std::out_of_range("Index out of range");
    data_ptr_[i] = values[ (k++) % vs ];
  }
}


// ------------------------ extractions ----------------------
// vector
template <typename T>
template <typename intVec, typename targetVec>
void MMatrix<T>::extract_vector(const intVec & I, targetVec & target) const {
  if(I.size() != target.size())
    throw std::runtime_error("Bad target size");

  size_t k = 0;
  for(size_t i : I) {
    if(i >= size_) throw std::out_of_range("Index out of range");
    target[k++] = data_ptr_[i];
  }
}

// matrix
template <typename T>
template <typename intVec, typename targetVec>
void MMatrix<T>::extract_matrix(const intVec & I, const intVec & J, targetVec & target) const {
  if(!ncol_ || !nrow_)
    throw std::runtime_error("Not a matrix");

  if(I.size() * J.size() != target.size())
    throw std::runtime_error("Bad target size");

  size_t k = 0;
  for(auto j : J) 
    for(auto i : I) 
       target[k++] = at(i,j);
}

// array
template <typename T>
template <typename intVec, typename targetVec>
void MMatrix<T>::extract_array(const std::vector<intVec> & I, targetVec & target) const {
  if(I.size() != dim_.size())
    throw std::runtime_error("Bad number of dimensions");

  size_t D = I.size();

  // first check target dimensions
  size_t le = 1;
  for(size_t i = 0; i < D; i++) le *= I[i].size();
  if(le != target.size())
    throw std::runtime_error("Bad target size");

  std::vector<size_t> ind;
  indices(I, ind);
  size_t k = 0;
  for(size_t i : ind) {
    target[k++] = at(i);
  }
}

// recursive function called by indices below
// should I make this a member of the class? it has no true reason to be
template <typename intVec>
inline void __indices__(const std::vector<intVec> & I, const std::vector<size_t> & Le, size_t d, std::vector<size_t> & ind) {
  if(I.size()-1 == d) {
    for(auto i : I[d])
      ind.push_back( i * Le[d]);
    return;
  }
  std::vector<size_t> ind2;
  __indices__(I, Le, d+1, ind2);
  for(size_t i2 : ind2)
    for(size_t i : I[d])
      ind.push_back( i * Le[d] + i2 );
}


// helper function for extract_array and set_values_array 
// compute the indices (in the array seen as a vector) of all
// elements whose coordinates are given by I (typically I = [ 1:2, 2:3, 1:5 ] )
template <typename T>
template <typename intVec>
void MMatrix<T>::indices(const std::vector<intVec> & I, std::vector<size_t> & ind) const {
  // compute offset values
  size_t D = I.size();
  std::vector<size_t> Le;
  size_t le = 1;
  Le.push_back(le);
  for(size_t i = 0; i < D - 1; i++) {
    le *= dim_[i];
    Le.push_back(le);
  }
    
  // let's go
  ind.clear();
  __indices__(I, Le, 0, ind);
}

// ----------------- component wise arithmetic --------------
template <typename T>
template <typename Tvec>
void MMatrix<T>::cw_sum(Tvec & e2) {
  size_t vs = e2.size();
  for(size_t i = 0; i < size_; i++) {
    data_ptr_[i] += e2[ i % vs ];
  }
}

template <typename T>
template <typename Tvec>
void MMatrix<T>::cw_minus(Tvec & e2) {
  size_t vs = e2.size();
  for(size_t i = 0; i < size_; i++) {
    data_ptr_[i] -= e2[ i % vs ];
  }
}

template <typename T>
template <typename Tvec>
void MMatrix<T>::cw_prod(Tvec & e2) {
  size_t vs = e2.size();
  for(size_t i = 0; i < size_; i++) {
    data_ptr_[i] *= e2[ i % vs ];
  }
}

template <typename T>
template <typename Tvec>
void MMatrix<T>::cw_div(Tvec & e2) {
  size_t vs = e2.size();
  for(size_t i = 0; i < size_; i++) {
    data_ptr_[i] /= e2[ i % vs ];
  }
}

template <typename T>
void MMatrix<T>::cw_inverse() {
  for(size_t i = 0; i < size_; i++) {
    data_ptr_[i] = 1/data_ptr_[i];
  }
}

template <typename T>
void MMatrix<T>::cw_opposite() {
  for(size_t i = 0; i < size_; i++) {
    data_ptr_[i] = -data_ptr_[i];
  }
}

// ------------------------------------------------------------
// UNSAFE, calling ()
template <typename T>
template <typename U>
std::vector<U> MMatrix<T>::sum() const
{
    std::vector<U> results(ncol_); // Allocates AND initialises w/ zero

    for (size_t i = 0; i < ncol_; ++i)
    {
        for (size_t j = 0; j < nrow_; ++j)
        {
            // Add the element in column i, row j.
            results[i] += static_cast<U>((*this)(j, i));
        }
    }
    return results;
}

// HELPER FUNCTIONS :

// get_type_name() is to get the template type by comparing it to known types
// was formally used to complete the descriptor file
template <typename T>
inline std::string get_type_name()
{
    if (std::is_same<T, int>::value)
    {
        return "integer"; // written in full cos need for descfile
    }
    else if (std::is_same<T, float>::value)
    {
        return "float";
    }
    else if (std::is_same<T, double>::value)
    {
        return "double";
    } 
    else if (std::is_same<T, short>::value)
    {
        return "short";
    }
    else if (std::is_same<T, char>::value)
    {
        return "char";
    } 
    else
    {
        return "unknown"; // to expand later ?
    }
}

#endif
