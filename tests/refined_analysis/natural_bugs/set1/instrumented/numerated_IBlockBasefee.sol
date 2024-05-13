1 // SPDX-License-Identifier: MIT
2 pragma experimental ABIEncoderV2;
3 pragma solidity =0.7.6;
4 
5 interface IBlockBasefee {
6     // Returns the base fee of this block in wei
7     function block_basefee() external view returns (uint256);
8 }