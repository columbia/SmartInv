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
75 interface INamePublicKey {
76 	function initialize(address _id, address _defaultKey, address _writerKey) external returns (bool);
77 
78 	function isKeyExist(address _id, address _key) external view returns (bool);
79 
80 	function getDefaultKey(address _id) external view returns (address);
81 
82 	function whitelistAddKey(address _id, address _key) external returns (bool);
83 }
84 
85 
86 
87 
88 
89 
90 
91 
92 
93 
94 
95 
96 
97 
98 
99 contract TokenERC20 {
100 	// Public variables of the token
101 	string public name;
102 	string public symbol;
103 	uint8 public decimals = 18;
104 	// 18 decimals is the strongly suggested default, avoid changing it
105 	uint256 public totalSupply;
106 
107 	// This creates an array with all balances
108 	mapping (address => uint256) public balanceOf;
109 	mapping (address => mapping (address => uint256)) public allowance;
110 
111 	// This generates a public event on the blockchain that will notify clients
112 	event Transfer(address indexed from, address indexed to, uint256 value);
113 
114 	// This generates a public event on the blockchain that will notify clients
115 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
116 
117 	// This notifies clients about the amount burnt
118 	event Burn(address indexed from, uint256 value);
119 
120 	/**
121 	 * Constructor function
122 	 *
123 	 * Initializes contract with initial supply tokens to the creator of the contract
124 	 */
125 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
126 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
127 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
128 		name = tokenName;                                   // Set the name for display purposes
129 		symbol = tokenSymbol;                               // Set the symbol for display purposes
130 	}
131 
132 	/**
133 	 * Internal transfer, only can be called by this contract
134 	 */
135 	function _transfer(address _from, address _to, uint _value) internal {
136 		// Prevent transfer to 0x0 address. Use burn() instead
137 		require(_to != address(0));
138 		// Check if the sender has enough
139 		require(balanceOf[_from] >= _value);
140 		// Check for overflows
141 		require(balanceOf[_to] + _value > balanceOf[_to]);
142 		// Save this for an assertion in the future
143 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
144 		// Subtract from the sender
145 		balanceOf[_from] -= _value;
146 		// Add the same to the recipient
147 		balanceOf[_to] += _value;
148 		emit Transfer(_from, _to, _value);
149 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
150 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
151 	}
152 
153 	/**
154 	 * Transfer tokens
155 	 *
156 	 * Send `_value` tokens to `_to` from your account
157 	 *
158 	 * @param _to The address of the recipient
159 	 * @param _value the amount to send
160 	 */
161 	function transfer(address _to, uint256 _value) public returns (bool success) {
162 		_transfer(msg.sender, _to, _value);
163 		return true;
164 	}
165 
166 	/**
167 	 * Transfer tokens from other address
168 	 *
169 	 * Send `_value` tokens to `_to` in behalf of `_from`
170 	 *
171 	 * @param _from The address of the sender
172 	 * @param _to The address of the recipient
173 	 * @param _value the amount to send
174 	 */
175 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
176 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
177 		allowance[_from][msg.sender] -= _value;
178 		_transfer(_from, _to, _value);
179 		return true;
180 	}
181 
182 	/**
183 	 * Set allowance for other address
184 	 *
185 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
186 	 *
187 	 * @param _spender The address authorized to spend
188 	 * @param _value the max amount they can spend
189 	 */
190 	function approve(address _spender, uint256 _value) public returns (bool success) {
191 		allowance[msg.sender][_spender] = _value;
192 		emit Approval(msg.sender, _spender, _value);
193 		return true;
194 	}
195 
196 	/**
197 	 * Set allowance for other address and notify
198 	 *
199 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
200 	 *
201 	 * @param _spender The address authorized to spend
202 	 * @param _value the max amount they can spend
203 	 * @param _extraData some extra information to send to the approved contract
204 	 */
205 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
206 		tokenRecipient spender = tokenRecipient(_spender);
207 		if (approve(_spender, _value)) {
208 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
209 			return true;
210 		}
211 	}
212 
213 	/**
214 	 * Destroy tokens
215 	 *
216 	 * Remove `_value` tokens from the system irreversibly
217 	 *
218 	 * @param _value the amount of money to burn
219 	 */
220 	function burn(uint256 _value) public returns (bool success) {
221 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
222 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
223 		totalSupply -= _value;                      // Updates totalSupply
224 		emit Burn(msg.sender, _value);
225 		return true;
226 	}
227 
228 	/**
229 	 * Destroy tokens from other account
230 	 *
231 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
232 	 *
233 	 * @param _from the address of the sender
234 	 * @param _value the amount of money to burn
235 	 */
236 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
237 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
238 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
239 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
240 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
241 		totalSupply -= _value;                              // Update totalSupply
242 		emit Burn(_from, _value);
243 		return true;
244 	}
245 }
246 
247 
248 /**
249  * @title TAO
250  */
251 contract TAO {
252 	using SafeMath for uint256;
253 
254 	address public vaultAddress;
255 	string public name;				// the name for this TAO
256 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
257 
258 	// TAO's data
259 	string public datHash;
260 	string public database;
261 	string public keyValue;
262 	bytes32 public contentId;
263 
264 	/**
265 	 * 0 = TAO
266 	 * 1 = Name
267 	 */
268 	uint8 public typeId;
269 
270 	/**
271 	 * @dev Constructor function
272 	 */
273 	constructor (string memory _name,
274 		address _originId,
275 		string memory _datHash,
276 		string memory _database,
277 		string memory _keyValue,
278 		bytes32 _contentId,
279 		address _vaultAddress
280 	) public {
281 		name = _name;
282 		originId = _originId;
283 		datHash = _datHash;
284 		database = _database;
285 		keyValue = _keyValue;
286 		contentId = _contentId;
287 
288 		// Creating TAO
289 		typeId = 0;
290 
291 		vaultAddress = _vaultAddress;
292 	}
293 
294 	/**
295 	 * @dev Checks if calling address is Vault contract
296 	 */
297 	modifier onlyVault {
298 		require (msg.sender == vaultAddress);
299 		_;
300 	}
301 
302 	/**
303 	 * Will receive any ETH sent
304 	 */
305 	function () external payable {
306 	}
307 
308 	/**
309 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
310 	 * @param _recipient The recipient address
311 	 * @param _amount The amount to transfer
312 	 * @return true on success
313 	 */
314 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
315 		_recipient.transfer(_amount);
316 		return true;
317 	}
318 
319 	/**
320 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
321 	 * @param _erc20TokenAddress The address of ERC20 Token
322 	 * @param _recipient The recipient address
323 	 * @param _amount The amount to transfer
324 	 * @return true on success
325 	 */
326 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
327 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
328 		_erc20.transfer(_recipient, _amount);
329 		return true;
330 	}
331 }
332 
333 
334 
335 
336 /**
337  * @title Name
338  */
339 contract Name is TAO {
340 	/**
341 	 * @dev Constructor function
342 	 */
343 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
344 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
345 		// Creating Name
346 		typeId = 1;
347 	}
348 }
349 
350 
351 
352 
353 /**
354  * @title AOLibrary
355  */
356 library AOLibrary {
357 	using SafeMath for uint256;
358 
359 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
360 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
361 
362 	/**
363 	 * @dev Check whether or not the given TAO ID is a TAO
364 	 * @param _taoId The ID of the TAO
365 	 * @return true if yes. false otherwise
366 	 */
367 	function isTAO(address _taoId) public view returns (bool) {
368 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
369 	}
370 
371 	/**
372 	 * @dev Check whether or not the given Name ID is a Name
373 	 * @param _nameId The ID of the Name
374 	 * @return true if yes. false otherwise
375 	 */
376 	function isName(address _nameId) public view returns (bool) {
377 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
378 	}
379 
380 	/**
381 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
382 	 * @param _tokenAddress The ERC20 Token address to check
383 	 */
384 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
385 		if (_tokenAddress == address(0)) {
386 			return false;
387 		}
388 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
389 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
390 	}
391 
392 	/**
393 	 * @dev Checks if the calling contract address is The AO
394 	 *		OR
395 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
396 	 * @param _sender The address to check
397 	 * @param _theAO The AO address
398 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
399 	 * @return true if yes, false otherwise
400 	 */
401 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
402 		return (_sender == _theAO ||
403 			(
404 				(isTAO(_theAO) || isName(_theAO)) &&
405 				_nameTAOPositionAddress != address(0) &&
406 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
407 			)
408 		);
409 	}
410 
411 	/**
412 	 * @dev Return the divisor used to correctly calculate percentage.
413 	 *		Percentage stored throughout AO contracts covers 4 decimals,
414 	 *		so 1% is 10000, 1.25% is 12500, etc
415 	 */
416 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
417 		return _PERCENTAGE_DIVISOR;
418 	}
419 
420 	/**
421 	 * @dev Return the divisor used to correctly calculate multiplier.
422 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
423 	 *		so 1 is 1000000, 0.023 is 23000, etc
424 	 */
425 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
426 		return _MULTIPLIER_DIVISOR;
427 	}
428 
429 	/**
430 	 * @dev deploy a TAO
431 	 * @param _name The name of the TAO
432 	 * @param _originId The Name ID the creates the TAO
433 	 * @param _datHash The datHash of this TAO
434 	 * @param _database The database for this TAO
435 	 * @param _keyValue The key/value pair to be checked on the database
436 	 * @param _contentId The contentId related to this TAO
437 	 * @param _nameTAOVaultAddress The address of NameTAOVault
438 	 */
439 	function deployTAO(string memory _name,
440 		address _originId,
441 		string memory _datHash,
442 		string memory _database,
443 		string memory _keyValue,
444 		bytes32 _contentId,
445 		address _nameTAOVaultAddress
446 		) public returns (TAO _tao) {
447 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
448 	}
449 
450 	/**
451 	 * @dev deploy a Name
452 	 * @param _name The name of the Name
453 	 * @param _originId The eth address the creates the Name
454 	 * @param _datHash The datHash of this Name
455 	 * @param _database The database for this Name
456 	 * @param _keyValue The key/value pair to be checked on the database
457 	 * @param _contentId The contentId related to this Name
458 	 * @param _nameTAOVaultAddress The address of NameTAOVault
459 	 */
460 	function deployName(string memory _name,
461 		address _originId,
462 		string memory _datHash,
463 		string memory _database,
464 		string memory _keyValue,
465 		bytes32 _contentId,
466 		address _nameTAOVaultAddress
467 		) public returns (Name _myName) {
468 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
469 	}
470 
471 	/**
472 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
473 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
474 	 * @param _currentPrimordialBalance Account's current primordial ion balance
475 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
476 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
477 	 * @return the new primordial weighted multiplier
478 	 */
479 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
480 		if (_currentWeightedMultiplier > 0) {
481 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
482 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
483 			return _totalWeightedIons.div(_totalIons);
484 		} else {
485 			return _additionalWeightedMultiplier;
486 		}
487 	}
488 
489 	/**
490 	 * @dev Calculate the primordial ion multiplier on a given lot
491 	 *		Total Primordial Mintable = T
492 	 *		Total Primordial Minted = M
493 	 *		Starting Multiplier = S
494 	 *		Ending Multiplier = E
495 	 *		To Purchase = P
496 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
497 	 *
498 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
499 	 * @param _totalPrimordialMintable Total Primordial ion mintable
500 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
501 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
502 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
503 	 * @return The multiplier in (10 ** 6)
504 	 */
505 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
506 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
507 			/**
508 			 * Let temp = M + (P/2)
509 			 * Multiplier = (1 - (temp / T)) x (S-E)
510 			 */
511 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
512 
513 			/**
514 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
515 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
516 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
517 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
518 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
519 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
520 			 */
521 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
522 			/**
523 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
524 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
525 			 */
526 			return multiplier.div(_MULTIPLIER_DIVISOR);
527 		} else {
528 			return 0;
529 		}
530 	}
531 
532 	/**
533 	 * @dev Calculate the bonus percentage of network ion on a given lot
534 	 *		Total Primordial Mintable = T
535 	 *		Total Primordial Minted = M
536 	 *		Starting Network Bonus Multiplier = Bs
537 	 *		Ending Network Bonus Multiplier = Be
538 	 *		To Purchase = P
539 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
540 	 *
541 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
542 	 * @param _totalPrimordialMintable Total Primordial ion intable
543 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
544 	 * @param _startingMultiplier The starting Network ion bonus multiplier
545 	 * @param _endingMultiplier The ending Network ion bonus multiplier
546 	 * @return The bonus percentage
547 	 */
548 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
549 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
550 			/**
551 			 * Let temp = M + (P/2)
552 			 * B% = (1 - (temp / T)) x (Bs-Be)
553 			 */
554 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
555 
556 			/**
557 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
558 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
559 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
560 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
561 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
562 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
563 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
564 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
565 			 */
566 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
567 			return bonusPercentage;
568 		} else {
569 			return 0;
570 		}
571 	}
572 
573 	/**
574 	 * @dev Calculate the bonus amount of network ion on a given lot
575 	 *		AO Bonus Amount = B% x P
576 	 *
577 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
578 	 * @param _totalPrimordialMintable Total Primordial ion intable
579 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
580 	 * @param _startingMultiplier The starting Network ion bonus multiplier
581 	 * @param _endingMultiplier The ending Network ion bonus multiplier
582 	 * @return The bonus percentage
583 	 */
584 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
585 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
586 		/**
587 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
588 		 * when calculating the network ion bonus amount
589 		 */
590 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
591 		return networkBonus;
592 	}
593 
594 	/**
595 	 * @dev Calculate the maximum amount of Primordial an account can burn
596 	 *		_primordialBalance = P
597 	 *		_currentWeightedMultiplier = M
598 	 *		_maximumMultiplier = S
599 	 *		_amountToBurn = B
600 	 *		B = ((S x P) - (P x M)) / S
601 	 *
602 	 * @param _primordialBalance Account's primordial ion balance
603 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
604 	 * @param _maximumMultiplier The maximum multiplier of this account
605 	 * @return The maximum burn amount
606 	 */
607 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
608 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
609 	}
610 
611 	/**
612 	 * @dev Calculate the new multiplier after burning primordial ion
613 	 *		_primordialBalance = P
614 	 *		_currentWeightedMultiplier = M
615 	 *		_amountToBurn = B
616 	 *		_newMultiplier = E
617 	 *		E = (P x M) / (P - B)
618 	 *
619 	 * @param _primordialBalance Account's primordial ion balance
620 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
621 	 * @param _amountToBurn The amount of primordial ion to burn
622 	 * @return The new multiplier
623 	 */
624 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
625 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
626 	}
627 
628 	/**
629 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
630 	 *		_primordialBalance = P
631 	 *		_currentWeightedMultiplier = M
632 	 *		_amountToConvert = C
633 	 *		_newMultiplier = E
634 	 *		E = (P x M) / (P + C)
635 	 *
636 	 * @param _primordialBalance Account's primordial ion balance
637 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
638 	 * @param _amountToConvert The amount of network ion to convert
639 	 * @return The new multiplier
640 	 */
641 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
642 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
643 	}
644 
645 	/**
646 	 * @dev count num of digits
647 	 * @param number uint256 of the nuumber to be checked
648 	 * @return uint8 num of digits
649 	 */
650 	function numDigits(uint256 number) public pure returns (uint8) {
651 		uint8 digits = 0;
652 		while(number != 0) {
653 			number = number.div(10);
654 			digits++;
655 		}
656 		return digits;
657 	}
658 }
659 
660 
661 
662 contract TheAO {
663 	address public theAO;
664 	address public nameTAOPositionAddress;
665 
666 	// Check whether an address is whitelisted and granted access to transact
667 	// on behalf of others
668 	mapping (address => bool) public whitelist;
669 
670 	constructor() public {
671 		theAO = msg.sender;
672 	}
673 
674 	/**
675 	 * @dev Checks if msg.sender is in whitelist.
676 	 */
677 	modifier inWhitelist() {
678 		require (whitelist[msg.sender] == true);
679 		_;
680 	}
681 
682 	/**
683 	 * @dev Transfer ownership of The AO to new address
684 	 * @param _theAO The new address to be transferred
685 	 */
686 	function transferOwnership(address _theAO) public {
687 		require (msg.sender == theAO);
688 		require (_theAO != address(0));
689 		theAO = _theAO;
690 	}
691 
692 	/**
693 	 * @dev Whitelist `_account` address to transact on behalf of others
694 	 * @param _account The address to whitelist
695 	 * @param _whitelist Either to whitelist or not
696 	 */
697 	function setWhitelist(address _account, bool _whitelist) public {
698 		require (msg.sender == theAO);
699 		require (_account != address(0));
700 		whitelist[_account] = _whitelist;
701 	}
702 }
703 
704 
705 
706 
707 
708 interface ionRecipient {
709 	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
710 }
711 
712 /**
713  * @title AOIonInterface
714  */
715 contract AOIonInterface is TheAO {
716 	using SafeMath for uint256;
717 
718 	address public namePublicKeyAddress;
719 	address public nameAccountRecoveryAddress;
720 
721 	INameTAOPosition internal _nameTAOPosition;
722 	INamePublicKey internal _namePublicKey;
723 	INameAccountRecovery internal _nameAccountRecovery;
724 
725 	// Public variables of the contract
726 	string public name;
727 	string public symbol;
728 	uint8 public decimals;
729 	uint256 public totalSupply;
730 
731 	// To differentiate denomination of AO
732 	uint256 public powerOfTen;
733 
734 	/***** NETWORK ION VARIABLES *****/
735 	uint256 public sellPrice;
736 	uint256 public buyPrice;
737 
738 	// This creates an array with all balances
739 	mapping (address => uint256) public balanceOf;
740 	mapping (address => mapping (address => uint256)) public allowance;
741 	mapping (address => bool) public frozenAccount;
742 	mapping (address => uint256) public stakedBalance;
743 	mapping (address => uint256) public escrowedBalance;
744 
745 	// This generates a public event on the blockchain that will notify clients
746 	event FrozenFunds(address target, bool frozen);
747 	event Stake(address indexed from, uint256 value);
748 	event Unstake(address indexed from, uint256 value);
749 	event Escrow(address indexed from, address indexed to, uint256 value);
750 	event Unescrow(address indexed from, uint256 value);
751 
752 	// This generates a public event on the blockchain that will notify clients
753 	event Transfer(address indexed from, address indexed to, uint256 value);
754 
755 	// This generates a public event on the blockchain that will notify clients
756 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
757 
758 	// This notifies clients about the amount burnt
759 	event Burn(address indexed from, uint256 value);
760 
761 	/**
762 	 * @dev Constructor function
763 	 */
764 	constructor(string memory _name, string memory _symbol, address _nameTAOPositionAddress, address _namePublicKeyAddress, address _nameAccountRecoveryAddress) public {
765 		setNameTAOPositionAddress(_nameTAOPositionAddress);
766 		setNamePublicKeyAddress(_namePublicKeyAddress);
767 		setNameAccountRecoveryAddress(_nameAccountRecoveryAddress);
768 		name = _name;           // Set the name for display purposes
769 		symbol = _symbol;       // Set the symbol for display purposes
770 		powerOfTen = 0;
771 		decimals = 0;
772 	}
773 
774 	/**
775 	 * @dev Checks if the calling contract address is The AO
776 	 *		OR
777 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
778 	 */
779 	modifier onlyTheAO {
780 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
781 		_;
782 	}
783 
784 	/***** The AO ONLY METHODS *****/
785 	/**
786 	 * @dev Transfer ownership of The AO to new address
787 	 * @param _theAO The new address to be transferred
788 	 */
789 	function transferOwnership(address _theAO) public onlyTheAO {
790 		require (_theAO != address(0));
791 		theAO = _theAO;
792 	}
793 
794 	/**
795 	 * @dev Whitelist `_account` address to transact on behalf of others
796 	 * @param _account The address to whitelist
797 	 * @param _whitelist Either to whitelist or not
798 	 */
799 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
800 		require (_account != address(0));
801 		whitelist[_account] = _whitelist;
802 	}
803 
804 	/**
805 	 * @dev The AO set the NameTAOPosition Address
806 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
807 	 */
808 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
809 		require (_nameTAOPositionAddress != address(0));
810 		nameTAOPositionAddress = _nameTAOPositionAddress;
811 		_nameTAOPosition = INameTAOPosition(nameTAOPositionAddress);
812 	}
813 
814 	/**
815 	 * @dev The AO set the NamePublicKey Address
816 	 * @param _namePublicKeyAddress The address of NamePublicKey
817 	 */
818 	function setNamePublicKeyAddress(address _namePublicKeyAddress) public onlyTheAO {
819 		require (_namePublicKeyAddress != address(0));
820 		namePublicKeyAddress = _namePublicKeyAddress;
821 		_namePublicKey = INamePublicKey(namePublicKeyAddress);
822 	}
823 
824 	/**
825 	 * @dev The AO set the NameAccountRecovery Address
826 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
827 	 */
828 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
829 		require (_nameAccountRecoveryAddress != address(0));
830 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
831 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
832 	}
833 
834 	/**
835 	 * @dev Allows TheAO to transfer `_amount` of ETH from this address to `_recipient`
836 	 * @param _recipient The recipient address
837 	 * @param _amount The amount to transfer
838 	 */
839 	function transferEth(address payable _recipient, uint256 _amount) public onlyTheAO {
840 		require (_recipient != address(0));
841 		_recipient.transfer(_amount);
842 	}
843 
844 	/**
845 	 * @dev Prevent/Allow target from sending & receiving ions
846 	 * @param target Address to be frozen
847 	 * @param freeze Either to freeze it or not
848 	 */
849 	function freezeAccount(address target, bool freeze) public onlyTheAO {
850 		frozenAccount[target] = freeze;
851 		emit FrozenFunds(target, freeze);
852 	}
853 
854 	/**
855 	 * @dev Allow users to buy ions for `newBuyPrice` eth and sell ions for `newSellPrice` eth
856 	 * @param newSellPrice Price users can sell to the contract
857 	 * @param newBuyPrice Price users can buy from the contract
858 	 */
859 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyTheAO {
860 		sellPrice = newSellPrice;
861 		buyPrice = newBuyPrice;
862 	}
863 
864 	/***** NETWORK ION WHITELISTED ADDRESS ONLY METHODS *****/
865 	/**
866 	 * @dev Create `mintedAmount` ions and send it to `target`
867 	 * @param target Address to receive the ions
868 	 * @param mintedAmount The amount of ions it will receive
869 	 * @return true on success
870 	 */
871 	function mint(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
872 		_mint(target, mintedAmount);
873 		return true;
874 	}
875 
876 	/**
877 	 * @dev Stake `_value` ions on behalf of `_from`
878 	 * @param _from The address of the target
879 	 * @param _value The amount to stake
880 	 * @return true on success
881 	 */
882 	function stakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
883 		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
884 		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
885 		stakedBalance[_from] = stakedBalance[_from].add(_value);	// Add to the targeted staked balance
886 		emit Stake(_from, _value);
887 		return true;
888 	}
889 
890 	/**
891 	 * @dev Unstake `_value` ions on behalf of `_from`
892 	 * @param _from The address of the target
893 	 * @param _value The amount to unstake
894 	 * @return true on success
895 	 */
896 	function unstakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
897 		require (stakedBalance[_from] >= _value);					// Check if the targeted staked balance is enough
898 		stakedBalance[_from] = stakedBalance[_from].sub(_value);	// Subtract from the targeted staked balance
899 		balanceOf[_from] = balanceOf[_from].add(_value);			// Add to the targeted balance
900 		emit Unstake(_from, _value);
901 		return true;
902 	}
903 
904 	/**
905 	 * @dev Store `_value` from `_from` to `_to` in escrow
906 	 * @param _from The address of the sender
907 	 * @param _to The address of the recipient
908 	 * @param _value The amount of network ions to put in escrow
909 	 * @return true on success
910 	 */
911 	function escrowFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool) {
912 		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
913 		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
914 		escrowedBalance[_to] = escrowedBalance[_to].add(_value);	// Add to the targeted escrowed balance
915 		emit Escrow(_from, _to, _value);
916 		return true;
917 	}
918 
919 	/**
920 	 * @dev Create `mintedAmount` ions and send it to `target` escrow balance
921 	 * @param target Address to receive ions
922 	 * @param mintedAmount The amount of ions it will receive in escrow
923 	 */
924 	function mintEscrow(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
925 		escrowedBalance[target] = escrowedBalance[target].add(mintedAmount);
926 		totalSupply = totalSupply.add(mintedAmount);
927 		emit Escrow(address(this), target, mintedAmount);
928 		return true;
929 	}
930 
931 	/**
932 	 * @dev Release escrowed `_value` from `_from`
933 	 * @param _from The address of the sender
934 	 * @param _value The amount of escrowed network ions to be released
935 	 * @return true on success
936 	 */
937 	function unescrowFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
938 		require (escrowedBalance[_from] >= _value);						// Check if the targeted escrowed balance is enough
939 		escrowedBalance[_from] = escrowedBalance[_from].sub(_value);	// Subtract from the targeted escrowed balance
940 		balanceOf[_from] = balanceOf[_from].add(_value);				// Add to the targeted balance
941 		emit Unescrow(_from, _value);
942 		return true;
943 	}
944 
945 	/**
946 	 *
947 	 * @dev Whitelisted address remove `_value` ions from the system irreversibly on behalf of `_from`.
948 	 *
949 	 * @param _from the address of the sender
950 	 * @param _value the amount of money to burn
951 	 */
952 	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist returns (bool success) {
953 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
954 		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
955 		totalSupply = totalSupply.sub(_value);              // Update totalSupply
956 		emit Burn(_from, _value);
957 		return true;
958 	}
959 
960 	/**
961 	 * @dev Whitelisted address transfer ions from other address
962 	 *
963 	 * Send `_value` ions to `_to` on behalf of `_from`
964 	 *
965 	 * @param _from The address of the sender
966 	 * @param _to The address of the recipient
967 	 * @param _value the amount to send
968 	 */
969 	function whitelistTransferFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool success) {
970 		_transfer(_from, _to, _value);
971 		return true;
972 	}
973 
974 	/***** PUBLIC METHODS *****/
975 	/**
976 	 * Transfer ions
977 	 *
978 	 * Send `_value` ions to `_to` from your account
979 	 *
980 	 * @param _to The address of the recipient
981 	 * @param _value the amount to send
982 	 */
983 	function transfer(address _to, uint256 _value) public returns (bool success) {
984 		_transfer(msg.sender, _to, _value);
985 		return true;
986 	}
987 
988 	/**
989 	 * Transfer ions from other address
990 	 *
991 	 * Send `_value` ions to `_to` in behalf of `_from`
992 	 *
993 	 * @param _from The address of the sender
994 	 * @param _to The address of the recipient
995 	 * @param _value the amount to send
996 	 */
997 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
998 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
999 		allowance[_from][msg.sender] -= _value;
1000 		_transfer(_from, _to, _value);
1001 		return true;
1002 	}
1003 
1004 	/**
1005 	 * Transfer ions between public key addresses in a Name
1006 	 * @param _nameId The ID of the Name
1007 	 * @param _from The address of the sender
1008 	 * @param _to The address of the recipient
1009 	 * @param _value the amount to send
1010 	 */
1011 	function transferBetweenPublicKeys(address _nameId, address _from, address _to, uint256 _value) public returns (bool success) {
1012 		require (AOLibrary.isName(_nameId));
1013 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _nameId));
1014 		require (!_nameAccountRecovery.isCompromised(_nameId));
1015 		// Make sure _from exist in the Name's Public Keys
1016 		require (_namePublicKey.isKeyExist(_nameId, _from));
1017 		// Make sure _to exist in the Name's Public Keys
1018 		require (_namePublicKey.isKeyExist(_nameId, _to));
1019 		_transfer(_from, _to, _value);
1020 		return true;
1021 	}
1022 
1023 	/**
1024 	 * Set allowance for other address
1025 	 *
1026 	 * Allows `_spender` to spend no more than `_value` ions in your behalf
1027 	 *
1028 	 * @param _spender The address authorized to spend
1029 	 * @param _value the max amount they can spend
1030 	 */
1031 	function approve(address _spender, uint256 _value) public returns (bool success) {
1032 		allowance[msg.sender][_spender] = _value;
1033 		emit Approval(msg.sender, _spender, _value);
1034 		return true;
1035 	}
1036 
1037 	/**
1038 	 * Set allowance for other address and notify
1039 	 *
1040 	 * Allows `_spender` to spend no more than `_value` ions in your behalf, and then ping the contract about it
1041 	 *
1042 	 * @param _spender The address authorized to spend
1043 	 * @param _value the max amount they can spend
1044 	 * @param _extraData some extra information to send to the approved contract
1045 	 */
1046 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
1047 		ionRecipient spender = ionRecipient(_spender);
1048 		if (approve(_spender, _value)) {
1049 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
1050 			return true;
1051 		}
1052 	}
1053 
1054 	/**
1055 	 * Destroy ions
1056 	 *
1057 	 * Remove `_value` ions from the system irreversibly
1058 	 *
1059 	 * @param _value the amount of money to burn
1060 	 */
1061 	function burn(uint256 _value) public returns (bool success) {
1062 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
1063 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
1064 		totalSupply -= _value;                      // Updates totalSupply
1065 		emit Burn(msg.sender, _value);
1066 		return true;
1067 	}
1068 
1069 	/**
1070 	 * Destroy ions from other account
1071 	 *
1072 	 * Remove `_value` ions from the system irreversibly on behalf of `_from`.
1073 	 *
1074 	 * @param _from the address of the sender
1075 	 * @param _value the amount of money to burn
1076 	 */
1077 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
1078 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
1079 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
1080 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
1081 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
1082 		totalSupply -= _value;                              // Update totalSupply
1083 		emit Burn(_from, _value);
1084 		return true;
1085 	}
1086 
1087 	/**
1088 	 * @dev Buy ions from contract by sending ether
1089 	 */
1090 	function buy() public payable {
1091 		require (buyPrice > 0);
1092 		uint256 amount = msg.value.div(buyPrice);
1093 		_transfer(address(this), msg.sender, amount);
1094 	}
1095 
1096 	/**
1097 	 * @dev Sell `amount` ions to contract
1098 	 * @param amount The amount of ions to be sold
1099 	 */
1100 	function sell(uint256 amount) public {
1101 		require (sellPrice > 0);
1102 		address myAddress = address(this);
1103 		require (myAddress.balance >= amount.mul(sellPrice));
1104 		_transfer(msg.sender, address(this), amount);
1105 		msg.sender.transfer(amount.mul(sellPrice));
1106 	}
1107 
1108 	/***** INTERNAL METHODS *****/
1109 	/**
1110 	 * @dev Send `_value` ions from `_from` to `_to`
1111 	 * @param _from The address of sender
1112 	 * @param _to The address of the recipient
1113 	 * @param _value The amount to send
1114 	 */
1115 	function _transfer(address _from, address _to, uint256 _value) internal {
1116 		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
1117 		require (balanceOf[_from] >= _value);					// Check if the sender has enough
1118 		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
1119 		require (!frozenAccount[_from]);						// Check if sender is frozen
1120 		require (!frozenAccount[_to]);							// Check if recipient is frozen
1121 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
1122 		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
1123 		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
1124 		emit Transfer(_from, _to, _value);
1125 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
1126 	}
1127 
1128 	/**
1129 	 * @dev Create `mintedAmount` ions and send it to `target`
1130 	 * @param target Address to receive the ions
1131 	 * @param mintedAmount The amount of ions it will receive
1132 	 */
1133 	function _mint(address target, uint256 mintedAmount) internal {
1134 		balanceOf[target] = balanceOf[target].add(mintedAmount);
1135 		totalSupply = totalSupply.add(mintedAmount);
1136 		emit Transfer(address(0), address(this), mintedAmount);
1137 		emit Transfer(address(this), target, mintedAmount);
1138 	}
1139 }
1140 
1141 
1142 contract AOTera is AOIonInterface {
1143 	/**
1144 	 * @dev Constructor function
1145 	 */
1146 	constructor(string memory _name, string memory _symbol, address _nameTAOPositionAddress, address _namePublicKeyAddress, address _nameAccountRecoveryAddress)
1147 		AOIonInterface(_name, _symbol, _nameTAOPositionAddress, _namePublicKeyAddress, _nameAccountRecoveryAddress) public {
1148 		powerOfTen = 12;
1149 		decimals = 12;
1150 	}
1151 }