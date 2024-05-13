1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 /// @title Permissions Read interface
5 /// @author Fei Protocol
6 interface IPermissionsRead {
7     // ----------- Getters -----------
8 
9     function isBurner(address _address) external view returns (bool);
10 
11     function isMinter(address _address) external view returns (bool);
12 
13     function isGovernor(address _address) external view returns (bool);
14 
15     function isGuardian(address _address) external view returns (bool);
16 
17     function isPCVController(address _address) external view returns (bool);
18 }
