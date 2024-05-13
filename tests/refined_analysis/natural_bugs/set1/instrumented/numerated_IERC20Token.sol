1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.8.9;
3 
4 import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 
6 abstract contract IERC20Token is IERC20 {
7     function upgrade(uint256 value) public virtual;
8 }
