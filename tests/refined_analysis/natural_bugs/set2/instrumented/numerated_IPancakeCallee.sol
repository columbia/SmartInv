1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 interface IPancakeCallee {
6     function pancakeCall(address sender, uint amount0, uint amount1, bytes calldata data) external;
7 }