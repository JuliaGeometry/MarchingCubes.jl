using BenchmarkTools
using MarchingCubes
using Test

@testset "march" begin
    mc = MarchingCubes.scenario()

    march(mc)
    @test length(mc.vertices) == 11_333
    @test length(mc.triangles) == 22_620

    march_legacy(mc)
    @test length(mc.vertices) == 11_333
    @test length(mc.triangles) == 22_732
end
