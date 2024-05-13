1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./MockERC20.sol";
5 
6 contract MockWeth is MockERC20 {
7     constructor() {}
8 
9     function deposit() external payable {
10         mint(msg.sender, msg.value);
11     }
12 
13     function withdraw(uint256 amount) external payable {
14         _burn(msg.sender, amount);
15         payable(msg.sender).transfer(amount);
16     }
17 }
