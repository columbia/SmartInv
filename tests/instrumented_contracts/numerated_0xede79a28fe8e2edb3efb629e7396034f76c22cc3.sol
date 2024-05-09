1 pragma solidity ^0.4.18;
2 
3 // Free money. No bamboozle.
4 // By NR
5 contract FreeMoney {
6     
7     uint public remaining;
8     
9     function FreeMoney() public payable {
10         remaining += msg.value;
11     }
12     
13     // Feel free to give money to whomever
14     function() payable {
15         remaining += msg.value;
16     }
17     
18     // You're welcome?!
19     function withdraw() public {
20         remaining = 0;
21         msg.sender.transfer(this.balance);
22     }
23 }