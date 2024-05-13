1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../IOracle.sol";
5 
6 /// @title Collateralization ratio oracle interface for Fei Protocol
7 /// @author Fei Protocol
8 interface ICollateralizationOracle is IOracle {
9     // ----------- Getters -----------
10 
11     // returns the PCV value, User-circulating FEI, and Protocol Equity, as well
12     // as a validity status.
13     function pcvStats()
14         external
15         view
16         returns (
17             uint256 protocolControlledValue,
18             uint256 userCirculatingFei,
19             int256 protocolEquity,
20             bool validityStatus
21         );
22 
23     // true if Protocol Equity > 0
24     function isOvercollateralized() external view returns (bool);
25 }
