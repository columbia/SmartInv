1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 	function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
10 		if (_a == 0) {
11 			return 0;
12 		}
13 		uint256 c = _a * _b;
14 		assert(c / _a == _b);
15 		return c;
16 	}
17 
18 	function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
19 		return _a / _b;
20 	}
21 
22 	function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
23 		assert(_b <= _a);
24 		return _a - _b;
25 	}
26 
27 	function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
28 		uint256 c = _a + _b;
29 		assert(c >= _a);
30 		return c;
31 	}
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract holds owner addresses, and provides basic authorization control
37  * functions.
38  */
39 contract Ownable {
40 	/**
41 	* @dev Allows to check if the given address has owner rights.
42 	* @param _owner The address to check for owner rights.
43 	* @return True if the address is owner, false if it is not.
44 	*/
45 	mapping(address => bool) public owners;
46 	
47 	/**
48 	* @dev The Ownable constructor adds the sender
49 	* account to the owners mapping.
50 	*/
51 	constructor() public {
52 		owners[msg.sender] = true;
53 	}
54 
55 	/**
56 	* @dev Throws if called by any account other than the owner.
57 	*/
58 	modifier onlyOwners() {
59 		require(owners[msg.sender], 'Owner message sender required.');
60 		_;
61 	}
62 
63 	/**
64 	* @dev Allows the current owners to grant or revoke 
65 	* owner-level access rights to the contract.
66 	* @param _owner The address to grant or revoke owner rights.
67 	* @param _isAllowed Boolean granting or revoking owner rights.
68 	* @return True if the operation has passed or throws if failed.
69 	*/
70 	function setOwner(address _owner, bool _isAllowed) public onlyOwners {
71 		require(_owner != address(0), 'Non-zero owner-address required.');
72 		owners[_owner] = _isAllowed;
73 	}
74 }
75 
76 /**
77  * @title Destroyable
78  * @dev Base contract that can be destroyed by the owners. All funds in contract will be sent back.
79  */
80 contract Destroyable is Ownable {
81 
82 	constructor() public payable {}
83 
84 	/**
85 	* @dev Transfers The current balance to the message sender and terminates the contract.
86 	*/
87 	function destroy() public onlyOwners {
88 		selfdestruct(msg.sender);
89 	}
90 
91 	/**
92 	* @dev Transfers The current balance to the specified _recipient and terminates the contract.
93 	* @param _recipient The address to send the current balance to.
94 	*/
95 	function destroyAndSend(address _recipient) public onlyOwners {
96 		require(_recipient != address(0), 'Non-zero recipient address required.');
97 		selfdestruct(_recipient);
98 	}
99 }
100 
101 /**
102  * @title BotOperated
103  * @dev The BotOperated contract holds bot addresses, and provides basic authorization control
104  * functions.
105  */
106 contract BotOperated is Ownable {
107 	/**
108 	* @dev Allows to check if the given address has bot rights.
109 	* @param _bot The address to check for bot rights.
110 	* @return True if the address is bot, false if it is not.
111 	*/
112 	mapping(address => bool) public bots;
113 
114 	/**
115 	 * @dev Throws if called by any account other than bot or owner.
116 	 */
117 	modifier onlyBotsOrOwners() {
118 		require(bots[msg.sender] || owners[msg.sender], 'Bot or owner message sender required.');
119 		_;
120 	}
121 
122 	/**
123 	* @dev Throws if called by any account other than the bot.
124 	*/
125 	modifier onlyBots() {
126 		require(bots[msg.sender], 'Bot message sender required.');
127 		_;
128 	}
129 
130 	/**
131 	* @dev The BotOperated constructor adds the sender
132 	* account to the bots mapping.
133 	*/
134 	constructor() public {
135 		bots[msg.sender] = true;
136 	}
137 
138 	/**
139 	* @dev Allows the current owners to grant or revoke 
140 	* bot-level access rights to the contract.
141 	* @param _bot The address to grant or revoke bot rights.
142 	* @param _isAllowed Boolean granting or revoking bot rights.
143 	* @return True if the operation has passed or throws if failed.
144 	*/
145 	function setBot(address _bot, bool _isAllowed) public onlyOwners {
146 		require(_bot != address(0), 'Non-zero bot-address required.');
147 		bots[_bot] = _isAllowed;
148 	}
149 }
150 
151 /**
152 * @title Pausable
153 * @dev Base contract which allows children to implement an emergency stop mechanism.
154 */
155 contract Pausable is BotOperated {
156 	event Pause();
157 	event Unpause();
158 
159 	bool public paused = true;
160 
161 	/**
162 	* @dev Modifier to allow actions only when the contract IS NOT paused.
163 	*/
164 	modifier whenNotPaused() {
165 		require(!paused, 'Unpaused contract required.');
166 		_;
167 	}
168 
169 	/**
170 	* @dev Called by the owner to pause, triggers stopped state.
171 	* @return True if the operation has passed.
172 	*/
173 	function pause() public onlyBotsOrOwners {
174 		paused = true;
175 		emit Pause();
176 	}
177 
178 	/**
179 	* @dev Called by the owner to unpause, returns to normal state.
180 	* @return True if the operation has passed.
181 	*/
182 	function unpause() public onlyBotsOrOwners {
183 		paused = false;
184 		emit Unpause();
185 	}
186 }
187 
188 interface EternalDataStorage {
189 	function balances(address _owner) external view returns (uint256);
190 
191 	function setBalance(address _owner, uint256 _value) external;
192 
193 	function allowed(address _owner, address _spender) external view returns (uint256);
194 
195 	function setAllowance(address _owner, address _spender, uint256 _amount) external;
196 
197 	function totalSupply() external view returns (uint256);
198 
199 	function setTotalSupply(uint256 _value) external;
200 
201 	function frozenAccounts(address _target) external view returns (bool isFrozen);
202 
203 	function setFrozenAccount(address _target, bool _isFrozen) external;
204 
205 	function increaseAllowance(address _owner,  address _spender, uint256 _increase) external;
206 
207 	function decreaseAllowance(address _owner,  address _spender, uint256 _decrease) external;
208 }
209 
210 interface Ledger {
211 	function addTransaction(address _from, address _to, uint _tokens) external;
212 }
213 
214 interface WhitelistData {
215 	function kycId(address _customer) external view returns (bytes32);
216 }
217 
218 
219 /**
220  * @title ERC20Standard token
221  * @dev Implementation of the basic standard token.
222  * @notice https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
223  */
224 contract ERC20Standard {
225 	
226 	using SafeMath for uint256;
227 
228 	EternalDataStorage internal dataStorage;
229 
230 	Ledger internal ledger;
231 
232 	WhitelistData internal whitelist;
233 
234 	/**
235 	 * @dev Triggered when tokens are transferred.
236 	 * @notice MUST trigger when tokens are transferred, including zero value transfers.
237 	 */
238 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
239 
240 	/**
241 	 * @dev Triggered whenever approve(address _spender, uint256 _value) is called.
242 	 * @notice MUST trigger on any successful call to approve(address _spender, uint256 _value).
243 	 */
244 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
245 
246 	modifier isWhitelisted(address _customer) {
247 		require(whitelist.kycId(_customer) != 0x0, 'Whitelisted customer required.');
248 		_;
249 	}
250 
251 	/**
252 	 * @dev Constructor function that instantiates the EternalDataStorage, Ledger and Whitelist contracts.
253 	 * @param _dataStorage Address of the Data Storage Contract.
254 	 * @param _ledger Address of the Ledger Contract.
255 	 * @param _whitelist Address of the Whitelist Data Contract.
256 	 */
257 	constructor(address _dataStorage, address _ledger, address _whitelist) public {
258 		require(_dataStorage != address(0), 'Non-zero data storage address required.');
259 		require(_ledger != address(0), 'Non-zero ledger address required.');
260 		require(_whitelist != address(0), 'Non-zero whitelist address required.');
261 
262 		dataStorage = EternalDataStorage(_dataStorage);
263 		ledger = Ledger(_ledger);
264 		whitelist = WhitelistData(_whitelist);
265 	}
266 
267 	/**
268 	 * @dev Gets the total supply of tokens.
269 	 * @return totalSupplyAmount The total amount of tokens.
270 	 */
271 	function totalSupply() public view returns (uint256 totalSupplyAmount) {
272 		return dataStorage.totalSupply();
273 	}
274 
275 	/**
276 	 * @dev Get the balance of the specified `_owner` address.
277 	 * @return balance The token balance of the given address.
278 	 */
279 	function balanceOf(address _owner) public view returns (uint256 balance) {
280 		return dataStorage.balances(_owner);
281 	}
282 
283 	/**
284 	 * @dev Transfer token to a specified address.
285 	 * @param _to The address to transfer to.
286 	 * @param _value The amount to be transferred.
287 	 * @return success True if the transfer was successful, or throws.
288 	 */
289 	function transfer(address _to, uint256 _value) public returns (bool success) {
290 		return _transfer(msg.sender, _to, _value);
291 	}
292 
293 	/**
294 	 * @dev Transfer `_value` tokens to `_to` in behalf of `_from`.
295 	 * @param _from The address of the sender.
296 	 * @param _to The address of the recipient.
297 	 * @param _value The amount to send.
298 	 * @return success True if the transfer was successful, or throws.
299 	 */    
300 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
301 		uint256 allowed = dataStorage.allowed(_from, msg.sender);
302 		require(allowed >= _value, 'From account has insufficient balance');
303 
304 		allowed = allowed.sub(_value);
305 		dataStorage.setAllowance(_from, msg.sender, allowed);
306 
307 		return _transfer(_from, _to, _value);
308 	}
309 
310 	/**
311 	 * @dev Allows `_spender` to withdraw from your account multiple times, up to the `_value` amount.
312 	 * approve will revert if allowance of _spender is 0. increaseApproval and decreaseApproval should
313 	 * be used instead to avoid exploit identified here: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approve
314 	 * @notice If this function is called again it overwrites the current allowance with `_value`.
315 	 * @param _spender The address authorized to spend.
316 	 * @param _value The max amount they can spend.
317 	 * @return success True if the operation was successful, or false.
318 	 */
319 	 
320 	function approve(address _spender, uint256 _value) public returns (bool success) {
321 		require
322 		(
323 			_value == 0 || dataStorage.allowed(msg.sender, _spender) == 0,
324 			'Approve value is required to be zero or account has already been approved.'
325 		);
326 		
327 		dataStorage.setAllowance(msg.sender, _spender, _value);
328 		
329 		emit Approval(msg.sender, _spender, _value);
330 		
331 		return true;
332 	}
333 
334 	/**
335 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
336 	 * This function must be called for increasing approval from a non-zero value
337 	 * as using approve will revert. It has been added as a fix to the exploit mentioned
338 	 * here: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approve
339 	 * @param _spender The address which will spend the funds.
340 	 * @param _addedValue The amount of tokens to increase the allowance by.
341 	 */
342 	function increaseApproval(address _spender, uint256 _addedValue) public {
343 		dataStorage.increaseAllowance(msg.sender, _spender, _addedValue);
344 		
345 		emit Approval(msg.sender, _spender, dataStorage.allowed(msg.sender, _spender));
346 	}
347 
348 	/**
349 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
350 	 * This function must be called for decreasing approval from a non-zero value
351 	 * as using approve will revert. It has been added as a fix to the exploit mentioned
352 	 * here: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#approve
353 	 * allowed value is better to use this function to avoid 2 calls (and wait until
354 	 * the first transaction is mined)
355 	 * @param _spender The address which will spend the funds.
356 	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
357 	 */
358 	function decreaseApproval(address _spender, uint256 _subtractedValue) public {		
359 		dataStorage.decreaseAllowance(msg.sender, _spender, _subtractedValue);
360 		
361 		emit Approval(msg.sender, _spender, dataStorage.allowed(msg.sender, _spender));
362 	}
363 
364 	/**
365 	* @dev Function to check the amount of tokens that an owner allowed to a spender.
366 	* @param _owner The address which owns the funds.
367 	* @param _spender The address which will spend the funds.
368 	* @return A uint256 specifying the amount of tokens still available for the spender.
369 	*/
370 	function allowance(address _owner, address _spender) public view returns (uint256) {
371 		return dataStorage.allowed(_owner, _spender);
372 	}
373 
374 	/**
375 	 * @dev Internal transfer, can only be called by this contract.
376 	 * @param _from The address of the sender.
377 	 * @param _to The address of the recipient.
378 	 * @param _value The amount to send.
379 	 * @return success True if the transfer was successful, or throws.
380 	 */
381 	function _transfer(address _from, address _to, uint256 _value) internal returns (bool success) {
382 		require(_to != address(0), 'Non-zero to-address required.');
383 		uint256 fromBalance = dataStorage.balances(_from);
384 		require(fromBalance >= _value, 'From-address has insufficient balance.');
385 
386 		fromBalance = fromBalance.sub(_value);
387 
388 		uint256 toBalance = dataStorage.balances(_to);
389 		toBalance = toBalance.add(_value);
390 
391 		dataStorage.setBalance(_from, fromBalance);
392 		dataStorage.setBalance(_to, toBalance);
393 
394 		ledger.addTransaction(_from, _to, _value);
395 
396 		emit Transfer(_from, _to, _value);
397 
398 		return true;
399 	}
400 }
401 
402 /**
403  * @title MintableToken
404  * @dev ERC20Standard modified with mintable token creation.
405  */
406 contract MintableToken is ERC20Standard, Ownable {
407 
408 	/**
409 	 * @dev Hardcap - maximum allowed amount of tokens to be minted
410 	 */
411 	uint104 public constant MINTING_HARDCAP = 1e30;
412 
413 	/**
414 	* @dev Auto-generated function to check whether the minting has finished.
415 	* @return True if the minting has finished, or false.
416 	*/
417 	bool public mintingFinished = false;
418 
419 	event Mint(address indexed _to, uint256 _amount);
420 	
421 	event MintFinished();
422 
423 	modifier canMint() {
424 		require(!mintingFinished, 'Uninished minting required.');
425 		_;
426 	}
427 
428 	/**
429 	* @dev Function to mint tokens
430 	* @param _to The address that will receive the minted tokens.
431 	* @param _amount The amount of tokens to mint.
432 	*/
433 	function mint(address _to, uint256 _amount) public onlyOwners canMint() {
434 		uint256 totalSupply = dataStorage.totalSupply();
435 		totalSupply = totalSupply.add(_amount);
436 		
437 		require(totalSupply <= MINTING_HARDCAP, 'Total supply of token in circulation must be below hardcap.');
438 		
439 		dataStorage.setTotalSupply(totalSupply);
440 
441 		uint256 toBalance = dataStorage.balances(_to);
442 		toBalance = toBalance.add(_amount);
443 		dataStorage.setBalance(_to, toBalance);
444 
445 		ledger.addTransaction(address(0), _to, _amount);
446 
447 		emit Transfer(address(0), _to, _amount);
448 
449 		emit Mint(_to, _amount);
450 	}
451 
452 	/**
453 	* @dev Function to permanently stop minting new tokens.
454 	*/
455 	function finishMinting() public onlyOwners {
456 		mintingFinished = true;
457 		emit MintFinished();
458 	}
459 }
460 
461 /**
462  * @title BurnableToken
463  * @dev ERC20Standard token that can be irreversibly burned(destroyed).
464  */
465 contract BurnableToken is ERC20Standard {
466 
467 	event Burn(address indexed _burner, uint256 _value);
468 	
469 	/**
470 	 * @dev Remove tokens from the system irreversibly.
471 	 * @notice Destroy tokens from your account.
472 	 * @param _value The amount of tokens to burn.
473 	 */
474 	function burn(uint256 _value) public {
475 		uint256 senderBalance = dataStorage.balances(msg.sender);
476 		require(senderBalance >= _value, 'Burn value less than account balance required.');
477 		senderBalance = senderBalance.sub(_value);
478 		dataStorage.setBalance(msg.sender, senderBalance);
479 
480 		uint256 totalSupply = dataStorage.totalSupply();
481 		totalSupply = totalSupply.sub(_value);
482 		dataStorage.setTotalSupply(totalSupply);
483 
484 		emit Burn(msg.sender, _value);
485 
486 		emit Transfer(msg.sender, address(0), _value);
487 	}
488 
489 	/**
490 	 * @dev Remove specified `_value` tokens from the system irreversibly on behalf of `_from`.
491 	 * @param _from The address from which to burn tokens.
492 	 * @param _value The amount of money to burn.
493 	 */
494 	function burnFrom(address _from, uint256 _value) public {
495 		uint256 fromBalance = dataStorage.balances(_from);
496 		require(fromBalance >= _value, 'Burn value less than from-account balance required.');
497 
498 		uint256 allowed = dataStorage.allowed(_from, msg.sender);
499 		require(allowed >= _value, 'Burn value less than account allowance required.');
500 
501 		fromBalance = fromBalance.sub(_value);
502 		dataStorage.setBalance(_from, fromBalance);
503 
504 		allowed = allowed.sub(_value);
505 		dataStorage.setAllowance(_from, msg.sender, allowed);
506 
507 		uint256 totalSupply = dataStorage.totalSupply();
508 		totalSupply = totalSupply.sub(_value);
509 		dataStorage.setTotalSupply(totalSupply);
510 
511 		emit Burn(_from, _value);
512 
513 		emit Transfer(_from, address(0), _value);
514 	}
515 }
516 
517 /**
518  * @title PausableToken
519  * @dev ERC20Standard modified with pausable transfers.
520  **/
521 contract PausableToken is ERC20Standard, Pausable {
522 	
523 	function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
524 		return super.transfer(_to, _value);
525 	}
526 
527 	function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
528 		return super.transferFrom(_from, _to, _value);
529 	}
530 
531 	function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
532 		return super.approve(_spender, _value);
533 	}
534 }
535 
536 /**
537  * @title FreezableToken
538  * @dev ERC20Standard modified with freezing accounts ability.
539  */
540 contract FreezableToken is ERC20Standard, Ownable {
541 
542 	event FrozenFunds(address indexed _target, bool _isFrozen);
543 
544 	/**
545 	 * @dev Allow or prevent target address from sending & receiving tokens.
546 	 * @param _target Address to be frozen or unfrozen.
547 	 * @param _isFrozen Boolean indicating freeze or unfreeze operation.
548 	 */ 
549 	function freezeAccount(address _target, bool _isFrozen) public onlyOwners {
550 		require(_target != address(0), 'Non-zero to-be-frozen-account address required.');
551 		dataStorage.setFrozenAccount(_target, _isFrozen);
552 		emit FrozenFunds(_target, _isFrozen);
553 	}
554 
555 	/**
556 	 * @dev Checks whether the target is frozen or not.
557 	 * @param _target Address to check.
558 	 * @return isFrozen A boolean that indicates whether the account is frozen or not. 
559 	 */
560 	function isAccountFrozen(address _target) public view returns (bool isFrozen) {
561 		return dataStorage.frozenAccounts(_target);
562 	}
563 
564 	/**
565 	 * @dev Overrided _transfer function that uses freeze functionality
566 	 */
567 	function _transfer(address _from, address _to, uint256 _value) internal returns (bool success) {
568 		assert(!dataStorage.frozenAccounts(_from));
569 
570 		assert(!dataStorage.frozenAccounts(_to));
571 		
572 		return super._transfer(_from, _to, _value);
573 	}
574 }
575 
576 /**
577  * @title ERC20Extended
578  * @dev Standard ERC20 token with extended functionalities.
579  */
580 contract ERC20Extended is FreezableToken, PausableToken, BurnableToken, MintableToken, Destroyable {
581 	/**
582 	* @dev Auto-generated function that returns the name of the token.
583 	* @return The name of the token.
584 	*/
585 	string public constant name = 'ORBISE10';
586 
587 	/**
588 	* @dev Auto-generated function that returns the symbol of the token.
589 	* @return The symbol of the token.
590 	*/
591 	string public constant symbol = 'ORBT';
592 
593 	/**
594 	* @dev Auto-generated function that returns the number of decimals of the token.
595 	* @return The number of decimals of the token.
596 	*/
597 	uint8 public constant decimals = 18;
598 
599 	/**
600 	* @dev Constant for the minimum allowed amount of tokens one can buy
601 	*/
602 	uint72 public constant MINIMUM_BUY_AMOUNT = 200e18;
603 
604 	/**
605 	* @dev Auto-generated function that gets the price at which the token is sold.
606 	* @return The sell price of the token.
607 	*/
608 	uint256 public sellPrice;
609 
610 	/**
611 	* @dev Auto-generated function that gets the price at which the token is bought.
612 	* @return The buy price of the token.
613 	*/
614 	uint256 public buyPrice;
615 
616 	/**
617 	* @dev Auto-generated function that gets the address of the wallet of the contract.
618 	* @return The address of the wallet.
619 	*/
620 	address public wallet;
621 
622 	/**
623 	* @dev Constructor function that calculates the total supply of tokens, 
624 	* sets the initial sell and buy prices and
625 	* passes arguments to base constructors.
626 	* @param _dataStorage Address of the Data Storage Contract.
627 	* @param _ledger Address of the Data Storage Contract.
628 	* @param _whitelist Address of the Whitelist Data Contract.
629 	*/
630 	constructor
631 	(
632 		address _dataStorage,
633 		address _ledger,
634 		address _whitelist
635 	)
636 		ERC20Standard(_dataStorage, _ledger, _whitelist)
637 		public 
638 	{
639 	}
640 
641 	/**
642 	* @dev Fallback function that allows the contract
643 	* to receive Ether directly.
644 	*/
645 	function() public payable { }
646 
647 	/**
648 	* @dev Function that sets both the sell and the buy price of the token.
649 	* @param _sellPrice The price at which the token will be sold.
650 	* @param _buyPrice The price at which the token will be bought.
651 	*/
652 	function setPrices(uint256 _sellPrice, uint256 _buyPrice) public onlyBotsOrOwners {
653 		sellPrice = _sellPrice;
654 		buyPrice = _buyPrice;
655 	}
656 
657 	/**
658 	* @dev Function that sets the current wallet address.
659 	* @param _walletAddress The address of wallet to be set.
660 	*/
661 	function setWallet(address _walletAddress) public onlyOwners {
662 		require(_walletAddress != address(0), 'Non-zero wallet address required.');
663 		wallet = _walletAddress;
664 	}
665 
666 	/**
667 	* @dev Send Ether to buy tokens at the current token sell price.
668 	* @notice buy function has minimum allowed amount one can buy
669 	*/
670 	function buy() public payable whenNotPaused isWhitelisted(msg.sender) {
671 		uint256 amount = msg.value.mul(1e18);
672 		
673 		amount = amount.div(sellPrice);
674 
675 		require(amount >= MINIMUM_BUY_AMOUNT, "Buy amount too small");
676 		
677 		_transfer(this, msg.sender, amount);
678 	}
679 	
680 	/**
681 	* @dev Sell `_amount` tokens at the current buy price.
682 	* @param _amount The amount to sell.
683 	*/
684 	function sell(uint256 _amount) public whenNotPaused {
685 		uint256 toBeTransferred = _amount.mul(buyPrice);
686 
687 		require(toBeTransferred >= 1e18, "Sell amount too small");
688 
689 		toBeTransferred = toBeTransferred.div(1e18);
690 
691 		require(address(this).balance >= toBeTransferred, 'Contract has insufficient balance.');
692 		_transfer(msg.sender, this, _amount);
693 		
694 		msg.sender.transfer(toBeTransferred);
695 	}
696 
697 	/**
698 	* @dev Get the contract balance in WEI.
699 	*/
700 	function getContractBalance() public view returns (uint256) {
701 		return address(this).balance;
702 	}
703 
704 	/**
705 	* @dev Withdraw `_amount` ETH to the wallet address.
706 	* @param _amount The amount to withdraw.
707 	*/
708 	function withdraw(uint256 _amount) public onlyOwners {
709 		require(address(this).balance >= _amount, 'Unable to withdraw specified amount.');
710 		require(wallet != address(0), 'Non-zero wallet address required.');
711 		wallet.transfer(_amount);
712 	}
713 
714 	/**
715 	* @dev Transfer, which is used when Orbise is bought with different currency than ETH.
716 	* @param _to The address of the recipient.
717 	* @param _value The amount of Orbise Tokens to transfer.
718 	* @return success True if operation is executed successfully.
719 	*/
720 	function nonEtherPurchaseTransfer(address _to, uint256 _value) public isWhitelisted(_to) onlyBots whenNotPaused returns (bool success) {
721 		return _transfer(msg.sender, _to, _value);
722 	}
723 }