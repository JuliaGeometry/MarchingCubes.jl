#! format: off
#=

@file    LookUpTable.h
@author  Thomas Lewiner <thomas.lewiner@polytechnique.org>
@author  Math Dept, PUC-Rio
@version 0.2
@date    12/08/2002

LookUpTable for the MarchingCubes 33 Algorithm
=#

#=
 case mapping
 For each of the possible vertex states listed in this table there is a
 specific triangulation of the edge intersection points.  The table lists
 all of them in the form of 0-5 edge triples with the list terminated by
 the invalid value -1.  For example: case[4] list the 2 triangles
 formed when cube[1] and cube[2] are inside of the surface, but the rest of
 the cube is not.
 *
 Cube description:
        8 ________ 7          _____7__             ________
       /|       /|          /|       /|          /|       /|
      / |      / |        8/ |     6/ |         / |  6   / |
   5 /_______ /  |        /___5____/  11       /__|_____/  |
    |   |    |6  |       |  12    |   |       |   | 3   | 2|
    |  4|____|___|3      |   |___3|___|       | 4 |_____|__|
    |  /     |  /        9 4/     10 /        |  /      |  /
    | /      | /         | /      | /2        | /    5  | /
    |/_______|/          |/___1___|/          |/_1______|/
   1          2
=#

const cases = (
  Int8.((  0, -1 ) .+ 1),
  Int8.((  1,  0 ) .+ 1),
  Int8.((  1,  1 ) .+ 1),
  Int8.((  2,  0 ) .+ 1),
  Int8.((  1,  2 ) .+ 1),
  Int8.((  3,  0 ) .+ 1),
  Int8.((  2,  3 ) .+ 1),
  Int8.((  5,  0 ) .+ 1),
  Int8.((  1,  3 ) .+ 1),
  Int8.((  2,  1 ) .+ 1),
  Int8.((  3,  3 ) .+ 1),
  Int8.((  5,  1 ) .+ 1),
  Int8.((  2,  5 ) .+ 1),
  Int8.((  5,  4 ) .+ 1),
  Int8.((  5,  9 ) .+ 1),
  Int8.((  8,  0 ) .+ 1),
  Int8.((  1,  4 ) .+ 1),
  Int8.((  2,  2 ) .+ 1),
  Int8.((  3,  4 ) .+ 1),
  Int8.((  5,  2 ) .+ 1),
  Int8.((  4,  2 ) .+ 1),
  Int8.((  6,  2 ) .+ 1),
  Int8.((  6,  9 ) .+ 1),
  Int8.(( 11,  0 ) .+ 1),
  Int8.((  3,  8 ) .+ 1),
  Int8.((  5,  5 ) .+ 1),
  Int8.((  7,  3 ) .+ 1),
  Int8.((  9,  1 ) .+ 1),
  Int8.((  6, 16 ) .+ 1),
  Int8.(( 14,  3 ) .+ 1),
  Int8.(( 12, 12 ) .+ 1),
  Int8.((  5, 24 ) .+ 1),
  Int8.((  1,  5 ) .+ 1),
  Int8.((  3,  1 ) .+ 1),
  Int8.((  2,  4 ) .+ 1),
  Int8.((  5,  3 ) .+ 1),
  Int8.((  3,  6 ) .+ 1),
  Int8.((  7,  0 ) .+ 1),
  Int8.((  5, 10 ) .+ 1),
  Int8.((  9,  0 ) .+ 1),
  Int8.((  4,  3 ) .+ 1),
  Int8.((  6,  4 ) .+ 1),
  Int8.((  6, 11 ) .+ 1),
  Int8.(( 14,  1 ) .+ 1),
  Int8.((  6, 17 ) .+ 1),
  Int8.(( 12,  4 ) .+ 1),
  Int8.(( 11,  6 ) .+ 1),
  Int8.((  5, 25 ) .+ 1),
  Int8.((  2,  8 ) .+ 1),
  Int8.((  5,  7 ) .+ 1),
  Int8.((  5, 12 ) .+ 1),
  Int8.((  8,  1 ) .+ 1),
  Int8.((  6, 18 ) .+ 1),
  Int8.(( 12,  5 ) .+ 1),
  Int8.(( 14,  7 ) .+ 1),
  Int8.((  5, 28 ) .+ 1),
  Int8.((  6, 21 ) .+ 1),
  Int8.(( 11,  4 ) .+ 1),
  Int8.(( 12, 15 ) .+ 1),
  Int8.((  5, 30 ) .+ 1),
  Int8.(( 10,  5 ) .+ 1),
  Int8.((  6, 32 ) .+ 1),
  Int8.((  6, 39 ) .+ 1),
  Int8.((  2, 12 ) .+ 1),
  Int8.((  1,  6 ) .+ 1),
  Int8.((  4,  0 ) .+ 1),
  Int8.((  3,  5 ) .+ 1),
  Int8.((  6,  0 ) .+ 1),
  Int8.((  2,  6 ) .+ 1),
  Int8.((  6,  3 ) .+ 1),
  Int8.((  5, 11 ) .+ 1),
  Int8.(( 14,  0 ) .+ 1),
  Int8.((  3,  9 ) .+ 1),
  Int8.((  6,  5 ) .+ 1),
  Int8.((  7,  4 ) .+ 1),
  Int8.(( 12,  1 ) .+ 1),
  Int8.((  5, 14 ) .+ 1),
  Int8.(( 11,  3 ) .+ 1),
  Int8.((  9,  4 ) .+ 1),
  Int8.((  5, 26 ) .+ 1),
  Int8.((  3, 10 ) .+ 1),
  Int8.((  6,  6 ) .+ 1),
  Int8.((  7,  5 ) .+ 1),
  Int8.(( 12,  2 ) .+ 1),
  Int8.((  6, 19 ) .+ 1),
  Int8.(( 10,  1 ) .+ 1),
  Int8.(( 12, 13 ) .+ 1),
  Int8.((  6, 24 ) .+ 1),
  Int8.((  7,  7 ) .+ 1),
  Int8.(( 12,  9 ) .+ 1),
  Int8.(( 13,  1 ) .+ 1),
  Int8.((  7,  9 ) .+ 1),
  Int8.(( 12, 20 ) .+ 1),
  Int8.((  6, 33 ) .+ 1),
  Int8.((  7, 13 ) .+ 1),
  Int8.((  3, 12 ) .+ 1),
  Int8.((  2, 10 ) .+ 1),
  Int8.((  6,  7 ) .+ 1),
  Int8.((  5, 13 ) .+ 1),
  Int8.(( 11,  2 ) .+ 1),
  Int8.((  5, 16 ) .+ 1),
  Int8.(( 12,  7 ) .+ 1),
  Int8.((  8,  3 ) .+ 1),
  Int8.((  5, 29 ) .+ 1),
  Int8.((  6, 22 ) .+ 1),
  Int8.(( 10,  2 ) .+ 1),
  Int8.(( 12, 17 ) .+ 1),
  Int8.((  6, 27 ) .+ 1),
  Int8.(( 14,  9 ) .+ 1),
  Int8.((  6, 34 ) .+ 1),
  Int8.((  5, 39 ) .+ 1),
  Int8.((  2, 14 ) .+ 1),
  Int8.((  5, 20 ) .+ 1),
  Int8.(( 14,  5 ) .+ 1),
  Int8.((  9,  5 ) .+ 1),
  Int8.((  5, 32 ) .+ 1),
  Int8.(( 11, 10 ) .+ 1),
  Int8.((  6, 35 ) .+ 1),
  Int8.((  5, 41 ) .+ 1),
  Int8.((  2, 16 ) .+ 1),
  Int8.(( 12, 23 ) .+ 1),
  Int8.((  6, 37 ) .+ 1),
  Int8.((  7, 14 ) .+ 1),
  Int8.((  3, 16 ) .+ 1),
  Int8.((  6, 46 ) .+ 1),
  Int8.((  4,  6 ) .+ 1),
  Int8.((  3, 21 ) .+ 1),
  Int8.((  1,  8 ) .+ 1),
  Int8.((  1,  7 ) .+ 1),
  Int8.((  3,  2 ) .+ 1),
  Int8.((  4,  1 ) .+ 1),
  Int8.((  6,  1 ) .+ 1),
  Int8.((  3,  7 ) .+ 1),
  Int8.((  7,  1 ) .+ 1),
  Int8.((  6, 10 ) .+ 1),
  Int8.(( 12,  0 ) .+ 1),
  Int8.((  2,  7 ) .+ 1),
  Int8.((  5,  6 ) .+ 1),
  Int8.((  6, 12 ) .+ 1),
  Int8.(( 11,  1 ) .+ 1),
  Int8.((  5, 15 ) .+ 1),
  Int8.((  9,  2 ) .+ 1),
  Int8.(( 14,  6 ) .+ 1),
  Int8.((  5, 27 ) .+ 1),
  Int8.((  2,  9 ) .+ 1),
  Int8.((  5,  8 ) .+ 1),
  Int8.((  6, 13 ) .+ 1),
  Int8.(( 14,  2 ) .+ 1),
  Int8.((  6, 20 ) .+ 1),
  Int8.(( 12,  6 ) .+ 1),
  Int8.(( 10,  3 ) .+ 1),
  Int8.((  6, 25 ) .+ 1),
  Int8.((  5, 18 ) .+ 1),
  Int8.((  8,  2 ) .+ 1),
  Int8.(( 12, 16 ) .+ 1),
  Int8.((  5, 31 ) .+ 1),
  Int8.(( 11,  9 ) .+ 1),
  Int8.((  5, 34 ) .+ 1),
  Int8.((  6, 40 ) .+ 1),
  Int8.((  2, 13 ) .+ 1),
  Int8.((  3, 11 ) .+ 1),
  Int8.((  7,  2 ) .+ 1),
  Int8.((  6, 14 ) .+ 1),
  Int8.(( 12,  3 ) .+ 1),
  Int8.((  7,  6 ) .+ 1),
  Int8.(( 13,  0 ) .+ 1),
  Int8.(( 12, 14 ) .+ 1),
  Int8.((  7,  8 ) .+ 1),
  Int8.((  6, 23 ) .+ 1),
  Int8.(( 12, 10 ) .+ 1),
  Int8.(( 10,  4 ) .+ 1),
  Int8.((  6, 28 ) .+ 1),
  Int8.(( 12, 21 ) .+ 1),
  Int8.((  7, 10 ) .+ 1),
  Int8.((  6, 41 ) .+ 1),
  Int8.((  3, 13 ) .+ 1),
  Int8.((  5, 21 ) .+ 1),
  Int8.((  9,  3 ) .+ 1),
  Int8.(( 11,  8 ) .+ 1),
  Int8.((  5, 33 ) .+ 1),
  Int8.(( 12, 22 ) .+ 1),
  Int8.((  7, 11 ) .+ 1),
  Int8.((  6, 42 ) .+ 1),
  Int8.((  3, 14 ) .+ 1),
  Int8.(( 14, 11 ) .+ 1),
  Int8.((  5, 36 ) .+ 1),
  Int8.((  6, 44 ) .+ 1),
  Int8.((  2, 17 ) .+ 1),
  Int8.((  6, 47 ) .+ 1),
  Int8.((  3, 18 ) .+ 1),
  Int8.((  4,  7 ) .+ 1),
  Int8.((  1,  9 ) .+ 1),
  Int8.((  2, 11 ) .+ 1),
  Int8.((  6,  8 ) .+ 1),
  Int8.((  6, 15 ) .+ 1),
  Int8.(( 10,  0 ) .+ 1),
  Int8.((  5, 17 ) .+ 1),
  Int8.(( 12,  8 ) .+ 1),
  Int8.(( 11,  7 ) .+ 1),
  Int8.((  6, 26 ) .+ 1),
  Int8.((  5, 19 ) .+ 1),
  Int8.(( 14,  4 ) .+ 1),
  Int8.(( 12, 18 ) .+ 1),
  Int8.((  6, 29 ) .+ 1),
  Int8.((  8,  4 ) .+ 1),
  Int8.((  5, 35 ) .+ 1),
  Int8.((  5, 40 ) .+ 1),
  Int8.((  2, 15 ) .+ 1),
  Int8.((  5, 22 ) .+ 1),
  Int8.(( 11,  5 ) .+ 1),
  Int8.(( 12, 19 ) .+ 1),
  Int8.((  6, 30 ) .+ 1),
  Int8.(( 14, 10 ) .+ 1),
  Int8.((  6, 36 ) .+ 1),
  Int8.((  6, 43 ) .+ 1),
  Int8.((  4,  4 ) .+ 1),
  Int8.((  9,  7 ) .+ 1),
  Int8.((  5, 37 ) .+ 1),
  Int8.((  7, 15 ) .+ 1),
  Int8.((  3, 17 ) .+ 1),
  Int8.((  5, 44 ) .+ 1),
  Int8.((  2, 19 ) .+ 1),
  Int8.((  3, 22 ) .+ 1),
  Int8.((  1, 10 ) .+ 1),
  Int8.((  5, 23 ) .+ 1),
  Int8.(( 12, 11 ) .+ 1),
  Int8.(( 14,  8 ) .+ 1),
  Int8.((  6, 31 ) .+ 1),
  Int8.((  9,  6 ) .+ 1),
  Int8.((  7, 12 ) .+ 1),
  Int8.((  5, 42 ) .+ 1),
  Int8.((  3, 15 ) .+ 1),
  Int8.(( 11, 11 ) .+ 1),
  Int8.((  6, 38 ) .+ 1),
  Int8.((  6, 45 ) .+ 1),
  Int8.((  4,  5 ) .+ 1),
  Int8.((  5, 45 ) .+ 1),
  Int8.((  3, 19 ) .+ 1),
  Int8.((  2, 21 ) .+ 1),
  Int8.((  1, 11 ) .+ 1),
  Int8.((  8,  5 ) .+ 1),
  Int8.((  5, 38 ) .+ 1),
  Int8.((  5, 43 ) .+ 1),
  Int8.((  2, 18 ) .+ 1),
  Int8.((  5, 46 ) .+ 1),
  Int8.((  3, 20 ) .+ 1),
  Int8.((  2, 22 ) .+ 1),
  Int8.((  1, 12 ) .+ 1),
  Int8.((  5, 47 ) .+ 1),
  Int8.((  2, 20 ) .+ 1),
  Int8.((  3, 23 ) .+ 1),
  Int8.((  1, 13 ) .+ 1),
  Int8.((  2, 23 ) .+ 1),
  Int8.((  1, 14 ) .+ 1),
  Int8.((  1, 15 ) .+ 1),
  Int8.((  0, -1 ) .+ 1),
)

#=
 tiling table for case 1
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling1 = (
  Int8.((  0,  8,  3 ) .+ 1),
  Int8.((  0,  1,  9 ) .+ 1),
  Int8.((  1,  2, 10 ) .+ 1),
  Int8.((  3, 11,  2 ) .+ 1),
  Int8.((  4,  7,  8 ) .+ 1),
  Int8.((  9,  5,  4 ) .+ 1),
  Int8.(( 10,  6,  5 ) .+ 1),
  Int8.((  7,  6, 11 ) .+ 1),
  Int8.((  7, 11,  6 ) .+ 1),
  Int8.(( 10,  5,  6 ) .+ 1),
  Int8.((  9,  4,  5 ) .+ 1),
  Int8.((  4,  8,  7 ) .+ 1),
  Int8.((  3,  2, 11 ) .+ 1),
  Int8.((  1, 10,  2 ) .+ 1),
  Int8.((  0,  9,  1 ) .+ 1),
  Int8.((  0,  3,  8 ) .+ 1),
)

#=
 tiling table for case 2
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling2 = (
  Int8.((  1,  8,  3,  9,  8,  1 ) .+ 1),
  Int8.((  0, 11,  2,  8, 11,  0 ) .+ 1),
  Int8.((  4,  3,  0,  7,  3,  4 ) .+ 1),
  Int8.((  9,  2, 10,  0,  2,  9 ) .+ 1),
  Int8.((  0,  5,  4,  1,  5,  0 ) .+ 1),
  Int8.((  3, 10,  1, 11, 10,  3 ) .+ 1),
  Int8.((  1,  6,  5,  2,  6,  1 ) .+ 1),
  Int8.((  7,  2,  3,  6,  2,  7 ) .+ 1),
  Int8.((  9,  7,  8,  5,  7,  9 ) .+ 1),
  Int8.((  6,  8,  4, 11,  8,  6 ) .+ 1),
  Int8.(( 10,  4,  9,  6,  4, 10 ) .+ 1),
  Int8.(( 11,  5, 10,  7,  5, 11 ) .+ 1),
  Int8.(( 11, 10,  5,  7, 11,  5 ) .+ 1),
  Int8.(( 10,  9,  4,  6, 10,  4 ) .+ 1),
  Int8.((  6,  4,  8, 11,  6,  8 ) .+ 1),
  Int8.((  9,  8,  7,  5,  9,  7 ) .+ 1),
  Int8.((  7,  3,  2,  6,  7,  2 ) .+ 1),
  Int8.((  1,  5,  6,  2,  1,  6 ) .+ 1),
  Int8.((  3,  1, 10, 11,  3, 10 ) .+ 1),
  Int8.((  0,  4,  5,  1,  0,  5 ) .+ 1),
  Int8.((  9, 10,  2,  0,  9,  2 ) .+ 1),
  Int8.((  4,  0,  3,  7,  4,  3 ) .+ 1),
  Int8.((  0,  2, 11,  8,  0, 11 ) .+ 1),
  Int8.((  1,  3,  8,  9,  1,  8 ) .+ 1),
)

#=
 test table for case 3
 One face to test
 When the test on the specified face is positive : 4 first triangles
 When the test on the specified face is negative : 2 last triangles
 *
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const test3 = (
  Int8(  5 ),
  Int8(  1 ),
  Int8(  4 ),
  Int8(  5 ),
  Int8(  1 ),
  Int8(  2 ),
  Int8(  2 ),
  Int8(  3 ),
  Int8(  4 ),
  Int8(  3 ),
  Int8(  6 ),
  Int8(  6 ),
  Int8( -6 ),
  Int8( -6 ),
  Int8( -3 ),
  Int8( -4 ),
  Int8( -3 ),
  Int8( -2 ),
  Int8( -2 ),
  Int8( -1 ),
  Int8( -5 ),
  Int8( -4 ),
  Int8( -1 ),
  Int8( -5 ),
)

#=
 tiling table for case 3.1
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling3_1 = (
  Int8.((  0,  8,  3,  1,  2, 10 ) .+ 1),
  Int8.((  9,  5,  4,  0,  8,  3 ) .+ 1),
  Int8.((  3,  0,  8, 11,  7,  6 ) .+ 1),
  Int8.((  1,  9,  0,  2,  3, 11 ) .+ 1),
  Int8.((  0,  1,  9,  8,  4,  7 ) .+ 1),
  Int8.((  9,  0,  1,  5, 10,  6 ) .+ 1),
  Int8.((  1,  2, 10,  9,  5,  4 ) .+ 1),
  Int8.(( 10,  1,  2,  6, 11,  7 ) .+ 1),
  Int8.((  8,  4,  7,  3, 11,  2 ) .+ 1),
  Int8.((  2,  3, 11, 10,  6,  5 ) .+ 1),
  Int8.((  5, 10,  6,  4,  7,  8 ) .+ 1),
  Int8.((  4,  9,  5,  7,  6, 11 ) .+ 1),
  Int8.((  5,  9,  4, 11,  6,  7 ) .+ 1),
  Int8.((  6, 10,  5,  8,  7,  4 ) .+ 1),
  Int8.(( 11,  3,  2,  5,  6, 10 ) .+ 1),
  Int8.((  7,  4,  8,  2, 11,  3 ) .+ 1),
  Int8.((  2,  1, 10,  7, 11,  6 ) .+ 1),
  Int8.(( 10,  2,  1,  4,  5,  9 ) .+ 1),
  Int8.((  1,  0,  9,  6, 10,  5 ) .+ 1),
  Int8.((  9,  1,  0,  7,  4,  8 ) .+ 1),
  Int8.((  0,  9,  1, 11,  3,  2 ) .+ 1),
  Int8.((  8,  0,  3,  6,  7, 11 ) .+ 1),
  Int8.((  4,  5,  9,  3,  8,  0 ) .+ 1),
  Int8.((  3,  8,  0, 10,  2,  1 ) .+ 1),
)

