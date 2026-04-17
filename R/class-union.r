setClassUnion("memoryMapped",
              members = c("mvector", "mmatrix", "marray"))

setClassUnion("mmatrixOrMarray",
              members = c("mmatrix", "marray"))

setClassUnion("mvectorOrNumeric", 
              members = c("mvector", "numeric"))

setClassUnion("numericOrArray", 
              members = c("numeric", "array"))

