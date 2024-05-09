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
88 interface IAOTreasury {
89 	function toBase(uint256 integerAmount, uint256 fractionAmount, bytes8 denominationName) external view returns (uint256);
90 	function isDenominationExist(bytes8 denominationName) external view returns (bool);
91 }
92 
93 
94 interface IAOContentHost {
95 	function create(address _host, bytes32 _stakedContentId, string calldata _encChallenge, string calldata _contentDatKey, string calldata _metadataDatKey) external returns (bool);
96 
97 	function getById(bytes32 _contentHostId) external view returns (bytes32, bytes32, address, string memory, string memory);
98 
99 	function contentHostPrice(bytes32 _contentHostId) external view returns (uint256);
100 
101 	function contentHostPaidByAO(bytes32 _contentHostId) external view returns (uint256);
102 
103 	function isExist(bytes32 _contentHostId) external view returns (bool);
104 }
105 
106 
107 interface IAOStakedContent {
108 	function getById(bytes32 _stakedContentId) external view returns (bytes32, address, uint256, uint256, uint256, uint256, bool, uint256);
109 
110 	function create(address _stakeOwner, bytes32 _contentId, uint256 _networkIntegerAmount, uint256 _networkFractionAmount, bytes8 _denomination, uint256 _primordialAmount, uint256 _profitPercentage) external returns (bytes32);
111 
112 	function isActive(bytes32 _stakedContentId) external view returns (bool);
113 }
114 
115 
116 interface IAOContent {
117 	function create(address _creator, string calldata _baseChallenge, uint256 _fileSize, bytes32 _contentUsageType, address _taoId) external returns (bytes32);
118 
119 	function isAOContentUsageType(bytes32 _contentId) external view returns (bool);
120 
121 	function getById(bytes32 _contentId) external view returns (address, uint256, bytes32, address, bytes32, uint8, bytes32, bytes32, string memory);
122 
123 	function getBaseChallenge(bytes32 _contentId) external view returns (string memory);
124 }
125 
126 
127 interface IAOPurchaseReceipt {
128 	function senderIsBuyer(bytes32 _purchaseReceiptId, address _sender) external view returns (bool);
129 
130 	function getById(bytes32 _purchaseReceiptId) external view returns (bytes32, bytes32, bytes32, address, uint256, uint256, uint256, string memory, address, uint256);
131 
132 	function isExist(bytes32 _purchaseReceiptId) external view returns (bool);
133 }
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
146 
147 contract TokenERC20 {
148 	// Public variables of the token
149 	string public name;
150 	string public symbol;
151 	uint8 public decimals = 18;
152 	// 18 decimals is the strongly suggested default, avoid changing it
153 	uint256 public totalSupply;
154 
155 	// This creates an array with all balances
156 	mapping (address => uint256) public balanceOf;
157 	mapping (address => mapping (address => uint256)) public allowance;
158 
159 	// This generates a public event on the blockchain that will notify clients
160 	event Transfer(address indexed from, address indexed to, uint256 value);
161 
162 	// This generates a public event on the blockchain that will notify clients
163 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
164 
165 	// This notifies clients about the amount burnt
166 	event Burn(address indexed from, uint256 value);
167 
168 	/**
169 	 * Constructor function
170 	 *
171 	 * Initializes contract with initial supply tokens to the creator of the contract
172 	 */
173 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
174 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
175 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
176 		name = tokenName;                                   // Set the name for display purposes
177 		symbol = tokenSymbol;                               // Set the symbol for display purposes
178 	}
179 
180 	/**
181 	 * Internal transfer, only can be called by this contract
182 	 */
183 	function _transfer(address _from, address _to, uint _value) internal {
184 		// Prevent transfer to 0x0 address. Use burn() instead
185 		require(_to != address(0));
186 		// Check if the sender has enough
187 		require(balanceOf[_from] >= _value);
188 		// Check for overflows
189 		require(balanceOf[_to] + _value > balanceOf[_to]);
190 		// Save this for an assertion in the future
191 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
192 		// Subtract from the sender
193 		balanceOf[_from] -= _value;
194 		// Add the same to the recipient
195 		balanceOf[_to] += _value;
196 		emit Transfer(_from, _to, _value);
197 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
198 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
199 	}
200 
201 	/**
202 	 * Transfer tokens
203 	 *
204 	 * Send `_value` tokens to `_to` from your account
205 	 *
206 	 * @param _to The address of the recipient
207 	 * @param _value the amount to send
208 	 */
209 	function transfer(address _to, uint256 _value) public returns (bool success) {
210 		_transfer(msg.sender, _to, _value);
211 		return true;
212 	}
213 
214 	/**
215 	 * Transfer tokens from other address
216 	 *
217 	 * Send `_value` tokens to `_to` in behalf of `_from`
218 	 *
219 	 * @param _from The address of the sender
220 	 * @param _to The address of the recipient
221 	 * @param _value the amount to send
222 	 */
223 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
224 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
225 		allowance[_from][msg.sender] -= _value;
226 		_transfer(_from, _to, _value);
227 		return true;
228 	}
229 
230 	/**
231 	 * Set allowance for other address
232 	 *
233 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
234 	 *
235 	 * @param _spender The address authorized to spend
236 	 * @param _value the max amount they can spend
237 	 */
238 	function approve(address _spender, uint256 _value) public returns (bool success) {
239 		allowance[msg.sender][_spender] = _value;
240 		emit Approval(msg.sender, _spender, _value);
241 		return true;
242 	}
243 
244 	/**
245 	 * Set allowance for other address and notify
246 	 *
247 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
248 	 *
249 	 * @param _spender The address authorized to spend
250 	 * @param _value the max amount they can spend
251 	 * @param _extraData some extra information to send to the approved contract
252 	 */
253 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
254 		tokenRecipient spender = tokenRecipient(_spender);
255 		if (approve(_spender, _value)) {
256 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
257 			return true;
258 		}
259 	}
260 
261 	/**
262 	 * Destroy tokens
263 	 *
264 	 * Remove `_value` tokens from the system irreversibly
265 	 *
266 	 * @param _value the amount of money to burn
267 	 */
268 	function burn(uint256 _value) public returns (bool success) {
269 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
270 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
271 		totalSupply -= _value;                      // Updates totalSupply
272 		emit Burn(msg.sender, _value);
273 		return true;
274 	}
275 
276 	/**
277 	 * Destroy tokens from other account
278 	 *
279 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
280 	 *
281 	 * @param _from the address of the sender
282 	 * @param _value the amount of money to burn
283 	 */
284 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
285 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
286 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
287 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
288 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
289 		totalSupply -= _value;                              // Update totalSupply
290 		emit Burn(_from, _value);
291 		return true;
292 	}
293 }
294 
295 
296 /**
297  * @title TAO
298  */
299 contract TAO {
300 	using SafeMath for uint256;
301 
302 	address public vaultAddress;
303 	string public name;				// the name for this TAO
304 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
305 
306 	// TAO's data
307 	string public datHash;
308 	string public database;
309 	string public keyValue;
310 	bytes32 public contentId;
311 
312 	/**
313 	 * 0 = TAO
314 	 * 1 = Name
315 	 */
316 	uint8 public typeId;
317 
318 	/**
319 	 * @dev Constructor function
320 	 */
321 	constructor (string memory _name,
322 		address _originId,
323 		string memory _datHash,
324 		string memory _database,
325 		string memory _keyValue,
326 		bytes32 _contentId,
327 		address _vaultAddress
328 	) public {
329 		name = _name;
330 		originId = _originId;
331 		datHash = _datHash;
332 		database = _database;
333 		keyValue = _keyValue;
334 		contentId = _contentId;
335 
336 		// Creating TAO
337 		typeId = 0;
338 
339 		vaultAddress = _vaultAddress;
340 	}
341 
342 	/**
343 	 * @dev Checks if calling address is Vault contract
344 	 */
345 	modifier onlyVault {
346 		require (msg.sender == vaultAddress);
347 		_;
348 	}
349 
350 	/**
351 	 * Will receive any ETH sent
352 	 */
353 	function () external payable {
354 	}
355 
356 	/**
357 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
358 	 * @param _recipient The recipient address
359 	 * @param _amount The amount to transfer
360 	 * @return true on success
361 	 */
362 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
363 		_recipient.transfer(_amount);
364 		return true;
365 	}
366 
367 	/**
368 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
369 	 * @param _erc20TokenAddress The address of ERC20 Token
370 	 * @param _recipient The recipient address
371 	 * @param _amount The amount to transfer
372 	 * @return true on success
373 	 */
374 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
375 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
376 		_erc20.transfer(_recipient, _amount);
377 		return true;
378 	}
379 }
380 
381 
382 
383 
384 /**
385  * @title Name
386  */
387 contract Name is TAO {
388 	/**
389 	 * @dev Constructor function
390 	 */
391 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
392 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
393 		// Creating Name
394 		typeId = 1;
395 	}
396 }
397 
398 
399 
400 
401 /**
402  * @title AOLibrary
403  */
404 library AOLibrary {
405 	using SafeMath for uint256;
406 
407 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
408 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
409 
410 	/**
411 	 * @dev Check whether or not the given TAO ID is a TAO
412 	 * @param _taoId The ID of the TAO
413 	 * @return true if yes. false otherwise
414 	 */
415 	function isTAO(address _taoId) public view returns (bool) {
416 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
417 	}
418 
419 	/**
420 	 * @dev Check whether or not the given Name ID is a Name
421 	 * @param _nameId The ID of the Name
422 	 * @return true if yes. false otherwise
423 	 */
424 	function isName(address _nameId) public view returns (bool) {
425 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
426 	}
427 
428 	/**
429 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
430 	 * @param _tokenAddress The ERC20 Token address to check
431 	 */
432 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
433 		if (_tokenAddress == address(0)) {
434 			return false;
435 		}
436 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
437 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
438 	}
439 
440 	/**
441 	 * @dev Checks if the calling contract address is The AO
442 	 *		OR
443 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
444 	 * @param _sender The address to check
445 	 * @param _theAO The AO address
446 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
447 	 * @return true if yes, false otherwise
448 	 */
449 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
450 		return (_sender == _theAO ||
451 			(
452 				(isTAO(_theAO) || isName(_theAO)) &&
453 				_nameTAOPositionAddress != address(0) &&
454 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
455 			)
456 		);
457 	}
458 
459 	/**
460 	 * @dev Return the divisor used to correctly calculate percentage.
461 	 *		Percentage stored throughout AO contracts covers 4 decimals,
462 	 *		so 1% is 10000, 1.25% is 12500, etc
463 	 */
464 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
465 		return _PERCENTAGE_DIVISOR;
466 	}
467 
468 	/**
469 	 * @dev Return the divisor used to correctly calculate multiplier.
470 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
471 	 *		so 1 is 1000000, 0.023 is 23000, etc
472 	 */
473 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
474 		return _MULTIPLIER_DIVISOR;
475 	}
476 
477 	/**
478 	 * @dev deploy a TAO
479 	 * @param _name The name of the TAO
480 	 * @param _originId The Name ID the creates the TAO
481 	 * @param _datHash The datHash of this TAO
482 	 * @param _database The database for this TAO
483 	 * @param _keyValue The key/value pair to be checked on the database
484 	 * @param _contentId The contentId related to this TAO
485 	 * @param _nameTAOVaultAddress The address of NameTAOVault
486 	 */
487 	function deployTAO(string memory _name,
488 		address _originId,
489 		string memory _datHash,
490 		string memory _database,
491 		string memory _keyValue,
492 		bytes32 _contentId,
493 		address _nameTAOVaultAddress
494 		) public returns (TAO _tao) {
495 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
496 	}
497 
498 	/**
499 	 * @dev deploy a Name
500 	 * @param _name The name of the Name
501 	 * @param _originId The eth address the creates the Name
502 	 * @param _datHash The datHash of this Name
503 	 * @param _database The database for this Name
504 	 * @param _keyValue The key/value pair to be checked on the database
505 	 * @param _contentId The contentId related to this Name
506 	 * @param _nameTAOVaultAddress The address of NameTAOVault
507 	 */
508 	function deployName(string memory _name,
509 		address _originId,
510 		string memory _datHash,
511 		string memory _database,
512 		string memory _keyValue,
513 		bytes32 _contentId,
514 		address _nameTAOVaultAddress
515 		) public returns (Name _myName) {
516 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
517 	}
518 
519 	/**
520 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
521 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
522 	 * @param _currentPrimordialBalance Account's current primordial ion balance
523 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
524 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
525 	 * @return the new primordial weighted multiplier
526 	 */
527 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
528 		if (_currentWeightedMultiplier > 0) {
529 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
530 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
531 			return _totalWeightedIons.div(_totalIons);
532 		} else {
533 			return _additionalWeightedMultiplier;
534 		}
535 	}
536 
537 	/**
538 	 * @dev Calculate the primordial ion multiplier on a given lot
539 	 *		Total Primordial Mintable = T
540 	 *		Total Primordial Minted = M
541 	 *		Starting Multiplier = S
542 	 *		Ending Multiplier = E
543 	 *		To Purchase = P
544 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
545 	 *
546 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
547 	 * @param _totalPrimordialMintable Total Primordial ion mintable
548 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
549 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
550 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
551 	 * @return The multiplier in (10 ** 6)
552 	 */
553 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
554 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
555 			/**
556 			 * Let temp = M + (P/2)
557 			 * Multiplier = (1 - (temp / T)) x (S-E)
558 			 */
559 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
560 
561 			/**
562 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
563 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
564 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
565 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
566 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
567 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
568 			 */
569 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
570 			/**
571 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
572 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
573 			 */
574 			return multiplier.div(_MULTIPLIER_DIVISOR);
575 		} else {
576 			return 0;
577 		}
578 	}
579 
580 	/**
581 	 * @dev Calculate the bonus percentage of network ion on a given lot
582 	 *		Total Primordial Mintable = T
583 	 *		Total Primordial Minted = M
584 	 *		Starting Network Bonus Multiplier = Bs
585 	 *		Ending Network Bonus Multiplier = Be
586 	 *		To Purchase = P
587 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
588 	 *
589 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
590 	 * @param _totalPrimordialMintable Total Primordial ion intable
591 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
592 	 * @param _startingMultiplier The starting Network ion bonus multiplier
593 	 * @param _endingMultiplier The ending Network ion bonus multiplier
594 	 * @return The bonus percentage
595 	 */
596 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
597 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
598 			/**
599 			 * Let temp = M + (P/2)
600 			 * B% = (1 - (temp / T)) x (Bs-Be)
601 			 */
602 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
603 
604 			/**
605 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
606 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
607 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
608 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
609 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
610 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
611 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
612 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
613 			 */
614 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
615 			return bonusPercentage;
616 		} else {
617 			return 0;
618 		}
619 	}
620 
621 	/**
622 	 * @dev Calculate the bonus amount of network ion on a given lot
623 	 *		AO Bonus Amount = B% x P
624 	 *
625 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
626 	 * @param _totalPrimordialMintable Total Primordial ion intable
627 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
628 	 * @param _startingMultiplier The starting Network ion bonus multiplier
629 	 * @param _endingMultiplier The ending Network ion bonus multiplier
630 	 * @return The bonus percentage
631 	 */
632 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
633 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
634 		/**
635 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
636 		 * when calculating the network ion bonus amount
637 		 */
638 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
639 		return networkBonus;
640 	}
641 
642 	/**
643 	 * @dev Calculate the maximum amount of Primordial an account can burn
644 	 *		_primordialBalance = P
645 	 *		_currentWeightedMultiplier = M
646 	 *		_maximumMultiplier = S
647 	 *		_amountToBurn = B
648 	 *		B = ((S x P) - (P x M)) / S
649 	 *
650 	 * @param _primordialBalance Account's primordial ion balance
651 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
652 	 * @param _maximumMultiplier The maximum multiplier of this account
653 	 * @return The maximum burn amount
654 	 */
655 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
656 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
657 	}
658 
659 	/**
660 	 * @dev Calculate the new multiplier after burning primordial ion
661 	 *		_primordialBalance = P
662 	 *		_currentWeightedMultiplier = M
663 	 *		_amountToBurn = B
664 	 *		_newMultiplier = E
665 	 *		E = (P x M) / (P - B)
666 	 *
667 	 * @param _primordialBalance Account's primordial ion balance
668 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
669 	 * @param _amountToBurn The amount of primordial ion to burn
670 	 * @return The new multiplier
671 	 */
672 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
673 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
674 	}
675 
676 	/**
677 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
678 	 *		_primordialBalance = P
679 	 *		_currentWeightedMultiplier = M
680 	 *		_amountToConvert = C
681 	 *		_newMultiplier = E
682 	 *		E = (P x M) / (P + C)
683 	 *
684 	 * @param _primordialBalance Account's primordial ion balance
685 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
686 	 * @param _amountToConvert The amount of network ion to convert
687 	 * @return The new multiplier
688 	 */
689 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
690 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
691 	}
692 
693 	/**
694 	 * @dev count num of digits
695 	 * @param number uint256 of the nuumber to be checked
696 	 * @return uint8 num of digits
697 	 */
698 	function numDigits(uint256 number) public pure returns (uint8) {
699 		uint8 digits = 0;
700 		while(number != 0) {
701 			number = number.div(10);
702 			digits++;
703 		}
704 		return digits;
705 	}
706 }
707 
708 
709 
710 contract TheAO {
711 	address public theAO;
712 	address public nameTAOPositionAddress;
713 
714 	// Check whether an address is whitelisted and granted access to transact
715 	// on behalf of others
716 	mapping (address => bool) public whitelist;
717 
718 	constructor() public {
719 		theAO = msg.sender;
720 	}
721 
722 	/**
723 	 * @dev Checks if msg.sender is in whitelist.
724 	 */
725 	modifier inWhitelist() {
726 		require (whitelist[msg.sender] == true);
727 		_;
728 	}
729 
730 	/**
731 	 * @dev Transfer ownership of The AO to new address
732 	 * @param _theAO The new address to be transferred
733 	 */
734 	function transferOwnership(address _theAO) public {
735 		require (msg.sender == theAO);
736 		require (_theAO != address(0));
737 		theAO = _theAO;
738 	}
739 
740 	/**
741 	 * @dev Whitelist `_account` address to transact on behalf of others
742 	 * @param _account The address to whitelist
743 	 * @param _whitelist Either to whitelist or not
744 	 */
745 	function setWhitelist(address _account, bool _whitelist) public {
746 		require (msg.sender == theAO);
747 		require (_account != address(0));
748 		whitelist[_account] = _whitelist;
749 	}
750 }
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
761  * @title AOPurchaseReceipt
762  */
763 contract AOPurchaseReceipt is TheAO, IAOPurchaseReceipt {
764 	using SafeMath for uint256;
765 
766 	uint256 public totalPurchaseReceipts;
767 	address public aoContentAddress;
768 	address public aoStakedContentAddress;
769 	address public aoContentHostAddress;
770 	address public aoTreasuryAddress;
771 	address public aoEarningAddress;
772 	address public nameFactoryAddress;
773 
774 	IAOContent internal _aoContent;
775 	IAOStakedContent internal _aoStakedContent;
776 	IAOContentHost internal _aoContentHost;
777 	IAOTreasury internal _aoTreasury;
778 	IAOEarning internal _aoEarning;
779 	INameFactory internal _nameFactory;
780 
781 	struct PurchaseReceipt {
782 		bytes32 purchaseReceiptId;
783 		bytes32 contentHostId;
784 		bytes32 stakedContentId;
785 		bytes32 contentId;
786 		address buyer;
787 		uint256 price;
788 		uint256 amountPaidByBuyer;	// total network ion paid in base denomination
789 		uint256 amountPaidByAO; // total amount paid by AO
790 		string publicKey; // The public key provided by request node
791 		address publicAddress; // The public address provided by request node
792 		uint256 createdOnTimestamp;
793 	}
794 
795 	// Mapping from PurchaseReceipt index to the PurchaseReceipt object
796 	mapping (uint256 => PurchaseReceipt) internal purchaseReceipts;
797 
798 	// Mapping from purchase receipt ID to index of the purchaseReceipts list
799 	mapping (bytes32 => uint256) internal purchaseReceiptIndex;
800 
801 	// Mapping from buyer's content host ID to the buy ID
802 	// To check whether or not buyer has bought/paid for a content
803 	mapping (address => mapping (bytes32 => bytes32)) public buyerPurchaseReceipts;
804 
805 	// Event to be broadcasted to public when a request node buys a content
806 	event BuyContent(
807 		address indexed buyer,
808 		bytes32 indexed purchaseReceiptId,
809 		bytes32 indexed contentHostId,
810 		bytes32 stakedContentId,
811 		bytes32 contentId,
812 		uint256 price,
813 		uint256 amountPaidByAO,
814 		uint256 amountPaidByBuyer,
815 		string publicKey,
816 		address publicAddress,
817 		uint256 createdOnTimestamp
818 	);
819 
820 	/**
821 	 * @dev Constructor function
822 	 * @param _aoContentAddress The address of AOContent
823 	 * @param _aoStakedContentAddress The address of AOStakedContent
824 	 * @param _aoTreasuryAddress The address of AOTreasury
825 	 * @param _aoEarningAddress The address of AOEarning
826 	 * @param _nameFactoryAddress The address of NameFactory
827 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
828 	 */
829 	constructor(address _aoContentAddress,
830 		address _aoStakedContentAddress,
831 		address _aoTreasuryAddress,
832 		address _aoEarningAddress,
833 		address _nameFactoryAddress,
834 		address _nameTAOPositionAddress
835 		) public {
836 		setAOContentAddress(_aoContentAddress);
837 		setAOStakedContentAddress(_aoStakedContentAddress);
838 		setAOTreasuryAddress(_aoTreasuryAddress);
839 		setAOEarningAddress(_aoEarningAddress);
840 		setNameFactoryAddress(_nameFactoryAddress);
841 		setNameTAOPositionAddress(_nameTAOPositionAddress);
842 	}
843 
844 	/**
845 	 * @dev Checks if the calling contract address is The AO
846 	 *		OR
847 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
848 	 */
849 	modifier onlyTheAO {
850 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
851 		_;
852 	}
853 
854 	/***** The AO ONLY METHODS *****/
855 	/**
856 	 * @dev Transfer ownership of The AO to new address
857 	 * @param _theAO The new address to be transferred
858 	 */
859 	function transferOwnership(address _theAO) public onlyTheAO {
860 		require (_theAO != address(0));
861 		theAO = _theAO;
862 	}
863 
864 	/**
865 	 * @dev Whitelist `_account` address to transact on behalf of others
866 	 * @param _account The address to whitelist
867 	 * @param _whitelist Either to whitelist or not
868 	 */
869 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
870 		require (_account != address(0));
871 		whitelist[_account] = _whitelist;
872 	}
873 
874 	/**
875 	 * @dev The AO sets AOContent address
876 	 * @param _aoContentAddress The address of AOContent
877 	 */
878 	function setAOContentAddress(address _aoContentAddress) public onlyTheAO {
879 		require (_aoContentAddress != address(0));
880 		aoContentAddress = _aoContentAddress;
881 		_aoContent = IAOContent(_aoContentAddress);
882 	}
883 
884 	/**
885 	 * @dev The AO sets AOStakedContent address
886 	 * @param _aoStakedContentAddress The address of AOStakedContent
887 	 */
888 	function setAOStakedContentAddress(address _aoStakedContentAddress) public onlyTheAO {
889 		require (_aoStakedContentAddress != address(0));
890 		aoStakedContentAddress = _aoStakedContentAddress;
891 		_aoStakedContent = IAOStakedContent(_aoStakedContentAddress);
892 	}
893 
894 	/**
895 	 * @dev The AO sets AOContentHost address
896 	 * @param _aoContentHostAddress The address of AOContentHost
897 	 */
898 	function setAOContentHostAddress(address _aoContentHostAddress) public onlyTheAO {
899 		require (_aoContentHostAddress != address(0));
900 		aoContentHostAddress = _aoContentHostAddress;
901 		_aoContentHost = IAOContentHost(_aoContentHostAddress);
902 	}
903 
904 	/**
905 	 * @dev The AO sets AOTreasury address
906 	 * @param _aoTreasuryAddress The address of AOTreasury
907 	 */
908 	function setAOTreasuryAddress(address _aoTreasuryAddress) public onlyTheAO {
909 		require (_aoTreasuryAddress != address(0));
910 		aoTreasuryAddress = _aoTreasuryAddress;
911 		_aoTreasury = IAOTreasury(_aoTreasuryAddress);
912 	}
913 
914 	/**
915 	 * @dev The AO sets AOEarning address
916 	 * @param _aoEarningAddress The address of AOEarning
917 	 */
918 	function setAOEarningAddress(address _aoEarningAddress) public onlyTheAO {
919 		require (_aoEarningAddress != address(0));
920 		aoEarningAddress = _aoEarningAddress;
921 		_aoEarning = IAOEarning(_aoEarningAddress);
922 	}
923 
924 	/**
925 	 * @dev The AO sets NameFactory address
926 	 * @param _nameFactoryAddress The address of NameFactory
927 	 */
928 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
929 		require (_nameFactoryAddress != address(0));
930 		nameFactoryAddress = _nameFactoryAddress;
931 		_nameFactory = INameFactory(_nameFactoryAddress);
932 	}
933 
934 	/**
935 	 * @dev The AO sets NameTAOPosition address
936 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
937 	 */
938 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
939 		require (_nameTAOPositionAddress != address(0));
940 		nameTAOPositionAddress = _nameTAOPositionAddress;
941 	}
942 
943 	/***** PUBLIC METHODS *****/
944 	/**
945 	 * @dev Bring content in to the requesting node by sending network ions to the contract to pay for the content
946 	 * @param _contentHostId The ID of hosted content
947 	 * @param _networkIntegerAmount The integer amount of network ion to pay
948 	 * @param _networkFractionAmount The fraction amount of network ion to pay
949 	 * @param _denomination The denomination of the network ion, i.e ao, kilo, mega, etc.
950 	 * @param _publicKey The public key of the request node
951 	 * @param _publicAddress The public address of the request node
952 	 */
953 	function buyContent(bytes32 _contentHostId,
954 		uint256 _networkIntegerAmount,
955 		uint256 _networkFractionAmount,
956 		bytes8 _denomination,
957 		string memory _publicKey,
958 		address _publicAddress
959 	) public {
960 		address _buyerNameId = _nameFactory.ethAddressToNameId(msg.sender);
961 		require (_buyerNameId != address(0));
962 		require (_canBuy(_buyerNameId, _contentHostId, _publicKey, _publicAddress));
963 
964 		(bytes32 _stakedContentId, bytes32 _contentId,,,) = _aoContentHost.getById(_contentHostId);
965 
966 		// Make sure the ion amount can pay for the content price
967 		if (_aoContent.isAOContentUsageType(_contentId)) {
968 			require (_canBuyAOContent(_aoContentHost.contentHostPrice(_contentHostId), _networkIntegerAmount, _networkFractionAmount, _denomination));
969 		}
970 
971 		// Increment totalPurchaseReceipts;
972 		totalPurchaseReceipts++;
973 
974 		// Generate purchaseReceiptId
975 		bytes32 _purchaseReceiptId = keccak256(abi.encodePacked(this, _buyerNameId, _contentHostId));
976 		PurchaseReceipt storage _purchaseReceipt = purchaseReceipts[totalPurchaseReceipts];
977 
978 		// Make sure the node doesn't buy the same content twice
979 		require (_purchaseReceipt.buyer == address(0));
980 
981 		_purchaseReceipt.purchaseReceiptId = _purchaseReceiptId;
982 		_purchaseReceipt.contentHostId = _contentHostId;
983 		_purchaseReceipt.stakedContentId = _stakedContentId;
984 		_purchaseReceipt.contentId = _contentId;
985 		_purchaseReceipt.buyer = _buyerNameId;
986 		// Update the receipt with the correct network amount
987 		_purchaseReceipt.price = _aoContentHost.contentHostPrice(_contentHostId);
988 		_purchaseReceipt.amountPaidByAO = _aoContentHost.contentHostPaidByAO(_contentHostId);
989 		_purchaseReceipt.amountPaidByBuyer = _purchaseReceipt.price.sub(_purchaseReceipt.amountPaidByAO);
990 		_purchaseReceipt.publicKey = _publicKey;
991 		_purchaseReceipt.publicAddress = _publicAddress;
992 		_purchaseReceipt.createdOnTimestamp = now;
993 
994 		purchaseReceiptIndex[_purchaseReceiptId] = totalPurchaseReceipts;
995 		buyerPurchaseReceipts[_buyerNameId][_contentHostId] = _purchaseReceiptId;
996 
997 		// Calculate content creator/host/The AO earning from this purchase and store them in escrow
998 		require (_aoEarning.calculateEarning(_purchaseReceiptId));
999 
1000 		emit BuyContent(
1001 			_purchaseReceipt.buyer,
1002 			_purchaseReceipt.purchaseReceiptId,
1003 			_purchaseReceipt.contentHostId,
1004 			_purchaseReceipt.stakedContentId,
1005 			_purchaseReceipt.contentId,
1006 			_purchaseReceipt.price,
1007 			_purchaseReceipt.amountPaidByAO,
1008 			_purchaseReceipt.amountPaidByBuyer,
1009 			_purchaseReceipt.publicKey,
1010 			_purchaseReceipt.publicAddress,
1011 			_purchaseReceipt.createdOnTimestamp
1012 		);
1013 	}
1014 
1015 	/**
1016 	 * @dev Return purchase receipt info at a given ID
1017 	 * @param _purchaseReceiptId The ID of the purchased content
1018 	 * @return The ID of the content host
1019 	 * @return The ID of the staked content
1020 	 * @return The ID of the content
1021 	 * @return address of the buyer
1022 	 * @return price of the content
1023 	 * @return amount paid by AO
1024 	 * @return amount paid by Buyer
1025 	 * @return request node's public key
1026 	 * @return request node's public address
1027 	 * @return created on timestamp
1028 	 */
1029 	function getById(bytes32 _purchaseReceiptId) external view returns (bytes32, bytes32, bytes32, address, uint256, uint256, uint256, string memory, address, uint256) {
1030 		// Make sure the purchase receipt exist
1031 		require (this.isExist(_purchaseReceiptId));
1032 		PurchaseReceipt memory _purchaseReceipt = purchaseReceipts[purchaseReceiptIndex[_purchaseReceiptId]];
1033 		return (
1034 			_purchaseReceipt.contentHostId,
1035 			_purchaseReceipt.stakedContentId,
1036 			_purchaseReceipt.contentId,
1037 			_purchaseReceipt.buyer,
1038 			_purchaseReceipt.price,
1039 			_purchaseReceipt.amountPaidByBuyer,
1040 			_purchaseReceipt.amountPaidByAO,
1041 			_purchaseReceipt.publicKey,
1042 			_purchaseReceipt.publicAddress,
1043 			_purchaseReceipt.createdOnTimestamp
1044 		);
1045 	}
1046 
1047 	/**
1048 	 * @dev Check whether or not sender is the buyer of purchase receipt ID
1049 	 * @param _purchaseReceiptId The ID of the Purchase Receipt to be checked
1050 	 * @param _sender The sender address
1051 	 * @return true if yes, false otherwise
1052 	 */
1053 	function senderIsBuyer(bytes32 _purchaseReceiptId, address _sender) external view returns (bool) {
1054 		require (this.isExist(_purchaseReceiptId));
1055 		require (_sender != address(0));
1056 		PurchaseReceipt memory _purchaseReceipt = purchaseReceipts[purchaseReceiptIndex[_purchaseReceiptId]];
1057 		return (_purchaseReceipt.buyer == _sender);
1058 	}
1059 
1060 	/**
1061 	 * @dev Check whether or not a purchaseReceiptId exist
1062 	 * @param _purchaseReceiptId The PurchaseReceipt ID to be checked
1063 	 * @return true if yes, false otherwise
1064 	 */
1065 	function isExist(bytes32 _purchaseReceiptId) external view returns (bool) {
1066 		return (purchaseReceiptIndex[_purchaseReceiptId] > 0);
1067 	}
1068 
1069 	/***** INTERNAL METHODS *****/
1070 	/**
1071 	 * @dev Check whether or not the passed params valid
1072 	 * @param _buyer The address of the buyer
1073 	 * @param _contentHostId The ID of hosted content
1074 	 * @param _publicKey The public key of the request node
1075 	 * @param _publicAddress The public address of the request node
1076 	 * @return true if yes, false otherwise
1077 	 */
1078 	function _canBuy(address _buyer,
1079 		bytes32 _contentHostId,
1080 		string memory _publicKey,
1081 		address _publicAddress
1082 	) internal view returns (bool) {
1083 		(bytes32 _stakedContentId,,address _host,,) = _aoContentHost.getById(_contentHostId);
1084 
1085 		// Make sure the content host exist
1086 		return (_aoContentHost.isExist(_contentHostId) &&
1087 			_buyer != address(0) &&
1088 			_buyer != _host &&
1089 			AOLibrary.isName(_buyer) &&
1090 			bytes(_publicKey).length > 0 &&
1091 			_publicAddress != address(0) &&
1092 			_aoStakedContent.isActive(_stakedContentId) &&
1093 			buyerPurchaseReceipts[_buyer][_contentHostId][0] == 0
1094 		);
1095 	}
1096 
1097 	/**
1098 	 * @dev Check whether the network ion is adequate to pay for existing staked content
1099 	 * @param _price The price of the content
1100 	 * @param _networkIntegerAmount The integer amount of the network ion
1101 	 * @param _networkFractionAmount The fraction amount of the network ion
1102 	 * @param _denomination The denomination of the the network ion
1103 	 * @return true when the amount is sufficient, false otherwise
1104 	 */
1105 	function _canBuyAOContent(uint256 _price, uint256 _networkIntegerAmount, uint256 _networkFractionAmount, bytes8 _denomination) internal view returns (bool) {
1106 		return _aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination) >= _price;
1107 	}
1108 }