1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { MathEx } from "../utility/MathEx.sol";
5 
6 contract TestMathEx {
7     function mulDivF(uint256 x, uint256 y, uint256 z) external pure returns (uint256) {
8         return MathEx.mulDivF(x, y, z);
9     }
10 
11     function mulDivC(uint256 x, uint256 y, uint256 z) external pure returns (uint256) {
12         return MathEx.mulDivC(x, y, z);
13     }
14 }
