1 pragma solidity >= 0.4.24 < 0.6.0;
2 
3 /**
4  * @title Owned
5  * @dev Contract that sets an owner, who can execute predefined functions, only accessible by him
6  */
7 contract Owned {
8 	address public owner;
9 
10 	constructor() public {
11 		owner = msg.sender;
12 	}
13 
14 	modifier onlyOwner {
15 		require(msg.sender == owner);
16 		_;
17 	}
18 
19 	function transferOwnership(address newOwner) public onlyOwner {
20 		require(newOwner != address(0x0));
21 		owner = newOwner;
22 	}
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Mathematical functions to check for overflows
28  */
29 contract SafeMath {
30 	function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
31 		uint256 c = a + b;
32 		assert(c >= a && c >= b);
33 
34 		return c;
35 	}
36 
37 	function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
38 		assert(b <= a);
39 		uint256 c = a - b;
40 
41 		return c;
42 	}
43 }
44 
45 contract CURESToken is Owned, SafeMath {
46 	// Public variables of the token
47 	string public name = "CURESToken";									// Token name
48 	string public symbol = "CRS";										// Token symbol
49 	uint8 public decimals = 18;											// Token amount of decimals
50 	uint256 public totalSupply = 500000000 * 10 ** uint256(decimals);	// Token supply - 500 Million
51 
52 	// Creates array with balances
53 	mapping (address => uint256) public balances;
54 	mapping (address => mapping (address => uint256)) public allowances;
55 	mapping (address => uint256) public frozenAccounts;
56 
57 	/**
58 	 * Constructor function
59 	 *
60 	 * @dev Constructor function - Deploy the contract
61 	 */
62 	constructor() public {
63 		// Give the creator all initial tokens
64 		balances[msg.sender] = totalSupply;
65 	}
66 
67 	/**
68 	 * @param _owner The address from which the balance will be retrieved
69 	 * @return The balance
70 	 */
71 	function balanceOf(address _owner) public view returns (uint256 balance) {
72 		return balances[_owner];
73 	}
74 
75 	/**
76 	 * @notice Allows `_spender` to spend no more than `_value` tokens in msg.sender behalf
77 	 * @param _owner The address of the account owning tokens
78 	 * @param _spender The address of the account able to transfer the tokens
79 	 * @return Amount of remaining tokens allowed to spent
80 	 */	
81 	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
82 		return allowances[_owner][_spender];
83 	}
84 
85 	/**
86 	 * @notice send `_value` token to `_to` from `msg.sender`
87 	 * @param _to The address of the recipient
88 	 * @param _value The amount of token to be transferred
89 	 * @return Whether the transfer was successful or not
90 	 */	
91 	function transfer(address _to, uint256 _value) public returns (bool success) {
92 		// Prevent transfer to 0x0 (empty) address, use burn() instead
93 		require(_to != address(0x0));
94 
95 		// Prevent empty transactions
96 		require(_value > 0);
97 
98 		// Check if sender account is frozen
99 		require(frozenAccounts[msg.sender] < now);
100 
101 		// Check if sender has enough
102 		require(balances[msg.sender] >= _value);
103 
104 		// Subtract the amount from the sender
105 		balances[msg.sender] = safeSub(balances[msg.sender], _value);
106 
107 		// Add the same amount to the recipient
108 		balances[_to] = safeAdd(balances[_to], _value);
109 
110 		// Generate the public transfer event and return success
111 		emit Transfer(msg.sender, _to, _value);
112 		return true;
113 	}
114 
115 	/**
116 	 * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
117 	 * @param _from The address of the sender
118 	 * @param _to The address of the recipient
119 	 * @param _value The amount of token to be transferred
120 	 * @return Whether the transfer was successful or not
121 	 */	
122 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
123 		// Prevent transfer to 0x0 (empty) address
124 		require(_to != address(0x0));
125 
126 		// Prevent empty transactions
127 		require(_value > 0);
128 
129 		// Check if token owner account is frozen
130 		require(frozenAccounts[_from] < now);
131 
132 		// Check if sender is allowed to spend the amount
133 		require(allowances[_from][msg.sender] >= _value);
134 
135 		// Check if token owner has enough
136 		require(balances[_from] >= _value);
137 
138 		// Subtract the amount from the sender
139 		allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender], _value);
140 
141 		// Subtract the amount from the token owner
142 		balances[_from] = safeSub(balances[_from], _value);
143 
144 		// Add the same amount to the recipient
145 		balances[_to] = safeAdd(balances[_to], _value);
146 
147 		// Generate the public transfer event and return success
148 		emit Transfer(_from, _to, _value);
149 		return true;
150 	}
151 
152 	/**
153 	 * @notice `msg.sender` approves `_spender` to spend `_value` tokens
154 	 * @param _spender The address of the account able to transfer the tokens
155 	 * @param _value The amount of tokens to be approved for transfer
156 	 * @return Whether the approval was successful or not
157 	 */	
158 	function approve(address _spender, uint256 _value) public returns (bool success) {
159 		// The amount has to be bigger or equal to 0
160 		require(_value >= 0);
161 
162 		allowances[msg.sender][_spender] = _value;
163 
164 		// Generate the public approval event and return success
165 		emit Approval(msg.sender, _spender, _value);
166 		return true;
167 	}
168 
169 	/**
170 	 * @notice Remove `_value` tokens from the system irreversibly
171 	 * @param _value the amount of money to burn
172 	 */
173 	function burn(uint256 _value) public returns (bool success) {
174 		// Check if value is less than 0
175 		require(_value > 0);
176 
177 		// Check if the owner has enough tokens
178 		require(balances[msg.sender] >= _value);
179 
180 		// Subtract the value from the owner
181 		balances[msg.sender] = safeSub(balances[msg.sender], _value);
182 
183 		// Subtract the value from the Total Balance
184 		totalSupply = safeSub(totalSupply, _value);
185 
186 		// Generate the public burn event and return success
187 		emit Burn(msg.sender, _value);
188 		return true;
189 	}
190 
191 	/**
192 	 * @dev Freeze one or more account until specific date
193 	 * @param _addresses array with wallet addresses we want to freeze
194 	 * @param _until is the time until when the account is frozen
195 	 */
196 	function FreezeAccounts(address[] memory _addresses, uint256 _until) public onlyOwner returns (bool success) {
197 		for (uint i = 0; i < _addresses.length; i++) {
198 			frozenAccounts[_addresses[i]] = _until;
199 
200 			// Generate the public freeze event
201 			emit Freeze(_addresses[i], _until);
202 		}
203 
204 		return true;
205 	}
206 
207 	// Public events on the blockchain to notify clients
208 	event Transfer(address indexed _owner, address indexed _to, uint256 _value);
209 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
210 	event Burn(address indexed _owner, uint256 _value);
211 	event Freeze(address indexed _owner, uint256 _until);
212 }