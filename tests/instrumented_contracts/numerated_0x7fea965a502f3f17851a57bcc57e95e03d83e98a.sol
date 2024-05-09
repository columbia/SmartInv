1 pragma solidity >=0.5.4 <0.6.0;
2 
3 interface IAOSetting {
4 	function getSettingValuesByTAOName(address _taoId, string calldata _settingName) external view returns (uint256, bool, address, bytes32, string memory);
5 	function getSettingTypes() external view returns (uint8, uint8, uint8, uint8, uint8);
6 
7 	function settingTypeLookup(uint256 _settingId) external view returns (uint8);
8 }
9 
10 
11 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
12 
13 
14 interface IAOIonLot {
15 	function createPrimordialLot(address _account, uint256 _primordialAmount, uint256 _multiplier, uint256 _networkBonusAmount) external returns (bytes32);
16 
17 	function createWeightedMultiplierLot(address _account, uint256 _amount, uint256 _weightedMultiplier) external returns (bytes32);
18 
19 	function lotById(bytes32 _lotId) external view returns (bytes32, address, uint256, uint256);
20 
21 	function totalLotsByAddress(address _lotOwner) external view returns (uint256);
22 
23 	function createBurnLot(address _account, uint256 _amount, uint256 _multiplierAfterBurn) external returns (bool);
24 
25 	function createConvertLot(address _account, uint256 _amount, uint256 _multiplierAfterConversion) external returns (bool);
26 }
27 
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34 
35 	/**
36 	 * @dev Multiplies two numbers, throws on overflow.
37 	 */
38 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
39 		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
40 		// benefit is lost if 'b' is also tested.
41 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
42 		if (a == 0) {
43 			return 0;
44 		}
45 
46 		c = a * b;
47 		assert(c / a == b);
48 		return c;
49 	}
50 
51 	/**
52 	 * @dev Integer division of two numbers, truncating the quotient.
53 	 */
54 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
55 		// assert(b > 0); // Solidity automatically throws when dividing by 0
56 		// uint256 c = a / b;
57 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
58 		return a / b;
59 	}
60 
61 	/**
62 	 * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
63 	 */
64 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65 		assert(b <= a);
66 		return a - b;
67 	}
68 
69 	/**
70 	 * @dev Adds two numbers, throws on overflow.
71 	 */
72 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
73 		c = a + b;
74 		assert(c >= a);
75 		return c;
76 	}
77 }
78 
79 
80 
81 
82 contract TokenERC20 {
83 	// Public variables of the token
84 	string public name;
85 	string public symbol;
86 	uint8 public decimals = 18;
87 	// 18 decimals is the strongly suggested default, avoid changing it
88 	uint256 public totalSupply;
89 
90 	// This creates an array with all balances
91 	mapping (address => uint256) public balanceOf;
92 	mapping (address => mapping (address => uint256)) public allowance;
93 
94 	// This generates a public event on the blockchain that will notify clients
95 	event Transfer(address indexed from, address indexed to, uint256 value);
96 
97 	// This generates a public event on the blockchain that will notify clients
98 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
99 
100 	// This notifies clients about the amount burnt
101 	event Burn(address indexed from, uint256 value);
102 
103 	/**
104 	 * Constructor function
105 	 *
106 	 * Initializes contract with initial supply tokens to the creator of the contract
107 	 */
108 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
109 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
110 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
111 		name = tokenName;                                   // Set the name for display purposes
112 		symbol = tokenSymbol;                               // Set the symbol for display purposes
113 	}
114 
115 	/**
116 	 * Internal transfer, only can be called by this contract
117 	 */
118 	function _transfer(address _from, address _to, uint _value) internal {
119 		// Prevent transfer to 0x0 address. Use burn() instead
120 		require(_to != address(0));
121 		// Check if the sender has enough
122 		require(balanceOf[_from] >= _value);
123 		// Check for overflows
124 		require(balanceOf[_to] + _value > balanceOf[_to]);
125 		// Save this for an assertion in the future
126 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
127 		// Subtract from the sender
128 		balanceOf[_from] -= _value;
129 		// Add the same to the recipient
130 		balanceOf[_to] += _value;
131 		emit Transfer(_from, _to, _value);
132 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
133 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
134 	}
135 
136 	/**
137 	 * Transfer tokens
138 	 *
139 	 * Send `_value` tokens to `_to` from your account
140 	 *
141 	 * @param _to The address of the recipient
142 	 * @param _value the amount to send
143 	 */
144 	function transfer(address _to, uint256 _value) public returns (bool success) {
145 		_transfer(msg.sender, _to, _value);
146 		return true;
147 	}
148 
149 	/**
150 	 * Transfer tokens from other address
151 	 *
152 	 * Send `_value` tokens to `_to` in behalf of `_from`
153 	 *
154 	 * @param _from The address of the sender
155 	 * @param _to The address of the recipient
156 	 * @param _value the amount to send
157 	 */
158 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
159 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
160 		allowance[_from][msg.sender] -= _value;
161 		_transfer(_from, _to, _value);
162 		return true;
163 	}
164 
165 	/**
166 	 * Set allowance for other address
167 	 *
168 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
169 	 *
170 	 * @param _spender The address authorized to spend
171 	 * @param _value the max amount they can spend
172 	 */
173 	function approve(address _spender, uint256 _value) public returns (bool success) {
174 		allowance[msg.sender][_spender] = _value;
175 		emit Approval(msg.sender, _spender, _value);
176 		return true;
177 	}
178 
179 	/**
180 	 * Set allowance for other address and notify
181 	 *
182 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
183 	 *
184 	 * @param _spender The address authorized to spend
185 	 * @param _value the max amount they can spend
186 	 * @param _extraData some extra information to send to the approved contract
187 	 */
188 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
189 		tokenRecipient spender = tokenRecipient(_spender);
190 		if (approve(_spender, _value)) {
191 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
192 			return true;
193 		}
194 	}
195 
196 	/**
197 	 * Destroy tokens
198 	 *
199 	 * Remove `_value` tokens from the system irreversibly
200 	 *
201 	 * @param _value the amount of money to burn
202 	 */
203 	function burn(uint256 _value) public returns (bool success) {
204 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
205 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
206 		totalSupply -= _value;                      // Updates totalSupply
207 		emit Burn(msg.sender, _value);
208 		return true;
209 	}
210 
211 	/**
212 	 * Destroy tokens from other account
213 	 *
214 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
215 	 *
216 	 * @param _from the address of the sender
217 	 * @param _value the amount of money to burn
218 	 */
219 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
220 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
221 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
222 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
223 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
224 		totalSupply -= _value;                              // Update totalSupply
225 		emit Burn(_from, _value);
226 		return true;
227 	}
228 }
229 
230 
231 contract TheAO {
232 	address public theAO;
233 	address public nameTAOPositionAddress;
234 
235 	// Check whether an address is whitelisted and granted access to transact
236 	// on behalf of others
237 	mapping (address => bool) public whitelist;
238 
239 	constructor() public {
240 		theAO = msg.sender;
241 	}
242 
243 	/**
244 	 * @dev Checks if msg.sender is in whitelist.
245 	 */
246 	modifier inWhitelist() {
247 		require (whitelist[msg.sender] == true);
248 		_;
249 	}
250 
251 	/**
252 	 * @dev Transfer ownership of The AO to new address
253 	 * @param _theAO The new address to be transferred
254 	 */
255 	function transferOwnership(address _theAO) public {
256 		require (msg.sender == theAO);
257 		require (_theAO != address(0));
258 		theAO = _theAO;
259 	}
260 
261 	/**
262 	 * @dev Whitelist `_account` address to transact on behalf of others
263 	 * @param _account The address to whitelist
264 	 * @param _whitelist Either to whitelist or not
265 	 */
266 	function setWhitelist(address _account, bool _whitelist) public {
267 		require (msg.sender == theAO);
268 		require (_account != address(0));
269 		whitelist[_account] = _whitelist;
270 	}
271 }
272 
273 
274 interface INameAccountRecovery {
275 	function isCompromised(address _id) external view returns (bool);
276 }
277 
278 
279 interface INamePublicKey {
280 	function initialize(address _id, address _defaultKey, address _writerKey) external returns (bool);
281 
282 	function isKeyExist(address _id, address _key) external view returns (bool);
283 
284 	function getDefaultKey(address _id) external view returns (address);
285 
286 	function whitelistAddKey(address _id, address _key) external returns (bool);
287 }
288 
289 
290 interface INameTAOPosition {
291 	function senderIsAdvocate(address _sender, address _id) external view returns (bool);
292 	function senderIsListener(address _sender, address _id) external view returns (bool);
293 	function senderIsSpeaker(address _sender, address _id) external view returns (bool);
294 	function senderIsPosition(address _sender, address _id) external view returns (bool);
295 	function getAdvocate(address _id) external view returns (address);
296 	function nameIsAdvocate(address _nameId, address _id) external view returns (bool);
297 	function nameIsPosition(address _nameId, address _id) external view returns (bool);
298 	function initialize(address _id, address _advocateId, address _listenerId, address _speakerId) external returns (bool);
299 	function determinePosition(address _sender, address _id) external view returns (uint256);
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
733 interface ionRecipient {
734 	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
735 }
736 
737 /**
738  * @title AOIonInterface
739  */
740 contract AOIonInterface is TheAO {
741 	using SafeMath for uint256;
742 
743 	address public namePublicKeyAddress;
744 	address public nameAccountRecoveryAddress;
745 
746 	INameTAOPosition internal _nameTAOPosition;
747 	INamePublicKey internal _namePublicKey;
748 	INameAccountRecovery internal _nameAccountRecovery;
749 
750 	// Public variables of the contract
751 	string public name;
752 	string public symbol;
753 	uint8 public decimals;
754 	uint256 public totalSupply;
755 
756 	// To differentiate denomination of AO
757 	uint256 public powerOfTen;
758 
759 	/***** NETWORK ION VARIABLES *****/
760 	uint256 public sellPrice;
761 	uint256 public buyPrice;
762 
763 	// This creates an array with all balances
764 	mapping (address => uint256) public balanceOf;
765 	mapping (address => mapping (address => uint256)) public allowance;
766 	mapping (address => bool) public frozenAccount;
767 	mapping (address => uint256) public stakedBalance;
768 	mapping (address => uint256) public escrowedBalance;
769 
770 	// This generates a public event on the blockchain that will notify clients
771 	event FrozenFunds(address target, bool frozen);
772 	event Stake(address indexed from, uint256 value);
773 	event Unstake(address indexed from, uint256 value);
774 	event Escrow(address indexed from, address indexed to, uint256 value);
775 	event Unescrow(address indexed from, uint256 value);
776 
777 	// This generates a public event on the blockchain that will notify clients
778 	event Transfer(address indexed from, address indexed to, uint256 value);
779 
780 	// This generates a public event on the blockchain that will notify clients
781 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
782 
783 	// This notifies clients about the amount burnt
784 	event Burn(address indexed from, uint256 value);
785 
786 	/**
787 	 * @dev Constructor function
788 	 */
789 	constructor(string memory _name, string memory _symbol, address _nameTAOPositionAddress, address _namePublicKeyAddress, address _nameAccountRecoveryAddress) public {
790 		setNameTAOPositionAddress(_nameTAOPositionAddress);
791 		setNamePublicKeyAddress(_namePublicKeyAddress);
792 		setNameAccountRecoveryAddress(_nameAccountRecoveryAddress);
793 		name = _name;           // Set the name for display purposes
794 		symbol = _symbol;       // Set the symbol for display purposes
795 		powerOfTen = 0;
796 		decimals = 0;
797 	}
798 
799 	/**
800 	 * @dev Checks if the calling contract address is The AO
801 	 *		OR
802 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
803 	 */
804 	modifier onlyTheAO {
805 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
806 		_;
807 	}
808 
809 	/***** The AO ONLY METHODS *****/
810 	/**
811 	 * @dev Transfer ownership of The AO to new address
812 	 * @param _theAO The new address to be transferred
813 	 */
814 	function transferOwnership(address _theAO) public onlyTheAO {
815 		require (_theAO != address(0));
816 		theAO = _theAO;
817 	}
818 
819 	/**
820 	 * @dev Whitelist `_account` address to transact on behalf of others
821 	 * @param _account The address to whitelist
822 	 * @param _whitelist Either to whitelist or not
823 	 */
824 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
825 		require (_account != address(0));
826 		whitelist[_account] = _whitelist;
827 	}
828 
829 	/**
830 	 * @dev The AO set the NameTAOPosition Address
831 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
832 	 */
833 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
834 		require (_nameTAOPositionAddress != address(0));
835 		nameTAOPositionAddress = _nameTAOPositionAddress;
836 		_nameTAOPosition = INameTAOPosition(nameTAOPositionAddress);
837 	}
838 
839 	/**
840 	 * @dev The AO set the NamePublicKey Address
841 	 * @param _namePublicKeyAddress The address of NamePublicKey
842 	 */
843 	function setNamePublicKeyAddress(address _namePublicKeyAddress) public onlyTheAO {
844 		require (_namePublicKeyAddress != address(0));
845 		namePublicKeyAddress = _namePublicKeyAddress;
846 		_namePublicKey = INamePublicKey(namePublicKeyAddress);
847 	}
848 
849 	/**
850 	 * @dev The AO set the NameAccountRecovery Address
851 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
852 	 */
853 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
854 		require (_nameAccountRecoveryAddress != address(0));
855 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
856 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
857 	}
858 
859 	/**
860 	 * @dev Allows TheAO to transfer `_amount` of ETH from this address to `_recipient`
861 	 * @param _recipient The recipient address
862 	 * @param _amount The amount to transfer
863 	 */
864 	function transferEth(address payable _recipient, uint256 _amount) public onlyTheAO {
865 		require (_recipient != address(0));
866 		_recipient.transfer(_amount);
867 	}
868 
869 	/**
870 	 * @dev Prevent/Allow target from sending & receiving ions
871 	 * @param target Address to be frozen
872 	 * @param freeze Either to freeze it or not
873 	 */
874 	function freezeAccount(address target, bool freeze) public onlyTheAO {
875 		frozenAccount[target] = freeze;
876 		emit FrozenFunds(target, freeze);
877 	}
878 
879 	/**
880 	 * @dev Allow users to buy ions for `newBuyPrice` eth and sell ions for `newSellPrice` eth
881 	 * @param newSellPrice Price users can sell to the contract
882 	 * @param newBuyPrice Price users can buy from the contract
883 	 */
884 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyTheAO {
885 		sellPrice = newSellPrice;
886 		buyPrice = newBuyPrice;
887 	}
888 
889 	/***** NETWORK ION WHITELISTED ADDRESS ONLY METHODS *****/
890 	/**
891 	 * @dev Create `mintedAmount` ions and send it to `target`
892 	 * @param target Address to receive the ions
893 	 * @param mintedAmount The amount of ions it will receive
894 	 * @return true on success
895 	 */
896 	function mint(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
897 		_mint(target, mintedAmount);
898 		return true;
899 	}
900 
901 	/**
902 	 * @dev Stake `_value` ions on behalf of `_from`
903 	 * @param _from The address of the target
904 	 * @param _value The amount to stake
905 	 * @return true on success
906 	 */
907 	function stakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
908 		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
909 		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
910 		stakedBalance[_from] = stakedBalance[_from].add(_value);	// Add to the targeted staked balance
911 		emit Stake(_from, _value);
912 		return true;
913 	}
914 
915 	/**
916 	 * @dev Unstake `_value` ions on behalf of `_from`
917 	 * @param _from The address of the target
918 	 * @param _value The amount to unstake
919 	 * @return true on success
920 	 */
921 	function unstakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
922 		require (stakedBalance[_from] >= _value);					// Check if the targeted staked balance is enough
923 		stakedBalance[_from] = stakedBalance[_from].sub(_value);	// Subtract from the targeted staked balance
924 		balanceOf[_from] = balanceOf[_from].add(_value);			// Add to the targeted balance
925 		emit Unstake(_from, _value);
926 		return true;
927 	}
928 
929 	/**
930 	 * @dev Store `_value` from `_from` to `_to` in escrow
931 	 * @param _from The address of the sender
932 	 * @param _to The address of the recipient
933 	 * @param _value The amount of network ions to put in escrow
934 	 * @return true on success
935 	 */
936 	function escrowFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool) {
937 		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
938 		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
939 		escrowedBalance[_to] = escrowedBalance[_to].add(_value);	// Add to the targeted escrowed balance
940 		emit Escrow(_from, _to, _value);
941 		return true;
942 	}
943 
944 	/**
945 	 * @dev Create `mintedAmount` ions and send it to `target` escrow balance
946 	 * @param target Address to receive ions
947 	 * @param mintedAmount The amount of ions it will receive in escrow
948 	 */
949 	function mintEscrow(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
950 		escrowedBalance[target] = escrowedBalance[target].add(mintedAmount);
951 		totalSupply = totalSupply.add(mintedAmount);
952 		emit Escrow(address(this), target, mintedAmount);
953 		return true;
954 	}
955 
956 	/**
957 	 * @dev Release escrowed `_value` from `_from`
958 	 * @param _from The address of the sender
959 	 * @param _value The amount of escrowed network ions to be released
960 	 * @return true on success
961 	 */
962 	function unescrowFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
963 		require (escrowedBalance[_from] >= _value);						// Check if the targeted escrowed balance is enough
964 		escrowedBalance[_from] = escrowedBalance[_from].sub(_value);	// Subtract from the targeted escrowed balance
965 		balanceOf[_from] = balanceOf[_from].add(_value);				// Add to the targeted balance
966 		emit Unescrow(_from, _value);
967 		return true;
968 	}
969 
970 	/**
971 	 *
972 	 * @dev Whitelisted address remove `_value` ions from the system irreversibly on behalf of `_from`.
973 	 *
974 	 * @param _from the address of the sender
975 	 * @param _value the amount of money to burn
976 	 */
977 	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist returns (bool success) {
978 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
979 		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
980 		totalSupply = totalSupply.sub(_value);              // Update totalSupply
981 		emit Burn(_from, _value);
982 		return true;
983 	}
984 
985 	/**
986 	 * @dev Whitelisted address transfer ions from other address
987 	 *
988 	 * Send `_value` ions to `_to` on behalf of `_from`
989 	 *
990 	 * @param _from The address of the sender
991 	 * @param _to The address of the recipient
992 	 * @param _value the amount to send
993 	 */
994 	function whitelistTransferFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool success) {
995 		_transfer(_from, _to, _value);
996 		return true;
997 	}
998 
999 	/***** PUBLIC METHODS *****/
1000 	/**
1001 	 * Transfer ions
1002 	 *
1003 	 * Send `_value` ions to `_to` from your account
1004 	 *
1005 	 * @param _to The address of the recipient
1006 	 * @param _value the amount to send
1007 	 */
1008 	function transfer(address _to, uint256 _value) public returns (bool success) {
1009 		_transfer(msg.sender, _to, _value);
1010 		return true;
1011 	}
1012 
1013 	/**
1014 	 * Transfer ions from other address
1015 	 *
1016 	 * Send `_value` ions to `_to` in behalf of `_from`
1017 	 *
1018 	 * @param _from The address of the sender
1019 	 * @param _to The address of the recipient
1020 	 * @param _value the amount to send
1021 	 */
1022 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
1023 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
1024 		allowance[_from][msg.sender] -= _value;
1025 		_transfer(_from, _to, _value);
1026 		return true;
1027 	}
1028 
1029 	/**
1030 	 * Transfer ions between public key addresses in a Name
1031 	 * @param _nameId The ID of the Name
1032 	 * @param _from The address of the sender
1033 	 * @param _to The address of the recipient
1034 	 * @param _value the amount to send
1035 	 */
1036 	function transferBetweenPublicKeys(address _nameId, address _from, address _to, uint256 _value) public returns (bool success) {
1037 		require (AOLibrary.isName(_nameId));
1038 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _nameId));
1039 		require (!_nameAccountRecovery.isCompromised(_nameId));
1040 		// Make sure _from exist in the Name's Public Keys
1041 		require (_namePublicKey.isKeyExist(_nameId, _from));
1042 		// Make sure _to exist in the Name's Public Keys
1043 		require (_namePublicKey.isKeyExist(_nameId, _to));
1044 		_transfer(_from, _to, _value);
1045 		return true;
1046 	}
1047 
1048 	/**
1049 	 * Set allowance for other address
1050 	 *
1051 	 * Allows `_spender` to spend no more than `_value` ions in your behalf
1052 	 *
1053 	 * @param _spender The address authorized to spend
1054 	 * @param _value the max amount they can spend
1055 	 */
1056 	function approve(address _spender, uint256 _value) public returns (bool success) {
1057 		allowance[msg.sender][_spender] = _value;
1058 		emit Approval(msg.sender, _spender, _value);
1059 		return true;
1060 	}
1061 
1062 	/**
1063 	 * Set allowance for other address and notify
1064 	 *
1065 	 * Allows `_spender` to spend no more than `_value` ions in your behalf, and then ping the contract about it
1066 	 *
1067 	 * @param _spender The address authorized to spend
1068 	 * @param _value the max amount they can spend
1069 	 * @param _extraData some extra information to send to the approved contract
1070 	 */
1071 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
1072 		ionRecipient spender = ionRecipient(_spender);
1073 		if (approve(_spender, _value)) {
1074 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
1075 			return true;
1076 		}
1077 	}
1078 
1079 	/**
1080 	 * Destroy ions
1081 	 *
1082 	 * Remove `_value` ions from the system irreversibly
1083 	 *
1084 	 * @param _value the amount of money to burn
1085 	 */
1086 	function burn(uint256 _value) public returns (bool success) {
1087 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
1088 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
1089 		totalSupply -= _value;                      // Updates totalSupply
1090 		emit Burn(msg.sender, _value);
1091 		return true;
1092 	}
1093 
1094 	/**
1095 	 * Destroy ions from other account
1096 	 *
1097 	 * Remove `_value` ions from the system irreversibly on behalf of `_from`.
1098 	 *
1099 	 * @param _from the address of the sender
1100 	 * @param _value the amount of money to burn
1101 	 */
1102 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
1103 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
1104 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
1105 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
1106 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
1107 		totalSupply -= _value;                              // Update totalSupply
1108 		emit Burn(_from, _value);
1109 		return true;
1110 	}
1111 
1112 	/**
1113 	 * @dev Buy ions from contract by sending ether
1114 	 */
1115 	function buy() public payable {
1116 		require (buyPrice > 0);
1117 		uint256 amount = msg.value.div(buyPrice);
1118 		_transfer(address(this), msg.sender, amount);
1119 	}
1120 
1121 	/**
1122 	 * @dev Sell `amount` ions to contract
1123 	 * @param amount The amount of ions to be sold
1124 	 */
1125 	function sell(uint256 amount) public {
1126 		require (sellPrice > 0);
1127 		address myAddress = address(this);
1128 		require (myAddress.balance >= amount.mul(sellPrice));
1129 		_transfer(msg.sender, address(this), amount);
1130 		msg.sender.transfer(amount.mul(sellPrice));
1131 	}
1132 
1133 	/***** INTERNAL METHODS *****/
1134 	/**
1135 	 * @dev Send `_value` ions from `_from` to `_to`
1136 	 * @param _from The address of sender
1137 	 * @param _to The address of the recipient
1138 	 * @param _value The amount to send
1139 	 */
1140 	function _transfer(address _from, address _to, uint256 _value) internal {
1141 		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
1142 		require (balanceOf[_from] >= _value);					// Check if the sender has enough
1143 		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
1144 		require (!frozenAccount[_from]);						// Check if sender is frozen
1145 		require (!frozenAccount[_to]);							// Check if recipient is frozen
1146 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
1147 		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
1148 		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
1149 		emit Transfer(_from, _to, _value);
1150 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
1151 	}
1152 
1153 	/**
1154 	 * @dev Create `mintedAmount` ions and send it to `target`
1155 	 * @param target Address to receive the ions
1156 	 * @param mintedAmount The amount of ions it will receive
1157 	 */
1158 	function _mint(address target, uint256 mintedAmount) internal {
1159 		balanceOf[target] = balanceOf[target].add(mintedAmount);
1160 		totalSupply = totalSupply.add(mintedAmount);
1161 		emit Transfer(address(0), address(this), mintedAmount);
1162 		emit Transfer(address(this), target, mintedAmount);
1163 	}
1164 }
1165 
1166 
1167 
1168 
1169 
1170 
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
1184 
1185 
1186 /**
1187  * @title AOIon
1188  */
1189 contract AOIon is AOIonInterface {
1190 	using SafeMath for uint256;
1191 
1192 	address public aoIonLotAddress;
1193 	address public settingTAOId;
1194 	address public aoSettingAddress;
1195 	address public aoethAddress;
1196 
1197 	// AO Dev Team addresses to receive Primordial/Network Ions
1198 	address public aoDevTeam1 = 0x146CbD9821e6A42c8ff6DC903fe91CB69625A105;
1199 	address public aoDevTeam2 = 0x4810aF1dA3aC827259eEa72ef845F4206C703E8D;
1200 
1201 	IAOIonLot internal _aoIonLot;
1202 	IAOSetting internal _aoSetting;
1203 	AOETH internal _aoeth;
1204 
1205 	/***** PRIMORDIAL ION VARIABLES *****/
1206 	uint256 public primordialTotalSupply;
1207 	uint256 public primordialTotalBought;
1208 	uint256 public primordialSellPrice;
1209 	uint256 public primordialBuyPrice;
1210 	uint256 public totalEthForPrimordial;	// Total ETH sent for Primordial AO+
1211 	uint256 public totalRedeemedAOETH;		// Total AOETH redeemed for Primordial AO+
1212 
1213 	// Total available primordial ion for sale 3,377,699,720,527,872 AO+
1214 	uint256 constant public TOTAL_PRIMORDIAL_FOR_SALE = 3377699720527872;
1215 
1216 	mapping (address => uint256) public primordialBalanceOf;
1217 	mapping (address => mapping (address => uint256)) public primordialAllowance;
1218 
1219 	// Mapping from owner's lot weighted multiplier to the amount of staked ions
1220 	mapping (address => mapping (uint256 => uint256)) public primordialStakedBalance;
1221 
1222 	event PrimordialTransfer(address indexed from, address indexed to, uint256 value);
1223 	event PrimordialApproval(address indexed _owner, address indexed _spender, uint256 _value);
1224 	event PrimordialBurn(address indexed from, uint256 value);
1225 	event PrimordialStake(address indexed from, uint256 value, uint256 weightedMultiplier);
1226 	event PrimordialUnstake(address indexed from, uint256 value, uint256 weightedMultiplier);
1227 
1228 	event NetworkExchangeEnded();
1229 
1230 	bool public networkExchangeEnded;
1231 
1232 	// Mapping from owner to his/her current weighted multiplier
1233 	mapping (address => uint256) internal ownerWeightedMultiplier;
1234 
1235 	// Mapping from owner to his/her max multiplier (multiplier of account's first Lot)
1236 	mapping (address => uint256) internal ownerMaxMultiplier;
1237 
1238 	// Event to be broadcasted to public when user buys primordial ion
1239 	// payWith 1 == with Ethereum
1240 	// payWith 2 == with AOETH
1241 	event BuyPrimordial(address indexed lotOwner, bytes32 indexed lotId, uint8 payWith, uint256 sentAmount, uint256 refundedAmount);
1242 
1243 	/**
1244 	 * @dev Constructor function
1245 	 */
1246 	constructor(string memory _name, string memory _symbol, address _settingTAOId, address _aoSettingAddress, address _nameTAOPositionAddress, address _namePublicKeyAddress, address _nameAccountRecoveryAddress)
1247 		AOIonInterface(_name, _symbol, _nameTAOPositionAddress, _namePublicKeyAddress, _nameAccountRecoveryAddress) public {
1248 		setSettingTAOId(_settingTAOId);
1249 		setAOSettingAddress(_aoSettingAddress);
1250 
1251 		powerOfTen = 0;
1252 		decimals = 0;
1253 		setPrimordialPrices(0, 10 ** 8); // Set Primordial buy price to 0.1 gwei/ion
1254 	}
1255 
1256 	/**
1257 	 * @dev Checks if buyer can buy primordial ion
1258 	 */
1259 	modifier canBuyPrimordial(uint256 _sentAmount, bool _withETH) {
1260 		require (networkExchangeEnded == false &&
1261 			primordialTotalBought < TOTAL_PRIMORDIAL_FOR_SALE &&
1262 			primordialBuyPrice > 0 &&
1263 			_sentAmount > 0 &&
1264 			availablePrimordialForSaleInETH() > 0 &&
1265 			(
1266 				(_withETH && availableETH() > 0) ||
1267 				(!_withETH && totalRedeemedAOETH < _aoeth.totalSupply())
1268 			)
1269 		);
1270 		_;
1271 	}
1272 
1273 	/***** The AO ONLY METHODS *****/
1274 	/**
1275 	 * @dev The AO sets AOIonLot address
1276 	 * @param _aoIonLotAddress The address of AOIonLot
1277 	 */
1278 	function setAOIonLotAddress(address _aoIonLotAddress) public onlyTheAO {
1279 		require (_aoIonLotAddress != address(0));
1280 		aoIonLotAddress = _aoIonLotAddress;
1281 		_aoIonLot = IAOIonLot(_aoIonLotAddress);
1282 	}
1283 
1284 	/**
1285 	 * @dev The AO sets setting TAO ID
1286 	 * @param _settingTAOId The new setting TAO ID to set
1287 	 */
1288 	function setSettingTAOId(address _settingTAOId) public onlyTheAO {
1289 		require (AOLibrary.isTAO(_settingTAOId));
1290 		settingTAOId = _settingTAOId;
1291 	}
1292 
1293 	/**
1294 	 * @dev The AO sets AO Setting address
1295 	 * @param _aoSettingAddress The address of AOSetting
1296 	 */
1297 	function setAOSettingAddress(address _aoSettingAddress) public onlyTheAO {
1298 		require (_aoSettingAddress != address(0));
1299 		aoSettingAddress = _aoSettingAddress;
1300 		_aoSetting = IAOSetting(_aoSettingAddress);
1301 	}
1302 
1303 	/**
1304 	 * @dev Set AO Dev team addresses to receive Primordial/Network ions during network exchange
1305 	 * @param _aoDevTeam1 The first AO dev team address
1306 	 * @param _aoDevTeam2 The second AO dev team address
1307 	 */
1308 	function setAODevTeamAddresses(address _aoDevTeam1, address _aoDevTeam2) public onlyTheAO {
1309 		aoDevTeam1 = _aoDevTeam1;
1310 		aoDevTeam2 = _aoDevTeam2;
1311 	}
1312 
1313 	/**
1314 	 * @dev Set AOETH address
1315 	 * @param _aoethAddress The address of AOETH
1316 	 */
1317 	function setAOETHAddress(address _aoethAddress) public onlyTheAO {
1318 		require (_aoethAddress != address(0));
1319 		aoethAddress = _aoethAddress;
1320 		_aoeth = AOETH(_aoethAddress);
1321 	}
1322 
1323 	/***** PRIMORDIAL ION THE AO ONLY METHODS *****/
1324 	/**
1325 	 * @dev Allow users to buy Primordial ions for `newBuyPrice` eth and sell Primordial ions for `newSellPrice` eth
1326 	 * @param newPrimordialSellPrice Price users can sell to the contract
1327 	 * @param newPrimordialBuyPrice Price users can buy from the contract
1328 	 */
1329 	function setPrimordialPrices(uint256 newPrimordialSellPrice, uint256 newPrimordialBuyPrice) public onlyTheAO {
1330 		primordialSellPrice = newPrimordialSellPrice;
1331 		primordialBuyPrice = newPrimordialBuyPrice;
1332 	}
1333 
1334 	/**
1335 	 * @dev Only the AO can force end network exchange
1336 	 */
1337 	function endNetworkExchange() public onlyTheAO {
1338 		require (!networkExchangeEnded);
1339 		networkExchangeEnded = true;
1340 		emit NetworkExchangeEnded();
1341 	}
1342 
1343 	/***** PRIMORDIAL ION WHITELISTED ADDRESS ONLY METHODS *****/
1344 	/**
1345 	 * @dev Stake `_value` Primordial ions at `_weightedMultiplier ` multiplier on behalf of `_from`
1346 	 * @param _from The address of the target
1347 	 * @param _value The amount of Primordial ions to stake
1348 	 * @param _weightedMultiplier The weighted multiplier of the Primordial ions
1349 	 * @return true on success
1350 	 */
1351 	function stakePrimordialFrom(address _from, uint256 _value, uint256 _weightedMultiplier) public inWhitelist returns (bool) {
1352 		// Check if the targeted balance is enough
1353 		require (primordialBalanceOf[_from] >= _value);
1354 		// Make sure the weighted multiplier is the same as account's current weighted multiplier
1355 		require (_weightedMultiplier == ownerWeightedMultiplier[_from]);
1356 		// Subtract from the targeted balance
1357 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);
1358 		// Add to the targeted staked balance
1359 		primordialStakedBalance[_from][_weightedMultiplier] = primordialStakedBalance[_from][_weightedMultiplier].add(_value);
1360 		emit PrimordialStake(_from, _value, _weightedMultiplier);
1361 		return true;
1362 	}
1363 
1364 	/**
1365 	 * @dev Unstake `_value` Primordial ions at `_weightedMultiplier` on behalf of `_from`
1366 	 * @param _from The address of the target
1367 	 * @param _value The amount to unstake
1368 	 * @param _weightedMultiplier The weighted multiplier of the Primordial ions
1369 	 * @return true on success
1370 	 */
1371 	function unstakePrimordialFrom(address _from, uint256 _value, uint256 _weightedMultiplier) public inWhitelist returns (bool) {
1372 		// Check if the targeted staked balance is enough
1373 		require (primordialStakedBalance[_from][_weightedMultiplier] >= _value);
1374 		// Subtract from the targeted staked balance
1375 		primordialStakedBalance[_from][_weightedMultiplier] = primordialStakedBalance[_from][_weightedMultiplier].sub(_value);
1376 		// Add to the targeted balance
1377 		primordialBalanceOf[_from] = primordialBalanceOf[_from].add(_value);
1378 		emit PrimordialUnstake(_from, _value, _weightedMultiplier);
1379 		return true;
1380 	}
1381 
1382 	/**
1383 	 * @dev Send `_value` primordial ions to `_to` on behalf of `_from`
1384 	 * @param _from The address of the sender
1385 	 * @param _to The address of the recipient
1386 	 * @param _value The amount to send
1387 	 * @return true on success
1388 	 */
1389 	function whitelistTransferPrimordialFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool) {
1390 		return _createLotAndTransferPrimordial(_from, _to, _value);
1391 	}
1392 
1393 	/***** PUBLIC METHODS *****/
1394 	/***** PRIMORDIAL ION PUBLIC METHODS *****/
1395 	/**
1396 	 * @dev Buy Primordial ions from contract by sending ether
1397 	 */
1398 	function buyPrimordial() public payable canBuyPrimordial(msg.value, true) {
1399 		(uint256 amount, uint256 remainderBudget, bool shouldEndNetworkExchange) = _calculateAmountAndRemainderBudget(msg.value, true);
1400 		require (amount > 0);
1401 
1402 		// Ends network exchange if necessary
1403 		if (shouldEndNetworkExchange) {
1404 			networkExchangeEnded = true;
1405 			emit NetworkExchangeEnded();
1406 		}
1407 
1408 		// Update totalEthForPrimordial
1409 		totalEthForPrimordial = totalEthForPrimordial.add(msg.value.sub(remainderBudget));
1410 
1411 		// Send the primordial ion to buyer and reward AO devs
1412 		bytes32 _lotId = _sendPrimordialAndRewardDev(amount, msg.sender);
1413 
1414 		emit BuyPrimordial(msg.sender, _lotId, 1, msg.value, remainderBudget);
1415 
1416 		// Send remainder budget back to buyer if exist
1417 		if (remainderBudget > 0) {
1418 			msg.sender.transfer(remainderBudget);
1419 		}
1420 	}
1421 
1422 	/**
1423 	 * @dev Buy Primordial ion from contract by sending AOETH
1424 	 */
1425 	function buyPrimordialWithAOETH(uint256 _aoethAmount) public canBuyPrimordial(_aoethAmount, false) {
1426 		(uint256 amount, uint256 remainderBudget, bool shouldEndNetworkExchange) = _calculateAmountAndRemainderBudget(_aoethAmount, false);
1427 		require (amount > 0);
1428 
1429 		// Ends network exchange if necessary
1430 		if (shouldEndNetworkExchange) {
1431 			networkExchangeEnded = true;
1432 			emit NetworkExchangeEnded();
1433 		}
1434 
1435 		// Calculate the actual AOETH that was charged for this transaction
1436 		uint256 actualCharge = _aoethAmount.sub(remainderBudget);
1437 
1438 		// Update totalRedeemedAOETH
1439 		totalRedeemedAOETH = totalRedeemedAOETH.add(actualCharge);
1440 
1441 		// Transfer AOETH from buyer to here
1442 		require (_aoeth.whitelistTransferFrom(msg.sender, address(this), actualCharge));
1443 
1444 		// Send the primordial ion to buyer and reward AO devs
1445 		bytes32 _lotId = _sendPrimordialAndRewardDev(amount, msg.sender);
1446 
1447 		emit BuyPrimordial(msg.sender, _lotId, 2, _aoethAmount, remainderBudget);
1448 	}
1449 
1450 	/**
1451 	 * @dev Send `_value` Primordial ions to `_to` from your account
1452 	 * @param _to The address of the recipient
1453 	 * @param _value The amount to send
1454 	 * @return true on success
1455 	 */
1456 	function transferPrimordial(address _to, uint256 _value) public returns (bool) {
1457 		return _createLotAndTransferPrimordial(msg.sender, _to, _value);
1458 	}
1459 
1460 	/**
1461 	 * @dev Send `_value` Primordial ions to `_to` from `_from`
1462 	 * @param _from The address of the sender
1463 	 * @param _to The address of the recipient
1464 	 * @param _value The amount to send
1465 	 * @return true on success
1466 	 */
1467 	function transferPrimordialFrom(address _from, address _to, uint256 _value) public returns (bool) {
1468 		require (_value <= primordialAllowance[_from][msg.sender]);
1469 		primordialAllowance[_from][msg.sender] = primordialAllowance[_from][msg.sender].sub(_value);
1470 
1471 		return _createLotAndTransferPrimordial(_from, _to, _value);
1472 	}
1473 
1474 	/**
1475 	 * Transfer primordial ions between public key addresses in a Name
1476 	 * @param _nameId The ID of the Name
1477 	 * @param _from The address of the sender
1478 	 * @param _to The address of the recipient
1479 	 * @param _value the amount to send
1480 	 */
1481 	function transferPrimordialBetweenPublicKeys(address _nameId, address _from, address _to, uint256 _value) public returns (bool) {
1482 		require (AOLibrary.isName(_nameId));
1483 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _nameId));
1484 		require (!_nameAccountRecovery.isCompromised(_nameId));
1485 		// Make sure _from exist in the Name's Public Keys
1486 		require (_namePublicKey.isKeyExist(_nameId, _from));
1487 		// Make sure _to exist in the Name's Public Keys
1488 		require (_namePublicKey.isKeyExist(_nameId, _to));
1489 		return _createLotAndTransferPrimordial(_from, _to, _value);
1490 	}
1491 
1492 	/**
1493 	 * @dev Allows `_spender` to spend no more than `_value` Primordial ions in your behalf
1494 	 * @param _spender The address authorized to spend
1495 	 * @param _value The max amount they can spend
1496 	 * @return true on success
1497 	 */
1498 	function approvePrimordial(address _spender, uint256 _value) public returns (bool) {
1499 		primordialAllowance[msg.sender][_spender] = _value;
1500 		emit PrimordialApproval(msg.sender, _spender, _value);
1501 		return true;
1502 	}
1503 
1504 	/**
1505 	 * @dev Allows `_spender` to spend no more than `_value` Primordial ions in your behalf, and then ping the contract about it
1506 	 * @param _spender The address authorized to spend
1507 	 * @param _value The max amount they can spend
1508 	 * @param _extraData some extra information to send to the approved contract
1509 	 * @return true on success
1510 	 */
1511 	function approvePrimordialAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool) {
1512 		tokenRecipient spender = tokenRecipient(_spender);
1513 		if (approvePrimordial(_spender, _value)) {
1514 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
1515 			return true;
1516 		}
1517 	}
1518 
1519 	/**
1520 	 * @dev Remove `_value` Primordial ions from the system irreversibly
1521 	 *		and re-weight the account's multiplier after burn
1522 	 * @param _value The amount to burn
1523 	 * @return true on success
1524 	 */
1525 	function burnPrimordial(uint256 _value) public returns (bool) {
1526 		require (primordialBalanceOf[msg.sender] >= _value);
1527 		require (calculateMaximumBurnAmount(msg.sender) >= _value);
1528 
1529 		// Update the account's multiplier
1530 		ownerWeightedMultiplier[msg.sender] = calculateMultiplierAfterBurn(msg.sender, _value);
1531 		primordialBalanceOf[msg.sender] = primordialBalanceOf[msg.sender].sub(_value);
1532 		primordialTotalSupply = primordialTotalSupply.sub(_value);
1533 
1534 		// Store burn lot info
1535 		require (_aoIonLot.createBurnLot(msg.sender, _value, ownerWeightedMultiplier[msg.sender]));
1536 		emit PrimordialBurn(msg.sender, _value);
1537 		return true;
1538 	}
1539 
1540 	/**
1541 	 * @dev Remove `_value` Primordial ions from the system irreversibly on behalf of `_from`
1542 	 *		and re-weight `_from`'s multiplier after burn
1543 	 * @param _from The address of sender
1544 	 * @param _value The amount to burn
1545 	 * @return true on success
1546 	 */
1547 	function burnPrimordialFrom(address _from, uint256 _value) public returns (bool) {
1548 		require (primordialBalanceOf[_from] >= _value);
1549 		require (primordialAllowance[_from][msg.sender] >= _value);
1550 		require (calculateMaximumBurnAmount(_from) >= _value);
1551 
1552 		// Update `_from`'s multiplier
1553 		ownerWeightedMultiplier[_from] = calculateMultiplierAfterBurn(_from, _value);
1554 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);
1555 		primordialAllowance[_from][msg.sender] = primordialAllowance[_from][msg.sender].sub(_value);
1556 		primordialTotalSupply = primordialTotalSupply.sub(_value);
1557 
1558 		// Store burn lot info
1559 		require (_aoIonLot.createBurnLot(_from, _value, ownerWeightedMultiplier[_from]));
1560 		emit PrimordialBurn(_from, _value);
1561 		return true;
1562 	}
1563 
1564 	/**
1565 	 * @dev Return the average weighted multiplier of all lots owned by an address
1566 	 * @param _lotOwner The address of the lot owner
1567 	 * @return the weighted multiplier of the address (in 10 ** 6)
1568 	 */
1569 	function weightedMultiplierByAddress(address _lotOwner) public view returns (uint256) {
1570 		return ownerWeightedMultiplier[_lotOwner];
1571 	}
1572 
1573 	/**
1574 	 * @dev Return the max multiplier of an address
1575 	 * @param _target The address to query
1576 	 * @return the max multiplier of the address (in 10 ** 6)
1577 	 */
1578 	function maxMultiplierByAddress(address _target) public view returns (uint256) {
1579 		return (_aoIonLot.totalLotsByAddress(_target) > 0) ? ownerMaxMultiplier[_target] : 0;
1580 	}
1581 
1582 	/**
1583 	 * @dev Calculate the primordial ion multiplier, bonus network ion percentage, and the
1584 	 *		bonus network ion amount on a given lot when someone purchases primordial ion
1585 	 *		during network exchange
1586 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
1587 	 * @return The multiplier in (10 ** 6)
1588 	 * @return The bonus percentage
1589 	 * @return The amount of network ion as bonus
1590 	 */
1591 	function calculateMultiplierAndBonus(uint256 _purchaseAmount) public view returns (uint256, uint256, uint256) {
1592 		(uint256 startingPrimordialMultiplier, uint256 endingPrimordialMultiplier, uint256 startingNetworkBonusMultiplier, uint256 endingNetworkBonusMultiplier) = _getSettingVariables();
1593 		return (
1594 			AOLibrary.calculatePrimordialMultiplier(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingPrimordialMultiplier, endingPrimordialMultiplier),
1595 			AOLibrary.calculateNetworkBonusPercentage(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier),
1596 			AOLibrary.calculateNetworkBonusAmount(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier)
1597 		);
1598 	}
1599 
1600 	/**
1601 	 * @dev Calculate the maximum amount of Primordial an account can burn
1602 	 * @param _account The address of the account
1603 	 * @return The maximum primordial ion amount to burn
1604 	 */
1605 	function calculateMaximumBurnAmount(address _account) public view returns (uint256) {
1606 		return AOLibrary.calculateMaximumBurnAmount(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], ownerMaxMultiplier[_account]);
1607 	}
1608 
1609 	/**
1610 	 * @dev Calculate account's new multiplier after burn `_amountToBurn` primordial ions
1611 	 * @param _account The address of the account
1612 	 * @param _amountToBurn The amount of primordial ion to burn
1613 	 * @return The new multiplier in (10 ** 6)
1614 	 */
1615 	function calculateMultiplierAfterBurn(address _account, uint256 _amountToBurn) public view returns (uint256) {
1616 		require (calculateMaximumBurnAmount(_account) >= _amountToBurn);
1617 		return AOLibrary.calculateMultiplierAfterBurn(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], _amountToBurn);
1618 	}
1619 
1620 	/**
1621 	 * @dev Calculate account's new multiplier after converting `amountToConvert` network ion to primordial ion
1622 	 * @param _account The address of the account
1623 	 * @param _amountToConvert The amount of network ion to convert
1624 	 * @return The new multiplier in (10 ** 6)
1625 	 */
1626 	function calculateMultiplierAfterConversion(address _account, uint256 _amountToConvert) public view returns (uint256) {
1627 		return AOLibrary.calculateMultiplierAfterConversion(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], _amountToConvert);
1628 	}
1629 
1630 	/**
1631 	 * @dev Convert `_value` of network ions to primordial ions
1632 	 *		and re-weight the account's multiplier after conversion
1633 	 * @param _value The amount to convert
1634 	 * @return true on success
1635 	 */
1636 	function convertToPrimordial(uint256 _value) public returns (bool) {
1637 		require (balanceOf[msg.sender] >= _value);
1638 
1639 		// Update the account's multiplier
1640 		ownerWeightedMultiplier[msg.sender] = calculateMultiplierAfterConversion(msg.sender, _value);
1641 		// Burn network ion
1642 		burn(_value);
1643 		// mint primordial ion
1644 		_mintPrimordial(msg.sender, _value);
1645 
1646 		require (_aoIonLot.createConvertLot(msg.sender, _value, ownerWeightedMultiplier[msg.sender]));
1647 		return true;
1648 	}
1649 
1650 	/**
1651 	 * @dev Get quantity of AO+ left in Network Exchange
1652 	 * @return The quantity of AO+ left in Network Exchange
1653 	 */
1654 	function availablePrimordialForSale() public view returns (uint256) {
1655 		return TOTAL_PRIMORDIAL_FOR_SALE.sub(primordialTotalBought);
1656 	}
1657 
1658 	/**
1659 	 * @dev Get quantity of AO+ in ETH left in Network Exchange (i.e How much ETH is there total that can be
1660 	 *		exchanged for AO+
1661 	 * @return The quantity of AO+ in ETH left in Network Exchange
1662 	 */
1663 	function availablePrimordialForSaleInETH() public view returns (uint256) {
1664 		return availablePrimordialForSale().mul(primordialBuyPrice);
1665 	}
1666 
1667 	/**
1668 	 * @dev Get maximum quantity of AOETH or ETH that can still be sold
1669 	 * @return The maximum quantity of AOETH or ETH that can still be sold
1670 	 */
1671 	function availableETH() public view returns (uint256) {
1672 		if (availablePrimordialForSaleInETH() > 0) {
1673 			uint256 _availableETH = availablePrimordialForSaleInETH().sub(_aoeth.totalSupply().sub(totalRedeemedAOETH));
1674 			if (availablePrimordialForSale() == 1 && _availableETH < primordialBuyPrice) {
1675 				return primordialBuyPrice;
1676 			} else {
1677 				return _availableETH;
1678 			}
1679 		} else {
1680 			return 0;
1681 		}
1682 	}
1683 
1684 	/***** INTERNAL METHODS *****/
1685 	/***** PRIMORDIAL ION INTERNAL METHODS *****/
1686 	/**
1687 	 * @dev Calculate the amount of ion the buyer will receive and remaining budget if exist
1688 	 *		when he/she buys primordial ion
1689 	 * @param _budget The amount of ETH sent by buyer
1690 	 * @param _withETH Whether or not buyer is paying with ETH
1691 	 * @return uint256 of the amount the buyer will receiver
1692 	 * @return uint256 of the remaining budget, if exist
1693 	 * @return bool whether or not the network exchange should end
1694 	 */
1695 	function _calculateAmountAndRemainderBudget(uint256 _budget, bool _withETH) internal view returns (uint256, uint256, bool) {
1696 		// Calculate the amount of ion
1697 		uint256 amount = _budget.div(primordialBuyPrice);
1698 
1699 		// If we need to return ETH to the buyer, in the case
1700 		// where the buyer sends more ETH than available primordial ion to be purchased
1701 		uint256 remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
1702 
1703 		uint256 _availableETH = availableETH();
1704 		// If paying with ETH, it can't exceed availableETH
1705 		if (_withETH && _budget > availableETH()) {
1706 			// Calculate the amount of ions
1707 			amount = _availableETH.div(primordialBuyPrice);
1708 			remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
1709 		}
1710 
1711 		// Make sure primordialTotalBought is not overflowing
1712 		bool shouldEndNetworkExchange = false;
1713 		if (primordialTotalBought.add(amount) >= TOTAL_PRIMORDIAL_FOR_SALE) {
1714 			amount = TOTAL_PRIMORDIAL_FOR_SALE.sub(primordialTotalBought);
1715 			shouldEndNetworkExchange = true;
1716 			remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
1717 		}
1718 		return (amount, remainderEth, shouldEndNetworkExchange);
1719 	}
1720 
1721 	/**
1722 	 * @dev Actually sending the primordial ion to buyer and reward AO devs accordingly
1723 	 * @param amount The amount of primordial ion to be sent to buyer
1724 	 * @param to The recipient of ion
1725 	 * @return the lot Id of the buyer
1726 	 */
1727 	function _sendPrimordialAndRewardDev(uint256 amount, address to) internal returns (bytes32) {
1728 		(uint256 startingPrimordialMultiplier,, uint256 startingNetworkBonusMultiplier, uint256 endingNetworkBonusMultiplier) = _getSettingVariables();
1729 
1730 		// Update primordialTotalBought
1731 		(uint256 multiplier, uint256 networkBonusPercentage, uint256 networkBonusAmount) = calculateMultiplierAndBonus(amount);
1732 		primordialTotalBought = primordialTotalBought.add(amount);
1733 		bytes32 _lotId = _createPrimordialLot(to, amount, multiplier, networkBonusAmount);
1734 
1735 		// Calculate The AO and AO Dev Team's portion of Primordial and Network ion Bonus
1736 		uint256 inverseMultiplier = startingPrimordialMultiplier.sub(multiplier); // Inverse of the buyer's multiplier
1737 		uint256 theAONetworkBonusAmount = (startingNetworkBonusMultiplier.sub(networkBonusPercentage).add(endingNetworkBonusMultiplier)).mul(amount).div(AOLibrary.PERCENTAGE_DIVISOR());
1738 		if (aoDevTeam1 != address(0)) {
1739 			_createPrimordialLot(aoDevTeam1, amount.div(2), inverseMultiplier, theAONetworkBonusAmount.div(2));
1740 		}
1741 		if (aoDevTeam2 != address(0)) {
1742 			_createPrimordialLot(aoDevTeam2, amount.div(2), inverseMultiplier, theAONetworkBonusAmount.div(2));
1743 		}
1744 		_mint(theAO, theAONetworkBonusAmount);
1745 		return _lotId;
1746 	}
1747 
1748 	/**
1749 	 * @dev Create a lot with `primordialAmount` of primordial ions with `_multiplier` for an `account`
1750 	 *		during network exchange, and reward `_networkBonusAmount` if exist
1751 	 * @param _account Address of the lot owner
1752 	 * @param _primordialAmount The amount of primordial ions to be stored in the lot
1753 	 * @param _multiplier The multiplier for this lot in (10 ** 6)
1754 	 * @param _networkBonusAmount The network ion bonus amount
1755 	 * @return Created lot Id
1756 	 */
1757 	function _createPrimordialLot(address _account, uint256 _primordialAmount, uint256 _multiplier, uint256 _networkBonusAmount) internal returns (bytes32) {
1758 		bytes32 lotId = _aoIonLot.createPrimordialLot(_account, _primordialAmount, _multiplier, _networkBonusAmount);
1759 
1760 		ownerWeightedMultiplier[_account] = AOLibrary.calculateWeightedMultiplier(ownerWeightedMultiplier[_account], primordialBalanceOf[_account], _multiplier, _primordialAmount);
1761 
1762 		// If this is the first lot, set this as the max multiplier of the account
1763 		if (_aoIonLot.totalLotsByAddress(_account) == 1) {
1764 			ownerMaxMultiplier[_account] = _multiplier;
1765 		}
1766 		_mintPrimordial(_account, _primordialAmount);
1767 		_mint(_account, _networkBonusAmount);
1768 
1769 		return lotId;
1770 	}
1771 
1772 	/**
1773 	 * @dev Create `mintedAmount` Primordial ions and send it to `target`
1774 	 * @param target Address to receive the Primordial ions
1775 	 * @param mintedAmount The amount of Primordial ions it will receive
1776 	 */
1777 	function _mintPrimordial(address target, uint256 mintedAmount) internal {
1778 		primordialBalanceOf[target] = primordialBalanceOf[target].add(mintedAmount);
1779 		primordialTotalSupply = primordialTotalSupply.add(mintedAmount);
1780 		emit PrimordialTransfer(address(0), address(this), mintedAmount);
1781 		emit PrimordialTransfer(address(this), target, mintedAmount);
1782 	}
1783 
1784 	/**
1785 	 * @dev Create a lot with `amount` of ions at `weightedMultiplier` for an `account`
1786 	 * @param _account Address of lot owner
1787 	 * @param _amount The amount of ions
1788 	 * @param _weightedMultiplier The multiplier of the lot (in 10^6)
1789 	 * @return bytes32 of new created lot ID
1790 	 */
1791 	function _createWeightedMultiplierLot(address _account, uint256 _amount, uint256 _weightedMultiplier) internal returns (bytes32) {
1792 		require (_account != address(0));
1793 		require (_amount > 0);
1794 
1795 		bytes32 lotId = _aoIonLot.createWeightedMultiplierLot(_account, _amount, _weightedMultiplier);
1796 		// If this is the first lot, set this as the max multiplier of the account
1797 		if (_aoIonLot.totalLotsByAddress(_account) == 1) {
1798 			ownerMaxMultiplier[_account] = _weightedMultiplier;
1799 		}
1800 		return lotId;
1801 	}
1802 
1803 	/**
1804 	 * @dev Create Lot and send `_value` Primordial ions from `_from` to `_to`
1805 	 * @param _from The address of sender
1806 	 * @param _to The address of the recipient
1807 	 * @param _value The amount to send
1808 	 * @return true on success
1809 	 */
1810 	function _createLotAndTransferPrimordial(address _from, address _to, uint256 _value) internal returns (bool) {
1811 		bytes32 _createdLotId = _createWeightedMultiplierLot(_to, _value, ownerWeightedMultiplier[_from]);
1812 		(, address _lotOwner,,) = _aoIonLot.lotById(_createdLotId);
1813 
1814 		// Make sure the new lot is created successfully
1815 		require (_lotOwner == _to);
1816 
1817 		// Update the weighted multiplier of the recipient
1818 		ownerWeightedMultiplier[_to] = AOLibrary.calculateWeightedMultiplier(ownerWeightedMultiplier[_to], primordialBalanceOf[_to], ownerWeightedMultiplier[_from], _value);
1819 
1820 		// Transfer the Primordial ions
1821 		require (_transferPrimordial(_from, _to, _value));
1822 		return true;
1823 	}
1824 
1825 	/**
1826 	 * @dev Send `_value` Primordial ions from `_from` to `_to`
1827 	 * @param _from The address of sender
1828 	 * @param _to The address of the recipient
1829 	 * @param _value The amount to send
1830 	 */
1831 	function _transferPrimordial(address _from, address _to, uint256 _value) internal returns (bool) {
1832 		require (_to != address(0));									// Prevent transfer to 0x0 address. Use burn() instead
1833 		require (primordialBalanceOf[_from] >= _value);						// Check if the sender has enough
1834 		require (primordialBalanceOf[_to].add(_value) >= primordialBalanceOf[_to]);	// Check for overflows
1835 		require (!frozenAccount[_from]);								// Check if sender is frozen
1836 		require (!frozenAccount[_to]);									// Check if recipient is frozen
1837 		uint256 previousBalances = primordialBalanceOf[_from].add(primordialBalanceOf[_to]);
1838 		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);			// Subtract from the sender
1839 		primordialBalanceOf[_to] = primordialBalanceOf[_to].add(_value);				// Add the same to the recipient
1840 		emit PrimordialTransfer(_from, _to, _value);
1841 		assert(primordialBalanceOf[_from].add(primordialBalanceOf[_to]) == previousBalances);
1842 		return true;
1843 	}
1844 
1845 	/**
1846 	 * @dev Get setting variables
1847 	 * @return startingPrimordialMultiplier The starting multiplier used to calculate primordial ion
1848 	 * @return endingPrimordialMultiplier The ending multiplier used to calculate primordial ion
1849 	 * @return startingNetworkBonusMultiplier The starting multiplier used to calculate network ion bonus
1850 	 * @return endingNetworkBonusMultiplier The ending multiplier used to calculate network ion bonus
1851 	 */
1852 	function _getSettingVariables() internal view returns (uint256, uint256, uint256, uint256) {
1853 		(uint256 startingPrimordialMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'startingPrimordialMultiplier');
1854 		(uint256 endingPrimordialMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'endingPrimordialMultiplier');
1855 
1856 		(uint256 startingNetworkBonusMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'startingNetworkBonusMultiplier');
1857 		(uint256 endingNetworkBonusMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'endingNetworkBonusMultiplier');
1858 
1859 		return (startingPrimordialMultiplier, endingPrimordialMultiplier, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier);
1860 	}
1861 }
1862 
1863 
1864 /**
1865  * @title AOETH
1866  */
1867 contract AOETH is TheAO, TokenERC20, tokenRecipient {
1868 	using SafeMath for uint256;
1869 
1870 	address public aoIonAddress;
1871 
1872 	AOIon internal _aoIon;
1873 
1874 	uint256 public totalERC20Tokens;
1875 	uint256 public totalTokenExchanges;
1876 
1877 	struct ERC20Token {
1878 		address tokenAddress;
1879 		uint256 price;			// price of this ERC20 Token to AOETH
1880 		uint256 maxQuantity;	// To prevent too much exposure to a given asset
1881 		uint256 exchangedQuantity;	// Running total (total AOETH exchanged from this specific ERC20 Token)
1882 		bool active;
1883 	}
1884 
1885 	struct TokenExchange {
1886 		bytes32 exchangeId;
1887 		address buyer;			// The buyer address
1888 		address tokenAddress;	// The address of ERC20 Token
1889 		uint256 price;			// price of ERC20 Token to AOETH
1890 		uint256 sentAmount;		// Amount of ERC20 Token sent
1891 		uint256 receivedAmount;	// Amount of AOETH received
1892 		bytes extraData; // Extra data
1893 	}
1894 
1895 	// Mapping from id to ERC20Token object
1896 	mapping (uint256 => ERC20Token) internal erc20Tokens;
1897 	mapping (address => uint256) internal erc20TokenIdLookup;
1898 
1899 	// Mapping from id to TokenExchange object
1900 	mapping (uint256 => TokenExchange) internal tokenExchanges;
1901 	mapping (bytes32 => uint256) internal tokenExchangeIdLookup;
1902 	mapping (address => uint256) public totalAddressTokenExchanges;
1903 
1904 	// Event to be broadcasted to public when TheAO adds an ERC20 Token
1905 	event AddERC20Token(address indexed tokenAddress, uint256 price, uint256 maxQuantity);
1906 
1907 	// Event to be broadcasted to public when TheAO sets price for ERC20 Token
1908 	event SetPrice(address indexed tokenAddress, uint256 price);
1909 
1910 	// Event to be broadcasted to public when TheAO sets max quantity for ERC20 Token
1911 	event SetMaxQuantity(address indexed tokenAddress, uint256 maxQuantity);
1912 
1913 	// Event to be broadcasted to public when TheAO sets active status for ERC20 Token
1914 	event SetActive(address indexed tokenAddress, bool active);
1915 
1916 	// Event to be broadcasted to public when user exchanges ERC20 Token for AOETH
1917 	event ExchangeToken(bytes32 indexed exchangeId, address indexed from, address tokenAddress, string tokenName, string tokenSymbol, uint256 sentTokenAmount, uint256 receivedAOETHAmount, bytes extraData);
1918 
1919 	/**
1920 	 * @dev Constructor function
1921 	 */
1922 	constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol, address _aoIonAddress, address _nameTAOPositionAddress)
1923 		TokenERC20(initialSupply, tokenName, tokenSymbol) public {
1924 		setAOIonAddress(_aoIonAddress);
1925 		setNameTAOPositionAddress(_nameTAOPositionAddress);
1926 	}
1927 
1928 	/**
1929 	 * @dev Checks if the calling contract address is The AO
1930 	 *		OR
1931 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
1932 	 */
1933 	modifier onlyTheAO {
1934 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
1935 		_;
1936 	}
1937 
1938 	/***** The AO ONLY METHODS *****/
1939 	/**
1940 	 * @dev Transfer ownership of The AO to new address
1941 	 * @param _theAO The new address to be transferred
1942 	 */
1943 	function transferOwnership(address _theAO) public onlyTheAO {
1944 		require (_theAO != address(0));
1945 		theAO = _theAO;
1946 	}
1947 
1948 	/**
1949 	 * @dev Whitelist `_account` address to transact on behalf of others
1950 	 * @param _account The address to whitelist
1951 	 * @param _whitelist Either to whitelist or not
1952 	 */
1953 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
1954 		require (_account != address(0));
1955 		whitelist[_account] = _whitelist;
1956 	}
1957 
1958 	/**
1959 	 * @dev The AO set the AOIon Address
1960 	 * @param _aoIonAddress The address of AOIon
1961 	 */
1962 	function setAOIonAddress(address _aoIonAddress) public onlyTheAO {
1963 		require (_aoIonAddress != address(0));
1964 		aoIonAddress = _aoIonAddress;
1965 		_aoIon = AOIon(_aoIonAddress);
1966 	}
1967 
1968 	/**
1969 	 * @dev The AO set the NameTAOPosition Address
1970 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
1971 	 */
1972 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
1973 		require (_nameTAOPositionAddress != address(0));
1974 		nameTAOPositionAddress = _nameTAOPositionAddress;
1975 	}
1976 
1977 	/**
1978 	 * @dev Allows TheAO to transfer `_amount` of ERC20 Token from this address to `_recipient`
1979 	 * @param _erc20TokenAddress The address of ERC20 Token
1980 	 * @param _recipient The recipient address
1981 	 * @param _amount The amount to transfer
1982 	 */
1983 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyTheAO {
1984 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
1985 		require (_erc20.transfer(_recipient, _amount));
1986 	}
1987 
1988 	/**
1989 	 * @dev Add an ERC20 Token to the list
1990 	 * @param _tokenAddress The address of the ERC20 Token
1991 	 * @param _price The price of this token to AOETH
1992 	 * @param _maxQuantity Maximum quantity allowed for exchange
1993 	 */
1994 	function addERC20Token(address _tokenAddress, uint256 _price, uint256 _maxQuantity) public onlyTheAO {
1995 		require (_tokenAddress != address(0) && _price > 0 && _maxQuantity > 0);
1996 		require (AOLibrary.isValidERC20TokenAddress(_tokenAddress));
1997 		require (erc20TokenIdLookup[_tokenAddress] == 0);
1998 
1999 		totalERC20Tokens++;
2000 		erc20TokenIdLookup[_tokenAddress] = totalERC20Tokens;
2001 		ERC20Token storage _erc20Token = erc20Tokens[totalERC20Tokens];
2002 		_erc20Token.tokenAddress = _tokenAddress;
2003 		_erc20Token.price = _price;
2004 		_erc20Token.maxQuantity = _maxQuantity;
2005 		_erc20Token.active = true;
2006 		emit AddERC20Token(_erc20Token.tokenAddress, _erc20Token.price, _erc20Token.maxQuantity);
2007 	}
2008 
2009 	/**
2010 	 * @dev Set price for existing ERC20 Token
2011 	 * @param _tokenAddress The address of the ERC20 Token
2012 	 * @param _price The price of this token to AOETH
2013 	 */
2014 	function setPrice(address _tokenAddress, uint256 _price) public onlyTheAO {
2015 		require (erc20TokenIdLookup[_tokenAddress] > 0);
2016 		require (_price > 0);
2017 
2018 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
2019 		_erc20Token.price = _price;
2020 		emit SetPrice(_erc20Token.tokenAddress, _erc20Token.price);
2021 	}
2022 
2023 	/**
2024 	 * @dev Set max quantity for existing ERC20 Token
2025 	 * @param _tokenAddress The address of the ERC20 Token
2026 	 * @param _maxQuantity The max exchange quantity for this token
2027 	 */
2028 	function setMaxQuantity(address _tokenAddress, uint256 _maxQuantity) public onlyTheAO {
2029 		require (erc20TokenIdLookup[_tokenAddress] > 0);
2030 
2031 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
2032 		require (_maxQuantity > _erc20Token.exchangedQuantity);
2033 		_erc20Token.maxQuantity = _maxQuantity;
2034 		emit SetMaxQuantity(_erc20Token.tokenAddress, _erc20Token.maxQuantity);
2035 	}
2036 
2037 	/**
2038 	 * @dev Set active status for existing ERC20 Token
2039 	 * @param _tokenAddress The address of the ERC20 Token
2040 	 * @param _active The active status for this token
2041 	 */
2042 	function setActive(address _tokenAddress, bool _active) public onlyTheAO {
2043 		require (erc20TokenIdLookup[_tokenAddress] > 0);
2044 
2045 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
2046 		_erc20Token.active = _active;
2047 		emit SetActive(_erc20Token.tokenAddress, _erc20Token.active);
2048 	}
2049 
2050 	/**
2051 	 * @dev Whitelisted address transfer tokens from other address
2052 	 *
2053 	 * Send `_value` tokens to `_to` on behalf of `_from`
2054 	 *
2055 	 * @param _from The address of the sender
2056 	 * @param _to The address of the recipient
2057 	 * @param _value the amount to send
2058 	 */
2059 	function whitelistTransferFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool success) {
2060 		_transfer(_from, _to, _value);
2061 		return true;
2062 	}
2063 
2064 	/***** PUBLIC METHODS *****/
2065 	/**
2066 	 * @dev Get an ERC20 Token information given an ID
2067 	 * @param _id The internal ID of the ERC20 Token
2068 	 * @return The ERC20 Token address
2069 	 * @return The name of the token
2070 	 * @return The symbol of the token
2071 	 * @return The price of this token to AOETH
2072 	 * @return The max quantity for exchange
2073 	 * @return The total AOETH exchanged from this token
2074 	 * @return The status of this token
2075 	 */
2076 	function getById(uint256 _id) public view returns (address, string memory, string memory, uint256, uint256, uint256, bool) {
2077 		require (erc20Tokens[_id].tokenAddress != address(0));
2078 		ERC20Token memory _erc20Token = erc20Tokens[_id];
2079 		return (
2080 			_erc20Token.tokenAddress,
2081 			TokenERC20(_erc20Token.tokenAddress).name(),
2082 			TokenERC20(_erc20Token.tokenAddress).symbol(),
2083 			_erc20Token.price,
2084 			_erc20Token.maxQuantity,
2085 			_erc20Token.exchangedQuantity,
2086 			_erc20Token.active
2087 		);
2088 	}
2089 
2090 	/**
2091 	 * @dev Get an ERC20 Token information given an address
2092 	 * @param _tokenAddress The address of the ERC20 Token
2093 	 * @return The ERC20 Token address
2094 	 * @return The name of the token
2095 	 * @return The symbol of the token
2096 	 * @return The price of this token to AOETH
2097 	 * @return The max quantity for exchange
2098 	 * @return The total AOETH exchanged from this token
2099 	 * @return The status of this token
2100 	 */
2101 	function getByAddress(address _tokenAddress) public view returns (address, string memory, string memory, uint256, uint256, uint256, bool) {
2102 		require (erc20TokenIdLookup[_tokenAddress] > 0);
2103 		return getById(erc20TokenIdLookup[_tokenAddress]);
2104 	}
2105 
2106 	/**
2107 	 * @dev When a user approves AOETH to spend on his/her behalf (i.e exchange to AOETH)
2108 	 * @param _from The user address that approved AOETH
2109 	 * @param _value The amount that the user approved
2110 	 * @param _token The address of the ERC20 Token
2111 	 * @param _extraData The extra data sent during the approval
2112 	 */
2113 	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external {
2114 		require (_from != address(0));
2115 		require (AOLibrary.isValidERC20TokenAddress(_token));
2116 
2117 		// Check if the token is supported
2118 		require (erc20TokenIdLookup[_token] > 0);
2119 		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_token]];
2120 		require (_erc20Token.active && _erc20Token.price > 0 && _erc20Token.exchangedQuantity < _erc20Token.maxQuantity);
2121 
2122 		uint256 amountToTransfer = _value.div(_erc20Token.price);
2123 		require (_erc20Token.maxQuantity.sub(_erc20Token.exchangedQuantity) >= amountToTransfer);
2124 		require (_aoIon.availableETH() >= amountToTransfer);
2125 
2126 		// Transfer the ERC20 Token from the `_from` address to here
2127 		require (TokenERC20(_token).transferFrom(_from, address(this), _value));
2128 
2129 		_erc20Token.exchangedQuantity = _erc20Token.exchangedQuantity.add(amountToTransfer);
2130 		balanceOf[_from] = balanceOf[_from].add(amountToTransfer);
2131 		totalSupply = totalSupply.add(amountToTransfer);
2132 
2133 		// Store the TokenExchange information
2134 		totalTokenExchanges++;
2135 		totalAddressTokenExchanges[_from]++;
2136 		bytes32 _exchangeId = keccak256(abi.encodePacked(this, _from, totalTokenExchanges));
2137 		tokenExchangeIdLookup[_exchangeId] = totalTokenExchanges;
2138 
2139 		TokenExchange storage _tokenExchange = tokenExchanges[totalTokenExchanges];
2140 		_tokenExchange.exchangeId = _exchangeId;
2141 		_tokenExchange.buyer = _from;
2142 		_tokenExchange.tokenAddress = _token;
2143 		_tokenExchange.price = _erc20Token.price;
2144 		_tokenExchange.sentAmount = _value;
2145 		_tokenExchange.receivedAmount = amountToTransfer;
2146 		_tokenExchange.extraData = _extraData;
2147 
2148 		emit ExchangeToken(_tokenExchange.exchangeId, _tokenExchange.buyer, _tokenExchange.tokenAddress, TokenERC20(_token).name(), TokenERC20(_token).symbol(), _tokenExchange.sentAmount, _tokenExchange.receivedAmount, _tokenExchange.extraData);
2149 	}
2150 
2151 	/**
2152 	 * @dev Get TokenExchange information given an exchange ID
2153 	 * @param _exchangeId The exchange ID to query
2154 	 * @return The buyer address
2155 	 * @return The sent ERC20 Token address
2156 	 * @return The ERC20 Token name
2157 	 * @return The ERC20 Token symbol
2158 	 * @return The price of ERC20 Token to AOETH
2159 	 * @return The amount of ERC20 Token sent
2160 	 * @return The amount of AOETH received
2161 	 * @return Extra data during the transaction
2162 	 */
2163 	function getTokenExchangeById(bytes32 _exchangeId) public view returns (address, address, string memory, string memory, uint256, uint256,  uint256, bytes memory) {
2164 		require (tokenExchangeIdLookup[_exchangeId] > 0);
2165 		TokenExchange memory _tokenExchange = tokenExchanges[tokenExchangeIdLookup[_exchangeId]];
2166 		return (
2167 			_tokenExchange.buyer,
2168 			_tokenExchange.tokenAddress,
2169 			TokenERC20(_tokenExchange.tokenAddress).name(),
2170 			TokenERC20(_tokenExchange.tokenAddress).symbol(),
2171 			_tokenExchange.price,
2172 			_tokenExchange.sentAmount,
2173 			_tokenExchange.receivedAmount,
2174 			_tokenExchange.extraData
2175 		);
2176 	}
2177 }