1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.7.6;
3 
4 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 
6 interface IERC20Detailed is IERC20 {
7     function name() external view returns (string memory);
8 
9     function symbol() external view returns (string memory);
10 
11     function decimals() external view returns (uint8);
12 }
