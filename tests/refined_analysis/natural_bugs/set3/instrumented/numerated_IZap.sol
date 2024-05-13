1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 interface IZap {
5     function zapOut(address _from, uint amount) external;
6     function zapIn(address _to) external payable;
7     function zapInToken(address _from, uint amount, address _to) external;
8 }