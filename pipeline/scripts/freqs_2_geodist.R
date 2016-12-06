
#!/bin/Rscript
args <- commandArgs(TRUE)
if(length(args)<1){
  tag=""  
}else{
  tag<-args[1]
}

library(jsonlite)
#library(emdbook) # for dbetabinom
source("scripts/utils/utils.R")

sourcefilename<-"/project/jnovembre/data/external_public/geodist/1kg_phase3_snps.tsv.gz"
likefilename<-paste("/project/jnovembre/data/external_public/geodist/1kg_phase3_snps.geodist5d4l.",tag,".lik.tsv.gz",sep="")
assignfilename<-paste("/project/jnovembre/data/external_public/geodist/1kg_phase3_snps.geodist5d4l.",tag,".assign.tsv.gz",sep="")

chr<-2


# Define all clusters
geodist_cats<-expand.grid(AFR=seq(0,3),EUR=seq(0,3),SAS=seq(0,3),EAS=seq(0,3),AMR=seq(0,3))

# The per cluster loglikelihood function
loglikelihood_perclust4<-function(x,n,c){
  if(c==0){
    if(x==0)
      return(log(1))
    else
      return(log(0))
  }
  if(c==1)
    return(dbetabinom(x,size=n,shape1=1,shape2=1000,log=TRUE))
  if(c==2)
    return(dbetabinom(x,size=n,shape1=2,shape2=100,log=TRUE))
  if(c==3)
    return(dbetabinom(x,size=n,shape1=1.2,shape2=2,log=TRUE))
}


# The likelihood for a cluster configuration
loglikelihood_clust4<-function(clustvec,xobs,nobs){
  # clustvec is a vector of form (0,1,1,0,2) and must have same dimension as xobs,nobs
  
  # initalize number of pops and logL
  npops<-length(xobs)
  logL<-0
  
  # cycle through pops computing loglikelihood 
  for(i in seq(1,npops)){
    logL<-logL+loglikelihood_perclust4(xobs[i],nobs[i],clustvec[i])
  }
  return(logL)
}

geodist_assign4<-function(xobs,nobs,geodist_cats){
  # Compute log likelihoods and get category assignment
  loglik_geodist_cats<-apply(geodist_cats,1,loglikelihood_clust4,xobs=xobs,nobs=nobs)
  return(loglik_geodist_cats)
}


assingfromfreqs<-function(snpid,freqs,flike,fassign,n=1000){
  
  xobs<-round(as.numeric(freqs)*n)
  nobs<-rep(n,length(freqs))
  likevec<-geodist_assign4(xobs,nobs,geodist_cats)
  geodistindex<-which.max(likevec)
  geodist<-geodist_cats[geodistindex,]
  #print(geodistindex)
  #print(geodist)
  write(paste(c(snpid,as.character(likevec)),collapse='\t'),flike,sep="\t")
  write(paste(c(snpid,as.character(cbind(geodistindex,geodist))),collapse='\t'),fassign,sep="\t")
}

assingfromfreqs_simple<-function(snpid,freqs,flike,fassign,n=1000){
  freqs <- as.numeric(freqs)
  freqcuts<-c(-0.01,0,0.005,0.05,1)
  geodist<-as.numeric(cut(freqs,freqcuts))-1
  geodistindex<-cat2id(geodist) 
  write(paste(c(snpid,as.character(c(geodistindex,geodist))),collapse='\t'),fassign,sep="\t")
}



processData<-function(imax=1e12){
  sourcefile<-file(sourcefilename,'r')
  likefile<-file(likefilename,'w')
  assignfile<-file(assignfilename,'w')
  
  f<-file("stdin",'r') #gzcon(sourcefile)
  flike<-gzcon(likefile)
  fassign<-gzcon(assignfile)
  
  
  i<-0
  stopread<-FALSE
  
  while(!stopread) {
    next_line = readLines(f, n = 1)
    
    ## Stop at eof
    if(length(next_line) == 0) {
      stopread = TRUE
      close(f)
      close(flike)
      close(fassign)
      break
    }
    
    
    #if(i %% imax/100==0)
    #  print(i)
    recordvalues<-strsplit(next_line,"\t")[[1]]
    if(recordvalues[1]!='#')
      i<-i+1
    
    if(i==1){   ## Use first row 
      fieldnames<-recordvalues
      #print(fieldnames)
    }else{
      snpid<-recordvalues[1:3]
      freqs<-recordvalues[17:21]
      freqs<-freqs[c(2,4,1,3,5)]  ### Cludge line to fix issue that 
                                  ### population order in freqs file does not match AFR,EUR,SAS,EAS,AMR
      
      assingfromfreqs_simple(snpid,freqs,flike,fassign)
    }
    
    ## Stop if i>x 
    if(i>imax){
      stopread=TRUE
      close(f)
      close(flike)
      close(fassign)
    }
    
    
  }
}

processData()
