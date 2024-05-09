1 pragma solidity ^0.4.13;
2 contract Token {
3     
4 	/* Public variables of the token */
5 	string public name;
6 	string public symbol;
7 	uint8 public decimals;
8 	uint256 public totalSupply;
9     
10 	/* This creates an array with all balances */
11 	mapping (address => uint256) public balanceOf;
12 
13 	/* This generates a public event on the blockchain that will notify clients */
14 	event Transfer(address indexed from, address indexed to, uint256 value);
15 
16 	function Token() {
17 	    totalSupply = 8400*(10**4)*(10**18);
18 		balanceOf[msg.sender] = 8400*(10**4)*(10**18);              // Give the creator all initial tokens
19 		name = "EthereumCryptoKitties";                                   // Set the name for display purposes
20 		symbol = "ETHCK";                               // Set the symbol for display purposes
21 		decimals = 18;                            // Amount of decimals for display purposes
22 	}
23 
24 	function transfer(address _to, uint256 _value) {
25 	/* Check if sender has balance and for overflows */
26 	if (balanceOf[msg.sender] < _value || balanceOf[_to] + _value < balanceOf[_to])
27 		revert();
28 	/* Add and subtract new balances */
29 	balanceOf[msg.sender] -= _value;
30 	balanceOf[_to] += _value;
31 	/* Notifiy anyone listening that this transfer took place */
32 	Transfer(msg.sender, _to, _value);
33 	}
34 
35 	/* This unnamed function is called whenever someone tries to send ether to it */
36 	function () {
37 	revert();     // Prevents accidental sending of ether
38 	}
39 }