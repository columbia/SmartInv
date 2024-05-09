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
129 interface IAOSetting {
130 	function getSettingValuesByTAOName(address _taoId, string calldata _settingName) external view returns (uint256, bool, address, bytes32, string memory);
131 	function getSettingTypes() external view returns (uint8, uint8, uint8, uint8, uint8);
132 
133 	function settingTypeLookup(uint256 _settingId) external view returns (uint8);
134 }
135 
136 
137 interface IAOIonLot {
138 	function createPrimordialLot(address _account, uint256 _primordialAmount, uint256 _multiplier, uint256 _networkBonusAmount) external returns (bytes32);
139 
140 	function createWeightedMultiplierLot(address _account, uint256 _amount, uint256 _weightedMultiplier) external returns (bytes32);
141 
142 	function lotById(bytes32 _lotId) external view returns (bytes32, address, uint256, uint256);
143 
144 	function totalLotsByAddress(address _lotOwner) external view returns (uint256);
145 
146 	function createBurnLot(address _account, uint256 _amount, uint256 _multiplierAfterBurn) external returns (bool);
147 
148 	function createConvertLot(address _account, uint256 _amount, uint256 _multiplierAfterConversion) external returns (bool);
149 }
150 
151 
152 interface INameFactory {
153 	function nonces(address _nameId) external view returns (uint256);
154 	function incrementNonce(address _nameId) external returns (uint256);
155 	function ethAddressToNameId(address _ethAddress) external view returns (address);
156 	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
157 	function nameIdToEthAddress(address _nameId) external view returns (address);
158 }
159 
160 
161 interface IAOContent {
162 	function create(address _creator, string calldata _baseChallenge, uint256 _fileSize, bytes32 _contentUsageType, address _taoId) external returns (bytes32);
163 
164 	function isAOContentUsageType(bytes32 _contentId) external view returns (bool);
165 
166 	function getById(bytes32 _contentId) external view returns (address, uint256, bytes32, address, bytes32, uint8, bytes32, bytes32, string memory);
167 
168 	function getBaseChallenge(bytes32 _contentId) external view returns (string memory);
169 }
170 
171 
172 interface IAOTreasury {
173 	function toBase(uint256 integerAmount, uint256 fractionAmount, bytes8 denominationName) external view returns (uint256);
174 	function isDenominationExist(bytes8 denominationName) external view returns (bool);
175 }
176 
177 
178 interface IAOStakedContent {
179 	function getById(bytes32 _stakedContentId) external view returns (bytes32, address, uint256, uint256, uint256, uint256, bool, uint256);
180 
181 	function create(address _stakeOwner, bytes32 _contentId, uint256 _networkIntegerAmount, uint256 _networkFractionAmount, bytes8 _denomination, uint256 _primordialAmount, uint256 _profitPercentage) external returns (bytes32);
182 
183 	function isActive(bytes32 _stakedContentId) external view returns (bool);
184 }
185 
186 
187 
188 
189 
190 
191 
192 
193 
194 
195 
196 
197 
198 contract TokenERC20 {
199 	// Public variables of the token
200 	string public name;
201 	string public symbol;
202 	uint8 public decimals = 18;
203 	// 18 decimals is the strongly suggested default, avoid changing it
204 	uint256 public totalSupply;
205 
206 	// This creates an array with all balances
207 	mapping (address => uint256) public balanceOf;
208 	mapping (address => mapping (address => uint256)) public allowance;
209 
210 	// This generates a public event on the blockchain that will notify clients
211 	event Transfer(address indexed from, address indexed to, uint256 value);
212 
213 	// This generates a public event on the blockchain that will notify clients
214 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
215 
216 	// This notifies clients about the amount burnt
217 	event Burn(address indexed from, uint256 value);
218 
219 	/**
220 	 * Constructor function
221 	 *
222 	 * Initializes contract with initial supply tokens to the creator of the contract
223 	 */
224 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
225 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
226 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
227 		name = tokenName;                                   // Set the name for display purposes
228 		symbol = tokenSymbol;                               // Set the symbol for display purposes
229 	}
230 
231 	/**
232 	 * Internal transfer, only can be called by this contract
233 	 */
234 	function _transfer(address _from, address _to, uint _value) internal {
235 		// Prevent transfer to 0x0 address. Use burn() instead
236 		require(_to != address(0));
237 		// Check if the sender has enough
238 		require(balanceOf[_from] >= _value);
239 		// Check for overflows
240 		require(balanceOf[_to] + _value > balanceOf[_to]);
241 		// Save this for an assertion in the future
242 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
243 		// Subtract from the sender
244 		balanceOf[_from] -= _value;
245 		// Add the same to the recipient
246 		balanceOf[_to] += _value;
247 		emit Transfer(_from, _to, _value);
248 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
249 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
250 	}
251 
252 	/**
253 	 * Transfer tokens
254 	 *
255 	 * Send `_value` tokens to `_to` from your account
256 	 *
257 	 * @param _to The address of the recipient
258 	 * @param _value the amount to send
259 	 */
260 	function transfer(address _to, uint256 _value) public returns (bool success) {
261 		_transfer(msg.sender, _to, _value);
262 		return true;
263 	}
264 
265 	/**
266 	 * Transfer tokens from other address
267 	 *
268 	 * Send `_value` tokens to `_to` in behalf of `_from`
269 	 *
270 	 * @param _from The address of the sender
271 	 * @param _to The address of the recipient
272 	 * @param _value the amount to send
273 	 */
274 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
275 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
276 		allowance[_from][msg.sender] -= _value;
277 		_transfer(_from, _to, _value);
278 		return true;
279 	}
280 
281 	/**
282 	 * Set allowance for other address
283 	 *
284 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
285 	 *
286 	 * @param _spender The address authorized to spend
287 	 * @param _value the max amount they can spend
288 	 */
289 	function approve(address _spender, uint256 _value) public returns (bool success) {
290 		allowance[msg.sender][_spender] = _value;
291 		emit Approval(msg.sender, _spender, _value);
292 		return true;
293 	}
294 
295 	/**
296 	 * Set allowance for other address and notify
297 	 *
298 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
299 	 *
300 	 * @param _spender The address authorized to spend
301 	 * @param _value the max amount they can spend
302 	 * @param _extraData some extra information to send to the approved contract
303 	 */
304 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
305 		tokenRecipient spender = tokenRecipient(_spender);
306 		if (approve(_spender, _value)) {
307 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
308 			return true;
309 		}
310 	}
311 
312 	/**
313 	 * Destroy tokens
314 	 *
315 	 * Remove `_value` tokens from the system irreversibly
316 	 *
317 	 * @param _value the amount of money to burn
318 	 */
319 	function burn(uint256 _value) public returns (bool success) {
320 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
321 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
322 		totalSupply -= _value;                      // Updates totalSupply
323 		emit Burn(msg.sender, _value);
324 		return true;
325 	}
326 
327 	/**
328 	 * Destroy tokens from other account
329 	 *
330 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
331 	 *
332 	 * @param _from the address of the sender
333 	 * @param _value the amount of money to burn
334 	 */
335 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
336 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
337 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
338 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
339 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
340 		totalSupply -= _value;                              // Update totalSupply
341 		emit Burn(_from, _value);
342 		return true;
343 	}
344 }
345 
346 
347 /**
348  * @title TAO
349  */
350 contract TAO {
351 	using SafeMath for uint256;
352 
353 	address public vaultAddress;
354 	string public name;				// the name for this TAO
355 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
356 
357 	// TAO's data
358 	string public datHash;
359 	string public database;
360 	string public keyValue;
361 	bytes32 public contentId;
362 
363 	/**
364 	 * 0 = TAO
365 	 * 1 = Name
366 	 */
367 	uint8 public typeId;
368 
369 	/**
370 	 * @dev Constructor function
371 	 */
372 	constructor (string memory _name,
373 		address _originId,
374 		string memory _datHash,
375 		string memory _database,
376 		string memory _keyValue,
377 		bytes32 _contentId,
378 		address _vaultAddress
379 	) public {
380 		name = _name;
381 		originId = _originId;
382 		datHash = _datHash;
383 		database = _database;
384 		keyValue = _keyValue;
385 		contentId = _contentId;
386 
387 		// Creating TAO
388 		typeId = 0;
389 
390 		vaultAddress = _vaultAddress;
391 	}
392 
393 	/**
394 	 * @dev Checks if calling address is Vault contract
395 	 */
396 	modifier onlyVault {
397 		require (msg.sender == vaultAddress);
398 		_;
399 	}
400 
401 	/**
402 	 * Will receive any ETH sent
403 	 */
404 	function () external payable {
405 	}
406 
407 	/**
408 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
409 	 * @param _recipient The recipient address
410 	 * @param _amount The amount to transfer
411 	 * @return true on success
412 	 */
413 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
414 		_recipient.transfer(_amount);
415 		return true;
416 	}
417 
418 	/**
419 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
420 	 * @param _erc20TokenAddress The address of ERC20 Token
421 	 * @param _recipient The recipient address
422 	 * @param _amount The amount to transfer
423 	 * @return true on success
424 	 */
425 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
426 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
427 		_erc20.transfer(_recipient, _amount);
428 		return true;
429 	}
430 }
431 
432 
433 
434 
435 /**
436  * @title Name
437  */
438 contract Name is TAO {
439 	/**
440 	 * @dev Constructor function
441 	 */
442 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
443 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
444 		// Creating Name
445 		typeId = 1;
446 	}
447 }
448 
449 
450 
451 
452 /**
453  * @title AOLibrary
454  */
455 library AOLibrary {
456 	using SafeMath for uint256;
457 
458 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
459 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
460 
461 	/**
462 	 * @dev Check whether or not the given TAO ID is a TAO
463 	 * @param _taoId The ID of the TAO
464 	 * @return true if yes. false otherwise
465 	 */
466 	function isTAO(address _taoId) public view returns (bool) {
467 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
468 	}
469 
470 	/**
471 	 * @dev Check whether or not the given Name ID is a Name
472 	 * @param _nameId The ID of the Name
473 	 * @return true if yes. false otherwise
474 	 */
475 	function isName(address _nameId) public view returns (bool) {
476 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
477 	}
478 
479 	/**
480 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
481 	 * @param _tokenAddress The ERC20 Token address to check
482 	 */
483 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
484 		if (_tokenAddress == address(0)) {
485 			return false;
486 		}
487 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
488 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
489 	}
490 
491 	/**
492 	 * @dev Checks if the calling contract address is The AO
493 	 *		OR
494 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
495 	 * @param _sender The address to check
496 	 * @param _theAO The AO address
497 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
498 	 * @return true if yes, false otherwise
499 	 */
500 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
501 		return (_sender == _theAO ||
502 			(
503 				(isTAO(_theAO) || isName(_theAO)) &&
504 				_nameTAOPositionAddress != address(0) &&
505 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
506 			)
507 		);
508 	}
509 
510 	/**
511 	 * @dev Return the divisor used to correctly calculate percentage.
512 	 *		Percentage stored throughout AO contracts covers 4 decimals,
513 	 *		so 1% is 10000, 1.25% is 12500, etc
514 	 */
515 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
516 		return _PERCENTAGE_DIVISOR;
517 	}
518 
519 	/**
520 	 * @dev Return the divisor used to correctly calculate multiplier.
521 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
522 	 *		so 1 is 1000000, 0.023 is 23000, etc
523 	 */
524 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
525 		return _MULTIPLIER_DIVISOR;
526 	}
527 
528 	/**
529 	 * @dev deploy a TAO
530 	 * @param _name The name of the TAO
531 	 * @param _originId The Name ID the creates the TAO
532 	 * @param _datHash The datHash of this TAO
533 	 * @param _database The database for this TAO
534 	 * @param _keyValue The key/value pair to be checked on the database
535 	 * @param _contentId The contentId related to this TAO
536 	 * @param _nameTAOVaultAddress The address of NameTAOVault
537 	 */
538 	function deployTAO(string memory _name,
539 		address _originId,
540 		string memory _datHash,
541 		string memory _database,
542 		string memory _keyValue,
543 		bytes32 _contentId,
544 		address _nameTAOVaultAddress
545 		) public returns (TAO _tao) {
546 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
547 	}
548 
549 	/**
550 	 * @dev deploy a Name
551 	 * @param _name The name of the Name
552 	 * @param _originId The eth address the creates the Name
553 	 * @param _datHash The datHash of this Name
554 	 * @param _database The database for this Name
555 	 * @param _keyValue The key/value pair to be checked on the database
556 	 * @param _contentId The contentId related to this Name
557 	 * @param _nameTAOVaultAddress The address of NameTAOVault
558 	 */
559 	function deployName(string memory _name,
560 		address _originId,
561 		string memory _datHash,
562 		string memory _database,
563 		string memory _keyValue,
564 		bytes32 _contentId,
565 		address _nameTAOVaultAddress
566 		) public returns (Name _myName) {
567 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
568 	}
569 
570 	/**
571 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
572 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
573 	 * @param _currentPrimordialBalance Account's current primordial ion balance
574 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
575 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
576 	 * @return the new primordial weighted multiplier
577 	 */
578 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
579 		if (_currentWeightedMultiplier > 0) {
580 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
581 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
582 			return _totalWeightedIons.div(_totalIons);
583 		} else {
584 			return _additionalWeightedMultiplier;
585 		}
586 	}
587 
588 	/**
589 	 * @dev Calculate the primordial ion multiplier on a given lot
590 	 *		Total Primordial Mintable = T
591 	 *		Total Primordial Minted = M
592 	 *		Starting Multiplier = S
593 	 *		Ending Multiplier = E
594 	 *		To Purchase = P
595 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
596 	 *
597 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
598 	 * @param _totalPrimordialMintable Total Primordial ion mintable
599 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
600 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
601 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
602 	 * @return The multiplier in (10 ** 6)
603 	 */
604 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
605 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
606 			/**
607 			 * Let temp = M + (P/2)
608 			 * Multiplier = (1 - (temp / T)) x (S-E)
609 			 */
610 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
611 
612 			/**
613 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
614 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
615 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
616 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
617 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
618 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
619 			 */
620 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
621 			/**
622 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
623 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
624 			 */
625 			return multiplier.div(_MULTIPLIER_DIVISOR);
626 		} else {
627 			return 0;
628 		}
629 	}
630 
631 	/**
632 	 * @dev Calculate the bonus percentage of network ion on a given lot
633 	 *		Total Primordial Mintable = T
634 	 *		Total Primordial Minted = M
635 	 *		Starting Network Bonus Multiplier = Bs
636 	 *		Ending Network Bonus Multiplier = Be
637 	 *		To Purchase = P
638 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
639 	 *
640 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
641 	 * @param _totalPrimordialMintable Total Primordial ion intable
642 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
643 	 * @param _startingMultiplier The starting Network ion bonus multiplier
644 	 * @param _endingMultiplier The ending Network ion bonus multiplier
645 	 * @return The bonus percentage
646 	 */
647 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
648 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
649 			/**
650 			 * Let temp = M + (P/2)
651 			 * B% = (1 - (temp / T)) x (Bs-Be)
652 			 */
653 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
654 
655 			/**
656 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
657 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
658 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
659 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
660 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
661 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
662 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
663 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
664 			 */
665 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
666 			return bonusPercentage;
667 		} else {
668 			return 0;
669 		}
670 	}
671 
672 	/**
673 	 * @dev Calculate the bonus amount of network ion on a given lot
674 	 *		AO Bonus Amount = B% x P
675 	 *
676 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
677 	 * @param _totalPrimordialMintable Total Primordial ion intable
678 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
679 	 * @param _startingMultiplier The starting Network ion bonus multiplier
680 	 * @param _endingMultiplier The ending Network ion bonus multiplier
681 	 * @return The bonus percentage
682 	 */
683 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
684 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
685 		/**
686 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
687 		 * when calculating the network ion bonus amount
688 		 */
689 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
690 		return networkBonus;
691 	}
692 
693 	/**
694 	 * @dev Calculate the maximum amount of Primordial an account can burn
695 	 *		_primordialBalance = P
696 	 *		_currentWeightedMultiplier = M
697 	 *		_maximumMultiplier = S
698 	 *		_amountToBurn = B
699 	 *		B = ((S x P) - (P x M)) / S
700 	 *
701 	 * @param _primordialBalance Account's primordial ion balance
702 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
703 	 * @param _maximumMultiplier The maximum multiplier of this account
704 	 * @return The maximum burn amount
705 	 */
706 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
707 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
708 	}
709 
710 	/**
711 	 * @dev Calculate the new multiplier after burning primordial ion
712 	 *		_primordialBalance = P
713 	 *		_currentWeightedMultiplier = M
714 	 *		_amountToBurn = B
715 	 *		_newMultiplier = E
716 	 *		E = (P x M) / (P - B)
717 	 *
718 	 * @param _primordialBalance Account's primordial ion balance
719 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
720 	 * @param _amountToBurn The amount of primordial ion to burn
721 	 * @return The new multiplier
722 	 */
723 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
724 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
725 	}
726 
727 	/**
728 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
729 	 *		_primordialBalance = P
730 	 *		_currentWeightedMultiplier = M
731 	 *		_amountToConvert = C
732 	 *		_newMultiplier = E
733 	 *		E = (P x M) / (P + C)
734 	 *
735 	 * @param _primordialBalance Account's primordial ion balance
736 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
737 	 * @param _amountToConvert The amount of network ion to convert
738 	 * @return The new multiplier
739 	 */
740 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
741 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
742 	}
743 
744 	/**
745 	 * @dev count num of digits
746 	 * @param number uint256 of the nuumber to be checked
747 	 * @return uint8 num of digits
748 	 */
749 	function numDigits(uint256 number) public pure returns (uint8) {
750 		uint8 digits = 0;
751 		while(number != 0) {
752 			number = number.div(10);
753 			digits++;
754 		}
755 		return digits;
756 	}
757 }
758 
759 
760 
761 
762 
763 
764 
765 
766 
767 
768 
769 
770 
771 
772 
773 
774 interface ionRecipient {
775 	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
776 }
777 
778 /**
779  * @title AOIonInterface
780  */
781 contract AOIonInterface is TheAO {
782 	using SafeMath for uint256;
783 
784 	address public namePublicKeyAddress;
785 	address public nameAccountRecoveryAddress;
786 
787 	INameTAOPosition internal _nameTAOPosition;
788 	INamePublicKey internal _namePublicKey;
789 	INameAccountRecovery internal _nameAccountRecovery;
790 
791 	// Public variables of the contract
792 	string public name;
793 	string public symbol;
794 	uint8 public decimals;
795 	uint256 public totalSupply;
796 
797 	// To differentiate denomination of AO
798 	uint256 public powerOfTen;
799 
800 	/***** NETWORK ION VARIABLES *****/
801 	uint256 public sellPrice;
802 	uint256 public buyPrice;
803 
804 	// This creates an array with all balances
805 	mapping (address => uint256) public balanceOf;
806 	mapping (address => mapping (address => uint256)) public allowance;
807 	mapping (address => bool) public frozenAccount;
808 	mapping (address => uint256) public stakedBalance;
809 	mapping (address => uint256) public escrowedBalance;
810 
811 	// This generates a public event on the blockchain that will notify clients
812 	event FrozenFunds(address target, bool frozen);
813 	event Stake(address indexed from, uint256 value);
814 	event Unstake(address indexed from, uint256 value);
815 	event Escrow(address indexed from, address indexed to, uint256 value);
816 	event Unescrow(address indexed from, uint256 value);
817 
818 	// This generates a public event on the blockchain that will notify clients
819 	event Transfer(address indexed from, address indexed to, uint256 value);
820 
821 	// This generates a public event on the blockchain that will notify clients
822 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
823 
824 	// This notifies clients about the amount burnt
825 	event Burn(address indexed from, uint256 value);
826 
827 	/**
828 	 * @dev Constructor function
829 	 */
830 	constructor(string memory _name, string memory _symbol, address _nameTAOPositionAddress, address _namePublicKeyAddress, address _nameAccountRecoveryAddress) public {
831 		setNameTAOPositionAddress(_nameTAOPositionAddress);
832 		setNamePublicKeyAddress(_namePublicKeyAddress);
833 		setNameAccountRecoveryAddress(_nameAccountRecoveryAddress);
834 		name = _name;           // Set the name for display purposes
835 		symbol = _symbol;       // Set the symbol for display purposes
836 		powerOfTen = 0;
837 		decimals = 0;
838 	}
839 
840 	/**
841 	 * @dev Checks if the calling contract address is The AO
842 	 *		OR
843 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
844 	 */
845 	modifier onlyTheAO {
846 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
847 		_;
848 	}
849 
850 	/***** The AO ONLY METHODS *****/
851 	/**
852 	 * @dev Transfer ownership of The AO to new address
853 	 * @param _theAO The new address to be transferred
854 	 */
855 	function transferOwnership(address _theAO) public onlyTheAO {
856 		require (_theAO != address(0));
857 		theAO = _theAO;
858 	}
859 
860 	/**
861 	 * @dev Whitelist `_account` address to transact on behalf of others
862 	 * @param _account The address to whitelist
863 	 * @param _whitelist Either to whitelist or not
864 	 */
865 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
866 		require (_account != address(0));
867 		whitelist[_account] = _whitelist;
868 	}
869 
870 	/**
871 	 * @dev The AO set the NameTAOPosition Address
872 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
873 	 */
874 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
875 		require (_nameTAOPositionAddress != address(0));
876 		nameTAOPositionAddress = _nameTAOPositionAddress;
877 		_nameTAOPosition = INameTAOPosition(nameTAOPositionAddress);
878 	}
879 
880 	/**
881 	 * @dev The AO set the NamePublicKey Address
882 	 * @param _namePublicKeyAddress The address of NamePublicKey
883 	 */
884 	function setNamePublicKeyAddress(address _namePublicKeyAddress) public onlyTheAO {
885 		require (_namePublicKeyAddress != address(0));
886 		namePublicKeyAddress = _namePublicKeyAddress;
887 		_namePublicKey = INamePublicKey(namePublicKeyAddress);
888 	}
889 
890 	/**
891 	 * @dev The AO set the NameAccountRecovery Address
892 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
893 	 */
894 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
895 		require (_nameAccountRecoveryAddress != address(0));
896 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
897 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
898 	}
899 
900 	/**
901 	 * @dev Allows TheAO to transfer `_amount` of ETH from this address to `_recipient`
902 	 * @param _recipient The recipient address
903 	 * @param _amount The amount to transfer
904 	 */
905 	function transferEth(address payable _recipient, uint256 _amount) public onlyTheAO {
906 		require (_recipient != address(0));
907 		_recipient.transfer(_amount);
908 	}
909 
910 	/**
911 	 * @dev Prevent/Allow target from sending & receiving ions
912 	 * @param target Address to be frozen
913 	 * @param freeze Either to freeze it or not
914 	 */
915 	function freezeAccount(address target, bool freeze) public onlyTheAO {
916 		frozenAccount[target] = freeze;
917 		emit FrozenFunds(target, freeze);
918 	}
919 
920 	/**
921 	 * @dev Allow users to buy ions for `newBuyPrice` eth and sell ions for `newSellPrice` eth
922 	 * @param newSellPrice Price users can sell to the contract
923 	 * @param newBuyPrice Price users can buy from the contract
924 	 */
925 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyTheAO {
926 		sellPrice = newSellPrice;
927 		buyPrice = newBuyPrice;
928 	}
929 
930 	/***** NETWORK ION WHITELISTED ADDRESS ONLY METHODS *****/
931 	/**
932 	 * @dev Create `mintedAmount` ions and send it to `target`
933 	 * @param target Address to receive the ions
934 	 * @param mintedAmount The amount of ions it will receive
935 	 * @return true on success
936 	 */
937 	function mint(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
938 		_mint(target, mintedAmount);
939 		return true;
940 	}
941 
942 	/**
943 	 * @dev Stake `_value` ions on behalf of `_from`
944 	 * @param _from The address of the target
945 	 * @param _value The amount to stake
946 	 * @return true on success
947 	 */
948 	function stakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
949 		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
950 		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
951 		stakedBalance[_from] = stakedBalance[_from].add(_value);	// Add to the targeted staked balance
952 		emit Stake(_from, _value);
953 		return true;
954 	}
955 
956 	/**
957 	 * @dev Unstake `_value` ions on behalf of `_from`
958 	 * @param _from The address of the target
959 	 * @param _value The amount to unstake
960 	 * @return true on success
961 	 */
962 	function unstakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
963 		require (stakedBalance[_from] >= _value);					// Check if the targeted staked balance is enough
964 		stakedBalance[_from] = stakedBalance[_from].sub(_value);	// Subtract from the targeted staked balance
965 		balanceOf[_from] = balanceOf[_from].add(_value);			// Add to the targeted balance
966 		emit Unstake(_from, _value);
967 		return true;
968 	}
969 
970 	/**
971 	 * @dev Store `_value` from `_from` to `_to` in escrow
972 	 * @param _from The address of the sender
973 	 * @param _to The address of the recipient
974 	 * @param _value The amount of network ions to put in escrow
975 	 * @return true on success
976 	 */
977 	function escrowFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool) {
978 		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
979 		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
980 		escrowedBalance[_to] = escrowedBalance[_to].add(_value);	// Add to the targeted escrowed balance
981 		emit Escrow(_from, _to, _value);
982 		return true;
983 	}
984 
985 	/**
986 	 * @dev Create `mintedAmount` ions and send it to `target` escrow balance
987 	 * @param target Address to receive ions
988 	 * @param mintedAmount The amount of ions it will receive in escrow
989 	 */
990 	function mintEscrow(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
991 		escrowedBalance[target] = escrowedBalance[target].add(mintedAmount);
992 		totalSupply = totalSupply.add(mintedAmount);
993 		emit Escrow(address(this), target, mintedAmount);
994 		return true;
995 	}
996 
997 	/**
998 	 * @dev Release escrowed `_value` from `_from`
999 	 * @param _from The address of the sender
1000 	 * @param _value The amount of escrowed network ions to be released
1001 	 * @return true on success
1002 	 */
1003 	function unescrowFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
1004 		require (escrowedBalance[_from] >= _value);						// Check if the targeted escrowed balance is enough
1005 		escrowedBalance[_from] = escrowedBalance[_from].sub(_value);	// Subtract from the targeted escrowed balance
1006 		balanceOf[_from] = balanceOf[_from].add(_value);				// Add to the targeted balance
1007 		emit Unescrow(_from, _value);
1008 		return true;
1009 	}
1010 
1011 	/**
1012 	 *
1013 	 * @dev Whitelisted address remove `_value` ions from the system irreversibly on behalf of `_from`.
1014 	 *
1015 	 * @param _from the address of the sender
1016 	 * @param _value the amount of money to burn
1017 	 */
1018 	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist returns (bool success) {
1019 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
1020 		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
1021 		totalSupply = totalSupply.sub(_value);              // Update totalSupply
1022 		emit Burn(_from, _value);
1023 		return true;
1024 	}
1025 
1026 	/**
1027 	 * @dev Whitelisted address transfer ions from other address
1028 	 *
1029 	 * Send `_value` ions to `_to` on behalf of `_from`
1030 	 *
1031 	 * @param _from The address of the sender
1032 	 * @param _to The address of the recipient
1033 	 * @param _value the amount to send
1034 	 */
1035 	function whitelistTransferFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool success) {
1036 		_transfer(_from, _to, _value);
1037 		return true;
1038 	}
1039 
1040 	/***** PUBLIC METHODS *****/
1041 	/**
1042 	 * Transfer ions
1043 	 *
1044 	 * Send `_value` ions to `_to` from your account
1045 	 *
1046 	 * @param _to The address of the recipient
1047 	 * @param _value the amount to send
1048 	 */
1049 	function transfer(address _to, uint256 _value) public returns (bool success) {
1050 		_transfer(msg.sender, _to, _value);
1051 		return true;
1052 	}
1053 
1054 	/**
1055 	 * Transfer ions from other address
1056 	 *
1057 	 * Send `_value` ions to `_to` in behalf of `_from`
1058 	 *
1059 	 * @param _from The address of the sender
1060 	 * @param _to The address of the recipient
1061 	 * @param _value the amount to send
1062 	 */
1063 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
1064 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
1065 		allowance[_from][msg.sender] -= _value;
1066 		_transfer(_from, _to, _value);
1067 		return true;
1068 	}
1069 
1070 	/**
1071 	 * Transfer ions between public key addresses in a Name
1072 	 * @param _nameId The ID of the Name
1073 	 * @param _from The address of the sender
1074 	 * @param _to The address of the recipient
1075 	 * @param _value the amount to send
1076 	 */
1077 	function transferBetweenPublicKeys(address _nameId, address _from, address _to, uint256 _value) public returns (bool success) {
1078 		require (AOLibrary.isName(_nameId));
1079 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _nameId));
1080 		require (!_nameAccountRecovery.isCompromised(_nameId));
1081 		// Make sure _from exist in the Name's Public Keys
1082 		require (_namePublicKey.isKeyExist(_nameId, _from));
1083 		// Make sure _to exist in the Name's Public Keys
1084 		require (_namePublicKey.isKeyExist(_nameId, _to));
1085 		_transfer(_from, _to, _value);
1086 		return true;
1087 	}
1088 
1089 	/**
1090 	 * Set allowance for other address
1091 	 *
1092 	 * Allows `_spender` to spend no more than `_value` ions in your behalf
1093 	 *
1094 	 * @param _spender The address authorized to spend
1095 	 * @param _value the max amount they can spend
1096 	 */
1097 	function approve(address _spender, uint256 _value) public returns (bool success) {
1098 		allowance[msg.sender][_spender] = _value;
1099 		emit Approval(msg.sender, _spender, _value);
1100 		return true;
1101 	}
1102 
1103 	/**
1104 	 * Set allowance for other address and notify
1105 	 *
1106 	 * Allows `_spender` to spend no more than `_value` ions in your behalf, and then ping the contract about it
1107 	 *
1108 	 * @param _spender The address authorized to spend
1109 	 * @param _value the max amount they can spend
1110 	 * @param _extraData some extra information to send to the approved contract
1111 	 */
1112 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
1113 		ionRecipient spender = ionRecipient(_spender);
1114 		if (approve(_spender, _value)) {
1115 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
1116 			return true;
1117 		}
1118 	}
1119 
1120 	/**
1121 	 * Destroy ions
1122 	 *
1123 	 * Remove `_value` ions from the system irreversibly
1124 	 *
1125 	 * @param _value the amount of money to burn
1126 	 */
1127 	function burn(uint256 _value) public returns (bool success) {
1128 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
1129 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
1130 		totalSupply -= _value;                      // Updates totalSupply
1131 		emit Burn(msg.sender, _value);
1132 		return true;
1133 	}
1134 
1135 	/**
1136 	 * Destroy ions from other account
1137 	 *
1138 	 * Remove `_value` ions from the system irreversibly on behalf of `_from`.
1139 	 *
1140 	 * @param _from the address of the sender
1141 	 * @param _value the amount of money to burn
1142 	 */
1143 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
1144 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
1145 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
1146 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
1147 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
1148 		totalSupply -= _value;                              // Update totalSupply
1149 		emit Burn(_from, _value);
1150 		return true;
1151 	}
1152 
1153 	/**
1154 	 * @dev Buy ions from contract by sending ether
1155 	 */
1156 	function buy() public payable {
1157 		require (buyPrice > 0);
1158 		uint256 amount = msg.value.div(buyPrice);
1159 		_transfer(address(this), msg.sender, amount);
1160 	}
1161 
1162 	/**
1163 	 * @dev Sell `amount` ions to contract
1164 	 * @param amount The amount of ions to be sold
1165 	 */
1166 	function sell(uint256 amount) public {
1167 		require (sellPrice > 0);
1168 		address myAddress = address(this);
1169 		require (myAddress.balance >= amount.mul(sellPrice));
1170 		_transfer(msg.sender, address(this), amount);
1171 		msg.sender.transfer(amount.mul(sellPrice));
1172 	}
1173 
1174 	/***** INTERNAL METHODS *****/
1175 	/**
1176 	 * @dev Send `_value` ions from `_from` to `_to`
1177 	 * @param _from The address of sender
1178 	 * @param _to The address of the recipient
1179 	 * @param _value The amount to send
1180 	 */
1181 	function _transfer(address _from, address _to, uint256 _value) internal {
1182 		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
1183 		require (balanceOf[_from] >= _value);					// Check if the sender has enough
1184 		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
1185 		require (!frozenAccount[_from]);						// Check if sender is frozen
1186 		require (!frozenAccount[_to]);							// Check if recipient is frozen
1187 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
1188 		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
1189 		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
1190 		emit Transfer(_from, _to, _value);
1191 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
1192 	}
1193 
1194 	/**
1195 	 * @dev Create `mintedAmount` ions and send it to `target`
1196 	 * @param target Address to receive the ions
1197 	 * @param mintedAmount The amount of ions it will receive
1198 	 */
1199 	function _mint(address target, uint256 mintedAmount) internal {
1200 		balanceOf[target] = balanceOf[target].add(mintedAmount);
1201 		totalSupply = totalSupply.add(mintedAmount);
1202 		emit Transfer(address(0), address(this), mintedAmount);
1203 		emit Transfer(address(this), target, mintedAmount);
1204 	}
1205 }
1206 
1207 
1208 
1209 
1210 
1211 
1212 
1213 
1214 
1215 
1216 
1217 
1218 
1219 /**
1220  * @title AOETH
1221  */
1222 contract AOETH is TheAO, TokenERC20, tokenRecipient {
1223 	using SafeMath for uint256;
1224 
1225 	address public aoIonAddress;
1226 
1227 	AOIon internal _aoIon;
1228 
1229 	uint256 public totalERC20Tokens;
1230 	uint256 public totalTokenExchanges;
1231 
1232 	struct ERC20Token {
1233 		address tokenAddress;
1234 		uint256 price;			// price of this ERC20 Token to AOETH
1235 		uint256 maxQuantity;	// To prevent too much exposure to a given asset
1236 		uint256 exchangedQuantity;	// Running total (total AOETH exchanged from this specific ERC20 Token)
1237 		bool active;
1238 	}
1239 
1240 	struct TokenExchange {
1241 		bytes32 exchangeId;
1242 		address buyer;			// The buyer address
1243 		address tokenAddress;	// The address of ERC20 Token
1244 		uint256 price;			// price of ERC20 Token to AOETH
1245 		uint256 sentAmount;		// Amount of ERC20 Token sent
1246 		uint256 receivedAmount;	// Amount of AOETH received
1247 		bytes extraData; // Extra data
1248 	}
1249 
1250 	// Mapping from id to ERC20Token object
1251 	mapping (uint256 => ERC20Token) internal erc20Tokens;
1252 	mapping (address => uint256) internal erc20TokenIdLookup;
1253 
1254 	// Mapping from id to TokenExchange object
1255 	mapping (uint256 => TokenExchange) internal tokenExchanges;
1256 	mapping (bytes32 => uint256) internal tokenExchangeIdLookup;
1257 	mapping (address => uint256) public totalAddressTokenExchanges;
1258 
1259 	// Event to be broadcasted to public when TheAO adds an ERC20 Token
1260 	event AddERC20Token(address indexed tokenAddress, uint256 price, uint256 maxQuantity);
1261 
1262 	// Event to be broadcasted to public when TheAO sets price for ERC20 Token
1263 	event SetPrice(address indexed tokenAddress, uint256 price);
1264 
1265 	// Event to be broadcasted to public when TheAO sets max quantity for ERC20 Token
1266 	event SetMaxQuantity(address indexed tokenAddress, uint256 maxQuantity);
1267 
1268 	// Event to be broadcasted to public when TheAO sets active status for ERC20 Token
1269 	event SetActive(address indexed tokenAddress, bool active);
1270 
1271 	// Event to be broadcasted to public when user exchanges ERC20 Token for AOETH
1272 	event ExchangeToken(bytes32 indexed exchangeId, address indexed from, address tokenAddress, string tokenName, string tokenSymbol, uint256 sentTokenAmount, uint256 receivedAOETHAmount, bytes extraData);
1273 
1274 	/**
1275 	 * @dev Constructor function
1276 	 */
1277 	constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol, address _aoIonAddress, address _nameTAOPositionAddress)
1278 		TokenERC20(initialSupply, tokenName, tokenSymbol) public {
1279 		setAOIonAddress(_aoIonAddress);
1280 		setNameTAOPositionAddress(_nameTAOPositionAddress);
1281 	}
1282 
1283 	/**
1284 	 * @dev Checks if the calling contract address is The AO
1285 	 *		OR
1286 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
1287 	 */
1288 	modifier onlyTheAO {
1289 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
1290 		_;
1291 	}
1292 
1293 	/***** The AO ONLY METHODS *****/
1294 	/**
1295 	 * @dev Transfer ownership of The AO to new address
1296 	 * @param _theAO The new address to be transferred
1297 	 */
1298 	function transferOwnership(address _theAO) public onlyTheAO {
1299 		require (_theAO != address(0));
1300 		theAO = _theAO;
1301 	}
1302 
1303 	/**
1304 	 * @dev Whitelist `_account` address to transact on behalf of others
1305 	 * @param _account The address to whitelist
1306 	 * @param _whitelist Either to whitelist or not
1307 	 */
1308 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
1309 		require (_account != address(0));
1310 		whitelist[_account] = _whitelist;
1311 	}
1312 
1313 	/**
1314 	 * @dev The AO set the AOIon Address
1315 	 * @param _aoIonAddress The address of AOIon
1316 	 */
1317 	function setAOIonAddress(address _aoIonAddress) public onlyTheAO {
1318 		require (_aoIonAddress != address(0));
1319 		aoIonAddress = _aoIonAddress;
1320 		_aoIon = AOIon(_aoIonAddress);
1321 	}
1322 
1323 	/**
1324 	 * @dev The AO set the NameTAOPosition Address
1325 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
1326 	 */
1327 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
1328 		require (_nameTAOPositionAddress != address(0));
1329 		nameTAOPositionAddress = _nameTAOPositionAddress;
1330 	}
1331 
1332 	/**
1333 	 * @dev Allows TheAO to transfer `_amount` of ERC20 Token from this address to `_recipient`
1334 	 * @param _erc20TokenAddress The address of ERC20 Token
1335 	 * @param _recipient The recipient address
1336 	 * @param _amount The amount to transfer
1337 	 */
1338 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyTheAO {
1339 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
1340 		require (_erc20.transfer(_recipient, _amount));
1341 	}
1342 
1343 	/**
1344 	 * @dev Add an ERC20 Token to the list
1345 	 * @param _tokenAddress The address of the ERC20 Token
1346 	 * @param _price The price of this token to AOETH
1347 	 * @param _maxQuantity Maximum quantity allowed for exchange
1348 	 */
1349 	function addERC20Token(address _tokenAddress, uint256 _price, uint256 _maxQuantity) public onlyTheAO {
1350 		require (_tokenAddress != address(0) && _price > 0 && _maxQuantity > 0);
1351 		require (AOLibrary.isValidERC20TokenAddress(_tokenAddress));
1352 		require (erc20TokenIdLookup[_tokenAddress] == 0);
1353 
1354 		totalERC20Tokens++;
1355 		erc20TokenIdLookup[_tokenAddress] = totalERC20Tokens;
1356 		ERC20Token storage _erc20Token = erc20Tokens[totalERC20Tokens];
1357 		_erc20Token.tokenAddress = _tokenAddress;
1358 		_erc20Token.price = _price;
1359 		_erc20Token.maxQuantity = _maxQuantity;
1360 		_erc20Token.active = true;
1361 		emit AddERC20Token(_erc20Token.tokenAddress, _erc20Token.price, _erc20Token.maxQuantity);
1362 	}
1363 
1364 	/**
1365 	 * @dev Set price for existing ERC20 Token
1366 	 * @param _tokenAddress The address of the ERC20 Token
1367 	 * @param _price The price of this token to AOETH
1368 	 */
1369 	function setPrice(address _tokenAddress, uint256 _price) public onlyTheAO {
1370 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1371 		require (_price > 0);
1372 
1373 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
1374 		_erc20Token.price = _price;
1375 		emit SetPrice(_erc20Token.tokenAddress, _erc20Token.price);
1376 	}
1377 
1378 	/**
1379 	 * @dev Set max quantity for existing ERC20 Token
1380 	 * @param _tokenAddress The address of the ERC20 Token
1381 	 * @param _maxQuantity The max exchange quantity for this token
1382 	 */
1383 	function setMaxQuantity(address _tokenAddress, uint256 _maxQuantity) public onlyTheAO {
1384 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1385 
1386 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
1387 		require (_maxQuantity > _erc20Token.exchangedQuantity);
1388 		_erc20Token.maxQuantity = _maxQuantity;
1389 		emit SetMaxQuantity(_erc20Token.tokenAddress, _erc20Token.maxQuantity);
1390 	}
1391 
1392 	/**
1393 	 * @dev Set active status for existing ERC20 Token
1394 	 * @param _tokenAddress The address of the ERC20 Token
1395 	 * @param _active The active status for this token
1396 	 */
1397 	function setActive(address _tokenAddress, bool _active) public onlyTheAO {
1398 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1399 
1400 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
1401 		_erc20Token.active = _active;
1402 		emit SetActive(_erc20Token.tokenAddress, _erc20Token.active);
1403 	}
1404 
1405 	/**
1406 	 * @dev Whitelisted address transfer tokens from other address
1407 	 *
1408 	 * Send `_value` tokens to `_to` on behalf of `_from`
1409 	 *
1410 	 * @param _from The address of the sender
1411 	 * @param _to The address of the recipient
1412 	 * @param _value the amount to send
1413 	 */
1414 	function whitelistTransferFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool success) {
1415 		_transfer(_from, _to, _value);
1416 		return true;
1417 	}
1418 
1419 	/***** PUBLIC METHODS *****/
1420 	/**
1421 	 * @dev Get an ERC20 Token information given an ID
1422 	 * @param _id The internal ID of the ERC20 Token
1423 	 * @return The ERC20 Token address
1424 	 * @return The name of the token
1425 	 * @return The symbol of the token
1426 	 * @return The price of this token to AOETH
1427 	 * @return The max quantity for exchange
1428 	 * @return The total AOETH exchanged from this token
1429 	 * @return The status of this token
1430 	 */
1431 	function getById(uint256 _id) public view returns (address, string memory, string memory, uint256, uint256, uint256, bool) {
1432 		require (erc20Tokens[_id].tokenAddress != address(0));
1433 		ERC20Token memory _erc20Token = erc20Tokens[_id];
1434 		return (
1435 			_erc20Token.tokenAddress,
1436 			TokenERC20(_erc20Token.tokenAddress).name(),
1437 			TokenERC20(_erc20Token.tokenAddress).symbol(),
1438 			_erc20Token.price,
1439 			_erc20Token.maxQuantity,
1440 			_erc20Token.exchangedQuantity,
1441 			_erc20Token.active
1442 		);
1443 	}
1444 
1445 	/**
1446 	 * @dev Get an ERC20 Token information given an address
1447 	 * @param _tokenAddress The address of the ERC20 Token
1448 	 * @return The ERC20 Token address
1449 	 * @return The name of the token
1450 	 * @return The symbol of the token
1451 	 * @return The price of this token to AOETH
1452 	 * @return The max quantity for exchange
1453 	 * @return The total AOETH exchanged from this token
1454 	 * @return The status of this token
1455 	 */
1456 	function getByAddress(address _tokenAddress) public view returns (address, string memory, string memory, uint256, uint256, uint256, bool) {
1457 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1458 		return getById(erc20TokenIdLookup[_tokenAddress]);
1459 	}
1460 
1461 	/**
1462 	 * @dev When a user approves AOETH to spend on his/her behalf (i.e exchange to AOETH)
1463 	 * @param _from The user address that approved AOETH
1464 	 * @param _value The amount that the user approved
1465 	 * @param _token The address of the ERC20 Token
1466 	 * @param _extraData The extra data sent during the approval
1467 	 */
1468 	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external {
1469 		require (_from != address(0));
1470 		require (AOLibrary.isValidERC20TokenAddress(_token));
1471 
1472 		// Check if the token is supported
1473 		require (erc20TokenIdLookup[_token] > 0);
1474 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_token]];
1475 		require (_erc20Token.active && _erc20Token.price > 0 && _erc20Token.exchangedQuantity < _erc20Token.maxQuantity);
1476 
1477 		uint256 amountToTransfer = _value.div(_erc20Token.price);
1478 		require (_erc20Token.maxQuantity.sub(_erc20Token.exchangedQuantity) >= amountToTransfer);
1479 		require (_aoIon.availableETH() >= amountToTransfer);
1480 
1481 		// Transfer the ERC20 Token from the `_from` address to here
1482 		require (TokenERC20(_token).transferFrom(_from, address(this), _value));
1483 
1484 		_erc20Token.exchangedQuantity = _erc20Token.exchangedQuantity.add(amountToTransfer);
1485 		balanceOf[_from] = balanceOf[_from].add(amountToTransfer);
1486 		totalSupply = totalSupply.add(amountToTransfer);
1487 
1488 		// Store the TokenExchange information
1489 		totalTokenExchanges++;
1490 		totalAddressTokenExchanges[_from]++;
1491 		bytes32 _exchangeId = keccak256(abi.encodePacked(this, _from, totalTokenExchanges));
1492 		tokenExchangeIdLookup[_exchangeId] = totalTokenExchanges;
1493 
1494 		TokenExchange storage _tokenExchange = tokenExchanges[totalTokenExchanges];
1495 		_tokenExchange.exchangeId = _exchangeId;
1496 		_tokenExchange.buyer = _from;
1497 		_tokenExchange.tokenAddress = _token;
1498 		_tokenExchange.price = _erc20Token.price;
1499 		_tokenExchange.sentAmount = _value;
1500 		_tokenExchange.receivedAmount = amountToTransfer;
1501 		_tokenExchange.extraData = _extraData;
1502 
1503 		emit ExchangeToken(_tokenExchange.exchangeId, _tokenExchange.buyer, _tokenExchange.tokenAddress, TokenERC20(_token).name(), TokenERC20(_token).symbol(), _tokenExchange.sentAmount, _tokenExchange.receivedAmount, _tokenExchange.extraData);
1504 	}
1505 
1506 	/**
1507 	 * @dev Get TokenExchange information given an exchange ID
1508 	 * @param _exchangeId The exchange ID to query
1509 	 * @return The buyer address
1510 	 * @return The sent ERC20 Token address
1511 	 * @return The ERC20 Token name
1512 	 * @return The ERC20 Token symbol
1513 	 * @return The price of ERC20 Token to AOETH
1514 	 * @return The amount of ERC20 Token sent
1515 	 * @return The amount of AOETH received
1516 	 * @return Extra data during the transaction
1517 	 */
1518 	function getTokenExchangeById(bytes32 _exchangeId) public view returns (address, address, string memory, string memory, uint256, uint256,  uint256, bytes memory) {
1519 		require (tokenExchangeIdLookup[_exchangeId] > 0);
1520 		TokenExchange memory _tokenExchange = tokenExchanges[tokenExchangeIdLookup[_exchangeId]];
1521 		return (
1522 			_tokenExchange.buyer,
1523 			_tokenExchange.tokenAddress,
1524 			TokenERC20(_tokenExchange.tokenAddress).name(),
1525 			TokenERC20(_tokenExchange.tokenAddress).symbol(),
1526 			_tokenExchange.price,
1527 			_tokenExchange.sentAmount,
1528 			_tokenExchange.receivedAmount,
1529 			_tokenExchange.extraData
1530 		);
1531 	}
1532 }
1533 
1534 
1535 /**
1536  * @title AOIon
1537  */
1538 contract AOIon is AOIonInterface {
1539 	using SafeMath for uint256;
1540 
1541 	address public aoIonLotAddress;
1542 	address public settingTAOId;
1543 	address public aoSettingAddress;
1544 	address public aoethAddress;
1545 
1546 	// AO Dev Team addresses to receive Primordial/Network Ions
1547 	address public aoDevTeam1 = 0x146CbD9821e6A42c8ff6DC903fe91CB69625A105;
1548 	address public aoDevTeam2 = 0x4810aF1dA3aC827259eEa72ef845F4206C703E8D;
1549 
1550 	IAOIonLot internal _aoIonLot;
1551 	IAOSetting internal _aoSetting;
1552 	AOETH internal _aoeth;
1553 
1554 	/***** PRIMORDIAL ION VARIABLES *****/
1555 	uint256 public primordialTotalSupply;
1556 	uint256 public primordialTotalBought;
1557 	uint256 public primordialSellPrice;
1558 	uint256 public primordialBuyPrice;
1559 	uint256 public totalEthForPrimordial;	// Total ETH sent for Primordial AO+
1560 	uint256 public totalRedeemedAOETH;		// Total AOETH redeemed for Primordial AO+
1561 
1562 	// Total available primordial ion for sale 3,377,699,720,527,872 AO+
1563 	uint256 constant public TOTAL_PRIMORDIAL_FOR_SALE = 3377699720527872;
1564 
1565 	mapping (address => uint256) public primordialBalanceOf;
1566 	mapping (address => mapping (address => uint256)) public primordialAllowance;
1567 
1568 	// Mapping from owner's lot weighted multiplier to the amount of staked ions
1569 	mapping (address => mapping (uint256 => uint256)) public primordialStakedBalance;
1570 
1571 	event PrimordialTransfer(address indexed from, address indexed to, uint256 value);
1572 	event PrimordialApproval(address indexed _owner, address indexed _spender, uint256 _value);
1573 	event PrimordialBurn(address indexed from, uint256 value);
1574 	event PrimordialStake(address indexed from, uint256 value, uint256 weightedMultiplier);
1575 	event PrimordialUnstake(address indexed from, uint256 value, uint256 weightedMultiplier);
1576 
1577 	event NetworkExchangeEnded();
1578 
1579 	bool public networkExchangeEnded;
1580 
1581 	// Mapping from owner to his/her current weighted multiplier
1582 	mapping (address => uint256) internal ownerWeightedMultiplier;
1583 
1584 	// Mapping from owner to his/her max multiplier (multiplier of account's first Lot)
1585 	mapping (address => uint256) internal ownerMaxMultiplier;
1586 
1587 	// Event to be broadcasted to public when user buys primordial ion
1588 	// payWith 1 == with Ethereum
1589 	// payWith 2 == with AOETH
1590 	event BuyPrimordial(address indexed lotOwner, bytes32 indexed lotId, uint8 payWith, uint256 sentAmount, uint256 refundedAmount);
1591 
1592 	/**
1593 	 * @dev Constructor function
1594 	 */
1595 	constructor(string memory _name, string memory _symbol, address _settingTAOId, address _aoSettingAddress, address _nameTAOPositionAddress, address _namePublicKeyAddress, address _nameAccountRecoveryAddress)
1596 		AOIonInterface(_name, _symbol, _nameTAOPositionAddress, _namePublicKeyAddress, _nameAccountRecoveryAddress) public {
1597 		setSettingTAOId(_settingTAOId);
1598 		setAOSettingAddress(_aoSettingAddress);
1599 
1600 		powerOfTen = 0;
1601 		decimals = 0;
1602 		setPrimordialPrices(0, 10 ** 8); // Set Primordial buy price to 0.1 gwei/ion
1603 	}
1604 
1605 	/**
1606 	 * @dev Checks if buyer can buy primordial ion
1607 	 */
1608 	modifier canBuyPrimordial(uint256 _sentAmount, bool _withETH) {
1609 		require (networkExchangeEnded == false &&
1610 			primordialTotalBought < TOTAL_PRIMORDIAL_FOR_SALE &&
1611 			primordialBuyPrice > 0 &&
1612 			_sentAmount > 0 &&
1613 			availablePrimordialForSaleInETH() > 0 &&
1614 			(
1615 				(_withETH && availableETH() > 0) ||
1616 				(!_withETH && totalRedeemedAOETH < _aoeth.totalSupply())
1617 			)
1618 		);
1619 		_;
1620 	}
1621 
1622 	/***** The AO ONLY METHODS *****/
1623 	/**
1624 	 * @dev The AO sets AOIonLot address
1625 	 * @param _aoIonLotAddress The address of AOIonLot
1626 	 */
1627 	function setAOIonLotAddress(address _aoIonLotAddress) public onlyTheAO {
1628 		require (_aoIonLotAddress != address(0));
1629 		aoIonLotAddress = _aoIonLotAddress;
1630 		_aoIonLot = IAOIonLot(_aoIonLotAddress);
1631 	}
1632 
1633 	/**
1634 	 * @dev The AO sets setting TAO ID
1635 	 * @param _settingTAOId The new setting TAO ID to set
1636 	 */
1637 	function setSettingTAOId(address _settingTAOId) public onlyTheAO {
1638 		require (AOLibrary.isTAO(_settingTAOId));
1639 		settingTAOId = _settingTAOId;
1640 	}
1641 
1642 	/**
1643 	 * @dev The AO sets AO Setting address
1644 	 * @param _aoSettingAddress The address of AOSetting
1645 	 */
1646 	function setAOSettingAddress(address _aoSettingAddress) public onlyTheAO {
1647 		require (_aoSettingAddress != address(0));
1648 		aoSettingAddress = _aoSettingAddress;
1649 		_aoSetting = IAOSetting(_aoSettingAddress);
1650 	}
1651 
1652 	/**
1653 	 * @dev Set AO Dev team addresses to receive Primordial/Network ions during network exchange
1654 	 * @param _aoDevTeam1 The first AO dev team address
1655 	 * @param _aoDevTeam2 The second AO dev team address
1656 	 */
1657 	function setAODevTeamAddresses(address _aoDevTeam1, address _aoDevTeam2) public onlyTheAO {
1658 		aoDevTeam1 = _aoDevTeam1;
1659 		aoDevTeam2 = _aoDevTeam2;
1660 	}
1661 
1662 	/**
1663 	 * @dev Set AOETH address
1664 	 * @param _aoethAddress The address of AOETH
1665 	 */
1666 	function setAOETHAddress(address _aoethAddress) public onlyTheAO {
1667 		require (_aoethAddress != address(0));
1668 		aoethAddress = _aoethAddress;
1669 		_aoeth = AOETH(_aoethAddress);
1670 	}
1671 
1672 	/***** PRIMORDIAL ION THE AO ONLY METHODS *****/
1673 	/**
1674 	 * @dev Allow users to buy Primordial ions for `newBuyPrice` eth and sell Primordial ions for `newSellPrice` eth
1675 	 * @param newPrimordialSellPrice Price users can sell to the contract
1676 	 * @param newPrimordialBuyPrice Price users can buy from the contract
1677 	 */
1678 	function setPrimordialPrices(uint256 newPrimordialSellPrice, uint256 newPrimordialBuyPrice) public onlyTheAO {
1679 		primordialSellPrice = newPrimordialSellPrice;
1680 		primordialBuyPrice = newPrimordialBuyPrice;
1681 	}
1682 
1683 	/**
1684 	 * @dev Only the AO can force end network exchange
1685 	 */
1686 	function endNetworkExchange() public onlyTheAO {
1687 		require (!networkExchangeEnded);
1688 		networkExchangeEnded = true;
1689 		emit NetworkExchangeEnded();
1690 	}
1691 
1692 	/***** PRIMORDIAL ION WHITELISTED ADDRESS ONLY METHODS *****/
1693 	/**
1694 	 * @dev Stake `_value` Primordial ions at `_weightedMultiplier ` multiplier on behalf of `_from`
1695 	 * @param _from The address of the target
1696 	 * @param _value The amount of Primordial ions to stake
1697 	 * @param _weightedMultiplier The weighted multiplier of the Primordial ions
1698 	 * @return true on success
1699 	 */
1700 	function stakePrimordialFrom(address _from, uint256 _value, uint256 _weightedMultiplier) public inWhitelist returns (bool) {
1701 		// Check if the targeted balance is enough
1702 		require (primordialBalanceOf[_from] >= _value);
1703 		// Make sure the weighted multiplier is the same as account's current weighted multiplier
1704 		require (_weightedMultiplier == ownerWeightedMultiplier[_from]);
1705 		// Subtract from the targeted balance
1706 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);
1707 		// Add to the targeted staked balance
1708 		primordialStakedBalance[_from][_weightedMultiplier] = primordialStakedBalance[_from][_weightedMultiplier].add(_value);
1709 		emit PrimordialStake(_from, _value, _weightedMultiplier);
1710 		return true;
1711 	}
1712 
1713 	/**
1714 	 * @dev Unstake `_value` Primordial ions at `_weightedMultiplier` on behalf of `_from`
1715 	 * @param _from The address of the target
1716 	 * @param _value The amount to unstake
1717 	 * @param _weightedMultiplier The weighted multiplier of the Primordial ions
1718 	 * @return true on success
1719 	 */
1720 	function unstakePrimordialFrom(address _from, uint256 _value, uint256 _weightedMultiplier) public inWhitelist returns (bool) {
1721 		// Check if the targeted staked balance is enough
1722 		require (primordialStakedBalance[_from][_weightedMultiplier] >= _value);
1723 		// Subtract from the targeted staked balance
1724 		primordialStakedBalance[_from][_weightedMultiplier] = primordialStakedBalance[_from][_weightedMultiplier].sub(_value);
1725 		// Add to the targeted balance
1726 		primordialBalanceOf[_from] = primordialBalanceOf[_from].add(_value);
1727 		emit PrimordialUnstake(_from, _value, _weightedMultiplier);
1728 		return true;
1729 	}
1730 
1731 	/**
1732 	 * @dev Send `_value` primordial ions to `_to` on behalf of `_from`
1733 	 * @param _from The address of the sender
1734 	 * @param _to The address of the recipient
1735 	 * @param _value The amount to send
1736 	 * @return true on success
1737 	 */
1738 	function whitelistTransferPrimordialFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool) {
1739 		return _createLotAndTransferPrimordial(_from, _to, _value);
1740 	}
1741 
1742 	/***** PUBLIC METHODS *****/
1743 	/***** PRIMORDIAL ION PUBLIC METHODS *****/
1744 	/**
1745 	 * @dev Buy Primordial ions from contract by sending ether
1746 	 */
1747 	function buyPrimordial() public payable canBuyPrimordial(msg.value, true) {
1748 		(uint256 amount, uint256 remainderBudget, bool shouldEndNetworkExchange) = _calculateAmountAndRemainderBudget(msg.value, true);
1749 		require (amount > 0);
1750 
1751 		// Ends network exchange if necessary
1752 		if (shouldEndNetworkExchange) {
1753 			networkExchangeEnded = true;
1754 			emit NetworkExchangeEnded();
1755 		}
1756 
1757 		// Update totalEthForPrimordial
1758 		totalEthForPrimordial = totalEthForPrimordial.add(msg.value.sub(remainderBudget));
1759 
1760 		// Send the primordial ion to buyer and reward AO devs
1761 		bytes32 _lotId = _sendPrimordialAndRewardDev(amount, msg.sender);
1762 
1763 		emit BuyPrimordial(msg.sender, _lotId, 1, msg.value, remainderBudget);
1764 
1765 		// Send remainder budget back to buyer if exist
1766 		if (remainderBudget > 0) {
1767 			msg.sender.transfer(remainderBudget);
1768 		}
1769 	}
1770 
1771 	/**
1772 	 * @dev Buy Primordial ion from contract by sending AOETH
1773 	 */
1774 	function buyPrimordialWithAOETH(uint256 _aoethAmount) public canBuyPrimordial(_aoethAmount, false) {
1775 		(uint256 amount, uint256 remainderBudget, bool shouldEndNetworkExchange) = _calculateAmountAndRemainderBudget(_aoethAmount, false);
1776 		require (amount > 0);
1777 
1778 		// Ends network exchange if necessary
1779 		if (shouldEndNetworkExchange) {
1780 			networkExchangeEnded = true;
1781 			emit NetworkExchangeEnded();
1782 		}
1783 
1784 		// Calculate the actual AOETH that was charged for this transaction
1785 		uint256 actualCharge = _aoethAmount.sub(remainderBudget);
1786 
1787 		// Update totalRedeemedAOETH
1788 		totalRedeemedAOETH = totalRedeemedAOETH.add(actualCharge);
1789 
1790 		// Transfer AOETH from buyer to here
1791 		require (_aoeth.whitelistTransferFrom(msg.sender, address(this), actualCharge));
1792 
1793 		// Send the primordial ion to buyer and reward AO devs
1794 		bytes32 _lotId = _sendPrimordialAndRewardDev(amount, msg.sender);
1795 
1796 		emit BuyPrimordial(msg.sender, _lotId, 2, _aoethAmount, remainderBudget);
1797 	}
1798 
1799 	/**
1800 	 * @dev Send `_value` Primordial ions to `_to` from your account
1801 	 * @param _to The address of the recipient
1802 	 * @param _value The amount to send
1803 	 * @return true on success
1804 	 */
1805 	function transferPrimordial(address _to, uint256 _value) public returns (bool) {
1806 		return _createLotAndTransferPrimordial(msg.sender, _to, _value);
1807 	}
1808 
1809 	/**
1810 	 * @dev Send `_value` Primordial ions to `_to` from `_from`
1811 	 * @param _from The address of the sender
1812 	 * @param _to The address of the recipient
1813 	 * @param _value The amount to send
1814 	 * @return true on success
1815 	 */
1816 	function transferPrimordialFrom(address _from, address _to, uint256 _value) public returns (bool) {
1817 		require (_value <= primordialAllowance[_from][msg.sender]);
1818 		primordialAllowance[_from][msg.sender] = primordialAllowance[_from][msg.sender].sub(_value);
1819 
1820 		return _createLotAndTransferPrimordial(_from, _to, _value);
1821 	}
1822 
1823 	/**
1824 	 * Transfer primordial ions between public key addresses in a Name
1825 	 * @param _nameId The ID of the Name
1826 	 * @param _from The address of the sender
1827 	 * @param _to The address of the recipient
1828 	 * @param _value the amount to send
1829 	 */
1830 	function transferPrimordialBetweenPublicKeys(address _nameId, address _from, address _to, uint256 _value) public returns (bool) {
1831 		require (AOLibrary.isName(_nameId));
1832 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _nameId));
1833 		require (!_nameAccountRecovery.isCompromised(_nameId));
1834 		// Make sure _from exist in the Name's Public Keys
1835 		require (_namePublicKey.isKeyExist(_nameId, _from));
1836 		// Make sure _to exist in the Name's Public Keys
1837 		require (_namePublicKey.isKeyExist(_nameId, _to));
1838 		return _createLotAndTransferPrimordial(_from, _to, _value);
1839 	}
1840 
1841 	/**
1842 	 * @dev Allows `_spender` to spend no more than `_value` Primordial ions in your behalf
1843 	 * @param _spender The address authorized to spend
1844 	 * @param _value The max amount they can spend
1845 	 * @return true on success
1846 	 */
1847 	function approvePrimordial(address _spender, uint256 _value) public returns (bool) {
1848 		primordialAllowance[msg.sender][_spender] = _value;
1849 		emit PrimordialApproval(msg.sender, _spender, _value);
1850 		return true;
1851 	}
1852 
1853 	/**
1854 	 * @dev Allows `_spender` to spend no more than `_value` Primordial ions in your behalf, and then ping the contract about it
1855 	 * @param _spender The address authorized to spend
1856 	 * @param _value The max amount they can spend
1857 	 * @param _extraData some extra information to send to the approved contract
1858 	 * @return true on success
1859 	 */
1860 	function approvePrimordialAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool) {
1861 		tokenRecipient spender = tokenRecipient(_spender);
1862 		if (approvePrimordial(_spender, _value)) {
1863 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
1864 			return true;
1865 		}
1866 	}
1867 
1868 	/**
1869 	 * @dev Remove `_value` Primordial ions from the system irreversibly
1870 	 *		and re-weight the account's multiplier after burn
1871 	 * @param _value The amount to burn
1872 	 * @return true on success
1873 	 */
1874 	function burnPrimordial(uint256 _value) public returns (bool) {
1875 		require (primordialBalanceOf[msg.sender] >= _value);
1876 		require (calculateMaximumBurnAmount(msg.sender) >= _value);
1877 
1878 		// Update the account's multiplier
1879 		ownerWeightedMultiplier[msg.sender] = calculateMultiplierAfterBurn(msg.sender, _value);
1880 		primordialBalanceOf[msg.sender] = primordialBalanceOf[msg.sender].sub(_value);
1881 		primordialTotalSupply = primordialTotalSupply.sub(_value);
1882 
1883 		// Store burn lot info
1884 		require (_aoIonLot.createBurnLot(msg.sender, _value, ownerWeightedMultiplier[msg.sender]));
1885 		emit PrimordialBurn(msg.sender, _value);
1886 		return true;
1887 	}
1888 
1889 	/**
1890 	 * @dev Remove `_value` Primordial ions from the system irreversibly on behalf of `_from`
1891 	 *		and re-weight `_from`'s multiplier after burn
1892 	 * @param _from The address of sender
1893 	 * @param _value The amount to burn
1894 	 * @return true on success
1895 	 */
1896 	function burnPrimordialFrom(address _from, uint256 _value) public returns (bool) {
1897 		require (primordialBalanceOf[_from] >= _value);
1898 		require (primordialAllowance[_from][msg.sender] >= _value);
1899 		require (calculateMaximumBurnAmount(_from) >= _value);
1900 
1901 		// Update `_from`'s multiplier
1902 		ownerWeightedMultiplier[_from] = calculateMultiplierAfterBurn(_from, _value);
1903 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);
1904 		primordialAllowance[_from][msg.sender] = primordialAllowance[_from][msg.sender].sub(_value);
1905 		primordialTotalSupply = primordialTotalSupply.sub(_value);
1906 
1907 		// Store burn lot info
1908 		require (_aoIonLot.createBurnLot(_from, _value, ownerWeightedMultiplier[_from]));
1909 		emit PrimordialBurn(_from, _value);
1910 		return true;
1911 	}
1912 
1913 	/**
1914 	 * @dev Return the average weighted multiplier of all lots owned by an address
1915 	 * @param _lotOwner The address of the lot owner
1916 	 * @return the weighted multiplier of the address (in 10 ** 6)
1917 	 */
1918 	function weightedMultiplierByAddress(address _lotOwner) public view returns (uint256) {
1919 		return ownerWeightedMultiplier[_lotOwner];
1920 	}
1921 
1922 	/**
1923 	 * @dev Return the max multiplier of an address
1924 	 * @param _target The address to query
1925 	 * @return the max multiplier of the address (in 10 ** 6)
1926 	 */
1927 	function maxMultiplierByAddress(address _target) public view returns (uint256) {
1928 		return (_aoIonLot.totalLotsByAddress(_target) > 0) ? ownerMaxMultiplier[_target] : 0;
1929 	}
1930 
1931 	/**
1932 	 * @dev Calculate the primordial ion multiplier, bonus network ion percentage, and the
1933 	 *		bonus network ion amount on a given lot when someone purchases primordial ion
1934 	 *		during network exchange
1935 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
1936 	 * @return The multiplier in (10 ** 6)
1937 	 * @return The bonus percentage
1938 	 * @return The amount of network ion as bonus
1939 	 */
1940 	function calculateMultiplierAndBonus(uint256 _purchaseAmount) public view returns (uint256, uint256, uint256) {
1941 		(uint256 startingPrimordialMultiplier, uint256 endingPrimordialMultiplier, uint256 startingNetworkBonusMultiplier, uint256 endingNetworkBonusMultiplier) = _getSettingVariables();
1942 		return (
1943 			AOLibrary.calculatePrimordialMultiplier(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingPrimordialMultiplier, endingPrimordialMultiplier),
1944 			AOLibrary.calculateNetworkBonusPercentage(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier),
1945 			AOLibrary.calculateNetworkBonusAmount(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier)
1946 		);
1947 	}
1948 
1949 	/**
1950 	 * @dev Calculate the maximum amount of Primordial an account can burn
1951 	 * @param _account The address of the account
1952 	 * @return The maximum primordial ion amount to burn
1953 	 */
1954 	function calculateMaximumBurnAmount(address _account) public view returns (uint256) {
1955 		return AOLibrary.calculateMaximumBurnAmount(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], ownerMaxMultiplier[_account]);
1956 	}
1957 
1958 	/**
1959 	 * @dev Calculate account's new multiplier after burn `_amountToBurn` primordial ions
1960 	 * @param _account The address of the account
1961 	 * @param _amountToBurn The amount of primordial ion to burn
1962 	 * @return The new multiplier in (10 ** 6)
1963 	 */
1964 	function calculateMultiplierAfterBurn(address _account, uint256 _amountToBurn) public view returns (uint256) {
1965 		require (calculateMaximumBurnAmount(_account) >= _amountToBurn);
1966 		return AOLibrary.calculateMultiplierAfterBurn(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], _amountToBurn);
1967 	}
1968 
1969 	/**
1970 	 * @dev Calculate account's new multiplier after converting `amountToConvert` network ion to primordial ion
1971 	 * @param _account The address of the account
1972 	 * @param _amountToConvert The amount of network ion to convert
1973 	 * @return The new multiplier in (10 ** 6)
1974 	 */
1975 	function calculateMultiplierAfterConversion(address _account, uint256 _amountToConvert) public view returns (uint256) {
1976 		return AOLibrary.calculateMultiplierAfterConversion(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], _amountToConvert);
1977 	}
1978 
1979 	/**
1980 	 * @dev Convert `_value` of network ions to primordial ions
1981 	 *		and re-weight the account's multiplier after conversion
1982 	 * @param _value The amount to convert
1983 	 * @return true on success
1984 	 */
1985 	function convertToPrimordial(uint256 _value) public returns (bool) {
1986 		require (balanceOf[msg.sender] >= _value);
1987 
1988 		// Update the account's multiplier
1989 		ownerWeightedMultiplier[msg.sender] = calculateMultiplierAfterConversion(msg.sender, _value);
1990 		// Burn network ion
1991 		burn(_value);
1992 		// mint primordial ion
1993 		_mintPrimordial(msg.sender, _value);
1994 
1995 		require (_aoIonLot.createConvertLot(msg.sender, _value, ownerWeightedMultiplier[msg.sender]));
1996 		return true;
1997 	}
1998 
1999 	/**
2000 	 * @dev Get quantity of AO+ left in Network Exchange
2001 	 * @return The quantity of AO+ left in Network Exchange
2002 	 */
2003 	function availablePrimordialForSale() public view returns (uint256) {
2004 		return TOTAL_PRIMORDIAL_FOR_SALE.sub(primordialTotalBought);
2005 	}
2006 
2007 	/**
2008 	 * @dev Get quantity of AO+ in ETH left in Network Exchange (i.e How much ETH is there total that can be
2009 	 *		exchanged for AO+
2010 	 * @return The quantity of AO+ in ETH left in Network Exchange
2011 	 */
2012 	function availablePrimordialForSaleInETH() public view returns (uint256) {
2013 		return availablePrimordialForSale().mul(primordialBuyPrice);
2014 	}
2015 
2016 	/**
2017 	 * @dev Get maximum quantity of AOETH or ETH that can still be sold
2018 	 * @return The maximum quantity of AOETH or ETH that can still be sold
2019 	 */
2020 	function availableETH() public view returns (uint256) {
2021 		if (availablePrimordialForSaleInETH() > 0) {
2022 			uint256 _availableETH = availablePrimordialForSaleInETH().sub(_aoeth.totalSupply().sub(totalRedeemedAOETH));
2023 			if (availablePrimordialForSale() == 1 && _availableETH < primordialBuyPrice) {
2024 				return primordialBuyPrice;
2025 			} else {
2026 				return _availableETH;
2027 			}
2028 		} else {
2029 			return 0;
2030 		}
2031 	}
2032 
2033 	/***** INTERNAL METHODS *****/
2034 	/***** PRIMORDIAL ION INTERNAL METHODS *****/
2035 	/**
2036 	 * @dev Calculate the amount of ion the buyer will receive and remaining budget if exist
2037 	 *		when he/she buys primordial ion
2038 	 * @param _budget The amount of ETH sent by buyer
2039 	 * @param _withETH Whether or not buyer is paying with ETH
2040 	 * @return uint256 of the amount the buyer will receiver
2041 	 * @return uint256 of the remaining budget, if exist
2042 	 * @return bool whether or not the network exchange should end
2043 	 */
2044 	function _calculateAmountAndRemainderBudget(uint256 _budget, bool _withETH) internal view returns (uint256, uint256, bool) {
2045 		// Calculate the amount of ion
2046 		uint256 amount = _budget.div(primordialBuyPrice);
2047 
2048 		// If we need to return ETH to the buyer, in the case
2049 		// where the buyer sends more ETH than available primordial ion to be purchased
2050 		uint256 remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
2051 
2052 		uint256 _availableETH = availableETH();
2053 		// If paying with ETH, it can't exceed availableETH
2054 		if (_withETH && _budget > availableETH()) {
2055 			// Calculate the amount of ions
2056 			amount = _availableETH.div(primordialBuyPrice);
2057 			remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
2058 		}
2059 
2060 		// Make sure primordialTotalBought is not overflowing
2061 		bool shouldEndNetworkExchange = false;
2062 		if (primordialTotalBought.add(amount) >= TOTAL_PRIMORDIAL_FOR_SALE) {
2063 			amount = TOTAL_PRIMORDIAL_FOR_SALE.sub(primordialTotalBought);
2064 			shouldEndNetworkExchange = true;
2065 			remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
2066 		}
2067 		return (amount, remainderEth, shouldEndNetworkExchange);
2068 	}
2069 
2070 	/**
2071 	 * @dev Actually sending the primordial ion to buyer and reward AO devs accordingly
2072 	 * @param amount The amount of primordial ion to be sent to buyer
2073 	 * @param to The recipient of ion
2074 	 * @return the lot Id of the buyer
2075 	 */
2076 	function _sendPrimordialAndRewardDev(uint256 amount, address to) internal returns (bytes32) {
2077 		(uint256 startingPrimordialMultiplier,, uint256 startingNetworkBonusMultiplier, uint256 endingNetworkBonusMultiplier) = _getSettingVariables();
2078 
2079 		// Update primordialTotalBought
2080 		(uint256 multiplier, uint256 networkBonusPercentage, uint256 networkBonusAmount) = calculateMultiplierAndBonus(amount);
2081 		primordialTotalBought = primordialTotalBought.add(amount);
2082 		bytes32 _lotId = _createPrimordialLot(to, amount, multiplier, networkBonusAmount);
2083 
2084 		// Calculate The AO and AO Dev Team's portion of Primordial and Network ion Bonus
2085 		uint256 inverseMultiplier = startingPrimordialMultiplier.sub(multiplier); // Inverse of the buyer's multiplier
2086 		uint256 theAONetworkBonusAmount = (startingNetworkBonusMultiplier.sub(networkBonusPercentage).add(endingNetworkBonusMultiplier)).mul(amount).div(AOLibrary.PERCENTAGE_DIVISOR());
2087 		if (aoDevTeam1 != address(0)) {
2088 			_createPrimordialLot(aoDevTeam1, amount.div(2), inverseMultiplier, theAONetworkBonusAmount.div(2));
2089 		}
2090 		if (aoDevTeam2 != address(0)) {
2091 			_createPrimordialLot(aoDevTeam2, amount.div(2), inverseMultiplier, theAONetworkBonusAmount.div(2));
2092 		}
2093 		_mint(theAO, theAONetworkBonusAmount);
2094 		return _lotId;
2095 	}
2096 
2097 	/**
2098 	 * @dev Create a lot with `primordialAmount` of primordial ions with `_multiplier` for an `account`
2099 	 *		during network exchange, and reward `_networkBonusAmount` if exist
2100 	 * @param _account Address of the lot owner
2101 	 * @param _primordialAmount The amount of primordial ions to be stored in the lot
2102 	 * @param _multiplier The multiplier for this lot in (10 ** 6)
2103 	 * @param _networkBonusAmount The network ion bonus amount
2104 	 * @return Created lot Id
2105 	 */
2106 	function _createPrimordialLot(address _account, uint256 _primordialAmount, uint256 _multiplier, uint256 _networkBonusAmount) internal returns (bytes32) {
2107 		bytes32 lotId = _aoIonLot.createPrimordialLot(_account, _primordialAmount, _multiplier, _networkBonusAmount);
2108 
2109 		ownerWeightedMultiplier[_account] = AOLibrary.calculateWeightedMultiplier(ownerWeightedMultiplier[_account], primordialBalanceOf[_account], _multiplier, _primordialAmount);
2110 
2111 		// If this is the first lot, set this as the max multiplier of the account
2112 		if (_aoIonLot.totalLotsByAddress(_account) == 1) {
2113 			ownerMaxMultiplier[_account] = _multiplier;
2114 		}
2115 		_mintPrimordial(_account, _primordialAmount);
2116 		_mint(_account, _networkBonusAmount);
2117 
2118 		return lotId;
2119 	}
2120 
2121 	/**
2122 	 * @dev Create `mintedAmount` Primordial ions and send it to `target`
2123 	 * @param target Address to receive the Primordial ions
2124 	 * @param mintedAmount The amount of Primordial ions it will receive
2125 	 */
2126 	function _mintPrimordial(address target, uint256 mintedAmount) internal {
2127 		primordialBalanceOf[target] = primordialBalanceOf[target].add(mintedAmount);
2128 		primordialTotalSupply = primordialTotalSupply.add(mintedAmount);
2129 		emit PrimordialTransfer(address(0), address(this), mintedAmount);
2130 		emit PrimordialTransfer(address(this), target, mintedAmount);
2131 	}
2132 
2133 	/**
2134 	 * @dev Create a lot with `amount` of ions at `weightedMultiplier` for an `account`
2135 	 * @param _account Address of lot owner
2136 	 * @param _amount The amount of ions
2137 	 * @param _weightedMultiplier The multiplier of the lot (in 10^6)
2138 	 * @return bytes32 of new created lot ID
2139 	 */
2140 	function _createWeightedMultiplierLot(address _account, uint256 _amount, uint256 _weightedMultiplier) internal returns (bytes32) {
2141 		require (_account != address(0));
2142 		require (_amount > 0);
2143 
2144 		bytes32 lotId = _aoIonLot.createWeightedMultiplierLot(_account, _amount, _weightedMultiplier);
2145 		// If this is the first lot, set this as the max multiplier of the account
2146 		if (_aoIonLot.totalLotsByAddress(_account) == 1) {
2147 			ownerMaxMultiplier[_account] = _weightedMultiplier;
2148 		}
2149 		return lotId;
2150 	}
2151 
2152 	/**
2153 	 * @dev Create Lot and send `_value` Primordial ions from `_from` to `_to`
2154 	 * @param _from The address of sender
2155 	 * @param _to The address of the recipient
2156 	 * @param _value The amount to send
2157 	 * @return true on success
2158 	 */
2159 	function _createLotAndTransferPrimordial(address _from, address _to, uint256 _value) internal returns (bool) {
2160 		bytes32 _createdLotId = _createWeightedMultiplierLot(_to, _value, ownerWeightedMultiplier[_from]);
2161 		(, address _lotOwner,,) = _aoIonLot.lotById(_createdLotId);
2162 
2163 		// Make sure the new lot is created successfully
2164 		require (_lotOwner == _to);
2165 
2166 		// Update the weighted multiplier of the recipient
2167 		ownerWeightedMultiplier[_to] = AOLibrary.calculateWeightedMultiplier(ownerWeightedMultiplier[_to], primordialBalanceOf[_to], ownerWeightedMultiplier[_from], _value);
2168 
2169 		// Transfer the Primordial ions
2170 		require (_transferPrimordial(_from, _to, _value));
2171 		return true;
2172 	}
2173 
2174 	/**
2175 	 * @dev Send `_value` Primordial ions from `_from` to `_to`
2176 	 * @param _from The address of sender
2177 	 * @param _to The address of the recipient
2178 	 * @param _value The amount to send
2179 	 */
2180 	function _transferPrimordial(address _from, address _to, uint256 _value) internal returns (bool) {
2181 		require (_to != address(0));									// Prevent transfer to 0x0 address. Use burn() instead
2182 		require (primordialBalanceOf[_from] >= _value);						// Check if the sender has enough
2183 		require (primordialBalanceOf[_to].add(_value) >= primordialBalanceOf[_to]);	// Check for overflows
2184 		require (!frozenAccount[_from]);								// Check if sender is frozen
2185 		require (!frozenAccount[_to]);									// Check if recipient is frozen
2186 		uint256 previousBalances = primordialBalanceOf[_from].add(primordialBalanceOf[_to]);
2187 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);			// Subtract from the sender
2188 		primordialBalanceOf[_to] = primordialBalanceOf[_to].add(_value);				// Add the same to the recipient
2189 		emit PrimordialTransfer(_from, _to, _value);
2190 		assert(primordialBalanceOf[_from].add(primordialBalanceOf[_to]) == previousBalances);
2191 		return true;
2192 	}
2193 
2194 	/**
2195 	 * @dev Get setting variables
2196 	 * @return startingPrimordialMultiplier The starting multiplier used to calculate primordial ion
2197 	 * @return endingPrimordialMultiplier The ending multiplier used to calculate primordial ion
2198 	 * @return startingNetworkBonusMultiplier The starting multiplier used to calculate network ion bonus
2199 	 * @return endingNetworkBonusMultiplier The ending multiplier used to calculate network ion bonus
2200 	 */
2201 	function _getSettingVariables() internal view returns (uint256, uint256, uint256, uint256) {
2202 		(uint256 startingPrimordialMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'startingPrimordialMultiplier');
2203 		(uint256 endingPrimordialMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'endingPrimordialMultiplier');
2204 
2205 		(uint256 startingNetworkBonusMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'startingNetworkBonusMultiplier');
2206 		(uint256 endingNetworkBonusMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'endingNetworkBonusMultiplier');
2207 
2208 		return (startingPrimordialMultiplier, endingPrimordialMultiplier, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier);
2209 	}
2210 }
2211 
2212 
2213 
2214 
2215 
2216 
2217 /**
2218  * @title AOStakedContent
2219  */
2220 contract AOStakedContent is TheAO, IAOStakedContent {
2221 	using SafeMath for uint256;
2222 
2223 	uint256 public totalStakedContents;
2224 	address public aoIonAddress;
2225 	address public aoTreasuryAddress;
2226 	address public aoContentAddress;
2227 	address public nameFactoryAddress;
2228 	address public namePublicKeyAddress;
2229 
2230 	AOIon internal _aoIon;
2231 	IAOTreasury internal _aoTreasury;
2232 	IAOContent internal _aoContent;
2233 	INameFactory internal _nameFactory;
2234 	INamePublicKey internal _namePublicKey;
2235 
2236 	struct StakedContent {
2237 		bytes32 stakedContentId;
2238 		bytes32 contentId;
2239 		address stakeOwner;
2240 		uint256 networkAmount;		// total network ion staked in base denomination
2241 		uint256 primordialAmount;	// the amount of primordial AOIon to stake (always in base denomination)
2242 		uint256 primordialWeightedMultiplier;
2243 		uint256 profitPercentage;	// support up to 4 decimals, 100% = 1000000
2244 		bool active;	// true if currently staked, false when unstaked
2245 		uint256 createdOnTimestamp;
2246 	}
2247 
2248 	// Mapping from StakedContent index to the StakedContent object
2249 	mapping (uint256 => StakedContent) internal stakedContents;
2250 
2251 	// Mapping from StakedContent ID to index of the stakedContents list
2252 	mapping (bytes32 => uint256) internal stakedContentIndex;
2253 
2254 	// Event to be broadcasted to public when `stakeOwner` stakes a new content
2255 	event StakeContent(
2256 		address indexed stakeOwner,
2257 		bytes32 indexed stakedContentId,
2258 		bytes32 indexed contentId,
2259 		uint256 baseNetworkAmount,
2260 		uint256 primordialAmount,
2261 		uint256 primordialWeightedMultiplier,
2262 		uint256 profitPercentage,
2263 		uint256 createdOnTimestamp
2264 	);
2265 
2266 	// Event to be broadcasted to public when `stakeOwner` updates the staked content's profit percentage
2267 	event SetProfitPercentage(address indexed stakeOwner, bytes32 indexed stakedContentId, uint256 newProfitPercentage);
2268 
2269 	// Event to be broadcasted to public when `stakeOwner` unstakes some network/primordial ion from an existing content
2270 	event UnstakePartialContent(
2271 		address indexed stakeOwner,
2272 		bytes32 indexed stakedContentId,
2273 		bytes32 indexed contentId,
2274 		uint256 remainingNetworkAmount,
2275 		uint256 remainingPrimordialAmount,
2276 		uint256 primordialWeightedMultiplier
2277 	);
2278 
2279 	// Event to be broadcasted to public when `stakeOwner` unstakes all ion amount on an existing content
2280 	event UnstakeContent(address indexed stakeOwner, bytes32 indexed stakedContentId);
2281 
2282 	// Event to be broadcasted to public when `stakeOwner` re-stakes an existing content
2283 	event StakeExistingContent(
2284 		address indexed stakeOwner,
2285 		bytes32 indexed stakedContentId,
2286 		bytes32 indexed contentId,
2287 		uint256 currentNetworkAmount,
2288 		uint256 currentPrimordialAmount,
2289 		uint256 currentPrimordialWeightedMultiplier
2290 	);
2291 
2292 	/**
2293 	 * @dev Constructor function
2294 	 * @param _aoIonAddress The address of AOIon
2295 	 * @param _aoTreasuryAddress The address of AOTreasury
2296 	 * @param _aoContentAddress The address of AOContent
2297 	 * @param _nameFactoryAddress The address of NameFactory
2298 	 * @param _namePublicKeyAddress The address of NamePublicKey
2299 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
2300 	 */
2301 	constructor(address _aoIonAddress, address _aoTreasuryAddress, address _aoContentAddress, address _nameFactoryAddress, address _namePublicKeyAddress, address _nameTAOPositionAddress) public {
2302 		setAOIonAddress(_aoIonAddress);
2303 		setAOTreasuryAddress(_aoTreasuryAddress);
2304 		setAOContentAddress(_aoContentAddress);
2305 		setNameFactoryAddress(_nameFactoryAddress);
2306 		setNamePublicKeyAddress(_namePublicKeyAddress);
2307 		setNameTAOPositionAddress(_nameTAOPositionAddress);
2308 	}
2309 
2310 	/**
2311 	 * @dev Checks if the calling contract address is The AO
2312 	 *		OR
2313 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
2314 	 */
2315 	modifier onlyTheAO {
2316 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
2317 		_;
2318 	}
2319 
2320 	/***** The AO ONLY METHODS *****/
2321 	/**
2322 	 * @dev Transfer ownership of The AO to new address
2323 	 * @param _theAO The new address to be transferred
2324 	 */
2325 	function transferOwnership(address _theAO) public onlyTheAO {
2326 		require (_theAO != address(0));
2327 		theAO = _theAO;
2328 	}
2329 
2330 	/**
2331 	 * @dev Whitelist `_account` address to transact on behalf of others
2332 	 * @param _account The address to whitelist
2333 	 * @param _whitelist Either to whitelist or not
2334 	 */
2335 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
2336 		require (_account != address(0));
2337 		whitelist[_account] = _whitelist;
2338 	}
2339 
2340 	/**
2341 	 * @dev The AO sets AOIon address
2342 	 * @param _aoIonAddress The address of AOIon
2343 	 */
2344 	function setAOIonAddress(address _aoIonAddress) public onlyTheAO {
2345 		require (_aoIonAddress != address(0));
2346 		aoIonAddress = _aoIonAddress;
2347 		_aoIon = AOIon(_aoIonAddress);
2348 	}
2349 
2350 	/**
2351 	 * @dev The AO sets AOTreasury address
2352 	 * @param _aoTreasuryAddress The address of AOTreasury
2353 	 */
2354 	function setAOTreasuryAddress(address _aoTreasuryAddress) public onlyTheAO {
2355 		require (_aoTreasuryAddress != address(0));
2356 		aoTreasuryAddress = _aoTreasuryAddress;
2357 		_aoTreasury = IAOTreasury(_aoTreasuryAddress);
2358 	}
2359 
2360 	/**
2361 	 * @dev The AO sets AO Content address
2362 	 * @param _aoContentAddress The address of AOContent
2363 	 */
2364 	function setAOContentAddress(address _aoContentAddress) public onlyTheAO {
2365 		require (_aoContentAddress != address(0));
2366 		aoContentAddress = _aoContentAddress;
2367 		_aoContent = IAOContent(_aoContentAddress);
2368 	}
2369 
2370 	/**
2371 	 * @dev The AO sets NameFactory address
2372 	 * @param _nameFactoryAddress The address of NameFactory
2373 	 */
2374 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
2375 		require (_nameFactoryAddress != address(0));
2376 		nameFactoryAddress = _nameFactoryAddress;
2377 		_nameFactory = INameFactory(_nameFactoryAddress);
2378 	}
2379 
2380 	/**
2381 	 * @dev The AO sets NamePublicKey address
2382 	 * @param _namePublicKeyAddress The address of NamePublicKey
2383 	 */
2384 	function setNamePublicKeyAddress(address _namePublicKeyAddress) public onlyTheAO {
2385 		require (_namePublicKeyAddress != address(0));
2386 		namePublicKeyAddress = _namePublicKeyAddress;
2387 		_namePublicKey = INamePublicKey(_namePublicKeyAddress);
2388 	}
2389 
2390 	/**
2391 	 * @dev The AO sets NameTAOPosition address
2392 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
2393 	 */
2394 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
2395 		require (_nameTAOPositionAddress != address(0));
2396 		nameTAOPositionAddress = _nameTAOPositionAddress;
2397 	}
2398 
2399 	/***** PUBLIC METHODS *****/
2400 	/**
2401 	 * @dev Stake the content
2402 	 * @param _stakeOwner the address that stake the content
2403 	 * @param _contentId The ID of the content
2404 	 * @param _networkIntegerAmount The integer amount of network ion to stake
2405 	 * @param _networkFractionAmount The fraction amount of network ion to stake
2406 	 * @param _denomination The denomination of the network ion, i.e ao, kilo, mega, etc.
2407 	 * @param _primordialAmount The amount of primordial ion to stake
2408 	 * @param _profitPercentage The percentage of profit the stake owner's media will charge
2409 	 * @return the newly created staked content ID
2410 	 */
2411 	function create(address _stakeOwner,
2412 		bytes32 _contentId,
2413 		uint256 _networkIntegerAmount,
2414 		uint256 _networkFractionAmount,
2415 		bytes8 _denomination,
2416 		uint256 _primordialAmount,
2417 		uint256 _profitPercentage
2418 		) external inWhitelist returns (bytes32) {
2419 		require (_canCreate(_stakeOwner, _contentId, _networkIntegerAmount, _networkFractionAmount, _denomination, _primordialAmount, _profitPercentage));
2420 		// Increment totalStakedContents
2421 		totalStakedContents++;
2422 
2423 		// Generate stakedContentId
2424 		bytes32 _stakedContentId = keccak256(abi.encodePacked(this, _stakeOwner, _contentId));
2425 		StakedContent storage _stakedContent = stakedContents[totalStakedContents];
2426 
2427 		// Make sure the node doesn't stake the same content twice
2428 		require (_stakedContent.stakeOwner == address(0));
2429 
2430 		_stakedContent.stakedContentId = _stakedContentId;
2431 		_stakedContent.contentId = _contentId;
2432 		_stakedContent.stakeOwner = _stakeOwner;
2433 		_stakedContent.profitPercentage = _profitPercentage;
2434 		_stakedContent.active = true;
2435 		_stakedContent.createdOnTimestamp = now;
2436 
2437 		if (_aoTreasury.isDenominationExist(_denomination) && (_networkIntegerAmount > 0 || _networkFractionAmount > 0)) {
2438 			_stakedContent.networkAmount = _aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination);
2439 			require (_aoIon.stakeFrom(_namePublicKey.getDefaultKey(_stakeOwner), _stakedContent.networkAmount));
2440 		}
2441 		if (_primordialAmount > 0) {
2442 			_stakedContent.primordialAmount = _primordialAmount;
2443 
2444 			// Primordial ion is the base AO ion
2445 			_stakedContent.primordialWeightedMultiplier = _aoIon.weightedMultiplierByAddress(_namePublicKey.getDefaultKey(_stakedContent.stakeOwner));
2446 			require (_aoIon.stakePrimordialFrom(_namePublicKey.getDefaultKey(_stakedContent.stakeOwner), _primordialAmount, _stakedContent.primordialWeightedMultiplier));
2447 		}
2448 
2449 		stakedContentIndex[_stakedContentId] = totalStakedContents;
2450 
2451 		emit StakeContent(_stakedContent.stakeOwner, _stakedContent.stakedContentId, _stakedContent.contentId, _stakedContent.networkAmount, _stakedContent.primordialAmount, _stakedContent.primordialWeightedMultiplier, _stakedContent.profitPercentage, _stakedContent.createdOnTimestamp);
2452 		return _stakedContent.stakedContentId;
2453 	}
2454 
2455 	/**
2456 	 * @dev Set profit percentage on existing staked content
2457 	 *		Will throw error if this is a Creative Commons/T(AO) Content
2458 	 * @param _stakedContentId The ID of the staked content
2459 	 * @param _profitPercentage The new value to be set
2460 	 */
2461 	function setProfitPercentage(bytes32 _stakedContentId, uint256 _profitPercentage) public {
2462 		require (_profitPercentage <= AOLibrary.PERCENTAGE_DIVISOR());
2463 
2464 		// Make sure the staked content exist
2465 		require (stakedContentIndex[_stakedContentId] > 0);
2466 
2467 		address _stakeOwnerNameId = _nameFactory.ethAddressToNameId(msg.sender);
2468 		require (_stakeOwnerNameId != address(0));
2469 
2470 		StakedContent storage _stakedContent = stakedContents[stakedContentIndex[_stakedContentId]];
2471 		// Make sure the staked content owner is the same as the sender
2472 		require (_stakedContent.stakeOwner == _stakeOwnerNameId);
2473 
2474 		// Make sure we are updating profit percentage for AO Content only
2475 		// Creative Commons/T(AO) Content has 0 profit percentage
2476 		require (_aoContent.isAOContentUsageType(_stakedContent.contentId));
2477 
2478 		_stakedContent.profitPercentage = _profitPercentage;
2479 
2480 		emit SetProfitPercentage(_stakeOwnerNameId, _stakedContentId, _profitPercentage);
2481 	}
2482 
2483 	/**
2484 	 * @dev Return staked content information at a given ID
2485 	 * @param _stakedContentId The ID of the staked content
2486 	 * @return The ID of the content being staked
2487 	 * @return address of the staked content's owner
2488 	 * @return the network base ion amount staked for this content
2489 	 * @return the primordial ion amount staked for this content
2490 	 * @return the primordial weighted multiplier of the staked content
2491 	 * @return the profit percentage of the content
2492 	 * @return status of the staked content
2493 	 * @return the timestamp when the staked content was created
2494 	 */
2495 	function getById(bytes32 _stakedContentId) external view returns (bytes32, address, uint256, uint256, uint256, uint256, bool, uint256) {
2496 		// Make sure the staked content exist
2497 		require (stakedContentIndex[_stakedContentId] > 0);
2498 
2499 		StakedContent memory _stakedContent = stakedContents[stakedContentIndex[_stakedContentId]];
2500 		return (
2501 			_stakedContent.contentId,
2502 			_stakedContent.stakeOwner,
2503 			_stakedContent.networkAmount,
2504 			_stakedContent.primordialAmount,
2505 			_stakedContent.primordialWeightedMultiplier,
2506 			_stakedContent.profitPercentage,
2507 			_stakedContent.active,
2508 			_stakedContent.createdOnTimestamp
2509 		);
2510 	}
2511 
2512 	/**
2513 	 * @dev Unstake existing staked content and refund partial staked amount to the stake owner
2514 	 *		Use unstakeContent() to unstake all staked ion amount. unstakePartialContent() can unstake only up to
2515 	 *		the mininum required to pay the fileSize
2516 	 * @param _stakedContentId The ID of the staked content
2517 	 * @param _networkIntegerAmount The integer amount of network ion to unstake
2518 	 * @param _networkFractionAmount The fraction amount of network ion to unstake
2519 	 * @param _denomination The denomination of the network ion, i.e ao, kilo, mega, etc.
2520 	 * @param _primordialAmount The amount of primordial ion to unstake
2521 	 */
2522 	function unstakePartialContent(bytes32 _stakedContentId,
2523 		uint256 _networkIntegerAmount,
2524 		uint256 _networkFractionAmount,
2525 		bytes8 _denomination,
2526 		uint256 _primordialAmount
2527 		) public {
2528 		// Make sure the staked content exist
2529 		require (stakedContentIndex[_stakedContentId] > 0);
2530 		require (_networkIntegerAmount > 0 || _networkFractionAmount > 0 || _primordialAmount > 0);
2531 
2532 		StakedContent storage _stakedContent = stakedContents[stakedContentIndex[_stakedContentId]];
2533 		(, uint256 _fileSize,,,,,,,) = _aoContent.getById(_stakedContent.contentId);
2534 
2535 		address _stakeOwnerNameId = _nameFactory.ethAddressToNameId(msg.sender);
2536 		require (_stakeOwnerNameId != address(0));
2537 
2538 		// Make sure the staked content owner is the same as the sender
2539 		require (_stakedContent.stakeOwner == _stakeOwnerNameId);
2540 		// Make sure the staked content is currently active (staked) with some amounts
2541 		require (this.isActive(_stakedContentId));
2542 		// Make sure the staked content has enough balance to unstake
2543 		require (_canUnstakePartial(_networkIntegerAmount, _networkFractionAmount, _denomination, _primordialAmount, _stakedContent.networkAmount, _stakedContent.primordialAmount, _fileSize));
2544 
2545 		if (_aoTreasury.isDenominationExist(_denomination) && (_networkIntegerAmount > 0 || _networkFractionAmount > 0)) {
2546 			uint256 _unstakeNetworkAmount = _aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination);
2547 			_stakedContent.networkAmount = _stakedContent.networkAmount.sub(_unstakeNetworkAmount);
2548 			require (_aoIon.unstakeFrom(_namePublicKey.getDefaultKey(_stakeOwnerNameId), _unstakeNetworkAmount));
2549 		}
2550 		if (_primordialAmount > 0) {
2551 			_stakedContent.primordialAmount = _stakedContent.primordialAmount.sub(_primordialAmount);
2552 			require (_aoIon.unstakePrimordialFrom(_namePublicKey.getDefaultKey(_stakeOwnerNameId), _primordialAmount, _stakedContent.primordialWeightedMultiplier));
2553 		}
2554 		emit UnstakePartialContent(_stakedContent.stakeOwner, _stakedContent.stakedContentId, _stakedContent.contentId, _stakedContent.networkAmount, _stakedContent.primordialAmount, _stakedContent.primordialWeightedMultiplier);
2555 	}
2556 
2557 	/**
2558 	 * @dev Unstake existing staked content and refund the total staked amount to the stake owner
2559 	 * @param _stakedContentId The ID of the staked content
2560 	 */
2561 	function unstakeContent(bytes32 _stakedContentId) public {
2562 		// Make sure the staked content exist
2563 		require (stakedContentIndex[_stakedContentId] > 0);
2564 
2565 		StakedContent storage _stakedContent = stakedContents[stakedContentIndex[_stakedContentId]];
2566 
2567 		address _stakeOwnerNameId = _nameFactory.ethAddressToNameId(msg.sender);
2568 		require (_stakeOwnerNameId != address(0));
2569 
2570 		// Make sure the staked content owner is the same as the sender
2571 		require (_stakedContent.stakeOwner == _stakeOwnerNameId);
2572 		// Make sure the staked content is currently active (staked) with some amounts
2573 		require (this.isActive(_stakedContentId));
2574 		_stakedContent.active = false;
2575 
2576 		if (_stakedContent.networkAmount > 0) {
2577 			uint256 _unstakeNetworkAmount = _stakedContent.networkAmount;
2578 			_stakedContent.networkAmount = 0;
2579 			require (_aoIon.unstakeFrom(_namePublicKey.getDefaultKey(_stakeOwnerNameId), _unstakeNetworkAmount));
2580 		}
2581 		if (_stakedContent.primordialAmount > 0) {
2582 			uint256 _primordialAmount = _stakedContent.primordialAmount;
2583 			uint256 _primordialWeightedMultiplier = _stakedContent.primordialWeightedMultiplier;
2584 			_stakedContent.primordialAmount = 0;
2585 			_stakedContent.primordialWeightedMultiplier = 0;
2586 			require (_aoIon.unstakePrimordialFrom(_namePublicKey.getDefaultKey(_stakeOwnerNameId), _primordialAmount, _primordialWeightedMultiplier));
2587 		}
2588 		emit UnstakeContent(_stakedContent.stakeOwner, _stakedContentId);
2589 	}
2590 
2591 	/**
2592 	 * @dev Stake existing content with more ions (this is to increase the price)
2593 	 *
2594 	 * @param _stakedContentId The ID of the staked content
2595 	 * @param _networkIntegerAmount The integer amount of network ion to stake
2596 	 * @param _networkFractionAmount The fraction amount of network ion to stake
2597 	 * @param _denomination The denomination of the network ion, i.e ao, kilo, mega, etc.
2598 	 * @param _primordialAmount The amount of primordial ion to stake. (The primordial weighted multiplier has to match the current staked weighted multiplier)
2599 	 */
2600 	function stakeExistingContent(bytes32 _stakedContentId,
2601 		uint256 _networkIntegerAmount,
2602 		uint256 _networkFractionAmount,
2603 		bytes8 _denomination,
2604 		uint256 _primordialAmount
2605 		) public {
2606 		// Make sure the staked content exist
2607 		require (stakedContentIndex[_stakedContentId] > 0);
2608 
2609 		StakedContent storage _stakedContent = stakedContents[stakedContentIndex[_stakedContentId]];
2610 		(, uint256 _fileSize,,,,,,,) = _aoContent.getById(_stakedContent.contentId);
2611 
2612 		address _stakeOwnerNameId = _nameFactory.ethAddressToNameId(msg.sender);
2613 		require (_stakeOwnerNameId != address(0));
2614 
2615 		// Make sure the staked content owner is the same as the sender
2616 		require (_stakedContent.stakeOwner == _stakeOwnerNameId);
2617 		require (_networkIntegerAmount > 0 || _networkFractionAmount > 0 || _primordialAmount > 0);
2618 		require (_canStakeExisting(_aoContent.isAOContentUsageType(_stakedContent.contentId), _fileSize, _stakedContent.networkAmount.add(_stakedContent.primordialAmount), _networkIntegerAmount, _networkFractionAmount, _denomination, _primordialAmount));
2619 
2620 		// Make sure we can stake primordial ion
2621 		// If we are currently staking an active staked content, then the stake owner's weighted multiplier has to match `stakedContent.primordialWeightedMultiplier`
2622 		// i.e, can't use a combination of different weighted multiplier. Stake owner has to call unstakeContent() to unstake all ions first
2623 		if (_primordialAmount > 0 && _stakedContent.active && _stakedContent.primordialAmount > 0 && _stakedContent.primordialWeightedMultiplier > 0) {
2624 			require (_aoIon.weightedMultiplierByAddress(_namePublicKey.getDefaultKey(_stakeOwnerNameId)) == _stakedContent.primordialWeightedMultiplier);
2625 		}
2626 
2627 		_stakedContent.active = true;
2628 		if (_aoTreasury.isDenominationExist(_denomination) && (_networkIntegerAmount > 0 || _networkFractionAmount > 0)) {
2629 			uint256 _stakeNetworkAmount = _aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination);
2630 			_stakedContent.networkAmount = _stakedContent.networkAmount.add(_stakeNetworkAmount);
2631 			require (_aoIon.stakeFrom(_namePublicKey.getDefaultKey(_stakedContent.stakeOwner), _stakeNetworkAmount));
2632 		}
2633 		if (_primordialAmount > 0) {
2634 			_stakedContent.primordialAmount = _stakedContent.primordialAmount.add(_primordialAmount);
2635 
2636 			// Primordial ion is the base AO ion
2637 			_stakedContent.primordialWeightedMultiplier = _aoIon.weightedMultiplierByAddress(_namePublicKey.getDefaultKey(_stakedContent.stakeOwner));
2638 			require (_aoIon.stakePrimordialFrom(_namePublicKey.getDefaultKey(_stakedContent.stakeOwner), _primordialAmount, _stakedContent.primordialWeightedMultiplier));
2639 		}
2640 
2641 		emit StakeExistingContent(_stakeOwnerNameId, _stakedContent.stakedContentId, _stakedContent.contentId, _stakedContent.networkAmount, _stakedContent.primordialAmount, _stakedContent.primordialWeightedMultiplier);
2642 	}
2643 
2644 	/**
2645 	 * @dev Check whether or not a staked content is active
2646 	 * @param _stakedContentId The ID of the staked content
2647 	 * @return true if yes, false otherwise.
2648 	 */
2649 	function isActive(bytes32 _stakedContentId) external view returns (bool) {
2650 		// Make sure the staked content exist
2651 		require (stakedContentIndex[_stakedContentId] > 0);
2652 
2653 		StakedContent memory _stakedContent = stakedContents[stakedContentIndex[_stakedContentId]];
2654 		return (_stakedContent.active == true && (_stakedContent.networkAmount > 0 || (_stakedContent.primordialAmount > 0 && _stakedContent.primordialWeightedMultiplier > 0)));
2655 	}
2656 
2657 	/***** INTERNAL METHODS *****/
2658 	/**
2659 	 * @dev Checks if create params are valid
2660 	 * @param _stakeOwner the address that stake the content
2661 	 * @param _contentId The ID of the content
2662 	 * @param _networkIntegerAmount The integer amount of network ion to stake
2663 	 * @param _networkFractionAmount The fraction amount of network ion to stake
2664 	 * @param _denomination The denomination of the network ion, i.e ao, kilo, mega, etc.
2665 	 * @param _primordialAmount The amount of primordial ion to stake
2666 	 * @param _profitPercentage The percentage of profit the stake owner's media will charge
2667 	 * @return true if yes. false otherwise
2668 	 */
2669 	function _canCreate(address _stakeOwner,
2670 		bytes32 _contentId,
2671 		uint256 _networkIntegerAmount,
2672 		uint256 _networkFractionAmount,
2673 		bytes8 _denomination,
2674 		uint256 _primordialAmount,
2675 		uint256 _profitPercentage) internal view returns (bool) {
2676 		(address _contentCreator, uint256 _fileSize,,,,,,,) = _aoContent.getById(_contentId);
2677 		return (_stakeOwner != address(0) &&
2678 			AOLibrary.isName(_stakeOwner) &&
2679 			_stakeOwner == _contentCreator &&
2680 			(_networkIntegerAmount > 0 || _networkFractionAmount > 0 || _primordialAmount > 0) &&
2681 			(_aoContent.isAOContentUsageType(_contentId) ?
2682 				_aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination).add(_primordialAmount) >= _fileSize :
2683 				_aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination).add(_primordialAmount) == _fileSize
2684 			) &&
2685 			_profitPercentage <= AOLibrary.PERCENTAGE_DIVISOR()
2686 		);
2687 	}
2688 
2689 	/**
2690 	 * @dev Check whether or the requested unstake amount is valid
2691 	 * @param _networkIntegerAmount The integer amount of the network ion
2692 	 * @param _networkFractionAmount The fraction amount of the network ion
2693 	 * @param _denomination The denomination of the the network ion
2694 	 * @param _primordialAmount The amount of primordial ion
2695 	 * @param _stakedNetworkAmount The current staked network ion amount
2696 	 * @param _stakedPrimordialAmount The current staked primordial ion amount
2697 	 * @param _stakedFileSize The file size of the staked content
2698 	 * @return true if can unstake, false otherwise
2699 	 */
2700 	function _canUnstakePartial(
2701 		uint256 _networkIntegerAmount,
2702 		uint256 _networkFractionAmount,
2703 		bytes8 _denomination,
2704 		uint256 _primordialAmount,
2705 		uint256 _stakedNetworkAmount,
2706 		uint256 _stakedPrimordialAmount,
2707 		uint256 _stakedFileSize
2708 		) internal view returns (bool) {
2709 		if (
2710 			(_denomination.length > 0 && _denomination[0] != 0 &&
2711 				(_networkIntegerAmount > 0 || _networkFractionAmount > 0) &&
2712 				_stakedNetworkAmount < _aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination)
2713 			) ||
2714 			_stakedPrimordialAmount < _primordialAmount ||
2715 			(
2716 				_denomination.length > 0 && _denomination[0] != 0
2717 					&& (_networkIntegerAmount > 0 || _networkFractionAmount > 0)
2718 					&& (_stakedNetworkAmount.sub(_aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination)).add(_stakedPrimordialAmount.sub(_primordialAmount)) < _stakedFileSize)
2719 			) ||
2720 			( _denomination.length == 0 && _denomination[0] == 0 && _networkIntegerAmount == 0 && _networkFractionAmount == 0 && _primordialAmount > 0 && _stakedPrimordialAmount.sub(_primordialAmount) < _stakedFileSize)
2721 		) {
2722 			return false;
2723 		} else {
2724 			return true;
2725 		}
2726 	}
2727 
2728 	/**
2729 	 * @dev Check whether the network ion and/or primordial ion is adequate to pay for existing staked content
2730 	 * @param _isAOContentUsageType whether or not the content is of AO Content usage type
2731 	 * @param _fileSize The size of the file
2732 	 * @param _stakedAmount The total staked amount
2733 	 * @param _networkIntegerAmount The integer amount of the network ion
2734 	 * @param _networkFractionAmount The fraction amount of the network ion
2735 	 * @param _denomination The denomination of the the network ion
2736 	 * @param _primordialAmount The amount of primordial ion
2737 	 * @return true when the amount is sufficient, false otherwise
2738 	 */
2739 	function _canStakeExisting(
2740 		bool _isAOContentUsageType,
2741 		uint256 _fileSize,
2742 		uint256 _stakedAmount,
2743 		uint256 _networkIntegerAmount,
2744 		uint256 _networkFractionAmount,
2745 		bytes8 _denomination,
2746 		uint256 _primordialAmount
2747 	) internal view returns (bool) {
2748 		if (_isAOContentUsageType) {
2749 			return _aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination).add(_primordialAmount).add(_stakedAmount) >= _fileSize;
2750 		} else {
2751 			return _aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination).add(_primordialAmount).add(_stakedAmount) == _fileSize;
2752 		}
2753 	}
2754 }