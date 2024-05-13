1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.6.12;
3 import "./FullMath.sol";
4 
5 // solhint-disable
6 
7 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
8 library FixedPoint {
9     // range: [0, 2**112 - 1]
10     // resolution: 1 / 2**112
11     struct uq112x112 {
12         uint224 _x;
13     }
14 
15     // range: [0, 2**144 - 1]
16     // resolution: 1 / 2**112
17     struct uq144x112 {
18         uint256 _x;
19     }
20 
21     uint8 private constant RESOLUTION = 112;
22     uint256 private constant Q112 = 0x10000000000000000000000000000;
23     uint256 private constant Q224 = 0x100000000000000000000000000000000000000000000000000000000;
24     uint256 private constant LOWER_MASK = 0xffffffffffffffffffffffffffff; // decimal of UQ*x112 (lower 112 bits)
25 
26     // decode a UQ144x112 into a uint144 by truncating after the radix point
27     function decode144(uq144x112 memory self) internal pure returns (uint144) {
28         return uint144(self._x >> RESOLUTION);
29     }
30 
31     // multiply a UQ112x112 by a uint256, returning a UQ144x112
32     // reverts on overflow
33     function mul(uq112x112 memory self, uint256 y) internal pure returns (uq144x112 memory) {
34         uint256 z = 0;
35         require(y == 0 || (z = self._x * y) / y == self._x, "FixedPoint::mul: overflow");
36         return uq144x112(z);
37     }
38 
39     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
40     // lossy if either numerator or denominator is greater than 112 bits
41     function fraction(uint256 numerator, uint256 denominator) internal pure returns (uq112x112 memory) {
42         require(denominator > 0, "FixedPoint::fraction: div by 0");
43         if (numerator == 0) return FixedPoint.uq112x112(0);
44 
45         if (numerator <= uint144(-1)) {
46             uint256 result = (numerator << RESOLUTION) / denominator;
47             require(result <= uint224(-1), "FixedPoint::fraction: overflow");
48             return uq112x112(uint224(result));
49         } else {
50             uint256 result = FullMath.mulDiv(numerator, Q112, denominator);
51             require(result <= uint224(-1), "FixedPoint::fraction: overflow");
52             return uq112x112(uint224(result));
53         }
54     }
55 }
