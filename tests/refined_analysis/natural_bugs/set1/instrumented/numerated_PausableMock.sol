1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '@openzeppelin/contracts/security/Pausable.sol';
10 
11 contract PausableMock is Pausable {
12   function pause() external {
13     _pause();
14   }
15 
16   function unpause() external {
17     _unpause();
18   }
19 }
