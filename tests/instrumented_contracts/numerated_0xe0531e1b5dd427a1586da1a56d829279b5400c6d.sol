1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Mathematical functions to check for overflows
6  */
7 contract SafeMath {
8 	function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
9 		uint256 c = a + b;
10 		assert(c >= a && c >= b);
11 
12 		return c;
13 	}
14 
15 	function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
16 		assert(b <= a);
17 		uint256 c = a - b;
18 
19 		return c;
20 	}
21 }
22 
23 contract CURESToken is SafeMath {
24 	// Public variables of the token
25 	string public name = "CURESToken";									// Token name
26 	string public symbol = "CRS";										// Token symbol
27 	uint8 public decimals = 18;											// Token amount of decimals
28 	uint256 public totalSupply = 500000000 * 10 ** uint256(decimals);	// Token supply - 500 Million
29 	address public CURES = this;										// Token address
30 
31 	// Creates array with balances
32 	mapping (address => uint256) public balances;
33 	mapping (address => mapping (address => uint256)) public allowances;
34 
35 	/**
36 	 * Constructor function
37 	 *
38 	 * @dev Constructor function - Deploy the contract
39 	 */
40 	constructor() public {
41 		// Give the creator all initial tokens
42 		balances[msg.sender] = totalSupply;
43 	}
44 
45 	/**
46 	 * @param _owner The address from which the balance will be retrieved
47 	 * @return The balance
48 	 */
49 	function balanceOf(address _owner) public view returns (uint256 balance) {
50 		return balances[_owner];
51 	}
52 
53 	/**
54 	 * @notice Allows `_spender` to spend no more than `_value` tokens in msg.sender behalf
55 	 * @param _owner The address of the account owning tokens
56 	 * @param _spender The address of the account able to transfer the tokens
57 	 * @return Amount of remaining tokens allowed to spent
58 	 */	
59 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
60 		return allowances[_owner][_spender];
61 	}
62 
63 	/**
64 	 * @notice send `_value` token to `_to` from `msg.sender`
65 	 * @param _to The address of the recipient
66 	 * @param _value The amount of token to be transferred
67 	 * @return Whether the transfer was successful or not
68 	 */	
69 	function transfer(address _to, uint256 _value) public returns (bool success) {
70 		// Prevent transfer to 0x0 (empty) address, use burn() instead
71 		require(_to != 0x0);
72 
73 		// Prevent empty transactions
74 		require(_value > 0);
75 
76 		// Check if sender has enough
77 		require(balances[msg.sender] >= _value);
78 
79 		// Subtract the amount from the sender
80 		balances[msg.sender] = safeSub(balances[msg.sender], _value);
81 
82 		// Add the same amount to the recipient
83 		balances[_to] = safeAdd(balances[_to], _value);
84 
85 		// Generate the public transfer event and return success
86 		emit Transfer(msg.sender, _to, _value);
87 		return true;
88 	}
89 
90 	/**
91 	 * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
92 	 * @param _from The address of the sender
93 	 * @param _to The address of the recipient
94 	 * @param _value The amount of token to be transferred
95 	 * @return Whether the transfer was successful or not
96 	 */	
97 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
98 		// Prevent transfer to 0x0 (empty) address
99 		require(_to != 0x0);
100 
101 		// Prevent empty transactions
102 		require(_value > 0);
103 
104 		// Check if sender is allowed to spend the amount
105 		require(allowances[_from][msg.sender] >= _value);
106 
107 		// Check if token owner has enough
108 		require(balances[_from] >= _value);
109 
110 		// Subtract the amount from the sender
111 		allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender], _value);
112 
113 		// Subtract the amount from the token owner
114 		balances[_from] = safeSub(balances[_from], _value);
115 
116 		// Add the same amount to the recipient
117 		balances[_to] = safeAdd(balances[_to], _value);
118 
119 		// Generate the public transfer event and return success
120 		emit Transfer(_from, _to, _value);
121 		return true;
122 	}
123 
124 	/**
125 	 * @notice `msg.sender` approves `_spender` to spend `_value` tokens
126 	 * @param _spender The address of the account able to transfer the tokens
127 	 * @param _value The amount of tokens to be approved for transfer
128 	 * @return Whether the approval was successful or not
129 	 */	
130 	function approve(address _spender, uint256 _value) public returns (bool success) {
131 		// The amount has to be bigger or equal to 0
132 		require(_value >= 0);
133 
134 		allowances[msg.sender][_spender] = _value;
135 
136 		// Generate the public approval event and return success
137 		emit Approval(msg.sender, _spender, _value);
138 		return true;
139 	}
140 
141 	/**
142 	 * @notice Remove `_value` tokens from the system irreversibly
143 	 * @param _value the amount of money to burn
144 	 */
145 	function burn(uint256 _value) public returns (bool success) {
146 		// Check if value is less than 0
147 		require(_value > 0);
148 
149 		// Check if the owner has enough tokens
150 		require(balances[msg.sender] >= _value);
151 
152 		// Subtract the value from the owner
153 		balances[msg.sender] = safeSub(balances[msg.sender], _value);
154 
155 		// Subtract the value from the Total Balance
156 		totalSupply = safeSub(totalSupply, _value);
157 
158 		// Generate the public burn event and return success
159 		emit Burn(msg.sender, _value);
160 		return true;
161 	}
162 
163 	// Public events on the blockchain to notify clients
164 	event Transfer(address indexed _owner, address indexed _to, uint256 _value);
165 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
166 	event Burn(address indexed _owner, uint256 _value);
167 }