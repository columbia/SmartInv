1 pragma solidity ^0.4.22;
2 
3 contract Uturn {
4     function() public payable {
5         msg.sender.transfer(msg.value);
6     }
7 }