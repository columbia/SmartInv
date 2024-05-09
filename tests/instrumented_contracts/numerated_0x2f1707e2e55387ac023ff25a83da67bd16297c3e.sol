1 pragma solidity ^0.4.1;
2 
3 contract EtherLovers {
4 
5   event LoversAdded(string lover1, string lover2);
6 
7   uint constant requiredFee = 100 finney;
8 
9   address private owner;
10 
11   function EtherLovers() public {
12     owner = msg.sender;
13   }
14 
15   modifier isOwner() { 
16     if (msg.sender != owner) {
17       throw;       
18     }
19     _;
20   }
21 
22   function declareLove(string lover1, string lover2) public payable {
23     if (msg.value >= requiredFee) {
24       LoversAdded(lover1, lover2);
25     } else {
26       throw;
27     }
28   }
29 
30   function collectFees() public isOwner() {
31     msg.sender.send(this.balance);
32   }
33 
34 }