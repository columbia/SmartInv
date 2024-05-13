1 // SPDX-License-Identifier: CC-BY-4.0
2 pragma solidity 0.6.12;
3 
4 // solhint-disable
5 
6 // taken from https://medium.com/coinmonks/math-in-solidity-part-3-percents-and-proportions-4db014e080b1
7 // license is CC-BY-4.0
8 library FullMath {
9     function fullMul(uint256 x, uint256 y) private pure returns (uint256 l, uint256 h) {
10         uint256 mm = mulmod(x, y, uint256(-1));
11         l = x * y;
12         h = mm - l;
13         if (mm < l) h -= 1;
14     }
15 
16     function fullDiv(
17         uint256 l,
18         uint256 h,
19         uint256 d
20     ) private pure returns (uint256) {
21         uint256 pow2 = d & -d;
22         d /= pow2;
23         l /= pow2;
24         l += h * ((-pow2) / pow2 + 1);
25         uint256 r = 1;
26         r *= 2 - d * r;
27         r *= 2 - d * r;
28         r *= 2 - d * r;
29         r *= 2 - d * r;
30         r *= 2 - d * r;
31         r *= 2 - d * r;
32         r *= 2 - d * r;
33         r *= 2 - d * r;
34         return l * r;
35     }
36 
37     function mulDiv(
38         uint256 x,
39         uint256 y,
40         uint256 d
41     ) internal pure returns (uint256) {
42         (uint256 l, uint256 h) = fullMul(x, y);
43         uint256 mm = mulmod(x, y, d);
44         if (mm > l) h -= 1;
45         l -= mm;
46         require(h < d, "FullMath::mulDiv: overflow");
47         return fullDiv(l, h, d);
48     }
49 }
