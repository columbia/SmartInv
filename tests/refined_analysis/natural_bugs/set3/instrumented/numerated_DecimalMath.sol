1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.4;
4 pragma experimental ABIEncoderV2;
5 
6 import "@openzeppelin/contracts/math/SafeMath.sol";
7 
8 library MySafeMath {
9     using SafeMath for uint256;
10 
11     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 quotient = a.div(b);
13         uint256 remainder = a - quotient * b;
14         if (remainder > 0) {
15             return quotient + 1;
16         } else {
17             return quotient;
18         }
19     }
20 }
21 
22 library DecimalMath {
23     using SafeMath for uint256;
24 
25     uint256 internal constant ONE = 10**18;
26     uint256 internal constant ONE2 = 10**36;
27 
28     function mulFloor(uint256 target, uint256 d) internal pure returns (uint256) {
29         return target.mul(d) / (10**18);
30     }
31 
32     function mulCeil(uint256 target, uint256 d) internal pure returns (uint256) {
33         return MySafeMath.divCeil(target.mul(d), 10**18);
34     }
35 
36     function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {
37         return target.mul(10**18).div(d);
38     }
39 
40     function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {
41         return MySafeMath.divCeil(target.mul(10**18), d);
42     }
43 
44     function reciprocalFloor(uint256 target) internal pure returns (uint256) {
45         return uint256(10**36).div(target);
46     }
47 
48     function reciprocalCeil(uint256 target) internal pure returns (uint256) {
49         return MySafeMath.divCeil(uint256(10**36), target);
50     }
51 }