using GrayCodeIterator
using Test

@testset "GrayCodeIterator.jl" begin

    # check if we get the correct number of items in the iterator
    @test length(GrayCode(23,13)) == count(true for v in GrayCode(23,13))
    @test length(GrayCode(2,3)) == count(true for v in GrayCode(2,3)) == 0

    # make sure Base.in is defined properly
    @test [0,0,1,1,0,1] ∈ GrayCode(6,3)
    @test [0,0,1,1,0,1] ∈ GrayCode(6,3,[0,0])
    @test [0,0,1,1,0,1] ∉ GrayCode(6,3,[1,0])
    @test [0,0,1,1,0,1] ∉ GrayCode(6,2)
    @test [0,0,1,1,0,1] ∉ GrayCode(6,2,[0,0,1])
    @test [0,0,1,1,0,1] ∉ GrayCode(5,3)

    # check a particular case, but order doesn't matter
    V_check = collect(GrayCode(5,2))
    V_correct = [[0, 0, 0, 1, 1]
                 [0, 0, 1, 1, 0]
                 [0, 0, 1, 0, 1]
                 [0, 1, 1, 0, 0]
                 [0, 1, 0, 1, 0]
                 [0, 1, 0, 0, 1]
                 [1, 1, 0, 0, 0]
                 [1, 0, 1, 0, 0]
                 [1, 0, 0, 1, 0]
                 [1, 0, 0, 0, 1]]
    @test length(V_check) == length(intersect(V_check, V_correct)) == 10

    # make sure eltype is correct
    @test eltype(GrayCode(5,2)) == typeof(first(GrayCode(5,2)))

    # check length and weight edge cases when there should only be one element returned
    @test collect(GrayCode(5,5)) == [[1,1,1,1,1]]
    @test collect(GrayCode(5,4,[0])) == [[0,1,1,1,1]]
    @test collect(GrayCode(5,0)) == [[0,0,0,0,0]]
    @test collect(GrayCode(5,1,[1])) == [[1,0,0,0,0]]
    @test collect(GrayCode(0,0)) == [Int[]]
    @test collect(GrayCode(3,2,[1,0,1])) == [[1,0,1]]

    # check that the iterator is empty when it should be
    @test isempty(GrayCode(3,5))
    @test isempty(GrayCode(0,5))
    @test isempty(GrayCode(3,1,[1,1]))
    @test isempty(GrayCode(3,1,[0,0,0]))
    @test isempty(GrayCode(3,1,[0,0,0,0]))
end

