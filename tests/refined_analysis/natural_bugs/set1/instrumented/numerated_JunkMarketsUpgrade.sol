1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../BaseLogic.sol";
6 
7 
8 contract JunkMarketsUpgrade is BaseLogic {
9     constructor() BaseLogic(MODULEID__MARKETS, bytes32(uint(0x1234))) {}
10 
11     function getEnteredMarkets(address) external pure returns (address[] memory output) {
12         output;
13         require(false, "JUNK_UPGRADE_TEST_FAILURE");
14     }
15 }
