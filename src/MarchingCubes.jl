raw"""

@article{marching_cubes_jgt,
    author = {Thomas Lewiner and Hélio Lopes and Antônio Wilson Vieira and Geovan Tavares},
    title = {Efficient implementation of marching cubes cases with topological guarantees},
    year = {2003},
    month = {december},
    journal = {Journal of Graphics Tools},
    volume = {8},
    number = {2},
    pages = {1--15},
    publisher = {A.K.Peters},
    doi = {10.1080/10867651.2003.10487582},
    url = {\url{http://thomas.lewiner.org/pdfs/marching_cubes_jgt.pdf}}
}

Adapted to `Julia` by T Bltg (github.com/t-bltg).
"""

module MarchingCubes

import Base: RefValue
using StaticArrays

export MC, march, march_legacy

include("lut.jl")

const Vertex{F} = SVector{3,F}
const Normal{F} = SVector{3,F}
const Triangle = SVector{3,Int}

"""
    MC(dat::Array{F,3}, I::Type = Int)

# Description
Structure to hold temporaries for the marching cube algorithm.
Vertices, normals and triangles are accessible using `m.vertices`, `m.normals` and `m.triangles`.
1-based indexing is assumed.

# Arguments
    - `dat`: rank 3 array of floating values on which the Marching Cubes algorithm is applied.
    - `I`: Int32, Int64, ...: vertices / normals / triangles index `Integer` type.
"""
struct MC{F,I}
    nx::Int
    ny::Int
    nz::Int
    dat::RefValue{Array{F,3}}
    cube::MVector{8,F}  # values of the implicit function on the active cube
    tv::MVector{3,Int}
    vtx::MVector{3,F}  # vertex buffer
    nrm::MVector{3,F}  # normal buffer
    x_vert::Array{I,3}
    y_vert::Array{I,3}
    z_vert::Array{I,3}
    triangles::Vector{Triangle}
    vertices::Vector{Vertex{F}}
    normals::Vector{Normal{F}}
    MC(dat::Array{F,3}, I::Type{G} = Int) where {F,G<:Integer} = begin
        m = new{F,I}(
            size(dat)...,
            Ref(dat),
            zeros(F, 8),
            zeros(Int, 3),
            zeros(F, 3),
            zeros(F, 3),
            zeros(I, size(dat)),
            zeros(I, size(dat)),
            zeros(I, size(dat)),
            Triangle[],
            Normal[],
            Vertex[],
        )
        sz = size(dat) |> prod
        sizehint!(m.triangles, nextpow(2, sz ÷ 6))
        sizehint!(m.vertices, nextpow(2, sz ÷ 2))
        sizehint!(m.normals, nextpow(2, sz ÷ 2))
        m
    end
end

"""
    lut_entry(args...; kwargs...)

# Description
Cube sign representation
"""
lut_entry(dat::Array{F,3}, cb, i, j, k, iso) where {F} = begin
    lut = UInt8(0)
    @inbounds for p ∈ 0:7
        c = dat[i+((p⊻(p>>1))&1), j+((p>>1)&1), k+((p>>2)&1)] - iso
        abs(c) < eps(F) && (c = eps(F))
        c > 0 && (lut += (UInt8(1) << p))
        cb[p+1] = c
    end
    Int(lut) + 1
end

"""
    march_legacy(m::MC, isovalue::Number)

# Decription
Original Marching Cubes algorithm.
"""
march_legacy(m::MC{F}, isovalue::Number = 0) where {F} = begin
    empty!(m.triangles)
    empty!(m.vertices)
    empty!(m.normals)
    dat = m.dat[]
    iso = F(isovalue)
    compute_intersection_points(m, dat, m.cube, iso)
    @inbounds for k ∈ 1:m.nz-1, j ∈ 1:m.ny-1, i ∈ 1:m.nx-1
        lut = lut_entry(dat, m.cube, i, j, k, iso)
        nt = 0
        while casesClassic[lut][3nt+1] > 0
            nt += 1
        end
        add_triangle(m, i, j, k, casesClassic[lut], nt)
    end
end

