1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '../managers/Manager.sol';
10 
11 contract AllowanceErrorTest is Manager {
12   using SafeERC20 for IERC20;
13 
14   constructor(IERC20 _token) {
15     _token.safeIncreaseAllowance(address(0x1), 1);
16     _token.safeIncreaseAllowance(address(0x1), type(uint256).max);
17   }
18 }
