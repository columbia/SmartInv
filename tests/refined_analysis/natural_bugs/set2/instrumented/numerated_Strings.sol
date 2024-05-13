1 //SPDX-License-Identifier: Unlicensed
2 pragma solidity >=0.7.5;
3 
4 library Strings {
5     function appendString(string memory str1, string memory str2) public pure returns (string memory result) {
6         return string(abi.encodePacked(str1,str2));
7     }
8     function appendNumber(string memory str, uint i) public pure returns (string memory result) {
9         return string(abi.encodePacked(str,i+uint(48)));
10     }
11 }
