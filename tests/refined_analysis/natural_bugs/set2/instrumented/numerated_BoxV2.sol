1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8;
4 
5 contract BoxV2 {
6     uint256 private value;
7 
8     event ValueChanged(uint256 newValue);
9 
10     function store(uint256 newValue) public {
11         value = newValue;
12         emit ValueChanged(value);
13     }
14 
15     function retrieve() public view returns (uint256) {
16         return value;
17     }
18 
19     function increment() public {
20         value = value + 1;
21         emit ValueChanged(value);
22     }
23 }
