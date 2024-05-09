1 pragma solidity ^0.4.24;
2 
3 // import 'openzeppelin-solidity/contracts/math/SafeMath.sol';
4 // pragma solidity ^0.4.24;
5 
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
17     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
18     // benefit is lost if 'b' is also tested.
19     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20     if (_a == 0) {
21       return 0;
22     }
23 
24     c = _a * _b;
25     assert(c / _a == _b);
26     return c;
27   }
28 
29   /**
30   * @dev Integer division of two numbers, truncating the quotient.
31   */
32   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
33     // assert(_b > 0); // Solidity automatically throws when dividing by 0
34     // uint256 c = _a / _b;
35     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
36     return _a / _b;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
43     assert(_b <= _a);
44     return _a - _b;
45   }
46 
47   /**
48   * @dev Adds two numbers, throws on overflow.
49   */
50   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
51     c = _a + _b;
52     assert(c >= _a);
53     return c;
54   }
55 }
56 
57 contract Owned {
58 	address public owner;
59 
60 	function Owned() public {
61 		owner = msg.sender;
62 	}
63 
64 	modifier onlyOwner {
65 		require(msg.sender == owner);
66 		_;
67 	}
68 
69 	function transferOwnership(address newOwner) onlyOwner public {
70 		owner = newOwner;
71 	}
72 }
73 
74 contract MigrationAgent {
75     function migrateFrom(address _from, uint256 _value);
76 }
77 
78 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
79 
80 contract TokenERC20 {
81 	// Public variables of the token
82 	string public name;
83 	string public symbol;
84 	// uint8 public decimals = 18;
85 	uint8 public decimals = 4;
86 	// 18 decimals is the strongly suggested default, avoid changing it
87 	uint256 public totalSupply;
88 
89 	// This creates an array with all balances
90 	mapping (address => uint256) public balanceOf;
91 	mapping (address => mapping (address => uint256)) public allowance;
92 
93 	// This generates a public event on the blockchain that will notify clients
94 	event Transfer(address indexed from, address indexed to, uint256 value);
95 
96 	// This notifies clients about the amount burnt
97 	event Burn(address indexed from, uint256 value);
98 
99 	/**
100 	 * Constrctor function
101 	 *
102 	 * Initializes contract with initial supply tokens to the creator of the contract
103 	 */
104 	function TokenERC20(uint256 initialSupply) public {
105 	    
106 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
107 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
108 		name = "WADCoin";                                   // Set the name for display purposes
109 		symbol = "wad";                               // Set the symbol for display purposes
110 	}
111 
112 
113 	/**
114 	 * Transfer tokens from other address
115 	 *
116 	 * Send `_value` tokens to `_to` in behalf of `_from`
117 	 *
118 	 * @param _from The address of the sender
119 	 * @param _to The address of the recipient
120 	 * @param _value the amount to send
121 	 */
122 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
123 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
124 		allowance[_from][msg.sender] -= _value;
125 		//_transfer(_from, _to, _value);
126 		return true;
127 	}
128 
129 	/**
130 	 * Set allowance for other address
131 	 *
132 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
133 	 *
134 	 * @param _spender The address authorized to spend
135 	 * @param _value the max amount they can spend
136 	 */
137 	function approve(address _spender, uint256 _value) public
138 		returns (bool success) {
139 			allowance[msg.sender][_spender] = _value;
140 			return true;
141 		}
142 
143 	/**
144 	 * Set allowance for other address and notify
145 	 *
146 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
147 	 *
148 	 * @param _spender The address authorized to spend
149 	 * @param _value the max amount they can spend
150 	 * @param _extraData some extra information to send to the approved contract
151 	 */
152 	function approveAndCall(address _spender, uint256 _value, bytes _extraData)
153 		public
154 		returns (bool success) {
155 			tokenRecipient spender = tokenRecipient(_spender);
156 			if (approve(_spender, _value)) {
157 				spender.receiveApproval(msg.sender, _value, this, _extraData);
158 				return true;
159 			}
160 		}
161 
162 	/**
163 	 * Destroy tokens
164 	 *
165 	 * Remove `_value` tokens from the system irreversibly
166 	 *
167 	 * @param _value the amount of money to burn
168 	 */
169 	function burn(uint256 _value) public returns (bool success) {
170 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
171 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
172 		totalSupply -= _value;                      // Updates totalSupply
173 		emit Burn(msg.sender, _value);
174 		return true;
175 	}
176 
177 	/**
178 	 * Destroy tokens from other account
179 	 *
180 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
181 	 *
182 	 * @param _from the address of the sender
183 	 * @param _value the amount of money to burn
184 	 */
185 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
186 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
187 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
188 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
189 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
190 		totalSupply -= _value;                              // Update totalSupply
191 		emit Burn(_from, _value);
192 		return true;
193 	}
194 }
195 
196 /******************************************/
197 /*        WADTOKEN STARTS HERE       */
198 /******************************************/
199 
200 contract WADCoin is Owned, TokenERC20 {
201 	using SafeMath for uint256;
202 
203 	uint256 public sellPrice;
204 	uint256 public buyPrice;
205     address public migrationAgent;
206     uint256 public totalMigrated;
207     address public migrationMaster;
208     
209     mapping(address => bytes32[]) public lockReason;
210 	mapping(address => mapping(bytes32 => lockToken)) public locked;
211     
212 	struct lockToken {
213         uint256 amount;
214         uint256 validity;
215     }
216     
217     // event Lock(
218     //     address indexed _of,
219     //     bytes32 indexed _reason,
220     //     uint256 _amount,
221     //     uint256 _validity
222     // );
223 
224 	/* This generates a public event on the blockchain that will notify clients */
225 	event Migrate(address indexed _from, address indexed _to, uint256 _value);
226     
227 	/* Initializes contract with initial supply tokens to the creator of the contract */
228 	// function MyAdvancedToken(
229 	function WADCoin( uint256 _initialSupply) TokenERC20(_initialSupply) public {
230 // 		initialSupply = _initialSupply;
231 // 		tokenName = _tokenName;
232 // 		tokenSymbol = _tokenSymbol;
233 	}
234 
235 	/// @notice Create `mintedAmount` tokens and send it to `target`
236 	/// @param target Address to receive the tokens
237 	/// @param mintedAmount the amount of tokens it will receive
238 	function mintToken(address target, uint256 mintedAmount) onlyOwner public {
239 		balanceOf[target] += mintedAmount;
240 		totalSupply += mintedAmount;
241 		emit Transfer(0, this, mintedAmount);
242 		emit Transfer(this, target, mintedAmount);
243 	}
244 
245 	/// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
246 	/// @param newSellPrice Price the users can sell to the contract
247 	/// @param newBuyPrice Price users can buy from the contract
248 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
249 		sellPrice = newSellPrice;
250 		buyPrice = newBuyPrice;
251 	}
252     
253     /**
254 	 * Internal transfer, only can be called by this contract
255 	 */
256 	function _transfer(address _from, address _to, uint _value) internal {
257 	    
258 		// Prevent transfer to 0x0 address. Use burn() instead
259 		require(_to != 0x0);
260 		// Check if the sender has enough
261 		require(transferableBalanceOf(_from) >= _value);
262 		// Check for overflows
263 		require(balanceOf[_to] + _value > balanceOf[_to]);
264 		// Save this for an assertion in the future
265 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
266 		// Subtract from the sender
267 		balanceOf[_from] -= _value;
268 		// Add the same to the recipient
269 		balanceOf[_to] += _value;
270 		emit Transfer(_from, _to, _value);
271 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
272 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
273 	}
274 
275 	/**
276 	 * Transfer tokens
277 	 *
278 	 * Send `_value` tokens to `_to` from your account
279 	 *
280 	 * @param _to The address of the recipient
281 	 * @param _value the amount to send
282 	 */
283 	function transfer(address _to, uint256 _value) public {
284 		_transfer(msg.sender, _to, _value);
285 	}
286     
287 	/**
288      * @dev Locks a specified amount of tokens against an address,
289      *      for a specified reason and time
290      */
291     
292     function lock(address _of, bytes32 _reason, uint256 _amount, uint256 _time)
293         onlyOwner
294         public
295         returns (bool)
296     {
297         uint256 validUntil = block.timestamp.add(_time);
298         // If tokens are already locked, the functions extendLock or
299         // increaseLockAmount should be used to make any changes
300         //require(tokensLocked(_of, _reason, block.timestamp) == 0);
301         require(_amount <= transferableBalanceOf(_of));
302         
303         if (locked[_of][_reason].amount == 0)
304             lockReason[_of].push(_reason);
305         
306         if(tokensLocked(_of, _reason, block.timestamp) == 0){
307             locked[_of][_reason] = lockToken(_amount, validUntil);    
308         }else{
309             locked[_of][_reason].amount += _amount;   
310         }
311         
312         //emit Lock(_of, _reason, _amount, validUntil);
313         return true;
314     }
315     
316     /**
317      * @dev Extends lock for a specified reason and time
318      * @param _reason The reason to lock tokens
319      * @param _time Lock extension time in seconds
320      */
321     function extendLock(bytes32 _reason, uint256 _time)
322         public
323         returns (bool)
324     {
325         require(tokensLocked(msg.sender, _reason, block.timestamp) > 0);
326         locked[msg.sender][_reason].validity += _time;
327         // emit Lock(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
328         return true;
329     }
330     
331     
332     /**
333      * @dev Returns tokens locked for a specified address for a
334      *      specified reason at a specified time
335      *
336      * @param _of The address whose tokens are locked
337      * @param _reason The reason to query the lock tokens for
338      * @param _time The timestamp to query the lock tokens for
339      */
340     function tokensLocked(address _of, bytes32 _reason, uint256 _time)
341         public
342         view
343         returns (uint256 amount)
344     {
345         if (locked[_of][_reason].validity > _time)
346             amount = locked[_of][_reason].amount;
347     }
348 
349 	function transferableBalanceOf(address _of)
350 		public
351 		view
352 		returns (uint256 amount)
353 		{
354 			uint256 lockedAmount = 0;
355 			for (uint256 i=0; i < lockReason[_of].length; i++) {
356 				lockedAmount += tokensLocked(_of,lockReason[_of][i], block.timestamp);
357 			}
358 			// amount = balances[_of].sub(lockedAmount);
359 			amount = balanceOf[_of].sub(lockedAmount);
360 			return amount;
361 		}
362     
363 	/// @notice Set address of migration target contract and enable migration
364 	/// process.
365 	/// @dev Required state: Operational Normal
366 	/// @dev State transition: -> Operational Migration
367 	/// @param _agent The address of the MigrationAgent contract
368 	function setMigrationAgent(address _agent) external {
369 		// Abort if not in Operational Normal state.
370 		if (migrationAgent != 0) throw;
371 		if (msg.sender != migrationMaster) throw;
372 		migrationAgent = _agent;
373 	}
374 
375 	function setMigrationMaster(address _master) external {
376 		if (msg.sender != migrationMaster) throw;
377 		if (_master == 0) throw;
378 		migrationMaster = _master;
379 	}
380 	
381 }