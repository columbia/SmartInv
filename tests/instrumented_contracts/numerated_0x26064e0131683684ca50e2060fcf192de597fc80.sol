1 pragma solidity ^0.4.23;
2 
3 contract Halfer{
4     address owner; 
5     constructor() public {
6         owner = msg.sender;
7     }
8     
9     function() public payable{
10         owner.transfer(msg.value/2);
11         msg.sender.transfer(address(this).balance);
12     }
13 }