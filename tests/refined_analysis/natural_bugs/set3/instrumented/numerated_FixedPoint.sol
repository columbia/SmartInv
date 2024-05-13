1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.4.0;
3 
4 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
5 library FixedPoint {
6     // range: [0, 2**112 - 1]
7     // resolution: 1 / 2**112
8     struct uq112x112 {
9         uint224 _x;
10     }
11 
12     // range: [0, 2**144 - 1]
13     // resolution: 1 / 2**112
14     struct uq144x112 {
15         uint _x;
16     }
17 
18     uint8 private constant RESOLUTION = 112;
19 
20     // encode a uint112 as a UQ112x112
21     function encode(uint112 x) internal pure returns (uq112x112 memory) {
22         return uq112x112(uint224(x) << RESOLUTION);
23     }
24 
25     // encodes a uint144 as a UQ144x112
26     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
27         return uq144x112(uint256(x) << RESOLUTION);
28     }
29 
30     // divide a UQ112x112 by a uint112, returning a UQ112x112
31     function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
32         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
33         return uq112x112(self._x / uint224(x));
34     }
35 
36     // multiply a UQ112x112 by a uint, returning a UQ144x112
37     // reverts on overflow
38     function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
39         uint z;
40         require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
41         return uq144x112(z);
42     }
43 
44     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
45     // equivalent to encode(numerator).div(denominator)
46     function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
47         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
48         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
49     }
50 
51     // decode a UQ112x112 into a uint112 by truncating after the radix point
52     function decode(uq112x112 memory self) internal pure returns (uint112) {
53         return uint112(self._x >> RESOLUTION);
54     }
55 
56     // decode a UQ144x112 into a uint144 by truncating after the radix point
57     function decode144(uq144x112 memory self) internal pure returns (uint144) {
58         return uint144(self._x >> RESOLUTION);
59     }
60 }
