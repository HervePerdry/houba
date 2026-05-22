setClassUnion("listOrNULL", members = c("list", "NULL"))

setClassUnion("characterOrNULL", members = c("character", "NULL"))

setClassUnion("numericOrCharacter", members = c("numeric", "character"))
