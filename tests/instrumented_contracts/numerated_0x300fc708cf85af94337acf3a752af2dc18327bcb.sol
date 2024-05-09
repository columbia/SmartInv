1 pragma solidity ^0.4.25;
2 
3 contract Repo {
4     function() public payable {}
5     address Owner;
6     function setOwner(address X) public { if (Owner==0) Owner = X; }
7     function setup(uint256 openDate) public payable {
8         if (msg.value >= 1 ether) {
9             open = openDate;
10         }
11     }
12     uint256 open;
13     function close() public {
14         if (msg.sender==Owner && now>=open) {
15             selfdestruct(msg.sender);
16         }
17     }
18 }