#=
 tiling table for case 3.2
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling3_2 = (
  Int8.(( 10,  3,  2, 10,  8,  3, 10,  1,  0,  8, 10,  0 ) .+ 1),
  Int8.((  3,  4,  8,  3,  5,  4,  3,  0,  9,  5,  3,  9 ) .+ 1),
  Int8.((  6,  8,  7,  6,  0,  8,  6, 11,  3,  0,  6,  3 ) .+ 1),
  Int8.(( 11,  0,  3, 11,  9,  0, 11,  2,  1,  9, 11,  1 ) .+ 1),
  Int8.((  7,  9,  4,  7,  1,  9,  7,  8,  0,  1,  7,  0 ) .+ 1),
  Int8.((  6,  1, 10,  6,  0,  1,  9,  0,  6,  9,  6,  5 ) .+ 1),
  Int8.((  4, 10,  5,  4,  2, 10,  4,  9,  1,  2,  4,  1 ) .+ 1),
  Int8.((  7,  2, 11,  7,  1,  2,  7,  6, 10,  1,  7, 10 ) .+ 1),
  Int8.((  2,  7, 11,  2,  4,  7,  2,  3,  8,  4,  2,  8 ) .+ 1),
  Int8.((  5, 11,  6,  5,  3, 11,  5, 10,  2,  3,  5,  2 ) .+ 1),
  Int8.((  8,  6,  7,  8, 10,  6,  8,  4,  5, 10,  8,  5 ) .+ 1),
  Int8.(( 11,  5,  6, 11,  9,  5, 11,  7,  4,  9, 11,  4 ) .+ 1),
  Int8.((  6,  5, 11,  5,  9, 11,  4,  7, 11,  4, 11,  9 ) .+ 1),
  Int8.((  7,  6,  8,  6, 10,  8,  5,  4,  8,  5,  8, 10 ) .+ 1),
  Int8.((  6, 11,  5, 11,  3,  5,  2, 10,  5,  2,  5,  3 ) .+ 1),
  Int8.(( 11,  7,  2,  7,  4,  2,  8,  3,  2,  8,  2,  4 ) .+ 1),
  Int8.(( 11,  2,  7,  2,  1,  7, 10,  6,  7, 10,  7,  1 ) .+ 1),
  Int8.((  5, 10,  4, 10,  2,  4,  1,  9,  4,  1,  4,  2 ) .+ 1),
  Int8.(( 10,  1,  6,  1,  0,  6,  6,  0,  9,  5,  6,  9 ) .+ 1),
  Int8.((  4,  9,  7,  9,  1,  7,  0,  8,  7,  0,  7,  1 ) .+ 1),
  Int8.((  3,  0, 11,  0,  9, 11,  1,  2, 11,  1, 11,  9 ) .+ 1),
  Int8.((  7,  8,  6,  8,  0,  6,  3, 11,  6,  3,  6,  0 ) .+ 1),
  Int8.((  8,  4,  3,  4,  5,  3,  9,  0,  3,  9,  3,  5 ) .+ 1),
  Int8.((  2,  3, 10,  3,  8, 10,  0,  1, 10,  0, 10,  8 ) .+ 1),
)

#=
 test table for case 4
 Interior to test
 When the test on the interior is negative : 2 first triangles
 When the test on the interior is positive : 6 last triangles
 *
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const test4 = (
  Int8( 7),
  Int8( 7),
  Int8( 7),
  Int8( 7),
  Int8(-7),
  Int8(-7),
  Int8(-7),
  Int8(-7),
)

#=
 tiling table for case 4.1
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling4_1 = (
  Int8.((  0,  8,  3,  5, 10,  6 ) .+ 1),
  Int8.((  0,  1,  9, 11,  7,  6 ) .+ 1),
  Int8.((  1,  2, 10,  8,  4,  7 ) .+ 1),
  Int8.((  9,  5,  4,  2,  3, 11 ) .+ 1),
  Int8.((  4,  5,  9, 11,  3,  2 ) .+ 1),
  Int8.(( 10,  2,  1,  7,  4,  8 ) .+ 1),
  Int8.((  9,  1,  0,  6,  7, 11 ) .+ 1),
  Int8.((  3,  8,  0,  6, 10,  5 ) .+ 1),
)

#=
 tiling table for case 4.2
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling4_2 = (
  Int8.((  8,  5,  0,  5,  8,  6,  3,  6,  8,  6,  3, 10,  0, 10,  3, 10,  0,  5 ) .+ 1),
  Int8.((  9,  6,  1,  6,  9,  7,  0,  7,  9,  7,  0, 11,  1, 11,  0, 11,  1,  6 ) .+ 1),
  Int8.(( 10,  7,  2,  7, 10,  4,  1,  4, 10,  4,  1,  8,  2,  8,  1,  8,  2,  7 ) .+ 1),
  Int8.(( 11,  4,  3,  4, 11,  5,  2,  5, 11,  5,  2,  9,  3,  9,  2,  9,  3,  4 ) .+ 1),
  Int8.((  3,  4, 11,  5, 11,  4, 11,  5,  2,  9,  2,  5,  2,  9,  3,  4,  3,  9 ) .+ 1),
  Int8.((  2,  7, 10,  4, 10,  7, 10,  4,  1,  8,  1,  4,  1,  8,  2,  7,  2,  8 ) .+ 1),
  Int8.((  1,  6,  9,  7,  9,  6,  9,  7,  0, 11,  0,  7,  0, 11,  1,  6,  1, 11 ) .+ 1),
  Int8.((  0,  5,  8,  6,  8,  5,  8,  6,  3, 10,  3,  6,  3, 10,  0,  5,  0, 10 ) .+ 1),
)

#=
 tiling table for case 5
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling5 = (
  Int8.((  2,  8,  3,  2, 10,  8, 10,  9,  8 ) .+ 1),
  Int8.((  1, 11,  2,  1,  9, 11,  9,  8, 11 ) .+ 1),
  Int8.((  4,  1,  9,  4,  7,  1,  7,  3,  1 ) .+ 1),
  Int8.((  8,  5,  4,  8,  3,  5,  3,  1,  5 ) .+ 1),
  Int8.((  0, 10,  1,  0,  8, 10,  8, 11, 10 ) .+ 1),
  Int8.(( 11,  4,  7, 11,  2,  4,  2,  0,  4 ) .+ 1),
  Int8.((  7,  0,  8,  7,  6,  0,  6,  2,  0 ) .+ 1),
  Int8.((  9,  3,  0,  9,  5,  3,  5,  7,  3 ) .+ 1),
  Int8.((  3,  6, 11,  3,  0,  6,  0,  4,  6 ) .+ 1),
  Int8.((  3,  9,  0,  3, 11,  9, 11, 10,  9 ) .+ 1),
  Int8.((  5,  2, 10,  5,  4,  2,  4,  0,  2 ) .+ 1),
  Int8.((  9,  6,  5,  9,  0,  6,  0,  2,  6 ) .+ 1),
  Int8.((  0,  7,  8,  0,  1,  7,  1,  5,  7 ) .+ 1),
  Int8.(( 10,  0,  1, 10,  6,  0,  6,  4,  0 ) .+ 1),
  Int8.((  6,  3, 11,  6,  5,  3,  5,  1,  3 ) .+ 1),
  Int8.(( 10,  7,  6, 10,  1,  7,  1,  3,  7 ) .+ 1),
  Int8.((  1,  4,  9,  1,  2,  4,  2,  6,  4 ) .+ 1),
  Int8.(( 11,  1,  2, 11,  7,  1,  7,  5,  1 ) .+ 1),
  Int8.((  8,  2,  3,  8,  4,  2,  4,  6,  2 ) .+ 1),
  Int8.((  2,  5, 10,  2,  3,  5,  3,  7,  5 ) .+ 1),
  Int8.((  7, 10,  6,  7,  8, 10,  8,  9, 10 ) .+ 1),
  Int8.((  6,  9,  5,  6, 11,  9, 11,  8,  9 ) .+ 1),
  Int8.((  5,  8,  4,  5, 10,  8, 10, 11,  8 ) .+ 1),
  Int8.((  4, 11,  7,  4,  9, 11,  9, 10, 11 ) .+ 1),
  Int8.((  4,  7, 11,  4, 11,  9,  9, 11, 10 ) .+ 1),
  Int8.((  5,  4,  8,  5,  8, 10, 10,  8, 11 ) .+ 1),
  Int8.((  6,  5,  9,  6,  9, 11, 11,  9,  8 ) .+ 1),
  Int8.((  7,  6, 10,  7, 10,  8,  8, 10,  9 ) .+ 1),
  Int8.((  2, 10,  5,  2,  5,  3,  3,  5,  7 ) .+ 1),
  Int8.((  8,  3,  2,  8,  2,  4,  4,  2,  6 ) .+ 1),
  Int8.(( 11,  2,  1, 11,  1,  7,  7,  1,  5 ) .+ 1),
  Int8.((  1,  9,  4,  1,  4,  2,  2,  4,  6 ) .+ 1),
  Int8.(( 10,  6,  7, 10,  7,  1,  1,  7,  3 ) .+ 1),
  Int8.((  6, 11,  3,  6,  3,  5,  5,  3,  1 ) .+ 1),
  Int8.(( 10,  1,  0, 10,  0,  6,  6,  0,  4 ) .+ 1),
  Int8.((  0,  8,  7,  0,  7,  1,  1,  7,  5 ) .+ 1),
  Int8.((  9,  5,  6,  9,  6,  0,  0,  6,  2 ) .+ 1),
  Int8.((  5, 10,  2,  5,  2,  4,  4,  2,  0 ) .+ 1),
  Int8.((  3,  0,  9,  3,  9, 11, 11,  9, 10 ) .+ 1),
  Int8.((  3, 11,  6,  3,  6,  0,  0,  6,  4 ) .+ 1),
  Int8.((  9,  0,  3,  9,  3,  5,  5,  3,  7 ) .+ 1),
  Int8.((  7,  8,  0,  7,  0,  6,  6,  0,  2 ) .+ 1),
  Int8.(( 11,  7,  4, 11,  4,  2,  2,  4,  0 ) .+ 1),
  Int8.((  0,  1, 10,  0, 10,  8,  8, 10, 11 ) .+ 1),
  Int8.((  8,  4,  5,  8,  5,  3,  3,  5,  1 ) .+ 1),
  Int8.((  4,  9,  1,  4,  1,  7,  7,  1,  3 ) .+ 1),
  Int8.((  1,  2, 11,  1, 11,  9,  9, 11,  8 ) .+ 1),
  Int8.((  2,  3,  8,  2,  8, 10, 10,  8,  9 ) .+ 1),
)

#=
 test table for case 6
 1 face to test + eventually the interior
 When the test on the specified face is positive : 5 first triangles
 When the test on the specified face is negative :
 - if the test on the interior is negative : 3 middle triangles
 - if the test on the interior is positive : 8 last triangles
 The support edge for the interior test is marked as the 3rd column.
 *
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const test6 = (
  Int8.((  2,  7,  10 + 1 )),
  Int8.((  4,  7,  11 + 1 )),
  Int8.((  5,  7,   1 + 1 )),
  Int8.((  5,  7,   3 + 1 )),
  Int8.((  1,  7,   9 + 1 )),
  Int8.((  3,  7,  10 + 1 )),
  Int8.((  6,  7,   5 + 1 )),
  Int8.((  1,  7,   8 + 1 )),
  Int8.((  4,  7,   8 + 1 )),
  Int8.((  1,  7,   8 + 1 )),
  Int8.((  3,  7,  11 + 1 )),
  Int8.((  5,  7,   2 + 1 )),
  Int8.((  5,  7,   0 + 1 )),
  Int8.((  1,  7,   9 + 1 )),
  Int8.((  6,  7,   6 + 1 )),
  Int8.((  2,  7,   9 + 1 )),
  Int8.((  4,  7,   8 + 1 )),
  Int8.((  2,  7,   9 + 1 )),
  Int8.((  2,  7,  10 + 1 )),
  Int8.((  6,  7,   7 + 1 )),
  Int8.((  3,  7,  10 + 1 )),
  Int8.((  4,  7,  11 + 1 )),
  Int8.((  3,  7,  11 + 1 )),
  Int8.((  6,  7,   4 + 1 )),
  Int8.(( -6, -7,   4 + 1 )),
  Int8.(( -3, -7,  11 + 1 )),
  Int8.(( -4, -7,  11 + 1 )),
  Int8.(( -3, -7,  10 + 1 )),
  Int8.(( -6, -7,   7 + 1 )),
  Int8.(( -2, -7,  10 + 1 )),
  Int8.(( -2, -7,   9 + 1 )),
  Int8.(( -4, -7,   8 + 1 )),
  Int8.(( -2, -7,   9 + 1 )),
  Int8.(( -6, -7,   6 + 1 )),
  Int8.(( -1, -7,   9 + 1 )),
  Int8.(( -5, -7,   0 + 1 )),
  Int8.(( -5, -7,   2 + 1 )),
  Int8.(( -3, -7,  11 + 1 )),
  Int8.(( -1, -7,   8 + 1 )),
  Int8.(( -4, -7,   8 + 1 )),
  Int8.(( -1, -7,   8 + 1 )),
  Int8.(( -6, -7,   5 + 1 )),
  Int8.(( -3, -7,  10 + 1 )),
  Int8.(( -1, -7,   9 + 1 )),
  Int8.(( -5, -7,   3 + 1 )),
  Int8.(( -5, -7,   1 + 1 )),
  Int8.(( -4, -7,  11 + 1 )),
  Int8.(( -2, -7,  10 + 1 )),
)

#=
 tiling table for case 6.1.1
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling6_1_1 = (
  Int8.((  6,  5, 10,  3,  1,  8,  9,  8,  1 ) .+ 1),
  Int8.(( 11,  7,  6,  9,  3,  1,  3,  9,  8 ) .+ 1),
  Int8.((  1,  2, 10,  7,  0,  4,  0,  7,  3 ) .+ 1),
  Int8.((  3,  0,  8,  5,  2,  6,  2,  5,  1 ) .+ 1),
  Int8.((  5,  4,  9,  2,  0, 11,  8, 11,  0 ) .+ 1),
  Int8.(( 10,  6,  5,  8,  2,  0,  2,  8, 11 ) .+ 1),
  Int8.(( 10,  6,  5,  0,  4,  3,  7,  3,  4 ) .+ 1),
  Int8.((  3,  0,  8,  6,  4, 10,  9, 10,  4 ) .+ 1),
  Int8.((  8,  3,  0, 10,  7,  5,  7, 10, 11 ) .+ 1),
  Int8.((  8,  4,  7, 10,  0,  2,  0, 10,  9 ) .+ 1),
  Int8.((  7,  6, 11,  0,  2,  9, 10,  9,  2 ) .+ 1),
  Int8.((  2,  3, 11,  4,  1,  5,  1,  4,  0 ) .+ 1),
  Int8.((  0,  1,  9,  6,  3,  7,  3,  6,  2 ) .+ 1),
  Int8.((  9,  0,  1, 11,  4,  6,  4, 11,  8 ) .+ 1),
  Int8.(( 11,  7,  6,  1,  5,  0,  4,  0,  5 ) .+ 1),
  Int8.((  0,  1,  9,  7,  5, 11, 10, 11,  5 ) .+ 1),
  Int8.((  4,  7,  8,  1,  3, 10, 11, 10,  3 ) .+ 1),
  Int8.((  9,  5,  4, 11,  1,  3,  1, 11, 10 ) .+ 1),
  Int8.(( 10,  1,  2,  8,  5,  7,  5,  8,  9 ) .+ 1),
  Int8.((  8,  4,  7,  2,  6,  1,  5,  1,  6 ) .+ 1),
  Int8.((  1,  2, 10,  4,  6,  8, 11,  8,  6 ) .+ 1),
  Int8.((  2,  3, 11,  5,  7,  9,  8,  9,  7 ) .+ 1),
  Int8.(( 11,  2,  3,  9,  6,  4,  6,  9, 10 ) .+ 1),
  Int8.((  9,  5,  4,  3,  7,  2,  6,  2,  7 ) .+ 1),
  Int8.((  4,  5,  9,  2,  7,  3,  7,  2,  6 ) .+ 1),
  Int8.((  3,  2, 11,  4,  6,  9, 10,  9,  6 ) .+ 1),
  Int8.(( 11,  3,  2,  9,  7,  5,  7,  9,  8 ) .+ 1),
  Int8.(( 10,  2,  1,  8,  6,  4,  6,  8, 11 ) .+ 1),
  Int8.((  7,  4,  8,  1,  6,  2,  6,  1,  5 ) .+ 1),
  Int8.((  2,  1, 10,  7,  5,  8,  9,  8,  5 ) .+ 1),
  Int8.((  4,  5,  9,  3,  1, 11, 10, 11,  1 ) .+ 1),
  Int8.((  8,  7,  4, 10,  3,  1,  3, 10, 11 ) .+ 1),
  Int8.((  9,  1,  0, 11,  5,  7,  5, 11, 10 ) .+ 1),
  Int8.((  6,  7, 11,  0,  5,  1,  5,  0,  4 ) .+ 1),
  Int8.((  1,  0,  9,  6,  4, 11,  8, 11,  4 ) .+ 1),
  Int8.((  9,  1,  0,  7,  3,  6,  2,  6,  3 ) .+ 1),
  Int8.(( 11,  3,  2,  5,  1,  4,  0,  4,  1 ) .+ 1),
  Int8.(( 11,  6,  7,  9,  2,  0,  2,  9, 10 ) .+ 1),
  Int8.((  7,  4,  8,  2,  0, 10,  9, 10,  0 ) .+ 1),
  Int8.((  0,  3,  8,  5,  7, 10, 11, 10,  7 ) .+ 1),
  Int8.((  8,  0,  3, 10,  4,  6,  4, 10,  9 ) .+ 1),
  Int8.((  5,  6, 10,  3,  4,  0,  4,  3,  7 ) .+ 1),
  Int8.((  5,  6, 10,  0,  2,  8, 11,  8,  2 ) .+ 1),
  Int8.((  9,  4,  5, 11,  0,  2,  0, 11,  8 ) .+ 1),
  Int8.((  8,  0,  3,  6,  2,  5,  1,  5,  2 ) .+ 1),
  Int8.(( 10,  2,  1,  4,  0,  7,  3,  7,  0 ) .+ 1),
  Int8.((  6,  7, 11,  1,  3,  9,  8,  9,  3 ) .+ 1),
  Int8.(( 10,  5,  6,  8,  1,  3,  1,  8,  9 ) .+ 1),
)

