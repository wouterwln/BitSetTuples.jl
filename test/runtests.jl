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


    # Test intersect function
    @testset "intersect" begin
        b1 = BitSetTuple(3)
        b2 = BitSetTuple([[1, 2, 3], [4], [4]])
        b3 = intersect(b1, b2)
        @test contents(b3) == (BitSet([1, 2, 3]), BitSet(), BitSet())
    end

    # Test union! function
    @testset "union!" begin
        b1 = BitSetTuple(3)
        b2 = BitSetTuple([[1, 2, 3], [4], [4]])
        union!(b1, b2)
        @test contents(b1) ==
              (BitSet([1, 2, 3]), BitSet([1, 2, 3, 4]), BitSet([1, 2, 3, 4]))
    end

    # Test union function
    @testset "union" begin
        b1 = BitSetTuple(3)
        b2 = BitSetTuple([[1, 2, 3], [4], [4]])
        b3 = union(b1, b2)
        @test contents(b3) ==
              (BitSet([1, 2, 3]), BitSet([1, 2, 3, 4]), BitSet([1, 2, 3, 4]))
    end

    # Test == operator
    @testset "== operator" begin
        b1 = BitSetTuple(3)
        b2 = BitSetTuple(3)
        b3 = BitSetTuple(4)
        @test b1 == b2
        @test !(b1 == b3)
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
