1 pragma solidity ^0.4.0;
2 contract BCMtest{
3 	/*public variables of the token*/
4 	string public standard="Token 0.1";
5 	string public name;
6 	string public symbol;
7 	uint8 public decimals;
8 	uint256 public initialSupply;
9 	uint256 public totalSupply;
10 	
11 	/*This creates an array with all balances*/
12 	mapping(address => uint256) public balanceOf;
13 	mapping(address => mapping(address => uint256)) public allowance;
14 	
15 	/*Initializes contract with initial supply tokens to the creator of the contract*/
16 	
17 	function BCMtest(){
18 	
19 		initialSupply=1000000;
20 		name= "bcmtest";
21 		decimals=0;
22 		symbol="B";
23 		
24 		balanceOf[msg.sender] = initialSupply;
25 		totalSupply = initialSupply;
26 		
27 		
28 	}
29 	/*Send Coins*/
30 	
31 	function transfer(address _to, uint256 _value){
32 		if(balanceOf[msg.sender]<_value) throw;
33 		if(balanceOf[_to]+_value<balanceOf[_to]) throw; 
34 		balanceOf[msg.sender]-=_value;
35 		balanceOf[_to]+=_value;
36 		
37 	}
38 	
39 	/*This unnamed function is called whenever someone tries to send ether to it*/
40 	function(){
41 		throw; //Prevent accidental sending of ether
42 		
43 	}
44 }