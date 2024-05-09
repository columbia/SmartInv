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
152 
153 
154 contract TokenERC20 {
155 	// Public variables of the token
156 	string public name;
157 	string public symbol;
158 	uint8 public decimals = 18;
159 	// 18 decimals is the strongly suggested default, avoid changing it
160 	uint256 public totalSupply;
161 
162 	// This creates an array with all balances
163 	mapping (address => uint256) public balanceOf;
164 	mapping (address => mapping (address => uint256)) public allowance;
165 
166 	// This generates a public event on the blockchain that will notify clients
167 	event Transfer(address indexed from, address indexed to, uint256 value);
168 
169 	// This generates a public event on the blockchain that will notify clients
170 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
171 
172 	// This notifies clients about the amount burnt
173 	event Burn(address indexed from, uint256 value);
174 
175 	/**
176 	 * Constructor function
177 	 *
178 	 * Initializes contract with initial supply tokens to the creator of the contract
179 	 */
180 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
181 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
182 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
183 		name = tokenName;                                   // Set the name for display purposes
184 		symbol = tokenSymbol;                               // Set the symbol for display purposes
185 	}
186 
187 	/**
188 	 * Internal transfer, only can be called by this contract
189 	 */
190 	function _transfer(address _from, address _to, uint _value) internal {
191 		// Prevent transfer to 0x0 address. Use burn() instead
192 		require(_to != address(0));
193 		// Check if the sender has enough
194 		require(balanceOf[_from] >= _value);
195 		// Check for overflows
196 		require(balanceOf[_to] + _value > balanceOf[_to]);
197 		// Save this for an assertion in the future
198 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
199 		// Subtract from the sender
200 		balanceOf[_from] -= _value;
201 		// Add the same to the recipient
202 		balanceOf[_to] += _value;
203 		emit Transfer(_from, _to, _value);
204 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
205 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
206 	}
207 
208 	/**
209 	 * Transfer tokens
210 	 *
211 	 * Send `_value` tokens to `_to` from your account
212 	 *
213 	 * @param _to The address of the recipient
214 	 * @param _value the amount to send
215 	 */
216 	function transfer(address _to, uint256 _value) public returns (bool success) {
217 		_transfer(msg.sender, _to, _value);
218 		return true;
219 	}
220 
221 	/**
222 	 * Transfer tokens from other address
223 	 *
224 	 * Send `_value` tokens to `_to` in behalf of `_from`
225 	 *
226 	 * @param _from The address of the sender
227 	 * @param _to The address of the recipient
228 	 * @param _value the amount to send
229 	 */
230 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
231 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
232 		allowance[_from][msg.sender] -= _value;
233 		_transfer(_from, _to, _value);
234 		return true;
235 	}
236 
237 	/**
238 	 * Set allowance for other address
239 	 *
240 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
241 	 *
242 	 * @param _spender The address authorized to spend
243 	 * @param _value the max amount they can spend
244 	 */
245 	function approve(address _spender, uint256 _value) public returns (bool success) {
246 		allowance[msg.sender][_spender] = _value;
247 		emit Approval(msg.sender, _spender, _value);
248 		return true;
249 	}
250 
251 	/**
252 	 * Set allowance for other address and notify
253 	 *
254 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
255 	 *
256 	 * @param _spender The address authorized to spend
257 	 * @param _value the max amount they can spend
258 	 * @param _extraData some extra information to send to the approved contract
259 	 */
260 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
261 		tokenRecipient spender = tokenRecipient(_spender);
262 		if (approve(_spender, _value)) {
263 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
264 			return true;
265 		}
266 	}
267 
268 	/**
269 	 * Destroy tokens
270 	 *
271 	 * Remove `_value` tokens from the system irreversibly
272 	 *
273 	 * @param _value the amount of money to burn
274 	 */
275 	function burn(uint256 _value) public returns (bool success) {
276 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
277 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
278 		totalSupply -= _value;                      // Updates totalSupply
279 		emit Burn(msg.sender, _value);
280 		return true;
281 	}
282 
283 	/**
284 	 * Destroy tokens from other account
285 	 *
286 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
287 	 *
288 	 * @param _from the address of the sender
289 	 * @param _value the amount of money to burn
290 	 */
291 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
292 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
293 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
294 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
295 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
296 		totalSupply -= _value;                              // Update totalSupply
297 		emit Burn(_from, _value);
298 		return true;
299 	}
300 }
301 
302 
303 interface INameFactory {
304 	function nonces(address _nameId) external view returns (uint256);
305 	function incrementNonce(address _nameId) external returns (uint256);
306 	function ethAddressToNameId(address _ethAddress) external view returns (address);
307 	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
308 	function nameIdToEthAddress(address _nameId) external view returns (address);
309 }
310 
311 
312 
313 
314 
315 
316 
317 
318 
319 
320 
321 /**
322  * @title TAO
323  */
324 contract TAO {
325 	using SafeMath for uint256;
326 
327 	address public vaultAddress;
328 	string public name;				// the name for this TAO
329 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
330 
331 	// TAO's data
332 	string public datHash;
333 	string public database;
334 	string public keyValue;
335 	bytes32 public contentId;
336 
337 	/**
338 	 * 0 = TAO
339 	 * 1 = Name
340 	 */
341 	uint8 public typeId;
342 
343 	/**
344 	 * @dev Constructor function
345 	 */
346 	constructor (string memory _name,
347 		address _originId,
348 		string memory _datHash,
349 		string memory _database,
350 		string memory _keyValue,
351 		bytes32 _contentId,
352 		address _vaultAddress
353 	) public {
354 		name = _name;
355 		originId = _originId;
356 		datHash = _datHash;
357 		database = _database;
358 		keyValue = _keyValue;
359 		contentId = _contentId;
360 
361 		// Creating TAO
362 		typeId = 0;
363 
364 		vaultAddress = _vaultAddress;
365 	}
366 
367 	/**
368 	 * @dev Checks if calling address is Vault contract
369 	 */
370 	modifier onlyVault {
371 		require (msg.sender == vaultAddress);
372 		_;
373 	}
374 
375 	/**
376 	 * Will receive any ETH sent
377 	 */
378 	function () external payable {
379 	}
380 
381 	/**
382 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
383 	 * @param _recipient The recipient address
384 	 * @param _amount The amount to transfer
385 	 * @return true on success
386 	 */
387 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
388 		_recipient.transfer(_amount);
389 		return true;
390 	}
391 
392 	/**
393 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
394 	 * @param _erc20TokenAddress The address of ERC20 Token
395 	 * @param _recipient The recipient address
396 	 * @param _amount The amount to transfer
397 	 * @return true on success
398 	 */
399 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
400 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
401 		_erc20.transfer(_recipient, _amount);
402 		return true;
403 	}
404 }
405 
406 
407 
408 
409 /**
410  * @title Name
411  */
412 contract Name is TAO {
413 	/**
414 	 * @dev Constructor function
415 	 */
416 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
417 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
418 		// Creating Name
419 		typeId = 1;
420 	}
421 }
422 
423 
424 
425 
426 /**
427  * @title AOLibrary
428  */
429 library AOLibrary {
430 	using SafeMath for uint256;
431 
432 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
433 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
434 
435 	/**
436 	 * @dev Check whether or not the given TAO ID is a TAO
437 	 * @param _taoId The ID of the TAO
438 	 * @return true if yes. false otherwise
439 	 */
440 	function isTAO(address _taoId) public view returns (bool) {
441 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
442 	}
443 
444 	/**
445 	 * @dev Check whether or not the given Name ID is a Name
446 	 * @param _nameId The ID of the Name
447 	 * @return true if yes. false otherwise
448 	 */
449 	function isName(address _nameId) public view returns (bool) {
450 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
451 	}
452 
453 	/**
454 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
455 	 * @param _tokenAddress The ERC20 Token address to check
456 	 */
457 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
458 		if (_tokenAddress == address(0)) {
459 			return false;
460 		}
461 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
462 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
463 	}
464 
465 	/**
466 	 * @dev Checks if the calling contract address is The AO
467 	 *		OR
468 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
469 	 * @param _sender The address to check
470 	 * @param _theAO The AO address
471 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
472 	 * @return true if yes, false otherwise
473 	 */
474 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
475 		return (_sender == _theAO ||
476 			(
477 				(isTAO(_theAO) || isName(_theAO)) &&
478 				_nameTAOPositionAddress != address(0) &&
479 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
480 			)
481 		);
482 	}
483 
484 	/**
485 	 * @dev Return the divisor used to correctly calculate percentage.
486 	 *		Percentage stored throughout AO contracts covers 4 decimals,
487 	 *		so 1% is 10000, 1.25% is 12500, etc
488 	 */
489 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
490 		return _PERCENTAGE_DIVISOR;
491 	}
492 
493 	/**
494 	 * @dev Return the divisor used to correctly calculate multiplier.
495 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
496 	 *		so 1 is 1000000, 0.023 is 23000, etc
497 	 */
498 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
499 		return _MULTIPLIER_DIVISOR;
500 	}
501 
502 	/**
503 	 * @dev deploy a TAO
504 	 * @param _name The name of the TAO
505 	 * @param _originId The Name ID the creates the TAO
506 	 * @param _datHash The datHash of this TAO
507 	 * @param _database The database for this TAO
508 	 * @param _keyValue The key/value pair to be checked on the database
509 	 * @param _contentId The contentId related to this TAO
510 	 * @param _nameTAOVaultAddress The address of NameTAOVault
511 	 */
512 	function deployTAO(string memory _name,
513 		address _originId,
514 		string memory _datHash,
515 		string memory _database,
516 		string memory _keyValue,
517 		bytes32 _contentId,
518 		address _nameTAOVaultAddress
519 		) public returns (TAO _tao) {
520 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
521 	}
522 
523 	/**
524 	 * @dev deploy a Name
525 	 * @param _name The name of the Name
526 	 * @param _originId The eth address the creates the Name
527 	 * @param _datHash The datHash of this Name
528 	 * @param _database The database for this Name
529 	 * @param _keyValue The key/value pair to be checked on the database
530 	 * @param _contentId The contentId related to this Name
531 	 * @param _nameTAOVaultAddress The address of NameTAOVault
532 	 */
533 	function deployName(string memory _name,
534 		address _originId,
535 		string memory _datHash,
536 		string memory _database,
537 		string memory _keyValue,
538 		bytes32 _contentId,
539 		address _nameTAOVaultAddress
540 		) public returns (Name _myName) {
541 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
542 	}
543 
544 	/**
545 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
546 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
547 	 * @param _currentPrimordialBalance Account's current primordial ion balance
548 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
549 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
550 	 * @return the new primordial weighted multiplier
551 	 */
552 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
553 		if (_currentWeightedMultiplier > 0) {
554 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
555 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
556 			return _totalWeightedIons.div(_totalIons);
557 		} else {
558 			return _additionalWeightedMultiplier;
559 		}
560 	}
561 
562 	/**
563 	 * @dev Calculate the primordial ion multiplier on a given lot
564 	 *		Total Primordial Mintable = T
565 	 *		Total Primordial Minted = M
566 	 *		Starting Multiplier = S
567 	 *		Ending Multiplier = E
568 	 *		To Purchase = P
569 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
570 	 *
571 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
572 	 * @param _totalPrimordialMintable Total Primordial ion mintable
573 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
574 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
575 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
576 	 * @return The multiplier in (10 ** 6)
577 	 */
578 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
579 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
580 			/**
581 			 * Let temp = M + (P/2)
582 			 * Multiplier = (1 - (temp / T)) x (S-E)
583 			 */
584 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
585 
586 			/**
587 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
588 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
589 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
590 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
591 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
592 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
593 			 */
594 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
595 			/**
596 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
597 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
598 			 */
599 			return multiplier.div(_MULTIPLIER_DIVISOR);
600 		} else {
601 			return 0;
602 		}
603 	}
604 
605 	/**
606 	 * @dev Calculate the bonus percentage of network ion on a given lot
607 	 *		Total Primordial Mintable = T
608 	 *		Total Primordial Minted = M
609 	 *		Starting Network Bonus Multiplier = Bs
610 	 *		Ending Network Bonus Multiplier = Be
611 	 *		To Purchase = P
612 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
613 	 *
614 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
615 	 * @param _totalPrimordialMintable Total Primordial ion intable
616 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
617 	 * @param _startingMultiplier The starting Network ion bonus multiplier
618 	 * @param _endingMultiplier The ending Network ion bonus multiplier
619 	 * @return The bonus percentage
620 	 */
621 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
622 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
623 			/**
624 			 * Let temp = M + (P/2)
625 			 * B% = (1 - (temp / T)) x (Bs-Be)
626 			 */
627 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
628 
629 			/**
630 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
631 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
632 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
633 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
634 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
635 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
636 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
637 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
638 			 */
639 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
640 			return bonusPercentage;
641 		} else {
642 			return 0;
643 		}
644 	}
645 
646 	/**
647 	 * @dev Calculate the bonus amount of network ion on a given lot
648 	 *		AO Bonus Amount = B% x P
649 	 *
650 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
651 	 * @param _totalPrimordialMintable Total Primordial ion intable
652 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
653 	 * @param _startingMultiplier The starting Network ion bonus multiplier
654 	 * @param _endingMultiplier The ending Network ion bonus multiplier
655 	 * @return The bonus percentage
656 	 */
657 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
658 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
659 		/**
660 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
661 		 * when calculating the network ion bonus amount
662 		 */
663 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
664 		return networkBonus;
665 	}
666 
667 	/**
668 	 * @dev Calculate the maximum amount of Primordial an account can burn
669 	 *		_primordialBalance = P
670 	 *		_currentWeightedMultiplier = M
671 	 *		_maximumMultiplier = S
672 	 *		_amountToBurn = B
673 	 *		B = ((S x P) - (P x M)) / S
674 	 *
675 	 * @param _primordialBalance Account's primordial ion balance
676 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
677 	 * @param _maximumMultiplier The maximum multiplier of this account
678 	 * @return The maximum burn amount
679 	 */
680 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
681 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
682 	}
683 
684 	/**
685 	 * @dev Calculate the new multiplier after burning primordial ion
686 	 *		_primordialBalance = P
687 	 *		_currentWeightedMultiplier = M
688 	 *		_amountToBurn = B
689 	 *		_newMultiplier = E
690 	 *		E = (P x M) / (P - B)
691 	 *
692 	 * @param _primordialBalance Account's primordial ion balance
693 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
694 	 * @param _amountToBurn The amount of primordial ion to burn
695 	 * @return The new multiplier
696 	 */
697 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
698 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
699 	}
700 
701 	/**
702 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
703 	 *		_primordialBalance = P
704 	 *		_currentWeightedMultiplier = M
705 	 *		_amountToConvert = C
706 	 *		_newMultiplier = E
707 	 *		E = (P x M) / (P + C)
708 	 *
709 	 * @param _primordialBalance Account's primordial ion balance
710 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
711 	 * @param _amountToConvert The amount of network ion to convert
712 	 * @return The new multiplier
713 	 */
714 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
715 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
716 	}
717 
718 	/**
719 	 * @dev count num of digits
720 	 * @param number uint256 of the nuumber to be checked
721 	 * @return uint8 num of digits
722 	 */
723 	function numDigits(uint256 number) public pure returns (uint8) {
724 		uint8 digits = 0;
725 		while(number != 0) {
726 			number = number.div(10);
727 			digits++;
728 		}
729 		return digits;
730 	}
731 }
732 
733 
734 
735 
736 
737 
738 
739 
740 
741 
742 
743 
744 
745 
746 
747 
748 
749 
750 
751 interface ionRecipient {
752 	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
753 }
754 
755 /**
756  * @title AOIonInterface
757  */
758 contract AOIonInterface is TheAO {
759 	using SafeMath for uint256;
760 
761 	address public namePublicKeyAddress;
762 	address public nameAccountRecoveryAddress;
763 
764 	INameTAOPosition internal _nameTAOPosition;
765 	INamePublicKey internal _namePublicKey;
766 	INameAccountRecovery internal _nameAccountRecovery;
767 
768 	// Public variables of the contract
769 	string public name;
770 	string public symbol;
771 	uint8 public decimals;
772 	uint256 public totalSupply;
773 
774 	// To differentiate denomination of AO
775 	uint256 public powerOfTen;
776 
777 	/***** NETWORK ION VARIABLES *****/
778 	uint256 public sellPrice;
779 	uint256 public buyPrice;
780 
781 	// This creates an array with all balances
782 	mapping (address => uint256) public balanceOf;
783 	mapping (address => mapping (address => uint256)) public allowance;
784 	mapping (address => bool) public frozenAccount;
785 	mapping (address => uint256) public stakedBalance;
786 	mapping (address => uint256) public escrowedBalance;
787 
788 	// This generates a public event on the blockchain that will notify clients
789 	event FrozenFunds(address target, bool frozen);
790 	event Stake(address indexed from, uint256 value);
791 	event Unstake(address indexed from, uint256 value);
792 	event Escrow(address indexed from, address indexed to, uint256 value);
793 	event Unescrow(address indexed from, uint256 value);
794 
795 	// This generates a public event on the blockchain that will notify clients
796 	event Transfer(address indexed from, address indexed to, uint256 value);
797 
798 	// This generates a public event on the blockchain that will notify clients
799 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
800 
801 	// This notifies clients about the amount burnt
802 	event Burn(address indexed from, uint256 value);
803 
804 	/**
805 	 * @dev Constructor function
806 	 */
807 	constructor(string memory _name, string memory _symbol, address _nameTAOPositionAddress, address _namePublicKeyAddress, address _nameAccountRecoveryAddress) public {
808 		setNameTAOPositionAddress(_nameTAOPositionAddress);
809 		setNamePublicKeyAddress(_namePublicKeyAddress);
810 		setNameAccountRecoveryAddress(_nameAccountRecoveryAddress);
811 		name = _name;           // Set the name for display purposes
812 		symbol = _symbol;       // Set the symbol for display purposes
813 		powerOfTen = 0;
814 		decimals = 0;
815 	}
816 
817 	/**
818 	 * @dev Checks if the calling contract address is The AO
819 	 *		OR
820 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
821 	 */
822 	modifier onlyTheAO {
823 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
824 		_;
825 	}
826 
827 	/***** The AO ONLY METHODS *****/
828 	/**
829 	 * @dev Transfer ownership of The AO to new address
830 	 * @param _theAO The new address to be transferred
831 	 */
832 	function transferOwnership(address _theAO) public onlyTheAO {
833 		require (_theAO != address(0));
834 		theAO = _theAO;
835 	}
836 
837 	/**
838 	 * @dev Whitelist `_account` address to transact on behalf of others
839 	 * @param _account The address to whitelist
840 	 * @param _whitelist Either to whitelist or not
841 	 */
842 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
843 		require (_account != address(0));
844 		whitelist[_account] = _whitelist;
845 	}
846 
847 	/**
848 	 * @dev The AO set the NameTAOPosition Address
849 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
850 	 */
851 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
852 		require (_nameTAOPositionAddress != address(0));
853 		nameTAOPositionAddress = _nameTAOPositionAddress;
854 		_nameTAOPosition = INameTAOPosition(nameTAOPositionAddress);
855 	}
856 
857 	/**
858 	 * @dev The AO set the NamePublicKey Address
859 	 * @param _namePublicKeyAddress The address of NamePublicKey
860 	 */
861 	function setNamePublicKeyAddress(address _namePublicKeyAddress) public onlyTheAO {
862 		require (_namePublicKeyAddress != address(0));
863 		namePublicKeyAddress = _namePublicKeyAddress;
864 		_namePublicKey = INamePublicKey(namePublicKeyAddress);
865 	}
866 
867 	/**
868 	 * @dev The AO set the NameAccountRecovery Address
869 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
870 	 */
871 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
872 		require (_nameAccountRecoveryAddress != address(0));
873 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
874 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
875 	}
876 
877 	/**
878 	 * @dev Allows TheAO to transfer `_amount` of ETH from this address to `_recipient`
879 	 * @param _recipient The recipient address
880 	 * @param _amount The amount to transfer
881 	 */
882 	function transferEth(address payable _recipient, uint256 _amount) public onlyTheAO {
883 		require (_recipient != address(0));
884 		_recipient.transfer(_amount);
885 	}
886 
887 	/**
888 	 * @dev Prevent/Allow target from sending & receiving ions
889 	 * @param target Address to be frozen
890 	 * @param freeze Either to freeze it or not
891 	 */
892 	function freezeAccount(address target, bool freeze) public onlyTheAO {
893 		frozenAccount[target] = freeze;
894 		emit FrozenFunds(target, freeze);
895 	}
896 
897 	/**
898 	 * @dev Allow users to buy ions for `newBuyPrice` eth and sell ions for `newSellPrice` eth
899 	 * @param newSellPrice Price users can sell to the contract
900 	 * @param newBuyPrice Price users can buy from the contract
901 	 */
902 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyTheAO {
903 		sellPrice = newSellPrice;
904 		buyPrice = newBuyPrice;
905 	}
906 
907 	/***** NETWORK ION WHITELISTED ADDRESS ONLY METHODS *****/
908 	/**
909 	 * @dev Create `mintedAmount` ions and send it to `target`
910 	 * @param target Address to receive the ions
911 	 * @param mintedAmount The amount of ions it will receive
912 	 * @return true on success
913 	 */
914 	function mint(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
915 		_mint(target, mintedAmount);
916 		return true;
917 	}
918 
919 	/**
920 	 * @dev Stake `_value` ions on behalf of `_from`
921 	 * @param _from The address of the target
922 	 * @param _value The amount to stake
923 	 * @return true on success
924 	 */
925 	function stakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
926 		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
927 		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
928 		stakedBalance[_from] = stakedBalance[_from].add(_value);	// Add to the targeted staked balance
929 		emit Stake(_from, _value);
930 		return true;
931 	}
932 
933 	/**
934 	 * @dev Unstake `_value` ions on behalf of `_from`
935 	 * @param _from The address of the target
936 	 * @param _value The amount to unstake
937 	 * @return true on success
938 	 */
939 	function unstakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
940 		require (stakedBalance[_from] >= _value);					// Check if the targeted staked balance is enough
941 		stakedBalance[_from] = stakedBalance[_from].sub(_value);	// Subtract from the targeted staked balance
942 		balanceOf[_from] = balanceOf[_from].add(_value);			// Add to the targeted balance
943 		emit Unstake(_from, _value);
944 		return true;
945 	}
946 
947 	/**
948 	 * @dev Store `_value` from `_from` to `_to` in escrow
949 	 * @param _from The address of the sender
950 	 * @param _to The address of the recipient
951 	 * @param _value The amount of network ions to put in escrow
952 	 * @return true on success
953 	 */
954 	function escrowFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool) {
955 		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
956 		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
957 		escrowedBalance[_to] = escrowedBalance[_to].add(_value);	// Add to the targeted escrowed balance
958 		emit Escrow(_from, _to, _value);
959 		return true;
960 	}
961 
962 	/**
963 	 * @dev Create `mintedAmount` ions and send it to `target` escrow balance
964 	 * @param target Address to receive ions
965 	 * @param mintedAmount The amount of ions it will receive in escrow
966 	 */
967 	function mintEscrow(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
968 		escrowedBalance[target] = escrowedBalance[target].add(mintedAmount);
969 		totalSupply = totalSupply.add(mintedAmount);
970 		emit Escrow(address(this), target, mintedAmount);
971 		return true;
972 	}
973 
974 	/**
975 	 * @dev Release escrowed `_value` from `_from`
976 	 * @param _from The address of the sender
977 	 * @param _value The amount of escrowed network ions to be released
978 	 * @return true on success
979 	 */
980 	function unescrowFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
981 		require (escrowedBalance[_from] >= _value);						// Check if the targeted escrowed balance is enough
982 		escrowedBalance[_from] = escrowedBalance[_from].sub(_value);	// Subtract from the targeted escrowed balance
983 		balanceOf[_from] = balanceOf[_from].add(_value);				// Add to the targeted balance
984 		emit Unescrow(_from, _value);
985 		return true;
986 	}
987 
988 	/**
989 	 *
990 	 * @dev Whitelisted address remove `_value` ions from the system irreversibly on behalf of `_from`.
991 	 *
992 	 * @param _from the address of the sender
993 	 * @param _value the amount of money to burn
994 	 */
995 	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist returns (bool success) {
996 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
997 		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
998 		totalSupply = totalSupply.sub(_value);              // Update totalSupply
999 		emit Burn(_from, _value);
1000 		return true;
1001 	}
1002 
1003 	/**
1004 	 * @dev Whitelisted address transfer ions from other address
1005 	 *
1006 	 * Send `_value` ions to `_to` on behalf of `_from`
1007 	 *
1008 	 * @param _from The address of the sender
1009 	 * @param _to The address of the recipient
1010 	 * @param _value the amount to send
1011 	 */
1012 	function whitelistTransferFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool success) {
1013 		_transfer(_from, _to, _value);
1014 		return true;
1015 	}
1016 
1017 	/***** PUBLIC METHODS *****/
1018 	/**
1019 	 * Transfer ions
1020 	 *
1021 	 * Send `_value` ions to `_to` from your account
1022 	 *
1023 	 * @param _to The address of the recipient
1024 	 * @param _value the amount to send
1025 	 */
1026 	function transfer(address _to, uint256 _value) public returns (bool success) {
1027 		_transfer(msg.sender, _to, _value);
1028 		return true;
1029 	}
1030 
1031 	/**
1032 	 * Transfer ions from other address
1033 	 *
1034 	 * Send `_value` ions to `_to` in behalf of `_from`
1035 	 *
1036 	 * @param _from The address of the sender
1037 	 * @param _to The address of the recipient
1038 	 * @param _value the amount to send
1039 	 */
1040 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
1041 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
1042 		allowance[_from][msg.sender] -= _value;
1043 		_transfer(_from, _to, _value);
1044 		return true;
1045 	}
1046 
1047 	/**
1048 	 * Transfer ions between public key addresses in a Name
1049 	 * @param _nameId The ID of the Name
1050 	 * @param _from The address of the sender
1051 	 * @param _to The address of the recipient
1052 	 * @param _value the amount to send
1053 	 */
1054 	function transferBetweenPublicKeys(address _nameId, address _from, address _to, uint256 _value) public returns (bool success) {
1055 		require (AOLibrary.isName(_nameId));
1056 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _nameId));
1057 		require (!_nameAccountRecovery.isCompromised(_nameId));
1058 		// Make sure _from exist in the Name's Public Keys
1059 		require (_namePublicKey.isKeyExist(_nameId, _from));
1060 		// Make sure _to exist in the Name's Public Keys
1061 		require (_namePublicKey.isKeyExist(_nameId, _to));
1062 		_transfer(_from, _to, _value);
1063 		return true;
1064 	}
1065 
1066 	/**
1067 	 * Set allowance for other address
1068 	 *
1069 	 * Allows `_spender` to spend no more than `_value` ions in your behalf
1070 	 *
1071 	 * @param _spender The address authorized to spend
1072 	 * @param _value the max amount they can spend
1073 	 */
1074 	function approve(address _spender, uint256 _value) public returns (bool success) {
1075 		allowance[msg.sender][_spender] = _value;
1076 		emit Approval(msg.sender, _spender, _value);
1077 		return true;
1078 	}
1079 
1080 	/**
1081 	 * Set allowance for other address and notify
1082 	 *
1083 	 * Allows `_spender` to spend no more than `_value` ions in your behalf, and then ping the contract about it
1084 	 *
1085 	 * @param _spender The address authorized to spend
1086 	 * @param _value the max amount they can spend
1087 	 * @param _extraData some extra information to send to the approved contract
1088 	 */
1089 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
1090 		ionRecipient spender = ionRecipient(_spender);
1091 		if (approve(_spender, _value)) {
1092 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
1093 			return true;
1094 		}
1095 	}
1096 
1097 	/**
1098 	 * Destroy ions
1099 	 *
1100 	 * Remove `_value` ions from the system irreversibly
1101 	 *
1102 	 * @param _value the amount of money to burn
1103 	 */
1104 	function burn(uint256 _value) public returns (bool success) {
1105 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
1106 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
1107 		totalSupply -= _value;                      // Updates totalSupply
1108 		emit Burn(msg.sender, _value);
1109 		return true;
1110 	}
1111 
1112 	/**
1113 	 * Destroy ions from other account
1114 	 *
1115 	 * Remove `_value` ions from the system irreversibly on behalf of `_from`.
1116 	 *
1117 	 * @param _from the address of the sender
1118 	 * @param _value the amount of money to burn
1119 	 */
1120 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
1121 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
1122 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
1123 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
1124 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
1125 		totalSupply -= _value;                              // Update totalSupply
1126 		emit Burn(_from, _value);
1127 		return true;
1128 	}
1129 
1130 	/**
1131 	 * @dev Buy ions from contract by sending ether
1132 	 */
1133 	function buy() public payable {
1134 		require (buyPrice > 0);
1135 		uint256 amount = msg.value.div(buyPrice);
1136 		_transfer(address(this), msg.sender, amount);
1137 	}
1138 
1139 	/**
1140 	 * @dev Sell `amount` ions to contract
1141 	 * @param amount The amount of ions to be sold
1142 	 */
1143 	function sell(uint256 amount) public {
1144 		require (sellPrice > 0);
1145 		address myAddress = address(this);
1146 		require (myAddress.balance >= amount.mul(sellPrice));
1147 		_transfer(msg.sender, address(this), amount);
1148 		msg.sender.transfer(amount.mul(sellPrice));
1149 	}
1150 
1151 	/***** INTERNAL METHODS *****/
1152 	/**
1153 	 * @dev Send `_value` ions from `_from` to `_to`
1154 	 * @param _from The address of sender
1155 	 * @param _to The address of the recipient
1156 	 * @param _value The amount to send
1157 	 */
1158 	function _transfer(address _from, address _to, uint256 _value) internal {
1159 		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
1160 		require (balanceOf[_from] >= _value);					// Check if the sender has enough
1161 		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
1162 		require (!frozenAccount[_from]);						// Check if sender is frozen
1163 		require (!frozenAccount[_to]);							// Check if recipient is frozen
1164 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
1165 		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
1166 		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
1167 		emit Transfer(_from, _to, _value);
1168 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
1169 	}
1170 
1171 	/**
1172 	 * @dev Create `mintedAmount` ions and send it to `target`
1173 	 * @param target Address to receive the ions
1174 	 * @param mintedAmount The amount of ions it will receive
1175 	 */
1176 	function _mint(address target, uint256 mintedAmount) internal {
1177 		balanceOf[target] = balanceOf[target].add(mintedAmount);
1178 		totalSupply = totalSupply.add(mintedAmount);
1179 		emit Transfer(address(0), address(this), mintedAmount);
1180 		emit Transfer(address(this), target, mintedAmount);
1181 	}
1182 }
1183 
1184 
1185 
1186 
1187 
1188 
1189 
1190 
1191 
1192 
1193 
1194 
1195 
1196 /**
1197  * @title AOETH
1198  */
1199 contract AOETH is TheAO, TokenERC20, tokenRecipient {
1200 	using SafeMath for uint256;
1201 
1202 	address public aoIonAddress;
1203 
1204 	AOIon internal _aoIon;
1205 
1206 	uint256 public totalERC20Tokens;
1207 	uint256 public totalTokenExchanges;
1208 
1209 	struct ERC20Token {
1210 		address tokenAddress;
1211 		uint256 price;			// price of this ERC20 Token to AOETH
1212 		uint256 maxQuantity;	// To prevent too much exposure to a given asset
1213 		uint256 exchangedQuantity;	// Running total (total AOETH exchanged from this specific ERC20 Token)
1214 		bool active;
1215 	}
1216 
1217 	struct TokenExchange {
1218 		bytes32 exchangeId;
1219 		address buyer;			// The buyer address
1220 		address tokenAddress;	// The address of ERC20 Token
1221 		uint256 price;			// price of ERC20 Token to AOETH
1222 		uint256 sentAmount;		// Amount of ERC20 Token sent
1223 		uint256 receivedAmount;	// Amount of AOETH received
1224 		bytes extraData; // Extra data
1225 	}
1226 
1227 	// Mapping from id to ERC20Token object
1228 	mapping (uint256 => ERC20Token) internal erc20Tokens;
1229 	mapping (address => uint256) internal erc20TokenIdLookup;
1230 
1231 	// Mapping from id to TokenExchange object
1232 	mapping (uint256 => TokenExchange) internal tokenExchanges;
1233 	mapping (bytes32 => uint256) internal tokenExchangeIdLookup;
1234 	mapping (address => uint256) public totalAddressTokenExchanges;
1235 
1236 	// Event to be broadcasted to public when TheAO adds an ERC20 Token
1237 	event AddERC20Token(address indexed tokenAddress, uint256 price, uint256 maxQuantity);
1238 
1239 	// Event to be broadcasted to public when TheAO sets price for ERC20 Token
1240 	event SetPrice(address indexed tokenAddress, uint256 price);
1241 
1242 	// Event to be broadcasted to public when TheAO sets max quantity for ERC20 Token
1243 	event SetMaxQuantity(address indexed tokenAddress, uint256 maxQuantity);
1244 
1245 	// Event to be broadcasted to public when TheAO sets active status for ERC20 Token
1246 	event SetActive(address indexed tokenAddress, bool active);
1247 
1248 	// Event to be broadcasted to public when user exchanges ERC20 Token for AOETH
1249 	event ExchangeToken(bytes32 indexed exchangeId, address indexed from, address tokenAddress, string tokenName, string tokenSymbol, uint256 sentTokenAmount, uint256 receivedAOETHAmount, bytes extraData);
1250 
1251 	/**
1252 	 * @dev Constructor function
1253 	 */
1254 	constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol, address _aoIonAddress, address _nameTAOPositionAddress)
1255 		TokenERC20(initialSupply, tokenName, tokenSymbol) public {
1256 		setAOIonAddress(_aoIonAddress);
1257 		setNameTAOPositionAddress(_nameTAOPositionAddress);
1258 	}
1259 
1260 	/**
1261 	 * @dev Checks if the calling contract address is The AO
1262 	 *		OR
1263 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
1264 	 */
1265 	modifier onlyTheAO {
1266 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
1267 		_;
1268 	}
1269 
1270 	/***** The AO ONLY METHODS *****/
1271 	/**
1272 	 * @dev Transfer ownership of The AO to new address
1273 	 * @param _theAO The new address to be transferred
1274 	 */
1275 	function transferOwnership(address _theAO) public onlyTheAO {
1276 		require (_theAO != address(0));
1277 		theAO = _theAO;
1278 	}
1279 
1280 	/**
1281 	 * @dev Whitelist `_account` address to transact on behalf of others
1282 	 * @param _account The address to whitelist
1283 	 * @param _whitelist Either to whitelist or not
1284 	 */
1285 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
1286 		require (_account != address(0));
1287 		whitelist[_account] = _whitelist;
1288 	}
1289 
1290 	/**
1291 	 * @dev The AO set the AOIon Address
1292 	 * @param _aoIonAddress The address of AOIon
1293 	 */
1294 	function setAOIonAddress(address _aoIonAddress) public onlyTheAO {
1295 		require (_aoIonAddress != address(0));
1296 		aoIonAddress = _aoIonAddress;
1297 		_aoIon = AOIon(_aoIonAddress);
1298 	}
1299 
1300 	/**
1301 	 * @dev The AO set the NameTAOPosition Address
1302 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
1303 	 */
1304 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
1305 		require (_nameTAOPositionAddress != address(0));
1306 		nameTAOPositionAddress = _nameTAOPositionAddress;
1307 	}
1308 
1309 	/**
1310 	 * @dev Allows TheAO to transfer `_amount` of ERC20 Token from this address to `_recipient`
1311 	 * @param _erc20TokenAddress The address of ERC20 Token
1312 	 * @param _recipient The recipient address
1313 	 * @param _amount The amount to transfer
1314 	 */
1315 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyTheAO {
1316 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
1317 		require (_erc20.transfer(_recipient, _amount));
1318 	}
1319 
1320 	/**
1321 	 * @dev Add an ERC20 Token to the list
1322 	 * @param _tokenAddress The address of the ERC20 Token
1323 	 * @param _price The price of this token to AOETH
1324 	 * @param _maxQuantity Maximum quantity allowed for exchange
1325 	 */
1326 	function addERC20Token(address _tokenAddress, uint256 _price, uint256 _maxQuantity) public onlyTheAO {
1327 		require (_tokenAddress != address(0) && _price > 0 && _maxQuantity > 0);
1328 		require (AOLibrary.isValidERC20TokenAddress(_tokenAddress));
1329 		require (erc20TokenIdLookup[_tokenAddress] == 0);
1330 
1331 		totalERC20Tokens++;
1332 		erc20TokenIdLookup[_tokenAddress] = totalERC20Tokens;
1333 		ERC20Token storage _erc20Token = erc20Tokens[totalERC20Tokens];
1334 		_erc20Token.tokenAddress = _tokenAddress;
1335 		_erc20Token.price = _price;
1336 		_erc20Token.maxQuantity = _maxQuantity;
1337 		_erc20Token.active = true;
1338 		emit AddERC20Token(_erc20Token.tokenAddress, _erc20Token.price, _erc20Token.maxQuantity);
1339 	}
1340 
1341 	/**
1342 	 * @dev Set price for existing ERC20 Token
1343 	 * @param _tokenAddress The address of the ERC20 Token
1344 	 * @param _price The price of this token to AOETH
1345 	 */
1346 	function setPrice(address _tokenAddress, uint256 _price) public onlyTheAO {
1347 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1348 		require (_price > 0);
1349 
1350 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
1351 		_erc20Token.price = _price;
1352 		emit SetPrice(_erc20Token.tokenAddress, _erc20Token.price);
1353 	}
1354 
1355 	/**
1356 	 * @dev Set max quantity for existing ERC20 Token
1357 	 * @param _tokenAddress The address of the ERC20 Token
1358 	 * @param _maxQuantity The max exchange quantity for this token
1359 	 */
1360 	function setMaxQuantity(address _tokenAddress, uint256 _maxQuantity) public onlyTheAO {
1361 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1362 
1363 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
1364 		require (_maxQuantity > _erc20Token.exchangedQuantity);
1365 		_erc20Token.maxQuantity = _maxQuantity;
1366 		emit SetMaxQuantity(_erc20Token.tokenAddress, _erc20Token.maxQuantity);
1367 	}
1368 
1369 	/**
1370 	 * @dev Set active status for existing ERC20 Token
1371 	 * @param _tokenAddress The address of the ERC20 Token
1372 	 * @param _active The active status for this token
1373 	 */
1374 	function setActive(address _tokenAddress, bool _active) public onlyTheAO {
1375 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1376 
1377 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
1378 		_erc20Token.active = _active;
1379 		emit SetActive(_erc20Token.tokenAddress, _erc20Token.active);
1380 	}
1381 
1382 	/**
1383 	 * @dev Whitelisted address transfer tokens from other address
1384 	 *
1385 	 * Send `_value` tokens to `_to` on behalf of `_from`
1386 	 *
1387 	 * @param _from The address of the sender
1388 	 * @param _to The address of the recipient
1389 	 * @param _value the amount to send
1390 	 */
1391 	function whitelistTransferFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool success) {
1392 		_transfer(_from, _to, _value);
1393 		return true;
1394 	}
1395 
1396 	/***** PUBLIC METHODS *****/
1397 	/**
1398 	 * @dev Get an ERC20 Token information given an ID
1399 	 * @param _id The internal ID of the ERC20 Token
1400 	 * @return The ERC20 Token address
1401 	 * @return The name of the token
1402 	 * @return The symbol of the token
1403 	 * @return The price of this token to AOETH
1404 	 * @return The max quantity for exchange
1405 	 * @return The total AOETH exchanged from this token
1406 	 * @return The status of this token
1407 	 */
1408 	function getById(uint256 _id) public view returns (address, string memory, string memory, uint256, uint256, uint256, bool) {
1409 		require (erc20Tokens[_id].tokenAddress != address(0));
1410 		ERC20Token memory _erc20Token = erc20Tokens[_id];
1411 		return (
1412 			_erc20Token.tokenAddress,
1413 			TokenERC20(_erc20Token.tokenAddress).name(),
1414 			TokenERC20(_erc20Token.tokenAddress).symbol(),
1415 			_erc20Token.price,
1416 			_erc20Token.maxQuantity,
1417 			_erc20Token.exchangedQuantity,
1418 			_erc20Token.active
1419 		);
1420 	}
1421 
1422 	/**
1423 	 * @dev Get an ERC20 Token information given an address
1424 	 * @param _tokenAddress The address of the ERC20 Token
1425 	 * @return The ERC20 Token address
1426 	 * @return The name of the token
1427 	 * @return The symbol of the token
1428 	 * @return The price of this token to AOETH
1429 	 * @return The max quantity for exchange
1430 	 * @return The total AOETH exchanged from this token
1431 	 * @return The status of this token
1432 	 */
1433 	function getByAddress(address _tokenAddress) public view returns (address, string memory, string memory, uint256, uint256, uint256, bool) {
1434 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1435 		return getById(erc20TokenIdLookup[_tokenAddress]);
1436 	}
1437 
1438 	/**
1439 	 * @dev When a user approves AOETH to spend on his/her behalf (i.e exchange to AOETH)
1440 	 * @param _from The user address that approved AOETH
1441 	 * @param _value The amount that the user approved
1442 	 * @param _token The address of the ERC20 Token
1443 	 * @param _extraData The extra data sent during the approval
1444 	 */
1445 	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external {
1446 		require (_from != address(0));
1447 		require (AOLibrary.isValidERC20TokenAddress(_token));
1448 
1449 		// Check if the token is supported
1450 		require (erc20TokenIdLookup[_token] > 0);
1451 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_token]];
1452 		require (_erc20Token.active && _erc20Token.price > 0 && _erc20Token.exchangedQuantity < _erc20Token.maxQuantity);
1453 
1454 		uint256 amountToTransfer = _value.div(_erc20Token.price);
1455 		require (_erc20Token.maxQuantity.sub(_erc20Token.exchangedQuantity) >= amountToTransfer);
1456 		require (_aoIon.availableETH() >= amountToTransfer);
1457 
1458 		// Transfer the ERC20 Token from the `_from` address to here
1459 		require (TokenERC20(_token).transferFrom(_from, address(this), _value));
1460 
1461 		_erc20Token.exchangedQuantity = _erc20Token.exchangedQuantity.add(amountToTransfer);
1462 		balanceOf[_from] = balanceOf[_from].add(amountToTransfer);
1463 		totalSupply = totalSupply.add(amountToTransfer);
1464 
1465 		// Store the TokenExchange information
1466 		totalTokenExchanges++;
1467 		totalAddressTokenExchanges[_from]++;
1468 		bytes32 _exchangeId = keccak256(abi.encodePacked(this, _from, totalTokenExchanges));
1469 		tokenExchangeIdLookup[_exchangeId] = totalTokenExchanges;
1470 
1471 		TokenExchange storage _tokenExchange = tokenExchanges[totalTokenExchanges];
1472 		_tokenExchange.exchangeId = _exchangeId;
1473 		_tokenExchange.buyer = _from;
1474 		_tokenExchange.tokenAddress = _token;
1475 		_tokenExchange.price = _erc20Token.price;
1476 		_tokenExchange.sentAmount = _value;
1477 		_tokenExchange.receivedAmount = amountToTransfer;
1478 		_tokenExchange.extraData = _extraData;
1479 
1480 		emit ExchangeToken(_tokenExchange.exchangeId, _tokenExchange.buyer, _tokenExchange.tokenAddress, TokenERC20(_token).name(), TokenERC20(_token).symbol(), _tokenExchange.sentAmount, _tokenExchange.receivedAmount, _tokenExchange.extraData);
1481 	}
1482 
1483 	/**
1484 	 * @dev Get TokenExchange information given an exchange ID
1485 	 * @param _exchangeId The exchange ID to query
1486 	 * @return The buyer address
1487 	 * @return The sent ERC20 Token address
1488 	 * @return The ERC20 Token name
1489 	 * @return The ERC20 Token symbol
1490 	 * @return The price of ERC20 Token to AOETH
1491 	 * @return The amount of ERC20 Token sent
1492 	 * @return The amount of AOETH received
1493 	 * @return Extra data during the transaction
1494 	 */
1495 	function getTokenExchangeById(bytes32 _exchangeId) public view returns (address, address, string memory, string memory, uint256, uint256,  uint256, bytes memory) {
1496 		require (tokenExchangeIdLookup[_exchangeId] > 0);
1497 		TokenExchange memory _tokenExchange = tokenExchanges[tokenExchangeIdLookup[_exchangeId]];
1498 		return (
1499 			_tokenExchange.buyer,
1500 			_tokenExchange.tokenAddress,
1501 			TokenERC20(_tokenExchange.tokenAddress).name(),
1502 			TokenERC20(_tokenExchange.tokenAddress).symbol(),
1503 			_tokenExchange.price,
1504 			_tokenExchange.sentAmount,
1505 			_tokenExchange.receivedAmount,
1506 			_tokenExchange.extraData
1507 		);
1508 	}
1509 }
1510 
1511 
1512 /**
1513  * @title AOIon
1514  */
1515 contract AOIon is AOIonInterface {
1516 	using SafeMath for uint256;
1517 
1518 	address public aoIonLotAddress;
1519 	address public settingTAOId;
1520 	address public aoSettingAddress;
1521 	address public aoethAddress;
1522 
1523 	// AO Dev Team addresses to receive Primordial/Network Ions
1524 	address public aoDevTeam1 = 0x146CbD9821e6A42c8ff6DC903fe91CB69625A105;
1525 	address public aoDevTeam2 = 0x4810aF1dA3aC827259eEa72ef845F4206C703E8D;
1526 
1527 	IAOIonLot internal _aoIonLot;
1528 	IAOSetting internal _aoSetting;
1529 	AOETH internal _aoeth;
1530 
1531 	/***** PRIMORDIAL ION VARIABLES *****/
1532 	uint256 public primordialTotalSupply;
1533 	uint256 public primordialTotalBought;
1534 	uint256 public primordialSellPrice;
1535 	uint256 public primordialBuyPrice;
1536 	uint256 public totalEthForPrimordial;	// Total ETH sent for Primordial AO+
1537 	uint256 public totalRedeemedAOETH;		// Total AOETH redeemed for Primordial AO+
1538 
1539 	// Total available primordial ion for sale 3,377,699,720,527,872 AO+
1540 	uint256 constant public TOTAL_PRIMORDIAL_FOR_SALE = 3377699720527872;
1541 
1542 	mapping (address => uint256) public primordialBalanceOf;
1543 	mapping (address => mapping (address => uint256)) public primordialAllowance;
1544 
1545 	// Mapping from owner's lot weighted multiplier to the amount of staked ions
1546 	mapping (address => mapping (uint256 => uint256)) public primordialStakedBalance;
1547 
1548 	event PrimordialTransfer(address indexed from, address indexed to, uint256 value);
1549 	event PrimordialApproval(address indexed _owner, address indexed _spender, uint256 _value);
1550 	event PrimordialBurn(address indexed from, uint256 value);
1551 	event PrimordialStake(address indexed from, uint256 value, uint256 weightedMultiplier);
1552 	event PrimordialUnstake(address indexed from, uint256 value, uint256 weightedMultiplier);
1553 
1554 	event NetworkExchangeEnded();
1555 
1556 	bool public networkExchangeEnded;
1557 
1558 	// Mapping from owner to his/her current weighted multiplier
1559 	mapping (address => uint256) internal ownerWeightedMultiplier;
1560 
1561 	// Mapping from owner to his/her max multiplier (multiplier of account's first Lot)
1562 	mapping (address => uint256) internal ownerMaxMultiplier;
1563 
1564 	// Event to be broadcasted to public when user buys primordial ion
1565 	// payWith 1 == with Ethereum
1566 	// payWith 2 == with AOETH
1567 	event BuyPrimordial(address indexed lotOwner, bytes32 indexed lotId, uint8 payWith, uint256 sentAmount, uint256 refundedAmount);
1568 
1569 	/**
1570 	 * @dev Constructor function
1571 	 */
1572 	constructor(string memory _name, string memory _symbol, address _settingTAOId, address _aoSettingAddress, address _nameTAOPositionAddress, address _namePublicKeyAddress, address _nameAccountRecoveryAddress)
1573 		AOIonInterface(_name, _symbol, _nameTAOPositionAddress, _namePublicKeyAddress, _nameAccountRecoveryAddress) public {
1574 		setSettingTAOId(_settingTAOId);
1575 		setAOSettingAddress(_aoSettingAddress);
1576 
1577 		powerOfTen = 0;
1578 		decimals = 0;
1579 		setPrimordialPrices(0, 10 ** 8); // Set Primordial buy price to 0.1 gwei/ion
1580 	}
1581 
1582 	/**
1583 	 * @dev Checks if buyer can buy primordial ion
1584 	 */
1585 	modifier canBuyPrimordial(uint256 _sentAmount, bool _withETH) {
1586 		require (networkExchangeEnded == false &&
1587 			primordialTotalBought < TOTAL_PRIMORDIAL_FOR_SALE &&
1588 			primordialBuyPrice > 0 &&
1589 			_sentAmount > 0 &&
1590 			availablePrimordialForSaleInETH() > 0 &&
1591 			(
1592 				(_withETH && availableETH() > 0) ||
1593 				(!_withETH && totalRedeemedAOETH < _aoeth.totalSupply())
1594 			)
1595 		);
1596 		_;
1597 	}
1598 
1599 	/***** The AO ONLY METHODS *****/
1600 	/**
1601 	 * @dev The AO sets AOIonLot address
1602 	 * @param _aoIonLotAddress The address of AOIonLot
1603 	 */
1604 	function setAOIonLotAddress(address _aoIonLotAddress) public onlyTheAO {
1605 		require (_aoIonLotAddress != address(0));
1606 		aoIonLotAddress = _aoIonLotAddress;
1607 		_aoIonLot = IAOIonLot(_aoIonLotAddress);
1608 	}
1609 
1610 	/**
1611 	 * @dev The AO sets setting TAO ID
1612 	 * @param _settingTAOId The new setting TAO ID to set
1613 	 */
1614 	function setSettingTAOId(address _settingTAOId) public onlyTheAO {
1615 		require (AOLibrary.isTAO(_settingTAOId));
1616 		settingTAOId = _settingTAOId;
1617 	}
1618 
1619 	/**
1620 	 * @dev The AO sets AO Setting address
1621 	 * @param _aoSettingAddress The address of AOSetting
1622 	 */
1623 	function setAOSettingAddress(address _aoSettingAddress) public onlyTheAO {
1624 		require (_aoSettingAddress != address(0));
1625 		aoSettingAddress = _aoSettingAddress;
1626 		_aoSetting = IAOSetting(_aoSettingAddress);
1627 	}
1628 
1629 	/**
1630 	 * @dev Set AO Dev team addresses to receive Primordial/Network ions during network exchange
1631 	 * @param _aoDevTeam1 The first AO dev team address
1632 	 * @param _aoDevTeam2 The second AO dev team address
1633 	 */
1634 	function setAODevTeamAddresses(address _aoDevTeam1, address _aoDevTeam2) public onlyTheAO {
1635 		aoDevTeam1 = _aoDevTeam1;
1636 		aoDevTeam2 = _aoDevTeam2;
1637 	}
1638 
1639 	/**
1640 	 * @dev Set AOETH address
1641 	 * @param _aoethAddress The address of AOETH
1642 	 */
1643 	function setAOETHAddress(address _aoethAddress) public onlyTheAO {
1644 		require (_aoethAddress != address(0));
1645 		aoethAddress = _aoethAddress;
1646 		_aoeth = AOETH(_aoethAddress);
1647 	}
1648 
1649 	/***** PRIMORDIAL ION THE AO ONLY METHODS *****/
1650 	/**
1651 	 * @dev Allow users to buy Primordial ions for `newBuyPrice` eth and sell Primordial ions for `newSellPrice` eth
1652 	 * @param newPrimordialSellPrice Price users can sell to the contract
1653 	 * @param newPrimordialBuyPrice Price users can buy from the contract
1654 	 */
1655 	function setPrimordialPrices(uint256 newPrimordialSellPrice, uint256 newPrimordialBuyPrice) public onlyTheAO {
1656 		primordialSellPrice = newPrimordialSellPrice;
1657 		primordialBuyPrice = newPrimordialBuyPrice;
1658 	}
1659 
1660 	/**
1661 	 * @dev Only the AO can force end network exchange
1662 	 */
1663 	function endNetworkExchange() public onlyTheAO {
1664 		require (!networkExchangeEnded);
1665 		networkExchangeEnded = true;
1666 		emit NetworkExchangeEnded();
1667 	}
1668 
1669 	/***** PRIMORDIAL ION WHITELISTED ADDRESS ONLY METHODS *****/
1670 	/**
1671 	 * @dev Stake `_value` Primordial ions at `_weightedMultiplier ` multiplier on behalf of `_from`
1672 	 * @param _from The address of the target
1673 	 * @param _value The amount of Primordial ions to stake
1674 	 * @param _weightedMultiplier The weighted multiplier of the Primordial ions
1675 	 * @return true on success
1676 	 */
1677 	function stakePrimordialFrom(address _from, uint256 _value, uint256 _weightedMultiplier) public inWhitelist returns (bool) {
1678 		// Check if the targeted balance is enough
1679 		require (primordialBalanceOf[_from] >= _value);
1680 		// Make sure the weighted multiplier is the same as account's current weighted multiplier
1681 		require (_weightedMultiplier == ownerWeightedMultiplier[_from]);
1682 		// Subtract from the targeted balance
1683 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);
1684 		// Add to the targeted staked balance
1685 		primordialStakedBalance[_from][_weightedMultiplier] = primordialStakedBalance[_from][_weightedMultiplier].add(_value);
1686 		emit PrimordialStake(_from, _value, _weightedMultiplier);
1687 		return true;
1688 	}
1689 
1690 	/**
1691 	 * @dev Unstake `_value` Primordial ions at `_weightedMultiplier` on behalf of `_from`
1692 	 * @param _from The address of the target
1693 	 * @param _value The amount to unstake
1694 	 * @param _weightedMultiplier The weighted multiplier of the Primordial ions
1695 	 * @return true on success
1696 	 */
1697 	function unstakePrimordialFrom(address _from, uint256 _value, uint256 _weightedMultiplier) public inWhitelist returns (bool) {
1698 		// Check if the targeted staked balance is enough
1699 		require (primordialStakedBalance[_from][_weightedMultiplier] >= _value);
1700 		// Subtract from the targeted staked balance
1701 		primordialStakedBalance[_from][_weightedMultiplier] = primordialStakedBalance[_from][_weightedMultiplier].sub(_value);
1702 		// Add to the targeted balance
1703 		primordialBalanceOf[_from] = primordialBalanceOf[_from].add(_value);
1704 		emit PrimordialUnstake(_from, _value, _weightedMultiplier);
1705 		return true;
1706 	}
1707 
1708 	/**
1709 	 * @dev Send `_value` primordial ions to `_to` on behalf of `_from`
1710 	 * @param _from The address of the sender
1711 	 * @param _to The address of the recipient
1712 	 * @param _value The amount to send
1713 	 * @return true on success
1714 	 */
1715 	function whitelistTransferPrimordialFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool) {
1716 		return _createLotAndTransferPrimordial(_from, _to, _value);
1717 	}
1718 
1719 	/***** PUBLIC METHODS *****/
1720 	/***** PRIMORDIAL ION PUBLIC METHODS *****/
1721 	/**
1722 	 * @dev Buy Primordial ions from contract by sending ether
1723 	 */
1724 	function buyPrimordial() public payable canBuyPrimordial(msg.value, true) {
1725 		(uint256 amount, uint256 remainderBudget, bool shouldEndNetworkExchange) = _calculateAmountAndRemainderBudget(msg.value, true);
1726 		require (amount > 0);
1727 
1728 		// Ends network exchange if necessary
1729 		if (shouldEndNetworkExchange) {
1730 			networkExchangeEnded = true;
1731 			emit NetworkExchangeEnded();
1732 		}
1733 
1734 		// Update totalEthForPrimordial
1735 		totalEthForPrimordial = totalEthForPrimordial.add(msg.value.sub(remainderBudget));
1736 
1737 		// Send the primordial ion to buyer and reward AO devs
1738 		bytes32 _lotId = _sendPrimordialAndRewardDev(amount, msg.sender);
1739 
1740 		emit BuyPrimordial(msg.sender, _lotId, 1, msg.value, remainderBudget);
1741 
1742 		// Send remainder budget back to buyer if exist
1743 		if (remainderBudget > 0) {
1744 			msg.sender.transfer(remainderBudget);
1745 		}
1746 	}
1747 
1748 	/**
1749 	 * @dev Buy Primordial ion from contract by sending AOETH
1750 	 */
1751 	function buyPrimordialWithAOETH(uint256 _aoethAmount) public canBuyPrimordial(_aoethAmount, false) {
1752 		(uint256 amount, uint256 remainderBudget, bool shouldEndNetworkExchange) = _calculateAmountAndRemainderBudget(_aoethAmount, false);
1753 		require (amount > 0);
1754 
1755 		// Ends network exchange if necessary
1756 		if (shouldEndNetworkExchange) {
1757 			networkExchangeEnded = true;
1758 			emit NetworkExchangeEnded();
1759 		}
1760 
1761 		// Calculate the actual AOETH that was charged for this transaction
1762 		uint256 actualCharge = _aoethAmount.sub(remainderBudget);
1763 
1764 		// Update totalRedeemedAOETH
1765 		totalRedeemedAOETH = totalRedeemedAOETH.add(actualCharge);
1766 
1767 		// Transfer AOETH from buyer to here
1768 		require (_aoeth.whitelistTransferFrom(msg.sender, address(this), actualCharge));
1769 
1770 		// Send the primordial ion to buyer and reward AO devs
1771 		bytes32 _lotId = _sendPrimordialAndRewardDev(amount, msg.sender);
1772 
1773 		emit BuyPrimordial(msg.sender, _lotId, 2, _aoethAmount, remainderBudget);
1774 	}
1775 
1776 	/**
1777 	 * @dev Send `_value` Primordial ions to `_to` from your account
1778 	 * @param _to The address of the recipient
1779 	 * @param _value The amount to send
1780 	 * @return true on success
1781 	 */
1782 	function transferPrimordial(address _to, uint256 _value) public returns (bool) {
1783 		return _createLotAndTransferPrimordial(msg.sender, _to, _value);
1784 	}
1785 
1786 	/**
1787 	 * @dev Send `_value` Primordial ions to `_to` from `_from`
1788 	 * @param _from The address of the sender
1789 	 * @param _to The address of the recipient
1790 	 * @param _value The amount to send
1791 	 * @return true on success
1792 	 */
1793 	function transferPrimordialFrom(address _from, address _to, uint256 _value) public returns (bool) {
1794 		require (_value <= primordialAllowance[_from][msg.sender]);
1795 		primordialAllowance[_from][msg.sender] = primordialAllowance[_from][msg.sender].sub(_value);
1796 
1797 		return _createLotAndTransferPrimordial(_from, _to, _value);
1798 	}
1799 
1800 	/**
1801 	 * Transfer primordial ions between public key addresses in a Name
1802 	 * @param _nameId The ID of the Name
1803 	 * @param _from The address of the sender
1804 	 * @param _to The address of the recipient
1805 	 * @param _value the amount to send
1806 	 */
1807 	function transferPrimordialBetweenPublicKeys(address _nameId, address _from, address _to, uint256 _value) public returns (bool) {
1808 		require (AOLibrary.isName(_nameId));
1809 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _nameId));
1810 		require (!_nameAccountRecovery.isCompromised(_nameId));
1811 		// Make sure _from exist in the Name's Public Keys
1812 		require (_namePublicKey.isKeyExist(_nameId, _from));
1813 		// Make sure _to exist in the Name's Public Keys
1814 		require (_namePublicKey.isKeyExist(_nameId, _to));
1815 		return _createLotAndTransferPrimordial(_from, _to, _value);
1816 	}
1817 
1818 	/**
1819 	 * @dev Allows `_spender` to spend no more than `_value` Primordial ions in your behalf
1820 	 * @param _spender The address authorized to spend
1821 	 * @param _value The max amount they can spend
1822 	 * @return true on success
1823 	 */
1824 	function approvePrimordial(address _spender, uint256 _value) public returns (bool) {
1825 		primordialAllowance[msg.sender][_spender] = _value;
1826 		emit PrimordialApproval(msg.sender, _spender, _value);
1827 		return true;
1828 	}
1829 
1830 	/**
1831 	 * @dev Allows `_spender` to spend no more than `_value` Primordial ions in your behalf, and then ping the contract about it
1832 	 * @param _spender The address authorized to spend
1833 	 * @param _value The max amount they can spend
1834 	 * @param _extraData some extra information to send to the approved contract
1835 	 * @return true on success
1836 	 */
1837 	function approvePrimordialAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool) {
1838 		tokenRecipient spender = tokenRecipient(_spender);
1839 		if (approvePrimordial(_spender, _value)) {
1840 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
1841 			return true;
1842 		}
1843 	}
1844 
1845 	/**
1846 	 * @dev Remove `_value` Primordial ions from the system irreversibly
1847 	 *		and re-weight the account's multiplier after burn
1848 	 * @param _value The amount to burn
1849 	 * @return true on success
1850 	 */
1851 	function burnPrimordial(uint256 _value) public returns (bool) {
1852 		require (primordialBalanceOf[msg.sender] >= _value);
1853 		require (calculateMaximumBurnAmount(msg.sender) >= _value);
1854 
1855 		// Update the account's multiplier
1856 		ownerWeightedMultiplier[msg.sender] = calculateMultiplierAfterBurn(msg.sender, _value);
1857 		primordialBalanceOf[msg.sender] = primordialBalanceOf[msg.sender].sub(_value);
1858 		primordialTotalSupply = primordialTotalSupply.sub(_value);
1859 
1860 		// Store burn lot info
1861 		require (_aoIonLot.createBurnLot(msg.sender, _value, ownerWeightedMultiplier[msg.sender]));
1862 		emit PrimordialBurn(msg.sender, _value);
1863 		return true;
1864 	}
1865 
1866 	/**
1867 	 * @dev Remove `_value` Primordial ions from the system irreversibly on behalf of `_from`
1868 	 *		and re-weight `_from`'s multiplier after burn
1869 	 * @param _from The address of sender
1870 	 * @param _value The amount to burn
1871 	 * @return true on success
1872 	 */
1873 	function burnPrimordialFrom(address _from, uint256 _value) public returns (bool) {
1874 		require (primordialBalanceOf[_from] >= _value);
1875 		require (primordialAllowance[_from][msg.sender] >= _value);
1876 		require (calculateMaximumBurnAmount(_from) >= _value);
1877 
1878 		// Update `_from`'s multiplier
1879 		ownerWeightedMultiplier[_from] = calculateMultiplierAfterBurn(_from, _value);
1880 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);
1881 		primordialAllowance[_from][msg.sender] = primordialAllowance[_from][msg.sender].sub(_value);
1882 		primordialTotalSupply = primordialTotalSupply.sub(_value);
1883 
1884 		// Store burn lot info
1885 		require (_aoIonLot.createBurnLot(_from, _value, ownerWeightedMultiplier[_from]));
1886 		emit PrimordialBurn(_from, _value);
1887 		return true;
1888 	}
1889 
1890 	/**
1891 	 * @dev Return the average weighted multiplier of all lots owned by an address
1892 	 * @param _lotOwner The address of the lot owner
1893 	 * @return the weighted multiplier of the address (in 10 ** 6)
1894 	 */
1895 	function weightedMultiplierByAddress(address _lotOwner) public view returns (uint256) {
1896 		return ownerWeightedMultiplier[_lotOwner];
1897 	}
1898 
1899 	/**
1900 	 * @dev Return the max multiplier of an address
1901 	 * @param _target The address to query
1902 	 * @return the max multiplier of the address (in 10 ** 6)
1903 	 */
1904 	function maxMultiplierByAddress(address _target) public view returns (uint256) {
1905 		return (_aoIonLot.totalLotsByAddress(_target) > 0) ? ownerMaxMultiplier[_target] : 0;
1906 	}
1907 
1908 	/**
1909 	 * @dev Calculate the primordial ion multiplier, bonus network ion percentage, and the
1910 	 *		bonus network ion amount on a given lot when someone purchases primordial ion
1911 	 *		during network exchange
1912 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
1913 	 * @return The multiplier in (10 ** 6)
1914 	 * @return The bonus percentage
1915 	 * @return The amount of network ion as bonus
1916 	 */
1917 	function calculateMultiplierAndBonus(uint256 _purchaseAmount) public view returns (uint256, uint256, uint256) {
1918 		(uint256 startingPrimordialMultiplier, uint256 endingPrimordialMultiplier, uint256 startingNetworkBonusMultiplier, uint256 endingNetworkBonusMultiplier) = _getSettingVariables();
1919 		return (
1920 			AOLibrary.calculatePrimordialMultiplier(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingPrimordialMultiplier, endingPrimordialMultiplier),
1921 			AOLibrary.calculateNetworkBonusPercentage(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier),
1922 			AOLibrary.calculateNetworkBonusAmount(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier)
1923 		);
1924 	}
1925 
1926 	/**
1927 	 * @dev Calculate the maximum amount of Primordial an account can burn
1928 	 * @param _account The address of the account
1929 	 * @return The maximum primordial ion amount to burn
1930 	 */
1931 	function calculateMaximumBurnAmount(address _account) public view returns (uint256) {
1932 		return AOLibrary.calculateMaximumBurnAmount(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], ownerMaxMultiplier[_account]);
1933 	}
1934 
1935 	/**
1936 	 * @dev Calculate account's new multiplier after burn `_amountToBurn` primordial ions
1937 	 * @param _account The address of the account
1938 	 * @param _amountToBurn The amount of primordial ion to burn
1939 	 * @return The new multiplier in (10 ** 6)
1940 	 */
1941 	function calculateMultiplierAfterBurn(address _account, uint256 _amountToBurn) public view returns (uint256) {
1942 		require (calculateMaximumBurnAmount(_account) >= _amountToBurn);
1943 		return AOLibrary.calculateMultiplierAfterBurn(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], _amountToBurn);
1944 	}
1945 
1946 	/**
1947 	 * @dev Calculate account's new multiplier after converting `amountToConvert` network ion to primordial ion
1948 	 * @param _account The address of the account
1949 	 * @param _amountToConvert The amount of network ion to convert
1950 	 * @return The new multiplier in (10 ** 6)
1951 	 */
1952 	function calculateMultiplierAfterConversion(address _account, uint256 _amountToConvert) public view returns (uint256) {
1953 		return AOLibrary.calculateMultiplierAfterConversion(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], _amountToConvert);
1954 	}
1955 
1956 	/**
1957 	 * @dev Convert `_value` of network ions to primordial ions
1958 	 *		and re-weight the account's multiplier after conversion
1959 	 * @param _value The amount to convert
1960 	 * @return true on success
1961 	 */
1962 	function convertToPrimordial(uint256 _value) public returns (bool) {
1963 		require (balanceOf[msg.sender] >= _value);
1964 
1965 		// Update the account's multiplier
1966 		ownerWeightedMultiplier[msg.sender] = calculateMultiplierAfterConversion(msg.sender, _value);
1967 		// Burn network ion
1968 		burn(_value);
1969 		// mint primordial ion
1970 		_mintPrimordial(msg.sender, _value);
1971 
1972 		require (_aoIonLot.createConvertLot(msg.sender, _value, ownerWeightedMultiplier[msg.sender]));
1973 		return true;
1974 	}
1975 
1976 	/**
1977 	 * @dev Get quantity of AO+ left in Network Exchange
1978 	 * @return The quantity of AO+ left in Network Exchange
1979 	 */
1980 	function availablePrimordialForSale() public view returns (uint256) {
1981 		return TOTAL_PRIMORDIAL_FOR_SALE.sub(primordialTotalBought);
1982 	}
1983 
1984 	/**
1985 	 * @dev Get quantity of AO+ in ETH left in Network Exchange (i.e How much ETH is there total that can be
1986 	 *		exchanged for AO+
1987 	 * @return The quantity of AO+ in ETH left in Network Exchange
1988 	 */
1989 	function availablePrimordialForSaleInETH() public view returns (uint256) {
1990 		return availablePrimordialForSale().mul(primordialBuyPrice);
1991 	}
1992 
1993 	/**
1994 	 * @dev Get maximum quantity of AOETH or ETH that can still be sold
1995 	 * @return The maximum quantity of AOETH or ETH that can still be sold
1996 	 */
1997 	function availableETH() public view returns (uint256) {
1998 		if (availablePrimordialForSaleInETH() > 0) {
1999 			uint256 _availableETH = availablePrimordialForSaleInETH().sub(_aoeth.totalSupply().sub(totalRedeemedAOETH));
2000 			if (availablePrimordialForSale() == 1 && _availableETH < primordialBuyPrice) {
2001 				return primordialBuyPrice;
2002 			} else {
2003 				return _availableETH;
2004 			}
2005 		} else {
2006 			return 0;
2007 		}
2008 	}
2009 
2010 	/***** INTERNAL METHODS *****/
2011 	/***** PRIMORDIAL ION INTERNAL METHODS *****/
2012 	/**
2013 	 * @dev Calculate the amount of ion the buyer will receive and remaining budget if exist
2014 	 *		when he/she buys primordial ion
2015 	 * @param _budget The amount of ETH sent by buyer
2016 	 * @param _withETH Whether or not buyer is paying with ETH
2017 	 * @return uint256 of the amount the buyer will receiver
2018 	 * @return uint256 of the remaining budget, if exist
2019 	 * @return bool whether or not the network exchange should end
2020 	 */
2021 	function _calculateAmountAndRemainderBudget(uint256 _budget, bool _withETH) internal view returns (uint256, uint256, bool) {
2022 		// Calculate the amount of ion
2023 		uint256 amount = _budget.div(primordialBuyPrice);
2024 
2025 		// If we need to return ETH to the buyer, in the case
2026 		// where the buyer sends more ETH than available primordial ion to be purchased
2027 		uint256 remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
2028 
2029 		uint256 _availableETH = availableETH();
2030 		// If paying with ETH, it can't exceed availableETH
2031 		if (_withETH && _budget > availableETH()) {
2032 			// Calculate the amount of ions
2033 			amount = _availableETH.div(primordialBuyPrice);
2034 			remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
2035 		}
2036 
2037 		// Make sure primordialTotalBought is not overflowing
2038 		bool shouldEndNetworkExchange = false;
2039 		if (primordialTotalBought.add(amount) >= TOTAL_PRIMORDIAL_FOR_SALE) {
2040 			amount = TOTAL_PRIMORDIAL_FOR_SALE.sub(primordialTotalBought);
2041 			shouldEndNetworkExchange = true;
2042 			remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
2043 		}
2044 		return (amount, remainderEth, shouldEndNetworkExchange);
2045 	}
2046 
2047 	/**
2048 	 * @dev Actually sending the primordial ion to buyer and reward AO devs accordingly
2049 	 * @param amount The amount of primordial ion to be sent to buyer
2050 	 * @param to The recipient of ion
2051 	 * @return the lot Id of the buyer
2052 	 */
2053 	function _sendPrimordialAndRewardDev(uint256 amount, address to) internal returns (bytes32) {
2054 		(uint256 startingPrimordialMultiplier,, uint256 startingNetworkBonusMultiplier, uint256 endingNetworkBonusMultiplier) = _getSettingVariables();
2055 
2056 		// Update primordialTotalBought
2057 		(uint256 multiplier, uint256 networkBonusPercentage, uint256 networkBonusAmount) = calculateMultiplierAndBonus(amount);
2058 		primordialTotalBought = primordialTotalBought.add(amount);
2059 		bytes32 _lotId = _createPrimordialLot(to, amount, multiplier, networkBonusAmount);
2060 
2061 		// Calculate The AO and AO Dev Team's portion of Primordial and Network ion Bonus
2062 		uint256 inverseMultiplier = startingPrimordialMultiplier.sub(multiplier); // Inverse of the buyer's multiplier
2063 		uint256 theAONetworkBonusAmount = (startingNetworkBonusMultiplier.sub(networkBonusPercentage).add(endingNetworkBonusMultiplier)).mul(amount).div(AOLibrary.PERCENTAGE_DIVISOR());
2064 		if (aoDevTeam1 != address(0)) {
2065 			_createPrimordialLot(aoDevTeam1, amount.div(2), inverseMultiplier, theAONetworkBonusAmount.div(2));
2066 		}
2067 		if (aoDevTeam2 != address(0)) {
2068 			_createPrimordialLot(aoDevTeam2, amount.div(2), inverseMultiplier, theAONetworkBonusAmount.div(2));
2069 		}
2070 		_mint(theAO, theAONetworkBonusAmount);
2071 		return _lotId;
2072 	}
2073 
2074 	/**
2075 	 * @dev Create a lot with `primordialAmount` of primordial ions with `_multiplier` for an `account`
2076 	 *		during network exchange, and reward `_networkBonusAmount` if exist
2077 	 * @param _account Address of the lot owner
2078 	 * @param _primordialAmount The amount of primordial ions to be stored in the lot
2079 	 * @param _multiplier The multiplier for this lot in (10 ** 6)
2080 	 * @param _networkBonusAmount The network ion bonus amount
2081 	 * @return Created lot Id
2082 	 */
2083 	function _createPrimordialLot(address _account, uint256 _primordialAmount, uint256 _multiplier, uint256 _networkBonusAmount) internal returns (bytes32) {
2084 		bytes32 lotId = _aoIonLot.createPrimordialLot(_account, _primordialAmount, _multiplier, _networkBonusAmount);
2085 
2086 		ownerWeightedMultiplier[_account] = AOLibrary.calculateWeightedMultiplier(ownerWeightedMultiplier[_account], primordialBalanceOf[_account], _multiplier, _primordialAmount);
2087 
2088 		// If this is the first lot, set this as the max multiplier of the account
2089 		if (_aoIonLot.totalLotsByAddress(_account) == 1) {
2090 			ownerMaxMultiplier[_account] = _multiplier;
2091 		}
2092 		_mintPrimordial(_account, _primordialAmount);
2093 		_mint(_account, _networkBonusAmount);
2094 
2095 		return lotId;
2096 	}
2097 
2098 	/**
2099 	 * @dev Create `mintedAmount` Primordial ions and send it to `target`
2100 	 * @param target Address to receive the Primordial ions
2101 	 * @param mintedAmount The amount of Primordial ions it will receive
2102 	 */
2103 	function _mintPrimordial(address target, uint256 mintedAmount) internal {
2104 		primordialBalanceOf[target] = primordialBalanceOf[target].add(mintedAmount);
2105 		primordialTotalSupply = primordialTotalSupply.add(mintedAmount);
2106 		emit PrimordialTransfer(address(0), address(this), mintedAmount);
2107 		emit PrimordialTransfer(address(this), target, mintedAmount);
2108 	}
2109 
2110 	/**
2111 	 * @dev Create a lot with `amount` of ions at `weightedMultiplier` for an `account`
2112 	 * @param _account Address of lot owner
2113 	 * @param _amount The amount of ions
2114 	 * @param _weightedMultiplier The multiplier of the lot (in 10^6)
2115 	 * @return bytes32 of new created lot ID
2116 	 */
2117 	function _createWeightedMultiplierLot(address _account, uint256 _amount, uint256 _weightedMultiplier) internal returns (bytes32) {
2118 		require (_account != address(0));
2119 		require (_amount > 0);
2120 
2121 		bytes32 lotId = _aoIonLot.createWeightedMultiplierLot(_account, _amount, _weightedMultiplier);
2122 		// If this is the first lot, set this as the max multiplier of the account
2123 		if (_aoIonLot.totalLotsByAddress(_account) == 1) {
2124 			ownerMaxMultiplier[_account] = _weightedMultiplier;
2125 		}
2126 		return lotId;
2127 	}
2128 
2129 	/**
2130 	 * @dev Create Lot and send `_value` Primordial ions from `_from` to `_to`
2131 	 * @param _from The address of sender
2132 	 * @param _to The address of the recipient
2133 	 * @param _value The amount to send
2134 	 * @return true on success
2135 	 */
2136 	function _createLotAndTransferPrimordial(address _from, address _to, uint256 _value) internal returns (bool) {
2137 		bytes32 _createdLotId = _createWeightedMultiplierLot(_to, _value, ownerWeightedMultiplier[_from]);
2138 		(, address _lotOwner,,) = _aoIonLot.lotById(_createdLotId);
2139 
2140 		// Make sure the new lot is created successfully
2141 		require (_lotOwner == _to);
2142 
2143 		// Update the weighted multiplier of the recipient
2144 		ownerWeightedMultiplier[_to] = AOLibrary.calculateWeightedMultiplier(ownerWeightedMultiplier[_to], primordialBalanceOf[_to], ownerWeightedMultiplier[_from], _value);
2145 
2146 		// Transfer the Primordial ions
2147 		require (_transferPrimordial(_from, _to, _value));
2148 		return true;
2149 	}
2150 
2151 	/**
2152 	 * @dev Send `_value` Primordial ions from `_from` to `_to`
2153 	 * @param _from The address of sender
2154 	 * @param _to The address of the recipient
2155 	 * @param _value The amount to send
2156 	 */
2157 	function _transferPrimordial(address _from, address _to, uint256 _value) internal returns (bool) {
2158 		require (_to != address(0));									// Prevent transfer to 0x0 address. Use burn() instead
2159 		require (primordialBalanceOf[_from] >= _value);						// Check if the sender has enough
2160 		require (primordialBalanceOf[_to].add(_value) >= primordialBalanceOf[_to]);	// Check for overflows
2161 		require (!frozenAccount[_from]);								// Check if sender is frozen
2162 		require (!frozenAccount[_to]);									// Check if recipient is frozen
2163 		uint256 previousBalances = primordialBalanceOf[_from].add(primordialBalanceOf[_to]);
2164 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);			// Subtract from the sender
2165 		primordialBalanceOf[_to] = primordialBalanceOf[_to].add(_value);				// Add the same to the recipient
2166 		emit PrimordialTransfer(_from, _to, _value);
2167 		assert(primordialBalanceOf[_from].add(primordialBalanceOf[_to]) == previousBalances);
2168 		return true;
2169 	}
2170 
2171 	/**
2172 	 * @dev Get setting variables
2173 	 * @return startingPrimordialMultiplier The starting multiplier used to calculate primordial ion
2174 	 * @return endingPrimordialMultiplier The ending multiplier used to calculate primordial ion
2175 	 * @return startingNetworkBonusMultiplier The starting multiplier used to calculate network ion bonus
2176 	 * @return endingNetworkBonusMultiplier The ending multiplier used to calculate network ion bonus
2177 	 */
2178 	function _getSettingVariables() internal view returns (uint256, uint256, uint256, uint256) {
2179 		(uint256 startingPrimordialMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'startingPrimordialMultiplier');
2180 		(uint256 endingPrimordialMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'endingPrimordialMultiplier');
2181 
2182 		(uint256 startingNetworkBonusMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'startingNetworkBonusMultiplier');
2183 		(uint256 endingNetworkBonusMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'endingNetworkBonusMultiplier');
2184 
2185 		return (startingPrimordialMultiplier, endingPrimordialMultiplier, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier);
2186 	}
2187 }
2188 
2189 
2190 /**
2191  * @title NameTAOVault
2192  */
2193 contract NameTAOVault is TheAO {
2194 	using SafeMath for uint256;
2195 
2196 	address public nameFactoryAddress;
2197 	address public nameAccountRecoveryAddress;
2198 	address public aoIonAddress;
2199 
2200 	INameFactory internal _nameFactory;
2201 	INameTAOPosition internal _nameTAOPosition;
2202 	INameAccountRecovery internal _nameAccountRecovery;
2203 	AOIon internal _aoIon;
2204 
2205 	// Event to be broadcasted to public when Advocate of `from` Name/TAO transfer ETH
2206 	// `from` is a Name/TAO
2207 	event TransferEth(address indexed advocateId, address from, address to, uint256 amount);
2208 
2209 	// Event to be broadcasted to public when Advocate of `from` Name/TAO transfer ERC20 Token
2210 	// `from` is a Name/TAO
2211 	event TransferERC20(address indexed advocateId, address from, address to, uint256 amount, address erc20TokenAddress, string erc20Name, string erc20Symbol);
2212 
2213 	// Event to be broadcasted to public when Advocate of `from` Name/TAO transfer AO
2214 	// `from` is a Name/TAO
2215 	event TransferAO(address indexed advocateId, address from, address to, uint256 amount);
2216 
2217 	// Event to be broadcasted to public when Advocate of `from` Name/TAO transfer AO+
2218 	// `from` is a Name/TAO
2219 	event TransferPrimordialAO(address indexed advocateId, address from, address to, uint256 amount);
2220 
2221 	/**
2222 	 * @dev Constructor function
2223 	 */
2224 	constructor(address _nameFactoryAddress, address _nameTAOPositionAddress) public {
2225 		setNameFactoryAddress(_nameFactoryAddress);
2226 		setNameTAOPositionAddress(_nameTAOPositionAddress);
2227 	}
2228 
2229 	/**
2230 	 * @dev Checks if the calling contract address is The AO
2231 	 *		OR
2232 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
2233 	 */
2234 	modifier onlyTheAO {
2235 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
2236 		_;
2237 	}
2238 
2239 	/**
2240 	 * @dev Check if `_id` is a Name or a TAO
2241 	 */
2242 	modifier isNameOrTAO(address _id) {
2243 		require (AOLibrary.isName(_id) || AOLibrary.isTAO(_id));
2244 		_;
2245 	}
2246 
2247 	/**
2248 	 * @dev Check if msg.sender is the current advocate of Name ID
2249 	 */
2250 	modifier onlyAdvocate(address _id) {
2251 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _id));
2252 		_;
2253 	}
2254 
2255 	/**
2256 	 * @dev Only allowed if sender's Name is not compromised
2257 	 */
2258 	modifier senderNameNotCompromised() {
2259 		require (!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
2260 		_;
2261 	}
2262 
2263 	/***** THE AO ONLY METHODS *****/
2264 	/**
2265 	 * @dev Transfer ownership of The AO to new address
2266 	 * @param _theAO The new address to be transferred
2267 	 */
2268 	function transferOwnership(address _theAO) public onlyTheAO {
2269 		require (_theAO != address(0));
2270 		theAO = _theAO;
2271 	}
2272 
2273 	/**
2274 	 * @dev Whitelist `_account` address to transact on behalf of others
2275 	 * @param _account The address to whitelist
2276 	 * @param _whitelist Either to whitelist or not
2277 	 */
2278 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
2279 		require (_account != address(0));
2280 		whitelist[_account] = _whitelist;
2281 	}
2282 
2283 	/**
2284 	 * @dev The AO sets NameFactory address
2285 	 * @param _nameFactoryAddress The address of NameFactory
2286 	 */
2287 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
2288 		require (_nameFactoryAddress != address(0));
2289 		nameFactoryAddress = _nameFactoryAddress;
2290 		_nameFactory = INameFactory(_nameFactoryAddress);
2291 	}
2292 
2293 	/**
2294 	 * @dev The AO sets NameTAOPosition address
2295 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
2296 	 */
2297 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
2298 		require (_nameTAOPositionAddress != address(0));
2299 		nameTAOPositionAddress = _nameTAOPositionAddress;
2300 		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
2301 	}
2302 
2303 	/**
2304 	 * @dev The AO set the NameAccountRecovery Address
2305 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
2306 	 */
2307 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
2308 		require (_nameAccountRecoveryAddress != address(0));
2309 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
2310 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
2311 	}
2312 
2313 	/**
2314 	 * @dev The AO sets AOIon (base denomination of AO) address
2315 	 * @param _aoIonAddress The address of AOIon
2316 	 */
2317 	function setAOIonAddress(address _aoIonAddress) public onlyTheAO {
2318 		require (_aoIonAddress != address(0));
2319 		aoIonAddress = _aoIonAddress;
2320 		_aoIon = AOIon(_aoIonAddress);
2321 	}
2322 
2323 	/***** PUBLIC METHODS *****/
2324 	/**
2325 	 * @dev Get Ethereum balance of `_id`
2326 	 * @param _id The ID to check
2327 	 * @return The ethereum balance
2328 	 */
2329 	function ethBalanceOf(address _id) public isNameOrTAO(_id) view returns (uint256) {
2330 		return address(_id).balance;
2331 	}
2332 
2333 	/**
2334 	 * @dev Get ERC20 token balance of `_id`
2335 	 * @param _erc20TokenAddress The address of the ERC20 Token
2336 	 * @param _id The ID to check
2337 	 * @return The ERC20 Token balance
2338 	 */
2339 	function erc20BalanceOf(address _erc20TokenAddress, address _id) public isNameOrTAO(_id) view returns (uint256) {
2340 		return TokenERC20(_erc20TokenAddress).balanceOf(_id);
2341 	}
2342 
2343 	/**
2344 	 * @dev Get AO balance of `_id`
2345 	 * @param _id The ID to check
2346 	 * @return The AO balance
2347 	 */
2348 	function AOBalanceOf(address _id) public isNameOrTAO(_id) view returns (uint256) {
2349 		return _aoIon.balanceOf(_id);
2350 	}
2351 
2352 	/**
2353 	 * @dev Get AO+ balance of `_id`
2354 	 * @param _id The ID to check
2355 	 * @return The AO+ balance
2356 	 */
2357 	function primordialAOBalanceOf(address _id) public isNameOrTAO(_id) view returns (uint256) {
2358 		return _aoIon.primordialBalanceOf(_id);
2359 	}
2360 
2361 	/**
2362 	 * @dev Transfer `_amount` of ETH from `_from` to `_to`
2363 	 * @param _from The sender address
2364 	 * @param _to The recipient address
2365 	 * @param _amount The amount to transfer
2366 	 */
2367 	function transferEth(address _from, address _to, uint256 _amount) public isNameOrTAO(_from) onlyAdvocate(_from) senderNameNotCompromised {
2368 		require (_amount > 0 && address(_from).balance >= _amount);
2369 		require (_to != address(0) && _from != _to);
2370 		if (_nameFactory.nameIdToEthAddress(_from) != address(0)) {
2371 			require (!_nameAccountRecovery.isCompromised(_from));
2372 		}
2373 		if (_nameFactory.nameIdToEthAddress(_to) != address(0)) {
2374 			require (!_nameAccountRecovery.isCompromised(_to));
2375 		}
2376 		require (TAO(address(uint160(_from))).transferEth(address(uint160(_to)), _amount));
2377 		emit TransferEth(_nameFactory.ethAddressToNameId(msg.sender), _from, _to, _amount);
2378 	}
2379 
2380 	/**
2381 	 * @dev Transfer `_amount` of ERC20 Token from `_from` to `_to`
2382 	 * @param _erc20TokenAddress The ERC20 Token Address
2383 	 * @param _from The sender address
2384 	 * @param _to The recipient address
2385 	 * @param _amount The amount to transfer
2386 	 */
2387 	function transferERC20(address _erc20TokenAddress, address _from, address _to, uint256 _amount) public isNameOrTAO(_from) onlyAdvocate(_from) senderNameNotCompromised {
2388 		require (AOLibrary.isValidERC20TokenAddress(_erc20TokenAddress));
2389 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
2390 		require (_amount > 0 && _erc20.balanceOf(_from) >= _amount);
2391 		require (_to != address(0) && _from != _to);
2392 		if (_nameFactory.nameIdToEthAddress(_from) != address(0)) {
2393 			require (!_nameAccountRecovery.isCompromised(_from));
2394 		}
2395 		if (_nameFactory.nameIdToEthAddress(_to) != address(0)) {
2396 			require (!_nameAccountRecovery.isCompromised(_to));
2397 		}
2398 		require (TAO(address(uint160(_from))).transferERC20(_erc20TokenAddress, address(uint160(_to)), _amount));
2399 		emit TransferERC20(_nameFactory.ethAddressToNameId(msg.sender), _from, _to, _amount, _erc20TokenAddress, _erc20.name(), _erc20.symbol());
2400 	}
2401 
2402 	/**
2403 	 * @dev Transfer `_amount` of AO from `_from` to `_to`
2404 	 * @param _from The sender address
2405 	 * @param _to The recipient address
2406 	 * @param _amount The amount to transfer
2407 	 */
2408 	function transferAO(address _from, address _to, uint256 _amount) public isNameOrTAO(_from) onlyAdvocate(_from) senderNameNotCompromised {
2409 		require (_amount > 0 && _aoIon.balanceOf(_from) >= _amount);
2410 		require (_to != address(0) && _from != _to);
2411 		if (_nameFactory.nameIdToEthAddress(_from) != address(0)) {
2412 			require (!_nameAccountRecovery.isCompromised(_from));
2413 		}
2414 		if (_nameFactory.nameIdToEthAddress(_to) != address(0)) {
2415 			require (!_nameAccountRecovery.isCompromised(_to));
2416 		}
2417 		require (_aoIon.whitelistTransferFrom(_from, _to, _amount));
2418 		emit TransferAO(_nameFactory.ethAddressToNameId(msg.sender), _from, _to, _amount);
2419 	}
2420 
2421 	/**
2422 	 * @dev Transfer `_amount` of AO+ (Primordial) from `_from` to `_to`
2423 	 * @param _from The sender address
2424 	 * @param _to The recipient address
2425 	 * @param _amount The amount to transfer
2426 	 */
2427 	function transferPrimordialAO(address _from, address _to, uint256 _amount) public isNameOrTAO(_from) onlyAdvocate(_from) senderNameNotCompromised {
2428 		require (_amount > 0 && _aoIon.primordialBalanceOf(_from) >= _amount);
2429 		require (_to != address(0) && _from != _to);
2430 		if (_nameFactory.nameIdToEthAddress(_from) != address(0)) {
2431 			require (!_nameAccountRecovery.isCompromised(_from));
2432 		}
2433 		if (_nameFactory.nameIdToEthAddress(_to) != address(0)) {
2434 			require (!_nameAccountRecovery.isCompromised(_to));
2435 		}
2436 		require (_aoIon.whitelistTransferPrimordialFrom(_from, _to, _amount));
2437 		emit TransferPrimordialAO(_nameFactory.ethAddressToNameId(msg.sender), _from, _to, _amount);
2438 	}
2439 }