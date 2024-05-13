1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IGlpManager {
5 
6     function getPrice(bool _maximise) external view returns (uint256);
7 }