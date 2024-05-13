1 // SPDX-License-Identifier: MIT
2 pragma experimental ABIEncoderV2;
3 pragma solidity =0.7.6;
4 
5 interface ILegacySilo {
6     function lpDeposit(address account, uint32 id) external view returns (uint256, uint256);
7     function beanDeposit(address account, uint32 id) external view returns (uint256);
8 }