1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
4 
5 contract ExternalFunctionMock {
6     using BoringMath for uint256;
7 
8     event Result(uint256 output);
9 
10     function sum(uint256 a, uint256 b) external returns (uint256 c) {
11         c = a.add(b);
12         emit Result(c);
13     }
14 }
