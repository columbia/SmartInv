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
70 contract TheAO {
71 	address public theAO;
72 	address public nameTAOPositionAddress;
73 
74 	// Check whether an address is whitelisted and granted access to transact
75 	// on behalf of others
76 	mapping (address => bool) public whitelist;
77 
78 	constructor() public {
79 		theAO = msg.sender;
80 	}
81 
82 	/**
83 	 * @dev Checks if msg.sender is in whitelist.
84 	 */
85 	modifier inWhitelist() {
86 		require (whitelist[msg.sender] == true);
87 		_;
88 	}
89 
90 	/**
91 	 * @dev Transfer ownership of The AO to new address
92 	 * @param _theAO The new address to be transferred
93 	 */
94 	function transferOwnership(address _theAO) public {
95 		require (msg.sender == theAO);
96 		require (_theAO != address(0));
97 		theAO = _theAO;
98 	}
99 
100 	/**
101 	 * @dev Whitelist `_account` address to transact on behalf of others
102 	 * @param _account The address to whitelist
103 	 * @param _whitelist Either to whitelist or not
104 	 */
105 	function setWhitelist(address _account, bool _whitelist) public {
106 		require (msg.sender == theAO);
107 		require (_account != address(0));
108 		whitelist[_account] = _whitelist;
109 	}
110 }
111 
112 
113 interface INameAccountRecovery {
114 	function isCompromised(address _id) external view returns (bool);
115 }
116 
117 
118 interface INameFactory {
119 	function nonces(address _nameId) external view returns (uint256);
120 	function incrementNonce(address _nameId) external returns (uint256);
121 	function ethAddressToNameId(address _ethAddress) external view returns (address);
122 	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
123 	function nameIdToEthAddress(address _nameId) external view returns (address);
124 }
125 
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
140 contract TokenERC20 {
141 	// Public variables of the token
142 	string public name;
143 	string public symbol;
144 	uint8 public decimals = 18;
145 	// 18 decimals is the strongly suggested default, avoid changing it
146 	uint256 public totalSupply;
147 
148 	// This creates an array with all balances
149 	mapping (address => uint256) public balanceOf;
150 	mapping (address => mapping (address => uint256)) public allowance;
151 
152 	// This generates a public event on the blockchain that will notify clients
153 	event Transfer(address indexed from, address indexed to, uint256 value);
154 
155 	// This generates a public event on the blockchain that will notify clients
156 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
157 
158 	// This notifies clients about the amount burnt
159 	event Burn(address indexed from, uint256 value);
160 
161 	/**
162 	 * Constructor function
163 	 *
164 	 * Initializes contract with initial supply tokens to the creator of the contract
165 	 */
166 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
167 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
168 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
169 		name = tokenName;                                   // Set the name for display purposes
170 		symbol = tokenSymbol;                               // Set the symbol for display purposes
171 	}
172 
173 	/**
174 	 * Internal transfer, only can be called by this contract
175 	 */
176 	function _transfer(address _from, address _to, uint _value) internal {
177 		// Prevent transfer to 0x0 address. Use burn() instead
178 		require(_to != address(0));
179 		// Check if the sender has enough
180 		require(balanceOf[_from] >= _value);
181 		// Check for overflows
182 		require(balanceOf[_to] + _value > balanceOf[_to]);
183 		// Save this for an assertion in the future
184 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
185 		// Subtract from the sender
186 		balanceOf[_from] -= _value;
187 		// Add the same to the recipient
188 		balanceOf[_to] += _value;
189 		emit Transfer(_from, _to, _value);
190 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
191 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
192 	}
193 
194 	/**
195 	 * Transfer tokens
196 	 *
197 	 * Send `_value` tokens to `_to` from your account
198 	 *
199 	 * @param _to The address of the recipient
200 	 * @param _value the amount to send
201 	 */
202 	function transfer(address _to, uint256 _value) public returns (bool success) {
203 		_transfer(msg.sender, _to, _value);
204 		return true;
205 	}
206 
207 	/**
208 	 * Transfer tokens from other address
209 	 *
210 	 * Send `_value` tokens to `_to` in behalf of `_from`
211 	 *
212 	 * @param _from The address of the sender
213 	 * @param _to The address of the recipient
214 	 * @param _value the amount to send
215 	 */
216 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
217 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
218 		allowance[_from][msg.sender] -= _value;
219 		_transfer(_from, _to, _value);
220 		return true;
221 	}
222 
223 	/**
224 	 * Set allowance for other address
225 	 *
226 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
227 	 *
228 	 * @param _spender The address authorized to spend
229 	 * @param _value the max amount they can spend
230 	 */
231 	function approve(address _spender, uint256 _value) public returns (bool success) {
232 		allowance[msg.sender][_spender] = _value;
233 		emit Approval(msg.sender, _spender, _value);
234 		return true;
235 	}
236 
237 	/**
238 	 * Set allowance for other address and notify
239 	 *
240 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
241 	 *
242 	 * @param _spender The address authorized to spend
243 	 * @param _value the max amount they can spend
244 	 * @param _extraData some extra information to send to the approved contract
245 	 */
246 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
247 		tokenRecipient spender = tokenRecipient(_spender);
248 		if (approve(_spender, _value)) {
249 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
250 			return true;
251 		}
252 	}
253 
254 	/**
255 	 * Destroy tokens
256 	 *
257 	 * Remove `_value` tokens from the system irreversibly
258 	 *
259 	 * @param _value the amount of money to burn
260 	 */
261 	function burn(uint256 _value) public returns (bool success) {
262 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
263 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
264 		totalSupply -= _value;                      // Updates totalSupply
265 		emit Burn(msg.sender, _value);
266 		return true;
267 	}
268 
269 	/**
270 	 * Destroy tokens from other account
271 	 *
272 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
273 	 *
274 	 * @param _from the address of the sender
275 	 * @param _value the amount of money to burn
276 	 */
277 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
278 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
279 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
280 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
281 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
282 		totalSupply -= _value;                              // Update totalSupply
283 		emit Burn(_from, _value);
284 		return true;
285 	}
286 }
287 
288 
289 /**
290  * @title TAO
291  */
292 contract TAO {
293 	using SafeMath for uint256;
294 
295 	address public vaultAddress;
296 	string public name;				// the name for this TAO
297 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
298 
299 	// TAO's data
300 	string public datHash;
301 	string public database;
302 	string public keyValue;
303 	bytes32 public contentId;
304 
305 	/**
306 	 * 0 = TAO
307 	 * 1 = Name
308 	 */
309 	uint8 public typeId;
310 
311 	/**
312 	 * @dev Constructor function
313 	 */
314 	constructor (string memory _name,
315 		address _originId,
316 		string memory _datHash,
317 		string memory _database,
318 		string memory _keyValue,
319 		bytes32 _contentId,
320 		address _vaultAddress
321 	) public {
322 		name = _name;
323 		originId = _originId;
324 		datHash = _datHash;
325 		database = _database;
326 		keyValue = _keyValue;
327 		contentId = _contentId;
328 
329 		// Creating TAO
330 		typeId = 0;
331 
332 		vaultAddress = _vaultAddress;
333 	}
334 
335 	/**
336 	 * @dev Checks if calling address is Vault contract
337 	 */
338 	modifier onlyVault {
339 		require (msg.sender == vaultAddress);
340 		_;
341 	}
342 
343 	/**
344 	 * Will receive any ETH sent
345 	 */
346 	function () external payable {
347 	}
348 
349 	/**
350 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
351 	 * @param _recipient The recipient address
352 	 * @param _amount The amount to transfer
353 	 * @return true on success
354 	 */
355 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
356 		_recipient.transfer(_amount);
357 		return true;
358 	}
359 
360 	/**
361 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
362 	 * @param _erc20TokenAddress The address of ERC20 Token
363 	 * @param _recipient The recipient address
364 	 * @param _amount The amount to transfer
365 	 * @return true on success
366 	 */
367 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
368 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
369 		_erc20.transfer(_recipient, _amount);
370 		return true;
371 	}
372 }
373 
374 
375 
376 
377 /**
378  * @title Name
379  */
380 contract Name is TAO {
381 	/**
382 	 * @dev Constructor function
383 	 */
384 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
385 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
386 		// Creating Name
387 		typeId = 1;
388 	}
389 }
390 
391 
392 
393 
394 /**
395  * @title AOLibrary
396  */
397 library AOLibrary {
398 	using SafeMath for uint256;
399 
400 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
401 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
402 
403 	/**
404 	 * @dev Check whether or not the given TAO ID is a TAO
405 	 * @param _taoId The ID of the TAO
406 	 * @return true if yes. false otherwise
407 	 */
408 	function isTAO(address _taoId) public view returns (bool) {
409 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
410 	}
411 
412 	/**
413 	 * @dev Check whether or not the given Name ID is a Name
414 	 * @param _nameId The ID of the Name
415 	 * @return true if yes. false otherwise
416 	 */
417 	function isName(address _nameId) public view returns (bool) {
418 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
419 	}
420 
421 	/**
422 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
423 	 * @param _tokenAddress The ERC20 Token address to check
424 	 */
425 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
426 		if (_tokenAddress == address(0)) {
427 			return false;
428 		}
429 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
430 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
431 	}
432 
433 	/**
434 	 * @dev Checks if the calling contract address is The AO
435 	 *		OR
436 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
437 	 * @param _sender The address to check
438 	 * @param _theAO The AO address
439 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
440 	 * @return true if yes, false otherwise
441 	 */
442 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
443 		return (_sender == _theAO ||
444 			(
445 				(isTAO(_theAO) || isName(_theAO)) &&
446 				_nameTAOPositionAddress != address(0) &&
447 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
448 			)
449 		);
450 	}
451 
452 	/**
453 	 * @dev Return the divisor used to correctly calculate percentage.
454 	 *		Percentage stored throughout AO contracts covers 4 decimals,
455 	 *		so 1% is 10000, 1.25% is 12500, etc
456 	 */
457 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
458 		return _PERCENTAGE_DIVISOR;
459 	}
460 
461 	/**
462 	 * @dev Return the divisor used to correctly calculate multiplier.
463 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
464 	 *		so 1 is 1000000, 0.023 is 23000, etc
465 	 */
466 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
467 		return _MULTIPLIER_DIVISOR;
468 	}
469 
470 	/**
471 	 * @dev deploy a TAO
472 	 * @param _name The name of the TAO
473 	 * @param _originId The Name ID the creates the TAO
474 	 * @param _datHash The datHash of this TAO
475 	 * @param _database The database for this TAO
476 	 * @param _keyValue The key/value pair to be checked on the database
477 	 * @param _contentId The contentId related to this TAO
478 	 * @param _nameTAOVaultAddress The address of NameTAOVault
479 	 */
480 	function deployTAO(string memory _name,
481 		address _originId,
482 		string memory _datHash,
483 		string memory _database,
484 		string memory _keyValue,
485 		bytes32 _contentId,
486 		address _nameTAOVaultAddress
487 		) public returns (TAO _tao) {
488 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
489 	}
490 
491 	/**
492 	 * @dev deploy a Name
493 	 * @param _name The name of the Name
494 	 * @param _originId The eth address the creates the Name
495 	 * @param _datHash The datHash of this Name
496 	 * @param _database The database for this Name
497 	 * @param _keyValue The key/value pair to be checked on the database
498 	 * @param _contentId The contentId related to this Name
499 	 * @param _nameTAOVaultAddress The address of NameTAOVault
500 	 */
501 	function deployName(string memory _name,
502 		address _originId,
503 		string memory _datHash,
504 		string memory _database,
505 		string memory _keyValue,
506 		bytes32 _contentId,
507 		address _nameTAOVaultAddress
508 		) public returns (Name _myName) {
509 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
510 	}
511 
512 	/**
513 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
514 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
515 	 * @param _currentPrimordialBalance Account's current primordial ion balance
516 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
517 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
518 	 * @return the new primordial weighted multiplier
519 	 */
520 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
521 		if (_currentWeightedMultiplier > 0) {
522 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
523 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
524 			return _totalWeightedIons.div(_totalIons);
525 		} else {
526 			return _additionalWeightedMultiplier;
527 		}
528 	}
529 
530 	/**
531 	 * @dev Calculate the primordial ion multiplier on a given lot
532 	 *		Total Primordial Mintable = T
533 	 *		Total Primordial Minted = M
534 	 *		Starting Multiplier = S
535 	 *		Ending Multiplier = E
536 	 *		To Purchase = P
537 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
538 	 *
539 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
540 	 * @param _totalPrimordialMintable Total Primordial ion mintable
541 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
542 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
543 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
544 	 * @return The multiplier in (10 ** 6)
545 	 */
546 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
547 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
548 			/**
549 			 * Let temp = M + (P/2)
550 			 * Multiplier = (1 - (temp / T)) x (S-E)
551 			 */
552 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
553 
554 			/**
555 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
556 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
557 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
558 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
559 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
560 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
561 			 */
562 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
563 			/**
564 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
565 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
566 			 */
567 			return multiplier.div(_MULTIPLIER_DIVISOR);
568 		} else {
569 			return 0;
570 		}
571 	}
572 
573 	/**
574 	 * @dev Calculate the bonus percentage of network ion on a given lot
575 	 *		Total Primordial Mintable = T
576 	 *		Total Primordial Minted = M
577 	 *		Starting Network Bonus Multiplier = Bs
578 	 *		Ending Network Bonus Multiplier = Be
579 	 *		To Purchase = P
580 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
581 	 *
582 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
583 	 * @param _totalPrimordialMintable Total Primordial ion intable
584 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
585 	 * @param _startingMultiplier The starting Network ion bonus multiplier
586 	 * @param _endingMultiplier The ending Network ion bonus multiplier
587 	 * @return The bonus percentage
588 	 */
589 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
590 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
591 			/**
592 			 * Let temp = M + (P/2)
593 			 * B% = (1 - (temp / T)) x (Bs-Be)
594 			 */
595 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
596 
597 			/**
598 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
599 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
600 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
601 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
602 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
603 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
604 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
605 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
606 			 */
607 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
608 			return bonusPercentage;
609 		} else {
610 			return 0;
611 		}
612 	}
613 
614 	/**
615 	 * @dev Calculate the bonus amount of network ion on a given lot
616 	 *		AO Bonus Amount = B% x P
617 	 *
618 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
619 	 * @param _totalPrimordialMintable Total Primordial ion intable
620 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
621 	 * @param _startingMultiplier The starting Network ion bonus multiplier
622 	 * @param _endingMultiplier The ending Network ion bonus multiplier
623 	 * @return The bonus percentage
624 	 */
625 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
626 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
627 		/**
628 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
629 		 * when calculating the network ion bonus amount
630 		 */
631 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
632 		return networkBonus;
633 	}
634 
635 	/**
636 	 * @dev Calculate the maximum amount of Primordial an account can burn
637 	 *		_primordialBalance = P
638 	 *		_currentWeightedMultiplier = M
639 	 *		_maximumMultiplier = S
640 	 *		_amountToBurn = B
641 	 *		B = ((S x P) - (P x M)) / S
642 	 *
643 	 * @param _primordialBalance Account's primordial ion balance
644 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
645 	 * @param _maximumMultiplier The maximum multiplier of this account
646 	 * @return The maximum burn amount
647 	 */
648 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
649 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
650 	}
651 
652 	/**
653 	 * @dev Calculate the new multiplier after burning primordial ion
654 	 *		_primordialBalance = P
655 	 *		_currentWeightedMultiplier = M
656 	 *		_amountToBurn = B
657 	 *		_newMultiplier = E
658 	 *		E = (P x M) / (P - B)
659 	 *
660 	 * @param _primordialBalance Account's primordial ion balance
661 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
662 	 * @param _amountToBurn The amount of primordial ion to burn
663 	 * @return The new multiplier
664 	 */
665 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
666 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
667 	}
668 
669 	/**
670 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
671 	 *		_primordialBalance = P
672 	 *		_currentWeightedMultiplier = M
673 	 *		_amountToConvert = C
674 	 *		_newMultiplier = E
675 	 *		E = (P x M) / (P + C)
676 	 *
677 	 * @param _primordialBalance Account's primordial ion balance
678 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
679 	 * @param _amountToConvert The amount of network ion to convert
680 	 * @return The new multiplier
681 	 */
682 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
683 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
684 	}
685 
686 	/**
687 	 * @dev count num of digits
688 	 * @param number uint256 of the nuumber to be checked
689 	 * @return uint8 num of digits
690 	 */
691 	function numDigits(uint256 number) public pure returns (uint8) {
692 		uint8 digits = 0;
693 		while(number != 0) {
694 			number = number.div(10);
695 			digits++;
696 		}
697 		return digits;
698 	}
699 }
700 
701 
702 
703 
704 
705 /**
706  * @title TAOController
707  */
708 contract TAOController is TheAO {
709 	address public nameFactoryAddress;
710 	address public nameAccountRecoveryAddress;
711 
712 	INameFactory internal _nameFactory;
713 	INameTAOPosition internal _nameTAOPosition;
714 	INameAccountRecovery internal _nameAccountRecovery;
715 
716 	/**
717 	 * @dev Constructor function
718 	 */
719 	constructor(address _nameFactoryAddress) public {
720 		setNameFactoryAddress(_nameFactoryAddress);
721 	}
722 
723 	/**
724 	 * @dev Checks if the calling contract address is The AO
725 	 *		OR
726 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
727 	 */
728 	modifier onlyTheAO {
729 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
730 		_;
731 	}
732 
733 	/**
734 	 * @dev Check if `_taoId` is a TAO
735 	 */
736 	modifier isTAO(address _taoId) {
737 		require (AOLibrary.isTAO(_taoId));
738 		_;
739 	}
740 
741 	/**
742 	 * @dev Check if `_nameId` is a Name
743 	 */
744 	modifier isName(address _nameId) {
745 		require (AOLibrary.isName(_nameId));
746 		_;
747 	}
748 
749 	/**
750 	 * @dev Check if `_id` is a Name or a TAO
751 	 */
752 	modifier isNameOrTAO(address _id) {
753 		require (AOLibrary.isName(_id) || AOLibrary.isTAO(_id));
754 		_;
755 	}
756 
757 	/**
758 	 * @dev Check is msg.sender address is a Name
759 	 */
760 	 modifier senderIsName() {
761 		require (_nameFactory.ethAddressToNameId(msg.sender) != address(0));
762 		_;
763 	 }
764 
765 	/**
766 	 * @dev Check if msg.sender is the current advocate of TAO ID
767 	 */
768 	modifier onlyAdvocate(address _id) {
769 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _id));
770 		_;
771 	}
772 
773 	/**
774 	 * @dev Only allowed if sender's Name is not compromised
775 	 */
776 	modifier senderNameNotCompromised() {
777 		require (!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
778 		_;
779 	}
780 
781 	/***** The AO ONLY METHODS *****/
782 	/**
783 	 * @dev Transfer ownership of The AO to new address
784 	 * @param _theAO The new address to be transferred
785 	 */
786 	function transferOwnership(address _theAO) public onlyTheAO {
787 		require (_theAO != address(0));
788 		theAO = _theAO;
789 	}
790 
791 	/**
792 	 * @dev Whitelist `_account` address to transact on behalf of others
793 	 * @param _account The address to whitelist
794 	 * @param _whitelist Either to whitelist or not
795 	 */
796 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
797 		require (_account != address(0));
798 		whitelist[_account] = _whitelist;
799 	}
800 
801 	/**
802 	 * @dev The AO sets NameFactory address
803 	 * @param _nameFactoryAddress The address of NameFactory
804 	 */
805 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
806 		require (_nameFactoryAddress != address(0));
807 		nameFactoryAddress = _nameFactoryAddress;
808 		_nameFactory = INameFactory(_nameFactoryAddress);
809 	}
810 
811 	/**
812 	 * @dev The AO sets NameTAOPosition address
813 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
814 	 */
815 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
816 		require (_nameTAOPositionAddress != address(0));
817 		nameTAOPositionAddress = _nameTAOPositionAddress;
818 		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
819 	}
820 
821 	/**
822 	 * @dev The AO set the NameAccountRecovery Address
823 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
824 	 */
825 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
826 		require (_nameAccountRecoveryAddress != address(0));
827 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
828 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
829 	}
830 }
831 
832 
833 
834 
835 
836 
837 
838 /**
839  * @title Voice
840  */
841 contract Voice is TheAO {
842 	using SafeMath for uint256;
843 
844 	// Public variables of the contract
845 	string public name;
846 	string public symbol;
847 	uint8 public decimals = 4;
848 
849 	uint256 constant public MAX_SUPPLY_PER_NAME = 100 * (10 ** 4);
850 
851 	uint256 public totalSupply;
852 
853 	// Mapping from Name ID to bool value whether or not it has received Voice
854 	mapping (address => bool) public hasReceived;
855 
856 	// Mapping from Name/TAO ID to its total available balance
857 	mapping (address => uint256) public balanceOf;
858 
859 	// Mapping from Name ID to TAO ID and its staked amount
860 	mapping (address => mapping(address => uint256)) public taoStakedBalance;
861 
862 	// This generates a public event on the blockchain that will notify clients
863 	event Mint(address indexed nameId, uint256 value);
864 	event Stake(address indexed nameId, address indexed taoId, uint256 value);
865 	event Unstake(address indexed nameId, address indexed taoId, uint256 value);
866 
867 	/**
868 	 * Constructor function
869 	 */
870 	constructor (string memory _name, string memory _symbol) public {
871 		name = _name;						// Set the name for display purposes
872 		symbol = _symbol;					// Set the symbol for display purposes
873 	}
874 
875 	/**
876 	 * @dev Checks if the calling contract address is The AO
877 	 *		OR
878 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
879 	 */
880 	modifier onlyTheAO {
881 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
882 		_;
883 	}
884 
885 	/**
886 	 * @dev Check if `_taoId` is a TAO
887 	 */
888 	modifier isTAO(address _taoId) {
889 		require (AOLibrary.isTAO(_taoId));
890 		_;
891 	}
892 
893 	/**
894 	 * @dev Check if `_nameId` is a Name
895 	 */
896 	modifier isName(address _nameId) {
897 		require (AOLibrary.isName(_nameId));
898 		_;
899 	}
900 
901 	/***** The AO ONLY METHODS *****/
902 	/**
903 	 * @dev Transfer ownership of The AO to new address
904 	 * @param _theAO The new address to be transferred
905 	 */
906 	function transferOwnership(address _theAO) public onlyTheAO {
907 		require (_theAO != address(0));
908 		theAO = _theAO;
909 	}
910 
911 	/**
912 	 * @dev Whitelist `_account` address to transact on behalf of others
913 	 * @param _account The address to whitelist
914 	 * @param _whitelist Either to whitelist or not
915 	 */
916 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
917 		require (_account != address(0));
918 		whitelist[_account] = _whitelist;
919 	}
920 
921 	/**
922 	 * @dev The AO set the NameTAOPosition Address
923 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
924 	 */
925 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
926 		require (_nameTAOPositionAddress != address(0));
927 		nameTAOPositionAddress = _nameTAOPositionAddress;
928 	}
929 
930 	/***** PUBLIC METHODS *****/
931 	/**
932 	 * @dev Create `MAX_SUPPLY_PER_NAME` Voice and send it to `_nameId`
933 	 * @param _nameId Address to receive Voice
934 	 * @return true on success
935 	 */
936 	function mint(address _nameId) public inWhitelist isName(_nameId) returns (bool) {
937 		// Make sure _nameId has not received Voice
938 		require (hasReceived[_nameId] == false);
939 
940 		hasReceived[_nameId] = true;
941 		balanceOf[_nameId] = balanceOf[_nameId].add(MAX_SUPPLY_PER_NAME);
942 		totalSupply = totalSupply.add(MAX_SUPPLY_PER_NAME);
943 		emit Mint(_nameId, MAX_SUPPLY_PER_NAME);
944 		return true;
945 	}
946 
947 	/**
948 	 * @dev Get staked balance of `_nameId`
949 	 * @param _nameId The Name ID to be queried
950 	 * @return total staked balance
951 	 */
952 	function stakedBalance(address _nameId) public isName(_nameId) view returns (uint256) {
953 		return MAX_SUPPLY_PER_NAME.sub(balanceOf[_nameId]);
954 	}
955 
956 	/**
957 	 * @dev Stake `_value` Voice on `_taoId` from `_nameId`
958 	 * @param _nameId The Name ID that wants to stake
959 	 * @param _taoId The TAO ID to stake
960 	 * @param _value The amount to stake
961 	 * @return true on success
962 	 */
963 	function stake(address _nameId, address _taoId, uint256 _value) public inWhitelist isName(_nameId) isTAO(_taoId) returns (bool) {
964 		require (_value > 0 && _value <= MAX_SUPPLY_PER_NAME);
965 		require (balanceOf[_nameId] >= _value);							// Check if the targeted balance is enough
966 		balanceOf[_nameId] = balanceOf[_nameId].sub(_value);			// Subtract from the targeted balance
967 		taoStakedBalance[_nameId][_taoId] = taoStakedBalance[_nameId][_taoId].add(_value);	// Add to the targeted staked balance
968 		balanceOf[_taoId] = balanceOf[_taoId].add(_value);
969 		emit Stake(_nameId, _taoId, _value);
970 		return true;
971 	}
972 
973 	/**
974 	 * @dev Unstake `_value` Voice from `_nameId`'s `_taoId`
975 	 * @param _nameId The Name ID that wants to unstake
976 	 * @param _taoId The TAO ID to unstake
977 	 * @param _value The amount to unstake
978 	 * @return true on success
979 	 */
980 	function unstake(address _nameId, address _taoId, uint256 _value) public inWhitelist isName(_nameId) isTAO(_taoId) returns (bool) {
981 		require (_value > 0 && _value <= MAX_SUPPLY_PER_NAME);
982 		require (taoStakedBalance[_nameId][_taoId] >= _value);	// Check if the targeted staked balance is enough
983 		require (balanceOf[_taoId] >= _value);	// Check if the total targeted staked balance is enough
984 		taoStakedBalance[_nameId][_taoId] = taoStakedBalance[_nameId][_taoId].sub(_value);	// Subtract from the targeted staked balance
985 		balanceOf[_taoId] = balanceOf[_taoId].sub(_value);
986 		balanceOf[_nameId] = balanceOf[_nameId].add(_value);			// Add to the targeted balance
987 		emit Unstake(_nameId, _taoId, _value);
988 		return true;
989 	}
990 }
991 
992 
993 /**
994  * @title TAOVoice
995  *
996  * The purpose of this contract is for Name to stake/unstake Voice on a TAO
997  */
998 contract TAOVoice is TAOController {
999 	address public voiceAddress;
1000 
1001 	Voice internal _voice;
1002 
1003 	/**
1004 	 * @dev Constructor function
1005 	 */
1006 	constructor(address _nameFactoryAddress, address _voiceAddress, address _nameTAOPositionAddress)
1007 		TAOController(_nameFactoryAddress) public {
1008 		setVoiceAddress(_voiceAddress);
1009 		setNameTAOPositionAddress(_nameTAOPositionAddress);
1010 	}
1011 
1012 	/***** The AO ONLY METHODS *****/
1013 	/**
1014 	 * @dev The AO set the Voice Address
1015 	 * @param _voiceAddress The address of Voice
1016 	 */
1017 	function setVoiceAddress(address _voiceAddress) public onlyTheAO {
1018 		require (_voiceAddress != address(0));
1019 		voiceAddress = _voiceAddress;
1020 		_voice = Voice(_voiceAddress);
1021 	}
1022 
1023 	/***** PUBLIC METHODS *****/
1024 	/**
1025 	 * @dev Name stakes Voice on a TAO
1026 	 * @param _taoId The ID of the TAO
1027 	 * @param _voiceAmount The amount of Voice to stake
1028 	 */
1029 	function stakeVoice(address _taoId, uint256 _voiceAmount) public isTAO(_taoId) senderIsName senderNameNotCompromised {
1030 		require (_voice.stake(_nameFactory.ethAddressToNameId(msg.sender), _taoId, _voiceAmount));
1031 	}
1032 
1033 	/**
1034 	 * @dev Name unstakes Voice on a TAO
1035 	 * @param _taoId The ID of the TAO
1036 	 * @param _voiceAmount The amount of Voice to unstake
1037 	 */
1038 	function unstakeVoice(address _taoId, uint256 _voiceAmount) public isTAO(_taoId) senderIsName senderNameNotCompromised {
1039 		require (_voice.unstake(_nameFactory.ethAddressToNameId(msg.sender), _taoId, _voiceAmount));
1040 	}
1041 }