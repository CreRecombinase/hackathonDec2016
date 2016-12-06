suppressPackageStartupMessages({
  library(dplyr)
  library(viridis)
  library(readr)
})
source("scripts/utils/utils.R")

POPS <- c("AFR", "EUR", "SAS", "EAS", "AMR")
N_POPS <- 5
SEQ_POPS <- 0:(N_POPS-1)
N_LEVELS <- 4


load_data <- function(){
  #data <- read.table("~/geodist/test.assign.tsv.gz")
  data <- data <- read_tsv("~/geodist/1kg_phase3_snps.geodist5d4l.simple.assign.tsv.gz", col_names=F)
  names(data) <- c("CHROM", "POS", "RSID", "CAT", POPS)
  
  fqs <- data %>% group_by(CAT, AFR, EUR, SAS, EAS, AMR) %>% summarize(COUNT=n())
  fqs <- fqs %>% ungroup() %>% arrange(desc(COUNT))
  fqs <- fqs %>% mutate(FREQ = COUNT/sum(COUNT))
}

tabulate_geodist <- function(data){
  names(data) <- c("CHROM", "POS", "RSID", "CAT", POPS)
  data %>% group_by(CAT, AFR, EUR, SAS, EAS, AMR) %>% summarize(COUNT=n()) %>%
    ungroup() %>% arrange(desc(COUNT))
}

colors <- viridis(N_LEVELS)

plot_geodist <- function(geodist_table, colors=viridis(4), ...){
  plot_rect(geodist_table$CAT, geodist_table$FREQ, colors=colors, ...)
  
}

id2col <- function(id, colors){
  cat <- id2cat(id)
  if(is.null(dim(cat))){
    colors[cat+1]
  }else{
    t(apply(cat+1, 1, function(i)colors[i]))
  }
}

plot_rect <- function(id, y, colors, n_rect=NULL, add=F, ylim=0:1, ...){
  RECT_WIDTH <- 1
  
  n_rect <- ifelse(is.null(n_rect), length(y), n_rect)
  
  
  xleft <- rep(SEQ_POPS, n_rect)
  xright <- xleft + RECT_WIDTH
  ytop <- if(length(y)==1) seq(0, 1, 1/n_rect) else cumsum(y[1:n_rect])/sum(y[1:n_rect])
  ybot <- c(0, ytop[-length(ytop)])
  ytop <- rep(ytop, each=N_POPS)
  ybot <- rep(ybot, each=N_POPS)
  
  colors <- t(id2col(id, colors))
  
  if(!add)plot(NA, xlim=c(0,N_POPS), ylim=ylim, xaxs='i', yaxs='i', xaxt='n', ...)
  
  rect(xleft, 1-ybot, xright, 1-ytop, col=colors, lwd=1, border="#55555540")
  rect(0,0, N_POPS, 1) #border
  axis(side=1, at=1:N_POPS - 0.5, labels=POPS, las=2)
}