using BitSetTuples
import BitSetTuples: complete!, get_membership_sets, contents
using Test

@testset "BitSetTuple.jl" begin
    @testset "constructor" begin
        for i = 1:10
            @test contents(BitSetTuple(i)) == Tuple([BitSet(1:i) for _ = 1:i])
        end
        @test contents(BitSetTuple([[1], [2], [3]])) ==
              Tuple([BitSet(1), BitSet(2), BitSet(3)])
    end

    @testset "intersect!" begin
        left = BitSetTuple(4)
        right = BitSetTuple(4)
        intersect!(left, right)
        @test left == BitSetTuple(4)

        left = BitSetTuple(3)
        right = BitSetTuple(4)
        @test_throws MethodError intersect!(left, right)

        left = BitSetTuple(4)
        right = BitSetTuple([collect(1:i) for i = 1:4])
        intersect!(left, right)
        @test left == right
    end

    @testset "complete!" begin
        c = BitSetTuple([Int64[], Int64[], Int64[], [2], Int64[], Int64[], [3], [1]])
        complete!(c, 4)
        @test c == BitSetTuple([
            Int64[4],
            Int64[4],
            Int64[4],
            [2, 4],
            Int64[4],
            Int64[4],
            [3, 4],
            [1, 4],
        ])

    end

    @testset "get_membership_sets" begin
        c = BitSetTuple([
            Int64[4],
            Int64[4],
            Int64[4],
            [2, 4],
            Int64[4],
            Int64[4],
            [3, 4],
            [1, 4],
        ])
        @test get_membership_sets(c, 4) == BitSetTuple([
            BitSet([1, 4]),
            BitSet([2, 4]),
            BitSet([3, 4]),
            BitSet([1, 2, 3, 4]),
        ])

    end
end
