1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 
4 interface IFactory {
5     function create(bytes calldata args) external returns (address instance);
6 
7     function create2(bytes calldata args, bytes32 salt) external returns (address instance);
8 }
