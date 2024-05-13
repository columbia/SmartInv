1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./MockEthPCVDeposit.sol";
5 
6 contract MockEthUniswapPCVDeposit is MockEthPCVDeposit {
7     address public pair;
8 
9     constructor(address _pair) MockEthPCVDeposit(payable(this)) {
10         pair = _pair;
11     }
12 }
