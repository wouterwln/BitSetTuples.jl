using BenchmarkTools
using BitSetTuples
using Random

Random.seed!(0)

const SUITE = BenchmarkGroup()


for i in (2, 5, 10, 100)
    SUITE["constructor_$i"] = @benchmarkable BitSetTuple($i)
end

for i in (5, 10, 50, 100)
    SUITE["intersect_$i"] = @benchmarkable intersect!(l, r) setup = begin
        l = BitSetTuple(collect(Tuple(unique(rand(1:$i, rand(1:$i)))) for _ in 1:$i))
        r = BitSetTuple(collect(Tuple(unique(rand(1:$i, rand(1:$i)))) for _ in 1:$i))
    end evals=1
end

for i in (5, 10, 50, 100)
    SUITE["union_$i"] = @benchmarkable union!(l, r) setup = begin
        l = BitSetTuple(collect(Tuple(unique(rand(1:$i, rand(1:$i)))) for _ in 1:$i))
        r = BitSetTuple(collect(Tuple(unique(rand(1:$i, rand(1:$i)))) for _ in 1:$i))
    end evals=1
end

for i in (5, 10, 50, 100)
    SUITE["is_valid_partition_$i"] = @benchmarkable is_valid_partition(BitSetTuple(collect(Tuple(unique(rand(1:$i, rand(1:$i)))) for _ in 1:$i)))
end

for i in (2, 5, 10, 100)
    SUITE["bounded_constructor_$i"] = @benchmarkable BoundedBitSetTuple($i)
end

for i in (5, 10, 50, 100)
    SUITE["bounded_intersect_$i"] = @benchmarkable intersect!(l, r) setup = begin
        l = BoundedBitSetTuple(rand(Bool, ($i, $i)))
        r = BoundedBitSetTuple(rand(Bool, ($i, $i)))
    end evals=1
end

for i in (5, 10, 50, 100)
    SUITE["bounded_union_$i"] = @benchmarkable union!(l, r) setup = begin
        l = BoundedBitSetTuple(rand(Bool, ($i, $i)))
        r = BoundedBitSetTuple(rand(Bool, ($i, $i)))
    end evals=1
end

for i in (5, 10, 50, 100)
    SUITE["bounded_is_valid_partition_$i"] = @benchmarkable is_valid_partition(BoundedBitSetTuple(rand(Bool, ($i, $i))))
end