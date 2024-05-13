1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 interface ITribe {
5     function mint(address to, uint256 amount) external;
6 }
7 
8 contract MockTribeMinter {
9     ITribe public tribe;
10 
11     constructor(ITribe _tribe) {
12         tribe = _tribe;
13     }
14 
15     function mint(address to, uint256 amount) external {
16         tribe.mint(to, amount);
17     }
18 }
