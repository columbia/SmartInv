1 pragma solidity ^0.4.25;
2 
3 contract Hodls {
4     function() public payable {}
5     function setOwner() { if (Owner==0) Owner = msg.sender; }
6     address Owner;
7     function setup(uint256 futureDate) public payable {
8         if (msg.value >= 1 ether) {
9             openDate = futureDate;
10         }
11     }
12     uint256 openDate;
13     function close() {
14         if (msg.sender==Owner && now >= openDate) {
15             selfdestruct(msg.sender);
16         }
17     }
18  }