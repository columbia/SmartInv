1 pragma solidity ^0.4.16;
2 
3 contract AnyChicken {
4 
5     address public owner;
6 	address public bigChicken;
7 	uint public bigAmount;
8 	uint public lastBlock;
9 	
10 	function AnyChicken() public payable {
11 		owner = msg.sender;
12 		bigChicken = msg.sender;
13 		bigAmount = msg.value;
14 		lastBlock = block.number;
15 	}
16 	
17 	function () public payable {
18 		if (block.number <= lastBlock + 1000) {
19 			require(msg.value > bigAmount);
20 			bigChicken = msg.sender;
21 			bigAmount = msg.value;
22 			lastBlock = block.number;
23 			owner.transfer(msg.value/100);
24 		}
25 		else {
26 			require(msg.sender == bigChicken);
27 			bigChicken.transfer(this.balance);
28 		}
29 	}
30 }