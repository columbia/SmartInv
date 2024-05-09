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
57 interface INameAccountRecovery {
58 	function isCompromised(address _id) external view returns (bool);
59 }
60 
61 
62 interface INameTAOPosition {
63 	function senderIsAdvocate(address _sender, address _id) external view returns (bool);
64 	function senderIsListener(address _sender, address _id) external view returns (bool);
65 	function senderIsSpeaker(address _sender, address _id) external view returns (bool);
66 	function senderIsPosition(address _sender, address _id) external view returns (bool);
67 	function getAdvocate(address _id) external view returns (address);
68 	function nameIsAdvocate(address _nameId, address _id) external view returns (bool);
69 	function nameIsPosition(address _nameId, address _id) external view returns (bool);
70 	function initialize(address _id, address _advocateId, address _listenerId, address _speakerId) external returns (bool);
71 	function determinePosition(address _sender, address _id) external view returns (uint256);
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
84 interface ITAOFactory {
85 	function nonces(address _taoId) external view returns (uint256);
86 	function incrementNonce(address _taoId) external returns (uint256);
87 }
88 
89 
90 interface ITAOAncestry {
91 	function initialize(address _id, address _parentId, uint256 _childMinLogos) external returns (bool);
92 
93 	function getAncestryById(address _id) external view returns (address, uint256, uint256);
94 
95 	function addChild(address _taoId, address _childId) external returns (bool);
96 
97 	function isChild(address _taoId, address _childId) external view returns (bool);
98 }
99 
100 
101 
102 
103 
104 
105 
106 
107 
108 
109 
110 
111 
112 contract TokenERC20 {
113 	// Public variables of the token
114 	string public name;
115 	string public symbol;
116 	uint8 public decimals = 18;
117 	// 18 decimals is the strongly suggested default, avoid changing it
118 	uint256 public totalSupply;
119 
120 	// This creates an array with all balances
121 	mapping (address => uint256) public balanceOf;
122 	mapping (address => mapping (address => uint256)) public allowance;
123 
124 	// This generates a public event on the blockchain that will notify clients
125 	event Transfer(address indexed from, address indexed to, uint256 value);
126 
127 	// This generates a public event on the blockchain that will notify clients
128 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
129 
130 	// This notifies clients about the amount burnt
131 	event Burn(address indexed from, uint256 value);
132 
133 	/**
134 	 * Constructor function
135 	 *
136 	 * Initializes contract with initial supply tokens to the creator of the contract
137 	 */
138 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
139 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
140 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
141 		name = tokenName;                                   // Set the name for display purposes
142 		symbol = tokenSymbol;                               // Set the symbol for display purposes
143 	}
144 
145 	/**
146 	 * Internal transfer, only can be called by this contract
147 	 */
148 	function _transfer(address _from, address _to, uint _value) internal {
149 		// Prevent transfer to 0x0 address. Use burn() instead
150 		require(_to != address(0));
151 		// Check if the sender has enough
152 		require(balanceOf[_from] >= _value);
153 		// Check for overflows
154 		require(balanceOf[_to] + _value > balanceOf[_to]);
155 		// Save this for an assertion in the future
156 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
157 		// Subtract from the sender
158 		balanceOf[_from] -= _value;
159 		// Add the same to the recipient
160 		balanceOf[_to] += _value;
161 		emit Transfer(_from, _to, _value);
162 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
163 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
164 	}
165 
166 	/**
167 	 * Transfer tokens
168 	 *
169 	 * Send `_value` tokens to `_to` from your account
170 	 *
171 	 * @param _to The address of the recipient
172 	 * @param _value the amount to send
173 	 */
174 	function transfer(address _to, uint256 _value) public returns (bool success) {
175 		_transfer(msg.sender, _to, _value);
176 		return true;
177 	}
178 
179 	/**
180 	 * Transfer tokens from other address
181 	 *
182 	 * Send `_value` tokens to `_to` in behalf of `_from`
183 	 *
184 	 * @param _from The address of the sender
185 	 * @param _to The address of the recipient
186 	 * @param _value the amount to send
187 	 */
188 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
189 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
190 		allowance[_from][msg.sender] -= _value;
191 		_transfer(_from, _to, _value);
192 		return true;
193 	}
194 
195 	/**
196 	 * Set allowance for other address
197 	 *
198 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
199 	 *
200 	 * @param _spender The address authorized to spend
201 	 * @param _value the max amount they can spend
202 	 */
203 	function approve(address _spender, uint256 _value) public returns (bool success) {
204 		allowance[msg.sender][_spender] = _value;
205 		emit Approval(msg.sender, _spender, _value);
206 		return true;
207 	}
208 
209 	/**
210 	 * Set allowance for other address and notify
211 	 *
212 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
213 	 *
214 	 * @param _spender The address authorized to spend
215 	 * @param _value the max amount they can spend
216 	 * @param _extraData some extra information to send to the approved contract
217 	 */
218 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
219 		tokenRecipient spender = tokenRecipient(_spender);
220 		if (approve(_spender, _value)) {
221 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
222 			return true;
223 		}
224 	}
225 
226 	/**
227 	 * Destroy tokens
228 	 *
229 	 * Remove `_value` tokens from the system irreversibly
230 	 *
231 	 * @param _value the amount of money to burn
232 	 */
233 	function burn(uint256 _value) public returns (bool success) {
234 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
235 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
236 		totalSupply -= _value;                      // Updates totalSupply
237 		emit Burn(msg.sender, _value);
238 		return true;
239 	}
240 
241 	/**
242 	 * Destroy tokens from other account
243 	 *
244 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
245 	 *
246 	 * @param _from the address of the sender
247 	 * @param _value the amount of money to burn
248 	 */
249 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
250 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
251 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
252 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
253 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
254 		totalSupply -= _value;                              // Update totalSupply
255 		emit Burn(_from, _value);
256 		return true;
257 	}
258 }
259 
260 
261 /**
262  * @title TAO
263  */
264 contract TAO {
265 	using SafeMath for uint256;
266 
267 	address public vaultAddress;
268 	string public name;				// the name for this TAO
269 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
270 
271 	// TAO's data
272 	string public datHash;
273 	string public database;
274 	string public keyValue;
275 	bytes32 public contentId;
276 
277 	/**
278 	 * 0 = TAO
279 	 * 1 = Name
280 	 */
281 	uint8 public typeId;
282 
283 	/**
284 	 * @dev Constructor function
285 	 */
286 	constructor (string memory _name,
287 		address _originId,
288 		string memory _datHash,
289 		string memory _database,
290 		string memory _keyValue,
291 		bytes32 _contentId,
292 		address _vaultAddress
293 	) public {
294 		name = _name;
295 		originId = _originId;
296 		datHash = _datHash;
297 		database = _database;
298 		keyValue = _keyValue;
299 		contentId = _contentId;
300 
301 		// Creating TAO
302 		typeId = 0;
303 
304 		vaultAddress = _vaultAddress;
305 	}
306 
307 	/**
308 	 * @dev Checks if calling address is Vault contract
309 	 */
310 	modifier onlyVault {
311 		require (msg.sender == vaultAddress);
312 		_;
313 	}
314 
315 	/**
316 	 * Will receive any ETH sent
317 	 */
318 	function () external payable {
319 	}
320 
321 	/**
322 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
323 	 * @param _recipient The recipient address
324 	 * @param _amount The amount to transfer
325 	 * @return true on success
326 	 */
327 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
328 		_recipient.transfer(_amount);
329 		return true;
330 	}
331 
332 	/**
333 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
334 	 * @param _erc20TokenAddress The address of ERC20 Token
335 	 * @param _recipient The recipient address
336 	 * @param _amount The amount to transfer
337 	 * @return true on success
338 	 */
339 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
340 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
341 		_erc20.transfer(_recipient, _amount);
342 		return true;
343 	}
344 }
345 
346 
347 
348 
349 /**
350  * @title Name
351  */
352 contract Name is TAO {
353 	/**
354 	 * @dev Constructor function
355 	 */
356 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
357 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
358 		// Creating Name
359 		typeId = 1;
360 	}
361 }
362 
363 
364 
365 
366 /**
367  * @title AOLibrary
368  */
369 library AOLibrary {
370 	using SafeMath for uint256;
371 
372 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
373 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
374 
375 	/**
376 	 * @dev Check whether or not the given TAO ID is a TAO
377 	 * @param _taoId The ID of the TAO
378 	 * @return true if yes. false otherwise
379 	 */
380 	function isTAO(address _taoId) public view returns (bool) {
381 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
382 	}
383 
384 	/**
385 	 * @dev Check whether or not the given Name ID is a Name
386 	 * @param _nameId The ID of the Name
387 	 * @return true if yes. false otherwise
388 	 */
389 	function isName(address _nameId) public view returns (bool) {
390 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
391 	}
392 
393 	/**
394 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
395 	 * @param _tokenAddress The ERC20 Token address to check
396 	 */
397 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
398 		if (_tokenAddress == address(0)) {
399 			return false;
400 		}
401 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
402 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
403 	}
404 
405 	/**
406 	 * @dev Checks if the calling contract address is The AO
407 	 *		OR
408 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
409 	 * @param _sender The address to check
410 	 * @param _theAO The AO address
411 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
412 	 * @return true if yes, false otherwise
413 	 */
414 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
415 		return (_sender == _theAO ||
416 			(
417 				(isTAO(_theAO) || isName(_theAO)) &&
418 				_nameTAOPositionAddress != address(0) &&
419 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
420 			)
421 		);
422 	}
423 
424 	/**
425 	 * @dev Return the divisor used to correctly calculate percentage.
426 	 *		Percentage stored throughout AO contracts covers 4 decimals,
427 	 *		so 1% is 10000, 1.25% is 12500, etc
428 	 */
429 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
430 		return _PERCENTAGE_DIVISOR;
431 	}
432 
433 	/**
434 	 * @dev Return the divisor used to correctly calculate multiplier.
435 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
436 	 *		so 1 is 1000000, 0.023 is 23000, etc
437 	 */
438 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
439 		return _MULTIPLIER_DIVISOR;
440 	}
441 
442 	/**
443 	 * @dev deploy a TAO
444 	 * @param _name The name of the TAO
445 	 * @param _originId The Name ID the creates the TAO
446 	 * @param _datHash The datHash of this TAO
447 	 * @param _database The database for this TAO
448 	 * @param _keyValue The key/value pair to be checked on the database
449 	 * @param _contentId The contentId related to this TAO
450 	 * @param _nameTAOVaultAddress The address of NameTAOVault
451 	 */
452 	function deployTAO(string memory _name,
453 		address _originId,
454 		string memory _datHash,
455 		string memory _database,
456 		string memory _keyValue,
457 		bytes32 _contentId,
458 		address _nameTAOVaultAddress
459 		) public returns (TAO _tao) {
460 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
461 	}
462 
463 	/**
464 	 * @dev deploy a Name
465 	 * @param _name The name of the Name
466 	 * @param _originId The eth address the creates the Name
467 	 * @param _datHash The datHash of this Name
468 	 * @param _database The database for this Name
469 	 * @param _keyValue The key/value pair to be checked on the database
470 	 * @param _contentId The contentId related to this Name
471 	 * @param _nameTAOVaultAddress The address of NameTAOVault
472 	 */
473 	function deployName(string memory _name,
474 		address _originId,
475 		string memory _datHash,
476 		string memory _database,
477 		string memory _keyValue,
478 		bytes32 _contentId,
479 		address _nameTAOVaultAddress
480 		) public returns (Name _myName) {
481 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
482 	}
483 
484 	/**
485 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
486 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
487 	 * @param _currentPrimordialBalance Account's current primordial ion balance
488 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
489 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
490 	 * @return the new primordial weighted multiplier
491 	 */
492 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
493 		if (_currentWeightedMultiplier > 0) {
494 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
495 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
496 			return _totalWeightedIons.div(_totalIons);
497 		} else {
498 			return _additionalWeightedMultiplier;
499 		}
500 	}
501 
502 	/**
503 	 * @dev Calculate the primordial ion multiplier on a given lot
504 	 *		Total Primordial Mintable = T
505 	 *		Total Primordial Minted = M
506 	 *		Starting Multiplier = S
507 	 *		Ending Multiplier = E
508 	 *		To Purchase = P
509 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
510 	 *
511 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
512 	 * @param _totalPrimordialMintable Total Primordial ion mintable
513 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
514 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
515 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
516 	 * @return The multiplier in (10 ** 6)
517 	 */
518 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
519 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
520 			/**
521 			 * Let temp = M + (P/2)
522 			 * Multiplier = (1 - (temp / T)) x (S-E)
523 			 */
524 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
525 
526 			/**
527 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
528 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
529 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
530 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
531 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
532 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
533 			 */
534 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
535 			/**
536 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
537 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
538 			 */
539 			return multiplier.div(_MULTIPLIER_DIVISOR);
540 		} else {
541 			return 0;
542 		}
543 	}
544 
545 	/**
546 	 * @dev Calculate the bonus percentage of network ion on a given lot
547 	 *		Total Primordial Mintable = T
548 	 *		Total Primordial Minted = M
549 	 *		Starting Network Bonus Multiplier = Bs
550 	 *		Ending Network Bonus Multiplier = Be
551 	 *		To Purchase = P
552 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
553 	 *
554 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
555 	 * @param _totalPrimordialMintable Total Primordial ion intable
556 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
557 	 * @param _startingMultiplier The starting Network ion bonus multiplier
558 	 * @param _endingMultiplier The ending Network ion bonus multiplier
559 	 * @return The bonus percentage
560 	 */
561 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
562 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
563 			/**
564 			 * Let temp = M + (P/2)
565 			 * B% = (1 - (temp / T)) x (Bs-Be)
566 			 */
567 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
568 
569 			/**
570 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
571 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
572 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
573 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
574 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
575 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
576 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
577 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
578 			 */
579 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
580 			return bonusPercentage;
581 		} else {
582 			return 0;
583 		}
584 	}
585 
586 	/**
587 	 * @dev Calculate the bonus amount of network ion on a given lot
588 	 *		AO Bonus Amount = B% x P
589 	 *
590 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
591 	 * @param _totalPrimordialMintable Total Primordial ion intable
592 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
593 	 * @param _startingMultiplier The starting Network ion bonus multiplier
594 	 * @param _endingMultiplier The ending Network ion bonus multiplier
595 	 * @return The bonus percentage
596 	 */
597 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
598 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
599 		/**
600 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
601 		 * when calculating the network ion bonus amount
602 		 */
603 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
604 		return networkBonus;
605 	}
606 
607 	/**
608 	 * @dev Calculate the maximum amount of Primordial an account can burn
609 	 *		_primordialBalance = P
610 	 *		_currentWeightedMultiplier = M
611 	 *		_maximumMultiplier = S
612 	 *		_amountToBurn = B
613 	 *		B = ((S x P) - (P x M)) / S
614 	 *
615 	 * @param _primordialBalance Account's primordial ion balance
616 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
617 	 * @param _maximumMultiplier The maximum multiplier of this account
618 	 * @return The maximum burn amount
619 	 */
620 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
621 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
622 	}
623 
624 	/**
625 	 * @dev Calculate the new multiplier after burning primordial ion
626 	 *		_primordialBalance = P
627 	 *		_currentWeightedMultiplier = M
628 	 *		_amountToBurn = B
629 	 *		_newMultiplier = E
630 	 *		E = (P x M) / (P - B)
631 	 *
632 	 * @param _primordialBalance Account's primordial ion balance
633 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
634 	 * @param _amountToBurn The amount of primordial ion to burn
635 	 * @return The new multiplier
636 	 */
637 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
638 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
639 	}
640 
641 	/**
642 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
643 	 *		_primordialBalance = P
644 	 *		_currentWeightedMultiplier = M
645 	 *		_amountToConvert = C
646 	 *		_newMultiplier = E
647 	 *		E = (P x M) / (P + C)
648 	 *
649 	 * @param _primordialBalance Account's primordial ion balance
650 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
651 	 * @param _amountToConvert The amount of network ion to convert
652 	 * @return The new multiplier
653 	 */
654 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
655 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
656 	}
657 
658 	/**
659 	 * @dev count num of digits
660 	 * @param number uint256 of the nuumber to be checked
661 	 * @return uint8 num of digits
662 	 */
663 	function numDigits(uint256 number) public pure returns (uint8) {
664 		uint8 digits = 0;
665 		while(number != 0) {
666 			number = number.div(10);
667 			digits++;
668 		}
669 		return digits;
670 	}
671 }
672 
673 
674 
675 
676 
677 contract TheAO {
678 	address public theAO;
679 	address public nameTAOPositionAddress;
680 
681 	// Check whether an address is whitelisted and granted access to transact
682 	// on behalf of others
683 	mapping (address => bool) public whitelist;
684 
685 	constructor() public {
686 		theAO = msg.sender;
687 	}
688 
689 	/**
690 	 * @dev Checks if msg.sender is in whitelist.
691 	 */
692 	modifier inWhitelist() {
693 		require (whitelist[msg.sender] == true);
694 		_;
695 	}
696 
697 	/**
698 	 * @dev Transfer ownership of The AO to new address
699 	 * @param _theAO The new address to be transferred
700 	 */
701 	function transferOwnership(address _theAO) public {
702 		require (msg.sender == theAO);
703 		require (_theAO != address(0));
704 		theAO = _theAO;
705 	}
706 
707 	/**
708 	 * @dev Whitelist `_account` address to transact on behalf of others
709 	 * @param _account The address to whitelist
710 	 * @param _whitelist Either to whitelist or not
711 	 */
712 	function setWhitelist(address _account, bool _whitelist) public {
713 		require (msg.sender == theAO);
714 		require (_account != address(0));
715 		whitelist[_account] = _whitelist;
716 	}
717 }
718 
719 
720 
721 
722 
723 
724 /**
725  * @title TAOController
726  */
727 contract TAOController is TheAO {
728 	address public nameFactoryAddress;
729 	address public nameAccountRecoveryAddress;
730 
731 	INameFactory internal _nameFactory;
732 	INameTAOPosition internal _nameTAOPosition;
733 	INameAccountRecovery internal _nameAccountRecovery;
734 
735 	/**
736 	 * @dev Constructor function
737 	 */
738 	constructor(address _nameFactoryAddress) public {
739 		setNameFactoryAddress(_nameFactoryAddress);
740 	}
741 
742 	/**
743 	 * @dev Checks if the calling contract address is The AO
744 	 *		OR
745 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
746 	 */
747 	modifier onlyTheAO {
748 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
749 		_;
750 	}
751 
752 	/**
753 	 * @dev Check if `_taoId` is a TAO
754 	 */
755 	modifier isTAO(address _taoId) {
756 		require (AOLibrary.isTAO(_taoId));
757 		_;
758 	}
759 
760 	/**
761 	 * @dev Check if `_nameId` is a Name
762 	 */
763 	modifier isName(address _nameId) {
764 		require (AOLibrary.isName(_nameId));
765 		_;
766 	}
767 
768 	/**
769 	 * @dev Check if `_id` is a Name or a TAO
770 	 */
771 	modifier isNameOrTAO(address _id) {
772 		require (AOLibrary.isName(_id) || AOLibrary.isTAO(_id));
773 		_;
774 	}
775 
776 	/**
777 	 * @dev Check is msg.sender address is a Name
778 	 */
779 	 modifier senderIsName() {
780 		require (_nameFactory.ethAddressToNameId(msg.sender) != address(0));
781 		_;
782 	 }
783 
784 	/**
785 	 * @dev Check if msg.sender is the current advocate of TAO ID
786 	 */
787 	modifier onlyAdvocate(address _id) {
788 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _id));
789 		_;
790 	}
791 
792 	/**
793 	 * @dev Only allowed if sender's Name is not compromised
794 	 */
795 	modifier senderNameNotCompromised() {
796 		require (!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
797 		_;
798 	}
799 
800 	/***** The AO ONLY METHODS *****/
801 	/**
802 	 * @dev Transfer ownership of The AO to new address
803 	 * @param _theAO The new address to be transferred
804 	 */
805 	function transferOwnership(address _theAO) public onlyTheAO {
806 		require (_theAO != address(0));
807 		theAO = _theAO;
808 	}
809 
810 	/**
811 	 * @dev Whitelist `_account` address to transact on behalf of others
812 	 * @param _account The address to whitelist
813 	 * @param _whitelist Either to whitelist or not
814 	 */
815 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
816 		require (_account != address(0));
817 		whitelist[_account] = _whitelist;
818 	}
819 
820 	/**
821 	 * @dev The AO sets NameFactory address
822 	 * @param _nameFactoryAddress The address of NameFactory
823 	 */
824 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
825 		require (_nameFactoryAddress != address(0));
826 		nameFactoryAddress = _nameFactoryAddress;
827 		_nameFactory = INameFactory(_nameFactoryAddress);
828 	}
829 
830 	/**
831 	 * @dev The AO sets NameTAOPosition address
832 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
833 	 */
834 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
835 		require (_nameTAOPositionAddress != address(0));
836 		nameTAOPositionAddress = _nameTAOPositionAddress;
837 		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
838 	}
839 
840 	/**
841 	 * @dev The AO set the NameAccountRecovery Address
842 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
843 	 */
844 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
845 		require (_nameAccountRecoveryAddress != address(0));
846 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
847 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
848 	}
849 }
850 
851 
852 
853 
854 /**
855  * @title TAOAncestry
856  */
857 contract TAOAncestry is TAOController, ITAOAncestry {
858 	using SafeMath for uint256;
859 
860 	address public taoFactoryAddress;
861 
862 	ITAOFactory internal _taoFactory;
863 
864 	struct Child {
865 		address taoId;
866 		bool approved;		// If false, then waiting for parent TAO approval
867 		bool connected;		// If false, then parent TAO want to remove this child TAO
868 	}
869 
870 	struct Ancestry {
871 		address taoId;
872 		address parentId;	// The parent of this TAO ID (could be a Name or TAO)
873 		uint256 childMinLogos;
874 		mapping (uint256 => Child) children;
875 		mapping (address => uint256) childInternalIdLookup;
876 		uint256 totalChildren;
877 		uint256 childInternalId;
878 	}
879 
880 	mapping (address => Ancestry) internal ancestries;
881 
882 	// Event to be broadcasted to public when Advocate updates min required Logos to create a child TAO
883 	event UpdateChildMinLogos(address indexed taoId, uint256 childMinLogos, uint256 nonce);
884 
885 	// Event to be broadcasted to public when a TAO adds a child TAO
886 	event AddChild(address indexed taoId, address taoAdvocate, address childId, address childAdvocate, bool approved, bool connected);
887 
888 	// Event to be broadcasted to public when a TAO approves a child TAO
889 	event ApproveChild(address indexed taoId, address taoAdvocate, address childId, address childAdvocate, uint256 nonce);
890 
891 	// Event to be broadcasted to public when a TAO removes a child TAO
892 	event RemoveChild(address indexed taoId, address taoAdvocate, address childId, address childAdvocate, uint256 nonce);
893 
894 	/**
895 	 * @dev Constructor function
896 	 */
897 	constructor(address _nameFactoryAddress, address _taoFactoryAddress, address _nameTAOPositionAddress)
898 		TAOController(_nameFactoryAddress) public {
899 		setTAOFactoryAddress(_taoFactoryAddress);
900 		setNameTAOPositionAddress(_nameTAOPositionAddress);
901 	}
902 
903 	/**
904 	 * @dev Check if calling address is Factory
905 	 */
906 	modifier onlyFactory {
907 		require (msg.sender == taoFactoryAddress);
908 		_;
909 	}
910 
911 	/***** The AO ONLY METHODS *****/
912 	/**
913 	 * @dev The AO set the TAOFactory Address
914 	 * @param _taoFactoryAddress The address of TAOFactory
915 	 */
916 	function setTAOFactoryAddress(address _taoFactoryAddress) public onlyTheAO {
917 		require (_taoFactoryAddress != address(0));
918 		taoFactoryAddress = _taoFactoryAddress;
919 		_taoFactory = ITAOFactory(_taoFactoryAddress);
920 	}
921 
922 	/***** PUBLIC METHODS *****/
923 	/**
924 	 * @dev Check whether or not a TAO ID exist in the list of ancestries
925 	 * @param _id The ID to be checked
926 	 * @return true if yes, false otherwise
927 	 */
928 	function isExist(address _id) public view returns (bool) {
929 		return ancestries[_id].taoId != address(0);
930 	}
931 
932 	/**
933 	 * @dev Store the Ancestry info for a TAO
934 	 * @param _id The ID of the TAO
935 	 * @param _parentId The parent ID of this TAO
936 	 * @param _childMinLogos The min required Logos to create a TAO
937 	 * @return true on success
938 	 */
939 	function initialize(address _id, address _parentId, uint256 _childMinLogos)
940 		external
941 		isTAO(_id)
942 		isNameOrTAO(_parentId)
943 		onlyFactory returns (bool) {
944 		require (!isExist(_id));
945 
946 		Ancestry storage _ancestry = ancestries[_id];
947 		_ancestry.taoId = _id;
948 		_ancestry.parentId = _parentId;
949 		_ancestry.childMinLogos = _childMinLogos;
950 		return true;
951 	}
952 
953 	/**
954 	 * @dev Get Ancestry info given a TAO ID
955 	 * @param _id The ID of the TAO
956 	 * @return the parent ID of this TAO (could be a Name/TAO)
957 	 * @return the min required Logos to create a child TAO
958 	 * @return the total child TAOs count
959 	 */
960 	function getAncestryById(address _id) external view returns (address, uint256, uint256) {
961 		require (isExist(_id));
962 		Ancestry memory _ancestry = ancestries[_id];
963 		return (
964 			_ancestry.parentId,
965 			_ancestry.childMinLogos,
966 			_ancestry.totalChildren
967 		);
968 	}
969 
970 	/**
971 	 * @dev Set min required Logos to create a child from this TAO
972 	 * @param _childMinLogos The min Logos to set
973 	 * @return the nonce for this transaction
974 	 */
975 	function updateChildMinLogos(address _id, uint256 _childMinLogos)
976 		public
977 		isTAO(_id)
978 		senderIsName
979 		senderNameNotCompromised
980 		onlyAdvocate(_id) {
981 		require (isExist(_id));
982 
983 		Ancestry storage _ancestry = ancestries[_id];
984 		_ancestry.childMinLogos = _childMinLogos;
985 
986 		uint256 _nonce = _taoFactory.incrementNonce(_id);
987 		require (_nonce > 0);
988 		emit UpdateChildMinLogos(_id, _ancestry.childMinLogos, _nonce);
989 	}
990 
991 	/**
992 	 * @dev Check if `_childId` is a child TAO of `_taoId`
993 	 * @param _taoId The TAO ID to be checked
994 	 * @param _childId The child TAO ID to check
995 	 * @return true if yes. Otherwise return false.
996 	 */
997 	function isChild(address _taoId, address _childId) external view returns (bool) {
998 		require (isExist(_taoId) && isExist(_childId));
999 		Ancestry storage _ancestry = ancestries[_taoId];
1000 		Ancestry memory _childAncestry = ancestries[_childId];
1001 		uint256 _childInternalId = _ancestry.childInternalIdLookup[_childId];
1002 		return (
1003 			_childInternalId > 0 &&
1004 			_ancestry.children[_childInternalId].approved &&
1005 			_ancestry.children[_childInternalId].connected &&
1006 			_childAncestry.parentId == _taoId
1007 		);
1008 	}
1009 
1010 	/**
1011 	 * @dev Check if `_childId` is a child TAO of `_taoId` that is not yet approved
1012 	 * @param _taoId The TAO ID to be checked
1013 	 * @param _childId The child TAO ID to check
1014 	 * @return true if yes. Otherwise return false.
1015 	 */
1016 	function isNotApprovedChild(address _taoId, address _childId) public view returns (bool) {
1017 		require (isExist(_taoId) && isExist(_childId));
1018 		Ancestry storage _ancestry = ancestries[_taoId];
1019 		uint256 _childInternalId = _ancestry.childInternalIdLookup[_childId];
1020 		return (
1021 			_childInternalId > 0 &&
1022 			!_ancestry.children[_childInternalId].approved &&
1023 			!_ancestry.children[_childInternalId].connected
1024 		);
1025 	}
1026 
1027 	/**
1028 	 * @dev Add child TAO
1029 	 * @param _taoId The TAO ID to be added to
1030 	 * @param _childId The ID to be added to as child TAO
1031 	 */
1032 	function addChild(address _taoId, address _childId)
1033 		external
1034 		isTAO(_taoId)
1035 		isTAO(_childId)
1036 		onlyFactory returns (bool) {
1037 		require (!this.isChild(_taoId, _childId));
1038 		Ancestry storage _ancestry = ancestries[_taoId];
1039 		require (_ancestry.childInternalIdLookup[_childId] == 0);
1040 
1041 		_ancestry.childInternalId++;
1042 		_ancestry.childInternalIdLookup[_childId] = _ancestry.childInternalId;
1043 
1044 		Child storage _child = _ancestry.children[_ancestry.childInternalId];
1045 		_child.taoId = _childId;
1046 
1047 		// If _taoId's Advocate == _childId's Advocate, then the child is automatically approved and connected
1048 		// Otherwise, child TAO needs parent TAO approval
1049 		address _taoAdvocate = _nameTAOPosition.getAdvocate(_taoId);
1050 		address _childAdvocate = _nameTAOPosition.getAdvocate(_childId);
1051 		emit AddChild(_taoId, _taoAdvocate, _childId, _childAdvocate, _child.approved, _child.connected);
1052 
1053 		if (_taoAdvocate == _childAdvocate) {
1054 			_approveChild(_taoId, _childId);
1055 		}
1056 		return true;
1057 	}
1058 
1059 	/**
1060 	 * @dev Advocate of `_taoId` approves child `_childId`
1061 	 * @param _taoId The TAO ID to be checked
1062 	 * @param _childId The child TAO ID to be approved
1063 	 */
1064 	function approveChild(address _taoId, address _childId)
1065 		public
1066 		isTAO(_taoId)
1067 		isTAO(_childId)
1068 		senderIsName
1069 		senderNameNotCompromised
1070 		onlyAdvocate(_taoId) {
1071 		require (isExist(_taoId) && isExist(_childId));
1072 		require (isNotApprovedChild(_taoId, _childId));
1073 		_approveChild(_taoId, _childId);
1074 	}
1075 
1076 	/**
1077 	 * @dev Advocate of `_taoId` removes child `_childId`
1078 	 * @param _taoId The TAO ID to be checked
1079 	 * @param _childId The child TAO ID to be removed
1080 	 */
1081 	function removeChild(address _taoId, address _childId)
1082 		public
1083 		isTAO(_taoId)
1084 		isTAO(_childId)
1085 		senderIsName
1086 		senderNameNotCompromised
1087 		onlyAdvocate(_taoId) {
1088 		require (this.isChild(_taoId, _childId));
1089 
1090 		Ancestry storage _ancestry = ancestries[_taoId];
1091 		_ancestry.totalChildren--;
1092 
1093 		Child storage _child = _ancestry.children[_ancestry.childInternalIdLookup[_childId]];
1094 		_child.connected = false;
1095 		_ancestry.childInternalIdLookup[_childId] = 0;
1096 
1097 		Ancestry storage _childAncestry = ancestries[_childId];
1098 		_childAncestry.parentId = address(0);
1099 
1100 		uint256 _nonce = _taoFactory.incrementNonce(_taoId);
1101 		require (_nonce > 0);
1102 
1103 		address _taoAdvocate = _nameTAOPosition.getAdvocate(_taoId);
1104 		address _childAdvocate = _nameTAOPosition.getAdvocate(_childId);
1105 		emit RemoveChild(_taoId, _taoAdvocate, _childId, _childAdvocate, _nonce);
1106 	}
1107 
1108 	/**
1109 	 * @dev Get list of child TAO IDs
1110 	 * @param _taoId The TAO ID to be checked
1111 	 * @param _from The starting index (start from 1)
1112 	 * @param _to The ending index, (max is childInternalId)
1113 	 * @return list of child TAO IDs
1114 	 */
1115 	function getChildIds(address _taoId, uint256 _from, uint256 _to) public view returns (address[] memory) {
1116 		require (isExist(_taoId));
1117 		Ancestry storage _ancestry = ancestries[_taoId];
1118 		require (_from >= 1 && _to >= _from && _ancestry.childInternalId >= _to);
1119 		address[] memory _childIds = new address[](_to.sub(_from).add(1));
1120 		for (uint256 i = _from; i <= _to; i++) {
1121 			_childIds[i.sub(_from)] = _ancestry.children[i].approved && _ancestry.children[i].connected ? _ancestry.children[i].taoId : address(0);
1122 		}
1123 		return _childIds;
1124 	}
1125 
1126 	/***** INTERNAL METHOD *****/
1127 	/**
1128 	 * @dev Actually approving the child TAO
1129 	 * @param _taoId The TAO ID to be checked
1130 	 * @param _childId The child TAO ID to be approved
1131 	 */
1132 	function _approveChild(address _taoId, address _childId) internal {
1133 		Ancestry storage _ancestry = ancestries[_taoId];
1134 		Ancestry storage _childAncestry = ancestries[_childId];
1135 		uint256 _childInternalId = _ancestry.childInternalIdLookup[_childId];
1136 
1137 		_ancestry.totalChildren++;
1138 
1139 		Child storage _child = _ancestry.children[_childInternalId];
1140 		_child.approved = true;
1141 		_child.connected = true;
1142 
1143 		_childAncestry.parentId = _taoId;
1144 
1145 		uint256 _nonce = _taoFactory.incrementNonce(_taoId);
1146 		require (_nonce > 0);
1147 
1148 		address _taoAdvocate = _nameTAOPosition.getAdvocate(_taoId);
1149 		address _childAdvocate = _nameTAOPosition.getAdvocate(_childId);
1150 		emit ApproveChild(_taoId, _taoAdvocate, _childId, _childAdvocate, _nonce);
1151 	}
1152 }