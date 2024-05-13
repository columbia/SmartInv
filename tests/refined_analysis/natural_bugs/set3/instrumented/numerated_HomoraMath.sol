1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 import "@openzeppelin/contracts/math/SafeMath.sol";
5 
6 
7 library HomoraMath {
8     using SafeMath for uint;
9 
10     function divCeil(uint lhs, uint rhs) internal pure returns (uint) {
11         return lhs.add(rhs).sub(1) / rhs;
12     }
13 
14     function fmul(uint lhs, uint rhs) internal pure returns (uint) {
15         return lhs.mul(rhs) / (2**112);
16     }
17 
18     function fdiv(uint lhs, uint rhs) internal pure returns (uint) {
19         return lhs.mul(2**112) / rhs;
20     }
21 
22     // implementation from https://github.com/Uniswap/uniswap-lib/commit/99f3f28770640ba1bb1ff460ac7c5292fb8291a0
23     // original implementation: https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol#L687
24     function sqrt(uint x) internal pure returns (uint) {
25         if (x == 0) return 0;
26         uint xx = x;
27         uint r = 1;
28 
29         if (xx >= 0x100000000000000000000000000000000) {
30             xx >>= 128;
31             r <<= 64;
32         }
33 
34         if (xx >= 0x10000000000000000) {
35             xx >>= 64;
36             r <<= 32;
37         }
38         if (xx >= 0x100000000) {
39             xx >>= 32;
40             r <<= 16;
41         }
42         if (xx >= 0x10000) {
43             xx >>= 16;
44             r <<= 8;
45         }
46         if (xx >= 0x100) {
47             xx >>= 8;
48             r <<= 4;
49         }
50         if (xx >= 0x10) {
51             xx >>= 4;
52             r <<= 2;
53         }
54         if (xx >= 0x8) {
55             r <<= 1;
56         }
57 
58         r = (r + x / r) >> 1;
59         r = (r + x / r) >> 1;
60         r = (r + x / r) >> 1;
61         r = (r + x / r) >> 1;
62         r = (r + x / r) >> 1;
63         r = (r + x / r) >> 1;
64         r = (r + x / r) >> 1; // Seven iterations should be enough
65         uint r1 = x / r;
66         return (r < r1 ? r : r1);
67     }
68 }
