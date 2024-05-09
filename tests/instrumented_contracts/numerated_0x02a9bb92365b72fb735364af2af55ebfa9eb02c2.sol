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
100 interface INameTAOPosition {
101 	function senderIsAdvocate(address _sender, address _id) external view returns (bool);
102 	function senderIsListener(address _sender, address _id) external view returns (bool);
103 	function senderIsSpeaker(address _sender, address _id) external view returns (bool);
104 	function senderIsPosition(address _sender, address _id) external view returns (bool);
105 	function getAdvocate(address _id) external view returns (address);
106 	function nameIsAdvocate(address _nameId, address _id) external view returns (bool);
107 	function nameIsPosition(address _nameId, address _id) external view returns (bool);
108 	function initialize(address _id, address _advocateId, address _listenerId, address _speakerId) external returns (bool);
109 	function determinePosition(address _sender, address _id) external view returns (uint256);
110 }
111 
112 
113 
114 
115 contract TokenERC20 {
116 	// Public variables of the token
117 	string public name;
118 	string public symbol;
119 	uint8 public decimals = 18;
120 	// 18 decimals is the strongly suggested default, avoid changing it
121 	uint256 public totalSupply;
122 
123 	// This creates an array with all balances
124 	mapping (address => uint256) public balanceOf;
125 	mapping (address => mapping (address => uint256)) public allowance;
126 
127 	// This generates a public event on the blockchain that will notify clients
128 	event Transfer(address indexed from, address indexed to, uint256 value);
129 
130 	// This generates a public event on the blockchain that will notify clients
131 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
132 
133 	// This notifies clients about the amount burnt
134 	event Burn(address indexed from, uint256 value);
135 
136 	/**
137 	 * Constructor function
138 	 *
139 	 * Initializes contract with initial supply tokens to the creator of the contract
140 	 */
141 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
142 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
143 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
144 		name = tokenName;                                   // Set the name for display purposes
145 		symbol = tokenSymbol;                               // Set the symbol for display purposes
146 	}
147 
148 	/**
149 	 * Internal transfer, only can be called by this contract
150 	 */
151 	function _transfer(address _from, address _to, uint _value) internal {
152 		// Prevent transfer to 0x0 address. Use burn() instead
153 		require(_to != address(0));
154 		// Check if the sender has enough
155 		require(balanceOf[_from] >= _value);
156 		// Check for overflows
157 		require(balanceOf[_to] + _value > balanceOf[_to]);
158 		// Save this for an assertion in the future
159 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
160 		// Subtract from the sender
161 		balanceOf[_from] -= _value;
162 		// Add the same to the recipient
163 		balanceOf[_to] += _value;
164 		emit Transfer(_from, _to, _value);
165 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
166 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
167 	}
168 
169 	/**
170 	 * Transfer tokens
171 	 *
172 	 * Send `_value` tokens to `_to` from your account
173 	 *
174 	 * @param _to The address of the recipient
175 	 * @param _value the amount to send
176 	 */
177 	function transfer(address _to, uint256 _value) public returns (bool success) {
178 		_transfer(msg.sender, _to, _value);
179 		return true;
180 	}
181 
182 	/**
183 	 * Transfer tokens from other address
184 	 *
185 	 * Send `_value` tokens to `_to` in behalf of `_from`
186 	 *
187 	 * @param _from The address of the sender
188 	 * @param _to The address of the recipient
189 	 * @param _value the amount to send
190 	 */
191 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
192 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
193 		allowance[_from][msg.sender] -= _value;
194 		_transfer(_from, _to, _value);
195 		return true;
196 	}
197 
198 	/**
199 	 * Set allowance for other address
200 	 *
201 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
202 	 *
203 	 * @param _spender The address authorized to spend
204 	 * @param _value the max amount they can spend
205 	 */
206 	function approve(address _spender, uint256 _value) public returns (bool success) {
207 		allowance[msg.sender][_spender] = _value;
208 		emit Approval(msg.sender, _spender, _value);
209 		return true;
210 	}
211 
212 	/**
213 	 * Set allowance for other address and notify
214 	 *
215 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
216 	 *
217 	 * @param _spender The address authorized to spend
218 	 * @param _value the max amount they can spend
219 	 * @param _extraData some extra information to send to the approved contract
220 	 */
221 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
222 		tokenRecipient spender = tokenRecipient(_spender);
223 		if (approve(_spender, _value)) {
224 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
225 			return true;
226 		}
227 	}
228 
229 	/**
230 	 * Destroy tokens
231 	 *
232 	 * Remove `_value` tokens from the system irreversibly
233 	 *
234 	 * @param _value the amount of money to burn
235 	 */
236 	function burn(uint256 _value) public returns (bool success) {
237 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
238 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
239 		totalSupply -= _value;                      // Updates totalSupply
240 		emit Burn(msg.sender, _value);
241 		return true;
242 	}
243 
244 	/**
245 	 * Destroy tokens from other account
246 	 *
247 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
248 	 *
249 	 * @param _from the address of the sender
250 	 * @param _value the amount of money to burn
251 	 */
252 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
253 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
254 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
255 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
256 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
257 		totalSupply -= _value;                              // Update totalSupply
258 		emit Burn(_from, _value);
259 		return true;
260 	}
261 }
262 
263 
264 
265 interface INameAccountRecovery {
266 	function isCompromised(address _id) external view returns (bool);
267 }
268 
269 
270 interface INameFactory {
271 	function nonces(address _nameId) external view returns (uint256);
272 	function incrementNonce(address _nameId) external returns (uint256);
273 	function ethAddressToNameId(address _ethAddress) external view returns (address);
274 	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
275 	function nameIdToEthAddress(address _nameId) external view returns (address);
276 }
277 
278 
279 interface ITAOPool {
280 	function createPool(address _taoId, bool _ethosCapStatus, uint256 _ethosCapAmount) external returns (bool);
281 }
282 
283 
284 interface IAOSetting {
285 	function getSettingValuesByTAOName(address _taoId, string calldata _settingName) external view returns (uint256, bool, address, bytes32, string memory);
286 	function getSettingTypes() external view returns (uint8, uint8, uint8, uint8, uint8);
287 
288 	function settingTypeLookup(uint256 _settingId) external view returns (uint8);
289 }
290 
291 
292 interface ITAOAncestry {
293 	function initialize(address _id, address _parentId, uint256 _childMinLogos) external returns (bool);
294 
295 	function getAncestryById(address _id) external view returns (address, uint256, uint256);
296 
297 	function addChild(address _taoId, address _childId) external returns (bool);
298 
299 	function isChild(address _taoId, address _childId) external view returns (bool);
300 }
301 
302 
303 interface INameTAOLookup {
304 	function isExist(string calldata _name) external view returns (bool);
305 
306 	function initialize(string calldata _name, address _nameTAOId, uint256 _typeId, string calldata _parentName, address _parentId, uint256 _parentTypeId) external returns (bool);
307 
308 	function getById(address _id) external view returns (string memory, address, uint256, string memory, address, uint256);
309 
310 	function getIdByName(string calldata _name) external view returns (address);
311 }
312 
313 
314 interface ITAOFactory {
315 	function nonces(address _taoId) external view returns (uint256);
316 	function incrementNonce(address _taoId) external returns (uint256);
317 }
318 
319 
320 
321 
322 
323 
324 
325 
326 
327 
328 
329 
330 
331 
332 /**
333  * @title TAO
334  */
335 contract TAO {
336 	using SafeMath for uint256;
337 
338 	address public vaultAddress;
339 	string public name;				// the name for this TAO
340 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
341 
342 	// TAO's data
343 	string public datHash;
344 	string public database;
345 	string public keyValue;
346 	bytes32 public contentId;
347 
348 	/**
349 	 * 0 = TAO
350 	 * 1 = Name
351 	 */
352 	uint8 public typeId;
353 
354 	/**
355 	 * @dev Constructor function
356 	 */
357 	constructor (string memory _name,
358 		address _originId,
359 		string memory _datHash,
360 		string memory _database,
361 		string memory _keyValue,
362 		bytes32 _contentId,
363 		address _vaultAddress
364 	) public {
365 		name = _name;
366 		originId = _originId;
367 		datHash = _datHash;
368 		database = _database;
369 		keyValue = _keyValue;
370 		contentId = _contentId;
371 
372 		// Creating TAO
373 		typeId = 0;
374 
375 		vaultAddress = _vaultAddress;
376 	}
377 
378 	/**
379 	 * @dev Checks if calling address is Vault contract
380 	 */
381 	modifier onlyVault {
382 		require (msg.sender == vaultAddress);
383 		_;
384 	}
385 
386 	/**
387 	 * Will receive any ETH sent
388 	 */
389 	function () external payable {
390 	}
391 
392 	/**
393 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
394 	 * @param _recipient The recipient address
395 	 * @param _amount The amount to transfer
396 	 * @return true on success
397 	 */
398 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
399 		_recipient.transfer(_amount);
400 		return true;
401 	}
402 
403 	/**
404 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
405 	 * @param _erc20TokenAddress The address of ERC20 Token
406 	 * @param _recipient The recipient address
407 	 * @param _amount The amount to transfer
408 	 * @return true on success
409 	 */
410 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
411 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
412 		_erc20.transfer(_recipient, _amount);
413 		return true;
414 	}
415 }
416 
417 
418 /**
419  * @title Name
420  */
421 contract Name is TAO {
422 	/**
423 	 * @dev Constructor function
424 	 */
425 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
426 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
427 		// Creating Name
428 		typeId = 1;
429 	}
430 }
431 
432 
433 
434 /**
435  * @title AOLibrary
436  */
437 library AOLibrary {
438 	using SafeMath for uint256;
439 
440 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
441 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
442 
443 	/**
444 	 * @dev Check whether or not the given TAO ID is a TAO
445 	 * @param _taoId The ID of the TAO
446 	 * @return true if yes. false otherwise
447 	 */
448 	function isTAO(address _taoId) public view returns (bool) {
449 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
450 	}
451 
452 	/**
453 	 * @dev Check whether or not the given Name ID is a Name
454 	 * @param _nameId The ID of the Name
455 	 * @return true if yes. false otherwise
456 	 */
457 	function isName(address _nameId) public view returns (bool) {
458 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
459 	}
460 
461 	/**
462 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
463 	 * @param _tokenAddress The ERC20 Token address to check
464 	 */
465 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
466 		if (_tokenAddress == address(0)) {
467 			return false;
468 		}
469 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
470 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
471 	}
472 
473 	/**
474 	 * @dev Checks if the calling contract address is The AO
475 	 *		OR
476 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
477 	 * @param _sender The address to check
478 	 * @param _theAO The AO address
479 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
480 	 * @return true if yes, false otherwise
481 	 */
482 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
483 		return (_sender == _theAO ||
484 			(
485 				(isTAO(_theAO) || isName(_theAO)) &&
486 				_nameTAOPositionAddress != address(0) &&
487 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
488 			)
489 		);
490 	}
491 
492 	/**
493 	 * @dev Return the divisor used to correctly calculate percentage.
494 	 *		Percentage stored throughout AO contracts covers 4 decimals,
495 	 *		so 1% is 10000, 1.25% is 12500, etc
496 	 */
497 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
498 		return _PERCENTAGE_DIVISOR;
499 	}
500 
501 	/**
502 	 * @dev Return the divisor used to correctly calculate multiplier.
503 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
504 	 *		so 1 is 1000000, 0.023 is 23000, etc
505 	 */
506 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
507 		return _MULTIPLIER_DIVISOR;
508 	}
509 
510 	/**
511 	 * @dev deploy a TAO
512 	 * @param _name The name of the TAO
513 	 * @param _originId The Name ID the creates the TAO
514 	 * @param _datHash The datHash of this TAO
515 	 * @param _database The database for this TAO
516 	 * @param _keyValue The key/value pair to be checked on the database
517 	 * @param _contentId The contentId related to this TAO
518 	 * @param _nameTAOVaultAddress The address of NameTAOVault
519 	 */
520 	function deployTAO(string memory _name,
521 		address _originId,
522 		string memory _datHash,
523 		string memory _database,
524 		string memory _keyValue,
525 		bytes32 _contentId,
526 		address _nameTAOVaultAddress
527 		) public returns (TAO _tao) {
528 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
529 	}
530 
531 	/**
532 	 * @dev deploy a Name
533 	 * @param _name The name of the Name
534 	 * @param _originId The eth address the creates the Name
535 	 * @param _datHash The datHash of this Name
536 	 * @param _database The database for this Name
537 	 * @param _keyValue The key/value pair to be checked on the database
538 	 * @param _contentId The contentId related to this Name
539 	 * @param _nameTAOVaultAddress The address of NameTAOVault
540 	 */
541 	function deployName(string memory _name,
542 		address _originId,
543 		string memory _datHash,
544 		string memory _database,
545 		string memory _keyValue,
546 		bytes32 _contentId,
547 		address _nameTAOVaultAddress
548 		) public returns (Name _myName) {
549 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
550 	}
551 
552 	/**
553 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
554 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
555 	 * @param _currentPrimordialBalance Account's current primordial ion balance
556 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
557 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
558 	 * @return the new primordial weighted multiplier
559 	 */
560 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
561 		if (_currentWeightedMultiplier > 0) {
562 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
563 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
564 			return _totalWeightedIons.div(_totalIons);
565 		} else {
566 			return _additionalWeightedMultiplier;
567 		}
568 	}
569 
570 	/**
571 	 * @dev Calculate the primordial ion multiplier on a given lot
572 	 *		Total Primordial Mintable = T
573 	 *		Total Primordial Minted = M
574 	 *		Starting Multiplier = S
575 	 *		Ending Multiplier = E
576 	 *		To Purchase = P
577 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
578 	 *
579 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
580 	 * @param _totalPrimordialMintable Total Primordial ion mintable
581 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
582 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
583 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
584 	 * @return The multiplier in (10 ** 6)
585 	 */
586 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
587 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
588 			/**
589 			 * Let temp = M + (P/2)
590 			 * Multiplier = (1 - (temp / T)) x (S-E)
591 			 */
592 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
593 
594 			/**
595 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
596 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
597 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
598 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
599 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
600 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
601 			 */
602 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
603 			/**
604 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
605 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
606 			 */
607 			return multiplier.div(_MULTIPLIER_DIVISOR);
608 		} else {
609 			return 0;
610 		}
611 	}
612 
613 	/**
614 	 * @dev Calculate the bonus percentage of network ion on a given lot
615 	 *		Total Primordial Mintable = T
616 	 *		Total Primordial Minted = M
617 	 *		Starting Network Bonus Multiplier = Bs
618 	 *		Ending Network Bonus Multiplier = Be
619 	 *		To Purchase = P
620 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
621 	 *
622 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
623 	 * @param _totalPrimordialMintable Total Primordial ion intable
624 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
625 	 * @param _startingMultiplier The starting Network ion bonus multiplier
626 	 * @param _endingMultiplier The ending Network ion bonus multiplier
627 	 * @return The bonus percentage
628 	 */
629 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
630 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
631 			/**
632 			 * Let temp = M + (P/2)
633 			 * B% = (1 - (temp / T)) x (Bs-Be)
634 			 */
635 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
636 
637 			/**
638 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
639 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
640 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
641 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
642 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
643 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
644 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
645 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
646 			 */
647 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
648 			return bonusPercentage;
649 		} else {
650 			return 0;
651 		}
652 	}
653 
654 	/**
655 	 * @dev Calculate the bonus amount of network ion on a given lot
656 	 *		AO Bonus Amount = B% x P
657 	 *
658 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
659 	 * @param _totalPrimordialMintable Total Primordial ion intable
660 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
661 	 * @param _startingMultiplier The starting Network ion bonus multiplier
662 	 * @param _endingMultiplier The ending Network ion bonus multiplier
663 	 * @return The bonus percentage
664 	 */
665 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
666 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
667 		/**
668 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
669 		 * when calculating the network ion bonus amount
670 		 */
671 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
672 		return networkBonus;
673 	}
674 
675 	/**
676 	 * @dev Calculate the maximum amount of Primordial an account can burn
677 	 *		_primordialBalance = P
678 	 *		_currentWeightedMultiplier = M
679 	 *		_maximumMultiplier = S
680 	 *		_amountToBurn = B
681 	 *		B = ((S x P) - (P x M)) / S
682 	 *
683 	 * @param _primordialBalance Account's primordial ion balance
684 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
685 	 * @param _maximumMultiplier The maximum multiplier of this account
686 	 * @return The maximum burn amount
687 	 */
688 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
689 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
690 	}
691 
692 	/**
693 	 * @dev Calculate the new multiplier after burning primordial ion
694 	 *		_primordialBalance = P
695 	 *		_currentWeightedMultiplier = M
696 	 *		_amountToBurn = B
697 	 *		_newMultiplier = E
698 	 *		E = (P x M) / (P - B)
699 	 *
700 	 * @param _primordialBalance Account's primordial ion balance
701 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
702 	 * @param _amountToBurn The amount of primordial ion to burn
703 	 * @return The new multiplier
704 	 */
705 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
706 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
707 	}
708 
709 	/**
710 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
711 	 *		_primordialBalance = P
712 	 *		_currentWeightedMultiplier = M
713 	 *		_amountToConvert = C
714 	 *		_newMultiplier = E
715 	 *		E = (P x M) / (P + C)
716 	 *
717 	 * @param _primordialBalance Account's primordial ion balance
718 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
719 	 * @param _amountToConvert The amount of network ion to convert
720 	 * @return The new multiplier
721 	 */
722 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
723 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
724 	}
725 
726 	/**
727 	 * @dev count num of digits
728 	 * @param number uint256 of the nuumber to be checked
729 	 * @return uint8 num of digits
730 	 */
731 	function numDigits(uint256 number) public pure returns (uint8) {
732 		uint8 digits = 0;
733 		while(number != 0) {
734 			number = number.div(10);
735 			digits++;
736 		}
737 		return digits;
738 	}
739 }
740 
741 
742 
743 
744 
745 /**
746  * @title TAOController
747  */
748 contract TAOController is TheAO {
749 	address public nameFactoryAddress;
750 	address public nameAccountRecoveryAddress;
751 
752 	INameFactory internal _nameFactory;
753 	INameTAOPosition internal _nameTAOPosition;
754 	INameAccountRecovery internal _nameAccountRecovery;
755 
756 	/**
757 	 * @dev Constructor function
758 	 */
759 	constructor(address _nameFactoryAddress) public {
760 		setNameFactoryAddress(_nameFactoryAddress);
761 	}
762 
763 	/**
764 	 * @dev Checks if the calling contract address is The AO
765 	 *		OR
766 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
767 	 */
768 	modifier onlyTheAO {
769 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
770 		_;
771 	}
772 
773 	/**
774 	 * @dev Check if `_taoId` is a TAO
775 	 */
776 	modifier isTAO(address _taoId) {
777 		require (AOLibrary.isTAO(_taoId));
778 		_;
779 	}
780 
781 	/**
782 	 * @dev Check if `_nameId` is a Name
783 	 */
784 	modifier isName(address _nameId) {
785 		require (AOLibrary.isName(_nameId));
786 		_;
787 	}
788 
789 	/**
790 	 * @dev Check if `_id` is a Name or a TAO
791 	 */
792 	modifier isNameOrTAO(address _id) {
793 		require (AOLibrary.isName(_id) || AOLibrary.isTAO(_id));
794 		_;
795 	}
796 
797 	/**
798 	 * @dev Check is msg.sender address is a Name
799 	 */
800 	 modifier senderIsName() {
801 		require (_nameFactory.ethAddressToNameId(msg.sender) != address(0));
802 		_;
803 	 }
804 
805 	/**
806 	 * @dev Check if msg.sender is the current advocate of TAO ID
807 	 */
808 	modifier onlyAdvocate(address _id) {
809 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _id));
810 		_;
811 	}
812 
813 	/**
814 	 * @dev Only allowed if sender's Name is not compromised
815 	 */
816 	modifier senderNameNotCompromised() {
817 		require (!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
818 		_;
819 	}
820 
821 	/***** The AO ONLY METHODS *****/
822 	/**
823 	 * @dev Transfer ownership of The AO to new address
824 	 * @param _theAO The new address to be transferred
825 	 */
826 	function transferOwnership(address _theAO) public onlyTheAO {
827 		require (_theAO != address(0));
828 		theAO = _theAO;
829 	}
830 
831 	/**
832 	 * @dev Whitelist `_account` address to transact on behalf of others
833 	 * @param _account The address to whitelist
834 	 * @param _whitelist Either to whitelist or not
835 	 */
836 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
837 		require (_account != address(0));
838 		whitelist[_account] = _whitelist;
839 	}
840 
841 	/**
842 	 * @dev The AO sets NameFactory address
843 	 * @param _nameFactoryAddress The address of NameFactory
844 	 */
845 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
846 		require (_nameFactoryAddress != address(0));
847 		nameFactoryAddress = _nameFactoryAddress;
848 		_nameFactory = INameFactory(_nameFactoryAddress);
849 	}
850 
851 	/**
852 	 * @dev The AO sets NameTAOPosition address
853 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
854 	 */
855 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
856 		require (_nameTAOPositionAddress != address(0));
857 		nameTAOPositionAddress = _nameTAOPositionAddress;
858 		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
859 	}
860 
861 	/**
862 	 * @dev The AO set the NameAccountRecovery Address
863 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
864 	 */
865 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
866 		require (_nameAccountRecoveryAddress != address(0));
867 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
868 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
869 	}
870 }
871 
872 
873 
874 
875 
876 
877 
878 
879 
880 
881 
882 
883 
884 
885 /**
886  * @title TAOCurrency
887  */
888 contract TAOCurrency is TheAO {
889 	using SafeMath for uint256;
890 
891 	// Public variables of the contract
892 	string public name;
893 	string public symbol;
894 	uint8 public decimals;
895 
896 	// To differentiate denomination of TAO Currency
897 	uint256 public powerOfTen;
898 
899 	uint256 public totalSupply;
900 
901 	// This creates an array with all balances
902 	// address is the address of nameId, not the eth public address
903 	mapping (address => uint256) public balanceOf;
904 
905 	// This generates a public event on the blockchain that will notify clients
906 	// address is the address of TAO/Name Id, not eth public address
907 	event Transfer(address indexed from, address indexed to, uint256 value);
908 
909 	// This notifies clients about the amount burnt
910 	// address is the address of TAO/Name Id, not eth public address
911 	event Burn(address indexed from, uint256 value);
912 
913 	/**
914 	 * Constructor function
915 	 *
916 	 * Initializes contract with initial supply TAOCurrency to the creator of the contract
917 	 */
918 	constructor (string memory _name, string memory _symbol, address _nameTAOPositionAddress) public {
919 		name = _name;		// Set the name for display purposes
920 		symbol = _symbol;	// Set the symbol for display purposes
921 
922 		powerOfTen = 0;
923 		decimals = 0;
924 
925 		setNameTAOPositionAddress(_nameTAOPositionAddress);
926 	}
927 
928 	/**
929 	 * @dev Checks if the calling contract address is The AO
930 	 *		OR
931 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
932 	 */
933 	modifier onlyTheAO {
934 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
935 		_;
936 	}
937 
938 	/**
939 	 * @dev Check if `_id` is a Name or a TAO
940 	 */
941 	modifier isNameOrTAO(address _id) {
942 		require (AOLibrary.isName(_id) || AOLibrary.isTAO(_id));
943 		_;
944 	}
945 
946 	/***** The AO ONLY METHODS *****/
947 	/**
948 	 * @dev Transfer ownership of The AO to new address
949 	 * @param _theAO The new address to be transferred
950 	 */
951 	function transferOwnership(address _theAO) public onlyTheAO {
952 		require (_theAO != address(0));
953 		theAO = _theAO;
954 	}
955 
956 	/**
957 	 * @dev Whitelist `_account` address to transact on behalf of others
958 	 * @param _account The address to whitelist
959 	 * @param _whitelist Either to whitelist or not
960 	 */
961 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
962 		require (_account != address(0));
963 		whitelist[_account] = _whitelist;
964 	}
965 
966 	/**
967 	 * @dev The AO set the NameTAOPosition Address
968 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
969 	 */
970 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
971 		require (_nameTAOPositionAddress != address(0));
972 		nameTAOPositionAddress = _nameTAOPositionAddress;
973 	}
974 
975 	/***** PUBLIC METHODS *****/
976 	/**
977 	 * @dev transfer TAOCurrency from other address
978 	 *
979 	 * Send `_value` TAOCurrency to `_to` in behalf of `_from`
980 	 *
981 	 * @param _from The address of the sender
982 	 * @param _to The address of the recipient
983 	 * @param _value the amount to send
984 	 */
985 	function transferFrom(address _from, address _to, uint256 _value) public inWhitelist isNameOrTAO(_from) isNameOrTAO(_to) returns (bool) {
986 		_transfer(_from, _to, _value);
987 		return true;
988 	}
989 
990 	/**
991 	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
992 	 * @param target Address to receive TAOCurrency
993 	 * @param mintedAmount The amount of TAOCurrency it will receive
994 	 * @return true on success
995 	 */
996 	function mint(address target, uint256 mintedAmount) public inWhitelist isNameOrTAO(target) returns (bool) {
997 		_mint(target, mintedAmount);
998 		return true;
999 	}
1000 
1001 	/**
1002 	 *
1003 	 * @dev Whitelisted address remove `_value` TAOCurrency from the system irreversibly on behalf of `_from`.
1004 	 *
1005 	 * @param _from the address of the sender
1006 	 * @param _value the amount of money to burn
1007 	 */
1008 	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist isNameOrTAO(_from) returns (bool success) {
1009 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
1010 		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
1011 		totalSupply = totalSupply.sub(_value);              // Update totalSupply
1012 		emit Burn(_from, _value);
1013 		return true;
1014 	}
1015 
1016 	/***** INTERNAL METHODS *****/
1017 	/**
1018 	 * @dev Send `_value` TAOCurrency from `_from` to `_to`
1019 	 * @param _from The address of sender
1020 	 * @param _to The address of the recipient
1021 	 * @param _value The amount to send
1022 	 */
1023 	function _transfer(address _from, address _to, uint256 _value) internal {
1024 		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
1025 		require (balanceOf[_from] >= _value);					// Check if the sender has enough
1026 		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
1027 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
1028 		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
1029 		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
1030 		emit Transfer(_from, _to, _value);
1031 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
1032 	}
1033 
1034 	/**
1035 	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
1036 	 * @param target Address to receive TAOCurrency
1037 	 * @param mintedAmount The amount of TAOCurrency it will receive
1038 	 */
1039 	function _mint(address target, uint256 mintedAmount) internal {
1040 		balanceOf[target] = balanceOf[target].add(mintedAmount);
1041 		totalSupply = totalSupply.add(mintedAmount);
1042 		emit Transfer(address(0), address(this), mintedAmount);
1043 		emit Transfer(address(this), target, mintedAmount);
1044 	}
1045 }
1046 
1047 
1048 
1049 
1050 
1051 contract Logos is TAOCurrency {
1052 	address public nameFactoryAddress;
1053 	address public nameAccountRecoveryAddress;
1054 
1055 	INameFactory internal _nameFactory;
1056 	INameTAOPosition internal _nameTAOPosition;
1057 	INameAccountRecovery internal _nameAccountRecovery;
1058 
1059 	// Mapping of a Name ID to the amount of Logos positioned by others to itself
1060 	// address is the address of nameId, not the eth public address
1061 	mapping (address => uint256) public positionFromOthers;
1062 
1063 	// Mapping of Name ID to other Name ID and the amount of Logos positioned by itself
1064 	mapping (address => mapping(address => uint256)) public positionOnOthers;
1065 
1066 	// Mapping of a Name ID to the total amount of Logos positioned by itself on others
1067 	mapping (address => uint256) public totalPositionOnOthers;
1068 
1069 	// Mapping of Name ID to it's advocated TAO ID and the amount of Logos earned
1070 	mapping (address => mapping(address => uint256)) public advocatedTAOLogos;
1071 
1072 	// Mapping of a Name ID to the total amount of Logos earned from advocated TAO
1073 	mapping (address => uint256) public totalAdvocatedTAOLogos;
1074 
1075 	// Event broadcasted to public when `from` address position `value` Logos to `to`
1076 	event PositionFrom(address indexed from, address indexed to, uint256 value);
1077 
1078 	// Event broadcasted to public when `from` address unposition `value` Logos from `to`
1079 	event UnpositionFrom(address indexed from, address indexed to, uint256 value);
1080 
1081 	// Event broadcasted to public when `nameId` receives `amount` of Logos from advocating `taoId`
1082 	event AddAdvocatedTAOLogos(address indexed nameId, address indexed taoId, uint256 amount);
1083 
1084 	// Event broadcasted to public when Logos from advocating `taoId` is transferred from `fromNameId` to `toNameId`
1085 	event TransferAdvocatedTAOLogos(address indexed fromNameId, address indexed toNameId, address indexed taoId, uint256 amount);
1086 
1087 	/**
1088 	 * @dev Constructor function
1089 	 */
1090 	constructor(string memory _name, string memory _symbol, address _nameFactoryAddress, address _nameTAOPositionAddress)
1091 		TAOCurrency(_name, _symbol, _nameTAOPositionAddress) public {
1092 		setNameFactoryAddress(_nameFactoryAddress);
1093 		setNameTAOPositionAddress(_nameTAOPositionAddress);
1094 	}
1095 
1096 	/**
1097 	 * @dev Check if `_taoId` is a TAO
1098 	 */
1099 	modifier isTAO(address _taoId) {
1100 		require (AOLibrary.isTAO(_taoId));
1101 		_;
1102 	}
1103 
1104 	/**
1105 	 * @dev Check if `_nameId` is a Name
1106 	 */
1107 	modifier isName(address _nameId) {
1108 		require (AOLibrary.isName(_nameId));
1109 		_;
1110 	}
1111 
1112 	/**
1113 	 * @dev Check if msg.sender is the current advocate of _id
1114 	 */
1115 	modifier onlyAdvocate(address _id) {
1116 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _id));
1117 		_;
1118 	}
1119 
1120 	/**
1121 	 * @dev Only allowed if Name is not compromised
1122 	 */
1123 	modifier nameNotCompromised(address _id) {
1124 		require (!_nameAccountRecovery.isCompromised(_id));
1125 		_;
1126 	}
1127 
1128 	/**
1129 	 * @dev Only allowed if sender's Name is not compromised
1130 	 */
1131 	modifier senderNameNotCompromised() {
1132 		require (!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
1133 		_;
1134 	}
1135 
1136 	/***** THE AO ONLY METHODS *****/
1137 	/**
1138 	 * @dev The AO sets NameFactory address
1139 	 * @param _nameFactoryAddress The address of NameFactory
1140 	 */
1141 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
1142 		require (_nameFactoryAddress != address(0));
1143 		nameFactoryAddress = _nameFactoryAddress;
1144 		_nameFactory = INameFactory(_nameFactoryAddress);
1145 	}
1146 
1147 	/**
1148 	 * @dev The AO set the NameTAOPosition Address
1149 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
1150 	 */
1151 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
1152 		require (_nameTAOPositionAddress != address(0));
1153 		nameTAOPositionAddress = _nameTAOPositionAddress;
1154 		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
1155 	}
1156 
1157 	/**
1158 	 * @dev The AO set the NameAccountRecovery Address
1159 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
1160 	 */
1161 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
1162 		require (_nameAccountRecoveryAddress != address(0));
1163 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
1164 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
1165 	}
1166 
1167 	/***** PUBLIC METHODS *****/
1168 	/**
1169 	 * @dev Get the total sum of Logos for an address
1170 	 * @param _target The address to check
1171 	 * @return The total sum of Logos (own + positioned + advocated TAOs)
1172 	 */
1173 	function sumBalanceOf(address _target) public isName(_target) view returns (uint256) {
1174 		return balanceOf[_target].add(positionFromOthers[_target]).add(totalAdvocatedTAOLogos[_target]);
1175 	}
1176 
1177 	/**
1178 	 * @dev Return the amount of Logos that are available to be positioned on other
1179 	 * @param _sender The sender address to check
1180 	 * @return The amount of Logos that are available to be positioned on other
1181 	 */
1182 	function availableToPositionAmount(address _sender) public isName(_sender) view returns (uint256) {
1183 		return balanceOf[_sender].sub(totalPositionOnOthers[_sender]);
1184 	}
1185 
1186 	/**
1187 	 * @dev `_from` Name position `_value` Logos onto `_to` Name
1188 	 *
1189 	 * @param _from The address of the sender
1190 	 * @param _to The address of the recipient
1191 	 * @param _value the amount to position
1192 	 * @return true on success
1193 	 */
1194 	function positionFrom(address _from, address _to, uint256 _value) public isName(_from) isName(_to) nameNotCompromised(_from) nameNotCompromised(_to) onlyAdvocate(_from) senderNameNotCompromised returns (bool) {
1195 		require (_from != _to);	// Can't position Logos to itself
1196 		require (availableToPositionAmount(_from) >= _value); // should have enough balance to position
1197 		require (positionFromOthers[_to].add(_value) >= positionFromOthers[_to]); // check for overflows
1198 
1199 		positionOnOthers[_from][_to] = positionOnOthers[_from][_to].add(_value);
1200 		totalPositionOnOthers[_from] = totalPositionOnOthers[_from].add(_value);
1201 		positionFromOthers[_to] = positionFromOthers[_to].add(_value);
1202 
1203 		emit PositionFrom(_from, _to, _value);
1204 		return true;
1205 	}
1206 
1207 	/**
1208 	 * @dev `_from` Name unposition `_value` Logos from `_to` Name
1209 	 *
1210 	 * @param _from The address of the sender
1211 	 * @param _to The address of the recipient
1212 	 * @param _value the amount to unposition
1213 	 * @return true on success
1214 	 */
1215 	function unpositionFrom(address _from, address _to, uint256 _value) public isName(_from) isName(_to) nameNotCompromised(_from) nameNotCompromised(_to) onlyAdvocate(_from) senderNameNotCompromised returns (bool) {
1216 		require (_from != _to);	// Can't unposition Logos to itself
1217 		require (positionOnOthers[_from][_to] >= _value);
1218 
1219 		positionOnOthers[_from][_to] = positionOnOthers[_from][_to].sub(_value);
1220 		totalPositionOnOthers[_from] = totalPositionOnOthers[_from].sub(_value);
1221 		positionFromOthers[_to] = positionFromOthers[_to].sub(_value);
1222 
1223 		emit UnpositionFrom(_from, _to, _value);
1224 		return true;
1225 	}
1226 
1227 	/**
1228 	 * @dev Add `_amount` logos earned from advocating a TAO `_taoId` to its Advocate
1229 	 * @param _taoId The ID of the advocated TAO
1230 	 * @param _amount the amount to reward
1231 	 * @return true on success
1232 	 */
1233 	function addAdvocatedTAOLogos(address _taoId, uint256 _amount) public inWhitelist isTAO(_taoId) returns (bool) {
1234 		require (_amount > 0);
1235 		address _nameId = _nameTAOPosition.getAdvocate(_taoId);
1236 
1237 		advocatedTAOLogos[_nameId][_taoId] = advocatedTAOLogos[_nameId][_taoId].add(_amount);
1238 		totalAdvocatedTAOLogos[_nameId] = totalAdvocatedTAOLogos[_nameId].add(_amount);
1239 
1240 		emit AddAdvocatedTAOLogos(_nameId, _taoId, _amount);
1241 		return true;
1242 	}
1243 
1244 	/**
1245 	 * @dev Transfer logos earned from advocating a TAO `_taoId` from `_fromNameId` to the Advocate of `_taoId`
1246 	 * @param _fromNameId The ID of the Name that sends the Logos
1247 	 * @param _taoId The ID of the advocated TAO
1248 	 * @return true on success
1249 	 */
1250 	function transferAdvocatedTAOLogos(address _fromNameId, address _taoId) public inWhitelist isName(_fromNameId) isTAO(_taoId) returns (bool) {
1251 		address _toNameId = _nameTAOPosition.getAdvocate(_taoId);
1252 		require (_fromNameId != _toNameId);
1253 		require (totalAdvocatedTAOLogos[_fromNameId] >= advocatedTAOLogos[_fromNameId][_taoId]);
1254 
1255 		uint256 _amount = advocatedTAOLogos[_fromNameId][_taoId];
1256 		advocatedTAOLogos[_fromNameId][_taoId] = 0;
1257 		totalAdvocatedTAOLogos[_fromNameId] = totalAdvocatedTAOLogos[_fromNameId].sub(_amount);
1258 		advocatedTAOLogos[_toNameId][_taoId] = advocatedTAOLogos[_toNameId][_taoId].add(_amount);
1259 		totalAdvocatedTAOLogos[_toNameId] = totalAdvocatedTAOLogos[_toNameId].add(_amount);
1260 
1261 		emit TransferAdvocatedTAOLogos(_fromNameId, _toNameId, _taoId, _amount);
1262 		return true;
1263 	}
1264 }
1265 
1266 
1267 
1268 /**
1269  * @title TAOFactory
1270  *
1271  * The purpose of this contract is to allow node to create TAO
1272  */
1273 contract TAOFactory is TAOController, ITAOFactory {
1274 	using SafeMath for uint256;
1275 
1276 	address[] internal taos;
1277 
1278 	address public nameTAOLookupAddress;
1279 	address public aoSettingAddress;
1280 	address public logosAddress;
1281 	address public nameTAOVaultAddress;
1282 	address public taoAncestryAddress;
1283 	address public settingTAOId;
1284 	address public taoPoolAddress;
1285 
1286 	INameTAOLookup internal _nameTAOLookup;
1287 	IAOSetting internal _aoSetting;
1288 	Logos internal _logos;
1289 	ITAOAncestry internal _taoAncestry;
1290 	ITAOPool internal _taoPool;
1291 
1292 	// Mapping from TAO ID to its nonce
1293 	mapping (address => uint256) internal _nonces;
1294 
1295 	// Event to be broadcasted to public when Advocate creates a TAO
1296 	event CreateTAO(address indexed advocateId, address taoId, uint256 index, string name, address parent, uint8 parentTypeId);
1297 
1298 	/**
1299 	 * @dev Constructor function
1300 	 */
1301 	constructor(address _nameFactoryAddress)
1302 		TAOController(_nameFactoryAddress) public {}
1303 
1304 	/**
1305 	 * @dev Checks if calling address can update TAO's nonce
1306 	 */
1307 	modifier canUpdateNonce {
1308 		require (msg.sender == nameTAOPositionAddress || msg.sender == taoAncestryAddress || msg.sender == taoPoolAddress);
1309 		_;
1310 	}
1311 
1312 	/***** The AO ONLY METHODS *****/
1313 	/**
1314 	 * @dev The AO set the NameTAOLookup Address
1315 	 * @param _nameTAOLookupAddress The address of NameTAOLookup
1316 	 */
1317 	function setNameTAOLookupAddress(address _nameTAOLookupAddress) public onlyTheAO {
1318 		require (_nameTAOLookupAddress != address(0));
1319 		nameTAOLookupAddress = _nameTAOLookupAddress;
1320 		_nameTAOLookup = INameTAOLookup(_nameTAOLookupAddress);
1321 	}
1322 
1323 	/**
1324 	 * @dev The AO set the AOSetting Address
1325 	 * @param _aoSettingAddress The address of AOSetting
1326 	 */
1327 	function setAOSettingAddress(address _aoSettingAddress) public onlyTheAO {
1328 		require (_aoSettingAddress != address(0));
1329 		aoSettingAddress = _aoSettingAddress;
1330 		_aoSetting = IAOSetting(_aoSettingAddress);
1331 	}
1332 
1333 	/**
1334 	 * @dev The AO set the Logos Address
1335 	 * @param _logosAddress The address of Logos
1336 	 */
1337 	function setLogosAddress(address _logosAddress) public onlyTheAO {
1338 		require (_logosAddress != address(0));
1339 		logosAddress = _logosAddress;
1340 		_logos = Logos(_logosAddress);
1341 	}
1342 
1343 	/**
1344 	 * @dev The AO set the NameTAOVault Address
1345 	 * @param _nameTAOVaultAddress The address of NameTAOVault
1346 	 */
1347 	function setNameTAOVaultAddress(address _nameTAOVaultAddress) public onlyTheAO {
1348 		require (_nameTAOVaultAddress != address(0));
1349 		nameTAOVaultAddress = _nameTAOVaultAddress;
1350 	}
1351 
1352 	/**
1353 	 * @dev The AO set the TAOAncestry Address
1354 	 * @param _taoAncestryAddress The address of TAOAncestry
1355 	 */
1356 	function setTAOAncestryAddress(address _taoAncestryAddress) public onlyTheAO {
1357 		require (_taoAncestryAddress != address(0));
1358 		taoAncestryAddress = _taoAncestryAddress;
1359 		_taoAncestry = ITAOAncestry(taoAncestryAddress);
1360 	}
1361 
1362 	/**
1363 	 * @dev The AO set settingTAOId (The TAO ID that holds the setting values)
1364 	 * @param _settingTAOId The address of settingTAOId
1365 	 */
1366 	function setSettingTAOId(address _settingTAOId) public onlyTheAO isTAO(_settingTAOId) {
1367 		settingTAOId = _settingTAOId;
1368 	}
1369 
1370 	/**
1371 	 * @dev The AO set the TAOPool Address
1372 	 * @param _taoPoolAddress The address of TAOPool
1373 	 */
1374 	function setTAOPoolAddress(address _taoPoolAddress) public onlyTheAO {
1375 		require (_taoPoolAddress != address(0));
1376 		taoPoolAddress = _taoPoolAddress;
1377 		_taoPool = ITAOPool(taoPoolAddress);
1378 	}
1379 
1380 	/***** PUBLIC METHODS *****/
1381 	/**
1382 	 * @dev Get the nonce given a TAO ID
1383 	 * @param _taoId The TAO ID to check
1384 	 * @return The nonce of the TAO
1385 	 */
1386 	function nonces(address _taoId) external view returns (uint256) {
1387 		return _nonces[_taoId];
1388 	}
1389 
1390 	/**
1391 	 * @dev Increment the nonce of a TAO
1392 	 * @param _taoId The ID of the TAO
1393 	 * @return current nonce
1394 	 */
1395 	function incrementNonce(address _taoId) external canUpdateNonce returns (uint256) {
1396 		// Check if _taoId exist
1397 		require (_nonces[_taoId] > 0);
1398 		_nonces[_taoId]++;
1399 		return _nonces[_taoId];
1400 	}
1401 
1402 	/**
1403 	 * @dev Name creates a TAO
1404 	 * @param _name The name of the TAO
1405 	 * @param _datHash The datHash of this TAO
1406 	 * @param _database The database for this TAO
1407 	 * @param _keyValue The key/value pair to be checked on the database
1408 	 * @param _contentId The contentId related to this TAO
1409 	 * @param _parentId The parent of this TAO (has to be a Name or TAO)
1410 	 * @param _childMinLogos The min required Logos to create a child from this TAO
1411 	 */
1412 	function createTAO(
1413 		string memory _name,
1414 		string memory _datHash,
1415 		string memory _database,
1416 		string memory _keyValue,
1417 		bytes32 _contentId,
1418 		address _parentId,
1419 		uint256 _childMinLogos,
1420 		bool _ethosCapStatus,
1421 		uint256 _ethosCapAmount
1422 	) public senderIsName senderNameNotCompromised isNameOrTAO(_parentId) {
1423 		require (bytes(_name).length > 0);
1424 		require (!_nameTAOLookup.isExist(_name));
1425 
1426 		uint256 _nameSumLogos = _logos.sumBalanceOf(_nameFactory.ethAddressToNameId(msg.sender));
1427 		if (AOLibrary.isTAO(_parentId)) {
1428 			(, uint256 _parentCreateChildTAOMinLogos,) = _taoAncestry.getAncestryById(_parentId);
1429 			require (_nameSumLogos >= _parentCreateChildTAOMinLogos);
1430 		} else {
1431 			require (_nameSumLogos >= _getCreateChildTAOMinLogos());
1432 		}
1433 
1434 		// Create the TAO
1435 		require (_createTAO(_name, _nameFactory.ethAddressToNameId(msg.sender), _datHash, _database, _keyValue, _contentId, _parentId, _childMinLogos, _ethosCapStatus, _ethosCapAmount));
1436 	}
1437 
1438 	/**
1439 	 * @dev Get TAO information
1440 	 * @param _taoId The ID of the TAO to be queried
1441 	 * @return The name of the TAO
1442 	 * @return The origin Name ID that created the TAO
1443 	 * @return The name of Name that created the TAO
1444 	 * @return The datHash of the TAO
1445 	 * @return The database of the TAO
1446 	 * @return The keyValue of the TAO
1447 	 * @return The contentId of the TAO
1448 	 * @return The typeId of the TAO
1449 	 */
1450 	function getTAO(address _taoId) public view returns (string memory, address, string memory, string memory, string memory, string memory, bytes32, uint8) {
1451 		TAO _tao = TAO(address(uint160(_taoId)));
1452 		return (
1453 			_tao.name(),
1454 			_tao.originId(),
1455 			Name(address(uint160(_tao.originId()))).name(),
1456 			_tao.datHash(),
1457 			_tao.database(),
1458 			_tao.keyValue(),
1459 			_tao.contentId(),
1460 			_tao.typeId()
1461 		);
1462 	}
1463 
1464 	/**
1465 	 * @dev Get total TAOs count
1466 	 * @return total TAOs count
1467 	 */
1468 	function getTotalTAOsCount() public view returns (uint256) {
1469 		return taos.length;
1470 	}
1471 
1472 	/**
1473 	 * @dev Get list of TAO IDs
1474 	 * @param _from The starting index
1475 	 * @param _to The ending index
1476 	 * @return list of TAO IDs
1477 	 */
1478 	function getTAOIds(uint256 _from, uint256 _to) public view returns (address[] memory) {
1479 		require (_from >= 0 && _to >= _from);
1480 		require (taos.length > 0);
1481 
1482 		address[] memory _taos = new address[](_to.sub(_from).add(1));
1483 		if (_to > taos.length.sub(1)) {
1484 			_to = taos.length.sub(1);
1485 		}
1486 		for (uint256 i = _from; i <= _to; i++) {
1487 			_taos[i.sub(_from)] = taos[i];
1488 		}
1489 		return _taos;
1490 	}
1491 
1492 	/**
1493 	 * @dev Check whether or not the signature is valid
1494 	 * @param _data The signed string data
1495 	 * @param _nonce The signed uint256 nonce (should be TAO's current nonce + 1)
1496 	 * @param _validateAddress The ETH address to be validated (optional)
1497 	 * @param _name The Name of the TAO
1498 	 * @param _signatureV The V part of the signature
1499 	 * @param _signatureR The R part of the signature
1500 	 * @param _signatureS The S part of the signature
1501 	 * @return true if valid. false otherwise
1502 	 * @return The name of the Name that created the signature
1503 	 * @return The Position of the Name that created the signature.
1504 	 *			0 == unknown. 1 == Advocate. 2 == Listener. 3 == Speaker
1505 	 */
1506 	function validateTAOSignature(
1507 		string memory _data,
1508 		uint256 _nonce,
1509 		address _validateAddress,
1510 		string memory _name,
1511 		uint8 _signatureV,
1512 		bytes32 _signatureR,
1513 		bytes32 _signatureS
1514 	) public isTAO(_getTAOIdByName(_name)) view returns (bool, string memory, uint256) {
1515 		address _signatureAddress = _getValidateSignatureAddress(_data, _nonce, _signatureV, _signatureR, _signatureS);
1516 		if (_isTAOSignatureAddressValid(_validateAddress, _signatureAddress, _getTAOIdByName(_name), _nonce)) {
1517 			return (true, Name(address(uint160(_nameFactory.ethAddressToNameId(_signatureAddress)))).name(), _nameTAOPosition.determinePosition(_signatureAddress, _getTAOIdByName(_name)));
1518 		} else {
1519 			return (false, "", 0);
1520 		}
1521 	}
1522 
1523 	/***** INTERNAL METHOD *****/
1524 	/**
1525 	 * @dev Actual creating the TAO
1526 	 * @param _name The name of the TAO
1527 	 * @param _nameId The ID of the Name that creates this TAO
1528 	 * @param _datHash The datHash of this TAO
1529 	 * @param _database The database for this TAO
1530 	 * @param _keyValue The key/value pair to be checked on the database
1531 	 * @param _contentId The contentId related to this TAO
1532 	 * @param _parentId The parent of this TAO (has to be a Name or TAO)
1533 	 * @param _childMinLogos The min required Logos to create a child from this TAO
1534 	 * @return true on success
1535 	 */
1536 	function _createTAO(
1537 		string memory _name,
1538 		address _nameId,
1539 		string memory _datHash,
1540 		string memory _database,
1541 		string memory _keyValue,
1542 		bytes32 _contentId,
1543 		address _parentId,
1544 		uint256 _childMinLogos,
1545 		bool _ethosCapStatus,
1546 		uint256 _ethosCapAmount
1547 	) internal returns (bool) {
1548 		// Create the TAO
1549 		address taoId = address(AOLibrary.deployTAO(_name, _nameId, _datHash, _database, _keyValue, _contentId, nameTAOVaultAddress));
1550 
1551 		// Increment the nonce
1552 		_nonces[taoId]++;
1553 
1554 		// Store the name lookup information
1555 		require (_nameTAOLookup.initialize(_name, taoId, 0, TAO(address(uint160(_parentId))).name(), _parentId, uint256(TAO(address(uint160(_parentId))).typeId())));
1556 
1557 		// Store the Advocate/Listener/Speaker information
1558 		require (_nameTAOPosition.initialize(taoId, _nameId, _nameId, _nameId));
1559 
1560 		// Store the "Ancestry" info of this TAO
1561 		require (_taoAncestry.initialize(taoId, _parentId, _childMinLogos));
1562 
1563 		// Creat a Pool so that public can stake Ethos/Pathos on it
1564 		require (_taoPool.createPool(taoId, _ethosCapStatus, _ethosCapAmount));
1565 
1566 		taos.push(taoId);
1567 
1568 		emit CreateTAO(_nameId, taoId, taos.length.sub(1), _name, _parentId, TAO(address(uint160(_parentId))).typeId());
1569 
1570 		if (AOLibrary.isTAO(_parentId)) {
1571 			require (_taoAncestry.addChild(_parentId, taoId));
1572 		}
1573 		return true;
1574 	}
1575 
1576 	/**
1577 	 * @dev Check whether or not the address recovered from the signature is valid
1578 	 * @param _validateAddress The ETH address to be validated (optional)
1579 	 * @param _signatureAddress The address recovered from the signature
1580 	 * @param _taoId The ID of the TAO
1581 	 * @param _nonce The signed uint256 nonce
1582 	 * @return true if valid. false otherwise
1583 	 */
1584 	function _isTAOSignatureAddressValid(
1585 		address _validateAddress,
1586 		address _signatureAddress,
1587 		address _taoId,
1588 		uint256 _nonce
1589 	) internal view returns (bool) {
1590 		if (_validateAddress != address(0)) {
1591 			return (_nonce == _nonces[_taoId].add(1) &&
1592 				_signatureAddress == _validateAddress &&
1593 				_nameTAOPosition.senderIsPosition(_validateAddress, _taoId)
1594 			);
1595 		} else {
1596 			return (
1597 				_nonce == _nonces[_taoId].add(1) &&
1598 				_nameTAOPosition.senderIsPosition(_signatureAddress, _taoId)
1599 			);
1600 		}
1601 	}
1602 
1603 	/**
1604 	 * @dev Internal function to get the TAO Id by name
1605 	 * @param _name The name of the TAO
1606 	 * @return the TAO ID
1607 	 */
1608 	function _getTAOIdByName(string memory _name) internal view returns (address) {
1609 		return _nameTAOLookup.getIdByName(_name);
1610 	}
1611 
1612 	/**
1613 	 * @dev Get createChildTAOMinLogos setting
1614 	 * @return createChildTAOMinLogos The minimum required Logos to create a TAO
1615 	 */
1616 	function _getCreateChildTAOMinLogos() internal view returns (uint256) {
1617 		(uint256 createChildTAOMinLogos,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'createChildTAOMinLogos');
1618 		return createChildTAOMinLogos;
1619 	}
1620 
1621 	/**
1622 	 * @dev Return the address that signed the data and nonce when validating signature
1623 	 * @param _data the data that was signed
1624 	 * @param _nonce The signed uint256 nonce
1625 	 * @param _v part of the signature
1626 	 * @param _r part of the signature
1627 	 * @param _s part of the signature
1628 	 * @return the address that signed the message
1629 	 */
1630 	function _getValidateSignatureAddress(string memory _data, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s) internal view returns (address) {
1631 		bytes32 _hash = keccak256(abi.encodePacked(address(this), _data, _nonce));
1632 		return ecrecover(_hash, _v, _r, _s);
1633 	}
1634 }