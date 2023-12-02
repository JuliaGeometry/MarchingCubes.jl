#include "LookUpTable.h"
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char const *argv[])
{
    int idx = atoi(argv[1]);
    int i = atoi(argv[2]), j = -1, k = -1;
    if (argc > 3) j = atoi(argv[3]);
    if (argc > 4) k = atoi(argv[4]);

    switch (idx)
    {
        // 2d
        case 1: printf("%d\n", cases[i][j]); break;
        case 2: printf("%d\n", tiling1[i][j]); break;
        case 3: printf("%d\n", tiling2[i][j]); break;
        case 4: printf("%d\n", tiling3_1[i][j]); break;
        case 5: printf("%d\n", tiling3_2[i][j]); break;
        case 6: printf("%d\n", tiling4_1[i][j]); break;
        case 7: printf("%d\n", tiling4_2[i][j]); break;
        case 8: printf("%d\n", tiling5[i][j]); break;
        case 9: printf("%d\n", test6[i][j]); break;
        case 10: printf("%d\n", tiling6_1_1[i][j]); break;
        case 11: printf("%d\n", tiling6_1_2[i][j]); break;
        case 12: printf("%d\n", tiling6_2[i][j]); break;
        case 13: printf("%d\n", test7[i][j]); break;
        case 14: printf("%d\n", tiling7_1[i][j]); break;
        case 15: printf("%d\n", tiling7_4_1[i][j]); break;
        case 16: printf("%d\n", tiling7_4_2[i][j]); break;
        case 17: printf("%d\n", tiling8[i][j]); break;
        case 18: printf("%d\n", tiling9[i][j]); break;
        case 19: printf("%d\n", test10[i][j]); break;
        case 20: printf("%d\n", tiling10_1_1[i][j]); break;
        case 21: printf("%d\n", tiling10_1_1_[i][j]); break;
        case 22: printf("%d\n", tiling10_1_2[i][j]); break;
        case 23: printf("%d\n", tiling10_2[i][j]); break;
        case 24: printf("%d\n", tiling10_2_[i][j]); break;
        case 25: printf("%d\n", tiling11[i][j]); break;
        case 26: printf("%d\n", test12[i][j]); break;
        case 27: printf("%d\n", tiling12_1_1[i][j]); break;
        case 28: printf("%d\n", tiling12_1_1_[i][j]); break;
        case 29: printf("%d\n", tiling12_1_2[i][j]); break;
        case 30: printf("%d\n", tiling12_2[i][j]); break;
        case 31: printf("%d\n", tiling12_2_[i][j]); break;
        case 32: printf("%d\n", test13[i][j]); break;
        case 33: printf("%d\n", tiling13_1[i][j]); break;
        case 34: printf("%d\n", tiling13_1_[i][j]); break;
        case 35: printf("%d\n", tiling14[i][j]); break;
        case 36: printf("%d\n", casesClassic[i][j]); break;

        // 1d
        case 101: printf("%d\n", test3[i]); break;
        case 102: printf("%d\n", test4[i]); break;
        case 103: printf("%d\n", subconfig13[i]); break;

        // 3d
        case 201: printf("%d\n", tiling7_2[i][j][k]); break;
        case 202: printf("%d\n", tiling7_3[i][j][k]); break;
        case 203: printf("%d\n", tiling13_2[i][j][k]); break;
        case 204: printf("%d\n", tiling13_2_[i][j][k]); break;
        case 205: printf("%d\n", tiling13_3[i][j][k]); break;
        case 206: printf("%d\n", tiling13_3_[i][j][k]); break;
        case 207: printf("%d\n", tiling13_4[i][j][k]); break;
        case 208: printf("%d\n", tiling13_5_1[i][j][k]); break;
        case 209: printf("%d\n", tiling13_5_2[i][j][k]); break;
    }
}
