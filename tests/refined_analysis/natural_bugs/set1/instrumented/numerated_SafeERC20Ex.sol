1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
6 
7 /**
8  * @dev extends the SafeERC20 library with additional operations
9  */
10 library SafeERC20Ex {
11     using SafeERC20 for IERC20;
12 
13     /**
14      * @dev ensures that the spender has sufficient allowance
15      */
16     function ensureApprove(IERC20 token, address spender, uint256 amount) internal {
17         if (amount == 0) {
18             return;
19         }
20 
21         uint256 allowance = token.allowance(address(this), spender);
22         if (allowance >= amount) {
23             return;
24         }
25 
26         if (allowance > 0) {
27             token.safeApprove(spender, 0);
28         }
29         token.safeApprove(spender, amount);
30     }
31 }
