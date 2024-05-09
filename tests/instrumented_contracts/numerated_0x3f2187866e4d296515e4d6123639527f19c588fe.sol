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
113 interface INameFactory {
114 	function nonces(address _nameId) external view returns (uint256);
115 	function incrementNonce(address _nameId) external returns (uint256);
116 	function ethAddressToNameId(address _ethAddress) external view returns (address);
117 	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
118 	function nameIdToEthAddress(address _nameId) external view returns (address);
119 }
120 
121 
122 interface ITAOCurrencyTreasury {
123 	function toBase(uint256 integerAmount, uint256 fractionAmount, bytes8 denominationName) external view returns (uint256);
124 	function isDenominationExist(bytes8 denominationName) external view returns (bool);
125 }
126 
127 
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
704 
705 
706 
707 
708 
709 
710 /**
711  * @title TAOCurrency
712  */
713 contract TAOCurrency is TheAO {
714 	using SafeMath for uint256;
715 
716 	// Public variables of the contract
717 	string public name;
718 	string public symbol;
719 	uint8 public decimals;
720 
721 	// To differentiate denomination of TAO Currency
722 	uint256 public powerOfTen;
723 
724 	uint256 public totalSupply;
725 
726 	// This creates an array with all balances
727 	// address is the address of nameId, not the eth public address
728 	mapping (address => uint256) public balanceOf;
729 
730 	// This generates a public event on the blockchain that will notify clients
731 	// address is the address of TAO/Name Id, not eth public address
732 	event Transfer(address indexed from, address indexed to, uint256 value);
733 
734 	// This notifies clients about the amount burnt
735 	// address is the address of TAO/Name Id, not eth public address
736 	event Burn(address indexed from, uint256 value);
737 
738 	/**
739 	 * Constructor function
740 	 *
741 	 * Initializes contract with initial supply TAOCurrency to the creator of the contract
742 	 */
743 	constructor (string memory _name, string memory _symbol, address _nameTAOPositionAddress) public {
744 		name = _name;		// Set the name for display purposes
745 		symbol = _symbol;	// Set the symbol for display purposes
746 
747 		powerOfTen = 0;
748 		decimals = 0;
749 
750 		setNameTAOPositionAddress(_nameTAOPositionAddress);
751 	}
752 
753 	/**
754 	 * @dev Checks if the calling contract address is The AO
755 	 *		OR
756 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
757 	 */
758 	modifier onlyTheAO {
759 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
760 		_;
761 	}
762 
763 	/**
764 	 * @dev Check if `_id` is a Name or a TAO
765 	 */
766 	modifier isNameOrTAO(address _id) {
767 		require (AOLibrary.isName(_id) || AOLibrary.isTAO(_id));
768 		_;
769 	}
770 
771 	/***** The AO ONLY METHODS *****/
772 	/**
773 	 * @dev Transfer ownership of The AO to new address
774 	 * @param _theAO The new address to be transferred
775 	 */
776 	function transferOwnership(address _theAO) public onlyTheAO {
777 		require (_theAO != address(0));
778 		theAO = _theAO;
779 	}
780 
781 	/**
782 	 * @dev Whitelist `_account` address to transact on behalf of others
783 	 * @param _account The address to whitelist
784 	 * @param _whitelist Either to whitelist or not
785 	 */
786 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
787 		require (_account != address(0));
788 		whitelist[_account] = _whitelist;
789 	}
790 
791 	/**
792 	 * @dev The AO set the NameTAOPosition Address
793 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
794 	 */
795 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
796 		require (_nameTAOPositionAddress != address(0));
797 		nameTAOPositionAddress = _nameTAOPositionAddress;
798 	}
799 
800 	/***** PUBLIC METHODS *****/
801 	/**
802 	 * @dev transfer TAOCurrency from other address
803 	 *
804 	 * Send `_value` TAOCurrency to `_to` in behalf of `_from`
805 	 *
806 	 * @param _from The address of the sender
807 	 * @param _to The address of the recipient
808 	 * @param _value the amount to send
809 	 */
810 	function transferFrom(address _from, address _to, uint256 _value) public inWhitelist isNameOrTAO(_from) isNameOrTAO(_to) returns (bool) {
811 		_transfer(_from, _to, _value);
812 		return true;
813 	}
814 
815 	/**
816 	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
817 	 * @param target Address to receive TAOCurrency
818 	 * @param mintedAmount The amount of TAOCurrency it will receive
819 	 * @return true on success
820 	 */
821 	function mint(address target, uint256 mintedAmount) public inWhitelist isNameOrTAO(target) returns (bool) {
822 		_mint(target, mintedAmount);
823 		return true;
824 	}
825 
826 	/**
827 	 *
828 	 * @dev Whitelisted address remove `_value` TAOCurrency from the system irreversibly on behalf of `_from`.
829 	 *
830 	 * @param _from the address of the sender
831 	 * @param _value the amount of money to burn
832 	 */
833 	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist isNameOrTAO(_from) returns (bool success) {
834 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
835 		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
836 		totalSupply = totalSupply.sub(_value);              // Update totalSupply
837 		emit Burn(_from, _value);
838 		return true;
839 	}
840 
841 	/***** INTERNAL METHODS *****/
842 	/**
843 	 * @dev Send `_value` TAOCurrency from `_from` to `_to`
844 	 * @param _from The address of sender
845 	 * @param _to The address of the recipient
846 	 * @param _value The amount to send
847 	 */
848 	function _transfer(address _from, address _to, uint256 _value) internal {
849 		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
850 		require (balanceOf[_from] >= _value);					// Check if the sender has enough
851 		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
852 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
853 		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
854 		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
855 		emit Transfer(_from, _to, _value);
856 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
857 	}
858 
859 	/**
860 	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
861 	 * @param target Address to receive TAOCurrency
862 	 * @param mintedAmount The amount of TAOCurrency it will receive
863 	 */
864 	function _mint(address target, uint256 mintedAmount) internal {
865 		balanceOf[target] = balanceOf[target].add(mintedAmount);
866 		totalSupply = totalSupply.add(mintedAmount);
867 		emit Transfer(address(0), address(this), mintedAmount);
868 		emit Transfer(address(this), target, mintedAmount);
869 	}
870 }
871 
872 
873 
874 /**
875  * @title TAOCurrency
876  *
877  * The purpose of this contract is to list all of the valid denominations of TAOCurrency and do the conversion between denominations
878  */
879 contract TAOCurrencyTreasury is TheAO, ITAOCurrencyTreasury {
880 	using SafeMath for uint256;
881 
882 	uint256 public totalDenominations;
883 	uint256 public totalDenominationExchanges;
884 
885 	address public nameFactoryAddress;
886 
887 	INameFactory internal _nameFactory;
888 
889 	struct Denomination {
890 		bytes8 name;
891 		address denominationAddress;
892 	}
893 
894 	struct DenominationExchange {
895 		bytes32 exchangeId;
896 		address nameId;			// The nameId that perform this exchange
897 		address fromDenominationAddress;	// The address of the from denomination
898 		address toDenominationAddress;		// The address of the target denomination
899 		uint256 amount;
900 	}
901 
902 	// Mapping from denomination index to Denomination object
903 	// The list is in order from lowest denomination to highest denomination
904 	// i.e, denominations[1] is the base denomination
905 	mapping (uint256 => Denomination) internal denominations;
906 
907 	// Mapping from denomination ID to index of denominations
908 	mapping (bytes8 => uint256) internal denominationIndex;
909 
910 	// Mapping from exchange id to DenominationExchange object
911 	mapping (uint256 => DenominationExchange) internal denominationExchanges;
912 	mapping (bytes32 => uint256) internal denominationExchangeIdLookup;
913 
914 	// Event to be broadcasted to public when a exchange between denominations happens
915 	event ExchangeDenomination(address indexed nameId, bytes32 indexed exchangeId, uint256 amount, address fromDenominationAddress, string fromDenominationSymbol, address toDenominationAddress, string toDenominationSymbol);
916 
917 	/**
918 	 * @dev Constructor function
919 	 */
920 	constructor(address _nameFactoryAddress, address _nameTAOPositionAddress) public {
921 		setNameFactoryAddress(_nameFactoryAddress);
922 		setNameTAOPositionAddress(_nameTAOPositionAddress);
923 	}
924 
925 	/**
926 	 * @dev Checks if the calling contract address is The AO
927 	 *		OR
928 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
929 	 */
930 	modifier onlyTheAO {
931 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
932 		_;
933 	}
934 
935 	/**
936 	 * @dev Checks if denomination is valid
937 	 */
938 	modifier isValidDenomination(bytes8 denominationName) {
939 		require (this.isDenominationExist(denominationName));
940 		_;
941 	}
942 
943 	/***** The AO ONLY METHODS *****/
944 	/**
945 	 * @dev Transfer ownership of The AO to new address
946 	 * @param _theAO The new address to be transferred
947 	 */
948 	function transferOwnership(address _theAO) public onlyTheAO {
949 		require (_theAO != address(0));
950 		theAO = _theAO;
951 	}
952 
953 	/**
954 	 * @dev Whitelist `_account` address to transact on behalf of others
955 	 * @param _account The address to whitelist
956 	 * @param _whitelist Either to whitelist or not
957 	 */
958 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
959 		require (_account != address(0));
960 		whitelist[_account] = _whitelist;
961 	}
962 
963 	/**
964 	 * @dev The AO set the NameTAOPosition Address
965 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
966 	 */
967 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
968 		require (_nameTAOPositionAddress != address(0));
969 		nameTAOPositionAddress = _nameTAOPositionAddress;
970 	}
971 
972 	/**
973 	 * @dev The AO set the NameFactory Address
974 	 * @param _nameFactoryAddress The address of NameFactory
975 	 */
976 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
977 		require (_nameFactoryAddress != address(0));
978 		nameFactoryAddress = _nameFactoryAddress;
979 		_nameFactory = INameFactory(_nameFactoryAddress);
980 	}
981 
982 	/**
983 	 * @dev The AO adds denomination and the contract address associated with it
984 	 * @param denominationName The name of the denomination, i.e ao, kilo, mega, etc.
985 	 * @param denominationAddress The address of the denomination TAOCurrency
986 	 * @return true on success
987 	 */
988 	function addDenomination(bytes8 denominationName, address denominationAddress) public onlyTheAO returns (bool) {
989 		require (denominationName.length > 0);
990 		require (denominationName[0] != 0);
991 		require (denominationAddress != address(0));
992 		require (denominationIndex[denominationName] == 0);
993 		totalDenominations++;
994 		// Make sure the new denomination is higher than the previous
995 		if (totalDenominations > 1) {
996 			TAOCurrency _lastDenominationTAOCurrency = TAOCurrency(denominations[totalDenominations - 1].denominationAddress);
997 			TAOCurrency _newDenominationTAOCurrency = TAOCurrency(denominationAddress);
998 			require (_newDenominationTAOCurrency.powerOfTen() > _lastDenominationTAOCurrency.powerOfTen());
999 		}
1000 		denominations[totalDenominations].name = denominationName;
1001 		denominations[totalDenominations].denominationAddress = denominationAddress;
1002 		denominationIndex[denominationName] = totalDenominations;
1003 		return true;
1004 	}
1005 
1006 	/**
1007 	 * @dev The AO updates denomination address or activates/deactivates the denomination
1008 	 * @param denominationName The name of the denomination, i.e ao, kilo, mega, etc.
1009 	 * @param denominationAddress The address of the denomination TAOCurrency
1010 	 * @return true on success
1011 	 */
1012 	function updateDenomination(bytes8 denominationName, address denominationAddress) public onlyTheAO isValidDenomination(denominationName) returns (bool) {
1013 		require (denominationAddress != address(0));
1014 		uint256 _denominationNameIndex = denominationIndex[denominationName];
1015 		TAOCurrency _newDenominationTAOCurrency = TAOCurrency(denominationAddress);
1016 		if (_denominationNameIndex > 1) {
1017 			TAOCurrency _prevDenominationTAOCurrency = TAOCurrency(denominations[_denominationNameIndex - 1].denominationAddress);
1018 			require (_newDenominationTAOCurrency.powerOfTen() > _prevDenominationTAOCurrency.powerOfTen());
1019 		}
1020 		if (_denominationNameIndex < totalDenominations) {
1021 			TAOCurrency _lastDenominationTAOCurrency = TAOCurrency(denominations[totalDenominations].denominationAddress);
1022 			require (_newDenominationTAOCurrency.powerOfTen() < _lastDenominationTAOCurrency.powerOfTen());
1023 		}
1024 		denominations[denominationIndex[denominationName]].denominationAddress = denominationAddress;
1025 		return true;
1026 	}
1027 
1028 	/***** PUBLIC METHODS *****/
1029 	/**
1030 	 * @dev Check if denomination exist given a name
1031 	 * @param denominationName The denomination name to check
1032 	 * @return true if yes. false otherwise
1033 	 */
1034 	function isDenominationExist(bytes8 denominationName) external view returns (bool) {
1035 		return (denominationName.length > 0 &&
1036 			denominationName[0] != 0 &&
1037 			denominationIndex[denominationName] > 0 &&
1038 			denominations[denominationIndex[denominationName]].denominationAddress != address(0)
1039 	   );
1040 	}
1041 
1042 	/**
1043 	 * @dev Get denomination info based on name
1044 	 * @param denominationName The name to be queried
1045 	 * @return the denomination short name
1046 	 * @return the denomination address
1047 	 * @return the denomination public name
1048 	 * @return the denomination symbol
1049 	 * @return the denomination num of decimals
1050 	 * @return the denomination multiplier (power of ten)
1051 	 */
1052 	function getDenominationByName(bytes8 denominationName) public isValidDenomination(denominationName) view returns (bytes8, address, string memory, string memory, uint8, uint256) {
1053 		TAOCurrency _tc = TAOCurrency(denominations[denominationIndex[denominationName]].denominationAddress);
1054 		return (
1055 			denominations[denominationIndex[denominationName]].name,
1056 			denominations[denominationIndex[denominationName]].denominationAddress,
1057 			_tc.name(),
1058 			_tc.symbol(),
1059 			_tc.decimals(),
1060 			_tc.powerOfTen()
1061 		);
1062 	}
1063 
1064 	/**
1065 	 * @dev Get denomination info by index
1066 	 * @param index The index to be queried
1067 	 * @return the denomination short name
1068 	 * @return the denomination address
1069 	 * @return the denomination public name
1070 	 * @return the denomination symbol
1071 	 * @return the denomination num of decimals
1072 	 * @return the denomination multiplier (power of ten)
1073 	 */
1074 	function getDenominationByIndex(uint256 index) public view returns (bytes8, address, string memory, string memory, uint8, uint256) {
1075 		require (index > 0 && index <= totalDenominations);
1076 		require (denominations[index].denominationAddress != address(0));
1077 		TAOCurrency _tc = TAOCurrency(denominations[index].denominationAddress);
1078 		return (
1079 			denominations[index].name,
1080 			denominations[index].denominationAddress,
1081 			_tc.name(),
1082 			_tc.symbol(),
1083 			_tc.decimals(),
1084 			_tc.powerOfTen()
1085 		);
1086 	}
1087 
1088 	/**
1089 	 * @dev Get base denomination info
1090 	 * @return the denomination short name
1091 	 * @return the denomination address
1092 	 * @return the denomination public name
1093 	 * @return the denomination symbol
1094 	 * @return the denomination num of decimals
1095 	 * @return the denomination multiplier (power of ten)
1096 	 */
1097 	function getBaseDenomination() public view returns (bytes8, address, string memory, string memory, uint8, uint256) {
1098 		require (totalDenominations > 0);
1099 		return getDenominationByIndex(1);
1100 	}
1101 
1102 	/**
1103 	 * @dev convert TAOCurrency from `denominationName` denomination to base denomination,
1104 	 *		in this case it's similar to web3.toWei() functionality
1105 	 *
1106 	 * Example:
1107 	 * 9.1 Kilo should be entered as 9 integerAmount and 100 fractionAmount
1108 	 * 9.02 Kilo should be entered as 9 integerAmount and 20 fractionAmount
1109 	 * 9.001 Kilo should be entered as 9 integerAmount and 1 fractionAmount
1110 	 *
1111 	 * @param integerAmount uint256 of the integer amount to be converted
1112 	 * @param fractionAmount uint256 of the frational amount to be converted
1113 	 * @param denominationName bytes8 name of the TAOCurrency denomination
1114 	 * @return uint256 converted amount in base denomination from target denomination
1115 	 */
1116 	function toBase(uint256 integerAmount, uint256 fractionAmount, bytes8 denominationName) external view returns (uint256) {
1117 		uint256 _fractionAmount = fractionAmount;
1118 		if (this.isDenominationExist(denominationName) && (integerAmount > 0 || _fractionAmount > 0)) {
1119 			Denomination memory _denomination = denominations[denominationIndex[denominationName]];
1120 			TAOCurrency _denominationTAOCurrency = TAOCurrency(_denomination.denominationAddress);
1121 			uint8 fractionNumDigits = AOLibrary.numDigits(_fractionAmount);
1122 			require (fractionNumDigits <= _denominationTAOCurrency.decimals());
1123 			uint256 baseInteger = integerAmount.mul(10 ** _denominationTAOCurrency.powerOfTen());
1124 			if (_denominationTAOCurrency.decimals() == 0) {
1125 				_fractionAmount = 0;
1126 			}
1127 			return baseInteger.add(_fractionAmount);
1128 		} else {
1129 			return 0;
1130 		}
1131 	}
1132 
1133 	/**
1134 	 * @dev convert TAOCurrency from base denomination to `denominationName` denomination,
1135 	 *		in this case it's similar to web3.fromWei() functionality
1136 	 * @param integerAmount uint256 of the base amount to be converted
1137 	 * @param denominationName bytes8 name of the target TAOCurrency denomination
1138 	 * @return uint256 of the converted integer amount in target denomination
1139 	 * @return uint256 of the converted fraction amount in target denomination
1140 	 */
1141 	function fromBase(uint256 integerAmount, bytes8 denominationName) public view returns (uint256, uint256) {
1142 		if (this.isDenominationExist(denominationName)) {
1143 			Denomination memory _denomination = denominations[denominationIndex[denominationName]];
1144 			TAOCurrency _denominationTAOCurrency = TAOCurrency(_denomination.denominationAddress);
1145 			uint256 denominationInteger = integerAmount.div(10 ** _denominationTAOCurrency.powerOfTen());
1146 			uint256 denominationFraction = integerAmount.sub(denominationInteger.mul(10 ** _denominationTAOCurrency.powerOfTen()));
1147 			return (denominationInteger, denominationFraction);
1148 		} else {
1149 			return (0, 0);
1150 		}
1151 	}
1152 
1153 	/**
1154 	 * @dev exchange `amount` TAOCurrency from `fromDenominationName` denomination to TAOCurrency in `toDenominationName` denomination
1155 	 * @param amount The amount of TAOCurrency to exchange
1156 	 * @param fromDenominationName The origin denomination
1157 	 * @param toDenominationName The target denomination
1158 	 */
1159 	function exchangeDenomination(uint256 amount, bytes8 fromDenominationName, bytes8 toDenominationName) public isValidDenomination(fromDenominationName) isValidDenomination(toDenominationName) {
1160 		address _nameId = _nameFactory.ethAddressToNameId(msg.sender);
1161 		require (_nameId != address(0));
1162 		require (amount > 0);
1163 		Denomination memory _fromDenomination = denominations[denominationIndex[fromDenominationName]];
1164 		Denomination memory _toDenomination = denominations[denominationIndex[toDenominationName]];
1165 		TAOCurrency _fromDenominationCurrency = TAOCurrency(_fromDenomination.denominationAddress);
1166 		TAOCurrency _toDenominationCurrency = TAOCurrency(_toDenomination.denominationAddress);
1167 		require (_fromDenominationCurrency.whitelistBurnFrom(_nameId, amount));
1168 		require (_toDenominationCurrency.mint(_nameId, amount));
1169 
1170 		// Store the DenominationExchange information
1171 		totalDenominationExchanges++;
1172 		bytes32 _exchangeId = keccak256(abi.encodePacked(this, _nameId, totalDenominationExchanges));
1173 		denominationExchangeIdLookup[_exchangeId] = totalDenominationExchanges;
1174 
1175 		DenominationExchange storage _denominationExchange = denominationExchanges[totalDenominationExchanges];
1176 		_denominationExchange.exchangeId = _exchangeId;
1177 		_denominationExchange.nameId = _nameId;
1178 		_denominationExchange.fromDenominationAddress = _fromDenomination.denominationAddress;
1179 		_denominationExchange.toDenominationAddress = _toDenomination.denominationAddress;
1180 		_denominationExchange.amount = amount;
1181 
1182 		emit ExchangeDenomination(_nameId, _exchangeId, amount, _fromDenomination.denominationAddress, TAOCurrency(_fromDenomination.denominationAddress).symbol(), _toDenomination.denominationAddress, TAOCurrency(_toDenomination.denominationAddress).symbol());
1183 	}
1184 
1185 	/**
1186 	 * @dev Get DenominationExchange information given an exchange ID
1187 	 * @param _exchangeId The exchange ID to query
1188 	 * @return The name ID that performed the exchange
1189 	 * @return The from denomination address
1190 	 * @return The to denomination address
1191 	 * @return The from denomination symbol
1192 	 * @return The to denomination symbol
1193 	 * @return The amount exchanged
1194 	 */
1195 	function getDenominationExchangeById(bytes32 _exchangeId) public view returns (address, address, address, string memory, string memory, uint256) {
1196 		require (denominationExchangeIdLookup[_exchangeId] > 0);
1197 		DenominationExchange memory _denominationExchange = denominationExchanges[denominationExchangeIdLookup[_exchangeId]];
1198 		return (
1199 			_denominationExchange.nameId,
1200 			_denominationExchange.fromDenominationAddress,
1201 			_denominationExchange.toDenominationAddress,
1202 			TAOCurrency(_denominationExchange.fromDenominationAddress).symbol(),
1203 			TAOCurrency(_denominationExchange.toDenominationAddress).symbol(),
1204 			_denominationExchange.amount
1205 		);
1206 	}
1207 
1208 	/**
1209 	 * @dev Return the highest possible denomination given a base amount
1210 	 * @param amount The amount to be converted
1211 	 * @return the denomination short name
1212 	 * @return the denomination address
1213 	 * @return the integer amount at the denomination level
1214 	 * @return the fraction amount at the denomination level
1215 	 * @return the denomination public name
1216 	 * @return the denomination symbol
1217 	 * @return the denomination num of decimals
1218 	 * @return the denomination multiplier (power of ten)
1219 	 */
1220 	function toHighestDenomination(uint256 amount) public view returns (bytes8, address, uint256, uint256, string memory, string memory, uint8, uint256) {
1221 		uint256 integerAmount;
1222 		uint256 fractionAmount;
1223 		uint256 index;
1224 		for (uint256 i=totalDenominations; i>0; i--) {
1225 			Denomination memory _denomination = denominations[i];
1226 			(integerAmount, fractionAmount) = fromBase(amount, _denomination.name);
1227 			if (integerAmount > 0) {
1228 				index = i;
1229 				break;
1230 			}
1231 		}
1232 		require (index > 0 && index <= totalDenominations);
1233 		require (integerAmount > 0 || fractionAmount > 0);
1234 		require (denominations[index].denominationAddress != address(0));
1235 		TAOCurrency _tc = TAOCurrency(denominations[index].denominationAddress);
1236 		return (
1237 			denominations[index].name,
1238 			denominations[index].denominationAddress,
1239 			integerAmount,
1240 			fractionAmount,
1241 			_tc.name(),
1242 			_tc.symbol(),
1243 			_tc.decimals(),
1244 			_tc.powerOfTen()
1245 		);
1246 	}
1247 }
1248 
1249 
1250 /**
1251  * @title PathosTreasury
1252  *
1253  * The purpose of this contract is to list all of the valid denominations of Pathos and do the conversion between denominations
1254  */
1255 contract PathosTreasury is TAOCurrencyTreasury {
1256 	/**
1257 	 * @dev Constructor function
1258 	 */
1259 	constructor(address _nameFactoryAddress, address _nameTAOPositionAddress)
1260 		TAOCurrencyTreasury(_nameFactoryAddress, _nameTAOPositionAddress) public {}
1261 }