1 pragma solidity ^0.4.20;
2 
3 contract dubbel {
4     address public previousSender;
5     uint public price = 0.001 ether;
6     
7     function() public payable {
8             require(msg.value == price);
9             previousSender.transfer(msg.value);
10             price *= 2;
11             previousSender = msg.sender;
12     }
13 }