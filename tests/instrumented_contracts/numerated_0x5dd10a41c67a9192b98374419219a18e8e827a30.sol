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
97 contract TokenERC20 {
98 	// Public variables of the token
99 	string public name;
100 	string public symbol;
101 	uint8 public decimals = 18;
102 	// 18 decimals is the strongly suggested default, avoid changing it
103 	uint256 public totalSupply;
104 
105 	// This creates an array with all balances
106 	mapping (address => uint256) public balanceOf;
107 	mapping (address => mapping (address => uint256)) public allowance;
108 
109 	// This generates a public event on the blockchain that will notify clients
110 	event Transfer(address indexed from, address indexed to, uint256 value);
111 
112 	// This generates a public event on the blockchain that will notify clients
113 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
114 
115 	// This notifies clients about the amount burnt
116 	event Burn(address indexed from, uint256 value);
117 
118 	/**
119 	 * Constructor function
120 	 *
121 	 * Initializes contract with initial supply tokens to the creator of the contract
122 	 */
123 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
124 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
125 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
126 		name = tokenName;                                   // Set the name for display purposes
127 		symbol = tokenSymbol;                               // Set the symbol for display purposes
128 	}
129 
130 	/**
131 	 * Internal transfer, only can be called by this contract
132 	 */
133 	function _transfer(address _from, address _to, uint _value) internal {
134 		// Prevent transfer to 0x0 address. Use burn() instead
135 		require(_to != address(0));
136 		// Check if the sender has enough
137 		require(balanceOf[_from] >= _value);
138 		// Check for overflows
139 		require(balanceOf[_to] + _value > balanceOf[_to]);
140 		// Save this for an assertion in the future
141 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
142 		// Subtract from the sender
143 		balanceOf[_from] -= _value;
144 		// Add the same to the recipient
145 		balanceOf[_to] += _value;
146 		emit Transfer(_from, _to, _value);
147 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
148 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
149 	}
150 
151 	/**
152 	 * Transfer tokens
153 	 *
154 	 * Send `_value` tokens to `_to` from your account
155 	 *
156 	 * @param _to The address of the recipient
157 	 * @param _value the amount to send
158 	 */
159 	function transfer(address _to, uint256 _value) public returns (bool success) {
160 		_transfer(msg.sender, _to, _value);
161 		return true;
162 	}
163 
164 	/**
165 	 * Transfer tokens from other address
166 	 *
167 	 * Send `_value` tokens to `_to` in behalf of `_from`
168 	 *
169 	 * @param _from The address of the sender
170 	 * @param _to The address of the recipient
171 	 * @param _value the amount to send
172 	 */
173 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
174 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
175 		allowance[_from][msg.sender] -= _value;
176 		_transfer(_from, _to, _value);
177 		return true;
178 	}
179 
180 	/**
181 	 * Set allowance for other address
182 	 *
183 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
184 	 *
185 	 * @param _spender The address authorized to spend
186 	 * @param _value the max amount they can spend
187 	 */
188 	function approve(address _spender, uint256 _value) public returns (bool success) {
189 		allowance[msg.sender][_spender] = _value;
190 		emit Approval(msg.sender, _spender, _value);
191 		return true;
192 	}
193 
194 	/**
195 	 * Set allowance for other address and notify
196 	 *
197 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
198 	 *
199 	 * @param _spender The address authorized to spend
200 	 * @param _value the max amount they can spend
201 	 * @param _extraData some extra information to send to the approved contract
202 	 */
203 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
204 		tokenRecipient spender = tokenRecipient(_spender);
205 		if (approve(_spender, _value)) {
206 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
207 			return true;
208 		}
209 	}
210 
211 	/**
212 	 * Destroy tokens
213 	 *
214 	 * Remove `_value` tokens from the system irreversibly
215 	 *
216 	 * @param _value the amount of money to burn
217 	 */
218 	function burn(uint256 _value) public returns (bool success) {
219 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
220 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
221 		totalSupply -= _value;                      // Updates totalSupply
222 		emit Burn(msg.sender, _value);
223 		return true;
224 	}
225 
226 	/**
227 	 * Destroy tokens from other account
228 	 *
229 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
230 	 *
231 	 * @param _from the address of the sender
232 	 * @param _value the amount of money to burn
233 	 */
234 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
235 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
236 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
237 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
238 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
239 		totalSupply -= _value;                              // Update totalSupply
240 		emit Burn(_from, _value);
241 		return true;
242 	}
243 }
244 
245 
246 /**
247  * @title TAO
248  */
249 contract TAO {
250 	using SafeMath for uint256;
251 
252 	address public vaultAddress;
253 	string public name;				// the name for this TAO
254 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
255 
256 	// TAO's data
257 	string public datHash;
258 	string public database;
259 	string public keyValue;
260 	bytes32 public contentId;
261 
262 	/**
263 	 * 0 = TAO
264 	 * 1 = Name
265 	 */
266 	uint8 public typeId;
267 
268 	/**
269 	 * @dev Constructor function
270 	 */
271 	constructor (string memory _name,
272 		address _originId,
273 		string memory _datHash,
274 		string memory _database,
275 		string memory _keyValue,
276 		bytes32 _contentId,
277 		address _vaultAddress
278 	) public {
279 		name = _name;
280 		originId = _originId;
281 		datHash = _datHash;
282 		database = _database;
283 		keyValue = _keyValue;
284 		contentId = _contentId;
285 
286 		// Creating TAO
287 		typeId = 0;
288 
289 		vaultAddress = _vaultAddress;
290 	}
291 
292 	/**
293 	 * @dev Checks if calling address is Vault contract
294 	 */
295 	modifier onlyVault {
296 		require (msg.sender == vaultAddress);
297 		_;
298 	}
299 
300 	/**
301 	 * Will receive any ETH sent
302 	 */
303 	function () external payable {
304 	}
305 
306 	/**
307 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
308 	 * @param _recipient The recipient address
309 	 * @param _amount The amount to transfer
310 	 * @return true on success
311 	 */
312 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
313 		_recipient.transfer(_amount);
314 		return true;
315 	}
316 
317 	/**
318 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
319 	 * @param _erc20TokenAddress The address of ERC20 Token
320 	 * @param _recipient The recipient address
321 	 * @param _amount The amount to transfer
322 	 * @return true on success
323 	 */
324 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
325 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
326 		_erc20.transfer(_recipient, _amount);
327 		return true;
328 	}
329 }
330 
331 
332 
333 
334 /**
335  * @title Name
336  */
337 contract Name is TAO {
338 	/**
339 	 * @dev Constructor function
340 	 */
341 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
342 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
343 		// Creating Name
344 		typeId = 1;
345 	}
346 }
347 
348 
349 
350 
351 /**
352  * @title AOLibrary
353  */
354 library AOLibrary {
355 	using SafeMath for uint256;
356 
357 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
358 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
359 
360 	/**
361 	 * @dev Check whether or not the given TAO ID is a TAO
362 	 * @param _taoId The ID of the TAO
363 	 * @return true if yes. false otherwise
364 	 */
365 	function isTAO(address _taoId) public view returns (bool) {
366 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
367 	}
368 
369 	/**
370 	 * @dev Check whether or not the given Name ID is a Name
371 	 * @param _nameId The ID of the Name
372 	 * @return true if yes. false otherwise
373 	 */
374 	function isName(address _nameId) public view returns (bool) {
375 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
376 	}
377 
378 	/**
379 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
380 	 * @param _tokenAddress The ERC20 Token address to check
381 	 */
382 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
383 		if (_tokenAddress == address(0)) {
384 			return false;
385 		}
386 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
387 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
388 	}
389 
390 	/**
391 	 * @dev Checks if the calling contract address is The AO
392 	 *		OR
393 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
394 	 * @param _sender The address to check
395 	 * @param _theAO The AO address
396 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
397 	 * @return true if yes, false otherwise
398 	 */
399 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
400 		return (_sender == _theAO ||
401 			(
402 				(isTAO(_theAO) || isName(_theAO)) &&
403 				_nameTAOPositionAddress != address(0) &&
404 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
405 			)
406 		);
407 	}
408 
409 	/**
410 	 * @dev Return the divisor used to correctly calculate percentage.
411 	 *		Percentage stored throughout AO contracts covers 4 decimals,
412 	 *		so 1% is 10000, 1.25% is 12500, etc
413 	 */
414 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
415 		return _PERCENTAGE_DIVISOR;
416 	}
417 
418 	/**
419 	 * @dev Return the divisor used to correctly calculate multiplier.
420 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
421 	 *		so 1 is 1000000, 0.023 is 23000, etc
422 	 */
423 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
424 		return _MULTIPLIER_DIVISOR;
425 	}
426 
427 	/**
428 	 * @dev deploy a TAO
429 	 * @param _name The name of the TAO
430 	 * @param _originId The Name ID the creates the TAO
431 	 * @param _datHash The datHash of this TAO
432 	 * @param _database The database for this TAO
433 	 * @param _keyValue The key/value pair to be checked on the database
434 	 * @param _contentId The contentId related to this TAO
435 	 * @param _nameTAOVaultAddress The address of NameTAOVault
436 	 */
437 	function deployTAO(string memory _name,
438 		address _originId,
439 		string memory _datHash,
440 		string memory _database,
441 		string memory _keyValue,
442 		bytes32 _contentId,
443 		address _nameTAOVaultAddress
444 		) public returns (TAO _tao) {
445 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
446 	}
447 
448 	/**
449 	 * @dev deploy a Name
450 	 * @param _name The name of the Name
451 	 * @param _originId The eth address the creates the Name
452 	 * @param _datHash The datHash of this Name
453 	 * @param _database The database for this Name
454 	 * @param _keyValue The key/value pair to be checked on the database
455 	 * @param _contentId The contentId related to this Name
456 	 * @param _nameTAOVaultAddress The address of NameTAOVault
457 	 */
458 	function deployName(string memory _name,
459 		address _originId,
460 		string memory _datHash,
461 		string memory _database,
462 		string memory _keyValue,
463 		bytes32 _contentId,
464 		address _nameTAOVaultAddress
465 		) public returns (Name _myName) {
466 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
467 	}
468 
469 	/**
470 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
471 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
472 	 * @param _currentPrimordialBalance Account's current primordial ion balance
473 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
474 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
475 	 * @return the new primordial weighted multiplier
476 	 */
477 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
478 		if (_currentWeightedMultiplier > 0) {
479 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
480 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
481 			return _totalWeightedIons.div(_totalIons);
482 		} else {
483 			return _additionalWeightedMultiplier;
484 		}
485 	}
486 
487 	/**
488 	 * @dev Calculate the primordial ion multiplier on a given lot
489 	 *		Total Primordial Mintable = T
490 	 *		Total Primordial Minted = M
491 	 *		Starting Multiplier = S
492 	 *		Ending Multiplier = E
493 	 *		To Purchase = P
494 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
495 	 *
496 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
497 	 * @param _totalPrimordialMintable Total Primordial ion mintable
498 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
499 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
500 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
501 	 * @return The multiplier in (10 ** 6)
502 	 */
503 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
504 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
505 			/**
506 			 * Let temp = M + (P/2)
507 			 * Multiplier = (1 - (temp / T)) x (S-E)
508 			 */
509 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
510 
511 			/**
512 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
513 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
514 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
515 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
516 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
517 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
518 			 */
519 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
520 			/**
521 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
522 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
523 			 */
524 			return multiplier.div(_MULTIPLIER_DIVISOR);
525 		} else {
526 			return 0;
527 		}
528 	}
529 
530 	/**
531 	 * @dev Calculate the bonus percentage of network ion on a given lot
532 	 *		Total Primordial Mintable = T
533 	 *		Total Primordial Minted = M
534 	 *		Starting Network Bonus Multiplier = Bs
535 	 *		Ending Network Bonus Multiplier = Be
536 	 *		To Purchase = P
537 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
538 	 *
539 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
540 	 * @param _totalPrimordialMintable Total Primordial ion intable
541 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
542 	 * @param _startingMultiplier The starting Network ion bonus multiplier
543 	 * @param _endingMultiplier The ending Network ion bonus multiplier
544 	 * @return The bonus percentage
545 	 */
546 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
547 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
548 			/**
549 			 * Let temp = M + (P/2)
550 			 * B% = (1 - (temp / T)) x (Bs-Be)
551 			 */
552 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
553 
554 			/**
555 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
556 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
557 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
558 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
559 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
560 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
561 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
562 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
563 			 */
564 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
565 			return bonusPercentage;
566 		} else {
567 			return 0;
568 		}
569 	}
570 
571 	/**
572 	 * @dev Calculate the bonus amount of network ion on a given lot
573 	 *		AO Bonus Amount = B% x P
574 	 *
575 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
576 	 * @param _totalPrimordialMintable Total Primordial ion intable
577 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
578 	 * @param _startingMultiplier The starting Network ion bonus multiplier
579 	 * @param _endingMultiplier The ending Network ion bonus multiplier
580 	 * @return The bonus percentage
581 	 */
582 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
583 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
584 		/**
585 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
586 		 * when calculating the network ion bonus amount
587 		 */
588 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
589 		return networkBonus;
590 	}
591 
592 	/**
593 	 * @dev Calculate the maximum amount of Primordial an account can burn
594 	 *		_primordialBalance = P
595 	 *		_currentWeightedMultiplier = M
596 	 *		_maximumMultiplier = S
597 	 *		_amountToBurn = B
598 	 *		B = ((S x P) - (P x M)) / S
599 	 *
600 	 * @param _primordialBalance Account's primordial ion balance
601 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
602 	 * @param _maximumMultiplier The maximum multiplier of this account
603 	 * @return The maximum burn amount
604 	 */
605 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
606 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
607 	}
608 
609 	/**
610 	 * @dev Calculate the new multiplier after burning primordial ion
611 	 *		_primordialBalance = P
612 	 *		_currentWeightedMultiplier = M
613 	 *		_amountToBurn = B
614 	 *		_newMultiplier = E
615 	 *		E = (P x M) / (P - B)
616 	 *
617 	 * @param _primordialBalance Account's primordial ion balance
618 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
619 	 * @param _amountToBurn The amount of primordial ion to burn
620 	 * @return The new multiplier
621 	 */
622 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
623 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
624 	}
625 
626 	/**
627 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
628 	 *		_primordialBalance = P
629 	 *		_currentWeightedMultiplier = M
630 	 *		_amountToConvert = C
631 	 *		_newMultiplier = E
632 	 *		E = (P x M) / (P + C)
633 	 *
634 	 * @param _primordialBalance Account's primordial ion balance
635 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
636 	 * @param _amountToConvert The amount of network ion to convert
637 	 * @return The new multiplier
638 	 */
639 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
640 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
641 	}
642 
643 	/**
644 	 * @dev count num of digits
645 	 * @param number uint256 of the nuumber to be checked
646 	 * @return uint8 num of digits
647 	 */
648 	function numDigits(uint256 number) public pure returns (uint8) {
649 		uint8 digits = 0;
650 		while(number != 0) {
651 			number = number.div(10);
652 			digits++;
653 		}
654 		return digits;
655 	}
656 }
657 
658 
659 
660 contract TheAO {
661 	address public theAO;
662 	address public nameTAOPositionAddress;
663 
664 	// Check whether an address is whitelisted and granted access to transact
665 	// on behalf of others
666 	mapping (address => bool) public whitelist;
667 
668 	constructor() public {
669 		theAO = msg.sender;
670 	}
671 
672 	/**
673 	 * @dev Checks if msg.sender is in whitelist.
674 	 */
675 	modifier inWhitelist() {
676 		require (whitelist[msg.sender] == true);
677 		_;
678 	}
679 
680 	/**
681 	 * @dev Transfer ownership of The AO to new address
682 	 * @param _theAO The new address to be transferred
683 	 */
684 	function transferOwnership(address _theAO) public {
685 		require (msg.sender == theAO);
686 		require (_theAO != address(0));
687 		theAO = _theAO;
688 	}
689 
690 	/**
691 	 * @dev Whitelist `_account` address to transact on behalf of others
692 	 * @param _account The address to whitelist
693 	 * @param _whitelist Either to whitelist or not
694 	 */
695 	function setWhitelist(address _account, bool _whitelist) public {
696 		require (msg.sender == theAO);
697 		require (_account != address(0));
698 		whitelist[_account] = _whitelist;
699 	}
700 }
701 
702 
703 /**
704  * @title TAOCurrency
705  */
706 contract TAOCurrency is TheAO {
707 	using SafeMath for uint256;
708 
709 	// Public variables of the contract
710 	string public name;
711 	string public symbol;
712 	uint8 public decimals;
713 
714 	// To differentiate denomination of TAO Currency
715 	uint256 public powerOfTen;
716 
717 	uint256 public totalSupply;
718 
719 	// This creates an array with all balances
720 	// address is the address of nameId, not the eth public address
721 	mapping (address => uint256) public balanceOf;
722 
723 	// This generates a public event on the blockchain that will notify clients
724 	// address is the address of TAO/Name Id, not eth public address
725 	event Transfer(address indexed from, address indexed to, uint256 value);
726 
727 	// This notifies clients about the amount burnt
728 	// address is the address of TAO/Name Id, not eth public address
729 	event Burn(address indexed from, uint256 value);
730 
731 	/**
732 	 * Constructor function
733 	 *
734 	 * Initializes contract with initial supply TAOCurrency to the creator of the contract
735 	 */
736 	constructor (string memory _name, string memory _symbol, address _nameTAOPositionAddress) public {
737 		name = _name;		// Set the name for display purposes
738 		symbol = _symbol;	// Set the symbol for display purposes
739 
740 		powerOfTen = 0;
741 		decimals = 0;
742 
743 		setNameTAOPositionAddress(_nameTAOPositionAddress);
744 	}
745 
746 	/**
747 	 * @dev Checks if the calling contract address is The AO
748 	 *		OR
749 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
750 	 */
751 	modifier onlyTheAO {
752 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
753 		_;
754 	}
755 
756 	/**
757 	 * @dev Check if `_id` is a Name or a TAO
758 	 */
759 	modifier isNameOrTAO(address _id) {
760 		require (AOLibrary.isName(_id) || AOLibrary.isTAO(_id));
761 		_;
762 	}
763 
764 	/***** The AO ONLY METHODS *****/
765 	/**
766 	 * @dev Transfer ownership of The AO to new address
767 	 * @param _theAO The new address to be transferred
768 	 */
769 	function transferOwnership(address _theAO) public onlyTheAO {
770 		require (_theAO != address(0));
771 		theAO = _theAO;
772 	}
773 
774 	/**
775 	 * @dev Whitelist `_account` address to transact on behalf of others
776 	 * @param _account The address to whitelist
777 	 * @param _whitelist Either to whitelist or not
778 	 */
779 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
780 		require (_account != address(0));
781 		whitelist[_account] = _whitelist;
782 	}
783 
784 	/**
785 	 * @dev The AO set the NameTAOPosition Address
786 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
787 	 */
788 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
789 		require (_nameTAOPositionAddress != address(0));
790 		nameTAOPositionAddress = _nameTAOPositionAddress;
791 	}
792 
793 	/***** PUBLIC METHODS *****/
794 	/**
795 	 * @dev transfer TAOCurrency from other address
796 	 *
797 	 * Send `_value` TAOCurrency to `_to` in behalf of `_from`
798 	 *
799 	 * @param _from The address of the sender
800 	 * @param _to The address of the recipient
801 	 * @param _value the amount to send
802 	 */
803 	function transferFrom(address _from, address _to, uint256 _value) public inWhitelist isNameOrTAO(_from) isNameOrTAO(_to) returns (bool) {
804 		_transfer(_from, _to, _value);
805 		return true;
806 	}
807 
808 	/**
809 	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
810 	 * @param target Address to receive TAOCurrency
811 	 * @param mintedAmount The amount of TAOCurrency it will receive
812 	 * @return true on success
813 	 */
814 	function mint(address target, uint256 mintedAmount) public inWhitelist isNameOrTAO(target) returns (bool) {
815 		_mint(target, mintedAmount);
816 		return true;
817 	}
818 
819 	/**
820 	 *
821 	 * @dev Whitelisted address remove `_value` TAOCurrency from the system irreversibly on behalf of `_from`.
822 	 *
823 	 * @param _from the address of the sender
824 	 * @param _value the amount of money to burn
825 	 */
826 	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist isNameOrTAO(_from) returns (bool success) {
827 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
828 		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
829 		totalSupply = totalSupply.sub(_value);              // Update totalSupply
830 		emit Burn(_from, _value);
831 		return true;
832 	}
833 
834 	/***** INTERNAL METHODS *****/
835 	/**
836 	 * @dev Send `_value` TAOCurrency from `_from` to `_to`
837 	 * @param _from The address of sender
838 	 * @param _to The address of the recipient
839 	 * @param _value The amount to send
840 	 */
841 	function _transfer(address _from, address _to, uint256 _value) internal {
842 		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
843 		require (balanceOf[_from] >= _value);					// Check if the sender has enough
844 		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
845 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
846 		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
847 		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
848 		emit Transfer(_from, _to, _value);
849 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
850 	}
851 
852 	/**
853 	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
854 	 * @param target Address to receive TAOCurrency
855 	 * @param mintedAmount The amount of TAOCurrency it will receive
856 	 */
857 	function _mint(address target, uint256 mintedAmount) internal {
858 		balanceOf[target] = balanceOf[target].add(mintedAmount);
859 		totalSupply = totalSupply.add(mintedAmount);
860 		emit Transfer(address(0), address(this), mintedAmount);
861 		emit Transfer(address(this), target, mintedAmount);
862 	}
863 }
864 
865 
866 
867 
868 
869 contract Logos is TAOCurrency {
870 	address public nameFactoryAddress;
871 	address public nameAccountRecoveryAddress;
872 
873 	INameFactory internal _nameFactory;
874 	INameTAOPosition internal _nameTAOPosition;
875 	INameAccountRecovery internal _nameAccountRecovery;
876 
877 	// Mapping of a Name ID to the amount of Logos positioned by others to itself
878 	// address is the address of nameId, not the eth public address
879 	mapping (address => uint256) public positionFromOthers;
880 
881 	// Mapping of Name ID to other Name ID and the amount of Logos positioned by itself
882 	mapping (address => mapping(address => uint256)) public positionOnOthers;
883 
884 	// Mapping of a Name ID to the total amount of Logos positioned by itself on others
885 	mapping (address => uint256) public totalPositionOnOthers;
886 
887 	// Mapping of Name ID to it's advocated TAO ID and the amount of Logos earned
888 	mapping (address => mapping(address => uint256)) public advocatedTAOLogos;
889 
890 	// Mapping of a Name ID to the total amount of Logos earned from advocated TAO
891 	mapping (address => uint256) public totalAdvocatedTAOLogos;
892 
893 	// Event broadcasted to public when `from` address position `value` Logos to `to`
894 	event PositionFrom(address indexed from, address indexed to, uint256 value);
895 
896 	// Event broadcasted to public when `from` address unposition `value` Logos from `to`
897 	event UnpositionFrom(address indexed from, address indexed to, uint256 value);
898 
899 	// Event broadcasted to public when `nameId` receives `amount` of Logos from advocating `taoId`
900 	event AddAdvocatedTAOLogos(address indexed nameId, address indexed taoId, uint256 amount);
901 
902 	// Event broadcasted to public when Logos from advocating `taoId` is transferred from `fromNameId` to `toNameId`
903 	event TransferAdvocatedTAOLogos(address indexed fromNameId, address indexed toNameId, address indexed taoId, uint256 amount);
904 
905 	/**
906 	 * @dev Constructor function
907 	 */
908 	constructor(string memory _name, string memory _symbol, address _nameFactoryAddress, address _nameTAOPositionAddress)
909 		TAOCurrency(_name, _symbol, _nameTAOPositionAddress) public {
910 		setNameFactoryAddress(_nameFactoryAddress);
911 		setNameTAOPositionAddress(_nameTAOPositionAddress);
912 	}
913 
914 	/**
915 	 * @dev Check if `_taoId` is a TAO
916 	 */
917 	modifier isTAO(address _taoId) {
918 		require (AOLibrary.isTAO(_taoId));
919 		_;
920 	}
921 
922 	/**
923 	 * @dev Check if `_nameId` is a Name
924 	 */
925 	modifier isName(address _nameId) {
926 		require (AOLibrary.isName(_nameId));
927 		_;
928 	}
929 
930 	/**
931 	 * @dev Check if msg.sender is the current advocate of _id
932 	 */
933 	modifier onlyAdvocate(address _id) {
934 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _id));
935 		_;
936 	}
937 
938 	/**
939 	 * @dev Only allowed if Name is not compromised
940 	 */
941 	modifier nameNotCompromised(address _id) {
942 		require (!_nameAccountRecovery.isCompromised(_id));
943 		_;
944 	}
945 
946 	/**
947 	 * @dev Only allowed if sender's Name is not compromised
948 	 */
949 	modifier senderNameNotCompromised() {
950 		require (!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
951 		_;
952 	}
953 
954 	/***** THE AO ONLY METHODS *****/
955 	/**
956 	 * @dev The AO sets NameFactory address
957 	 * @param _nameFactoryAddress The address of NameFactory
958 	 */
959 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
960 		require (_nameFactoryAddress != address(0));
961 		nameFactoryAddress = _nameFactoryAddress;
962 		_nameFactory = INameFactory(_nameFactoryAddress);
963 	}
964 
965 	/**
966 	 * @dev The AO set the NameTAOPosition Address
967 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
968 	 */
969 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
970 		require (_nameTAOPositionAddress != address(0));
971 		nameTAOPositionAddress = _nameTAOPositionAddress;
972 		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
973 	}
974 
975 	/**
976 	 * @dev The AO set the NameAccountRecovery Address
977 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
978 	 */
979 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
980 		require (_nameAccountRecoveryAddress != address(0));
981 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
982 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
983 	}
984 
985 	/***** PUBLIC METHODS *****/
986 	/**
987 	 * @dev Get the total sum of Logos for an address
988 	 * @param _target The address to check
989 	 * @return The total sum of Logos (own + positioned + advocated TAOs)
990 	 */
991 	function sumBalanceOf(address _target) public isName(_target) view returns (uint256) {
992 		return balanceOf[_target].add(positionFromOthers[_target]).add(totalAdvocatedTAOLogos[_target]);
993 	}
994 
995 	/**
996 	 * @dev Return the amount of Logos that are available to be positioned on other
997 	 * @param _sender The sender address to check
998 	 * @return The amount of Logos that are available to be positioned on other
999 	 */
1000 	function availableToPositionAmount(address _sender) public isName(_sender) view returns (uint256) {
1001 		return balanceOf[_sender].sub(totalPositionOnOthers[_sender]);
1002 	}
1003 
1004 	/**
1005 	 * @dev `_from` Name position `_value` Logos onto `_to` Name
1006 	 *
1007 	 * @param _from The address of the sender
1008 	 * @param _to The address of the recipient
1009 	 * @param _value the amount to position
1010 	 * @return true on success
1011 	 */
1012 	function positionFrom(address _from, address _to, uint256 _value) public isName(_from) isName(_to) nameNotCompromised(_from) nameNotCompromised(_to) onlyAdvocate(_from) senderNameNotCompromised returns (bool) {
1013 		require (_from != _to);	// Can't position Logos to itself
1014 		require (availableToPositionAmount(_from) >= _value); // should have enough balance to position
1015 		require (positionFromOthers[_to].add(_value) >= positionFromOthers[_to]); // check for overflows
1016 
1017 		positionOnOthers[_from][_to] = positionOnOthers[_from][_to].add(_value);
1018 		totalPositionOnOthers[_from] = totalPositionOnOthers[_from].add(_value);
1019 		positionFromOthers[_to] = positionFromOthers[_to].add(_value);
1020 
1021 		emit PositionFrom(_from, _to, _value);
1022 		return true;
1023 	}
1024 
1025 	/**
1026 	 * @dev `_from` Name unposition `_value` Logos from `_to` Name
1027 	 *
1028 	 * @param _from The address of the sender
1029 	 * @param _to The address of the recipient
1030 	 * @param _value the amount to unposition
1031 	 * @return true on success
1032 	 */
1033 	function unpositionFrom(address _from, address _to, uint256 _value) public isName(_from) isName(_to) nameNotCompromised(_from) nameNotCompromised(_to) onlyAdvocate(_from) senderNameNotCompromised returns (bool) {
1034 		require (_from != _to);	// Can't unposition Logos to itself
1035 		require (positionOnOthers[_from][_to] >= _value);
1036 
1037 		positionOnOthers[_from][_to] = positionOnOthers[_from][_to].sub(_value);
1038 		totalPositionOnOthers[_from] = totalPositionOnOthers[_from].sub(_value);
1039 		positionFromOthers[_to] = positionFromOthers[_to].sub(_value);
1040 
1041 		emit UnpositionFrom(_from, _to, _value);
1042 		return true;
1043 	}
1044 
1045 	/**
1046 	 * @dev Add `_amount` logos earned from advocating a TAO `_taoId` to its Advocate
1047 	 * @param _taoId The ID of the advocated TAO
1048 	 * @param _amount the amount to reward
1049 	 * @return true on success
1050 	 */
1051 	function addAdvocatedTAOLogos(address _taoId, uint256 _amount) public inWhitelist isTAO(_taoId) returns (bool) {
1052 		require (_amount > 0);
1053 		address _nameId = _nameTAOPosition.getAdvocate(_taoId);
1054 
1055 		advocatedTAOLogos[_nameId][_taoId] = advocatedTAOLogos[_nameId][_taoId].add(_amount);
1056 		totalAdvocatedTAOLogos[_nameId] = totalAdvocatedTAOLogos[_nameId].add(_amount);
1057 
1058 		emit AddAdvocatedTAOLogos(_nameId, _taoId, _amount);
1059 		return true;
1060 	}
1061 
1062 	/**
1063 	 * @dev Transfer logos earned from advocating a TAO `_taoId` from `_fromNameId` to the Advocate of `_taoId`
1064 	 * @param _fromNameId The ID of the Name that sends the Logos
1065 	 * @param _taoId The ID of the advocated TAO
1066 	 * @return true on success
1067 	 */
1068 	function transferAdvocatedTAOLogos(address _fromNameId, address _taoId) public inWhitelist isName(_fromNameId) isTAO(_taoId) returns (bool) {
1069 		address _toNameId = _nameTAOPosition.getAdvocate(_taoId);
1070 		require (_fromNameId != _toNameId);
1071 		require (totalAdvocatedTAOLogos[_fromNameId] >= advocatedTAOLogos[_fromNameId][_taoId]);
1072 
1073 		uint256 _amount = advocatedTAOLogos[_fromNameId][_taoId];
1074 		advocatedTAOLogos[_fromNameId][_taoId] = 0;
1075 		totalAdvocatedTAOLogos[_fromNameId] = totalAdvocatedTAOLogos[_fromNameId].sub(_amount);
1076 		advocatedTAOLogos[_toNameId][_taoId] = advocatedTAOLogos[_toNameId][_taoId].add(_amount);
1077 		totalAdvocatedTAOLogos[_toNameId] = totalAdvocatedTAOLogos[_toNameId].add(_amount);
1078 
1079 		emit TransferAdvocatedTAOLogos(_fromNameId, _toNameId, _taoId, _amount);
1080 		return true;
1081 	}
1082 }