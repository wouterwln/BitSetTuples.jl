@testitem "BitSetTuple" begin
    using BitSetTuples
    import BitSetTuples: contents

    @testset "constructor" begin
        for i = 1:10
            @test contents(BitSetTuple(i)) == Tuple([BitSet(1:i) for _ = 1:i])
        end
        @test contents(BitSetTuple([[1], [2], [3]])) ==
              Tuple([BitSet(1), BitSet(2), BitSet(3)])

        @test BitSetTuple(((1, 2, 3), (1, 2, 3), (1, 2, 3))) == BitSetTuple(3)
    end

    @testset "iterator" begin
        for i = 1:10
            @test collect(BitSetTuple(i)) == [BitSet(1:i) for _ = 1:i]
        end
        @test collect(BitSetTuple([[1], [2], [3]])) == [BitSet(1), BitSet(2), BitSet(3)]
    end

    @testset "length" begin
        for i = 1:10
            @test length(BitSetTuple(i)) == i
        end
        @test length(BitSetTuple([[1], [2], [3]])) == 3
    end

    @testset "getindex" begin
        for i = 1:10
            @test getindex(BitSetTuple(i), i) == BitSet(1:i)
        end
        @test getindex(BitSetTuple([[1], [2], [3]]), 1) == BitSet(1)
        @test getindex(BitSetTuple([[1], [2], [3]]), 2) == BitSet(2)
        @test getindex(BitSetTuple([[1], [2], [3]]), 3) == BitSet(3)
    end

    @testset "intersect!" begin
        left = BitSetTuple(4)
        right = BitSetTuple(4)
        intersect!(left, right)
        @test left == BitSetTuple(4)
        @test intersect!(left, right) === left

        left = BitSetTuple(3)
        right = BitSetTuple(4)
        @test_throws MethodError intersect!(left, right)

        left = BitSetTuple(4)
        right = BitSetTuple([collect(1:i) for i = 1:4])
        intersect!(left, right)
        @test left == right
        @test intersect!(left, right) === left
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

    @testset "is_valid_partition" begin
        @test is_valid_partition(BitSetTuple(3))
        @test is_valid_partition(BitSetTuple([[1], [2], [3]]))
        @test !is_valid_partition(BitSetTuple([[1, 2], [2], [3]]))
        @test !is_valid_partition(BitSetTuple([[1], [2, 3], [3]]))
        @test is_valid_partition(BitSetTuple([[1, 2], [1, 2], [3]]))
        @test !is_valid_partition(BitSetTuple([[1, 2], [4]]))
    end
end

@testitem "BoundedBitSetTuple" begin
    using BitSetTuples
    import BitSetTuples: __contents

    @testset "constructor" begin
        for i = 1:10
            @test BoundedBitSetTuple(rand, i, 10) isa BoundedBitSetTuple
            @test BoundedBitSetTuple(UndefInitializer(), i, i) isa BoundedBitSetTuple 
            @test BoundedBitSetTuple(UndefInitializer(), i) isa BoundedBitSetTuple
            @test @inferred BoundedBitSetTuple(zeros, i, i + 1) == BoundedBitSetTuple(BitMatrix(zeros(Bool, (i, i + 1))))
            @test @inferred BoundedBitSetTuple(i) == BoundedBitSetTuple(ones, i)
            @test @inferred BoundedBitSetTuple(i) == BoundedBitSetTuple(ones, i, i)
        end
    end

    @testset "contents" begin
        for i = 1:10
            @test contents(BoundedBitSetTuple(i)) == Tuple.(contents(BitSetTuple(i)))
        end
    end

    @testset "length" begin
        for i = 1:10
            @test length(BoundedBitSetTuple(i)) == i
        end
    end

    @testset "size" begin
        for i = 1:10
            @test size(BoundedBitSetTuple(i)) == (i, i)
        end
    end

    @testset "getindex" begin
        for i = 1:10
            @test getindex(BoundedBitSetTuple(i), i) == BitVector(ones(Bool, i))
            @test getindex(BoundedBitSetTuple(i), i, i) == true
        end
    end

    @testset "setindex!" begin
        for i = 1:10
            b = BoundedBitSetTuple(i)
            setindex!(b, false, i, i)
            @test getindex(b, i, i) == false
            setindex!(b, true, i, i)
            @test getindex(b, i, i) == true
        end
    end

    @testset "intersect!" begin
        left = BoundedBitSetTuple(4)
        right = BoundedBitSetTuple(4)
        intersect!(left, right)
        @test left == BoundedBitSetTuple(4)
        @test intersect!(left, right) === left

        left = BoundedBitSetTuple(3)
        right = BoundedBitSetTuple(4)
        @test_throws DimensionMismatch intersect!(left, right)

        left = BoundedBitSetTuple(4)
        right = BoundedBitSetTuple(4)
        for i = 1:4, j = i:4
            delete!(right, i, j)
        end

        intersect!(left, right)
        @test left == right
        @test intersect!(left, right) === left
    end


    # Test intersect function
    @testset "intersect" begin
        b1 = BoundedBitSetTuple(3)
        delete!(b1, 1, 1)
        b2 = BoundedBitSetTuple(3)
        for i = 2:3, j = i:3
            delete!(b2, i, j)
        end
        b3 = intersect(b1, b2)
        @test __contents(b3) == BitMatrix(Bool[0 1 1; 1 0 0; 1 1 0])
    end

    # Test union! function
    @testset "union!" begin
        b1 = BoundedBitSetTuple(zeros(Bool, (3, 3)))
        insert!(b1, 1, 1)
        b2 = BoundedBitSetTuple(zeros(Bool, (3, 3)))
        insert!(b2, 2, 3)
        union!(b1, b2)
        @test sum(__contents(b1)) === 2
        @test b1[1, 1] && b1[2, 3]
    end

    # Test union function
    @testset "union" begin
        b1 = BoundedBitSetTuple(zeros(Bool, (3, 3)))
        insert!(b1, 1, 1)
        b2 = BoundedBitSetTuple(zeros(Bool, (3, 3)))
        insert!(b2, 2, 3)
        b3 = union(b1, b2)
        @test sum(__contents(b3)) === 2
        @test b3[1, 1] && b3[2, 3]
    end

    # Test == operator
    @testset "== operator" begin
        b1 = BoundedBitSetTuple(3)
        b2 = BoundedBitSetTuple(3)
        b3 = BoundedBitSetTuple(4)
        @test b1 == b2
        @test !(b1 == b3)
    end

    @testset "is_valid_partition" begin
        @test is_valid_partition(BoundedBitSetTuple(3))
        @test is_valid_partition(BoundedBitSetTuple(4))
        @test is_valid_partition(BoundedBitSetTuple(BitMatrix(Bool[1 1 0; 1 1 0; 0 0 1])))
        @test !is_valid_partition(BoundedBitSetTuple(BitMatrix(Bool[1 1 0; 1 1 0; 0 1 1])))
        @test !is_valid_partition(BoundedBitSetTuple(BitMatrix(Bool[1 1 0; 1 1 0; 0 0 0])))
    end
end
