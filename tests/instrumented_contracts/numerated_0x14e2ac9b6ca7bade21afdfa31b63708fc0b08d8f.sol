1 /**
2  *	Made by X-cessive Overlord of Acmeme.biz.
3  *	Gamble responsibly.
4  */
5 
6 pragma solidity ^0.4.18;
7 
8 contract KingOfTheHill {
9 
10 	uint public timeLimit = 1 hours;
11 	uint public lastKing;
12 	address public owner;
13 	address public currentKing;
14 	address[] public previousEntries;
15 
16 	event NewKing(address indexed newKing, uint timestamp);
17 	event Winner(address indexed winner, uint winnings);
18 	
19 	function KingOfTheHill() public {
20 		owner = msg.sender;
21 	}
22 
23 	function seed() external payable {
24 		require(msg.sender == owner);
25 		lastKing = block.timestamp;
26 	}
27 
28 	function () external payable {
29 		require(msg.value == 0.1 ether);
30 		if ((lastKing + timeLimit) < block.timestamp) {
31 			winner();
32 		}
33 		previousEntries.push(currentKing);
34 		lastKing = block.timestamp;
35 		currentKing = msg.sender;
36 		NewKing(currentKing, lastKing);
37 	}
38 
39 	function winner() internal {
40 		uint winnings = this.balance - 0.1 ether;
41 		currentKing.transfer(winnings);
42 		Winner(currentKing, winnings);
43 	}
44 
45 	function numberOfPreviousEntries() constant external returns (uint) {
46 		return previousEntries.length;
47 	}
48 
49 }