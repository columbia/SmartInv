1 pragma solidity ^0.4.0;
2 
3 
4 contract testing {
5   mapping (address => uint256) public balanceOf;
6   event Transfer(address indexed from, address indexed to, uint256 value);
7   event LogB(bytes32 h);
8 
9 	  
10   	function buy() payable returns (uint amount){
11         amount = msg.value ;                     // calculates the amount
12         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
13         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
14         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
15         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
16         return amount;                                     // ends function and returns
17     }
18 	  
19 
20 }