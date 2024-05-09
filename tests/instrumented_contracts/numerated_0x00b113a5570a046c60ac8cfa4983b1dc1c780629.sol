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
70 interface INameTAOLookup {
71 	function isExist(string calldata _name) external view returns (bool);
72 
73 	function initialize(string calldata _name, address _nameTAOId, uint256 _typeId, string calldata _parentName, address _parentId, uint256 _parentTypeId) external returns (bool);
74 
75 	function getById(address _id) external view returns (string memory, address, uint256, string memory, address, uint256);
76 
77 	function getIdByName(string calldata _name) external view returns (address);
78 }
79 
80 
81 
82 
83 contract TheAO {
84 	address public theAO;
85 	address public nameTAOPositionAddress;
86 
87 	// Check whether an address is whitelisted and granted access to transact
88 	// on behalf of others
89 	mapping (address => bool) public whitelist;
90 
91 	constructor() public {
92 		theAO = msg.sender;
93 	}
94 
95 	/**
96 	 * @dev Checks if msg.sender is in whitelist.
97 	 */
98 	modifier inWhitelist() {
99 		require (whitelist[msg.sender] == true);
100 		_;
101 	}
102 
103 	/**
104 	 * @dev Transfer ownership of The AO to new address
105 	 * @param _theAO The new address to be transferred
106 	 */
107 	function transferOwnership(address _theAO) public {
108 		require (msg.sender == theAO);
109 		require (_theAO != address(0));
110 		theAO = _theAO;
111 	}
112 
113 	/**
114 	 * @dev Whitelist `_account` address to transact on behalf of others
115 	 * @param _account The address to whitelist
116 	 * @param _whitelist Either to whitelist or not
117 	 */
118 	function setWhitelist(address _account, bool _whitelist) public {
119 		require (msg.sender == theAO);
120 		require (_account != address(0));
121 		whitelist[_account] = _whitelist;
122 	}
123 }
124 
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
135 contract TokenERC20 {
136 	// Public variables of the token
137 	string public name;
138 	string public symbol;
139 	uint8 public decimals = 18;
140 	// 18 decimals is the strongly suggested default, avoid changing it
141 	uint256 public totalSupply;
142 
143 	// This creates an array with all balances
144 	mapping (address => uint256) public balanceOf;
145 	mapping (address => mapping (address => uint256)) public allowance;
146 
147 	// This generates a public event on the blockchain that will notify clients
148 	event Transfer(address indexed from, address indexed to, uint256 value);
149 
150 	// This generates a public event on the blockchain that will notify clients
151 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
152 
153 	// This notifies clients about the amount burnt
154 	event Burn(address indexed from, uint256 value);
155 
156 	/**
157 	 * Constructor function
158 	 *
159 	 * Initializes contract with initial supply tokens to the creator of the contract
160 	 */
161 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
162 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
163 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
164 		name = tokenName;                                   // Set the name for display purposes
165 		symbol = tokenSymbol;                               // Set the symbol for display purposes
166 	}
167 
168 	/**
169 	 * Internal transfer, only can be called by this contract
170 	 */
171 	function _transfer(address _from, address _to, uint _value) internal {
172 		// Prevent transfer to 0x0 address. Use burn() instead
173 		require(_to != address(0));
174 		// Check if the sender has enough
175 		require(balanceOf[_from] >= _value);
176 		// Check for overflows
177 		require(balanceOf[_to] + _value > balanceOf[_to]);
178 		// Save this for an assertion in the future
179 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
180 		// Subtract from the sender
181 		balanceOf[_from] -= _value;
182 		// Add the same to the recipient
183 		balanceOf[_to] += _value;
184 		emit Transfer(_from, _to, _value);
185 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
186 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
187 	}
188 
189 	/**
190 	 * Transfer tokens
191 	 *
192 	 * Send `_value` tokens to `_to` from your account
193 	 *
194 	 * @param _to The address of the recipient
195 	 * @param _value the amount to send
196 	 */
197 	function transfer(address _to, uint256 _value) public returns (bool success) {
198 		_transfer(msg.sender, _to, _value);
199 		return true;
200 	}
201 
202 	/**
203 	 * Transfer tokens from other address
204 	 *
205 	 * Send `_value` tokens to `_to` in behalf of `_from`
206 	 *
207 	 * @param _from The address of the sender
208 	 * @param _to The address of the recipient
209 	 * @param _value the amount to send
210 	 */
211 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
212 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
213 		allowance[_from][msg.sender] -= _value;
214 		_transfer(_from, _to, _value);
215 		return true;
216 	}
217 
218 	/**
219 	 * Set allowance for other address
220 	 *
221 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
222 	 *
223 	 * @param _spender The address authorized to spend
224 	 * @param _value the max amount they can spend
225 	 */
226 	function approve(address _spender, uint256 _value) public returns (bool success) {
227 		allowance[msg.sender][_spender] = _value;
228 		emit Approval(msg.sender, _spender, _value);
229 		return true;
230 	}
231 
232 	/**
233 	 * Set allowance for other address and notify
234 	 *
235 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
236 	 *
237 	 * @param _spender The address authorized to spend
238 	 * @param _value the max amount they can spend
239 	 * @param _extraData some extra information to send to the approved contract
240 	 */
241 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
242 		tokenRecipient spender = tokenRecipient(_spender);
243 		if (approve(_spender, _value)) {
244 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
245 			return true;
246 		}
247 	}
248 
249 	/**
250 	 * Destroy tokens
251 	 *
252 	 * Remove `_value` tokens from the system irreversibly
253 	 *
254 	 * @param _value the amount of money to burn
255 	 */
256 	function burn(uint256 _value) public returns (bool success) {
257 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
258 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
259 		totalSupply -= _value;                      // Updates totalSupply
260 		emit Burn(msg.sender, _value);
261 		return true;
262 	}
263 
264 	/**
265 	 * Destroy tokens from other account
266 	 *
267 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
268 	 *
269 	 * @param _from the address of the sender
270 	 * @param _value the amount of money to burn
271 	 */
272 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
273 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
274 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
275 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
276 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
277 		totalSupply -= _value;                              // Update totalSupply
278 		emit Burn(_from, _value);
279 		return true;
280 	}
281 }
282 
283 
284 /**
285  * @title TAO
286  */
287 contract TAO {
288 	using SafeMath for uint256;
289 
290 	address public vaultAddress;
291 	string public name;				// the name for this TAO
292 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
293 
294 	// TAO's data
295 	string public datHash;
296 	string public database;
297 	string public keyValue;
298 	bytes32 public contentId;
299 
300 	/**
301 	 * 0 = TAO
302 	 * 1 = Name
303 	 */
304 	uint8 public typeId;
305 
306 	/**
307 	 * @dev Constructor function
308 	 */
309 	constructor (string memory _name,
310 		address _originId,
311 		string memory _datHash,
312 		string memory _database,
313 		string memory _keyValue,
314 		bytes32 _contentId,
315 		address _vaultAddress
316 	) public {
317 		name = _name;
318 		originId = _originId;
319 		datHash = _datHash;
320 		database = _database;
321 		keyValue = _keyValue;
322 		contentId = _contentId;
323 
324 		// Creating TAO
325 		typeId = 0;
326 
327 		vaultAddress = _vaultAddress;
328 	}
329 
330 	/**
331 	 * @dev Checks if calling address is Vault contract
332 	 */
333 	modifier onlyVault {
334 		require (msg.sender == vaultAddress);
335 		_;
336 	}
337 
338 	/**
339 	 * Will receive any ETH sent
340 	 */
341 	function () external payable {
342 	}
343 
344 	/**
345 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
346 	 * @param _recipient The recipient address
347 	 * @param _amount The amount to transfer
348 	 * @return true on success
349 	 */
350 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
351 		_recipient.transfer(_amount);
352 		return true;
353 	}
354 
355 	/**
356 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
357 	 * @param _erc20TokenAddress The address of ERC20 Token
358 	 * @param _recipient The recipient address
359 	 * @param _amount The amount to transfer
360 	 * @return true on success
361 	 */
362 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
363 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
364 		_erc20.transfer(_recipient, _amount);
365 		return true;
366 	}
367 }
368 
369 
370 
371 
372 /**
373  * @title Name
374  */
375 contract Name is TAO {
376 	/**
377 	 * @dev Constructor function
378 	 */
379 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
380 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
381 		// Creating Name
382 		typeId = 1;
383 	}
384 }
385 
386 
387 
388 
389 /**
390  * @title AOLibrary
391  */
392 library AOLibrary {
393 	using SafeMath for uint256;
394 
395 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
396 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
397 
398 	/**
399 	 * @dev Check whether or not the given TAO ID is a TAO
400 	 * @param _taoId The ID of the TAO
401 	 * @return true if yes. false otherwise
402 	 */
403 	function isTAO(address _taoId) public view returns (bool) {
404 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
405 	}
406 
407 	/**
408 	 * @dev Check whether or not the given Name ID is a Name
409 	 * @param _nameId The ID of the Name
410 	 * @return true if yes. false otherwise
411 	 */
412 	function isName(address _nameId) public view returns (bool) {
413 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
414 	}
415 
416 	/**
417 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
418 	 * @param _tokenAddress The ERC20 Token address to check
419 	 */
420 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
421 		if (_tokenAddress == address(0)) {
422 			return false;
423 		}
424 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
425 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
426 	}
427 
428 	/**
429 	 * @dev Checks if the calling contract address is The AO
430 	 *		OR
431 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
432 	 * @param _sender The address to check
433 	 * @param _theAO The AO address
434 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
435 	 * @return true if yes, false otherwise
436 	 */
437 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
438 		return (_sender == _theAO ||
439 			(
440 				(isTAO(_theAO) || isName(_theAO)) &&
441 				_nameTAOPositionAddress != address(0) &&
442 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
443 			)
444 		);
445 	}
446 
447 	/**
448 	 * @dev Return the divisor used to correctly calculate percentage.
449 	 *		Percentage stored throughout AO contracts covers 4 decimals,
450 	 *		so 1% is 10000, 1.25% is 12500, etc
451 	 */
452 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
453 		return _PERCENTAGE_DIVISOR;
454 	}
455 
456 	/**
457 	 * @dev Return the divisor used to correctly calculate multiplier.
458 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
459 	 *		so 1 is 1000000, 0.023 is 23000, etc
460 	 */
461 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
462 		return _MULTIPLIER_DIVISOR;
463 	}
464 
465 	/**
466 	 * @dev deploy a TAO
467 	 * @param _name The name of the TAO
468 	 * @param _originId The Name ID the creates the TAO
469 	 * @param _datHash The datHash of this TAO
470 	 * @param _database The database for this TAO
471 	 * @param _keyValue The key/value pair to be checked on the database
472 	 * @param _contentId The contentId related to this TAO
473 	 * @param _nameTAOVaultAddress The address of NameTAOVault
474 	 */
475 	function deployTAO(string memory _name,
476 		address _originId,
477 		string memory _datHash,
478 		string memory _database,
479 		string memory _keyValue,
480 		bytes32 _contentId,
481 		address _nameTAOVaultAddress
482 		) public returns (TAO _tao) {
483 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
484 	}
485 
486 	/**
487 	 * @dev deploy a Name
488 	 * @param _name The name of the Name
489 	 * @param _originId The eth address the creates the Name
490 	 * @param _datHash The datHash of this Name
491 	 * @param _database The database for this Name
492 	 * @param _keyValue The key/value pair to be checked on the database
493 	 * @param _contentId The contentId related to this Name
494 	 * @param _nameTAOVaultAddress The address of NameTAOVault
495 	 */
496 	function deployName(string memory _name,
497 		address _originId,
498 		string memory _datHash,
499 		string memory _database,
500 		string memory _keyValue,
501 		bytes32 _contentId,
502 		address _nameTAOVaultAddress
503 		) public returns (Name _myName) {
504 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
505 	}
506 
507 	/**
508 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
509 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
510 	 * @param _currentPrimordialBalance Account's current primordial ion balance
511 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
512 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
513 	 * @return the new primordial weighted multiplier
514 	 */
515 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
516 		if (_currentWeightedMultiplier > 0) {
517 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
518 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
519 			return _totalWeightedIons.div(_totalIons);
520 		} else {
521 			return _additionalWeightedMultiplier;
522 		}
523 	}
524 
525 	/**
526 	 * @dev Calculate the primordial ion multiplier on a given lot
527 	 *		Total Primordial Mintable = T
528 	 *		Total Primordial Minted = M
529 	 *		Starting Multiplier = S
530 	 *		Ending Multiplier = E
531 	 *		To Purchase = P
532 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
533 	 *
534 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
535 	 * @param _totalPrimordialMintable Total Primordial ion mintable
536 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
537 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
538 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
539 	 * @return The multiplier in (10 ** 6)
540 	 */
541 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
542 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
543 			/**
544 			 * Let temp = M + (P/2)
545 			 * Multiplier = (1 - (temp / T)) x (S-E)
546 			 */
547 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
548 
549 			/**
550 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
551 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
552 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
553 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
554 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
555 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
556 			 */
557 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
558 			/**
559 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
560 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
561 			 */
562 			return multiplier.div(_MULTIPLIER_DIVISOR);
563 		} else {
564 			return 0;
565 		}
566 	}
567 
568 	/**
569 	 * @dev Calculate the bonus percentage of network ion on a given lot
570 	 *		Total Primordial Mintable = T
571 	 *		Total Primordial Minted = M
572 	 *		Starting Network Bonus Multiplier = Bs
573 	 *		Ending Network Bonus Multiplier = Be
574 	 *		To Purchase = P
575 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
576 	 *
577 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
578 	 * @param _totalPrimordialMintable Total Primordial ion intable
579 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
580 	 * @param _startingMultiplier The starting Network ion bonus multiplier
581 	 * @param _endingMultiplier The ending Network ion bonus multiplier
582 	 * @return The bonus percentage
583 	 */
584 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
585 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
586 			/**
587 			 * Let temp = M + (P/2)
588 			 * B% = (1 - (temp / T)) x (Bs-Be)
589 			 */
590 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
591 
592 			/**
593 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
594 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
595 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
596 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
597 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
598 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
599 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
600 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
601 			 */
602 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
603 			return bonusPercentage;
604 		} else {
605 			return 0;
606 		}
607 	}
608 
609 	/**
610 	 * @dev Calculate the bonus amount of network ion on a given lot
611 	 *		AO Bonus Amount = B% x P
612 	 *
613 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
614 	 * @param _totalPrimordialMintable Total Primordial ion intable
615 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
616 	 * @param _startingMultiplier The starting Network ion bonus multiplier
617 	 * @param _endingMultiplier The ending Network ion bonus multiplier
618 	 * @return The bonus percentage
619 	 */
620 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
621 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
622 		/**
623 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
624 		 * when calculating the network ion bonus amount
625 		 */
626 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
627 		return networkBonus;
628 	}
629 
630 	/**
631 	 * @dev Calculate the maximum amount of Primordial an account can burn
632 	 *		_primordialBalance = P
633 	 *		_currentWeightedMultiplier = M
634 	 *		_maximumMultiplier = S
635 	 *		_amountToBurn = B
636 	 *		B = ((S x P) - (P x M)) / S
637 	 *
638 	 * @param _primordialBalance Account's primordial ion balance
639 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
640 	 * @param _maximumMultiplier The maximum multiplier of this account
641 	 * @return The maximum burn amount
642 	 */
643 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
644 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
645 	}
646 
647 	/**
648 	 * @dev Calculate the new multiplier after burning primordial ion
649 	 *		_primordialBalance = P
650 	 *		_currentWeightedMultiplier = M
651 	 *		_amountToBurn = B
652 	 *		_newMultiplier = E
653 	 *		E = (P x M) / (P - B)
654 	 *
655 	 * @param _primordialBalance Account's primordial ion balance
656 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
657 	 * @param _amountToBurn The amount of primordial ion to burn
658 	 * @return The new multiplier
659 	 */
660 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
661 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
662 	}
663 
664 	/**
665 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
666 	 *		_primordialBalance = P
667 	 *		_currentWeightedMultiplier = M
668 	 *		_amountToConvert = C
669 	 *		_newMultiplier = E
670 	 *		E = (P x M) / (P + C)
671 	 *
672 	 * @param _primordialBalance Account's primordial ion balance
673 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
674 	 * @param _amountToConvert The amount of network ion to convert
675 	 * @return The new multiplier
676 	 */
677 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
678 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
679 	}
680 
681 	/**
682 	 * @dev count num of digits
683 	 * @param number uint256 of the nuumber to be checked
684 	 * @return uint8 num of digits
685 	 */
686 	function numDigits(uint256 number) public pure returns (uint8) {
687 		uint8 digits = 0;
688 		while(number != 0) {
689 			number = number.div(10);
690 			digits++;
691 		}
692 		return digits;
693 	}
694 }
695 
696 
697 
698 /**
699  * @title NameTAOLookup
700  *
701  */
702 contract NameTAOLookup is TheAO, INameTAOLookup {
703 	address public nameFactoryAddress;
704 	address public taoFactoryAddress;
705 
706 	struct NameTAOInfo {
707 		string name;
708 		address nameTAOId;
709 		uint256 typeId; // 0 = TAO. 1 = Name
710 		string parentName;
711 		address parentId; // Can be a Name ID/TAO ID/ETH address
712 		uint256 parentTypeId; // 0 = TAO. 1 = Name. 2 = ETH address
713 	}
714 
715 	uint256 public totalNames;
716 	uint256 public totalTAOs;
717 
718 	// Mapping from Name/TAO ID to NameTAOInfo
719 	mapping (address => NameTAOInfo) internal nameTAOInfos;
720 
721 	// Mapping from name to Name/TAO ID
722 	mapping (bytes32 => address) internal nameToNameTAOIdLookup;
723 
724 	/**
725 	 * @dev Constructor function
726 	 */
727 	constructor(address _nameFactoryAddress, address _taoFactoryAddress, address _nameTAOPositionAddress) public {
728 		setNameFactoryAddress(_nameFactoryAddress);
729 		setTAOFactoryAddress(_taoFactoryAddress);
730 		setNameTAOPositionAddress(_nameTAOPositionAddress);
731 	}
732 
733 	/**
734 	 * @dev Checks if the calling contract address is The AO
735 	 *		OR
736 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
737 	 */
738 	modifier onlyTheAO {
739 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
740 		_;
741 	}
742 
743 	/**
744 	 * @dev Check if calling address is Factory
745 	 */
746 	modifier onlyFactory {
747 		require (msg.sender == nameFactoryAddress || msg.sender == taoFactoryAddress);
748 		_;
749 	}
750 
751 	/***** The AO ONLY METHODS *****/
752 	/**
753 	 * @dev Transfer ownership of The AO to new address
754 	 * @param _theAO The new address to be transferred
755 	 */
756 	function transferOwnership(address _theAO) public onlyTheAO {
757 		require (_theAO != address(0));
758 		theAO = _theAO;
759 	}
760 
761 	/**
762 	 * @dev Whitelist `_account` address to transact on behalf of others
763 	 * @param _account The address to whitelist
764 	 * @param _whitelist Either to whitelist or not
765 	 */
766 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
767 		require (_account != address(0));
768 		whitelist[_account] = _whitelist;
769 	}
770 
771 	/**
772 	 * @dev The AO set the nameFactoryAddress Address
773 	 * @param _nameFactoryAddress The address of NameFactory
774 	 */
775 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
776 		require (_nameFactoryAddress != address(0));
777 		nameFactoryAddress = _nameFactoryAddress;
778 	}
779 
780 	/**
781 	 * @dev The AO set the taoFactoryAddress Address
782 	 * @param _taoFactoryAddress The address of TAOFactory
783 	 */
784 	function setTAOFactoryAddress(address _taoFactoryAddress) public onlyTheAO {
785 		require (_taoFactoryAddress != address(0));
786 		taoFactoryAddress = _taoFactoryAddress;
787 	}
788 
789 	/**
790 	 * @dev The AO set the NameTAOPosition Address
791 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
792 	 */
793 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
794 		require (_nameTAOPositionAddress != address(0));
795 		nameTAOPositionAddress = _nameTAOPositionAddress;
796 	}
797 
798 	/***** PUBLIC METHODS *****/
799 	/**
800 	 * @dev Check whether or not a name exist in the list
801 	 * @param _name The name to be checked
802 	 * @return true if yes, false otherwise
803 	 */
804 	function isExist(string calldata _name) external view returns (bool) {
805 		bytes32 _nameKey = keccak256(abi.encodePacked(_name));
806 		return (nameToNameTAOIdLookup[_nameKey] != address(0));
807 	}
808 
809 	/**
810 	 * @dev Add a new NameTAOInfo
811 	 * @param _name The name of the Name/TAO
812 	 * @param _nameTAOId The address of the Name/TAO
813 	 * @param _typeId If TAO = 0. Name = 1
814 	 * @param _parentName The parent name of the Name/TAO
815 	 * @param _parentId The address of the parent. Can be a Name ID/TAO ID/ETH address
816 	 * @param _parentTypeId If TAO = 0. Name = 1. 2 = ETH address
817 	 * @return true on success
818 	 */
819 	function initialize(string calldata _name, address _nameTAOId, uint256 _typeId, string calldata _parentName, address _parentId, uint256 _parentTypeId) external onlyFactory returns (bool) {
820 		require (bytes(_name).length > 0);
821 		require (_nameTAOId != address(0));
822 		require (_typeId == 0 || _typeId == 1);
823 		require (bytes(_parentName).length > 0);
824 		require (_parentId != address(0));
825 		require (_parentTypeId >= 0 && _parentTypeId <= 2);
826 		require (!this.isExist(_name));
827 		if (_parentTypeId != 2) {
828 			require (this.isExist(_parentName));
829 		}
830 
831 		bytes32 _nameKey = keccak256(abi.encodePacked(_name));
832 		nameToNameTAOIdLookup[_nameKey] = _nameTAOId;
833 
834 		NameTAOInfo storage _nameTAOInfo = nameTAOInfos[_nameTAOId];
835 		_nameTAOInfo.name = _name;
836 		_nameTAOInfo.nameTAOId = _nameTAOId;
837 		_nameTAOInfo.typeId = _typeId;
838 		_nameTAOInfo.parentName = _parentName;
839 		_nameTAOInfo.parentId = _parentId;
840 		_nameTAOInfo.parentTypeId = _parentTypeId;
841 
842 		if (_typeId == 0) {
843 			totalTAOs++;
844 		} else {
845 			totalNames++;
846 		}
847 		return true;
848 	}
849 
850 	/**
851 	 * @dev Get the NameTAOInfo given a name
852 	 * @param _name The name to be queried
853 	 * @return the name of Name/TAO
854 	 * @return the address of Name/TAO
855 	 * @return type ID. 0 = TAO. 1 = Name
856 	 * @return the parent name of Name/TAO
857 	 * @return the address of the parent. Can be a Name ID/TAO ID/ETH address
858 	 * @return the parent typeId. If TAO = 0. Name = 1. 2 = ETH address
859 	 */
860 	function getByName(string memory _name) public view returns (string memory, address, uint256, string memory, address, uint256) {
861 		require (this.isExist(_name));
862 		bytes32 _nameKey = keccak256(abi.encodePacked(_name));
863 		NameTAOInfo memory _nameTAOInfo = nameTAOInfos[nameToNameTAOIdLookup[_nameKey]];
864 		return (
865 			_nameTAOInfo.name,
866 			_nameTAOInfo.nameTAOId,
867 			_nameTAOInfo.typeId,
868 			_nameTAOInfo.parentName,
869 			_nameTAOInfo.parentId,
870 			_nameTAOInfo.parentTypeId
871 		);
872 	}
873 
874 	/**
875 	 * @dev Get the NameTAOInfo given a Name/TAO ID
876 	 * @param _id The Name/TAO ID to be queried
877 	 * @return the name of Name/TAO
878 	 * @return the address of Name/TAO
879 	 * @return type ID. 0 = TAO. 1 = Name
880 	 * @return the parent name of Name/TAO
881 	 * @return the address of the parent. Can be a Name ID/TAO ID/ETH address
882 	 * @return the parent typeId. If TAO = 0. Name = 1. 2 = ETH address
883 	 */
884 	function getById(address _id) external view returns (string memory, address, uint256, string memory, address, uint256) {
885 		require (nameTAOInfos[_id].nameTAOId != address(0));
886 		NameTAOInfo memory _nameTAOInfo = nameTAOInfos[_id];
887 		return (
888 			_nameTAOInfo.name,
889 			_nameTAOInfo.nameTAOId,
890 			_nameTAOInfo.typeId,
891 			_nameTAOInfo.parentName,
892 			_nameTAOInfo.parentId,
893 			_nameTAOInfo.parentTypeId
894 		);
895 	}
896 
897 	/**
898 	 * @dev Return the Name/TAO ID given a _name
899 	 * @param _name The name to be queried
900 	 * @return the nameTAOId of the name
901 	 */
902 	function getIdByName(string calldata _name) external view returns (address) {
903 		bytes32 _nameKey = keccak256(abi.encodePacked(_name));
904 		return nameToNameTAOIdLookup[_nameKey];
905 	}
906 }