"""
    march(m::MC, isovalue::Number)

# Decription
Enhanced topologically controlled Marching Cubes algorithm.
"""
march(m::MC{F}, isovalue::Number = 0) where {F} = begin
    empty!(m.triangles)
    empty!(m.vertices)
    empty!(m.normals)
    dat = m.dat[]
    iso = F(isovalue)
    compute_intersection_points(m, dat, m.cube, iso)
    @inbounds for k ∈ 1:m.nz-1, j ∈ 1:m.ny-1, i ∈ 1:m.nx-1
        lut = lut_entry(dat, m.cube, i, j, k, iso)

        case = cases[lut][1]  # case of the active cube in [1; 16]
        cfg = cases[lut][2]  # configuration of the active cube
        subcfg = 1  # subconfiguration of the active cube

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
                add_triangle(m, i, j, k, tiling13_4[cfg][sc-18], 12, add_c_vertex(m, i, j, k))
            elseif sc ≥ 23 && sc ≤ 26  # 13.5
                subcfg = sc - 22
                if test_interior(case, m.cube, cfg, subcfg, test13[cfg][6])
                    add_triangle(m, i, j, k, tiling13_5_1[cfg][subcfg], 6)
                else
                    add_triangle(m, i, j, k, tiling13_5_2[cfg][subcfg], 10)
                end
            elseif sc ≥ 27 && sc ≤ 38  # 13.3
                add_triangle(m, i, j, k, tiling13_3_[cfg][sc-26], 10, add_c_vertex(m, i, j, k))
            elseif sc ≥ 39 && sc ≤ 45  # 13.2
                add_triangle(m, i, j, k, tiling13_2_[cfg][sc-38], 6)
            elseif sc > 45
                throw(error("Marching Cubes: Impossible case 13?"))
            end
        elseif case == 15
            add_triangle(m, i, j, k, tiling14[cfg], 4)
        end
    end
    return
end

"""
    compute_intersection_points(args...; kwargs...)

# Description
Computes almost all the vertices of the mesh by interpolation along the cubes edges.
"""
compute_intersection_points(m::MC{F}, dat, cb, iso) where {F} = begin
    @inbounds for k ∈ axes(dat, 3), j ∈ axes(dat, 2), i ∈ axes(dat, 1)
        c0 = dat[i, j, k]
        c1 = i < m.nx ? dat[i+1, j, k] - iso : c0
        c2 = j < m.ny ? dat[i, j+1, k] - iso : c0
        c3 = k < m.nz ? dat[i, j, k+1] - iso : c0
        m.cube[1] = abs(c0) < eps(F) ? eps(F) : c0
        m.cube[2] = abs(c1) < eps(F) ? eps(F) : c1
        m.cube[4] = abs(c2) < eps(F) ? eps(F) : c2
        m.cube[5] = abs(c3) < eps(F) ? eps(F) : c3
        if m.cube[1] < 0
            m.cube[2] > 0 && (m.x_vert[i, j, k] = add_x_vertex(m, dat, cb, i, j, k))
            m.cube[4] > 0 && (m.y_vert[i, j, k] = add_y_vertex(m, dat, cb, i, j, k))
            m.cube[5] > 0 && (m.z_vert[i, j, k] = add_z_vertex(m, dat, cb, i, j, k))
        else
            m.cube[2] < 0 && (m.x_vert[i, j, k] = add_x_vertex(m, dat, cb, i, j, k))
            m.cube[4] < 0 && (m.y_vert[i, j, k] = add_y_vertex(m, dat, cb, i, j, k))
            m.cube[5] < 0 && (m.z_vert[i, j, k] = add_z_vertex(m, dat, cb, i, j, k))
        end
    end
    return
end

