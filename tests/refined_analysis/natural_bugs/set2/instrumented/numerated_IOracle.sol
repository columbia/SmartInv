1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../external/Decimal.sol";
5 
6 /// @title generic oracle interface for Fei Protocol
7 /// @author Fei Protocol
8 interface IOracle {
9     // ----------- Events -----------
10 
11     event Update(uint256 _peg);
12 
13     // ----------- State changing API -----------
14 
15     function update() external;
16 
17     // ----------- Getters -----------
18 
19     function read() external view returns (Decimal.D256 memory, bool);
20 
21     function isOutdated() external view returns (bool);
22 }
