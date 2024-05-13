1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 contract ForceEth {
5     constructor() payable {}
6 
7     receive() external payable {}
8 
9     function forceEth(address to) public {
10         selfdestruct(payable(to));
11     }
12 }
