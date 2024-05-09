1 pragma solidity >=0.5.4 <0.6.0;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
4 
5 
6 interface INameAccountRecovery {
7 	function isCompromised(address _id) external view returns (bool);
8 }
9 
10 
11 interface INamePublicKey {
12 	function initialize(address _id, address _defaultKey, address _writerKey) external returns (bool);
13 
14 	function isKeyExist(address _id, address _key) external view returns (bool);
15 
16 	function getDefaultKey(address _id) external view returns (address);
17 
18 	function whitelistAddKey(address _id, address _key) external returns (bool);
19 }
20 
21 
22 interface INameTAOPosition {
23 	function senderIsAdvocate(address _sender, address _id) external view returns (bool);
24 	function senderIsListener(address _sender, address _id) external view returns (bool);
25 	function senderIsSpeaker(address _sender, address _id) external view returns (bool);
26 	function senderIsPosition(address _sender, address _id) external view returns (bool);
27 	function getAdvocate(address _id) external view returns (address);
28 	function nameIsAdvocate(address _nameId, address _id) external view returns (bool);
29 	function nameIsPosition(address _nameId, address _id) external view returns (bool);
30 	function initialize(address _id, address _advocateId, address _listenerId, address _speakerId) external returns (bool);
31 	function determinePosition(address _sender, address _id) external view returns (uint256);
32 }
33 
34 
35 contract TheAO {
36 	address public theAO;
37 	address public nameTAOPositionAddress;
38 
39 	// Check whether an address is whitelisted and granted access to transact
40 	// on behalf of others
41 	mapping (address => bool) public whitelist;
42 
43 	constructor() public {
44 		theAO = msg.sender;
45 	}
46 
47 	/**
48 	 * @dev Checks if msg.sender is in whitelist.
49 	 */
50 	modifier inWhitelist() {
51 		require (whitelist[msg.sender] == true);
52 		_;
53 	}
54 
55 	/**
56 	 * @dev Transfer ownership of The AO to new address
57 	 * @param _theAO The new address to be transferred
58 	 */
59 	function transferOwnership(address _theAO) public {
60 		require (msg.sender == theAO);
61 		require (_theAO != address(0));
62 		theAO = _theAO;
63 	}
64 
65 	/**
66 	 * @dev Whitelist `_account` address to transact on behalf of others
67 	 * @param _account The address to whitelist
68 	 * @param _whitelist Either to whitelist or not
69 	 */
70 	function setWhitelist(address _account, bool _whitelist) public {
71 		require (msg.sender == theAO);
72 		require (_account != address(0));
73 		whitelist[_account] = _whitelist;
74 	}
75 }
76 
77 
78 /**
79  * @title SafeMath
80  * @dev Math operations with safety checks that throw on error
81  */
82 library SafeMath {
83 
84 	/**
85 	 * @dev Multiplies two numbers, throws on overflow.
86 	 */
87 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
88 		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
89 		// benefit is lost if 'b' is also tested.
90 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
91 		if (a == 0) {
92 			return 0;
93 		}
94 
95 		c = a * b;
96 		assert(c / a == b);
97 		return c;
98 	}
99 
100 	/**
101 	 * @dev Integer division of two numbers, truncating the quotient.
102 	 */
103 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
104 		// assert(b > 0); // Solidity automatically throws when dividing by 0
105 		// uint256 c = a / b;
106 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
107 		return a / b;
108 	}
109 
110 	/**
111 	 * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
112 	 */
113 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114 		assert(b <= a);
115 		return a - b;
116 	}
117 
118 	/**
119 	 * @dev Adds two numbers, throws on overflow.
120 	 */
121 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
122 		c = a + b;
123 		assert(c >= a);
124 		return c;
125 	}
126 }
127 
128 
129 interface IAOTreasury {
130 	function toBase(uint256 integerAmount, uint256 fractionAmount, bytes8 denominationName) external view returns (uint256);
131 	function isDenominationExist(bytes8 denominationName) external view returns (bool);
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
709 
710 
711 
712 
713 
714 
715 
716 
717 
718 interface ionRecipient {
719 	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
720 }
721 
722 /**
723  * @title AOIonInterface
724  */
725 contract AOIonInterface is TheAO {
726 	using SafeMath for uint256;
727 
728 	address public namePublicKeyAddress;
729 	address public nameAccountRecoveryAddress;
730 
731 	INameTAOPosition internal _nameTAOPosition;
732 	INamePublicKey internal _namePublicKey;
733 	INameAccountRecovery internal _nameAccountRecovery;
734 
735 	// Public variables of the contract
736 	string public name;
737 	string public symbol;
738 	uint8 public decimals;
739 	uint256 public totalSupply;
740 
741 	// To differentiate denomination of AO
742 	uint256 public powerOfTen;
743 
744 	/***** NETWORK ION VARIABLES *****/
745 	uint256 public sellPrice;
746 	uint256 public buyPrice;
747 
748 	// This creates an array with all balances
749 	mapping (address => uint256) public balanceOf;
750 	mapping (address => mapping (address => uint256)) public allowance;
751 	mapping (address => bool) public frozenAccount;
752 	mapping (address => uint256) public stakedBalance;
753 	mapping (address => uint256) public escrowedBalance;
754 
755 	// This generates a public event on the blockchain that will notify clients
756 	event FrozenFunds(address target, bool frozen);
757 	event Stake(address indexed from, uint256 value);
758 	event Unstake(address indexed from, uint256 value);
759 	event Escrow(address indexed from, address indexed to, uint256 value);
760 	event Unescrow(address indexed from, uint256 value);
761 
762 	// This generates a public event on the blockchain that will notify clients
763 	event Transfer(address indexed from, address indexed to, uint256 value);
764 
765 	// This generates a public event on the blockchain that will notify clients
766 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
767 
768 	// This notifies clients about the amount burnt
769 	event Burn(address indexed from, uint256 value);
770 
771 	/**
772 	 * @dev Constructor function
773 	 */
774 	constructor(string memory _name, string memory _symbol, address _nameTAOPositionAddress, address _namePublicKeyAddress, address _nameAccountRecoveryAddress) public {
775 		setNameTAOPositionAddress(_nameTAOPositionAddress);
776 		setNamePublicKeyAddress(_namePublicKeyAddress);
777 		setNameAccountRecoveryAddress(_nameAccountRecoveryAddress);
778 		name = _name;           // Set the name for display purposes
779 		symbol = _symbol;       // Set the symbol for display purposes
780 		powerOfTen = 0;
781 		decimals = 0;
782 	}
783 
784 	/**
785 	 * @dev Checks if the calling contract address is The AO
786 	 *		OR
787 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
788 	 */
789 	modifier onlyTheAO {
790 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
791 		_;
792 	}
793 
794 	/***** The AO ONLY METHODS *****/
795 	/**
796 	 * @dev Transfer ownership of The AO to new address
797 	 * @param _theAO The new address to be transferred
798 	 */
799 	function transferOwnership(address _theAO) public onlyTheAO {
800 		require (_theAO != address(0));
801 		theAO = _theAO;
802 	}
803 
804 	/**
805 	 * @dev Whitelist `_account` address to transact on behalf of others
806 	 * @param _account The address to whitelist
807 	 * @param _whitelist Either to whitelist or not
808 	 */
809 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
810 		require (_account != address(0));
811 		whitelist[_account] = _whitelist;
812 	}
813 
814 	/**
815 	 * @dev The AO set the NameTAOPosition Address
816 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
817 	 */
818 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
819 		require (_nameTAOPositionAddress != address(0));
820 		nameTAOPositionAddress = _nameTAOPositionAddress;
821 		_nameTAOPosition = INameTAOPosition(nameTAOPositionAddress);
822 	}
823 
824 	/**
825 	 * @dev The AO set the NamePublicKey Address
826 	 * @param _namePublicKeyAddress The address of NamePublicKey
827 	 */
828 	function setNamePublicKeyAddress(address _namePublicKeyAddress) public onlyTheAO {
829 		require (_namePublicKeyAddress != address(0));
830 		namePublicKeyAddress = _namePublicKeyAddress;
831 		_namePublicKey = INamePublicKey(namePublicKeyAddress);
832 	}
833 
834 	/**
835 	 * @dev The AO set the NameAccountRecovery Address
836 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
837 	 */
838 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
839 		require (_nameAccountRecoveryAddress != address(0));
840 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
841 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
842 	}
843 
844 	/**
845 	 * @dev Allows TheAO to transfer `_amount` of ETH from this address to `_recipient`
846 	 * @param _recipient The recipient address
847 	 * @param _amount The amount to transfer
848 	 */
849 	function transferEth(address payable _recipient, uint256 _amount) public onlyTheAO {
850 		require (_recipient != address(0));
851 		_recipient.transfer(_amount);
852 	}
853 
854 	/**
855 	 * @dev Prevent/Allow target from sending & receiving ions
856 	 * @param target Address to be frozen
857 	 * @param freeze Either to freeze it or not
858 	 */
859 	function freezeAccount(address target, bool freeze) public onlyTheAO {
860 		frozenAccount[target] = freeze;
861 		emit FrozenFunds(target, freeze);
862 	}
863 
864 	/**
865 	 * @dev Allow users to buy ions for `newBuyPrice` eth and sell ions for `newSellPrice` eth
866 	 * @param newSellPrice Price users can sell to the contract
867 	 * @param newBuyPrice Price users can buy from the contract
868 	 */
869 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyTheAO {
870 		sellPrice = newSellPrice;
871 		buyPrice = newBuyPrice;
872 	}
873 
874 	/***** NETWORK ION WHITELISTED ADDRESS ONLY METHODS *****/
875 	/**
876 	 * @dev Create `mintedAmount` ions and send it to `target`
877 	 * @param target Address to receive the ions
878 	 * @param mintedAmount The amount of ions it will receive
879 	 * @return true on success
880 	 */
881 	function mint(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
882 		_mint(target, mintedAmount);
883 		return true;
884 	}
885 
886 	/**
887 	 * @dev Stake `_value` ions on behalf of `_from`
888 	 * @param _from The address of the target
889 	 * @param _value The amount to stake
890 	 * @return true on success
891 	 */
892 	function stakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
893 		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
894 		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
895 		stakedBalance[_from] = stakedBalance[_from].add(_value);	// Add to the targeted staked balance
896 		emit Stake(_from, _value);
897 		return true;
898 	}
899 
900 	/**
901 	 * @dev Unstake `_value` ions on behalf of `_from`
902 	 * @param _from The address of the target
903 	 * @param _value The amount to unstake
904 	 * @return true on success
905 	 */
906 	function unstakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
907 		require (stakedBalance[_from] >= _value);					// Check if the targeted staked balance is enough
908 		stakedBalance[_from] = stakedBalance[_from].sub(_value);	// Subtract from the targeted staked balance
909 		balanceOf[_from] = balanceOf[_from].add(_value);			// Add to the targeted balance
910 		emit Unstake(_from, _value);
911 		return true;
912 	}
913 
914 	/**
915 	 * @dev Store `_value` from `_from` to `_to` in escrow
916 	 * @param _from The address of the sender
917 	 * @param _to The address of the recipient
918 	 * @param _value The amount of network ions to put in escrow
919 	 * @return true on success
920 	 */
921 	function escrowFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool) {
922 		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
923 		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
924 		escrowedBalance[_to] = escrowedBalance[_to].add(_value);	// Add to the targeted escrowed balance
925 		emit Escrow(_from, _to, _value);
926 		return true;
927 	}
928 
929 	/**
930 	 * @dev Create `mintedAmount` ions and send it to `target` escrow balance
931 	 * @param target Address to receive ions
932 	 * @param mintedAmount The amount of ions it will receive in escrow
933 	 */
934 	function mintEscrow(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
935 		escrowedBalance[target] = escrowedBalance[target].add(mintedAmount);
936 		totalSupply = totalSupply.add(mintedAmount);
937 		emit Escrow(address(this), target, mintedAmount);
938 		return true;
939 	}
940 
941 	/**
942 	 * @dev Release escrowed `_value` from `_from`
943 	 * @param _from The address of the sender
944 	 * @param _value The amount of escrowed network ions to be released
945 	 * @return true on success
946 	 */
947 	function unescrowFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
948 		require (escrowedBalance[_from] >= _value);						// Check if the targeted escrowed balance is enough
949 		escrowedBalance[_from] = escrowedBalance[_from].sub(_value);	// Subtract from the targeted escrowed balance
950 		balanceOf[_from] = balanceOf[_from].add(_value);				// Add to the targeted balance
951 		emit Unescrow(_from, _value);
952 		return true;
953 	}
954 
955 	/**
956 	 *
957 	 * @dev Whitelisted address remove `_value` ions from the system irreversibly on behalf of `_from`.
958 	 *
959 	 * @param _from the address of the sender
960 	 * @param _value the amount of money to burn
961 	 */
962 	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist returns (bool success) {
963 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
964 		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
965 		totalSupply = totalSupply.sub(_value);              // Update totalSupply
966 		emit Burn(_from, _value);
967 		return true;
968 	}
969 
970 	/**
971 	 * @dev Whitelisted address transfer ions from other address
972 	 *
973 	 * Send `_value` ions to `_to` on behalf of `_from`
974 	 *
975 	 * @param _from The address of the sender
976 	 * @param _to The address of the recipient
977 	 * @param _value the amount to send
978 	 */
979 	function whitelistTransferFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool success) {
980 		_transfer(_from, _to, _value);
981 		return true;
982 	}
983 
984 	/***** PUBLIC METHODS *****/
985 	/**
986 	 * Transfer ions
987 	 *
988 	 * Send `_value` ions to `_to` from your account
989 	 *
990 	 * @param _to The address of the recipient
991 	 * @param _value the amount to send
992 	 */
993 	function transfer(address _to, uint256 _value) public returns (bool success) {
994 		_transfer(msg.sender, _to, _value);
995 		return true;
996 	}
997 
998 	/**
999 	 * Transfer ions from other address
1000 	 *
1001 	 * Send `_value` ions to `_to` in behalf of `_from`
1002 	 *
1003 	 * @param _from The address of the sender
1004 	 * @param _to The address of the recipient
1005 	 * @param _value the amount to send
1006 	 */
1007 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
1008 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
1009 		allowance[_from][msg.sender] -= _value;
1010 		_transfer(_from, _to, _value);
1011 		return true;
1012 	}
1013 
1014 	/**
1015 	 * Transfer ions between public key addresses in a Name
1016 	 * @param _nameId The ID of the Name
1017 	 * @param _from The address of the sender
1018 	 * @param _to The address of the recipient
1019 	 * @param _value the amount to send
1020 	 */
1021 	function transferBetweenPublicKeys(address _nameId, address _from, address _to, uint256 _value) public returns (bool success) {
1022 		require (AOLibrary.isName(_nameId));
1023 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _nameId));
1024 		require (!_nameAccountRecovery.isCompromised(_nameId));
1025 		// Make sure _from exist in the Name's Public Keys
1026 		require (_namePublicKey.isKeyExist(_nameId, _from));
1027 		// Make sure _to exist in the Name's Public Keys
1028 		require (_namePublicKey.isKeyExist(_nameId, _to));
1029 		_transfer(_from, _to, _value);
1030 		return true;
1031 	}
1032 
1033 	/**
1034 	 * Set allowance for other address
1035 	 *
1036 	 * Allows `_spender` to spend no more than `_value` ions in your behalf
1037 	 *
1038 	 * @param _spender The address authorized to spend
1039 	 * @param _value the max amount they can spend
1040 	 */
1041 	function approve(address _spender, uint256 _value) public returns (bool success) {
1042 		allowance[msg.sender][_spender] = _value;
1043 		emit Approval(msg.sender, _spender, _value);
1044 		return true;
1045 	}
1046 
1047 	/**
1048 	 * Set allowance for other address and notify
1049 	 *
1050 	 * Allows `_spender` to spend no more than `_value` ions in your behalf, and then ping the contract about it
1051 	 *
1052 	 * @param _spender The address authorized to spend
1053 	 * @param _value the max amount they can spend
1054 	 * @param _extraData some extra information to send to the approved contract
1055 	 */
1056 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
1057 		ionRecipient spender = ionRecipient(_spender);
1058 		if (approve(_spender, _value)) {
1059 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
1060 			return true;
1061 		}
1062 	}
1063 
1064 	/**
1065 	 * Destroy ions
1066 	 *
1067 	 * Remove `_value` ions from the system irreversibly
1068 	 *
1069 	 * @param _value the amount of money to burn
1070 	 */
1071 	function burn(uint256 _value) public returns (bool success) {
1072 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
1073 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
1074 		totalSupply -= _value;                      // Updates totalSupply
1075 		emit Burn(msg.sender, _value);
1076 		return true;
1077 	}
1078 
1079 	/**
1080 	 * Destroy ions from other account
1081 	 *
1082 	 * Remove `_value` ions from the system irreversibly on behalf of `_from`.
1083 	 *
1084 	 * @param _from the address of the sender
1085 	 * @param _value the amount of money to burn
1086 	 */
1087 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
1088 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
1089 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
1090 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
1091 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
1092 		totalSupply -= _value;                              // Update totalSupply
1093 		emit Burn(_from, _value);
1094 		return true;
1095 	}
1096 
1097 	/**
1098 	 * @dev Buy ions from contract by sending ether
1099 	 */
1100 	function buy() public payable {
1101 		require (buyPrice > 0);
1102 		uint256 amount = msg.value.div(buyPrice);
1103 		_transfer(address(this), msg.sender, amount);
1104 	}
1105 
1106 	/**
1107 	 * @dev Sell `amount` ions to contract
1108 	 * @param amount The amount of ions to be sold
1109 	 */
1110 	function sell(uint256 amount) public {
1111 		require (sellPrice > 0);
1112 		address myAddress = address(this);
1113 		require (myAddress.balance >= amount.mul(sellPrice));
1114 		_transfer(msg.sender, address(this), amount);
1115 		msg.sender.transfer(amount.mul(sellPrice));
1116 	}
1117 
1118 	/***** INTERNAL METHODS *****/
1119 	/**
1120 	 * @dev Send `_value` ions from `_from` to `_to`
1121 	 * @param _from The address of sender
1122 	 * @param _to The address of the recipient
1123 	 * @param _value The amount to send
1124 	 */
1125 	function _transfer(address _from, address _to, uint256 _value) internal {
1126 		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
1127 		require (balanceOf[_from] >= _value);					// Check if the sender has enough
1128 		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
1129 		require (!frozenAccount[_from]);						// Check if sender is frozen
1130 		require (!frozenAccount[_to]);							// Check if recipient is frozen
1131 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
1132 		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
1133 		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
1134 		emit Transfer(_from, _to, _value);
1135 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
1136 	}
1137 
1138 	/**
1139 	 * @dev Create `mintedAmount` ions and send it to `target`
1140 	 * @param target Address to receive the ions
1141 	 * @param mintedAmount The amount of ions it will receive
1142 	 */
1143 	function _mint(address target, uint256 mintedAmount) internal {
1144 		balanceOf[target] = balanceOf[target].add(mintedAmount);
1145 		totalSupply = totalSupply.add(mintedAmount);
1146 		emit Transfer(address(0), address(this), mintedAmount);
1147 		emit Transfer(address(this), target, mintedAmount);
1148 	}
1149 }
1150 
1151 
1152 /**
1153  * @title AOTreasury
1154  *
1155  * The purpose of this contract is to list all of the valid denominations of AOIon and do the conversion between denominations
1156  */
1157 contract AOTreasury is TheAO, IAOTreasury {
1158 	using SafeMath for uint256;
1159 
1160 	uint256 public totalDenominations;
1161 	uint256 public totalDenominationExchanges;
1162 
1163 	struct Denomination {
1164 		bytes8 name;
1165 		address denominationAddress;
1166 	}
1167 
1168 	struct DenominationExchange {
1169 		bytes32 exchangeId;
1170 		address sender;			// The sender address
1171 		address fromDenominationAddress;	// The address of the from denomination
1172 		address toDenominationAddress;		// The address of the target denomination
1173 		uint256 amount;
1174 	}
1175 
1176 	// Mapping from denomination index to Denomination object
1177 	// The list is in order from lowest denomination to highest denomination
1178 	// i.e, denominations[1] is the base denomination
1179 	mapping (uint256 => Denomination) internal denominations;
1180 
1181 	// Mapping from denomination ID to index of denominations
1182 	mapping (bytes8 => uint256) internal denominationIndex;
1183 
1184 	// Mapping from exchange id to DenominationExchange object
1185 	mapping (uint256 => DenominationExchange) internal denominationExchanges;
1186 	mapping (bytes32 => uint256) internal denominationExchangeIdLookup;
1187 
1188 	// Event to be broadcasted to public when a exchange between denominations happens
1189 	event ExchangeDenomination(address indexed account, bytes32 indexed exchangeId, uint256 amount, address fromDenominationAddress, string fromDenominationSymbol, address toDenominationAddress, string toDenominationSymbol);
1190 
1191 	/**
1192 	 * @dev Constructor function
1193 	 */
1194 	constructor(address _nameTAOPositionAddress) public {
1195 		setNameTAOPositionAddress(_nameTAOPositionAddress);
1196 	}
1197 
1198 	/**
1199 	 * @dev Checks if the calling contract address is The AO
1200 	 *		OR
1201 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
1202 	 */
1203 	modifier onlyTheAO {
1204 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
1205 		_;
1206 	}
1207 
1208 	/**
1209 	 * @dev Checks if denomination is valid
1210 	 */
1211 	modifier isValidDenomination(bytes8 denominationName) {
1212 		require (this.isDenominationExist(denominationName));
1213 		_;
1214 	}
1215 
1216 	/***** The AO ONLY METHODS *****/
1217 	/**
1218 	 * @dev Transfer ownership of The AO to new address
1219 	 * @param _theAO The new address to be transferred
1220 	 */
1221 	function transferOwnership(address _theAO) public onlyTheAO {
1222 		require (_theAO != address(0));
1223 		theAO = _theAO;
1224 	}
1225 
1226 	/**
1227 	 * @dev Whitelist `_account` address to transact on behalf of others
1228 	 * @param _account The address to whitelist
1229 	 * @param _whitelist Either to whitelist or not
1230 	 */
1231 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
1232 		require (_account != address(0));
1233 		whitelist[_account] = _whitelist;
1234 	}
1235 
1236 	/**
1237 	 * @dev The AO set the NameTAOPosition Address
1238 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
1239 	 */
1240 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
1241 		require (_nameTAOPositionAddress != address(0));
1242 		nameTAOPositionAddress = _nameTAOPositionAddress;
1243 	}
1244 
1245 	/**
1246 	 * @dev The AO adds denomination and the contract address associated with it
1247 	 * @param denominationName The name of the denomination, i.e ao, kilo, mega, etc.
1248 	 * @param denominationAddress The address of the denomination ion
1249 	 * @return true on success
1250 	 */
1251 	function addDenomination(bytes8 denominationName, address denominationAddress) public onlyTheAO returns (bool) {
1252 		require (denominationName.length > 0);
1253 		require (denominationName[0] != 0);
1254 		require (denominationAddress != address(0));
1255 		require (denominationIndex[denominationName] == 0);
1256 		totalDenominations++;
1257 		// Make sure the new denomination is higher than the previous
1258 		if (totalDenominations > 1) {
1259 			AOIonInterface _lastDenominationIon = AOIonInterface(denominations[totalDenominations - 1].denominationAddress);
1260 			AOIonInterface _newDenominationIon = AOIonInterface(denominationAddress);
1261 			require (_newDenominationIon.powerOfTen() > _lastDenominationIon.powerOfTen());
1262 		}
1263 		denominations[totalDenominations].name = denominationName;
1264 		denominations[totalDenominations].denominationAddress = denominationAddress;
1265 		denominationIndex[denominationName] = totalDenominations;
1266 		return true;
1267 	}
1268 
1269 	/**
1270 	 * @dev The AO updates denomination address or activates/deactivates the denomination
1271 	 * @param denominationName The name of the denomination, i.e ao, kilo, mega, etc.
1272 	 * @param denominationAddress The address of the denomination ion
1273 	 * @return true on success
1274 	 */
1275 	function updateDenomination(bytes8 denominationName, address denominationAddress) public onlyTheAO isValidDenomination(denominationName) returns (bool) {
1276 		require (denominationAddress != address(0));
1277 		uint256 _denominationNameIndex = denominationIndex[denominationName];
1278 		AOIonInterface _newDenominationIon = AOIonInterface(denominationAddress);
1279 		if (_denominationNameIndex > 1) {
1280 			AOIonInterface _prevDenominationIon = AOIonInterface(denominations[_denominationNameIndex - 1].denominationAddress);
1281 			require (_newDenominationIon.powerOfTen() > _prevDenominationIon.powerOfTen());
1282 		}
1283 		if (_denominationNameIndex < totalDenominations) {
1284 			AOIonInterface _lastDenominationIon = AOIonInterface(denominations[totalDenominations].denominationAddress);
1285 			require (_newDenominationIon.powerOfTen() < _lastDenominationIon.powerOfTen());
1286 		}
1287 		denominations[denominationIndex[denominationName]].denominationAddress = denominationAddress;
1288 		return true;
1289 	}
1290 
1291 	/***** PUBLIC METHODS *****/
1292 	/**
1293 	 * @dev Check if denomination exist given a name
1294 	 * @param denominationName The denomination name to check
1295 	 * @return true if yes. false otherwise
1296 	 */
1297 	function isDenominationExist(bytes8 denominationName) external view returns (bool) {
1298 		return (denominationName.length > 0 &&
1299 			denominationName[0] != 0 &&
1300 			denominationIndex[denominationName] > 0 &&
1301 			denominations[denominationIndex[denominationName]].denominationAddress != address(0)
1302 	   );
1303 	}
1304 
1305 	/**
1306 	 * @dev Get denomination info based on name
1307 	 * @param denominationName The name to be queried
1308 	 * @return the denomination short name
1309 	 * @return the denomination address
1310 	 * @return the denomination public name
1311 	 * @return the denomination symbol
1312 	 * @return the denomination num of decimals
1313 	 * @return the denomination multiplier (power of ten)
1314 	 */
1315 	function getDenominationByName(bytes8 denominationName) public isValidDenomination(denominationName) view returns (bytes8, address, string memory, string memory, uint8, uint256) {
1316 		AOIonInterface _ao = AOIonInterface(denominations[denominationIndex[denominationName]].denominationAddress);
1317 		return (
1318 			denominations[denominationIndex[denominationName]].name,
1319 			denominations[denominationIndex[denominationName]].denominationAddress,
1320 			_ao.name(),
1321 			_ao.symbol(),
1322 			_ao.decimals(),
1323 			_ao.powerOfTen()
1324 		);
1325 	}
1326 
1327 	/**
1328 	 * @dev Get denomination info by index
1329 	 * @param index The index to be queried
1330 	 * @return the denomination short name
1331 	 * @return the denomination address
1332 	 * @return the denomination public name
1333 	 * @return the denomination symbol
1334 	 * @return the denomination num of decimals
1335 	 * @return the denomination multiplier (power of ten)
1336 	 */
1337 	function getDenominationByIndex(uint256 index) public view returns (bytes8, address, string memory, string memory, uint8, uint256) {
1338 		require (index > 0 && index <= totalDenominations);
1339 		require (denominations[index].denominationAddress != address(0));
1340 		AOIonInterface _ao = AOIonInterface(denominations[index].denominationAddress);
1341 		return (
1342 			denominations[index].name,
1343 			denominations[index].denominationAddress,
1344 			_ao.name(),
1345 			_ao.symbol(),
1346 			_ao.decimals(),
1347 			_ao.powerOfTen()
1348 		);
1349 	}
1350 
1351 	/**
1352 	 * @dev Get base denomination info
1353 	 * @return the denomination short name
1354 	 * @return the denomination address
1355 	 * @return the denomination public name
1356 	 * @return the denomination symbol
1357 	 * @return the denomination num of decimals
1358 	 * @return the denomination multiplier (power of ten)
1359 	 */
1360 	function getBaseDenomination() public view returns (bytes8, address, string memory, string memory, uint8, uint256) {
1361 		require (totalDenominations > 0);
1362 		return getDenominationByIndex(1);
1363 	}
1364 
1365 	/**
1366 	 * @dev convert ion from `denominationName` denomination to base denomination,
1367 	 *		in this case it's similar to web3.toWei() functionality
1368 	 *
1369 	 * Example:
1370 	 * 9.1 Kilo should be entered as 9 integerAmount and 100 fractionAmount
1371 	 * 9.02 Kilo should be entered as 9 integerAmount and 20 fractionAmount
1372 	 * 9.001 Kilo should be entered as 9 integerAmount and 1 fractionAmount
1373 	 *
1374 	 * @param integerAmount uint256 of the integer amount to be converted
1375 	 * @param fractionAmount uint256 of the frational amount to be converted
1376 	 * @param denominationName bytes8 name of the ion denomination
1377 	 * @return uint256 converted amount in base denomination from target denomination
1378 	 */
1379 	function toBase(uint256 integerAmount, uint256 fractionAmount, bytes8 denominationName) external view returns (uint256) {
1380 		uint256 _fractionAmount = fractionAmount;
1381 		if (this.isDenominationExist(denominationName) && (integerAmount > 0 || _fractionAmount > 0)) {
1382 			Denomination memory _denomination = denominations[denominationIndex[denominationName]];
1383 			AOIonInterface _denominationIon = AOIonInterface(_denomination.denominationAddress);
1384 			uint8 fractionNumDigits = AOLibrary.numDigits(_fractionAmount);
1385 			require (fractionNumDigits <= _denominationIon.decimals());
1386 			uint256 baseInteger = integerAmount.mul(10 ** _denominationIon.powerOfTen());
1387 			if (_denominationIon.decimals() == 0) {
1388 				_fractionAmount = 0;
1389 			}
1390 			return baseInteger.add(_fractionAmount);
1391 		} else {
1392 			return 0;
1393 		}
1394 	}
1395 
1396 	/**
1397 	 * @dev convert ion from base denomination to `denominationName` denomination,
1398 	 *		in this case it's similar to web3.fromWei() functionality
1399 	 * @param integerAmount uint256 of the base amount to be converted
1400 	 * @param denominationName bytes8 name of the target ion denomination
1401 	 * @return uint256 of the converted integer amount in target denomination
1402 	 * @return uint256 of the converted fraction amount in target denomination
1403 	 */
1404 	function fromBase(uint256 integerAmount, bytes8 denominationName) public view returns (uint256, uint256) {
1405 		if (this.isDenominationExist(denominationName)) {
1406 			Denomination memory _denomination = denominations[denominationIndex[denominationName]];
1407 			AOIonInterface _denominationIon = AOIonInterface(_denomination.denominationAddress);
1408 			uint256 denominationInteger = integerAmount.div(10 ** _denominationIon.powerOfTen());
1409 			uint256 denominationFraction = integerAmount.sub(denominationInteger.mul(10 ** _denominationIon.powerOfTen()));
1410 			return (denominationInteger, denominationFraction);
1411 		} else {
1412 			return (0, 0);
1413 		}
1414 	}
1415 
1416 	/**
1417 	 * @dev exchange `amount` ion from `fromDenominationName` denomination to ion in `toDenominationName` denomination
1418 	 * @param amount The amount of ion to exchange
1419 	 * @param fromDenominationName The origin denomination
1420 	 * @param toDenominationName The target denomination
1421 	 */
1422 	function exchangeDenomination(uint256 amount, bytes8 fromDenominationName, bytes8 toDenominationName) public isValidDenomination(fromDenominationName) isValidDenomination(toDenominationName) {
1423 		require (amount > 0);
1424 		Denomination memory _fromDenomination = denominations[denominationIndex[fromDenominationName]];
1425 		Denomination memory _toDenomination = denominations[denominationIndex[toDenominationName]];
1426 		AOIonInterface _fromDenominationIon = AOIonInterface(_fromDenomination.denominationAddress);
1427 		AOIonInterface _toDenominationIon = AOIonInterface(_toDenomination.denominationAddress);
1428 		require (_fromDenominationIon.whitelistBurnFrom(msg.sender, amount));
1429 		require (_toDenominationIon.mint(msg.sender, amount));
1430 
1431 		// Store the DenominationExchange information
1432 		totalDenominationExchanges++;
1433 		bytes32 _exchangeId = keccak256(abi.encodePacked(this, msg.sender, totalDenominationExchanges));
1434 		denominationExchangeIdLookup[_exchangeId] = totalDenominationExchanges;
1435 
1436 		DenominationExchange storage _denominationExchange = denominationExchanges[totalDenominationExchanges];
1437 		_denominationExchange.exchangeId = _exchangeId;
1438 		_denominationExchange.sender = msg.sender;
1439 		_denominationExchange.fromDenominationAddress = _fromDenomination.denominationAddress;
1440 		_denominationExchange.toDenominationAddress = _toDenomination.denominationAddress;
1441 		_denominationExchange.amount = amount;
1442 
1443 		emit ExchangeDenomination(msg.sender, _exchangeId, amount, _fromDenomination.denominationAddress, AOIonInterface(_fromDenomination.denominationAddress).symbol(), _toDenomination.denominationAddress, AOIonInterface(_toDenomination.denominationAddress).symbol());
1444 	}
1445 
1446 	/**
1447 	 * @dev Get DenominationExchange information given an exchange ID
1448 	 * @param _exchangeId The exchange ID to query
1449 	 * @return The sender address
1450 	 * @return The from denomination address
1451 	 * @return The to denomination address
1452 	 * @return The from denomination symbol
1453 	 * @return The to denomination symbol
1454 	 * @return The amount exchanged
1455 	 */
1456 	function getDenominationExchangeById(bytes32 _exchangeId) public view returns (address, address, address, string memory, string memory, uint256) {
1457 		require (denominationExchangeIdLookup[_exchangeId] > 0);
1458 		DenominationExchange memory _denominationExchange = denominationExchanges[denominationExchangeIdLookup[_exchangeId]];
1459 		return (
1460 			_denominationExchange.sender,
1461 			_denominationExchange.fromDenominationAddress,
1462 			_denominationExchange.toDenominationAddress,
1463 			AOIonInterface(_denominationExchange.fromDenominationAddress).symbol(),
1464 			AOIonInterface(_denominationExchange.toDenominationAddress).symbol(),
1465 			_denominationExchange.amount
1466 		);
1467 	}
1468 
1469 	/**
1470 	 * @dev Return the highest possible denomination given a base amount
1471 	 * @param amount The amount to be converted
1472 	 * @return the denomination short name
1473 	 * @return the denomination address
1474 	 * @return the integer amount at the denomination level
1475 	 * @return the fraction amount at the denomination level
1476 	 * @return the denomination public name
1477 	 * @return the denomination symbol
1478 	 * @return the denomination num of decimals
1479 	 * @return the denomination multiplier (power of ten)
1480 	 */
1481 	function toHighestDenomination(uint256 amount) public view returns (bytes8, address, uint256, uint256, string memory, string memory, uint8, uint256) {
1482 		uint256 integerAmount;
1483 		uint256 fractionAmount;
1484 		uint256 index;
1485 		for (uint256 i=totalDenominations; i>0; i--) {
1486 			Denomination memory _denomination = denominations[i];
1487 			(integerAmount, fractionAmount) = fromBase(amount, _denomination.name);
1488 			if (integerAmount > 0) {
1489 				index = i;
1490 				break;
1491 			}
1492 		}
1493 		require (index > 0 && index <= totalDenominations);
1494 		require (integerAmount > 0 || fractionAmount > 0);
1495 		require (denominations[index].denominationAddress != address(0));
1496 		AOIonInterface _ao = AOIonInterface(denominations[index].denominationAddress);
1497 		return (
1498 			denominations[index].name,
1499 			denominations[index].denominationAddress,
1500 			integerAmount,
1501 			fractionAmount,
1502 			_ao.name(),
1503 			_ao.symbol(),
1504 			_ao.decimals(),
1505 			_ao.powerOfTen()
1506 		);
1507 	}
1508 }