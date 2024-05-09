1 pragma solidity ^0.4.24;
2 
3 contract ZhenNet {
4   event ZhenData(address _a, address _b, bytes32 s1, bytes32 s2, bytes32 s3, bytes32 s4,
5     bytes32 s5, bytes32 s6, bytes32 s7, bytes32 s8);
6   function store(address _a, address _b, bytes32 s1, bytes32 s2, bytes32 s3, bytes32 s4,
7     bytes32 s5, bytes32 s6, bytes32 s7, bytes32 s8) {
8     emit ZhenData(_a, _b, s1, s2, s3, s4, s5, s6, s7, s8);
9   } 
10 }