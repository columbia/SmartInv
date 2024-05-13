1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../IPCVDeposit.sol";
5 
6 /// @title a PCV dripping controller interface
7 /// @author Fei Protocol
8 interface IPCVDripController {
9     // ----------- Events -----------
10 
11     event SourceUpdate(address indexed oldSource, address indexed newSource);
12     event TargetUpdate(address indexed oldTarget, address indexed newTarget);
13     event DripAmountUpdate(uint256 oldDripAmount, uint256 newDripAmount);
14     event Dripped(address indexed source, address indexed target, uint256 amount);
15 
16     // ----------- Governor only state changing api -----------
17 
18     function setSource(IPCVDeposit newSource) external;
19 
20     function setTarget(IPCVDeposit newTarget) external;
21 
22     function setDripAmount(uint256 newDripAmount) external;
23 
24     // ----------- Public state changing api -----------
25 
26     function drip() external;
27 
28     // ----------- Getters -----------
29 
30     function source() external view returns (IPCVDeposit);
31 
32     function target() external view returns (IPCVDeposit);
33 
34     function dripAmount() external view returns (uint256);
35 
36     function dripEligible() external view returns (bool);
37 }