#=
 tiling table for case 6.1.2
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling6_1_2 = (
    Int8.(( 1, 12,  3, 12, 10,  3,  6,  3, 10,  3,  6,  8,  5,  8,  6,  8,  5, 12, 12,  9,  8,  1,  9, 12, 12,  5, 10 ) .+ 1),
    Int8.(( 1, 12,  3,  1, 11, 12, 11,  1,  6,  9,  6,  1,  6,  9,  7, 12,  7,  9,  9,  8, 12, 12,  8,  3, 11,  7, 12 ) .+ 1),
    Int8.(( 4, 12,  0,  4,  1, 12,  1,  4, 10,  7, 10,  4, 10,  7,  2, 12,  2,  7,  7,  3, 12, 12,  3,  0,  1,  2, 12 ) .+ 1),
    Int8.(( 6, 12,  2,  6,  3, 12,  3,  6,  8,  5,  8,  6,  8,  5,  0, 12,  0,  5,  5,  1, 12, 12,  1,  2,  3,  0, 12 ) .+ 1),
    Int8.(( 0, 12,  2, 12,  9,  2,  5,  2,  9,  2,  5, 11,  4, 11,  5, 11,  4, 12, 12,  8, 11,  0,  8, 12, 12,  4,  9 ) .+ 1),
    Int8.(( 0, 12,  2,  0, 10, 12, 10,  0,  5,  8,  5,  0,  5,  8,  6, 12,  6,  8,  8, 11, 12, 12, 11,  2, 10,  6, 12 ) .+ 1),
    Int8.(( 4, 12,  0, 12,  5,  0, 10,  0,  5,  0, 10,  3,  6,  3, 10,  3,  6, 12, 12,  7,  3,  4,  7, 12, 12,  6,  5 ) .+ 1),
    Int8.(( 4, 12,  6, 12,  8,  6,  3,  6,  8,  6,  3, 10,  0, 10,  3, 10,  0, 12, 12,  9, 10,  4,  9, 12, 12,  0,  8 ) .+ 1),
    Int8.(( 5, 12,  7,  5,  8, 12,  8,  5,  0, 10,  0,  5,  0, 10,  3, 12,  3, 10, 10, 11, 12, 12, 11,  7,  8,  3, 12 ) .+ 1),
    Int8.(( 2, 12,  0,  2,  8, 12,  8,  2,  7, 10,  7,  2,  7, 10,  4, 12,  4, 10, 10,  9, 12, 12,  9,  0,  8,  4, 12 ) .+ 1),
    Int8.(( 2, 12,  0, 12, 11,  0,  7,  0, 11,  0,  7,  9,  6,  9,  7,  9,  6, 12, 12, 10,  9,  2, 10, 12, 12,  6, 11 ) .+ 1),
    Int8.(( 5, 12,  1,  5,  2, 12,  2,  5, 11,  4, 11,  5, 11,  4,  3, 12,  3,  4,  4,  0, 12, 12,  0,  1,  2,  3, 12 ) .+ 1),
    Int8.(( 7, 12,  3,  7,  0, 12,  0,  7,  9,  6,  9,  7,  9,  6,  1, 12,  1,  6,  6,  2, 12, 12,  2,  3,  0,  1, 12 ) .+ 1),
    Int8.(( 6, 12,  4,  6,  9, 12,  9,  6,  1, 11,  1,  6,  1, 11,  0, 12,  0, 11, 11,  8, 12, 12,  8,  4,  9,  0, 12 ) .+ 1),
    Int8.(( 5, 12,  1, 12,  6,  1, 11,  1,  6,  1, 11,  0,  7,  0, 11,  0,  7, 12, 12,  4,  0,  5,  4, 12, 12,  7,  6 ) .+ 1),
    Int8.(( 5, 12,  7, 12,  9,  7,  0,  7,  9,  7,  0, 11,  1, 11,  0, 11,  1, 12, 12, 10, 11,  5, 10, 12, 12,  1,  9 ) .+ 1),
    Int8.(( 3, 12,  1, 12,  8,  1,  4,  1,  8,  1,  4, 10,  7, 10,  4, 10,  7, 12, 12, 11, 10,  3, 11, 12, 12,  7,  8 ) .+ 1),
    Int8.(( 3, 12,  1,  3,  9, 12,  9,  3,  4, 11,  4,  3,  4, 11,  5, 12,  5, 11, 11, 10, 12, 12, 10,  1,  9,  5, 12 ) .+ 1),
    Int8.(( 7, 12,  5,  7, 10, 12, 10,  7,  2,  8,  2,  7,  2,  8,  1, 12,  1,  8,  8,  9, 12, 12,  9,  5, 10,  1, 12 ) .+ 1),
    Int8.(( 6, 12,  2, 12,  7,  2,  8,  2,  7,  2,  8,  1,  4,  1,  8,  1,  4, 12, 12,  5,  1,  6,  5, 12, 12,  4,  7 ) .+ 1),
    Int8.(( 6, 12,  4, 12, 10,  4,  1,  4, 10,  4,  1,  8,  2,  8,  1,  8,  2, 12, 12, 11,  8,  6, 11, 12, 12,  2, 10 ) .+ 1),
    Int8.(( 7, 12,  5, 12, 11,  5,  2,  5, 11,  5,  2,  9,  3,  9,  2,  9,  3, 12, 12,  8,  9,  7,  8, 12, 12,  3, 11 ) .+ 1),
    Int8.(( 4, 12,  6,  4, 11, 12, 11,  4,  3,  9,  3,  4,  3,  9,  2, 12,  2,  9,  9, 10, 12, 12, 10,  6, 11,  2, 12 ) .+ 1),
    Int8.(( 7, 12,  3, 12,  4,  3,  9,  3,  4,  3,  9,  2,  5,  2,  9,  2,  5, 12, 12,  6,  2,  7,  6, 12, 12,  5,  4 ) .+ 1),
    Int8.(( 3, 12,  7,  3,  4, 12,  4,  3,  9,  2,  9,  3,  9,  2,  5, 12,  5,  2,  2,  6, 12, 12,  6,  7,  4,  5, 12 ) .+ 1),
    Int8.(( 6, 12,  4, 12, 11,  4,  3,  4, 11,  4,  3,  9,  2,  9,  3,  9,  2, 12, 12, 10,  9,  6, 10, 12, 12,  2, 11 ) .+ 1),
    Int8.(( 5, 12,  7,  5, 11, 12, 11,  5,  2,  9,  2,  5,  2,  9,  3, 12,  3,  9,  9,  8, 12, 12,  8,  7, 11,  3, 12 ) .+ 1),
    Int8.(( 4, 12,  6,  4, 10, 12, 10,  4,  1,  8,  1,  4,  1,  8,  2, 12,  2,  8,  8, 11, 12, 12, 11,  6, 10,  2, 12 ) .+ 1),
    Int8.(( 2, 12,  6,  2,  7, 12,  7,  2,  8,  1,  8,  2,  8,  1,  4, 12,  4,  1,  1,  5, 12, 12,  5,  6,  7,  4, 12 ) .+ 1),
    Int8.(( 5, 12,  7, 12, 10,  7,  2,  7, 10,  7,  2,  8,  1,  8,  2,  8,  1, 12, 12,  9,  8,  5,  9, 12, 12,  1, 10 ) .+ 1),
    Int8.(( 1, 12,  3, 12,  9,  3,  4,  3,  9,  3,  4, 11,  5, 11,  4, 11,  5, 12, 12, 10, 11,  1, 10, 12, 12,  5,  9 ) .+ 1),
    Int8.(( 1, 12,  3,  1,  8, 12,  8,  1,  4, 10,  4,  1,  4, 10,  7, 12,  7, 10, 10, 11, 12, 12, 11,  3,  8,  7, 12 ) .+ 1),
    Int8.(( 7, 12,  5,  7,  9, 12,  9,  7,  0, 11,  0,  7,  0, 11,  1, 12,  1, 11, 11, 10, 12, 12, 10,  5,  9,  1, 12 ) .+ 1),
    Int8.(( 1, 12,  5,  1,  6, 12,  6,  1, 11,  0, 11,  1, 11,  0,  7, 12,  7,  0,  0,  4, 12, 12,  4,  5,  6,  7, 12 ) .+ 1),
    Int8.(( 4, 12,  6, 12,  9,  6,  1,  6,  9,  6,  1, 11,  0, 11,  1, 11,  0, 12, 12,  8, 11,  4,  8, 12, 12,  0,  9 ) .+ 1),
    Int8.(( 3, 12,  7, 12,  0,  7,  9,  7,  0,  7,  9,  6,  1,  6,  9,  6,  1, 12, 12,  2,  6,  3,  2, 12, 12,  1,  0 ) .+ 1),
    Int8.(( 1, 12,  5, 12,  2,  5, 11,  5,  2,  5, 11,  4,  3,  4, 11,  4,  3, 12, 12,  0,  4,  1,  0, 12, 12,  3,  2 ) .+ 1),
    Int8.(( 0, 12,  2,  0, 11, 12, 11,  0,  7,  9,  7,  0,  7,  9,  6, 12,  6,  9,  9, 10, 12, 12, 10,  2, 11,  6, 12 ) .+ 1),
    Int8.(( 0, 12,  2, 12,  8,  2,  7,  2,  8,  2,  7, 10,  4, 10,  7, 10,  4, 12, 12,  9, 10,  0,  9, 12, 12,  4,  8 ) .+ 1),
    Int8.(( 7, 12,  5, 12,  8,  5,  0,  5,  8,  5,  0, 10,  3, 10,  0, 10,  3, 12, 12, 11, 10,  7, 11, 12, 12,  3,  8 ) .+ 1),
    Int8.(( 6, 12,  4,  6,  8, 12,  8,  6,  3, 10,  3,  6,  3, 10,  0, 12,  0, 10, 10,  9, 12, 12,  9,  4,  8,  0, 12 ) .+ 1),
    Int8.(( 0, 12,  4,  0,  5, 12,  5,  0, 10,  3, 10,  0, 10,  3,  6, 12,  6,  3,  3,  7, 12, 12,  7,  4,  5,  6, 12 ) .+ 1),
    Int8.(( 2, 12,  0, 12, 10,  0,  5,  0, 10,  0,  5,  8,  6,  8,  5,  8,  6, 12, 12, 11,  8,  2, 11, 12, 12,  6, 10 ) .+ 1),
    Int8.(( 2, 12,  0,  2,  9, 12,  9,  2,  5, 11,  5,  2,  5, 11,  4, 12,  4, 11, 11,  8, 12, 12,  8,  0,  9,  4, 12 ) .+ 1),
    Int8.(( 2, 12,  6, 12,  3,  6,  8,  6,  3,  6,  8,  5,  0,  5,  8,  5,  0, 12, 12,  1,  5,  2,  1, 12, 12,  0,  3 ) .+ 1),
    Int8.(( 0, 12,  4, 12,  1,  4, 10,  4,  1,  4, 10,  7,  2,  7, 10,  7,  2, 12, 12,  3,  7,  0,  3, 12, 12,  2,  1 ) .+ 1),
    Int8.(( 3, 12,  1, 12, 11,  1,  6,  1, 11,  1,  6,  9,  7,  9,  6,  9,  7, 12, 12,  8,  9,  3,  8, 12, 12,  7, 11 ) .+ 1),
    Int8.(( 3, 12,  1,  3, 10, 12, 10,  3,  6,  8,  6,  3,  6,  8,  5, 12,  5,  8,  8,  9, 12, 12,  9,  1, 10,  5, 12 ) .+ 1),
)

#=
 tiling table for case 6.2
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling6_2 = (
  Int8.(( 1, 10,  3,  6,  3, 10,  3,  6,  8,  5,  8,  6,  8,  5,  9 ) .+ 1),
  Int8.(( 1, 11,  3, 11,  1,  6,  9,  6,  1,  6,  9,  7,  8,  7,  9 ) .+ 1),
  Int8.(( 4,  1,  0,  1,  4, 10,  7, 10,  4, 10,  7,  2,  3,  2,  7 ) .+ 1),
  Int8.(( 6,  3,  2,  3,  6,  8,  5,  8,  6,  8,  5,  0,  1,  0,  5 ) .+ 1),
  Int8.(( 0,  9,  2,  5,  2,  9,  2,  5, 11,  4, 11,  5, 11,  4,  8 ) .+ 1),
  Int8.(( 0, 10,  2, 10,  0,  5,  8,  5,  0,  5,  8,  6, 11,  6,  8 ) .+ 1),
  Int8.(( 4,  5,  0, 10,  0,  5,  0, 10,  3,  6,  3, 10,  3,  6,  7 ) .+ 1),
  Int8.(( 4,  8,  6,  3,  6,  8,  6,  3, 10,  0, 10,  3, 10,  0,  9 ) .+ 1),
  Int8.(( 5,  8,  7,  8,  5,  0, 10,  0,  5,  0, 10,  3, 11,  3, 10 ) .+ 1),
  Int8.(( 2,  8,  0,  8,  2,  7, 10,  7,  2,  7, 10,  4,  9,  4, 10 ) .+ 1),
  Int8.(( 2, 11,  0,  7,  0, 11,  0,  7,  9,  6,  9,  7,  9,  6, 10 ) .+ 1),
  Int8.(( 5,  2,  1,  2,  5, 11,  4, 11,  5, 11,  4,  3,  0,  3,  4 ) .+ 1),
  Int8.(( 7,  0,  3,  0,  7,  9,  6,  9,  7,  9,  6,  1,  2,  1,  6 ) .+ 1),
  Int8.(( 6,  9,  4,  9,  6,  1, 11,  1,  6,  1, 11,  0,  8,  0, 11 ) .+ 1),
  Int8.(( 5,  6,  1, 11,  1,  6,  1, 11,  0,  7,  0, 11,  0,  7,  4 ) .+ 1),
  Int8.(( 5,  9,  7,  0,  7,  9,  7,  0, 11,  1, 11,  0, 11,  1, 10 ) .+ 1),
  Int8.(( 3,  8,  1,  4,  1,  8,  1,  4, 10,  7, 10,  4, 10,  7, 11 ) .+ 1),
  Int8.(( 3,  9,  1,  9,  3,  4, 11,  4,  3,  4, 11,  5, 10,  5, 11 ) .+ 1),
  Int8.(( 7, 10,  5, 10,  7,  2,  8,  2,  7,  2,  8,  1,  9,  1,  8 ) .+ 1),
  Int8.(( 6,  7,  2,  8,  2,  7,  2,  8,  1,  4,  1,  8,  1,  4,  5 ) .+ 1),
  Int8.(( 6, 10,  4,  1,  4, 10,  4,  1,  8,  2,  8,  1,  8,  2, 11 ) .+ 1),
  Int8.(( 7, 11,  5,  2,  5, 11,  5,  2,  9,  3,  9,  2,  9,  3,  8 ) .+ 1),
  Int8.(( 4, 11,  6, 11,  4,  3,  9,  3,  4,  3,  9,  2, 10,  2,  9 ) .+ 1),
  Int8.(( 7,  4,  3,  9,  3,  4,  3,  9,  2,  5,  2,  9,  2,  5,  6 ) .+ 1),
  Int8.(( 3,  4,  7,  4,  3,  9,  2,  9,  3,  9,  2,  5,  6,  5,  2 ) .+ 1),
  Int8.(( 6, 11,  4,  3,  4, 11,  4,  3,  9,  2,  9,  3,  9,  2, 10 ) .+ 1),
  Int8.(( 5, 11,  7, 11,  5,  2,  9,  2,  5,  2,  9,  3,  8,  3,  9 ) .+ 1),
  Int8.(( 4, 10,  6, 10,  4,  1,  8,  1,  4,  1,  8,  2, 11,  2,  8 ) .+ 1),
  Int8.(( 2,  7,  6,  7,  2,  8,  1,  8,  2,  8,  1,  4,  5,  4,  1 ) .+ 1),
  Int8.(( 5, 10,  7,  2,  7, 10,  7,  2,  8,  1,  8,  2,  8,  1,  9 ) .+ 1),
  Int8.(( 1,  9,  3,  4,  3,  9,  3,  4, 11,  5, 11,  4, 11,  5, 10 ) .+ 1),
  Int8.(( 1,  8,  3,  8,  1,  4, 10,  4,  1,  4, 10,  7, 11,  7, 10 ) .+ 1),
  Int8.(( 7,  9,  5,  9,  7,  0, 11,  0,  7,  0, 11,  1, 10,  1, 11 ) .+ 1),
  Int8.(( 1,  6,  5,  6,  1, 11,  0, 11,  1, 11,  0,  7,  4,  7,  0 ) .+ 1),
  Int8.(( 4,  9,  6,  1,  6,  9,  6,  1, 11,  0, 11,  1, 11,  0,  8 ) .+ 1),
  Int8.(( 3,  0,  7,  9,  7,  0,  7,  9,  6,  1,  6,  9,  6,  1,  2 ) .+ 1),
  Int8.(( 1,  2,  5, 11,  5,  2,  5, 11,  4,  3,  4, 11,  4,  3,  0 ) .+ 1),
  Int8.(( 0, 11,  2, 11,  0,  7,  9,  7,  0,  7,  9,  6, 10,  6,  9 ) .+ 1),
  Int8.(( 0,  8,  2,  7,  2,  8,  2,  7, 10,  4, 10,  7, 10,  4,  9 ) .+ 1),
  Int8.(( 7,  8,  5,  0,  5,  8,  5,  0, 10,  3, 10,  0, 10,  3, 11 ) .+ 1),
  Int8.(( 6,  8,  4,  8,  6,  3, 10,  3,  6,  3, 10,  0,  9,  0, 10 ) .+ 1),
  Int8.(( 0,  5,  4,  5,  0, 10,  3, 10,  0, 10,  3,  6,  7,  6,  3 ) .+ 1),
  Int8.(( 2, 10,  0,  5,  0, 10,  0,  5,  8,  6,  8,  5,  8,  6, 11 ) .+ 1),
  Int8.(( 2,  9,  0,  9,  2,  5, 11,  5,  2,  5, 11,  4,  8,  4, 11 ) .+ 1),
  Int8.(( 2,  3,  6,  8,  6,  3,  6,  8,  5,  0,  5,  8,  5,  0,  1 ) .+ 1),
  Int8.(( 0,  1,  4, 10,  4,  1,  4, 10,  7,  2,  7, 10,  7,  2,  3 ) .+ 1),
  Int8.(( 3, 11,  1,  6,  1, 11,  1,  6,  9,  7,  9,  6,  9,  7,  8 ) .+ 1),
  Int8.(( 3, 10,  1, 10,  3,  6,  8,  6,  3,  6,  8,  5,  9,  5,  8 ) .+ 1),
)

#=
 test table for case 7
 3 faces to test + eventually the interior
 When the tests on the 3 specified faces are positive :
 - if the test on the interior is positive : 5 first triangles
 - if the test on the interior is negative : 9 next triangles
 When the tests on the first  and the second specified faces are positive : 9 next triangles
 When the tests on the first  and the third  specified faces are positive : 9 next triangles
 When the tests on the second and the third  specified faces are positive : 9 next triangles
 When the test on the first  specified face is positive : 5 next triangles
 When the test on the second specified face is positive : 5 next triangles
 When the test on the third  specified face is positive : 5 next triangles
 When the tests on the 3 specified faces are negative : 3 last triangles
 The support edge for the interior test is marked as the 5th column.
 *
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const test7 = (
  Int8.((  1,  2,  5,  7,  1 + 1 )),
  Int8.((  3,  4,  5,  7,  3 + 1 )),
  Int8.((  4,  1,  6,  7,  4 + 1 )),
  Int8.((  4,  1,  5,  7,  0 + 1 )),
  Int8.((  2,  3,  5,  7,  2 + 1 )),
  Int8.((  1,  2,  6,  7,  5 + 1 )),
  Int8.((  2,  3,  6,  7,  6 + 1 )),
  Int8.((  3,  4,  6,  7,  7 + 1 )),
  Int8.(( -3, -4, -6, -7,  7 + 1 )),
  Int8.(( -2, -3, -6, -7,  6 + 1 )),
  Int8.(( -1, -2, -6, -7,  5 + 1 )),
  Int8.(( -2, -3, -5, -7,  2 + 1 )),
  Int8.(( -4, -1, -5, -7,  0 + 1 )),
  Int8.(( -4, -1, -6, -7,  4 + 1 )),
  Int8.(( -3, -4, -5, -7,  3 + 1 )),
  Int8.(( -1, -2, -5, -7,  1 + 1 )),
)

#=
 tiling table for case 7.1
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling7_1 = (
  Int8.((  9,  5,  4, 10,  1,  2,  8,  3,  0 ) .+ 1),
  Int8.(( 11,  7,  6,  8,  3,  0, 10,  1,  2 ) .+ 1),
  Int8.((  3,  0,  8,  5,  4,  9,  7,  6, 11 ) .+ 1),
  Int8.((  8,  4,  7,  9,  0,  1, 11,  2,  3 ) .+ 1),
  Int8.(( 10,  6,  5, 11,  2,  3,  9,  0,  1 ) .+ 1),
  Int8.((  0,  1,  9,  6,  5, 10,  4,  7,  8 ) .+ 1),
  Int8.((  1,  2, 10,  7,  6, 11,  5,  4,  9 ) .+ 1),
  Int8.((  2,  3, 11,  4,  7,  8,  6,  5, 10 ) .+ 1),
  Int8.(( 11,  3,  2,  8,  7,  4, 10,  5,  6 ) .+ 1),
  Int8.(( 10,  2,  1, 11,  6,  7,  9,  4,  5 ) .+ 1),
  Int8.((  9,  1,  0, 10,  5,  6,  8,  7,  4 ) .+ 1),
  Int8.((  5,  6, 10,  3,  2, 11,  1,  0,  9 ) .+ 1),
  Int8.((  7,  4,  8,  1,  0,  9,  3,  2, 11 ) .+ 1),
  Int8.((  8,  0,  3,  9,  4,  5, 11,  6,  7 ) .+ 1),
  Int8.((  6,  7, 11,  0,  3,  8,  2,  1, 10 ) .+ 1),
  Int8.((  4,  5,  9,  2,  1, 10,  0,  3,  8 ) .+ 1),
)

