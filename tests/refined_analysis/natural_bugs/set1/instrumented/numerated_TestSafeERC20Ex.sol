1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 
6 import { SafeERC20Ex } from "../token/SafeERC20Ex.sol";
7 
8 contract TestSafeERC20Ex {
9     using SafeERC20Ex for IERC20;
10 
11     function ensureApprove(IERC20 token, address spender, uint256 amount) external {
12         token.ensureApprove(spender, amount);
13     }
14 }
