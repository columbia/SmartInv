1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 /// @title IPCVSentinel
5 /// @notice an interface for defining how the PCVSentinel functions
6 /// @dev any implementation of this contract should be granted the Guardian role
7 interface IPCVSentinel {
8     // ---------- Events ----------
9     event Protected(address indexed guard);
10     event GuardAdded(address indexed guard);
11     event GuardRemoved(address indexed guard);
12 
13     // ---------- Public Read-Only API ----------
14     function isGuard(address guard) external view returns (bool);
15 
16     function allGuards() external view returns (address[] memory all);
17 
18     // ---------- Governor-Or-Admin-Or-Guardian-Only State-Changing API ----------
19     function knight(address guard) external;
20 
21     function slay(address traitor) external;
22 
23     // ---------- Public State-Changing API ----------
24     function protec(address guard) external;
25 }
