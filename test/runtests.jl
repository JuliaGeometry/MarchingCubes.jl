using BenchmarkTools
using MarchingCubes
using Test

@testset "march" begin
    mc = MarchingCubes.test_scenario()

    @btime march($mc)
    @show length(mc.vertices) length(mc.triangles)

    @btime march_legacy($mc)
    @show length(mc.vertices) length(mc.triangles)

end
