1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@openzeppelin/contracts/math/SafeMath.sol";
6 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
7 import "../SwapUtils.sol";
8 
9 /**
10  * @title PermissionlessSwapUtils library
11  * @notice A library to be used within Swap.sol. Contains functions responsible for custody and AMM functionalities.
12  * @dev Contracts relying on this library must initialize SwapUtils.Swap struct then use this library
13  * for SwapUtils.Swap struct. Note that this library contains both functions called by users and admins.
14  * Admin functions should be protected within contracts using this library.
15  */
16 library PermissionlessSwapUtils {
17     using SafeERC20 for IERC20;
18     using SafeMath for uint256;
19 
20     /**
21      * @notice Withdraw all admin fees to two addresses evenly
22      * @param self Swap struct to withdraw fees from
23      * @param creator Address to send hald of the fees to. For the creator of the community pool.
24      * @param protocol Address to send the half of the fees to. For the protocol fee collection.
25      */
26     function withdrawAdminFees(
27         SwapUtils.Swap storage self,
28         address creator,
29         address protocol
30     ) internal {
31         IERC20[] memory pooledTokens = self.pooledTokens;
32         for (uint256 i = 0; i < pooledTokens.length; i++) {
33             IERC20 token = pooledTokens[i];
34             uint256 balance = token.balanceOf(address(this)).sub(
35                 self.balances[i]
36             ) / 2;
37             if (balance != 0) {
38                 token.safeTransfer(creator, balance);
39                 token.safeTransfer(protocol, balance);
40             }
41         }
42     }
43 }
