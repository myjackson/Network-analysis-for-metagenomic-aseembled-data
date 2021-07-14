library(igraph)

setwd('Q:/Abteilungsprojekte/Surf/surf-KB/Mic-Ecology/02_PROJECTS/1. Antibiotic resistance/2. Jangwoo PhD/1_Project/4_NRP72_WP4/3_Data Analysis/2_Rcodes/8. NetworkAnalysis') # to set a working directory
source("functions.R")
data_folder = "1_Data"
graphic_infos = "2_Graphic_Infos"

################################## To subset a sub-matrix (for input-matrix for edge calculation)
dat<-read.delim(file.path(data_folder,"ALL_CARD+integrall_v2_x2.csv"),sep=",")  
dat<-subset(dat,sample!='M43') # M43 is SED-DS : Needs to be removed (only Water samples are considered in the downstream analysis)

new_df = data.frame(node_1 = dat$classification_2, node_2 = dat$contig_id)

g = graph.data.frame(new_df)
adj = as_adj(g)

topology_m = make_topology_matrix(adj)
# write.table(topology_m,file='topology_m.csv',sep=',',row.names = TRUE) # To check intermediate file! (double-check if everything goes right)
sub_topology_m<-topology_m[c(1:74),c(75:199)] # Need to sub-select sub-matrix comprising ARG-classes in row & contig IDs in columns (74 X 125)
# write.table(sub_topology_m,file='sub_topology_m.csv',sep=',',row.names = TRUE) # To check intermediate file! (double-check if everything goes right)

################################## To calculate Edge-Infos for all ARG combinations 
sub.dat<-t(sub_topology_m) # to transform the input-matrix - just to make easier to operate following loops!
sub.dat<-as.data.frame(sub.dat) # to transform the input-matrix to dataframe - just to make easier to operate following loops!
# write.table(sub.dat,file='intermediate_sub_dat.csv',sep=',',row.names = TRUE) # To check intermediate file! (double-check if everything goes right)

ls_0<-c()
for (j in 1:length(colnames(sub.dat))){
  sub.sub.dat<-sub.dat[sub.dat[,j]==1,]
  
  ls<-c()
  for (i in 1:length(colnames(sub.dat))){
    ls<-c(ls,sum(sub.sub.dat[,i])/sum(sub.sub.dat[,j]))
  }
  ls_0<-rbind(ls_0,ls)
}

colnames(ls_0)<-colnames(sub.dat)
rownames(ls_0)<-colnames(sub.dat)

# write.table(ls_0,file='intermediate.csv',sep=',',row.names = T) # to check the intermediate file - always double check if the calculation is going right.

################################## To generate a dataframe summarizing "Node1 (source) - Node2 (target) - Edge (Co-occurrence frequency)
# id_m = diag(ncol(ls_0))
# ls_0=ls_0-id_m

ls_result<-c()

for (i in 1:length(colnames(ls_0))){
  sub.ls_0<-ls_0[ls_0[,i]>0,]
  
  for (j in 1:length(sub.ls_0[,i])){
    ls<-c(row.names(sub.ls_0)[j],colnames(sub.ls_0)[i],as.numeric(sub.ls_0[,i][j]))
    ls_result<-rbind(ls_result,ls)
  }
}

colnames(ls_result)<-c("node1","node2","edge")

write.table(ls_result,file.path(data_folder,"network_node_info_subtype.csv"),sep=',',row.names = F)

################################## To generate an adjacency matrix using the dataframe produced above

dat<-read.delim(file.path(data_folder,"network_node_info_subtype.csv"),sep=",")

new_df = data.frame(node_1 = dat$node1, node_2 = dat$node2)
g = graph.data.frame(new_df)

adj = as_adj(g)

################################## To draw a directed-network 

net<-graph_from_adjacency_matrix(adj,mode="directed",weighted = NULL,diag = FALSE) # generating a directed network from dataframe

### To extract Vertex IDs (to create another dataframe where graphic infos will be saved)

ls<-c()
for (i in V(net)){
  ls<-c(ls,V(net)[i])
}

dat.V<-as.data.frame(ls,col.names='vertices')
ls<-row.names(dat.V)
dat.V<-as.data.frame(ls)
colnames(dat.V)<-'Vertices'
write.table(dat.V,file.path(data_folder,"vertices_x2_subtype.csv"),sep=',',row.names = F)

### to set label names and edge colors (separately saved in a vector)
library(RColorBrewer)

dat.info<-read.delim(file.path(graphic_infos,"vertices_x2_subtype_graphicINFO.csv"),sep=",")
color<-as.vector(dat.info$Color)
labels<-dat.info$Labels

dat.edge<-read.delim(file.path(graphic_infos,"edges_x2_subtype_edgeCOLOR.csv"),sep=",")
edge.col<-as.vector(dat.edge$color)

### to draw a directed-network graph
V(net)$color<-color

# "Non" interactive plotting
plot.igraph(net, vertex.size=5,vertex.label.cex=0.5,
            vertex.label=labels,
            vertex.label.font = 3,
            vertex.label.dist = 1,
            vertex.label.color = "black",
            edge.arrow.size=.04, edge.curved=0.8,
            edge.color=edge.col,
            layout=layout.auto,
            margin=c(0,0,0,2.5)) # optional parameters: layout=layout.circle; vertex.label.font = 3,

# "Interactive" plotting (optional)
tkplot(net, vertex.size=5,vertex.label.cex=0.5,
            vertex.label=labels,
            vertex.label.dist = 1,
            vertex.label.color = "black",
            edge.arrow.size=.04, edge.curved=0.8,
            edge.color=edge.col,
            layout=layout.auto) # optional parameters: layout=layout.circle; vertex.label.font = 3,

### following codes will generate a legend
dat.info<-read.delim(file.path(graphic_infos,"vertices_x2_subtype_legend_LABEL.csv"),sep=",")
labels<-as.vector(dat.info$Label)
colors<-as.vector(dat.info$Color)

legend(x = 1, y = 1,
       legend=labels,
       horiz=FALSE,bty="n",
       cex=0.6,
       pt.cex=1,
       pch=21,
       pt.bg=colors,
       col='black',
       text.col='black',
       x.intersp=0.3,
       y.intersp=0.3)


