module LightGraphs

using SimpleTraits

### Remove the following line once #915 is closed
using ArnoldiMethod
using Statistics: mean

using Inflate: InflateGzipStream
using DataStructures: IntDisjointSets, PriorityQueue, Queue, Deque, dequeue!, dequeue_pair!, enqueue!, heappop!, heappush!, in_same_set, peek, union!, find_root
using LinearAlgebra: I, Symmetric, diagm, eigen, eigvals, norm, rmul!, tril, triu
import LinearAlgebra: Diagonal, issymmetric, mul!
using Random: AbstractRNG, GLOBAL_RNG, MersenneTwister, randperm, randsubseq!, seed!, shuffle, shuffle!
using SparseArrays: SparseMatrixCSC, nonzeros, nzrange, rowvals
using Distributed: @distributed
import SparseArrays: blockdiag, sparse

import Base: adjoint, write, ==, <, *, ≈, convert, isless, issubset, union, intersect,
            reverse, isassigned, getindex, setindex!, show,
            print, copy, in, sum, size, eltype, length, ndims, transpose,
            join, iterate, eltype, get, Pair, Tuple, zero

export
# Interface
AbstractGraph, AbstractEdge, AbstractEdgeIter,
# Graph, DiGraph, Edge,

# Edge, Graph, SimpleGraph, SimpleGraphFromIterator, DiGraph, SimpleDiGraphFromIterator, SimpleDiGraph,
vertices, edges, edgetype, nv, ne, src, dst,
is_directed, IsDirected,
has_contiguous_vertices, HasContiguousVertices,
has_vertex, has_edge, inneighbors, outneighbors,

# core
is_ordered, add_vertices!, indegree, outdegree, degree,
Δout, Δin, δout, δin, Δ, δ, degree_histogram,
neighbors, all_neighbors, common_neighbors,
has_self_loops, num_self_loops, density, squash, weights,
add_edge!, add_vertex!, add_vertices!, rem_edge!, rem_vertex!, rem_vertices!,

# deprecated decomposition
core_number, k_core, k_shell, k_crust, k_corona,

# deprecated distance
eccentricity, diameter, periphery, radius, center,

# distance between graphs
spectral_distance, edit_distance,

# edit path cost functions
MinkowskiCost, BoundedMinkowskiCost,

# operators
complement, reverse, blockdiag, union, intersect,
difference, symmetric_difference,
join, tensor_product, cartesian_product, crosspath,
induced_subgraph, egonet, merge_vertices!, merge_vertices,

# deprecated bfs
gdistances, gdistances!, bfs_tree, bfs_parents, has_path,

# bipartition
is_bipartite, bipartite_map,

# deprecated dfs
is_cyclic, topological_sort_by_dfs, dfs_tree, dfs_parents,

# random
randomwalk, self_avoiding_walk, non_backtracking_randomwalk,

# diffusion
diffusion, diffusion_rate,

# coloring
greedy_color,

# deprecated connectivity
connected_components, strongly_connected_components, strongly_connected_components_kosaraju, weakly_connected_components,
is_connected, is_strongly_connected, is_weakly_connected, period,
condensation, attracting_components, neighborhood, neighborhood_dists,
isgraphical,

# deprecated cycles
simplecycles_hawick_james, maxsimplecycles, simplecycles, simplecycles_iter,
simplecyclescount, simplecycleslength, karp_minimum_cycle_mean, cycle_basis,
simplecycles_limited_length,

# maximum_adjacency_visit
mincut, maximum_adjacency_visit,

# deprecated a-star, dijkstra, bellman-ford, floyd-warshall, desopo-pape, spfa
a_star, dijkstra_shortest_paths, bellman_ford_shortest_paths,
spfa_shortest_paths,has_negative_edge_cycle_spfa,has_negative_edge_cycle, enumerate_paths,
johnson_shortest_paths, floyd_warshall_shortest_paths, transitiveclosure!, transitiveclosure, transitivereduction,
yen_k_shortest_paths, desopo_pape_shortest_paths,

# deprecated centrality
betweenness_centrality, closeness_centrality, degree_centrality,
indegree_centrality, outdegree_centrality, katz_centrality, pagerank,
eigenvector_centrality, stress_centrality, radiality_centrality,

# spectral
adjacency_matrix, laplacian_matrix, adjacency_spectrum, laplacian_spectrum,
non_backtracking_matrix, incidence_matrix, Nonbacktracking,
contract,

# persistence
loadgraph, loadgraphs, savegraph, LGFormat,

# deprecated randgraphs
erdos_renyi, expected_degree_graph, watts_strogatz, random_regular_graph, random_regular_digraph,
random_configuration_model, random_tournament_digraph, StochasticBlockModel, make_edgestream,
nearbipartiteSBM, blockcounts, blockfractions, stochastic_block_model, barabasi_albert,
barabasi_albert!, static_fitness_model, static_scale_free, kronecker, dorogovtsev_mendes, random_orientation_dag,

# deprecated community
modularity, core_periphery_deg,
local_clustering,local_clustering_coefficient, global_clustering_coefficient, triangles,
label_propagation, maximal_cliques, clique_percolation,

#deprecated generators
complete_graph, star_graph, path_graph, wheel_graph, cycle_graph,
complete_bipartite_graph, complete_multipartite_graph, turan_graph,
complete_digraph, star_digraph, path_digraph, grid, wheel_digraph, cycle_digraph,
binary_tree, double_binary_tree, roach_graph, clique_graph, ladder_graph,
circular_ladder_graph, barbell_graph, lollipop_graph, friendship_graph,
circulant_graph, circulant_digraph,

