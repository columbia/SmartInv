1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import './managers/IStrategyManager.sol';
10 
11 /// @title Sherlock core interface for yield strategy
12 /// @author Evert Kors
13 interface ISherlockStrategy {
14   /// @notice Deposit `_amount` into active strategy
15   /// @param _amount Amount of tokens
16   /// @dev gov only
17   function yieldStrategyDeposit(uint256 _amount) external;
18 
19   /// @notice Withdraw `_amount` from active strategy
20   /// @param _amount Amount of tokens
21   /// @dev gov only
22   function yieldStrategyWithdraw(uint256 _amount) external;
23 
24   /// @notice Withdraw all funds from active strategy
25   /// @dev gov only
26   function yieldStrategyWithdrawAll() external;
27 }