#=
 tiling table for case 7.2
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling7_2 = (
  (
   Int8.((  1,  2, 10,  3,  4,  8,  4,  3,  5,  0,  5,  3,  5,  0,  9 ) .+ 1),
   Int8.((  3,  0,  8,  9,  1,  4,  2,  4,  1,  4,  2,  5, 10,  5,  2 ) .+ 1),
   Int8.((  9,  5,  4,  0, 10,  1, 10,  0,  8, 10,  8,  2,  3,  2,  8 ) .+ 1),
),
  (
   Int8.((  3,  0,  8,  1,  6, 10,  6,  1,  7,  2,  7,  1,  7,  2, 11 ) .+ 1),
   Int8.((  1,  2, 10, 11,  3,  6,  0,  6,  3,  6,  0,  7,  8,  7,  0 ) .+ 1),
   Int8.(( 11,  7,  6,  2,  8,  3,  8,  2, 10,  8, 10,  0,  1,  0, 10 ) .+ 1),
),
  (
   Int8.((  9,  5,  4, 11,  3,  6,  0,  6,  3,  6,  0,  7,  8,  7,  0 ) .+ 1),
   Int8.(( 11,  7,  6,  3,  4,  8,  4,  3,  5,  0,  5,  3,  5,  0,  9 ) .+ 1),
   Int8.((  3,  0,  8,  4,  9,  7, 11,  7,  9,  5, 11,  9, 11,  5,  6 ) .+ 1),
),
  (
   Int8.((  0,  1,  9,  2,  7, 11,  7,  2,  4,  3,  4,  2,  4,  3,  8 ) .+ 1),
   Int8.((  2,  3, 11,  8,  0,  7,  1,  7,  0,  7,  1,  4,  9,  4,  1 ) .+ 1),
   Int8.((  8,  4,  7,  3,  9,  0,  9,  3, 11,  9, 11,  1,  2,  1, 11 ) .+ 1),
),
  (
   Int8.((  2,  3, 11,  0,  5,  9,  5,  0,  6,  1,  6,  0,  6,  1, 10 ) .+ 1),
   Int8.((  0,  1,  9, 10,  2,  5,  3,  5,  2,  5,  3,  6, 11,  6,  3 ) .+ 1),
   Int8.((  6,  5, 10,  1, 11,  2, 11,  1,  9, 11,  9,  3,  0,  3,  9 ) .+ 1),
),
  (
   Int8.((  6,  5, 10,  8,  0,  7,  1,  7,  0,  7,  1,  4,  9,  4,  1 ) .+ 1),
   Int8.((  8,  4,  7,  0,  5,  9,  5,  0,  6,  1,  6,  0,  6,  1, 10 ) .+ 1),
   Int8.((  0,  1,  9,  5, 10,  4,  8,  4, 10,  6,  8, 10,  8,  6,  7 ) .+ 1),
),
  (
   Int8.(( 11,  7,  6,  9,  1,  4,  2,  4,  1,  4,  2,  5, 10,  5,  2 ) .+ 1),
   Int8.((  9,  5,  4,  1,  6, 10,  6,  1,  7,  2,  7,  1,  7,  2, 11 ) .+ 1),
   Int8.((  1,  2, 10,  6, 11,  5,  9,  5, 11,  7,  9, 11,  9,  7,  4 ) .+ 1),
),
  (
   Int8.((  8,  4,  7, 10,  2,  5,  3,  5,  2,  5,  3,  6, 11,  6,  3 ) .+ 1),
   Int8.((  6,  5, 10,  2,  7, 11,  7,  2,  4,  3,  4,  2,  4,  3,  8 ) .+ 1),
   Int8.((  2,  3, 11,  7,  8,  6, 10,  6,  8,  4, 10,  8, 10,  4,  5 ) .+ 1),
),
  (
   Int8.((  7,  4,  8,  5,  2, 10,  2,  5,  3,  6,  3,  5,  3,  6, 11 ) .+ 1),
   Int8.(( 10,  5,  6, 11,  7,  2,  4,  2,  7,  2,  4,  3,  8,  3,  4 ) .+ 1),
   Int8.(( 11,  3,  2,  6,  8,  7,  8,  6, 10,  8, 10,  4,  5,  4, 10 ) .+ 1),
),
  (
   Int8.((  6,  7, 11,  4,  1,  9,  1,  4,  2,  5,  2,  4,  2,  5, 10 ) .+ 1),
   Int8.((  4,  5,  9, 10,  6,  1,  7,  1,  6,  1,  7,  2, 11,  2,  7 ) .+ 1),
   Int8.(( 10,  2,  1,  5, 11,  6, 11,  5,  9, 11,  9,  7,  4,  7,  9 ) .+ 1),
),
  (
   Int8.(( 10,  5,  6,  7,  0,  8,  0,  7,  1,  4,  1,  7,  1,  4,  9 ) .+ 1),
   Int8.((  7,  4,  8,  9,  5,  0,  6,  0,  5,  0,  6,  1, 10,  1,  6 ) .+ 1),
   Int8.((  9,  1,  0,  4, 10,  5, 10,  4,  8, 10,  8,  6,  7,  6,  8 ) .+ 1),
),
  (
   Int8.(( 11,  3,  2,  9,  5,  0,  6,  0,  5,  0,  6,  1, 10,  1,  6 ) .+ 1),
   Int8.((  9,  1,  0,  5,  2, 10,  2,  5,  3,  6,  3,  5,  3,  6, 11 ) .+ 1),
   Int8.(( 10,  5,  6,  2, 11,  1,  9,  1, 11,  3,  9, 11,  9,  3,  0 ) .+ 1),
),
  (
   Int8.((  9,  1,  0, 11,  7,  2,  4,  2,  7,  2,  4,  3,  8,  3,  4 ) .+ 1),
   Int8.(( 11,  3,  2,  7,  0,  8,  0,  7,  1,  4,  1,  7,  1,  4,  9 ) .+ 1),
   Int8.((  7,  4,  8,  0,  9,  3, 11,  3,  9,  1, 11,  9, 11,  1,  2 ) .+ 1),
),
  (
   Int8.((  4,  5,  9,  6,  3, 11,  3,  6,  0,  7,  0,  6,  0,  7,  8 ) .+ 1),
   Int8.((  6,  7, 11,  8,  4,  3,  5,  3,  4,  3,  5,  0,  9,  0,  5 ) .+ 1),
   Int8.((  8,  0,  3,  7,  9,  4,  9,  7, 11,  9, 11,  5,  6,  5, 11 ) .+ 1),
),
  (
   Int8.((  8,  0,  3, 10,  6,  1,  7,  1,  6,  1,  7,  2, 11,  2,  7 ) .+ 1),
   Int8.(( 10,  2,  1,  6,  3, 11,  3,  6,  0,  7,  0,  6,  0,  7,  8 ) .+ 1),
   Int8.((  6,  7, 11,  3,  8,  2, 10,  2,  8,  0, 10,  8, 10,  0,  1 ) .+ 1),
),
  (
   Int8.(( 10,  2,  1,  8,  4,  3,  5,  3,  4,  3,  5,  0,  9,  0,  5 ) .+ 1),
   Int8.((  8,  0,  3,  4,  1,  9,  1,  4,  2,  5,  2,  4,  2,  5, 10 ) .+ 1),
   Int8.((  4,  5,  9,  1, 10,  0,  8,  0, 10,  2,  8, 10,  8,  2,  3 ) .+ 1),
))

#=
 tiling table for case 7.3
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling7_3 = (
  (
   Int8.(( 12,  2, 10, 12, 10,  5, 12,  5,  4, 12,  4,  8, 12,  8,  3, 12,  3,  0, 12,  0,  9, 12,  9,  1, 12,  1,  2 ) .+ 1),
   Int8.(( 12,  5,  4, 12,  4,  8, 12,  8,  3, 12,  3,  2, 12,  2, 10, 12, 10,  1, 12,  1,  0, 12,  0,  9, 12,  9,  5 ) .+ 1),
   Int8.((  5,  4, 12, 10,  5, 12,  2, 10, 12,  3,  2, 12,  8,  3, 12,  0,  8, 12,  1,  0, 12,  9,  1, 12,  4,  9, 12 ) .+ 1),
),
  (
   Int8.(( 12,  0,  8, 12,  8,  7, 12,  7,  6, 12,  6, 10, 12, 10,  1, 12,  1,  2, 12,  2, 11, 12, 11,  3, 12,  3,  0 ) .+ 1),
   Int8.(( 12,  7,  6, 12,  6, 10, 12, 10,  1, 12,  1,  0, 12,  0,  8, 12,  8,  3, 12,  3,  2, 12,  2, 11, 12, 11,  7 ) .+ 1),
   Int8.((  7,  6, 12,  8,  7, 12,  0,  8, 12,  1,  0, 12, 10,  1, 12,  2, 10, 12,  3,  2, 12, 11,  3, 12,  6, 11, 12 ) .+ 1),
),
  (
   Int8.((  9,  5, 12,  0,  9, 12,  3,  0, 12, 11,  3, 12,  6, 11, 12,  7,  6, 12,  8,  7, 12,  4,  8, 12,  5,  4, 12 ) .+ 1),
   Int8.((  3,  0, 12, 11,  3, 12,  6, 11, 12,  5,  6, 12,  9,  5, 12,  4,  9, 12,  7,  4, 12,  8,  7, 12,  0,  8, 12 ) .+ 1),
   Int8.(( 12,  3,  0, 12,  0,  9, 12,  9,  5, 12,  5,  6, 12,  6, 11, 12, 11,  7, 12,  7,  4, 12,  4,  8, 12,  8,  3 ) .+ 1),
),
  (
   Int8.(( 12,  1,  9, 12,  9,  4, 12,  4,  7, 12,  7, 11, 12, 11,  2, 12,  2,  3, 12,  3,  8, 12,  8,  0, 12,  0,  1 ) .+ 1),
   Int8.(( 12,  4,  7, 12,  7, 11, 12, 11,  2, 12,  2,  1, 12,  1,  9, 12,  9,  0, 12,  0,  3, 12,  3,  8, 12,  8,  4 ) .+ 1),
   Int8.((  4,  7, 12,  9,  4, 12,  1,  9, 12,  2,  1, 12, 11,  2, 12,  3, 11, 12,  0,  3, 12,  8,  0, 12,  7,  8, 12 ) .+ 1),
),
  (
   Int8.(( 12,  3, 11, 12, 11,  6, 12,  6,  5, 12,  5,  9, 12,  9,  0, 12,  0,  1, 12,  1, 10, 12, 10,  2, 12,  2,  3 ) .+ 1),
   Int8.(( 12,  6,  5, 12,  5,  9, 12,  9,  0, 12,  0,  3, 12,  3, 11, 12, 11,  2, 12,  2,  1, 12,  1, 10, 12, 10,  6 ) .+ 1),
   Int8.((  6,  5, 12, 11,  6, 12,  3, 11, 12,  0,  3, 12,  9,  0, 12,  1,  9, 12,  2,  1, 12, 10,  2, 12,  5, 10, 12 ) .+ 1),
),
  (
   Int8.(( 10,  6, 12,  1, 10, 12,  0,  1, 12,  8,  0, 12,  7,  8, 12,  4,  7, 12,  9,  4, 12,  5,  9, 12,  6,  5, 12 ) .+ 1),
   Int8.((  0,  1, 12,  8,  0, 12,  7,  8, 12,  6,  7, 12, 10,  6, 12,  5, 10, 12,  4,  5, 12,  9,  4, 12,  1,  9, 12 ) .+ 1),
   Int8.(( 12,  0,  1, 12,  1, 10, 12, 10,  6, 12,  6,  7, 12,  7,  8, 12,  8,  4, 12,  4,  5, 12,  5,  9, 12,  9,  0 ) .+ 1),
),
  (
   Int8.(( 11,  7, 12,  2, 11, 12,  1,  2, 12,  9,  1, 12,  4,  9, 12,  5,  4, 12, 10,  5, 12,  6, 10, 12,  7,  6, 12 ) .+ 1),
   Int8.((  1,  2, 12,  9,  1, 12,  4,  9, 12,  7,  4, 12, 11,  7, 12,  6, 11, 12,  5,  6, 12, 10,  5, 12,  2, 10, 12 ) .+ 1),
   Int8.(( 12,  1,  2, 12,  2, 11, 12, 11,  7, 12,  7,  4, 12,  4,  9, 12,  9,  5, 12,  5,  6, 12,  6, 10, 12, 10,  1 ) .+ 1),
),
  (
   Int8.((  8,  4, 12,  3,  8, 12,  2,  3, 12, 10,  2, 12,  5, 10, 12,  6,  5, 12, 11,  6, 12,  7, 11, 12,  4,  7, 12 ) .+ 1),
   Int8.((  2,  3, 12, 10,  2, 12,  5, 10, 12,  4,  5, 12,  8,  4, 12,  7,  8, 12,  6,  7, 12, 11,  6, 12,  3, 11, 12 ) .+ 1),
   Int8.(( 12,  2,  3, 12,  3,  8, 12,  8,  4, 12,  4,  5, 12,  5, 10, 12, 10,  6, 12,  6,  7, 12,  7, 11, 12, 11,  2 ) .+ 1),
),
  (
   Int8.(( 12,  4,  8, 12,  8,  3, 12,  3,  2, 12,  2, 10, 12, 10,  5, 12,  5,  6, 12,  6, 11, 12, 11,  7, 12,  7,  4 ) .+ 1),
   Int8.(( 12,  3,  2, 12,  2, 10, 12, 10,  5, 12,  5,  4, 12,  4,  8, 12,  8,  7, 12,  7,  6, 12,  6, 11, 12, 11,  3 ) .+ 1),
   Int8.((  3,  2, 12,  8,  3, 12,  4,  8, 12,  5,  4, 12, 10,  5, 12,  6, 10, 12,  7,  6, 12, 11,  7, 12,  2, 11, 12 ) .+ 1),
),
  (
   Int8.(( 12,  7, 11, 12, 11,  2, 12,  2,  1, 12,  1,  9, 12,  9,  4, 12,  4,  5, 12,  5, 10, 12, 10,  6, 12,  6,  7 ) .+ 1),
   Int8.(( 12,  2,  1, 12,  1,  9, 12,  9,  4, 12,  4,  7, 12,  7, 11, 12, 11,  6, 12,  6,  5, 12,  5, 10, 12, 10,  2 ) .+ 1),
   Int8.((  2,  1, 12, 11,  2, 12,  7, 11, 12,  4,  7, 12,  9,  4, 12,  5,  9, 12,  6,  5, 12, 10,  6, 12,  1, 10, 12 ) .+ 1),
),
  (
   Int8.(( 12,  6, 10, 12, 10,  1, 12,  1,  0, 12,  0,  8, 12,  8,  7, 12,  7,  4, 12,  4,  9, 12,  9,  5, 12,  5,  6 ) .+ 1),
   Int8.(( 12,  1,  0, 12,  0,  8, 12,  8,  7, 12,  7,  6, 12,  6, 10, 12, 10,  5, 12,  5,  4, 12,  4,  9, 12,  9,  1 ) .+ 1),
   Int8.((  1,  0, 12, 10,  1, 12,  6, 10, 12,  7,  6, 12,  8,  7, 12,  4,  8, 12,  5,  4, 12,  9,  5, 12,  0,  9, 12 ) .+ 1),
),
  (
   Int8.(( 11,  3, 12,  6, 11, 12,  5,  6, 12,  9,  5, 12,  0,  9, 12,  1,  0, 12, 10,  1, 12,  2, 10, 12,  3,  2, 12 ) .+ 1),
   Int8.((  5,  6, 12,  9,  5, 12,  0,  9, 12,  3,  0, 12, 11,  3, 12,  2, 11, 12,  1,  2, 12, 10,  1, 12,  6, 10, 12 ) .+ 1),
   Int8.(( 12,  5,  6, 12,  6, 11, 12, 11,  3, 12,  3,  0, 12,  0,  9, 12,  9,  1, 12,  1,  2, 12,  2, 10, 12, 10,  5 ) .+ 1),
),
  (
   Int8.((  9,  1, 12,  4,  9, 12,  7,  4, 12, 11,  7, 12,  2, 11, 12,  3,  2, 12,  8,  3, 12,  0,  8, 12,  1,  0, 12 ) .+ 1),
   Int8.((  7,  4, 12, 11,  7, 12,  2, 11, 12,  1,  2, 12,  9,  1, 12,  0,  9, 12,  3,  0, 12,  8,  3, 12,  4,  8, 12 ) .+ 1),
   Int8.(( 12,  7,  4, 12,  4,  9, 12,  9,  1, 12,  1,  2, 12,  2, 11, 12, 11,  3, 12,  3,  0, 12,  0,  8, 12,  8,  7 ) .+ 1),
),
  (
   Int8.(( 12,  5,  9, 12,  9,  0, 12,  0,  3, 12,  3, 11, 12, 11,  6, 12,  6,  7, 12,  7,  8, 12,  8,  4, 12,  4,  5 ) .+ 1),
   Int8.(( 12,  0,  3, 12,  3, 11, 12, 11,  6, 12,  6,  5, 12,  5,  9, 12,  9,  4, 12,  4,  7, 12,  7,  8, 12,  8,  0 ) .+ 1),
   Int8.((  0,  3, 12,  9,  0, 12,  5,  9, 12,  6,  5, 12, 11,  6, 12,  7, 11, 12,  4,  7, 12,  8,  4, 12,  3,  8, 12 ) .+ 1),
),
  (
   Int8.((  8,  0, 12,  7,  8, 12,  6,  7, 12, 10,  6, 12,  1, 10, 12,  2,  1, 12, 11,  2, 12,  3, 11, 12,  0,  3, 12 ) .+ 1),
   Int8.((  6,  7, 12, 10,  6, 12,  1, 10, 12,  0,  1, 12,  8,  0, 12,  3,  8, 12,  2,  3, 12, 11,  2, 12,  7, 11, 12 ) .+ 1),
   Int8.(( 12,  6,  7, 12,  7,  8, 12,  8,  0, 12,  0,  1, 12,  1, 10, 12, 10,  2, 12,  2,  3, 12,  3, 11, 12, 11,  6 ) .+ 1),
),
  (
   Int8.(( 10,  2, 12,  5, 10, 12,  4,  5, 12,  8,  4, 12,  3,  8, 12,  0,  3, 12,  9,  0, 12,  1,  9, 12,  2,  1, 12 ) .+ 1),
   Int8.((  4,  5, 12,  8,  4, 12,  3,  8, 12,  2,  3, 12, 10,  2, 12,  1, 10, 12,  0,  1, 12,  9,  0, 12,  5,  9, 12 ) .+ 1),
   Int8.(( 12,  4,  5, 12,  5, 10, 12, 10,  2, 12,  2,  3, 12,  3,  8, 12,  8,  0, 12,  0,  1, 12,  1,  9, 12,  9,  4 ) .+ 1),
))

#=
 tiling table for case 7.4.1
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling7_4_1 = (
  Int8.((  3,  4,  8,  4,  3, 10,  2, 10,  3,  4, 10,  5,  9,  1,  0 ) .+ 1),
  Int8.((  1,  6, 10,  6,  1,  8,  0,  8,  1,  6,  8,  7, 11,  3,  2 ) .+ 1),
  Int8.(( 11,  3,  6,  9,  6,  3,  6,  9,  5,  0,  9,  3,  7,  4,  8 ) .+ 1),
  Int8.((  2,  7, 11,  7,  2,  9,  1,  9,  2,  7,  9,  4,  8,  0,  3 ) .+ 1),
  Int8.((  0,  5,  9,  5,  0, 11,  3, 11,  0,  5, 11,  6, 10,  2,  1 ) .+ 1),
  Int8.((  8,  0,  7, 10,  7,  0,  7, 10,  6,  1, 10,  0,  4,  5,  9 ) .+ 1),
  Int8.((  9,  1,  4, 11,  4,  1,  4, 11,  7,  2, 11,  1,  5,  6, 10 ) .+ 1),
  Int8.(( 10,  2,  5,  8,  5,  2,  5,  8,  4,  3,  8,  2,  6,  7, 11 ) .+ 1),
  Int8.((  5,  2, 10,  2,  5,  8,  4,  8,  5,  2,  8,  3, 11,  7,  6 ) .+ 1),
  Int8.((  4,  1,  9,  1,  4, 11,  7, 11,  4,  1, 11,  2, 10,  6,  5 ) .+ 1),
  Int8.((  7,  0,  8,  0,  7, 10,  6, 10,  7,  0, 10,  1,  9,  5,  4 ) .+ 1),
  Int8.((  9,  5,  0, 11,  0,  5,  0, 11,  3,  6, 11,  5,  1,  2, 10 ) .+ 1),
  Int8.(( 11,  7,  2,  9,  2,  7,  2,  9,  1,  4,  9,  7,  3,  0,  8 ) .+ 1),
  Int8.((  6,  3, 11,  3,  6,  9,  5,  9,  6,  3,  9,  0,  8,  4,  7 ) .+ 1),
  Int8.(( 10,  6,  1,  8,  1,  6,  1,  8,  0,  7,  8,  6,  2,  3, 11 ) .+ 1),
  Int8.((  8,  4,  3, 10,  3,  4,  3, 10,  2,  5, 10,  4,  0,  1,  9 ) .+ 1),
)

#=
 tiling table for case 7.4.2
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling7_4_2 = (
  Int8.((   9,  4,  8,  4,  9,  5, 10,  5,  9,  1, 10,  9, 10,  1,  2,  0,  2,  1,  2,  0,  3,  8,  3,  0,  9,  8,  0 ) .+ 1),
  Int8.((  11,  6, 10,  6, 11,  7,  8,  7, 11,  3,  8, 11,  8,  3,  0,  2,  0,  3,  0,  2,  1, 10,  1,  2, 11, 10,  2 ) .+ 1),
  Int8.((  11,  3,  8,  0,  8,  3,  8,  0,  9,  8,  9,  4,  5,  4,  9,  4,  5,  7,  6,  7,  5,  7,  6, 11,  7, 11,  8 ) .+ 1),
  Int8.((   8,  7, 11,  7,  8,  4,  9,  4,  8,  0,  9,  8,  9,  0,  1,  3,  1,  0,  1,  3,  2, 11,  2,  3,  8, 11,  3 ) .+ 1),
  Int8.((  10,  5,  9,  5, 10,  6, 11,  6, 10,  2, 11, 10, 11,  2,  3,  1,  3,  2,  3,  1,  0,  9,  0,  1, 10,  9,  1 ) .+ 1),
  Int8.((   8,  0,  9,  1,  9,  0,  9,  1, 10,  9, 10,  5,  6,  5, 10,  5,  6,  4,  7,  4,  6,  4,  7,  8,  4,  8,  9 ) .+ 1),
  Int8.((   9,  1, 10,  2, 10,  1, 10,  2, 11, 10, 11,  6,  7,  6, 11,  6,  7,  5,  4,  5,  7,  5,  4,  9,  5,  9, 10 ) .+ 1),
  Int8.((  10,  2, 11,  3, 11,  2, 11,  3,  8, 11,  8,  7,  4,  7,  8,  7,  4,  6,  5,  6,  4,  6,  5, 10,  6, 10, 11 ) .+ 1),
  Int8.((  11,  2, 10,  2, 11,  3,  8,  3, 11,  7,  8, 11,  8,  7,  4,  6,  4,  7,  4,  6,  5, 10,  5,  6, 11, 10,  6 ) .+ 1),
  Int8.((  10,  1,  9,  1, 10,  2, 11,  2, 10,  6, 11, 10, 11,  6,  7,  5,  7,  6,  7,  5,  4,  9,  4,  5, 10,  9,  5 ) .+ 1),
  Int8.((   9,  0,  8,  0,  9,  1, 10,  1,  9,  5, 10,  9, 10,  5,  6,  4,  6,  5,  6,  4,  7,  8,  7,  4,  9,  8,  4 ) .+ 1),
  Int8.((   9,  5, 10,  6, 10,  5, 10,  6, 11, 10, 11,  2,  3,  2, 11,  2,  3,  1,  0,  1,  3,  1,  0,  9,  1,  9, 10 ) .+ 1),
  Int8.((  11,  7,  8,  4,  8,  7,  8,  4,  9,  8,  9,  0,  1,  0,  9,  0,  1,  3,  2,  3,  1,  3,  2, 11,  3, 11,  8 ) .+ 1),
  Int8.((   8,  3, 11,  3,  8,  0,  9,  0,  8,  4,  9,  8,  9,  4,  5,  7,  5,  4,  5,  7,  6, 11,  6,  7,  8, 11,  7 ) .+ 1),
  Int8.((  10,  6, 11,  7, 11,  6, 11,  7,  8, 11,  8,  3,  0,  3,  8,  3,  0,  2,  1,  2,  0,  2,  1, 10,  2, 10, 11 ) .+ 1),
  Int8.((   8,  4,  9,  5,  9,  4,  9,  5, 10,  9, 10,  1,  2,  1, 10,  1,  2,  0,  3,  0,  2,  0,  3,  8,  0,  8,  9 ) .+ 1),
)

