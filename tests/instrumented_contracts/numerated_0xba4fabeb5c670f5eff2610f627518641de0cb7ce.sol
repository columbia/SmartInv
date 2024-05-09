1 pragma solidity ^0.4.24;
2 
3 contract DonateDust {
4 
5 	address public owner;
6 	uint256 public totalDonations;
7 
8 	constructor() {
9 		owner = msg.sender;
10 	}
11 
12 	modifier onlyOwner { 
13 		require (msg.sender == owner); 
14 		_; 
15 	}
16 	
17 	function donate() public payable {
18 		totalDonations += msg.value;
19 	}
20 
21 	function withdraw() public onlyOwner {
22 		owner.transfer(address(this).balance);
23 	}
24 	
25 	function() public payable {
26 		donate();
27 	}
28 }