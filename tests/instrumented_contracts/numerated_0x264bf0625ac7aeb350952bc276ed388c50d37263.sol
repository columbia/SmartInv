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
88 interface IAOPurchaseReceipt {
89 	function senderIsBuyer(bytes32 _purchaseReceiptId, address _sender) external view returns (bool);
90 
91 	function getById(bytes32 _purchaseReceiptId) external view returns (bytes32, bytes32, bytes32, address, uint256, uint256, uint256, string memory, address, uint256);
92 
93 	function isExist(bytes32 _purchaseReceiptId) external view returns (bool);
94 }
95 
96 
97 interface IAOStakedContent {
98 	function getById(bytes32 _stakedContentId) external view returns (bytes32, address, uint256, uint256, uint256, uint256, bool, uint256);
99 
100 	function create(address _stakeOwner, bytes32 _contentId, uint256 _networkIntegerAmount, uint256 _networkFractionAmount, bytes8 _denomination, uint256 _primordialAmount, uint256 _profitPercentage) external returns (bytes32);
101 
102 	function isActive(bytes32 _stakedContentId) external view returns (bool);
103 }
104 
105 
106 interface IAOContent {
107 	function create(address _creator, string calldata _baseChallenge, uint256 _fileSize, bytes32 _contentUsageType, address _taoId) external returns (bytes32);
108 
109 	function isAOContentUsageType(bytes32 _contentId) external view returns (bool);
110 
111 	function getById(bytes32 _contentId) external view returns (address, uint256, bytes32, address, bytes32, uint8, bytes32, bytes32, string memory);
112 
113 	function getBaseChallenge(bytes32 _contentId) external view returns (string memory);
114 }
115 
116 
117 interface IAOContentHost {
118 	function create(address _host, bytes32 _stakedContentId, string calldata _encChallenge, string calldata _contentDatKey, string calldata _metadataDatKey) external returns (bool);
119 
120 	function getById(bytes32 _contentHostId) external view returns (bytes32, bytes32, address, string memory, string memory);
121 
122 	function contentHostPrice(bytes32 _contentHostId) external view returns (uint256);
123 
124 	function contentHostPaidByAO(bytes32 _contentHostId) external view returns (uint256);
125 
126 	function isExist(bytes32 _contentHostId) external view returns (bool);
127 }
128 
129 
130 
131 
132 
133 
134 
135 
136 
137 
138 
139 
140 
141 contract TokenERC20 {
142 	// Public variables of the token
143 	string public name;
144 	string public symbol;
145 	uint8 public decimals = 18;
146 	// 18 decimals is the strongly suggested default, avoid changing it
147 	uint256 public totalSupply;
148 
149 	// This creates an array with all balances
150 	mapping (address => uint256) public balanceOf;
151 	mapping (address => mapping (address => uint256)) public allowance;
152 
153 	// This generates a public event on the blockchain that will notify clients
154 	event Transfer(address indexed from, address indexed to, uint256 value);
155 
156 	// This generates a public event on the blockchain that will notify clients
157 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
158 
159 	// This notifies clients about the amount burnt
160 	event Burn(address indexed from, uint256 value);
161 
162 	/**
163 	 * Constructor function
164 	 *
165 	 * Initializes contract with initial supply tokens to the creator of the contract
166 	 */
167 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
168 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
169 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
170 		name = tokenName;                                   // Set the name for display purposes
171 		symbol = tokenSymbol;                               // Set the symbol for display purposes
172 	}
173 
174 	/**
175 	 * Internal transfer, only can be called by this contract
176 	 */
177 	function _transfer(address _from, address _to, uint _value) internal {
178 		// Prevent transfer to 0x0 address. Use burn() instead
179 		require(_to != address(0));
180 		// Check if the sender has enough
181 		require(balanceOf[_from] >= _value);
182 		// Check for overflows
183 		require(balanceOf[_to] + _value > balanceOf[_to]);
184 		// Save this for an assertion in the future
185 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
186 		// Subtract from the sender
187 		balanceOf[_from] -= _value;
188 		// Add the same to the recipient
189 		balanceOf[_to] += _value;
190 		emit Transfer(_from, _to, _value);
191 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
192 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
193 	}
194 
195 	/**
196 	 * Transfer tokens
197 	 *
198 	 * Send `_value` tokens to `_to` from your account
199 	 *
200 	 * @param _to The address of the recipient
201 	 * @param _value the amount to send
202 	 */
203 	function transfer(address _to, uint256 _value) public returns (bool success) {
204 		_transfer(msg.sender, _to, _value);
205 		return true;
206 	}
207 
208 	/**
209 	 * Transfer tokens from other address
210 	 *
211 	 * Send `_value` tokens to `_to` in behalf of `_from`
212 	 *
213 	 * @param _from The address of the sender
214 	 * @param _to The address of the recipient
215 	 * @param _value the amount to send
216 	 */
217 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
218 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
219 		allowance[_from][msg.sender] -= _value;
220 		_transfer(_from, _to, _value);
221 		return true;
222 	}
223 
224 	/**
225 	 * Set allowance for other address
226 	 *
227 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
228 	 *
229 	 * @param _spender The address authorized to spend
230 	 * @param _value the max amount they can spend
231 	 */
232 	function approve(address _spender, uint256 _value) public returns (bool success) {
233 		allowance[msg.sender][_spender] = _value;
234 		emit Approval(msg.sender, _spender, _value);
235 		return true;
236 	}
237 
238 	/**
239 	 * Set allowance for other address and notify
240 	 *
241 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
242 	 *
243 	 * @param _spender The address authorized to spend
244 	 * @param _value the max amount they can spend
245 	 * @param _extraData some extra information to send to the approved contract
246 	 */
247 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
248 		tokenRecipient spender = tokenRecipient(_spender);
249 		if (approve(_spender, _value)) {
250 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
251 			return true;
252 		}
253 	}
254 
255 	/**
256 	 * Destroy tokens
257 	 *
258 	 * Remove `_value` tokens from the system irreversibly
259 	 *
260 	 * @param _value the amount of money to burn
261 	 */
262 	function burn(uint256 _value) public returns (bool success) {
263 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
264 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
265 		totalSupply -= _value;                      // Updates totalSupply
266 		emit Burn(msg.sender, _value);
267 		return true;
268 	}
269 
270 	/**
271 	 * Destroy tokens from other account
272 	 *
273 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
274 	 *
275 	 * @param _from the address of the sender
276 	 * @param _value the amount of money to burn
277 	 */
278 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
279 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
280 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
281 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
282 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
283 		totalSupply -= _value;                              // Update totalSupply
284 		emit Burn(_from, _value);
285 		return true;
286 	}
287 }
288 
289 
290 /**
291  * @title TAO
292  */
293 contract TAO {
294 	using SafeMath for uint256;
295 
296 	address public vaultAddress;
297 	string public name;				// the name for this TAO
298 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
299 
300 	// TAO's data
301 	string public datHash;
302 	string public database;
303 	string public keyValue;
304 	bytes32 public contentId;
305 
306 	/**
307 	 * 0 = TAO
308 	 * 1 = Name
309 	 */
310 	uint8 public typeId;
311 
312 	/**
313 	 * @dev Constructor function
314 	 */
315 	constructor (string memory _name,
316 		address _originId,
317 		string memory _datHash,
318 		string memory _database,
319 		string memory _keyValue,
320 		bytes32 _contentId,
321 		address _vaultAddress
322 	) public {
323 		name = _name;
324 		originId = _originId;
325 		datHash = _datHash;
326 		database = _database;
327 		keyValue = _keyValue;
328 		contentId = _contentId;
329 
330 		// Creating TAO
331 		typeId = 0;
332 
333 		vaultAddress = _vaultAddress;
334 	}
335 
336 	/**
337 	 * @dev Checks if calling address is Vault contract
338 	 */
339 	modifier onlyVault {
340 		require (msg.sender == vaultAddress);
341 		_;
342 	}
343 
344 	/**
345 	 * Will receive any ETH sent
346 	 */
347 	function () external payable {
348 	}
349 
350 	/**
351 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
352 	 * @param _recipient The recipient address
353 	 * @param _amount The amount to transfer
354 	 * @return true on success
355 	 */
356 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
357 		_recipient.transfer(_amount);
358 		return true;
359 	}
360 
361 	/**
362 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
363 	 * @param _erc20TokenAddress The address of ERC20 Token
364 	 * @param _recipient The recipient address
365 	 * @param _amount The amount to transfer
366 	 * @return true on success
367 	 */
368 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
369 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
370 		_erc20.transfer(_recipient, _amount);
371 		return true;
372 	}
373 }
374 
375 
376 
377 
378 /**
379  * @title Name
380  */
381 contract Name is TAO {
382 	/**
383 	 * @dev Constructor function
384 	 */
385 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
386 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
387 		// Creating Name
388 		typeId = 1;
389 	}
390 }
391 
392 
393 
394 
395 /**
396  * @title AOLibrary
397  */
398 library AOLibrary {
399 	using SafeMath for uint256;
400 
401 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
402 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
403 
404 	/**
405 	 * @dev Check whether or not the given TAO ID is a TAO
406 	 * @param _taoId The ID of the TAO
407 	 * @return true if yes. false otherwise
408 	 */
409 	function isTAO(address _taoId) public view returns (bool) {
410 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
411 	}
412 
413 	/**
414 	 * @dev Check whether or not the given Name ID is a Name
415 	 * @param _nameId The ID of the Name
416 	 * @return true if yes. false otherwise
417 	 */
418 	function isName(address _nameId) public view returns (bool) {
419 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
420 	}
421 
422 	/**
423 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
424 	 * @param _tokenAddress The ERC20 Token address to check
425 	 */
426 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
427 		if (_tokenAddress == address(0)) {
428 			return false;
429 		}
430 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
431 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
432 	}
433 
434 	/**
435 	 * @dev Checks if the calling contract address is The AO
436 	 *		OR
437 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
438 	 * @param _sender The address to check
439 	 * @param _theAO The AO address
440 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
441 	 * @return true if yes, false otherwise
442 	 */
443 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
444 		return (_sender == _theAO ||
445 			(
446 				(isTAO(_theAO) || isName(_theAO)) &&
447 				_nameTAOPositionAddress != address(0) &&
448 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
449 			)
450 		);
451 	}
452 
453 	/**
454 	 * @dev Return the divisor used to correctly calculate percentage.
455 	 *		Percentage stored throughout AO contracts covers 4 decimals,
456 	 *		so 1% is 10000, 1.25% is 12500, etc
457 	 */
458 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
459 		return _PERCENTAGE_DIVISOR;
460 	}
461 
462 	/**
463 	 * @dev Return the divisor used to correctly calculate multiplier.
464 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
465 	 *		so 1 is 1000000, 0.023 is 23000, etc
466 	 */
467 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
468 		return _MULTIPLIER_DIVISOR;
469 	}
470 
471 	/**
472 	 * @dev deploy a TAO
473 	 * @param _name The name of the TAO
474 	 * @param _originId The Name ID the creates the TAO
475 	 * @param _datHash The datHash of this TAO
476 	 * @param _database The database for this TAO
477 	 * @param _keyValue The key/value pair to be checked on the database
478 	 * @param _contentId The contentId related to this TAO
479 	 * @param _nameTAOVaultAddress The address of NameTAOVault
480 	 */
481 	function deployTAO(string memory _name,
482 		address _originId,
483 		string memory _datHash,
484 		string memory _database,
485 		string memory _keyValue,
486 		bytes32 _contentId,
487 		address _nameTAOVaultAddress
488 		) public returns (TAO _tao) {
489 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
490 	}
491 
492 	/**
493 	 * @dev deploy a Name
494 	 * @param _name The name of the Name
495 	 * @param _originId The eth address the creates the Name
496 	 * @param _datHash The datHash of this Name
497 	 * @param _database The database for this Name
498 	 * @param _keyValue The key/value pair to be checked on the database
499 	 * @param _contentId The contentId related to this Name
500 	 * @param _nameTAOVaultAddress The address of NameTAOVault
501 	 */
502 	function deployName(string memory _name,
503 		address _originId,
504 		string memory _datHash,
505 		string memory _database,
506 		string memory _keyValue,
507 		bytes32 _contentId,
508 		address _nameTAOVaultAddress
509 		) public returns (Name _myName) {
510 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
511 	}
512 
513 	/**
514 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
515 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
516 	 * @param _currentPrimordialBalance Account's current primordial ion balance
517 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
518 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
519 	 * @return the new primordial weighted multiplier
520 	 */
521 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
522 		if (_currentWeightedMultiplier > 0) {
523 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
524 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
525 			return _totalWeightedIons.div(_totalIons);
526 		} else {
527 			return _additionalWeightedMultiplier;
528 		}
529 	}
530 
531 	/**
532 	 * @dev Calculate the primordial ion multiplier on a given lot
533 	 *		Total Primordial Mintable = T
534 	 *		Total Primordial Minted = M
535 	 *		Starting Multiplier = S
536 	 *		Ending Multiplier = E
537 	 *		To Purchase = P
538 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
539 	 *
540 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
541 	 * @param _totalPrimordialMintable Total Primordial ion mintable
542 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
543 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
544 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
545 	 * @return The multiplier in (10 ** 6)
546 	 */
547 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
548 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
549 			/**
550 			 * Let temp = M + (P/2)
551 			 * Multiplier = (1 - (temp / T)) x (S-E)
552 			 */
553 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
554 
555 			/**
556 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
557 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
558 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
559 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
560 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
561 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
562 			 */
563 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
564 			/**
565 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
566 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
567 			 */
568 			return multiplier.div(_MULTIPLIER_DIVISOR);
569 		} else {
570 			return 0;
571 		}
572 	}
573 
574 	/**
575 	 * @dev Calculate the bonus percentage of network ion on a given lot
576 	 *		Total Primordial Mintable = T
577 	 *		Total Primordial Minted = M
578 	 *		Starting Network Bonus Multiplier = Bs
579 	 *		Ending Network Bonus Multiplier = Be
580 	 *		To Purchase = P
581 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
582 	 *
583 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
584 	 * @param _totalPrimordialMintable Total Primordial ion intable
585 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
586 	 * @param _startingMultiplier The starting Network ion bonus multiplier
587 	 * @param _endingMultiplier The ending Network ion bonus multiplier
588 	 * @return The bonus percentage
589 	 */
590 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
591 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
592 			/**
593 			 * Let temp = M + (P/2)
594 			 * B% = (1 - (temp / T)) x (Bs-Be)
595 			 */
596 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
597 
598 			/**
599 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
600 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
601 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
602 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
603 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
604 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
605 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
606 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
607 			 */
608 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
609 			return bonusPercentage;
610 		} else {
611 			return 0;
612 		}
613 	}
614 
615 	/**
616 	 * @dev Calculate the bonus amount of network ion on a given lot
617 	 *		AO Bonus Amount = B% x P
618 	 *
619 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
620 	 * @param _totalPrimordialMintable Total Primordial ion intable
621 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
622 	 * @param _startingMultiplier The starting Network ion bonus multiplier
623 	 * @param _endingMultiplier The ending Network ion bonus multiplier
624 	 * @return The bonus percentage
625 	 */
626 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
627 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
628 		/**
629 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
630 		 * when calculating the network ion bonus amount
631 		 */
632 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
633 		return networkBonus;
634 	}
635 
636 	/**
637 	 * @dev Calculate the maximum amount of Primordial an account can burn
638 	 *		_primordialBalance = P
639 	 *		_currentWeightedMultiplier = M
640 	 *		_maximumMultiplier = S
641 	 *		_amountToBurn = B
642 	 *		B = ((S x P) - (P x M)) / S
643 	 *
644 	 * @param _primordialBalance Account's primordial ion balance
645 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
646 	 * @param _maximumMultiplier The maximum multiplier of this account
647 	 * @return The maximum burn amount
648 	 */
649 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
650 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
651 	}
652 
653 	/**
654 	 * @dev Calculate the new multiplier after burning primordial ion
655 	 *		_primordialBalance = P
656 	 *		_currentWeightedMultiplier = M
657 	 *		_amountToBurn = B
658 	 *		_newMultiplier = E
659 	 *		E = (P x M) / (P - B)
660 	 *
661 	 * @param _primordialBalance Account's primordial ion balance
662 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
663 	 * @param _amountToBurn The amount of primordial ion to burn
664 	 * @return The new multiplier
665 	 */
666 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
667 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
668 	}
669 
670 	/**
671 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
672 	 *		_primordialBalance = P
673 	 *		_currentWeightedMultiplier = M
674 	 *		_amountToConvert = C
675 	 *		_newMultiplier = E
676 	 *		E = (P x M) / (P + C)
677 	 *
678 	 * @param _primordialBalance Account's primordial ion balance
679 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
680 	 * @param _amountToConvert The amount of network ion to convert
681 	 * @return The new multiplier
682 	 */
683 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
684 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
685 	}
686 
687 	/**
688 	 * @dev count num of digits
689 	 * @param number uint256 of the nuumber to be checked
690 	 * @return uint8 num of digits
691 	 */
692 	function numDigits(uint256 number) public pure returns (uint8) {
693 		uint8 digits = 0;
694 		while(number != 0) {
695 			number = number.div(10);
696 			digits++;
697 		}
698 		return digits;
699 	}
700 }
701 
702 
703 
704 contract TheAO {
705 	address public theAO;
706 	address public nameTAOPositionAddress;
707 
708 	// Check whether an address is whitelisted and granted access to transact
709 	// on behalf of others
710 	mapping (address => bool) public whitelist;
711 
712 	constructor() public {
713 		theAO = msg.sender;
714 	}
715 
716 	/**
717 	 * @dev Checks if msg.sender is in whitelist.
718 	 */
719 	modifier inWhitelist() {
720 		require (whitelist[msg.sender] == true);
721 		_;
722 	}
723 
724 	/**
725 	 * @dev Transfer ownership of The AO to new address
726 	 * @param _theAO The new address to be transferred
727 	 */
728 	function transferOwnership(address _theAO) public {
729 		require (msg.sender == theAO);
730 		require (_theAO != address(0));
731 		theAO = _theAO;
732 	}
733 
734 	/**
735 	 * @dev Whitelist `_account` address to transact on behalf of others
736 	 * @param _account The address to whitelist
737 	 * @param _whitelist Either to whitelist or not
738 	 */
739 	function setWhitelist(address _account, bool _whitelist) public {
740 		require (msg.sender == theAO);
741 		require (_account != address(0));
742 		whitelist[_account] = _whitelist;
743 	}
744 }
745 
746 
747 
748 
749 
750 
751 
752 
753 /**
754  * @title AOContentHost
755  */
756 contract AOContentHost is TheAO, IAOContentHost {
757 	using SafeMath for uint256;
758 
759 	uint256 public totalContentHosts;
760 	address public aoContentAddress;
761 	address public aoStakedContentAddress;
762 	address public aoPurchaseReceiptAddress;
763 	address public aoEarningAddress;
764 	address public nameFactoryAddress;
765 
766 	IAOContent internal _aoContent;
767 	IAOStakedContent internal _aoStakedContent;
768 	IAOPurchaseReceipt internal _aoPurchaseReceipt;
769 	IAOEarning internal _aoEarning;
770 	INameFactory internal _nameFactory;
771 
772 	struct ContentHost {
773 		bytes32 contentHostId;
774 		bytes32 stakedContentId;
775 		bytes32 contentId;
776 		address host;
777 		/**
778 		 * encChallenge is the content's PUBLIC KEY unique to the host
779 		 */
780 		string encChallenge;
781 		string contentDatKey;
782 		string metadataDatKey;
783 	}
784 
785 	// Mapping from ContentHost index to the ContentHost object
786 	mapping (uint256 => ContentHost) internal contentHosts;
787 
788 	// Mapping from content host ID to index of the contentHosts list
789 	mapping (bytes32 => uint256) internal contentHostIndex;
790 
791 	// Event to be broadcasted to public when a node hosts a content
792 	event HostContent(address indexed host, bytes32 indexed contentHostId, bytes32 stakedContentId, bytes32 contentId, string contentDatKey, string metadataDatKey);
793 
794 	/**
795 	 * @dev Constructor function
796 	 * @param _aoContentAddress The address of AOContent
797 	 * @param _aoStakedContentAddress The address of AOStakedContent
798 	 * @param _aoPurchaseReceiptAddress The address of AOPurchaseReceipt
799 	 * @param _aoEarningAddress The address of AOEarning
800 	 * @param _nameFactoryAddress The address of NameFactory
801 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
802 	 */
803 	constructor(address _aoContentAddress, address _aoStakedContentAddress, address _aoPurchaseReceiptAddress, address _aoEarningAddress, address _nameFactoryAddress, address _nameTAOPositionAddress) public {
804 		setAOContentAddress(_aoContentAddress);
805 		setAOStakedContentAddress(_aoStakedContentAddress);
806 		setAOPurchaseReceiptAddress(_aoPurchaseReceiptAddress);
807 		setAOEarningAddress(_aoEarningAddress);
808 		setNameFactoryAddress(_nameFactoryAddress);
809 		setNameTAOPositionAddress(_nameTAOPositionAddress);
810 	}
811 
812 	/**
813 	 * @dev Checks if the calling contract address is The AO
814 	 *		OR
815 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
816 	 */
817 	modifier onlyTheAO {
818 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
819 		_;
820 	}
821 
822 	/***** The AO ONLY METHODS *****/
823 	/**
824 	 * @dev Transfer ownership of The AO to new address
825 	 * @param _theAO The new address to be transferred
826 	 */
827 	function transferOwnership(address _theAO) public onlyTheAO {
828 		require (_theAO != address(0));
829 		theAO = _theAO;
830 	}
831 
832 	/**
833 	 * @dev Whitelist `_account` address to transact on behalf of others
834 	 * @param _account The address to whitelist
835 	 * @param _whitelist Either to whitelist or not
836 	 */
837 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
838 		require (_account != address(0));
839 		whitelist[_account] = _whitelist;
840 	}
841 
842 	/**
843 	 * @dev The AO sets AOContent address
844 	 * @param _aoContentAddress The address of AOContent
845 	 */
846 	function setAOContentAddress(address _aoContentAddress) public onlyTheAO {
847 		require (_aoContentAddress != address(0));
848 		aoContentAddress = _aoContentAddress;
849 		_aoContent = IAOContent(_aoContentAddress);
850 	}
851 
852 	/**
853 	 * @dev The AO sets AOStakedContent address
854 	 * @param _aoStakedContentAddress The address of AOStakedContent
855 	 */
856 	function setAOStakedContentAddress(address _aoStakedContentAddress) public onlyTheAO {
857 		require (_aoStakedContentAddress != address(0));
858 		aoStakedContentAddress = _aoStakedContentAddress;
859 		_aoStakedContent = IAOStakedContent(_aoStakedContentAddress);
860 	}
861 
862 	/**
863 	 * @dev The AO sets AOPurchaseReceipt address
864 	 * @param _aoPurchaseReceiptAddress The address of AOPurchaseReceipt
865 	 */
866 	function setAOPurchaseReceiptAddress(address _aoPurchaseReceiptAddress) public onlyTheAO {
867 		require (_aoPurchaseReceiptAddress != address(0));
868 		aoPurchaseReceiptAddress = _aoPurchaseReceiptAddress;
869 		_aoPurchaseReceipt = IAOPurchaseReceipt(_aoPurchaseReceiptAddress);
870 	}
871 
872 	/**
873 	 * @dev The AO sets AOEarning address
874 	 * @param _aoEarningAddress The address of AOEarning
875 	 */
876 	function setAOEarningAddress(address _aoEarningAddress) public onlyTheAO {
877 		require (_aoEarningAddress != address(0));
878 		aoEarningAddress = _aoEarningAddress;
879 		_aoEarning = IAOEarning(_aoEarningAddress);
880 	}
881 
882 	/**
883 	 * @dev The AO sets NameFactory address
884 	 * @param _nameFactoryAddress The address of NameFactory
885 	 */
886 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
887 		require (_nameFactoryAddress != address(0));
888 		nameFactoryAddress = _nameFactoryAddress;
889 		_nameFactory = INameFactory(_nameFactoryAddress);
890 	}
891 
892 	/**
893 	 * @dev The AO sets NameTAOPosition address
894 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
895 	 */
896 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
897 		require (_nameTAOPositionAddress != address(0));
898 		nameTAOPositionAddress = _nameTAOPositionAddress;
899 	}
900 
901 	/***** PUBLIC METHODS *****/
902 	/**
903 	 * @dev Add the distribution node info that hosts the content
904 	 * @param _host the address of the host
905 	 * @param _stakedContentId The ID of the staked content
906 	 * @param _encChallenge The encrypted challenge string (PUBLIC KEY) of the content unique to the host
907 	 * @param _contentDatKey The dat key of the content
908 	 * @param _metadataDatKey The dat key of the content's metadata
909 	 * @return true on success
910 	 */
911 	function create(address _host, bytes32 _stakedContentId, string calldata _encChallenge, string calldata _contentDatKey, string calldata _metadataDatKey) external inWhitelist returns (bool) {
912 		require (_create(_host, _stakedContentId, _encChallenge, _contentDatKey, _metadataDatKey));
913 		return true;
914 	}
915 
916 	/**
917 	 * @dev Return content host info at a given ID
918 	 * @param _contentHostId The ID of the hosted content
919 	 * @return The ID of the staked content
920 	 * @return The ID of the content
921 	 * @return address of the host
922 	 * @return the dat key of the content
923 	 * @return the dat key of the content's metadata
924 	 */
925 	function getById(bytes32 _contentHostId) external view returns (bytes32, bytes32, address, string memory, string memory) {
926 		// Make sure the content host exist
927 		require (contentHostIndex[_contentHostId] > 0);
928 		ContentHost memory _contentHost = contentHosts[contentHostIndex[_contentHostId]];
929 		return (
930 			_contentHost.stakedContentId,
931 			_contentHost.contentId,
932 			_contentHost.host,
933 			_contentHost.contentDatKey,
934 			_contentHost.metadataDatKey
935 		);
936 	}
937 
938 	/**
939 	 * @dev Determine the content price hosted by a host
940 	 * @param _contentHostId The content host ID to be checked
941 	 * @return the price of the content
942 	 */
943 	function contentHostPrice(bytes32 _contentHostId) external view returns (uint256) {
944 		// Make sure content host exist
945 		require (contentHostIndex[_contentHostId] > 0);
946 
947 		bytes32 _stakedContentId = contentHosts[contentHostIndex[_contentHostId]].stakedContentId;
948 		require (_aoStakedContent.isActive(_stakedContentId));
949 
950 		(,,uint256 _networkAmount, uint256 _primordialAmount,,,,) = _aoStakedContent.getById(_stakedContentId);
951 		return _networkAmount.add(_primordialAmount);
952 	}
953 
954 	/**
955 	 * @dev Determine the how much the content is paid by AO given a contentHostId
956 	 * @param _contentHostId The content host ID to be checked
957 	 * @return the amount paid by AO
958 	 */
959 	function contentHostPaidByAO(bytes32 _contentHostId) external view returns (uint256) {
960 		// Make sure content host exist
961 		require (contentHostIndex[_contentHostId] > 0);
962 
963 		bytes32 _stakedContentId = contentHosts[contentHostIndex[_contentHostId]].stakedContentId;
964 		require (_aoStakedContent.isActive(_stakedContentId));
965 
966 		bytes32 _contentId = contentHosts[contentHostIndex[_contentHostId]].contentId;
967 		if (_aoContent.isAOContentUsageType(_contentId)) {
968 			return 0;
969 		} else {
970 			return this.contentHostPrice(_contentHostId);
971 		}
972 	}
973 
974 	/**
975 	 * @dev Check whether or not a contentHostId exist
976 	 * @param _contentHostId The content host ID to be checked
977 	 * @return true if yes, false otherwise
978 	 */
979 	function isExist(bytes32 _contentHostId) external view returns (bool) {
980 		return (contentHostIndex[_contentHostId] > 0);
981 	}
982 
983 	/**
984 	 * @dev Request node wants to become a distribution node after buying the content
985 	 *		Also, if this transaction succeeds, contract will release all of the earnings that are
986 	 *		currently in escrow for content creator/host/The AO
987 	 * @param _purchaseReceiptId The ID of the Purchase Receipt
988 	 * @param _baseChallengeV The V part of signature when signing the base challenge
989 	 * @param _baseChallengeR The R part of signature when signing the base challenge
990 	 * @param _baseChallengeS The S part of signature when signing the base challenge
991 	 * @param _encChallenge The encrypted challenge string (PUBLIC KEY) of the content unique to the host
992 	 * @param _contentDatKey The dat key of the content
993 	 * @param _metadataDatKey The dat key of the content's metadata
994 	 */
995 	function becomeHost(
996 		bytes32 _purchaseReceiptId,
997 		uint8 _baseChallengeV,
998 		bytes32 _baseChallengeR,
999 		bytes32 _baseChallengeS,
1000 		string memory _encChallenge,
1001 		string memory _contentDatKey,
1002 		string memory _metadataDatKey
1003 	) public {
1004 		address _hostNameId = _nameFactory.ethAddressToNameId(msg.sender);
1005 		require (_hostNameId != address(0));
1006 		require (_canBecomeHost(_purchaseReceiptId, _hostNameId, _baseChallengeV, _baseChallengeR, _baseChallengeS));
1007 
1008 		(, bytes32 _stakedContentId,,,,,,,,) = _aoPurchaseReceipt.getById(_purchaseReceiptId);
1009 
1010 		require (_create(_hostNameId, _stakedContentId, _encChallenge, _contentDatKey, _metadataDatKey));
1011 
1012 		// Release earning from escrow
1013 		require (_aoEarning.releaseEarning(_purchaseReceiptId));
1014 	}
1015 
1016 	/***** INTERNAL METHODS *****/
1017 	/**
1018 	 * @dev Actual add the distribution node info that hosts the content
1019 	 * @param _host the address of the host
1020 	 * @param _stakedContentId The ID of the staked content
1021 	 * @param _encChallenge The encrypted challenge string (PUBLIC KEY) of the content unique to the host
1022 	 * @param _contentDatKey The dat key of the content
1023 	 * @param _metadataDatKey The dat key of the content's metadata
1024 	 * @return true on success
1025 	 */
1026 	function _create(address _host, bytes32 _stakedContentId, string memory _encChallenge, string memory _contentDatKey, string memory _metadataDatKey) internal returns (bool) {
1027 		require (_host != address(0));
1028 		require (AOLibrary.isName(_host));
1029 		require (bytes(_encChallenge).length > 0);
1030 		require (bytes(_contentDatKey).length > 0);
1031 		require (bytes(_metadataDatKey).length > 0);
1032 		require (_aoStakedContent.isActive(_stakedContentId));
1033 
1034 		// Increment totalContentHosts
1035 		totalContentHosts++;
1036 
1037 		// Generate contentId
1038 		bytes32 _contentHostId = keccak256(abi.encodePacked(this, _host, _stakedContentId));
1039 
1040 		ContentHost storage _contentHost = contentHosts[totalContentHosts];
1041 
1042 		// Make sure the node doesn't host the same content twice
1043 		require (_contentHost.host == address(0));
1044 
1045 		(bytes32 _contentId,,,,,,,) = _aoStakedContent.getById(_stakedContentId);
1046 
1047 		_contentHost.contentHostId = _contentHostId;
1048 		_contentHost.stakedContentId = _stakedContentId;
1049 		_contentHost.contentId = _contentId;
1050 		_contentHost.host = _host;
1051 		_contentHost.encChallenge = _encChallenge;
1052 		_contentHost.contentDatKey = _contentDatKey;
1053 		_contentHost.metadataDatKey = _metadataDatKey;
1054 
1055 		contentHostIndex[_contentHostId] = totalContentHosts;
1056 
1057 		emit HostContent(_contentHost.host, _contentHost.contentHostId, _contentHost.stakedContentId, _contentHost.contentId, _contentHost.contentDatKey, _contentHost.metadataDatKey);
1058 		return true;
1059 	}
1060 
1061 	/**
1062 	 * @dev Check whether or not the passed params are valid
1063 	 * @param _purchaseReceiptId The ID of the Purchase Receipt
1064 	 * @param _sender The address of the sender
1065 	 * @param _baseChallengeV The V part of signature when signing the base challenge
1066 	 * @param _baseChallengeR The R part of signature when signing the base challenge
1067 	 * @param _baseChallengeS The S part of signature when signing the base challenge
1068 	 * @return true if yes, false otherwise
1069 	 */
1070 	function _canBecomeHost(bytes32 _purchaseReceiptId, address _sender, uint8 _baseChallengeV, bytes32 _baseChallengeR, bytes32 _baseChallengeS) internal view returns (bool) {
1071 		// Make sure the purchase receipt owner is the same as the sender
1072 		return (_aoPurchaseReceipt.senderIsBuyer(_purchaseReceiptId, _sender) &&
1073 			_verifyBecomeHostSignature(_purchaseReceiptId, _baseChallengeV, _baseChallengeR, _baseChallengeS)
1074 		);
1075 	}
1076 
1077 	/**
1078 	 * @dev Verify the become host signature
1079 	 * @param _purchaseReceiptId The ID of the purchase receipt
1080 	 * @param _v part of the signature
1081 	 * @param _r part of the signature
1082 	 * @param _s part of the signature
1083 	 * @return true if valid, false otherwise
1084 	 */
1085 	function _verifyBecomeHostSignature(bytes32 _purchaseReceiptId, uint8 _v, bytes32 _r, bytes32 _s) internal view returns (bool) {
1086 		(,, bytes32 _contentId,,,,,, address _publicAddress,) = _aoPurchaseReceipt.getById(_purchaseReceiptId);
1087 
1088 		bytes32 _hash = keccak256(abi.encodePacked(address(this), _aoContent.getBaseChallenge(_contentId)));
1089 		return (ecrecover(_hash, _v, _r, _s) == _publicAddress);
1090 	}
1091 }