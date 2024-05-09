1 pragma solidity >=0.5.4 <0.6.0;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12 	/**
13 	 * @dev Multiplies two numbers, throws on overflow.
14 	 */
15 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16 		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17 		// benefit is lost if 'b' is also tested.
18 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19 		if (a == 0) {
20 			return 0;
21 		}
22 
23 		c = a * b;
24 		assert(c / a == b);
25 		return c;
26 	}
27 
28 	/**
29 	 * @dev Integer division of two numbers, truncating the quotient.
30 	 */
31 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
32 		// assert(b > 0); // Solidity automatically throws when dividing by 0
33 		// uint256 c = a / b;
34 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 		return a / b;
36 	}
37 
38 	/**
39 	 * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40 	 */
41 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42 		assert(b <= a);
43 		return a - b;
44 	}
45 
46 	/**
47 	 * @dev Adds two numbers, throws on overflow.
48 	 */
49 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50 		c = a + b;
51 		assert(c >= a);
52 		return c;
53 	}
54 }
55 
56 
57 interface INameTAOPosition {
58 	function senderIsAdvocate(address _sender, address _id) external view returns (bool);
59 	function senderIsListener(address _sender, address _id) external view returns (bool);
60 	function senderIsSpeaker(address _sender, address _id) external view returns (bool);
61 	function senderIsPosition(address _sender, address _id) external view returns (bool);
62 	function getAdvocate(address _id) external view returns (address);
63 	function nameIsAdvocate(address _nameId, address _id) external view returns (bool);
64 	function nameIsPosition(address _nameId, address _id) external view returns (bool);
65 	function initialize(address _id, address _advocateId, address _listenerId, address _speakerId) external returns (bool);
66 	function determinePosition(address _sender, address _id) external view returns (uint256);
67 }
68 
69 
70 interface INameFactory {
71 	function nonces(address _nameId) external view returns (uint256);
72 	function incrementNonce(address _nameId) external returns (uint256);
73 	function ethAddressToNameId(address _ethAddress) external view returns (address);
74 	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
75 	function nameIdToEthAddress(address _nameId) external view returns (address);
76 }
77 
78 
79 interface IAOEarning {
80 	function calculateEarning(bytes32 _purchaseReceiptId) external returns (bool);
81 
82 	function releaseEarning(bytes32 _purchaseReceiptId) external returns (bool);
83 
84 	function getTotalStakedContentEarning(bytes32 _stakedContentId) external view returns (uint256, uint256, uint256);
85 }
86 
87 
88 interface IAOContentHost {
89 	function create(address _host, bytes32 _stakedContentId, string calldata _encChallenge, string calldata _contentDatKey, string calldata _metadataDatKey) external returns (bool);
90 
91 	function getById(bytes32 _contentHostId) external view returns (bytes32, bytes32, address, string memory, string memory);
92 
93 	function contentHostPrice(bytes32 _contentHostId) external view returns (uint256);
94 
95 	function contentHostPaidByAO(bytes32 _contentHostId) external view returns (uint256);
96 
97 	function isExist(bytes32 _contentHostId) external view returns (bool);
98 }
99 
100 
101 interface IAOStakedContent {
102 	function getById(bytes32 _stakedContentId) external view returns (bytes32, address, uint256, uint256, uint256, uint256, bool, uint256);
103 
104 	function create(address _stakeOwner, bytes32 _contentId, uint256 _networkIntegerAmount, uint256 _networkFractionAmount, bytes8 _denomination, uint256 _primordialAmount, uint256 _profitPercentage) external returns (bytes32);
105 
106 	function isActive(bytes32 _stakedContentId) external view returns (bool);
107 }
108 
109 
110 interface IAOContent {
111 	function create(address _creator, string calldata _baseChallenge, uint256 _fileSize, bytes32 _contentUsageType, address _taoId) external returns (bytes32);
112 
113 	function isAOContentUsageType(bytes32 _contentId) external view returns (bool);
114 
115 	function getById(bytes32 _contentId) external view returns (address, uint256, bytes32, address, bytes32, uint8, bytes32, bytes32, string memory);
116 
117 	function getBaseChallenge(bytes32 _contentId) external view returns (string memory);
118 }
119 
120 
121 interface IAOTreasury {
122 	function toBase(uint256 integerAmount, uint256 fractionAmount, bytes8 denominationName) external view returns (uint256);
123 	function isDenominationExist(bytes8 denominationName) external view returns (bool);
124 }
125 
126 
127 interface IAOSetting {
128 	function getSettingValuesByTAOName(address _taoId, string calldata _settingName) external view returns (uint256, bool, address, bytes32, string memory);
129 	function getSettingTypes() external view returns (uint8, uint8, uint8, uint8, uint8);
130 
131 	function settingTypeLookup(uint256 _settingId) external view returns (uint8);
132 }
133 
134 
135 
136 
137 
138 
139 
140 
141 
142 
143 
144 
145 
146 contract TokenERC20 {
147 	// Public variables of the token
148 	string public name;
149 	string public symbol;
150 	uint8 public decimals = 18;
151 	// 18 decimals is the strongly suggested default, avoid changing it
152 	uint256 public totalSupply;
153 
154 	// This creates an array with all balances
155 	mapping (address => uint256) public balanceOf;
156 	mapping (address => mapping (address => uint256)) public allowance;
157 
158 	// This generates a public event on the blockchain that will notify clients
159 	event Transfer(address indexed from, address indexed to, uint256 value);
160 
161 	// This generates a public event on the blockchain that will notify clients
162 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
163 
164 	// This notifies clients about the amount burnt
165 	event Burn(address indexed from, uint256 value);
166 
167 	/**
168 	 * Constructor function
169 	 *
170 	 * Initializes contract with initial supply tokens to the creator of the contract
171 	 */
172 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
173 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
174 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
175 		name = tokenName;                                   // Set the name for display purposes
176 		symbol = tokenSymbol;                               // Set the symbol for display purposes
177 	}
178 
179 	/**
180 	 * Internal transfer, only can be called by this contract
181 	 */
182 	function _transfer(address _from, address _to, uint _value) internal {
183 		// Prevent transfer to 0x0 address. Use burn() instead
184 		require(_to != address(0));
185 		// Check if the sender has enough
186 		require(balanceOf[_from] >= _value);
187 		// Check for overflows
188 		require(balanceOf[_to] + _value > balanceOf[_to]);
189 		// Save this for an assertion in the future
190 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
191 		// Subtract from the sender
192 		balanceOf[_from] -= _value;
193 		// Add the same to the recipient
194 		balanceOf[_to] += _value;
195 		emit Transfer(_from, _to, _value);
196 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
197 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
198 	}
199 
200 	/**
201 	 * Transfer tokens
202 	 *
203 	 * Send `_value` tokens to `_to` from your account
204 	 *
205 	 * @param _to The address of the recipient
206 	 * @param _value the amount to send
207 	 */
208 	function transfer(address _to, uint256 _value) public returns (bool success) {
209 		_transfer(msg.sender, _to, _value);
210 		return true;
211 	}
212 
213 	/**
214 	 * Transfer tokens from other address
215 	 *
216 	 * Send `_value` tokens to `_to` in behalf of `_from`
217 	 *
218 	 * @param _from The address of the sender
219 	 * @param _to The address of the recipient
220 	 * @param _value the amount to send
221 	 */
222 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
223 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
224 		allowance[_from][msg.sender] -= _value;
225 		_transfer(_from, _to, _value);
226 		return true;
227 	}
228 
229 	/**
230 	 * Set allowance for other address
231 	 *
232 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
233 	 *
234 	 * @param _spender The address authorized to spend
235 	 * @param _value the max amount they can spend
236 	 */
237 	function approve(address _spender, uint256 _value) public returns (bool success) {
238 		allowance[msg.sender][_spender] = _value;
239 		emit Approval(msg.sender, _spender, _value);
240 		return true;
241 	}
242 
243 	/**
244 	 * Set allowance for other address and notify
245 	 *
246 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
247 	 *
248 	 * @param _spender The address authorized to spend
249 	 * @param _value the max amount they can spend
250 	 * @param _extraData some extra information to send to the approved contract
251 	 */
252 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
253 		tokenRecipient spender = tokenRecipient(_spender);
254 		if (approve(_spender, _value)) {
255 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
256 			return true;
257 		}
258 	}
259 
260 	/**
261 	 * Destroy tokens
262 	 *
263 	 * Remove `_value` tokens from the system irreversibly
264 	 *
265 	 * @param _value the amount of money to burn
266 	 */
267 	function burn(uint256 _value) public returns (bool success) {
268 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
269 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
270 		totalSupply -= _value;                      // Updates totalSupply
271 		emit Burn(msg.sender, _value);
272 		return true;
273 	}
274 
275 	/**
276 	 * Destroy tokens from other account
277 	 *
278 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
279 	 *
280 	 * @param _from the address of the sender
281 	 * @param _value the amount of money to burn
282 	 */
283 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
284 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
285 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
286 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
287 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
288 		totalSupply -= _value;                              // Update totalSupply
289 		emit Burn(_from, _value);
290 		return true;
291 	}
292 }
293 
294 
295 /**
296  * @title TAO
297  */
298 contract TAO {
299 	using SafeMath for uint256;
300 
301 	address public vaultAddress;
302 	string public name;				// the name for this TAO
303 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
304 
305 	// TAO's data
306 	string public datHash;
307 	string public database;
308 	string public keyValue;
309 	bytes32 public contentId;
310 
311 	/**
312 	 * 0 = TAO
313 	 * 1 = Name
314 	 */
315 	uint8 public typeId;
316 
317 	/**
318 	 * @dev Constructor function
319 	 */
320 	constructor (string memory _name,
321 		address _originId,
322 		string memory _datHash,
323 		string memory _database,
324 		string memory _keyValue,
325 		bytes32 _contentId,
326 		address _vaultAddress
327 	) public {
328 		name = _name;
329 		originId = _originId;
330 		datHash = _datHash;
331 		database = _database;
332 		keyValue = _keyValue;
333 		contentId = _contentId;
334 
335 		// Creating TAO
336 		typeId = 0;
337 
338 		vaultAddress = _vaultAddress;
339 	}
340 
341 	/**
342 	 * @dev Checks if calling address is Vault contract
343 	 */
344 	modifier onlyVault {
345 		require (msg.sender == vaultAddress);
346 		_;
347 	}
348 
349 	/**
350 	 * Will receive any ETH sent
351 	 */
352 	function () external payable {
353 	}
354 
355 	/**
356 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
357 	 * @param _recipient The recipient address
358 	 * @param _amount The amount to transfer
359 	 * @return true on success
360 	 */
361 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
362 		_recipient.transfer(_amount);
363 		return true;
364 	}
365 
366 	/**
367 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
368 	 * @param _erc20TokenAddress The address of ERC20 Token
369 	 * @param _recipient The recipient address
370 	 * @param _amount The amount to transfer
371 	 * @return true on success
372 	 */
373 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
374 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
375 		_erc20.transfer(_recipient, _amount);
376 		return true;
377 	}
378 }
379 
380 
381 
382 
383 /**
384  * @title Name
385  */
386 contract Name is TAO {
387 	/**
388 	 * @dev Constructor function
389 	 */
390 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
391 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
392 		// Creating Name
393 		typeId = 1;
394 	}
395 }
396 
397 
398 
399 
400 /**
401  * @title AOLibrary
402  */
403 library AOLibrary {
404 	using SafeMath for uint256;
405 
406 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
407 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
408 
409 	/**
410 	 * @dev Check whether or not the given TAO ID is a TAO
411 	 * @param _taoId The ID of the TAO
412 	 * @return true if yes. false otherwise
413 	 */
414 	function isTAO(address _taoId) public view returns (bool) {
415 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
416 	}
417 
418 	/**
419 	 * @dev Check whether or not the given Name ID is a Name
420 	 * @param _nameId The ID of the Name
421 	 * @return true if yes. false otherwise
422 	 */
423 	function isName(address _nameId) public view returns (bool) {
424 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
425 	}
426 
427 	/**
428 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
429 	 * @param _tokenAddress The ERC20 Token address to check
430 	 */
431 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
432 		if (_tokenAddress == address(0)) {
433 			return false;
434 		}
435 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
436 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
437 	}
438 
439 	/**
440 	 * @dev Checks if the calling contract address is The AO
441 	 *		OR
442 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
443 	 * @param _sender The address to check
444 	 * @param _theAO The AO address
445 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
446 	 * @return true if yes, false otherwise
447 	 */
448 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
449 		return (_sender == _theAO ||
450 			(
451 				(isTAO(_theAO) || isName(_theAO)) &&
452 				_nameTAOPositionAddress != address(0) &&
453 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
454 			)
455 		);
456 	}
457 
458 	/**
459 	 * @dev Return the divisor used to correctly calculate percentage.
460 	 *		Percentage stored throughout AO contracts covers 4 decimals,
461 	 *		so 1% is 10000, 1.25% is 12500, etc
462 	 */
463 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
464 		return _PERCENTAGE_DIVISOR;
465 	}
466 
467 	/**
468 	 * @dev Return the divisor used to correctly calculate multiplier.
469 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
470 	 *		so 1 is 1000000, 0.023 is 23000, etc
471 	 */
472 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
473 		return _MULTIPLIER_DIVISOR;
474 	}
475 
476 	/**
477 	 * @dev deploy a TAO
478 	 * @param _name The name of the TAO
479 	 * @param _originId The Name ID the creates the TAO
480 	 * @param _datHash The datHash of this TAO
481 	 * @param _database The database for this TAO
482 	 * @param _keyValue The key/value pair to be checked on the database
483 	 * @param _contentId The contentId related to this TAO
484 	 * @param _nameTAOVaultAddress The address of NameTAOVault
485 	 */
486 	function deployTAO(string memory _name,
487 		address _originId,
488 		string memory _datHash,
489 		string memory _database,
490 		string memory _keyValue,
491 		bytes32 _contentId,
492 		address _nameTAOVaultAddress
493 		) public returns (TAO _tao) {
494 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
495 	}
496 
497 	/**
498 	 * @dev deploy a Name
499 	 * @param _name The name of the Name
500 	 * @param _originId The eth address the creates the Name
501 	 * @param _datHash The datHash of this Name
502 	 * @param _database The database for this Name
503 	 * @param _keyValue The key/value pair to be checked on the database
504 	 * @param _contentId The contentId related to this Name
505 	 * @param _nameTAOVaultAddress The address of NameTAOVault
506 	 */
507 	function deployName(string memory _name,
508 		address _originId,
509 		string memory _datHash,
510 		string memory _database,
511 		string memory _keyValue,
512 		bytes32 _contentId,
513 		address _nameTAOVaultAddress
514 		) public returns (Name _myName) {
515 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
516 	}
517 
518 	/**
519 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
520 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
521 	 * @param _currentPrimordialBalance Account's current primordial ion balance
522 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
523 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
524 	 * @return the new primordial weighted multiplier
525 	 */
526 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
527 		if (_currentWeightedMultiplier > 0) {
528 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
529 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
530 			return _totalWeightedIons.div(_totalIons);
531 		} else {
532 			return _additionalWeightedMultiplier;
533 		}
534 	}
535 
536 	/**
537 	 * @dev Calculate the primordial ion multiplier on a given lot
538 	 *		Total Primordial Mintable = T
539 	 *		Total Primordial Minted = M
540 	 *		Starting Multiplier = S
541 	 *		Ending Multiplier = E
542 	 *		To Purchase = P
543 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
544 	 *
545 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
546 	 * @param _totalPrimordialMintable Total Primordial ion mintable
547 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
548 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
549 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
550 	 * @return The multiplier in (10 ** 6)
551 	 */
552 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
553 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
554 			/**
555 			 * Let temp = M + (P/2)
556 			 * Multiplier = (1 - (temp / T)) x (S-E)
557 			 */
558 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
559 
560 			/**
561 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
562 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
563 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
564 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
565 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
566 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
567 			 */
568 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
569 			/**
570 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
571 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
572 			 */
573 			return multiplier.div(_MULTIPLIER_DIVISOR);
574 		} else {
575 			return 0;
576 		}
577 	}
578 
579 	/**
580 	 * @dev Calculate the bonus percentage of network ion on a given lot
581 	 *		Total Primordial Mintable = T
582 	 *		Total Primordial Minted = M
583 	 *		Starting Network Bonus Multiplier = Bs
584 	 *		Ending Network Bonus Multiplier = Be
585 	 *		To Purchase = P
586 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
587 	 *
588 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
589 	 * @param _totalPrimordialMintable Total Primordial ion intable
590 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
591 	 * @param _startingMultiplier The starting Network ion bonus multiplier
592 	 * @param _endingMultiplier The ending Network ion bonus multiplier
593 	 * @return The bonus percentage
594 	 */
595 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
596 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
597 			/**
598 			 * Let temp = M + (P/2)
599 			 * B% = (1 - (temp / T)) x (Bs-Be)
600 			 */
601 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
602 
603 			/**
604 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
605 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
606 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
607 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
608 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
609 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
610 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
611 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
612 			 */
613 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
614 			return bonusPercentage;
615 		} else {
616 			return 0;
617 		}
618 	}
619 
620 	/**
621 	 * @dev Calculate the bonus amount of network ion on a given lot
622 	 *		AO Bonus Amount = B% x P
623 	 *
624 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
625 	 * @param _totalPrimordialMintable Total Primordial ion intable
626 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
627 	 * @param _startingMultiplier The starting Network ion bonus multiplier
628 	 * @param _endingMultiplier The ending Network ion bonus multiplier
629 	 * @return The bonus percentage
630 	 */
631 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
632 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
633 		/**
634 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
635 		 * when calculating the network ion bonus amount
636 		 */
637 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
638 		return networkBonus;
639 	}
640 
641 	/**
642 	 * @dev Calculate the maximum amount of Primordial an account can burn
643 	 *		_primordialBalance = P
644 	 *		_currentWeightedMultiplier = M
645 	 *		_maximumMultiplier = S
646 	 *		_amountToBurn = B
647 	 *		B = ((S x P) - (P x M)) / S
648 	 *
649 	 * @param _primordialBalance Account's primordial ion balance
650 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
651 	 * @param _maximumMultiplier The maximum multiplier of this account
652 	 * @return The maximum burn amount
653 	 */
654 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
655 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
656 	}
657 
658 	/**
659 	 * @dev Calculate the new multiplier after burning primordial ion
660 	 *		_primordialBalance = P
661 	 *		_currentWeightedMultiplier = M
662 	 *		_amountToBurn = B
663 	 *		_newMultiplier = E
664 	 *		E = (P x M) / (P - B)
665 	 *
666 	 * @param _primordialBalance Account's primordial ion balance
667 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
668 	 * @param _amountToBurn The amount of primordial ion to burn
669 	 * @return The new multiplier
670 	 */
671 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
672 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
673 	}
674 
675 	/**
676 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
677 	 *		_primordialBalance = P
678 	 *		_currentWeightedMultiplier = M
679 	 *		_amountToConvert = C
680 	 *		_newMultiplier = E
681 	 *		E = (P x M) / (P + C)
682 	 *
683 	 * @param _primordialBalance Account's primordial ion balance
684 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
685 	 * @param _amountToConvert The amount of network ion to convert
686 	 * @return The new multiplier
687 	 */
688 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
689 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
690 	}
691 
692 	/**
693 	 * @dev count num of digits
694 	 * @param number uint256 of the nuumber to be checked
695 	 * @return uint8 num of digits
696 	 */
697 	function numDigits(uint256 number) public pure returns (uint8) {
698 		uint8 digits = 0;
699 		while(number != 0) {
700 			number = number.div(10);
701 			digits++;
702 		}
703 		return digits;
704 	}
705 }
706 
707 
708 
709 contract TheAO {
710 	address public theAO;
711 	address public nameTAOPositionAddress;
712 
713 	// Check whether an address is whitelisted and granted access to transact
714 	// on behalf of others
715 	mapping (address => bool) public whitelist;
716 
717 	constructor() public {
718 		theAO = msg.sender;
719 	}
720 
721 	/**
722 	 * @dev Checks if msg.sender is in whitelist.
723 	 */
724 	modifier inWhitelist() {
725 		require (whitelist[msg.sender] == true);
726 		_;
727 	}
728 
729 	/**
730 	 * @dev Transfer ownership of The AO to new address
731 	 * @param _theAO The new address to be transferred
732 	 */
733 	function transferOwnership(address _theAO) public {
734 		require (msg.sender == theAO);
735 		require (_theAO != address(0));
736 		theAO = _theAO;
737 	}
738 
739 	/**
740 	 * @dev Whitelist `_account` address to transact on behalf of others
741 	 * @param _account The address to whitelist
742 	 * @param _whitelist Either to whitelist or not
743 	 */
744 	function setWhitelist(address _account, bool _whitelist) public {
745 		require (msg.sender == theAO);
746 		require (_account != address(0));
747 		whitelist[_account] = _whitelist;
748 	}
749 }
750 
751 
752 
753 
754 
755 
756 
757 
758 
759 
760 /**
761  * @title AOContentFactory
762  *
763  * The purpose of this contract is to allow content creator to stake network AO ions and/or primordial AO+ ions
764  * on his/her content
765  */
766 contract AOContentFactory is TheAO {
767 	using SafeMath for uint256;
768 
769 	address public settingTAOId;
770 	address public aoSettingAddress;
771 	address public aoTreasuryAddress;
772 	address public aoContentAddress;
773 	address public aoStakedContentAddress;
774 	address public aoContentHostAddress;
775 	address public aoEarningAddress;
776 	address public nameFactoryAddress;
777 
778 	IAOSetting internal _aoSetting;
779 	IAOTreasury internal _aoTreasury;
780 	IAOContent internal _aoContent;
781 	IAOStakedContent internal _aoStakedContent;
782 	IAOContentHost internal _aoContentHost;
783 	IAOEarning internal _aoEarning;
784 	INameFactory internal _nameFactory;
785 	INameTAOPosition internal _nameTAOPosition;
786 
787 	/**
788 	 * @dev Constructor function
789 	 * @param _settingTAOId The TAO ID that controls the setting
790 	 * @param _aoSettingAddress The address of AOSetting
791 	 * @param _aoTreasuryAddress The address of AOTreasury
792 	 * @param _aoContentAddress The address of AOContent
793 	 * @param _aoStakedContentAddress The address of AOStakedContent
794 	 * @param _aoContentHostAddress The address of AOContentHost
795 	 * @param _aoEarningAddress The address of AOEarning
796 	 * @param _nameFactoryAddress The address of NameFactory
797 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
798 	 */
799 	constructor(address _settingTAOId,
800 		address _aoSettingAddress,
801 		address _aoTreasuryAddress,
802 		address _aoContentAddress,
803 		address _aoStakedContentAddress,
804 		address _aoContentHostAddress,
805 		address _aoEarningAddress,
806 		address _nameFactoryAddress,
807 		address _nameTAOPositionAddress
808 		) public {
809 		setSettingTAOId(_settingTAOId);
810 		setAOSettingAddress(_aoSettingAddress);
811 		setAOTreasuryAddress(_aoTreasuryAddress);
812 		setAOContentAddress(_aoContentAddress);
813 		setAOStakedContentAddress(_aoStakedContentAddress);
814 		setAOContentHostAddress(_aoContentHostAddress);
815 		setAOEarningAddress(_aoEarningAddress);
816 		setNameFactoryAddress(_nameFactoryAddress);
817 		setNameTAOPositionAddress(_nameTAOPositionAddress);
818 	}
819 
820 	/**
821 	 * @dev Checks if the calling contract address is The AO
822 	 *		OR
823 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
824 	 */
825 	modifier onlyTheAO {
826 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
827 		_;
828 	}
829 
830 	/***** The AO ONLY METHODS *****/
831 	/**
832 	 * @dev Transfer ownership of The AO to new address
833 	 * @param _theAO The new address to be transferred
834 	 */
835 	function transferOwnership(address _theAO) public onlyTheAO {
836 		require (_theAO != address(0));
837 		theAO = _theAO;
838 	}
839 
840 	/**
841 	 * @dev Whitelist `_account` address to transact on behalf of others
842 	 * @param _account The address to whitelist
843 	 * @param _whitelist Either to whitelist or not
844 	 */
845 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
846 		require (_account != address(0));
847 		whitelist[_account] = _whitelist;
848 	}
849 
850 	/**
851 	 * @dev The AO sets setting TAO ID
852 	 * @param _settingTAOId The new setting TAO ID to set
853 	 */
854 	function setSettingTAOId(address _settingTAOId) public onlyTheAO {
855 		require (AOLibrary.isTAO(_settingTAOId));
856 		settingTAOId = _settingTAOId;
857 	}
858 
859 	/**
860 	 * @dev The AO sets AO Setting address
861 	 * @param _aoSettingAddress The address of AOSetting
862 	 */
863 	function setAOSettingAddress(address _aoSettingAddress) public onlyTheAO {
864 		require (_aoSettingAddress != address(0));
865 		aoSettingAddress = _aoSettingAddress;
866 		_aoSetting = IAOSetting(_aoSettingAddress);
867 	}
868 
869 	/**
870 	 * @dev The AO sets AO Treasury address
871 	 * @param _aoTreasuryAddress The address of AOTreasury
872 	 */
873 	function setAOTreasuryAddress(address _aoTreasuryAddress) public onlyTheAO {
874 		require (_aoTreasuryAddress != address(0));
875 		aoTreasuryAddress = _aoTreasuryAddress;
876 		_aoTreasury = IAOTreasury(_aoTreasuryAddress);
877 	}
878 
879 	/**
880 	 * @dev The AO sets AOContent address
881 	 * @param _aoContentAddress The address of AOContent
882 	 */
883 	function setAOContentAddress(address _aoContentAddress) public onlyTheAO {
884 		require (_aoContentAddress != address(0));
885 		aoContentAddress = _aoContentAddress;
886 		_aoContent = IAOContent(_aoContentAddress);
887 	}
888 
889 	/**
890 	 * @dev The AO sets AOStakedContent address
891 	 * @param _aoStakedContentAddress The address of AOStakedContent
892 	 */
893 	function setAOStakedContentAddress(address _aoStakedContentAddress) public onlyTheAO {
894 		require (_aoStakedContentAddress != address(0));
895 		aoStakedContentAddress = _aoStakedContentAddress;
896 		_aoStakedContent = IAOStakedContent(_aoStakedContentAddress);
897 	}
898 
899 	/**
900 	 * @dev The AO sets AOContentHost address
901 	 * @param _aoContentHostAddress The address of AOContentHost
902 	 */
903 	function setAOContentHostAddress(address _aoContentHostAddress) public onlyTheAO {
904 		require (_aoContentHostAddress != address(0));
905 		aoContentHostAddress = _aoContentHostAddress;
906 		_aoContentHost = IAOContentHost(_aoContentHostAddress);
907 	}
908 
909 	/**
910 	 * @dev The AO sets AOEarning address
911 	 * @param _aoEarningAddress The address of AOEarning
912 	 */
913 	function setAOEarningAddress(address _aoEarningAddress) public onlyTheAO {
914 		require (_aoEarningAddress != address(0));
915 		aoEarningAddress = _aoEarningAddress;
916 		_aoEarning = IAOEarning(_aoEarningAddress);
917 	}
918 
919 	/**
920 	 * @dev The AO sets NameFactory address
921 	 * @param _nameFactoryAddress The address of NameFactory
922 	 */
923 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
924 		require (_nameFactoryAddress != address(0));
925 		nameFactoryAddress = _nameFactoryAddress;
926 		_nameFactory = INameFactory(_nameFactoryAddress);
927 	}
928 
929 	/**
930 	 * @dev The AO sets NameTAOPosition address
931 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
932 	 */
933 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
934 		require (_nameTAOPositionAddress != address(0));
935 		nameTAOPositionAddress = _nameTAOPositionAddress;
936 		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
937 	}
938 
939 	/***** PUBLIC METHODS *****/
940 	/**
941 	 * @dev Stake `_networkIntegerAmount` + `_networkFractionAmount` of network ion in `_denomination` and/or `_primordialAmount` primordial ion for an AO Content
942 	 * @param _networkIntegerAmount The integer amount of network ion to stake
943 	 * @param _networkFractionAmount The fraction amount of network ion to stake
944 	 * @param _denomination The denomination of the network ion, i.e ao, kilo, mega, etc.
945 	 * @param _primordialAmount The amount of primordial ion to stake
946 	 * @param _baseChallenge The base challenge string (PUBLIC KEY) of the content
947 	 * @param _encChallenge The encrypted challenge string (PUBLIC KEY) of the content unique to the host
948 	 * @param _contentDatKey The dat key of the content
949 	 * @param _metadataDatKey The dat key of the content's metadata
950 	 * @param _fileSize The size of the file
951 	 * @param _profitPercentage The percentage of profit the stake owner's media will charge
952 	 */
953 	function stakeAOContent(
954 		uint256 _networkIntegerAmount,
955 		uint256 _networkFractionAmount,
956 		bytes8 _denomination,
957 		uint256 _primordialAmount,
958 		string memory _baseChallenge,
959 		string memory _encChallenge,
960 		string memory _contentDatKey,
961 		string memory _metadataDatKey,
962 		uint256 _fileSize,
963 		uint256 _profitPercentage
964 		) public {
965 		/**
966 		 * 1. Store this content
967 		 * 2. Stake the network/primordial ion on content
968 		 * 3. Add the node info that hosts this content (in this case the creator himself)
969 		 */
970 		require (
971 			_hostContent(
972 				msg.sender,
973 				_stakeContent(
974 					msg.sender,
975 					_storeContent(
976 						msg.sender,
977 						_baseChallenge,
978 						_fileSize,
979 						_contentUsageType_aoContent(),
980 						address(0)
981 					),
982 					_networkIntegerAmount,
983 					_networkFractionAmount,
984 					_denomination,
985 					_primordialAmount,
986 					_profitPercentage
987 				),
988 				_encChallenge,
989 				_contentDatKey,
990 				_metadataDatKey
991 			)
992 		);
993 	}
994 
995 	/**
996 	 * @dev Stake `_networkIntegerAmount` + `_networkFractionAmount` of network ion in `_denomination` and/or `_primordialAmount` primordial ion for a Creative Commons Content
997 	 * @param _networkIntegerAmount The integer amount of network on to stake
998 	 * @param _networkFractionAmount The fraction amount of network ion to stake
999 	 * @param _denomination The denomination of the network ion, i.e ao, kilo, mega, etc.
1000 	 * @param _primordialAmount The amount of primordial ion to stake
1001 	 * @param _baseChallenge The base challenge string (PUBLIC KEY) of the content
1002 	 * @param _encChallenge The encrypted challenge string (PUBLIC KEY) of the content unique to the host
1003 	 * @param _contentDatKey The dat key of the content
1004 	 * @param _metadataDatKey The dat key of the content's metadata
1005 	 * @param _fileSize The size of the file
1006 	 */
1007 	function stakeCreativeCommonsContent(
1008 		uint256 _networkIntegerAmount,
1009 		uint256 _networkFractionAmount,
1010 		bytes8 _denomination,
1011 		uint256 _primordialAmount,
1012 		string memory _baseChallenge,
1013 		string memory _encChallenge,
1014 		string memory _contentDatKey,
1015 		string memory _metadataDatKey,
1016 		uint256 _fileSize
1017 		) public {
1018 		/**
1019 		 * 1. Store this content
1020 		 * 2. Stake the network/primordial ion on content
1021 		 * 3. Add the node info that hosts this content (in this case the creator himself)
1022 		 */
1023 		require (
1024 			_hostContent(
1025 				msg.sender,
1026 				_stakeContent(
1027 					msg.sender,
1028 					_storeContent(
1029 						msg.sender,
1030 						_baseChallenge,
1031 						_fileSize,
1032 						_contentUsageType_creativeCommons(),
1033 						address(0)
1034 					),
1035 					_networkIntegerAmount,
1036 					_networkFractionAmount,
1037 					_denomination,
1038 					_primordialAmount,
1039 					0
1040 				),
1041 				_encChallenge,
1042 				_contentDatKey,
1043 				_metadataDatKey
1044 			)
1045 		);
1046 	}
1047 
1048 	/**
1049 	 * @dev Stake `_networkIntegerAmount` + `_networkFractionAmount` of network ion in `_denomination` and/or `_primordialAmount` primordial ion for a T(AO) Content
1050 	 * @param _networkIntegerAmount The integer amount of network ion to stake
1051 	 * @param _networkFractionAmount The fraction amount of network ion to stake
1052 	 * @param _denomination The denomination of the network ion, i.e ao, kilo, mega, etc.
1053 	 * @param _primordialAmount The amount of primordial ion to stake
1054 	 * @param _baseChallenge The base challenge string (PUBLIC KEY) of the content
1055 	 * @param _encChallenge The encrypted challenge string (PUBLIC KEY) of the content unique to the host
1056 	 * @param _contentDatKey The dat key of the content
1057 	 * @param _metadataDatKey The dat key of the content's metadata
1058 	 * @param _fileSize The size of the file
1059 	 * @param _taoId The TAO (TAO) ID for this content (if this is a T(AO) Content)
1060 	 */
1061 	function stakeTAOContent(
1062 		uint256 _networkIntegerAmount,
1063 		uint256 _networkFractionAmount,
1064 		bytes8 _denomination,
1065 		uint256 _primordialAmount,
1066 		string memory _baseChallenge,
1067 		string memory _encChallenge,
1068 		string memory _contentDatKey,
1069 		string memory _metadataDatKey,
1070 		uint256 _fileSize,
1071 		address _taoId
1072 		) public {
1073 		/**
1074 		 * 1. Store this content
1075 		 * 2. Stake the network/primordial ion on content
1076 		 * 3. Add the node info that hosts this content (in this case the creator himself)
1077 		 */
1078 		require (
1079 			_hostContent(
1080 				msg.sender,
1081 				_stakeContent(
1082 					msg.sender,
1083 					_storeContent(
1084 						msg.sender,
1085 						_baseChallenge,
1086 						_fileSize,
1087 						_contentUsageType_taoContent(),
1088 						_taoId
1089 					),
1090 					_networkIntegerAmount,
1091 					_networkFractionAmount,
1092 					_denomination,
1093 					_primordialAmount,
1094 					0
1095 				),
1096 				_encChallenge,
1097 				_contentDatKey,
1098 				_metadataDatKey
1099 			)
1100 		);
1101 	}
1102 
1103 	/**
1104 	 * @dev Return the staking information of a StakedContent ID
1105 	 * @param _stakedContentId The ID of the staked content
1106 	 * @return the network base ion amount staked for this content
1107 	 * @return the primordial ion amount staked for this content
1108 	 * @return the primordial weighted multiplier of the staked content
1109 	 */
1110 	function getStakingMetrics(bytes32 _stakedContentId) public view returns (uint256, uint256, uint256) {
1111 		(,, uint256 networkAmount, uint256 primordialAmount, uint256 primordialWeightedMultiplier,,,) = _aoStakedContent.getById(_stakedContentId);
1112 		return (
1113 			networkAmount,
1114 			primordialAmount,
1115 			primordialWeightedMultiplier
1116 		);
1117 	}
1118 
1119 	/**
1120 	 * @dev Return the earning information of a StakedContent ID
1121 	 * @param _stakedContentId The ID of the staked content
1122 	 * @return the total earning from staking this content
1123 	 * @return the total earning from hosting this content
1124 	 * @return the total The AO earning of this content
1125 	 */
1126 	function getEarningMetrics(bytes32 _stakedContentId) public view returns (uint256, uint256, uint256) {
1127 		return _aoEarning.getTotalStakedContentEarning(_stakedContentId);
1128 	}
1129 
1130 	/**
1131 	 * @dev Return the staking and earning information of a StakedContent ID
1132 	 * @param _stakedContentId The ID of the staked content
1133 	 * @return the network base ion amount staked for this content
1134 	 * @return the primordial ion amount staked for this content
1135 	 * @return the primordial weighted multiplier of the staked content
1136 	 * @return the total earning from staking this content
1137 	 * @return the total earning from hosting this content
1138 	 * @return the total The AO earning of this content
1139 	 */
1140 	function getContentMetrics(bytes32 _stakedContentId) public view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1141 		(uint256 networkAmount, uint256 primordialAmount, uint256 primordialWeightedMultiplier) = getStakingMetrics(_stakedContentId);
1142 		(uint256 totalStakeEarning, uint256 totalHostEarning, uint256 totalTheAOEarning) = getEarningMetrics(_stakedContentId);
1143 		return (
1144 			networkAmount,
1145 			primordialAmount,
1146 			primordialWeightedMultiplier,
1147 			totalStakeEarning,
1148 			totalHostEarning,
1149 			totalTheAOEarning
1150 		);
1151 	}
1152 
1153 	/***** INTERNAL METHODS *****/
1154 	/**
1155 	 * @dev Get Content Usage Type = AO Content setting
1156 	 * @return contentUsageType_aoContent Content Usage Type = AO Content
1157 	 */
1158 	function _contentUsageType_aoContent() internal view returns (bytes32) {
1159 		(,,,bytes32 contentUsageType_aoContent,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'contentUsageType_aoContent');
1160 		return contentUsageType_aoContent;
1161 	}
1162 
1163 	/**
1164 	 * @dev Get Content Usage Type = Creative Commons setting
1165 	 * @return contentUsageType_creativeCommons Content Usage Type = Creative Commons
1166 	 */
1167 	function _contentUsageType_creativeCommons() internal view returns (bytes32) {
1168 		(,,,bytes32 contentUsageType_creativeCommons,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'contentUsageType_creativeCommons');
1169 		return contentUsageType_creativeCommons;
1170 	}
1171 
1172 	/**
1173 	 * @dev Get Content Usage Type = TAO Content setting
1174 	 * @return contentUsageType_taoContent Content Usage Type = T(AO) Content
1175 	 */
1176 	function _contentUsageType_taoContent() internal view returns (bytes32) {
1177 		(,,,bytes32 contentUsageType_taoContent,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'contentUsageType_taoContent');
1178 		return contentUsageType_taoContent;
1179 	}
1180 
1181 	/**
1182 	 * @dev Store the content information (content creation during staking)
1183 	 * @param _creator the address of the content creator
1184 	 * @param _baseChallenge The base challenge string (PUBLIC KEY) of the content
1185 	 * @param _fileSize The size of the file
1186 	 * @param _contentUsageType The content usage type, i.e AO Content, Creative Commons, or T(AO) Content
1187 	 * @param _taoId The TAO (TAO) ID for this content (if this is a T(AO) Content)
1188 	 * @return the ID of the content
1189 	 */
1190 	function _storeContent(address _creator,
1191 		string memory _baseChallenge,
1192 		uint256 _fileSize,
1193 		bytes32 _contentUsageType,
1194 		address _taoId
1195 		) internal returns (bytes32) {
1196 		address _creatorNameId = _nameFactory.ethAddressToNameId(_creator);
1197 		require (_creatorNameId != address(0));
1198 		return _aoContent.create(_creatorNameId, _baseChallenge, _fileSize, _contentUsageType, _taoId);
1199 	}
1200 
1201 	/**
1202 	 * @dev Actual staking the content
1203 	 * @param _stakeOwner the address that stake the content
1204 	 * @param _contentId The ID of the content
1205 	 * @param _networkIntegerAmount The integer amount of network ion to stake
1206 	 * @param _networkFractionAmount The fraction amount of network ion to stake
1207 	 * @param _denomination The denomination of the network ion, i.e ao, kilo, mega, etc.
1208 	 * @param _primordialAmount The amount of primordial ion to stake
1209 	 * @param _profitPercentage The percentage of profit the stake owner's media will charge
1210 	 * @return the newly created staked content ID
1211 	 */
1212 	function _stakeContent(address _stakeOwner,
1213 		bytes32 _contentId,
1214 		uint256 _networkIntegerAmount,
1215 		uint256 _networkFractionAmount,
1216 		bytes8 _denomination,
1217 		uint256 _primordialAmount,
1218 		uint256 _profitPercentage
1219 		) internal returns (bytes32) {
1220 		address _stakeOwnerNameId = _nameFactory.ethAddressToNameId(_stakeOwner);
1221 		require (_stakeOwnerNameId != address(0));
1222 		return _aoStakedContent.create(_stakeOwnerNameId, _contentId, _networkIntegerAmount, _networkFractionAmount, _denomination, _primordialAmount, _profitPercentage);
1223 	}
1224 
1225 	/**
1226 	 * @dev Add the distribution node info that hosts the content
1227 	 * @param _host the address of the host
1228 	 * @param _stakedContentId The ID of the staked content
1229 	 * @param _encChallenge The encrypted challenge string (PUBLIC KEY) of the content unique to the host
1230 	 * @param _contentDatKey The dat key of the content
1231 	 * @param _metadataDatKey The dat key of the content's metadata
1232 	 * @return true on success
1233 	 */
1234 	function _hostContent(address _host, bytes32 _stakedContentId, string memory _encChallenge, string memory _contentDatKey, string memory _metadataDatKey) internal returns (bool) {
1235 		address _hostNameId = _nameFactory.ethAddressToNameId(_host);
1236 		require (_hostNameId != address(0));
1237 		return _aoContentHost.create(_hostNameId, _stakedContentId, _encChallenge, _contentDatKey, _metadataDatKey);
1238 	}
1239 }