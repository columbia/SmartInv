1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../BaseLogic.sol";
6 
7 
8 contract JunkETokenUpgrade is BaseLogic {
9     constructor() BaseLogic(MODULEID__ETOKEN, bytes32(0)) {}
10 
11     function name() external pure returns (string memory) {
12         return "JUNK_UPGRADE_NAME";
13     }
14 }
