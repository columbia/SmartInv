1 pragma solidity ^0.4.2;
2 contract owned {
3 	address public owner;
4 	function owned() {
5 		owner = msg.sender;
6 	}
7 	function changeOwner(address newOwner) onlyowner {
8 		owner = newOwner;
9 	}
10 	modifier onlyowner() {
11 		if (msg.sender==owner) _;
12 	}
13 }
14 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
15 contract CSToken is owned {
16 	/* Public variables of the token */
17 	string public standard = 'Token 0.1';
18 	string public name;
19 	string public symbol;
20 	uint8 public decimals;
21 	uint256 public totalSupply;
22 	/* This creates an array with all balances */
23 	mapping (address => uint256) public balanceOf;
24 	mapping (address => mapping (address => uint256)) public allowance;
25 	/* This generates a public event on the blockchain that will notify clients */
26 	event Transfer(address indexed from, address indexed to, uint256 value);
27 	/* Initializes contract with initial supply tokens to the creator of the contract */
28 	function CSToken(
29 	uint256 initialSupply,
30 	string tokenName,
31 	uint8 decimalUnits,
32 	string tokenSymbol
33 	) {
34 		owner = msg.sender;
35 		balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
36 		totalSupply = initialSupply;                        // Update total supply
37 		name = tokenName;                                   // Set the name for display purposes
38 		symbol = tokenSymbol;                               // Set the symbol for display purposes
39 		decimals = decimalUnits;                            // Amount of decimals for display purposes
40 	}
41 	/* Send coins */
42 	function transfer(address _to, uint256 _value) {
43 		if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
44 		if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
45 		balanceOf[msg.sender] -= _value;                     // Subtract from the sender
46 		balanceOf[_to] += _value;                            // Add the same to the recipient
47 		Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
48 	}
49 	function mintToken(address target, uint256 mintedAmount) onlyowner {
50 		balanceOf[target] += mintedAmount;
51 		totalSupply += mintedAmount;
52 		Transfer(0, owner, mintedAmount);
53 		Transfer(owner, target, mintedAmount);
54 	}
55 	/* Allow another contract to spend some tokens in your behalf */
56 	function approve(address _spender, uint256 _value)
57 	returns (bool success) {
58 		allowance[msg.sender][_spender] = _value;
59 		return true;
60 	}
61 	/* Approve and then comunicate the approved contract in a single tx */
62 	function approveAndCall(address _spender, uint256 _value, bytes _extraData)
63 	returns (bool success) {
64 		tokenRecipient spender = tokenRecipient(_spender);
65 		if (approve(_spender, _value)) {
66 			spender.receiveApproval(msg.sender, _value, this, _extraData);
67 			return true;
68 		}
69 	}
70 	/* A contract attempts to get the coins */
71 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
72 		if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
73 		if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
74 		if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
75 		balanceOf[_from] -= _value;                          // Subtract from the sender
76 		balanceOf[_to] += _value;                            // Add the same to the recipient
77 		allowance[_from][msg.sender] -= _value;
78 		Transfer(_from, _to, _value);
79 		return true;
80 	}
81 	/* This unnamed function is called whenever someone tries to send ether to it */
82 	function () {
83 		throw;     // Prevents accidental sending of ether
84 	}
85 }