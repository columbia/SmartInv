1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 /// @title a PCV Deposit interface for only balance getters
5 /// @author Fei Protocol
6 interface IPCVDepositBalances {
7     // ----------- Getters -----------
8 
9     /// @notice gets the effective balance of "balanceReportedIn" token if the deposit were fully withdrawn
10     function balance() external view returns (uint256);
11 
12     /// @notice gets the token address in which this deposit returns its balance
13     function balanceReportedIn() external view returns (address);
14 
15     /// @notice gets the resistant token balance and protocol owned fei of this deposit
16     function resistantBalanceAndFei() external view returns (uint256, uint256);
17 }
