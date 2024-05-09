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
739 
740 interface ionRecipient {
741 	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
742 }
743 
744 /**
745  * @title AOIonInterface
746  */
747 contract AOIonInterface is TheAO {
748 	using SafeMath for uint256;
749 
750 	address public namePublicKeyAddress;
751 	address public nameAccountRecoveryAddress;
752 
753 	INameTAOPosition internal _nameTAOPosition;
754 	INamePublicKey internal _namePublicKey;
755 	INameAccountRecovery internal _nameAccountRecovery;
756 
757 	// Public variables of the contract
758 	string public name;
759 	string public symbol;
760 	uint8 public decimals;
761 	uint256 public totalSupply;
762 
763 	// To differentiate denomination of AO
764 	uint256 public powerOfTen;
765 
766 	/***** NETWORK ION VARIABLES *****/
767 	uint256 public sellPrice;
768 	uint256 public buyPrice;
769 
770 	// This creates an array with all balances
771 	mapping (address => uint256) public balanceOf;
772 	mapping (address => mapping (address => uint256)) public allowance;
773 	mapping (address => bool) public frozenAccount;
774 	mapping (address => uint256) public stakedBalance;
775 	mapping (address => uint256) public escrowedBalance;
776 
777 	// This generates a public event on the blockchain that will notify clients
778 	event FrozenFunds(address target, bool frozen);
779 	event Stake(address indexed from, uint256 value);
780 	event Unstake(address indexed from, uint256 value);
781 	event Escrow(address indexed from, address indexed to, uint256 value);
782 	event Unescrow(address indexed from, uint256 value);
783 
784 	// This generates a public event on the blockchain that will notify clients
785 	event Transfer(address indexed from, address indexed to, uint256 value);
786 
787 	// This generates a public event on the blockchain that will notify clients
788 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
789 
790 	// This notifies clients about the amount burnt
791 	event Burn(address indexed from, uint256 value);
792 
793 	/**
794 	 * @dev Constructor function
795 	 */
796 	constructor(string memory _name, string memory _symbol, address _nameTAOPositionAddress, address _namePublicKeyAddress, address _nameAccountRecoveryAddress) public {
797 		setNameTAOPositionAddress(_nameTAOPositionAddress);
798 		setNamePublicKeyAddress(_namePublicKeyAddress);
799 		setNameAccountRecoveryAddress(_nameAccountRecoveryAddress);
800 		name = _name;           // Set the name for display purposes
801 		symbol = _symbol;       // Set the symbol for display purposes
802 		powerOfTen = 0;
803 		decimals = 0;
804 	}
805 
806 	/**
807 	 * @dev Checks if the calling contract address is The AO
808 	 *		OR
809 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
810 	 */
811 	modifier onlyTheAO {
812 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
813 		_;
814 	}
815 
816 	/***** The AO ONLY METHODS *****/
817 	/**
818 	 * @dev Transfer ownership of The AO to new address
819 	 * @param _theAO The new address to be transferred
820 	 */
821 	function transferOwnership(address _theAO) public onlyTheAO {
822 		require (_theAO != address(0));
823 		theAO = _theAO;
824 	}
825 
826 	/**
827 	 * @dev Whitelist `_account` address to transact on behalf of others
828 	 * @param _account The address to whitelist
829 	 * @param _whitelist Either to whitelist or not
830 	 */
831 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
832 		require (_account != address(0));
833 		whitelist[_account] = _whitelist;
834 	}
835 
836 	/**
837 	 * @dev The AO set the NameTAOPosition Address
838 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
839 	 */
840 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
841 		require (_nameTAOPositionAddress != address(0));
842 		nameTAOPositionAddress = _nameTAOPositionAddress;
843 		_nameTAOPosition = INameTAOPosition(nameTAOPositionAddress);
844 	}
845 
846 	/**
847 	 * @dev The AO set the NamePublicKey Address
848 	 * @param _namePublicKeyAddress The address of NamePublicKey
849 	 */
850 	function setNamePublicKeyAddress(address _namePublicKeyAddress) public onlyTheAO {
851 		require (_namePublicKeyAddress != address(0));
852 		namePublicKeyAddress = _namePublicKeyAddress;
853 		_namePublicKey = INamePublicKey(namePublicKeyAddress);
854 	}
855 
856 	/**
857 	 * @dev The AO set the NameAccountRecovery Address
858 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
859 	 */
860 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
861 		require (_nameAccountRecoveryAddress != address(0));
862 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
863 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
864 	}
865 
866 	/**
867 	 * @dev Allows TheAO to transfer `_amount` of ETH from this address to `_recipient`
868 	 * @param _recipient The recipient address
869 	 * @param _amount The amount to transfer
870 	 */
871 	function transferEth(address payable _recipient, uint256 _amount) public onlyTheAO {
872 		require (_recipient != address(0));
873 		_recipient.transfer(_amount);
874 	}
875 
876 	/**
877 	 * @dev Prevent/Allow target from sending & receiving ions
878 	 * @param target Address to be frozen
879 	 * @param freeze Either to freeze it or not
880 	 */
881 	function freezeAccount(address target, bool freeze) public onlyTheAO {
882 		frozenAccount[target] = freeze;
883 		emit FrozenFunds(target, freeze);
884 	}
885 
886 	/**
887 	 * @dev Allow users to buy ions for `newBuyPrice` eth and sell ions for `newSellPrice` eth
888 	 * @param newSellPrice Price users can sell to the contract
889 	 * @param newBuyPrice Price users can buy from the contract
890 	 */
891 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyTheAO {
892 		sellPrice = newSellPrice;
893 		buyPrice = newBuyPrice;
894 	}
895 
896 	/***** NETWORK ION WHITELISTED ADDRESS ONLY METHODS *****/
897 	/**
898 	 * @dev Create `mintedAmount` ions and send it to `target`
899 	 * @param target Address to receive the ions
900 	 * @param mintedAmount The amount of ions it will receive
901 	 * @return true on success
902 	 */
903 	function mint(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
904 		_mint(target, mintedAmount);
905 		return true;
906 	}
907 
908 	/**
909 	 * @dev Stake `_value` ions on behalf of `_from`
910 	 * @param _from The address of the target
911 	 * @param _value The amount to stake
912 	 * @return true on success
913 	 */
914 	function stakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
915 		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
916 		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
917 		stakedBalance[_from] = stakedBalance[_from].add(_value);	// Add to the targeted staked balance
918 		emit Stake(_from, _value);
919 		return true;
920 	}
921 
922 	/**
923 	 * @dev Unstake `_value` ions on behalf of `_from`
924 	 * @param _from The address of the target
925 	 * @param _value The amount to unstake
926 	 * @return true on success
927 	 */
928 	function unstakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
929 		require (stakedBalance[_from] >= _value);					// Check if the targeted staked balance is enough
930 		stakedBalance[_from] = stakedBalance[_from].sub(_value);	// Subtract from the targeted staked balance
931 		balanceOf[_from] = balanceOf[_from].add(_value);			// Add to the targeted balance
932 		emit Unstake(_from, _value);
933 		return true;
934 	}
935 
936 	/**
937 	 * @dev Store `_value` from `_from` to `_to` in escrow
938 	 * @param _from The address of the sender
939 	 * @param _to The address of the recipient
940 	 * @param _value The amount of network ions to put in escrow
941 	 * @return true on success
942 	 */
943 	function escrowFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool) {
944 		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
945 		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
946 		escrowedBalance[_to] = escrowedBalance[_to].add(_value);	// Add to the targeted escrowed balance
947 		emit Escrow(_from, _to, _value);
948 		return true;
949 	}
950 
951 	/**
952 	 * @dev Create `mintedAmount` ions and send it to `target` escrow balance
953 	 * @param target Address to receive ions
954 	 * @param mintedAmount The amount of ions it will receive in escrow
955 	 */
956 	function mintEscrow(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
957 		escrowedBalance[target] = escrowedBalance[target].add(mintedAmount);
958 		totalSupply = totalSupply.add(mintedAmount);
959 		emit Escrow(address(this), target, mintedAmount);
960 		return true;
961 	}
962 
963 	/**
964 	 * @dev Release escrowed `_value` from `_from`
965 	 * @param _from The address of the sender
966 	 * @param _value The amount of escrowed network ions to be released
967 	 * @return true on success
968 	 */
969 	function unescrowFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
970 		require (escrowedBalance[_from] >= _value);						// Check if the targeted escrowed balance is enough
971 		escrowedBalance[_from] = escrowedBalance[_from].sub(_value);	// Subtract from the targeted escrowed balance
972 		balanceOf[_from] = balanceOf[_from].add(_value);				// Add to the targeted balance
973 		emit Unescrow(_from, _value);
974 		return true;
975 	}
976 
977 	/**
978 	 *
979 	 * @dev Whitelisted address remove `_value` ions from the system irreversibly on behalf of `_from`.
980 	 *
981 	 * @param _from the address of the sender
982 	 * @param _value the amount of money to burn
983 	 */
984 	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist returns (bool success) {
985 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
986 		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
987 		totalSupply = totalSupply.sub(_value);              // Update totalSupply
988 		emit Burn(_from, _value);
989 		return true;
990 	}
991 
992 	/**
993 	 * @dev Whitelisted address transfer ions from other address
994 	 *
995 	 * Send `_value` ions to `_to` on behalf of `_from`
996 	 *
997 	 * @param _from The address of the sender
998 	 * @param _to The address of the recipient
999 	 * @param _value the amount to send
1000 	 */
1001 	function whitelistTransferFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool success) {
1002 		_transfer(_from, _to, _value);
1003 		return true;
1004 	}
1005 
1006 	/***** PUBLIC METHODS *****/
1007 	/**
1008 	 * Transfer ions
1009 	 *
1010 	 * Send `_value` ions to `_to` from your account
1011 	 *
1012 	 * @param _to The address of the recipient
1013 	 * @param _value the amount to send
1014 	 */
1015 	function transfer(address _to, uint256 _value) public returns (bool success) {
1016 		_transfer(msg.sender, _to, _value);
1017 		return true;
1018 	}
1019 
1020 	/**
1021 	 * Transfer ions from other address
1022 	 *
1023 	 * Send `_value` ions to `_to` in behalf of `_from`
1024 	 *
1025 	 * @param _from The address of the sender
1026 	 * @param _to The address of the recipient
1027 	 * @param _value the amount to send
1028 	 */
1029 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
1030 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
1031 		allowance[_from][msg.sender] -= _value;
1032 		_transfer(_from, _to, _value);
1033 		return true;
1034 	}
1035 
1036 	/**
1037 	 * Transfer ions between public key addresses in a Name
1038 	 * @param _nameId The ID of the Name
1039 	 * @param _from The address of the sender
1040 	 * @param _to The address of the recipient
1041 	 * @param _value the amount to send
1042 	 */
1043 	function transferBetweenPublicKeys(address _nameId, address _from, address _to, uint256 _value) public returns (bool success) {
1044 		require (AOLibrary.isName(_nameId));
1045 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _nameId));
1046 		require (!_nameAccountRecovery.isCompromised(_nameId));
1047 		// Make sure _from exist in the Name's Public Keys
1048 		require (_namePublicKey.isKeyExist(_nameId, _from));
1049 		// Make sure _to exist in the Name's Public Keys
1050 		require (_namePublicKey.isKeyExist(_nameId, _to));
1051 		_transfer(_from, _to, _value);
1052 		return true;
1053 	}
1054 
1055 	/**
1056 	 * Set allowance for other address
1057 	 *
1058 	 * Allows `_spender` to spend no more than `_value` ions in your behalf
1059 	 *
1060 	 * @param _spender The address authorized to spend
1061 	 * @param _value the max amount they can spend
1062 	 */
1063 	function approve(address _spender, uint256 _value) public returns (bool success) {
1064 		allowance[msg.sender][_spender] = _value;
1065 		emit Approval(msg.sender, _spender, _value);
1066 		return true;
1067 	}
1068 
1069 	/**
1070 	 * Set allowance for other address and notify
1071 	 *
1072 	 * Allows `_spender` to spend no more than `_value` ions in your behalf, and then ping the contract about it
1073 	 *
1074 	 * @param _spender The address authorized to spend
1075 	 * @param _value the max amount they can spend
1076 	 * @param _extraData some extra information to send to the approved contract
1077 	 */
1078 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
1079 		ionRecipient spender = ionRecipient(_spender);
1080 		if (approve(_spender, _value)) {
1081 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
1082 			return true;
1083 		}
1084 	}
1085 
1086 	/**
1087 	 * Destroy ions
1088 	 *
1089 	 * Remove `_value` ions from the system irreversibly
1090 	 *
1091 	 * @param _value the amount of money to burn
1092 	 */
1093 	function burn(uint256 _value) public returns (bool success) {
1094 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
1095 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
1096 		totalSupply -= _value;                      // Updates totalSupply
1097 		emit Burn(msg.sender, _value);
1098 		return true;
1099 	}
1100 
1101 	/**
1102 	 * Destroy ions from other account
1103 	 *
1104 	 * Remove `_value` ions from the system irreversibly on behalf of `_from`.
1105 	 *
1106 	 * @param _from the address of the sender
1107 	 * @param _value the amount of money to burn
1108 	 */
1109 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
1110 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
1111 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
1112 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
1113 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
1114 		totalSupply -= _value;                              // Update totalSupply
1115 		emit Burn(_from, _value);
1116 		return true;
1117 	}
1118 
1119 	/**
1120 	 * @dev Buy ions from contract by sending ether
1121 	 */
1122 	function buy() public payable {
1123 		require (buyPrice > 0);
1124 		uint256 amount = msg.value.div(buyPrice);
1125 		_transfer(address(this), msg.sender, amount);
1126 	}
1127 
1128 	/**
1129 	 * @dev Sell `amount` ions to contract
1130 	 * @param amount The amount of ions to be sold
1131 	 */
1132 	function sell(uint256 amount) public {
1133 		require (sellPrice > 0);
1134 		address myAddress = address(this);
1135 		require (myAddress.balance >= amount.mul(sellPrice));
1136 		_transfer(msg.sender, address(this), amount);
1137 		msg.sender.transfer(amount.mul(sellPrice));
1138 	}
1139 
1140 	/***** INTERNAL METHODS *****/
1141 	/**
1142 	 * @dev Send `_value` ions from `_from` to `_to`
1143 	 * @param _from The address of sender
1144 	 * @param _to The address of the recipient
1145 	 * @param _value The amount to send
1146 	 */
1147 	function _transfer(address _from, address _to, uint256 _value) internal {
1148 		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
1149 		require (balanceOf[_from] >= _value);					// Check if the sender has enough
1150 		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
1151 		require (!frozenAccount[_from]);						// Check if sender is frozen
1152 		require (!frozenAccount[_to]);							// Check if recipient is frozen
1153 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
1154 		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
1155 		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
1156 		emit Transfer(_from, _to, _value);
1157 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
1158 	}
1159 
1160 	/**
1161 	 * @dev Create `mintedAmount` ions and send it to `target`
1162 	 * @param target Address to receive the ions
1163 	 * @param mintedAmount The amount of ions it will receive
1164 	 */
1165 	function _mint(address target, uint256 mintedAmount) internal {
1166 		balanceOf[target] = balanceOf[target].add(mintedAmount);
1167 		totalSupply = totalSupply.add(mintedAmount);
1168 		emit Transfer(address(0), address(this), mintedAmount);
1169 		emit Transfer(address(this), target, mintedAmount);
1170 	}
1171 }
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
1184 
1185 /**
1186  * @title AOETH
1187  */
1188 contract AOETH is TheAO, TokenERC20, tokenRecipient {
1189 	using SafeMath for uint256;
1190 
1191 	address public aoIonAddress;
1192 
1193 	AOIon internal _aoIon;
1194 
1195 	uint256 public totalERC20Tokens;
1196 	uint256 public totalTokenExchanges;
1197 
1198 	struct ERC20Token {
1199 		address tokenAddress;
1200 		uint256 price;			// price of this ERC20 Token to AOETH
1201 		uint256 maxQuantity;	// To prevent too much exposure to a given asset
1202 		uint256 exchangedQuantity;	// Running total (total AOETH exchanged from this specific ERC20 Token)
1203 		bool active;
1204 	}
1205 
1206 	struct TokenExchange {
1207 		bytes32 exchangeId;
1208 		address buyer;			// The buyer address
1209 		address tokenAddress;	// The address of ERC20 Token
1210 		uint256 price;			// price of ERC20 Token to AOETH
1211 		uint256 sentAmount;		// Amount of ERC20 Token sent
1212 		uint256 receivedAmount;	// Amount of AOETH received
1213 		bytes extraData; // Extra data
1214 	}
1215 
1216 	// Mapping from id to ERC20Token object
1217 	mapping (uint256 => ERC20Token) internal erc20Tokens;
1218 	mapping (address => uint256) internal erc20TokenIdLookup;
1219 
1220 	// Mapping from id to TokenExchange object
1221 	mapping (uint256 => TokenExchange) internal tokenExchanges;
1222 	mapping (bytes32 => uint256) internal tokenExchangeIdLookup;
1223 	mapping (address => uint256) public totalAddressTokenExchanges;
1224 
1225 	// Event to be broadcasted to public when TheAO adds an ERC20 Token
1226 	event AddERC20Token(address indexed tokenAddress, uint256 price, uint256 maxQuantity);
1227 
1228 	// Event to be broadcasted to public when TheAO sets price for ERC20 Token
1229 	event SetPrice(address indexed tokenAddress, uint256 price);
1230 
1231 	// Event to be broadcasted to public when TheAO sets max quantity for ERC20 Token
1232 	event SetMaxQuantity(address indexed tokenAddress, uint256 maxQuantity);
1233 
1234 	// Event to be broadcasted to public when TheAO sets active status for ERC20 Token
1235 	event SetActive(address indexed tokenAddress, bool active);
1236 
1237 	// Event to be broadcasted to public when user exchanges ERC20 Token for AOETH
1238 	event ExchangeToken(bytes32 indexed exchangeId, address indexed from, address tokenAddress, string tokenName, string tokenSymbol, uint256 sentTokenAmount, uint256 receivedAOETHAmount, bytes extraData);
1239 
1240 	/**
1241 	 * @dev Constructor function
1242 	 */
1243 	constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol, address _aoIonAddress, address _nameTAOPositionAddress)
1244 		TokenERC20(initialSupply, tokenName, tokenSymbol) public {
1245 		setAOIonAddress(_aoIonAddress);
1246 		setNameTAOPositionAddress(_nameTAOPositionAddress);
1247 	}
1248 
1249 	/**
1250 	 * @dev Checks if the calling contract address is The AO
1251 	 *		OR
1252 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
1253 	 */
1254 	modifier onlyTheAO {
1255 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
1256 		_;
1257 	}
1258 
1259 	/***** The AO ONLY METHODS *****/
1260 	/**
1261 	 * @dev Transfer ownership of The AO to new address
1262 	 * @param _theAO The new address to be transferred
1263 	 */
1264 	function transferOwnership(address _theAO) public onlyTheAO {
1265 		require (_theAO != address(0));
1266 		theAO = _theAO;
1267 	}
1268 
1269 	/**
1270 	 * @dev Whitelist `_account` address to transact on behalf of others
1271 	 * @param _account The address to whitelist
1272 	 * @param _whitelist Either to whitelist or not
1273 	 */
1274 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
1275 		require (_account != address(0));
1276 		whitelist[_account] = _whitelist;
1277 	}
1278 
1279 	/**
1280 	 * @dev The AO set the AOIon Address
1281 	 * @param _aoIonAddress The address of AOIon
1282 	 */
1283 	function setAOIonAddress(address _aoIonAddress) public onlyTheAO {
1284 		require (_aoIonAddress != address(0));
1285 		aoIonAddress = _aoIonAddress;
1286 		_aoIon = AOIon(_aoIonAddress);
1287 	}
1288 
1289 	/**
1290 	 * @dev The AO set the NameTAOPosition Address
1291 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
1292 	 */
1293 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
1294 		require (_nameTAOPositionAddress != address(0));
1295 		nameTAOPositionAddress = _nameTAOPositionAddress;
1296 	}
1297 
1298 	/**
1299 	 * @dev Allows TheAO to transfer `_amount` of ERC20 Token from this address to `_recipient`
1300 	 * @param _erc20TokenAddress The address of ERC20 Token
1301 	 * @param _recipient The recipient address
1302 	 * @param _amount The amount to transfer
1303 	 */
1304 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyTheAO {
1305 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
1306 		require (_erc20.transfer(_recipient, _amount));
1307 	}
1308 
1309 	/**
1310 	 * @dev Add an ERC20 Token to the list
1311 	 * @param _tokenAddress The address of the ERC20 Token
1312 	 * @param _price The price of this token to AOETH
1313 	 * @param _maxQuantity Maximum quantity allowed for exchange
1314 	 */
1315 	function addERC20Token(address _tokenAddress, uint256 _price, uint256 _maxQuantity) public onlyTheAO {
1316 		require (_tokenAddress != address(0) && _price > 0 && _maxQuantity > 0);
1317 		require (AOLibrary.isValidERC20TokenAddress(_tokenAddress));
1318 		require (erc20TokenIdLookup[_tokenAddress] == 0);
1319 
1320 		totalERC20Tokens++;
1321 		erc20TokenIdLookup[_tokenAddress] = totalERC20Tokens;
1322 		ERC20Token storage _erc20Token = erc20Tokens[totalERC20Tokens];
1323 		_erc20Token.tokenAddress = _tokenAddress;
1324 		_erc20Token.price = _price;
1325 		_erc20Token.maxQuantity = _maxQuantity;
1326 		_erc20Token.active = true;
1327 		emit AddERC20Token(_erc20Token.tokenAddress, _erc20Token.price, _erc20Token.maxQuantity);
1328 	}
1329 
1330 	/**
1331 	 * @dev Set price for existing ERC20 Token
1332 	 * @param _tokenAddress The address of the ERC20 Token
1333 	 * @param _price The price of this token to AOETH
1334 	 */
1335 	function setPrice(address _tokenAddress, uint256 _price) public onlyTheAO {
1336 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1337 		require (_price > 0);
1338 
1339 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
1340 		_erc20Token.price = _price;
1341 		emit SetPrice(_erc20Token.tokenAddress, _erc20Token.price);
1342 	}
1343 
1344 	/**
1345 	 * @dev Set max quantity for existing ERC20 Token
1346 	 * @param _tokenAddress The address of the ERC20 Token
1347 	 * @param _maxQuantity The max exchange quantity for this token
1348 	 */
1349 	function setMaxQuantity(address _tokenAddress, uint256 _maxQuantity) public onlyTheAO {
1350 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1351 
1352 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
1353 		require (_maxQuantity > _erc20Token.exchangedQuantity);
1354 		_erc20Token.maxQuantity = _maxQuantity;
1355 		emit SetMaxQuantity(_erc20Token.tokenAddress, _erc20Token.maxQuantity);
1356 	}
1357 
1358 	/**
1359 	 * @dev Set active status for existing ERC20 Token
1360 	 * @param _tokenAddress The address of the ERC20 Token
1361 	 * @param _active The active status for this token
1362 	 */
1363 	function setActive(address _tokenAddress, bool _active) public onlyTheAO {
1364 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1365 
1366 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
1367 		_erc20Token.active = _active;
1368 		emit SetActive(_erc20Token.tokenAddress, _erc20Token.active);
1369 	}
1370 
1371 	/**
1372 	 * @dev Whitelisted address transfer tokens from other address
1373 	 *
1374 	 * Send `_value` tokens to `_to` on behalf of `_from`
1375 	 *
1376 	 * @param _from The address of the sender
1377 	 * @param _to The address of the recipient
1378 	 * @param _value the amount to send
1379 	 */
1380 	function whitelistTransferFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool success) {
1381 		_transfer(_from, _to, _value);
1382 		return true;
1383 	}
1384 
1385 	/***** PUBLIC METHODS *****/
1386 	/**
1387 	 * @dev Get an ERC20 Token information given an ID
1388 	 * @param _id The internal ID of the ERC20 Token
1389 	 * @return The ERC20 Token address
1390 	 * @return The name of the token
1391 	 * @return The symbol of the token
1392 	 * @return The price of this token to AOETH
1393 	 * @return The max quantity for exchange
1394 	 * @return The total AOETH exchanged from this token
1395 	 * @return The status of this token
1396 	 */
1397 	function getById(uint256 _id) public view returns (address, string memory, string memory, uint256, uint256, uint256, bool) {
1398 		require (erc20Tokens[_id].tokenAddress != address(0));
1399 		ERC20Token memory _erc20Token = erc20Tokens[_id];
1400 		return (
1401 			_erc20Token.tokenAddress,
1402 			TokenERC20(_erc20Token.tokenAddress).name(),
1403 			TokenERC20(_erc20Token.tokenAddress).symbol(),
1404 			_erc20Token.price,
1405 			_erc20Token.maxQuantity,
1406 			_erc20Token.exchangedQuantity,
1407 			_erc20Token.active
1408 		);
1409 	}
1410 
1411 	/**
1412 	 * @dev Get an ERC20 Token information given an address
1413 	 * @param _tokenAddress The address of the ERC20 Token
1414 	 * @return The ERC20 Token address
1415 	 * @return The name of the token
1416 	 * @return The symbol of the token
1417 	 * @return The price of this token to AOETH
1418 	 * @return The max quantity for exchange
1419 	 * @return The total AOETH exchanged from this token
1420 	 * @return The status of this token
1421 	 */
1422 	function getByAddress(address _tokenAddress) public view returns (address, string memory, string memory, uint256, uint256, uint256, bool) {
1423 		require (erc20TokenIdLookup[_tokenAddress] > 0);
1424 		return getById(erc20TokenIdLookup[_tokenAddress]);
1425 	}
1426 
1427 	/**
1428 	 * @dev When a user approves AOETH to spend on his/her behalf (i.e exchange to AOETH)
1429 	 * @param _from The user address that approved AOETH
1430 	 * @param _value The amount that the user approved
1431 	 * @param _token The address of the ERC20 Token
1432 	 * @param _extraData The extra data sent during the approval
1433 	 */
1434 	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external {
1435 		require (_from != address(0));
1436 		require (AOLibrary.isValidERC20TokenAddress(_token));
1437 
1438 		// Check if the token is supported
1439 		require (erc20TokenIdLookup[_token] > 0);
1440 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_token]];
1441 		require (_erc20Token.active && _erc20Token.price > 0 && _erc20Token.exchangedQuantity < _erc20Token.maxQuantity);
1442 
1443 		uint256 amountToTransfer = _value.div(_erc20Token.price);
1444 		require (_erc20Token.maxQuantity.sub(_erc20Token.exchangedQuantity) >= amountToTransfer);
1445 		require (_aoIon.availableETH() >= amountToTransfer);
1446 
1447 		// Transfer the ERC20 Token from the `_from` address to here
1448 		require (TokenERC20(_token).transferFrom(_from, address(this), _value));
1449 
1450 		_erc20Token.exchangedQuantity = _erc20Token.exchangedQuantity.add(amountToTransfer);
1451 		balanceOf[_from] = balanceOf[_from].add(amountToTransfer);
1452 		totalSupply = totalSupply.add(amountToTransfer);
1453 
1454 		// Store the TokenExchange information
1455 		totalTokenExchanges++;
1456 		totalAddressTokenExchanges[_from]++;
1457 		bytes32 _exchangeId = keccak256(abi.encodePacked(this, _from, totalTokenExchanges));
1458 		tokenExchangeIdLookup[_exchangeId] = totalTokenExchanges;
1459 
1460 		TokenExchange storage _tokenExchange = tokenExchanges[totalTokenExchanges];
1461 		_tokenExchange.exchangeId = _exchangeId;
1462 		_tokenExchange.buyer = _from;
1463 		_tokenExchange.tokenAddress = _token;
1464 		_tokenExchange.price = _erc20Token.price;
1465 		_tokenExchange.sentAmount = _value;
1466 		_tokenExchange.receivedAmount = amountToTransfer;
1467 		_tokenExchange.extraData = _extraData;
1468 
1469 		emit ExchangeToken(_tokenExchange.exchangeId, _tokenExchange.buyer, _tokenExchange.tokenAddress, TokenERC20(_token).name(), TokenERC20(_token).symbol(), _tokenExchange.sentAmount, _tokenExchange.receivedAmount, _tokenExchange.extraData);
1470 	}
1471 
1472 	/**
1473 	 * @dev Get TokenExchange information given an exchange ID
1474 	 * @param _exchangeId The exchange ID to query
1475 	 * @return The buyer address
1476 	 * @return The sent ERC20 Token address
1477 	 * @return The ERC20 Token name
1478 	 * @return The ERC20 Token symbol
1479 	 * @return The price of ERC20 Token to AOETH
1480 	 * @return The amount of ERC20 Token sent
1481 	 * @return The amount of AOETH received
1482 	 * @return Extra data during the transaction
1483 	 */
1484 	function getTokenExchangeById(bytes32 _exchangeId) public view returns (address, address, string memory, string memory, uint256, uint256,  uint256, bytes memory) {
1485 		require (tokenExchangeIdLookup[_exchangeId] > 0);
1486 		TokenExchange memory _tokenExchange = tokenExchanges[tokenExchangeIdLookup[_exchangeId]];
1487 		return (
1488 			_tokenExchange.buyer,
1489 			_tokenExchange.tokenAddress,
1490 			TokenERC20(_tokenExchange.tokenAddress).name(),
1491 			TokenERC20(_tokenExchange.tokenAddress).symbol(),
1492 			_tokenExchange.price,
1493 			_tokenExchange.sentAmount,
1494 			_tokenExchange.receivedAmount,
1495 			_tokenExchange.extraData
1496 		);
1497 	}
1498 }
1499 
1500 
1501 /**
1502  * @title AOIon
1503  */
1504 contract AOIon is AOIonInterface {
1505 	using SafeMath for uint256;
1506 
1507 	address public aoIonLotAddress;
1508 	address public settingTAOId;
1509 	address public aoSettingAddress;
1510 	address public aoethAddress;
1511 
1512 	// AO Dev Team addresses to receive Primordial/Network Ions
1513 	address public aoDevTeam1 = 0x146CbD9821e6A42c8ff6DC903fe91CB69625A105;
1514 	address public aoDevTeam2 = 0x4810aF1dA3aC827259eEa72ef845F4206C703E8D;
1515 
1516 	IAOIonLot internal _aoIonLot;
1517 	IAOSetting internal _aoSetting;
1518 	AOETH internal _aoeth;
1519 
1520 	/***** PRIMORDIAL ION VARIABLES *****/
1521 	uint256 public primordialTotalSupply;
1522 	uint256 public primordialTotalBought;
1523 	uint256 public primordialSellPrice;
1524 	uint256 public primordialBuyPrice;
1525 	uint256 public totalEthForPrimordial;	// Total ETH sent for Primordial AO+
1526 	uint256 public totalRedeemedAOETH;		// Total AOETH redeemed for Primordial AO+
1527 
1528 	// Total available primordial ion for sale 3,377,699,720,527,872 AO+
1529 	uint256 constant public TOTAL_PRIMORDIAL_FOR_SALE = 3377699720527872;
1530 
1531 	mapping (address => uint256) public primordialBalanceOf;
1532 	mapping (address => mapping (address => uint256)) public primordialAllowance;
1533 
1534 	// Mapping from owner's lot weighted multiplier to the amount of staked ions
1535 	mapping (address => mapping (uint256 => uint256)) public primordialStakedBalance;
1536 
1537 	event PrimordialTransfer(address indexed from, address indexed to, uint256 value);
1538 	event PrimordialApproval(address indexed _owner, address indexed _spender, uint256 _value);
1539 	event PrimordialBurn(address indexed from, uint256 value);
1540 	event PrimordialStake(address indexed from, uint256 value, uint256 weightedMultiplier);
1541 	event PrimordialUnstake(address indexed from, uint256 value, uint256 weightedMultiplier);
1542 
1543 	event NetworkExchangeEnded();
1544 
1545 	bool public networkExchangeEnded;
1546 
1547 	// Mapping from owner to his/her current weighted multiplier
1548 	mapping (address => uint256) internal ownerWeightedMultiplier;
1549 
1550 	// Mapping from owner to his/her max multiplier (multiplier of account's first Lot)
1551 	mapping (address => uint256) internal ownerMaxMultiplier;
1552 
1553 	// Event to be broadcasted to public when user buys primordial ion
1554 	// payWith 1 == with Ethereum
1555 	// payWith 2 == with AOETH
1556 	event BuyPrimordial(address indexed lotOwner, bytes32 indexed lotId, uint8 payWith, uint256 sentAmount, uint256 refundedAmount);
1557 
1558 	/**
1559 	 * @dev Constructor function
1560 	 */
1561 	constructor(string memory _name, string memory _symbol, address _settingTAOId, address _aoSettingAddress, address _nameTAOPositionAddress, address _namePublicKeyAddress, address _nameAccountRecoveryAddress)
1562 		AOIonInterface(_name, _symbol, _nameTAOPositionAddress, _namePublicKeyAddress, _nameAccountRecoveryAddress) public {
1563 		setSettingTAOId(_settingTAOId);
1564 		setAOSettingAddress(_aoSettingAddress);
1565 
1566 		powerOfTen = 0;
1567 		decimals = 0;
1568 		setPrimordialPrices(0, 10 ** 8); // Set Primordial buy price to 0.1 gwei/ion
1569 	}
1570 
1571 	/**
1572 	 * @dev Checks if buyer can buy primordial ion
1573 	 */
1574 	modifier canBuyPrimordial(uint256 _sentAmount, bool _withETH) {
1575 		require (networkExchangeEnded == false &&
1576 			primordialTotalBought < TOTAL_PRIMORDIAL_FOR_SALE &&
1577 			primordialBuyPrice > 0 &&
1578 			_sentAmount > 0 &&
1579 			availablePrimordialForSaleInETH() > 0 &&
1580 			(
1581 				(_withETH && availableETH() > 0) ||
1582 				(!_withETH && totalRedeemedAOETH < _aoeth.totalSupply())
1583 			)
1584 		);
1585 		_;
1586 	}
1587 
1588 	/***** The AO ONLY METHODS *****/
1589 	/**
1590 	 * @dev The AO sets AOIonLot address
1591 	 * @param _aoIonLotAddress The address of AOIonLot
1592 	 */
1593 	function setAOIonLotAddress(address _aoIonLotAddress) public onlyTheAO {
1594 		require (_aoIonLotAddress != address(0));
1595 		aoIonLotAddress = _aoIonLotAddress;
1596 		_aoIonLot = IAOIonLot(_aoIonLotAddress);
1597 	}
1598 
1599 	/**
1600 	 * @dev The AO sets setting TAO ID
1601 	 * @param _settingTAOId The new setting TAO ID to set
1602 	 */
1603 	function setSettingTAOId(address _settingTAOId) public onlyTheAO {
1604 		require (AOLibrary.isTAO(_settingTAOId));
1605 		settingTAOId = _settingTAOId;
1606 	}
1607 
1608 	/**
1609 	 * @dev The AO sets AO Setting address
1610 	 * @param _aoSettingAddress The address of AOSetting
1611 	 */
1612 	function setAOSettingAddress(address _aoSettingAddress) public onlyTheAO {
1613 		require (_aoSettingAddress != address(0));
1614 		aoSettingAddress = _aoSettingAddress;
1615 		_aoSetting = IAOSetting(_aoSettingAddress);
1616 	}
1617 
1618 	/**
1619 	 * @dev Set AO Dev team addresses to receive Primordial/Network ions during network exchange
1620 	 * @param _aoDevTeam1 The first AO dev team address
1621 	 * @param _aoDevTeam2 The second AO dev team address
1622 	 */
1623 	function setAODevTeamAddresses(address _aoDevTeam1, address _aoDevTeam2) public onlyTheAO {
1624 		aoDevTeam1 = _aoDevTeam1;
1625 		aoDevTeam2 = _aoDevTeam2;
1626 	}
1627 
1628 	/**
1629 	 * @dev Set AOETH address
1630 	 * @param _aoethAddress The address of AOETH
1631 	 */
1632 	function setAOETHAddress(address _aoethAddress) public onlyTheAO {
1633 		require (_aoethAddress != address(0));
1634 		aoethAddress = _aoethAddress;
1635 		_aoeth = AOETH(_aoethAddress);
1636 	}
1637 
1638 	/***** PRIMORDIAL ION THE AO ONLY METHODS *****/
1639 	/**
1640 	 * @dev Allow users to buy Primordial ions for `newBuyPrice` eth and sell Primordial ions for `newSellPrice` eth
1641 	 * @param newPrimordialSellPrice Price users can sell to the contract
1642 	 * @param newPrimordialBuyPrice Price users can buy from the contract
1643 	 */
1644 	function setPrimordialPrices(uint256 newPrimordialSellPrice, uint256 newPrimordialBuyPrice) public onlyTheAO {
1645 		primordialSellPrice = newPrimordialSellPrice;
1646 		primordialBuyPrice = newPrimordialBuyPrice;
1647 	}
1648 
1649 	/**
1650 	 * @dev Only the AO can force end network exchange
1651 	 */
1652 	function endNetworkExchange() public onlyTheAO {
1653 		require (!networkExchangeEnded);
1654 		networkExchangeEnded = true;
1655 		emit NetworkExchangeEnded();
1656 	}
1657 
1658 	/***** PRIMORDIAL ION WHITELISTED ADDRESS ONLY METHODS *****/
1659 	/**
1660 	 * @dev Stake `_value` Primordial ions at `_weightedMultiplier ` multiplier on behalf of `_from`
1661 	 * @param _from The address of the target
1662 	 * @param _value The amount of Primordial ions to stake
1663 	 * @param _weightedMultiplier The weighted multiplier of the Primordial ions
1664 	 * @return true on success
1665 	 */
1666 	function stakePrimordialFrom(address _from, uint256 _value, uint256 _weightedMultiplier) public inWhitelist returns (bool) {
1667 		// Check if the targeted balance is enough
1668 		require (primordialBalanceOf[_from] >= _value);
1669 		// Make sure the weighted multiplier is the same as account's current weighted multiplier
1670 		require (_weightedMultiplier == ownerWeightedMultiplier[_from]);
1671 		// Subtract from the targeted balance
1672 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);
1673 		// Add to the targeted staked balance
1674 		primordialStakedBalance[_from][_weightedMultiplier] = primordialStakedBalance[_from][_weightedMultiplier].add(_value);
1675 		emit PrimordialStake(_from, _value, _weightedMultiplier);
1676 		return true;
1677 	}
1678 
1679 	/**
1680 	 * @dev Unstake `_value` Primordial ions at `_weightedMultiplier` on behalf of `_from`
1681 	 * @param _from The address of the target
1682 	 * @param _value The amount to unstake
1683 	 * @param _weightedMultiplier The weighted multiplier of the Primordial ions
1684 	 * @return true on success
1685 	 */
1686 	function unstakePrimordialFrom(address _from, uint256 _value, uint256 _weightedMultiplier) public inWhitelist returns (bool) {
1687 		// Check if the targeted staked balance is enough
1688 		require (primordialStakedBalance[_from][_weightedMultiplier] >= _value);
1689 		// Subtract from the targeted staked balance
1690 		primordialStakedBalance[_from][_weightedMultiplier] = primordialStakedBalance[_from][_weightedMultiplier].sub(_value);
1691 		// Add to the targeted balance
1692 		primordialBalanceOf[_from] = primordialBalanceOf[_from].add(_value);
1693 		emit PrimordialUnstake(_from, _value, _weightedMultiplier);
1694 		return true;
1695 	}
1696 
1697 	/**
1698 	 * @dev Send `_value` primordial ions to `_to` on behalf of `_from`
1699 	 * @param _from The address of the sender
1700 	 * @param _to The address of the recipient
1701 	 * @param _value The amount to send
1702 	 * @return true on success
1703 	 */
1704 	function whitelistTransferPrimordialFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool) {
1705 		return _createLotAndTransferPrimordial(_from, _to, _value);
1706 	}
1707 
1708 	/***** PUBLIC METHODS *****/
1709 	/***** PRIMORDIAL ION PUBLIC METHODS *****/
1710 	/**
1711 	 * @dev Buy Primordial ions from contract by sending ether
1712 	 */
1713 	function buyPrimordial() public payable canBuyPrimordial(msg.value, true) {
1714 		(uint256 amount, uint256 remainderBudget, bool shouldEndNetworkExchange) = _calculateAmountAndRemainderBudget(msg.value, true);
1715 		require (amount > 0);
1716 
1717 		// Ends network exchange if necessary
1718 		if (shouldEndNetworkExchange) {
1719 			networkExchangeEnded = true;
1720 			emit NetworkExchangeEnded();
1721 		}
1722 
1723 		// Update totalEthForPrimordial
1724 		totalEthForPrimordial = totalEthForPrimordial.add(msg.value.sub(remainderBudget));
1725 
1726 		// Send the primordial ion to buyer and reward AO devs
1727 		bytes32 _lotId = _sendPrimordialAndRewardDev(amount, msg.sender);
1728 
1729 		emit BuyPrimordial(msg.sender, _lotId, 1, msg.value, remainderBudget);
1730 
1731 		// Send remainder budget back to buyer if exist
1732 		if (remainderBudget > 0) {
1733 			msg.sender.transfer(remainderBudget);
1734 		}
1735 	}
1736 
1737 	/**
1738 	 * @dev Buy Primordial ion from contract by sending AOETH
1739 	 */
1740 	function buyPrimordialWithAOETH(uint256 _aoethAmount) public canBuyPrimordial(_aoethAmount, false) {
1741 		(uint256 amount, uint256 remainderBudget, bool shouldEndNetworkExchange) = _calculateAmountAndRemainderBudget(_aoethAmount, false);
1742 		require (amount > 0);
1743 
1744 		// Ends network exchange if necessary
1745 		if (shouldEndNetworkExchange) {
1746 			networkExchangeEnded = true;
1747 			emit NetworkExchangeEnded();
1748 		}
1749 
1750 		// Calculate the actual AOETH that was charged for this transaction
1751 		uint256 actualCharge = _aoethAmount.sub(remainderBudget);
1752 
1753 		// Update totalRedeemedAOETH
1754 		totalRedeemedAOETH = totalRedeemedAOETH.add(actualCharge);
1755 
1756 		// Transfer AOETH from buyer to here
1757 		require (_aoeth.whitelistTransferFrom(msg.sender, address(this), actualCharge));
1758 
1759 		// Send the primordial ion to buyer and reward AO devs
1760 		bytes32 _lotId = _sendPrimordialAndRewardDev(amount, msg.sender);
1761 
1762 		emit BuyPrimordial(msg.sender, _lotId, 2, _aoethAmount, remainderBudget);
1763 	}
1764 
1765 	/**
1766 	 * @dev Send `_value` Primordial ions to `_to` from your account
1767 	 * @param _to The address of the recipient
1768 	 * @param _value The amount to send
1769 	 * @return true on success
1770 	 */
1771 	function transferPrimordial(address _to, uint256 _value) public returns (bool) {
1772 		return _createLotAndTransferPrimordial(msg.sender, _to, _value);
1773 	}
1774 
1775 	/**
1776 	 * @dev Send `_value` Primordial ions to `_to` from `_from`
1777 	 * @param _from The address of the sender
1778 	 * @param _to The address of the recipient
1779 	 * @param _value The amount to send
1780 	 * @return true on success
1781 	 */
1782 	function transferPrimordialFrom(address _from, address _to, uint256 _value) public returns (bool) {
1783 		require (_value <= primordialAllowance[_from][msg.sender]);
1784 		primordialAllowance[_from][msg.sender] = primordialAllowance[_from][msg.sender].sub(_value);
1785 
1786 		return _createLotAndTransferPrimordial(_from, _to, _value);
1787 	}
1788 
1789 	/**
1790 	 * Transfer primordial ions between public key addresses in a Name
1791 	 * @param _nameId The ID of the Name
1792 	 * @param _from The address of the sender
1793 	 * @param _to The address of the recipient
1794 	 * @param _value the amount to send
1795 	 */
1796 	function transferPrimordialBetweenPublicKeys(address _nameId, address _from, address _to, uint256 _value) public returns (bool) {
1797 		require (AOLibrary.isName(_nameId));
1798 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _nameId));
1799 		require (!_nameAccountRecovery.isCompromised(_nameId));
1800 		// Make sure _from exist in the Name's Public Keys
1801 		require (_namePublicKey.isKeyExist(_nameId, _from));
1802 		// Make sure _to exist in the Name's Public Keys
1803 		require (_namePublicKey.isKeyExist(_nameId, _to));
1804 		return _createLotAndTransferPrimordial(_from, _to, _value);
1805 	}
1806 
1807 	/**
1808 	 * @dev Allows `_spender` to spend no more than `_value` Primordial ions in your behalf
1809 	 * @param _spender The address authorized to spend
1810 	 * @param _value The max amount they can spend
1811 	 * @return true on success
1812 	 */
1813 	function approvePrimordial(address _spender, uint256 _value) public returns (bool) {
1814 		primordialAllowance[msg.sender][_spender] = _value;
1815 		emit PrimordialApproval(msg.sender, _spender, _value);
1816 		return true;
1817 	}
1818 
1819 	/**
1820 	 * @dev Allows `_spender` to spend no more than `_value` Primordial ions in your behalf, and then ping the contract about it
1821 	 * @param _spender The address authorized to spend
1822 	 * @param _value The max amount they can spend
1823 	 * @param _extraData some extra information to send to the approved contract
1824 	 * @return true on success
1825 	 */
1826 	function approvePrimordialAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool) {
1827 		tokenRecipient spender = tokenRecipient(_spender);
1828 		if (approvePrimordial(_spender, _value)) {
1829 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
1830 			return true;
1831 		}
1832 	}
1833 
1834 	/**
1835 	 * @dev Remove `_value` Primordial ions from the system irreversibly
1836 	 *		and re-weight the account's multiplier after burn
1837 	 * @param _value The amount to burn
1838 	 * @return true on success
1839 	 */
1840 	function burnPrimordial(uint256 _value) public returns (bool) {
1841 		require (primordialBalanceOf[msg.sender] >= _value);
1842 		require (calculateMaximumBurnAmount(msg.sender) >= _value);
1843 
1844 		// Update the account's multiplier
1845 		ownerWeightedMultiplier[msg.sender] = calculateMultiplierAfterBurn(msg.sender, _value);
1846 		primordialBalanceOf[msg.sender] = primordialBalanceOf[msg.sender].sub(_value);
1847 		primordialTotalSupply = primordialTotalSupply.sub(_value);
1848 
1849 		// Store burn lot info
1850 		require (_aoIonLot.createBurnLot(msg.sender, _value, ownerWeightedMultiplier[msg.sender]));
1851 		emit PrimordialBurn(msg.sender, _value);
1852 		return true;
1853 	}
1854 
1855 	/**
1856 	 * @dev Remove `_value` Primordial ions from the system irreversibly on behalf of `_from`
1857 	 *		and re-weight `_from`'s multiplier after burn
1858 	 * @param _from The address of sender
1859 	 * @param _value The amount to burn
1860 	 * @return true on success
1861 	 */
1862 	function burnPrimordialFrom(address _from, uint256 _value) public returns (bool) {
1863 		require (primordialBalanceOf[_from] >= _value);
1864 		require (primordialAllowance[_from][msg.sender] >= _value);
1865 		require (calculateMaximumBurnAmount(_from) >= _value);
1866 
1867 		// Update `_from`'s multiplier
1868 		ownerWeightedMultiplier[_from] = calculateMultiplierAfterBurn(_from, _value);
1869 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);
1870 		primordialAllowance[_from][msg.sender] = primordialAllowance[_from][msg.sender].sub(_value);
1871 		primordialTotalSupply = primordialTotalSupply.sub(_value);
1872 
1873 		// Store burn lot info
1874 		require (_aoIonLot.createBurnLot(_from, _value, ownerWeightedMultiplier[_from]));
1875 		emit PrimordialBurn(_from, _value);
1876 		return true;
1877 	}
1878 
1879 	/**
1880 	 * @dev Return the average weighted multiplier of all lots owned by an address
1881 	 * @param _lotOwner The address of the lot owner
1882 	 * @return the weighted multiplier of the address (in 10 ** 6)
1883 	 */
1884 	function weightedMultiplierByAddress(address _lotOwner) public view returns (uint256) {
1885 		return ownerWeightedMultiplier[_lotOwner];
1886 	}
1887 
1888 	/**
1889 	 * @dev Return the max multiplier of an address
1890 	 * @param _target The address to query
1891 	 * @return the max multiplier of the address (in 10 ** 6)
1892 	 */
1893 	function maxMultiplierByAddress(address _target) public view returns (uint256) {
1894 		return (_aoIonLot.totalLotsByAddress(_target) > 0) ? ownerMaxMultiplier[_target] : 0;
1895 	}
1896 
1897 	/**
1898 	 * @dev Calculate the primordial ion multiplier, bonus network ion percentage, and the
1899 	 *		bonus network ion amount on a given lot when someone purchases primordial ion
1900 	 *		during network exchange
1901 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
1902 	 * @return The multiplier in (10 ** 6)
1903 	 * @return The bonus percentage
1904 	 * @return The amount of network ion as bonus
1905 	 */
1906 	function calculateMultiplierAndBonus(uint256 _purchaseAmount) public view returns (uint256, uint256, uint256) {
1907 		(uint256 startingPrimordialMultiplier, uint256 endingPrimordialMultiplier, uint256 startingNetworkBonusMultiplier, uint256 endingNetworkBonusMultiplier) = _getSettingVariables();
1908 		return (
1909 			AOLibrary.calculatePrimordialMultiplier(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingPrimordialMultiplier, endingPrimordialMultiplier),
1910 			AOLibrary.calculateNetworkBonusPercentage(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier),
1911 			AOLibrary.calculateNetworkBonusAmount(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier)
1912 		);
1913 	}
1914 
1915 	/**
1916 	 * @dev Calculate the maximum amount of Primordial an account can burn
1917 	 * @param _account The address of the account
1918 	 * @return The maximum primordial ion amount to burn
1919 	 */
1920 	function calculateMaximumBurnAmount(address _account) public view returns (uint256) {
1921 		return AOLibrary.calculateMaximumBurnAmount(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], ownerMaxMultiplier[_account]);
1922 	}
1923 
1924 	/**
1925 	 * @dev Calculate account's new multiplier after burn `_amountToBurn` primordial ions
1926 	 * @param _account The address of the account
1927 	 * @param _amountToBurn The amount of primordial ion to burn
1928 	 * @return The new multiplier in (10 ** 6)
1929 	 */
1930 	function calculateMultiplierAfterBurn(address _account, uint256 _amountToBurn) public view returns (uint256) {
1931 		require (calculateMaximumBurnAmount(_account) >= _amountToBurn);
1932 		return AOLibrary.calculateMultiplierAfterBurn(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], _amountToBurn);
1933 	}
1934 
1935 	/**
1936 	 * @dev Calculate account's new multiplier after converting `amountToConvert` network ion to primordial ion
1937 	 * @param _account The address of the account
1938 	 * @param _amountToConvert The amount of network ion to convert
1939 	 * @return The new multiplier in (10 ** 6)
1940 	 */
1941 	function calculateMultiplierAfterConversion(address _account, uint256 _amountToConvert) public view returns (uint256) {
1942 		return AOLibrary.calculateMultiplierAfterConversion(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], _amountToConvert);
1943 	}
1944 
1945 	/**
1946 	 * @dev Convert `_value` of network ions to primordial ions
1947 	 *		and re-weight the account's multiplier after conversion
1948 	 * @param _value The amount to convert
1949 	 * @return true on success
1950 	 */
1951 	function convertToPrimordial(uint256 _value) public returns (bool) {
1952 		require (balanceOf[msg.sender] >= _value);
1953 
1954 		// Update the account's multiplier
1955 		ownerWeightedMultiplier[msg.sender] = calculateMultiplierAfterConversion(msg.sender, _value);
1956 		// Burn network ion
1957 		burn(_value);
1958 		// mint primordial ion
1959 		_mintPrimordial(msg.sender, _value);
1960 
1961 		require (_aoIonLot.createConvertLot(msg.sender, _value, ownerWeightedMultiplier[msg.sender]));
1962 		return true;
1963 	}
1964 
1965 	/**
1966 	 * @dev Get quantity of AO+ left in Network Exchange
1967 	 * @return The quantity of AO+ left in Network Exchange
1968 	 */
1969 	function availablePrimordialForSale() public view returns (uint256) {
1970 		return TOTAL_PRIMORDIAL_FOR_SALE.sub(primordialTotalBought);
1971 	}
1972 
1973 	/**
1974 	 * @dev Get quantity of AO+ in ETH left in Network Exchange (i.e How much ETH is there total that can be
1975 	 *		exchanged for AO+
1976 	 * @return The quantity of AO+ in ETH left in Network Exchange
1977 	 */
1978 	function availablePrimordialForSaleInETH() public view returns (uint256) {
1979 		return availablePrimordialForSale().mul(primordialBuyPrice);
1980 	}
1981 
1982 	/**
1983 	 * @dev Get maximum quantity of AOETH or ETH that can still be sold
1984 	 * @return The maximum quantity of AOETH or ETH that can still be sold
1985 	 */
1986 	function availableETH() public view returns (uint256) {
1987 		if (availablePrimordialForSaleInETH() > 0) {
1988 			uint256 _availableETH = availablePrimordialForSaleInETH().sub(_aoeth.totalSupply().sub(totalRedeemedAOETH));
1989 			if (availablePrimordialForSale() == 1 && _availableETH < primordialBuyPrice) {
1990 				return primordialBuyPrice;
1991 			} else {
1992 				return _availableETH;
1993 			}
1994 		} else {
1995 			return 0;
1996 		}
1997 	}
1998 
1999 	/***** INTERNAL METHODS *****/
2000 	/***** PRIMORDIAL ION INTERNAL METHODS *****/
2001 	/**
2002 	 * @dev Calculate the amount of ion the buyer will receive and remaining budget if exist
2003 	 *		when he/she buys primordial ion
2004 	 * @param _budget The amount of ETH sent by buyer
2005 	 * @param _withETH Whether or not buyer is paying with ETH
2006 	 * @return uint256 of the amount the buyer will receiver
2007 	 * @return uint256 of the remaining budget, if exist
2008 	 * @return bool whether or not the network exchange should end
2009 	 */
2010 	function _calculateAmountAndRemainderBudget(uint256 _budget, bool _withETH) internal view returns (uint256, uint256, bool) {
2011 		// Calculate the amount of ion
2012 		uint256 amount = _budget.div(primordialBuyPrice);
2013 
2014 		// If we need to return ETH to the buyer, in the case
2015 		// where the buyer sends more ETH than available primordial ion to be purchased
2016 		uint256 remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
2017 
2018 		uint256 _availableETH = availableETH();
2019 		// If paying with ETH, it can't exceed availableETH
2020 		if (_withETH && _budget > availableETH()) {
2021 			// Calculate the amount of ions
2022 			amount = _availableETH.div(primordialBuyPrice);
2023 			remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
2024 		}
2025 
2026 		// Make sure primordialTotalBought is not overflowing
2027 		bool shouldEndNetworkExchange = false;
2028 		if (primordialTotalBought.add(amount) >= TOTAL_PRIMORDIAL_FOR_SALE) {
2029 			amount = TOTAL_PRIMORDIAL_FOR_SALE.sub(primordialTotalBought);
2030 			shouldEndNetworkExchange = true;
2031 			remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
2032 		}
2033 		return (amount, remainderEth, shouldEndNetworkExchange);
2034 	}
2035 
2036 	/**
2037 	 * @dev Actually sending the primordial ion to buyer and reward AO devs accordingly
2038 	 * @param amount The amount of primordial ion to be sent to buyer
2039 	 * @param to The recipient of ion
2040 	 * @return the lot Id of the buyer
2041 	 */
2042 	function _sendPrimordialAndRewardDev(uint256 amount, address to) internal returns (bytes32) {
2043 		(uint256 startingPrimordialMultiplier,, uint256 startingNetworkBonusMultiplier, uint256 endingNetworkBonusMultiplier) = _getSettingVariables();
2044 
2045 		// Update primordialTotalBought
2046 		(uint256 multiplier, uint256 networkBonusPercentage, uint256 networkBonusAmount) = calculateMultiplierAndBonus(amount);
2047 		primordialTotalBought = primordialTotalBought.add(amount);
2048 		bytes32 _lotId = _createPrimordialLot(to, amount, multiplier, networkBonusAmount);
2049 
2050 		// Calculate The AO and AO Dev Team's portion of Primordial and Network ion Bonus
2051 		uint256 inverseMultiplier = startingPrimordialMultiplier.sub(multiplier); // Inverse of the buyer's multiplier
2052 		uint256 theAONetworkBonusAmount = (startingNetworkBonusMultiplier.sub(networkBonusPercentage).add(endingNetworkBonusMultiplier)).mul(amount).div(AOLibrary.PERCENTAGE_DIVISOR());
2053 		if (aoDevTeam1 != address(0)) {
2054 			_createPrimordialLot(aoDevTeam1, amount.div(2), inverseMultiplier, theAONetworkBonusAmount.div(2));
2055 		}
2056 		if (aoDevTeam2 != address(0)) {
2057 			_createPrimordialLot(aoDevTeam2, amount.div(2), inverseMultiplier, theAONetworkBonusAmount.div(2));
2058 		}
2059 		_mint(theAO, theAONetworkBonusAmount);
2060 		return _lotId;
2061 	}
2062 
2063 	/**
2064 	 * @dev Create a lot with `primordialAmount` of primordial ions with `_multiplier` for an `account`
2065 	 *		during network exchange, and reward `_networkBonusAmount` if exist
2066 	 * @param _account Address of the lot owner
2067 	 * @param _primordialAmount The amount of primordial ions to be stored in the lot
2068 	 * @param _multiplier The multiplier for this lot in (10 ** 6)
2069 	 * @param _networkBonusAmount The network ion bonus amount
2070 	 * @return Created lot Id
2071 	 */
2072 	function _createPrimordialLot(address _account, uint256 _primordialAmount, uint256 _multiplier, uint256 _networkBonusAmount) internal returns (bytes32) {
2073 		bytes32 lotId = _aoIonLot.createPrimordialLot(_account, _primordialAmount, _multiplier, _networkBonusAmount);
2074 
2075 		ownerWeightedMultiplier[_account] = AOLibrary.calculateWeightedMultiplier(ownerWeightedMultiplier[_account], primordialBalanceOf[_account], _multiplier, _primordialAmount);
2076 
2077 		// If this is the first lot, set this as the max multiplier of the account
2078 		if (_aoIonLot.totalLotsByAddress(_account) == 1) {
2079 			ownerMaxMultiplier[_account] = _multiplier;
2080 		}
2081 		_mintPrimordial(_account, _primordialAmount);
2082 		_mint(_account, _networkBonusAmount);
2083 
2084 		return lotId;
2085 	}
2086 
2087 	/**
2088 	 * @dev Create `mintedAmount` Primordial ions and send it to `target`
2089 	 * @param target Address to receive the Primordial ions
2090 	 * @param mintedAmount The amount of Primordial ions it will receive
2091 	 */
2092 	function _mintPrimordial(address target, uint256 mintedAmount) internal {
2093 		primordialBalanceOf[target] = primordialBalanceOf[target].add(mintedAmount);
2094 		primordialTotalSupply = primordialTotalSupply.add(mintedAmount);
2095 		emit PrimordialTransfer(address(0), address(this), mintedAmount);
2096 		emit PrimordialTransfer(address(this), target, mintedAmount);
2097 	}
2098 
2099 	/**
2100 	 * @dev Create a lot with `amount` of ions at `weightedMultiplier` for an `account`
2101 	 * @param _account Address of lot owner
2102 	 * @param _amount The amount of ions
2103 	 * @param _weightedMultiplier The multiplier of the lot (in 10^6)
2104 	 * @return bytes32 of new created lot ID
2105 	 */
2106 	function _createWeightedMultiplierLot(address _account, uint256 _amount, uint256 _weightedMultiplier) internal returns (bytes32) {
2107 		require (_account != address(0));
2108 		require (_amount > 0);
2109 
2110 		bytes32 lotId = _aoIonLot.createWeightedMultiplierLot(_account, _amount, _weightedMultiplier);
2111 		// If this is the first lot, set this as the max multiplier of the account
2112 		if (_aoIonLot.totalLotsByAddress(_account) == 1) {
2113 			ownerMaxMultiplier[_account] = _weightedMultiplier;
2114 		}
2115 		return lotId;
2116 	}
2117 
2118 	/**
2119 	 * @dev Create Lot and send `_value` Primordial ions from `_from` to `_to`
2120 	 * @param _from The address of sender
2121 	 * @param _to The address of the recipient
2122 	 * @param _value The amount to send
2123 	 * @return true on success
2124 	 */
2125 	function _createLotAndTransferPrimordial(address _from, address _to, uint256 _value) internal returns (bool) {
2126 		bytes32 _createdLotId = _createWeightedMultiplierLot(_to, _value, ownerWeightedMultiplier[_from]);
2127 		(, address _lotOwner,,) = _aoIonLot.lotById(_createdLotId);
2128 
2129 		// Make sure the new lot is created successfully
2130 		require (_lotOwner == _to);
2131 
2132 		// Update the weighted multiplier of the recipient
2133 		ownerWeightedMultiplier[_to] = AOLibrary.calculateWeightedMultiplier(ownerWeightedMultiplier[_to], primordialBalanceOf[_to], ownerWeightedMultiplier[_from], _value);
2134 
2135 		// Transfer the Primordial ions
2136 		require (_transferPrimordial(_from, _to, _value));
2137 		return true;
2138 	}
2139 
2140 	/**
2141 	 * @dev Send `_value` Primordial ions from `_from` to `_to`
2142 	 * @param _from The address of sender
2143 	 * @param _to The address of the recipient
2144 	 * @param _value The amount to send
2145 	 */
2146 	function _transferPrimordial(address _from, address _to, uint256 _value) internal returns (bool) {
2147 		require (_to != address(0));									// Prevent transfer to 0x0 address. Use burn() instead
2148 		require (primordialBalanceOf[_from] >= _value);						// Check if the sender has enough
2149 		require (primordialBalanceOf[_to].add(_value) >= primordialBalanceOf[_to]);	// Check for overflows
2150 		require (!frozenAccount[_from]);								// Check if sender is frozen
2151 		require (!frozenAccount[_to]);									// Check if recipient is frozen
2152 		uint256 previousBalances = primordialBalanceOf[_from].add(primordialBalanceOf[_to]);
2153 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);			// Subtract from the sender
2154 		primordialBalanceOf[_to] = primordialBalanceOf[_to].add(_value);				// Add the same to the recipient
2155 		emit PrimordialTransfer(_from, _to, _value);
2156 		assert(primordialBalanceOf[_from].add(primordialBalanceOf[_to]) == previousBalances);
2157 		return true;
2158 	}
2159 
2160 	/**
2161 	 * @dev Get setting variables
2162 	 * @return startingPrimordialMultiplier The starting multiplier used to calculate primordial ion
2163 	 * @return endingPrimordialMultiplier The ending multiplier used to calculate primordial ion
2164 	 * @return startingNetworkBonusMultiplier The starting multiplier used to calculate network ion bonus
2165 	 * @return endingNetworkBonusMultiplier The ending multiplier used to calculate network ion bonus
2166 	 */
2167 	function _getSettingVariables() internal view returns (uint256, uint256, uint256, uint256) {
2168 		(uint256 startingPrimordialMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'startingPrimordialMultiplier');
2169 		(uint256 endingPrimordialMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'endingPrimordialMultiplier');
2170 
2171 		(uint256 startingNetworkBonusMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'startingNetworkBonusMultiplier');
2172 		(uint256 endingNetworkBonusMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'endingNetworkBonusMultiplier');
2173 
2174 		return (startingPrimordialMultiplier, endingPrimordialMultiplier, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier);
2175 	}
2176 }