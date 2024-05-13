1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IRateCalculator {
5     
6     function name() external pure returns (string memory);
7 
8     function requireValidInitData(bytes calldata _initData) external pure;
9 
10     function getConstants() external pure returns (bytes memory _calldata);
11 
12     function getNewRate(bytes calldata _data, bytes calldata _initData) external pure returns (uint64 _newRatePerSec);
13 }