# deprecated smallgraphs
smallgraph,

# deprecated Euclidean graphs
euclidean_graph,

# deprecated minimum_spanning_trees
boruvka_mst, kruskal_mst, prim_mst,

#steinertree
steiner_tree,

#biconnectivity and articulation points
articulation, biconnected_components, bridges,

#graphcut
normalized_cut, karger_min_cut, karger_cut_cost, karger_cut_edges,

#deprecated dominatingset
dominating_set,

#independentset
independent_set,

#deprecated vertexcover
vertex_cover,

# useful utilities
is_graphical

"""
    LightGraphs

An optimized graphs package.

Simple graphs (not multi- or hypergraphs) are represented in a memory- and
time-efficient manner with adjacency lists and edge sets. Both directed and
undirected graphs are supported via separate types, and conversion is available
from directed to undirected.

The project goal is to mirror the functionality of robust network and graph
analysis libraries such as NetworkX while being simpler to use and more
efficient than existing Julian graph libraries such as Graphs.jl. It is an
explicit design decision that any data not required for graph manipulation
(attributes and other information, for example) is expected to be stored
outside of the graph structure itself. Such data lends itself to storage in
more traditional and better-optimized mechanisms.

[Full documentation](http://codecov.io/github/JuliaGraphs/LightGraphs.jl) is available,
and tutorials are available at the
[JuliaGraphsTutorials repository](https://github.com/JuliaGraphs/JuliaGraphsTutorials).
"""
LightGraphs
include("interface.jl")
include("utils.jl")
include("core.jl")
include("defaultdistance.jl")
include("operators.jl")

include("SimpleGraphsCore/SimpleGraphsCore.jl")
include("Generators/Generators.jl")
include("Degeneracy/Degeneracy.jl")
include("Traversals/Traversals.jl")
include("ShortestPaths/ShortestPaths.jl")  # requires Traversals
include("Measurements/Measurements.jl") # requires ShortestPaths
include("Connectivity/Connectivity.jl")  # requires ShortestPaths
include("Transitivity/Transitivity.jl")
include("Cycles/Cycles.jl")
include("VertexSubsets/VertexSubsets.jl")
include("Structure/Structure.jl")
include("linalg13/LinAlg.jl")
include("Centrality/Centrality.jl") # requires LinAlg
include("Coloring/Coloring.jl")  # requires Connectivity
include("Community/Community.jl")
include("SimpleGraphs/SimpleGraphs.jl")
include("Biconnectivity/Biconnectivity.jl")
include("Experimental/Experimental.jl")

include("deprecations13/degeneracy13.jl")
include("deprecations13/traversals13/bfs.jl")
include("deprecations13/traversals13/bipartition.jl")
include("deprecations13/traversals13/greedy_color.jl")
include("deprecations13/traversals13/dfs.jl")
include("deprecations13/traversals13/maxadjvisit.jl")
include("deprecations13/traversals13/randomwalks.jl")
include("deprecations13/traversals13/diffusion.jl")
include("deprecations13/edit_distance.jl")
include("deprecations13/shortestpaths13/astar.jl")
include("deprecations13/shortestpaths13/bellman-ford.jl")
include("deprecations13/shortestpaths13/dijkstra.jl")
include("deprecations13/shortestpaths13/johnson.jl")
include("deprecations13/shortestpaths13/desopo-pape.jl")
include("deprecations13/shortestpaths13/floyd-warshall.jl")
include("deprecations13/shortestpaths13/yen.jl")
include("deprecations13/shortestpaths13/spfa.jl")
include("deprecations13/distance13.jl")
include("deprecations13/connectivity13.jl")
include("deprecations13/digraph13/transitivity.jl")
include("deprecations13/cycles13/johnson.jl")
include("deprecations13/cycles13/hawick-james.jl")
include("deprecations13/cycles13/karp.jl")
include("deprecations13/cycles13/basis.jl")
include("deprecations13/cycles13/limited_length.jl")
include("persistence13/common.jl")
include("persistence13/lg.jl")
include("deprecations13/centrality13/betweenness.jl")
include("deprecations13/centrality13/closeness.jl")
include("deprecations13/centrality13/stress.jl")
include("deprecations13/centrality13/degree.jl")
include("deprecations13/centrality13/katz.jl")
include("deprecations13/centrality13/pagerank.jl")
include("deprecations13/centrality13/eigenvector.jl")
include("deprecations13/centrality13/radiality.jl")
include("deprecations13/community13/modularity.jl")
include("deprecations13/community13/label_propagation.jl")
include("deprecations13/community13/core-periphery.jl")
include("deprecations13/community13/clustering.jl")
include("deprecations13/community13/cliques.jl")
include("deprecations13/community13/clique_percolation.jl")
include("deprecations13/biconnectivity13.jl")
include("spanningtrees13/boruvka.jl")
include("spanningtrees13/kruskal.jl")
include("spanningtrees13/prim.jl")
include("steinertree13/steiner_tree.jl")
include("graphcut13/normalized_cut.jl")
include("graphcut13/karger_min_cut.jl")
include("deprecations13/dominatingset13/degree_dom_set.jl")
include("deprecations13/dominatingset13/minimal_dom_set.jl")
include("deprecations13/independentset13/degree_ind_set.jl")
include("deprecations13/independentset13/maximal_ind_set.jl")
include("deprecations13/vertexcover13/degree_vertex_cover.jl")
include("deprecations13/vertexcover13/random_vertex_cover.jl")
include("Parallel/Parallel.jl")

include("deprecations.jl")
using .LinAlg
end # module
