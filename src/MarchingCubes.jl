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

using PrecompileTools
using StaticArrays

import Base: RefValue

export MC, march, march_legacy

include("lut.jl")

const Vertex{F} = SVector{3,F}
const Normal{F} = SVector{3,F}
const Triangle = SVector{3,Int}

"""
    MC(vol::Array{F,3}, I::Type = Int; x = [], y = [], z = [])

# Description
Structure to hold temporaries and output of the marching cubes algorithm.
Vertices, normals and triangles are accessible using `m.vertices`, `m.normals` and `m.triangles`.
1-based indexing is assumed.
Optionally, pass `x`, `y`, `z` to normalize the vertices coordinates instead of `0:nx-1`, `0:ny-1` and `0:nz-1`.

# Arguments
    - `vol`: rank 3 array of floats (volume) on which the Marching Cubes algorithm is applied.
    - `I`: Int32, Int64, ...: vertices / normals / triangles index `Integer` type (defaults to `Int`).
    - `x` normalize vertex.x to the coordinates of `x`.
    - `y` normalize vertex.y to the coordinates of `y`.
    - `z` normalize vertex.z to the coordinates of `z`.
"""
struct MC{F,I}
    nx::Int  # height of the grid
    ny::Int  # width of the grid
    nz::Int  # depth of the grid
    vol::RefValue{Array{F,3}}  # implicit function values sampled on the grid
    cube::MVector{8,F}  # values of the implicit function on the active cube
    tv::MVector{3,I}  # triangle buffer
    vtx::MVector{3,F}  # vertex buffer
    nrm::MVector{3,F}  # normal buffer
    vert_indices::Array{I,4}  # pre-computed vertex indices
    triangles::Vector{Triangle}  # output triangles
    vertices::Vector{Vertex{F}}  # output vertex positions
    normals::Vector{Normal{F}}  # output vertex normals
    normal_sign::Int  # direction of normal vectors (+1 for outward / -1 for inward)
    x::RefValue{Vector{F}}
    y::RefValue{Vector{F}}
    z::RefValue{Vector{F}}
    MC(
        vol::Array{F,3},
        I::Type{G} = Int;
        normal_sign::Integer = 1,
        x::AbstractVector{F} = F[],
        y::AbstractVector{F} = F[],
        z::AbstractVector{F} = F[],
    ) where {F<:AbstractFloat,G<:Integer} = begin
        isa(x, AbstractRange) && (x = collect(x))
        isa(y, AbstractRange) && (y = collect(y))
        isa(z, AbstractRange) && (z = collect(z))
        abs(normal_sign) == 1 ||
        throw(ArgumentError("`normal_sign` should be either -1 or +1"))
        m = new{F,I}(
            size(vol)...,
            Ref(vol),
            zeros(F, 8),
            zeros(Int, 3),
            zeros(F, 3),
            zeros(F, 3),
            zeros(I, (3, size(vol)...)),
            Triangle[],
            Vertex[],
            Normal[],
            normal_sign,
            Ref(x),
            Ref(y),
            Ref(z),
        )
        sz = size(vol) |> prod
        sizehint!(m.triangles, nextpow(2, sz ÷ 6))
        sizehint!(m.vertices, nextpow(2, sz ÷ 2))
        sizehint!(m.normals, nextpow(2, sz ÷ 2))
        m
    end
end

"""
    lut_entry(vol, cb, i, j, k, iso)

# Description
Cube sign representation.
"""
lut_entry(vol::Array{F,3}, cb, i, j, k, iso) where {F} = begin
    lut = UInt8(0)
    @inbounds for p ∈ 0:7
        c = vol[i+((p⊻(p>>1))&1), j+((p>>1)&1), k+((p>>2)&1)] - iso
        abs(c) < eps(F) && (c = eps(F))
        c > 0 && (lut += (UInt8(1) << p))
        cb[p+1] = c
    end
    Int(lut) + 1
end

"""
    denormalize(m::MC)

# Description
Optional denormalization step of vertices to user coordinates.
"""
denormalize(m::MC) = begin
    if length(m.x[]) > 0 && length(m.y[]) > 0 && length(m.z[]) > 0
        mx, Mx = extrema(m.x[])
        my, My = extrema(m.y[])
        mz, Mz = extrema(m.z[])
        scl =
            @SVector([Mx - mx, My - my, Mz - mz]) ./
            @SVector([m.nx - 1, m.ny - 1, m.nz - 1])
        off = @SVector([mx, my, mz])
        @inbounds for (n, v) in enumerate(m.vertices)
            m.vertices[n] = Vertex(off .+ v .* scl)
        end
    end
    nothing
