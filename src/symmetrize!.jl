# symmetrize!.jl

"""
        symmetrize!(el; i = :i, j = :j, k = :k)

Make an edgelist symmetric. Sorts so that i < j, and grabs the unique ties. Works for perceiver-edgelist and usual edgelist.
"""
function symmetrize!(el; i = :i, j = :j, k = :k)

    sortedges!(el[!, i], el[!, j])

    # if perceiver-edgelist or regular 'ol edgelist
    sel = if "k" ∈ names(el)
        [i, j, k]
    else
        [i, j]
    end
    
    sort!(el, sel)
    ex = findall(nonunique(el[!, sel]) .== true)
    deleteat!(el, ex)
end

"""
        symmetrize(elo; i = :i, j = :j, k = :k)

Makes a copy. cf. symmetrize!.

Make an edgelist symmetric. Sorts so that i < j, and grabs the unique ties. Works for perceiver-edgelist and usual edgelist.

"""
function symmetrize(elo; i = :i, j = :j, k = :k)

    el = deepcopy(elo)
    symmetrize!(el; i = i, j = j, k = k)

    return el
end
