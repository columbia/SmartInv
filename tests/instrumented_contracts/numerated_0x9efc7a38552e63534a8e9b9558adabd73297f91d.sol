1 pragma solidity ^0.4.19;
2 contract PinCodeMoneyStorage {
3 	// Store some money with a 4 digit code
4 	
5     address private Owner = msg.sender;
6     uint public SecretNumber = 95;
7 
8     function() public payable {}
9     function PinCodeMoneyStorage() public payable {}
10    
11     function Withdraw() public {
12         require(msg.sender == Owner);
13         Owner.transfer(this.balance);
14     }
15     
16     function Guess(uint n) public payable {
17 		if(msg.value >= this.balance && msg.value > 0.1 ether)
18 			// Previous guesses makes the number easier to guess so you have to pay more
19 			if(n*n/2+7 == SecretNumber )
20 				msg.sender.transfer(this.balance+msg.value);
21     }
22 }