1 pragma solidity ^0.4.11;
2 
3 contract Freewatch {
4 	string public name;
5 	string public symbol;
6 	uint8 public decimals;
7 	
8     /* Creates an array with all balances */
9     mapping (address => uint256) public balanceOf;
10 	
11 	event Transfer(address indexed from, address indexed to, uint256 value);
12 	
13 	/* Initializes contract with initial supply tokens to the creator of the contract */
14 	function Freewatch (
15 		uint256 initialSupply,
16 		string tokenName,
17 		uint8 decimalUnits,
18 		string tokenSymbol
19 		) {
20 		balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
21 		name = tokenName;                                   // Set the name for display purposes
22 		symbol = tokenSymbol;                               // Set the symbol for display purposes
23 		decimals = decimalUnits;                            // Amount of decimals for display purposes
24 }
25 	
26 	/* Send coins */
27 	function transfer(address _to, uint256 _value) {
28 		if(msg.data.length < (2 * 32) + 4) { revert(); }
29 		/* Check if sender has balance and for overflows */
30 		if (balanceOf[msg.sender] < _value || balanceOf[_to] + _value < balanceOf[_to])
31 			revert();
32 		/* Add and subtract new balances */
33 		balanceOf[msg.sender] -= _value;
34 		balanceOf[_to] += _value;
35 			/* Notify anyone listening that this transfer took place */
36 		Transfer(msg.sender, _to, _value);
37 		}
38 }