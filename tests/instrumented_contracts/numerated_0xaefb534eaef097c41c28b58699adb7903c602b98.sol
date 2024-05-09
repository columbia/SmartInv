1 pragma solidity ^0.4.16; 
2 /*** @title SafeMath * @dev Math operations with safety checks that throw on error */ 
3 
4 library SafeMath { //安全的算法 
5 	
6 	/** * @dev Multiplies two numbers, throws on overflow. */
7 	function mul(uint256 a, uint256 b) internal pure returns (uint256) { 
8 		if (a == 0) { return 0; }uint256 c = a * b; assert(c / a == b); return c; 
9 	}
10 	
11 	/** * @dev Integer division of two numbers, truncating the quotient. */
12 	function div(uint256 a, uint256 b) internal pure returns (uint256) { 
13 		// assert(b > 0); 
14 		// Solidity automatically throws when dividing by 0 uint256 c = a / b; 
15 		// assert(a == b * c + a % b); 
16 		// There is no case in which this doesn't hold return c; 
17 	}
18 	
19 	/** * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend). */
20 	function sub(uint256 a, uint256 b) internal pure returns (uint256) { 
21 		assert(b <= a); return a - b; 
22 	}
23 	
24 	/** * @dev Adds two numbers, throws on overflow. */
25 	function add(uint256 a, uint256 b) internal pure returns (uint256) { 
26 		uint256 c = a + b; assert(c >= a); return c; 
27 	} 
28 }
29 
30 contract owned { //认证 
31 	address public owner; 
32 	function owned() public { 
33 		owner = msg.sender; 
34 	}
35 	
36 	modifier onlyOwner { 
37 		require(msg.sender == owner); _; 
38 	}
39 	
40 	function transferOwnership(address newOwner) onlyOwner public { 
41 		owner = newOwner;
42 	} 
43 }
44 
45 interface tokenRecipient { 
46 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
47 } 
48 
49 contract TokenERC20 { 
50 	using SafeMath for uint256; 
51 	
52 	// Public variables of the token 
53 	string public name; 
54 	string public symbol; 
55 	uint8 public decimals = 18; 
56 	
57 	// 18 decimals is the strongly suggested default, avoid changing it 
58 	uint256 public totalSupply; 
59 	
60 	// This creates an array with all balances 
61 	mapping (address => uint256) public balanceOf; 
62 	mapping (address => mapping (address => uint256)) public allowance; 
63 	
64 	// This generates a public event on the blockchain that will notify clients 
65 	event Transfer(address indexed from, address indexed to, uint256 value); 
66 	
67 	// This notifies clients about the amount burnt 
68 	event Burn(address indexed from, uint256 value); 
69 	
70 	/*** Constrctor function 
71 	** Initializes contract with initial supply tokens to the creator of the contract 
72 	*/ 
73 	function TokenERC20( //初始化代币 
74 		uint256 initialSupply, 
75 		string tokenName, 
76 		string tokenSymbol 
77 	) public { 
78 		totalSupply = initialSupply * 10 ** uint256(decimals); // Update total supply with the decimal amount 
79 		balanceOf[msg.sender] = totalSupply; // Give the creator all initial tokens 
80 		name = tokenName; // Set the name for display purposes 
81 		symbol = tokenSymbol; // Set the symbol for display purposes 
82 	}
83 	
84 	/*** Internal transfer, only can be called by this contract 
85 	*/ 
86 	function _transfer(address _from, address _to, uint _value) internal { 
87 		// Prevent transfer to 0x0 address. Use burn() instead 
88 		require(_to != 0x0);
89 		// Check if the sender has enough 
90 		require(balanceOf[_from] >= _value); 
91 		// Check for overflows 
92 		require(balanceOf[_to].add(_value) > balanceOf[_to]); 
93 		// Save this for an assertion in the future 
94 		uint previousBalances = balanceOf[_from].add(balanceOf[_to]); 
95 		// Subtract from the sender 
96 		balanceOf[_from] = balanceOf[_from].sub(_value); 
97 		// Add the same to the recipient 
98 		balanceOf[_to] = balanceOf[_to].add(_value); 
99 		emit Transfer(_from, _to, _value); 
100 		// Asserts are used to use static analysis to find bugs in your code. They should never fail 
101 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances); 
102 	}
103 	
104 	/*** Transfer tokens 
105 	** Send `_value` tokens to `_to` from your account 
106 	** @param _to The address of the recipient 
107 	* @param _value the amount to send 
108 	*/
109 	function transfer(address _to, uint256 _value) public { //公开的交易 
110 		_transfer(msg.sender, _to, _value); 
111 	}
112 	
113 	/*** Transfer tokens from other address 
114 	** Send `_value` tokens to `_to` in behalf of `_from` 
115 	** @param _from The address of the sender 
116 	* @param _to The address of the recipient 
117 	* @param _value the amount to send 
118 	*/ 
119 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) { //代转 
120 		require(_value <= allowance[_from][msg.sender]); 
121 		// Check allowance 
122 		allowance[_from][msg.sender ] = allowance[_from][msg.sender].sub(_value); 
123 		_transfer(_from, _to, _value); return true; 
124 	}
125 	
126 	/*** Set allowance for other address 
127 	** Allows `_spender` to spend no more than `_value` tokens in your behalf 
128 	** @param _spender The address authorized to spend 
129 	* @param _value the max amount they can spend 
130 	*/ 
131 	function approve(address _spender, uint256 _value) public returns (bool success) { 
132 		require(_value == 0 || (allowance[msg.sender][_spender] == 0));
133 		allowance[msg.sender][_spender] = _value;
134 		return true; 
135 	}
136 	
137 	/*** Set allowance for other address and notify 
138 	** Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it 
139 	** @param _spender The address authorized to spend 
140 	* @param _value the max amount they can spend 
141 	* @param _extraData some extra information to send to the approved contract 
142 	*/ 
143 	function approveAndCall(address _spender, uint256 _value, bytes _extraData ) public returns (bool success) { 
144 		tokenRecipient spender = tokenRecipient(_spender); 
145 		if (approve(_spender, _value)) { 
146 			spender.receiveApproval(msg.sender, _value, this, _extraData); return true; 
147 		} 
148 	}
149 	
150 	/*** Destroy tokens ** Remove `_value` tokens from the system irreversibly 
151 	** @param _value the amount of money to burn 
152 	*/ 
153 	function burn(uint256 _value) public returns (bool success) { //销毁 
154 		require(balanceOf[msg.sender] >= _value); 
155 		// Check if the sender has enough 
156 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value); 
157 		// Subtract from the sender 
158 		totalSupply = totalSupply.sub(_value); 
159 		// Updates totalSupply 
160 		emit Burn(msg.sender, _value); 
161 		return true;		
162 	}
163 	
164 	/*** Destroy tokens from other account 
165 	** Remove `_value` tokens from the system irreversibly on behalf of `_from`. 
166 	* @param _from the address of the sender 
167 	* @param _value the amount of money to burn 
168 	*/ 
169 	function burnFrom(address _from, uint256 _value) public returns (bool success) { //销毁他人的代币 
170 		require(balanceOf[_from] >= _value); 
171 		// Check if the targeted balance is enough 
172 		require(_value <= allowance[_from][msg.sender]); 
173 		// Check allowance 
174 		balanceOf[_from] = balanceOf[_from].sub(_value); 
175 		// Subtract from the targeted balance 
176 		allowance[_from][msg.sender ] = allowance[_from][msg.sender].sub(_value); 
177 		// Subtract from the sender's allowance 
178 		totalSupply = totalSupply.sub(_value); 
179 		// Update totalSupply 
180 		emit Burn(_from, _value); 
181 		return true; 
182 	} 
183 	
184 	/*** Batch Transfer tokens 
185 	** Send `_value` tokens to `_receivers` from your account 
186 	** @param _receivers The address of the recipient 
187 	* @param _value the amount to send 
188 	*/
189 	function batchTransfer(address[] _receivers, uint256 _value) public returns (bool success) {
190 		uint receiverCount = _receivers.length;
191 		uint256 amount = _value.mul(uint256(receiverCount));
192 		require(receiverCount > 0);
193 		require(_value > 0 && balanceOf[msg.sender] >= amount);
194 
195 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
196 		for (uint i = 0; i < receiverCount; i++) {
197 			balanceOf[_receivers[i]] = balanceOf[_receivers[i]].add(_value);
198 			Transfer(msg.sender, _receivers[i], _value);
199 		}
200 		return true;
201 	}
202 }
203 /******************************************/ 
204 /* ADVANCED TOKEN STARTS HERE */
205 /******************************************/ 
206 contract MyAdvancedToken is owned, TokenERC20 { 
207 	using SafeMath for uint256; 
208 	uint256 public sellPrice ; 
209 	uint256 public buyPrice; 
210 	
211 	mapping (address => bool) public frozenAccount; 
212 	
213 	/* This generates a public event on the blockchain that will notify clients */ 
214 	event FrozenFunds(address target, bool frozen); 
215 	
216 	/* Initializes contract with initial supply tokens to the creator of the contract */ 
217 	function MyAdvancedToken( 
218 		uint256 initialSupply, 
219 		string tokenName, 
220 		string tokenSymbol 
221 	) TokenERC20(initialSupply, tokenName, tokenSymbol) public {} 
222 	
223 	/* Internal transfer, only can be called by this contract */ 
224 	function _transfer(address _from, address _to, uint _value) internal { 
225 		require (_to != 0x0); 
226 		
227 		// Prevent transfer to 0x0 address. Use burn() instead 
228 		require (balanceOf[_from] >= _value); 
229 		
230 		// Check if the sender has enough 
231 		require (balanceOf[_to].add (_value) >= balanceOf[_to]); 
232 		
233 		// Check for overflows 
234 		require(!frozenAccount[_from]); 
235 		
236 		// Check if sender is frozen 
237 		require(!frozenAccount[_to]); 
238 		
239 		// Check if recipient is frozen 
240 		balanceOf[_from] = balanceOf[_from].sub(_value); 
241 		
242 		// Subtract from the sender 
243 		balanceOf[_to] = balanceOf[_to ].add (_value); 
244 		
245 		// Add the same to the recipient 
246 		emit Transfer(_from, _to, _value); 
247 	}
248 	
249 	/// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens 
250 	/// @param target Address to be frozen 
251 	/// @param freeze either to freeze it or not 
252 	function freezeAccount(address target, bool freeze) onlyOwner public { // 冻结账户 
253 		frozenAccount[target] = freeze; emit FrozenFunds(target, freeze); 
254 	}
255 	
256 	/// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth 
257 	/// @param newSellPrice Price the users can sell to the contract 
258 	/// @param newBuyPrice Price users can buy from the contract 
259 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public { //代币买卖价格 
260 		sellPrice = newSellPrice; 
261 		buyPrice = newBuyPrice; 
262 	}
263 	
264 	/// @notice Buy tokens from contract by sending ether 
265 	function buy() payable public { //买代币 
266 		uint amount = msg.value.div(buyPrice); // calculates the amount
267 		_transfer(this, msg.sender, amount); // makes the transfers 
268 	}
269 	
270 	/// @notice Sell `amount` tokens to contract 
271 	/// @param amount amount of tokens to be sold 
272 	function sell(uint256 amount) public { //卖代币 
273 		require(address(this).balance >= amount.mul(sellPrice)); // checks if the contract has enough ether to buy 
274 		_transfer(msg.sender, this, amount); // makes the transfers 
275 		msg.sender.transfer(amount.mul(sellPrice)); // sends ether to the seller. It's important to do this last to avoid recursion attacks 
276 	} 
277 }