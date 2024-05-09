1 pragma solidity ^0.4.11;
2  
3 contract admined {
4 	address public admin;
5 
6 	function admined() public{
7 		admin = msg.sender; //The address of the person who deploys the contract
8 	}
9 
10 	modifier onlyAdmin(){ //The function that uses this modifier can only be executed by the admin
11 		require(msg.sender == admin);
12 		_;
13 	}
14 
15 	function transferAdminship(address newAdmin) onlyAdmin public { //This function can be only called by the admin and assigns a new admin
16 		admin = newAdmin;
17 	}
18 
19 }
20 
21 contract Token {
22 
23 	mapping (address => uint256) public balanceOf;
24 	// balanceOf[address] = 5;
25 	string public name;
26 	string public symbol; //Example: ETH
27 	uint8 public decimals; //Example 18. This is going to be the smallest unit of the coin. And the code is based on this unit.  When you say an address has a balance equal to 1. Then the real balance is 10**-18 of the coin. to represent a balance of 1 coin, then that is 10**18 of the smallest unit in code
28 	uint256 public totalSupply; //Total supply including the number of decimals. ex: 1000 coins are 1000*(10 ** decimals) where decimals = 18
29 	event Transfer(address indexed from, address indexed to, uint256 value); //Defining an event which is triggered when is called and can be catch to the outside world through a library like Web3
30 
31 
32 	function Token(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public{ //The constructor. The initializer of contract. Only called once
33 		balanceOf[msg.sender] = initialSupply; //msg.sender is the address of the one who deployed the contract. That address will have all the inital supply  
34 		totalSupply = initialSupply; //The total supply is the inital supply
35 		decimals = decimalUnits; //set the decimals
36 		symbol = tokenSymbol; //set the simbo
37 		name = tokenName; //Set the name of the token
38 	}
39 
40 	function transfer(address _to, uint256 _value) public{ //The function to transfer. Can be called by anyone. 
41 		require(balanceOf[msg.sender] >= _value); //If the address doesn't have enough balance, the function won't be executed
42 		require(balanceOf[_to] + _value >= balanceOf[_to]); //Check for overflow errors
43 		balanceOf[msg.sender] -= _value; //Substract the amount to send from the sender address
44 		balanceOf[_to] += _value; //Add the amount to send to the receiver address
45 		Transfer(msg.sender, _to, _value); //Tell the outside world that a transaction took place
46 	}
47 
48 }
49 
50 contract EcoCrypto is admined, Token{ //The main contract. The token which will inherit from the other two contracts. ie this contract will have already defined the functions defined in the previous contracts
51 
52 	function EcoCrypto() public  //initializer
53 	  Token (10000000000000000000, "EcoCrypto", "ECO", 8 ){ //calles the constructor/initializer of the contract called taken
54 		
55 	}
56 
57 	function transfer(address _to, uint256 _value) public{ //The main function.  It was already defined by the contract called token. Since we're defining a function with the same name transfer, we're overriding it
58 		require(balanceOf[msg.sender] > 0);
59 		require(balanceOf[msg.sender] >= _value);
60 		require(balanceOf[_to] + _value >= balanceOf[_to]);
61 		//if(admin)
62 		balanceOf[msg.sender] -= _value;
63 		balanceOf[_to] += _value;
64 		Transfer(msg.sender, _to, _value);
65 	}
66 
67 }