"""
    test_interior(args...; kwargs...)

# Description
Tests if the components of the tesselation of the cube should be connected through the interior of the cube.
"""
test_interior(case, cb::MVector{N,T}, cfg, subcfg, s) where {N,T} = begin
    test = 0
    @inbounds begin
        if case == 5 || case == 11
            a = (cb[5] - cb[1]) * (cb[7] - cb[3]) - (cb[8] - cb[4]) * (cb[6] - cb[2])
            b = (
                cb[3] * (cb[5] - cb[1]) + cb[1] * (cb[7] - cb[3]) -
                cb[2] * (cb[8] - cb[4]) - cb[4] * (cb[6] - cb[2])
            )
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
                0
            end
            At = 0
            if edge == 1
                t = cb[1] / (cb[1] - cb[2])
                Bt = cb[4] + (cb[3] - cb[4]) * t
                Ct = cb[8] + (cb[7] - cb[8]) * t
                Dt = cb[5] + (cb[6] - cb[5]) * t
            elseif edge == 2
                t = cb[2] / (cb[2] - cb[3])
                Bt = cb[1] + (cb[4] - cb[1]) * t
                Ct = cb[5] + (cb[8] - cb[5]) * t
                Dt = cb[6] + (cb[7] - cb[6]) * t
            elseif edge == 3
                t = cb[3] / (cb[3] - cb[4])
                Bt = cb[2] + (cb[1] - cb[2]) * t
                Ct = cb[6] + (cb[5] - cb[6]) * t
                Dt = cb[7] + (cb[8] - cb[7]) * t
            elseif edge == 4
                t = cb[4] / (cb[4] - cb[1])
                Bt = cb[3] + (cb[2] - cb[3]) * t
                Ct = cb[7] + (cb[6] - cb[7]) * t
                Dt = cb[8] + (cb[5] - cb[8]) * t
            elseif edge == 5
                t = cb[5] / (cb[5] - cb[6])
                Bt = cb[8] + (cb[7] - cb[8]) * t
                Ct = cb[4] + (cb[3] - cb[4]) * t
                Dt = cb[1] + (cb[2] - cb[1]) * t
            elseif edge == 6
                t = cb[6] / (cb[6] - cb[7])
                Bt = cb[5] + (cb[8] - cb[5]) * t
                Ct = cb[1] + (cb[4] - cb[1]) * t
                Dt = cb[2] + (cb[3] - cb[2]) * t
            elseif edge == 7
                t = cb[7] / (cb[7] - cb[6])
                Bt = cb[6] + (cb[5] - cb[6]) * t
                Ct = cb[2] + (cb[1] - cb[2]) * t
                Dt = cb[3] + (cb[4] - cb[3]) * t
            elseif edge == 8
                t = cb[8] / (cb[8] - cb[5])
                Bt = cb[7] + (cb[6] - cb[7]) * t
                Ct = cb[3] + (cb[2] - cb[3]) * t
                Dt = cb[4] + (cb[1] - cb[4]) * t
            elseif edge == 9
                t = cb[1] / (cb[1] - cb[5])
                Bt = cb[4] + (cb[8] - cb[4]) * t
                Ct = cb[3] + (cb[7] - cb[3]) * t
                Dt = cb[2] + (cb[6] - cb[2]) * t
            elseif edge == 10
                t = cb[2] / (cb[2] - cb[6])
                Bt = cb[1] + (cb[5] - cb[1]) * t
                Ct = cb[4] + (cb[8] - cb[4]) * t
                Dt = cb[3] + (cb[7] - cb[3]) * t
            elseif edge == 11
                t = cb[3] / (cb[3] - cb[7])
                Bt = cb[2] + (cb[6] - cb[2]) * t
                Ct = cb[1] + (cb[5] - cb[1]) * t
                Dt = cb[4] + (cb[8] - cb[4]) * t
            elseif edge == 12
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

"""
    test_face(args...; kwargs...)

# Description
Tests if the components of the tesselation of the cube should be connected by the interior of an ambiguous face.
"""
test_face(cb::MVector{N,T}, face) where {N,T} = begin
    @inbounds begin
        if (af = abs(face)) == 1
            A = cb[1]
            B = cb[5]
            C = cb[6]
            D = cb[2]
        elseif af == 2
            A = cb[2]
            B = cb[6]
            C = cb[7]
            D = cb[3]
        elseif af == 3
            A = cb[3]
            B = cb[7]
            C = cb[8]
            D = cb[4]
        elseif af == 4
            A = cb[4]
            B = cb[8]
            C = cb[5]
            D = cb[1]
        elseif af == 5
            A = cb[1]
            B = cb[4]
            C = cb[3]
            D = cb[2]
        elseif af == 6
            A = cb[5]
            B = cb[8]
            C = cb[7]
            D = cb[6]
        else
            throw(error("Invalid face code $face"))
        end
    end
    abs(A * C - B * D) < eps(T) ? face ≥ 0 : face * A * (A * C - B * D) ≥ 0  # face and A invert signs
end

