1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 pragma experimental ABIEncoderV2;
4 import "../BentoBoxFlat.sol";
5 
6 contract BentoBoxMock is BentoBoxV1 {
7     constructor(IERC20 weth) public BentoBoxV1(weth) {
8         return;
9     }
10 
11     function addProfit(IERC20 token, uint256 amount) public {
12         token.safeTransferFrom(msg.sender, address(this), amount);
13         totals[token].addElastic(amount);
14     }
15 }
