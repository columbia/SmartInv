1 pragma solidity ^0.4.19;
2 
3 contract NHGame{
4 	uint public curMax=0;
5 	address public argCurMax = msg.sender;
6 	uint public solveTime=2**256-1;
7 	address owner = msg.sender;
8 	uint public stake=0;
9 	uint numberOfGames=0;
10 	    
11 	function setNewValue() public payable{
12 		require (msg.value > curMax);
13 		require (block.number<solveTime);
14 		curMax=msg.value;
15 		stake+=msg.value;
16 		argCurMax=msg.sender;
17 		solveTime=block.number+40320;
18 	}
19     
20 	function withdraw() public{
21 		if ((msg.sender == owner)&&(curMax>0)&&(block.number>solveTime)){
22 			uint tosend=stake*95/100;
23 			uint tokeep=this.balance-tosend;
24 			address sendToAdd=argCurMax;
25 			argCurMax = owner;
26 			curMax=0;
27 			stake=0;
28 			solveTime=2**256-1;
29 			numberOfGames++;
30 			owner.transfer(tokeep);
31 			sendToAdd.transfer(tosend);
32 		}
33 	}
34 }