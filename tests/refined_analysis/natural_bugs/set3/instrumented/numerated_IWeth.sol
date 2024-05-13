1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 interface IWeth {
5     function deposit() external payable;
6 
7     function approve(address _who, uint256 _wad) external;
8 }
