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
    SUITE["complete_$i"] = @benchmarkable complete!(tup, $i) setup=begin
        tup = BitSetTuple(collect(Tuple(unique(rand(1:$i, rand(1:$i)))) for _ in 1:$i))
    end evals=1
end

for i in (5, 10, 50, 100)
    tup = BitSetTuple(collect(Tuple(unique(rand(1:i, rand(1:i)))) for _ in 1:i))
    SUITE["get_membership_sets_$i"] = @benchmarkable get_membership_sets($tup, $i) 
end