#=
 tiling table for case 8
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling8 = (
  Int8.(( 9,  8, 10, 10,  8, 11 ) .+ 1),
  Int8.(( 1,  5,  3,  3,  5,  7 ) .+ 1),
  Int8.(( 0,  4,  2,  4,  6,  2 ) .+ 1),
  Int8.(( 0,  2,  4,  4,  2,  6 ) .+ 1),
  Int8.(( 1,  3,  5,  3,  7,  5 ) .+ 1),
  Int8.(( 9, 10,  8, 10, 11,  8 ) .+ 1),
)

#=
 tiling table for case 9
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling9 = (
  Int8.((  2, 10,  5,  3,  2,  5,  3,  5,  4,  3,  4,  8 ) .+ 1),
  Int8.((  4,  7, 11,  9,  4, 11,  9, 11,  2,  9,  2,  1 ) .+ 1),
  Int8.(( 10,  7,  6,  1,  7, 10,  1,  8,  7,  1,  0,  8 ) .+ 1),
  Int8.((  3,  6, 11,  0,  6,  3,  0,  5,  6,  0,  9,  5 ) .+ 1),
  Int8.((  3, 11,  6,  0,  3,  6,  0,  6,  5,  0,  5,  9 ) .+ 1),
  Int8.(( 10,  6,  7,  1, 10,  7,  1,  7,  8,  1,  8,  0 ) .+ 1),
  Int8.((  4, 11,  7,  9, 11,  4,  9,  2, 11,  9,  1,  2 ) .+ 1),
  Int8.((  2,  5, 10,  3,  5,  2,  3,  4,  5,  3,  8,  4 ) .+ 1),
)

#=
 test table for case 10
 2 faces to test + eventually the interior
 When the tests on both specified faces are positive : 4 middle triangles (1)
 When the test on the first  specified face is positive : 8 first triangles
 When the test on the second specified face is positive : 8 next triangles
 When the tests on both specified faces are negative :
 - if the test on the interior is negative : 4 middle triangles
 - if the test on the interior is positive : 8 last triangles
 *
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const test10 = (
  Int8.(( 2,  4,  7 )),
  Int8.(( 5,  6,  7 )),
  Int8.(( 1,  3,  7 )),
  Int8.(( 1,  3,  7 )),
  Int8.(( 5,  6,  7 )),
  Int8.(( 2,  4,  7 )),
)

#=
 tiling table for case 10.1.1
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling10_1_1 = (
  Int8.((  5, 10,  7, 11,  7, 10,  8,  1,  9,  1,  8,  3 ) .+ 1),
  Int8.((  1,  2,  5,  6,  5,  2,  4,  3,  0,  3,  4,  7 ) .+ 1),
  Int8.(( 11,  0,  8,  0, 11,  2,  4,  9,  6, 10,  6,  9 ) .+ 1),
  Int8.((  9,  0, 10,  2, 10,  0,  6,  8,  4,  8,  6, 11 ) .+ 1),
  Int8.((  7,  2,  3,  2,  7,  6,  0,  1,  4,  5,  4,  1 ) .+ 1),
  Int8.((  7,  9,  5,  9,  7,  8, 10,  1, 11,  3, 11,  1 ) .+ 1),
)

#=
 tiling table for case 10.1.1 inverted
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling10_1_1_ = (
  Int8.((  5,  9,  7,  8,  7,  9, 11,  1, 10,  1, 11,  3 ) .+ 1),
  Int8.((  3,  2,  7,  6,  7,  2,  4,  1,  0,  1,  4,  5 ) .+ 1),
  Int8.(( 10,  0,  9,  0, 10,  2,  4,  8,  6, 11,  6,  8 ) .+ 1),
  Int8.((  8,  0, 11,  2, 11,  0,  6,  9,  4,  9,  6, 10 ) .+ 1),
  Int8.((  5,  2,  1,  2,  5,  6,  0,  3,  4,  7,  4,  3 ) .+ 1),
  Int8.((  7, 10,  5, 10,  7, 11,  9,  1,  8,  3,  8,  1 ) .+ 1),
)

#=
 tiling table for case 10.1.2
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling10_1_2 = (
  Int8.((  3, 11,  7,  3,  7,  8,  9,  8,  7,  5,  9,  7,  9,  5, 10,  9, 10,  1,  3,  1, 10, 11,  3, 10 ) .+ 1),
  Int8.((  7,  6,  5,  7,  5,  4,  0,  4,  5,  1,  0,  5,  0,  1,  2,  0,  2,  3,  7,  3,  2,  6,  7,  2 ) .+ 1),
  Int8.(( 11,  2, 10,  6, 11, 10, 11,  6,  4, 11,  4,  8,  0,  8,  4,  9,  0,  4,  0,  9, 10,  0, 10,  2 ) .+ 1),
  Int8.(( 11,  2, 10, 11, 10,  6,  4,  6, 10,  9,  4, 10,  4,  9,  0,  4,  0,  8, 11,  8,  0,  2, 11,  0 ) .+ 1),
  Int8.((  7,  6,  5,  4,  7,  5,  7,  4,  0,  7,  0,  3,  2,  3,  0,  1,  2,  0,  2,  1,  5,  2,  5,  6 ) .+ 1),
  Int8.((  7,  8,  3, 11,  7,  3,  7, 11, 10,  7, 10,  5,  9,  5, 10,  1,  9, 10,  9,  1,  3,  9,  3,  8 ) .+ 1),
)

#=
 tiling table for case 10.2
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling10_2 = (
  Int8.(( 12,  5,  9, 12,  9,  8, 12,  8,  3, 12,  3,  1, 12,  1, 10, 12, 10, 11, 12, 11,  7, 12,  7,  5 ) .+ 1),
  Int8.(( 12,  1,  0, 12,  0,  4, 12,  4,  7, 12,  7,  3, 12,  3,  2, 12,  2,  6, 12,  6,  5, 12,  5,  1 ) .+ 1),
  Int8.((  4,  8, 12,  6,  4, 12, 10,  6, 12,  9, 10, 12,  0,  9, 12,  2,  0, 12, 11,  2, 12,  8, 11, 12 ) .+ 1),
  Int8.(( 12,  9,  4, 12,  4,  6, 12,  6, 11, 12, 11,  8, 12,  8,  0, 12,  0,  2, 12,  2, 10, 12, 10,  9 ) .+ 1),
  Int8.((  0,  3, 12,  4,  0, 12,  5,  4, 12,  1,  5, 12,  2,  1, 12,  6,  2, 12,  7,  6, 12,  3,  7, 12 ) .+ 1),
  Int8.(( 10,  5, 12, 11, 10, 12,  3, 11, 12,  1,  3, 12,  9,  1, 12,  8,  9, 12,  7,  8, 12,  5,  7, 12 ) .+ 1),
)

#=
 tiling table for case 10.2 inverted
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling10_2_ = (
  Int8.((  8,  7, 12,  9,  8, 12,  1,  9, 12,  3,  1, 12, 11,  3, 12, 10, 11, 12,  5, 10, 12,  7,  5, 12 ) .+ 1),
  Int8.((  4,  5, 12,  0,  4, 12,  3,  0, 12,  7,  3, 12,  6,  7, 12,  2,  6, 12,  1,  2, 12,  5,  1, 12 ) .+ 1),
  Int8.(( 12, 11,  6, 12,  6,  4, 12,  4,  9, 12,  9, 10, 12, 10,  2, 12,  2,  0, 12,  0,  8, 12,  8, 11 ) .+ 1),
  Int8.((  6, 10, 12,  4,  6, 12,  8,  4, 12, 11,  8, 12,  2, 11, 12,  0,  2, 12,  9,  0, 12, 10,  9, 12 ) .+ 1),
  Int8.(( 12,  7,  4, 12,  4,  0, 12,  0,  1, 12,  1,  5, 12,  5,  6, 12,  6,  2, 12,  2,  3, 12,  3,  7 ) .+ 1),
  Int8.(( 12,  7, 11, 12, 11, 10, 12, 10,  1, 12,  1,  3, 12,  3,  8, 12,  8,  9, 12,  9,  5, 12,  5,  7 ) .+ 1),
)

#=
 tiling table for case 11
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling11 = (
  Int8.(( 2, 10,  9,  2,  9,  7,  2,  7,  3,  7,  9,  4 ) .+ 1),
  Int8.(( 1,  6,  2,  1,  8,  6,  1,  9,  8,  8,  7,  6 ) .+ 1),
  Int8.(( 8,  3,  1,  8,  1,  6,  8,  6,  4,  6,  1, 10 ) .+ 1),
  Int8.(( 0,  8, 11,  0, 11,  5,  0,  5,  1,  5, 11,  6 ) .+ 1),
  Int8.(( 9,  5,  7,  9,  7,  2,  9,  2,  0,  2,  7, 11 ) .+ 1),
  Int8.(( 5,  0,  4,  5, 11,  0,  5, 10, 11, 11,  3,  0 ) .+ 1),
  Int8.(( 5,  4,  0,  5,  0, 11,  5, 11, 10, 11,  0,  3 ) .+ 1),
  Int8.(( 9,  7,  5,  9,  2,  7,  9,  0,  2,  2, 11,  7 ) .+ 1),
  Int8.(( 0, 11,  8,  0,  5, 11,  0,  1,  5,  5,  6, 11 ) .+ 1),
  Int8.(( 8,  1,  3,  8,  6,  1,  8,  4,  6,  6, 10,  1 ) .+ 1),
  Int8.(( 1,  2,  6,  1,  6,  8,  1,  8,  9,  8,  6,  7 ) .+ 1),
  Int8.(( 2,  9, 10,  2,  7,  9,  2,  3,  7,  7,  4,  9 ) .+ 1),
)

#=
 test table for case 12
 2 faces to test + eventually the interior
 When the tests on both specified faces are positive : 4 middle triangles (1)
 When the test on the first  specified face is positive : 8 first triangles
 When the test on the second specified face is positive : 8 next triangles
 When the tests on both specified faces are negative :
 - if the test on the interior is negative : 4 middle triangles
 - if the test on the interior is positive : 8 last triangles
 The support edge for the interior test is marked as the 4th column.
 *
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const test12 = (
  Int8.(( 4,  3,  7, 11 + 1 )),
  Int8.(( 3,  2,  7, 10 + 1 )),
  Int8.(( 2,  6,  7,  5 + 1 )),
  Int8.(( 6,  4,  7,  7 + 1 )),
  Int8.(( 2,  1,  7,  9 + 1 )),
  Int8.(( 5,  2,  7,  1 + 1 )),
  Int8.(( 5,  3,  7,  2 + 1 )),
  Int8.(( 5,  1,  7,  0 + 1 )),
  Int8.(( 5,  4,  7,  3 + 1 )),
  Int8.(( 6,  3,  7,  6 + 1 )),
  Int8.(( 1,  6,  7,  4 + 1 )),
  Int8.(( 1,  4,  7,  8 + 1 )),
  Int8.(( 4,  1,  7,  8 + 1 )),
  Int8.(( 6,  1,  7,  4 + 1 )),
  Int8.(( 3,  6,  7,  6 + 1 )),
  Int8.(( 4,  5,  7,  3 + 1 )),
  Int8.(( 1,  5,  7,  0 + 1 )),
  Int8.(( 3,  5,  7,  2 + 1 )),
  Int8.(( 2,  5,  7,  1 + 1 )),
  Int8.(( 1,  2,  7,  9 + 1 )),
  Int8.(( 4,  6,  7,  7 + 1 )),
  Int8.(( 6,  2,  7,  5 + 1 )),
  Int8.(( 2,  3,  7, 10 + 1 )),
  Int8.(( 3,  4,  7, 11 + 1 )),
)

#=
 tiling table for case 12.1.1
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling12_1_1 = (
  Int8.((  7,  6, 11, 10,  3,  2,  3, 10,  8,  9,  8, 10 ) .+ 1),
  Int8.((  6,  5, 10,  9,  2,  1,  2,  9, 11,  8, 11,  9 ) .+ 1),
  Int8.(( 10,  6,  5,  7,  9,  4,  9,  7,  1,  3,  1,  7 ) .+ 1),
  Int8.((  7,  6, 11,  4,  8,  5,  3,  5,  8,  5,  3,  1 ) .+ 1),
  Int8.((  5,  4,  9,  8,  1,  0,  1,  8, 10, 11, 10,  8 ) .+ 1),
  Int8.((  1,  2, 10,  0,  9,  3,  5,  3,  9,  3,  5,  7 ) .+ 1),
  Int8.(( 10,  1,  2,  0, 11,  3, 11,  0,  6,  4,  6,  0 ) .+ 1),
  Int8.((  8,  3,  0,  2,  9,  1,  9,  2,  4,  6,  4,  2 ) .+ 1),
  Int8.((  3,  0,  8,  2, 11,  1,  7,  1, 11,  1,  7,  5 ) .+ 1),
  Int8.((  6,  5, 10,  7, 11,  4,  2,  4, 11,  4,  2,  0 ) .+ 1),
  Int8.((  9,  5,  4,  6,  8,  7,  8,  6,  0,  2,  0,  6 ) .+ 1),
  Int8.((  8,  3,  0,  7,  4, 11,  9, 11,  4, 11,  9, 10 ) .+ 1),
  Int8.((  4,  7,  8, 11,  0,  3,  0, 11,  9, 10,  9, 11 ) .+ 1),
  Int8.((  4,  7,  8,  5,  9,  6,  0,  6,  9,  6,  0,  2 ) .+ 1),
  Int8.(( 11,  7,  6,  4, 10,  5, 10,  4,  2,  0,  2,  4 ) .+ 1),
  Int8.(( 11,  2,  3,  1,  8,  0,  8,  1,  7,  5,  7,  1 ) .+ 1),
  Int8.((  0,  1,  9,  3,  8,  2,  4,  2,  8,  2,  4,  6 ) .+ 1),
  Int8.((  2,  3, 11,  1, 10,  0,  6,  0, 10,  0,  6,  4 ) .+ 1),
  Int8.((  9,  0,  1,  3, 10,  2, 10,  3,  5,  7,  5,  3 ) .+ 1),
  Int8.((  9,  0,  1,  4,  5,  8, 10,  8,  5,  8, 10, 11 ) .+ 1),
  Int8.((  8,  4,  7,  5, 11,  6, 11,  5,  3,  1,  3,  5 ) .+ 1),
  Int8.((  5,  4,  9,  6, 10,  7,  1,  7, 10,  7,  1,  3 ) .+ 1),
  Int8.(( 10,  1,  2,  5,  6,  9, 11,  9,  6,  9, 11,  8 ) .+ 1),
  Int8.(( 11,  2,  3,  6,  7, 10,  8, 10,  7, 10,  8,  9 ) .+ 1),
)

#=
 tiling table for case 12.1.1 inverted
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling12_1_1_ = (
  Int8.((  3,  2, 11, 10,  7,  6,  7, 10,  8,  9,  8, 10 ) .+ 1),
  Int8.((  2,  1, 10,  9,  6,  5,  6,  9, 11,  8, 11,  9 ) .+ 1),
  Int8.((  9,  4,  5,  7, 10,  6, 10,  7,  1,  3,  1,  7 ) .+ 1),
  Int8.((  7,  4,  8,  6, 11,  5,  3,  5, 11,  5,  3,  1 ) .+ 1),
  Int8.((  1,  0,  9,  8,  5,  4,  5,  8, 10, 11, 10,  8 ) .+ 1),
  Int8.((  1,  0,  9,  2, 10,  3,  5,  3, 10,  3,  5,  7 ) .+ 1),
  Int8.(( 11,  3,  2,  0, 10,  1, 10,  0,  6,  4,  6,  0 ) .+ 1),
  Int8.((  9,  1,  0,  2,  8,  3,  8,  2,  4,  6,  4,  2 ) .+ 1),
  Int8.((  3,  2, 11,  0,  8,  1,  7,  1,  8,  1,  7,  5 ) .+ 1),
  Int8.((  6,  7, 11,  5, 10,  4,  2,  4, 10,  4,  2,  0 ) .+ 1),
  Int8.((  8,  7,  4,  6,  9,  5,  9,  6,  0,  2,  0,  6 ) .+ 1),
  Int8.((  8,  7,  4,  3,  0, 11,  9, 11,  0, 11,  9, 10 ) .+ 1),
  Int8.((  0,  3,  8, 11,  4,  7,  4, 11,  9, 10,  9, 11 ) .+ 1),
  Int8.((  4,  5,  9,  7,  8,  6,  0,  6,  8,  6,  0,  2 ) .+ 1),
  Int8.(( 10,  5,  6,  4, 11,  7, 11,  4,  2,  0,  2,  4 ) .+ 1),
  Int8.((  8,  0,  3,  1, 11,  2, 11,  1,  7,  5,  7,  1 ) .+ 1),
  Int8.((  0,  3,  8,  1,  9,  2,  4,  2,  9,  2,  4,  6 ) .+ 1),
  Int8.((  2,  1, 10,  3, 11,  0,  6,  0, 11,  0,  6,  4 ) .+ 1),
  Int8.(( 10,  2,  1,  3,  9,  0,  9,  3,  5,  7,  5,  3 ) .+ 1),
  Int8.((  9,  4,  5,  0,  1,  8, 10,  8,  1,  8, 10, 11 ) .+ 1),
  Int8.(( 11,  6,  7,  5,  8,  4,  8,  5,  3,  1,  3,  5 ) .+ 1),
  Int8.((  5,  6, 10,  4,  9,  7,  1,  7,  9,  7,  1,  3 ) .+ 1),
  Int8.(( 10,  5,  6,  1,  2,  9, 11,  9,  2,  9, 11,  8 ) .+ 1),
  Int8.(( 11,  6,  7,  2,  3, 10,  8, 10,  3, 10,  8,  9 ) .+ 1),
)

