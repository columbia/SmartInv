1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 contract MockAnglePoolManager {
5     address public token;
6 
7     constructor(address _token) {
8         token = _token;
9     }
10 }
