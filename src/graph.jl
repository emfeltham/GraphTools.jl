# graph.jl

"""
    graph(egos, alters; directed = true)

vertices: the position of a name in vtx gives its index in the graph object
"""
function graph(egos, alters; directed = true)
    vertices = sort(unique(vcat(egos, alters)));
    
    g = if directed
        SimpleDiGraph(length(vertices))
    else
        SimpleGraph(length(vertices))
    end

    addties!(g, egos, alters, vertices)
    return g, vertices
end

"""
    graph(egos, alters, nodes; directed = true)

ARGS
=====

nodes: the larger set of nodes to construct the graph from. This is useful if the edgelist is a filtered subset, and nodes may have been dropped (i.e., isolates).

vertices: the position of a name in vtx gives its index in the graph object

"""
function graph(egos, alters, nodes; directed = true)
    vertices = sort(unique(nodes));
    
    g = if directed
        SimpleDiGraph(length(vertices))
    else
        SimpleGraph(length(vertices))
    end

    addties!(g, egos, alters, vertices)
    return g, vertices
end

function addties!(g, egos, alters, vtx)
    for (e, a) in zip(egos, alters)
        ei, ai = nametoindex(e, a, vtx)
        add_edge!(g, ei, ai)
    end
end

"""
        nametoindex(e, a, vtx)

Convert the node names (from the edgelist) to node indices consistent with
Graphs.jl: the graph is indexed from 1 to the number of nodes.

Here, the index is assigned based on vertices, the (unique) set of node names.
"""
function nametoindex(e, a, vertices)
    
    ei = findfirst(vertices .== e)
    ai = findfirst(vertices .== a)
    return ei, ai
end