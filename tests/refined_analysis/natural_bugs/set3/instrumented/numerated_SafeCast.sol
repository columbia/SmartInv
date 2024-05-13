1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.11;
4 
5 
6 library SafeCast {
7     function toUint200(uint256 value) internal pure returns (uint200) {
8         require(value < 2**200, "value does not fit in 200 bits");
9         return uint200(value);
10     }
11 
12     function toUint128(uint256 value) internal pure returns (uint128) {
13         require(value < 2**128, "value does not fit in 128 bits");
14         return uint128(value);
15     }
16 
17     function toUint40(uint256 value) internal pure returns (uint40) {
18         require(value < 2**40, "value does not fit in 40 bits");
19         return uint40(value);
20     }
21 
22     function toUint8(uint256 value) internal pure returns (uint8) {
23         require(value < 2**8, "value does not fit in 8 bits");
24         return uint8(value);
25     }
26 }
