1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IGMXRouter {
5 
6     function swap(address[] memory _path, uint256 _amountIn, uint256 _minOut, address _receiver) external;
7 }