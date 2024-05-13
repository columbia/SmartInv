1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 contract MockPCVSwapper {
5     bool public swapped;
6 
7     function swap() public {
8         swapped = true;
9     }
10 }
