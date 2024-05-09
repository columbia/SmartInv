1 pragma solidity ^0.4.16;
2 
3 contract AccessControl {
4 	address public owner;
5 	address public ceoAddress;
6 
7 	function AccessControl() public {
8 		owner = msg.sender;
9 	}
10 
11 	modifier onlyOwner {
12 		require(msg.sender == owner);
13 		_;
14 	}
15 
16 	modifier onlyCEO {
17 		require(msg.sender == ceoAddress);
18 		_;
19 	}
20 
21 	function setCEO(address _ceo) onlyOwner public {
22 		ceoAddress = _ceo;
23 	}
24 }
25 
26 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
27 
28 contract TokenERC20 {
29 	// Public variables of the token
30 	string public name;
31 	string public symbol;
32 	uint8 public decimals = 18;
33 	// 18 decimals is the strongly suggested default, avoid changing it
34 	uint256 public totalSupply;
35 
36 	// This creates an array with all balances
37 	mapping (address => uint256) public balanceOf;
38 	mapping (address => mapping (address => uint256)) public allowance;
39 
40 	// This generates a public event on the blockchain that will notify clients
41 	event Transfer(address indexed from, address indexed to, uint256 value);
42 
43 	// This notifies clients about the amount burnt
44 	event Burn(address indexed from, uint256 value);
45 
46 	/**
47 	 * Constrctor function
48 	 *
49 	 * Initializes contract with initial supply tokens to the creator of the contract
50 	 */
51 	function TokenERC20(
52 		uint256 initialSupply,
53 		string tokenName,
54 		string tokenSymbol
55 	) public {
56 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
57 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
58 		name = tokenName;                                   // Set the name for display purposes
59 		symbol = tokenSymbol;                               // Set the symbol for display purposes
60 	}
61 
62 	/**
63 	 * Internal transfer, only can be called by this contract
64 	 */
65 	function _transfer(address _from, address _to, uint _value) internal {
66 		// Prevent transfer to 0x0 address. Use burn() instead
67 		require(_to != 0x0);
68 		// Check if the sender has enough
69 		require(balanceOf[_from] >= _value);
70 		// Check for overflows
71 		require(balanceOf[_to] + _value > balanceOf[_to]);
72 		// Save this for an assertion in the future
73 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
74 		// Subtract from the sender
75 		balanceOf[_from] -= _value;
76 		// Add the same to the recipient
77 		balanceOf[_to] += _value;
78 		Transfer(_from, _to, _value);
79 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
80 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
81 	}
82 
83 	/**
84 	 * Transfer tokens
85 	 *
86 	 * Send `_value` tokens to `_to` from your account
87 	 *
88 	 * @param _to The address of the recipient
89 	 * @param _value the amount to send
90 	 */
91 	function transfer(address _to, uint256 _value) public {
92 		_transfer(msg.sender, _to, _value);
93 	}
94 
95 	/**
96 	 * Transfer tokens from other address
97 	 *
98 	 * Send `_value` tokens to `_to` in behalf of `_from`
99 	 *
100 	 * @param _from The address of the sender
101 	 * @param _to The address of the recipient
102 	 * @param _value the amount to send
103 	 */
104 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
106 		allowance[_from][msg.sender] -= _value;
107 		_transfer(_from, _to, _value);
108 		return true;
109 	}
110 
111 	/**
112 	 * Set allowance for other address
113 	 *
114 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
115 	 *
116 	 * @param _spender The address authorized to spend
117 	 * @param _value the max amount they can spend
118 	 */
119 	function approve(address _spender, uint256 _value) public
120 	returns (bool success) {
121 		allowance[msg.sender][_spender] = _value;
122 		return true;
123 	}
124 
125 	/**
126 	 * Set allowance for other address and notify
127 	 *
128 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
129 	 *
130 	 * @param _spender The address authorized to spend
131 	 * @param _value the max amount they can spend
132 	 * @param _extraData some extra information to send to the approved contract
133 	 */
134 	function approveAndCall(address _spender, uint256 _value, bytes _extraData)
135 	public
136 	returns (bool success) {
137 		tokenRecipient spender = tokenRecipient(_spender);
138 		if (approve(_spender, _value)) {
139 			spender.receiveApproval(msg.sender, _value, this, _extraData);
140 			return true;
141 		}
142 	}
143 
144 	/**
145 	 * Destroy tokens
146 	 *
147 	 * Remove `_value` tokens from the system irreversibly
148 	 *
149 	 * @param _value the amount of money to burn
150 	 */
151 	function burn(uint256 _value) public returns (bool success) {
152 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
153 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
154 		totalSupply -= _value;                      // Updates totalSupply
155 		Burn(msg.sender, _value);
156 		return true;
157 	}
158 
159 	/**
160 	 * Destroy tokens from other account
161 	 *
162 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
163 	 *
164 	 * @param _from the address of the sender
165 	 * @param _value the amount of money to burn
166 	 */
167 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
168 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
169 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
170 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
171 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
172 		totalSupply -= _value;                              // Update totalSupply
173 		Burn(_from, _value);
174 		return true;
175 	}
176 }
177 
178 /******************************************/
179 /*       MGC TOKEN STARTS HERE       */
180 /******************************************/
181 
182 contract MGCToken is AccessControl, TokenERC20 {
183 
184 	mapping (address => bool) public frozenAccount;
185 
186 	/* This generates a public event on the blockchain that will notify clients */
187 	event FrozenFunds(address target, bool frozen);
188 
189 	/* Initializes contract with initial supply tokens to the creator of the contract */
190 	function MGCToken() TokenERC20(2000000000, 'Magic Game Chain', 'MGCT') public {}
191 
192 	/* Internal transfer, only can be called by this contract */
193 	function _transfer(address _from, address _to, uint _value) internal {
194 		require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
195 		require (balanceOf[_from] >= _value);               // Check if the sender has enough
196 		require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
197 		require(!frozenAccount[_from]);                     // Check if sender is frozen
198 		require(!frozenAccount[_to]);                       // Check if recipient is frozen
199 		balanceOf[_from] -= _value;                         // Subtract from the sender
200 		balanceOf[_to] += _value;                           // Add the same to the recipient
201 		Transfer(_from, _to, _value);
202 	}
203 
204 	/// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
205 	/// @param target Address to be frozen
206 	/// @param freeze either to freeze it or not
207 	function freezeAccount(address target, bool freeze) onlyCEO public {
208 		frozenAccount[target] = freeze;
209 		FrozenFunds(target, freeze);
210 	}
211 }