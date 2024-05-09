1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9 		if (a == 0) {
10 			return 0;
11 		}
12 		uint256 c = a * b;
13 		assert(c / a == b);
14 		return c;
15 	}
16 
17 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
18 		// assert(b > 0); // Solidity automatically throws when dividing by 0
19 		uint256 c = a / b;
20 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
21 		return c;
22 	}
23 
24 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25 		assert(b <= a);
26 		return a - b;
27 	}
28 
29 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
30 		uint256 c = a + b;
31 		assert(c >= a);
32 		return c;
33 	}
34 }
35 
36 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
37 
38 contract TokenERC20 {
39 	// Public variables of the token
40 	string public name;
41 	string public symbol;
42 	uint8 public decimals = 18;
43 	// 18 decimals is the strongly suggested default, avoid changing it
44 	uint256 public totalSupply;
45 
46 	// This creates an array with all balances
47 	mapping (address => uint256) public balanceOf;
48 	mapping (address => mapping (address => uint256)) public allowance;
49 
50 	// This generates a public event on the blockchain that will notify clients
51 	event Transfer(address indexed from, address indexed to, uint256 value);
52 
53 	// This generates a public event on the blockchain that will notify clients
54 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 
56 	// This notifies clients about the amount burnt
57 	event Burn(address indexed from, uint256 value);
58 
59 	/**
60 	 * Constructor function
61 	 *
62 	 * Initializes contract with initial supply tokens to the creator of the contract
63 	 */
64 	constructor(
65 		uint256 initialSupply,
66 		string tokenName,
67 		string tokenSymbol
68 	) public {
69 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
70 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
71 		name = tokenName;                                   // Set the name for display purposes
72 		symbol = tokenSymbol;                               // Set the symbol for display purposes
73 	}
74 
75 	/**
76 	 * Internal transfer, only can be called by this contract
77 	 */
78 	function _transfer(address _from, address _to, uint _value) internal {
79 		// Prevent transfer to 0x0 address. Use burn() instead
80 		require(_to != 0x0);
81 		// Check if the sender has enough
82 		require(balanceOf[_from] >= _value);
83 		// Check for overflows
84 		require(balanceOf[_to] + _value > balanceOf[_to]);
85 		// Save this for an assertion in the future
86 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
87 		// Subtract from the sender
88 		balanceOf[_from] -= _value;
89 		// Add the same to the recipient
90 		balanceOf[_to] += _value;
91 		emit Transfer(_from, _to, _value);
92 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
93 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
94 	}
95 
96 	/**
97 	 * Transfer tokens
98 	 *
99 	 * Send `_value` tokens to `_to` from your account
100 	 *
101 	 * @param _to The address of the recipient
102 	 * @param _value the amount to send
103 	 */
104 	function transfer(address _to, uint256 _value) public returns (bool success) {
105 		_transfer(msg.sender, _to, _value);
106 		return true;
107 	}
108 
109 	/**
110 	 * Transfer tokens from other address
111 	 *
112 	 * Send `_value` tokens to `_to` in behalf of `_from`
113 	 *
114 	 * @param _from The address of the sender
115 	 * @param _to The address of the recipient
116 	 * @param _value the amount to send
117 	 */
118 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
119 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
120 		allowance[_from][msg.sender] -= _value;
121 		_transfer(_from, _to, _value);
122 		return true;
123 	}
124 
125 	/**
126 	 * Set allowance for other address
127 	 *
128 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
129 	 *
130 	 * @param _spender The address authorized to spend
131 	 * @param _value the max amount they can spend
132 	 */
133 	function approve(address _spender, uint256 _value) public returns (bool success) {
134 		allowance[msg.sender][_spender] = _value;
135 		emit Approval(msg.sender, _spender, _value);
136 		return true;
137 	}
138 
139 	/**
140 	 * Set allowance for other address and notify
141 	 *
142 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
143 	 *
144 	 * @param _spender The address authorized to spend
145 	 * @param _value the max amount they can spend
146 	 * @param _extraData some extra information to send to the approved contract
147 	 */
148 	function approveAndCall(address _spender, uint256 _value, bytes _extraData)
149 		public
150 		returns (bool success) {
151 		tokenRecipient spender = tokenRecipient(_spender);
152 		if (approve(_spender, _value)) {
153 			spender.receiveApproval(msg.sender, _value, this, _extraData);
154 			return true;
155 		}
156 	}
157 
158 	/**
159 	 * Destroy tokens
160 	 *
161 	 * Remove `_value` tokens from the system irreversibly
162 	 *
163 	 * @param _value the amount of money to burn
164 	 */
165 	function burn(uint256 _value) public returns (bool success) {
166 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
167 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
168 		totalSupply -= _value;                      // Updates totalSupply
169 		emit Burn(msg.sender, _value);
170 		return true;
171 	}
172 
173 	/**
174 	 * Destroy tokens from other account
175 	 *
176 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
177 	 *
178 	 * @param _from the address of the sender
179 	 * @param _value the amount of money to burn
180 	 */
181 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
182 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
183 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
184 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
185 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
186 		totalSupply -= _value;                              // Update totalSupply
187 		emit Burn(_from, _value);
188 		return true;
189 	}
190 }
191 
192 contract developed {
193 	address public developer;
194 
195 	/**
196 	 * Constructor
197 	 */
198 	constructor() public {
199 		developer = msg.sender;
200 	}
201 
202 	/**
203 	 * @dev Checks only developer address is calling
204 	 */
205 	modifier onlyDeveloper {
206 		require(msg.sender == developer);
207 		_;
208 	}
209 
210 	/**
211 	 * @dev Allows developer to switch developer address
212 	 * @param _developer The new developer address to be set
213 	 */
214 	function changeDeveloper(address _developer) public onlyDeveloper {
215 		developer = _developer;
216 	}
217 
218 	/**
219 	 * @dev Allows developer to withdraw ERC20 Token
220 	 */
221 	function withdrawToken(address tokenContractAddress) public onlyDeveloper {
222 		TokenERC20 _token = TokenERC20(tokenContractAddress);
223 		if (_token.balanceOf(this) > 0) {
224 			_token.transfer(developer, _token.balanceOf(this));
225 		}
226 	}
227 }
228 
229 contract MyAdvancedToken is developed, TokenERC20 {
230 
231 	uint256 public sellPrice;
232 	uint256 public buyPrice;
233 
234 	mapping (address => bool) public frozenAccount;
235 
236 	/* This generates a public event on the blockchain that will notify clients */
237 	event FrozenFunds(address target, bool frozen);
238 
239 	/* Initializes contract with initial supply tokens to the creator of the contract */
240 	constructor (
241 		uint256 initialSupply,
242 		string tokenName,
243 		string tokenSymbol
244 	) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
245 
246 	/* Internal transfer, only can be called by this contract */
247 	function _transfer(address _from, address _to, uint _value) internal {
248 		require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
249 		require (balanceOf[_from] >= _value);               // Check if the sender has enough
250 		require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
251 		require(!frozenAccount[_from]);                     // Check if sender is frozen
252 		require(!frozenAccount[_to]);                       // Check if recipient is frozen
253 		balanceOf[_from] -= _value;                         // Subtract from the sender
254 		balanceOf[_to] += _value;                           // Add the same to the recipient
255 		emit Transfer(_from, _to, _value);
256 	}
257 
258 	/// @notice Create `mintedAmount` tokens and send it to `target`
259 	/// @param target Address to receive the tokens
260 	/// @param mintedAmount the amount of tokens it will receive
261 	function mintToken(address target, uint256 mintedAmount) onlyDeveloper public {
262 		balanceOf[target] += mintedAmount;
263 		totalSupply += mintedAmount;
264 		emit Transfer(0, this, mintedAmount);
265 		emit Transfer(this, target, mintedAmount);
266 	}
267 
268 	/// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
269 	/// @param target Address to be frozen
270 	/// @param freeze either to freeze it or not
271 	function freezeAccount(address target, bool freeze) onlyDeveloper public {
272 		frozenAccount[target] = freeze;
273 		emit FrozenFunds(target, freeze);
274 	}
275 
276 	/// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
277 	/// @param newSellPrice Price the users can sell to the contract
278 	/// @param newBuyPrice Price users can buy from the contract
279 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyDeveloper public {
280 		sellPrice = newSellPrice;
281 		buyPrice = newBuyPrice;
282 	}
283 
284 	/// @notice Buy tokens from contract by sending ether
285 	function buy() payable public {
286 		uint amount = msg.value / buyPrice;               // calculates the amount
287 		_transfer(this, msg.sender, amount);              // makes the transfers
288 	}
289 
290 	/// @notice Sell `amount` tokens to contract
291 	/// @param amount amount of tokens to be sold
292 	function sell(uint256 amount) public {
293 		address myAddress = this;
294 		require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
295 		_transfer(msg.sender, this, amount);              // makes the transfers
296 		msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
297 	}
298 }
299 
300 /**
301  * @title SpinToken
302  */
303 contract SpinToken is MyAdvancedToken {
304 	using SafeMath for uint256;
305 
306 	bool public paused;
307 
308 	mapping (address => bool) public allowMintTransfer;
309 	mapping (address => bool) public allowBurn;
310 
311 	event Mint(address indexed account, uint256 value);
312 
313 	/**
314 	 * @dev Checks if account address is allowed to mint and transfer
315 	 */
316 	modifier onlyMintTransferBy(address account) {
317 		require(allowMintTransfer[account] == true || account == developer);
318 		_;
319 	}
320 
321 	/**
322 	 * @dev Checks if account address is allowed to burn token
323 	 */
324 	modifier onlyBurnBy(address account) {
325 		require(allowBurn[account] == true || account == developer);
326 		_;
327 	}
328 
329 	/**
330 	 * @dev Checks if contract is currently active
331 	 */
332 	modifier contractIsActive {
333 		require(paused == false);
334 		_;
335 	}
336 
337 	/**
338 	 * Constructor
339 	 * @dev Initializes contract with initial supply tokens to the creator of the contract
340 	 */
341 	constructor(
342 		uint256 initialSupply,
343 		string tokenName,
344 		string tokenSymbol
345 	) MyAdvancedToken(initialSupply, tokenName, tokenSymbol) public {}
346 
347 	/******************************************/
348 	/*       DEVELOPER ONLY METHODS           */
349 	/******************************************/
350 	/**
351 	 * @dev Only developer can pause contract
352 	 * @param _paused The boolean value to be set
353 	 */
354 	function setPaused(bool _paused) public onlyDeveloper {
355 		paused = _paused;
356 	}
357 
358 	/**
359 	 * @dev Only developer can allow `_account` address to mint transfer
360 	 * @param _account The address of the sender
361 	 * @param _allowed The boolean value to be set
362 	 */
363 	function setAllowMintTransfer(address _account, bool _allowed) public onlyDeveloper {
364 		allowMintTransfer[_account] = _allowed;
365 	}
366 
367 	/**
368 	 * @dev Only developer can allow `_account` address to burn token
369 	 * @param _account The address of the sender
370 	 * @param _allowed The boolean value to be set
371 	 */
372 	function setAllowBurn(address _account, bool _allowed) public onlyDeveloper {
373 		allowBurn[_account] = _allowed;
374 	}
375 
376 	/******************************************/
377 	/*            PUBLIC METHODS              */
378 	/******************************************/
379 
380 	/**
381 	 * @dev Get total supply
382 	 * @return The token total supply
383 	 */
384 	function getTotalSupply() public constant returns (uint256) {
385 		return totalSupply;
386 	}
387 
388 	/**
389 	 * @dev Get balance of an account
390 	 * @param account The account to be checked
391 	 * @return The token balance of the account
392 	 */
393 	function getBalanceOf(address account) public constant returns (uint256) {
394 		return balanceOf[account];
395 	}
396 
397 	/**
398 	 * Transfer tokens
399 	 *
400 	 * Send `_value` tokens to `_to` from your account
401 	 *
402 	 * @param _to The address of the recipient
403 	 * @param _value the amount to send
404 	 */
405 	function transfer(address _to, uint256 _value) public contractIsActive returns (bool success) {
406 		_transfer(msg.sender, _to, _value);
407 		return true;
408 	}
409 
410 	/**
411 	 * Transfer tokens from other address
412 	 *
413 	 * Send `_value` tokens to `_to` in behalf of `_from`
414 	 *
415 	 * @param _from The address of the sender
416 	 * @param _to The address of the recipient
417 	 * @param _value the amount to send
418 	 */
419 	function transferFrom(address _from, address _to, uint256 _value) public contractIsActive returns (bool success) {
420 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
421 		allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
422 		_transfer(_from, _to, _value);
423 		return true;
424 	}
425 
426 	/**
427 	 * Set allowance for other address
428 	 *
429 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
430 	 *
431 	 * @param _spender The address authorized to spend
432 	 * @param _value the max amount they can spend
433 	 */
434 	function approve(address _spender, uint256 _value) public contractIsActive returns (bool success) {
435 		allowance[msg.sender][_spender] = _value;
436 		emit Approval(msg.sender, _spender, _value);
437 		return true;
438 	}
439 
440 	/**
441 	 * Set allowance for other address and notify
442 	 *
443 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
444 	 *
445 	 * @param _spender The address authorized to spend
446 	 * @param _value the max amount they can spend
447 	 * @param _extraData some extra information to send to the approved contract
448 	 */
449 	function approveAndCall(address _spender, uint256 _value, bytes _extraData)
450 		public
451 		contractIsActive
452 		returns (bool success) {
453 		tokenRecipient spender = tokenRecipient(_spender);
454 		if (approve(_spender, _value)) {
455 			spender.receiveApproval(msg.sender, _value, this, _extraData);
456 			return true;
457 		}
458 	}
459 
460 	/**
461 	 * Destroy tokens
462 	 *
463 	 * Remove `_value` tokens from the system irreversibly
464 	 *
465 	 * @param _value the amount of money to burn
466 	 */
467 	function burn(uint256 _value) public contractIsActive returns (bool success) {
468 		require(balanceOf[msg.sender] >= _value);						// Check if the sender has enough
469 		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);		// Subtract from the sender
470 		totalSupply = totalSupply.sub(_value);							// Updates totalSupply
471 		emit Burn(msg.sender, _value);
472 		return true;
473 	}
474 
475 	/**
476 	 * Destroy tokens from other account
477 	 *
478 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
479 	 *
480 	 * @param _from the address of the sender
481 	 * @param _value the amount of money to burn
482 	 */
483 	function burnFrom(address _from, uint256 _value) public contractIsActive returns (bool success) {
484 		require(balanceOf[_from] >= _value);									// Check if the targeted balance is enough
485 		require(_value <= allowance[_from][msg.sender]);						// Check allowance
486 		balanceOf[_from] = balanceOf[_from].sub(_value);						// Subtract from the targeted balance
487 		allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);// Subtract from the sender's allowance
488 		totalSupply = totalSupply.sub(_value);									// Update totalSupply
489 		emit Burn(_from, _value);
490 		return true;
491 	}
492 
493 	/// @notice Buy tokens from contract by sending ether
494 	function buy() payable public contractIsActive {
495 		uint amount = msg.value.div(buyPrice);				// calculates the amount
496 		_transfer(this, msg.sender, amount);				// makes the transfers
497 	}
498 
499 	/// @notice Sell `amount` tokens to contract
500 	/// @param amount amount of tokens to be sold
501 	function sell(uint256 amount) public contractIsActive {
502 		address myAddress = this;
503 		require(myAddress.balance >= amount.mul(sellPrice));	// checks if the contract has enough ether to buy
504 		_transfer(msg.sender, this, amount);					// makes the transfers
505 		msg.sender.transfer(amount.mul(sellPrice));				// sends ether to the seller. It's important to do this last to avoid recursion attacks
506 	}
507 
508 	/**
509 	 * @dev Mints and transfers token to `_to` address.
510 	 * @param _to The address of the recipient
511 	 * @param _value The amount of token to mint and transfer
512 	 * @return Return true if success
513 	 */
514 	function mintTransfer(address _to, uint _value) public contractIsActive
515 		onlyMintTransferBy(msg.sender)
516 		returns (bool) {
517 		require(_value > 0);
518 		totalSupply = totalSupply.add(_value);
519 		/*
520 		 * We are actually minting to msg.sender
521 		 * and then transfer from msg.sender to to address
522 		 *
523 		 * Since they cancel out each other, we don't need
524 		 * these executions:
525 		 * balances[msg.sender] = balances[msg.sender].add(value);
526 		 * balances[msg.sender] = balances[msg.sender].sub(value);
527 		 */
528 		balanceOf[_to] = balanceOf[_to].add(_value);
529 		emit Mint(msg.sender, _value);
530 		emit Transfer(msg.sender, _to, _value);
531 		return true;
532 	}
533 
534 	/**
535 	 * @dev Burns token at specific address.
536 	 * @param _at the address of the sender
537 	 * @param _value the amount of token to burn
538 	 * @return true if success
539 	 */
540 	function burnAt(address _at, uint _value) public contractIsActive
541 		onlyBurnBy(msg.sender)
542 		returns (bool) {
543 		balanceOf[_at] = balanceOf[_at].sub(_value);
544 		totalSupply = totalSupply.sub(_value);
545 		emit Burn(_at, _value);
546 		return true;
547 	}
548 
549 	/******************************************/
550 	/*          INTERNAL METHODS              */
551 	/******************************************/
552 
553 	/**
554 	 * @dev Internal transfer, only can be called by this contract
555 	 * @param _from The address of the sender
556 	 * @param _to The address of the recipient
557 	 * @param _value the amount to send
558 	 */
559 	function _transfer(address _from, address _to, uint256 _value) internal contractIsActive {
560 		// Prevent transfer to 0x0 address. Use burn() instead
561 		require(_to != 0x0);
562 		// Check if the sender has enough
563 		require(balanceOf[_from] >= _value);
564 		require(!frozenAccount[_from]);                     // Check if sender is frozen
565 		require(!frozenAccount[_to]);                       // Check if recipient is frozen
566 		// Save this for an assertion in the future
567 		uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
568 		// Subtract from the sender
569 		balanceOf[_from] = balanceOf[_from].sub(_value);
570 		// Add the same to the recipient
571 		balanceOf[_to] = balanceOf[_to].add(_value);
572 		emit Transfer(_from, _to, _value);
573 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
574 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
575 	}
576 }