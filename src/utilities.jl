# utilities.jl

"""
        tupleize(alters1, alters2; sort = true)

Create a vector of tuples from the columns of an edgelist. If asymmetric, sort should be false.
"""
function tupleize(alters1, alters2; sort = false)
    tups = Vector{Tuple{String, String}}(undef, length(alters1))
    for (i, (e1, e2)) in enumerate(zip(alters1, alters2))
        tups[i] = if sort
            tups[i] = if e1 > e2
                (e2, e1)
            else
                (e1, e2)
            end
        else
            (e1, e2)
        end
    end
    return tups
end