end

"""
    march_legacy(m::MC, isovalue::Number = 0)

# Description
Original Marching Cubes algorithm.

# Arguments
    - `m`: Marching Cubes data structure.
    - `isovalue`: isosurface value.
"""
march_legacy(m::MC{F}, isovalue::Number = F(0)) where {F} = begin
    empty!(m.triangles)
    empty!(m.vertices)
    empty!(m.normals)

    vol = m.vol[]
    iso = F(isovalue)

    compute_intersection_points(m, vol, m.cube, iso)

    @inbounds for k ∈ 1:m.nz-1, j ∈ 1:m.ny-1, i ∈ 1:m.nx-1
        lut = lut_entry(vol, m.cube, i, j, k, iso)
        nt = 0
        while casesClassic[lut][3nt+1] > 0
            nt += 1
        end
        add_triangle(m, i, j, k, casesClassic[lut], nt)
    end

    denormalize(m)
    nothing
end

"""
    march(m::MC, isovalue::Number = 0)

# Description
Topologically controlled Marching Cubes algorithm.

Arguments
    - `m`: Marching Cubes data structure.
    - `isovalue`: isosurface value.
"""
march(m::MC{F}, isovalue::Number = F(0)) where {F} = begin
    empty!(m.triangles)
    empty!(m.vertices)
    empty!(m.normals)

    vol = m.vol[]
    iso = F(isovalue)

    compute_intersection_points(m, vol, m.cube, iso)

    @inbounds for k ∈ 1:m.nz-1, j ∈ 1:m.ny-1, i ∈ 1:m.nx-1
        lut = lut_entry(vol, m.cube, i, j, k, iso)

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
            elseif sc ≥ 39 && sc ≤ 44  # 13.2
                add_triangle(m, i, j, k, tiling13_2_[cfg][sc-38], 6)
            elseif sc == 45  # 13.1
                add_triangle(m, i, j, k, tiling13_1_[cfg], 4)
            elseif sc > 45
                @error "Impossible case 13 ?"
            end
        elseif case == 15
            add_triangle(m, i, j, k, tiling14[cfg], 4)
        end
    end

    denormalize(m)
    nothing
end

"""
    compute_intersection_points(m::MC, vol, cb, iso)

# Description
Computes almost all the vertices of the mesh by interpolation along the cubes edges.
"""
compute_intersection_points(m::MC{F}, vol, cb, iso) where {F} = begin
    @inbounds for k ∈ axes(vol, 3), j ∈ axes(vol, 2), i ∈ axes(vol, 1)
        c0::F = vol[i, j, k] - iso
        c1::F = i < m.nx ? vol[i+1, j, k] - iso : c0
        c2::F = j < m.ny ? vol[i, j+1, k] - iso : c0
        c3::F = k < m.nz ? vol[i, j, k+1] - iso : c0
        m.cube[1] = abs(c0) < eps(F) ? eps(F) : c0
        m.cube[2] = abs(c1) < eps(F) ? eps(F) : c1
        m.cube[4] = abs(c2) < eps(F) ? eps(F) : c2
        m.cube[5] = abs(c3) < eps(F) ? eps(F) : c3
        if m.cube[1] < 0
            m.cube[2] > 0 &&
                (m.vert_indices[1, i, j, k] = add_x_vertex(m, vol, cb, i, j, k))
            m.cube[4] > 0 &&
                (m.vert_indices[2, i, j, k] = add_y_vertex(m, vol, cb, i, j, k))
            m.cube[5] > 0 &&
                (m.vert_indices[3, i, j, k] = add_z_vertex(m, vol, cb, i, j, k))
        else
            m.cube[2] < 0 &&
                (m.vert_indices[1, i, j, k] = add_x_vertex(m, vol, cb, i, j, k))
            m.cube[4] < 0 &&
                (m.vert_indices[2, i, j, k] = add_y_vertex(m, vol, cb, i, j, k))
            m.cube[5] < 0 &&
                (m.vert_indices[3, i, j, k] = add_z_vertex(m, vol, cb, i, j, k))
        end
    end
    nothing
end

