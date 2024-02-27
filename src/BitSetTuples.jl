module BitSetTuples

export BitSetTuple, BoundedBitSetTuple, contents, tupled_contents, is_valid_partition

using TupleTools
import TupleTools: ntuple, StaticLength

struct BitSetTuple{N}
    contents::NTuple{N,BitSet}
end


BitSetTuple(::Val{N}) where {N} = BitSetTuple(ntuple((_) -> BitSet(1:N), StaticLength(N)))
BitSetTuple(N::Int) = BitSetTuple(Val(N))
BitSetTuple(labels::AbstractArray) =
    BitSetTuple(ntuple((i) -> BitSet(labels[i]), StaticLength(length(labels))))
BitSetTuple(labels::NTuple{N,T} where {T}) where {N} =
    BitSetTuple(ntuple((i) -> BitSet(labels[i]), StaticLength(N)))
    
contents(c::BitSetTuple{N} where {N}) = c.contents
tupled_contents(c::BitSetTuple{N} where {N}) = Tuple.(c.contents)

Base.length(c::BitSetTuple{N}) where {N} = N

Base.iterate(c::BitSetTuple{N} where {N}) = iterate(c.contents)
Base.iterate(c::BitSetTuple{N} where {N}, state) = iterate(c.contents, state)

Base.getindex(c::BitSetTuple{N} where {N}, i::Int) = c.contents[i]

Base.intersect!(left::BitSetTuple{N}, right::BitSetTuple{N}) where {N} = begin
    intersect!.(contents(left), contents(right))
    return left
end
Base.intersect(left::BitSetTuple{N}, right::BitSetTuple{N}) where {N} =
    BitSetTuple(intersect.(contents(left), contents(right)))
Base.union!(left::BitSetTuple{N}, right::BitSetTuple{N}) where {N} =
    BitSetTuple(union!.(contents(left), contents(right)))
Base.union(left::BitSetTuple{N}, right::BitSetTuple{N}) where {N} =
    BitSetTuple(union.(contents(left), contents(right)))

Base.:(==)(left::BitSetTuple{N}, right::BitSetTuple{N}) where {N} =
    contents(left) == contents(right)

function is_valid_partition(set::BitSetTuple{N}) where {N}
    c = unique(contents(set))
    if reduce(union, c) != BitSet(1:N)
        return false
    end
    for i = 1:N
        if sum(x -> i ∈ x, c) > 1
            return false
        end
    end
    return true
end


struct BoundedBitSetTuple
    contents::BitMatrix
end


BoundedBitSetTuple(init, N::Int, M::Int) = BoundedBitSetTuple(init(Bool, (N, M)))
BoundedBitSetTuple(::UndefInitializer, N::Int, M::Int) =
    BoundedBitSetTuple(BitMatrix(UndefInitializer(), (N, M)))
BoundedBitSetTuple(init, N::Int) = BoundedBitSetTuple(init, N, N)
BoundedBitSetTuple(N::Int) = BoundedBitSetTuple(ones, N)

function BoundedBitSetTuple(labels::Tuple)
    size = maximum(maximum.(labels))
    result = BoundedBitSetTuple(zeros, length(labels), maximum(maximum.(labels)))
    for i = 1:length(labels)
        for j in labels[i]
            insert!(result, j, i)
        end
    end
    return result
end

contents(set::BoundedBitSetTuple) = set.contents

function tupled_contents(set::BoundedBitSetTuple)
    Tuple(
        map(
            col -> Tuple(
                filter(
                    elem -> elem != 0,
                    map(elem -> elem[2] == 1 ? elem[1] : 0, enumerate(col)),
                ),
            ),
            eachcol(contents(set)),
        ),
    )
end

Base.size(set::BoundedBitSetTuple) = size(contents(set))
Base.size(set::BoundedBitSetTuple, i::Int) = size(contents(set), i)
Base.length(set::BoundedBitSetTuple) = size(set, 1)

Base.delete!(set::BoundedBitSetTuple, i::Int, j::Int) = set.contents[i, j] = false
Base.insert!(set::BoundedBitSetTuple, i::Int, j::Int) = set.contents[i, j] = true

Base.getindex(set::BoundedBitSetTuple, i::Int) = contents(set)[i, :]
Base.getindex(set::BoundedBitSetTuple, i::Int, j::Int) = contents(set)[i, j]

Base.setindex!(set::BoundedBitSetTuple, value, i::Int, j::Int) = set.contents[i, j] = value
Base.setindex!(set::BoundedBitSetTuple, value, i::Int, ::Colon) = set.contents[i, :] .= value
Base.setindex!(set::BoundedBitSetTuple, value, ::Colon, j::Int) = set.contents[:, j] .= value

Base.intersect(left::BoundedBitSetTuple, right::BoundedBitSetTuple) =
    BoundedBitSetTuple(contents(left) .& contents(right))
Base.union(left::BoundedBitSetTuple, right::BoundedBitSetTuple) =
    BoundedBitSetTuple(contents(left) .| contents(right))

Base.intersect!(left::BoundedBitSetTuple, right::BoundedBitSetTuple) =
    BoundedBitSetTuple(left.contents .&= contents(right))
Base.union!(left::BoundedBitSetTuple, right::BoundedBitSetTuple) =
    BoundedBitSetTuple(left.contents .|= contents(right))

Base.:(==)(left::BoundedBitSetTuple, right::BoundedBitSetTuple) =
    contents(left) == contents(right)


function is_valid_partition(set::BoundedBitSetTuple)
    cols = eachcol(contents(set))
    result = first(cols)
    hashes = Set(hash(result))
    for i = 2:length(cols)
        if hash(cols[i]) ∉ hashes
            push!(hashes, hash(cols[i]))
            result .⊻= cols[i]
        end
    end
    return all(result)
end

end
