NCAT <- 4
NPOP <- 5
BASE <- NCAT^(0:(NPOP-1))

cat2id <- function(cat){
  #print(cat)
  if(is.null(dim(cat))){
    sum(cat * BASE)
  }else{
    apply(cat, 1, cat2id)
  }
}


#' from category, gets id
id2cat <- function(id){
  if(length(id)== 1){
  cat <- rep(0, NPOP)
  for(i in NPOP:1){
    cat[i] <- id %/% BASE[i]
    #print(id)
    id <- id - cat[i] * BASE[i]
  }
    return(cat)
  } else {
    t(sapply(id, id2cat))
  }
}

#sanity check
#all(sapply(0:1023, function(i)cat2id(id2cat(i))) == 0:1023)
