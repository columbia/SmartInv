1 pragma solidity ^0.4.19;
2 
3 
4 contract SafeMath {
5 
6 	function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
7 		uint256 c = a + b;
8 		assert(c >= a && c >= b);
9 		return c;
10 	}
11 
12 	function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
13 		assert(b <= a);
14 		return a - b;
15 	}
16 
17 	function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
18 		uint256 c = a * b;
19 		assert(a == 0 || c / a == b);
20 		return c;
21 	}
22 
23 	function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
24 		assert(b > 0);
25 		uint256 c = a / b;
26 		assert(a == b * c + a % b);
27 		return c;
28 	}
29 }
30 
31 
32 contract ERC20Token {
33 
34 	// --------
35 	//	Events
36 	// ---------
37 
38 	// publicize actions to external listeners.
39 	/// @notice Triggered when tokens are transferred.
40 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
41 
42 	/// @notice Triggered whenever approve(address _spender, uint256 _value) is called.
43 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 
45 	// --------
46 	//	Getters
47 	// ---------
48 
49 	/// @notice Get the total amount of token supply
50 	function totalSupply() public constant returns (uint256 _totalSupply);
51 
52 	/// @notice Get the account balance of address _owner
53 	/// @param _owner The address from which the balance will be retrieved
54 	/// @return The balance
55 	function balanceOf(address _owner) public constant returns (uint256 balance);
56 
57 	/// @param _owner The address of the account owning tokens
58 	/// @param _spender The address of the account able to transfer the tokens
59 	/// @return Amount of remaining tokens allowed to spent by the _spender from _owner account
60 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
61 
62 	// --------
63 	//	Actions
64 	// ---------
65 
66 	/// @notice send _value amount of tokens to _to address from msg.sender address
67 	/// @param _to The address of the recipient
68 	/// @param _value The amount of token to be transferred
69 	/// @return a boolean - whether the transfer was successful or not
70 	function transfer(address _to, uint256 _value) public returns (bool success);
71 
72 	/// @notice send _value amount of tokens to _to address from _from address, on the condition it is approved by _from
73 	/// @param _from The address of the sender
74 	/// @param _to The address of the recipient
75 	/// @param _value The amount of token to be transferred
76 	/// @return a boolean - whether the transfer was successful or not
77 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
78 
79 	/// @notice msg.sender approves _spender to spend multiple times up to _value amount of tokens
80 	/// If this function is called again it overwrites the current allowance with _value.
81 	/// @param _spender The address of the account able to transfer the tokens
82 	/// @param _value The amount of tokens to be approved for transfer
83 	/// @return a boolean - whether the approval was successful or not
84 	function approve(address _spender, uint256 _value) public returns (bool success);
85 }
86 
87 
88 contract SecureERC20Token is ERC20Token {
89 
90 	// State variables
91 
92 	// balances dictionary that maps addresses to balances
93 	mapping (address => uint256) private balances;
94 
95 	// locked account dictionary that maps addresses to boolean
96 	mapping (address => bool) private lockedAccounts;
97 
98 	 // allowed dictionary that allow transfer rights to other addresses.
99 	mapping (address => mapping(address => uint256)) private allowed;
100 
101 	// The Token's name: e.g. 'Gilgamesh Tokens'
102 	string public name;
103 
104 	// Symbol of the token: e.q 'GIL'
105 	string public symbol;
106 
107 	// Number of decimals of the smallest unit: e.g '18'
108 	uint8 public decimals;
109 
110 	// Number of total tokens: e,g: '1000000000'
111 	uint256 public totalSupply;
112 
113 	// token version
114 	uint8 public version = 1;
115 
116 	// address of the contract admin
117 	address public admin;
118 
119 	// address of the contract minter
120 	address public minter;
121 
122 	// creationBlock is the block number that the Token was created
123 	uint256 public creationBlock;
124 
125 	// Flag that determines if the token is transferable or not
126 	// disable actionable ERC20 token methods
127 	bool public isTransferEnabled;
128 
129 	event AdminOwnershipTransferred(address indexed previousAdmin, address indexed newAdmin);
130 	event MinterOwnershipTransferred(address indexed previousMinter, address indexed newMinter);
131 	event TransferStatus(address indexed sender, bool status);
132 
133 	// @notice Constructor to create Gilgamesh ERC20 Token
134 	function SecureERC20Token(
135 		uint256 initialSupply,
136 		string _name,
137 		string _symbol,
138 		uint8 _decimals,
139 		bool _isTransferEnabled
140 	) public {
141 		// assign all tokens to the deployer
142 		balances[msg.sender] = initialSupply;
143 
144 		totalSupply = initialSupply; // set initial supply of Tokens
145 		name = _name;				 // set token name
146 		decimals = _decimals;		 // set the decimals
147 		symbol = _symbol;			 // set the token symbol
148 		isTransferEnabled = _isTransferEnabled;
149 		creationBlock = block.number;
150 		minter = msg.sender;		// by default the contract deployer is the minter
151 		admin = msg.sender;			// by default the contract deployer is the admin
152 	}
153 
154 	// --------------
155 	// ERC20 Methods
156 	// --------------
157 
158 	/// @notice Get the total amount of token supply
159 	function totalSupply() public constant returns (uint256 _totalSupply) {
160 		return totalSupply;
161 	}
162 
163 	/// @notice Get the account balance of address _owner
164 	/// @param _owner The address from which the balance will be retrieved
165 	/// @return The balance
166 	function balanceOf(address _owner) public constant returns (uint256 balance) {
167 		return balances[_owner];
168 	}
169 
170 	/// @notice send _value amount of tokens to _to address from msg.sender address
171 	/// @param _to The address of the recipient
172 	/// @param _value The amount of token to be transferred
173 	/// @return a boolean - whether the transfer was successful or not
174 	function transfer(address _to, uint256 _value) public returns (bool success) {
175 		// if transfer is not enabled throw an error and stop execution.
176 		require(isTransferEnabled);
177 
178 		// continue with transfer
179 		return doTransfer(msg.sender, _to, _value);
180 	}
181 
182 	/// @notice send _value amount of tokens to _to address from _from address, on the condition it is approved by _from
183 	/// @param _from The address of the sender
184 	/// @param _to The address of the recipient
185 	/// @param _value The amount of token to be transferred
186 	/// @return a boolean - whether the transfer was successful or not
187 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
188 		// if transfer is not enabled throw an error and stop execution.
189 		require(isTransferEnabled);
190 
191 		// if from allowed transferrable rights to sender for amount _value
192 		if (allowed[_from][msg.sender] < _value) revert();
193 
194 		// subtreact allowance
195 		allowed[_from][msg.sender] -= _value;
196 
197 		// continue with transfer
198 		return doTransfer(_from, _to, _value);
199 	}
200 
201 	/// @notice msg.sender approves _spender to spend _value tokens
202 	/// @param _spender The address of the account able to transfer the tokens
203 	/// @param _value The amount of tokens to be approved for transfer
204 	/// @return a boolean - whether the approval was successful or not
205 	function approve(address _spender, uint256 _value)
206 	public
207 	is_not_locked(_spender)
208 	returns (bool success) {
209 		// if transfer is not enabled throw an error and stop execution.
210 		require(isTransferEnabled);
211 
212 		// user can only reassign an allowance of 0 if value is greater than 0
213 		// sender should first change the allowance to zero by calling approve(_spender, 0)
214 		// race condition is explained below:
215 		// https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216 		if(_value != 0 && allowed[msg.sender][_spender] != 0) revert();
217 
218 		if (
219 			// if sender balance is less than _value return false;
220 			balances[msg.sender] < _value
221 		) {
222 			// transaction failure
223 			return false;
224 		}
225 
226 		// allow transfer rights from msg.sender to _spender for _value token amount
227 		allowed[msg.sender][_spender] = _value;
228 
229 		// log approval event
230 		Approval(msg.sender, _spender, _value);
231 
232 		// transaction successful
233 		return true;
234 	}
235 
236 	/// @param _owner The address of the account owning tokens
237 	/// @param _spender The address of the account able to transfer the tokens
238 	/// @return Amount of remaining tokens allowed to spent by the _spender from _owner account
239 	function allowance(address _owner, address _spender)
240 	public
241 	constant
242 	returns (uint256 remaining) {
243 		return allowed[_owner][_spender];
244 	}
245 
246 	// --------------
247 	// Contract Custom Methods - Non ERC20
248 	// --------------
249 
250 	/* Public Methods */
251 
252 	/// @notice only the admin is allowed to lock accounts.
253 	/// @param _owner the address of the account to be locked
254 	function lockAccount(address _owner)
255 	public
256 	is_not_locked(_owner)
257 	validate_address(_owner)
258 	onlyAdmin {
259 		lockedAccounts[_owner] = true;
260 	}
261 
262 	/// @notice only the admin is allowed to unlock accounts.
263 	/// @param _owner the address of the account to be unlocked
264 	function unlockAccount(address _owner)
265 	public
266 	is_locked(_owner)
267 	validate_address(_owner)
268 	onlyAdmin {
269 		lockedAccounts[_owner] = false;
270 	}
271 
272 	/// @notice only the admin is allowed to burn tokens - in case if the user haven't verified identity or performed fraud
273 	/// @param _owner the address of the account that their tokens needs to be burnt
274 	function burnUserTokens(address _owner)
275 	public
276 	validate_address(_owner)
277 	onlyAdmin {
278 		// if user balance is 0 ignore
279 		if (balances[_owner] == 0) revert();
280 
281 		// should never happen but just in case
282 		if (balances[_owner] > totalSupply) revert();
283 
284 		// decrease the total supply
285 		totalSupply -= balances[_owner];
286 
287 		// burn it all
288 		balances[_owner] = 0;
289 	}
290 
291 	/// @notice only the admin is allowed to change the minter.
292 	/// @param newMinter the address of the minter
293 	function changeMinter(address newMinter)
294 	public
295 	validate_address(newMinter)
296 	onlyAdmin {
297 		if (minter == newMinter) revert();
298 		MinterOwnershipTransferred(minter, newMinter);
299 		minter = newMinter;
300 	}
301 
302 	/// @notice only the admin is allowed to change the admin.
303 	/// @param newAdmin the address of the new admin
304 	function changeAdmin(address newAdmin)
305 	public
306 	validate_address(newAdmin)
307 	onlyAdmin {
308 		if (admin == newAdmin) revert();
309 		AdminOwnershipTransferred(admin, newAdmin);
310 		admin = newAdmin;
311 	}
312 
313 	/// @notice mint new tokens by the minter
314 	/// @param _owner the owner of the newly tokens
315 	/// @param _amount the amount of new token to be minted
316 	function mint(address _owner, uint256 _amount)
317 	public
318 	onlyMinter
319 	validate_address(_owner)
320 	returns (bool success) {
321 		// preventing overflow on the totalSupply
322 		if (totalSupply + _amount < totalSupply) revert();
323 
324 		// preventing overflow on the receiver account
325 		if (balances[_owner] + _amount < balances[_owner]) revert();
326 
327 		// increase the total supply
328 		totalSupply += _amount;
329 
330 		// assign the additional supply to the target account.
331 		balances[_owner] += _amount;
332 
333 		// contract has minted new token by the minter
334 		Transfer(0x0, msg.sender, _amount);
335 
336 		// minter has transferred token to the target account
337 		Transfer(msg.sender, _owner, _amount);
338 
339 		return true;
340 	}
341 
342 	/// @notice Enables token holders to transfer their tokens freely if true
343 	/// after the crowdsale is finished it will be true
344 	/// for security reasons can be switched to false
345 	/// @param _isTransferEnabled boolean
346 	function enableTransfers(bool _isTransferEnabled) public onlyAdmin {
347 		isTransferEnabled = _isTransferEnabled;
348 		TransferStatus(msg.sender, isTransferEnabled);
349 	}
350 
351 	/* Internal Methods */
352 
353 	///	@dev this is the actual transfer function and it can only be called internally
354 	/// @notice send _value amount of tokens to _to address from _from address
355 	/// @param _to The address of the recipient
356 	/// @param _value The amount of token to be transferred
357 	/// @return a boolean - whether the transfer was successful or not
358 	function doTransfer(address _from, address _to, uint256 _value)
359 	validate_address(_to)
360 	is_not_locked(_from)
361 	internal
362 	returns (bool success) {
363 		if (
364 			// if the value is not more than 0 fail
365 			_value <= 0 ||
366 			// if the sender doesn't have enough balance fail
367 			balances[_from] < _value ||
368 			// if token supply overflows (total supply exceeds 2^256 - 1) fail
369 			balances[_to] + _value < balances[_to]
370 		) {
371 			// transaction failed
372 			return false;
373 		}
374 
375 		// decrease the number of tokens from sender address.
376 		balances[_from] -= _value;
377 
378 		// increase the number of tokens for _to address
379 		balances[_to] += _value;
380 
381 		// log transfer event
382 		Transfer(_from, _to, _value);
383 
384 		// transaction successful
385 		return true;
386 	}
387 
388 	// --------------
389 	// Modifiers
390 	// --------------
391 	modifier onlyMinter() {
392 		// if sender is not the minter stop the execution
393 		if (msg.sender != minter) revert();
394 		// if the sender is the minter continue
395 		_;
396 	}
397 
398 	modifier onlyAdmin() {
399 		// if sender is not the admin stop the execution
400 		if (msg.sender != admin) revert();
401 		// if the sender is the admin continue
402 		_;
403 	}
404 
405 	modifier validate_address(address _address) {
406 		if (_address == address(0)) revert();
407 		_;
408 	}
409 
410 	modifier is_not_locked(address _address) {
411 		if (lockedAccounts[_address] == true) revert();
412 		_;
413 	}
414 
415 	modifier is_locked(address _address) {
416 		if (lockedAccounts[_address] != true) revert();
417 		_;
418 	}
419 }
420 
421 
422 contract GilgameshToken is SecureERC20Token {
423 	// @notice Constructor to create Gilgamesh ERC20 Token
424 	function GilgameshToken()
425 	public
426 	SecureERC20Token(
427 		0, // no token in the begning
428 		"Gilgamesh Token", // Token Name
429 		"GIL", // Token Symbol
430 		18, // Decimals
431 		false // Enable token transfer
432 	) {}
433 
434 }
435 
436 
437 /*
438 	Copyright 2017, Skiral Inc
439 */
440 contract GilgameshTokenSale is SafeMath{
441 
442 	// creationBlock is the block number that the Token was created
443 	uint256 public creationBlock;
444 
445 	// startBlock token sale starting block
446 	uint256 public startBlock;
447 
448 	// endBlock token sale ending block
449 	// end block is not a valid block for crowdfunding. endBlock - 1 is the last valid block
450 	uint256 public endBlock;
451 
452 	// total Wei rasised
453 	uint256 public totalRaised = 0;
454 
455 	// Has Gilgamesh stopped the sale
456 	bool public saleStopped = false;
457 
458 	// Has Gilgamesh finalized the sale
459 	bool public saleFinalized = false;
460 
461 	// Minimum purchase - 0.1 Ether
462 	uint256 constant public minimumInvestment = 100 finney;
463 
464 	// Maximum hard Cap
465 	uint256 public hardCap = 50000 ether;
466 
467 	// number of wei GIL tokens for sale - 60 Million GIL Tokens
468 	uint256 public tokenCap = 60000000 * 10**18;
469 
470 	// Minimum cap
471 	uint256 public minimumCap = 1250 ether;
472 
473 	/* Contract Info */
474 
475 	// the deposit address for the Eth that is raised.
476 	address public fundOwnerWallet;
477 
478 	// the deposit address for the tokens that is minted for the dev team.
479 	address public tokenOwnerWallet;
480 
481 	// owner the address of the contract depoloyer
482 	address public owner;
483 
484 	// List of stage bonus percentages in every stage
485 	// this will get generated in the constructor
486 	uint[] public stageBonusPercentage;
487 
488 	// number of participants
489 	uint256 public totalParticipants;
490 
491 	// a map of userId to wei
492 	mapping(uint256 => uint256) public paymentsByUserId;
493 
494 	// a map of user address to wei
495 	mapping(address => uint256) public paymentsByAddress;
496 
497 	// total number of bonus stages.
498 	uint8 public totalStages;
499 
500 	// max bonus percentage on first stage
501 	uint8 public stageMaxBonusPercentage;
502 
503 	// number of wei-GIL tokens for 1 wei (18 decimals)
504 	uint256 public tokenPrice;
505 
506 	// the team owns 25% of the tokens - 3 times more than token purchasers.
507 	uint8 public teamTokenRatio = 3;
508 
509 	// GIL token address
510 	GilgameshToken public token;
511 
512 	// if Ether or Token cap has been reached
513 	bool public isCapReached = false;
514 
515 	// log when token sale has been initialized
516 	event LogTokenSaleInitialized(
517 		address indexed owner,
518 		address indexed fundOwnerWallet,
519 		uint256 startBlock,
520 		uint256 endBlock,
521 		uint256 creationBlock
522 	);
523 
524 	// log each contribution
525 	event LogContribution(
526 		address indexed contributorAddress,
527 		address indexed invokerAddress,
528 		uint256 amount,
529 		uint256 totalRaised,
530 		uint256 userAssignedTokens,
531 		uint256 indexed userId
532 	);
533 
534 	// log when crowd fund is finalized
535 	event LogFinalized(address owner, uint256 teamTokens);
536 
537 	// Constructor
538 	function GilgameshTokenSale(
539 		uint256 _startBlock, // starting block number
540 		uint256 _endBlock, // ending block number
541 		address _fundOwnerWallet, // fund owner wallet address - transfer ether to this address during and after fund has been closed
542 		address _tokenOwnerWallet, // token fund owner wallet address - transfer GIL tokens to this address after fund is finalized
543 		uint8 _totalStages, // total number of bonus stages
544 		uint8 _stageMaxBonusPercentage, // maximum percentage for bonus in the first stage
545 		uint256 _tokenPrice, // price of each GIL token in wei
546 		address _gilgameshToken, // address of the gilgamesh ERC20 token contract
547 		uint256 _minimumCap, // minimum cap, minimum amount of wei to be raised
548 		uint256 _tokenCap // tokenCap
549 	)
550 	public
551 	validate_address(_fundOwnerWallet) {
552 
553 		if (
554 			_gilgameshToken == 0x0 ||
555 			_tokenOwnerWallet == 0x0 ||
556 			// start block needs to be in the future
557 			_startBlock < getBlockNumber()  ||
558 			// start block should be less than ending block
559 			_startBlock >= _endBlock  ||
560 			// minimum number of stages is 2
561 			_totalStages < 2 ||
562 			// verify stage max bonus
563 			_stageMaxBonusPercentage < 0  ||
564 			_stageMaxBonusPercentage > 100 ||
565 			// stage bonus percentage needs to be devisible by number of stages
566 			_stageMaxBonusPercentage % (_totalStages - 1) != 0 ||
567 			// total number of blocks needs to be devisible by the total stages
568 			(_endBlock - _startBlock) % _totalStages != 0
569 		) revert();
570 
571 		owner = msg.sender; // make the contract creator the `owner`
572 		token = GilgameshToken(_gilgameshToken);
573 		endBlock = _endBlock;
574 		startBlock = _startBlock;
575 		creationBlock = getBlockNumber();
576 		fundOwnerWallet = _fundOwnerWallet;
577 		tokenOwnerWallet = _tokenOwnerWallet;
578 		tokenPrice = _tokenPrice;
579 		totalStages = _totalStages;
580 		minimumCap = _minimumCap;
581 		stageMaxBonusPercentage = _stageMaxBonusPercentage;
582 		totalRaised = 0; //	total number of wei raised
583 		tokenCap = _tokenCap;
584 
585 		// spread bonuses evenly between stages - e.g 27 / 9 = 3%
586 		uint spread = stageMaxBonusPercentage / (totalStages - 1);
587 
588 		// loop through [10 to 1] => ( 9 to 0) * 3% = [27%, 24%, 21%, 18%, 15%, 12%, 9%, 6%, 3%, 0%]
589 		for (uint stageNumber = totalStages; stageNumber > 0; stageNumber--) {
590 			stageBonusPercentage.push((stageNumber - 1) * spread);
591 		}
592 
593 		LogTokenSaleInitialized(
594 			owner,
595 			fundOwnerWallet,
596 			startBlock,
597 			endBlock,
598 			creationBlock
599 		);
600 	}
601 
602 	// --------------
603 	// Public Funtions
604 	// --------------
605 
606 	/// @notice Function to stop sale for an emergency.
607 	/// @dev Only Gilgamesh Dev can do it after it has been activated.
608 	function emergencyStopSale()
609 	public
610 	only_sale_active
611 	onlyOwner {
612 		saleStopped = true;
613 	}
614 
615 	/// @notice Function to restart stopped sale.
616 	/// @dev Only Gilgamesh Dev can do it after it has been disabled and sale has stopped.
617 	/// can it's in a valid time range for sale
618 	function restartSale()
619 	public
620 	only_during_sale_period
621 	only_sale_stopped
622 	onlyOwner {
623 		// if sale is finalized fail
624 		if (saleFinalized) revert();
625 		saleStopped = false;
626 	}
627 
628 	/// @notice Function to change the fund owner wallet address
629 	/// @dev Only Gilgamesh Dev can trigger this function
630 	function changeFundOwnerWalletAddress(address _fundOwnerWallet)
631 	public
632 	validate_address(_fundOwnerWallet)
633 	onlyOwner {
634 		fundOwnerWallet = _fundOwnerWallet;
635 	}
636 
637 	/// @notice Function to change the token fund owner wallet address
638 	/// @dev Only Gilgamesh Dev can trigger this function
639 	function changeTokenOwnerWalletAddress(address _tokenOwnerWallet)
640 	public
641 	validate_address(_tokenOwnerWallet)
642 	onlyOwner {
643 		tokenOwnerWallet = _tokenOwnerWallet;
644 	}
645 
646 	/// @notice finalize the sale
647 	/// @dev Only Gilgamesh Dev can trigger this function
648 	function finalizeSale()
649 	public
650 	onlyOwner {
651 		doFinalizeSale();
652 	}
653 
654 	/// @notice change hard cap and if it reaches hard cap finalize sale
655 	function changeCap(uint256 _cap)
656 	public
657 	onlyOwner {
658 		if (_cap < minimumCap) revert();
659 		if (_cap <= totalRaised) revert();
660 
661 		hardCap = _cap;
662 
663 		if (totalRaised + minimumInvestment >= hardCap) {
664 			isCapReached = true;
665 			doFinalizeSale();
666 		}
667 	}
668 
669 	/// @notice change minimum cap, in case Ether price fluctuates.
670 	function changeMinimumCap(uint256 _cap)
671 	public
672 	onlyOwner {
673 		if (minimumCap < _cap) revert();
674 		minimumCap = _cap;
675 	}
676 
677 	/// @notice remove conttact only when sale has been finalized
678 	/// transfer all the fund to the contract owner
679 	/// @dev only Gilgamesh Dev can trigger this function
680 	function removeContract()
681 	public
682 	onlyOwner {
683 		if (!saleFinalized) revert();
684 		selfdestruct(msg.sender);
685 	}
686 
687 	/// @notice only the owner is allowed to change the owner.
688 	/// @param _newOwner the address of the new owner
689 	function changeOwner(address _newOwner)
690 	public
691 	validate_address(_newOwner)
692 	onlyOwner {
693 		require(_newOwner != owner);
694 		owner = _newOwner;
695 	}
696 
697 	/// @dev The fallback function is called when ether is sent to the contract
698 	/// Payable is a required solidity modifier to receive ether
699 	/// every contract only has one unnamed function
700 	/// 2300 gas available for this function
701 	/*function () public payable {
702 		return deposit();
703 	}*/
704 
705 	/**
706 	* Pay on a behalf of the sender.
707 	*
708 	* @param customerId Identifier in the central database, UUID v4
709 	*
710 	*/
711 	/// @dev allow purchasers to deposit ETH for GIL Tokens.
712 	function depositForMySelf(uint256 userId)
713 	public
714 	only_sale_active
715 	minimum_contribution()
716 	payable {
717 		deposit(userId, msg.sender);
718 	}
719 
720 	///	@dev deposit() is an public function that accepts a userId and userAddress
721 	///	contract receives ETH in return of GIL tokens
722 	function deposit(uint256 userId, address userAddress)
723 	public
724 	payable
725 	only_sale_active
726 	minimum_contribution()
727 	validate_address(userAddress) {
728 		// if it passes hard cap throw
729 		if (totalRaised + msg.value > hardCap) revert();
730 
731 		uint256 userAssignedTokens = calculateTokens(msg.value);
732 
733 		// if user tokens are 0 throw
734 		if (userAssignedTokens <= 0) revert();
735 
736 		// if number of tokens exceed the token cap stop execution
737 		if (token.totalSupply() + userAssignedTokens > tokenCap) revert();
738 
739 		// send funds to fund owner wallet
740 		if (!fundOwnerWallet.send(msg.value)) revert();
741 
742 		// mint tokens for the user
743 		if (!token.mint(userAddress, userAssignedTokens)) revert();
744 
745 		// save total number wei raised
746 		totalRaised = safeAdd(totalRaised, msg.value);
747 
748 		// if cap is reached mark it
749 		if (totalRaised >= hardCap) {
750 			isCapReached = true;
751 		}
752 
753 		// if token supply has exceeded or reached the token cap stop
754 		if (token.totalSupply() >= tokenCap) {
755 			isCapReached = true;
756 		}
757 
758 		// increase the number of participants for the first transaction
759 		if (paymentsByUserId[userId] == 0) {
760 			totalParticipants++;
761 		}
762 
763 		// increase the amount that the user has payed
764 		paymentsByUserId[userId] += msg.value;
765 
766 		// total wei based on address
767 		paymentsByAddress[userAddress] += msg.value;
768 
769 		// log contribution event
770 		LogContribution(
771 			userAddress,
772 			msg.sender,
773 			msg.value,
774 			totalRaised,
775 			userAssignedTokens,
776 			userId
777 		);
778 	}
779 
780 	/// @notice calculate number of tokens need to be issued based on the amount received
781 	/// @param amount number of wei received
782 	function calculateTokens(uint256 amount)
783 	public
784 	view
785 	returns (uint256) {
786 		// return 0 if the crowd fund has ended or it hasn't started
787 		if (!isDuringSalePeriod(getBlockNumber())) return 0;
788 
789 		// get the current stage number by block number
790 		uint8 currentStage = getStageByBlockNumber(getBlockNumber());
791 
792 		// if current stage is more than the total stage return 0 - something is wrong
793 		if (currentStage > totalStages) return 0;
794 
795 		// calculate number of tokens that needs to be issued for the purchaser
796 		uint256 purchasedTokens = safeMul(amount, tokenPrice);
797 		// calculate number of tokens that needs to be rewraded to the purchaser
798 		uint256 rewardedTokens = calculateRewardTokens(purchasedTokens, currentStage);
799 		// add purchasedTokens and rewardedTokens
800 		return safeAdd(purchasedTokens, rewardedTokens);
801 	}
802 
803 	/// @notice calculate reward based on amount of tokens that will be issued to the purchaser
804 	/// @param amount number tokens that will be minted for the purchaser
805 	/// @param stageNumber number of current stage in the crowd fund process
806 	function calculateRewardTokens(uint256 amount, uint8 stageNumber)
807 	public
808 	view
809 	returns (uint256 rewardAmount) {
810 		// throw if it's invalid stage number
811 		if (
812 			stageNumber < 1 ||
813 			stageNumber > totalStages
814 		) revert();
815 
816 		// get stage index for the array
817 		uint8 stageIndex = stageNumber - 1;
818 
819 		// calculate reward - e.q 100 token creates 100 * 20 /100 = 20 tokens for reward
820 		return safeDiv(safeMul(amount, stageBonusPercentage[stageIndex]), 100);
821 	}
822 
823 	/// @notice get crowd fund stage by block number
824 	/// @param _blockNumber block number
825 	function getStageByBlockNumber(uint256 _blockNumber)
826 	public
827 	view
828 	returns (uint8) {
829 		// throw error, if block number is out of range
830 		if (!isDuringSalePeriod(_blockNumber)) revert();
831 
832 		uint256 totalBlocks = safeSub(endBlock, startBlock);
833 		uint256 numOfBlockPassed = safeSub(_blockNumber, startBlock);
834 
835 		// since numbers round down we need to add one to number of stage
836 		return uint8(safeDiv(safeMul(totalStages, numOfBlockPassed), totalBlocks) + 1);
837 	}
838 
839 	// --------------
840 	// Internal Funtions
841 	// --------------
842 
843 	/// @notice check if the block number is during the sale period
844 	/// @param _blockNumber block number
845 	function isDuringSalePeriod(uint256 _blockNumber)
846 	view
847 	internal
848 	returns (bool) {
849 		return (_blockNumber >= startBlock && _blockNumber < endBlock);
850 	}
851 
852 	/// @notice finalize the crowdfun sale
853 	/// @dev Only Gilgamesh Dev can trigger this function
854 	function doFinalizeSale()
855 	internal
856 	onlyOwner {
857 
858 		if (saleFinalized) revert();
859 
860 		// calculate the number of tokens that needs to be assigned to Gilgamesh team
861 		uint256 teamTokens = safeMul(token.totalSupply(), teamTokenRatio);
862 
863 		if (teamTokens > 0){
864 			// mint tokens for the team
865 			if (!token.mint(tokenOwnerWallet, teamTokens)) revert();
866 		}
867 
868 		// if there is any fund drain it
869 		if(this.balance > 0) {
870 			// send ether funds to fund owner wallet
871 			if (!fundOwnerWallet.send(this.balance)) revert();
872 		}
873 
874 		// finalize sale flag
875 		saleFinalized = true;
876 
877 		// stop sale flag
878 		saleStopped = true;
879 
880 		// log finalized
881 		LogFinalized(tokenOwnerWallet, teamTokens);
882 	}
883 
884 	/// @notice returns block.number
885 	function getBlockNumber() constant internal returns (uint) {
886 		return block.number;
887 	}
888 
889 	// --------------
890 	// Modifiers
891 	// --------------
892 
893 	/// continue only when sale has stopped
894 	modifier only_sale_stopped {
895 		if (!saleStopped) revert();
896 		_;
897 	}
898 
899 
900 	/// validates an address - currently only checks that it isn't null
901 	modifier validate_address(address _address) {
902 		if (_address == 0x0) revert();
903 		_;
904 	}
905 
906 	/// continue only during the sale period
907 	modifier only_during_sale_period {
908 		// if block number is less than starting block fail
909 		if (getBlockNumber() < startBlock) revert();
910 		// if block number has reach to the end block fail
911 		if (getBlockNumber() >= endBlock) revert();
912 		// otherwise safe to continue
913 		_;
914 	}
915 
916 	/// continue when sale is active and valid
917 	modifier only_sale_active {
918 		// if sale is finalized fail
919 		if (saleFinalized) revert();
920 		// if sale is stopped fail
921 		if (saleStopped) revert();
922 		// if cap is reached
923 		if (isCapReached) revert();
924 		// if block number is less than starting block fail
925 		if (getBlockNumber() < startBlock) revert();
926 		// if block number has reach to the end block fail
927 		if (getBlockNumber() >= endBlock) revert();
928 		// otherwise safe to continue
929 		_;
930 	}
931 
932 	/// continue if minimum contribution has reached
933 	modifier minimum_contribution() {
934 		if (msg.value < minimumInvestment) revert();
935 		_;
936 	}
937 
938 	/// continue when the invoker is the owner
939 	modifier onlyOwner() {
940 		if (msg.sender != owner) revert();
941 		_;
942 	}
943 }