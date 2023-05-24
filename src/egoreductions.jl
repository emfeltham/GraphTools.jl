# egoreductions.jl

"""
        egoreductions(els, codes, codename)

Calculate individual network characteristics, and return a DataFrame.

ARGS
====
- els : edgelist
- codes : village codes to include
- codename : name of village code variable
"""
function egoreductions(els, codes, codename)
    nfs = DataFrame();

    nets, egos, alters = eachcol(els[!, [codename, :ego, :alter]]);
    _egoreducts!(nfs, nets, egos, alters, codes, codename)
    
    return nfs
end

function _egoreducts!(nf, nets, egos, alters, codes, codename; directed = true)
    for code in codes
        egos_c = @views egos[nets .== code]
        alters_c = @views alters[nets .== code]

        g, vtx = graph(egos_c, alters_c; directed = directed)
        
        nf_code = egoreduction(g, vtx)
        nf_code[!, codename] .= code
        append!(nf, nf_code)
    end
end

function egoreduction(g, vtx)
    nf = DataFrame(:name => vtx)
    nf[!, :degree] = degree(g);
    nf[!, :degree_vilnorm] = nf[!, :degree] .* inv(maximum(nf[!, :degree]))
    nf[!, :between] = betweenness_centrality(g);
    nf[!, :between] = nf[!, :between] .* inv(maximum(nf[!, :between]))
    # nf[!, :eigen] = eigenvector_centrality(g); gives bounds error sometimes?
    nf[!, :close] = closeness_centrality(g);
    return nf
end
