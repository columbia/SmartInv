1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.5.0;
4 
5 interface IBabyCallee {
6     function babyCall(address sender, uint amount0, uint amount1, bytes calldata data) external;
7 }
