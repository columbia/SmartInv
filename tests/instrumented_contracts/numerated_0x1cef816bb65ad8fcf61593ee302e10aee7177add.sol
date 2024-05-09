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
303 
304 
305 
306 
307 
308 
309 
310 
311 
312 /**
313  * @title TAO
314  */
315 contract TAO {
316 	using SafeMath for uint256;
317 
318 	address public vaultAddress;
319 	string public name;				// the name for this TAO
320 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
321 
322 	// TAO's data
323 	string public datHash;
324 	string public database;
325 	string public keyValue;
326 	bytes32 public contentId;
327 
328 	/**
329 	 * 0 = TAO
330 	 * 1 = Name
331 	 */
332 	uint8 public typeId;
333 
334 	/**
335 	 * @dev Constructor function
336 	 */
337 	constructor (string memory _name,
338 		address _originId,
339 		string memory _datHash,
340 		string memory _database,
341 		string memory _keyValue,
342 		bytes32 _contentId,
343 		address _vaultAddress
344 	) public {
345 		name = _name;
346 		originId = _originId;
347 		datHash = _datHash;
348 		database = _database;
349 		keyValue = _keyValue;
350 		contentId = _contentId;
351 
352 		// Creating TAO
353 		typeId = 0;
354 
355 		vaultAddress = _vaultAddress;
356 	}
357 
358 	/**
359 	 * @dev Checks if calling address is Vault contract
360 	 */
361 	modifier onlyVault {
362 		require (msg.sender == vaultAddress);
363 		_;
364 	}
365 
366 	/**
367 	 * Will receive any ETH sent
368 	 */
369 	function () external payable {
370 	}
371 
372 	/**
373 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
374 	 * @param _recipient The recipient address
375 	 * @param _amount The amount to transfer
376 	 * @return true on success
377 	 */
378 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
379 		_recipient.transfer(_amount);
380 		return true;
381 	}
382 
383 	/**
384 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
385 	 * @param _erc20TokenAddress The address of ERC20 Token
386 	 * @param _recipient The recipient address
387 	 * @param _amount The amount to transfer
388 	 * @return true on success
389 	 */
390 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
391 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
392 		_erc20.transfer(_recipient, _amount);
393 		return true;
394 	}
395 }
396 
397 
398 
399 
400 /**
401  * @title Name
402  */
403 contract Name is TAO {
404 	/**
405 	 * @dev Constructor function
406 	 */
407 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
408 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
409 		// Creating Name
410 		typeId = 1;
411 	}
412 }
413 
414 
415 
416 
417 /**
418  * @title AOLibrary
419  */
420 library AOLibrary {
421 	using SafeMath for uint256;
422 
423 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
424 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
425 
426 	/**
427 	 * @dev Check whether or not the given TAO ID is a TAO
428 	 * @param _taoId The ID of the TAO
429 	 * @return true if yes. false otherwise
430 	 */
431 	function isTAO(address _taoId) public view returns (bool) {
432 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
433 	}
434 
435 	/**
436 	 * @dev Check whether or not the given Name ID is a Name
437 	 * @param _nameId The ID of the Name
438 	 * @return true if yes. false otherwise
439 	 */
440 	function isName(address _nameId) public view returns (bool) {
441 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
442 	}
443 
444 	/**
445 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
446 	 * @param _tokenAddress The ERC20 Token address to check
447 	 */
448 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
449 		if (_tokenAddress == address(0)) {
450 			return false;
451 		}
452 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
453 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
454 	}
455 
456 	/**
457 	 * @dev Checks if the calling contract address is The AO
458 	 *		OR
459 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
460 	 * @param _sender The address to check
461 	 * @param _theAO The AO address
462 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
463 	 * @return true if yes, false otherwise
464 	 */
465 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
466 		return (_sender == _theAO ||
467 			(
468 				(isTAO(_theAO) || isName(_theAO)) &&
469 				_nameTAOPositionAddress != address(0) &&
470 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
471 			)
472 		);
473 	}
474 
475 	/**
476 	 * @dev Return the divisor used to correctly calculate percentage.
477 	 *		Percentage stored throughout AO contracts covers 4 decimals,
478 	 *		so 1% is 10000, 1.25% is 12500, etc
479 	 */
480 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
481 		return _PERCENTAGE_DIVISOR;
482 	}
483 
484 	/**
485 	 * @dev Return the divisor used to correctly calculate multiplier.
486 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
487 	 *		so 1 is 1000000, 0.023 is 23000, etc
488 	 */
489 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
490 		return _MULTIPLIER_DIVISOR;
491 	}
492 
493 	/**
494 	 * @dev deploy a TAO
495 	 * @param _name The name of the TAO
496 	 * @param _originId The Name ID the creates the TAO
497 	 * @param _datHash The datHash of this TAO
498 	 * @param _database The database for this TAO
499 	 * @param _keyValue The key/value pair to be checked on the database
500 	 * @param _contentId The contentId related to this TAO
501 	 * @param _nameTAOVaultAddress The address of NameTAOVault
502 	 */
503 	function deployTAO(string memory _name,
504 		address _originId,
505 		string memory _datHash,
506 		string memory _database,
507 		string memory _keyValue,
508 		bytes32 _contentId,
509 		address _nameTAOVaultAddress
510 		) public returns (TAO _tao) {
511 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
512 	}
513 
514 	/**
515 	 * @dev deploy a Name
516 	 * @param _name The name of the Name
517 	 * @param _originId The eth address the creates the Name
518 	 * @param _datHash The datHash of this Name
519 	 * @param _database The database for this Name
520 	 * @param _keyValue The key/value pair to be checked on the database
521 	 * @param _contentId The contentId related to this Name
522 	 * @param _nameTAOVaultAddress The address of NameTAOVault
523 	 */
524 	function deployName(string memory _name,
525 		address _originId,
526 		string memory _datHash,
527 		string memory _database,
528 		string memory _keyValue,
529 		bytes32 _contentId,
530 		address _nameTAOVaultAddress
531 		) public returns (Name _myName) {
532 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
533 	}
534 
535 	/**
536 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
537 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
538 	 * @param _currentPrimordialBalance Account's current primordial ion balance
539 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
540 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
541 	 * @return the new primordial weighted multiplier
542 	 */
543 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
544 		if (_currentWeightedMultiplier > 0) {
545 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
546 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
547 			return _totalWeightedIons.div(_totalIons);
548 		} else {
549 			return _additionalWeightedMultiplier;
550 		}
551 	}
552 
553 	/**
554 	 * @dev Calculate the primordial ion multiplier on a given lot
555 	 *		Total Primordial Mintable = T
556 	 *		Total Primordial Minted = M
557 	 *		Starting Multiplier = S
558 	 *		Ending Multiplier = E
559 	 *		To Purchase = P
560 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
561 	 *
562 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
563 	 * @param _totalPrimordialMintable Total Primordial ion mintable
564 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
565 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
566 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
567 	 * @return The multiplier in (10 ** 6)
568 	 */
569 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
570 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
571 			/**
572 			 * Let temp = M + (P/2)
573 			 * Multiplier = (1 - (temp / T)) x (S-E)
574 			 */
575 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
576 
577 			/**
578 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
579 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
580 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
581 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
582 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
583 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
584 			 */
585 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
586 			/**
587 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
588 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
589 			 */
590 			return multiplier.div(_MULTIPLIER_DIVISOR);
591 		} else {
592 			return 0;
593 		}
594 	}
595 
596 	/**
597 	 * @dev Calculate the bonus percentage of network ion on a given lot
598 	 *		Total Primordial Mintable = T
599 	 *		Total Primordial Minted = M
600 	 *		Starting Network Bonus Multiplier = Bs
601 	 *		Ending Network Bonus Multiplier = Be
602 	 *		To Purchase = P
603 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
604 	 *
605 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
606 	 * @param _totalPrimordialMintable Total Primordial ion intable
607 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
608 	 * @param _startingMultiplier The starting Network ion bonus multiplier
609 	 * @param _endingMultiplier The ending Network ion bonus multiplier
610 	 * @return The bonus percentage
611 	 */
612 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
613 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
614 			/**
615 			 * Let temp = M + (P/2)
616 			 * B% = (1 - (temp / T)) x (Bs-Be)
617 			 */
618 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
619 
620 			/**
621 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
622 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
623 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
624 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
625 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
626 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
627 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
628 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
629 			 */
630 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
631 			return bonusPercentage;
632 		} else {
633 			return 0;
634 		}
635 	}
636 
637 	/**
638 	 * @dev Calculate the bonus amount of network ion on a given lot
639 	 *		AO Bonus Amount = B% x P
640 	 *
641 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
642 	 * @param _totalPrimordialMintable Total Primordial ion intable
643 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
644 	 * @param _startingMultiplier The starting Network ion bonus multiplier
645 	 * @param _endingMultiplier The ending Network ion bonus multiplier
646 	 * @return The bonus percentage
647 	 */
648 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
649 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
650 		/**
651 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
652 		 * when calculating the network ion bonus amount
653 		 */
654 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
655 		return networkBonus;
656 	}
657 
658 	/**
659 	 * @dev Calculate the maximum amount of Primordial an account can burn
660 	 *		_primordialBalance = P
661 	 *		_currentWeightedMultiplier = M
662 	 *		_maximumMultiplier = S
663 	 *		_amountToBurn = B
664 	 *		B = ((S x P) - (P x M)) / S
665 	 *
666 	 * @param _primordialBalance Account's primordial ion balance
667 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
668 	 * @param _maximumMultiplier The maximum multiplier of this account
669 	 * @return The maximum burn amount
670 	 */
671 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
672 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
673 	}
674 
675 	/**
676 	 * @dev Calculate the new multiplier after burning primordial ion
677 	 *		_primordialBalance = P
678 	 *		_currentWeightedMultiplier = M
679 	 *		_amountToBurn = B
680 	 *		_newMultiplier = E
681 	 *		E = (P x M) / (P - B)
682 	 *
683 	 * @param _primordialBalance Account's primordial ion balance
684 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
685 	 * @param _amountToBurn The amount of primordial ion to burn
686 	 * @return The new multiplier
687 	 */
688 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
689 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
690 	}
691 
692 	/**
693 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
694 	 *		_primordialBalance = P
695 	 *		_currentWeightedMultiplier = M
696 	 *		_amountToConvert = C
697 	 *		_newMultiplier = E
698 	 *		E = (P x M) / (P + C)
699 	 *
700 	 * @param _primordialBalance Account's primordial ion balance
701 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
702 	 * @param _amountToConvert The amount of network ion to convert
703 	 * @return The new multiplier
704 	 */
705 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
706 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
707 	}
708 
709 	/**
710 	 * @dev count num of digits
711 	 * @param number uint256 of the nuumber to be checked
712 	 * @return uint8 num of digits
713 	 */
714 	function numDigits(uint256 number) public pure returns (uint8) {
715 		uint8 digits = 0;
716 		while(number != 0) {
717 			number = number.div(10);
718 			digits++;
719 		}
720 		return digits;
721 	}
722 }
723 
724 
725 
726 
727 
728 
729 
730 
731 
732 
733 
734 
735 
736 
737 
738 
739 interface ionRecipient {
740 	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
741 }
742 
743 /**
744  * @title AOIonInterface
745  */
746 contract AOIonInterface is TheAO {
747 	using SafeMath for uint256;
748 
749 	address public namePublicKeyAddress;
750 	address public nameAccountRecoveryAddress;
751 
752 	INameTAOPosition internal _nameTAOPosition;
753 	INamePublicKey internal _namePublicKey;
754 	INameAccountRecovery internal _nameAccountRecovery;
755 
756 	// Public variables of the contract
757 	string public name;
758 	string public symbol;
759 	uint8 public decimals;
760 	uint256 public totalSupply;
761 
762 	// To differentiate denomination of AO
763 	uint256 public powerOfTen;
764 
765 	/***** NETWORK ION VARIABLES *****/
766 	uint256 public sellPrice;
767 	uint256 public buyPrice;
768 
769 	// This creates an array with all balances
770 	mapping (address => uint256) public balanceOf;
771 	mapping (address => mapping (address => uint256)) public allowance;
772 	mapping (address => bool) public frozenAccount;
773 	mapping (address => uint256) public stakedBalance;
774 	mapping (address => uint256) public escrowedBalance;
775 
776 	// This generates a public event on the blockchain that will notify clients
777 	event FrozenFunds(address target, bool frozen);
778 	event Stake(address indexed from, uint256 value);
779 	event Unstake(address indexed from, uint256 value);
780 	event Escrow(address indexed from, address indexed to, uint256 value);
781 	event Unescrow(address indexed from, uint256 value);
782 
783 	// This generates a public event on the blockchain that will notify clients
784 	event Transfer(address indexed from, address indexed to, uint256 value);
785 
786 	// This generates a public event on the blockchain that will notify clients
787 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
788 
789 	// This notifies clients about the amount burnt
790 	event Burn(address indexed from, uint256 value);
791 
792 	/**
793 	 * @dev Constructor function
794 	 */
795 	constructor(string memory _name, string memory _symbol, address _nameTAOPositionAddress, address _namePublicKeyAddress, address _nameAccountRecoveryAddress) public {
796 		setNameTAOPositionAddress(_nameTAOPositionAddress);
797 		setNamePublicKeyAddress(_namePublicKeyAddress);
798 		setNameAccountRecoveryAddress(_nameAccountRecoveryAddress);
799 		name = _name;           // Set the name for display purposes
800 		symbol = _symbol;       // Set the symbol for display purposes
801 		powerOfTen = 0;
802 		decimals = 0;
803 	}
804 
805 	/**
806 	 * @dev Checks if the calling contract address is The AO
807 	 *		OR
808 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
809 	 */
810 	modifier onlyTheAO {
811 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
812 		_;
813 	}
814 
815 	/***** The AO ONLY METHODS *****/
816 	/**
817 	 * @dev Transfer ownership of The AO to new address
818 	 * @param _theAO The new address to be transferred
819 	 */
820 	function transferOwnership(address _theAO) public onlyTheAO {
821 		require (_theAO != address(0));
822 		theAO = _theAO;
823 	}
824 
825 	/**
826 	 * @dev Whitelist `_account` address to transact on behalf of others
827 	 * @param _account The address to whitelist
828 	 * @param _whitelist Either to whitelist or not
829 	 */
830 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
831 		require (_account != address(0));
832 		whitelist[_account] = _whitelist;
833 	}
834 
835 	/**
836 	 * @dev The AO set the NameTAOPosition Address
837 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
838 	 */
839 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
840 		require (_nameTAOPositionAddress != address(0));
841 		nameTAOPositionAddress = _nameTAOPositionAddress;
842 		_nameTAOPosition = INameTAOPosition(nameTAOPositionAddress);
843 	}
844 
845 	/**
846 	 * @dev The AO set the NamePublicKey Address
847 	 * @param _namePublicKeyAddress The address of NamePublicKey
848 	 */
849 	function setNamePublicKeyAddress(address _namePublicKeyAddress) public onlyTheAO {
850 		require (_namePublicKeyAddress != address(0));
851 		namePublicKeyAddress = _namePublicKeyAddress;
852 		_namePublicKey = INamePublicKey(namePublicKeyAddress);
853 	}
854 
855 	/**
856 	 * @dev The AO set the NameAccountRecovery Address
857 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
858 	 */
859 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
860 		require (_nameAccountRecoveryAddress != address(0));
861 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
862 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
863 	}
864 
865 	/**
866 	 * @dev Allows TheAO to transfer `_amount` of ETH from this address to `_recipient`
867 	 * @param _recipient The recipient address
868 	 * @param _amount The amount to transfer
869 	 */
870 	function transferEth(address payable _recipient, uint256 _amount) public onlyTheAO {
871 		require (_recipient != address(0));
872 		_recipient.transfer(_amount);
873 	}
874 
875 	/**
876 	 * @dev Prevent/Allow target from sending & receiving ions
877 	 * @param target Address to be frozen
878 	 * @param freeze Either to freeze it or not
879 	 */
880 	function freezeAccount(address target, bool freeze) public onlyTheAO {
881 		frozenAccount[target] = freeze;
882 		emit FrozenFunds(target, freeze);
883 	}
884 
885 	/**
886 	 * @dev Allow users to buy ions for `newBuyPrice` eth and sell ions for `newSellPrice` eth
887 	 * @param newSellPrice Price users can sell to the contract
888 	 * @param newBuyPrice Price users can buy from the contract
889 	 */
890 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyTheAO {
891 		sellPrice = newSellPrice;
892 		buyPrice = newBuyPrice;
893 	}
894 
895 	/***** NETWORK ION WHITELISTED ADDRESS ONLY METHODS *****/
896 	/**
897 	 * @dev Create `mintedAmount` ions and send it to `target`
898 	 * @param target Address to receive the ions
899 	 * @param mintedAmount The amount of ions it will receive
900 	 * @return true on success
901 	 */
902 	function mint(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
903 		_mint(target, mintedAmount);
904 		return true;
905 	}
906 
907 	/**
908 	 * @dev Stake `_value` ions on behalf of `_from`
909 	 * @param _from The address of the target
910 	 * @param _value The amount to stake
911 	 * @return true on success
912 	 */
913 	function stakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
914 		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
915 		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
916 		stakedBalance[_from] = stakedBalance[_from].add(_value);	// Add to the targeted staked balance
917 		emit Stake(_from, _value);
918 		return true;
919 	}
920 
921 	/**
922 	 * @dev Unstake `_value` ions on behalf of `_from`
923 	 * @param _from The address of the target
924 	 * @param _value The amount to unstake
925 	 * @return true on success
926 	 */
927 	function unstakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
928 		require (stakedBalance[_from] >= _value);					// Check if the targeted staked balance is enough
929 		stakedBalance[_from] = stakedBalance[_from].sub(_value);	// Subtract from the targeted staked balance
930 		balanceOf[_from] = balanceOf[_from].add(_value);			// Add to the targeted balance
931 		emit Unstake(_from, _value);
932 		return true;
933 	}
934 
935 	/**
936 	 * @dev Store `_value` from `_from` to `_to` in escrow
937 	 * @param _from The address of the sender
938 	 * @param _to The address of the recipient
939 	 * @param _value The amount of network ions to put in escrow
940 	 * @return true on success
941 	 */
942 	function escrowFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool) {
943 		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
944 		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
945 		escrowedBalance[_to] = escrowedBalance[_to].add(_value);	// Add to the targeted escrowed balance
946 		emit Escrow(_from, _to, _value);
947 		return true;
948 	}
949 
950 	/**
951 	 * @dev Create `mintedAmount` ions and send it to `target` escrow balance
952 	 * @param target Address to receive ions
953 	 * @param mintedAmount The amount of ions it will receive in escrow
954 	 */
955 	function mintEscrow(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
956 		escrowedBalance[target] = escrowedBalance[target].add(mintedAmount);
957 		totalSupply = totalSupply.add(mintedAmount);
958 		emit Escrow(address(this), target, mintedAmount);
959 		return true;
960 	}
961 
962 	/**
963 	 * @dev Release escrowed `_value` from `_from`
964 	 * @param _from The address of the sender
965 	 * @param _value The amount of escrowed network ions to be released
966 	 * @return true on success
967 	 */
968 	function unescrowFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
969 		require (escrowedBalance[_from] >= _value);						// Check if the targeted escrowed balance is enough
970 		escrowedBalance[_from] = escrowedBalance[_from].sub(_value);	// Subtract from the targeted escrowed balance
971 		balanceOf[_from] = balanceOf[_from].add(_value);				// Add to the targeted balance
972 		emit Unescrow(_from, _value);
973 		return true;
974 	}
975 
976 	/**
977 	 *
978 	 * @dev Whitelisted address remove `_value` ions from the system irreversibly on behalf of `_from`.
979 	 *
980 	 * @param _from the address of the sender
981 	 * @param _value the amount of money to burn
982 	 */
983 	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist returns (bool success) {
984 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
985 		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
986 		totalSupply = totalSupply.sub(_value);              // Update totalSupply
987 		emit Burn(_from, _value);
988 		return true;
989 	}
990 
991 	/**
992 	 * @dev Whitelisted address transfer ions from other address
993 	 *
994 	 * Send `_value` ions to `_to` on behalf of `_from`
995 	 *
996 	 * @param _from The address of the sender
997 	 * @param _to The address of the recipient
998 	 * @param _value the amount to send
999 	 */
1000 	function whitelistTransferFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool success) {
1001 		_transfer(_from, _to, _value);
1002 		return true;
1003 	}
1004 
1005 	/***** PUBLIC METHODS *****/
1006 	/**
1007 	 * Transfer ions
1008 	 *
1009 	 * Send `_value` ions to `_to` from your account
1010 	 *
1011 	 * @param _to The address of the recipient
1012 	 * @param _value the amount to send
1013 	 */
1014 	function transfer(address _to, uint256 _value) public returns (bool success) {
1015 		_transfer(msg.sender, _to, _value);
1016 		return true;
1017 	}
1018 
1019 	/**
1020 	 * Transfer ions from other address
1021 	 *
1022 	 * Send `_value` ions to `_to` in behalf of `_from`
1023 	 *
1024 	 * @param _from The address of the sender
1025 	 * @param _to The address of the recipient
1026 	 * @param _value the amount to send
1027 	 */
1028 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
1029 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
1030 		allowance[_from][msg.sender] -= _value;
1031 		_transfer(_from, _to, _value);
1032 		return true;
1033 	}
1034 
1035 	/**
1036 	 * Transfer ions between public key addresses in a Name
1037 	 * @param _nameId The ID of the Name
1038 	 * @param _from The address of the sender
1039 	 * @param _to The address of the recipient
1040 	 * @param _value the amount to send
1041 	 */
1042 	function transferBetweenPublicKeys(address _nameId, address _from, address _to, uint256 _value) public returns (bool success) {
1043 		require (AOLibrary.isName(_nameId));
1044 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _nameId));
1045 		require (!_nameAccountRecovery.isCompromised(_nameId));
1046 		// Make sure _from exist in the Name's Public Keys
1047 		require (_namePublicKey.isKeyExist(_nameId, _from));
1048 		// Make sure _to exist in the Name's Public Keys
1049 		require (_namePublicKey.isKeyExist(_nameId, _to));
1050 		_transfer(_from, _to, _value);
1051 		return true;
1052 	}
1053 
1054 	/**
1055 	 * Set allowance for other address
1056 	 *
1057 	 * Allows `_spender` to spend no more than `_value` ions in your behalf
1058 	 *
1059 	 * @param _spender The address authorized to spend
1060 	 * @param _value the max amount they can spend
1061 	 */
1062 	function approve(address _spender, uint256 _value) public returns (bool success) {
1063 		allowance[msg.sender][_spender] = _value;
1064 		emit Approval(msg.sender, _spender, _value);
1065 		return true;
1066 	}
1067 
1068 	/**
1069 	 * Set allowance for other address and notify
1070 	 *
1071 	 * Allows `_spender` to spend no more than `_value` ions in your behalf, and then ping the contract about it
1072 	 *
1073 	 * @param _spender The address authorized to spend
1074 	 * @param _value the max amount they can spend
1075 	 * @param _extraData some extra information to send to the approved contract
1076 	 */
1077 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
1078 		ionRecipient spender = ionRecipient(_spender);
1079 		if (approve(_spender, _value)) {
1080 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
1081 			return true;
1082 		}
1083 	}
1084 
1085 	/**
1086 	 * Destroy ions
1087 	 *
1088 	 * Remove `_value` ions from the system irreversibly
1089 	 *
1090 	 * @param _value the amount of money to burn
1091 	 */
1092 	function burn(uint256 _value) public returns (bool success) {
1093 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
1094 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
1095 		totalSupply -= _value;                      // Updates totalSupply
1096 		emit Burn(msg.sender, _value);
1097 		return true;
1098 	}
1099 
1100 	/**
1101 	 * Destroy ions from other account
1102 	 *
1103 	 * Remove `_value` ions from the system irreversibly on behalf of `_from`.
1104 	 *
1105 	 * @param _from the address of the sender
1106 	 * @param _value the amount of money to burn
1107 	 */
1108 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
1109 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
1110 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
1111 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
1112 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
1113 		totalSupply -= _value;                              // Update totalSupply
1114 		emit Burn(_from, _value);
1115 		return true;
1116 	}
1117 
1118 	/**
1119 	 * @dev Buy ions from contract by sending ether
1120 	 */
1121 	function buy() public payable {
1122 		require (buyPrice > 0);
1123 		uint256 amount = msg.value.div(buyPrice);
1124 		_transfer(address(this), msg.sender, amount);
1125 	}
1126 
1127 	/**
1128 	 * @dev Sell `amount` ions to contract
1129 	 * @param amount The amount of ions to be sold
1130 	 */
1131 	function sell(uint256 amount) public {
1132 		require (sellPrice > 0);
1133 		address myAddress = address(this);
1134 		require (myAddress.balance >= amount.mul(sellPrice));
1135 		_transfer(msg.sender, address(this), amount);
1136 		msg.sender.transfer(amount.mul(sellPrice));
1137 	}
1138 
1139 	/***** INTERNAL METHODS *****/
1140 	/**
1141 	 * @dev Send `_value` ions from `_from` to `_to`
1142 	 * @param _from The address of sender
1143 	 * @param _to The address of the recipient
1144 	 * @param _value The amount to send
1145 	 */
1146 	function _transfer(address _from, address _to, uint256 _value) internal {
1147 		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
1148 		require (balanceOf[_from] >= _value);					// Check if the sender has enough
1149 		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
1150 		require (!frozenAccount[_from]);						// Check if sender is frozen
1151 		require (!frozenAccount[_to]);							// Check if recipient is frozen
1152 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
1153 		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
1154 		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
1155 		emit Transfer(_from, _to, _value);
1156 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
1157 	}
1158 
1159 	/**
1160 	 * @dev Create `mintedAmount` ions and send it to `target`
1161 	 * @param target Address to receive the ions
1162 	 * @param mintedAmount The amount of ions it will receive
1163 	 */
1164 	function _mint(address target, uint256 mintedAmount) internal {
1165 		balanceOf[target] = balanceOf[target].add(mintedAmount);
1166 		totalSupply = totalSupply.add(mintedAmount);
1167 		emit Transfer(address(0), address(this), mintedAmount);
1168 		emit Transfer(address(this), target, mintedAmount);
1169 	}
1170 }
1171 
1172 
1173 
1174 
1175 
1176 
1177 
1178 
1179 
1180 
1181 
1182 
1183 
1184 /**
1185  * @title AOETH
1186  */
1187 contract AOETH is TheAO, TokenERC20, tokenRecipient {
1188 	using SafeMath for uint256;
1189 
1190 	address public aoIonAddress;
1191 
1192 	AOIon internal _aoIon;
1193 
1194 	uint256 public totalERC20Tokens;
1195 	uint256 public totalTokenExchanges;
1196 
1197 	struct ERC20Token {
1198 		address tokenAddress;
1199 		uint256 price;			// price of this ERC20 Token to AOETH
1200 		uint256 maxQuantity;	// To prevent too much exposure to a given asset
1201 		uint256 exchangedQuantity;	// Running total (total AOETH exchanged from this specific ERC20 Token)
1202 		bool active;
1203 	}
1204 
1205 	struct TokenExchange {
1206 		bytes32 exchangeId;
1207 		address buyer;			// The buyer address
1208 		address tokenAddress;	// The address of ERC20 Token
1209 		uint256 price;			// price of ERC20 Token to AOETH
1210 		uint256 sentAmount;		// Amount of ERC20 Token sent
1211 		uint256 receivedAmount;	// Amount of AOETH received
1212 		bytes extraData; // Extra data
1213 	}
1214 
1215 	// Mapping from id to ERC20Token object
1216 	mapping (uint256 => ERC20Token) internal erc20Tokens;
1217 	mapping (address => uint256) internal erc20TokenIdLookup;
1218 
1219 	// Mapping from id to TokenExchange object
1220 	mapping (uint256 => TokenExchange) internal tokenExchanges;
1221 	mapping (bytes32 => uint256) internal tokenExchangeIdLookup;
1222 	mapping (address => uint256) public totalAddressTokenExchanges;
1223 
1224 	// Event to be broadcasted to public when TheAO adds an ERC20 Token
1225 	event AddERC20Token(address indexed tokenAddress, uint256 price, uint256 maxQuantity);
1226 
1227 	// Event to be broadcasted to public when TheAO sets price for ERC20 Token
1228 	event SetPrice(address indexed tokenAddress, uint256 price);
1229 
1230 	// Event to be broadcasted to public when TheAO sets max quantity for ERC20 Token
1231 	event SetMaxQuantity(address indexed tokenAddress, uint256 maxQuantity);
1232 
1233 	// Event to be broadcasted to public when TheAO sets active status for ERC20 Token
1234 	event SetActive(address indexed tokenAddress, bool active);
1235 
1236 	// Event to be broadcasted to public when user exchanges ERC20 Token for AOETH
1237 	event ExchangeToken(bytes32 indexed exchangeId, address indexed from, address tokenAddress, string tokenName, string tokenSymbol, uint256 sentTokenAmount, uint256 receivedAOETHAmount, bytes extraData);
1238 
1239 	/**
1240 	 * @dev Constructor function
1241 	 */
1242 	constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol, address _aoIonAddress, address _nameTAOPositionAddress)
1243 		TokenERC20(initialSupply, tokenName, tokenSymbol) public {
1244 		setAOIonAddress(_aoIonAddress);
1245 		setNameTAOPositionAddress(_nameTAOPositionAddress);
1246 	}
1247 
1248 	/**
1249 	 * @dev Checks if the calling contract address is The AO
1250 	 *		OR
1251 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
1252 	 */
1253 	modifier onlyTheAO {
1254 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
1255 		_;
1256 	}
1257 
1258 	/***** The AO ONLY METHODS *****/
1259 	/**
1260 	 * @dev Transfer ownership of The AO to new address
1261 	 * @param _theAO The new address to be transferred
1262 	 */
1263 	function transferOwnership(address _theAO) public onlyTheAO {
1264 		require (_theAO != address(0));
1265 		theAO = _theAO;
1266 	}
1267 
1268 	/**
1269 	 * @dev Whitelist `_account` address to transact on behalf of others
1270 	 * @param _account The address to whitelist
1271 	 * @param _whitelist Either to whitelist or not
1272 	 */
1273 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
1274 		require (_account != address(0));
1275 		whitelist[_account] = _whitelist;
1276 	}
1277 
1278 	/**
1279 	 * @dev The AO set the AOIon Address
1280 	 * @param _aoIonAddress The address of AOIon
1281 	 */
1282 	function setAOIonAddress(address _aoIonAddress) public onlyTheAO {
1283 		require (_aoIonAddress != address(0));
1284 		aoIonAddress = _aoIonAddress;
1285 		_aoIon = AOIon(_aoIonAddress);
1286 	}
1287 
1288 	/**
1289 	 * @dev The AO set the NameTAOPosition Address
1290 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
1291 	 */
1292 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
1293 		require (_nameTAOPositionAddress != address(0));
1294 		nameTAOPositionAddress = _nameTAOPositionAddress;
1295 	}
1296 
1297 	/**
1298 	 * @dev Allows TheAO to transfer `_amount` of ERC20 Token from this address to `_recipient`
1299 	 * @param _erc20TokenAddress The address of ERC20 Token
1300 	 * @param _recipient The recipient address
1301 	 * @param _amount The amount to transfer
1302 	 */
1303 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyTheAO {
1304 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
1305 		require (_erc20.transfer(_recipient, _amount));
1306 	}
1307 
1308 	/**
1309 	 * @dev Add an ERC20 Token to the list
1310 	 * @param _tokenAddress The address of the ERC20 Token
1311 	 * @param _price The price of this token to AOETH
1312 	 * @param _maxQuantity Maximum quantity allowed for exchange
1313 	 */
1314 	function addERC20Token(address _tokenAddress, uint256 _price, uint256 _maxQuantity) public onlyTheAO {
1315 		require (_tokenAddress != address(0) && _price > 0 && _maxQuantity > 0);
1316 		require (AOLibrary.isValidERC20TokenAddress(_tokenAddress));
1317 		require (erc20TokenIdLookup[_tokenAddress] == 0);
1318 
1319 		totalERC20Tokens++;
1320 		erc20TokenIdLookup[_tokenAddress] = totalERC20Tokens;
1321 		ERC20Token storage _erc20Token = erc20Tokens[totalERC20Tokens];
1322 		_erc20Token.tokenAddress = _tokenAddress;
1323 		_erc20Token.price = _price;
1324 		_erc20Token.maxQuantity = _maxQuantity;
1325 		_erc20Token.active = true;
1326 		emit AddERC20Token(_erc20Token.tokenAddress, _erc20Token.price, _erc20Token.maxQuantity);
1327 	}
1328 
1329 	/**
1330 	 * @dev Set price for existing ERC20 Token
1331 	 * @param _tokenAddress The address of the ERC20 Token
1332 	 * @param _price The price of this token to AOETH
1333 	 */
1334 	function setPrice(address _tokenAddress, uint256 _price) public onlyTheAO {
1335 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1336 		require (_price > 0);
1337 
1338 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
1339 		_erc20Token.price = _price;
1340 		emit SetPrice(_erc20Token.tokenAddress, _erc20Token.price);
1341 	}
1342 
1343 	/**
1344 	 * @dev Set max quantity for existing ERC20 Token
1345 	 * @param _tokenAddress The address of the ERC20 Token
1346 	 * @param _maxQuantity The max exchange quantity for this token
1347 	 */
1348 	function setMaxQuantity(address _tokenAddress, uint256 _maxQuantity) public onlyTheAO {
1349 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1350 
1351 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
1352 		require (_maxQuantity > _erc20Token.exchangedQuantity);
1353 		_erc20Token.maxQuantity = _maxQuantity;
1354 		emit SetMaxQuantity(_erc20Token.tokenAddress, _erc20Token.maxQuantity);
1355 	}
1356 
1357 	/**
1358 	 * @dev Set active status for existing ERC20 Token
1359 	 * @param _tokenAddress The address of the ERC20 Token
1360 	 * @param _active The active status for this token
1361 	 */
1362 	function setActive(address _tokenAddress, bool _active) public onlyTheAO {
1363 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1364 
1365 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
1366 		_erc20Token.active = _active;
1367 		emit SetActive(_erc20Token.tokenAddress, _erc20Token.active);
1368 	}
1369 
1370 	/**
1371 	 * @dev Whitelisted address transfer tokens from other address
1372 	 *
1373 	 * Send `_value` tokens to `_to` on behalf of `_from`
1374 	 *
1375 	 * @param _from The address of the sender
1376 	 * @param _to The address of the recipient
1377 	 * @param _value the amount to send
1378 	 */
1379 	function whitelistTransferFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool success) {
1380 		_transfer(_from, _to, _value);
1381 		return true;
1382 	}
1383 
1384 	/***** PUBLIC METHODS *****/
1385 	/**
1386 	 * @dev Get an ERC20 Token information given an ID
1387 	 * @param _id The internal ID of the ERC20 Token
1388 	 * @return The ERC20 Token address
1389 	 * @return The name of the token
1390 	 * @return The symbol of the token
1391 	 * @return The price of this token to AOETH
1392 	 * @return The max quantity for exchange
1393 	 * @return The total AOETH exchanged from this token
1394 	 * @return The status of this token
1395 	 */
1396 	function getById(uint256 _id) public view returns (address, string memory, string memory, uint256, uint256, uint256, bool) {
1397 		require (erc20Tokens[_id].tokenAddress != address(0));
1398 		ERC20Token memory _erc20Token = erc20Tokens[_id];
1399 		return (
1400 			_erc20Token.tokenAddress,
1401 			TokenERC20(_erc20Token.tokenAddress).name(),
1402 			TokenERC20(_erc20Token.tokenAddress).symbol(),
1403 			_erc20Token.price,
1404 			_erc20Token.maxQuantity,
1405 			_erc20Token.exchangedQuantity,
1406 			_erc20Token.active
1407 		);
1408 	}
1409 
1410 	/**
1411 	 * @dev Get an ERC20 Token information given an address
1412 	 * @param _tokenAddress The address of the ERC20 Token
1413 	 * @return The ERC20 Token address
1414 	 * @return The name of the token
1415 	 * @return The symbol of the token
1416 	 * @return The price of this token to AOETH
1417 	 * @return The max quantity for exchange
1418 	 * @return The total AOETH exchanged from this token
1419 	 * @return The status of this token
1420 	 */
1421 	function getByAddress(address _tokenAddress) public view returns (address, string memory, string memory, uint256, uint256, uint256, bool) {
1422 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1423 		return getById(erc20TokenIdLookup[_tokenAddress]);
1424 	}
1425 
1426 	/**
1427 	 * @dev When a user approves AOETH to spend on his/her behalf (i.e exchange to AOETH)
1428 	 * @param _from The user address that approved AOETH
1429 	 * @param _value The amount that the user approved
1430 	 * @param _token The address of the ERC20 Token
1431 	 * @param _extraData The extra data sent during the approval
1432 	 */
1433 	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external {
1434 		require (_from != address(0));
1435 		require (AOLibrary.isValidERC20TokenAddress(_token));
1436 
1437 		// Check if the token is supported
1438 		require (erc20TokenIdLookup[_token] > 0);
1439 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_token]];
1440 		require (_erc20Token.active && _erc20Token.price > 0 && _erc20Token.exchangedQuantity < _erc20Token.maxQuantity);
1441 
1442 		uint256 amountToTransfer = _value.div(_erc20Token.price);
1443 		require (_erc20Token.maxQuantity.sub(_erc20Token.exchangedQuantity) >= amountToTransfer);
1444 		require (_aoIon.availableETH() >= amountToTransfer);
1445 
1446 		// Transfer the ERC20 Token from the `_from` address to here
1447 		require (TokenERC20(_token).transferFrom(_from, address(this), _value));
1448 
1449 		_erc20Token.exchangedQuantity = _erc20Token.exchangedQuantity.add(amountToTransfer);
1450 		balanceOf[_from] = balanceOf[_from].add(amountToTransfer);
1451 		totalSupply = totalSupply.add(amountToTransfer);
1452 
1453 		// Store the TokenExchange information
1454 		totalTokenExchanges++;
1455 		totalAddressTokenExchanges[_from]++;
1456 		bytes32 _exchangeId = keccak256(abi.encodePacked(this, _from, totalTokenExchanges));
1457 		tokenExchangeIdLookup[_exchangeId] = totalTokenExchanges;
1458 
1459 		TokenExchange storage _tokenExchange = tokenExchanges[totalTokenExchanges];
1460 		_tokenExchange.exchangeId = _exchangeId;
1461 		_tokenExchange.buyer = _from;
1462 		_tokenExchange.tokenAddress = _token;
1463 		_tokenExchange.price = _erc20Token.price;
1464 		_tokenExchange.sentAmount = _value;
1465 		_tokenExchange.receivedAmount = amountToTransfer;
1466 		_tokenExchange.extraData = _extraData;
1467 
1468 		emit ExchangeToken(_tokenExchange.exchangeId, _tokenExchange.buyer, _tokenExchange.tokenAddress, TokenERC20(_token).name(), TokenERC20(_token).symbol(), _tokenExchange.sentAmount, _tokenExchange.receivedAmount, _tokenExchange.extraData);
1469 	}
1470 
1471 	/**
1472 	 * @dev Get TokenExchange information given an exchange ID
1473 	 * @param _exchangeId The exchange ID to query
1474 	 * @return The buyer address
1475 	 * @return The sent ERC20 Token address
1476 	 * @return The ERC20 Token name
1477 	 * @return The ERC20 Token symbol
1478 	 * @return The price of ERC20 Token to AOETH
1479 	 * @return The amount of ERC20 Token sent
1480 	 * @return The amount of AOETH received
1481 	 * @return Extra data during the transaction
1482 	 */
1483 	function getTokenExchangeById(bytes32 _exchangeId) public view returns (address, address, string memory, string memory, uint256, uint256,  uint256, bytes memory) {
1484 		require (tokenExchangeIdLookup[_exchangeId] > 0);
1485 		TokenExchange memory _tokenExchange = tokenExchanges[tokenExchangeIdLookup[_exchangeId]];
1486 		return (
1487 			_tokenExchange.buyer,
1488 			_tokenExchange.tokenAddress,
1489 			TokenERC20(_tokenExchange.tokenAddress).name(),
1490 			TokenERC20(_tokenExchange.tokenAddress).symbol(),
1491 			_tokenExchange.price,
1492 			_tokenExchange.sentAmount,
1493 			_tokenExchange.receivedAmount,
1494 			_tokenExchange.extraData
1495 		);
1496 	}
1497 }
1498 
1499 
1500 /**
1501  * @title AOIon
1502  */
1503 contract AOIon is AOIonInterface {
1504 	using SafeMath for uint256;
1505 
1506 	address public aoIonLotAddress;
1507 	address public settingTAOId;
1508 	address public aoSettingAddress;
1509 	address public aoethAddress;
1510 
1511 	// AO Dev Team addresses to receive Primordial/Network Ions
1512 	address public aoDevTeam1 = 0x146CbD9821e6A42c8ff6DC903fe91CB69625A105;
1513 	address public aoDevTeam2 = 0x4810aF1dA3aC827259eEa72ef845F4206C703E8D;
1514 
1515 	IAOIonLot internal _aoIonLot;
1516 	IAOSetting internal _aoSetting;
1517 	AOETH internal _aoeth;
1518 
1519 	/***** PRIMORDIAL ION VARIABLES *****/
1520 	uint256 public primordialTotalSupply;
1521 	uint256 public primordialTotalBought;
1522 	uint256 public primordialSellPrice;
1523 	uint256 public primordialBuyPrice;
1524 	uint256 public totalEthForPrimordial;	// Total ETH sent for Primordial AO+
1525 	uint256 public totalRedeemedAOETH;		// Total AOETH redeemed for Primordial AO+
1526 
1527 	// Total available primordial ion for sale 3,377,699,720,527,872 AO+
1528 	uint256 constant public TOTAL_PRIMORDIAL_FOR_SALE = 3377699720527872;
1529 
1530 	mapping (address => uint256) public primordialBalanceOf;
1531 	mapping (address => mapping (address => uint256)) public primordialAllowance;
1532 
1533 	// Mapping from owner's lot weighted multiplier to the amount of staked ions
1534 	mapping (address => mapping (uint256 => uint256)) public primordialStakedBalance;
1535 
1536 	event PrimordialTransfer(address indexed from, address indexed to, uint256 value);
1537 	event PrimordialApproval(address indexed _owner, address indexed _spender, uint256 _value);
1538 	event PrimordialBurn(address indexed from, uint256 value);
1539 	event PrimordialStake(address indexed from, uint256 value, uint256 weightedMultiplier);
1540 	event PrimordialUnstake(address indexed from, uint256 value, uint256 weightedMultiplier);
1541 
1542 	event NetworkExchangeEnded();
1543 
1544 	bool public networkExchangeEnded;
1545 
1546 	// Mapping from owner to his/her current weighted multiplier
1547 	mapping (address => uint256) internal ownerWeightedMultiplier;
1548 
1549 	// Mapping from owner to his/her max multiplier (multiplier of account's first Lot)
1550 	mapping (address => uint256) internal ownerMaxMultiplier;
1551 
1552 	// Event to be broadcasted to public when user buys primordial ion
1553 	// payWith 1 == with Ethereum
1554 	// payWith 2 == with AOETH
1555 	event BuyPrimordial(address indexed lotOwner, bytes32 indexed lotId, uint8 payWith, uint256 sentAmount, uint256 refundedAmount);
1556 
1557 	/**
1558 	 * @dev Constructor function
1559 	 */
1560 	constructor(string memory _name, string memory _symbol, address _settingTAOId, address _aoSettingAddress, address _nameTAOPositionAddress, address _namePublicKeyAddress, address _nameAccountRecoveryAddress)
1561 		AOIonInterface(_name, _symbol, _nameTAOPositionAddress, _namePublicKeyAddress, _nameAccountRecoveryAddress) public {
1562 		setSettingTAOId(_settingTAOId);
1563 		setAOSettingAddress(_aoSettingAddress);
1564 
1565 		powerOfTen = 0;
1566 		decimals = 0;
1567 		setPrimordialPrices(0, 10 ** 8); // Set Primordial buy price to 0.1 gwei/ion
1568 	}
1569 
1570 	/**
1571 	 * @dev Checks if buyer can buy primordial ion
1572 	 */
1573 	modifier canBuyPrimordial(uint256 _sentAmount, bool _withETH) {
1574 		require (networkExchangeEnded == false &&
1575 			primordialTotalBought < TOTAL_PRIMORDIAL_FOR_SALE &&
1576 			primordialBuyPrice > 0 &&
1577 			_sentAmount > 0 &&
1578 			availablePrimordialForSaleInETH() > 0 &&
1579 			(
1580 				(_withETH && availableETH() > 0) ||
1581 				(!_withETH && totalRedeemedAOETH < _aoeth.totalSupply())
1582 			)
1583 		);
1584 		_;
1585 	}
1586 
1587 	/***** The AO ONLY METHODS *****/
1588 	/**
1589 	 * @dev The AO sets AOIonLot address
1590 	 * @param _aoIonLotAddress The address of AOIonLot
1591 	 */
1592 	function setAOIonLotAddress(address _aoIonLotAddress) public onlyTheAO {
1593 		require (_aoIonLotAddress != address(0));
1594 		aoIonLotAddress = _aoIonLotAddress;
1595 		_aoIonLot = IAOIonLot(_aoIonLotAddress);
1596 	}
1597 
1598 	/**
1599 	 * @dev The AO sets setting TAO ID
1600 	 * @param _settingTAOId The new setting TAO ID to set
1601 	 */
1602 	function setSettingTAOId(address _settingTAOId) public onlyTheAO {
1603 		require (AOLibrary.isTAO(_settingTAOId));
1604 		settingTAOId = _settingTAOId;
1605 	}
1606 
1607 	/**
1608 	 * @dev The AO sets AO Setting address
1609 	 * @param _aoSettingAddress The address of AOSetting
1610 	 */
1611 	function setAOSettingAddress(address _aoSettingAddress) public onlyTheAO {
1612 		require (_aoSettingAddress != address(0));
1613 		aoSettingAddress = _aoSettingAddress;
1614 		_aoSetting = IAOSetting(_aoSettingAddress);
1615 	}
1616 
1617 	/**
1618 	 * @dev Set AO Dev team addresses to receive Primordial/Network ions during network exchange
1619 	 * @param _aoDevTeam1 The first AO dev team address
1620 	 * @param _aoDevTeam2 The second AO dev team address
1621 	 */
1622 	function setAODevTeamAddresses(address _aoDevTeam1, address _aoDevTeam2) public onlyTheAO {
1623 		aoDevTeam1 = _aoDevTeam1;
1624 		aoDevTeam2 = _aoDevTeam2;
1625 	}
1626 
1627 	/**
1628 	 * @dev Set AOETH address
1629 	 * @param _aoethAddress The address of AOETH
1630 	 */
1631 	function setAOETHAddress(address _aoethAddress) public onlyTheAO {
1632 		require (_aoethAddress != address(0));
1633 		aoethAddress = _aoethAddress;
1634 		_aoeth = AOETH(_aoethAddress);
1635 	}
1636 
1637 	/***** PRIMORDIAL ION THE AO ONLY METHODS *****/
1638 	/**
1639 	 * @dev Allow users to buy Primordial ions for `newBuyPrice` eth and sell Primordial ions for `newSellPrice` eth
1640 	 * @param newPrimordialSellPrice Price users can sell to the contract
1641 	 * @param newPrimordialBuyPrice Price users can buy from the contract
1642 	 */
1643 	function setPrimordialPrices(uint256 newPrimordialSellPrice, uint256 newPrimordialBuyPrice) public onlyTheAO {
1644 		primordialSellPrice = newPrimordialSellPrice;
1645 		primordialBuyPrice = newPrimordialBuyPrice;
1646 	}
1647 
1648 	/**
1649 	 * @dev Only the AO can force end network exchange
1650 	 */
1651 	function endNetworkExchange() public onlyTheAO {
1652 		require (!networkExchangeEnded);
1653 		networkExchangeEnded = true;
1654 		emit NetworkExchangeEnded();
1655 	}
1656 
1657 	/***** PRIMORDIAL ION WHITELISTED ADDRESS ONLY METHODS *****/
1658 	/**
1659 	 * @dev Stake `_value` Primordial ions at `_weightedMultiplier ` multiplier on behalf of `_from`
1660 	 * @param _from The address of the target
1661 	 * @param _value The amount of Primordial ions to stake
1662 	 * @param _weightedMultiplier The weighted multiplier of the Primordial ions
1663 	 * @return true on success
1664 	 */
1665 	function stakePrimordialFrom(address _from, uint256 _value, uint256 _weightedMultiplier) public inWhitelist returns (bool) {
1666 		// Check if the targeted balance is enough
1667 		require (primordialBalanceOf[_from] >= _value);
1668 		// Make sure the weighted multiplier is the same as account's current weighted multiplier
1669 		require (_weightedMultiplier == ownerWeightedMultiplier[_from]);
1670 		// Subtract from the targeted balance
1671 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);
1672 		// Add to the targeted staked balance
1673 		primordialStakedBalance[_from][_weightedMultiplier] = primordialStakedBalance[_from][_weightedMultiplier].add(_value);
1674 		emit PrimordialStake(_from, _value, _weightedMultiplier);
1675 		return true;
1676 	}
1677 
1678 	/**
1679 	 * @dev Unstake `_value` Primordial ions at `_weightedMultiplier` on behalf of `_from`
1680 	 * @param _from The address of the target
1681 	 * @param _value The amount to unstake
1682 	 * @param _weightedMultiplier The weighted multiplier of the Primordial ions
1683 	 * @return true on success
1684 	 */
1685 	function unstakePrimordialFrom(address _from, uint256 _value, uint256 _weightedMultiplier) public inWhitelist returns (bool) {
1686 		// Check if the targeted staked balance is enough
1687 		require (primordialStakedBalance[_from][_weightedMultiplier] >= _value);
1688 		// Subtract from the targeted staked balance
1689 		primordialStakedBalance[_from][_weightedMultiplier] = primordialStakedBalance[_from][_weightedMultiplier].sub(_value);
1690 		// Add to the targeted balance
1691 		primordialBalanceOf[_from] = primordialBalanceOf[_from].add(_value);
1692 		emit PrimordialUnstake(_from, _value, _weightedMultiplier);
1693 		return true;
1694 	}
1695 
1696 	/**
1697 	 * @dev Send `_value` primordial ions to `_to` on behalf of `_from`
1698 	 * @param _from The address of the sender
1699 	 * @param _to The address of the recipient
1700 	 * @param _value The amount to send
1701 	 * @return true on success
1702 	 */
1703 	function whitelistTransferPrimordialFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool) {
1704 		return _createLotAndTransferPrimordial(_from, _to, _value);
1705 	}
1706 
1707 	/***** PUBLIC METHODS *****/
1708 	/***** PRIMORDIAL ION PUBLIC METHODS *****/
1709 	/**
1710 	 * @dev Buy Primordial ions from contract by sending ether
1711 	 */
1712 	function buyPrimordial() public payable canBuyPrimordial(msg.value, true) {
1713 		(uint256 amount, uint256 remainderBudget, bool shouldEndNetworkExchange) = _calculateAmountAndRemainderBudget(msg.value, true);
1714 		require (amount > 0);
1715 
1716 		// Ends network exchange if necessary
1717 		if (shouldEndNetworkExchange) {
1718 			networkExchangeEnded = true;
1719 			emit NetworkExchangeEnded();
1720 		}
1721 
1722 		// Update totalEthForPrimordial
1723 		totalEthForPrimordial = totalEthForPrimordial.add(msg.value.sub(remainderBudget));
1724 
1725 		// Send the primordial ion to buyer and reward AO devs
1726 		bytes32 _lotId = _sendPrimordialAndRewardDev(amount, msg.sender);
1727 
1728 		emit BuyPrimordial(msg.sender, _lotId, 1, msg.value, remainderBudget);
1729 
1730 		// Send remainder budget back to buyer if exist
1731 		if (remainderBudget > 0) {
1732 			msg.sender.transfer(remainderBudget);
1733 		}
1734 	}
1735 
1736 	/**
1737 	 * @dev Buy Primordial ion from contract by sending AOETH
1738 	 */
1739 	function buyPrimordialWithAOETH(uint256 _aoethAmount) public canBuyPrimordial(_aoethAmount, false) {
1740 		(uint256 amount, uint256 remainderBudget, bool shouldEndNetworkExchange) = _calculateAmountAndRemainderBudget(_aoethAmount, false);
1741 		require (amount > 0);
1742 
1743 		// Ends network exchange if necessary
1744 		if (shouldEndNetworkExchange) {
1745 			networkExchangeEnded = true;
1746 			emit NetworkExchangeEnded();
1747 		}
1748 
1749 		// Calculate the actual AOETH that was charged for this transaction
1750 		uint256 actualCharge = _aoethAmount.sub(remainderBudget);
1751 
1752 		// Update totalRedeemedAOETH
1753 		totalRedeemedAOETH = totalRedeemedAOETH.add(actualCharge);
1754 
1755 		// Transfer AOETH from buyer to here
1756 		require (_aoeth.whitelistTransferFrom(msg.sender, address(this), actualCharge));
1757 
1758 		// Send the primordial ion to buyer and reward AO devs
1759 		bytes32 _lotId = _sendPrimordialAndRewardDev(amount, msg.sender);
1760 
1761 		emit BuyPrimordial(msg.sender, _lotId, 2, _aoethAmount, remainderBudget);
1762 	}
1763 
1764 	/**
1765 	 * @dev Send `_value` Primordial ions to `_to` from your account
1766 	 * @param _to The address of the recipient
1767 	 * @param _value The amount to send
1768 	 * @return true on success
1769 	 */
1770 	function transferPrimordial(address _to, uint256 _value) public returns (bool) {
1771 		return _createLotAndTransferPrimordial(msg.sender, _to, _value);
1772 	}
1773 
1774 	/**
1775 	 * @dev Send `_value` Primordial ions to `_to` from `_from`
1776 	 * @param _from The address of the sender
1777 	 * @param _to The address of the recipient
1778 	 * @param _value The amount to send
1779 	 * @return true on success
1780 	 */
1781 	function transferPrimordialFrom(address _from, address _to, uint256 _value) public returns (bool) {
1782 		require (_value <= primordialAllowance[_from][msg.sender]);
1783 		primordialAllowance[_from][msg.sender] = primordialAllowance[_from][msg.sender].sub(_value);
1784 
1785 		return _createLotAndTransferPrimordial(_from, _to, _value);
1786 	}
1787 
1788 	/**
1789 	 * Transfer primordial ions between public key addresses in a Name
1790 	 * @param _nameId The ID of the Name
1791 	 * @param _from The address of the sender
1792 	 * @param _to The address of the recipient
1793 	 * @param _value the amount to send
1794 	 */
1795 	function transferPrimordialBetweenPublicKeys(address _nameId, address _from, address _to, uint256 _value) public returns (bool) {
1796 		require (AOLibrary.isName(_nameId));
1797 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _nameId));
1798 		require (!_nameAccountRecovery.isCompromised(_nameId));
1799 		// Make sure _from exist in the Name's Public Keys
1800 		require (_namePublicKey.isKeyExist(_nameId, _from));
1801 		// Make sure _to exist in the Name's Public Keys
1802 		require (_namePublicKey.isKeyExist(_nameId, _to));
1803 		return _createLotAndTransferPrimordial(_from, _to, _value);
1804 	}
1805 
1806 	/**
1807 	 * @dev Allows `_spender` to spend no more than `_value` Primordial ions in your behalf
1808 	 * @param _spender The address authorized to spend
1809 	 * @param _value The max amount they can spend
1810 	 * @return true on success
1811 	 */
1812 	function approvePrimordial(address _spender, uint256 _value) public returns (bool) {
1813 		primordialAllowance[msg.sender][_spender] = _value;
1814 		emit PrimordialApproval(msg.sender, _spender, _value);
1815 		return true;
1816 	}
1817 
1818 	/**
1819 	 * @dev Allows `_spender` to spend no more than `_value` Primordial ions in your behalf, and then ping the contract about it
1820 	 * @param _spender The address authorized to spend
1821 	 * @param _value The max amount they can spend
1822 	 * @param _extraData some extra information to send to the approved contract
1823 	 * @return true on success
1824 	 */
1825 	function approvePrimordialAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool) {
1826 		tokenRecipient spender = tokenRecipient(_spender);
1827 		if (approvePrimordial(_spender, _value)) {
1828 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
1829 			return true;
1830 		}
1831 	}
1832 
1833 	/**
1834 	 * @dev Remove `_value` Primordial ions from the system irreversibly
1835 	 *		and re-weight the account's multiplier after burn
1836 	 * @param _value The amount to burn
1837 	 * @return true on success
1838 	 */
1839 	function burnPrimordial(uint256 _value) public returns (bool) {
1840 		require (primordialBalanceOf[msg.sender] >= _value);
1841 		require (calculateMaximumBurnAmount(msg.sender) >= _value);
1842 
1843 		// Update the account's multiplier
1844 		ownerWeightedMultiplier[msg.sender] = calculateMultiplierAfterBurn(msg.sender, _value);
1845 		primordialBalanceOf[msg.sender] = primordialBalanceOf[msg.sender].sub(_value);
1846 		primordialTotalSupply = primordialTotalSupply.sub(_value);
1847 
1848 		// Store burn lot info
1849 		require (_aoIonLot.createBurnLot(msg.sender, _value, ownerWeightedMultiplier[msg.sender]));
1850 		emit PrimordialBurn(msg.sender, _value);
1851 		return true;
1852 	}
1853 
1854 	/**
1855 	 * @dev Remove `_value` Primordial ions from the system irreversibly on behalf of `_from`
1856 	 *		and re-weight `_from`'s multiplier after burn
1857 	 * @param _from The address of sender
1858 	 * @param _value The amount to burn
1859 	 * @return true on success
1860 	 */
1861 	function burnPrimordialFrom(address _from, uint256 _value) public returns (bool) {
1862 		require (primordialBalanceOf[_from] >= _value);
1863 		require (primordialAllowance[_from][msg.sender] >= _value);
1864 		require (calculateMaximumBurnAmount(_from) >= _value);
1865 
1866 		// Update `_from`'s multiplier
1867 		ownerWeightedMultiplier[_from] = calculateMultiplierAfterBurn(_from, _value);
1868 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);
1869 		primordialAllowance[_from][msg.sender] = primordialAllowance[_from][msg.sender].sub(_value);
1870 		primordialTotalSupply = primordialTotalSupply.sub(_value);
1871 
1872 		// Store burn lot info
1873 		require (_aoIonLot.createBurnLot(_from, _value, ownerWeightedMultiplier[_from]));
1874 		emit PrimordialBurn(_from, _value);
1875 		return true;
1876 	}
1877 
1878 	/**
1879 	 * @dev Return the average weighted multiplier of all lots owned by an address
1880 	 * @param _lotOwner The address of the lot owner
1881 	 * @return the weighted multiplier of the address (in 10 ** 6)
1882 	 */
1883 	function weightedMultiplierByAddress(address _lotOwner) public view returns (uint256) {
1884 		return ownerWeightedMultiplier[_lotOwner];
1885 	}
1886 
1887 	/**
1888 	 * @dev Return the max multiplier of an address
1889 	 * @param _target The address to query
1890 	 * @return the max multiplier of the address (in 10 ** 6)
1891 	 */
1892 	function maxMultiplierByAddress(address _target) public view returns (uint256) {
1893 		return (_aoIonLot.totalLotsByAddress(_target) > 0) ? ownerMaxMultiplier[_target] : 0;
1894 	}
1895 
1896 	/**
1897 	 * @dev Calculate the primordial ion multiplier, bonus network ion percentage, and the
1898 	 *		bonus network ion amount on a given lot when someone purchases primordial ion
1899 	 *		during network exchange
1900 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
1901 	 * @return The multiplier in (10 ** 6)
1902 	 * @return The bonus percentage
1903 	 * @return The amount of network ion as bonus
1904 	 */
1905 	function calculateMultiplierAndBonus(uint256 _purchaseAmount) public view returns (uint256, uint256, uint256) {
1906 		(uint256 startingPrimordialMultiplier, uint256 endingPrimordialMultiplier, uint256 startingNetworkBonusMultiplier, uint256 endingNetworkBonusMultiplier) = _getSettingVariables();
1907 		return (
1908 			AOLibrary.calculatePrimordialMultiplier(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingPrimordialMultiplier, endingPrimordialMultiplier),
1909 			AOLibrary.calculateNetworkBonusPercentage(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier),
1910 			AOLibrary.calculateNetworkBonusAmount(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier)
1911 		);
1912 	}
1913 
1914 	/**
1915 	 * @dev Calculate the maximum amount of Primordial an account can burn
1916 	 * @param _account The address of the account
1917 	 * @return The maximum primordial ion amount to burn
1918 	 */
1919 	function calculateMaximumBurnAmount(address _account) public view returns (uint256) {
1920 		return AOLibrary.calculateMaximumBurnAmount(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], ownerMaxMultiplier[_account]);
1921 	}
1922 
1923 	/**
1924 	 * @dev Calculate account's new multiplier after burn `_amountToBurn` primordial ions
1925 	 * @param _account The address of the account
1926 	 * @param _amountToBurn The amount of primordial ion to burn
1927 	 * @return The new multiplier in (10 ** 6)
1928 	 */
1929 	function calculateMultiplierAfterBurn(address _account, uint256 _amountToBurn) public view returns (uint256) {
1930 		require (calculateMaximumBurnAmount(_account) >= _amountToBurn);
1931 		return AOLibrary.calculateMultiplierAfterBurn(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], _amountToBurn);
1932 	}
1933 
1934 	/**
1935 	 * @dev Calculate account's new multiplier after converting `amountToConvert` network ion to primordial ion
1936 	 * @param _account The address of the account
1937 	 * @param _amountToConvert The amount of network ion to convert
1938 	 * @return The new multiplier in (10 ** 6)
1939 	 */
1940 	function calculateMultiplierAfterConversion(address _account, uint256 _amountToConvert) public view returns (uint256) {
1941 		return AOLibrary.calculateMultiplierAfterConversion(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], _amountToConvert);
1942 	}
1943 
1944 	/**
1945 	 * @dev Convert `_value` of network ions to primordial ions
1946 	 *		and re-weight the account's multiplier after conversion
1947 	 * @param _value The amount to convert
1948 	 * @return true on success
1949 	 */
1950 	function convertToPrimordial(uint256 _value) public returns (bool) {
1951 		require (balanceOf[msg.sender] >= _value);
1952 
1953 		// Update the account's multiplier
1954 		ownerWeightedMultiplier[msg.sender] = calculateMultiplierAfterConversion(msg.sender, _value);
1955 		// Burn network ion
1956 		burn(_value);
1957 		// mint primordial ion
1958 		_mintPrimordial(msg.sender, _value);
1959 
1960 		require (_aoIonLot.createConvertLot(msg.sender, _value, ownerWeightedMultiplier[msg.sender]));
1961 		return true;
1962 	}
1963 
1964 	/**
1965 	 * @dev Get quantity of AO+ left in Network Exchange
1966 	 * @return The quantity of AO+ left in Network Exchange
1967 	 */
1968 	function availablePrimordialForSale() public view returns (uint256) {
1969 		return TOTAL_PRIMORDIAL_FOR_SALE.sub(primordialTotalBought);
1970 	}
1971 
1972 	/**
1973 	 * @dev Get quantity of AO+ in ETH left in Network Exchange (i.e How much ETH is there total that can be
1974 	 *		exchanged for AO+
1975 	 * @return The quantity of AO+ in ETH left in Network Exchange
1976 	 */
1977 	function availablePrimordialForSaleInETH() public view returns (uint256) {
1978 		return availablePrimordialForSale().mul(primordialBuyPrice);
1979 	}
1980 
1981 	/**
1982 	 * @dev Get maximum quantity of AOETH or ETH that can still be sold
1983 	 * @return The maximum quantity of AOETH or ETH that can still be sold
1984 	 */
1985 	function availableETH() public view returns (uint256) {
1986 		if (availablePrimordialForSaleInETH() > 0) {
1987 			uint256 _availableETH = availablePrimordialForSaleInETH().sub(_aoeth.totalSupply().sub(totalRedeemedAOETH));
1988 			if (availablePrimordialForSale() == 1 && _availableETH < primordialBuyPrice) {
1989 				return primordialBuyPrice;
1990 			} else {
1991 				return _availableETH;
1992 			}
1993 		} else {
1994 			return 0;
1995 		}
1996 	}
1997 
1998 	/***** INTERNAL METHODS *****/
1999 	/***** PRIMORDIAL ION INTERNAL METHODS *****/
2000 	/**
2001 	 * @dev Calculate the amount of ion the buyer will receive and remaining budget if exist
2002 	 *		when he/she buys primordial ion
2003 	 * @param _budget The amount of ETH sent by buyer
2004 	 * @param _withETH Whether or not buyer is paying with ETH
2005 	 * @return uint256 of the amount the buyer will receiver
2006 	 * @return uint256 of the remaining budget, if exist
2007 	 * @return bool whether or not the network exchange should end
2008 	 */
2009 	function _calculateAmountAndRemainderBudget(uint256 _budget, bool _withETH) internal view returns (uint256, uint256, bool) {
2010 		// Calculate the amount of ion
2011 		uint256 amount = _budget.div(primordialBuyPrice);
2012 
2013 		// If we need to return ETH to the buyer, in the case
2014 		// where the buyer sends more ETH than available primordial ion to be purchased
2015 		uint256 remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
2016 
2017 		uint256 _availableETH = availableETH();
2018 		// If paying with ETH, it can't exceed availableETH
2019 		if (_withETH && _budget > availableETH()) {
2020 			// Calculate the amount of ions
2021 			amount = _availableETH.div(primordialBuyPrice);
2022 			remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
2023 		}
2024 
2025 		// Make sure primordialTotalBought is not overflowing
2026 		bool shouldEndNetworkExchange = false;
2027 		if (primordialTotalBought.add(amount) >= TOTAL_PRIMORDIAL_FOR_SALE) {
2028 			amount = TOTAL_PRIMORDIAL_FOR_SALE.sub(primordialTotalBought);
2029 			shouldEndNetworkExchange = true;
2030 			remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
2031 		}
2032 		return (amount, remainderEth, shouldEndNetworkExchange);
2033 	}
2034 
2035 	/**
2036 	 * @dev Actually sending the primordial ion to buyer and reward AO devs accordingly
2037 	 * @param amount The amount of primordial ion to be sent to buyer
2038 	 * @param to The recipient of ion
2039 	 * @return the lot Id of the buyer
2040 	 */
2041 	function _sendPrimordialAndRewardDev(uint256 amount, address to) internal returns (bytes32) {
2042 		(uint256 startingPrimordialMultiplier,, uint256 startingNetworkBonusMultiplier, uint256 endingNetworkBonusMultiplier) = _getSettingVariables();
2043 
2044 		// Update primordialTotalBought
2045 		(uint256 multiplier, uint256 networkBonusPercentage, uint256 networkBonusAmount) = calculateMultiplierAndBonus(amount);
2046 		primordialTotalBought = primordialTotalBought.add(amount);
2047 		bytes32 _lotId = _createPrimordialLot(to, amount, multiplier, networkBonusAmount);
2048 
2049 		// Calculate The AO and AO Dev Team's portion of Primordial and Network ion Bonus
2050 		uint256 inverseMultiplier = startingPrimordialMultiplier.sub(multiplier); // Inverse of the buyer's multiplier
2051 		uint256 theAONetworkBonusAmount = (startingNetworkBonusMultiplier.sub(networkBonusPercentage).add(endingNetworkBonusMultiplier)).mul(amount).div(AOLibrary.PERCENTAGE_DIVISOR());
2052 		if (aoDevTeam1 != address(0)) {
2053 			_createPrimordialLot(aoDevTeam1, amount.div(2), inverseMultiplier, theAONetworkBonusAmount.div(2));
2054 		}
2055 		if (aoDevTeam2 != address(0)) {
2056 			_createPrimordialLot(aoDevTeam2, amount.div(2), inverseMultiplier, theAONetworkBonusAmount.div(2));
2057 		}
2058 		_mint(theAO, theAONetworkBonusAmount);
2059 		return _lotId;
2060 	}
2061 
2062 	/**
2063 	 * @dev Create a lot with `primordialAmount` of primordial ions with `_multiplier` for an `account`
2064 	 *		during network exchange, and reward `_networkBonusAmount` if exist
2065 	 * @param _account Address of the lot owner
2066 	 * @param _primordialAmount The amount of primordial ions to be stored in the lot
2067 	 * @param _multiplier The multiplier for this lot in (10 ** 6)
2068 	 * @param _networkBonusAmount The network ion bonus amount
2069 	 * @return Created lot Id
2070 	 */
2071 	function _createPrimordialLot(address _account, uint256 _primordialAmount, uint256 _multiplier, uint256 _networkBonusAmount) internal returns (bytes32) {
2072 		bytes32 lotId = _aoIonLot.createPrimordialLot(_account, _primordialAmount, _multiplier, _networkBonusAmount);
2073 
2074 		ownerWeightedMultiplier[_account] = AOLibrary.calculateWeightedMultiplier(ownerWeightedMultiplier[_account], primordialBalanceOf[_account], _multiplier, _primordialAmount);
2075 
2076 		// If this is the first lot, set this as the max multiplier of the account
2077 		if (_aoIonLot.totalLotsByAddress(_account) == 1) {
2078 			ownerMaxMultiplier[_account] = _multiplier;
2079 		}
2080 		_mintPrimordial(_account, _primordialAmount);
2081 		_mint(_account, _networkBonusAmount);
2082 
2083 		return lotId;
2084 	}
2085 
2086 	/**
2087 	 * @dev Create `mintedAmount` Primordial ions and send it to `target`
2088 	 * @param target Address to receive the Primordial ions
2089 	 * @param mintedAmount The amount of Primordial ions it will receive
2090 	 */
2091 	function _mintPrimordial(address target, uint256 mintedAmount) internal {
2092 		primordialBalanceOf[target] = primordialBalanceOf[target].add(mintedAmount);
2093 		primordialTotalSupply = primordialTotalSupply.add(mintedAmount);
2094 		emit PrimordialTransfer(address(0), address(this), mintedAmount);
2095 		emit PrimordialTransfer(address(this), target, mintedAmount);
2096 	}
2097 
2098 	/**
2099 	 * @dev Create a lot with `amount` of ions at `weightedMultiplier` for an `account`
2100 	 * @param _account Address of lot owner
2101 	 * @param _amount The amount of ions
2102 	 * @param _weightedMultiplier The multiplier of the lot (in 10^6)
2103 	 * @return bytes32 of new created lot ID
2104 	 */
2105 	function _createWeightedMultiplierLot(address _account, uint256 _amount, uint256 _weightedMultiplier) internal returns (bytes32) {
2106 		require (_account != address(0));
2107 		require (_amount > 0);
2108 
2109 		bytes32 lotId = _aoIonLot.createWeightedMultiplierLot(_account, _amount, _weightedMultiplier);
2110 		// If this is the first lot, set this as the max multiplier of the account
2111 		if (_aoIonLot.totalLotsByAddress(_account) == 1) {
2112 			ownerMaxMultiplier[_account] = _weightedMultiplier;
2113 		}
2114 		return lotId;
2115 	}
2116 
2117 	/**
2118 	 * @dev Create Lot and send `_value` Primordial ions from `_from` to `_to`
2119 	 * @param _from The address of sender
2120 	 * @param _to The address of the recipient
2121 	 * @param _value The amount to send
2122 	 * @return true on success
2123 	 */
2124 	function _createLotAndTransferPrimordial(address _from, address _to, uint256 _value) internal returns (bool) {
2125 		bytes32 _createdLotId = _createWeightedMultiplierLot(_to, _value, ownerWeightedMultiplier[_from]);
2126 		(, address _lotOwner,,) = _aoIonLot.lotById(_createdLotId);
2127 
2128 		// Make sure the new lot is created successfully
2129 		require (_lotOwner == _to);
2130 
2131 		// Update the weighted multiplier of the recipient
2132 		ownerWeightedMultiplier[_to] = AOLibrary.calculateWeightedMultiplier(ownerWeightedMultiplier[_to], primordialBalanceOf[_to], ownerWeightedMultiplier[_from], _value);
2133 
2134 		// Transfer the Primordial ions
2135 		require (_transferPrimordial(_from, _to, _value));
2136 		return true;
2137 	}
2138 
2139 	/**
2140 	 * @dev Send `_value` Primordial ions from `_from` to `_to`
2141 	 * @param _from The address of sender
2142 	 * @param _to The address of the recipient
2143 	 * @param _value The amount to send
2144 	 */
2145 	function _transferPrimordial(address _from, address _to, uint256 _value) internal returns (bool) {
2146 		require (_to != address(0));									// Prevent transfer to 0x0 address. Use burn() instead
2147 		require (primordialBalanceOf[_from] >= _value);						// Check if the sender has enough
2148 		require (primordialBalanceOf[_to].add(_value) >= primordialBalanceOf[_to]);	// Check for overflows
2149 		require (!frozenAccount[_from]);								// Check if sender is frozen
2150 		require (!frozenAccount[_to]);									// Check if recipient is frozen
2151 		uint256 previousBalances = primordialBalanceOf[_from].add(primordialBalanceOf[_to]);
2152 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);			// Subtract from the sender
2153 		primordialBalanceOf[_to] = primordialBalanceOf[_to].add(_value);				// Add the same to the recipient
2154 		emit PrimordialTransfer(_from, _to, _value);
2155 		assert(primordialBalanceOf[_from].add(primordialBalanceOf[_to]) == previousBalances);
2156 		return true;
2157 	}
2158 
2159 	/**
2160 	 * @dev Get setting variables
2161 	 * @return startingPrimordialMultiplier The starting multiplier used to calculate primordial ion
2162 	 * @return endingPrimordialMultiplier The ending multiplier used to calculate primordial ion
2163 	 * @return startingNetworkBonusMultiplier The starting multiplier used to calculate network ion bonus
2164 	 * @return endingNetworkBonusMultiplier The ending multiplier used to calculate network ion bonus
2165 	 */
2166 	function _getSettingVariables() internal view returns (uint256, uint256, uint256, uint256) {
2167 		(uint256 startingPrimordialMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'startingPrimordialMultiplier');
2168 		(uint256 endingPrimordialMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'endingPrimordialMultiplier');
2169 
2170 		(uint256 startingNetworkBonusMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'startingNetworkBonusMultiplier');
2171 		(uint256 endingNetworkBonusMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'endingNetworkBonusMultiplier');
2172 
2173 		return (startingPrimordialMultiplier, endingPrimordialMultiplier, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier);
2174 	}
2175 }
2176 
2177 
2178 /**
2179  * @title AOPool
2180  *
2181  * This contract acts as the exchange between AO and ETH/ERC-20 compatible tokens
2182  */
2183 contract AOPool is TheAO {
2184 	using SafeMath for uint256;
2185 
2186 	address public aoIonAddress;
2187 	AOIon internal _aoIon;
2188 
2189 	struct Pool {
2190 		uint256 price;	// Flat price of AO
2191 
2192 		/**
2193 		 * If true, Pool is live and can be sold into.
2194 		 * Otherwise, Pool cannot be sold into.
2195 		 */
2196 		bool status;
2197 
2198 		/**
2199 		 * If true, has sell cap. Otherwise, no sell cap.
2200 		 */
2201 		bool sellCapStatus;
2202 
2203 		/**
2204 		 * Denominated in AO, creates a cap for the amount of AO that can be
2205 		 * put up for sale in this pool at `price`
2206 		 */
2207 		uint256 sellCapAmount;
2208 
2209 		/**
2210 		 * If true, has quantity cap. Otherwise, no quantity cap.
2211 		 */
2212 		bool quantityCapStatus;
2213 
2214 		/**
2215 		 * Denominated in AO, creates a cap for the amount of AO at any given time
2216 		 * that can be available for sale in this pool
2217 		 */
2218 		uint256 quantityCapAmount;
2219 
2220 		/**
2221 		 * If true, the Pool is priced in an ERC20 compatible token.
2222 		 * Otherwise, the Pool is priced in Ethereum
2223 		 */
2224 		bool erc20CounterAsset;
2225 
2226 		address erc20TokenAddress;			// The address of the ERC20 Token
2227 
2228 		/**
2229 		 * Used if ERC20 token needs to deviate from Ethereum in multiplication/division
2230 		 */
2231 		uint256 erc20TokenMultiplier;
2232 
2233 		address adminAddress;				// defaults to TheAO address, but can be modified
2234 	}
2235 
2236 	struct Lot {
2237 		bytes32 lotId;						// The ID of this Lot
2238 		address seller;						// Ethereum address of the seller
2239 		uint256 lotQuantity;				// Amount of AO being added to the Pool from this Lot
2240 		uint256 poolId;						// Identifier for the Pool this Lot is adding to
2241 		uint256 poolPreSellSnapshot;		// Amount of contributed to the Pool prior to this Lot Number
2242 		uint256 poolSellLotSnapshot;		// poolPreSellSnapshot + lotQuantity
2243 		uint256 lotValueInCounterAsset;		// Amount of AO x Pool Price
2244 		uint256 counterAssetWithdrawn;		// Amount of Counter-Asset withdrawn from this Lot
2245 		uint256 ionWithdrawn;				// Amount of AO withdrawn from this Lot
2246 		uint256 timestamp;
2247 	}
2248 
2249 	// Contract variables
2250 	uint256 public totalPool;
2251 	uint256 public contractTotalLot;		// Total lot from all pools
2252 	uint256 public contractTotalSell;		// Quantity of AO that has been contributed to all Pools
2253 	uint256 public contractTotalBuy;		// Quantity of AO that has been bought from all Pools
2254 	uint256 public contractTotalQuantity;	// Quantity of AO available to buy from all Pools
2255 	uint256 public contractTotalWithdrawn;	// Quantity of AO that has been withdrawn from all Pools
2256 	uint256 public contractEthereumBalance;	// Total Ethereum in contract
2257 	uint256 public contractTotalEthereumWithdrawn; // Total Ethereum withdrawn from selling AO in contract
2258 
2259 	// Mapping from Pool ID to Pool
2260 	mapping (uint256 => Pool) public pools;
2261 
2262 	// Mapping from Lot ID to Lot
2263 	mapping (bytes32 => Lot) public lots;
2264 
2265 	// Mapping from Pool ID to total Lots in the Pool
2266 	mapping (uint256 => uint256) public poolTotalLot;
2267 
2268 	// Mapping from Pool ID to quantity of AO available to buy at `price`
2269 	mapping (uint256 => uint256) public poolTotalQuantity;
2270 
2271 	// Mapping from Pool ID to quantity of AO that has been contributed to the Pool
2272 	mapping (uint256 => uint256) public poolTotalSell;
2273 
2274 	// Mapping from Pool ID to quantity of AO that has been bought from the Pool
2275 	mapping (uint256 => uint256) public poolTotalBuy;
2276 
2277 	// Mapping from Pool ID to quantity of AO that has been withdrawn from the Pool
2278 	mapping (uint256 => uint256) public poolTotalWithdrawn;
2279 
2280 	// Mapping from Pool ID to total Ethereum available to withdraw
2281 	mapping (uint256 => uint256) public poolEthereumBalance;
2282 
2283 	// Mapping from Pool ID to quantity of ERC20 token available to withdraw
2284 	mapping (uint256 => uint256) public poolERC20TokenBalance;
2285 
2286 	// Mapping from Pool ID to amount of Ethereum withdrawn from selling AO
2287 	mapping (uint256 => uint256) public poolTotalEthereumWithdrawn;
2288 
2289 	// Mapping from an address to quantity of AO put on sale from all sell lots
2290 	mapping (address => uint256) public totalPutOnSale;
2291 
2292 	// Mapping from an address to quantity of AO sold and redeemed from all sell lots
2293 	mapping (address => uint256) public totalSold;
2294 
2295 	// Mapping from an address to quantity of AO bought from all pool
2296 	mapping (address => uint256) public totalBought;
2297 
2298 	// Mapping from an address to amount of Ethereum withdrawn from selling AO
2299 	mapping (address => uint256) public totalEthereumWithdrawn;
2300 
2301 	// Mapping from an address to its Lots
2302 	mapping (address => bytes32[]) internal ownerLots;
2303 
2304 	// Mapping from Pool's Lot ID to Lot internal ID
2305 	mapping (uint256 => mapping (bytes32 => uint256)) internal poolLotInternalIdLookup;
2306 
2307 	// Mapping from Pool's Lot internal ID to total ion withdrawn
2308 	mapping (uint256 => mapping (uint256 => uint256)) internal poolLotIonWithdrawn;
2309 
2310 	// Mapping from Pool's tenth Lot to total ion withdrawn
2311 	// This is to help optimize calculating the total ion withdrawn before certain Lot
2312 	mapping (uint256 => mapping (uint256 => uint256)) internal poolTenthLotIonWithdrawnSnapshot;
2313 
2314 	// Mapping from Pool's hundredth Lot to total ion withdrawn
2315 	// This is to help optimize calculating the total ion withdrawn before certain Lot
2316 	mapping (uint256 => mapping (uint256 => uint256)) internal poolHundredthLotIonWithdrawnSnapshot;
2317 
2318 	// Mapping from Pool's thousandth Lot to total ion withdrawn
2319 	// This is to help optimize calculating the total ion withdrawn before certain Lot
2320 	mapping (uint256 => mapping (uint256 => uint256)) internal poolThousandthLotIonWithdrawnSnapshot;
2321 
2322 	// Mapping from Pool's ten thousandth Lot to total ion withdrawn
2323 	// This is to help optimize calculating the total ion withdrawn before certain Lot
2324 	mapping (uint256 => mapping (uint256 => uint256)) internal poolTenThousandthLotIonWithdrawnSnapshot;
2325 
2326 	// Mapping from Pool's hundred thousandth Lot to total ion withdrawn
2327 	// This is to help optimize calculating the total ion withdrawn before certain Lot
2328 	mapping (uint256 => mapping (uint256 => uint256)) internal poolHundredThousandthLotIonWithdrawnSnapshot;
2329 
2330 	// Mapping from Pool's millionth Lot to total ion withdrawn
2331 	// This is to help optimize calculating the total ion withdrawn before certain Lot
2332 	mapping (uint256 => mapping (uint256 => uint256)) internal poolMillionthLotIonWithdrawnSnapshot;
2333 
2334 	// Event to be broadcasted to public when Pool is created
2335 	event CreatePool(uint256 indexed poolId, address indexed adminAddress, uint256 price, bool status, bool sellCapStatus, uint256 sellCapAmount, bool quantityCapStatus, uint256 quantityCapAmount, bool erc20CounterAsset, address erc20TokenAddress, uint256 erc20TokenMultiplier);
2336 
2337 	// Event to be broadcasted to public when Pool's status is updated
2338 	// If status == true, start Pool
2339 	// Otherwise, stop Pool
2340 	event UpdatePoolStatus(uint256 indexed poolId, bool status);
2341 
2342 	// Event to be broadcasted to public when Pool's admin address is changed
2343 	event ChangeAdminAddress(uint256 indexed poolId, address newAdminAddress);
2344 
2345 	/**
2346 	 * Event to be broadcasted to public when a seller sells AO
2347 	 *
2348 	 * If erc20CounterAsset is true, the Lot is priced in an ERC20 compatible token.
2349 	 * Otherwise, the Lot is priced in Ethereum
2350 	 */
2351 	event LotCreation(uint256 indexed poolId, bytes32 indexed lotId, address indexed seller, uint256 lotQuantity, uint256 price, uint256 poolPreSellSnapshot, uint256 poolSellLotSnapshot, uint256 lotValueInCounterAsset, bool erc20CounterAsset, uint256 timestamp);
2352 
2353 	// Event to be broadcasted to public when a buyer buys AO
2354 	event BuyWithEth(uint256 indexed poolId, address indexed buyer, uint256 buyQuantity, uint256 price, uint256 currentPoolTotalBuy);
2355 
2356 	// Event to be broadcasted to public when a buyer withdraw ETH from Lot
2357 	event WithdrawEth(address indexed seller, bytes32 indexed lotId, uint256 indexed poolId, uint256 withdrawnAmount, uint256 currentLotValueInCounterAsset, uint256 currentLotCounterAssetWithdrawn);
2358 
2359 	// Event to be broadcasted to public when a seller withdraw ion from Lot
2360 	event WithdrawIon(address indexed seller, bytes32 indexed lotId, uint256 indexed poolId, uint256 withdrawnAmount, uint256 currentlotValueInCounterAsset, uint256 currentLotIonWithdrawn);
2361 
2362 	/**
2363 	 * @dev Constructor function
2364 	 */
2365 	constructor(address _aoIonAddress, address _nameTAOPositionAddress) public {
2366 		setAOIonAddress(_aoIonAddress);
2367 		setNameTAOPositionAddress(_nameTAOPositionAddress);
2368 	}
2369 
2370 	/**
2371 	 * @dev Checks if the calling contract address is The AO
2372 	 *		OR
2373 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
2374 	 */
2375 	modifier onlyTheAO {
2376 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
2377 		_;
2378 	}
2379 
2380 	/***** THE AO ONLY METHODS *****/
2381 	/**
2382 	 * @dev Transfer ownership of The AO to new address
2383 	 * @param _theAO The new address to be transferred
2384 	 */
2385 	function transferOwnership(address _theAO) public onlyTheAO {
2386 		require (_theAO != address(0));
2387 		theAO = _theAO;
2388 	}
2389 
2390 	/**
2391 	 * @dev Whitelist `_account` address to transact on behalf of others
2392 	 * @param _account The address to whitelist
2393 	 * @param _whitelist Either to whitelist or not
2394 	 */
2395 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
2396 		require (_account != address(0));
2397 		whitelist[_account] = _whitelist;
2398 	}
2399 
2400 	/**
2401 	 * @dev The AO set the AOIonAddress Address
2402 	 * @param _aoIonAddress The address of AOIonAddress
2403 	 */
2404 	function setAOIonAddress(address _aoIonAddress) public onlyTheAO {
2405 		require (_aoIonAddress != address(0));
2406 		aoIonAddress = _aoIonAddress;
2407 		_aoIon = AOIon(_aoIonAddress);
2408 	}
2409 
2410 	/**
2411 	 * @dev The AO sets NameTAOPosition address
2412 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
2413 	 */
2414 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
2415 		require (_nameTAOPositionAddress != address(0));
2416 		nameTAOPositionAddress = _nameTAOPositionAddress;
2417 	}
2418 
2419 	/**
2420 	 * @dev Allows TheAO to transfer `_amount` of ETH from this address to `_recipient`
2421 	 * @param _recipient The recipient address
2422 	 * @param _amount The amount to transfer
2423 	 */
2424 	function transferEth(address payable _recipient, uint256 _amount) public onlyTheAO {
2425 		_recipient.transfer(_amount);
2426 	}
2427 
2428 	/**
2429 	 * @dev Allows TheAO to transfer `_amount` of ERC20 Token from this address to `_recipient`
2430 	 * @param _erc20TokenAddress The address of ERC20 Token
2431 	 * @param _recipient The recipient address
2432 	 * @param _amount The amount to transfer
2433 	 */
2434 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyTheAO {
2435 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
2436 		require (_erc20.transfer(_recipient, _amount));
2437 	}
2438 
2439 	/**
2440 	 * @dev TheAO creates a Pool
2441 	 * @param _price The flat price of AO
2442 	 * @param _status The status of the Pool
2443 	 *					true = Pool is live and can be sold into
2444 	 *					false = Pool cannot be sold into
2445 	 * @param _sellCapStatus Whether or not the Pool has sell cap
2446 	 *					true = has sell cap
2447 	 *					false = no sell cap
2448 	 * @param _sellCapAmount Cap for the amount of AO that can be put up for sale in this Pool at `_price`
2449 	 * @param _quantityCapStatus Whether or not the Pool has quantity cap
2450 	 *					true = has quantity cap
2451 	 *					false = no quantity cap
2452 	 * @param _quantityCapAmount Cap for the amount of AO at any given time that can be available for sale in this Pool
2453 	 * @param _erc20CounterAsset Type of the Counter-Asset
2454 	 *					true = Pool is priced in ERC20 compatible Token
2455 	 *					false = Pool is priced in Ethereum
2456 	 * @param _erc20TokenAddress The address of the ERC20 Token
2457 	 * @param _erc20TokenMultiplier Used if ERC20 Token needs to deviate from Ethereum in multiplication/division
2458 	 */
2459 	function createPool(
2460 		uint256 _price,
2461 		bool _status,
2462 		bool _sellCapStatus,
2463 		uint256 _sellCapAmount,
2464 		bool _quantityCapStatus,
2465 		uint256 _quantityCapAmount,
2466 		bool _erc20CounterAsset,
2467 		address _erc20TokenAddress,
2468 		uint256 _erc20TokenMultiplier) public onlyTheAO {
2469 		require (_price > 0);
2470 		// Make sure sell cap amount is provided if sell cap is enabled
2471 		if (_sellCapStatus == true) {
2472 			require (_sellCapAmount > 0);
2473 		}
2474 		// Make sure quantity cap amount is provided if quantity cap is enabled
2475 		if (_quantityCapStatus == true) {
2476 			require (_quantityCapAmount > 0);
2477 		}
2478 		// Make sure the ERC20 token address and multiplier are provided
2479 		// if this Pool is priced in ERC20 compatible Token
2480 		if (_erc20CounterAsset == true) {
2481 			require (AOLibrary.isValidERC20TokenAddress(_erc20TokenAddress));
2482 			require (_erc20TokenMultiplier > 0);
2483 		}
2484 
2485 		totalPool++;
2486 		Pool storage _pool = pools[totalPool];
2487 		_pool.price = _price;
2488 		_pool.status = _status;
2489 		_pool.sellCapStatus = _sellCapStatus;
2490 		if (_sellCapStatus) {
2491 			_pool.sellCapAmount = _sellCapAmount;
2492 		}
2493 		_pool.quantityCapStatus = _quantityCapStatus;
2494 		if (_quantityCapStatus) {
2495 			_pool.quantityCapAmount = _quantityCapAmount;
2496 		}
2497 		_pool.erc20CounterAsset = _erc20CounterAsset;
2498 		if (_erc20CounterAsset) {
2499 			_pool.erc20TokenAddress = _erc20TokenAddress;
2500 			_pool.erc20TokenMultiplier = _erc20TokenMultiplier;
2501 		}
2502 		_pool.adminAddress = msg.sender;
2503 
2504 		emit CreatePool(totalPool, _pool.adminAddress, _pool.price, _pool.status, _pool.sellCapStatus, _pool.sellCapAmount, _pool.quantityCapStatus, _pool.quantityCapAmount, _pool.erc20CounterAsset, _pool.erc20TokenAddress, _pool.erc20TokenMultiplier);
2505 	}
2506 
2507 	/***** Pool's Admin Only Methods *****/
2508 	/**
2509 	 * @dev Start/Stop a Pool
2510 	 * @param _poolId The ID of the Pool
2511 	 * @param _status The status to set. true = start. false = stop
2512 	 */
2513 	function updatePoolStatus(uint256 _poolId, bool _status) public {
2514 		// Check pool existence by requiring price > 0
2515 		require (pools[_poolId].price > 0 && (pools[_poolId].adminAddress == msg.sender || AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress)));
2516 		pools[_poolId].status = _status;
2517 		emit UpdatePoolStatus(_poolId, _status);
2518 	}
2519 
2520 	/**
2521 	 * @dev Change Admin Address
2522 	 * @param _poolId The ID of the Pool
2523 	 * @param _adminAddress The new admin address to set
2524 	 */
2525 	function changeAdminAddress(uint256 _poolId, address _adminAddress) public {
2526 		// Check pool existence by requiring price > 0
2527 		require (pools[_poolId].price > 0 && (pools[_poolId].adminAddress == msg.sender || AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress)));
2528 		require (_adminAddress != address(0));
2529 		pools[_poolId].adminAddress = _adminAddress;
2530 		emit ChangeAdminAddress(_poolId, _adminAddress);
2531 	}
2532 
2533 	/***** Public Methods *****/
2534 	/**
2535 	 * @dev Seller sells AO in Pool `_poolId` - create a Lot to be added to a Pool for a seller.
2536 	 * @param _poolId The ID of the Pool
2537 	 * @param _quantity The amount of AO to be sold
2538 	 * @param _price The price supplied by seller
2539 	 */
2540 	function sell(uint256 _poolId, uint256 _quantity, uint256 _price) public {
2541 		Pool memory _pool = pools[_poolId];
2542 		require (_pool.status == true && _pool.price == _price && _quantity > 0 && _aoIon.balanceOf(msg.sender) >= _quantity);
2543 
2544 		// If there is a sell cap
2545 		if (_pool.sellCapStatus == true) {
2546 			require (poolTotalSell[_poolId].add(_quantity) <= _pool.sellCapAmount);
2547 		}
2548 
2549 		// If there is a quantity cap
2550 		if (_pool.quantityCapStatus == true) {
2551 			require (poolTotalQuantity[_poolId].add(_quantity) <= _pool.quantityCapAmount);
2552 		}
2553 
2554 		// Create Lot for this sell transaction
2555 		contractTotalLot++;
2556 		poolTotalLot[_poolId]++;
2557 
2558 		// Generate Lot ID
2559 		bytes32 _lotId = keccak256(abi.encodePacked(this, msg.sender, contractTotalLot));
2560 
2561 		Lot storage _lot = lots[_lotId];
2562 		_lot.lotId = _lotId;
2563 		_lot.seller = msg.sender;
2564 		_lot.lotQuantity = _quantity;
2565 		_lot.poolId = _poolId;
2566 		_lot.poolPreSellSnapshot = poolTotalSell[_poolId];
2567 		_lot.poolSellLotSnapshot = poolTotalSell[_poolId].add(_quantity);
2568 		_lot.lotValueInCounterAsset = _quantity.mul(_pool.price);
2569 		_lot.timestamp = now;
2570 		poolLotInternalIdLookup[_poolId][_lotId] = poolTotalLot[_poolId];
2571 		ownerLots[msg.sender].push(_lotId);
2572 
2573 		// Update contract variables
2574 		poolTotalQuantity[_poolId] = poolTotalQuantity[_poolId].add(_quantity);
2575 		poolTotalSell[_poolId] = poolTotalSell[_poolId].add(_quantity);
2576 		totalPutOnSale[msg.sender] = totalPutOnSale[msg.sender].add(_quantity);
2577 		contractTotalQuantity = contractTotalQuantity.add(_quantity);
2578 		contractTotalSell = contractTotalSell.add(_quantity);
2579 
2580 		require (_aoIon.whitelistTransferFrom(msg.sender, address(this), _quantity));
2581 
2582 		emit LotCreation(_lot.poolId, _lot.lotId, _lot.seller, _lot.lotQuantity, _pool.price, _lot.poolPreSellSnapshot, _lot.poolSellLotSnapshot, _lot.lotValueInCounterAsset, _pool.erc20CounterAsset, _lot.timestamp);
2583 	}
2584 
2585 	/**
2586 	 * @dev Retrieve number of Lots an `_account` has
2587 	 * @param _account The address of the Lot's owner
2588 	 * @return Total Lots the owner has
2589 	 */
2590 	function ownerTotalLot(address _account) public view returns (uint256) {
2591 		return ownerLots[_account].length;
2592 	}
2593 
2594 	/**
2595 	 * @dev Get list of owner's Lot IDs from `_from` to `_to` index
2596 	 * @param _account The address of the Lot's owner
2597 	 * @param _from The starting index, (i.e 0)
2598 	 * @param _to The ending index, (i.e total - 1)
2599 	 * @return list of owner's Lot IDs
2600 	 */
2601 	function ownerLotIds(address _account, uint256 _from, uint256 _to) public view returns (bytes32[] memory) {
2602 		require (_from >= 0 && _to >= _from && ownerLots[_account].length > _to);
2603 		bytes32[] memory _lotIds = new bytes32[](_to.sub(_from).add(1));
2604 		for (uint256 i = _from; i <= _to; i++) {
2605 			_lotIds[i.sub(_from)] = ownerLots[_account][i];
2606 		}
2607 		return _lotIds;
2608 	}
2609 
2610 	/**
2611 	 * @dev Buyer buys AO from Pool `_poolId` with Ethereum
2612 	 * @param _poolId The ID of the Pool
2613 	 * @param _quantity The amount of AO to be bought
2614 	 * @param _price The price supplied by buyer
2615 	 */
2616 	function buyWithEth(uint256 _poolId, uint256 _quantity, uint256 _price) public payable {
2617 		Pool memory _pool = pools[_poolId];
2618 		require (_pool.status == true && _pool.price == _price && _pool.erc20CounterAsset == false);
2619 		require (_quantity > 0 && _quantity <= poolTotalQuantity[_poolId]);
2620 		require (msg.value > 0 && msg.value.div(_pool.price) == _quantity);
2621 
2622 		// Update contract variables
2623 		poolTotalQuantity[_poolId] = poolTotalQuantity[_poolId].sub(_quantity);
2624 		poolTotalBuy[_poolId] = poolTotalBuy[_poolId].add(_quantity);
2625 		poolEthereumBalance[_poolId] = poolEthereumBalance[_poolId].add(msg.value);
2626 
2627 		contractTotalQuantity = contractTotalQuantity.sub(_quantity);
2628 		contractTotalBuy = contractTotalBuy.add(_quantity);
2629 		contractEthereumBalance = contractEthereumBalance.add(msg.value);
2630 
2631 		totalBought[msg.sender] = totalBought[msg.sender].add(_quantity);
2632 
2633 		require (_aoIon.whitelistTransferFrom(address(this), msg.sender, _quantity));
2634 
2635 		emit BuyWithEth(_poolId, msg.sender, _quantity, _price, poolTotalBuy[_poolId]);
2636 	}
2637 
2638 	/**
2639 	 * @dev Seller withdraw Ethereum from Lot `_lotId`
2640 	 * @param _lotId The ID of the Lot
2641 	 */
2642 	function withdrawEth(bytes32 _lotId) public {
2643 		Lot storage _lot = lots[_lotId];
2644 		require (_lot.seller == msg.sender && _lot.lotValueInCounterAsset > 0);
2645 		(uint256 soldQuantity, uint256 ethAvailableToWithdraw,) = lotEthAvailableToWithdraw(_lotId);
2646 
2647 		require (ethAvailableToWithdraw > 0 && ethAvailableToWithdraw <= _lot.lotValueInCounterAsset && ethAvailableToWithdraw <= poolEthereumBalance[_lot.poolId] && ethAvailableToWithdraw <= contractEthereumBalance && soldQuantity <= _lot.lotQuantity.sub(_lot.ionWithdrawn));
2648 
2649 		// Update lot variables
2650 		_lot.counterAssetWithdrawn = _lot.counterAssetWithdrawn.add(ethAvailableToWithdraw);
2651 		_lot.lotValueInCounterAsset = _lot.lotValueInCounterAsset.sub(ethAvailableToWithdraw);
2652 
2653 		// Update contract variables
2654 		poolEthereumBalance[_lot.poolId] = poolEthereumBalance[_lot.poolId].sub(ethAvailableToWithdraw);
2655 		poolTotalEthereumWithdrawn[_lot.poolId] = poolTotalEthereumWithdrawn[_lot.poolId].add(ethAvailableToWithdraw);
2656 		contractEthereumBalance = contractEthereumBalance.sub(ethAvailableToWithdraw);
2657 		contractTotalEthereumWithdrawn = contractTotalEthereumWithdrawn.add(ethAvailableToWithdraw);
2658 
2659 		totalSold[msg.sender] = totalSold[msg.sender].add(soldQuantity);
2660 		totalEthereumWithdrawn[msg.sender] = totalEthereumWithdrawn[msg.sender].add(ethAvailableToWithdraw);
2661 
2662 		// Send eth to seller
2663 		address(uint160(_lot.seller)).transfer(ethAvailableToWithdraw);
2664 		//_lot.seller.transfer(ethAvailableToWithdraw);
2665 
2666 		emit WithdrawEth(_lot.seller, _lot.lotId, _lot.poolId, ethAvailableToWithdraw, _lot.lotValueInCounterAsset, _lot.counterAssetWithdrawn);
2667 	}
2668 
2669 	/**
2670 	 * @dev Seller gets Lot `_lotId` (priced in ETH) available to withdraw info
2671 	 * @param _lotId The ID of the Lot
2672 	 * @return The amount of ion sold
2673 	 * @return Ethereum available to withdraw from the Lot
2674 	 * @return Current Ethereum withdrawn from the Lot
2675 	 */
2676 	function lotEthAvailableToWithdraw(bytes32 _lotId) public view returns (uint256, uint256, uint256) {
2677 		Lot memory _lot = lots[_lotId];
2678 		require (_lot.seller != address(0));
2679 
2680 		Pool memory _pool = pools[_lot.poolId];
2681 		require (_pool.erc20CounterAsset == false);
2682 
2683 		uint256 soldQuantity = 0;
2684 		uint256 ethAvailableToWithdraw = 0;
2685 
2686 		// Check whether or not there are ions withdrawn from Lots before this Lot
2687 		uint256 lotAdjustment = totalIonWithdrawnBeforeLot(_lotId);
2688 
2689 		if (poolTotalBuy[_lot.poolId] > _lot.poolPreSellSnapshot.sub(lotAdjustment) && _lot.lotValueInCounterAsset > 0) {
2690 			soldQuantity = (poolTotalBuy[_lot.poolId] >= _lot.poolSellLotSnapshot.sub(lotAdjustment)) ? _lot.lotQuantity : poolTotalBuy[_lot.poolId].sub(_lot.poolPreSellSnapshot.sub(lotAdjustment));
2691 			if (soldQuantity > 0) {
2692 				if (soldQuantity > _lot.ionWithdrawn) {
2693 					soldQuantity = soldQuantity.sub(_lot.ionWithdrawn);
2694 				}
2695 				soldQuantity = soldQuantity.sub(_lot.counterAssetWithdrawn.div(_pool.price));
2696 				ethAvailableToWithdraw = soldQuantity.mul(_pool.price);
2697 				assert (soldQuantity <= _lot.lotValueInCounterAsset.div(_pool.price));
2698 				assert (soldQuantity.add(_lot.ionWithdrawn) <= _lot.lotQuantity);
2699 				assert (ethAvailableToWithdraw <= _lot.lotValueInCounterAsset);
2700 			}
2701 		}
2702 		return (soldQuantity, ethAvailableToWithdraw, _lot.counterAssetWithdrawn);
2703 	}
2704 
2705 	/**
2706 	 * @dev Seller withdraw ion from Lot `_lotId`
2707 	 * @param _lotId The ID of the Lot
2708 	 * @param _quantity The amount of ion to withdraw
2709 	 */
2710 	function withdrawIon(bytes32 _lotId, uint256 _quantity) public {
2711 		Lot storage _lot = lots[_lotId];
2712 		require (_lot.seller == msg.sender && _lot.lotValueInCounterAsset > 0);
2713 
2714 		Pool memory _pool = pools[_lot.poolId];
2715 		require (_quantity > 0 && _quantity <= _lot.lotValueInCounterAsset.div(_pool.price));
2716 
2717 		// Update lot variables
2718 		_lot.ionWithdrawn = _lot.ionWithdrawn.add(_quantity);
2719 		_lot.lotValueInCounterAsset = _lot.lotValueInCounterAsset.sub(_quantity.mul(_pool.price));
2720 		poolLotIonWithdrawn[_lot.poolId][poolLotInternalIdLookup[_lot.poolId][_lotId]] = poolLotIonWithdrawn[_lot.poolId][poolLotInternalIdLookup[_lot.poolId][_lotId]].add(_quantity);
2721 
2722 		// Store Pool's millionth Lot snapshot
2723 		uint256 millionth = poolLotInternalIdLookup[_lot.poolId][_lotId].div(1000000);
2724 		if (poolLotInternalIdLookup[_lot.poolId][_lotId].sub(millionth.mul(1000000)) != 0) {
2725 			millionth++;
2726 		}
2727 		poolMillionthLotIonWithdrawnSnapshot[_lot.poolId][millionth] = poolMillionthLotIonWithdrawnSnapshot[_lot.poolId][millionth].add(_quantity);
2728 
2729 		// Store Pool's hundred thousandth Lot snapshot
2730 		uint256 hundredThousandth = poolLotInternalIdLookup[_lot.poolId][_lotId].div(100000);
2731 		if (poolLotInternalIdLookup[_lot.poolId][_lotId].sub(hundredThousandth.mul(100000)) != 0) {
2732 			hundredThousandth++;
2733 		}
2734 		poolHundredThousandthLotIonWithdrawnSnapshot[_lot.poolId][hundredThousandth] = poolHundredThousandthLotIonWithdrawnSnapshot[_lot.poolId][hundredThousandth].add(_quantity);
2735 
2736 		// Store Pool's ten thousandth Lot snapshot
2737 		uint256 tenThousandth = poolLotInternalIdLookup[_lot.poolId][_lotId].div(10000);
2738 		if (poolLotInternalIdLookup[_lot.poolId][_lotId].sub(tenThousandth.mul(10000)) != 0) {
2739 			tenThousandth++;
2740 		}
2741 		poolTenThousandthLotIonWithdrawnSnapshot[_lot.poolId][tenThousandth] = poolTenThousandthLotIonWithdrawnSnapshot[_lot.poolId][tenThousandth].add(_quantity);
2742 
2743 		// Store Pool's thousandth Lot snapshot
2744 		uint256 thousandth = poolLotInternalIdLookup[_lot.poolId][_lotId].div(1000);
2745 		if (poolLotInternalIdLookup[_lot.poolId][_lotId].sub(thousandth.mul(1000)) != 0) {
2746 			thousandth++;
2747 		}
2748 		poolThousandthLotIonWithdrawnSnapshot[_lot.poolId][thousandth] = poolThousandthLotIonWithdrawnSnapshot[_lot.poolId][thousandth].add(_quantity);
2749 
2750 		// Store Pool's hundredth Lot snapshot
2751 		uint256 hundredth = poolLotInternalIdLookup[_lot.poolId][_lotId].div(100);
2752 		if (poolLotInternalIdLookup[_lot.poolId][_lotId].sub(hundredth.mul(100)) != 0) {
2753 			hundredth++;
2754 		}
2755 		poolHundredthLotIonWithdrawnSnapshot[_lot.poolId][hundredth] = poolHundredthLotIonWithdrawnSnapshot[_lot.poolId][hundredth].add(_quantity);
2756 
2757 		// Store Pool's tenth Lot snapshot
2758 		uint256 tenth = poolLotInternalIdLookup[_lot.poolId][_lotId].div(10);
2759 		if (poolLotInternalIdLookup[_lot.poolId][_lotId].sub(tenth.mul(10)) != 0) {
2760 			tenth++;
2761 		}
2762 		poolTenthLotIonWithdrawnSnapshot[_lot.poolId][tenth] = poolTenthLotIonWithdrawnSnapshot[_lot.poolId][tenth].add(_quantity);
2763 
2764 		// Update contract variables
2765 		poolTotalQuantity[_lot.poolId] = poolTotalQuantity[_lot.poolId].sub(_quantity);
2766 		contractTotalQuantity = contractTotalQuantity.sub(_quantity);
2767 		poolTotalWithdrawn[_lot.poolId] = poolTotalWithdrawn[_lot.poolId].add(_quantity);
2768 		contractTotalWithdrawn = contractTotalWithdrawn.add(_quantity);
2769 
2770 		totalPutOnSale[msg.sender] = totalPutOnSale[msg.sender].sub(_quantity);
2771 
2772 		assert (_lot.ionWithdrawn.add(_lot.lotValueInCounterAsset.div(_pool.price)).add(_lot.counterAssetWithdrawn.div(_pool.price)) == _lot.lotQuantity);
2773 
2774 		require (_aoIon.whitelistTransferFrom(address(this), msg.sender, _quantity));
2775 
2776 		emit WithdrawIon(_lot.seller, _lot.lotId, _lot.poolId, _quantity, _lot.lotValueInCounterAsset, _lot.ionWithdrawn);
2777 	}
2778 
2779 	/**
2780 	 * @dev Get total ion withdrawn from all Lots before Lot `_lotId`
2781 	 * @param _lotId The ID of the Lot
2782 	 * @return Total ion withdrawn from all Lots before Lot `_lotId`
2783 	 */
2784 	function totalIonWithdrawnBeforeLot(bytes32 _lotId) public view returns (uint256) {
2785 		Lot memory _lot = lots[_lotId];
2786 		require (_lot.seller != address(0) && poolLotInternalIdLookup[_lot.poolId][_lotId] > 0);
2787 
2788 		uint256 totalIonWithdrawn = 0;
2789 		uint256 lotInternalId = poolLotInternalIdLookup[_lot.poolId][_lotId];
2790 		uint256 lowerBound = 0;
2791 
2792 		uint256 millionth = lotInternalId.div(1000000);
2793 		if (millionth > 0) {
2794 			for (uint256 i=1; i<=millionth; i++) {
2795 				if (poolMillionthLotIonWithdrawnSnapshot[_lot.poolId][i] > 0) {
2796 					totalIonWithdrawn = totalIonWithdrawn.add(poolMillionthLotIonWithdrawnSnapshot[_lot.poolId][i]);
2797 				}
2798 			}
2799 			lowerBound = millionth.mul(1000000);
2800 			if (lowerBound == lotInternalId) {
2801 				totalIonWithdrawn = totalIonWithdrawn.sub(poolLotIonWithdrawn[_lot.poolId][lotInternalId]);
2802 				return totalIonWithdrawn;
2803 			} else {
2804 				lowerBound = lowerBound.div(100000);
2805 			}
2806 		}
2807 
2808 		uint256 hundredThousandth = lotInternalId.div(100000);
2809 		if (hundredThousandth > 0) {
2810 			for (uint256 i=lowerBound.add(1); i<=hundredThousandth; i++) {
2811 				if (poolHundredThousandthLotIonWithdrawnSnapshot[_lot.poolId][i] > 0) {
2812 					totalIonWithdrawn = totalIonWithdrawn.add(poolHundredThousandthLotIonWithdrawnSnapshot[_lot.poolId][i]);
2813 				}
2814 			}
2815 			lowerBound = hundredThousandth.mul(100000);
2816 			if (lowerBound == lotInternalId) {
2817 				totalIonWithdrawn = totalIonWithdrawn.sub(poolLotIonWithdrawn[_lot.poolId][lotInternalId]);
2818 				return totalIonWithdrawn;
2819 			} else {
2820 				lowerBound = lowerBound.div(10000);
2821 			}
2822 		}
2823 
2824 		uint256 tenThousandth = lotInternalId.div(10000);
2825 		if (tenThousandth > 0) {
2826 			for (uint256 i=lowerBound.add(1); i<=tenThousandth; i++) {
2827 				if (poolTenThousandthLotIonWithdrawnSnapshot[_lot.poolId][i] > 0) {
2828 					totalIonWithdrawn = totalIonWithdrawn.add(poolTenThousandthLotIonWithdrawnSnapshot[_lot.poolId][i]);
2829 				}
2830 			}
2831 			lowerBound = tenThousandth.mul(10000);
2832 			if (lowerBound == lotInternalId) {
2833 				totalIonWithdrawn = totalIonWithdrawn.sub(poolLotIonWithdrawn[_lot.poolId][lotInternalId]);
2834 				return totalIonWithdrawn;
2835 			} else {
2836 				lowerBound = lowerBound.div(1000);
2837 			}
2838 		}
2839 
2840 		uint256 thousandth = lotInternalId.div(1000);
2841 		if (thousandth > 0) {
2842 			for (uint256 i=lowerBound.add(1); i<=thousandth; i++) {
2843 				if (poolThousandthLotIonWithdrawnSnapshot[_lot.poolId][i] > 0) {
2844 					totalIonWithdrawn = totalIonWithdrawn.add(poolThousandthLotIonWithdrawnSnapshot[_lot.poolId][i]);
2845 				}
2846 			}
2847 			lowerBound = thousandth.mul(1000);
2848 			if (lowerBound == lotInternalId) {
2849 				totalIonWithdrawn = totalIonWithdrawn.sub(poolLotIonWithdrawn[_lot.poolId][lotInternalId]);
2850 				return totalIonWithdrawn;
2851 			} else {
2852 				lowerBound = lowerBound.div(100);
2853 			}
2854 		}
2855 
2856 		uint256 hundredth = lotInternalId.div(100);
2857 		if (hundredth > 0) {
2858 			for (uint256 i=lowerBound.add(1); i<=hundredth; i++) {
2859 				if (poolHundredthLotIonWithdrawnSnapshot[_lot.poolId][i] > 0) {
2860 					totalIonWithdrawn = totalIonWithdrawn.add(poolHundredthLotIonWithdrawnSnapshot[_lot.poolId][i]);
2861 				}
2862 			}
2863 			lowerBound = hundredth.mul(100);
2864 			if (lowerBound == lotInternalId) {
2865 				totalIonWithdrawn = totalIonWithdrawn.sub(poolLotIonWithdrawn[_lot.poolId][lotInternalId]);
2866 				return totalIonWithdrawn;
2867 			} else {
2868 				lowerBound = lowerBound.div(10);
2869 			}
2870 		}
2871 
2872 		uint256 tenth = lotInternalId.div(10);
2873 		if (tenth > 0) {
2874 			for (uint256 i=lowerBound.add(1); i<=tenth; i++) {
2875 				if (poolTenthLotIonWithdrawnSnapshot[_lot.poolId][i] > 0) {
2876 					totalIonWithdrawn = totalIonWithdrawn.add(poolTenthLotIonWithdrawnSnapshot[_lot.poolId][i]);
2877 				}
2878 			}
2879 			lowerBound = tenth.mul(10);
2880 			if (lowerBound == lotInternalId) {
2881 				totalIonWithdrawn = totalIonWithdrawn.sub(poolLotIonWithdrawn[_lot.poolId][lotInternalId]);
2882 				return totalIonWithdrawn;
2883 			}
2884 		}
2885 
2886 		for (uint256 i=lowerBound.add(1); i<lotInternalId; i++) {
2887 			if (poolLotIonWithdrawn[_lot.poolId][i] > 0) {
2888 				totalIonWithdrawn = totalIonWithdrawn.add(poolLotIonWithdrawn[_lot.poolId][i]);
2889 			}
2890 		}
2891 		return totalIonWithdrawn;
2892 	}
2893 }