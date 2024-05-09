1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   constructor() public {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) onlyOwner public {
34     require(newOwner != address(0));
35     emit OwnershipTransferred(owner, newOwner);
36     owner = newOwner;
37   }
38 }
39 
40 
41 /**
42  * @title ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/20
44  */
45 contract ERC20 {
46   uint256 public totalSupply;
47 
48   /**
49    * @param _owner The address from which the balance will be retrieved
50    * @return The balance
51    */
52   function balanceOf(address _owner) public constant returns (uint256 balance);
53 
54   /**
55    * @notice send `_value` token to `_to` from `msg.sender`
56    * @param _to The address of the recipient
57    * @param _value The amount of token to be transferred
58    * @return Whether the transfer was successful or not
59    */
60   function transfer(address _to, uint256 _value) public returns (bool success);
61 
62   /**
63    * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
64    * @param _from The address of the sender
65    * @param _to The address of the recipient
66    * @param _value The amount of token to be transferred
67    * @return Whether the transfer was successful or not
68    */
69   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
70 
71   /**
72    * @notice `msg.sender` approves `_spender` to spend `_value` tokens
73    * @param _spender The address of the account able to transfer the tokens
74    * @param _value The amount of tokens to be approved for transfer
75    * @return Whether the approval was successful or not
76    */
77   function approve(address _spender, uint256 _value) public returns (bool success);
78 
79   /**
80    * @param _owner The address of the account owning tokens
81    * @param _spender The address of the account able to transfer the tokens
82    * @return Amount of remaining tokens allowed to spent
83    */
84   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
85 
86   /**
87    * MUST trigger when tokens are transferred, including zero value transfers.
88    */
89   event Transfer(address indexed _from, address indexed _to, uint256 _value);
90 
91   /**
92    * MUST trigger on any successful call to approve(address _spender, uint256 _value)
93    */
94   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95 }
96 
97 library SafeMath {
98 	/**
99 	* @notice Adds two numbers, throws on overflow.
100 	*/
101 	function add(
102 		uint256 a,
103 		uint256 b
104 	)
105 		internal pure returns (uint256 c)
106 	{
107 		c = a + b;
108 		assert(c >= a);
109 		return c;
110 	}
111 
112 	/**
113 	* @notice Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
114 	*/
115 	function sub(
116 		uint256 a,
117 		uint256 b
118 	)
119 		internal pure returns (uint256)
120 	{
121 		assert(b <= a);
122 		return a - b;
123 	}
124 
125 
126 	/**
127 	* @notice Multiplies two numbers, throws on overflow.
128 	*/
129 	function mul(
130 		uint256 a,
131 		uint256 b
132 	)
133 		internal pure returns (uint256 c)
134 	{
135 		if (a == 0) {
136 				return 0;
137 		}
138 		c = a * b;
139 		assert(c / a == b);
140 		return c;
141 	}
142 
143 	/**
144 	* @dev Integer division of two numbers, truncating the quotient.
145 	*/
146 	function div(
147 		uint256 a,
148 		uint256 b
149 	)
150 		internal pure returns (uint256)
151 	{
152 		// assert(b > 0); // Solidity automatically throws when dividing by 0
153 		// uint256 c = a / b;
154 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
155 		return a / b;
156 	}
157 }
158 
159 contract F2KToken is ERC20, Ownable {
160 	// Adding safe calculation methods to uint256
161 	using SafeMath for uint256;
162 
163 	// Defining balances mapping (ERC20)
164 	mapping(address => uint256) balances;
165 
166 	// Defining allowances mapping (ERC20)
167 	mapping(address => mapping(address => uint256)) allowed;
168 
169 	// Defining addresses allowed to bypass global freeze
170 	mapping(address => bool) public freezeBypassing;
171 
172 	// Defining addresses that have custom lockups periods
173 	mapping(address => uint256) public lockupExpirations;
174 
175 	// Token Symbol
176 	string public constant symbol = "F2K";
177 
178 	// Token Name
179 	string public constant name = "Farm2Kitchen Token";
180 
181 	// Token Decimals
182 	uint8 public constant decimals = 2;
183 
184 	// global freeze one-way toggle
185 	bool public tradingLive;
186 
187 	// Total supply of token
188 	uint256 public totalSupply;
189 
190     constructor() public {
191         totalSupply = 280000000 * (10 ** uint256(decimals));
192         balances[owner] = totalSupply;
193         emit Transfer(address(0), owner, totalSupply);
194     }
195 
196 	/**
197 	 * @notice Event for Lockup period applied to address
198 	 * @param owner Specific lockup address target
199 	 * @param until Timestamp when lockup end (seconds since epoch)
200 	 */
201 	event LockupApplied(
202 		address indexed owner,
203 		uint256 until
204 	);
205 	
206 	/**
207 	 * @notice distribute tokens to an address
208 	 * @param to Who will receive the token
209 	 * @param tokenAmount How much token will be sent
210 	 */
211 	function distribute(
212 			address to,
213 			uint256 tokenAmount
214 	)
215 			public onlyOwner
216 	{
217 			require(tokenAmount > 0);
218 			require(tokenAmount <= balances[msg.sender]);
219 
220 			balances[msg.sender] = balances[msg.sender].sub(tokenAmount);
221 			balances[to] = balances[to].add(tokenAmount);
222 
223 			emit Transfer(owner, to, tokenAmount);
224 	}
225 
226 	/**
227 	 * @notice Prevents the given wallet to transfer its token for the given duration.
228 	 *      This methods resets the lock duration if one is already in place.
229 	 * @param wallet The wallet address to lock
230 	 * @param duration How much time is the token locked from now (in sec)
231 	 */
232 	function lockup(
233 			address wallet,
234 			uint256 duration
235 	)
236 			public onlyOwner
237 	{
238 			uint256 lockupExpiration = duration.add(now);
239 			lockupExpirations[wallet] = lockupExpiration;
240 			emit LockupApplied(wallet, lockupExpiration);
241 	}
242 
243 	/**
244 	 * @notice choose if an address is allowed to bypass the global freeze
245 	 * @param to Target of the freeze bypass status update
246 	 * @param status New status (if true will bypass)
247 	 */
248 	function setBypassStatus(
249 			address to,
250 			bool status
251 	)
252 			public onlyOwner
253 	{
254 			freezeBypassing[to] = status;
255 	}
256 
257 	/**
258 	 * @notice One-way toggle to allow trading (remove global freeze)
259 	 * @param status New status (if true will bypass)
260 	 */
261 	function setTrading(
262 			bool status
263 	) 
264 		public onlyOwner 
265 	{
266 			tradingLive = status;
267 	}
268 
269 	/**
270 	 * @notice Modifier that checks if the conditions are met for a token to be
271 	 * tradable. To be so, it must :
272 	 *  - Global Freeze must be removed, or, "from" must be allowed to bypass it
273 	 *  - "from" must not be in a custom lockup period
274 	 * @param from Who to check the status
275 	 */
276 	modifier tradable(address from) {
277 			require(
278 					(tradingLive || freezeBypassing[from]) && //solium-disable-line indentation
279 					(lockupExpirations[from] <= now)
280 			);
281 			_;
282 	}
283 
284 	/**
285 	 * @notice Return the total supply of the token
286 	 * @dev This function is part of the ERC20 standard 
287 	 * @return {"totalSupply": "The token supply"}
288 	 */
289 	function totalSupply() public view returns (uint256 supply) {
290 			return totalSupply;
291 	}
292 
293 	/**
294 	 * @notice Get the token balance of `owner`
295 	 * @dev This function is part of the ERC20 standard
296 	 * @param owner The wallet to get the balance of
297 	 * @return {"balance": "The balance of `owner`"}
298 	 */
299 	function balanceOf(
300 			address owner
301 	)
302 			public view returns (uint256 balance)
303 	{
304 			return balances[owner];
305 	}
306 
307 	/**
308 	 * @notice Transfers `amount` from msg.sender to `destination`
309 	 * @dev This function is part of the ERC20 standard
310 	 * @param to The address that receives the tokens
311 	 * @param tokenAmount Token amount to transfer
312 	 * @return {"success": "If the operation completed successfuly"}
313 	 */
314 	function transfer(
315 			address to,
316 			uint256 tokenAmount
317 	)
318 			public tradable(msg.sender) returns (bool success)
319 	{
320 			require(tokenAmount > 0);
321 			require(tokenAmount <= balances[msg.sender]);
322 
323 			balances[msg.sender] = balances[msg.sender].sub(tokenAmount);
324 			balances[to] = balances[to].add(tokenAmount);
325 			emit Transfer(msg.sender, to, tokenAmount);
326 			return true;
327 	}
328 
329 	/**
330 	 * @notice Transfer tokens from an address to another one
331 	 * through an allowance made before
332 	 * @dev This function is part of the ERC20 standard
333 	 * @param from The address that sends the tokens
334 	 * @param to The address that receives the tokens
335 	 * @param tokenAmount Token amount to transfer
336 	 * @return {"success": "If the operation completed successfuly"}
337 	 */
338 	function transferFrom(
339 			address from,
340 			address to,
341 			uint256 tokenAmount
342 	)
343 			public tradable(from) returns (bool success)
344 	{
345 			require(tokenAmount > 0);
346 			require(tokenAmount <= balances[from]);
347 			require(tokenAmount <= allowed[from][msg.sender]);
348 			
349 			balances[from] = balances[from].sub(tokenAmount);
350 			allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokenAmount);
351 			balances[to] = balances[to].add(tokenAmount);
352 			
353 			emit Transfer(from, to, tokenAmount);
354 			return true;
355 	}
356 	
357 	/**
358 	 * @notice Approve an address to send `tokenAmount` tokens to `msg.sender` (make an allowance)
359 	 * @dev This function is part of the ERC20 standard
360 	 * @param spender The allowed address
361 	 * @param tokenAmount The maximum amount allowed to spend
362 	 * @return {"success": "If the operation completed successfuly"}
363 	 */
364 	function approve(
365 			address spender,
366 			uint256 tokenAmount
367 	)
368 			public returns (bool success)
369 	{
370 			allowed[msg.sender][spender] = tokenAmount;
371 			emit Approval(msg.sender, spender, tokenAmount);
372 			return true;
373 	}
374 
375 	/**
376 	* @notice Increase the amount of tokens that an owner allowed to a spender.
377 	* To increment allowed value it is better to use this function to avoid double withdrawal attack. 
378 	* @param spender The address which will spend the funds.
379 	* @param tokenAmount The amount of tokens to increase the allowance by.
380 	*/
381 	function increaseApproval(
382 			address spender,
383 			uint tokenAmount
384 	)
385 			public returns (bool)
386 	{
387 			allowed[msg.sender][spender] = (allowed[msg.sender][spender].add(tokenAmount));
388 			emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
389 			
390 			return true;
391 	}
392 
393 	/**
394 	* @notice Decrease the amount of tokens that an owner allowed to a spender.
395 	* To decrease the allowed value it is better to use this function to avoid double withdrawal attack. 
396 	* @param spender The address which will spend the funds.
397 	* @param tokenAmount The amount of tokens to decrease the allowance by.
398 	*/
399 	function decreaseApproval(
400 			address spender,
401 			uint tokenAmount
402 	)
403 			public returns (bool)
404 	{
405 			uint oldValue = allowed[msg.sender][spender];
406 			if (tokenAmount > oldValue) {
407 				allowed[msg.sender][spender] = 0;
408 			} else {
409 				allowed[msg.sender][spender] = oldValue.sub(tokenAmount);
410 			}
411 			emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
412 			
413 			return true;
414 	}
415 	
416 	/**
417 	 * @notice Get the remaining allowance for a spender on a given address
418 	 * @dev This function is part of the ERC20 standard
419 	 * @param tokenOwner The address that owns the tokens
420 	 * @param spender The spender
421 	 * @return {"remaining": "The amount of tokens remaining in the allowance"}
422 	 */
423 	function allowance(
424 			address tokenOwner,
425 			address spender
426 	)
427 			public view returns (uint256 remaining)
428 	{
429 			return allowed[tokenOwner][spender];
430 	}
431 
432 	function burn(
433 			uint tokenAmount
434 	) 
435 			public onlyOwner returns (bool)
436 	{
437 		require(balances[msg.sender] >= tokenAmount);
438 		balances[msg.sender] = balances[msg.sender].sub(tokenAmount);
439 		totalSupply = totalSupply.sub(tokenAmount);
440 		return true;
441 	}
442 
443 	/**
444 	 * @notice Permits to withdraw any ERC20 tokens that have been mistakingly sent to this contract
445 	 * @param tokenAddress The received ERC20 token address
446 	 * @param tokenAmount The amount of ERC20 tokens to withdraw from this contract
447 	 * @return {"success": "If the operation completed successfuly"}
448 	 */
449 	function withdrawERC20Token(
450 			address tokenAddress,
451 			uint256 tokenAmount
452 	)
453 			public onlyOwner returns (bool success)
454 	{
455 			return ERC20(tokenAddress).transfer(owner, tokenAmount);
456 	}
457 
458 }