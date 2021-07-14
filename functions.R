# To build a topology matrix 
make_topology_matrix = function(adjacency_matrix){
  id_m = diag(ncol(adjacency_matrix))
  topology_m = solve(id_m-adjacency_matrix)
  colnames(topology_m) = colnames(adjacency_matrix)
  rownames(topology_m) = rownames(adjacency_matrix)
  return(as.matrix(topology_m))
}
