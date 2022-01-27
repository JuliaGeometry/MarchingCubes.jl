module MarchingCubes
  import Base: RefValue
  using StaticArrays

  export MC, march

  include("lut.jl")

  const Vertex{T} = MVector{6, T}
  const Triangle = MVector{3, Int}

  struct MC{T} where {T<:AbstractFloat}
    nx::Int
    ny::Int
    nz::Int
    dat::RefValue{Array{T, 3}}
    cube::MVector{8, T}
    tv::MVector{3, Int}
    x_vert::Array{Int, 3}
    y_vert::Array{Int, 3}
    z_vert::Array{Int, 3}
    vertices::Vector{Vertex{T}}
    triangles::Vector{Triangle}
    legacy::Bool
    MC(dat::Array{T, 3}; legacy=false) where T = begin
      new{T}(
        size(dat)..., Ref(dat),
        zeros(MVector{8, T}), zeros(MVector{3, Int}),
        zeros(Int, size(dat)),
        zeros(Int, size(dat)),
        zeros(Int, size(dat)),
        Vertex[], Triangle[],
        legacy
      )
    end
  end

  march(m::MC{T}, isovalue::Number = 0) where T = begin
    empty!(m.triangles)
    empty!(m.vertices)
    dat = m.dat[]
    iso = T(isovalue)
    compute_intersection_points(m, dat, iso)
    @inbounds for k ∈ 1:m.nz-1, j ∈ 1:m.ny-1, i ∈ 1:m.nx-1
      lut = UInt8(0)
      for p ∈ 0:7
        c = dat[i+((p ⊻ (p >> 1)) & 1), j+((p >> 1) & 1), k+((p >> 2) & 1)] - iso
        abs(c) < eps(T) && (c = eps(T))
        c > 0 && (lut += (UInt8(1) << p))
        m.cube[p+1] = c
      end
      lut = Int(lut) + 1

      if m.legacy
        nt = 0
        @inbounds while casesClassic[lut][3nt+1] != -1
          nt += 1
        end
        add_triangle(m, i, j, k, casesClassic[lut], nt)
        continue
      end

      case = cases[lut][1] + 1
      cfg = cases[lut][2] + 1
      subcfg = 1

      if case == 1
        nothing
      elseif case == 2
        add_triangle(m, i, j, k, tiling1[cfg], 1)
      elseif case == 3
        add_triangle(m, i, j, k, tiling2[cfg], 2)
      elseif case == 4
        if test_face(m.cube, test3[cfg])
          add_triangle(m, i, j, k, tiling3_2[cfg], 4)  # 3.2
        else
          add_triangle(m, i, j, k, tiling3_1[cfg], 2)  # 3.1
        end
      elseif case == 5
        if test_interior(case, m.cube, cfg, subcfg, test4[cfg])
          add_triangle(m, i, j, k, tiling4_1[cfg], 2)  # 4.1.1
        else
          add_triangle(m, i, j, k, tiling4_2[cfg], 6)  # 4.1.2
        end
      elseif case == 6
        add_triangle(m, i, j, k, tiling5[cfg], 3)
      elseif case == 7
        if test_face(m.cube, test6[cfg][1])
          add_triangle(m, i, j, k, tiling6_2[cfg], 5)  # 6.2
        else
          if test_interior(case, m.cube, cfg, subcfg, test6[cfg][2])
            add_triangle(m, i, j, k, tiling6_1_1[cfg], 3)  # 6.1.1
          else
            add_triangle(m, i, j, k, tiling6_1_2[cfg], 9, add_c_vertex(m, i, j, k))  # 6.1.2
          end
        end
      elseif case == 8
        test_face(m.cube, test7[cfg][1]) && (subcfg += 1)
        test_face(m.cube, test7[cfg][2]) && (subcfg += 2)
        test_face(m.cube, test7[cfg][3]) && (subcfg += 4)
        if subcfg == 1
          add_triangle(m, i, j, k, tiling7_1[cfg], 3)
        elseif subcfg == 2 || subcfg == 3
          add_triangle(m, i, j, k, tiling7_2[cfg][subcfg-1], 5)
        elseif subcfg == 4
          add_triangle(m, i, j, k, tiling7_3[cfg][1], 9, add_c_vertex(m, i, j, k))
        elseif subcfg == 5
          add_triangle(m, i, j, k, tiling7_2[cfg][3], 5)
        elseif subcfg == 6 || subcfg == 7
          add_triangle(m, i, j, k, tiling7_3[cfg][subcfg-4], 9, add_c_vertex(m, i, j, k))
        elseif subcfg == 8
          if test_interior(case, m.cube, cfg, subcfg, test7[cfg][4])
            add_triangle(m, i, j, k, tiling7_4_2[cfg], 9)
          else
            add_triangle(m, i, j, k, tiling7_4_1[cfg], 5)
          end
        end
      elseif case == 9
        add_triangle(m, i, j, k, tiling8[cfg], 2)
      elseif case == 10
        add_triangle(m, i, j, k, tiling9[cfg], 4)
      elseif case == 11
        if test_face(m.cube, test10[cfg][1])
          if test_face(m.cube, test10[cfg][2])
            add_triangle(m, i, j, k, tiling10_1_1_[cfg], 4)  # 10.1.1
          else
            add_triangle(m, i, j, k, tiling10_2[cfg], 8, add_c_vertex(m, i, j, k))  # 10.2
          end
        else
          if test_face(m.cube, test10[cfg][2])
            add_triangle(m, i, j, k, tiling10_2_[cfg], 8, add_c_vertex(m, i, j, k))  # 10.2
          else
            if test_interior(case, m.cube, cfg, subcfg, test10[cfg][3])
              add_triangle(m, i, j, k, tiling10_1_1[cfg], 4)  # 10.1.1
            else
              add_triangle(m, i, j, k, tiling10_1_2[cfg], 8)  # 10.1.2
            end
          end
        end
      elseif case == 12
        add_triangle(m, i, j, k, tiling11[cfg], 4)
      elseif case == 13
        if test_face(m.cube, test12[cfg][1])
          if test_face(m.cube, test12[cfg][2])
            add_triangle(m, i, j, k, tiling12_1_1_[cfg], 4)  # 12.1.1
          else
            add_triangle(m, i, j, k, tiling12_2[cfg], 8, add_c_vertex(m, i, j, k))  # 12.2
          end
        else
          if test_face(m.cube, test12[cfg][2])
            add_triangle(m, i, j, k, tiling12_2_[cfg], 8, add_c_vertex(m, i, j, k))  # 12.2
          else
            if test_interior(case, m.cube, cfg, subcfg, test12[cfg][3])
              add_triangle(m, i, j, k, tiling12_1_1[cfg], 4)  # 12.1.1
            else
              add_triangle(m, i, j, k, tiling12_1_2[cfg], 8)  # 12.1.2
            end
          end
        end
      elseif case == 14
        test_face(m.cube, test13[cfg][1]) && (subcfg += 1)
        test_face(m.cube, test13[cfg][2]) && (subcfg += 2)
        test_face(m.cube, test13[cfg][3]) && (subcfg += 4)
        test_face(m.cube, test13[cfg][4]) && (subcfg += 8)
        test_face(m.cube, test13[cfg][5]) && (subcfg += 16)
        test_face(m.cube, test13[cfg][6]) && (subcfg += 32)
        if (sc = subcfg13[subcfg]) == 0  # 13.1
          add_triangle(m, i, j, k, tiling13_1[cfg], 4)
        elseif sc ≥ 1 && sc ≤ 6  # 13.2
          add_triangle(m, i, j, k, tiling13_2[cfg][sc], 6)
        elseif sc ≥ 7 && sc ≤ 18  # 13.3
          add_triangle(m, i, j, k, tiling13_3[cfg][sc-6], 10, add_c_vertex(m, i, j, k))
        elseif sc ≥ 19 && sc ≤ 22  # 13.4
          add_triangle(m, i, j, k, tiling13_3[cfg][sc-18], 12, add_c_vertex(m, i, j, k))
        elseif sc ≥ 23 && sc ≤ 26  # 13.5
          subcfg = sc - 22
          if test_interior(case, m.cube, cfg, subcfg, test13[cfg][6])
            add_triangle(m, i, j, k, tiling13_5_1[cfg][subcfg], 6)
          else
            add_triangle(m, i, j, k, tiling13_5_2[cfg][subcfg], 10)
          end
        elseif sc ≥ 27 && sc ≤ 38  # 13.3
          add_triangle(m, i, j, k, tiling13_3_[cfg][sc-26], 10, add_c_vertex(m, i, j, k))
        elseif sc ≥ 39 && sc ≤ 45
          add_triangle(m, i, j, k, tiling13_2_[cfg][sc-38], 6)
        elseif sc > 45
          throw(error("Marching Cubes: Impossible case 13?"))
        end
      elseif case == 15
        add_triangle(m, i, j, k, tiling14[cfg], 4)
      end
    end
  end

  compute_intersection_points(m::MC{T}, dat::AbstractArray, iso::AbstractFloat) where T = begin
    @inbounds for k ∈ axes(dat, 3), j ∈ axes(dat, 2), i ∈ axes(dat, 1)
      c0 = dat[i, j, k]
      c1 = i < m.nx ? dat[i+1, j, k] - iso : c0
      c2 = j < m.ny ? dat[i, j+1, k] - iso : c0
      c3 = k < m.nz ? dat[i, j, k+1] - iso : c0
      abs(c0) < eps(T) && (c0 = eps(T))
      abs(c1) < eps(T) && (c1 = eps(T))
      abs(c2) < eps(T) && (c2 = eps(T))
      abs(c3) < eps(T) && (c3 = eps(T))
      m.cube[1] = c0
      m.cube[2] = c1
      m.cube[3] = c2
      m.cube[4] = c3
      if c0 < 0
        c1 > 0 && (m.x_vert[i, j, k] = add_x_vertex(m, dat, i, j, k))
        c2 > 0 && (m.y_vert[i, j, k] = add_y_vertex(m, dat, i, j, k))
        c3 > 0 && (m.z_vert[i, j, k] = add_z_vertex(m, dat, i, j, k))
      else
        c1 < 0 && (m.x_vert[i, j, k] = add_x_vertex(m, dat, i, j, k))
        c2 < 0 && (m.y_vert[i, j, k] = add_y_vertex(m, dat, i, j, k))
        c3 < 0 && (m.z_vert[i, j, k] = add_z_vertex(m, dat, i, j, k))
      end
    end
  end

  test_interior(case, cb::MVector{N, T}, cfg, subcfg, s) where {N, T} = begin
    test = 0
    if case == 5 || case == 11
      a = (cb[5] - cb[1]) * (cb[7] - cb[3]) - (cb[8] - cb[4]) * (cb[6] - cb[2])
      b = cb[3] * (cb[5] - cb[1]) + cb[1] * (cb[7] - cb[3]) - cb[2] * (cb[8] - cb[4]) - cb[4] * (cb[6] - cb[2])
      t = -b / 2a
      (t < 0 || t > 1) && return s > 0

      At = cb[1] + (cb[5] - cb[1]) * t
      Bt = cb[4] + (cb[8] - cb[4]) * t
      Ct = cb[3] + (cb[7] - cb[3]) * t
      Dt = cb[2] + (cb[6] - cb[2]) * t
    elseif case == 7 || case == 8 || case == 13 || case == 14
      # reference edge of the triangulation
      edge = if case == 7
        test6[cfg][3]
      elseif case == 8
        test7[cfg][5]
      elseif case == 13
        test12[cfg][4]
      elseif case == 14
        tiling13_5_1[cfg][subcfg][1]
      else
        -1
      end
      At = 0
      if edge == 0
        t = cb[1] / (cb[1] - cb[2])
        Bt = cb[4] + (cb[3] - cb[4]) * t
        Ct = cb[8] + (cb[7] - cb[8]) * t
        Dt = cb[5] + (cb[6] - cb[5]) * t
      elseif edge == 1
        t = cb[2] / (cb[2] - cb[3])
        Bt = cb[1] + (cb[4] - cb[1]) * t
        Ct = cb[5] + (cb[8] - cb[5]) * t
        Dt = cb[6] + (cb[7] - cb[6]) * t
      elseif edge == 2
        t = cb[3] / (cb[3] - cb[4])
        Bt = cb[2] + (cb[1] - cb[2]) * t
        Ct = cb[6] + (cb[5] - cb[6]) * t
        Dt = cb[7] + (cb[8] - cb[7]) * t
      elseif edge == 3
        t = cb[4] / (cb[4] - cb[1])
        Bt = cb[3] + (cb[2] - cb[3]) * t
        Ct = cb[7] + (cb[6] - cb[7]) * t
        Dt = cb[8] + (cb[5] - cb[8]) * t
      elseif edge == 4
        t = cb[5] / (cb[5] - cb[6])
        Bt = cb[8] + (cb[7] - cb[8]) * t
        Ct = cb[4] + (cb[3] - cb[4]) * t
        Dt = cb[1] + (cb[2] - cb[1]) * t
      elseif edge == 5
        t = cb[6] / (cb[6] - cb[7])
        Bt = cb[5] + (cb[8] - cb[5]) * t
        Ct = cb[1] + (cb[4] - cb[1]) * t
        Dt = cb[2] + (cb[3] - cb[2]) * t
      elseif edge == 6
        t = cb[7] / (cb[7] - cb[6])
        Bt = cb[6] + (cb[5] - cb[6]) * t
        Ct = cb[2] + (cb[1] - cb[2]) * t
        Dt = cb[3] + (cb[4] - cb[3]) * t
      elseif edge == 7
        t = cb[8] / (cb[8] - cb[5])
        Bt = cb[7] + (cb[6] - cb[7]) * t
        Ct = cb[3] + (cb[2] - cb[3]) * t
        Dt = cb[4] + (cb[1] - cb[4]) * t
      elseif edge == 8
        t = cb[1] / (cb[1] - cb[5])
        Bt = cb[4] + (cb[8] - cb[4]) * t
        Ct = cb[3] + (cb[7] - cb[3]) * t
        Dt = cb[2] + (cb[6] - cb[2]) * t
      elseif edge == 9
        t = cb[2] / (cb[2] - cb[6])
        Bt = cb[1] + (cb[5] - cb[1]) * t
        Ct = cb[4] + (cb[8] - cb[4]) * t
        Dt = cb[3] + (cb[7] - cb[3]) * t
      elseif edge == 10
        t = cb[3] / (cb[3] - cb[7])
        Bt = cb[2] + (cb[6] - cb[2]) * t
        Ct = cb[1] + (cb[5] - cb[1]) * t
        Dt = cb[4] + (cb[8] - cb[4]) * t
      elseif edge == 11
        t = cb[4] / (cb[4] - cb[8])
        Bt = cb[3] + (cb[7] - cb[3]) * t
        Ct = cb[2] + (cb[6] - cb[2]) * t
        Dt = cb[1] + (cb[5] - cb[1]) * t
      else
        throw(throw(error("Invalid edge $edge")))
      end

    else
      throw(throw(error("Invalid ambiguous case $case")))
    end

    At ≥ 0 && (test += 1)
    Bt ≥ 0 && (test += 2)
    Ct ≥ 0 && (test += 4)
    Dt ≥ 0 && (test += 8)
    return if test == 6 || test == 8 || test == 9 || test == 12 || (test ≥ 0 && test ≤ 4)
      s > 0
    elseif test == 5
      (At * Ct - Bt * Dt < eps(T)) ? s > 0 : s < 0
    elseif test == 10
      (At * Ct - Bt * Dt ≥ eps(T)) ? s > 0 : s < 0
    else  # test == 7 || test == 11 || test ≥ 13
      s < 0
    end
  end

  test_face(cb::MVector{N, T}, face) where {N, T} = begin
    if (af = abs(face)) == 1
      A = cb[1]; B = cb[5]; C = cb[6]; D = cb[2]
    elseif af == 2
      A = cb[2]; B = cb[6]; C = cb[7]; D = cb[3]
    elseif af == 3
      A = cb[3]; B = cb[7]; C = cb[8]; D = cb[4]
    elseif af == 4
      A = cb[4]; B = cb[8]; C = cb[5]; D = cb[1]
    elseif af == 5
      A = cb[1]; B = cb[4]; C = cb[3]; D = cb[2]
    elseif af == 6
      A = cb[5]; B = cb[8]; C = cb[7]; D = cb[6]
    end
    abs(A * C - B * D) < eps(T) ? face ≥ 0 : face * A * (A * C - B * D) ≥ 0  # face and A invert signs
  end

  """
  add_triangle(...)

  # Description
  Routine to add a triangle to the mesh

  # Arguments
    - `trig` the code for the triangle as a sequence of edges index.
    - `n` the number of triangles to produce.
    - `v12` the index of the interior vertex to use, if necessary.
  """
  @inline add_triangle(m::MC, i, j, k, tri, n, v12=-1) = begin
    @inbounds for t ∈ 1:3n
      m.tv[(t-1)%3+1] = if (tr = tri[t]) == 0
        m.x_vert[i, j, k]
      elseif tr == 1
        m.y_vert[i+1, j, k]
      elseif tr == 2
        m.x_vert[i, j+1, k]
      elseif tr == 3
        m.y_vert[i, j, k]
      elseif tr == 4
        m.x_vert[i, j, k+1]
      elseif tr == 5
        m.y_vert[i+1, j, k+1]
      elseif tr == 6
        m.x_vert[i, j+1, k+1]
      elseif tr == 7
        m.y_vert[i, j, k+1]
      elseif tr == 8
        m.z_vert[i, j, k]
      elseif tr == 9
        m.z_vert[i+1, j, k]
      elseif tr == 10
        m.z_vert[i+1, j+1, k]
      elseif tr == 11
        m.z_vert[i, j+1, k]
      elseif tr == 12
        v12
      end
      # @assert m.tv[(t-1)%3+1] != -1
      (t-1)%3 == 2 && push!(m.triangles, Triangle(m.tv...))
    end
    return
  end

  @inline x_grad(m::MC, dat, i, j, k) = (
    i > 1 ? (
      i < m.nx ? (dat[i+1, j, k] - dat[i-1, j, k]) / 2 : (dat[i, j, k] - dat[i-1, j, k])
    ) : (dat[i+1, j, k] - dat[i, j, k])
  )

  @inline y_grad(m::MC, dat, i, j, k) = (
    j > 1 ? (
      j < m.ny ? (dat[i, j+1, k] - dat[i, j-1, k]) / 2 : (dat[i, j, k] - dat[i, j-1, k])
    ) : (dat[i, j+1, k] - dat[i, j, k])
  )

  @inline z_grad(m::MC, dat, i, j, k) = (
    k > 1 ? (
      k < m.nz ? (dat[i, j, k+1] - dat[i, j, k-1]) / 2 : (dat[i, j, k] - dat[i, j, k-1])
    ) : (dat[i, j, k+1] - dat[i, j, k])
  )

  @inline norm(v) = √(v[4]^2 + v[5]^2 + v[6]^2)

  add_x_vertex(m::MC{T}, dat, i, j, k) where T = begin
    nv = length(m.vertices)
    u = m.cube[1] / (m.cube[1] - m.cube[2])
    vert = Vertex(
      i + u, j, k,
      (1 - u) * x_grad(m, dat, i, j, k) + u * x_grad(m, dat, i + 1, j, k),
      (1 - u) * y_grad(m, dat, i, j, k) + u * y_grad(m, dat, i + 1, j, k),
      (1 - u) * z_grad(m, dat, i, j, k) + u * z_grad(m, dat, i + 1, j, k),
    )
    (u=norm(vert)) > 0 && (vert[4:6] ./= u)
    push!(m.vertices, vert)
    nv
  end

  add_y_vertex(m::MC{T}, dat, i, j, k) where T = begin
    nv = length(m.vertices)
    u = m.cube[1] / (m.cube[1] - m.cube[3])
    vert = Vertex(
      i, j + u, k,
      (1 - u) * x_grad(m, dat, i, j, k) + u * x_grad(m, dat, i, j + 1, k),
      (1 - u) * y_grad(m, dat, i, j, k) + u * y_grad(m, dat, i, j + 1, k),
      (1 - u) * z_grad(m, dat, i, j, k) + u * z_grad(m, dat, i, j + 1, k),
    )
    (u=norm(vert)) > 0 && (vert[4:6] ./= u)
    push!(m.vertices, vert)
    nv
  end

  add_z_vertex(m::MC{T}, dat, i, j, k) where T = begin
    nv = length(m.vertices)
    u = m.cube[1] / (m.cube[1] - m.cube[4])
    vert = Vertex(
      i, j, k + u,
      (1 - u) * x_grad(m, dat, i, j, k) + u * x_grad(m, dat, i, j, k + 1),
      (1 - u) * y_grad(m, dat, i, j, k) + u * y_grad(m, dat, i, j, k + 1),
      (1 - u) * z_grad(m, dat, i, j, k) + u * z_grad(m, dat, i, j, k + 1),
    )
    (u=norm(vert)) > 0 && (vert[4:6] ./= u)
    push!(m.vertices, vert)
    nv
  end

  add_c_vertex(m::MC{T}, i, j, k) where T = begin
    nv = length(m.vertices)
    vert = Vertex(0, 0, 0, 0, 0, 0)

    # computes the average of the intersection points of the cube
    u = T(0)
    (id=m.x_vert[i, j, k]) == -1 || (u += 1; vert .+= m.vertices[id])
    (id=m.y_vert[i+1, j, k]) == -1 || (u += 1; vert .+= m.vertices[id])
    (id=m.x_vert[i, j+1, k]) == -1 || (u += 1; vert .+= m.vertices[id])
    (id=m.y_vert[i, j, k]) == -1 || (u += 1; vert .+= m.vertices[id])
    (id=m.x_vert[i, j, k+1]) == -1 || (u += 1; vert .+= m.vertices[id])
    (id=m.y_vert[i+1, j, k+1]) == -1 || (u += 1; vert .+= m.vertices[id])
    (id=m.x_vert[i, j+1, k+1]) == -1 || (u += 1; vert .+= m.vertices[id])
    (id=m.x_vert[i, j, k+1]) == -1 || (u += 1; vert .+= m.vertices[id])
    (id=m.y_vert[i, j, k+1]) == -1 || (u += 1; vert .+= m.vertices[id])
    (id=m.z_vert[i, j, k]) == -1 || (u += 1; vert .+= m.vertices[id])
    (id=m.z_vert[i+1, j, k]) == -1 || (u += 1; vert .+= m.vertices[id])
    (id=m.z_vert[i+1, j+1, k]) == -1 || (u += 1; vert .+= m.vertices[id])
    (id=m.z_vert[i, j+1, k]) == -1 || (u += 1; vert .+= m.vertices[id])
    vert[1:3] ./= u

    (u=norm(vert)) > 0 && (vert[4:6] ./= u)
    push!(m.vertices, vert)
    nv
  end

end
