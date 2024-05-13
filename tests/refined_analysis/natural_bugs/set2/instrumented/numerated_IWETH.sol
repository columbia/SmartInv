1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 interface IWETH {
6     function deposit() external payable;
7     function transfer(address to, uint value) external returns (bool);
8     function withdraw(uint) external;
9 }