"""
    add_triangle(args...; kwargs...)

# Description
Routine to add a triangle to the mesh

# Arguments
  - `trig` the code for the triangle as a sequence of edges index.
  - `n` the number of triangles to produce.
  - `v12` the index of the interior vertex to use, if necessary.
"""
add_triangle(m, i, j, k, tri, n, v12 = 0) = begin
    @inbounds for t ∈ 1:3n
        tr = tri[t]
        id = (t - 1) % 3 + 1
        m.tv[id] = tv = if tr == 1
            m.x_vert[i, j, k]
        elseif tr == 2
            m.y_vert[i+1, j, k]
        elseif tr == 3
            m.x_vert[i, j+1, k]
        elseif tr == 4
            m.y_vert[i, j, k]
        elseif tr == 5
            m.x_vert[i, j, k+1]
        elseif tr == 6
            m.y_vert[i+1, j, k+1]
        elseif tr == 7
            m.x_vert[i, j+1, k+1]
        elseif tr == 8
            m.y_vert[i, j, k+1]
        elseif tr == 9
            m.z_vert[i, j, k]
        elseif tr == 10
            m.z_vert[i+1, j, k]
        elseif tr == 11
            m.z_vert[i+1, j+1, k]
        elseif tr == 12
            m.z_vert[i, j+1, k]
        else
            v12
        end
        @assert tv > 0
        id == 3 && push!(m.triangles, Triangle(m.tv...))
    end
    return
end

"""
    ∇x(args...; kwargs...)

# Description
Interpolates the horizontal gradient of the implicit function at the lower vertex of the specified cube.
"""
@inline ∇x(dat, i, j, k, nx) = @inbounds(
    i > 1 ?
    (i < nx ? (dat[i+1, j, k] - dat[i-1, j, k]) / 2 : (dat[i, j, k] - dat[i-1, j, k])) :
    (dat[i+1, j, k] - dat[i, j, k])
)

@inline ∇y(dat, i, j, k, ny) = @inbounds(
    j > 1 ?
    (j < ny ? (dat[i, j+1, k] - dat[i, j-1, k]) / 2 : (dat[i, j, k] - dat[i, j-1, k])) :
    (dat[i, j+1, k] - dat[i, j, k])
)

@inline ∇z(dat, i, j, k, nz) = @inbounds(
    k > 1 ?
    (k < nz ? (dat[i, j, k+1] - dat[i, j, k-1]) / 2 : (dat[i, j, k] - dat[i, j, k-1])) :
    (dat[i, j, k+1] - dat[i, j, k])
)

@inline norm(v) = @inbounds √(v[1]^2 + v[2]^2 + v[3]^2)

"""
    add_x_vertex(args...; kwargs...)

# Description
Adds a vertex on the current horizontal edge.
"""
add_x_vertex(m::MC{F}, dat, cb, i, j, k) where {F} = begin
    @inbounds begin
        u = cb[1] / (cb[1] - cb[2])
        m.nrm[1] = (1 - u) * ∇x(dat, i, j, k, m.nx) + u * ∇x(dat, i + 1, j, k, m.nx)
        m.nrm[2] = (1 - u) * ∇y(dat, i, j, k, m.ny) + u * ∇y(dat, i + 1, j, k, m.ny)
        m.nrm[3] = (1 - u) * ∇z(dat, i, j, k, m.nz) + u * ∇z(dat, i + 1, j, k, m.nz)
        (n = norm(m.nrm)) > eps(F) && (m.nrm ./= n)
    end
    push!(m.vertices, Vertex(i + u, j, k))
    push!(m.normals, Normal(m.nrm...))
    length(m.vertices)
end

add_y_vertex(m::MC{F}, dat, cb, i, j, k) where {F} = begin
    @inbounds begin
        u = cb[1] / (cb[1] - cb[3])
        m.nrm[1] = (1 - u) * ∇x(dat, i, j, k, m.nx) + u * ∇x(dat, i, j + 1, k, m.nx)
        m.nrm[2] = (1 - u) * ∇y(dat, i, j, k, m.ny) + u * ∇y(dat, i, j + 1, k, m.ny)
        m.nrm[3] = (1 - u) * ∇z(dat, i, j, k, m.nz) + u * ∇z(dat, i, j + 1, k, m.nz)
        (n = norm(m.nrm)) > eps(F) && (m.nrm ./= n)
    end
    push!(m.vertices, Vertex(i, j + u, k))
    push!(m.normals, Normal(m.nrm...))
    length(m.vertices)
end

add_z_vertex(m::MC{F}, dat, cb, i, j, k) where {F} = begin
    @inbounds begin
        u = cb[1] / (cb[1] - cb[4])
        m.nrm[1] = (1 - u) * ∇x(dat, i, j, k, m.nx) + u * ∇x(dat, i, j, k + 1, m.nx)
        m.nrm[2] = (1 - u) * ∇y(dat, i, j, k, m.ny) + u * ∇y(dat, i, j, k + 1, m.ny)
        m.nrm[3] = (1 - u) * ∇z(dat, i, j, k, m.nz) + u * ∇z(dat, i, j, k + 1, m.nz)
        (n = norm(m.nrm)) > eps(F) && (m.nrm ./= n)
    end
    push!(m.vertices, Vertex(i, j, k + u))
    push!(m.normals, Normal(m.nrm...))
    length(m.vertices)
