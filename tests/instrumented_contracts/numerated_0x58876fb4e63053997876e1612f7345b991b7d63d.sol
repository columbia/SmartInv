1 pragma solidity ^0.4.11;
2 
3 contract SafeMath{
4 	function safeMul(uint a, uint b) internal returns (uint) {
5 		uint c = a * b;
6 		assert(a == 0 || c / a == b);
7 		return c;
8 	}
9 
10 	function safeDiv(uint a, uint b) internal returns (uint) {
11 		assert(b > 0);
12 		uint c = a / b;
13 		assert(a == b * c + a % b);
14 		return c;
15 	}
16 
17 	function safeSub(uint a, uint b) internal returns (uint) {
18 		assert(b <= a);
19 		return a - b;
20 	}
21 
22 	function safeAdd(uint a, uint b) internal returns (uint) {
23 		uint c = a + b;
24 		assert(c >= a);
25 		return c;
26 	}
27 	function assert(bool assertion) internal {
28 		if (!assertion) {
29 			revert();
30 		}
31 	}
32 }
33 
34 // Contract that defines administrative actions
35 contract admined {
36 
37 	// Define adminitrator address
38 	address public admin;
39 
40 	// Entry function sets the admin as the sender
41 	function admined(){
42 		admin = msg.sender;
43 	}
44 
45 	// Check if the sender is the admin
46 	modifier onlyAdmin(){
47 		require(msg.sender == admin);
48 		_;
49 	}
50 
51 	// Transfer the admin role to a new address
52 	function transferAdminship(address newAdmin) public onlyAdmin {
53 		admin = newAdmin;
54 	}
55 }
56 
57 // Contract that creates the Token
58 contract Token is SafeMath {
59 
60 	// Contract balance
61 	mapping (address => uint256) public balanceOf;
62 	// Token name
63 	string public name = "MoralityAI";
64 	// Token symbol
65 	string public symbol = "Mo";
66 	// Decimals to use
67 	uint8 public decimal = 18; 
68 	// Total initial suppy
69 	uint256 public totalSupply = 1000000000000000000000000;
70 	// Transfer function interface
71 	event Transfer(address indexed from, address indexed to, uint256 value);
72 
73 	// Token creation function
74 	function Token(){
75 		// set the balance of the creator to the initial supply
76 		balanceOf[msg.sender] = totalSupply;
77 	}
78 
79 	// Transfer function used to send tokens to an address
80 	function transfer(address _to, uint256 _value){
81 		// Check if the creator actually has the required balance
82 		require(balanceOf[msg.sender] >= _value);
83 		// Check if the amount sent will not overflow
84 		require(safeAdd(balanceOf[_to], _value) >= balanceOf[_to]);
85 		// Substract tokens from the creator
86 		balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
87 		// Add tokens to the transfer address
88 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
89 		// Execute the transfer
90 		Transfer(msg.sender, _to, _value);
91 	}
92 }
93 
94 // Contract that creates a token which inherits
95 // the administrator contract properties and token contract properties
96 contract MoralityAI is admined, Token{
97 
98 	// Create the token
99 	function MoralityAI() Token(){
100 		admin = msg.sender;
101 		balanceOf[admin] = totalSupply;
102 	}
103 
104 	// Minting function that can only be called by the admin
105 	function mintToken(address target, uint256 mintedAmount) public onlyAdmin{
106 		// Increase the balance of the target address with the amount of minted tokens
107 		balanceOf[target] = safeAdd(balanceOf[target], mintedAmount);
108 		// Increase the total supply of tokens
109 		totalSupply = safeAdd(totalSupply, mintedAmount);
110 		// Transfer the amount to this contract
111 		Transfer(0, this, mintedAmount);
112 		// Then transfer the amount to the target address
113 		Transfer(this, target, mintedAmount);
114 	}
115 
116 	// Toekn transfer function
117 	function transfer(address _to, uint256 _value) public{
118 		// Check if balance of the sender is not negative
119 		require(balanceOf[msg.sender] > 0);
120 		// Check if balance of the sender is greater than or equal than the amount transfered
121 		require(balanceOf[msg.sender] >= _value);
122 		// Check for overflow
123 		require(safeAdd(balanceOf[_to], _value) >= balanceOf[_to]);
124 
125 		// Substract the amount of tokens from the creator
126 		balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
127 		// And add the amount of tokens to the target address
128 		balanceOf[_to] = safeAdd(balanceOf[_to], _value);
129 		// Execute the transfer
130 		Transfer(msg.sender, _to, _value);
131 	}
132 }