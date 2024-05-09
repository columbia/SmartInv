1 pragma solidity >=0.5.4 <0.6.0;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
4 
5 
6 contract TheAO {
7 	address public theAO;
8 	address public nameTAOPositionAddress;
9 
10 	// Check whether an address is whitelisted and granted access to transact
11 	// on behalf of others
12 	mapping (address => bool) public whitelist;
13 
14 	constructor() public {
15 		theAO = msg.sender;
16 	}
17 
18 	/**
19 	 * @dev Checks if msg.sender is in whitelist.
20 	 */
21 	modifier inWhitelist() {
22 		require (whitelist[msg.sender] == true);
23 		_;
24 	}
25 
26 	/**
27 	 * @dev Transfer ownership of The AO to new address
28 	 * @param _theAO The new address to be transferred
29 	 */
30 	function transferOwnership(address _theAO) public {
31 		require (msg.sender == theAO);
32 		require (_theAO != address(0));
33 		theAO = _theAO;
34 	}
35 
36 	/**
37 	 * @dev Whitelist `_account` address to transact on behalf of others
38 	 * @param _account The address to whitelist
39 	 * @param _whitelist Either to whitelist or not
40 	 */
41 	function setWhitelist(address _account, bool _whitelist) public {
42 		require (msg.sender == theAO);
43 		require (_account != address(0));
44 		whitelist[_account] = _whitelist;
45 	}
46 }
47 
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54 
55 	/**
56 	 * @dev Multiplies two numbers, throws on overflow.
57 	 */
58 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
59 		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
60 		// benefit is lost if 'b' is also tested.
61 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62 		if (a == 0) {
63 			return 0;
64 		}
65 
66 		c = a * b;
67 		assert(c / a == b);
68 		return c;
69 	}
70 
71 	/**
72 	 * @dev Integer division of two numbers, truncating the quotient.
73 	 */
74 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
75 		// assert(b > 0); // Solidity automatically throws when dividing by 0
76 		// uint256 c = a / b;
77 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
78 		return a / b;
79 	}
80 
81 	/**
82 	 * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
83 	 */
84 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85 		assert(b <= a);
86 		return a - b;
87 	}
88 
89 	/**
90 	 * @dev Adds two numbers, throws on overflow.
91 	 */
92 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
93 		c = a + b;
94 		assert(c >= a);
95 		return c;
96 	}
97 }
98 
99 
100 interface INameAccountRecovery {
101 	function isCompromised(address _id) external view returns (bool);
102 }
103 
104 
105 interface INamePublicKey {
106 	function initialize(address _id, address _defaultKey, address _writerKey) external returns (bool);
107 
108 	function isKeyExist(address _id, address _key) external view returns (bool);
109 
110 	function getDefaultKey(address _id) external view returns (address);
111 
112 	function whitelistAddKey(address _id, address _key) external returns (bool);
113 }
114 
115 
116 interface INameTAOPosition {
117 	function senderIsAdvocate(address _sender, address _id) external view returns (bool);
118 	function senderIsListener(address _sender, address _id) external view returns (bool);
119 	function senderIsSpeaker(address _sender, address _id) external view returns (bool);
120 	function senderIsPosition(address _sender, address _id) external view returns (bool);
121 	function getAdvocate(address _id) external view returns (address);
122 	function nameIsAdvocate(address _nameId, address _id) external view returns (bool);
123 	function nameIsPosition(address _nameId, address _id) external view returns (bool);
124 	function initialize(address _id, address _advocateId, address _listenerId, address _speakerId) external returns (bool);
125 	function determinePosition(address _sender, address _id) external view returns (uint256);
126 }
127 
128 
129 
130 
131 
132 
133 /**
134  * @title TAOCurrency
135  */
136 contract TAOCurrency is TheAO {
137 	using SafeMath for uint256;
138 
139 	// Public variables of the contract
140 	string public name;
141 	string public symbol;
142 	uint8 public decimals;
143 
144 	// To differentiate denomination of TAO Currency
145 	uint256 public powerOfTen;
146 
147 	uint256 public totalSupply;
148 
149 	// This creates an array with all balances
150 	// address is the address of nameId, not the eth public address
151 	mapping (address => uint256) public balanceOf;
152 
153 	// This generates a public event on the blockchain that will notify clients
154 	// address is the address of TAO/Name Id, not eth public address
155 	event Transfer(address indexed from, address indexed to, uint256 value);
156 
157 	// This notifies clients about the amount burnt
158 	// address is the address of TAO/Name Id, not eth public address
159 	event Burn(address indexed from, uint256 value);
160 
161 	/**
162 	 * Constructor function
163 	 *
164 	 * Initializes contract with initial supply TAOCurrency to the creator of the contract
165 	 */
166 	constructor (string memory _name, string memory _symbol, address _nameTAOPositionAddress) public {
167 		name = _name;		// Set the name for display purposes
168 		symbol = _symbol;	// Set the symbol for display purposes
169 
170 		powerOfTen = 0;
171 		decimals = 0;
172 
173 		setNameTAOPositionAddress(_nameTAOPositionAddress);
174 	}
175 
176 	/**
177 	 * @dev Checks if the calling contract address is The AO
178 	 *		OR
179 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
180 	 */
181 	modifier onlyTheAO {
182 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
183 		_;
184 	}
185 
186 	/**
187 	 * @dev Check if `_id` is a Name or a TAO
188 	 */
189 	modifier isNameOrTAO(address _id) {
190 		require (AOLibrary.isName(_id) || AOLibrary.isTAO(_id));
191 		_;
192 	}
193 
194 	/***** The AO ONLY METHODS *****/
195 	/**
196 	 * @dev Transfer ownership of The AO to new address
197 	 * @param _theAO The new address to be transferred
198 	 */
199 	function transferOwnership(address _theAO) public onlyTheAO {
200 		require (_theAO != address(0));
201 		theAO = _theAO;
202 	}
203 
204 	/**
205 	 * @dev Whitelist `_account` address to transact on behalf of others
206 	 * @param _account The address to whitelist
207 	 * @param _whitelist Either to whitelist or not
208 	 */
209 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
210 		require (_account != address(0));
211 		whitelist[_account] = _whitelist;
212 	}
213 
214 	/**
215 	 * @dev The AO set the NameTAOPosition Address
216 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
217 	 */
218 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
219 		require (_nameTAOPositionAddress != address(0));
220 		nameTAOPositionAddress = _nameTAOPositionAddress;
221 	}
222 
223 	/***** PUBLIC METHODS *****/
224 	/**
225 	 * @dev transfer TAOCurrency from other address
226 	 *
227 	 * Send `_value` TAOCurrency to `_to` in behalf of `_from`
228 	 *
229 	 * @param _from The address of the sender
230 	 * @param _to The address of the recipient
231 	 * @param _value the amount to send
232 	 */
233 	function transferFrom(address _from, address _to, uint256 _value) public inWhitelist isNameOrTAO(_from) isNameOrTAO(_to) returns (bool) {
234 		_transfer(_from, _to, _value);
235 		return true;
236 	}
237 
238 	/**
239 	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
240 	 * @param target Address to receive TAOCurrency
241 	 * @param mintedAmount The amount of TAOCurrency it will receive
242 	 * @return true on success
243 	 */
244 	function mint(address target, uint256 mintedAmount) public inWhitelist isNameOrTAO(target) returns (bool) {
245 		_mint(target, mintedAmount);
246 		return true;
247 	}
248 
249 	/**
250 	 *
251 	 * @dev Whitelisted address remove `_value` TAOCurrency from the system irreversibly on behalf of `_from`.
252 	 *
253 	 * @param _from the address of the sender
254 	 * @param _value the amount of money to burn
255 	 */
256 	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist isNameOrTAO(_from) returns (bool success) {
257 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
258 		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
259 		totalSupply = totalSupply.sub(_value);              // Update totalSupply
260 		emit Burn(_from, _value);
261 		return true;
262 	}
263 
264 	/***** INTERNAL METHODS *****/
265 	/**
266 	 * @dev Send `_value` TAOCurrency from `_from` to `_to`
267 	 * @param _from The address of sender
268 	 * @param _to The address of the recipient
269 	 * @param _value The amount to send
270 	 */
271 	function _transfer(address _from, address _to, uint256 _value) internal {
272 		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
273 		require (balanceOf[_from] >= _value);					// Check if the sender has enough
274 		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
275 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
276 		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
277 		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
278 		emit Transfer(_from, _to, _value);
279 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
280 	}
281 
282 	/**
283 	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
284 	 * @param target Address to receive TAOCurrency
285 	 * @param mintedAmount The amount of TAOCurrency it will receive
286 	 */
287 	function _mint(address target, uint256 mintedAmount) internal {
288 		balanceOf[target] = balanceOf[target].add(mintedAmount);
289 		totalSupply = totalSupply.add(mintedAmount);
290 		emit Transfer(address(0), address(this), mintedAmount);
291 		emit Transfer(address(this), target, mintedAmount);
292 	}
293 }
294 
295 
296 interface IAOSetting {
297 	function getSettingValuesByTAOName(address _taoId, string calldata _settingName) external view returns (uint256, bool, address, bytes32, string memory);
298 	function getSettingTypes() external view returns (uint8, uint8, uint8, uint8, uint8);
299 
300 	function settingTypeLookup(uint256 _settingId) external view returns (uint8);
301 }
302 
303 
304 interface IAOIonLot {
305 	function createPrimordialLot(address _account, uint256 _primordialAmount, uint256 _multiplier, uint256 _networkBonusAmount) external returns (bytes32);
306 
307 	function createWeightedMultiplierLot(address _account, uint256 _amount, uint256 _weightedMultiplier) external returns (bytes32);
308 
309 	function lotById(bytes32 _lotId) external view returns (bytes32, address, uint256, uint256);
310 
311 	function totalLotsByAddress(address _lotOwner) external view returns (uint256);
312 
313 	function createBurnLot(address _account, uint256 _amount, uint256 _multiplierAfterBurn) external returns (bool);
314 
315 	function createConvertLot(address _account, uint256 _amount, uint256 _multiplierAfterConversion) external returns (bool);
316 }
317 
318 
319 interface IAOPurchaseReceipt {
320 	function senderIsBuyer(bytes32 _purchaseReceiptId, address _sender) external view returns (bool);
321 
322 	function getById(bytes32 _purchaseReceiptId) external view returns (bytes32, bytes32, bytes32, address, uint256, uint256, uint256, string memory, address, uint256);
323 
324 	function isExist(bytes32 _purchaseReceiptId) external view returns (bool);
325 }
326 
327 
328 interface IAOContentHost {
329 	function create(address _host, bytes32 _stakedContentId, string calldata _encChallenge, string calldata _contentDatKey, string calldata _metadataDatKey) external returns (bool);
330 
331 	function getById(bytes32 _contentHostId) external view returns (bytes32, bytes32, address, string memory, string memory);
332 
333 	function contentHostPrice(bytes32 _contentHostId) external view returns (uint256);
334 
335 	function contentHostPaidByAO(bytes32 _contentHostId) external view returns (uint256);
336 
337 	function isExist(bytes32 _contentHostId) external view returns (bool);
338 }
339 
340 
341 interface IAOStakedContent {
342 	function getById(bytes32 _stakedContentId) external view returns (bytes32, address, uint256, uint256, uint256, uint256, bool, uint256);
343 
344 	function create(address _stakeOwner, bytes32 _contentId, uint256 _networkIntegerAmount, uint256 _networkFractionAmount, bytes8 _denomination, uint256 _primordialAmount, uint256 _profitPercentage) external returns (bytes32);
345 
346 	function isActive(bytes32 _stakedContentId) external view returns (bool);
347 }
348 
349 
350 interface IAOContent {
351 	function create(address _creator, string calldata _baseChallenge, uint256 _fileSize, bytes32 _contentUsageType, address _taoId) external returns (bytes32);
352 
353 	function isAOContentUsageType(bytes32 _contentId) external view returns (bool);
354 
355 	function getById(bytes32 _contentId) external view returns (address, uint256, bytes32, address, bytes32, uint8, bytes32, bytes32, string memory);
356 
357 	function getBaseChallenge(bytes32 _contentId) external view returns (string memory);
358 }
359 
360 
361 interface INameFactory {
362 	function nonces(address _nameId) external view returns (uint256);
363 	function incrementNonce(address _nameId) external returns (uint256);
364 	function ethAddressToNameId(address _ethAddress) external view returns (address);
365 	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
366 	function nameIdToEthAddress(address _nameId) external view returns (address);
367 }
368 
369 
370 interface IAOEarning {
371 	function calculateEarning(bytes32 _purchaseReceiptId) external returns (bool);
372 
373 	function releaseEarning(bytes32 _purchaseReceiptId) external returns (bool);
374 
375 	function getTotalStakedContentEarning(bytes32 _stakedContentId) external view returns (uint256, uint256, uint256);
376 }
377 
378 
379 
380 
381 
382 
383 
384 
385 
386 
387 
388 
389 
390 contract TokenERC20 {
391 	// Public variables of the token
392 	string public name;
393 	string public symbol;
394 	uint8 public decimals = 18;
395 	// 18 decimals is the strongly suggested default, avoid changing it
396 	uint256 public totalSupply;
397 
398 	// This creates an array with all balances
399 	mapping (address => uint256) public balanceOf;
400 	mapping (address => mapping (address => uint256)) public allowance;
401 
402 	// This generates a public event on the blockchain that will notify clients
403 	event Transfer(address indexed from, address indexed to, uint256 value);
404 
405 	// This generates a public event on the blockchain that will notify clients
406 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
407 
408 	// This notifies clients about the amount burnt
409 	event Burn(address indexed from, uint256 value);
410 
411 	/**
412 	 * Constructor function
413 	 *
414 	 * Initializes contract with initial supply tokens to the creator of the contract
415 	 */
416 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
417 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
418 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
419 		name = tokenName;                                   // Set the name for display purposes
420 		symbol = tokenSymbol;                               // Set the symbol for display purposes
421 	}
422 
423 	/**
424 	 * Internal transfer, only can be called by this contract
425 	 */
426 	function _transfer(address _from, address _to, uint _value) internal {
427 		// Prevent transfer to 0x0 address. Use burn() instead
428 		require(_to != address(0));
429 		// Check if the sender has enough
430 		require(balanceOf[_from] >= _value);
431 		// Check for overflows
432 		require(balanceOf[_to] + _value > balanceOf[_to]);
433 		// Save this for an assertion in the future
434 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
435 		// Subtract from the sender
436 		balanceOf[_from] -= _value;
437 		// Add the same to the recipient
438 		balanceOf[_to] += _value;
439 		emit Transfer(_from, _to, _value);
440 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
441 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
442 	}
443 
444 	/**
445 	 * Transfer tokens
446 	 *
447 	 * Send `_value` tokens to `_to` from your account
448 	 *
449 	 * @param _to The address of the recipient
450 	 * @param _value the amount to send
451 	 */
452 	function transfer(address _to, uint256 _value) public returns (bool success) {
453 		_transfer(msg.sender, _to, _value);
454 		return true;
455 	}
456 
457 	/**
458 	 * Transfer tokens from other address
459 	 *
460 	 * Send `_value` tokens to `_to` in behalf of `_from`
461 	 *
462 	 * @param _from The address of the sender
463 	 * @param _to The address of the recipient
464 	 * @param _value the amount to send
465 	 */
466 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
467 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
468 		allowance[_from][msg.sender] -= _value;
469 		_transfer(_from, _to, _value);
470 		return true;
471 	}
472 
473 	/**
474 	 * Set allowance for other address
475 	 *
476 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
477 	 *
478 	 * @param _spender The address authorized to spend
479 	 * @param _value the max amount they can spend
480 	 */
481 	function approve(address _spender, uint256 _value) public returns (bool success) {
482 		allowance[msg.sender][_spender] = _value;
483 		emit Approval(msg.sender, _spender, _value);
484 		return true;
485 	}
486 
487 	/**
488 	 * Set allowance for other address and notify
489 	 *
490 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
491 	 *
492 	 * @param _spender The address authorized to spend
493 	 * @param _value the max amount they can spend
494 	 * @param _extraData some extra information to send to the approved contract
495 	 */
496 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
497 		tokenRecipient spender = tokenRecipient(_spender);
498 		if (approve(_spender, _value)) {
499 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
500 			return true;
501 		}
502 	}
503 
504 	/**
505 	 * Destroy tokens
506 	 *
507 	 * Remove `_value` tokens from the system irreversibly
508 	 *
509 	 * @param _value the amount of money to burn
510 	 */
511 	function burn(uint256 _value) public returns (bool success) {
512 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
513 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
514 		totalSupply -= _value;                      // Updates totalSupply
515 		emit Burn(msg.sender, _value);
516 		return true;
517 	}
518 
519 	/**
520 	 * Destroy tokens from other account
521 	 *
522 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
523 	 *
524 	 * @param _from the address of the sender
525 	 * @param _value the amount of money to burn
526 	 */
527 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
528 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
529 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
530 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
531 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
532 		totalSupply -= _value;                              // Update totalSupply
533 		emit Burn(_from, _value);
534 		return true;
535 	}
536 }
537 
538 
539 /**
540  * @title TAO
541  */
542 contract TAO {
543 	using SafeMath for uint256;
544 
545 	address public vaultAddress;
546 	string public name;				// the name for this TAO
547 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
548 
549 	// TAO's data
550 	string public datHash;
551 	string public database;
552 	string public keyValue;
553 	bytes32 public contentId;
554 
555 	/**
556 	 * 0 = TAO
557 	 * 1 = Name
558 	 */
559 	uint8 public typeId;
560 
561 	/**
562 	 * @dev Constructor function
563 	 */
564 	constructor (string memory _name,
565 		address _originId,
566 		string memory _datHash,
567 		string memory _database,
568 		string memory _keyValue,
569 		bytes32 _contentId,
570 		address _vaultAddress
571 	) public {
572 		name = _name;
573 		originId = _originId;
574 		datHash = _datHash;
575 		database = _database;
576 		keyValue = _keyValue;
577 		contentId = _contentId;
578 
579 		// Creating TAO
580 		typeId = 0;
581 
582 		vaultAddress = _vaultAddress;
583 	}
584 
585 	/**
586 	 * @dev Checks if calling address is Vault contract
587 	 */
588 	modifier onlyVault {
589 		require (msg.sender == vaultAddress);
590 		_;
591 	}
592 
593 	/**
594 	 * Will receive any ETH sent
595 	 */
596 	function () external payable {
597 	}
598 
599 	/**
600 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
601 	 * @param _recipient The recipient address
602 	 * @param _amount The amount to transfer
603 	 * @return true on success
604 	 */
605 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
606 		_recipient.transfer(_amount);
607 		return true;
608 	}
609 
610 	/**
611 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
612 	 * @param _erc20TokenAddress The address of ERC20 Token
613 	 * @param _recipient The recipient address
614 	 * @param _amount The amount to transfer
615 	 * @return true on success
616 	 */
617 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
618 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
619 		_erc20.transfer(_recipient, _amount);
620 		return true;
621 	}
622 }
623 
624 
625 
626 
627 /**
628  * @title Name
629  */
630 contract Name is TAO {
631 	/**
632 	 * @dev Constructor function
633 	 */
634 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
635 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
636 		// Creating Name
637 		typeId = 1;
638 	}
639 }
640 
641 
642 
643 
644 /**
645  * @title AOLibrary
646  */
647 library AOLibrary {
648 	using SafeMath for uint256;
649 
650 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
651 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
652 
653 	/**
654 	 * @dev Check whether or not the given TAO ID is a TAO
655 	 * @param _taoId The ID of the TAO
656 	 * @return true if yes. false otherwise
657 	 */
658 	function isTAO(address _taoId) public view returns (bool) {
659 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
660 	}
661 
662 	/**
663 	 * @dev Check whether or not the given Name ID is a Name
664 	 * @param _nameId The ID of the Name
665 	 * @return true if yes. false otherwise
666 	 */
667 	function isName(address _nameId) public view returns (bool) {
668 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
669 	}
670 
671 	/**
672 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
673 	 * @param _tokenAddress The ERC20 Token address to check
674 	 */
675 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
676 		if (_tokenAddress == address(0)) {
677 			return false;
678 		}
679 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
680 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
681 	}
682 
683 	/**
684 	 * @dev Checks if the calling contract address is The AO
685 	 *		OR
686 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
687 	 * @param _sender The address to check
688 	 * @param _theAO The AO address
689 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
690 	 * @return true if yes, false otherwise
691 	 */
692 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
693 		return (_sender == _theAO ||
694 			(
695 				(isTAO(_theAO) || isName(_theAO)) &&
696 				_nameTAOPositionAddress != address(0) &&
697 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
698 			)
699 		);
700 	}
701 
702 	/**
703 	 * @dev Return the divisor used to correctly calculate percentage.
704 	 *		Percentage stored throughout AO contracts covers 4 decimals,
705 	 *		so 1% is 10000, 1.25% is 12500, etc
706 	 */
707 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
708 		return _PERCENTAGE_DIVISOR;
709 	}
710 
711 	/**
712 	 * @dev Return the divisor used to correctly calculate multiplier.
713 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
714 	 *		so 1 is 1000000, 0.023 is 23000, etc
715 	 */
716 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
717 		return _MULTIPLIER_DIVISOR;
718 	}
719 
720 	/**
721 	 * @dev deploy a TAO
722 	 * @param _name The name of the TAO
723 	 * @param _originId The Name ID the creates the TAO
724 	 * @param _datHash The datHash of this TAO
725 	 * @param _database The database for this TAO
726 	 * @param _keyValue The key/value pair to be checked on the database
727 	 * @param _contentId The contentId related to this TAO
728 	 * @param _nameTAOVaultAddress The address of NameTAOVault
729 	 */
730 	function deployTAO(string memory _name,
731 		address _originId,
732 		string memory _datHash,
733 		string memory _database,
734 		string memory _keyValue,
735 		bytes32 _contentId,
736 		address _nameTAOVaultAddress
737 		) public returns (TAO _tao) {
738 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
739 	}
740 
741 	/**
742 	 * @dev deploy a Name
743 	 * @param _name The name of the Name
744 	 * @param _originId The eth address the creates the Name
745 	 * @param _datHash The datHash of this Name
746 	 * @param _database The database for this Name
747 	 * @param _keyValue The key/value pair to be checked on the database
748 	 * @param _contentId The contentId related to this Name
749 	 * @param _nameTAOVaultAddress The address of NameTAOVault
750 	 */
751 	function deployName(string memory _name,
752 		address _originId,
753 		string memory _datHash,
754 		string memory _database,
755 		string memory _keyValue,
756 		bytes32 _contentId,
757 		address _nameTAOVaultAddress
758 		) public returns (Name _myName) {
759 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
760 	}
761 
762 	/**
763 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
764 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
765 	 * @param _currentPrimordialBalance Account's current primordial ion balance
766 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
767 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
768 	 * @return the new primordial weighted multiplier
769 	 */
770 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
771 		if (_currentWeightedMultiplier > 0) {
772 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
773 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
774 			return _totalWeightedIons.div(_totalIons);
775 		} else {
776 			return _additionalWeightedMultiplier;
777 		}
778 	}
779 
780 	/**
781 	 * @dev Calculate the primordial ion multiplier on a given lot
782 	 *		Total Primordial Mintable = T
783 	 *		Total Primordial Minted = M
784 	 *		Starting Multiplier = S
785 	 *		Ending Multiplier = E
786 	 *		To Purchase = P
787 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
788 	 *
789 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
790 	 * @param _totalPrimordialMintable Total Primordial ion mintable
791 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
792 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
793 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
794 	 * @return The multiplier in (10 ** 6)
795 	 */
796 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
797 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
798 			/**
799 			 * Let temp = M + (P/2)
800 			 * Multiplier = (1 - (temp / T)) x (S-E)
801 			 */
802 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
803 
804 			/**
805 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
806 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
807 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
808 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
809 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
810 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
811 			 */
812 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
813 			/**
814 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
815 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
816 			 */
817 			return multiplier.div(_MULTIPLIER_DIVISOR);
818 		} else {
819 			return 0;
820 		}
821 	}
822 
823 	/**
824 	 * @dev Calculate the bonus percentage of network ion on a given lot
825 	 *		Total Primordial Mintable = T
826 	 *		Total Primordial Minted = M
827 	 *		Starting Network Bonus Multiplier = Bs
828 	 *		Ending Network Bonus Multiplier = Be
829 	 *		To Purchase = P
830 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
831 	 *
832 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
833 	 * @param _totalPrimordialMintable Total Primordial ion intable
834 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
835 	 * @param _startingMultiplier The starting Network ion bonus multiplier
836 	 * @param _endingMultiplier The ending Network ion bonus multiplier
837 	 * @return The bonus percentage
838 	 */
839 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
840 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
841 			/**
842 			 * Let temp = M + (P/2)
843 			 * B% = (1 - (temp / T)) x (Bs-Be)
844 			 */
845 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
846 
847 			/**
848 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
849 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
850 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
851 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
852 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
853 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
854 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
855 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
856 			 */
857 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
858 			return bonusPercentage;
859 		} else {
860 			return 0;
861 		}
862 	}
863 
864 	/**
865 	 * @dev Calculate the bonus amount of network ion on a given lot
866 	 *		AO Bonus Amount = B% x P
867 	 *
868 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
869 	 * @param _totalPrimordialMintable Total Primordial ion intable
870 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
871 	 * @param _startingMultiplier The starting Network ion bonus multiplier
872 	 * @param _endingMultiplier The ending Network ion bonus multiplier
873 	 * @return The bonus percentage
874 	 */
875 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
876 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
877 		/**
878 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
879 		 * when calculating the network ion bonus amount
880 		 */
881 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
882 		return networkBonus;
883 	}
884 
885 	/**
886 	 * @dev Calculate the maximum amount of Primordial an account can burn
887 	 *		_primordialBalance = P
888 	 *		_currentWeightedMultiplier = M
889 	 *		_maximumMultiplier = S
890 	 *		_amountToBurn = B
891 	 *		B = ((S x P) - (P x M)) / S
892 	 *
893 	 * @param _primordialBalance Account's primordial ion balance
894 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
895 	 * @param _maximumMultiplier The maximum multiplier of this account
896 	 * @return The maximum burn amount
897 	 */
898 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
899 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
900 	}
901 
902 	/**
903 	 * @dev Calculate the new multiplier after burning primordial ion
904 	 *		_primordialBalance = P
905 	 *		_currentWeightedMultiplier = M
906 	 *		_amountToBurn = B
907 	 *		_newMultiplier = E
908 	 *		E = (P x M) / (P - B)
909 	 *
910 	 * @param _primordialBalance Account's primordial ion balance
911 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
912 	 * @param _amountToBurn The amount of primordial ion to burn
913 	 * @return The new multiplier
914 	 */
915 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
916 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
917 	}
918 
919 	/**
920 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
921 	 *		_primordialBalance = P
922 	 *		_currentWeightedMultiplier = M
923 	 *		_amountToConvert = C
924 	 *		_newMultiplier = E
925 	 *		E = (P x M) / (P + C)
926 	 *
927 	 * @param _primordialBalance Account's primordial ion balance
928 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
929 	 * @param _amountToConvert The amount of network ion to convert
930 	 * @return The new multiplier
931 	 */
932 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
933 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
934 	}
935 
936 	/**
937 	 * @dev count num of digits
938 	 * @param number uint256 of the nuumber to be checked
939 	 * @return uint8 num of digits
940 	 */
941 	function numDigits(uint256 number) public pure returns (uint8) {
942 		uint8 digits = 0;
943 		while(number != 0) {
944 			number = number.div(10);
945 			digits++;
946 		}
947 		return digits;
948 	}
949 }
950 
951 
952 
953 
954 
955 
956 
957 
958 
959 
960 
961 
962 
963 
964 
965 
966 
967 interface ionRecipient {
968 	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
969 }
970 
971 /**
972  * @title AOIonInterface
973  */
974 contract AOIonInterface is TheAO {
975 	using SafeMath for uint256;
976 
977 	address public namePublicKeyAddress;
978 	address public nameAccountRecoveryAddress;
979 
980 	INameTAOPosition internal _nameTAOPosition;
981 	INamePublicKey internal _namePublicKey;
982 	INameAccountRecovery internal _nameAccountRecovery;
983 
984 	// Public variables of the contract
985 	string public name;
986 	string public symbol;
987 	uint8 public decimals;
988 	uint256 public totalSupply;
989 
990 	// To differentiate denomination of AO
991 	uint256 public powerOfTen;
992 
993 	/***** NETWORK ION VARIABLES *****/
994 	uint256 public sellPrice;
995 	uint256 public buyPrice;
996 
997 	// This creates an array with all balances
998 	mapping (address => uint256) public balanceOf;
999 	mapping (address => mapping (address => uint256)) public allowance;
1000 	mapping (address => bool) public frozenAccount;
1001 	mapping (address => uint256) public stakedBalance;
1002 	mapping (address => uint256) public escrowedBalance;
1003 
1004 	// This generates a public event on the blockchain that will notify clients
1005 	event FrozenFunds(address target, bool frozen);
1006 	event Stake(address indexed from, uint256 value);
1007 	event Unstake(address indexed from, uint256 value);
1008 	event Escrow(address indexed from, address indexed to, uint256 value);
1009 	event Unescrow(address indexed from, uint256 value);
1010 
1011 	// This generates a public event on the blockchain that will notify clients
1012 	event Transfer(address indexed from, address indexed to, uint256 value);
1013 
1014 	// This generates a public event on the blockchain that will notify clients
1015 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
1016 
1017 	// This notifies clients about the amount burnt
1018 	event Burn(address indexed from, uint256 value);
1019 
1020 	/**
1021 	 * @dev Constructor function
1022 	 */
1023 	constructor(string memory _name, string memory _symbol, address _nameTAOPositionAddress, address _namePublicKeyAddress, address _nameAccountRecoveryAddress) public {
1024 		setNameTAOPositionAddress(_nameTAOPositionAddress);
1025 		setNamePublicKeyAddress(_namePublicKeyAddress);
1026 		setNameAccountRecoveryAddress(_nameAccountRecoveryAddress);
1027 		name = _name;           // Set the name for display purposes
1028 		symbol = _symbol;       // Set the symbol for display purposes
1029 		powerOfTen = 0;
1030 		decimals = 0;
1031 	}
1032 
1033 	/**
1034 	 * @dev Checks if the calling contract address is The AO
1035 	 *		OR
1036 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
1037 	 */
1038 	modifier onlyTheAO {
1039 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
1040 		_;
1041 	}
1042 
1043 	/***** The AO ONLY METHODS *****/
1044 	/**
1045 	 * @dev Transfer ownership of The AO to new address
1046 	 * @param _theAO The new address to be transferred
1047 	 */
1048 	function transferOwnership(address _theAO) public onlyTheAO {
1049 		require (_theAO != address(0));
1050 		theAO = _theAO;
1051 	}
1052 
1053 	/**
1054 	 * @dev Whitelist `_account` address to transact on behalf of others
1055 	 * @param _account The address to whitelist
1056 	 * @param _whitelist Either to whitelist or not
1057 	 */
1058 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
1059 		require (_account != address(0));
1060 		whitelist[_account] = _whitelist;
1061 	}
1062 
1063 	/**
1064 	 * @dev The AO set the NameTAOPosition Address
1065 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
1066 	 */
1067 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
1068 		require (_nameTAOPositionAddress != address(0));
1069 		nameTAOPositionAddress = _nameTAOPositionAddress;
1070 		_nameTAOPosition = INameTAOPosition(nameTAOPositionAddress);
1071 	}
1072 
1073 	/**
1074 	 * @dev The AO set the NamePublicKey Address
1075 	 * @param _namePublicKeyAddress The address of NamePublicKey
1076 	 */
1077 	function setNamePublicKeyAddress(address _namePublicKeyAddress) public onlyTheAO {
1078 		require (_namePublicKeyAddress != address(0));
1079 		namePublicKeyAddress = _namePublicKeyAddress;
1080 		_namePublicKey = INamePublicKey(namePublicKeyAddress);
1081 	}
1082 
1083 	/**
1084 	 * @dev The AO set the NameAccountRecovery Address
1085 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
1086 	 */
1087 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
1088 		require (_nameAccountRecoveryAddress != address(0));
1089 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
1090 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
1091 	}
1092 
1093 	/**
1094 	 * @dev Allows TheAO to transfer `_amount` of ETH from this address to `_recipient`
1095 	 * @param _recipient The recipient address
1096 	 * @param _amount The amount to transfer
1097 	 */
1098 	function transferEth(address payable _recipient, uint256 _amount) public onlyTheAO {
1099 		require (_recipient != address(0));
1100 		_recipient.transfer(_amount);
1101 	}
1102 
1103 	/**
1104 	 * @dev Prevent/Allow target from sending & receiving ions
1105 	 * @param target Address to be frozen
1106 	 * @param freeze Either to freeze it or not
1107 	 */
1108 	function freezeAccount(address target, bool freeze) public onlyTheAO {
1109 		frozenAccount[target] = freeze;
1110 		emit FrozenFunds(target, freeze);
1111 	}
1112 
1113 	/**
1114 	 * @dev Allow users to buy ions for `newBuyPrice` eth and sell ions for `newSellPrice` eth
1115 	 * @param newSellPrice Price users can sell to the contract
1116 	 * @param newBuyPrice Price users can buy from the contract
1117 	 */
1118 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyTheAO {
1119 		sellPrice = newSellPrice;
1120 		buyPrice = newBuyPrice;
1121 	}
1122 
1123 	/***** NETWORK ION WHITELISTED ADDRESS ONLY METHODS *****/
1124 	/**
1125 	 * @dev Create `mintedAmount` ions and send it to `target`
1126 	 * @param target Address to receive the ions
1127 	 * @param mintedAmount The amount of ions it will receive
1128 	 * @return true on success
1129 	 */
1130 	function mint(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
1131 		_mint(target, mintedAmount);
1132 		return true;
1133 	}
1134 
1135 	/**
1136 	 * @dev Stake `_value` ions on behalf of `_from`
1137 	 * @param _from The address of the target
1138 	 * @param _value The amount to stake
1139 	 * @return true on success
1140 	 */
1141 	function stakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
1142 		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
1143 		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
1144 		stakedBalance[_from] = stakedBalance[_from].add(_value);	// Add to the targeted staked balance
1145 		emit Stake(_from, _value);
1146 		return true;
1147 	}
1148 
1149 	/**
1150 	 * @dev Unstake `_value` ions on behalf of `_from`
1151 	 * @param _from The address of the target
1152 	 * @param _value The amount to unstake
1153 	 * @return true on success
1154 	 */
1155 	function unstakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
1156 		require (stakedBalance[_from] >= _value);					// Check if the targeted staked balance is enough
1157 		stakedBalance[_from] = stakedBalance[_from].sub(_value);	// Subtract from the targeted staked balance
1158 		balanceOf[_from] = balanceOf[_from].add(_value);			// Add to the targeted balance
1159 		emit Unstake(_from, _value);
1160 		return true;
1161 	}
1162 
1163 	/**
1164 	 * @dev Store `_value` from `_from` to `_to` in escrow
1165 	 * @param _from The address of the sender
1166 	 * @param _to The address of the recipient
1167 	 * @param _value The amount of network ions to put in escrow
1168 	 * @return true on success
1169 	 */
1170 	function escrowFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool) {
1171 		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
1172 		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
1173 		escrowedBalance[_to] = escrowedBalance[_to].add(_value);	// Add to the targeted escrowed balance
1174 		emit Escrow(_from, _to, _value);
1175 		return true;
1176 	}
1177 
1178 	/**
1179 	 * @dev Create `mintedAmount` ions and send it to `target` escrow balance
1180 	 * @param target Address to receive ions
1181 	 * @param mintedAmount The amount of ions it will receive in escrow
1182 	 */
1183 	function mintEscrow(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
1184 		escrowedBalance[target] = escrowedBalance[target].add(mintedAmount);
1185 		totalSupply = totalSupply.add(mintedAmount);
1186 		emit Escrow(address(this), target, mintedAmount);
1187 		return true;
1188 	}
1189 
1190 	/**
1191 	 * @dev Release escrowed `_value` from `_from`
1192 	 * @param _from The address of the sender
1193 	 * @param _value The amount of escrowed network ions to be released
1194 	 * @return true on success
1195 	 */
1196 	function unescrowFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
1197 		require (escrowedBalance[_from] >= _value);						// Check if the targeted escrowed balance is enough
1198 		escrowedBalance[_from] = escrowedBalance[_from].sub(_value);	// Subtract from the targeted escrowed balance
1199 		balanceOf[_from] = balanceOf[_from].add(_value);				// Add to the targeted balance
1200 		emit Unescrow(_from, _value);
1201 		return true;
1202 	}
1203 
1204 	/**
1205 	 *
1206 	 * @dev Whitelisted address remove `_value` ions from the system irreversibly on behalf of `_from`.
1207 	 *
1208 	 * @param _from the address of the sender
1209 	 * @param _value the amount of money to burn
1210 	 */
1211 	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist returns (bool success) {
1212 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
1213 		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
1214 		totalSupply = totalSupply.sub(_value);              // Update totalSupply
1215 		emit Burn(_from, _value);
1216 		return true;
1217 	}
1218 
1219 	/**
1220 	 * @dev Whitelisted address transfer ions from other address
1221 	 *
1222 	 * Send `_value` ions to `_to` on behalf of `_from`
1223 	 *
1224 	 * @param _from The address of the sender
1225 	 * @param _to The address of the recipient
1226 	 * @param _value the amount to send
1227 	 */
1228 	function whitelistTransferFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool success) {
1229 		_transfer(_from, _to, _value);
1230 		return true;
1231 	}
1232 
1233 	/***** PUBLIC METHODS *****/
1234 	/**
1235 	 * Transfer ions
1236 	 *
1237 	 * Send `_value` ions to `_to` from your account
1238 	 *
1239 	 * @param _to The address of the recipient
1240 	 * @param _value the amount to send
1241 	 */
1242 	function transfer(address _to, uint256 _value) public returns (bool success) {
1243 		_transfer(msg.sender, _to, _value);
1244 		return true;
1245 	}
1246 
1247 	/**
1248 	 * Transfer ions from other address
1249 	 *
1250 	 * Send `_value` ions to `_to` in behalf of `_from`
1251 	 *
1252 	 * @param _from The address of the sender
1253 	 * @param _to The address of the recipient
1254 	 * @param _value the amount to send
1255 	 */
1256 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
1257 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
1258 		allowance[_from][msg.sender] -= _value;
1259 		_transfer(_from, _to, _value);
1260 		return true;
1261 	}
1262 
1263 	/**
1264 	 * Transfer ions between public key addresses in a Name
1265 	 * @param _nameId The ID of the Name
1266 	 * @param _from The address of the sender
1267 	 * @param _to The address of the recipient
1268 	 * @param _value the amount to send
1269 	 */
1270 	function transferBetweenPublicKeys(address _nameId, address _from, address _to, uint256 _value) public returns (bool success) {
1271 		require (AOLibrary.isName(_nameId));
1272 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _nameId));
1273 		require (!_nameAccountRecovery.isCompromised(_nameId));
1274 		// Make sure _from exist in the Name's Public Keys
1275 		require (_namePublicKey.isKeyExist(_nameId, _from));
1276 		// Make sure _to exist in the Name's Public Keys
1277 		require (_namePublicKey.isKeyExist(_nameId, _to));
1278 		_transfer(_from, _to, _value);
1279 		return true;
1280 	}
1281 
1282 	/**
1283 	 * Set allowance for other address
1284 	 *
1285 	 * Allows `_spender` to spend no more than `_value` ions in your behalf
1286 	 *
1287 	 * @param _spender The address authorized to spend
1288 	 * @param _value the max amount they can spend
1289 	 */
1290 	function approve(address _spender, uint256 _value) public returns (bool success) {
1291 		allowance[msg.sender][_spender] = _value;
1292 		emit Approval(msg.sender, _spender, _value);
1293 		return true;
1294 	}
1295 
1296 	/**
1297 	 * Set allowance for other address and notify
1298 	 *
1299 	 * Allows `_spender` to spend no more than `_value` ions in your behalf, and then ping the contract about it
1300 	 *
1301 	 * @param _spender The address authorized to spend
1302 	 * @param _value the max amount they can spend
1303 	 * @param _extraData some extra information to send to the approved contract
1304 	 */
1305 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
1306 		ionRecipient spender = ionRecipient(_spender);
1307 		if (approve(_spender, _value)) {
1308 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
1309 			return true;
1310 		}
1311 	}
1312 
1313 	/**
1314 	 * Destroy ions
1315 	 *
1316 	 * Remove `_value` ions from the system irreversibly
1317 	 *
1318 	 * @param _value the amount of money to burn
1319 	 */
1320 	function burn(uint256 _value) public returns (bool success) {
1321 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
1322 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
1323 		totalSupply -= _value;                      // Updates totalSupply
1324 		emit Burn(msg.sender, _value);
1325 		return true;
1326 	}
1327 
1328 	/**
1329 	 * Destroy ions from other account
1330 	 *
1331 	 * Remove `_value` ions from the system irreversibly on behalf of `_from`.
1332 	 *
1333 	 * @param _from the address of the sender
1334 	 * @param _value the amount of money to burn
1335 	 */
1336 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
1337 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
1338 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
1339 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
1340 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
1341 		totalSupply -= _value;                              // Update totalSupply
1342 		emit Burn(_from, _value);
1343 		return true;
1344 	}
1345 
1346 	/**
1347 	 * @dev Buy ions from contract by sending ether
1348 	 */
1349 	function buy() public payable {
1350 		require (buyPrice > 0);
1351 		uint256 amount = msg.value.div(buyPrice);
1352 		_transfer(address(this), msg.sender, amount);
1353 	}
1354 
1355 	/**
1356 	 * @dev Sell `amount` ions to contract
1357 	 * @param amount The amount of ions to be sold
1358 	 */
1359 	function sell(uint256 amount) public {
1360 		require (sellPrice > 0);
1361 		address myAddress = address(this);
1362 		require (myAddress.balance >= amount.mul(sellPrice));
1363 		_transfer(msg.sender, address(this), amount);
1364 		msg.sender.transfer(amount.mul(sellPrice));
1365 	}
1366 
1367 	/***** INTERNAL METHODS *****/
1368 	/**
1369 	 * @dev Send `_value` ions from `_from` to `_to`
1370 	 * @param _from The address of sender
1371 	 * @param _to The address of the recipient
1372 	 * @param _value The amount to send
1373 	 */
1374 	function _transfer(address _from, address _to, uint256 _value) internal {
1375 		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
1376 		require (balanceOf[_from] >= _value);					// Check if the sender has enough
1377 		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
1378 		require (!frozenAccount[_from]);						// Check if sender is frozen
1379 		require (!frozenAccount[_to]);							// Check if recipient is frozen
1380 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
1381 		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
1382 		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
1383 		emit Transfer(_from, _to, _value);
1384 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
1385 	}
1386 
1387 	/**
1388 	 * @dev Create `mintedAmount` ions and send it to `target`
1389 	 * @param target Address to receive the ions
1390 	 * @param mintedAmount The amount of ions it will receive
1391 	 */
1392 	function _mint(address target, uint256 mintedAmount) internal {
1393 		balanceOf[target] = balanceOf[target].add(mintedAmount);
1394 		totalSupply = totalSupply.add(mintedAmount);
1395 		emit Transfer(address(0), address(this), mintedAmount);
1396 		emit Transfer(address(this), target, mintedAmount);
1397 	}
1398 }
1399 
1400 
1401 
1402 
1403 
1404 
1405 
1406 
1407 
1408 
1409 
1410 
1411 
1412 /**
1413  * @title AOETH
1414  */
1415 contract AOETH is TheAO, TokenERC20, tokenRecipient {
1416 	using SafeMath for uint256;
1417 
1418 	address public aoIonAddress;
1419 
1420 	AOIon internal _aoIon;
1421 
1422 	uint256 public totalERC20Tokens;
1423 	uint256 public totalTokenExchanges;
1424 
1425 	struct ERC20Token {
1426 		address tokenAddress;
1427 		uint256 price;			// price of this ERC20 Token to AOETH
1428 		uint256 maxQuantity;	// To prevent too much exposure to a given asset
1429 		uint256 exchangedQuantity;	// Running total (total AOETH exchanged from this specific ERC20 Token)
1430 		bool active;
1431 	}
1432 
1433 	struct TokenExchange {
1434 		bytes32 exchangeId;
1435 		address buyer;			// The buyer address
1436 		address tokenAddress;	// The address of ERC20 Token
1437 		uint256 price;			// price of ERC20 Token to AOETH
1438 		uint256 sentAmount;		// Amount of ERC20 Token sent
1439 		uint256 receivedAmount;	// Amount of AOETH received
1440 		bytes extraData; // Extra data
1441 	}
1442 
1443 	// Mapping from id to ERC20Token object
1444 	mapping (uint256 => ERC20Token) internal erc20Tokens;
1445 	mapping (address => uint256) internal erc20TokenIdLookup;
1446 
1447 	// Mapping from id to TokenExchange object
1448 	mapping (uint256 => TokenExchange) internal tokenExchanges;
1449 	mapping (bytes32 => uint256) internal tokenExchangeIdLookup;
1450 	mapping (address => uint256) public totalAddressTokenExchanges;
1451 
1452 	// Event to be broadcasted to public when TheAO adds an ERC20 Token
1453 	event AddERC20Token(address indexed tokenAddress, uint256 price, uint256 maxQuantity);
1454 
1455 	// Event to be broadcasted to public when TheAO sets price for ERC20 Token
1456 	event SetPrice(address indexed tokenAddress, uint256 price);
1457 
1458 	// Event to be broadcasted to public when TheAO sets max quantity for ERC20 Token
1459 	event SetMaxQuantity(address indexed tokenAddress, uint256 maxQuantity);
1460 
1461 	// Event to be broadcasted to public when TheAO sets active status for ERC20 Token
1462 	event SetActive(address indexed tokenAddress, bool active);
1463 
1464 	// Event to be broadcasted to public when user exchanges ERC20 Token for AOETH
1465 	event ExchangeToken(bytes32 indexed exchangeId, address indexed from, address tokenAddress, string tokenName, string tokenSymbol, uint256 sentTokenAmount, uint256 receivedAOETHAmount, bytes extraData);
1466 
1467 	/**
1468 	 * @dev Constructor function
1469 	 */
1470 	constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol, address _aoIonAddress, address _nameTAOPositionAddress)
1471 		TokenERC20(initialSupply, tokenName, tokenSymbol) public {
1472 		setAOIonAddress(_aoIonAddress);
1473 		setNameTAOPositionAddress(_nameTAOPositionAddress);
1474 	}
1475 
1476 	/**
1477 	 * @dev Checks if the calling contract address is The AO
1478 	 *		OR
1479 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
1480 	 */
1481 	modifier onlyTheAO {
1482 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
1483 		_;
1484 	}
1485 
1486 	/***** The AO ONLY METHODS *****/
1487 	/**
1488 	 * @dev Transfer ownership of The AO to new address
1489 	 * @param _theAO The new address to be transferred
1490 	 */
1491 	function transferOwnership(address _theAO) public onlyTheAO {
1492 		require (_theAO != address(0));
1493 		theAO = _theAO;
1494 	}
1495 
1496 	/**
1497 	 * @dev Whitelist `_account` address to transact on behalf of others
1498 	 * @param _account The address to whitelist
1499 	 * @param _whitelist Either to whitelist or not
1500 	 */
1501 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
1502 		require (_account != address(0));
1503 		whitelist[_account] = _whitelist;
1504 	}
1505 
1506 	/**
1507 	 * @dev The AO set the AOIon Address
1508 	 * @param _aoIonAddress The address of AOIon
1509 	 */
1510 	function setAOIonAddress(address _aoIonAddress) public onlyTheAO {
1511 		require (_aoIonAddress != address(0));
1512 		aoIonAddress = _aoIonAddress;
1513 		_aoIon = AOIon(_aoIonAddress);
1514 	}
1515 
1516 	/**
1517 	 * @dev The AO set the NameTAOPosition Address
1518 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
1519 	 */
1520 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
1521 		require (_nameTAOPositionAddress != address(0));
1522 		nameTAOPositionAddress = _nameTAOPositionAddress;
1523 	}
1524 
1525 	/**
1526 	 * @dev Allows TheAO to transfer `_amount` of ERC20 Token from this address to `_recipient`
1527 	 * @param _erc20TokenAddress The address of ERC20 Token
1528 	 * @param _recipient The recipient address
1529 	 * @param _amount The amount to transfer
1530 	 */
1531 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyTheAO {
1532 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
1533 		require (_erc20.transfer(_recipient, _amount));
1534 	}
1535 
1536 	/**
1537 	 * @dev Add an ERC20 Token to the list
1538 	 * @param _tokenAddress The address of the ERC20 Token
1539 	 * @param _price The price of this token to AOETH
1540 	 * @param _maxQuantity Maximum quantity allowed for exchange
1541 	 */
1542 	function addERC20Token(address _tokenAddress, uint256 _price, uint256 _maxQuantity) public onlyTheAO {
1543 		require (_tokenAddress != address(0) && _price > 0 && _maxQuantity > 0);
1544 		require (AOLibrary.isValidERC20TokenAddress(_tokenAddress));
1545 		require (erc20TokenIdLookup[_tokenAddress] == 0);
1546 
1547 		totalERC20Tokens++;
1548 		erc20TokenIdLookup[_tokenAddress] = totalERC20Tokens;
1549 		ERC20Token storage _erc20Token = erc20Tokens[totalERC20Tokens];
1550 		_erc20Token.tokenAddress = _tokenAddress;
1551 		_erc20Token.price = _price;
1552 		_erc20Token.maxQuantity = _maxQuantity;
1553 		_erc20Token.active = true;
1554 		emit AddERC20Token(_erc20Token.tokenAddress, _erc20Token.price, _erc20Token.maxQuantity);
1555 	}
1556 
1557 	/**
1558 	 * @dev Set price for existing ERC20 Token
1559 	 * @param _tokenAddress The address of the ERC20 Token
1560 	 * @param _price The price of this token to AOETH
1561 	 */
1562 	function setPrice(address _tokenAddress, uint256 _price) public onlyTheAO {
1563 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1564 		require (_price > 0);
1565 
1566 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
1567 		_erc20Token.price = _price;
1568 		emit SetPrice(_erc20Token.tokenAddress, _erc20Token.price);
1569 	}
1570 
1571 	/**
1572 	 * @dev Set max quantity for existing ERC20 Token
1573 	 * @param _tokenAddress The address of the ERC20 Token
1574 	 * @param _maxQuantity The max exchange quantity for this token
1575 	 */
1576 	function setMaxQuantity(address _tokenAddress, uint256 _maxQuantity) public onlyTheAO {
1577 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1578 
1579 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
1580 		require (_maxQuantity > _erc20Token.exchangedQuantity);
1581 		_erc20Token.maxQuantity = _maxQuantity;
1582 		emit SetMaxQuantity(_erc20Token.tokenAddress, _erc20Token.maxQuantity);
1583 	}
1584 
1585 	/**
1586 	 * @dev Set active status for existing ERC20 Token
1587 	 * @param _tokenAddress The address of the ERC20 Token
1588 	 * @param _active The active status for this token
1589 	 */
1590 	function setActive(address _tokenAddress, bool _active) public onlyTheAO {
1591 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1592 
1593 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
1594 		_erc20Token.active = _active;
1595 		emit SetActive(_erc20Token.tokenAddress, _erc20Token.active);
1596 	}
1597 
1598 	/**
1599 	 * @dev Whitelisted address transfer tokens from other address
1600 	 *
1601 	 * Send `_value` tokens to `_to` on behalf of `_from`
1602 	 *
1603 	 * @param _from The address of the sender
1604 	 * @param _to The address of the recipient
1605 	 * @param _value the amount to send
1606 	 */
1607 	function whitelistTransferFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool success) {
1608 		_transfer(_from, _to, _value);
1609 		return true;
1610 	}
1611 
1612 	/***** PUBLIC METHODS *****/
1613 	/**
1614 	 * @dev Get an ERC20 Token information given an ID
1615 	 * @param _id The internal ID of the ERC20 Token
1616 	 * @return The ERC20 Token address
1617 	 * @return The name of the token
1618 	 * @return The symbol of the token
1619 	 * @return The price of this token to AOETH
1620 	 * @return The max quantity for exchange
1621 	 * @return The total AOETH exchanged from this token
1622 	 * @return The status of this token
1623 	 */
1624 	function getById(uint256 _id) public view returns (address, string memory, string memory, uint256, uint256, uint256, bool) {
1625 		require (erc20Tokens[_id].tokenAddress != address(0));
1626 		ERC20Token memory _erc20Token = erc20Tokens[_id];
1627 		return (
1628 			_erc20Token.tokenAddress,
1629 			TokenERC20(_erc20Token.tokenAddress).name(),
1630 			TokenERC20(_erc20Token.tokenAddress).symbol(),
1631 			_erc20Token.price,
1632 			_erc20Token.maxQuantity,
1633 			_erc20Token.exchangedQuantity,
1634 			_erc20Token.active
1635 		);
1636 	}
1637 
1638 	/**
1639 	 * @dev Get an ERC20 Token information given an address
1640 	 * @param _tokenAddress The address of the ERC20 Token
1641 	 * @return The ERC20 Token address
1642 	 * @return The name of the token
1643 	 * @return The symbol of the token
1644 	 * @return The price of this token to AOETH
1645 	 * @return The max quantity for exchange
1646 	 * @return The total AOETH exchanged from this token
1647 	 * @return The status of this token
1648 	 */
1649 	function getByAddress(address _tokenAddress) public view returns (address, string memory, string memory, uint256, uint256, uint256, bool) {
1650 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1651 		return getById(erc20TokenIdLookup[_tokenAddress]);
1652 	}
1653 
1654 	/**
1655 	 * @dev When a user approves AOETH to spend on his/her behalf (i.e exchange to AOETH)
1656 	 * @param _from The user address that approved AOETH
1657 	 * @param _value The amount that the user approved
1658 	 * @param _token The address of the ERC20 Token
1659 	 * @param _extraData The extra data sent during the approval
1660 	 */
1661 	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external {
1662 		require (_from != address(0));
1663 		require (AOLibrary.isValidERC20TokenAddress(_token));
1664 
1665 		// Check if the token is supported
1666 		require (erc20TokenIdLookup[_token] > 0);
1667 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_token]];
1668 		require (_erc20Token.active && _erc20Token.price > 0 && _erc20Token.exchangedQuantity < _erc20Token.maxQuantity);
1669 
1670 		uint256 amountToTransfer = _value.div(_erc20Token.price);
1671 		require (_erc20Token.maxQuantity.sub(_erc20Token.exchangedQuantity) >= amountToTransfer);
1672 		require (_aoIon.availableETH() >= amountToTransfer);
1673 
1674 		// Transfer the ERC20 Token from the `_from` address to here
1675 		require (TokenERC20(_token).transferFrom(_from, address(this), _value));
1676 
1677 		_erc20Token.exchangedQuantity = _erc20Token.exchangedQuantity.add(amountToTransfer);
1678 		balanceOf[_from] = balanceOf[_from].add(amountToTransfer);
1679 		totalSupply = totalSupply.add(amountToTransfer);
1680 
1681 		// Store the TokenExchange information
1682 		totalTokenExchanges++;
1683 		totalAddressTokenExchanges[_from]++;
1684 		bytes32 _exchangeId = keccak256(abi.encodePacked(this, _from, totalTokenExchanges));
1685 		tokenExchangeIdLookup[_exchangeId] = totalTokenExchanges;
1686 
1687 		TokenExchange storage _tokenExchange = tokenExchanges[totalTokenExchanges];
1688 		_tokenExchange.exchangeId = _exchangeId;
1689 		_tokenExchange.buyer = _from;
1690 		_tokenExchange.tokenAddress = _token;
1691 		_tokenExchange.price = _erc20Token.price;
1692 		_tokenExchange.sentAmount = _value;
1693 		_tokenExchange.receivedAmount = amountToTransfer;
1694 		_tokenExchange.extraData = _extraData;
1695 
1696 		emit ExchangeToken(_tokenExchange.exchangeId, _tokenExchange.buyer, _tokenExchange.tokenAddress, TokenERC20(_token).name(), TokenERC20(_token).symbol(), _tokenExchange.sentAmount, _tokenExchange.receivedAmount, _tokenExchange.extraData);
1697 	}
1698 
1699 	/**
1700 	 * @dev Get TokenExchange information given an exchange ID
1701 	 * @param _exchangeId The exchange ID to query
1702 	 * @return The buyer address
1703 	 * @return The sent ERC20 Token address
1704 	 * @return The ERC20 Token name
1705 	 * @return The ERC20 Token symbol
1706 	 * @return The price of ERC20 Token to AOETH
1707 	 * @return The amount of ERC20 Token sent
1708 	 * @return The amount of AOETH received
1709 	 * @return Extra data during the transaction
1710 	 */
1711 	function getTokenExchangeById(bytes32 _exchangeId) public view returns (address, address, string memory, string memory, uint256, uint256,  uint256, bytes memory) {
1712 		require (tokenExchangeIdLookup[_exchangeId] > 0);
1713 		TokenExchange memory _tokenExchange = tokenExchanges[tokenExchangeIdLookup[_exchangeId]];
1714 		return (
1715 			_tokenExchange.buyer,
1716 			_tokenExchange.tokenAddress,
1717 			TokenERC20(_tokenExchange.tokenAddress).name(),
1718 			TokenERC20(_tokenExchange.tokenAddress).symbol(),
1719 			_tokenExchange.price,
1720 			_tokenExchange.sentAmount,
1721 			_tokenExchange.receivedAmount,
1722 			_tokenExchange.extraData
1723 		);
1724 	}
1725 }
1726 
1727 
1728 /**
1729  * @title AOIon
1730  */
1731 contract AOIon is AOIonInterface {
1732 	using SafeMath for uint256;
1733 
1734 	address public aoIonLotAddress;
1735 	address public settingTAOId;
1736 	address public aoSettingAddress;
1737 	address public aoethAddress;
1738 
1739 	// AO Dev Team addresses to receive Primordial/Network Ions
1740 	address public aoDevTeam1 = 0x146CbD9821e6A42c8ff6DC903fe91CB69625A105;
1741 	address public aoDevTeam2 = 0x4810aF1dA3aC827259eEa72ef845F4206C703E8D;
1742 
1743 	IAOIonLot internal _aoIonLot;
1744 	IAOSetting internal _aoSetting;
1745 	AOETH internal _aoeth;
1746 
1747 	/***** PRIMORDIAL ION VARIABLES *****/
1748 	uint256 public primordialTotalSupply;
1749 	uint256 public primordialTotalBought;
1750 	uint256 public primordialSellPrice;
1751 	uint256 public primordialBuyPrice;
1752 	uint256 public totalEthForPrimordial;	// Total ETH sent for Primordial AO+
1753 	uint256 public totalRedeemedAOETH;		// Total AOETH redeemed for Primordial AO+
1754 
1755 	// Total available primordial ion for sale 3,377,699,720,527,872 AO+
1756 	uint256 constant public TOTAL_PRIMORDIAL_FOR_SALE = 3377699720527872;
1757 
1758 	mapping (address => uint256) public primordialBalanceOf;
1759 	mapping (address => mapping (address => uint256)) public primordialAllowance;
1760 
1761 	// Mapping from owner's lot weighted multiplier to the amount of staked ions
1762 	mapping (address => mapping (uint256 => uint256)) public primordialStakedBalance;
1763 
1764 	event PrimordialTransfer(address indexed from, address indexed to, uint256 value);
1765 	event PrimordialApproval(address indexed _owner, address indexed _spender, uint256 _value);
1766 	event PrimordialBurn(address indexed from, uint256 value);
1767 	event PrimordialStake(address indexed from, uint256 value, uint256 weightedMultiplier);
1768 	event PrimordialUnstake(address indexed from, uint256 value, uint256 weightedMultiplier);
1769 
1770 	event NetworkExchangeEnded();
1771 
1772 	bool public networkExchangeEnded;
1773 
1774 	// Mapping from owner to his/her current weighted multiplier
1775 	mapping (address => uint256) internal ownerWeightedMultiplier;
1776 
1777 	// Mapping from owner to his/her max multiplier (multiplier of account's first Lot)
1778 	mapping (address => uint256) internal ownerMaxMultiplier;
1779 
1780 	// Event to be broadcasted to public when user buys primordial ion
1781 	// payWith 1 == with Ethereum
1782 	// payWith 2 == with AOETH
1783 	event BuyPrimordial(address indexed lotOwner, bytes32 indexed lotId, uint8 payWith, uint256 sentAmount, uint256 refundedAmount);
1784 
1785 	/**
1786 	 * @dev Constructor function
1787 	 */
1788 	constructor(string memory _name, string memory _symbol, address _settingTAOId, address _aoSettingAddress, address _nameTAOPositionAddress, address _namePublicKeyAddress, address _nameAccountRecoveryAddress)
1789 		AOIonInterface(_name, _symbol, _nameTAOPositionAddress, _namePublicKeyAddress, _nameAccountRecoveryAddress) public {
1790 		setSettingTAOId(_settingTAOId);
1791 		setAOSettingAddress(_aoSettingAddress);
1792 
1793 		powerOfTen = 0;
1794 		decimals = 0;
1795 		setPrimordialPrices(0, 10 ** 8); // Set Primordial buy price to 0.1 gwei/ion
1796 	}
1797 
1798 	/**
1799 	 * @dev Checks if buyer can buy primordial ion
1800 	 */
1801 	modifier canBuyPrimordial(uint256 _sentAmount, bool _withETH) {
1802 		require (networkExchangeEnded == false &&
1803 			primordialTotalBought < TOTAL_PRIMORDIAL_FOR_SALE &&
1804 			primordialBuyPrice > 0 &&
1805 			_sentAmount > 0 &&
1806 			availablePrimordialForSaleInETH() > 0 &&
1807 			(
1808 				(_withETH && availableETH() > 0) ||
1809 				(!_withETH && totalRedeemedAOETH < _aoeth.totalSupply())
1810 			)
1811 		);
1812 		_;
1813 	}
1814 
1815 	/***** The AO ONLY METHODS *****/
1816 	/**
1817 	 * @dev The AO sets AOIonLot address
1818 	 * @param _aoIonLotAddress The address of AOIonLot
1819 	 */
1820 	function setAOIonLotAddress(address _aoIonLotAddress) public onlyTheAO {
1821 		require (_aoIonLotAddress != address(0));
1822 		aoIonLotAddress = _aoIonLotAddress;
1823 		_aoIonLot = IAOIonLot(_aoIonLotAddress);
1824 	}
1825 
1826 	/**
1827 	 * @dev The AO sets setting TAO ID
1828 	 * @param _settingTAOId The new setting TAO ID to set
1829 	 */
1830 	function setSettingTAOId(address _settingTAOId) public onlyTheAO {
1831 		require (AOLibrary.isTAO(_settingTAOId));
1832 		settingTAOId = _settingTAOId;
1833 	}
1834 
1835 	/**
1836 	 * @dev The AO sets AO Setting address
1837 	 * @param _aoSettingAddress The address of AOSetting
1838 	 */
1839 	function setAOSettingAddress(address _aoSettingAddress) public onlyTheAO {
1840 		require (_aoSettingAddress != address(0));
1841 		aoSettingAddress = _aoSettingAddress;
1842 		_aoSetting = IAOSetting(_aoSettingAddress);
1843 	}
1844 
1845 	/**
1846 	 * @dev Set AO Dev team addresses to receive Primordial/Network ions during network exchange
1847 	 * @param _aoDevTeam1 The first AO dev team address
1848 	 * @param _aoDevTeam2 The second AO dev team address
1849 	 */
1850 	function setAODevTeamAddresses(address _aoDevTeam1, address _aoDevTeam2) public onlyTheAO {
1851 		aoDevTeam1 = _aoDevTeam1;
1852 		aoDevTeam2 = _aoDevTeam2;
1853 	}
1854 
1855 	/**
1856 	 * @dev Set AOETH address
1857 	 * @param _aoethAddress The address of AOETH
1858 	 */
1859 	function setAOETHAddress(address _aoethAddress) public onlyTheAO {
1860 		require (_aoethAddress != address(0));
1861 		aoethAddress = _aoethAddress;
1862 		_aoeth = AOETH(_aoethAddress);
1863 	}
1864 
1865 	/***** PRIMORDIAL ION THE AO ONLY METHODS *****/
1866 	/**
1867 	 * @dev Allow users to buy Primordial ions for `newBuyPrice` eth and sell Primordial ions for `newSellPrice` eth
1868 	 * @param newPrimordialSellPrice Price users can sell to the contract
1869 	 * @param newPrimordialBuyPrice Price users can buy from the contract
1870 	 */
1871 	function setPrimordialPrices(uint256 newPrimordialSellPrice, uint256 newPrimordialBuyPrice) public onlyTheAO {
1872 		primordialSellPrice = newPrimordialSellPrice;
1873 		primordialBuyPrice = newPrimordialBuyPrice;
1874 	}
1875 
1876 	/**
1877 	 * @dev Only the AO can force end network exchange
1878 	 */
1879 	function endNetworkExchange() public onlyTheAO {
1880 		require (!networkExchangeEnded);
1881 		networkExchangeEnded = true;
1882 		emit NetworkExchangeEnded();
1883 	}
1884 
1885 	/***** PRIMORDIAL ION WHITELISTED ADDRESS ONLY METHODS *****/
1886 	/**
1887 	 * @dev Stake `_value` Primordial ions at `_weightedMultiplier ` multiplier on behalf of `_from`
1888 	 * @param _from The address of the target
1889 	 * @param _value The amount of Primordial ions to stake
1890 	 * @param _weightedMultiplier The weighted multiplier of the Primordial ions
1891 	 * @return true on success
1892 	 */
1893 	function stakePrimordialFrom(address _from, uint256 _value, uint256 _weightedMultiplier) public inWhitelist returns (bool) {
1894 		// Check if the targeted balance is enough
1895 		require (primordialBalanceOf[_from] >= _value);
1896 		// Make sure the weighted multiplier is the same as account's current weighted multiplier
1897 		require (_weightedMultiplier == ownerWeightedMultiplier[_from]);
1898 		// Subtract from the targeted balance
1899 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);
1900 		// Add to the targeted staked balance
1901 		primordialStakedBalance[_from][_weightedMultiplier] = primordialStakedBalance[_from][_weightedMultiplier].add(_value);
1902 		emit PrimordialStake(_from, _value, _weightedMultiplier);
1903 		return true;
1904 	}
1905 
1906 	/**
1907 	 * @dev Unstake `_value` Primordial ions at `_weightedMultiplier` on behalf of `_from`
1908 	 * @param _from The address of the target
1909 	 * @param _value The amount to unstake
1910 	 * @param _weightedMultiplier The weighted multiplier of the Primordial ions
1911 	 * @return true on success
1912 	 */
1913 	function unstakePrimordialFrom(address _from, uint256 _value, uint256 _weightedMultiplier) public inWhitelist returns (bool) {
1914 		// Check if the targeted staked balance is enough
1915 		require (primordialStakedBalance[_from][_weightedMultiplier] >= _value);
1916 		// Subtract from the targeted staked balance
1917 		primordialStakedBalance[_from][_weightedMultiplier] = primordialStakedBalance[_from][_weightedMultiplier].sub(_value);
1918 		// Add to the targeted balance
1919 		primordialBalanceOf[_from] = primordialBalanceOf[_from].add(_value);
1920 		emit PrimordialUnstake(_from, _value, _weightedMultiplier);
1921 		return true;
1922 	}
1923 
1924 	/**
1925 	 * @dev Send `_value` primordial ions to `_to` on behalf of `_from`
1926 	 * @param _from The address of the sender
1927 	 * @param _to The address of the recipient
1928 	 * @param _value The amount to send
1929 	 * @return true on success
1930 	 */
1931 	function whitelistTransferPrimordialFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool) {
1932 		return _createLotAndTransferPrimordial(_from, _to, _value);
1933 	}
1934 
1935 	/***** PUBLIC METHODS *****/
1936 	/***** PRIMORDIAL ION PUBLIC METHODS *****/
1937 	/**
1938 	 * @dev Buy Primordial ions from contract by sending ether
1939 	 */
1940 	function buyPrimordial() public payable canBuyPrimordial(msg.value, true) {
1941 		(uint256 amount, uint256 remainderBudget, bool shouldEndNetworkExchange) = _calculateAmountAndRemainderBudget(msg.value, true);
1942 		require (amount > 0);
1943 
1944 		// Ends network exchange if necessary
1945 		if (shouldEndNetworkExchange) {
1946 			networkExchangeEnded = true;
1947 			emit NetworkExchangeEnded();
1948 		}
1949 
1950 		// Update totalEthForPrimordial
1951 		totalEthForPrimordial = totalEthForPrimordial.add(msg.value.sub(remainderBudget));
1952 
1953 		// Send the primordial ion to buyer and reward AO devs
1954 		bytes32 _lotId = _sendPrimordialAndRewardDev(amount, msg.sender);
1955 
1956 		emit BuyPrimordial(msg.sender, _lotId, 1, msg.value, remainderBudget);
1957 
1958 		// Send remainder budget back to buyer if exist
1959 		if (remainderBudget > 0) {
1960 			msg.sender.transfer(remainderBudget);
1961 		}
1962 	}
1963 
1964 	/**
1965 	 * @dev Buy Primordial ion from contract by sending AOETH
1966 	 */
1967 	function buyPrimordialWithAOETH(uint256 _aoethAmount) public canBuyPrimordial(_aoethAmount, false) {
1968 		(uint256 amount, uint256 remainderBudget, bool shouldEndNetworkExchange) = _calculateAmountAndRemainderBudget(_aoethAmount, false);
1969 		require (amount > 0);
1970 
1971 		// Ends network exchange if necessary
1972 		if (shouldEndNetworkExchange) {
1973 			networkExchangeEnded = true;
1974 			emit NetworkExchangeEnded();
1975 		}
1976 
1977 		// Calculate the actual AOETH that was charged for this transaction
1978 		uint256 actualCharge = _aoethAmount.sub(remainderBudget);
1979 
1980 		// Update totalRedeemedAOETH
1981 		totalRedeemedAOETH = totalRedeemedAOETH.add(actualCharge);
1982 
1983 		// Transfer AOETH from buyer to here
1984 		require (_aoeth.whitelistTransferFrom(msg.sender, address(this), actualCharge));
1985 
1986 		// Send the primordial ion to buyer and reward AO devs
1987 		bytes32 _lotId = _sendPrimordialAndRewardDev(amount, msg.sender);
1988 
1989 		emit BuyPrimordial(msg.sender, _lotId, 2, _aoethAmount, remainderBudget);
1990 	}
1991 
1992 	/**
1993 	 * @dev Send `_value` Primordial ions to `_to` from your account
1994 	 * @param _to The address of the recipient
1995 	 * @param _value The amount to send
1996 	 * @return true on success
1997 	 */
1998 	function transferPrimordial(address _to, uint256 _value) public returns (bool) {
1999 		return _createLotAndTransferPrimordial(msg.sender, _to, _value);
2000 	}
2001 
2002 	/**
2003 	 * @dev Send `_value` Primordial ions to `_to` from `_from`
2004 	 * @param _from The address of the sender
2005 	 * @param _to The address of the recipient
2006 	 * @param _value The amount to send
2007 	 * @return true on success
2008 	 */
2009 	function transferPrimordialFrom(address _from, address _to, uint256 _value) public returns (bool) {
2010 		require (_value <= primordialAllowance[_from][msg.sender]);
2011 		primordialAllowance[_from][msg.sender] = primordialAllowance[_from][msg.sender].sub(_value);
2012 
2013 		return _createLotAndTransferPrimordial(_from, _to, _value);
2014 	}
2015 
2016 	/**
2017 	 * Transfer primordial ions between public key addresses in a Name
2018 	 * @param _nameId The ID of the Name
2019 	 * @param _from The address of the sender
2020 	 * @param _to The address of the recipient
2021 	 * @param _value the amount to send
2022 	 */
2023 	function transferPrimordialBetweenPublicKeys(address _nameId, address _from, address _to, uint256 _value) public returns (bool) {
2024 		require (AOLibrary.isName(_nameId));
2025 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _nameId));
2026 		require (!_nameAccountRecovery.isCompromised(_nameId));
2027 		// Make sure _from exist in the Name's Public Keys
2028 		require (_namePublicKey.isKeyExist(_nameId, _from));
2029 		// Make sure _to exist in the Name's Public Keys
2030 		require (_namePublicKey.isKeyExist(_nameId, _to));
2031 		return _createLotAndTransferPrimordial(_from, _to, _value);
2032 	}
2033 
2034 	/**
2035 	 * @dev Allows `_spender` to spend no more than `_value` Primordial ions in your behalf
2036 	 * @param _spender The address authorized to spend
2037 	 * @param _value The max amount they can spend
2038 	 * @return true on success
2039 	 */
2040 	function approvePrimordial(address _spender, uint256 _value) public returns (bool) {
2041 		primordialAllowance[msg.sender][_spender] = _value;
2042 		emit PrimordialApproval(msg.sender, _spender, _value);
2043 		return true;
2044 	}
2045 
2046 	/**
2047 	 * @dev Allows `_spender` to spend no more than `_value` Primordial ions in your behalf, and then ping the contract about it
2048 	 * @param _spender The address authorized to spend
2049 	 * @param _value The max amount they can spend
2050 	 * @param _extraData some extra information to send to the approved contract
2051 	 * @return true on success
2052 	 */
2053 	function approvePrimordialAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool) {
2054 		tokenRecipient spender = tokenRecipient(_spender);
2055 		if (approvePrimordial(_spender, _value)) {
2056 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
2057 			return true;
2058 		}
2059 	}
2060 
2061 	/**
2062 	 * @dev Remove `_value` Primordial ions from the system irreversibly
2063 	 *		and re-weight the account's multiplier after burn
2064 	 * @param _value The amount to burn
2065 	 * @return true on success
2066 	 */
2067 	function burnPrimordial(uint256 _value) public returns (bool) {
2068 		require (primordialBalanceOf[msg.sender] >= _value);
2069 		require (calculateMaximumBurnAmount(msg.sender) >= _value);
2070 
2071 		// Update the account's multiplier
2072 		ownerWeightedMultiplier[msg.sender] = calculateMultiplierAfterBurn(msg.sender, _value);
2073 		primordialBalanceOf[msg.sender] = primordialBalanceOf[msg.sender].sub(_value);
2074 		primordialTotalSupply = primordialTotalSupply.sub(_value);
2075 
2076 		// Store burn lot info
2077 		require (_aoIonLot.createBurnLot(msg.sender, _value, ownerWeightedMultiplier[msg.sender]));
2078 		emit PrimordialBurn(msg.sender, _value);
2079 		return true;
2080 	}
2081 
2082 	/**
2083 	 * @dev Remove `_value` Primordial ions from the system irreversibly on behalf of `_from`
2084 	 *		and re-weight `_from`'s multiplier after burn
2085 	 * @param _from The address of sender
2086 	 * @param _value The amount to burn
2087 	 * @return true on success
2088 	 */
2089 	function burnPrimordialFrom(address _from, uint256 _value) public returns (bool) {
2090 		require (primordialBalanceOf[_from] >= _value);
2091 		require (primordialAllowance[_from][msg.sender] >= _value);
2092 		require (calculateMaximumBurnAmount(_from) >= _value);
2093 
2094 		// Update `_from`'s multiplier
2095 		ownerWeightedMultiplier[_from] = calculateMultiplierAfterBurn(_from, _value);
2096 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);
2097 		primordialAllowance[_from][msg.sender] = primordialAllowance[_from][msg.sender].sub(_value);
2098 		primordialTotalSupply = primordialTotalSupply.sub(_value);
2099 
2100 		// Store burn lot info
2101 		require (_aoIonLot.createBurnLot(_from, _value, ownerWeightedMultiplier[_from]));
2102 		emit PrimordialBurn(_from, _value);
2103 		return true;
2104 	}
2105 
2106 	/**
2107 	 * @dev Return the average weighted multiplier of all lots owned by an address
2108 	 * @param _lotOwner The address of the lot owner
2109 	 * @return the weighted multiplier of the address (in 10 ** 6)
2110 	 */
2111 	function weightedMultiplierByAddress(address _lotOwner) public view returns (uint256) {
2112 		return ownerWeightedMultiplier[_lotOwner];
2113 	}
2114 
2115 	/**
2116 	 * @dev Return the max multiplier of an address
2117 	 * @param _target The address to query
2118 	 * @return the max multiplier of the address (in 10 ** 6)
2119 	 */
2120 	function maxMultiplierByAddress(address _target) public view returns (uint256) {
2121 		return (_aoIonLot.totalLotsByAddress(_target) > 0) ? ownerMaxMultiplier[_target] : 0;
2122 	}
2123 
2124 	/**
2125 	 * @dev Calculate the primordial ion multiplier, bonus network ion percentage, and the
2126 	 *		bonus network ion amount on a given lot when someone purchases primordial ion
2127 	 *		during network exchange
2128 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
2129 	 * @return The multiplier in (10 ** 6)
2130 	 * @return The bonus percentage
2131 	 * @return The amount of network ion as bonus
2132 	 */
2133 	function calculateMultiplierAndBonus(uint256 _purchaseAmount) public view returns (uint256, uint256, uint256) {
2134 		(uint256 startingPrimordialMultiplier, uint256 endingPrimordialMultiplier, uint256 startingNetworkBonusMultiplier, uint256 endingNetworkBonusMultiplier) = _getSettingVariables();
2135 		return (
2136 			AOLibrary.calculatePrimordialMultiplier(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingPrimordialMultiplier, endingPrimordialMultiplier),
2137 			AOLibrary.calculateNetworkBonusPercentage(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier),
2138 			AOLibrary.calculateNetworkBonusAmount(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier)
2139 		);
2140 	}
2141 
2142 	/**
2143 	 * @dev Calculate the maximum amount of Primordial an account can burn
2144 	 * @param _account The address of the account
2145 	 * @return The maximum primordial ion amount to burn
2146 	 */
2147 	function calculateMaximumBurnAmount(address _account) public view returns (uint256) {
2148 		return AOLibrary.calculateMaximumBurnAmount(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], ownerMaxMultiplier[_account]);
2149 	}
2150 
2151 	/**
2152 	 * @dev Calculate account's new multiplier after burn `_amountToBurn` primordial ions
2153 	 * @param _account The address of the account
2154 	 * @param _amountToBurn The amount of primordial ion to burn
2155 	 * @return The new multiplier in (10 ** 6)
2156 	 */
2157 	function calculateMultiplierAfterBurn(address _account, uint256 _amountToBurn) public view returns (uint256) {
2158 		require (calculateMaximumBurnAmount(_account) >= _amountToBurn);
2159 		return AOLibrary.calculateMultiplierAfterBurn(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], _amountToBurn);
2160 	}
2161 
2162 	/**
2163 	 * @dev Calculate account's new multiplier after converting `amountToConvert` network ion to primordial ion
2164 	 * @param _account The address of the account
2165 	 * @param _amountToConvert The amount of network ion to convert
2166 	 * @return The new multiplier in (10 ** 6)
2167 	 */
2168 	function calculateMultiplierAfterConversion(address _account, uint256 _amountToConvert) public view returns (uint256) {
2169 		return AOLibrary.calculateMultiplierAfterConversion(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], _amountToConvert);
2170 	}
2171 
2172 	/**
2173 	 * @dev Convert `_value` of network ions to primordial ions
2174 	 *		and re-weight the account's multiplier after conversion
2175 	 * @param _value The amount to convert
2176 	 * @return true on success
2177 	 */
2178 	function convertToPrimordial(uint256 _value) public returns (bool) {
2179 		require (balanceOf[msg.sender] >= _value);
2180 
2181 		// Update the account's multiplier
2182 		ownerWeightedMultiplier[msg.sender] = calculateMultiplierAfterConversion(msg.sender, _value);
2183 		// Burn network ion
2184 		burn(_value);
2185 		// mint primordial ion
2186 		_mintPrimordial(msg.sender, _value);
2187 
2188 		require (_aoIonLot.createConvertLot(msg.sender, _value, ownerWeightedMultiplier[msg.sender]));
2189 		return true;
2190 	}
2191 
2192 	/**
2193 	 * @dev Get quantity of AO+ left in Network Exchange
2194 	 * @return The quantity of AO+ left in Network Exchange
2195 	 */
2196 	function availablePrimordialForSale() public view returns (uint256) {
2197 		return TOTAL_PRIMORDIAL_FOR_SALE.sub(primordialTotalBought);
2198 	}
2199 
2200 	/**
2201 	 * @dev Get quantity of AO+ in ETH left in Network Exchange (i.e How much ETH is there total that can be
2202 	 *		exchanged for AO+
2203 	 * @return The quantity of AO+ in ETH left in Network Exchange
2204 	 */
2205 	function availablePrimordialForSaleInETH() public view returns (uint256) {
2206 		return availablePrimordialForSale().mul(primordialBuyPrice);
2207 	}
2208 
2209 	/**
2210 	 * @dev Get maximum quantity of AOETH or ETH that can still be sold
2211 	 * @return The maximum quantity of AOETH or ETH that can still be sold
2212 	 */
2213 	function availableETH() public view returns (uint256) {
2214 		if (availablePrimordialForSaleInETH() > 0) {
2215 			uint256 _availableETH = availablePrimordialForSaleInETH().sub(_aoeth.totalSupply().sub(totalRedeemedAOETH));
2216 			if (availablePrimordialForSale() == 1 && _availableETH < primordialBuyPrice) {
2217 				return primordialBuyPrice;
2218 			} else {
2219 				return _availableETH;
2220 			}
2221 		} else {
2222 			return 0;
2223 		}
2224 	}
2225 
2226 	/***** INTERNAL METHODS *****/
2227 	/***** PRIMORDIAL ION INTERNAL METHODS *****/
2228 	/**
2229 	 * @dev Calculate the amount of ion the buyer will receive and remaining budget if exist
2230 	 *		when he/she buys primordial ion
2231 	 * @param _budget The amount of ETH sent by buyer
2232 	 * @param _withETH Whether or not buyer is paying with ETH
2233 	 * @return uint256 of the amount the buyer will receiver
2234 	 * @return uint256 of the remaining budget, if exist
2235 	 * @return bool whether or not the network exchange should end
2236 	 */
2237 	function _calculateAmountAndRemainderBudget(uint256 _budget, bool _withETH) internal view returns (uint256, uint256, bool) {
2238 		// Calculate the amount of ion
2239 		uint256 amount = _budget.div(primordialBuyPrice);
2240 
2241 		// If we need to return ETH to the buyer, in the case
2242 		// where the buyer sends more ETH than available primordial ion to be purchased
2243 		uint256 remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
2244 
2245 		uint256 _availableETH = availableETH();
2246 		// If paying with ETH, it can't exceed availableETH
2247 		if (_withETH && _budget > availableETH()) {
2248 			// Calculate the amount of ions
2249 			amount = _availableETH.div(primordialBuyPrice);
2250 			remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
2251 		}
2252 
2253 		// Make sure primordialTotalBought is not overflowing
2254 		bool shouldEndNetworkExchange = false;
2255 		if (primordialTotalBought.add(amount) >= TOTAL_PRIMORDIAL_FOR_SALE) {
2256 			amount = TOTAL_PRIMORDIAL_FOR_SALE.sub(primordialTotalBought);
2257 			shouldEndNetworkExchange = true;
2258 			remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
2259 		}
2260 		return (amount, remainderEth, shouldEndNetworkExchange);
2261 	}
2262 
2263 	/**
2264 	 * @dev Actually sending the primordial ion to buyer and reward AO devs accordingly
2265 	 * @param amount The amount of primordial ion to be sent to buyer
2266 	 * @param to The recipient of ion
2267 	 * @return the lot Id of the buyer
2268 	 */
2269 	function _sendPrimordialAndRewardDev(uint256 amount, address to) internal returns (bytes32) {
2270 		(uint256 startingPrimordialMultiplier,, uint256 startingNetworkBonusMultiplier, uint256 endingNetworkBonusMultiplier) = _getSettingVariables();
2271 
2272 		// Update primordialTotalBought
2273 		(uint256 multiplier, uint256 networkBonusPercentage, uint256 networkBonusAmount) = calculateMultiplierAndBonus(amount);
2274 		primordialTotalBought = primordialTotalBought.add(amount);
2275 		bytes32 _lotId = _createPrimordialLot(to, amount, multiplier, networkBonusAmount);
2276 
2277 		// Calculate The AO and AO Dev Team's portion of Primordial and Network ion Bonus
2278 		uint256 inverseMultiplier = startingPrimordialMultiplier.sub(multiplier); // Inverse of the buyer's multiplier
2279 		uint256 theAONetworkBonusAmount = (startingNetworkBonusMultiplier.sub(networkBonusPercentage).add(endingNetworkBonusMultiplier)).mul(amount).div(AOLibrary.PERCENTAGE_DIVISOR());
2280 		if (aoDevTeam1 != address(0)) {
2281 			_createPrimordialLot(aoDevTeam1, amount.div(2), inverseMultiplier, theAONetworkBonusAmount.div(2));
2282 		}
2283 		if (aoDevTeam2 != address(0)) {
2284 			_createPrimordialLot(aoDevTeam2, amount.div(2), inverseMultiplier, theAONetworkBonusAmount.div(2));
2285 		}
2286 		_mint(theAO, theAONetworkBonusAmount);
2287 		return _lotId;
2288 	}
2289 
2290 	/**
2291 	 * @dev Create a lot with `primordialAmount` of primordial ions with `_multiplier` for an `account`
2292 	 *		during network exchange, and reward `_networkBonusAmount` if exist
2293 	 * @param _account Address of the lot owner
2294 	 * @param _primordialAmount The amount of primordial ions to be stored in the lot
2295 	 * @param _multiplier The multiplier for this lot in (10 ** 6)
2296 	 * @param _networkBonusAmount The network ion bonus amount
2297 	 * @return Created lot Id
2298 	 */
2299 	function _createPrimordialLot(address _account, uint256 _primordialAmount, uint256 _multiplier, uint256 _networkBonusAmount) internal returns (bytes32) {
2300 		bytes32 lotId = _aoIonLot.createPrimordialLot(_account, _primordialAmount, _multiplier, _networkBonusAmount);
2301 
2302 		ownerWeightedMultiplier[_account] = AOLibrary.calculateWeightedMultiplier(ownerWeightedMultiplier[_account], primordialBalanceOf[_account], _multiplier, _primordialAmount);
2303 
2304 		// If this is the first lot, set this as the max multiplier of the account
2305 		if (_aoIonLot.totalLotsByAddress(_account) == 1) {
2306 			ownerMaxMultiplier[_account] = _multiplier;
2307 		}
2308 		_mintPrimordial(_account, _primordialAmount);
2309 		_mint(_account, _networkBonusAmount);
2310 
2311 		return lotId;
2312 	}
2313 
2314 	/**
2315 	 * @dev Create `mintedAmount` Primordial ions and send it to `target`
2316 	 * @param target Address to receive the Primordial ions
2317 	 * @param mintedAmount The amount of Primordial ions it will receive
2318 	 */
2319 	function _mintPrimordial(address target, uint256 mintedAmount) internal {
2320 		primordialBalanceOf[target] = primordialBalanceOf[target].add(mintedAmount);
2321 		primordialTotalSupply = primordialTotalSupply.add(mintedAmount);
2322 		emit PrimordialTransfer(address(0), address(this), mintedAmount);
2323 		emit PrimordialTransfer(address(this), target, mintedAmount);
2324 	}
2325 
2326 	/**
2327 	 * @dev Create a lot with `amount` of ions at `weightedMultiplier` for an `account`
2328 	 * @param _account Address of lot owner
2329 	 * @param _amount The amount of ions
2330 	 * @param _weightedMultiplier The multiplier of the lot (in 10^6)
2331 	 * @return bytes32 of new created lot ID
2332 	 */
2333 	function _createWeightedMultiplierLot(address _account, uint256 _amount, uint256 _weightedMultiplier) internal returns (bytes32) {
2334 		require (_account != address(0));
2335 		require (_amount > 0);
2336 
2337 		bytes32 lotId = _aoIonLot.createWeightedMultiplierLot(_account, _amount, _weightedMultiplier);
2338 		// If this is the first lot, set this as the max multiplier of the account
2339 		if (_aoIonLot.totalLotsByAddress(_account) == 1) {
2340 			ownerMaxMultiplier[_account] = _weightedMultiplier;
2341 		}
2342 		return lotId;
2343 	}
2344 
2345 	/**
2346 	 * @dev Create Lot and send `_value` Primordial ions from `_from` to `_to`
2347 	 * @param _from The address of sender
2348 	 * @param _to The address of the recipient
2349 	 * @param _value The amount to send
2350 	 * @return true on success
2351 	 */
2352 	function _createLotAndTransferPrimordial(address _from, address _to, uint256 _value) internal returns (bool) {
2353 		bytes32 _createdLotId = _createWeightedMultiplierLot(_to, _value, ownerWeightedMultiplier[_from]);
2354 		(, address _lotOwner,,) = _aoIonLot.lotById(_createdLotId);
2355 
2356 		// Make sure the new lot is created successfully
2357 		require (_lotOwner == _to);
2358 
2359 		// Update the weighted multiplier of the recipient
2360 		ownerWeightedMultiplier[_to] = AOLibrary.calculateWeightedMultiplier(ownerWeightedMultiplier[_to], primordialBalanceOf[_to], ownerWeightedMultiplier[_from], _value);
2361 
2362 		// Transfer the Primordial ions
2363 		require (_transferPrimordial(_from, _to, _value));
2364 		return true;
2365 	}
2366 
2367 	/**
2368 	 * @dev Send `_value` Primordial ions from `_from` to `_to`
2369 	 * @param _from The address of sender
2370 	 * @param _to The address of the recipient
2371 	 * @param _value The amount to send
2372 	 */
2373 	function _transferPrimordial(address _from, address _to, uint256 _value) internal returns (bool) {
2374 		require (_to != address(0));									// Prevent transfer to 0x0 address. Use burn() instead
2375 		require (primordialBalanceOf[_from] >= _value);						// Check if the sender has enough
2376 		require (primordialBalanceOf[_to].add(_value) >= primordialBalanceOf[_to]);	// Check for overflows
2377 		require (!frozenAccount[_from]);								// Check if sender is frozen
2378 		require (!frozenAccount[_to]);									// Check if recipient is frozen
2379 		uint256 previousBalances = primordialBalanceOf[_from].add(primordialBalanceOf[_to]);
2380 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);			// Subtract from the sender
2381 		primordialBalanceOf[_to] = primordialBalanceOf[_to].add(_value);				// Add the same to the recipient
2382 		emit PrimordialTransfer(_from, _to, _value);
2383 		assert(primordialBalanceOf[_from].add(primordialBalanceOf[_to]) == previousBalances);
2384 		return true;
2385 	}
2386 
2387 	/**
2388 	 * @dev Get setting variables
2389 	 * @return startingPrimordialMultiplier The starting multiplier used to calculate primordial ion
2390 	 * @return endingPrimordialMultiplier The ending multiplier used to calculate primordial ion
2391 	 * @return startingNetworkBonusMultiplier The starting multiplier used to calculate network ion bonus
2392 	 * @return endingNetworkBonusMultiplier The ending multiplier used to calculate network ion bonus
2393 	 */
2394 	function _getSettingVariables() internal view returns (uint256, uint256, uint256, uint256) {
2395 		(uint256 startingPrimordialMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'startingPrimordialMultiplier');
2396 		(uint256 endingPrimordialMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'endingPrimordialMultiplier');
2397 
2398 		(uint256 startingNetworkBonusMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'startingNetworkBonusMultiplier');
2399 		(uint256 endingNetworkBonusMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'endingNetworkBonusMultiplier');
2400 
2401 		return (startingPrimordialMultiplier, endingPrimordialMultiplier, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier);
2402 	}
2403 }
2404 
2405 
2406 
2407 
2408 
2409 
2410 contract Pathos is TAOCurrency {
2411 	/**
2412 	 * @dev Constructor function
2413 	 */
2414 	constructor(string memory _name, string memory _symbol, address _nameTAOPositionAddress)
2415 		TAOCurrency(_name, _symbol, _nameTAOPositionAddress) public {}
2416 }
2417 
2418 
2419 
2420 
2421 
2422 contract Ethos is TAOCurrency {
2423 	/**
2424 	 * @dev Constructor function
2425 	 */
2426 	constructor(string memory _name, string memory _symbol, address _nameTAOPositionAddress)
2427 		TAOCurrency(_name, _symbol, _nameTAOPositionAddress) public {}
2428 }
2429 
2430 
2431 
2432 
2433 
2434 
2435 
2436 /**
2437  * @title AOEarning
2438  *
2439  * This contract stores the earning from staking/hosting content on AO
2440  */
2441 contract AOEarning is TheAO, IAOEarning {
2442 	using SafeMath for uint256;
2443 
2444 	address public settingTAOId;
2445 	address public aoSettingAddress;
2446 	address public aoIonAddress;
2447 	address public nameFactoryAddress;
2448 	address public pathosAddress;
2449 	address public ethosAddress;
2450 	address public aoContentAddress;
2451 	address public aoStakedContentAddress;
2452 	address public aoContentHostAddress;
2453 	address public aoPurchaseReceiptAddress;
2454 	address public namePublicKeyAddress;
2455 
2456 	IAOSetting internal _aoSetting;
2457 	AOIon internal _aoIon;
2458 	INameFactory internal _nameFactory;
2459 	Pathos internal _pathos;
2460 	Ethos internal _ethos;
2461 	IAOContent internal _aoContent;
2462 	IAOStakedContent internal _aoStakedContent;
2463 	IAOContentHost internal _aoContentHost;
2464 	IAOPurchaseReceipt internal _aoPurchaseReceipt;
2465 	INamePublicKey internal _namePublicKey;
2466 
2467 	// Total earning from staking content from all nodes
2468 	uint256 public totalStakedContentEarning;
2469 
2470 	// Total earning from hosting content from all nodes
2471 	uint256 public totalContentHostEarning;
2472 
2473 	// Total The AO earning
2474 	uint256 public totalTheAOEarning;
2475 
2476 	// Mapping from PurchaseReceipt ID to its escrowed earning status
2477 	mapping (bytes32 => bool) internal purchaseReceiptEarningEscrowed;
2478 
2479 	// Mapping from PurchaseReceipt ID to its unescrowed earning status
2480 	mapping (bytes32 => bool) internal purchaseReceiptEarningUnescrowed;
2481 
2482 	// Mapping from address to his/her earning from content that he/she staked
2483 	mapping (address => uint256) public ownerStakedContentEarning;
2484 
2485 	// Mapping from address to his/her earning from content that he/she hosted
2486 	mapping (address => uint256) public ownerContentHostEarning;
2487 
2488 	// Mapping from address to his/her network price earning
2489 	// i.e, when staked amount = filesize
2490 	mapping (address => uint256) public ownerNetworkPriceEarning;
2491 
2492 	// Mapping from address to his/her content price earning
2493 	// i.e, when staked amount > filesize
2494 	mapping (address => uint256) public ownerContentPriceEarning;
2495 
2496 	// Mapping from address to his/her inflation bonus
2497 	mapping (address => uint256) public ownerInflationBonusAccrued;
2498 
2499 	struct Earning {
2500 		bytes32 purchaseReceiptId;
2501 		uint256 paymentEarning;
2502 		uint256 inflationBonus;
2503 		uint256 pathosAmount;
2504 		uint256 ethosAmount;
2505 	}
2506 
2507 	// Mapping from address to earning from staking content of a PurchaseReceipt ID
2508 	mapping (address => mapping(bytes32 => Earning)) public ownerPurchaseReceiptStakeEarnings;
2509 
2510 	// Mapping from address to earning from hosting content of a PurchaseReceipt ID
2511 	mapping (address => mapping(bytes32 => Earning)) public ownerPurchaseReceiptHostEarnings;
2512 
2513 	// Mapping from PurchaaseReceipt ID to earning for The AO
2514 	mapping (bytes32 => Earning) public theAOPurchaseReceiptEarnings;
2515 
2516 	// Mapping from StakedContent ID to it's total earning from staking
2517 	mapping (bytes32 => uint256) public stakedContentStakeEarning;
2518 
2519 	// Mapping from StakedContent ID to it's total earning from hosting
2520 	mapping (bytes32 => uint256) public stakedContentHostEarning;
2521 
2522 	// Mapping from StakedContent ID to it's total earning earned by The AO
2523 	mapping (bytes32 => uint256) public stakedContentTheAOEarning;
2524 
2525 	// Mapping from content host ID to it's total earning
2526 	mapping (bytes32 => uint256) public contentHostEarning;
2527 
2528 	// Event to be broadcasted to public when content creator/host earns the payment split in escrow when request node buys the content
2529 	// recipientType:
2530 	// 0 => Content Creator (Stake Owner)
2531 	// 1 => Node Host
2532 	// 2 => The AO
2533 	event PaymentEarningEscrowed(address indexed recipient, bytes32 indexed purchaseReceiptId, uint256 price, uint256 recipientProfitPercentage, uint256 recipientPaymentEarning, uint8 recipientType);
2534 
2535 	// Event to be broadcasted to public when content creator/host/The AO earns inflation bonus in escrow when request node buys the content
2536 	// recipientType:
2537 	// 0 => Content Creator (Stake Owner)
2538 	// 1 => Node Host
2539 	// 2 => The AO
2540 	event InflationBonusEscrowed(address indexed recipient, bytes32 indexed purchaseReceiptId, uint256 totalInflationBonusAmount, uint256 recipientProfitPercentage, uint256 recipientInflationBonus, uint8 recipientType);
2541 
2542 	// Event to be broadcasted to public when content creator/host/The AO earning is released from escrow
2543 	// recipientType:
2544 	// 0 => Content Creator (Stake Owner)
2545 	// 1 => Node Host
2546 	// 2 => The AO
2547 	event EarningUnescrowed(address indexed recipient, bytes32 indexed purchaseReceiptId, uint256 paymentEarning, uint256 inflationBonus, uint8 recipientType);
2548 
2549 	// Event to be broadcasted to public when content creator's Name earns Pathos when a node buys a content
2550 	event PathosEarned(address indexed nameId, bytes32 indexed purchaseReceiptId, uint256 amount);
2551 
2552 	// Event to be broadcasted to public when host's Name earns Ethos when a node buys a content
2553 	event EthosEarned(address indexed nameId, bytes32 indexed purchaseReceiptId, uint256 amount);
2554 
2555 	/**
2556 	 * @dev Constructor function
2557 	 * @param _settingTAOId The TAO ID that controls the setting
2558 	 * @param _aoSettingAddress The address of AOSetting
2559 	 * @param _aoIonAddress The address of AOIon
2560 	 * @param _nameFactoryAddress The address of NameFactory
2561 	 * @param _pathosAddress The address of Pathos
2562 	 * @param _ethosAddress The address of Ethos
2563 	 * @param _namePublicKeyAddress The address of NamePublicKey
2564 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
2565 	 */
2566 	constructor(address _settingTAOId,
2567 		address _aoSettingAddress,
2568 		address _aoIonAddress,
2569 		address _nameFactoryAddress,
2570 		address _pathosAddress,
2571 		address _ethosAddress,
2572 		address _aoContentAddress,
2573 		address _namePublicKeyAddress,
2574 		address _nameTAOPositionAddress) public {
2575 		setSettingTAOId(_settingTAOId);
2576 		setAOSettingAddress(_aoSettingAddress);
2577 		setAOIonAddress(_aoIonAddress);
2578 		setNameFactoryAddress(_nameFactoryAddress);
2579 		setPathosAddress(_pathosAddress);
2580 		setEthosAddress(_ethosAddress);
2581 		setAOContentAddress(_aoContentAddress);
2582 		setNamePublicKeyAddress(_namePublicKeyAddress);
2583 		setNameTAOPositionAddress(_nameTAOPositionAddress);
2584 	}
2585 
2586 	/**
2587 	 * @dev Checks if the calling contract address is The AO
2588 	 *		OR
2589 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
2590 	 */
2591 	modifier onlyTheAO {
2592 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
2593 		_;
2594 	}
2595 
2596 	/***** The AO ONLY METHODS *****/
2597 	/**
2598 	 * @dev Transfer ownership of The AO to new address
2599 	 * @param _theAO The new address to be transferred
2600 	 */
2601 	function transferOwnership(address _theAO) public onlyTheAO {
2602 		require (_theAO != address(0));
2603 		theAO = _theAO;
2604 	}
2605 
2606 	/**
2607 	 * @dev Whitelist `_account` address to transact on behalf of others
2608 	 * @param _account The address to whitelist
2609 	 * @param _whitelist Either to whitelist or not
2610 	 */
2611 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
2612 		require (_account != address(0));
2613 		whitelist[_account] = _whitelist;
2614 	}
2615 
2616 	/**
2617 	 * @dev The AO sets setting TAO ID
2618 	 * @param _settingTAOId The new setting TAO ID to set
2619 	 */
2620 	function setSettingTAOId(address _settingTAOId) public onlyTheAO {
2621 		require (AOLibrary.isTAO(_settingTAOId));
2622 		settingTAOId = _settingTAOId;
2623 	}
2624 
2625 	/**
2626 	 * @dev The AO sets AO Setting address
2627 	 * @param _aoSettingAddress The address of AOSetting
2628 	 */
2629 	function setAOSettingAddress(address _aoSettingAddress) public onlyTheAO {
2630 		require (_aoSettingAddress != address(0));
2631 		aoSettingAddress = _aoSettingAddress;
2632 		_aoSetting = IAOSetting(_aoSettingAddress);
2633 	}
2634 
2635 	/**
2636 	 * @dev The AO sets AOIon address
2637 	 * @param _aoIonAddress The address of AOIon
2638 	 */
2639 	function setAOIonAddress(address _aoIonAddress) public onlyTheAO {
2640 		require (_aoIonAddress != address(0));
2641 		aoIonAddress = _aoIonAddress;
2642 		_aoIon = AOIon(_aoIonAddress);
2643 	}
2644 
2645 	/**
2646 	 * @dev The AO sets NameFactory address
2647 	 * @param _nameFactoryAddress The address of NameFactory
2648 	 */
2649 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
2650 		require (_nameFactoryAddress != address(0));
2651 		nameFactoryAddress = _nameFactoryAddress;
2652 		_nameFactory = INameFactory(_nameFactoryAddress);
2653 	}
2654 
2655 	/**
2656 	 * @dev The AO sets Pathos address
2657 	 * @param _pathosAddress The address of Pathos
2658 	 */
2659 	function setPathosAddress(address _pathosAddress) public onlyTheAO {
2660 		require (_pathosAddress != address(0));
2661 		pathosAddress = _pathosAddress;
2662 		_pathos = Pathos(_pathosAddress);
2663 	}
2664 
2665 	/**
2666 	 * @dev The AO sets Ethos address
2667 	 * @param _ethosAddress The address of Ethos
2668 	 */
2669 	function setEthosAddress(address _ethosAddress) public onlyTheAO {
2670 		require (_ethosAddress != address(0));
2671 		ethosAddress = _ethosAddress;
2672 		_ethos = Ethos(_ethosAddress);
2673 	}
2674 
2675 	/**
2676 	 * @dev The AO sets AOContent address
2677 	 * @param _aoContentAddress The address of AOContent
2678 	 */
2679 	function setAOContentAddress(address _aoContentAddress) public onlyTheAO {
2680 		require (_aoContentAddress != address(0));
2681 		aoContentAddress = _aoContentAddress;
2682 		_aoContent = IAOContent(_aoContentAddress);
2683 	}
2684 
2685 	/**
2686 	 * @dev The AO sets AOStakedContent address
2687 	 * @param _aoStakedContentAddress The address of AOStakedContent
2688 	 */
2689 	function setAOStakedContentAddress(address _aoStakedContentAddress) public onlyTheAO {
2690 		require (_aoStakedContentAddress != address(0));
2691 		aoStakedContentAddress = _aoStakedContentAddress;
2692 		_aoStakedContent = IAOStakedContent(_aoStakedContentAddress);
2693 	}
2694 
2695 	/**
2696 	 * @dev The AO sets AOContentHost address
2697 	 * @param _aoContentHostAddress The address of AOContentHost
2698 	 */
2699 	function setAOContentHostAddress(address _aoContentHostAddress) public onlyTheAO {
2700 		require (_aoContentHostAddress != address(0));
2701 		aoContentHostAddress = _aoContentHostAddress;
2702 		_aoContentHost = IAOContentHost(_aoContentHostAddress);
2703 	}
2704 
2705 	/**
2706 	 * @dev The AO sets AOPurchaseReceipt address
2707 	 * @param _aoPurchaseReceiptAddress The address of AOPurchaseReceipt
2708 	 */
2709 	function setAOPurchaseReceiptAddress(address _aoPurchaseReceiptAddress) public onlyTheAO {
2710 		require (_aoPurchaseReceiptAddress != address(0));
2711 		aoPurchaseReceiptAddress = _aoPurchaseReceiptAddress;
2712 		_aoPurchaseReceipt = IAOPurchaseReceipt(_aoPurchaseReceiptAddress);
2713 	}
2714 
2715 	/**
2716 	 * @dev The AO sets NamePublicKey address
2717 	 * @param _namePublicKeyAddress The address of NamePublicKey
2718 	 */
2719 	function setNamePublicKeyAddress(address _namePublicKeyAddress) public onlyTheAO {
2720 		require (_namePublicKeyAddress != address(0));
2721 		namePublicKeyAddress = _namePublicKeyAddress;
2722 		_namePublicKey = INamePublicKey(_namePublicKeyAddress);
2723 	}
2724 
2725 	/**
2726 	 * @dev The AO set the NameTAOPosition Address
2727 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
2728 	 */
2729 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
2730 		require (_nameTAOPositionAddress != address(0));
2731 		nameTAOPositionAddress = _nameTAOPositionAddress;
2732 	}
2733 
2734 	/***** PUBLIC METHODS *****/
2735 	/**
2736 	 * @dev Calculate the content creator/host/The AO earning when request node buys the content.
2737 	 *		Also at this stage, all of the earnings are stored in escrow
2738 	 * @param _purchaseReceiptId The ID of the purchase receipt object
2739 	 * @return true on success
2740 	 */
2741 	function calculateEarning(bytes32 _purchaseReceiptId) external inWhitelist returns (bool) {
2742 		require (_aoPurchaseReceipt.isExist(_purchaseReceiptId));
2743 		require (!purchaseReceiptEarningEscrowed[_purchaseReceiptId]);
2744 		purchaseReceiptEarningEscrowed[_purchaseReceiptId] = true;
2745 
2746 		// Split the payment earning between content creator and host and store them in escrow
2747 		_escrowPaymentEarning(_purchaseReceiptId);
2748 
2749 		// Calculate the inflation bonus earning for content creator/node/The AO in escrow
2750 		_escrowInflationBonus(_purchaseReceiptId);
2751 		return true;
2752 	}
2753 
2754 	/**
2755 	 * @dev Release the payment earning and inflation bonus that is in escrow for specific PurchaseReceipt ID
2756 	 * @param _purchaseReceiptId The purchase receipt ID to check
2757 	 * @return true on success
2758 	 */
2759 	function releaseEarning(bytes32 _purchaseReceiptId) external inWhitelist returns (bool) {
2760 		require (_aoPurchaseReceipt.isExist(_purchaseReceiptId));
2761 		require (purchaseReceiptEarningEscrowed[_purchaseReceiptId] && !purchaseReceiptEarningUnescrowed[_purchaseReceiptId]);
2762 		purchaseReceiptEarningUnescrowed[_purchaseReceiptId] = true;
2763 
2764 		(bytes32 _contentHostId, bytes32 _stakedContentId, bytes32 _contentId,,, uint256 _amountPaidByBuyer,,,,) = _aoPurchaseReceipt.getById(_purchaseReceiptId);
2765 		(, address _stakeOwner,,,,,,) = _aoStakedContent.getById(_stakedContentId);
2766 		(,, address _host,,) = _aoContentHost.getById(_contentHostId);
2767 		(, uint256 _fileSize,,,,,,,) = _aoContent.getById(_contentId);
2768 
2769 		// Release the earning in escrow for stake owner
2770 		_releaseEarning(_stakedContentId, _contentHostId, _purchaseReceiptId, _amountPaidByBuyer > _fileSize, _stakeOwner, 0);
2771 
2772 		// Release the earning in escrow for host
2773 		_releaseEarning(_stakedContentId, _contentHostId, _purchaseReceiptId, _amountPaidByBuyer > _fileSize, _host, 1);
2774 
2775 		// Release the earning in escrow for The AO
2776 		_releaseEarning(_stakedContentId, _contentHostId, _purchaseReceiptId, _amountPaidByBuyer > _fileSize, theAO, 2);
2777 		return true;
2778 	}
2779 
2780 	/**
2781 	 * @dev Return the earning information of a StakedContent ID
2782 	 * @param _stakedContentId The ID of the staked content
2783 	 * @return the total earning from staking this content
2784 	 * @return the total earning from hosting this content
2785 	 * @return the total The AO earning of this content
2786 	 */
2787 	function getTotalStakedContentEarning(bytes32 _stakedContentId) external view returns (uint256, uint256, uint256) {
2788 		return (
2789 			stakedContentStakeEarning[_stakedContentId],
2790 			stakedContentHostEarning[_stakedContentId],
2791 			stakedContentTheAOEarning[_stakedContentId]
2792 		);
2793 	}
2794 
2795 	/***** INTERNAL METHODS *****/
2796 	/**
2797 	 * @dev Calculate the payment split for content creator/host and store them in escrow
2798 	 * @param _purchaseReceiptId The ID of the purchase receipt object
2799 	 */
2800 	function _escrowPaymentEarning(bytes32 _purchaseReceiptId) internal {
2801 		(uint256 _stakeOwnerEarning, uint256 _pathosAmount) = _escrowStakeOwnerPaymentEarning(_purchaseReceiptId);
2802 		(uint256 _ethosAmount) = _escrowHostPaymentEarning(_purchaseReceiptId, _stakeOwnerEarning);
2803 		_escrowTheAOPaymentEarning(_purchaseReceiptId, _pathosAmount, _ethosAmount);
2804 	}
2805 
2806 	/**
2807 	 * @dev Calculate the payment split for content creator and store them in escrow
2808 	 * @param _purchaseReceiptId The ID of the purchase receipt object
2809 	 * @return The stake owner's earning amount
2810 	 * @return The pathos earned from this transaction
2811 	 */
2812 	function _escrowStakeOwnerPaymentEarning(bytes32 _purchaseReceiptId) internal returns (uint256, uint256) {
2813 		(uint256 inflationRate,,) = _getSettingVariables();
2814 		(, bytes32 _stakedContentId, bytes32 _contentId, address _buyer, uint256 _price,,,,,) = _aoPurchaseReceipt.getById(_purchaseReceiptId);
2815 		(, address _stakeOwner,,,, uint256 _profitPercentage,,) = _aoStakedContent.getById(_stakedContentId);
2816 
2817 		Earning storage _ownerPurchaseReceiptStakeEarning = ownerPurchaseReceiptStakeEarnings[_stakeOwner][_purchaseReceiptId];
2818 		_ownerPurchaseReceiptStakeEarning.purchaseReceiptId = _purchaseReceiptId;
2819 
2820 		// Store how much the content creator (stake owner) earns in escrow
2821 		// If content is AO Content Usage Type, stake owner earns 0%
2822 		// and all profit goes to the serving host node
2823 		_ownerPurchaseReceiptStakeEarning.paymentEarning = _aoContent.isAOContentUsageType(_contentId) ? (_price.mul(_profitPercentage)).div(AOLibrary.PERCENTAGE_DIVISOR()) : 0;
2824 		// Pathos = Price X Node Share X Inflation Rate
2825 		_ownerPurchaseReceiptStakeEarning.pathosAmount = _price.mul(AOLibrary.PERCENTAGE_DIVISOR().sub(_profitPercentage)).mul(inflationRate).div(AOLibrary.PERCENTAGE_DIVISOR()).div(AOLibrary.PERCENTAGE_DIVISOR());
2826 		require (_aoIon.escrowFrom(_namePublicKey.getDefaultKey(_buyer), _namePublicKey.getDefaultKey(_stakeOwner), _ownerPurchaseReceiptStakeEarning.paymentEarning));
2827 		emit PaymentEarningEscrowed(_stakeOwner, _purchaseReceiptId, _price, _profitPercentage, _ownerPurchaseReceiptStakeEarning.paymentEarning, 0);
2828 		return (_ownerPurchaseReceiptStakeEarning.paymentEarning, _ownerPurchaseReceiptStakeEarning.pathosAmount);
2829 	}
2830 
2831 	/**
2832 	 * @dev Calculate the payment split for host node and store them in escrow
2833 	 * @param _purchaseReceiptId The ID of the purchase receipt object
2834 	 * @param _stakeOwnerEarning The stake owner's earning amount
2835 	 * @return The ethos earned from this transaction
2836 	 */
2837 	function _escrowHostPaymentEarning(bytes32 _purchaseReceiptId, uint256 _stakeOwnerEarning) internal returns (uint256) {
2838 		(uint256 inflationRate,,) = _getSettingVariables();
2839 		(bytes32 _contentHostId, bytes32 _stakedContentId, bytes32 _contentId, address _buyer, uint256 _price,,,,,) = _aoPurchaseReceipt.getById(_purchaseReceiptId);
2840 		(,,,,, uint256 _profitPercentage,,) = _aoStakedContent.getById(_stakedContentId);
2841 		(,, address _host,,) = _aoContentHost.getById(_contentHostId);
2842 
2843 		// Store how much the node host earns in escrow
2844 		Earning storage _ownerPurchaseReceiptHostEarning = ownerPurchaseReceiptHostEarnings[_host][_purchaseReceiptId];
2845 		_ownerPurchaseReceiptHostEarning.purchaseReceiptId = _purchaseReceiptId;
2846 		_ownerPurchaseReceiptHostEarning.paymentEarning = _price.sub(_stakeOwnerEarning);
2847 		// Ethos = Price X Creator Share X Inflation Rate
2848 		_ownerPurchaseReceiptHostEarning.ethosAmount = _price.mul(_profitPercentage).mul(inflationRate).div(AOLibrary.PERCENTAGE_DIVISOR()).div(AOLibrary.PERCENTAGE_DIVISOR());
2849 
2850 		if (_aoContent.isAOContentUsageType(_contentId)) {
2851 			require (_aoIon.escrowFrom(_namePublicKey.getDefaultKey(_buyer), _namePublicKey.getDefaultKey(_host), _ownerPurchaseReceiptHostEarning.paymentEarning));
2852 		} else {
2853 			// If not AO Content usage type, we want to mint to the host
2854 			require (_aoIon.mintEscrow(_namePublicKey.getDefaultKey(_host), _ownerPurchaseReceiptHostEarning.paymentEarning));
2855 		}
2856 		emit PaymentEarningEscrowed(_host, _purchaseReceiptId, _price, AOLibrary.PERCENTAGE_DIVISOR().sub(_profitPercentage), _ownerPurchaseReceiptHostEarning.paymentEarning, 1);
2857 		return _ownerPurchaseReceiptHostEarning.ethosAmount;
2858 	}
2859 
2860 	/**
2861 	 * @dev Calculate the earning for The AO and store them in escrow
2862 	 * @param _purchaseReceiptId The ID of the purchase receipt object
2863 	 * @param _pathosAmount The amount of pathos earned by stake owner
2864 	 * @param _ethosAmount The amount of ethos earned by host node
2865 	 */
2866 	function _escrowTheAOPaymentEarning(bytes32 _purchaseReceiptId, uint256 _pathosAmount, uint256 _ethosAmount) internal {
2867 		(,,uint256 theAOEthosEarnedRate) = _getSettingVariables();
2868 		(,,,, uint256 _price,,,,,) = _aoPurchaseReceipt.getById(_purchaseReceiptId);
2869 
2870 		// Store how much The AO earns in escrow
2871 		Earning storage _theAOPurchaseReceiptEarning = theAOPurchaseReceiptEarnings[_purchaseReceiptId];
2872 		_theAOPurchaseReceiptEarning.purchaseReceiptId = _purchaseReceiptId;
2873 		// Pathos + X% of Ethos
2874 		_theAOPurchaseReceiptEarning.paymentEarning = _pathosAmount.add(_ethosAmount.mul(theAOEthosEarnedRate).div(AOLibrary.PERCENTAGE_DIVISOR()));
2875 		require (_aoIon.mintEscrow(theAO, _theAOPurchaseReceiptEarning.paymentEarning));
2876 		emit PaymentEarningEscrowed(theAO, _purchaseReceiptId, _price, 0, _theAOPurchaseReceiptEarning.paymentEarning, 2);
2877 	}
2878 
2879 	/**
2880 	 * @dev Mint the inflation bonus for content creator/host/The AO and store them in escrow
2881 	 * @param _purchaseReceiptId The ID of the purchase receipt object
2882 	 */
2883 	function _escrowInflationBonus(
2884 		bytes32 _purchaseReceiptId
2885 	) internal {
2886 		(, uint256 theAOCut,) = _getSettingVariables();
2887 		uint256 _inflationBonusAmount = _calculateInflationBonus(_purchaseReceiptId);
2888 		(bytes32 _contentHostId, bytes32 _stakedContentId, bytes32 _contentId,,,,,,,) = _aoPurchaseReceipt.getById(_purchaseReceiptId);
2889 		(, address _stakeOwner,,,, uint256 _profitPercentage,,) = _aoStakedContent.getById(_stakedContentId);
2890 		(,, address _host,,) = _aoContentHost.getById(_contentHostId);
2891 
2892 		if (_inflationBonusAmount > 0) {
2893 			// Store how much the content creator earns in escrow
2894 			uint256 _stakeOwnerInflationBonus = _aoContent.isAOContentUsageType(_contentId) ? (_inflationBonusAmount.mul(_profitPercentage)).div(AOLibrary.PERCENTAGE_DIVISOR()) : 0;
2895 			Earning storage _ownerPurchaseReceiptStakeEarning = ownerPurchaseReceiptStakeEarnings[_stakeOwner][_purchaseReceiptId];
2896 			_ownerPurchaseReceiptStakeEarning.inflationBonus = _stakeOwnerInflationBonus;
2897 			require (_aoIon.mintEscrow(_namePublicKey.getDefaultKey(_stakeOwner), _ownerPurchaseReceiptStakeEarning.inflationBonus));
2898 			emit InflationBonusEscrowed(_stakeOwner, _purchaseReceiptId, _inflationBonusAmount, _profitPercentage, _ownerPurchaseReceiptStakeEarning.inflationBonus, 0);
2899 
2900 			// Store how much the host earns in escrow
2901 			Earning storage _ownerPurchaseReceiptHostEarning = ownerPurchaseReceiptHostEarnings[_host][_purchaseReceiptId];
2902 			_ownerPurchaseReceiptHostEarning.inflationBonus = _inflationBonusAmount.sub(_stakeOwnerInflationBonus);
2903 			require (_aoIon.mintEscrow(_namePublicKey.getDefaultKey(_host), _ownerPurchaseReceiptHostEarning.inflationBonus));
2904 			emit InflationBonusEscrowed(_host, _purchaseReceiptId, _inflationBonusAmount, AOLibrary.PERCENTAGE_DIVISOR().sub(_profitPercentage), _ownerPurchaseReceiptHostEarning.inflationBonus, 1);
2905 
2906 			// Store how much the The AO earns in escrow
2907 			Earning storage _theAOPurchaseReceiptEarning = theAOPurchaseReceiptEarnings[_purchaseReceiptId];
2908 			_theAOPurchaseReceiptEarning.inflationBonus = (_inflationBonusAmount.mul(theAOCut)).div(AOLibrary.PERCENTAGE_DIVISOR());
2909 			require (_aoIon.mintEscrow(theAO, _theAOPurchaseReceiptEarning.inflationBonus));
2910 			emit InflationBonusEscrowed(theAO, _purchaseReceiptId, _inflationBonusAmount, theAOCut, _theAOPurchaseReceiptEarning.inflationBonus, 2);
2911 		} else {
2912 			emit InflationBonusEscrowed(_stakeOwner, _purchaseReceiptId, 0, _profitPercentage, 0, 0);
2913 			emit InflationBonusEscrowed(_host, _purchaseReceiptId, 0, AOLibrary.PERCENTAGE_DIVISOR().sub(_profitPercentage), 0, 1);
2914 			emit InflationBonusEscrowed(theAO, _purchaseReceiptId, 0, theAOCut, 0, 2);
2915 		}
2916 	}
2917 
2918 	/**
2919 	 * @dev Calculate the inflation bonus amount
2920 	 * @param _purchaseReceiptId The ID of the PurchaseReceipt
2921 	 * @return the bonus network amount
2922 	 */
2923 	function _calculateInflationBonus(bytes32 _purchaseReceiptId) internal view returns (uint256) {
2924 		(uint256 inflationRate,,) = _getSettingVariables();
2925 		(, bytes32 _stakedContentId,,,,,,,,) = _aoPurchaseReceipt.getById(_purchaseReceiptId);
2926 		(,,uint256 _networkAmount, uint256 _primordialAmount, uint256 _primordialWeightedMultiplier,,,) = _aoStakedContent.getById(_stakedContentId);
2927 
2928 		uint256 _networkBonus = _networkAmount.mul(inflationRate).div(AOLibrary.PERCENTAGE_DIVISOR());
2929 		uint256 _primordialBonus = _primordialAmount.mul(_primordialWeightedMultiplier).div(AOLibrary.MULTIPLIER_DIVISOR()).mul(inflationRate).div(AOLibrary.PERCENTAGE_DIVISOR());
2930 		return _networkBonus.add(_primordialBonus);
2931 	}
2932 
2933 	/**
2934 	 * @dev Release the escrowed earning for a specific PurchaseReceipt ID for an account
2935 	 * @param _stakedContentId The ID of the staked content
2936 	 * @param _contentHostId The ID of the hosted content
2937 	 * @param _purchaseReceiptId The purchase receipt ID
2938 	 * @param _buyerPaidMoreThanFileSize Whether or not the request node paid more than filesize when buying the content
2939 	 * @param _account The address of account that made the earning (content creator/host)
2940 	 * @param _recipientType The type of the earning recipient (0 => content creator. 1 => host. 2 => theAO)
2941 	 */
2942 	function _releaseEarning(bytes32 _stakedContentId, bytes32 _contentHostId, bytes32 _purchaseReceiptId, bool _buyerPaidMoreThanFileSize, address _account, uint8 _recipientType) internal {
2943 		// Make sure the recipient type is valid
2944 		require (_recipientType >= 0 && _recipientType <= 2);
2945 
2946 		uint256 _paymentEarning;
2947 		uint256 _inflationBonus;
2948 		uint256 _totalEarning;
2949 		uint256 _pathosAmount;
2950 		uint256 _ethosAmount;
2951 		if (_recipientType == 0) {
2952 			Earning storage _earning = ownerPurchaseReceiptStakeEarnings[_account][_purchaseReceiptId];
2953 			_paymentEarning = _earning.paymentEarning;
2954 			_inflationBonus = _earning.inflationBonus;
2955 			_pathosAmount = _earning.pathosAmount;
2956 			_earning.paymentEarning = 0;
2957 			_earning.inflationBonus = 0;
2958 			_earning.pathosAmount = 0;
2959 			_earning.ethosAmount = 0;
2960 			_totalEarning = _paymentEarning.add(_inflationBonus);
2961 
2962 			// Update the global var settings
2963 			totalStakedContentEarning = totalStakedContentEarning.add(_totalEarning);
2964 			ownerStakedContentEarning[_account] = ownerStakedContentEarning[_account].add(_totalEarning);
2965 			stakedContentStakeEarning[_stakedContentId] = stakedContentStakeEarning[_stakedContentId].add(_totalEarning);
2966 			if (_buyerPaidMoreThanFileSize) {
2967 				ownerContentPriceEarning[_account] = ownerContentPriceEarning[_account].add(_totalEarning);
2968 			} else {
2969 				ownerNetworkPriceEarning[_account] = ownerNetworkPriceEarning[_account].add(_totalEarning);
2970 			}
2971 			ownerInflationBonusAccrued[_account] = ownerInflationBonusAccrued[_account].add(_inflationBonus);
2972 
2973 			// Reward the content creator/stake owner with some Pathos
2974 			require (_pathos.mint(_account, _pathosAmount));
2975 			emit PathosEarned(_account, _purchaseReceiptId, _pathosAmount);
2976 			require (_aoIon.unescrowFrom(_namePublicKey.getDefaultKey(_account), _totalEarning));
2977 		} else if (_recipientType == 1) {
2978 			Earning storage _earning = ownerPurchaseReceiptHostEarnings[_account][_purchaseReceiptId];
2979 			_paymentEarning = _earning.paymentEarning;
2980 			_inflationBonus = _earning.inflationBonus;
2981 			_ethosAmount = _earning.ethosAmount;
2982 			_earning.paymentEarning = 0;
2983 			_earning.inflationBonus = 0;
2984 			_earning.pathosAmount = 0;
2985 			_earning.ethosAmount = 0;
2986 			_totalEarning = _paymentEarning.add(_inflationBonus);
2987 
2988 			// Update the global var settings
2989 			totalContentHostEarning = totalContentHostEarning.add(_totalEarning);
2990 			ownerContentHostEarning[_account] = ownerContentHostEarning[_account].add(_totalEarning);
2991 			stakedContentHostEarning[_stakedContentId] = stakedContentHostEarning[_stakedContentId].add(_totalEarning);
2992 			contentHostEarning[_contentHostId] = contentHostEarning[_contentHostId].add(_totalEarning);
2993 			if (_buyerPaidMoreThanFileSize) {
2994 				ownerContentPriceEarning[_account] = ownerContentPriceEarning[_account].add(_totalEarning);
2995 			} else {
2996 				ownerNetworkPriceEarning[_account] = ownerNetworkPriceEarning[_account].add(_totalEarning);
2997 			}
2998 			ownerInflationBonusAccrued[_account] = ownerInflationBonusAccrued[_account].add(_inflationBonus);
2999 
3000 			// Reward the host node with some Ethos
3001 			require (_ethos.mint(_account, _ethosAmount));
3002 			emit EthosEarned(_account, _purchaseReceiptId, _ethosAmount);
3003 			require (_aoIon.unescrowFrom(_namePublicKey.getDefaultKey(_account), _totalEarning));
3004 		} else {
3005 			Earning storage _earning = theAOPurchaseReceiptEarnings[_purchaseReceiptId];
3006 			_paymentEarning = _earning.paymentEarning;
3007 			_inflationBonus = _earning.inflationBonus;
3008 			_earning.paymentEarning = 0;
3009 			_earning.inflationBonus = 0;
3010 			_earning.pathosAmount = 0;
3011 			_earning.ethosAmount = 0;
3012 			_totalEarning = _paymentEarning.add(_inflationBonus);
3013 
3014 			// Update the global var settings
3015 			totalTheAOEarning = totalTheAOEarning.add(_totalEarning);
3016 			ownerInflationBonusAccrued[_account] = ownerInflationBonusAccrued[_account].add(_inflationBonus);
3017 			stakedContentTheAOEarning[_stakedContentId] = stakedContentTheAOEarning[_stakedContentId].add(_totalEarning);
3018 			require (_aoIon.unescrowFrom(_account, _totalEarning));
3019 		}
3020 		emit EarningUnescrowed(_account, _purchaseReceiptId, _paymentEarning, _inflationBonus, _recipientType);
3021 	}
3022 
3023 	/**
3024 	 * @dev Get setting variables
3025 	 * @return inflationRate The rate to use when calculating inflation bonus
3026 	 * @return theAOCut The rate to use when calculating the AO earning
3027 	 * @return theAOEthosEarnedRate The rate to use when calculating the Ethos to AO rate for the AO
3028 	 */
3029 	function _getSettingVariables() internal view returns (uint256, uint256, uint256) {
3030 		(uint256 inflationRate,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'inflationRate');
3031 		(uint256 theAOCut,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'theAOCut');
3032 		(uint256 theAOEthosEarnedRate,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'theAOEthosEarnedRate');
3033 
3034 		return (inflationRate, theAOCut, theAOEthosEarnedRate);
3035 	}
3036 }