#=
 tiling table for case 12.1.2
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling12_1_2 = (
  Int8.((  7,  3, 11,  3,  7,  8,  9,  8,  7,  6,  9,  7,  9,  6, 10,  2, 10,  6, 11,  2,  6,  2, 11,  3 ) .+ 1),
  Int8.((  6,  2, 10,  2,  6, 11,  8, 11,  6,  5,  8,  6,  8,  5,  9,  1,  9,  5, 10,  1,  5,  1, 10,  2 ) .+ 1),
  Int8.(( 10,  9,  5,  9, 10,  1,  3,  1, 10,  6,  3, 10,  3,  6,  7,  4,  7,  6,  5,  4,  6,  4,  5,  9 ) .+ 1),
  Int8.((  7,  8, 11,  3, 11,  8, 11,  3,  1, 11,  1,  6,  5,  6,  1,  6,  5,  4,  6,  4,  7,  8,  7,  4 ) .+ 1),
  Int8.((  5,  1,  9,  1,  5, 10, 11, 10,  5,  4, 11,  5, 11,  4,  8,  0,  8,  4,  9,  0,  4,  0,  9,  1 ) .+ 1),
  Int8.((  1,  9, 10,  5, 10,  9, 10,  5,  7, 10,  7,  2,  3,  2,  7,  2,  3,  0,  2,  0,  1,  9,  1,  0 ) .+ 1),
  Int8.(( 10, 11,  2, 11, 10,  6,  4,  6, 10,  1,  4, 10,  4,  1,  0,  3,  0,  1,  2,  3,  1,  3,  2, 11 ) .+ 1),
  Int8.((  8,  9,  0,  9,  8,  4,  6,  4,  8,  3,  6,  8,  6,  3,  2,  1,  2,  3,  0,  1,  3,  1,  0,  9 ) .+ 1),
  Int8.((  3, 11,  8,  7,  8, 11,  8,  7,  5,  8,  5,  0,  1,  0,  5,  0,  1,  2,  0,  2,  3, 11,  3,  2 ) .+ 1),
  Int8.((  6, 11, 10,  2, 10, 11, 10,  2,  0, 10,  0,  5,  4,  5,  0,  5,  4,  7,  5,  7,  6, 11,  6,  7 ) .+ 1),
  Int8.((  9,  8,  4,  8,  9,  0,  2,  0,  9,  5,  2,  9,  2,  5,  6,  7,  6,  5,  4,  7,  5,  7,  4,  8 ) .+ 1),
  Int8.((  8,  4,  0,  9,  0,  4,  0,  9, 10,  0, 10,  3, 11,  3, 10,  3, 11,  7,  3,  7,  8,  4,  8,  7 ) .+ 1),
  Int8.((  4,  0,  8,  0,  4,  9, 10,  9,  4,  7, 10,  4, 10,  7, 11,  3, 11,  7,  8,  3,  7,  3,  8,  0 ) .+ 1),
  Int8.((  4,  9,  8,  0,  8,  9,  8,  0,  2,  8,  2,  7,  6,  7,  2,  7,  6,  5,  7,  5,  4,  9,  4,  5 ) .+ 1),
  Int8.(( 11, 10,  6, 10, 11,  2,  0,  2, 11,  7,  0, 11,  0,  7,  4,  5,  4,  7,  6,  5,  7,  5,  6, 10 ) .+ 1),
  Int8.(( 11,  8,  3,  8, 11,  7,  5,  7, 11,  2,  5, 11,  5,  2,  1,  0,  1,  2,  3,  0,  2,  0,  3,  8 ) .+ 1),
  Int8.((  0,  8,  9,  4,  9,  8,  9,  4,  6,  9,  6,  1,  2,  1,  6,  1,  2,  3,  1,  3,  0,  8,  0,  3 ) .+ 1),
  Int8.((  2, 10, 11,  6, 11, 10, 11,  6,  4, 11,  4,  3,  0,  3,  4,  3,  0,  1,  3,  1,  2, 10,  2,  1 ) .+ 1),
  Int8.((  9, 10,  1, 10,  9,  5,  7,  5,  9,  0,  7,  9,  7,  0,  3,  2,  3,  0,  1,  2,  0,  2,  1, 10 ) .+ 1),
  Int8.((  9,  5,  1, 10,  1,  5,  1, 10, 11,  1, 11,  0,  8,  0, 11,  0,  8,  4,  0,  4,  9,  5,  9,  4 ) .+ 1),
  Int8.((  8, 11,  7, 11,  8,  3,  1,  3,  8,  4,  1,  8,  1,  4,  5,  6,  5,  4,  7,  6,  4,  6,  7, 11 ) .+ 1),
  Int8.((  5, 10,  9,  1,  9, 10,  9,  1,  3,  9,  3,  4,  7,  4,  3,  4,  7,  6,  4,  6,  5, 10,  5,  6 ) .+ 1),
  Int8.(( 10,  6,  2, 11,  2,  6,  2, 11,  8,  2,  8,  1,  9,  1,  8,  1,  9,  5,  1,  5, 10,  6, 10,  5 ) .+ 1),
  Int8.(( 11,  7,  3,  8,  3,  7,  3,  8,  9,  3,  9,  2, 10,  2,  9,  2, 10,  6,  2,  6, 11,  7, 11,  6 ) .+ 1),
)

#=
 tiling table for case 12.2
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling12_2 = (
  Int8.((   9,  8, 12, 10,  9, 12,  2, 10, 12,  3,  2, 12, 11,  3, 12,  6, 11, 12,  7,  6, 12,  8,  7, 12 ) .+ 1),
  Int8.((   8, 11, 12,  9,  8, 12,  1,  9, 12,  2,  1, 12, 10,  2, 12,  5, 10, 12,  6,  5, 12, 11,  6, 12 ) .+ 1),
  Int8.((   3,  1, 12,  7,  3, 12,  4,  7, 12,  9,  4, 12,  5,  9, 12,  6,  5, 12, 10,  6, 12,  1, 10, 12 ) .+ 1),
  Int8.((  12,  3,  1, 12,  1,  5, 12,  5,  6, 12,  6, 11, 12, 11,  7, 12,  7,  4, 12,  4,  8, 12,  8,  3 ) .+ 1),
  Int8.((  11, 10, 12,  8, 11, 12,  0,  8, 12,  1,  0, 12,  9,  1, 12,  4,  9, 12,  5,  4, 12, 10,  5, 12 ) .+ 1),
  Int8.((  12,  5,  7, 12,  7,  3, 12,  3,  2, 12,  2, 10, 12, 10,  1, 12,  1,  0, 12,  0,  9, 12,  9,  5 ) .+ 1),
  Int8.((   4,  6, 12,  0,  4, 12,  1,  0, 12, 10,  1, 12,  2, 10, 12,  3,  2, 12, 11,  3, 12,  6, 11, 12 ) .+ 1),
  Int8.((   6,  4, 12,  2,  6, 12,  3,  2, 12,  8,  3, 12,  0,  8, 12,  1,  0, 12,  9,  1, 12,  4,  9, 12 ) .+ 1),
  Int8.((  12,  7,  5, 12,  5,  1, 12,  1,  0, 12,  0,  8, 12,  8,  3, 12,  3,  2, 12,  2, 11, 12, 11,  7 ) .+ 1),
  Int8.((  12,  2,  0, 12,  0,  4, 12,  4,  5, 12,  5, 10, 12, 10,  6, 12,  6,  7, 12,  7, 11, 12, 11,  2 ) .+ 1),
  Int8.((   2,  0, 12,  6,  2, 12,  7,  6, 12,  8,  7, 12,  4,  8, 12,  5,  4, 12,  9,  5, 12,  0,  9, 12 ) .+ 1),
  Int8.((  12,  9, 10, 12, 10, 11, 12, 11,  7, 12,  7,  4, 12,  4,  8, 12,  8,  3, 12,  3,  0, 12,  0,  9 ) .+ 1),
  Int8.((  10,  9, 12, 11, 10, 12,  7, 11, 12,  4,  7, 12,  8,  4, 12,  3,  8, 12,  0,  3, 12,  9,  0, 12 ) .+ 1),
  Int8.((  12,  0,  2, 12,  2,  6, 12,  6,  7, 12,  7,  8, 12,  8,  4, 12,  4,  5, 12,  5,  9, 12,  9,  0 ) .+ 1),
  Int8.((   0,  2, 12,  4,  0, 12,  5,  4, 12, 10,  5, 12,  6, 10, 12,  7,  6, 12, 11,  7, 12,  2, 11, 12 ) .+ 1),
  Int8.((   5,  7, 12,  1,  5, 12,  0,  1, 12,  8,  0, 12,  3,  8, 12,  2,  3, 12, 11,  2, 12,  7, 11, 12 ) .+ 1),
  Int8.((  12,  4,  6, 12,  6,  2, 12,  2,  3, 12,  3,  8, 12,  8,  0, 12,  0,  1, 12,  1,  9, 12,  9,  4 ) .+ 1),
  Int8.((  12,  6,  4, 12,  4,  0, 12,  0,  1, 12,  1, 10, 12, 10,  2, 12,  2,  3, 12,  3, 11, 12, 11,  6 ) .+ 1),
  Int8.((   7,  5, 12,  3,  7, 12,  2,  3, 12, 10,  2, 12,  1, 10, 12,  0,  1, 12,  9,  0, 12,  5,  9, 12 ) .+ 1),
  Int8.((  12, 10, 11, 12, 11,  8, 12,  8,  0, 12,  0,  1, 12,  1,  9, 12,  9,  4, 12,  4,  5, 12,  5, 10 ) .+ 1),
  Int8.((   1,  3, 12,  5,  1, 12,  6,  5, 12, 11,  6, 12,  7, 11, 12,  4,  7, 12,  8,  4, 12,  3,  8, 12 ) .+ 1),
  Int8.((  12,  1,  3, 12,  3,  7, 12,  7,  4, 12,  4,  9, 12,  9,  5, 12,  5,  6, 12,  6, 10, 12, 10,  1 ) .+ 1),
  Int8.((  12, 11,  8, 12,  8,  9, 12,  9,  1, 12,  1,  2, 12,  2, 10, 12, 10,  5, 12,  5,  6, 12,  6, 11 ) .+ 1),
  Int8.((  12,  8,  9, 12,  9, 10, 12, 10,  2, 12,  2,  3, 12,  3, 11, 12, 11,  6, 12,  6,  7, 12,  7,  8 ) .+ 1),
)

#=
 tiling table for case 12.2 inverted
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling12_2_ = (
  Int8.(( 12,  2, 11, 12, 11,  7, 12,  7,  6, 12,  6, 10, 12, 10,  9, 12,  9,  8, 12,  8,  3, 12,  3,  2 ) .+ 1),
  Int8.(( 12,  1, 10, 12, 10,  6, 12,  6,  5, 12,  5,  9, 12,  9,  8, 12,  8, 11, 12, 11,  2, 12,  2,  1 ) .+ 1),
  Int8.(( 12,  4,  5, 12,  5, 10, 12, 10,  6, 12,  6,  7, 12,  7,  3, 12,  3,  1, 12,  1,  9, 12,  9,  4 ) .+ 1),
  Int8.((  7,  6, 12,  8,  7, 12,  4,  8, 12,  5,  4, 12,  1,  5, 12,  3,  1, 12, 11,  3, 12,  6, 11, 12 ) .+ 1),
  Int8.(( 12,  0,  9, 12,  9,  5, 12,  5,  4, 12,  4,  8, 12,  8, 11, 12, 11, 10, 12, 10,  1, 12,  1,  0 ) .+ 1),
  Int8.((  1,  2, 12,  9,  1, 12,  0,  9, 12,  3,  0, 12,  7,  3, 12,  5,  7, 12, 10,  5, 12,  2, 10, 12 ) .+ 1),
  Int8.(( 12,  1,  2, 12,  2, 11, 12, 11,  3, 12,  3,  0, 12,  0,  4, 12,  4,  6, 12,  6, 10, 12, 10,  1 ) .+ 1),
  Int8.(( 12,  3,  0, 12,  0,  9, 12,  9,  1, 12,  1,  2, 12,  2,  6, 12,  6,  4, 12,  4,  8, 12,  8,  3 ) .+ 1),
  Int8.((  3,  0, 12, 11,  3, 12,  2, 11, 12,  1,  2, 12,  5,  1, 12,  7,  5, 12,  8,  7, 12,  0,  8, 12 ) .+ 1),
  Int8.((  6,  5, 12, 11,  6, 12,  7, 11, 12,  4,  7, 12,  0,  4, 12,  2,  0, 12, 10,  2, 12,  5, 10, 12 ) .+ 1),
  Int8.(( 12,  7,  4, 12,  4,  9, 12,  9,  5, 12,  5,  6, 12,  6,  2, 12,  2,  0, 12,  0,  8, 12,  8,  7 ) .+ 1),
  Int8.((  8,  7, 12,  0,  8, 12,  3,  0, 12, 11,  3, 12, 10, 11, 12,  9, 10, 12,  4,  9, 12,  7,  4, 12 ) .+ 1),
  Int8.(( 12,  7,  8, 12,  8,  0, 12,  0,  3, 12,  3, 11, 12, 11, 10, 12, 10,  9, 12,  9,  4, 12,  4,  7 ) .+ 1),
  Int8.((  4,  7, 12,  9,  4, 12,  5,  9, 12,  6,  5, 12,  2,  6, 12,  0,  2, 12,  8,  0, 12,  7,  8, 12 ) .+ 1),
  Int8.(( 12,  5,  6, 12,  6, 11, 12, 11,  7, 12,  7,  4, 12,  4,  0, 12,  0,  2, 12,  2, 10, 12, 10,  5 ) .+ 1),
  Int8.(( 12,  0,  3, 12,  3, 11, 12, 11,  2, 12,  2,  1, 12,  1,  5, 12,  5,  7, 12,  7,  8, 12,  8,  0 ) .+ 1),
  Int8.((  0,  3, 12,  9,  0, 12,  1,  9, 12,  2,  1, 12,  6,  2, 12,  4,  6, 12,  8,  4, 12,  3,  8, 12 ) .+ 1),
  Int8.((  2,  1, 12, 11,  2, 12,  3, 11, 12,  0,  3, 12,  4,  0, 12,  6,  4, 12, 10,  6, 12,  1, 10, 12 ) .+ 1),
  Int8.(( 12,  2,  1, 12,  1,  9, 12,  9,  0, 12,  0,  3, 12,  3,  7, 12,  7,  5, 12,  5, 10, 12, 10,  2 ) .+ 1),
  Int8.((  9,  0, 12,  5,  9, 12,  4,  5, 12,  8,  4, 12, 11,  8, 12, 10, 11, 12,  1, 10, 12,  0,  1, 12 ) .+ 1),
  Int8.(( 12,  6,  7, 12,  7,  8, 12,  8,  4, 12,  4,  5, 12,  5,  1, 12,  1,  3, 12,  3, 11, 12, 11,  6 ) .+ 1),
  Int8.((  5,  4, 12, 10,  5, 12,  6, 10, 12,  7,  6, 12,  3,  7, 12,  1,  3, 12,  9,  1, 12,  4,  9, 12 ) .+ 1),
  Int8.(( 10,  1, 12,  6, 10, 12,  5,  6, 12,  9,  5, 12,  8,  9, 12, 11,  8, 12,  2, 11, 12,  1,  2, 12 ) .+ 1),
  Int8.(( 11,  2, 12,  7, 11, 12,  6,  7, 12, 10,  6, 12,  9, 10, 12,  8,  9, 12,  3,  8, 12,  2,  3, 12 ) .+ 1),
)

#=
 test table for case 13
 All faces are to be tested
 *
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const test13 = (
  Int8.(( 1, 2, 3, 4, 5, 6, 7 )),
  Int8.(( 2, 3, 4, 1, 5, 6, 7 )),
)

#=
 subconfiguration table for case 13
 Hard-coded tests for the subconfiguration determination
 *
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const subcfg13 = (
  Int8(  0 + 1),
  Int8(  1 + 1),
  Int8(  2 + 1),
  Int8(  7 + 1),
  Int8(  3 + 1),
  Int8( -1 + 1),
  Int8( 11 + 1),
  Int8( -1 + 1),
  Int8(  4 + 1),
  Int8(  8 + 1),
  Int8( -1 + 1),
  Int8( -1 + 1),
  Int8( 14 + 1),
  Int8( -1 + 1),
  Int8( -1 + 1),
  Int8( -1 + 1),
  Int8(  5 + 1),
  Int8(  9 + 1),
  Int8( 12 + 1),
  Int8( 23 + 1),
  Int8( 15 + 1),
  Int8( -1 + 1),
  Int8( 21 + 1),
  Int8( 38 + 1),
  Int8( 17 + 1),
  Int8( 20 + 1),
  Int8( -1 + 1),
  Int8( 36 + 1),
  Int8( 26 + 1),
  Int8( 33 + 1),
  Int8( 30 + 1),
  Int8( 44 + 1),
  Int8(  6 + 1),
  Int8( 10 + 1),
  Int8( 13 + 1),
  Int8( 19 + 1),
  Int8( 16 + 1),
  Int8( -1 + 1),
  Int8( 25 + 1),
  Int8( 37 + 1),
  Int8( 18 + 1),
  Int8( 24 + 1),
  Int8( -1 + 1),
  Int8( 35 + 1),
  Int8( 22 + 1),
  Int8( 32 + 1),
  Int8( 29 + 1),
  Int8( 43 + 1),
  Int8( -1 + 1),
  Int8( -1 + 1),
  Int8( -1 + 1),
  Int8( 34 + 1),
  Int8( -1 + 1),
  Int8( -1 + 1),
  Int8( 28 + 1),
  Int8( 42 + 1),
  Int8( -1 + 1),
  Int8( 31 + 1),
  Int8( -1 + 1),
  Int8( 41 + 1),
  Int8( 27 + 1),
  Int8( 40 + 1),
  Int8( 39 + 1),
  Int8( 45 + 1),
)

#=
 tiling table for case 13.1
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling13_1 = (
  Int8.(( 11,  7,  6,  1,  2, 10,  8,  3,  0,  9,  5, 4 ) .+ 1),
  Int8.((  8,  4,  7,  2,  3, 11,  9,  0,  1, 10,  6, 5 ) .+ 1),
)

#=
 tiling table for case 13.1 inverted
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling13_1_ = (
  Int8.(( 7,  4,  8, 11,  3,  2,  1,  0,  9,  5,  6, 10 ) .+ 1),
  Int8.(( 6,  7, 11, 10,  2,  1,  0,  3,  8,  4,  5,  9 ) .+ 1),
)

#=
 tiling table for case 13.2
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling13_2 = (
  (
   Int8.(( 1,  2, 10, 11,  7,  6,  3,  4,  8,  4,  3,  5,  0,  5,  3,  5,  0,  9 ) .+ 1),
   Int8.(( 8,  3,  0, 11,  7,  6,  9,  1,  4,  2,  4,  1,  4,  2,  5, 10,  5,  2 ) .+ 1),
   Int8.(( 9,  5,  4,  8,  3,  0,  1,  6, 10,  6,  1,  7,  2,  7,  1,  7,  2, 11 ) .+ 1),
   Int8.(( 9,  5,  4,  1,  2, 10, 11,  3,  6,  0,  6,  3,  6,  0,  7,  8,  7,  0 ) .+ 1),
   Int8.(( 9,  5,  4, 11,  7,  6,  0, 10,  1, 10,  0,  8, 10,  8,  2,  3,  2,  8 ) .+ 1),
   Int8.(( 1,  2, 10,  3,  0,  8,  4,  9,  7, 11,  7,  9,  5, 11,  9, 11,  5,  6 ) .+ 1),
),
  (
   Int8.(( 2,  3, 11,  8,  4,  7,  0,  5,  9,  5,  0,  6,  1,  6,  0,  6,  1, 10 ) .+ 1),
   Int8.(( 9,  0,  1,  8,  4,  7, 10,  2,  5,  3,  5,  2,  5,  3,  6, 11,  6,  3 ) .+ 1),
   Int8.(( 6,  5, 10,  9,  0,  1,  2,  7, 11,  7,  2,  4,  3,  4,  2,  4,  3,  8 ) .+ 1),
   Int8.(( 6,  5, 10,  2,  3, 11,  8,  0,  7,  1,  7,  0,  7,  1,  4,  9,  4,  1 ) .+ 1),
   Int8.(( 6,  5, 10,  8,  4,  7,  1, 11,  2, 11,  1,  9, 11,  9,  3,  0,  3,  9 ) .+ 1),
   Int8.(( 2,  3, 11,  0,  1,  9,  5, 10,  4,  8,  4, 10,  6,  8, 10,  8,  6,  7 ) .+ 1),
))

#=
 tiling table for case 13.2 inverted
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling13_2_ = (
  (
   Int8.(( 10,  5,  6, 11,  3,  2,  7,  0,  8,  0,  7,  1,  4,  1,  7,  1,  4,  9 ) .+ 1),
   Int8.(( 11,  3,  2,  7,  4,  8,  9,  5,  0,  6,  0,  5,  0,  6,  1, 10,  1,  6 ) .+ 1),
   Int8.((  1,  0,  9,  7,  4,  8,  5,  2, 10,  2,  5,  3,  6,  3,  5,  3,  6, 11 ) .+ 1),
   Int8.(( 10,  5,  6,  1,  0,  9, 11,  7,  2,  4,  2,  7,  2,  4,  3,  8,  3,  4 ) .+ 1),
   Int8.(( 10,  5,  6,  7,  4,  8,  2, 11,  1,  9,  1, 11,  3,  9, 11,  9,  3,  0 ) .+ 1),
   Int8.(( 11,  3,  2,  9,  1,  0,  4, 10,  5, 10,  4,  8, 10,  8,  6,  7,  6,  8 ) .+ 1),
),
  (
   Int8.((  6,  7, 11,  8,  0,  3,  4,  1,  9,  1,  4,  2,  5,  2,  4,  2,  5, 10 ) .+ 1),
   Int8.((  8,  0,  3,  4,  5,  9, 10,  6,  1,  7,  1,  6,  1,  7,  2, 11,  2,  7 ) .+ 1),
   Int8.((  2,  1, 10,  4,  5,  9,  6,  3, 11,  3,  6,  0,  7,  0,  6,  0,  7,  8 ) .+ 1),
   Int8.((  6,  7, 11,  2,  1, 10,  8,  4,  3,  5,  3,  4,  3,  5,  0,  9,  0,  5 ) .+ 1),
   Int8.((  6,  7, 11,  4,  5,  9,  3,  8,  2, 10,  2,  8,  0, 10,  8, 10,  0,  1 ) .+ 1),
   Int8.((  8,  0,  3, 10,  2,  1,  5, 11,  6, 11,  5,  9, 11,  9,  7,  4,  7,  9 ) .+ 1),
))

