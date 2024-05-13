1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./../utils/GlobalRateLimitedMinter.sol";
5 
6 contract MockMinter {
7     GlobalRateLimitedMinter globalRateLimitedMinter;
8 
9     constructor(GlobalRateLimitedMinter _globalRateLimitedMinter) {
10         globalRateLimitedMinter = _globalRateLimitedMinter;
11     }
12 
13     function mint(address to, uint256 amount) external {
14         globalRateLimitedMinter.mint(to, amount);
15     }
16 
17     function mintAllFei(address to) external {
18         globalRateLimitedMinter.mintMaxAllowableFei(to);
19     }
20 }
