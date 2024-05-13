1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./MockOracleCoreRef.sol";
5 
6 contract MockCollateralizationOracle is MockOracleCoreRef {
7     uint256 public userCirculatingFei = 1e20;
8 
9     uint256 public pcvValue = 5e20;
10 
11     constructor(address core, uint256 exchangeRate) MockOracleCoreRef(core, exchangeRate) {}
12 
13     function set(uint256 _userCirculatingFei, uint256 _pcvValue) public {
14         userCirculatingFei = _userCirculatingFei;
15         pcvValue = _pcvValue;
16     }
17 
18     function isOvercollateralized() public view returns (bool) {
19         return pcvEquityValue() > 0;
20     }
21 
22     function pcvEquityValue() public view returns (int256) {
23         return int256(pcvValue) - int256(userCirculatingFei);
24     }
25 
26     function pcvStats()
27         public
28         view
29         returns (
30             uint256,
31             uint256,
32             int256,
33             bool
34         )
35     {
36         return (pcvValue, userCirculatingFei, pcvEquityValue(), valid);
37     }
38 }
