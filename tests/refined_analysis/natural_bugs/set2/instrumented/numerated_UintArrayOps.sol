1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/utils/math/SafeCast.sol";
5 
6 library UintArrayOps {
7     using SafeCast for uint256;
8 
9     function sum(uint256[] memory array) internal pure returns (uint256 _sum) {
10         for (uint256 i = 0; i < array.length; i++) {
11             _sum += array[i];
12         }
13 
14         return _sum;
15     }
16 
17     function signedDifference(uint256[] memory a, uint256[] memory b)
18         internal
19         pure
20         returns (int256[] memory _difference)
21     {
22         require(a.length == b.length, "Arrays must be the same length");
23 
24         _difference = new int256[](a.length);
25 
26         for (uint256 i = 0; i < a.length; i++) {
27             _difference[i] = a[i].toInt256() - b[i].toInt256();
28         }
29 
30         return _difference;
31     }
32 
33     /// @dev given two int arrays a & b, returns an array c such that c[i] = a[i] - b[i], with negative values truncated to 0
34     function positiveDifference(uint256[] memory a, uint256[] memory b)
35         internal
36         pure
37         returns (uint256[] memory _positiveDifference)
38     {
39         require(a.length == b.length, "Arrays must be the same length");
40 
41         _positiveDifference = new uint256[](a.length);
42 
43         for (uint256 i = 0; i < a.length; i++) {
44             if (a[i] > b[i]) {
45                 _positiveDifference[i] = a[i] - b[i];
46             }
47         }
48 
49         return _positiveDifference;
50     }
51 }
