1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 library FixedPoint {
5     // range: [0, 2**112 - 1]
6     // resolution: 1 / 2**112
7     struct uq112x112 {
8         uint224 _x;
9     }
10 
11     // range: [0, 2**144 - 1]
12     // resolution: 1 / 2**112
13     struct uq144x112 {
14         uint _x;
15     }
16 
17     uint8 private constant RESOLUTION = 112;
18 
19     // encode a uint112 as a UQ112x112
20     function encode(uint112 x) internal pure returns (uq112x112 memory) {
21         return uq112x112(uint224(x) << RESOLUTION);
22     }
23 
24     // encodes a uint144 as a UQ144x112
25     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
26         return uq144x112(uint256(x) << RESOLUTION);
27     }
28 
29     // divide a UQ112x112 by a uint112, returning a UQ112x112
30     function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
31         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
32         return uq112x112(self._x / uint224(x));
33     }
34 
35     // multiply a UQ112x112 by a uint, returning a UQ144x112
36     // reverts on overflow
37     function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
38         uint z;
39         require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
40         return uq144x112(z);
41     }
42 
43     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
44     // equivalent to encode(numerator).div(denominator)
45     function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
46         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
47         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
48     }
49 
50     // decode a UQ112x112 into a uint112 by truncating after the radix point
51     function decode(uq112x112 memory self) internal pure returns (uint112) {
52         return uint112(self._x >> RESOLUTION);
53     }
54 
55     // decode a UQ144x112 into a uint144 by truncating after the radix point
56     function decode144(uq144x112 memory self) internal pure returns (uint144) {
57         return uint144(self._x >> RESOLUTION);
58     }
59 }
