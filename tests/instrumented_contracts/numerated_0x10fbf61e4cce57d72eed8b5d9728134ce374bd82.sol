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
100 
101 
102 
103 
104 /**
105  * @title TAOCurrency
106  */
107 contract TAOCurrency is TheAO {
108 	using SafeMath for uint256;
109 
110 	// Public variables of the contract
111 	string public name;
112 	string public symbol;
113 	uint8 public decimals;
114 
115 	// To differentiate denomination of TAO Currency
116 	uint256 public powerOfTen;
117 
118 	uint256 public totalSupply;
119 
120 	// This creates an array with all balances
121 	// address is the address of nameId, not the eth public address
122 	mapping (address => uint256) public balanceOf;
123 
124 	// This generates a public event on the blockchain that will notify clients
125 	// address is the address of TAO/Name Id, not eth public address
126 	event Transfer(address indexed from, address indexed to, uint256 value);
127 
128 	// This notifies clients about the amount burnt
129 	// address is the address of TAO/Name Id, not eth public address
130 	event Burn(address indexed from, uint256 value);
131 
132 	/**
133 	 * Constructor function
134 	 *
135 	 * Initializes contract with initial supply TAOCurrency to the creator of the contract
136 	 */
137 	constructor (string memory _name, string memory _symbol, address _nameTAOPositionAddress) public {
138 		name = _name;		// Set the name for display purposes
139 		symbol = _symbol;	// Set the symbol for display purposes
140 
141 		powerOfTen = 0;
142 		decimals = 0;
143 
144 		setNameTAOPositionAddress(_nameTAOPositionAddress);
145 	}
146 
147 	/**
148 	 * @dev Checks if the calling contract address is The AO
149 	 *		OR
150 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
151 	 */
152 	modifier onlyTheAO {
153 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
154 		_;
155 	}
156 
157 	/**
158 	 * @dev Check if `_id` is a Name or a TAO
159 	 */
160 	modifier isNameOrTAO(address _id) {
161 		require (AOLibrary.isName(_id) || AOLibrary.isTAO(_id));
162 		_;
163 	}
164 
165 	/***** The AO ONLY METHODS *****/
166 	/**
167 	 * @dev Transfer ownership of The AO to new address
168 	 * @param _theAO The new address to be transferred
169 	 */
170 	function transferOwnership(address _theAO) public onlyTheAO {
171 		require (_theAO != address(0));
172 		theAO = _theAO;
173 	}
174 
175 	/**
176 	 * @dev Whitelist `_account` address to transact on behalf of others
177 	 * @param _account The address to whitelist
178 	 * @param _whitelist Either to whitelist or not
179 	 */
180 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
181 		require (_account != address(0));
182 		whitelist[_account] = _whitelist;
183 	}
184 
185 	/**
186 	 * @dev The AO set the NameTAOPosition Address
187 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
188 	 */
189 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
190 		require (_nameTAOPositionAddress != address(0));
191 		nameTAOPositionAddress = _nameTAOPositionAddress;
192 	}
193 
194 	/***** PUBLIC METHODS *****/
195 	/**
196 	 * @dev transfer TAOCurrency from other address
197 	 *
198 	 * Send `_value` TAOCurrency to `_to` in behalf of `_from`
199 	 *
200 	 * @param _from The address of the sender
201 	 * @param _to The address of the recipient
202 	 * @param _value the amount to send
203 	 */
204 	function transferFrom(address _from, address _to, uint256 _value) public inWhitelist isNameOrTAO(_from) isNameOrTAO(_to) returns (bool) {
205 		_transfer(_from, _to, _value);
206 		return true;
207 	}
208 
209 	/**
210 	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
211 	 * @param target Address to receive TAOCurrency
212 	 * @param mintedAmount The amount of TAOCurrency it will receive
213 	 * @return true on success
214 	 */
215 	function mint(address target, uint256 mintedAmount) public inWhitelist isNameOrTAO(target) returns (bool) {
216 		_mint(target, mintedAmount);
217 		return true;
218 	}
219 
220 	/**
221 	 *
222 	 * @dev Whitelisted address remove `_value` TAOCurrency from the system irreversibly on behalf of `_from`.
223 	 *
224 	 * @param _from the address of the sender
225 	 * @param _value the amount of money to burn
226 	 */
227 	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist isNameOrTAO(_from) returns (bool success) {
228 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
229 		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
230 		totalSupply = totalSupply.sub(_value);              // Update totalSupply
231 		emit Burn(_from, _value);
232 		return true;
233 	}
234 
235 	/***** INTERNAL METHODS *****/
236 	/**
237 	 * @dev Send `_value` TAOCurrency from `_from` to `_to`
238 	 * @param _from The address of sender
239 	 * @param _to The address of the recipient
240 	 * @param _value The amount to send
241 	 */
242 	function _transfer(address _from, address _to, uint256 _value) internal {
243 		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
244 		require (balanceOf[_from] >= _value);					// Check if the sender has enough
245 		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
246 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
247 		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
248 		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
249 		emit Transfer(_from, _to, _value);
250 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
251 	}
252 
253 	/**
254 	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
255 	 * @param target Address to receive TAOCurrency
256 	 * @param mintedAmount The amount of TAOCurrency it will receive
257 	 */
258 	function _mint(address target, uint256 mintedAmount) internal {
259 		balanceOf[target] = balanceOf[target].add(mintedAmount);
260 		totalSupply = totalSupply.add(mintedAmount);
261 		emit Transfer(address(0), address(this), mintedAmount);
262 		emit Transfer(address(this), target, mintedAmount);
263 	}
264 }
265 
266 
267 interface INameTAOPosition {
268 	function senderIsAdvocate(address _sender, address _id) external view returns (bool);
269 	function senderIsListener(address _sender, address _id) external view returns (bool);
270 	function senderIsSpeaker(address _sender, address _id) external view returns (bool);
271 	function senderIsPosition(address _sender, address _id) external view returns (bool);
272 	function getAdvocate(address _id) external view returns (address);
273 	function nameIsAdvocate(address _nameId, address _id) external view returns (bool);
274 	function nameIsPosition(address _nameId, address _id) external view returns (bool);
275 	function initialize(address _id, address _advocateId, address _listenerId, address _speakerId) external returns (bool);
276 	function determinePosition(address _sender, address _id) external view returns (uint256);
277 }
278 
279 
280 
281 interface IAOSetting {
282 	function getSettingValuesByTAOName(address _taoId, string calldata _settingName) external view returns (uint256, bool, address, bytes32, string memory);
283 	function getSettingTypes() external view returns (uint8, uint8, uint8, uint8, uint8);
284 
285 	function settingTypeLookup(uint256 _settingId) external view returns (uint8);
286 }
287 
288 
289 interface INameAccountRecovery {
290 	function isCompromised(address _id) external view returns (bool);
291 }
292 
293 
294 interface INamePublicKey {
295 	function initialize(address _id, address _defaultKey, address _writerKey) external returns (bool);
296 
297 	function isKeyExist(address _id, address _key) external view returns (bool);
298 
299 	function getDefaultKey(address _id) external view returns (address);
300 
301 	function whitelistAddKey(address _id, address _key) external returns (bool);
302 }
303 
304 
305 interface INameTAOLookup {
306 	function isExist(string calldata _name) external view returns (bool);
307 
308 	function initialize(string calldata _name, address _nameTAOId, uint256 _typeId, string calldata _parentName, address _parentId, uint256 _parentTypeId) external returns (bool);
309 
310 	function getById(address _id) external view returns (string memory, address, uint256, string memory, address, uint256);
311 
312 	function getIdByName(string calldata _name) external view returns (address);
313 }
314 
315 
316 interface INameFactory {
317 	function nonces(address _nameId) external view returns (uint256);
318 	function incrementNonce(address _nameId) external returns (uint256);
319 	function ethAddressToNameId(address _ethAddress) external view returns (address);
320 	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
321 	function nameIdToEthAddress(address _nameId) external view returns (address);
322 }
323 
324 
325 
326 
327 
328 
329 
330 
331 
332 
333 
334 
335 
336 contract TokenERC20 {
337 	// Public variables of the token
338 	string public name;
339 	string public symbol;
340 	uint8 public decimals = 18;
341 	// 18 decimals is the strongly suggested default, avoid changing it
342 	uint256 public totalSupply;
343 
344 	// This creates an array with all balances
345 	mapping (address => uint256) public balanceOf;
346 	mapping (address => mapping (address => uint256)) public allowance;
347 
348 	// This generates a public event on the blockchain that will notify clients
349 	event Transfer(address indexed from, address indexed to, uint256 value);
350 
351 	// This generates a public event on the blockchain that will notify clients
352 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
353 
354 	// This notifies clients about the amount burnt
355 	event Burn(address indexed from, uint256 value);
356 
357 	/**
358 	 * Constructor function
359 	 *
360 	 * Initializes contract with initial supply tokens to the creator of the contract
361 	 */
362 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
363 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
364 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
365 		name = tokenName;                                   // Set the name for display purposes
366 		symbol = tokenSymbol;                               // Set the symbol for display purposes
367 	}
368 
369 	/**
370 	 * Internal transfer, only can be called by this contract
371 	 */
372 	function _transfer(address _from, address _to, uint _value) internal {
373 		// Prevent transfer to 0x0 address. Use burn() instead
374 		require(_to != address(0));
375 		// Check if the sender has enough
376 		require(balanceOf[_from] >= _value);
377 		// Check for overflows
378 		require(balanceOf[_to] + _value > balanceOf[_to]);
379 		// Save this for an assertion in the future
380 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
381 		// Subtract from the sender
382 		balanceOf[_from] -= _value;
383 		// Add the same to the recipient
384 		balanceOf[_to] += _value;
385 		emit Transfer(_from, _to, _value);
386 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
387 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
388 	}
389 
390 	/**
391 	 * Transfer tokens
392 	 *
393 	 * Send `_value` tokens to `_to` from your account
394 	 *
395 	 * @param _to The address of the recipient
396 	 * @param _value the amount to send
397 	 */
398 	function transfer(address _to, uint256 _value) public returns (bool success) {
399 		_transfer(msg.sender, _to, _value);
400 		return true;
401 	}
402 
403 	/**
404 	 * Transfer tokens from other address
405 	 *
406 	 * Send `_value` tokens to `_to` in behalf of `_from`
407 	 *
408 	 * @param _from The address of the sender
409 	 * @param _to The address of the recipient
410 	 * @param _value the amount to send
411 	 */
412 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
413 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
414 		allowance[_from][msg.sender] -= _value;
415 		_transfer(_from, _to, _value);
416 		return true;
417 	}
418 
419 	/**
420 	 * Set allowance for other address
421 	 *
422 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
423 	 *
424 	 * @param _spender The address authorized to spend
425 	 * @param _value the max amount they can spend
426 	 */
427 	function approve(address _spender, uint256 _value) public returns (bool success) {
428 		allowance[msg.sender][_spender] = _value;
429 		emit Approval(msg.sender, _spender, _value);
430 		return true;
431 	}
432 
433 	/**
434 	 * Set allowance for other address and notify
435 	 *
436 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
437 	 *
438 	 * @param _spender The address authorized to spend
439 	 * @param _value the max amount they can spend
440 	 * @param _extraData some extra information to send to the approved contract
441 	 */
442 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
443 		tokenRecipient spender = tokenRecipient(_spender);
444 		if (approve(_spender, _value)) {
445 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
446 			return true;
447 		}
448 	}
449 
450 	/**
451 	 * Destroy tokens
452 	 *
453 	 * Remove `_value` tokens from the system irreversibly
454 	 *
455 	 * @param _value the amount of money to burn
456 	 */
457 	function burn(uint256 _value) public returns (bool success) {
458 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
459 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
460 		totalSupply -= _value;                      // Updates totalSupply
461 		emit Burn(msg.sender, _value);
462 		return true;
463 	}
464 
465 	/**
466 	 * Destroy tokens from other account
467 	 *
468 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
469 	 *
470 	 * @param _from the address of the sender
471 	 * @param _value the amount of money to burn
472 	 */
473 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
474 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
475 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
476 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
477 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
478 		totalSupply -= _value;                              // Update totalSupply
479 		emit Burn(_from, _value);
480 		return true;
481 	}
482 }
483 
484 
485 /**
486  * @title TAO
487  */
488 contract TAO {
489 	using SafeMath for uint256;
490 
491 	address public vaultAddress;
492 	string public name;				// the name for this TAO
493 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
494 
495 	// TAO's data
496 	string public datHash;
497 	string public database;
498 	string public keyValue;
499 	bytes32 public contentId;
500 
501 	/**
502 	 * 0 = TAO
503 	 * 1 = Name
504 	 */
505 	uint8 public typeId;
506 
507 	/**
508 	 * @dev Constructor function
509 	 */
510 	constructor (string memory _name,
511 		address _originId,
512 		string memory _datHash,
513 		string memory _database,
514 		string memory _keyValue,
515 		bytes32 _contentId,
516 		address _vaultAddress
517 	) public {
518 		name = _name;
519 		originId = _originId;
520 		datHash = _datHash;
521 		database = _database;
522 		keyValue = _keyValue;
523 		contentId = _contentId;
524 
525 		// Creating TAO
526 		typeId = 0;
527 
528 		vaultAddress = _vaultAddress;
529 	}
530 
531 	/**
532 	 * @dev Checks if calling address is Vault contract
533 	 */
534 	modifier onlyVault {
535 		require (msg.sender == vaultAddress);
536 		_;
537 	}
538 
539 	/**
540 	 * Will receive any ETH sent
541 	 */
542 	function () external payable {
543 	}
544 
545 	/**
546 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
547 	 * @param _recipient The recipient address
548 	 * @param _amount The amount to transfer
549 	 * @return true on success
550 	 */
551 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
552 		_recipient.transfer(_amount);
553 		return true;
554 	}
555 
556 	/**
557 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
558 	 * @param _erc20TokenAddress The address of ERC20 Token
559 	 * @param _recipient The recipient address
560 	 * @param _amount The amount to transfer
561 	 * @return true on success
562 	 */
563 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
564 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
565 		_erc20.transfer(_recipient, _amount);
566 		return true;
567 	}
568 }
569 
570 
571 /**
572  * @title Name
573  */
574 contract Name is TAO {
575 	/**
576 	 * @dev Constructor function
577 	 */
578 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
579 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
580 		// Creating Name
581 		typeId = 1;
582 	}
583 }
584 
585 
586 /**
587  * @title AOLibrary
588  */
589 library AOLibrary {
590 	using SafeMath for uint256;
591 
592 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
593 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
594 
595 	/**
596 	 * @dev Check whether or not the given TAO ID is a TAO
597 	 * @param _taoId The ID of the TAO
598 	 * @return true if yes. false otherwise
599 	 */
600 	function isTAO(address _taoId) public view returns (bool) {
601 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
602 	}
603 
604 	/**
605 	 * @dev Check whether or not the given Name ID is a Name
606 	 * @param _nameId The ID of the Name
607 	 * @return true if yes. false otherwise
608 	 */
609 	function isName(address _nameId) public view returns (bool) {
610 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
611 	}
612 
613 	/**
614 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
615 	 * @param _tokenAddress The ERC20 Token address to check
616 	 */
617 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
618 		if (_tokenAddress == address(0)) {
619 			return false;
620 		}
621 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
622 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
623 	}
624 
625 	/**
626 	 * @dev Checks if the calling contract address is The AO
627 	 *		OR
628 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
629 	 * @param _sender The address to check
630 	 * @param _theAO The AO address
631 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
632 	 * @return true if yes, false otherwise
633 	 */
634 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
635 		return (_sender == _theAO ||
636 			(
637 				(isTAO(_theAO) || isName(_theAO)) &&
638 				_nameTAOPositionAddress != address(0) &&
639 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
640 			)
641 		);
642 	}
643 
644 	/**
645 	 * @dev Return the divisor used to correctly calculate percentage.
646 	 *		Percentage stored throughout AO contracts covers 4 decimals,
647 	 *		so 1% is 10000, 1.25% is 12500, etc
648 	 */
649 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
650 		return _PERCENTAGE_DIVISOR;
651 	}
652 
653 	/**
654 	 * @dev Return the divisor used to correctly calculate multiplier.
655 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
656 	 *		so 1 is 1000000, 0.023 is 23000, etc
657 	 */
658 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
659 		return _MULTIPLIER_DIVISOR;
660 	}
661 
662 	/**
663 	 * @dev deploy a TAO
664 	 * @param _name The name of the TAO
665 	 * @param _originId The Name ID the creates the TAO
666 	 * @param _datHash The datHash of this TAO
667 	 * @param _database The database for this TAO
668 	 * @param _keyValue The key/value pair to be checked on the database
669 	 * @param _contentId The contentId related to this TAO
670 	 * @param _nameTAOVaultAddress The address of NameTAOVault
671 	 */
672 	function deployTAO(string memory _name,
673 		address _originId,
674 		string memory _datHash,
675 		string memory _database,
676 		string memory _keyValue,
677 		bytes32 _contentId,
678 		address _nameTAOVaultAddress
679 		) public returns (TAO _tao) {
680 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
681 	}
682 
683 	/**
684 	 * @dev deploy a Name
685 	 * @param _name The name of the Name
686 	 * @param _originId The eth address the creates the Name
687 	 * @param _datHash The datHash of this Name
688 	 * @param _database The database for this Name
689 	 * @param _keyValue The key/value pair to be checked on the database
690 	 * @param _contentId The contentId related to this Name
691 	 * @param _nameTAOVaultAddress The address of NameTAOVault
692 	 */
693 	function deployName(string memory _name,
694 		address _originId,
695 		string memory _datHash,
696 		string memory _database,
697 		string memory _keyValue,
698 		bytes32 _contentId,
699 		address _nameTAOVaultAddress
700 		) public returns (Name _myName) {
701 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
702 	}
703 
704 	/**
705 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
706 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
707 	 * @param _currentPrimordialBalance Account's current primordial ion balance
708 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
709 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
710 	 * @return the new primordial weighted multiplier
711 	 */
712 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
713 		if (_currentWeightedMultiplier > 0) {
714 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
715 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
716 			return _totalWeightedIons.div(_totalIons);
717 		} else {
718 			return _additionalWeightedMultiplier;
719 		}
720 	}
721 
722 	/**
723 	 * @dev Calculate the primordial ion multiplier on a given lot
724 	 *		Total Primordial Mintable = T
725 	 *		Total Primordial Minted = M
726 	 *		Starting Multiplier = S
727 	 *		Ending Multiplier = E
728 	 *		To Purchase = P
729 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
730 	 *
731 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
732 	 * @param _totalPrimordialMintable Total Primordial ion mintable
733 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
734 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
735 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
736 	 * @return The multiplier in (10 ** 6)
737 	 */
738 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
739 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
740 			/**
741 			 * Let temp = M + (P/2)
742 			 * Multiplier = (1 - (temp / T)) x (S-E)
743 			 */
744 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
745 
746 			/**
747 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
748 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
749 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
750 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
751 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
752 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
753 			 */
754 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
755 			/**
756 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
757 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
758 			 */
759 			return multiplier.div(_MULTIPLIER_DIVISOR);
760 		} else {
761 			return 0;
762 		}
763 	}
764 
765 	/**
766 	 * @dev Calculate the bonus percentage of network ion on a given lot
767 	 *		Total Primordial Mintable = T
768 	 *		Total Primordial Minted = M
769 	 *		Starting Network Bonus Multiplier = Bs
770 	 *		Ending Network Bonus Multiplier = Be
771 	 *		To Purchase = P
772 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
773 	 *
774 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
775 	 * @param _totalPrimordialMintable Total Primordial ion intable
776 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
777 	 * @param _startingMultiplier The starting Network ion bonus multiplier
778 	 * @param _endingMultiplier The ending Network ion bonus multiplier
779 	 * @return The bonus percentage
780 	 */
781 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
782 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
783 			/**
784 			 * Let temp = M + (P/2)
785 			 * B% = (1 - (temp / T)) x (Bs-Be)
786 			 */
787 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
788 
789 			/**
790 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
791 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
792 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
793 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
794 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
795 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
796 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
797 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
798 			 */
799 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
800 			return bonusPercentage;
801 		} else {
802 			return 0;
803 		}
804 	}
805 
806 	/**
807 	 * @dev Calculate the bonus amount of network ion on a given lot
808 	 *		AO Bonus Amount = B% x P
809 	 *
810 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
811 	 * @param _totalPrimordialMintable Total Primordial ion intable
812 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
813 	 * @param _startingMultiplier The starting Network ion bonus multiplier
814 	 * @param _endingMultiplier The ending Network ion bonus multiplier
815 	 * @return The bonus percentage
816 	 */
817 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
818 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
819 		/**
820 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
821 		 * when calculating the network ion bonus amount
822 		 */
823 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
824 		return networkBonus;
825 	}
826 
827 	/**
828 	 * @dev Calculate the maximum amount of Primordial an account can burn
829 	 *		_primordialBalance = P
830 	 *		_currentWeightedMultiplier = M
831 	 *		_maximumMultiplier = S
832 	 *		_amountToBurn = B
833 	 *		B = ((S x P) - (P x M)) / S
834 	 *
835 	 * @param _primordialBalance Account's primordial ion balance
836 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
837 	 * @param _maximumMultiplier The maximum multiplier of this account
838 	 * @return The maximum burn amount
839 	 */
840 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
841 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
842 	}
843 
844 	/**
845 	 * @dev Calculate the new multiplier after burning primordial ion
846 	 *		_primordialBalance = P
847 	 *		_currentWeightedMultiplier = M
848 	 *		_amountToBurn = B
849 	 *		_newMultiplier = E
850 	 *		E = (P x M) / (P - B)
851 	 *
852 	 * @param _primordialBalance Account's primordial ion balance
853 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
854 	 * @param _amountToBurn The amount of primordial ion to burn
855 	 * @return The new multiplier
856 	 */
857 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
858 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
859 	}
860 
861 	/**
862 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
863 	 *		_primordialBalance = P
864 	 *		_currentWeightedMultiplier = M
865 	 *		_amountToConvert = C
866 	 *		_newMultiplier = E
867 	 *		E = (P x M) / (P + C)
868 	 *
869 	 * @param _primordialBalance Account's primordial ion balance
870 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
871 	 * @param _amountToConvert The amount of network ion to convert
872 	 * @return The new multiplier
873 	 */
874 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
875 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
876 	}
877 
878 	/**
879 	 * @dev count num of digits
880 	 * @param number uint256 of the nuumber to be checked
881 	 * @return uint8 num of digits
882 	 */
883 	function numDigits(uint256 number) public pure returns (uint8) {
884 		uint8 digits = 0;
885 		while(number != 0) {
886 			number = number.div(10);
887 			digits++;
888 		}
889 		return digits;
890 	}
891 }
892 
893 
894 
895 
896 
897 
898 
899 
900 
901 
902 /**
903  * @title Voice
904  */
905 contract Voice is TheAO {
906 	using SafeMath for uint256;
907 
908 	// Public variables of the contract
909 	string public name;
910 	string public symbol;
911 	uint8 public decimals = 4;
912 
913 	uint256 constant public MAX_SUPPLY_PER_NAME = 100 * (10 ** 4);
914 
915 	uint256 public totalSupply;
916 
917 	// Mapping from Name ID to bool value whether or not it has received Voice
918 	mapping (address => bool) public hasReceived;
919 
920 	// Mapping from Name/TAO ID to its total available balance
921 	mapping (address => uint256) public balanceOf;
922 
923 	// Mapping from Name ID to TAO ID and its staked amount
924 	mapping (address => mapping(address => uint256)) public taoStakedBalance;
925 
926 	// This generates a public event on the blockchain that will notify clients
927 	event Mint(address indexed nameId, uint256 value);
928 	event Stake(address indexed nameId, address indexed taoId, uint256 value);
929 	event Unstake(address indexed nameId, address indexed taoId, uint256 value);
930 
931 	/**
932 	 * Constructor function
933 	 */
934 	constructor (string memory _name, string memory _symbol) public {
935 		name = _name;						// Set the name for display purposes
936 		symbol = _symbol;					// Set the symbol for display purposes
937 	}
938 
939 	/**
940 	 * @dev Checks if the calling contract address is The AO
941 	 *		OR
942 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
943 	 */
944 	modifier onlyTheAO {
945 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
946 		_;
947 	}
948 
949 	/**
950 	 * @dev Check if `_taoId` is a TAO
951 	 */
952 	modifier isTAO(address _taoId) {
953 		require (AOLibrary.isTAO(_taoId));
954 		_;
955 	}
956 
957 	/**
958 	 * @dev Check if `_nameId` is a Name
959 	 */
960 	modifier isName(address _nameId) {
961 		require (AOLibrary.isName(_nameId));
962 		_;
963 	}
964 
965 	/***** The AO ONLY METHODS *****/
966 	/**
967 	 * @dev Transfer ownership of The AO to new address
968 	 * @param _theAO The new address to be transferred
969 	 */
970 	function transferOwnership(address _theAO) public onlyTheAO {
971 		require (_theAO != address(0));
972 		theAO = _theAO;
973 	}
974 
975 	/**
976 	 * @dev Whitelist `_account` address to transact on behalf of others
977 	 * @param _account The address to whitelist
978 	 * @param _whitelist Either to whitelist or not
979 	 */
980 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
981 		require (_account != address(0));
982 		whitelist[_account] = _whitelist;
983 	}
984 
985 	/**
986 	 * @dev The AO set the NameTAOPosition Address
987 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
988 	 */
989 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
990 		require (_nameTAOPositionAddress != address(0));
991 		nameTAOPositionAddress = _nameTAOPositionAddress;
992 	}
993 
994 	/***** PUBLIC METHODS *****/
995 	/**
996 	 * @dev Create `MAX_SUPPLY_PER_NAME` Voice and send it to `_nameId`
997 	 * @param _nameId Address to receive Voice
998 	 * @return true on success
999 	 */
1000 	function mint(address _nameId) public inWhitelist isName(_nameId) returns (bool) {
1001 		// Make sure _nameId has not received Voice
1002 		require (hasReceived[_nameId] == false);
1003 
1004 		hasReceived[_nameId] = true;
1005 		balanceOf[_nameId] = balanceOf[_nameId].add(MAX_SUPPLY_PER_NAME);
1006 		totalSupply = totalSupply.add(MAX_SUPPLY_PER_NAME);
1007 		emit Mint(_nameId, MAX_SUPPLY_PER_NAME);
1008 		return true;
1009 	}
1010 
1011 	/**
1012 	 * @dev Get staked balance of `_nameId`
1013 	 * @param _nameId The Name ID to be queried
1014 	 * @return total staked balance
1015 	 */
1016 	function stakedBalance(address _nameId) public isName(_nameId) view returns (uint256) {
1017 		return MAX_SUPPLY_PER_NAME.sub(balanceOf[_nameId]);
1018 	}
1019 
1020 	/**
1021 	 * @dev Stake `_value` Voice on `_taoId` from `_nameId`
1022 	 * @param _nameId The Name ID that wants to stake
1023 	 * @param _taoId The TAO ID to stake
1024 	 * @param _value The amount to stake
1025 	 * @return true on success
1026 	 */
1027 	function stake(address _nameId, address _taoId, uint256 _value) public inWhitelist isName(_nameId) isTAO(_taoId) returns (bool) {
1028 		require (_value > 0 && _value <= MAX_SUPPLY_PER_NAME);
1029 		require (balanceOf[_nameId] >= _value);							// Check if the targeted balance is enough
1030 		balanceOf[_nameId] = balanceOf[_nameId].sub(_value);			// Subtract from the targeted balance
1031 		taoStakedBalance[_nameId][_taoId] = taoStakedBalance[_nameId][_taoId].add(_value);	// Add to the targeted staked balance
1032 		balanceOf[_taoId] = balanceOf[_taoId].add(_value);
1033 		emit Stake(_nameId, _taoId, _value);
1034 		return true;
1035 	}
1036 
1037 	/**
1038 	 * @dev Unstake `_value` Voice from `_nameId`'s `_taoId`
1039 	 * @param _nameId The Name ID that wants to unstake
1040 	 * @param _taoId The TAO ID to unstake
1041 	 * @param _value The amount to unstake
1042 	 * @return true on success
1043 	 */
1044 	function unstake(address _nameId, address _taoId, uint256 _value) public inWhitelist isName(_nameId) isTAO(_taoId) returns (bool) {
1045 		require (_value > 0 && _value <= MAX_SUPPLY_PER_NAME);
1046 		require (taoStakedBalance[_nameId][_taoId] >= _value);	// Check if the targeted staked balance is enough
1047 		require (balanceOf[_taoId] >= _value);	// Check if the total targeted staked balance is enough
1048 		taoStakedBalance[_nameId][_taoId] = taoStakedBalance[_nameId][_taoId].sub(_value);	// Subtract from the targeted staked balance
1049 		balanceOf[_taoId] = balanceOf[_taoId].sub(_value);
1050 		balanceOf[_nameId] = balanceOf[_nameId].add(_value);			// Add to the targeted balance
1051 		emit Unstake(_nameId, _taoId, _value);
1052 		return true;
1053 	}
1054 }
1055 
1056 
1057 
1058 
1059 
1060 
1061 
1062 
1063 
1064 
1065 contract Pathos is TAOCurrency {
1066 	/**
1067 	 * @dev Constructor function
1068 	 */
1069 	constructor(string memory _name, string memory _symbol, address _nameTAOPositionAddress)
1070 		TAOCurrency(_name, _symbol, _nameTAOPositionAddress) public {}
1071 }
1072 
1073 
1074 
1075 
1076 
1077 contract Ethos is TAOCurrency {
1078 	/**
1079 	 * @dev Constructor function
1080 	 */
1081 	constructor(string memory _name, string memory _symbol, address _nameTAOPositionAddress)
1082 		TAOCurrency(_name, _symbol, _nameTAOPositionAddress) public {}
1083 }
1084 
1085 
1086 /**
1087  * @title NameFactory
1088  *
1089  * The purpose of this contract is to allow node to create Name
1090  */
1091 contract NameFactory is TheAO, INameFactory {
1092 	using SafeMath for uint256;
1093 
1094 	address public voiceAddress;
1095 	address public nameTAOVaultAddress;
1096 	address public nameTAOLookupAddress;
1097 	address public namePublicKeyAddress;
1098 	address public nameAccountRecoveryAddress;
1099 	address public settingTAOId;
1100 	address public aoSettingAddress;
1101 	address public pathosAddress;
1102 	address public ethosAddress;
1103 
1104 	Voice internal _voice;
1105 	INameTAOLookup internal _nameTAOLookup;
1106 	INameTAOPosition internal _nameTAOPosition;
1107 	INamePublicKey internal _namePublicKey;
1108 	INameAccountRecovery internal _nameAccountRecovery;
1109 	IAOSetting internal _aoSetting;
1110 	Pathos internal _pathos;
1111 	Ethos internal _ethos;
1112 
1113 	address[] internal names;
1114 
1115 	// Mapping from eth address to Name ID
1116 	mapping (address => address) internal _ethAddressToNameId;
1117 
1118 	// Mapping from Name ID to eth address
1119 	mapping (address => address) internal _nameIdToEthAddress;
1120 
1121 	// Mapping from Name ID to its nonce
1122 	mapping (address => uint256) internal _nonces;
1123 
1124 	// Event to be broadcasted to public when a Name is created
1125 	event CreateName(address indexed ethAddress, address nameId, uint256 index, string name);
1126 
1127 	// Event to be broadcasted to public when Primordial contributor is rewarded
1128 	event RewardContributor(address indexed nameId, uint256 pathosAmount, uint256 ethosAmount);
1129 
1130 	/**
1131 	 * @dev Constructor function
1132 	 */
1133 	constructor(address _voiceAddress) public {
1134 		setVoiceAddress(_voiceAddress);
1135 	}
1136 
1137 	/**
1138 	 * @dev Checks if the calling contract address is The AO
1139 	 *		OR
1140 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
1141 	 */
1142 	modifier onlyTheAO {
1143 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
1144 		_;
1145 	}
1146 
1147 	/**
1148 	 * @dev Checks if calling address can update Name's nonce
1149 	 */
1150 	modifier canUpdateNonce {
1151 		require (msg.sender == nameTAOPositionAddress || msg.sender == namePublicKeyAddress || msg.sender == nameAccountRecoveryAddress);
1152 		_;
1153 	}
1154 
1155 	/***** The AO ONLY METHODS *****/
1156 	/**
1157 	 * @dev Transfer ownership of The AO to new address
1158 	 * @param _theAO The new address to be transferred
1159 	 */
1160 	function transferOwnership(address _theAO) public onlyTheAO {
1161 		require (_theAO != address(0));
1162 		theAO = _theAO;
1163 	}
1164 
1165 	/**
1166 	 * @dev Whitelist `_account` address to transact on behalf of others
1167 	 * @param _account The address to whitelist
1168 	 * @param _whitelist Either to whitelist or not
1169 	 */
1170 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
1171 		require (_account != address(0));
1172 		whitelist[_account] = _whitelist;
1173 	}
1174 
1175 	/**
1176 	 * @dev The AO set the Voice Address
1177 	 * @param _voiceAddress The address of Voice
1178 	 */
1179 	function setVoiceAddress(address _voiceAddress) public onlyTheAO {
1180 		require (_voiceAddress != address(0));
1181 		voiceAddress = _voiceAddress;
1182 		_voice = Voice(voiceAddress);
1183 	}
1184 
1185 	/**
1186 	 * @dev The AO set the NameTAOVault Address
1187 	 * @param _nameTAOVaultAddress The address of NameTAOVault
1188 	 */
1189 	function setNameTAOVaultAddress(address _nameTAOVaultAddress) public onlyTheAO {
1190 		require (_nameTAOVaultAddress != address(0));
1191 		nameTAOVaultAddress = _nameTAOVaultAddress;
1192 	}
1193 
1194 	/**
1195 	 * @dev The AO set the NameTAOLookup Address
1196 	 * @param _nameTAOLookupAddress The address of NameTAOLookup
1197 	 */
1198 	function setNameTAOLookupAddress(address _nameTAOLookupAddress) public onlyTheAO {
1199 		require (_nameTAOLookupAddress != address(0));
1200 		nameTAOLookupAddress = _nameTAOLookupAddress;
1201 		_nameTAOLookup = INameTAOLookup(nameTAOLookupAddress);
1202 	}
1203 
1204 	/**
1205 	 * @dev The AO set the NameTAOPosition Address
1206 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
1207 	 */
1208 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
1209 		require (_nameTAOPositionAddress != address(0));
1210 		nameTAOPositionAddress = _nameTAOPositionAddress;
1211 		_nameTAOPosition = INameTAOPosition(nameTAOPositionAddress);
1212 	}
1213 
1214 	/**
1215 	 * @dev The AO set the NamePublicKey Address
1216 	 * @param _namePublicKeyAddress The address of NamePublicKey
1217 	 */
1218 	function setNamePublicKeyAddress(address _namePublicKeyAddress) public onlyTheAO {
1219 		require (_namePublicKeyAddress != address(0));
1220 		namePublicKeyAddress = _namePublicKeyAddress;
1221 		_namePublicKey = INamePublicKey(namePublicKeyAddress);
1222 	}
1223 
1224 	/**
1225 	 * @dev The AO set the NameAccountRecovery Address
1226 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
1227 	 */
1228 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
1229 		require (_nameAccountRecoveryAddress != address(0));
1230 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
1231 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
1232 	}
1233 
1234 	/**
1235 	 * @dev The AO sets setting TAO ID
1236 	 * @param _settingTAOId The new setting TAO ID to set
1237 	 */
1238 	function setSettingTAOId(address _settingTAOId) public onlyTheAO {
1239 		require (AOLibrary.isTAO(_settingTAOId));
1240 		settingTAOId = _settingTAOId;
1241 	}
1242 
1243 	/**
1244 	 * @dev The AO sets AO Setting address
1245 	 * @param _aoSettingAddress The address of AOSetting
1246 	 */
1247 	function setAOSettingAddress(address _aoSettingAddress) public onlyTheAO {
1248 		require (_aoSettingAddress != address(0));
1249 		aoSettingAddress = _aoSettingAddress;
1250 		_aoSetting = IAOSetting(_aoSettingAddress);
1251 	}
1252 
1253 	/**
1254 	 * @dev The AO sets Pathos address
1255 	 * @param _pathosAddress The address of Pathos
1256 	 */
1257 	function setPathosAddress(address _pathosAddress) public onlyTheAO {
1258 		require (_pathosAddress != address(0));
1259 		pathosAddress = _pathosAddress;
1260 		_pathos = Pathos(_pathosAddress);
1261 	}
1262 
1263 	/**
1264 	 * @dev The AO sets Ethos address
1265 	 * @param _ethosAddress The address of Ethos
1266 	 */
1267 	function setEthosAddress(address _ethosAddress) public onlyTheAO {
1268 		require (_ethosAddress != address(0));
1269 		ethosAddress = _ethosAddress;
1270 		_ethos = Ethos(_ethosAddress);
1271 	}
1272 
1273 	/**
1274 	 * @dev NameAccountRecovery contract replaces eth address associated with a Name
1275 	 * @param _id The ID of the Name
1276 	 * @param _newAddress The new eth address
1277 	 * @return true on success
1278 	 */
1279 	function setNameNewAddress(address _id, address _newAddress) external returns (bool) {
1280 		require (msg.sender == nameAccountRecoveryAddress);
1281 		require (AOLibrary.isName(_id));
1282 		require (_newAddress != address(0));
1283 		require (_ethAddressToNameId[_newAddress] == address(0));
1284 		require (_nameIdToEthAddress[_id] != address(0));
1285 
1286 		address _currentEthAddress = _nameIdToEthAddress[_id];
1287 		_ethAddressToNameId[_currentEthAddress] = address(0);
1288 		_ethAddressToNameId[_newAddress] = _id;
1289 		_nameIdToEthAddress[_id] = _newAddress;
1290 		return true;
1291 	}
1292 
1293 	/***** PUBLIC METHODS *****/
1294 	/**
1295 	 * @dev Get the nonce given a Name ID
1296 	 * @param _nameId The Name ID to check
1297 	 * @return The nonce of the Name
1298 	 */
1299 	function nonces(address _nameId) external view returns (uint256) {
1300 		return _nonces[_nameId];
1301 	}
1302 
1303 	/**
1304 	 * @dev Increment the nonce of a Name
1305 	 * @param _nameId The ID of the Name
1306 	 * @return current nonce
1307 	 */
1308 	function incrementNonce(address _nameId) external canUpdateNonce returns (uint256) {
1309 		// Check if _nameId exist
1310 		require (_nonces[_nameId] > 0);
1311 		_nonces[_nameId]++;
1312 		return _nonces[_nameId];
1313 	}
1314 
1315 	/**
1316 	 * @dev Create a Name
1317 	 * @param _name The name of the Name
1318 	 * @param _datHash The datHash to this Name's profile
1319 	 * @param _database The database for this Name
1320 	 * @param _keyValue The key/value pair to be checked on the database
1321 	 * @param _contentId The contentId related to this Name
1322 	 * @param _writerKey The writer public key for this Name
1323 	 */
1324 	function createName(string memory _name, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _writerKey) public {
1325 		require (bytes(_name).length > 0);
1326 		require (!_nameTAOLookup.isExist(_name));
1327 
1328 		// Only one Name per ETH address
1329 		require (_ethAddressToNameId[msg.sender] == address(0));
1330 
1331 		// The address is the Name ID (which is also a TAO ID)
1332 		address nameId = address(AOLibrary.deployName(_name, msg.sender, _datHash, _database, _keyValue, _contentId, nameTAOVaultAddress));
1333 
1334 		// Only one ETH address per Name
1335 		require (_nameIdToEthAddress[nameId] == address(0));
1336 
1337 		// Increment the nonce
1338 		_nonces[nameId]++;
1339 
1340 		_ethAddressToNameId[msg.sender] = nameId;
1341 		_nameIdToEthAddress[nameId] = msg.sender;
1342 
1343 		// Store the name lookup information
1344 		require (_nameTAOLookup.initialize(_name, nameId, 1, 'human', msg.sender, 2));
1345 
1346 		// Store the Advocate/Listener/Speaker information
1347 		require (_nameTAOPosition.initialize(nameId, nameId, nameId, nameId));
1348 
1349 		// Store the public key information
1350 		require (_namePublicKey.initialize(nameId, msg.sender, _writerKey));
1351 
1352 		names.push(nameId);
1353 
1354 		// Need to mint Voice for this Name
1355 		require (_voice.mint(nameId));
1356 
1357 		// Reward primordial contributor Name with Pathos/Ethos
1358 		_rewardContributor(nameId);
1359 
1360 		emit CreateName(msg.sender, nameId, names.length.sub(1), _name);
1361 	}
1362 
1363 	/**
1364 	 * @dev Get the Name ID given an ETH address
1365 	 * @param _ethAddress The ETH address to check
1366 	 * @return The Name ID
1367 	 */
1368 	function ethAddressToNameId(address _ethAddress) external view returns (address) {
1369 		return _ethAddressToNameId[_ethAddress];
1370 	}
1371 
1372 	/**
1373 	 * @dev Get the ETH address given a Name ID
1374 	 * @param _nameId The Name ID to check
1375 	 * @return The ETH address
1376 	 */
1377 	function nameIdToEthAddress(address _nameId) external view returns (address) {
1378 		return _nameIdToEthAddress[_nameId];
1379 	}
1380 
1381 	/**
1382 	 * @dev Get Name information
1383 	 * @param _nameId The ID of the Name to be queried
1384 	 * @return The name of the Name
1385 	 * @return The originId of the Name (in this case, it's the creator node's ETH address)
1386 	 * @return The datHash of the Name
1387 	 * @return The database of the Name
1388 	 * @return The keyValue of the Name
1389 	 * @return The contentId of the Name
1390 	 * @return The typeId of the Name
1391 	 */
1392 	function getName(address _nameId) public view returns (string memory, address, string memory, string memory, string memory, bytes32, uint8) {
1393 		Name _name = Name(address(uint160(_nameId)));
1394 		return (
1395 			_name.name(),
1396 			_name.originId(),
1397 			_name.datHash(),
1398 			_name.database(),
1399 			_name.keyValue(),
1400 			_name.contentId(),
1401 			_name.typeId()
1402 		);
1403 	}
1404 
1405 	/**
1406 	 * @dev Get total Names count
1407 	 * @return total Names count
1408 	 */
1409 	function getTotalNamesCount() public view returns (uint256) {
1410 		return names.length;
1411 	}
1412 
1413 	/**
1414 	 * @dev Get list of Name IDs
1415 	 * @param _from The starting index
1416 	 * @param _to The ending index
1417 	 * @return list of Name IDs
1418 	 */
1419 	function getNameIds(uint256 _from, uint256 _to) public view returns (address[] memory) {
1420 		require (_from >= 0 && _to >= _from);
1421 		require (names.length > 0);
1422 
1423 		address[] memory _names = new address[](_to.sub(_from).add(1));
1424 		if (_to > names.length.sub(1)) {
1425 			_to = names.length.sub(1);
1426 		}
1427 		for (uint256 i = _from; i <= _to; i++) {
1428 			_names[i.sub(_from)] = names[i];
1429 		}
1430 		return _names;
1431 	}
1432 
1433 	/**
1434 	 * @dev Check whether or not the signature is valid
1435 	 * @param _data The signed string data
1436 	 * @param _nonce The signed uint256 nonce (should be Name's current nonce + 1)
1437 	 * @param _validateAddress The ETH address to be validated (optional)
1438 	 * @param _name The name of the Name
1439 	 * @param _signatureV The V part of the signature
1440 	 * @param _signatureR The R part of the signature
1441 	 * @param _signatureS The S part of the signature
1442 	 * @return true if valid. false otherwise
1443 	 */
1444 	function validateNameSignature(
1445 		string memory _data,
1446 		uint256 _nonce,
1447 		address _validateAddress,
1448 		string memory _name,
1449 		uint8 _signatureV,
1450 		bytes32 _signatureR,
1451 		bytes32 _signatureS
1452 	) public view returns (bool) {
1453 		require (_nameTAOLookup.isExist(_name));
1454 		address _nameId = _nameTAOLookup.getIdByName(_name);
1455 		require (_nameId != address(0));
1456 		address _signatureAddress = _getValidateSignatureAddress(_data, _nonce, _signatureV, _signatureR, _signatureS);
1457 		if (_validateAddress != address(0)) {
1458 			return (
1459 				_nonce == _nonces[_nameId].add(1) &&
1460 				_signatureAddress == _validateAddress &&
1461 				_namePublicKey.isKeyExist(_nameId, _validateAddress)
1462 			);
1463 		} else {
1464 			return (
1465 				_nonce == _nonces[_nameId].add(1) &&
1466 				_signatureAddress == _namePublicKey.getDefaultKey(_nameId)
1467 			);
1468 		}
1469 	}
1470 
1471 	/***** INTERNAL METHODS *****/
1472 	/**
1473 	 * @dev Return the address that signed the data and nonce when validating signature
1474 	 * @param _data the data that was signed
1475 	 * @param _nonce The signed uint256 nonce
1476 	 * @param _v part of the signature
1477 	 * @param _r part of the signature
1478 	 * @param _s part of the signature
1479 	 * @return the address that signed the message
1480 	 */
1481 	function _getValidateSignatureAddress(string memory _data, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s) internal view returns (address) {
1482 		bytes32 _hash = keccak256(abi.encodePacked(address(this), _data, _nonce));
1483 		return ecrecover(_hash, _v, _r, _s);
1484 	}
1485 
1486 	/**
1487 	 * @dev Reward primordial contributor Name with pathos/ethos
1488 	 */
1489 	function _rewardContributor(address _nameId) internal {
1490 		if (settingTAOId != address(0)) {
1491 			(,,,, string memory primordialContributorName) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'primordialContributorName');
1492 			(uint256 primordialContributorPathos,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'primordialContributorPathos');
1493 			(uint256 primordialContributorEthos,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'primordialContributorEthos');
1494 			(uint256 primordialContributorEarning,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'primordialContributorEarning');
1495 			address _primordialContributorNameId = _nameTAOLookup.getIdByName(primordialContributorName);
1496 			if (_primordialContributorNameId == _nameId) {
1497 				_pathos.mint(_nameId, primordialContributorPathos);
1498 				_ethos.mint(_nameId, primordialContributorEthos);
1499 			} else if (_primordialContributorNameId != address(0)) {
1500 				_pathos.mint(_primordialContributorNameId, primordialContributorEarning);
1501 				_ethos.mint(_primordialContributorNameId, primordialContributorEarning);
1502 				emit RewardContributor(_nameId, primordialContributorEarning, primordialContributorEarning);
1503 			}
1504 		}
1505 	}
1506 }