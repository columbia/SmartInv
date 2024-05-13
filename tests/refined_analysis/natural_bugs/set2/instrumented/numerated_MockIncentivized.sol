1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../refs/CoreRef.sol";
5 
6 contract MockIncentivized is CoreRef {
7     constructor(address core) CoreRef(core) {}
8 
9     function sendFei(address to, uint256 amount) public {
10         fei().transfer(to, amount);
11     }
12 
13     function approve(address account) public {
14         fei().approve(account, type(uint256).max);
15     }
16 
17     function sendFeiFrom(
18         address from,
19         address to,
20         uint256 amount
21     ) public {
22         fei().transferFrom(from, to, amount);
23     }
24 }
