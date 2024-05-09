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
70 interface INameAccountRecovery {
71 	function isCompromised(address _id) external view returns (bool);
72 }
73 
74 
75 interface INameFactory {
76 	function nonces(address _nameId) external view returns (uint256);
77 	function incrementNonce(address _nameId) external returns (uint256);
78 	function ethAddressToNameId(address _ethAddress) external view returns (address);
79 	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
80 	function nameIdToEthAddress(address _nameId) external view returns (address);
81 }
82 
83 
84 interface INamePublicKey {
85 	function initialize(address _id, address _defaultKey, address _writerKey) external returns (bool);
86 
87 	function isKeyExist(address _id, address _key) external view returns (bool);
88 
89 	function getDefaultKey(address _id) external view returns (address);
90 
91 	function whitelistAddKey(address _id, address _key) external returns (bool);
92 }
93 
94 
95 
96 
97 
98 
99 
100 
101 
102 
103 
104 
105 
106 contract TokenERC20 {
107 	// Public variables of the token
108 	string public name;
109 	string public symbol;
110 	uint8 public decimals = 18;
111 	// 18 decimals is the strongly suggested default, avoid changing it
112 	uint256 public totalSupply;
113 
114 	// This creates an array with all balances
115 	mapping (address => uint256) public balanceOf;
116 	mapping (address => mapping (address => uint256)) public allowance;
117 
118 	// This generates a public event on the blockchain that will notify clients
119 	event Transfer(address indexed from, address indexed to, uint256 value);
120 
121 	// This generates a public event on the blockchain that will notify clients
122 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
123 
124 	// This notifies clients about the amount burnt
125 	event Burn(address indexed from, uint256 value);
126 
127 	/**
128 	 * Constructor function
129 	 *
130 	 * Initializes contract with initial supply tokens to the creator of the contract
131 	 */
132 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
133 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
134 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
135 		name = tokenName;                                   // Set the name for display purposes
136 		symbol = tokenSymbol;                               // Set the symbol for display purposes
137 	}
138 
139 	/**
140 	 * Internal transfer, only can be called by this contract
141 	 */
142 	function _transfer(address _from, address _to, uint _value) internal {
143 		// Prevent transfer to 0x0 address. Use burn() instead
144 		require(_to != address(0));
145 		// Check if the sender has enough
146 		require(balanceOf[_from] >= _value);
147 		// Check for overflows
148 		require(balanceOf[_to] + _value > balanceOf[_to]);
149 		// Save this for an assertion in the future
150 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
151 		// Subtract from the sender
152 		balanceOf[_from] -= _value;
153 		// Add the same to the recipient
154 		balanceOf[_to] += _value;
155 		emit Transfer(_from, _to, _value);
156 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
157 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
158 	}
159 
160 	/**
161 	 * Transfer tokens
162 	 *
163 	 * Send `_value` tokens to `_to` from your account
164 	 *
165 	 * @param _to The address of the recipient
166 	 * @param _value the amount to send
167 	 */
168 	function transfer(address _to, uint256 _value) public returns (bool success) {
169 		_transfer(msg.sender, _to, _value);
170 		return true;
171 	}
172 
173 	/**
174 	 * Transfer tokens from other address
175 	 *
176 	 * Send `_value` tokens to `_to` in behalf of `_from`
177 	 *
178 	 * @param _from The address of the sender
179 	 * @param _to The address of the recipient
180 	 * @param _value the amount to send
181 	 */
182 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
183 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
184 		allowance[_from][msg.sender] -= _value;
185 		_transfer(_from, _to, _value);
186 		return true;
187 	}
188 
189 	/**
190 	 * Set allowance for other address
191 	 *
192 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
193 	 *
194 	 * @param _spender The address authorized to spend
195 	 * @param _value the max amount they can spend
196 	 */
197 	function approve(address _spender, uint256 _value) public returns (bool success) {
198 		allowance[msg.sender][_spender] = _value;
199 		emit Approval(msg.sender, _spender, _value);
200 		return true;
201 	}
202 
203 	/**
204 	 * Set allowance for other address and notify
205 	 *
206 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
207 	 *
208 	 * @param _spender The address authorized to spend
209 	 * @param _value the max amount they can spend
210 	 * @param _extraData some extra information to send to the approved contract
211 	 */
212 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
213 		tokenRecipient spender = tokenRecipient(_spender);
214 		if (approve(_spender, _value)) {
215 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
216 			return true;
217 		}
218 	}
219 
220 	/**
221 	 * Destroy tokens
222 	 *
223 	 * Remove `_value` tokens from the system irreversibly
224 	 *
225 	 * @param _value the amount of money to burn
226 	 */
227 	function burn(uint256 _value) public returns (bool success) {
228 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
229 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
230 		totalSupply -= _value;                      // Updates totalSupply
231 		emit Burn(msg.sender, _value);
232 		return true;
233 	}
234 
235 	/**
236 	 * Destroy tokens from other account
237 	 *
238 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
239 	 *
240 	 * @param _from the address of the sender
241 	 * @param _value the amount of money to burn
242 	 */
243 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
244 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
245 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
246 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
247 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
248 		totalSupply -= _value;                              // Update totalSupply
249 		emit Burn(_from, _value);
250 		return true;
251 	}
252 }
253 
254 
255 /**
256  * @title TAO
257  */
258 contract TAO {
259 	using SafeMath for uint256;
260 
261 	address public vaultAddress;
262 	string public name;				// the name for this TAO
263 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
264 
265 	// TAO's data
266 	string public datHash;
267 	string public database;
268 	string public keyValue;
269 	bytes32 public contentId;
270 
271 	/**
272 	 * 0 = TAO
273 	 * 1 = Name
274 	 */
275 	uint8 public typeId;
276 
277 	/**
278 	 * @dev Constructor function
279 	 */
280 	constructor (string memory _name,
281 		address _originId,
282 		string memory _datHash,
283 		string memory _database,
284 		string memory _keyValue,
285 		bytes32 _contentId,
286 		address _vaultAddress
287 	) public {
288 		name = _name;
289 		originId = _originId;
290 		datHash = _datHash;
291 		database = _database;
292 		keyValue = _keyValue;
293 		contentId = _contentId;
294 
295 		// Creating TAO
296 		typeId = 0;
297 
298 		vaultAddress = _vaultAddress;
299 	}
300 
301 	/**
302 	 * @dev Checks if calling address is Vault contract
303 	 */
304 	modifier onlyVault {
305 		require (msg.sender == vaultAddress);
306 		_;
307 	}
308 
309 	/**
310 	 * Will receive any ETH sent
311 	 */
312 	function () external payable {
313 	}
314 
315 	/**
316 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
317 	 * @param _recipient The recipient address
318 	 * @param _amount The amount to transfer
319 	 * @return true on success
320 	 */
321 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
322 		_recipient.transfer(_amount);
323 		return true;
324 	}
325 
326 	/**
327 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
328 	 * @param _erc20TokenAddress The address of ERC20 Token
329 	 * @param _recipient The recipient address
330 	 * @param _amount The amount to transfer
331 	 * @return true on success
332 	 */
333 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
334 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
335 		_erc20.transfer(_recipient, _amount);
336 		return true;
337 	}
338 }
339 
340 
341 
342 
343 /**
344  * @title Name
345  */
346 contract Name is TAO {
347 	/**
348 	 * @dev Constructor function
349 	 */
350 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
351 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
352 		// Creating Name
353 		typeId = 1;
354 	}
355 }
356 
357 
358 
359 
360 /**
361  * @title AOLibrary
362  */
363 library AOLibrary {
364 	using SafeMath for uint256;
365 
366 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
367 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
368 
369 	/**
370 	 * @dev Check whether or not the given TAO ID is a TAO
371 	 * @param _taoId The ID of the TAO
372 	 * @return true if yes. false otherwise
373 	 */
374 	function isTAO(address _taoId) public view returns (bool) {
375 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
376 	}
377 
378 	/**
379 	 * @dev Check whether or not the given Name ID is a Name
380 	 * @param _nameId The ID of the Name
381 	 * @return true if yes. false otherwise
382 	 */
383 	function isName(address _nameId) public view returns (bool) {
384 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
385 	}
386 
387 	/**
388 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
389 	 * @param _tokenAddress The ERC20 Token address to check
390 	 */
391 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
392 		if (_tokenAddress == address(0)) {
393 			return false;
394 		}
395 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
396 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
397 	}
398 
399 	/**
400 	 * @dev Checks if the calling contract address is The AO
401 	 *		OR
402 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
403 	 * @param _sender The address to check
404 	 * @param _theAO The AO address
405 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
406 	 * @return true if yes, false otherwise
407 	 */
408 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
409 		return (_sender == _theAO ||
410 			(
411 				(isTAO(_theAO) || isName(_theAO)) &&
412 				_nameTAOPositionAddress != address(0) &&
413 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
414 			)
415 		);
416 	}
417 
418 	/**
419 	 * @dev Return the divisor used to correctly calculate percentage.
420 	 *		Percentage stored throughout AO contracts covers 4 decimals,
421 	 *		so 1% is 10000, 1.25% is 12500, etc
422 	 */
423 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
424 		return _PERCENTAGE_DIVISOR;
425 	}
426 
427 	/**
428 	 * @dev Return the divisor used to correctly calculate multiplier.
429 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
430 	 *		so 1 is 1000000, 0.023 is 23000, etc
431 	 */
432 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
433 		return _MULTIPLIER_DIVISOR;
434 	}
435 
436 	/**
437 	 * @dev deploy a TAO
438 	 * @param _name The name of the TAO
439 	 * @param _originId The Name ID the creates the TAO
440 	 * @param _datHash The datHash of this TAO
441 	 * @param _database The database for this TAO
442 	 * @param _keyValue The key/value pair to be checked on the database
443 	 * @param _contentId The contentId related to this TAO
444 	 * @param _nameTAOVaultAddress The address of NameTAOVault
445 	 */
446 	function deployTAO(string memory _name,
447 		address _originId,
448 		string memory _datHash,
449 		string memory _database,
450 		string memory _keyValue,
451 		bytes32 _contentId,
452 		address _nameTAOVaultAddress
453 		) public returns (TAO _tao) {
454 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
455 	}
456 
457 	/**
458 	 * @dev deploy a Name
459 	 * @param _name The name of the Name
460 	 * @param _originId The eth address the creates the Name
461 	 * @param _datHash The datHash of this Name
462 	 * @param _database The database for this Name
463 	 * @param _keyValue The key/value pair to be checked on the database
464 	 * @param _contentId The contentId related to this Name
465 	 * @param _nameTAOVaultAddress The address of NameTAOVault
466 	 */
467 	function deployName(string memory _name,
468 		address _originId,
469 		string memory _datHash,
470 		string memory _database,
471 		string memory _keyValue,
472 		bytes32 _contentId,
473 		address _nameTAOVaultAddress
474 		) public returns (Name _myName) {
475 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
476 	}
477 
478 	/**
479 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
480 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
481 	 * @param _currentPrimordialBalance Account's current primordial ion balance
482 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
483 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
484 	 * @return the new primordial weighted multiplier
485 	 */
486 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
487 		if (_currentWeightedMultiplier > 0) {
488 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
489 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
490 			return _totalWeightedIons.div(_totalIons);
491 		} else {
492 			return _additionalWeightedMultiplier;
493 		}
494 	}
495 
496 	/**
497 	 * @dev Calculate the primordial ion multiplier on a given lot
498 	 *		Total Primordial Mintable = T
499 	 *		Total Primordial Minted = M
500 	 *		Starting Multiplier = S
501 	 *		Ending Multiplier = E
502 	 *		To Purchase = P
503 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
504 	 *
505 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
506 	 * @param _totalPrimordialMintable Total Primordial ion mintable
507 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
508 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
509 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
510 	 * @return The multiplier in (10 ** 6)
511 	 */
512 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
513 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
514 			/**
515 			 * Let temp = M + (P/2)
516 			 * Multiplier = (1 - (temp / T)) x (S-E)
517 			 */
518 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
519 
520 			/**
521 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
522 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
523 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
524 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
525 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
526 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
527 			 */
528 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
529 			/**
530 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
531 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
532 			 */
533 			return multiplier.div(_MULTIPLIER_DIVISOR);
534 		} else {
535 			return 0;
536 		}
537 	}
538 
539 	/**
540 	 * @dev Calculate the bonus percentage of network ion on a given lot
541 	 *		Total Primordial Mintable = T
542 	 *		Total Primordial Minted = M
543 	 *		Starting Network Bonus Multiplier = Bs
544 	 *		Ending Network Bonus Multiplier = Be
545 	 *		To Purchase = P
546 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
547 	 *
548 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
549 	 * @param _totalPrimordialMintable Total Primordial ion intable
550 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
551 	 * @param _startingMultiplier The starting Network ion bonus multiplier
552 	 * @param _endingMultiplier The ending Network ion bonus multiplier
553 	 * @return The bonus percentage
554 	 */
555 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
556 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
557 			/**
558 			 * Let temp = M + (P/2)
559 			 * B% = (1 - (temp / T)) x (Bs-Be)
560 			 */
561 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
562 
563 			/**
564 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
565 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
566 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
567 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
568 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
569 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
570 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
571 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
572 			 */
573 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
574 			return bonusPercentage;
575 		} else {
576 			return 0;
577 		}
578 	}
579 
580 	/**
581 	 * @dev Calculate the bonus amount of network ion on a given lot
582 	 *		AO Bonus Amount = B% x P
583 	 *
584 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
585 	 * @param _totalPrimordialMintable Total Primordial ion intable
586 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
587 	 * @param _startingMultiplier The starting Network ion bonus multiplier
588 	 * @param _endingMultiplier The ending Network ion bonus multiplier
589 	 * @return The bonus percentage
590 	 */
591 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
592 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
593 		/**
594 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
595 		 * when calculating the network ion bonus amount
596 		 */
597 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
598 		return networkBonus;
599 	}
600 
601 	/**
602 	 * @dev Calculate the maximum amount of Primordial an account can burn
603 	 *		_primordialBalance = P
604 	 *		_currentWeightedMultiplier = M
605 	 *		_maximumMultiplier = S
606 	 *		_amountToBurn = B
607 	 *		B = ((S x P) - (P x M)) / S
608 	 *
609 	 * @param _primordialBalance Account's primordial ion balance
610 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
611 	 * @param _maximumMultiplier The maximum multiplier of this account
612 	 * @return The maximum burn amount
613 	 */
614 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
615 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
616 	}
617 
618 	/**
619 	 * @dev Calculate the new multiplier after burning primordial ion
620 	 *		_primordialBalance = P
621 	 *		_currentWeightedMultiplier = M
622 	 *		_amountToBurn = B
623 	 *		_newMultiplier = E
624 	 *		E = (P x M) / (P - B)
625 	 *
626 	 * @param _primordialBalance Account's primordial ion balance
627 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
628 	 * @param _amountToBurn The amount of primordial ion to burn
629 	 * @return The new multiplier
630 	 */
631 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
632 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
633 	}
634 
635 	/**
636 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
637 	 *		_primordialBalance = P
638 	 *		_currentWeightedMultiplier = M
639 	 *		_amountToConvert = C
640 	 *		_newMultiplier = E
641 	 *		E = (P x M) / (P + C)
642 	 *
643 	 * @param _primordialBalance Account's primordial ion balance
644 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
645 	 * @param _amountToConvert The amount of network ion to convert
646 	 * @return The new multiplier
647 	 */
648 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
649 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
650 	}
651 
652 	/**
653 	 * @dev count num of digits
654 	 * @param number uint256 of the nuumber to be checked
655 	 * @return uint8 num of digits
656 	 */
657 	function numDigits(uint256 number) public pure returns (uint8) {
658 		uint8 digits = 0;
659 		while(number != 0) {
660 			number = number.div(10);
661 			digits++;
662 		}
663 		return digits;
664 	}
665 }
666 
667 
668 
669 contract TheAO {
670 	address public theAO;
671 	address public nameTAOPositionAddress;
672 
673 	// Check whether an address is whitelisted and granted access to transact
674 	// on behalf of others
675 	mapping (address => bool) public whitelist;
676 
677 	constructor() public {
678 		theAO = msg.sender;
679 	}
680 
681 	/**
682 	 * @dev Checks if msg.sender is in whitelist.
683 	 */
684 	modifier inWhitelist() {
685 		require (whitelist[msg.sender] == true);
686 		_;
687 	}
688 
689 	/**
690 	 * @dev Transfer ownership of The AO to new address
691 	 * @param _theAO The new address to be transferred
692 	 */
693 	function transferOwnership(address _theAO) public {
694 		require (msg.sender == theAO);
695 		require (_theAO != address(0));
696 		theAO = _theAO;
697 	}
698 
699 	/**
700 	 * @dev Whitelist `_account` address to transact on behalf of others
701 	 * @param _account The address to whitelist
702 	 * @param _whitelist Either to whitelist or not
703 	 */
704 	function setWhitelist(address _account, bool _whitelist) public {
705 		require (msg.sender == theAO);
706 		require (_account != address(0));
707 		whitelist[_account] = _whitelist;
708 	}
709 }
710 
711 
712 
713 
714 
715 
716 /**
717  * @title NamePublicKey
718  */
719 contract NamePublicKey is TheAO, INamePublicKey {
720 	using SafeMath for uint256;
721 
722 	address public nameFactoryAddress;
723 	address public nameAccountRecoveryAddress;
724 
725 	INameFactory internal _nameFactory;
726 	INameTAOPosition internal _nameTAOPosition;
727 	INameAccountRecovery internal _nameAccountRecovery;
728 
729 	struct PublicKey {
730 		bool created;
731 		address defaultKey;
732 		address writerKey;
733 		address[] keys;
734 	}
735 
736 	// Mapping from nameId to its PublicKey
737 	mapping (address => PublicKey) internal publicKeys;
738 
739 	// Mapping from key to nameId
740 	mapping (address => address) public keyToNameId;
741 
742 	// Event to be broadcasted to public when a publicKey is added to a Name
743 	event AddKey(address indexed nameId, address publicKey, uint256 nonce);
744 
745 	// Event to be broadcasted to public when a publicKey is removed from a Name
746 	event RemoveKey(address indexed nameId, address publicKey, uint256 nonce);
747 
748 	// Event to be broadcasted to public when a publicKey is set as default for a Name
749 	event SetDefaultKey(address indexed nameId, address publicKey, uint256 nonce);
750 
751 	// Event to be broadcasted to public when a publicKey is set as writer for a Name
752 	event SetWriterKey(address indexed nameId, address publicKey, uint256 nonce);
753 
754 	/**
755 	 * @dev Constructor function
756 	 */
757 	constructor(address _nameFactoryAddress, address _nameTAOPositionAddress) public {
758 		setNameFactoryAddress(_nameFactoryAddress);
759 		setNameTAOPositionAddress(_nameTAOPositionAddress);
760 	}
761 
762 	/**
763 	 * @dev Checks if the calling contract address is The AO
764 	 *		OR
765 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
766 	 */
767 	modifier onlyTheAO {
768 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
769 		_;
770 	}
771 
772 	/**
773 	 * @dev Check if calling address is Factory
774 	 */
775 	modifier onlyFactory {
776 		require (msg.sender == nameFactoryAddress);
777 		_;
778 	}
779 
780 	/**
781 	 * @dev Check if `_nameId` is a Name
782 	 */
783 	modifier isName(address _nameId) {
784 		require (AOLibrary.isName(_nameId));
785 		_;
786 	}
787 
788 	/**
789 	 * @dev Check if msg.sender is the current advocate of Name ID
790 	 */
791 	modifier onlyAdvocate(address _id) {
792 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _id));
793 		_;
794 	}
795 
796 	/**
797 	 * @dev Only allowed if sender's Name is not compromised
798 	 */
799 	modifier senderNameNotCompromised() {
800 		require (!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
801 		_;
802 	}
803 
804 	/**
805 	 * @dev Check if `_key` is not yet taken
806 	 */
807 	modifier keyNotTaken(address _key) {
808 		require (_key != address(0) && keyToNameId[_key] == address(0));
809 		_;
810 	}
811 
812 	/***** The AO ONLY METHODS *****/
813 	/**
814 	 * @dev Transfer ownership of The AO to new address
815 	 * @param _theAO The new address to be transferred
816 	 */
817 	function transferOwnership(address _theAO) public onlyTheAO {
818 		require (_theAO != address(0));
819 		theAO = _theAO;
820 	}
821 
822 	/**
823 	 * @dev Whitelist `_account` address to transact on behalf of others
824 	 * @param _account The address to whitelist
825 	 * @param _whitelist Either to whitelist or not
826 	 */
827 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
828 		require (_account != address(0));
829 		whitelist[_account] = _whitelist;
830 	}
831 
832 	/**
833 	 * @dev The AO sets NameFactory address
834 	 * @param _nameFactoryAddress The address of NameFactory
835 	 */
836 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
837 		require (_nameFactoryAddress != address(0));
838 		nameFactoryAddress = _nameFactoryAddress;
839 		_nameFactory = INameFactory(_nameFactoryAddress);
840 	}
841 
842 	/**
843 	 * @dev The AO sets NameTAOPosition address
844 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
845 	 */
846 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
847 		require (_nameTAOPositionAddress != address(0));
848 		nameTAOPositionAddress = _nameTAOPositionAddress;
849 		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
850 	}
851 
852 	/**
853 	 * @dev The AO set the NameAccountRecovery Address
854 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
855 	 */
856 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
857 		require (_nameAccountRecoveryAddress != address(0));
858 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
859 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
860 	}
861 
862 	/**
863 	 * @dev Whitelisted address add publicKey to list for a Name
864 	 * @param _id The ID of the Name
865 	 * @param _key The publicKey to be added
866 	 * @return true on success
867 	 */
868 	function whitelistAddKey(address _id, address _key) external isName(_id) keyNotTaken(_key) inWhitelist returns (bool) {
869 		require (_addKey(_id, _key));
870 		return true;
871 	}
872 
873 	/***** PUBLIC METHODS *****/
874 	/**
875 	 * @dev Check whether or not a Name ID exist in the list of Public Keys
876 	 * @param _id The ID to be checked
877 	 * @return true if yes, false otherwise
878 	 */
879 	function isExist(address _id) public view returns (bool) {
880 		return publicKeys[_id].created;
881 	}
882 
883 	/**
884 	 * @dev Store the PublicKey info for a Name
885 	 * @param _id The ID of the Name
886 	 * @param _defaultKey The default public key for this Name
887 	 * @param _writerKey The writer public key for this Name
888 	 * @return true on success
889 	 */
890 	function initialize(address _id, address _defaultKey, address _writerKey)
891 		external
892 		isName(_id)
893 		keyNotTaken(_defaultKey)
894 		keyNotTaken(_writerKey)
895 		onlyFactory returns (bool) {
896 		require (!isExist(_id));
897 
898 		keyToNameId[_defaultKey] = _id;
899 		if (_defaultKey != _writerKey) {
900 			keyToNameId[_writerKey] = _id;
901 		}
902 		PublicKey storage _publicKey = publicKeys[_id];
903 		_publicKey.created = true;
904 		_publicKey.defaultKey = _defaultKey;
905 		_publicKey.writerKey = _writerKey;
906 		_publicKey.keys.push(_defaultKey);
907 		if (_defaultKey != _writerKey) {
908 			_publicKey.keys.push(_writerKey);
909 		}
910 		return true;
911 	}
912 
913 	/**
914 	 * @dev Get total publicKeys count for a Name
915 	 * @param _id The ID of the Name
916 	 * @return total publicKeys count
917 	 */
918 	function getTotalPublicKeysCount(address _id) public isName(_id) view returns (uint256) {
919 		require (isExist(_id));
920 		return publicKeys[_id].keys.length;
921 	}
922 
923 	/**
924 	 * @dev Check whether or not a publicKey exist in the list for a Name
925 	 * @param _id The ID of the Name
926 	 * @param _key The publicKey to check
927 	 * @return true if yes. false otherwise
928 	 */
929 	function isKeyExist(address _id, address _key) isName(_id) external view returns (bool) {
930 		require (isExist(_id));
931 		require (_key != address(0));
932 		return keyToNameId[_key] == _id;
933 	}
934 
935 	/**
936 	 * @dev Add publicKey to list for a Name
937 	 * @param _id The ID of the Name
938 	 * @param _key The publicKey to be added
939 	 * @param _nonce The signed uint256 nonce (should be Name's current nonce + 1)
940 	 * @param _signatureV The V part of the signature
941 	 * @param _signatureR The R part of the signature
942 	 * @param _signatureS The S part of the signature
943 	 */
944 	function addKey(address _id,
945 		address _key,
946 		uint256 _nonce,
947 		uint8 _signatureV,
948 		bytes32 _signatureR,
949 		bytes32 _signatureS
950 	) public isName(_id) onlyAdvocate(_id) keyNotTaken(_key) senderNameNotCompromised {
951 		require (_nonce == _nameFactory.nonces(_id).add(1));
952 		bytes32 _hash = keccak256(abi.encodePacked(address(this), _id, _key, _nonce));
953 		require (ecrecover(_hash, _signatureV, _signatureR, _signatureS) == _key);
954 		require (_addKey(_id, _key));
955 	}
956 
957 	/**
958 	 * @dev Get default public key of a Name
959 	 * @param _id The ID of the Name
960 	 * @return the default public key
961 	 */
962 	function getDefaultKey(address _id) external isName(_id) view returns (address) {
963 		require (isExist(_id));
964 		return publicKeys[_id].defaultKey;
965 	}
966 
967 	/**
968 	 * @dev Get writer public key of a Name
969 	 * @param _id The ID of the Name
970 	 * @return the writer public key
971 	 */
972 	function getWriterKey(address _id) external isName(_id) view returns (address) {
973 		require (isExist(_id));
974 		return publicKeys[_id].writerKey;
975 	}
976 
977 	/**
978 	 * @dev Check whether or not a key is Name's writerKey
979 	 * @param _id The ID of the Name
980 	 * @param _key The key to be checked
981 	 * @return true if yes, false otherwise
982 	 */
983 	function isNameWriterKey(address _id, address _key) public isName(_id) view returns (bool) {
984 		require (isExist(_id));
985 		require (_key != address(0));
986 		return publicKeys[_id].writerKey == _key;
987 	}
988 
989 	/**
990 	 * @dev Get list of publicKeys of a Name
991 	 * @param _id The ID of the Name
992 	 * @param _from The starting index
993 	 * @param _to The ending index
994 	 * @return list of publicKeys
995 	 */
996 	function getKeys(address _id, uint256 _from, uint256 _to) public isName(_id) view returns (address[] memory) {
997 		require (isExist(_id));
998 		require (_from >= 0 && _to >= _from);
999 
1000 		PublicKey memory _publicKey = publicKeys[_id];
1001 		require (_publicKey.keys.length > 0);
1002 
1003 		if (_to >  _publicKey.keys.length.sub(1)) {
1004 			_to = _publicKey.keys.length.sub(1);
1005 		}
1006 		address[] memory _keys = new address[](_to.sub(_from).add(1));
1007 
1008 		for (uint256 i = _from; i <= _to; i++) {
1009 			_keys[i.sub(_from)] = _publicKey.keys[i];
1010 		}
1011 		return _keys;
1012 	}
1013 
1014 	/**
1015 	 * @dev Remove publicKey from the list
1016 	 * @param _id The ID of the Name
1017 	 * @param _key The publicKey to be removed
1018 	 */
1019 	function removeKey(address _id, address _key) public isName(_id) onlyAdvocate(_id) senderNameNotCompromised {
1020 		require (this.isKeyExist(_id, _key));
1021 
1022 		PublicKey storage _publicKey = publicKeys[_id];
1023 
1024 		// Can't remove default key
1025 		require (_key != _publicKey.defaultKey);
1026 		// Can't remove writer key
1027 		require (_key != _publicKey.writerKey);
1028 		// Has to have at least defaultKey/writerKey
1029 		require (_publicKey.keys.length > 1);
1030 
1031 		keyToNameId[_key] = address(0);
1032 
1033 		uint256 index;
1034 		for (uint256 i = 0; i < _publicKey.keys.length; i++) {
1035 			if (_publicKey.keys[i] == _key) {
1036 				index = i;
1037 				break;
1038 			}
1039 		}
1040 
1041 		for (uint256 i = index; i < _publicKey.keys.length.sub(1); i++) {
1042 			_publicKey.keys[i] = _publicKey.keys[i+1];
1043 		}
1044 		_publicKey.keys.length--;
1045 
1046 		uint256 _nonce = _nameFactory.incrementNonce(_id);
1047 		require (_nonce > 0);
1048 
1049 		emit RemoveKey(_id, _key, _nonce);
1050 	}
1051 
1052 	/**
1053 	 * @dev Set a publicKey as the default for a Name
1054 	 * @param _id The ID of the Name
1055 	 * @param _defaultKey The defaultKey to be set
1056 	 * @param _signatureV The V part of the signature for this update
1057 	 * @param _signatureR The R part of the signature for this update
1058 	 * @param _signatureS The S part of the signature for this update
1059 	 */
1060 	function setDefaultKey(address _id, address _defaultKey, uint8 _signatureV, bytes32 _signatureR, bytes32 _signatureS) public isName(_id) onlyAdvocate(_id) senderNameNotCompromised {
1061 		require (this.isKeyExist(_id, _defaultKey));
1062 
1063 		bytes32 _hash = keccak256(abi.encodePacked(address(this), _id, _defaultKey));
1064 		require (ecrecover(_hash, _signatureV, _signatureR, _signatureS) == msg.sender);
1065 
1066 		PublicKey storage _publicKey = publicKeys[_id];
1067 		_publicKey.defaultKey = _defaultKey;
1068 
1069 		uint256 _nonce = _nameFactory.incrementNonce(_id);
1070 		require (_nonce > 0);
1071 		emit SetDefaultKey(_id, _defaultKey, _nonce);
1072 	}
1073 
1074 	/**
1075 	 * @dev Set a publicKey as the writer for a Name
1076 	 * @param _id The ID of the Name
1077 	 * @param _writerKey The writerKey to be set
1078 	 * @param _signatureV The V part of the signature for this update
1079 	 * @param _signatureR The R part of the signature for this update
1080 	 * @param _signatureS The S part of the signature for this update
1081 	 */
1082 	function setWriterKey(address _id, address _writerKey, uint8 _signatureV, bytes32 _signatureR, bytes32 _signatureS) public isName(_id) onlyAdvocate(_id) senderNameNotCompromised {
1083 		bytes32 _hash = keccak256(abi.encodePacked(address(this), _id, _writerKey));
1084 		require (ecrecover(_hash, _signatureV, _signatureR, _signatureS) == msg.sender);
1085 		require (_setWriterKey(_id, _writerKey));
1086 	}
1087 
1088 	/**
1089 	 * @dev Add key and set as writerKey for a Name
1090 	 * @param _id The ID of the Name
1091 	 * @param _key The writerKey to be added
1092 	 * @param _nonce The signed uint256 nonce (should be Name's current nonce + 1)
1093 	 * @param _signatureV The V part of the signature
1094 	 * @param _signatureR The R part of the signature
1095 	 * @param _signatureS The S part of the signature
1096 	 */
1097 	function addSetWriterKey(address _id,
1098 		address _key,
1099 		uint256 _nonce,
1100 		uint8 _signatureV,
1101 		bytes32 _signatureR,
1102 		bytes32 _signatureS
1103 	) public isName(_id) onlyAdvocate(_id) keyNotTaken(_key) senderNameNotCompromised {
1104 		require (_nonce == _nameFactory.nonces(_id).add(1));
1105 		bytes32 _hash = keccak256(abi.encodePacked(address(this), _id, _key, _nonce));
1106 		require (ecrecover(_hash, _signatureV, _signatureR, _signatureS) == _key);
1107 		require (_addKey(_id, _key));
1108 		require (_setWriterKey(_id, _key));
1109 	}
1110 
1111 	/***** INTERNAL METHOD *****/
1112 	/**
1113 	 * @dev Actual adding the publicKey to list for a Name
1114 	 * @param _id The ID of the Name
1115 	 * @param _key The publicKey to be added
1116 	 * @return true on success
1117 	 */
1118 	function _addKey(address _id, address _key) internal returns (bool) {
1119 		require (!this.isKeyExist(_id, _key));
1120 
1121 		keyToNameId[_key] = _id;
1122 
1123 		PublicKey storage _publicKey = publicKeys[_id];
1124 		_publicKey.keys.push(_key);
1125 
1126 		uint256 _nonce = _nameFactory.incrementNonce(_id);
1127 		require (_nonce > 0);
1128 
1129 		emit AddKey(_id, _key, _nonce);
1130 		return true;
1131 	}
1132 
1133 	/**
1134 	 * @dev Actual setting the writerKey for a Name
1135 	 * @param _id The ID of the Name
1136 	 * @param _writerKey The writerKey to be set
1137 	 * @return true on success
1138 	 */
1139 	function _setWriterKey(address _id, address _writerKey) internal returns (bool) {
1140 		require (this.isKeyExist(_id, _writerKey));
1141 
1142 		PublicKey storage _publicKey = publicKeys[_id];
1143 		_publicKey.writerKey = _writerKey;
1144 
1145 		uint256 _nonce = _nameFactory.incrementNonce(_id);
1146 		require (_nonce > 0);
1147 		emit SetWriterKey(_id, _writerKey, _nonce);
1148 		return true;
1149 	}
1150 }