1 pragma solidity ^0.4.16;
2 
3 contract owned {
4 	address public owner;
5 
6 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8 	function owned() public {
9 		owner = msg.sender;
10 	}
11 
12 	modifier onlyOwner {
13 		require(msg.sender == owner);
14 		_;
15 	}
16 
17 	function transferOwnership(address newOwner) onlyOwner public {
18 		require(newOwner != address(0));
19 		OwnershipTransferred(owner, newOwner);
20 		owner = newOwner;
21 	}
22 }
23 
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
25 
26 contract TokenERC20 {
27 	// Public variables of the token
28 	string public name;
29 	string public symbol;
30 	uint8 public decimals = 18;
31 	// 18 decimals is the strongly suggested default, avoid changing it
32 	uint256 public totalSupply;
33 
34 	// This creates an array with all balances
35 	mapping (address => uint256) public balanceOf;
36 	mapping (address => mapping (address => uint256)) public allowance;
37 
38 	// This generates a public event on the blockchain that will notify clients
39 	event Transfer(address indexed from, address indexed to, uint256 value);
40 
41 	// This notifies clients about the amount burnt
42 	event Burn(address indexed from, uint256 value);
43 
44 	/**
45 	 * Constrctor function
46 	 *
47 	 * Initializes contract with initial supply tokens to the creator of the contract
48 	 */
49 	function TokenERC20(
50 			uint256 initialSupply,
51 			string tokenName,
52 			string tokenSymbol
53 			) public {
54 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
55 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
56 		name = tokenName;                                   // Set the name for display purposes
57 		symbol = tokenSymbol;                               // Set the symbol for display purposes
58 	}
59 
60 	/**
61 	 * Internal transfer, only can be called by this contract
62 	 */
63 	function _transfer(address _from, address _to, uint _value) internal {
64 		//require(_value > 0); //uint will never be less than zero ;)
65 		// Prevent transfer to 0x0 address. Use burn() instead
66 		require(_to != 0x0);
67 		// Check if the sender has enough
68 		require(balanceOf[_from] >= _value);
69 		// Check for overflows
70 		require(balanceOf[_to] + _value > balanceOf[_to]);
71 		// Save this for an assertion in the future
72 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
73 		// Subtract from the sender
74 		balanceOf[_from] -= _value;
75 		// Add the same to the recipient
76 		balanceOf[_to] += _value;
77 		Transfer(_from, _to, _value);
78 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
79 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
80 	}
81 
82 	/**
83 	 * Transfer tokens
84 	 *
85 	 * Send `_value` tokens to `_to` from your account
86 	 *
87 	 * @param _to The address of the recipient
88 	 * @param _value the amount to send
89 	 */
90 	function transfer(address _to, uint256 _value) public {
91 		_transfer(msg.sender, _to, _value);
92 	}
93 
94 	/**
95 	 * Transfer tokens from other address
96 	 *
97 	 * Send `_value` tokens to `_to` in behalf of `_from`
98 	 *
99 	 * @param _from The address of the sender
100 	 * @param _to The address of the recipient
101 	 * @param _value the amount to send
102 	 */
103 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
104 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
105 		allowance[_from][msg.sender] -= _value;
106 		_transfer(_from, _to, _value);
107 		return true;
108 	}
109 
110 	/**
111 	 * Set allowance for other address
112 	 *
113 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
114 	 *
115 	 * @param _spender The address authorized to spend
116 	 * @param _value the max amount they can spend
117 	 */
118 	function approve(address _spender, uint256 _value) public
119 		returns (bool success) {
120 			//require(_value > 0); //uint will never be less than zero ;)
121 			allowance[msg.sender][_spender] = _value;
122 			return true;
123 		}
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
134 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) public
135 		returns (bool success) {
136 			tokenRecipient spender = tokenRecipient(_spender);
137 			if (approve(_spender, _value)) {
138 				spender.receiveApproval(msg.sender, _value, this, _extraData);
139 				return true;
140 			}
141 		}
142 
143 	/**
144 	 * Destroy tokens
145 	 *
146 	 * Remove `_value` tokens from the system irreversibly
147 	 *
148 	 * @param _value the amount of money to burn
149 	 */
150 	function burn(uint256 _value) public returns (bool success) {
151 		//require(_value > 0); //uint will never be less than zero ;)
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
178 contract AdvancedToken is owned, TokenERC20 {
179 
180 	mapping (address => bool) public frozenAccount;
181 
182 	/* This generates a public event on the blockchain that will notify clients */
183 	event FrozenFunds(address target, bool frozen);
184 
185 	/* Initializes contract with initial supply tokens to the creator of the contract */
186 	function AdvancedToken(
187 			uint256 initialSupply,
188 			string tokenName,
189 			string tokenSymbol
190 			) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
191 
192 	/* Avoid anyone sending Ether to the contract for mistake */
193 	function () public {
194 		//if ether is sent to this address, send it back.
195 		//throw;
196 		require(false); //always fail
197 	}
198 
199 	/* Internal transfer, only can be called by this contract */
200 	function _transfer(address _from, address _to, uint _value) internal {
201 		require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
202 		require (balanceOf[_from] >= _value);               // Check if the sender has enough
203 		require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
204 		require(!frozenAccount[_from]);                     // Check if sender is frozen
205 		require(!frozenAccount[_to]);                       // Check if recipient is frozen
206 		balanceOf[_from] -= _value;                         // Subtract from the sender
207 		balanceOf[_to] += _value;                           // Add the same to the recipient
208 		Transfer(_from, _to, _value);
209 	}
210 
211 	/* Never mint more tokens */
212 	/// @notice Create `mintedAmount` tokens and send it to `target`
213 	/// @param target Address to receive the tokens
214 	/// @param mintedAmount the amount of tokens it will receive
215 	/*function mintToken(address target, uint256 mintedAmount) onlyOwner public {
216 		balanceOf[target] += mintedAmount;
217 		totalSupply += mintedAmount;
218 		Transfer(0, this, mintedAmount);
219 		Transfer(this, target, mintedAmount);
220 		}*/
221 
222 	/// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
223 	/// @param target Address to be frozen
224 	/// @param freeze either to freeze it or not
225 	function freezeAccount(address target, bool freeze) onlyOwner public {
226 		frozenAccount[target] = freeze;
227 		FrozenFunds(target, freeze);
228 	}
229 
230 }
231 
232 /**
233  * @title Pausable
234  * @dev Base contract which allows children to implement an emergency stop mechanism.
235  */
236 contract Pausable is owned {
237 	event Pause();
238 	event Unpause();
239 
240 	bool public paused = false;
241 
242 	/**
243 	 * @dev modifier to allow actions only when the contract IS NOT paused
244 	 */
245 	modifier whenNotPaused() {
246 		require(!paused);
247 		_;
248 	}
249 
250 	/**
251 	 * @dev modifier to allow actions only when the contract IS paused
252 	 */
253 	modifier whenPaused {
254 		require(paused);
255 		_;
256 	}
257 
258 	/**
259 	 * @dev called by the owner to pause, triggers stopped state
260 	 */
261 	function pause() onlyOwner whenNotPaused public returns (bool) {
262 		paused = true;
263 		Pause();
264 		return true;
265 	}
266 
267 	/**
268 	 * @dev called by the owner to unpause, returns to normal state
269 	 */
270 	function unpause() onlyOwner whenPaused public returns (bool) {
271 		paused = false;
272 		Unpause();
273 		return true;
274 	}
275 }
276 
277 /******************************************/
278 /*   WANG-WANG TOKEN (WWT) STARTS HERE     */
279 /******************************************/
280 contract WangWangToken is AdvancedToken, Pausable {
281 
282 	uint256 public initialSupply = 100000000; //100,000,000
283 	string public tokenName = "Wang-Wang Token";
284 	string public tokenSymbol = "WWT";
285 
286 	function WangWangToken() AdvancedToken(initialSupply, tokenName, tokenSymbol) public {}
287 
288 	function transfer(address _to, uint256 _value) whenNotPaused public {
289 		super.transfer(_to, _value);
290 	}
291 
292 	function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool success) {
293 		return super.transferFrom(_from, _to, _value);
294 	}
295 
296 	function burn(uint256 _value) whenNotPaused public returns (bool success) {
297 		return super.burn(_value);
298 	}
299 
300 	function burnFrom(address _from, uint256 _value) whenNotPaused public returns (bool success) {
301 		return super.burnFrom(_from, _value);
302 	}
303 }