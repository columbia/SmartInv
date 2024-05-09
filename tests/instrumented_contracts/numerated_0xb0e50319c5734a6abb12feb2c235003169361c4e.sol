1 pragma solidity >=0.5.4 <0.6.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9 	/**
10 	 * @dev Multiplies two numbers, throws on overflow.
11 	 */
12 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13 		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14 		// benefit is lost if 'b' is also tested.
15 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16 		if (a == 0) {
17 			return 0;
18 		}
19 
20 		c = a * b;
21 		assert(c / a == b);
22 		return c;
23 	}
24 
25 	/**
26 	 * @dev Integer division of two numbers, truncating the quotient.
27 	 */
28 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
29 		// assert(b > 0); // Solidity automatically throws when dividing by 0
30 		// uint256 c = a / b;
31 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
32 		return a / b;
33 	}
34 
35 	/**
36 	 * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37 	 */
38 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39 		assert(b <= a);
40 		return a - b;
41 	}
42 
43 	/**
44 	 * @dev Adds two numbers, throws on overflow.
45 	 */
46 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47 		c = a + b;
48 		assert(c >= a);
49 		return c;
50 	}
51 }
52 
53 
54 interface INameTAOPosition {
55 	function senderIsAdvocate(address _sender, address _id) external view returns (bool);
56 	function senderIsListener(address _sender, address _id) external view returns (bool);
57 	function senderIsSpeaker(address _sender, address _id) external view returns (bool);
58 	function senderIsPosition(address _sender, address _id) external view returns (bool);
59 	function getAdvocate(address _id) external view returns (address);
60 	function nameIsAdvocate(address _nameId, address _id) external view returns (bool);
61 	function nameIsPosition(address _nameId, address _id) external view returns (bool);
62 	function initialize(address _id, address _advocateId, address _listenerId, address _speakerId) external returns (bool);
63 	function determinePosition(address _sender, address _id) external view returns (uint256);
64 }
65 
66 
67 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
68 
69 
70 
71 
72 
73 /**
74  * @title TAO
75  */
76 contract TAO {
77 	using SafeMath for uint256;
78 
79 	address public vaultAddress;
80 	string public name;				// the name for this TAO
81 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
82 
83 	// TAO's data
84 	string public datHash;
85 	string public database;
86 	string public keyValue;
87 	bytes32 public contentId;
88 
89 	/**
90 	 * 0 = TAO
91 	 * 1 = Name
92 	 */
93 	uint8 public typeId;
94 
95 	/**
96 	 * @dev Constructor function
97 	 */
98 	constructor (string memory _name,
99 		address _originId,
100 		string memory _datHash,
101 		string memory _database,
102 		string memory _keyValue,
103 		bytes32 _contentId,
104 		address _vaultAddress
105 	) public {
106 		name = _name;
107 		originId = _originId;
108 		datHash = _datHash;
109 		database = _database;
110 		keyValue = _keyValue;
111 		contentId = _contentId;
112 
113 		// Creating TAO
114 		typeId = 0;
115 
116 		vaultAddress = _vaultAddress;
117 	}
118 
119 	/**
120 	 * @dev Checks if calling address is Vault contract
121 	 */
122 	modifier onlyVault {
123 		require (msg.sender == vaultAddress);
124 		_;
125 	}
126 
127 	/**
128 	 * Will receive any ETH sent
129 	 */
130 	function () external payable {
131 	}
132 
133 	/**
134 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
135 	 * @param _recipient The recipient address
136 	 * @param _amount The amount to transfer
137 	 * @return true on success
138 	 */
139 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
140 		_recipient.transfer(_amount);
141 		return true;
142 	}
143 
144 	/**
145 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
146 	 * @param _erc20TokenAddress The address of ERC20 Token
147 	 * @param _recipient The recipient address
148 	 * @param _amount The amount to transfer
149 	 * @return true on success
150 	 */
151 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
152 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
153 		_erc20.transfer(_recipient, _amount);
154 		return true;
155 	}
156 }
157 
158 
159 interface INameAccountRecovery {
160 	function isCompromised(address _id) external view returns (bool);
161 }
162 
163 
164 interface INameFactory {
165 	function nonces(address _nameId) external view returns (uint256);
166 	function incrementNonce(address _nameId) external returns (uint256);
167 	function ethAddressToNameId(address _ethAddress) external view returns (address);
168 	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
169 	function nameIdToEthAddress(address _nameId) external view returns (address);
170 }
171 
172 
173 contract TheAO {
174 	address public theAO;
175 	address public nameTAOPositionAddress;
176 
177 	// Check whether an address is whitelisted and granted access to transact
178 	// on behalf of others
179 	mapping (address => bool) public whitelist;
180 
181 	constructor() public {
182 		theAO = msg.sender;
183 	}
184 
185 	/**
186 	 * @dev Checks if msg.sender is in whitelist.
187 	 */
188 	modifier inWhitelist() {
189 		require (whitelist[msg.sender] == true);
190 		_;
191 	}
192 
193 	/**
194 	 * @dev Transfer ownership of The AO to new address
195 	 * @param _theAO The new address to be transferred
196 	 */
197 	function transferOwnership(address _theAO) public {
198 		require (msg.sender == theAO);
199 		require (_theAO != address(0));
200 		theAO = _theAO;
201 	}
202 
203 	/**
204 	 * @dev Whitelist `_account` address to transact on behalf of others
205 	 * @param _account The address to whitelist
206 	 * @param _whitelist Either to whitelist or not
207 	 */
208 	function setWhitelist(address _account, bool _whitelist) public {
209 		require (msg.sender == theAO);
210 		require (_account != address(0));
211 		whitelist[_account] = _whitelist;
212 	}
213 }
214 
215 
216 interface ITAOFactory {
217 	function nonces(address _taoId) external view returns (uint256);
218 	function incrementNonce(address _taoId) external returns (uint256);
219 }
220 
221 
222 interface ITAOPool {
223 	function createPool(address _taoId, bool _ethosCapStatus, uint256 _ethosCapAmount) external returns (bool);
224 }
225 
226 
227 
228 
229 
230 
231 
232 
233 
234 
235 
236 
237 
238 /**
239  * @title Name
240  */
241 contract Name is TAO {
242 	/**
243 	 * @dev Constructor function
244 	 */
245 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
246 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
247 		// Creating Name
248 		typeId = 1;
249 	}
250 }
251 
252 
253 
254 
255 
256 
257 contract TokenERC20 {
258 	// Public variables of the token
259 	string public name;
260 	string public symbol;
261 	uint8 public decimals = 18;
262 	// 18 decimals is the strongly suggested default, avoid changing it
263 	uint256 public totalSupply;
264 
265 	// This creates an array with all balances
266 	mapping (address => uint256) public balanceOf;
267 	mapping (address => mapping (address => uint256)) public allowance;
268 
269 	// This generates a public event on the blockchain that will notify clients
270 	event Transfer(address indexed from, address indexed to, uint256 value);
271 
272 	// This generates a public event on the blockchain that will notify clients
273 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
274 
275 	// This notifies clients about the amount burnt
276 	event Burn(address indexed from, uint256 value);
277 
278 	/**
279 	 * Constructor function
280 	 *
281 	 * Initializes contract with initial supply tokens to the creator of the contract
282 	 */
283 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
284 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
285 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
286 		name = tokenName;                                   // Set the name for display purposes
287 		symbol = tokenSymbol;                               // Set the symbol for display purposes
288 	}
289 
290 	/**
291 	 * Internal transfer, only can be called by this contract
292 	 */
293 	function _transfer(address _from, address _to, uint _value) internal {
294 		// Prevent transfer to 0x0 address. Use burn() instead
295 		require(_to != address(0));
296 		// Check if the sender has enough
297 		require(balanceOf[_from] >= _value);
298 		// Check for overflows
299 		require(balanceOf[_to] + _value > balanceOf[_to]);
300 		// Save this for an assertion in the future
301 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
302 		// Subtract from the sender
303 		balanceOf[_from] -= _value;
304 		// Add the same to the recipient
305 		balanceOf[_to] += _value;
306 		emit Transfer(_from, _to, _value);
307 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
308 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
309 	}
310 
311 	/**
312 	 * Transfer tokens
313 	 *
314 	 * Send `_value` tokens to `_to` from your account
315 	 *
316 	 * @param _to The address of the recipient
317 	 * @param _value the amount to send
318 	 */
319 	function transfer(address _to, uint256 _value) public returns (bool success) {
320 		_transfer(msg.sender, _to, _value);
321 		return true;
322 	}
323 
324 	/**
325 	 * Transfer tokens from other address
326 	 *
327 	 * Send `_value` tokens to `_to` in behalf of `_from`
328 	 *
329 	 * @param _from The address of the sender
330 	 * @param _to The address of the recipient
331 	 * @param _value the amount to send
332 	 */
333 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
334 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
335 		allowance[_from][msg.sender] -= _value;
336 		_transfer(_from, _to, _value);
337 		return true;
338 	}
339 
340 	/**
341 	 * Set allowance for other address
342 	 *
343 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
344 	 *
345 	 * @param _spender The address authorized to spend
346 	 * @param _value the max amount they can spend
347 	 */
348 	function approve(address _spender, uint256 _value) public returns (bool success) {
349 		allowance[msg.sender][_spender] = _value;
350 		emit Approval(msg.sender, _spender, _value);
351 		return true;
352 	}
353 
354 	/**
355 	 * Set allowance for other address and notify
356 	 *
357 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
358 	 *
359 	 * @param _spender The address authorized to spend
360 	 * @param _value the max amount they can spend
361 	 * @param _extraData some extra information to send to the approved contract
362 	 */
363 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
364 		tokenRecipient spender = tokenRecipient(_spender);
365 		if (approve(_spender, _value)) {
366 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
367 			return true;
368 		}
369 	}
370 
371 	/**
372 	 * Destroy tokens
373 	 *
374 	 * Remove `_value` tokens from the system irreversibly
375 	 *
376 	 * @param _value the amount of money to burn
377 	 */
378 	function burn(uint256 _value) public returns (bool success) {
379 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
380 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
381 		totalSupply -= _value;                      // Updates totalSupply
382 		emit Burn(msg.sender, _value);
383 		return true;
384 	}
385 
386 	/**
387 	 * Destroy tokens from other account
388 	 *
389 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
390 	 *
391 	 * @param _from the address of the sender
392 	 * @param _value the amount of money to burn
393 	 */
394 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
395 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
396 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
397 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
398 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
399 		totalSupply -= _value;                              // Update totalSupply
400 		emit Burn(_from, _value);
401 		return true;
402 	}
403 }
404 
405 
406 /**
407  * @title AOLibrary
408  */
409 library AOLibrary {
410 	using SafeMath for uint256;
411 
412 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
413 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
414 
415 	/**
416 	 * @dev Check whether or not the given TAO ID is a TAO
417 	 * @param _taoId The ID of the TAO
418 	 * @return true if yes. false otherwise
419 	 */
420 	function isTAO(address _taoId) public view returns (bool) {
421 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
422 	}
423 
424 	/**
425 	 * @dev Check whether or not the given Name ID is a Name
426 	 * @param _nameId The ID of the Name
427 	 * @return true if yes. false otherwise
428 	 */
429 	function isName(address _nameId) public view returns (bool) {
430 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
431 	}
432 
433 	/**
434 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
435 	 * @param _tokenAddress The ERC20 Token address to check
436 	 */
437 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
438 		if (_tokenAddress == address(0)) {
439 			return false;
440 		}
441 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
442 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
443 	}
444 
445 	/**
446 	 * @dev Checks if the calling contract address is The AO
447 	 *		OR
448 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
449 	 * @param _sender The address to check
450 	 * @param _theAO The AO address
451 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
452 	 * @return true if yes, false otherwise
453 	 */
454 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
455 		return (_sender == _theAO ||
456 			(
457 				(isTAO(_theAO) || isName(_theAO)) &&
458 				_nameTAOPositionAddress != address(0) &&
459 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
460 			)
461 		);
462 	}
463 
464 	/**
465 	 * @dev Return the divisor used to correctly calculate percentage.
466 	 *		Percentage stored throughout AO contracts covers 4 decimals,
467 	 *		so 1% is 10000, 1.25% is 12500, etc
468 	 */
469 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
470 		return _PERCENTAGE_DIVISOR;
471 	}
472 
473 	/**
474 	 * @dev Return the divisor used to correctly calculate multiplier.
475 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
476 	 *		so 1 is 1000000, 0.023 is 23000, etc
477 	 */
478 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
479 		return _MULTIPLIER_DIVISOR;
480 	}
481 
482 	/**
483 	 * @dev deploy a TAO
484 	 * @param _name The name of the TAO
485 	 * @param _originId The Name ID the creates the TAO
486 	 * @param _datHash The datHash of this TAO
487 	 * @param _database The database for this TAO
488 	 * @param _keyValue The key/value pair to be checked on the database
489 	 * @param _contentId The contentId related to this TAO
490 	 * @param _nameTAOVaultAddress The address of NameTAOVault
491 	 */
492 	function deployTAO(string memory _name,
493 		address _originId,
494 		string memory _datHash,
495 		string memory _database,
496 		string memory _keyValue,
497 		bytes32 _contentId,
498 		address _nameTAOVaultAddress
499 		) public returns (TAO _tao) {
500 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
501 	}
502 
503 	/**
504 	 * @dev deploy a Name
505 	 * @param _name The name of the Name
506 	 * @param _originId The eth address the creates the Name
507 	 * @param _datHash The datHash of this Name
508 	 * @param _database The database for this Name
509 	 * @param _keyValue The key/value pair to be checked on the database
510 	 * @param _contentId The contentId related to this Name
511 	 * @param _nameTAOVaultAddress The address of NameTAOVault
512 	 */
513 	function deployName(string memory _name,
514 		address _originId,
515 		string memory _datHash,
516 		string memory _database,
517 		string memory _keyValue,
518 		bytes32 _contentId,
519 		address _nameTAOVaultAddress
520 		) public returns (Name _myName) {
521 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
522 	}
523 
524 	/**
525 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
526 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
527 	 * @param _currentPrimordialBalance Account's current primordial ion balance
528 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
529 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
530 	 * @return the new primordial weighted multiplier
531 	 */
532 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
533 		if (_currentWeightedMultiplier > 0) {
534 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
535 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
536 			return _totalWeightedIons.div(_totalIons);
537 		} else {
538 			return _additionalWeightedMultiplier;
539 		}
540 	}
541 
542 	/**
543 	 * @dev Calculate the primordial ion multiplier on a given lot
544 	 *		Total Primordial Mintable = T
545 	 *		Total Primordial Minted = M
546 	 *		Starting Multiplier = S
547 	 *		Ending Multiplier = E
548 	 *		To Purchase = P
549 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
550 	 *
551 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
552 	 * @param _totalPrimordialMintable Total Primordial ion mintable
553 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
554 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
555 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
556 	 * @return The multiplier in (10 ** 6)
557 	 */
558 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
559 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
560 			/**
561 			 * Let temp = M + (P/2)
562 			 * Multiplier = (1 - (temp / T)) x (S-E)
563 			 */
564 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
565 
566 			/**
567 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
568 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
569 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
570 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
571 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
572 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
573 			 */
574 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
575 			/**
576 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
577 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
578 			 */
579 			return multiplier.div(_MULTIPLIER_DIVISOR);
580 		} else {
581 			return 0;
582 		}
583 	}
584 
585 	/**
586 	 * @dev Calculate the bonus percentage of network ion on a given lot
587 	 *		Total Primordial Mintable = T
588 	 *		Total Primordial Minted = M
589 	 *		Starting Network Bonus Multiplier = Bs
590 	 *		Ending Network Bonus Multiplier = Be
591 	 *		To Purchase = P
592 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
593 	 *
594 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
595 	 * @param _totalPrimordialMintable Total Primordial ion intable
596 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
597 	 * @param _startingMultiplier The starting Network ion bonus multiplier
598 	 * @param _endingMultiplier The ending Network ion bonus multiplier
599 	 * @return The bonus percentage
600 	 */
601 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
602 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
603 			/**
604 			 * Let temp = M + (P/2)
605 			 * B% = (1 - (temp / T)) x (Bs-Be)
606 			 */
607 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
608 
609 			/**
610 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
611 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
612 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
613 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
614 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
615 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
616 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
617 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
618 			 */
619 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
620 			return bonusPercentage;
621 		} else {
622 			return 0;
623 		}
624 	}
625 
626 	/**
627 	 * @dev Calculate the bonus amount of network ion on a given lot
628 	 *		AO Bonus Amount = B% x P
629 	 *
630 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
631 	 * @param _totalPrimordialMintable Total Primordial ion intable
632 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
633 	 * @param _startingMultiplier The starting Network ion bonus multiplier
634 	 * @param _endingMultiplier The ending Network ion bonus multiplier
635 	 * @return The bonus percentage
636 	 */
637 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
638 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
639 		/**
640 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
641 		 * when calculating the network ion bonus amount
642 		 */
643 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
644 		return networkBonus;
645 	}
646 
647 	/**
648 	 * @dev Calculate the maximum amount of Primordial an account can burn
649 	 *		_primordialBalance = P
650 	 *		_currentWeightedMultiplier = M
651 	 *		_maximumMultiplier = S
652 	 *		_amountToBurn = B
653 	 *		B = ((S x P) - (P x M)) / S
654 	 *
655 	 * @param _primordialBalance Account's primordial ion balance
656 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
657 	 * @param _maximumMultiplier The maximum multiplier of this account
658 	 * @return The maximum burn amount
659 	 */
660 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
661 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
662 	}
663 
664 	/**
665 	 * @dev Calculate the new multiplier after burning primordial ion
666 	 *		_primordialBalance = P
667 	 *		_currentWeightedMultiplier = M
668 	 *		_amountToBurn = B
669 	 *		_newMultiplier = E
670 	 *		E = (P x M) / (P - B)
671 	 *
672 	 * @param _primordialBalance Account's primordial ion balance
673 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
674 	 * @param _amountToBurn The amount of primordial ion to burn
675 	 * @return The new multiplier
676 	 */
677 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
678 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
679 	}
680 
681 	/**
682 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
683 	 *		_primordialBalance = P
684 	 *		_currentWeightedMultiplier = M
685 	 *		_amountToConvert = C
686 	 *		_newMultiplier = E
687 	 *		E = (P x M) / (P + C)
688 	 *
689 	 * @param _primordialBalance Account's primordial ion balance
690 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
691 	 * @param _amountToConvert The amount of network ion to convert
692 	 * @return The new multiplier
693 	 */
694 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
695 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
696 	}
697 
698 	/**
699 	 * @dev count num of digits
700 	 * @param number uint256 of the nuumber to be checked
701 	 * @return uint8 num of digits
702 	 */
703 	function numDigits(uint256 number) public pure returns (uint8) {
704 		uint8 digits = 0;
705 		while(number != 0) {
706 			number = number.div(10);
707 			digits++;
708 		}
709 		return digits;
710 	}
711 }
712 
713 
714 
715 
716 
717 /**
718  * @title TAOController
719  */
720 contract TAOController is TheAO {
721 	address public nameFactoryAddress;
722 	address public nameAccountRecoveryAddress;
723 
724 	INameFactory internal _nameFactory;
725 	INameTAOPosition internal _nameTAOPosition;
726 	INameAccountRecovery internal _nameAccountRecovery;
727 
728 	/**
729 	 * @dev Constructor function
730 	 */
731 	constructor(address _nameFactoryAddress) public {
732 		setNameFactoryAddress(_nameFactoryAddress);
733 	}
734 
735 	/**
736 	 * @dev Checks if the calling contract address is The AO
737 	 *		OR
738 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
739 	 */
740 	modifier onlyTheAO {
741 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
742 		_;
743 	}
744 
745 	/**
746 	 * @dev Check if `_taoId` is a TAO
747 	 */
748 	modifier isTAO(address _taoId) {
749 		require (AOLibrary.isTAO(_taoId));
750 		_;
751 	}
752 
753 	/**
754 	 * @dev Check if `_nameId` is a Name
755 	 */
756 	modifier isName(address _nameId) {
757 		require (AOLibrary.isName(_nameId));
758 		_;
759 	}
760 
761 	/**
762 	 * @dev Check if `_id` is a Name or a TAO
763 	 */
764 	modifier isNameOrTAO(address _id) {
765 		require (AOLibrary.isName(_id) || AOLibrary.isTAO(_id));
766 		_;
767 	}
768 
769 	/**
770 	 * @dev Check is msg.sender address is a Name
771 	 */
772 	 modifier senderIsName() {
773 		require (_nameFactory.ethAddressToNameId(msg.sender) != address(0));
774 		_;
775 	 }
776 
777 	/**
778 	 * @dev Check if msg.sender is the current advocate of TAO ID
779 	 */
780 	modifier onlyAdvocate(address _id) {
781 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _id));
782 		_;
783 	}
784 
785 	/**
786 	 * @dev Only allowed if sender's Name is not compromised
787 	 */
788 	modifier senderNameNotCompromised() {
789 		require (!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
790 		_;
791 	}
792 
793 	/***** The AO ONLY METHODS *****/
794 	/**
795 	 * @dev Transfer ownership of The AO to new address
796 	 * @param _theAO The new address to be transferred
797 	 */
798 	function transferOwnership(address _theAO) public onlyTheAO {
799 		require (_theAO != address(0));
800 		theAO = _theAO;
801 	}
802 
803 	/**
804 	 * @dev Whitelist `_account` address to transact on behalf of others
805 	 * @param _account The address to whitelist
806 	 * @param _whitelist Either to whitelist or not
807 	 */
808 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
809 		require (_account != address(0));
810 		whitelist[_account] = _whitelist;
811 	}
812 
813 	/**
814 	 * @dev The AO sets NameFactory address
815 	 * @param _nameFactoryAddress The address of NameFactory
816 	 */
817 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
818 		require (_nameFactoryAddress != address(0));
819 		nameFactoryAddress = _nameFactoryAddress;
820 		_nameFactory = INameFactory(_nameFactoryAddress);
821 	}
822 
823 	/**
824 	 * @dev The AO sets NameTAOPosition address
825 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
826 	 */
827 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
828 		require (_nameTAOPositionAddress != address(0));
829 		nameTAOPositionAddress = _nameTAOPositionAddress;
830 		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
831 	}
832 
833 	/**
834 	 * @dev The AO set the NameAccountRecovery Address
835 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
836 	 */
837 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
838 		require (_nameAccountRecoveryAddress != address(0));
839 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
840 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
841 	}
842 }
843 
844 
845 
846 
847 
848 
849 
850 
851 
852 /**
853  * @title TAOCurrency
854  */
855 contract TAOCurrency is TheAO {
856 	using SafeMath for uint256;
857 
858 	// Public variables of the contract
859 	string public name;
860 	string public symbol;
861 	uint8 public decimals;
862 
863 	// To differentiate denomination of TAO Currency
864 	uint256 public powerOfTen;
865 
866 	uint256 public totalSupply;
867 
868 	// This creates an array with all balances
869 	// address is the address of nameId, not the eth public address
870 	mapping (address => uint256) public balanceOf;
871 
872 	// This generates a public event on the blockchain that will notify clients
873 	// address is the address of TAO/Name Id, not eth public address
874 	event Transfer(address indexed from, address indexed to, uint256 value);
875 
876 	// This notifies clients about the amount burnt
877 	// address is the address of TAO/Name Id, not eth public address
878 	event Burn(address indexed from, uint256 value);
879 
880 	/**
881 	 * Constructor function
882 	 *
883 	 * Initializes contract with initial supply TAOCurrency to the creator of the contract
884 	 */
885 	constructor (string memory _name, string memory _symbol, address _nameTAOPositionAddress) public {
886 		name = _name;		// Set the name for display purposes
887 		symbol = _symbol;	// Set the symbol for display purposes
888 
889 		powerOfTen = 0;
890 		decimals = 0;
891 
892 		setNameTAOPositionAddress(_nameTAOPositionAddress);
893 	}
894 
895 	/**
896 	 * @dev Checks if the calling contract address is The AO
897 	 *		OR
898 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
899 	 */
900 	modifier onlyTheAO {
901 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
902 		_;
903 	}
904 
905 	/**
906 	 * @dev Check if `_id` is a Name or a TAO
907 	 */
908 	modifier isNameOrTAO(address _id) {
909 		require (AOLibrary.isName(_id) || AOLibrary.isTAO(_id));
910 		_;
911 	}
912 
913 	/***** The AO ONLY METHODS *****/
914 	/**
915 	 * @dev Transfer ownership of The AO to new address
916 	 * @param _theAO The new address to be transferred
917 	 */
918 	function transferOwnership(address _theAO) public onlyTheAO {
919 		require (_theAO != address(0));
920 		theAO = _theAO;
921 	}
922 
923 	/**
924 	 * @dev Whitelist `_account` address to transact on behalf of others
925 	 * @param _account The address to whitelist
926 	 * @param _whitelist Either to whitelist or not
927 	 */
928 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
929 		require (_account != address(0));
930 		whitelist[_account] = _whitelist;
931 	}
932 
933 	/**
934 	 * @dev The AO set the NameTAOPosition Address
935 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
936 	 */
937 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
938 		require (_nameTAOPositionAddress != address(0));
939 		nameTAOPositionAddress = _nameTAOPositionAddress;
940 	}
941 
942 	/***** PUBLIC METHODS *****/
943 	/**
944 	 * @dev transfer TAOCurrency from other address
945 	 *
946 	 * Send `_value` TAOCurrency to `_to` in behalf of `_from`
947 	 *
948 	 * @param _from The address of the sender
949 	 * @param _to The address of the recipient
950 	 * @param _value the amount to send
951 	 */
952 	function transferFrom(address _from, address _to, uint256 _value) public inWhitelist isNameOrTAO(_from) isNameOrTAO(_to) returns (bool) {
953 		_transfer(_from, _to, _value);
954 		return true;
955 	}
956 
957 	/**
958 	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
959 	 * @param target Address to receive TAOCurrency
960 	 * @param mintedAmount The amount of TAOCurrency it will receive
961 	 * @return true on success
962 	 */
963 	function mint(address target, uint256 mintedAmount) public inWhitelist isNameOrTAO(target) returns (bool) {
964 		_mint(target, mintedAmount);
965 		return true;
966 	}
967 
968 	/**
969 	 *
970 	 * @dev Whitelisted address remove `_value` TAOCurrency from the system irreversibly on behalf of `_from`.
971 	 *
972 	 * @param _from the address of the sender
973 	 * @param _value the amount of money to burn
974 	 */
975 	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist isNameOrTAO(_from) returns (bool success) {
976 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
977 		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
978 		totalSupply = totalSupply.sub(_value);              // Update totalSupply
979 		emit Burn(_from, _value);
980 		return true;
981 	}
982 
983 	/***** INTERNAL METHODS *****/
984 	/**
985 	 * @dev Send `_value` TAOCurrency from `_from` to `_to`
986 	 * @param _from The address of sender
987 	 * @param _to The address of the recipient
988 	 * @param _value The amount to send
989 	 */
990 	function _transfer(address _from, address _to, uint256 _value) internal {
991 		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
992 		require (balanceOf[_from] >= _value);					// Check if the sender has enough
993 		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
994 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
995 		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
996 		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
997 		emit Transfer(_from, _to, _value);
998 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
999 	}
1000 
1001 	/**
1002 	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
1003 	 * @param target Address to receive TAOCurrency
1004 	 * @param mintedAmount The amount of TAOCurrency it will receive
1005 	 */
1006 	function _mint(address target, uint256 mintedAmount) internal {
1007 		balanceOf[target] = balanceOf[target].add(mintedAmount);
1008 		totalSupply = totalSupply.add(mintedAmount);
1009 		emit Transfer(address(0), address(this), mintedAmount);
1010 		emit Transfer(address(this), target, mintedAmount);
1011 	}
1012 }
1013 
1014 
1015 
1016 
1017 
1018 
1019 
1020 
1021 contract Logos is TAOCurrency {
1022 	address public nameFactoryAddress;
1023 	address public nameAccountRecoveryAddress;
1024 
1025 	INameFactory internal _nameFactory;
1026 	INameTAOPosition internal _nameTAOPosition;
1027 	INameAccountRecovery internal _nameAccountRecovery;
1028 
1029 	// Mapping of a Name ID to the amount of Logos positioned by others to itself
1030 	// address is the address of nameId, not the eth public address
1031 	mapping (address => uint256) public positionFromOthers;
1032 
1033 	// Mapping of Name ID to other Name ID and the amount of Logos positioned by itself
1034 	mapping (address => mapping(address => uint256)) public positionOnOthers;
1035 
1036 	// Mapping of a Name ID to the total amount of Logos positioned by itself on others
1037 	mapping (address => uint256) public totalPositionOnOthers;
1038 
1039 	// Mapping of Name ID to it's advocated TAO ID and the amount of Logos earned
1040 	mapping (address => mapping(address => uint256)) public advocatedTAOLogos;
1041 
1042 	// Mapping of a Name ID to the total amount of Logos earned from advocated TAO
1043 	mapping (address => uint256) public totalAdvocatedTAOLogos;
1044 
1045 	// Event broadcasted to public when `from` address position `value` Logos to `to`
1046 	event PositionFrom(address indexed from, address indexed to, uint256 value);
1047 
1048 	// Event broadcasted to public when `from` address unposition `value` Logos from `to`
1049 	event UnpositionFrom(address indexed from, address indexed to, uint256 value);
1050 
1051 	// Event broadcasted to public when `nameId` receives `amount` of Logos from advocating `taoId`
1052 	event AddAdvocatedTAOLogos(address indexed nameId, address indexed taoId, uint256 amount);
1053 
1054 	// Event broadcasted to public when Logos from advocating `taoId` is transferred from `fromNameId` to `toNameId`
1055 	event TransferAdvocatedTAOLogos(address indexed fromNameId, address indexed toNameId, address indexed taoId, uint256 amount);
1056 
1057 	/**
1058 	 * @dev Constructor function
1059 	 */
1060 	constructor(string memory _name, string memory _symbol, address _nameFactoryAddress, address _nameTAOPositionAddress)
1061 		TAOCurrency(_name, _symbol, _nameTAOPositionAddress) public {
1062 		setNameFactoryAddress(_nameFactoryAddress);
1063 		setNameTAOPositionAddress(_nameTAOPositionAddress);
1064 	}
1065 
1066 	/**
1067 	 * @dev Check if `_taoId` is a TAO
1068 	 */
1069 	modifier isTAO(address _taoId) {
1070 		require (AOLibrary.isTAO(_taoId));
1071 		_;
1072 	}
1073 
1074 	/**
1075 	 * @dev Check if `_nameId` is a Name
1076 	 */
1077 	modifier isName(address _nameId) {
1078 		require (AOLibrary.isName(_nameId));
1079 		_;
1080 	}
1081 
1082 	/**
1083 	 * @dev Check if msg.sender is the current advocate of _id
1084 	 */
1085 	modifier onlyAdvocate(address _id) {
1086 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _id));
1087 		_;
1088 	}
1089 
1090 	/**
1091 	 * @dev Only allowed if Name is not compromised
1092 	 */
1093 	modifier nameNotCompromised(address _id) {
1094 		require (!_nameAccountRecovery.isCompromised(_id));
1095 		_;
1096 	}
1097 
1098 	/**
1099 	 * @dev Only allowed if sender's Name is not compromised
1100 	 */
1101 	modifier senderNameNotCompromised() {
1102 		require (!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
1103 		_;
1104 	}
1105 
1106 	/***** THE AO ONLY METHODS *****/
1107 	/**
1108 	 * @dev The AO sets NameFactory address
1109 	 * @param _nameFactoryAddress The address of NameFactory
1110 	 */
1111 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
1112 		require (_nameFactoryAddress != address(0));
1113 		nameFactoryAddress = _nameFactoryAddress;
1114 		_nameFactory = INameFactory(_nameFactoryAddress);
1115 	}
1116 
1117 	/**
1118 	 * @dev The AO set the NameTAOPosition Address
1119 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
1120 	 */
1121 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
1122 		require (_nameTAOPositionAddress != address(0));
1123 		nameTAOPositionAddress = _nameTAOPositionAddress;
1124 		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
1125 	}
1126 
1127 	/**
1128 	 * @dev The AO set the NameAccountRecovery Address
1129 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
1130 	 */
1131 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
1132 		require (_nameAccountRecoveryAddress != address(0));
1133 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
1134 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
1135 	}
1136 
1137 	/***** PUBLIC METHODS *****/
1138 	/**
1139 	 * @dev Get the total sum of Logos for an address
1140 	 * @param _target The address to check
1141 	 * @return The total sum of Logos (own + positioned + advocated TAOs)
1142 	 */
1143 	function sumBalanceOf(address _target) public isName(_target) view returns (uint256) {
1144 		return balanceOf[_target].add(positionFromOthers[_target]).add(totalAdvocatedTAOLogos[_target]);
1145 	}
1146 
1147 	/**
1148 	 * @dev Return the amount of Logos that are available to be positioned on other
1149 	 * @param _sender The sender address to check
1150 	 * @return The amount of Logos that are available to be positioned on other
1151 	 */
1152 	function availableToPositionAmount(address _sender) public isName(_sender) view returns (uint256) {
1153 		return balanceOf[_sender].sub(totalPositionOnOthers[_sender]);
1154 	}
1155 
1156 	/**
1157 	 * @dev `_from` Name position `_value` Logos onto `_to` Name
1158 	 *
1159 	 * @param _from The address of the sender
1160 	 * @param _to The address of the recipient
1161 	 * @param _value the amount to position
1162 	 * @return true on success
1163 	 */
1164 	function positionFrom(address _from, address _to, uint256 _value) public isName(_from) isName(_to) nameNotCompromised(_from) nameNotCompromised(_to) onlyAdvocate(_from) senderNameNotCompromised returns (bool) {
1165 		require (_from != _to);	// Can't position Logos to itself
1166 		require (availableToPositionAmount(_from) >= _value); // should have enough balance to position
1167 		require (positionFromOthers[_to].add(_value) >= positionFromOthers[_to]); // check for overflows
1168 
1169 		positionOnOthers[_from][_to] = positionOnOthers[_from][_to].add(_value);
1170 		totalPositionOnOthers[_from] = totalPositionOnOthers[_from].add(_value);
1171 		positionFromOthers[_to] = positionFromOthers[_to].add(_value);
1172 
1173 		emit PositionFrom(_from, _to, _value);
1174 		return true;
1175 	}
1176 
1177 	/**
1178 	 * @dev `_from` Name unposition `_value` Logos from `_to` Name
1179 	 *
1180 	 * @param _from The address of the sender
1181 	 * @param _to The address of the recipient
1182 	 * @param _value the amount to unposition
1183 	 * @return true on success
1184 	 */
1185 	function unpositionFrom(address _from, address _to, uint256 _value) public isName(_from) isName(_to) nameNotCompromised(_from) nameNotCompromised(_to) onlyAdvocate(_from) senderNameNotCompromised returns (bool) {
1186 		require (_from != _to);	// Can't unposition Logos to itself
1187 		require (positionOnOthers[_from][_to] >= _value);
1188 
1189 		positionOnOthers[_from][_to] = positionOnOthers[_from][_to].sub(_value);
1190 		totalPositionOnOthers[_from] = totalPositionOnOthers[_from].sub(_value);
1191 		positionFromOthers[_to] = positionFromOthers[_to].sub(_value);
1192 
1193 		emit UnpositionFrom(_from, _to, _value);
1194 		return true;
1195 	}
1196 
1197 	/**
1198 	 * @dev Add `_amount` logos earned from advocating a TAO `_taoId` to its Advocate
1199 	 * @param _taoId The ID of the advocated TAO
1200 	 * @param _amount the amount to reward
1201 	 * @return true on success
1202 	 */
1203 	function addAdvocatedTAOLogos(address _taoId, uint256 _amount) public inWhitelist isTAO(_taoId) returns (bool) {
1204 		require (_amount > 0);
1205 		address _nameId = _nameTAOPosition.getAdvocate(_taoId);
1206 
1207 		advocatedTAOLogos[_nameId][_taoId] = advocatedTAOLogos[_nameId][_taoId].add(_amount);
1208 		totalAdvocatedTAOLogos[_nameId] = totalAdvocatedTAOLogos[_nameId].add(_amount);
1209 
1210 		emit AddAdvocatedTAOLogos(_nameId, _taoId, _amount);
1211 		return true;
1212 	}
1213 
1214 	/**
1215 	 * @dev Transfer logos earned from advocating a TAO `_taoId` from `_fromNameId` to the Advocate of `_taoId`
1216 	 * @param _fromNameId The ID of the Name that sends the Logos
1217 	 * @param _taoId The ID of the advocated TAO
1218 	 * @return true on success
1219 	 */
1220 	function transferAdvocatedTAOLogos(address _fromNameId, address _taoId) public inWhitelist isName(_fromNameId) isTAO(_taoId) returns (bool) {
1221 		address _toNameId = _nameTAOPosition.getAdvocate(_taoId);
1222 		require (_fromNameId != _toNameId);
1223 		require (totalAdvocatedTAOLogos[_fromNameId] >= advocatedTAOLogos[_fromNameId][_taoId]);
1224 
1225 		uint256 _amount = advocatedTAOLogos[_fromNameId][_taoId];
1226 		advocatedTAOLogos[_fromNameId][_taoId] = 0;
1227 		totalAdvocatedTAOLogos[_fromNameId] = totalAdvocatedTAOLogos[_fromNameId].sub(_amount);
1228 		advocatedTAOLogos[_toNameId][_taoId] = advocatedTAOLogos[_toNameId][_taoId].add(_amount);
1229 		totalAdvocatedTAOLogos[_toNameId] = totalAdvocatedTAOLogos[_toNameId].add(_amount);
1230 
1231 		emit TransferAdvocatedTAOLogos(_fromNameId, _toNameId, _taoId, _amount);
1232 		return true;
1233 	}
1234 }
1235 
1236 
1237 
1238 /**
1239  * @title TAOPool
1240  *
1241  * This contract acts as the bookkeeper of TAO Currencies that are staked on TAO
1242  */
1243 contract TAOPool is TAOController, ITAOPool {
1244 	using SafeMath for uint256;
1245 
1246 	address public taoFactoryAddress;
1247 	address public pathosAddress;
1248 	address public ethosAddress;
1249 	address public logosAddress;
1250 
1251 	ITAOFactory internal _taoFactory;
1252 	TAOCurrency internal _pathos;
1253 	TAOCurrency internal _ethos;
1254 	Logos internal _logos;
1255 
1256 	struct Pool {
1257 		address taoId;
1258 		/**
1259 		 * If true, has ethos cap. Otherwise, no ethos cap.
1260 		 */
1261 		bool ethosCapStatus;
1262 		uint256 ethosCapAmount;	// Creates a cap for the amount of Ethos that can be staked into this pool
1263 
1264 		/**
1265 		 * If true, Pool is live and can be staked into.
1266 		 */
1267 		bool status;
1268 	}
1269 
1270 	struct EthosLot {
1271 		bytes32 ethosLotId;					// The ID of this Lot
1272 		address nameId;						// The ID of the Name that staked Ethos
1273 		uint256 lotQuantity;				// Amount of Ethos being staked to the Pool from this Lot
1274 		address taoId;						// Identifier for the Pool this Lot is adding to
1275 		uint256 poolPreStakeSnapshot;		// Amount of Ethos contributed to the Pool prior to this Lot Number
1276 		uint256 poolStakeLotSnapshot;		// poolPreStakeSnapshot + lotQuantity
1277 		uint256 lotValueInLogos;
1278 		uint256 logosWithdrawn;				// Amount of Logos withdrawn from this Lot
1279 		uint256 timestamp;
1280 	}
1281 
1282 	uint256 public contractTotalEthosLot;		// Total Ethos lot from all pools
1283 	uint256 public contractTotalPathosStake;	// Total Pathos stake from all pools (how many Pathos stakes are there in contract)
1284 	uint256 public contractTotalEthos;			// Quantity of Ethos that has been staked to all Pools
1285 	uint256 public contractTotalPathos;			// Quantity of Pathos that has been staked to all Pools
1286 	uint256 public contractTotalLogosWithdrawn;		// Quantity of Logos that has been withdrawn from all Pools
1287 
1288 	// Mapping from TAO ID to Pool
1289 	mapping (address => Pool) public pools;
1290 
1291 	// Mapping from Ethos Lot ID to Ethos Lot
1292 	mapping (bytes32 => EthosLot) public ethosLots;
1293 
1294 	// Mapping from Pool's TAO ID to total Ethos Lots in the Pool
1295 	mapping (address => uint256) public poolTotalEthosLot;
1296 
1297 	// Mapping from Pool's TAO ID to quantity of Logos that has been withdrawn from the Pool
1298 	mapping (address => uint256) public poolTotalLogosWithdrawn;
1299 
1300 	// Mapping from a Name ID to its Ethos Lots
1301 	mapping (address => bytes32[]) internal ownerEthosLots;
1302 
1303 	// Mapping from a Name ID to quantity of Ethos staked from all Ethos lots
1304 	mapping (address => uint256) public totalEthosStaked;
1305 
1306 	// Mapping from a Name ID to quantity of Pathos staked from all Ethos lots
1307 	mapping (address => uint256) public totalPathosStaked;
1308 
1309 	// Mapping from a Name ID to total Logos withdrawn from all Ethos lots
1310 	mapping (address => uint256) public totalLogosWithdrawn;
1311 
1312 	// Mapping from a Name ID to quantity of Ethos staked from all Ethos lots on a Pool
1313 	mapping (address => mapping (address => uint256)) public namePoolEthosStaked;
1314 
1315 	// Mapping from a Name ID to quantity of Pathos staked on a Pool
1316 	mapping (address => mapping (address => uint256)) public namePoolPathosStaked;
1317 
1318 	// Mapping from a Name ID to quantity of Logos withdrawn from a Pool
1319 	mapping (address => mapping (address => uint256)) public namePoolLogosWithdrawn;
1320 
1321 	// Event to be broadcasted to public when Pool is created
1322 	event CreatePool(address indexed taoId, bool ethosCapStatus, uint256 ethosCapAmount, bool status);
1323 
1324 	// Event to be broadcasted to public when Pool's status is updated
1325 	// If status == true, start Pool
1326 	// Otherwise, stop Pool
1327 	event UpdatePoolStatus(address indexed taoId, bool status, uint256 nonce);
1328 
1329 	// Event to be broadcasted to public when Pool's Ethos cap is updated
1330 	event UpdatePoolEthosCap(address indexed taoId, bool ethosCapStatus, uint256 ethosCapAmount, uint256 nonce);
1331 
1332 	/**
1333 	 * Event to be broadcasted to public when nameId stakes Ethos
1334 	 */
1335 	event StakeEthos(address indexed taoId, bytes32 indexed ethosLotId, address indexed nameId, uint256 lotQuantity, uint256 poolPreStakeSnapshot, uint256 poolStakeLotSnapshot, uint256 lotValueInLogos, uint256 timestamp);
1336 
1337 	// Event to be broadcasted to public when nameId stakes Pathos
1338 	event StakePathos(address indexed taoId, bytes32 indexed stakeId, address indexed nameId, uint256 stakeQuantity, uint256 currentPoolTotalStakedPathos, uint256 timestamp);
1339 
1340 	// Event to be broadcasted to public when nameId withdraws Logos from Ethos Lot
1341 	event WithdrawLogos(address indexed nameId, bytes32 indexed ethosLotId, address indexed taoId, uint256 withdrawnAmount, uint256 currentLotValueInLogos, uint256 currentLotLogosWithdrawn, uint256 timestamp);
1342 
1343 	/**
1344 	 * @dev Constructor function
1345 	 */
1346 	constructor(address _nameFactoryAddress, address _taoFactoryAddress, address _nameTAOPositionAddress, address _pathosAddress, address _ethosAddress, address _logosAddress)
1347 		TAOController(_nameFactoryAddress) public {
1348 		setTAOFactoryAddress(_taoFactoryAddress);
1349 		setNameTAOPositionAddress(_nameTAOPositionAddress);
1350 		setPathosAddress(_pathosAddress);
1351 		setEthosAddress(_ethosAddress);
1352 		setLogosAddress(_logosAddress);
1353 	}
1354 
1355 	/**
1356 	 * @dev Check if calling address is TAO Factory address
1357 	 */
1358 	modifier onlyTAOFactory {
1359 		require (msg.sender == taoFactoryAddress);
1360 		_;
1361 	}
1362 
1363 	/***** The AO ONLY METHODS *****/
1364 	/**
1365 	 * @dev The AO set the TAOFactory Address
1366 	 * @param _taoFactoryAddress The address of TAOFactory
1367 	 */
1368 	function setTAOFactoryAddress(address _taoFactoryAddress) public onlyTheAO {
1369 		require (_taoFactoryAddress != address(0));
1370 		taoFactoryAddress = _taoFactoryAddress;
1371 		_taoFactory = ITAOFactory(_taoFactoryAddress);
1372 	}
1373 
1374 	/**
1375 	 * @dev The AO set the Pathos Address
1376 	 * @param _pathosAddress The address of Pathos
1377 	 */
1378 	function setPathosAddress(address _pathosAddress) public onlyTheAO {
1379 		require (_pathosAddress != address(0));
1380 		pathosAddress = _pathosAddress;
1381 		_pathos = TAOCurrency(_pathosAddress);
1382 	}
1383 
1384 	/**
1385 	 * @dev The AO set the Ethos Address
1386 	 * @param _ethosAddress The address of Ethos
1387 	 */
1388 	function setEthosAddress(address _ethosAddress) public onlyTheAO {
1389 		require (_ethosAddress != address(0));
1390 		ethosAddress = _ethosAddress;
1391 		_ethos = TAOCurrency(_ethosAddress);
1392 	}
1393 
1394 	/**
1395 	 * @dev The AO set the Logos Address
1396 	 * @param _logosAddress The address of Logos
1397 	 */
1398 	function setLogosAddress(address _logosAddress) public onlyTheAO {
1399 		require (_logosAddress != address(0));
1400 		logosAddress = _logosAddress;
1401 		_logos = Logos(_logosAddress);
1402 	}
1403 
1404 	/***** PUBLIC METHODS *****/
1405 	/**
1406 	 * @dev Check whether or not Pool exist for a TAO ID
1407 	 * @param _id The ID to be checked
1408 	 * @return true if yes, false otherwise
1409 	 */
1410 	function isExist(address _id) public view returns (bool) {
1411 		return pools[_id].taoId != address(0);
1412 	}
1413 
1414 	/**
1415 	 * @dev Create a pool for a TAO
1416 	 */
1417 	function createPool(
1418 		address _taoId,
1419 		bool _ethosCapStatus,
1420 		uint256 _ethosCapAmount
1421 	) external isTAO(_taoId) onlyTAOFactory returns (bool) {
1422 		// Make sure ethos cap amount is provided if ethos cap is enabled
1423 		if (_ethosCapStatus) {
1424 			require (_ethosCapAmount > 0);
1425 		}
1426 		// Make sure the pool is not yet created
1427 		require (pools[_taoId].taoId == address(0));
1428 
1429 		Pool storage _pool = pools[_taoId];
1430 		_pool.taoId = _taoId;
1431 		_pool.status = true;
1432 		_pool.ethosCapStatus = _ethosCapStatus;
1433 		if (_ethosCapStatus) {
1434 			_pool.ethosCapAmount = _ethosCapAmount;
1435 		}
1436 
1437 		emit CreatePool(_pool.taoId, _pool.ethosCapStatus, _pool.ethosCapAmount, _pool.status);
1438 		return true;
1439 	}
1440 
1441 	/**
1442 	 * @dev Start/Stop a Pool
1443 	 * @param _taoId The TAO ID of the Pool
1444 	 * @param _status The status to set. true = start. false = stop
1445 	 */
1446 	function updatePoolStatus(address _taoId, bool _status) public isTAO(_taoId) onlyAdvocate(_taoId) senderNameNotCompromised {
1447 		require (pools[_taoId].taoId != address(0));
1448 		pools[_taoId].status = _status;
1449 
1450 		uint256 _nonce = _taoFactory.incrementNonce(_taoId);
1451 		require (_nonce > 0);
1452 
1453 		emit UpdatePoolStatus(_taoId, _status, _nonce);
1454 	}
1455 
1456 	/**
1457 	 * @dev Update Ethos cap of a Pool
1458 	 * @param _taoId The TAO ID of the Pool
1459 	 * @param _ethosCapStatus The ethos cap status to set
1460 	 * @param _ethosCapAmount The ethos cap amount to set
1461 	 */
1462 	function updatePoolEthosCap(address _taoId, bool _ethosCapStatus, uint256 _ethosCapAmount) public isTAO(_taoId) onlyAdvocate(_taoId) senderNameNotCompromised {
1463 		require (pools[_taoId].taoId != address(0));
1464 		// If there is an ethos cap
1465 		if (_ethosCapStatus) {
1466 			require (_ethosCapAmount > 0 && _ethosCapAmount > _pathos.balanceOf(_taoId));
1467 		}
1468 
1469 		pools[_taoId].ethosCapStatus = _ethosCapStatus;
1470 		if (_ethosCapStatus) {
1471 			pools[_taoId].ethosCapAmount = _ethosCapAmount;
1472 		}
1473 
1474 		uint256 _nonce = _taoFactory.incrementNonce(_taoId);
1475 		require (_nonce > 0);
1476 
1477 		emit UpdatePoolEthosCap(_taoId, _ethosCapStatus, _ethosCapAmount, _nonce);
1478 	}
1479 
1480 	/**
1481 	 * @dev A Name stakes Ethos in Pool `_taoId`
1482 	 * @param _taoId The TAO ID of the Pool
1483 	 * @param _quantity The amount of Ethos to be staked
1484 	 */
1485 	function stakeEthos(address _taoId, uint256 _quantity) public isTAO(_taoId) senderIsName senderNameNotCompromised {
1486 		Pool memory _pool = pools[_taoId];
1487 		address _nameId = _nameFactory.ethAddressToNameId(msg.sender);
1488 		require (_pool.status == true && _quantity > 0 && _ethos.balanceOf(_nameId) >= _quantity);
1489 
1490 		// If there is an ethos cap
1491 		if (_pool.ethosCapStatus) {
1492 			require (_ethos.balanceOf(_taoId).add(_quantity) <= _pool.ethosCapAmount);
1493 		}
1494 
1495 		// Create Ethos Lot for this transaction
1496 		contractTotalEthosLot++;
1497 		poolTotalEthosLot[_taoId]++;
1498 
1499 		// Generate Ethos Lot ID
1500 		bytes32 _ethosLotId = keccak256(abi.encodePacked(this, msg.sender, contractTotalEthosLot));
1501 
1502 		EthosLot storage _ethosLot = ethosLots[_ethosLotId];
1503 		_ethosLot.ethosLotId = _ethosLotId;
1504 		_ethosLot.nameId = _nameId;
1505 		_ethosLot.lotQuantity = _quantity;
1506 		_ethosLot.taoId = _taoId;
1507 		_ethosLot.poolPreStakeSnapshot = _ethos.balanceOf(_taoId);
1508 		_ethosLot.poolStakeLotSnapshot = _ethos.balanceOf(_taoId).add(_quantity);
1509 		_ethosLot.lotValueInLogos = _quantity;
1510 		_ethosLot.timestamp = now;
1511 
1512 		ownerEthosLots[_nameId].push(_ethosLotId);
1513 
1514 		// Update contract variables
1515 		totalEthosStaked[_nameId] = totalEthosStaked[_nameId].add(_quantity);
1516 		namePoolEthosStaked[_nameId][_taoId] = namePoolEthosStaked[_nameId][_taoId].add(_quantity);
1517 		contractTotalEthos = contractTotalEthos.add(_quantity);
1518 
1519 		require (_ethos.transferFrom(_nameId, _taoId, _quantity));
1520 
1521 		emit StakeEthos(_ethosLot.taoId, _ethosLot.ethosLotId, _ethosLot.nameId, _ethosLot.lotQuantity, _ethosLot.poolPreStakeSnapshot, _ethosLot.poolStakeLotSnapshot, _ethosLot.lotValueInLogos, _ethosLot.timestamp);
1522 	}
1523 
1524 	/**
1525 	 * @dev Retrieve number of Ethos Lots a `_nameId` has
1526 	 * @param _nameId The Name ID of the Ethos Lot's owner
1527 	 * @return Total Ethos Lots the owner has
1528 	 */
1529 	function ownerTotalEthosLot(address _nameId) public view returns (uint256) {
1530 		return ownerEthosLots[_nameId].length;
1531 	}
1532 
1533 	/**
1534 	 * @dev Get list of owner's Ethos Lot IDs from `_from` to `_to` index
1535 	 * @param _nameId The Name Id of the Ethos Lot's owner
1536 	 * @param _from The starting index, (i.e 0)
1537 	 * @param _to The ending index, (i.e total - 1)
1538 	 * @return list of owner's Ethos Lot IDs
1539 	 */
1540 	function ownerEthosLotIds(address _nameId, uint256 _from, uint256 _to) public view returns (bytes32[] memory) {
1541 		require (_from >= 0 && _to >= _from && ownerEthosLots[_nameId].length > _to);
1542 		bytes32[] memory _ethosLotIds = new bytes32[](_to.sub(_from).add(1));
1543 		for (uint256 i = _from; i <= _to; i++) {
1544 			_ethosLotIds[i.sub(_from)] = ownerEthosLots[_nameId][i];
1545 		}
1546 		return _ethosLotIds;
1547 	}
1548 
1549 	/**
1550 	 * @dev Return the amount of Pathos that can be staked on Pool
1551 	 * @param _taoId The TAO ID of the Pool
1552 	 * @return The amount of Pathos that can be staked
1553 	 */
1554 	function availablePathosToStake(address _taoId) public isTAO(_taoId) view returns (uint256) {
1555 		if (pools[_taoId].status == true) {
1556 			return _ethos.balanceOf(_taoId).sub(_pathos.balanceOf(_taoId));
1557 		} else {
1558 			return 0;
1559 		}
1560 	}
1561 
1562 	/**
1563 	 * @dev A Name stakes Pathos in Pool `_taoId`
1564 	 * @param _taoId The TAO ID of the Pool
1565 	 * @param _quantity The amount of Pathos to stake
1566 	 */
1567 	function stakePathos(address _taoId, uint256 _quantity) public isTAO(_taoId) senderIsName senderNameNotCompromised {
1568 		Pool memory _pool = pools[_taoId];
1569 		address _nameId = _nameFactory.ethAddressToNameId(msg.sender);
1570 		require (_pool.status == true && _quantity > 0 && _pathos.balanceOf(_nameId) >= _quantity && _quantity <= availablePathosToStake(_taoId));
1571 
1572 		// Update contract variables
1573 		contractTotalPathosStake++;
1574 		totalPathosStaked[_nameId] = totalPathosStaked[_nameId].add(_quantity);
1575 		namePoolPathosStaked[_nameId][_taoId] = namePoolPathosStaked[_nameId][_taoId].add(_quantity);
1576 		contractTotalPathos = contractTotalPathos.add(_quantity);
1577 
1578 		// Generate Pathos Stake ID
1579 		bytes32 _stakeId = keccak256(abi.encodePacked(this, msg.sender, contractTotalPathosStake));
1580 
1581 		require (_pathos.transferFrom(_nameId, _taoId, _quantity));
1582 
1583 		// Also add advocated TAO logos to Advocate of _taoId
1584 		require (_logos.addAdvocatedTAOLogos(_taoId, _quantity));
1585 
1586 		emit StakePathos(_taoId, _stakeId, _nameId, _quantity, _pathos.balanceOf(_taoId), now);
1587 	}
1588 
1589 	/**
1590 	 * @dev Name that staked Ethos withdraw Logos from Ethos Lot `_ethosLotId`
1591 	 * @param _ethosLotId The ID of the Ethos Lot
1592 	 */
1593 	function withdrawLogos(bytes32 _ethosLotId) public senderIsName senderNameNotCompromised {
1594 		EthosLot storage _ethosLot = ethosLots[_ethosLotId];
1595 		address _nameId = _nameFactory.ethAddressToNameId(msg.sender);
1596 		require (_ethosLot.nameId == _nameId && _ethosLot.lotValueInLogos > 0);
1597 
1598 		uint256 logosAvailableToWithdraw = lotLogosAvailableToWithdraw(_ethosLotId);
1599 
1600 		require (logosAvailableToWithdraw > 0 && logosAvailableToWithdraw <= _ethosLot.lotValueInLogos);
1601 
1602 		// Update lot variables
1603 		_ethosLot.logosWithdrawn = _ethosLot.logosWithdrawn.add(logosAvailableToWithdraw);
1604 		_ethosLot.lotValueInLogos = _ethosLot.lotValueInLogos.sub(logosAvailableToWithdraw);
1605 
1606 		// Update contract variables
1607 		contractTotalLogosWithdrawn = contractTotalLogosWithdrawn.add(logosAvailableToWithdraw);
1608 		poolTotalLogosWithdrawn[_ethosLot.taoId] = poolTotalLogosWithdrawn[_ethosLot.taoId].add(logosAvailableToWithdraw);
1609 		totalLogosWithdrawn[_ethosLot.nameId] = totalLogosWithdrawn[_ethosLot.nameId].add(logosAvailableToWithdraw);
1610 		namePoolLogosWithdrawn[_ethosLot.nameId][_ethosLot.taoId] = namePoolLogosWithdrawn[_ethosLot.nameId][_ethosLot.taoId].add(logosAvailableToWithdraw);
1611 
1612 		// Mint logos to seller
1613 		require (_logos.mint(_nameId, logosAvailableToWithdraw));
1614 
1615 		emit WithdrawLogos(_ethosLot.nameId, _ethosLot.ethosLotId, _ethosLot.taoId, logosAvailableToWithdraw, _ethosLot.lotValueInLogos, _ethosLot.logosWithdrawn, now);
1616 	}
1617 
1618 	/**
1619 	 * @dev Name gets Ethos Lot `_ethosLotId` available Logos to withdraw
1620 	 * @param _ethosLotId The ID of the Ethos Lot
1621 	 * @return The amount of Logos available to withdraw
1622 	 */
1623 	function lotLogosAvailableToWithdraw(bytes32 _ethosLotId) public view returns (uint256) {
1624 		EthosLot memory _ethosLot = ethosLots[_ethosLotId];
1625 		require (_ethosLot.nameId != address(0));
1626 
1627 		uint256 logosAvailableToWithdraw = 0;
1628 
1629 		if (_pathos.balanceOf(_ethosLot.taoId) > _ethosLot.poolPreStakeSnapshot && _ethosLot.lotValueInLogos > 0) {
1630 			logosAvailableToWithdraw = (_pathos.balanceOf(_ethosLot.taoId) >= _ethosLot.poolStakeLotSnapshot) ? _ethosLot.lotQuantity : _pathos.balanceOf(_ethosLot.taoId).sub(_ethosLot.poolPreStakeSnapshot);
1631 			if (logosAvailableToWithdraw > 0) {
1632 				logosAvailableToWithdraw = logosAvailableToWithdraw.sub(_ethosLot.logosWithdrawn);
1633 			}
1634 		}
1635 		return logosAvailableToWithdraw;
1636 	}
1637 }