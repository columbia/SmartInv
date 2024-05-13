1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 interface ISherClaim {
10   error InvalidAmount();
11   error ZeroArgument();
12   error InvalidState();
13 
14   // Event emitted when tokens have been added to the timelock
15   event Add(address indexed sender, address indexed account, uint256 amount);
16   // Event emitted when tokens have been claimed
17   event Claim(address indexed account, uint256 amount);
18 
19   function add(address _user, uint256 _amount) external;
20 
21   function newEntryDeadline() external view returns (uint256);
22 }
