# Network-analysis-for-metagenomic-aseembled-data
Drected-networks-for-analyzing-genes-collocations-in-the-same-contigs

# Date: July 14, 2021
# Author: Jangwoo Lee (Eawag & ETH Zurich)
## Related Publication: Wastewater bypass is a major temporary point-source of antibiotic resistance genes and multi-resistance risk factors in a Swiss river(in preparation)

# Introduction
-Given that two genes are co-located in the same assembled contig, a directed network could be produced from two vertices (two co-located genes) and the edge information which could link the relationship between them. In this study, we defined the edge as “Co-occurrence frequency”, e.g., the proportion of the number of contigs that contain both genes (A and B) to the number of contigs containing the gene A.

# Th followings are input files for analyzing network under Graph Theory
-ALL_CARD+integrall_v2_x2.csv : The raw dataset where the name of contigs, and collocated genes are listed (this will be the starting point of this analysis).
-network_node_info_subtype.csv : The summarized table where two vertices (node 1 for source; node 2 for target) and edge information are saved.

# The followings are input files where 'graphic information' for drawing network graphs are saved.
-vertices_x2_subtype_graphicINFO.csv : The information on labels and colors of vertices.
-edges_x2_subtype_edgeCOLOR.csv : The information on edge colors.
-vertices_x2_subtype_legend_LABEL.csv : The information on labels in the figure legend.

# Graph algorithms
-functions.R : The customized R function for creating 'topology' matrix.
-nrp72_wp4_CARD_cooccurrence_matrix_v2.R : The main graph algorithms for analyzing directed networks.