#=
 tiling table for case 13.3
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling13_3 = (
  (
   Int8.(( 11,  7,  6, 12,  2, 10, 12, 10,  5, 12,  5,  4, 12,  4,  8, 12,  8,  3, 12,  3,  0, 12,  0,  9, 12,  9,  1, 12,  1,  2 ) .+ 1),
   Int8.((  1,  2, 10,  9,  5, 12,  0,  9, 12,  3,  0, 12, 11,  3, 12,  6, 11, 12,  7,  6, 12,  8,  7, 12,  4,  8, 12,  5,  4, 12 ) .+ 1),
   Int8.(( 11,  7,  6, 12,  5,  4, 12,  4,  8, 12,  8,  3, 12,  3,  2, 12,  2, 10, 12, 10,  1, 12,  1,  0, 12,  0,  9, 12,  9,  5 ) .+ 1),
   Int8.((  1,  2, 10, 12,  3,  0, 12,  0,  9, 12,  9,  5, 12,  5,  6, 12,  6, 11, 12, 11,  7, 12,  7,  4, 12,  4,  8, 12,  8,  3 ) .+ 1),
   Int8.((  8,  3,  0, 11,  7, 12,  2, 11, 12,  1,  2, 12,  9,  1, 12,  4,  9, 12,  5,  4, 12, 10,  5, 12,  6, 10, 12,  7,  6, 12 ) .+ 1),
   Int8.(( 11,  7,  6,  5,  4, 12, 10,  5, 12,  2, 10, 12,  3,  2, 12,  8,  3, 12,  0,  8, 12,  1,  0, 12,  9,  1, 12,  4,  9, 12 ) .+ 1),
   Int8.((  8,  3,  0,  1,  2, 12,  9,  1, 12,  4,  9, 12,  7,  4, 12, 11,  7, 12,  6, 11, 12,  5,  6, 12, 10,  5, 12,  2, 10, 12 ) .+ 1),
   Int8.((  9,  5,  4, 12,  0,  8, 12,  8,  7, 12,  7,  6, 12,  6, 10, 12, 10,  1, 12,  1,  2, 12,  2, 11, 12, 11,  3, 12,  3,  0 ) .+ 1),
   Int8.((  9,  5,  4, 12,  7,  6, 12,  6, 10, 12, 10,  1, 12,  1,  0, 12,  0,  8, 12,  8,  3, 12,  3,  2, 12,  2, 11, 12, 11,  7 ) .+ 1),
   Int8.((  8,  3,  0, 12,  1,  2, 12,  2, 11, 12, 11,  7, 12,  7,  4, 12,  4,  9, 12,  9,  5, 12,  5,  6, 12,  6, 10, 12, 10,  1 ) .+ 1),
   Int8.((  9,  5,  4,  7,  6, 12,  8,  7, 12,  0,  8, 12,  1,  0, 12, 10,  1, 12,  2, 10, 12,  3,  2, 12, 11,  3, 12,  6, 11, 12 ) .+ 1),
   Int8.((  1,  2, 10,  3,  0, 12, 11,  3, 12,  6, 11, 12,  5,  6, 12,  9,  5, 12,  4,  9, 12,  7,  4, 12,  8,  7, 12,  0,  8, 12 ) .+ 1),
),
  (
   Int8.((  8,  4,  7, 12,  3, 11, 12, 11,  6, 12,  6,  5, 12,  5,  9, 12,  9,  0, 12,  0,  1, 12,  1, 10, 12, 10,  2, 12,  2,  3 ) .+ 1),
   Int8.((  2,  3, 11, 10,  6, 12,  1, 10, 12,  0,  1, 12,  8,  0, 12,  7,  8, 12,  4,  7, 12,  9,  4, 12,  5,  9, 12,  6,  5, 12 ) .+ 1),
   Int8.((  8,  4,  7, 12,  6,  5, 12,  5,  9, 12,  9,  0, 12,  0,  3, 12,  3, 11, 12, 11,  2, 12,  2,  1, 12,  1, 10, 12, 10,  6 ) .+ 1),
   Int8.((  2,  3, 11, 12,  0,  1, 12,  1, 10, 12, 10,  6, 12,  6,  7, 12,  7,  8, 12,  8,  4, 12,  4,  5, 12,  5,  9, 12,  9,  0 ) .+ 1),
   Int8.((  0,  1,  9,  8,  4, 12,  3,  8, 12,  2,  3, 12, 10,  2, 12,  5, 10, 12,  6,  5, 12, 11,  6, 12,  7, 11, 12,  4,  7, 12 ) .+ 1),
   Int8.((  8,  4,  7,  6,  5, 12, 11,  6, 12,  3, 11, 12,  0,  3, 12,  9,  0, 12,  1,  9, 12,  2,  1, 12, 10,  2, 12,  5, 10, 12 ) .+ 1),
   Int8.((  9,  0,  1,  2,  3, 12, 10,  2, 12,  5, 10, 12,  4,  5, 12,  8,  4, 12,  7,  8, 12,  6,  7, 12, 11,  6, 12,  3, 11, 12 ) .+ 1),
   Int8.((  6,  5, 10, 12,  1,  9, 12,  9,  4, 12,  4,  7, 12,  7, 11, 12, 11,  2, 12,  2,  3, 12,  3,  8, 12,  8,  0, 12,  0,  1 ) .+ 1),
   Int8.((  6,  5, 10, 12,  4,  7, 12,  7, 11, 12, 11,  2, 12,  2,  1, 12,  1,  9, 12,  9,  0, 12,  0,  3, 12,  3,  8, 12,  8,  4 ) .+ 1),
   Int8.((  9,  0,  1, 12,  2,  3, 12,  3,  8, 12,  8,  4, 12,  4,  5, 12,  5, 10, 12, 10,  6, 12,  6,  7, 12,  7, 11, 12, 11,  2 ) .+ 1),
   Int8.((  6,  5, 10,  4,  7, 12,  9,  4, 12,  1,  9, 12,  2,  1, 12, 11,  2, 12,  3, 11, 12,  0,  3, 12,  8,  0, 12,  7,  8, 12 ) .+ 1),
   Int8.((  2,  3, 11,  0,  1, 12,  8,  0, 12,  7,  8, 12,  6,  7, 12, 10,  6, 12,  5, 10, 12,  4,  5, 12,  9,  4, 12,  1,  9, 12 ) .+ 1),
))

#=
 tiling table for case 13.3, inverted
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
  const tiling13_3_ = (
  (
   Int8.((  3,  2, 11,  8,  7, 12,  0,  8, 12,  1,  0, 12, 10,  1, 12,  6, 10, 12,  5,  6, 12,  9,  5, 12,  4,  9, 12,  7,  4, 12 ) .+ 1),
   Int8.((  5,  6, 10, 12,  2, 11, 12, 11,  7, 12,  7,  4, 12,  4,  9, 12,  9,  1, 12,  1,  0, 12,  0,  8, 12,  8,  3, 12,  3,  2 ) .+ 1),
   Int8.(( 10,  5,  6, 12,  7,  4, 12,  4,  9, 12,  9,  1, 12,  1,  2, 12,  2, 11, 12, 11,  3, 12,  3,  0, 12,  0,  8, 12,  8,  7 ) .+ 1),
   Int8.(( 11,  3,  2, 12,  1,  0, 12,  0,  8, 12,  8,  7, 12,  7,  6, 12,  6, 10, 12, 10,  5, 12,  5,  4, 12,  4,  9, 12,  9,  1 ) .+ 1),
   Int8.((  7,  4,  8, 11,  3, 12,  6, 11, 12,  5,  6, 12,  9,  5, 12,  0,  9, 12,  1,  0, 12, 10,  1, 12,  2, 10, 12,  3,  2, 12 ) .+ 1),
   Int8.((  7,  4,  8,  5,  6, 12,  9,  5, 12,  0,  9, 12,  3,  0, 12, 11,  3, 12,  2, 11, 12,  1,  2, 12, 10,  1, 12,  6, 10, 12 ) .+ 1),
   Int8.(( 11,  3,  2,  1,  0, 12, 10,  1, 12,  6, 10, 12,  7,  6, 12,  8,  7, 12,  4,  8, 12,  5,  4, 12,  9,  5, 12,  0,  9, 12 ) .+ 1),
   Int8.((  1,  0,  9, 12,  4,  8, 12,  8,  3, 12,  3,  2, 12,  2, 10, 12, 10,  5, 12,  5,  6, 12,  6, 11, 12, 11,  7, 12,  7,  4 ) .+ 1),
   Int8.((  7,  4,  8, 12,  5,  6, 12,  6, 11, 12, 11,  3, 12,  3,  0, 12,  0,  9, 12,  9,  1, 12,  1,  2, 12,  2, 10, 12, 10,  5 ) .+ 1),
   Int8.((  1,  0,  9, 12,  3,  2, 12,  2, 10, 12, 10,  5, 12,  5,  4, 12,  4,  8, 12,  8,  7, 12,  7,  6, 12,  6, 11, 12, 11,  3 ) .+ 1),
   Int8.(( 10,  5,  6,  7,  4, 12, 11,  7, 12,  2, 11, 12,  1,  2, 12,  9,  1, 12,  0,  9, 12,  3,  0, 12,  8,  3, 12,  4,  8, 12 ) .+ 1),
   Int8.((  9,  1,  0,  3,  2, 12,  8,  3, 12,  4,  8, 12,  5,  4, 12, 10,  5, 12,  6, 10, 12,  7,  6, 12, 11,  7, 12,  2, 11, 12 ) .+ 1),
),
  (
   Int8.((  0,  3,  8,  9,  4, 12,  1,  9, 12,  2,  1, 12, 11,  2, 12,  7, 11, 12,  6,  7, 12, 10,  6, 12,  5, 10, 12,  4,  5, 12 ) .+ 1),
   Int8.(( 11,  6,  7, 12,  3,  8, 12,  8,  4, 12,  4,  5, 12,  5, 10, 12, 10,  2, 12,  2,  1, 12,  1,  9, 12,  9,  0, 12,  0,  3 ) .+ 1),
   Int8.((  6,  7, 11, 12,  4,  5, 12,  5, 10, 12, 10,  2, 12,  2,  3, 12,  3,  8, 12,  8,  0, 12,  0,  1, 12,  1,  9, 12,  9,  4 ) .+ 1),
   Int8.((  8,  0,  3, 12,  2,  1, 12,  1,  9, 12,  9,  4, 12,  4,  7, 12,  7, 11, 12, 11,  6, 12,  6,  5, 12,  5, 10, 12, 10,  2 ) .+ 1),
   Int8.((  4,  5,  9,  8,  0, 12,  7,  8, 12,  6,  7, 12, 10,  6, 12,  1, 10, 12,  2,  1, 12, 11,  2, 12,  3, 11, 12,  0,  3, 12 ) .+ 1),
   Int8.((  4,  5,  9,  6,  7, 12, 10,  6, 12,  1, 10, 12,  0,  1, 12,  8,  0, 12,  3,  8, 12,  2,  3, 12, 11,  2, 12,  7, 11, 12 ) .+ 1),
   Int8.((  8,  0,  3,  2,  1, 12, 11,  2, 12,  7, 11, 12,  4,  7, 12,  9,  4, 12,  5,  9, 12,  6,  5, 12, 10,  6, 12,  1, 10, 12 ) .+ 1),
   Int8.((  2,  1, 10, 12,  5,  9, 12,  9,  0, 12,  0,  3, 12,  3, 11, 12, 11,  6, 12,  6,  7, 12,  7,  8, 12,  8,  4, 12,  4,  5 ) .+ 1),
   Int8.((  4,  5,  9, 12,  6,  7, 12,  7,  8, 12,  8,  0, 12,  0,  1, 12,  1, 10, 12, 10,  2, 12,  2,  3, 12,  3, 11, 12, 11,  6 ) .+ 1),
   Int8.((  2,  1, 10, 12,  0,  3, 12,  3, 11, 12, 11,  6, 12,  6,  5, 12,  5,  9, 12,  9,  4, 12,  4,  7, 12,  7,  8, 12,  8,  0 ) .+ 1),
   Int8.((  6,  7, 11,  4,  5, 12,  8,  4, 12,  3,  8, 12,  2,  3, 12, 10,  2, 12,  1, 10, 12,  0,  1, 12,  9,  0, 12,  5,  9, 12 ) .+ 1),
   Int8.(( 10,  2,  1,  0,  3, 12,  9,  0, 12,  5,  9, 12,  6,  5, 12, 11,  6, 12,  7, 11, 12,  4,  7, 12,  8,  4, 12,  3,  8, 12 ) .+ 1),
))

#=
 tiling table for case 13.4
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling13_4 = (
  (
  Int8.(( 12,  2, 10, 12, 10,  5, 12,  5,  6, 12,  6, 11, 12, 11,  7, 12,  7,  4, 12,  4,  8, 12,  8,  3, 12,  3,  0, 12,  0,  9, 12,  9,  1, 12,  1,  2 ) .+ 1),
  Int8.(( 11,  3, 12,  6, 11, 12,  7,  6, 12,  8,  7, 12,  4,  8, 12,  5,  4, 12,  9,  5, 12,  0,  9, 12,  1,  0, 12, 10,  1, 12,  2, 10, 12,  3,  2, 12 ) .+ 1),
  Int8.((  9,  1, 12,  4,  9, 12,  5,  4, 12, 10,  5, 12,  6, 10, 12,  7,  6, 12, 11,  7, 12,  2, 11, 12,  3,  2, 12,  8,  3, 12,  0,  8, 12,  1,  0, 12 ) .+ 1),
  Int8.(( 12,  0,  8, 12,  8,  7, 12,  7,  4, 12,  4,  9, 12,  9,  5, 12,  5,  6, 12,  6, 10, 12, 10,  1, 12,  1,  2, 12,  2, 11, 12, 11,  3, 12,  3,  0 ) .+ 1),
),
  (
  Int8.(( 12,  3, 11, 12, 11,  6, 12,  6,  7, 12,  7,  8, 12,  8,  4, 12,  4,  5, 12,  5,  9, 12,  9,  0, 12,  0,  1, 12,  1, 10, 12, 10,  2, 12,  2,  3 ) .+ 1),
  Int8.((  8,  0, 12,  7,  8, 12,  4,  7, 12,  9,  4, 12,  5,  9, 12,  6,  5, 12, 10,  6, 12,  1, 10, 12,  2,  1, 12, 11,  2, 12,  3, 11, 12,  0,  3, 12 ) .+ 1),
  Int8.(( 10,  2, 12,  5, 10, 12,  6,  5, 12, 11,  6, 12,  7, 11, 12,  4,  7, 12,  8,  4, 12,  3,  8, 12,  0,  3, 12,  9,  0, 12,  1,  9, 12,  2,  1, 12 ) .+ 1),
  Int8.(( 12,  1,  9, 12,  9,  4, 12,  4,  5, 12,  5, 10, 12, 10,  6, 12,  6,  7, 12,  7, 11, 12, 11,  2, 12,  2,  3, 12,  3,  8, 12,  8,  0, 12,  0,  1 ) .+ 1),
))

#=
 tiling table for case 13.5.1
 The support edge for the interior test is marked as the 1st column.
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling13_5_1 = (
  (
  Int8.(( 7,  6, 11,  1,  0,  9, 10,  3,  2,  3, 10,  5,  3,  5,  8,  4,  8, 5 ) .+ 1),
  Int8.(( 1,  2, 10,  7,  4,  8,  3,  0, 11,  6, 11,  0,  9,  6,  0,  6,  9, 5 ) .+ 1),
  Int8.(( 3,  0,  8,  5,  6, 10,  1,  2,  9,  4,  9,  2, 11,  4,  2,  4, 11, 7 ) .+ 1),
  Int8.(( 5,  4,  9,  3,  2, 11,  8,  1,  0,  1,  8,  7,  1,  7, 10,  6, 10, 7 ) .+ 1),
),
  (
  Int8.(( 4,  7,  8,  2,  1, 10, 11,  0,  3,  0, 11,  6,  0,  6,  9,  5,  9, 6 ) .+ 1),
  Int8.(( 2,  3, 11,  4,  5,  9,  0,  1,  8,  7,  8,  1, 10,  7,  1,  7, 10, 6 ) .+ 1),
  Int8.(( 0,  1,  9,  6,  7, 11,  2,  3, 10,  5, 10,  3,  8,  5,  3,  5,  8, 4 ) .+ 1),
  Int8.(( 6,  5, 10,  0,  3,  8,  9,  2,  1,  2,  9,  4,  2,  4, 11,  7, 11, 4 ) .+ 1),
))

#=
 tiling table for case 13.5.2
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling13_5_2 = (
  (
  Int8.(( 1,  0,  9,  7,  4,  8,  7,  8,  3,  7,  3, 11,  2, 11,  3, 11,  2, 10, 11, 10,  6,  5,  6, 10,  6,  5,  7,  4,  7, 5 ) .+ 1),
  Int8.(( 7,  4,  8, 11,  3,  2,  6, 11,  2, 10,  6,  2,  6, 10,  5,  9,  5, 10,  1,  9, 10,  9,  1,  0,  2,  0,  1,  0,  2, 3 ) .+ 1),
  Int8.(( 5,  6, 10,  9,  1,  0,  4,  9,  0,  8,  4,  0,  4,  8,  7, 11,  7,  8,  3, 11,  8, 11,  3,  2,  0,  2,  3,  2,  0, 1 ) .+ 1),
  Int8.(( 3,  2, 11,  5,  6, 10,  5, 10,  1,  5,  1,  9,  0,  9,  1,  9,  0,  8,  9,  8,  4,  4,  8,  7,  4,  7,  5,  6,  5, 7 ) .+ 1),
),
  (
  Int8.(( 2,  1, 10,  4,  5,  9,  4,  9,  0,  4,  0,  8,  3,  8,  0,  8,  3, 11,  8, 11,  7,  6,  7, 11,  7,  6,  4,  5,  4, 6 ) .+ 1),
  Int8.(( 4,  5,  9,  8,  0,  3,  7,  8,  3, 11,  7,  3,  7, 11,  6, 10,  6, 11,  2, 10, 11, 10,  2,  1,  3,  1,  2,  1,  3, 0 ) .+ 1),
  Int8.(( 6,  7, 11, 10,  2,  1,  5, 10,  1,  9,  5,  1,  5,  9,  4,  8,  4,  9,  0,  8,  9,  8,  0,  3,  1,  3,  0,  3,  1, 2 ) .+ 1),
  Int8.(( 0,  3,  8,  6,  7, 11,  6, 11,  2,  6,  2, 10,  1, 10,  2, 10,  1,  9, 10,  9,  5,  5,  9,  4,  5,  4,  6,  7,  6, 4 ) .+ 1),
))

#=
 tiling table for case 14
 For each of the case above, the specific triangulation of the edge
 intersection points is given.
 When a case is ambiguous, there is an auxiliary table that contains
 the face number to test and the tiling table contains the specific
 triangulations depending on the results
 A minus sign means to invert the result of the test.
=#
#-----------------------------------------------------------------------------
const tiling14 = (
  Int8.((  5,  9,  8,  5,  8,  2,  5,  2,  6,  3,  2,  8 ) .+ 1),
  Int8.((  2,  1,  5,  2,  5,  8,  2,  8, 11,  4,  8,  5 ) .+ 1),
  Int8.((  9,  4,  6,  9,  6,  3,  9,  3,  1, 11,  3,  6 ) .+ 1),
  Int8.((  1, 11, 10,  1,  4, 11,  1,  0,  4,  7, 11,  4 ) .+ 1),
  Int8.((  8,  2,  0,  8,  5,  2,  8,  7,  5, 10,  2,  5 ) .+ 1),
  Int8.((  0,  7,  3,  0, 10,  7,  0,  9, 10,  6,  7, 10 ) .+ 1),
  Int8.((  0,  3,  7,  0,  7, 10,  0, 10,  9,  6, 10,  7 ) .+ 1),
  Int8.((  8,  0,  2,  8,  2,  5,  8,  5,  7, 10,  5,  2 ) .+ 1),
  Int8.((  1, 10, 11,  1, 11,  4,  1,  4,  0,  7,  4, 11 ) .+ 1),
  Int8.((  9,  6,  4,  9,  3,  6,  9,  1,  3, 11,  6,  3 ) .+ 1),
  Int8.((  2,  5,  1,  2,  8,  5,  2, 11,  8,  4,  5,  8 ) .+ 1),
  Int8.((  5,  8,  9,  5,  2,  8,  5,  6,  2,  3,  8,  2 ) .+ 1),
)

#=
 original Marching Cubes implementation
 For each of the possible vertex states listed in this table there is a
 specific triangulation of the edge intersection points.  The table lists
 all of them in the form of 0-5 edge triples with the list terminated by
 the invalid value 0.  For example: casesClassic[4] list the 2 triangles
 formed when cube[1] and cube[2] are inside of the surface, but the rest of
 the cube is not.