end

"""
    add_c_vertex(args...; kwargs...)

# Description
Adds a vertex inside the current cube.
"""
add_c_vertex(m, i, j, k) = begin
    u = 0
    @inbounds begin  # computes the average of the intersection points of the cube
        m.vtx .= 0
        m.nrm .= 0
        (id = m.x_vert[i, j, k]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[id]; m.nrm .+= m.normals[id])
        (id = m.y_vert[i+1, j, k]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[id]; m.nrm .+= m.normals[id])
        (id = m.x_vert[i, j+1, k]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[id]; m.nrm .+= m.normals[id])
        (id = m.y_vert[i, j, k]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[id]; m.nrm .+= m.normals[id])
        (id = m.x_vert[i, j, k+1]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[id]; m.nrm .+= m.normals[id])
        (id = m.y_vert[i+1, j, k+1]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[id]; m.nrm .+= m.normals[id])
        (id = m.x_vert[i, j+1, k+1]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[id]; m.nrm .+= m.normals[id])
        (id = m.y_vert[i, j, k+1]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[id]; m.nrm .+= m.normals[id])
        (id = m.z_vert[i, j, k]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[id]; m.nrm .+= m.normals[id])
        (id = m.z_vert[i+1, j, k]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[id]; m.nrm .+= m.normals[id])
        (id = m.z_vert[i+1, j+1, k]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[id]; m.nrm .+= m.normals[id])
        (id = m.z_vert[i, j+1, k]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[id]; m.nrm .+= m.normals[id])
        m.vtx ./= u
        (n = norm(m.nrm)) > eps(F) && (m.nrm ./= n)
    end
    push!(m.vertices, Vertex(m.vtx...))
    push!(m.normals, Normal(m.nrm...))
    length(m.vertices)
end

test_scenario(nx = 60, ny = 60, nz = 60, case = :torus2) = begin
    dat = zeros(Float32, nx, ny, nz)

    sx, sy, sz = size(dat) ./ 16
    tx = nx / 2sx
    ty = ny / 2sy + 1.5
    tz = nz / 2sz

    r = 1.85
    R = 4

    cushin(x, y, z) = (
        z^2 * x^2 - z^4 - 2z * x^2 + 2z^3 + x^2 - z^2 - (x^2 - z) * (x^2 - z) - y^4 - 2x^2 * y^2 - y^2 * z^2 +
        2y^2 * z +
        y^2
    )

    torus2(x, y, z) =
        (
            (x^2 + y^2 + z^2 + R^2 - r^2) * (x^2 + y^2 + z^2 + R^2 - r^2) -
            4R^2 * (x^2 + y^2)
        ) * (
            (x^2 + (y + R) * (y + R) + z^2 + R^2 - r^2) *
            (x^2 + (y + R) * (y + R) + z^2 + R^2 - r^2) -
            4R^2 * ((y + R) * (y + R) + z^2)
        )

    sphere(x, y, z) = (
        ((x - 2) * (x - 2) + (y - 2) * (y - 2) + (z - 2) * (z - 2) - 1) *
        ((x + 2) * (x + 2) + (y - 2) * (y - 2) + (z - 2) * (z - 2) - 1) *
        ((x - 2) * (x - 2) + (y + 2) * (y + 2) + (z - 2) * (z - 2) - 1)
    )

    plane(x, y, z) = x + y + z - 3

    cassini(x, y, z) = (
        (x^2 + y^2 + z^2 + 0.45^2) * (x^2 + y^2 + z^2 + 0.45^2) -
        16 * 0.45^2 * (x^2 + z^2) - 0.5^2
    )

    blooby(x, y, z) = x^4 - 5x^2 + y^4 - 5y^2 + z^4 - 5z^2 + 11.8

    callback = (;
        cushin = cushin,
        torus2 = torus2,
        sphere = sphere,
        plane = plane,
        cassini = cassini,
        blooby = blooby,
    )[case]

    for k ∈ 1:nz, j ∈ 1:ny, i ∈ 1:nx
        dat[i, j, k] = callback(i / sx - tx, j / sy - ty, k / sz - tz)
    end

    MC(dat, Int32)
end

end
