1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 
4 import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
5 
6 contract MockERC20 is ERC20 {
7     constructor(address recipient, uint256 amount) ERC20("MockERC20", "MockERC20") {
8         ERC20._mint(recipient, amount);
9     }
10 }
