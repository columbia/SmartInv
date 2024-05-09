1 pragma solidity ^0.4.24;
2 
3 contract MultiSender {
4     function multiSend(uint256 amount, address[] addresses) public returns (bool) {
5         for (uint i = 0; i < addresses.length; i++) {
6             addresses[i].transfer(amount);
7         }
8     }
9 
10     function () public payable {
11         
12     }
13 }