using BenchmarkTools
using MarchingCubes
using Test

@testset begin "march"
  nx = ny = nz = 60
  dat = zeros(Float32, nx, ny, nz)

  sx, sy, sz = size(dat) ./ 16
  tx = nx / 2sx
  ty = ny / 2sy + 1.5
  tz = nz / 2sz

  r = 1.85
  R = 4

  cushin(x, y, z) = (
    z^2 * x^2 - z^4 - 2z * x^2 + 2z^3 + x^2 - z^2 -
    (x^2 - z) * (x^2 - z) - y^4 - 2x^2 *y^2 - y^2 *z^2 + 2y^2 *z + y^2
  )

  torus2(x, y, z) = (
    (x^2 + y^2 + z^2 + R^2 - r^2) *
    (x^2 + y^2 + z^2 + R^2 - r^2) - 4R^2 * (x^2 + y^2)
  ) * (
    (x^2 + (y + R) * (y + R) + z^2 + R^2 - r^2) *
    (x^2 + (y + R) * (y + R) + z^2 + R^2 - r^2) - 4R^2 * ((y + R) * (y + R) + z^2)
  )

  sphere(x, y, z) = (
    ((x - 2) * (x - 2) + (y - 2) * (y - 2) + (z - 2) * (z - 2) - 1) *
    ((x + 2) * (x + 2) + (y - 2) * (y - 2) + (z - 2) * (z - 2) - 1) *
    ((x - 2) * (x - 2) + (y + 2) * (y + 2) + (z - 2) * (z - 2) - 1)
  )

  plane(x, y, z) = x + y + z -3

  cassini(x, y, z) = (
    (x^2 + y^2 + z^2 + .45^2) *
    (x^2 + y^2 + z^2 + .45^2) - 16 * .45^2 * (x^2 + z^2) - .5^2
  )

  blooby(x, y, z) = x^4 - 5x^2 + y^4 - 5y^2 + z^4 - 5z^2 + 11.8

  for k ∈ 1:nz, j ∈ 1:ny, i ∈ 1:nx
    dat[i, j, k] = torus2(i / sx - tx, j / sy - ty, k / sz - tz)
  end

  mc = MC(dat)
  @btime march($mc)
  @show length(mc.vertices) length(mc.triangles)

  mc = MC(dat; legacy=true)
  @btime march($mc)
  @show length(mc.vertices) length(mc.triangles)

end