"""
    test_interior(case, cb, cfg, subcfg, s)

# Description
Tests if the components of the tessellation of the cube should be connected through the interior of the cube.
"""
test_interior(case, cb::MVector{N,T}, cfg, subcfg, s) where {N,T} = begin
    test = 0
    At = Bt = Ct = Dt = T(0)
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
                tiling13_5_1[cfg][subcfg][1] - 1
            else
                -1
            end
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
                t = cb[7] / (cb[7] - cb[8])
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
                @error "Invalid edge $edge"
            end
        else
            @error "Invalid ambiguous case $case"
        end
    end

    At ≥ 0 && (test += 1)
    Bt ≥ 0 && (test += 2)
    Ct ≥ 0 && (test += 4)
    Dt ≥ 0 && (test += 8)

    if test == 6 || test == 8 || test == 9 || test == 12 || (test ≥ 0 && test ≤ 4)
        s > 0
    elseif test == 5
        (At * Ct - Bt * Dt < eps(T)) ? s > 0 : s < 0
    elseif test == 10
        (At * Ct - Bt * Dt ≥ eps(T)) ? s > 0 : s < 0
    else  # test == 7 || test == 11 || test ≥ 13
        s < 0
    end::Bool
end

"""
    test_face(cb, face)

# Description
Tests if the components of the tessellation of the cube should be connected by the interior of an ambiguous face.
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
            @error "Invalid face code $face"
        end
    end
    abs(A * C - B * D) < eps(T) ? face ≥ 0 : face * A * (A * C - B * D) ≥ 0  # face and A invert signs
end

"""
    add_triangle(m::MC, i, j, k, tri, n, v12 = 0)

# Description
Routine to add a triangle to the mesh.

# Arguments
  - `tri` the code for the triangle as a sequence of edges index.
  - `n` the number of triangles to produce.
  - `v12` the index of the interior vertex to use, if necessary.
"""
add_triangle(m::MC{F,I}, i, j, k, tri, n, v12 = I(0)) where {F,I} = begin
    @inbounds for t ∈ 1:3n
        tr = tri[t]
        id = (t - 1) % 3 + 1
        m.tv[id] = tv = if tr == 1
            m.vert_indices[1, i, j, k]
        elseif tr == 2
            m.vert_indices[2, i+1, j, k]
        elseif tr == 3
            m.vert_indices[1, i, j+1, k]
        elseif tr == 4
            m.vert_indices[2, i, j, k]
        elseif tr == 5
            m.vert_indices[1, i, j, k+1]
        elseif tr == 6
            m.vert_indices[2, i+1, j, k+1]
        elseif tr == 7
            m.vert_indices[1, i, j+1, k+1]
        elseif tr == 8
            m.vert_indices[2, i, j, k+1]
        elseif tr == 9
            m.vert_indices[3, i, j, k]
        elseif tr == 10
            m.vert_indices[3, i+1, j, k]
        elseif tr == 11
            m.vert_indices[3, i+1, j+1, k]
        elseif tr == 12
            m.vert_indices[3, i, j+1, k]
        else
            I(v12)
        end::I
        tv == 0 && @warn "Invalid triangle $(length(m.triangles) + 1)"
        id == 3 && push!(m.triangles, Triangle(m.tv))
    end
    nothing
end

"""
    ∇x(args...; kwargs...)

# Description
Interpolates the horizontal gradient of the implicit function at the lower vertex of the specified cube.
"""
@inline ∇x(vol::AbstractArray{F}, i, j, k, nx) where {F} = @inbounds(
    i > 1 ?
    (i < nx ? (vol[i+1, j, k] - vol[i-1, j, k]) / 2 : (vol[i, j, k] - vol[i-1, j, k])) :
    (vol[i+1, j, k] - vol[i, j, k])
)::F

@inline ∇y(vol::AbstractArray{F}, i, j, k, ny) where {F} = @inbounds(
    j > 1 ?
    (j < ny ? (vol[i, j+1, k] - vol[i, j-1, k]) / 2 : (vol[i, j, k] - vol[i, j-1, k])) :
    (vol[i, j+1, k] - vol[i, j, k])
)::F

@inline ∇z(vol::AbstractArray{F}, i, j, k, nz) where {F} = @inbounds(
    k > 1 ?
    (k < nz ? (vol[i, j, k+1] - vol[i, j, k-1]) / 2 : (vol[i, j, k] - vol[i, j, k-1])) :
    (vol[i, j, k+1] - vol[i, j, k])
)::F

@inline norm(x) = @inbounds √(x[1]^2 + x[2]^2 + x[3]^2)

"""
    add_x_vertex(m::MC, vol, cb, i, j, k)