=#
#-----------------------------------------------------------------------------
const casesClassic = (
  Int8.(( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  8,  3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  1,  9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  8,  3,  9,  8,  1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  2, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  8,  3,  1,  2, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  2, 10,  0,  2,  9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  2,  8,  3,  2, 10,  8, 10,  9,  8, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3, 11,  2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0, 11,  2,  8, 11,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  9,  0,  2,  3, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1, 11,  2,  1,  9, 11,  9,  8, 11, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3, 10,  1, 11, 10,  3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0, 10,  1,  0,  8, 10,  8, 11, 10, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3,  9,  0,  3, 11,  9, 11, 10,  9, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  8, 10, 10,  8, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  4,  7,  8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  4,  3,  0,  7,  3,  4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  1,  9,  8,  4,  7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  4,  1,  9,  4,  7,  1,  7,  3,  1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  2, 10,  8,  4,  7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3,  4,  7,  3,  0,  4,  1,  2, 10, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  2, 10,  9,  0,  2,  8,  4,  7, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  2, 10,  9,  2,  9,  7,  2,  7,  3,  7,  9,  4, -1, -1, -1, -1 ) .+ 1),
  Int8.((  8,  4,  7,  3, 11,  2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 11,  4,  7, 11,  2,  4,  2,  0,  4, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  0,  1,  8,  4,  7,  2,  3, 11, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  4,  7, 11,  9,  4, 11,  9, 11,  2,  9,  2,  1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3, 10,  1,  3, 11, 10,  7,  8,  4, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1, 11, 10,  1,  4, 11,  1,  0,  4,  7, 11,  4, -1, -1, -1, -1 ) .+ 1),
  Int8.((  4,  7,  8,  9,  0, 11,  9, 11, 10, 11,  0,  3, -1, -1, -1, -1 ) .+ 1),
  Int8.((  4,  7, 11,  4, 11,  9,  9, 11, 10, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  5,  4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  5,  4,  0,  8,  3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  5,  4,  1,  5,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  8,  5,  4,  8,  3,  5,  3,  1,  5, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  2, 10,  9,  5,  4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3,  0,  8,  1,  2, 10,  4,  9,  5, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  5,  2, 10,  5,  4,  2,  4,  0,  2, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  2, 10,  5,  3,  2,  5,  3,  5,  4,  3,  4,  8, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  5,  4,  2,  3, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0, 11,  2,  0,  8, 11,  4,  9,  5, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  5,  4,  0,  1,  5,  2,  3, 11, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  2,  1,  5,  2,  5,  8,  2,  8, 11,  4,  8,  5, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 10,  3, 11, 10,  1,  3,  9,  5,  4, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  4,  9,  5,  0,  8,  1,  8, 10,  1,  8, 11, 10, -1, -1, -1, -1 ) .+ 1),
  Int8.((  5,  4,  0,  5,  0, 11,  5, 11, 10, 11,  0,  3, -1, -1, -1, -1 ) .+ 1),
  Int8.((  5,  4,  8,  5,  8, 10, 10,  8, 11, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  7,  8,  5,  7,  9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  3,  0,  9,  5,  3,  5,  7,  3, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  7,  8,  0,  1,  7,  1,  5,  7, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  5,  3,  3,  5,  7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  7,  8,  9,  5,  7, 10,  1,  2, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 10,  1,  2,  9,  5,  0,  5,  3,  0,  5,  7,  3, -1, -1, -1, -1 ) .+ 1),
  Int8.((  8,  0,  2,  8,  2,  5,  8,  5,  7, 10,  5,  2, -1, -1, -1, -1 ) .+ 1),
  Int8.((  2, 10,  5,  2,  5,  3,  3,  5,  7, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  7,  9,  5,  7,  8,  9,  3, 11,  2, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  5,  7,  9,  7,  2,  9,  2,  0,  2,  7, 11, -1, -1, -1, -1 ) .+ 1),
  Int8.((  2,  3, 11,  0,  1,  8,  1,  7,  8,  1,  5,  7, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 11,  2,  1, 11,  1,  7,  7,  1,  5, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  5,  8,  8,  5,  7, 10,  1,  3, 10,  3, 11, -1, -1, -1, -1 ) .+ 1),
  Int8.((  5,  7,  0,  5,  0,  9,  7, 11,  0,  1,  0, 10, 11, 10,  0, -1 ) .+ 1),
  Int8.(( 11, 10,  0, 11,  0,  3, 10,  5,  0,  8,  0,  7,  5,  7,  0, -1 ) .+ 1),
  Int8.(( 11, 10,  5,  7, 11,  5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 10,  6,  5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  8,  3,  5, 10,  6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  0,  1,  5, 10,  6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  8,  3,  1,  9,  8,  5, 10,  6, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  6,  5,  2,  6,  1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  6,  5,  1,  2,  6,  3,  0,  8, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  6,  5,  9,  0,  6,  0,  2,  6, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  5,  9,  8,  5,  8,  2,  5,  2,  6,  3,  2,  8, -1, -1, -1, -1 ) .+ 1),
  Int8.((  2,  3, 11, 10,  6,  5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 11,  0,  8, 11,  2,  0, 10,  6,  5, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  1,  9,  2,  3, 11,  5, 10,  6, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  5, 10,  6,  1,  9,  2,  9, 11,  2,  9,  8, 11, -1, -1, -1, -1 ) .+ 1),
  Int8.((  6,  3, 11,  6,  5,  3,  5,  1,  3, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  8, 11,  0, 11,  5,  0,  5,  1,  5, 11,  6, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3, 11,  6,  0,  3,  6,  0,  6,  5,  0,  5,  9, -1, -1, -1, -1 ) .+ 1),
  Int8.((  6,  5,  9,  6,  9, 11, 11,  9,  8, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  5, 10,  6,  4,  7,  8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  4,  3,  0,  4,  7,  3,  6,  5, 10, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  9,  0,  5, 10,  6,  8,  4,  7, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 10,  6,  5,  1,  9,  7,  1,  7,  3,  7,  9,  4, -1, -1, -1, -1 ) .+ 1),
  Int8.((  6,  1,  2,  6,  5,  1,  4,  7,  8, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  2,  5,  5,  2,  6,  3,  0,  4,  3,  4,  7, -1, -1, -1, -1 ) .+ 1),
  Int8.((  8,  4,  7,  9,  0,  5,  0,  6,  5,  0,  2,  6, -1, -1, -1, -1 ) .+ 1),
  Int8.((  7,  3,  9,  7,  9,  4,  3,  2,  9,  5,  9,  6,  2,  6,  9, -1 ) .+ 1),
  Int8.((  3, 11,  2,  7,  8,  4, 10,  6,  5, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  5, 10,  6,  4,  7,  2,  4,  2,  0,  2,  7, 11, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  1,  9,  4,  7,  8,  2,  3, 11,  5, 10,  6, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  2,  1,  9, 11,  2,  9,  4, 11,  7, 11,  4,  5, 10,  6, -1 ) .+ 1),
  Int8.((  8,  4,  7,  3, 11,  5,  3,  5,  1,  5, 11,  6, -1, -1, -1, -1 ) .+ 1),
  Int8.((  5,  1, 11,  5, 11,  6,  1,  0, 11,  7, 11,  4,  0,  4, 11, -1 ) .+ 1),
  Int8.((  0,  5,  9,  0,  6,  5,  0,  3,  6, 11,  6,  3,  8,  4,  7, -1 ) .+ 1),
  Int8.((  6,  5,  9,  6,  9, 11,  4,  7,  9,  7, 11,  9, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 10,  4,  9,  6,  4, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  4, 10,  6,  4,  9, 10,  0,  8,  3, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 10,  0,  1, 10,  6,  0,  6,  4,  0, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  8,  3,  1,  8,  1,  6,  8,  6,  4,  6,  1, 10, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  4,  9,  1,  2,  4,  2,  6,  4, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3,  0,  8,  1,  2,  9,  2,  4,  9,  2,  6,  4, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  2,  4,  4,  2,  6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  8,  3,  2,  8,  2,  4,  4,  2,  6, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 10,  4,  9, 10,  6,  4, 11,  2,  3, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  8,  2,  2,  8, 11,  4,  9, 10,  4, 10,  6, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3, 11,  2,  0,  1,  6,  0,  6,  4,  6,  1, 10, -1, -1, -1, -1 ) .+ 1),
  Int8.((  6,  4,  1,  6,  1, 10,  4,  8,  1,  2,  1, 11,  8, 11,  1, -1 ) .+ 1),
  Int8.((  9,  6,  4,  9,  3,  6,  9,  1,  3, 11,  6,  3, -1, -1, -1, -1 ) .+ 1),
  Int8.((  8, 11,  1,  8,  1,  0, 11,  6,  1,  9,  1,  4,  6,  4,  1, -1 ) .+ 1),
  Int8.((  3, 11,  6,  3,  6,  0,  0,  6,  4, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  6,  4,  8, 11,  6,  8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  7, 10,  6,  7,  8, 10,  8,  9, 10, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  7,  3,  0, 10,  7,  0,  9, 10,  6,  7, 10, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 10,  6,  7,  1, 10,  7,  1,  7,  8,  1,  8,  0, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 10,  6,  7, 10,  7,  1,  1,  7,  3, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  2,  6,  1,  6,  8,  1,  8,  9,  8,  6,  7, -1, -1, -1, -1 ) .+ 1),
  Int8.((  2,  6,  9,  2,  9,  1,  6,  7,  9,  0,  9,  3,  7,  3,  9, -1 ) .+ 1),
  Int8.((  7,  8,  0,  7,  0,  6,  6,  0,  2, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  7,  3,  2,  6,  7,  2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  2,  3, 11, 10,  6,  8, 10,  8,  9,  8,  6,  7, -1, -1, -1, -1 ) .+ 1),
  Int8.((  2,  0,  7,  2,  7, 11,  0,  9,  7,  6,  7, 10,  9, 10,  7, -1 ) .+ 1),
  Int8.((  1,  8,  0,  1,  7,  8,  1, 10,  7,  6,  7, 10,  2,  3, 11, -1 ) .+ 1),
  Int8.(( 11,  2,  1, 11,  1,  7, 10,  6,  1,  6,  7,  1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  8,  9,  6,  8,  6,  7,  9,  1,  6, 11,  6,  3,  1,  3,  6, -1 ) .+ 1),
  Int8.((  0,  9,  1, 11,  6,  7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  7,  8,  0,  7,  0,  6,  3, 11,  0, 11,  6,  0, -1, -1, -1, -1 ) .+ 1),
  Int8.((  7, 11,  6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  7,  6, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3,  0,  8, 11,  7,  6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  1,  9, 11,  7,  6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  8,  1,  9,  8,  3,  1, 11,  7,  6, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 10,  1,  2,  6, 11,  7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  2, 10,  3,  0,  8,  6, 11,  7, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  2,  9,  0,  2, 10,  9,  6, 11,  7, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  6, 11,  7,  2, 10,  3, 10,  8,  3, 10,  9,  8, -1, -1, -1, -1 ) .+ 1),
  Int8.((  7,  2,  3,  6,  2,  7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  7,  0,  8,  7,  6,  0,  6,  2,  0, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  2,  7,  6,  2,  3,  7,  0,  1,  9, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  6,  2,  1,  8,  6,  1,  9,  8,  8,  7,  6, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 10,  7,  6, 10,  1,  7,  1,  3,  7, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 10,  7,  6,  1,  7, 10,  1,  8,  7,  1,  0,  8, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  3,  7,  0,  7, 10,  0, 10,  9,  6, 10,  7, -1, -1, -1, -1 ) .+ 1),
  Int8.((  7,  6, 10,  7, 10,  8,  8, 10,  9, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  6,  8,  4, 11,  8,  6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3,  6, 11,  3,  0,  6,  0,  4,  6, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  8,  6, 11,  8,  4,  6,  9,  0,  1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  4,  6,  9,  6,  3,  9,  3,  1, 11,  3,  6, -1, -1, -1, -1 ) .+ 1),
  Int8.((  6,  8,  4,  6, 11,  8,  2, 10,  1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  2, 10,  3,  0, 11,  0,  6, 11,  0,  4,  6, -1, -1, -1, -1 ) .+ 1),
  Int8.((  4, 11,  8,  4,  6, 11,  0,  2,  9,  2, 10,  9, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 10,  9,  3, 10,  3,  2,  9,  4,  3, 11,  3,  6,  4,  6,  3, -1 ) .+ 1),
  Int8.((  8,  2,  3,  8,  4,  2,  4,  6,  2, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  4,  2,  4,  6,  2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  9,  0,  2,  3,  4,  2,  4,  6,  4,  3,  8, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  9,  4,  1,  4,  2,  2,  4,  6, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  8,  1,  3,  8,  6,  1,  8,  4,  6,  6, 10,  1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 10,  1,  0, 10,  0,  6,  6,  0,  4, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  4,  6,  3,  4,  3,  8,  6, 10,  3,  0,  3,  9, 10,  9,  3, -1 ) .+ 1),
  Int8.(( 10,  9,  4,  6, 10,  4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  4,  9,  5,  7,  6, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  8,  3,  4,  9,  5, 11,  7,  6, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  5,  0,  1,  5,  4,  0,  7,  6, 11, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 11,  7,  6,  8,  3,  4,  3,  5,  4,  3,  1,  5, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  5,  4, 10,  1,  2,  7,  6, 11, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  6, 11,  7,  1,  2, 10,  0,  8,  3,  4,  9,  5, -1, -1, -1, -1 ) .+ 1),
  Int8.((  7,  6, 11,  5,  4, 10,  4,  2, 10,  4,  0,  2, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3,  4,  8,  3,  5,  4,  3,  2,  5, 10,  5,  2, 11,  7,  6, -1 ) .+ 1),
  Int8.((  7,  2,  3,  7,  6,  2,  5,  4,  9, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  5,  4,  0,  8,  6,  0,  6,  2,  6,  8,  7, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3,  6,  2,  3,  7,  6,  1,  5,  0,  5,  4,  0, -1, -1, -1, -1 ) .+ 1),
  Int8.((  6,  2,  8,  6,  8,  7,  2,  1,  8,  4,  8,  5,  1,  5,  8, -1 ) .+ 1),
  Int8.((  9,  5,  4, 10,  1,  6,  1,  7,  6,  1,  3,  7, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  6, 10,  1,  7,  6,  1,  0,  7,  8,  7,  0,  9,  5,  4, -1 ) .+ 1),
  Int8.((  4,  0, 10,  4, 10,  5,  0,  3, 10,  6, 10,  7,  3,  7, 10, -1 ) .+ 1),
  Int8.((  7,  6, 10,  7, 10,  8,  5,  4, 10,  4,  8, 10, -1, -1, -1, -1 ) .+ 1),
  Int8.((  6,  9,  5,  6, 11,  9, 11,  8,  9, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3,  6, 11,  0,  6,  3,  0,  5,  6,  0,  9,  5, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0, 11,  8,  0,  5, 11,  0,  1,  5,  5,  6, 11, -1, -1, -1, -1 ) .+ 1),
  Int8.((  6, 11,  3,  6,  3,  5,  5,  3,  1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  2, 10,  9,  5, 11,  9, 11,  8, 11,  5,  6, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0, 11,  3,  0,  6, 11,  0,  9,  6,  5,  6,  9,  1,  2, 10, -1 ) .+ 1),
  Int8.(( 11,  8,  5, 11,  5,  6,  8,  0,  5, 10,  5,  2,  0,  2,  5, -1 ) .+ 1),
  Int8.((  6, 11,  3,  6,  3,  5,  2, 10,  3, 10,  5,  3, -1, -1, -1, -1 ) .+ 1),
  Int8.((  5,  8,  9,  5,  2,  8,  5,  6,  2,  3,  8,  2, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  5,  6,  9,  6,  0,  0,  6,  2, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  5,  8,  1,  8,  0,  5,  6,  8,  3,  8,  2,  6,  2,  8, -1 ) .+ 1),
  Int8.((  1,  5,  6,  2,  1,  6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  3,  6,  1,  6, 10,  3,  8,  6,  5,  6,  9,  8,  9,  6, -1 ) .+ 1),
  Int8.(( 10,  1,  0, 10,  0,  6,  9,  5,  0,  5,  6,  0, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  3,  8,  5,  6, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 10,  5,  6, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 11,  5, 10,  7,  5, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 11,  5, 10, 11,  7,  5,  8,  3,  0, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  5, 11,  7,  5, 10, 11,  1,  9,  0, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 10,  7,  5, 10, 11,  7,  9,  8,  1,  8,  3,  1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 11,  1,  2, 11,  7,  1,  7,  5,  1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  8,  3,  1,  2,  7,  1,  7,  5,  7,  2, 11, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  7,  5,  9,  2,  7,  9,  0,  2,  2, 11,  7, -1, -1, -1, -1 ) .+ 1),
  Int8.((  7,  5,  2,  7,  2, 11,  5,  9,  2,  3,  2,  8,  9,  8,  2, -1 ) .+ 1),
  Int8.((  2,  5, 10,  2,  3,  5,  3,  7,  5, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  8,  2,  0,  8,  5,  2,  8,  7,  5, 10,  2,  5, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  0,  1,  5, 10,  3,  5,  3,  7,  3, 10,  2, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  8,  2,  9,  2,  1,  8,  7,  2, 10,  2,  5,  7,  5,  2, -1 ) .+ 1),
  Int8.((  1,  3,  5,  3,  7,  5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  8,  7,  0,  7,  1,  1,  7,  5, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  0,  3,  9,  3,  5,  5,  3,  7, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  8,  7,  5,  9,  7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  5,  8,  4,  5, 10,  8, 10, 11,  8, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  5,  0,  4,  5, 11,  0,  5, 10, 11, 11,  3,  0, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  1,  9,  8,  4, 10,  8, 10, 11, 10,  4,  5, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 10, 11,  4, 10,  4,  5, 11,  3,  4,  9,  4,  1,  3,  1,  4, -1 ) .+ 1),
  Int8.((  2,  5,  1,  2,  8,  5,  2, 11,  8,  4,  5,  8, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  4, 11,  0, 11,  3,  4,  5, 11,  2, 11,  1,  5,  1, 11, -1 ) .+ 1),
  Int8.((  0,  2,  5,  0,  5,  9,  2, 11,  5,  4,  5,  8, 11,  8,  5, -1 ) .+ 1),
  Int8.((  9,  4,  5,  2, 11,  3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  2,  5, 10,  3,  5,  2,  3,  4,  5,  3,  8,  4, -1, -1, -1, -1 ) .+ 1),
  Int8.((  5, 10,  2,  5,  2,  4,  4,  2,  0, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3, 10,  2,  3,  5, 10,  3,  8,  5,  4,  5,  8,  0,  1,  9, -1 ) .+ 1),
  Int8.((  5, 10,  2,  5,  2,  4,  1,  9,  2,  9,  4,  2, -1, -1, -1, -1 ) .+ 1),
  Int8.((  8,  4,  5,  8,  5,  3,  3,  5,  1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  4,  5,  1,  0,  5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  8,  4,  5,  8,  5,  3,  9,  0,  5,  0,  3,  5, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  4,  5, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  4, 11,  7,  4,  9, 11,  9, 10, 11, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  8,  3,  4,  9,  7,  9, 11,  7,  9, 10, 11, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1, 10, 11,  1, 11,  4,  1,  4,  0,  7,  4, 11, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3,  1,  4,  3,  4,  8,  1, 10,  4,  7,  4, 11, 10, 11,  4, -1 ) .+ 1),
  Int8.((  4, 11,  7,  9, 11,  4,  9,  2, 11,  9,  1,  2, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9,  7,  4,  9, 11,  7,  9,  1, 11,  2, 11,  1,  0,  8,  3, -1 ) .+ 1),
  Int8.(( 11,  7,  4, 11,  4,  2,  2,  4,  0, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( 11,  7,  4, 11,  4,  2,  8,  3,  4,  3,  2,  4, -1, -1, -1, -1 ) .+ 1),
  Int8.((  2,  9, 10,  2,  7,  9,  2,  3,  7,  7,  4,  9, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9, 10,  7,  9,  7,  4, 10,  2,  7,  8,  7,  0,  2,  0,  7, -1 ) .+ 1),
  Int8.((  3,  7, 10,  3, 10,  2,  7,  4, 10,  1, 10,  0,  4,  0, 10, -1 ) .+ 1),
  Int8.((  1, 10,  2,  8,  7,  4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  4,  9,  1,  4,  1,  7,  7,  1,  3, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  4,  9,  1,  4,  1,  7,  0,  8,  1,  8,  7,  1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  4,  0,  3,  7,  4,  3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  4,  8,  7, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9, 10,  8, 10, 11,  8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3,  0,  9,  3,  9, 11, 11,  9, 10, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  1, 10,  0, 10,  8,  8, 10, 11, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3,  1, 10, 11,  3, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  2, 11,  1, 11,  9,  9, 11,  8, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3,  0,  9,  3,  9, 11,  1,  2,  9,  2, 11,  9, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  2, 11,  8,  0, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  3,  2, 11, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  2,  3,  8,  2,  8, 10, 10,  8,  9, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  9, 10,  2,  0,  9,  2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  2,  3,  8,  2,  8, 10,  0,  1,  8,  1, 10,  8, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1, 10,  2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  1,  3,  8,  9,  1,  8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  9,  1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.((  0,  3,  8, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
  Int8.(( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ) .+ 1),
)
