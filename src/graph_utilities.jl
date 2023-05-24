# graph_utilities.jl
# need to figure out how this all works
# under changes to the nodes and/or vertices
# remember: we re-index the nodes and/or vertices
# these changes should be passed 
# ideally, avoid using MetaGraphs.jl

struct GraphTable
    g::T where {T <: AbstractGraph}
    nf::DataFrame
    ef::DataFrame
    edgemap::Dict{S, Int} where {S <: AbstractEdge}
end

function _initedgemap(g)
    return Dict{eltype(typeof(edges(g))), Int}()
end

function _fill_edgemap!(em, edgevec)
    for (i, edge) in enumerate(edgevec)
        em[edge] = i 
    end
end

# probably, should be a mutable struct (g, nf, ef)
function graphtable(
    conv; ego = :ego, alter = :alter, directed = false, edgedata = true
)

    ## edgedata must be non-duplicated

    g, vtx = graph(conv[!, ego], conv[!, alter]; directed = directed)

    em = _initedgemap(g)
    _fill_edgemap!(em, edges(g))
    
    # adding names should be option
    nf = DataFrame(:vertex => 1:nv(g), :name => vtx)
    ef = DataFrame(
        :edge => [e for e in edges(g)],
        :edgenum => [em[e] for e in edges(g)],
        :alter1 => [vtx[src(e)] for e in edges(g)],
        :alter2 => [vtx[dst(e)] for e in edges(g)]
    )

    if edgedata
        leftjoin!(ef, conv, on = [:alter1 => ego, :alter2 => alter])
        sort!(ef, :edgenum)
    end

    return GraphTable(g, nf, ef, em)
end

function graphtable(g, vtx)

    em = _initedgemap(g)
    _fill_edgemap!(em, edges(g))

    nf = DataFrame(:vertex => 1:nv(g), :name => vtx)
    ef = DataFrame(
        :edge => [e for e in edges(g)],
        :edgenum => [em[e] for e in edges(g)],
        :alter1 => [vtx[src(e)] for e in edges(g)],
        :alter2 => [vtx[dst(e)] for e in edges(g)]
    )

    return GraphTable(g, nf, ef, em)
end

function nodemeasure!(nf, g, fx, args...; on = :vertex, kwargs...)
    new = DataFrame(
        :vertex => 1:nv(g),
        Symbol(fx) => fx(g; kwargs...)
    )

    if string(fx) ∈ names(gt.nf)
        select!(gt.nf, Not(Symbol(fx)))
    end

    leftjoin!(nf, new; on = on)

    try
        disallowmissing!(gt.nf, Symbol(fx))
    catch
        println("missing created")
    end

    sort!(nf, :vertex)
end

function nodemeasure!(gt, fx, args...; on = :vertex, kwargs...)
    new = DataFrame(
        :vertex => 1:nv(gt.g),
        Symbol(fx) => fx(gt.g; kwargs...)
    )

    if string(fx) ∈ names(gt.nf)
        select!(gt.nf, Not(Symbol(fx)))
    end

    leftjoin!(gt.nf, new; on = on)

    try
        disallowmissing!(gt.nf, Symbol(fx))
    catch
        println("missing created")
    end

    sort!(gt.nf, :vertex)
end
