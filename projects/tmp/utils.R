
NCAT <- 4
NPOP <- 5
cat2id <- function(cat){
  #print(cat)
  if(is.null(dim(cat))){
    sum(cat * NCAT^(0:(NPOP-1)))
  }else{
    apply(cat, 1, cat2id)
  }
}


#' from category, gets id
id2cat <- function(id){
  if(length(id)== 1){
  cat <- rep(0, NPOP)
  for(i in NPOP:1){
    cat[i] <- id %/% 4^(i-1)
    #print(id)
    id <- id - cat[i] * 4^(i-1)
  }
    return(cat)
  } else {
    t(sapply(id, id2cat))
  }
}

#sanity check
#all(sapply(0:1023, function(i)cat2id(id2cat(i))) == 0:1023)
