1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 /// @title incentive contract interface
5 /// @author Fei Protocol
6 /// @notice Called by FEI token contract when transferring with an incentivized address
7 /// @dev should be appointed as a Minter or Burner as needed
8 interface IIncentive {
9     // ----------- Fei only state changing api -----------
10 
11     /// @notice apply incentives on transfer
12     /// @param sender the sender address of the FEI
13     /// @param receiver the receiver address of the FEI
14     /// @param operator the operator (msg.sender) of the transfer
15     /// @param amount the amount of FEI transferred
16     function incentivize(
17         address sender,
18         address receiver,
19         address operator,
20         uint256 amount
21     ) external;
22 }
