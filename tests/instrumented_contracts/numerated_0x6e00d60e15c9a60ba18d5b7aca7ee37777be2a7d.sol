1 pragma solidity ^0.4.19;
2 
3 contract TestToken {
4     
5     mapping (address => uint) public balanceOf;
6     
7     function () public payable {
8         
9         balanceOf[msg.sender] = msg.value;
10         
11     }
12     
13 }