
module GraphTools

using Graphs, MetaGraphs, DataFrames
    
pths = [
    "graph.jl", "sortedges!.jl", "symmetrize!.jl",
    "egoreductions.jl", "egoreductions.jl", "graph_utilities.jl"
];

for e in pths; include(e) end

export graph, sortedges!, symmetrize!, symmetrize, egoreduction, egoreductions, GraphTable, graphtable, nodemeasure!

end
