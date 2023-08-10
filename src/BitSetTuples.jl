module BitSetTuples

export BitSetTuple, complete!, get_membership_sets

using TupleTools
import TupleTools: ntuple, StaticLength

struct BitSetTuple{N}
    contents::NTuple{N,BitSet}
end


BitSetTuple(::Val{N}) where {N} = BitSetTuple(ntuple((_) -> BitSet(1:N), StaticLength(N)))
BitSetTuple(N::Int) = BitSetTuple(Val(N))
BitSetTuple(labels::AbstractArray) =
    BitSetTuple(ntuple((i) -> BitSet(labels[i]), StaticLength(length(labels))))
BitSetTuple(labels::NTuple{N,T}) where {N,T} =
    BitSetTuple(ntuple((i) -> BitSet(labels[i]), StaticLength(N)))


contents(c::BitSetTuple{N} where {N}) = c.contents
Base.intersect!(left::BitSetTuple{N}, right::BitSetTuple{N}) where {N} =
    intersect!.(contents(left), contents(right))
Base.:(==)(left::BitSetTuple{N}, right::BitSetTuple{N}) where {N} =
    contents(left) == contents(right)


"""
    complete!(tuple::BitSetTuple, max_element::Int)

Makes sure all elements from 1 up to `max_element` are included in at least one `BitSet`. 
If an element does not occur in any of the `BitSet`s, it is added to all of them.
"""
function complete!(tuple::BitSetTuple, max_element::Int)
    bitsets = contents(tuple)
    for node = 1:max_element
        if !any(node .∈ bitsets)    #If a variable does not occur in any group
            Base.push!.(bitsets, node)   #Add it to all groups
        end
    end
end


"""
    convert_to_constraint(constraint::BitSetTuple, max_element::Int)

Checks all elements from 1 to max_element and returns a BitSetTuple where each element is a BitSet containing all the groups that contain that element.
"""
function get_membership_sets(tuple::BitSetTuple, max_element::Int)
    bitsets = contents(tuple)
    result = map(
        node -> union(bitsets[findall(node .∈ bitsets)]...),
        ntuple((i) -> i, StaticLength(max_element)),
    )
    return BitSetTuple(result)
end


end