# Description
Adds a vertex on the current horizontal edge.
"""
add_x_vertex(m::MC{F}, vol, cb, i, j, k) where {F} = begin
    @inbounds begin
        u = cb[1] / (cb[1] - cb[2])
        m.nrm[1] = (1 - u) * ∇x(vol, i, j, k, m.nx) + u * ∇x(vol, i + 1, j, k, m.nx)
        m.nrm[2] = (1 - u) * ∇y(vol, i, j, k, m.ny) + u * ∇y(vol, i + 1, j, k, m.ny)
        m.nrm[3] = (1 - u) * ∇z(vol, i, j, k, m.nz) + u * ∇z(vol, i + 1, j, k, m.nz)
        (mag = norm(m.nrm)) > eps(F) && (m.nrm ./= mag)
    end
    push!(m.vertices, Vertex(i - 1 + u, j - 1, k - 1))
    push!(m.normals, Normal(m.normal_sign * m.nrm))
    length(m.vertices)
end

add_y_vertex(m::MC{F}, vol, cb, i, j, k) where {F} = begin
    @inbounds begin
        u = cb[1] / (cb[1] - cb[4])
        m.nrm[1] = (1 - u) * ∇x(vol, i, j, k, m.nx) + u * ∇x(vol, i, j + 1, k, m.nx)
        m.nrm[2] = (1 - u) * ∇y(vol, i, j, k, m.ny) + u * ∇y(vol, i, j + 1, k, m.ny)
        m.nrm[3] = (1 - u) * ∇z(vol, i, j, k, m.nz) + u * ∇z(vol, i, j + 1, k, m.nz)
        (mag = norm(m.nrm)) > eps(F) && (m.nrm ./= mag)
    end
    push!(m.vertices, Vertex(i - 1, j - 1 + u, k - 1))
    push!(m.normals, Normal(m.normal_sign * m.nrm))
    length(m.vertices)
end

add_z_vertex(m::MC{F}, vol, cb, i, j, k) where {F} = begin
    @inbounds begin
        u = cb[1] / (cb[1] - cb[5])
        m.nrm[1] = (1 - u) * ∇x(vol, i, j, k, m.nx) + u * ∇x(vol, i, j, k + 1, m.nx)
        m.nrm[2] = (1 - u) * ∇y(vol, i, j, k, m.ny) + u * ∇y(vol, i, j, k + 1, m.ny)
        m.nrm[3] = (1 - u) * ∇z(vol, i, j, k, m.nz) + u * ∇z(vol, i, j, k + 1, m.nz)
        (mag = norm(m.nrm)) > eps(F) && (m.nrm ./= mag)
    end
    push!(m.vertices, Vertex(i - 1, j - 1, k - 1 + u))
    push!(m.normals, Normal(m.normal_sign * m.nrm))
    length(m.vertices)
end

"""
    add_c_vertex(m::MC, i, j, k)

# Description
Add a vertex inside the current cube.
"""
add_c_vertex(m::MC{F}, i, j, k) where {F} = begin
    u = 0
    @inbounds begin
        m.vtx .= 0
        m.nrm .= 0
        # compute the average of the intersection points of the cube
        (n = m.vert_indices[1, i, j, k]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[n]; m.nrm .+= m.normals[n])
        (n = m.vert_indices[2, i+1, j, k]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[n]; m.nrm .+= m.normals[n])
        (n = m.vert_indices[1, i, j+1, k]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[n]; m.nrm .+= m.normals[n])
        (n = m.vert_indices[2, i, j, k]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[n]; m.nrm .+= m.normals[n])
        (n = m.vert_indices[1, i, j, k+1]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[n]; m.nrm .+= m.normals[n])
        (n = m.vert_indices[2, i+1, j, k+1]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[n]; m.nrm .+= m.normals[n])
        (n = m.vert_indices[1, i, j+1, k+1]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[n]; m.nrm .+= m.normals[n])
        (n = m.vert_indices[2, i, j, k+1]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[n]; m.nrm .+= m.normals[n])
        (n = m.vert_indices[3, i, j, k]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[n]; m.nrm .+= m.normals[n])
        (n = m.vert_indices[3, i+1, j, k]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[n]; m.nrm .+= m.normals[n])
        (n = m.vert_indices[3, i+1, j+1, k]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[n]; m.nrm .+= m.normals[n])
        (n = m.vert_indices[3, i, j+1, k]) > 0 &&
            (u += 1; m.vtx .+= m.vertices[n]; m.nrm .+= m.normals[n])
        m.vtx ./= u
        (mag = norm(m.nrm)) > eps(F) && (m.nrm ./= mag)
    end
    push!(m.vertices, Vertex(m.vtx))
    push!(m.normals, Normal(m.normal_sign * m.nrm))
    length(m.vertices)
end

include("example.jl")

@compile_workload begin
    march(scenario(4, 4, 4; F = Float64, I = Int))
end

end
