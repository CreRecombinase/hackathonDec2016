suppressPackageStartupMessages({
  library(dplyr)
  library(viridis)
})
source("utils.R")

POPS <- c("AFR", "EUR", "SAS", "EAS", "AMR")
N_POPS <- 5
SEQ_POPS <- 0:(N_POPS-1)
N_LEVELS <- 4


load_data <- function(){
  data <- read.table("~/geodist/test.assign.tsv.gz")
  names(data) <- c("CHROM", "POS", "RSID", "CAT", POPS)
  
  fqs <- data %>% group_by(CAT, AFR, EUR, SAS, EAS, AMR) %>% summarize(COUNT=n())
  fqs <- fqs %>% ungroup() %>% arrange(desc(COUNT))
  fqs <- fqs %>% mutate(FREQ = COUNT/sum(COUNT))
}

colors <- viridis(N_LEVELS)

plot_geodist <- function(categories, counts, colors, annotation){
  
}

id2col <- function(id, colors){
  cat <- id2cat(id)
  if(is.null(dim(cat))){
    colors[cat+1]
  }else{
    t(apply(cat+1, 1, function(i)colors[i]))
  }
}

plot_rect <- function(id, y, colors, n_rect=NULL, ...){
  RECT_WIDTH <- 1
  n_rect <- ifelse(is.null(n_rect), length(y), n_rect)
  plot(NA, xlim=c(0,N_POPS), ylim=c(0,1), xaxs='i', yaxs='i', xaxt='n', ...)
  
  xleft <- rep(SEQ_POPS, n_rect)
  xright <- xleft + RECT_WIDTH
  ytop <- if(length(y)==1) seq(0, 1, 1/n_rect) else cumsum(y[1:n_rect])/sum(y[1:n_rect])
  ybot <- c(0, ytop[-length(ytop)])
  ytop <- rep(ytop, each=N_POPS)
  ybot <- rep(ybot, each=N_POPS)
  
  colors <- t(id2col(id, colors))
  
  
  rect(xleft, 1-ybot, xright, 1-ytop, col=colors, lwd=1, border="#55555540")
  rect(0,0, N_POPS, 1) #border
  axis(side=1, at=1:N_POPS - 0.5, labels=POPS, las=2)
}