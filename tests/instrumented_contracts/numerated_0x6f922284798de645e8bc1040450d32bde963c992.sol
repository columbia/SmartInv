1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.1;
3 
4 /**
5  * @title DebankL2Register
6  */
7 
8 contract DebankL2Register {
9 
10     mapping(address => uint256) public nonces;
11     mapping(address => string) public l2Accounts;
12 
13     event Register(address user, string l2Account, uint256 registerCnt);
14 
15     function register(string calldata l2Account) public {
16         l2Accounts[msg.sender] = l2Account;
17         nonces[msg.sender] += 1;
18         emit Register(msg.sender, l2Account, nonces[msg.sender]);
19     }
20 }