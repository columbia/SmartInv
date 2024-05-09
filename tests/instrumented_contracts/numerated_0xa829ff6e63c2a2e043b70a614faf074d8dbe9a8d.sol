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
70 interface IAOSetting {
71 	function getSettingValuesByTAOName(address _taoId, string calldata _settingName) external view returns (uint256, bool, address, bytes32, string memory);
72 	function getSettingTypes() external view returns (uint8, uint8, uint8, uint8, uint8);
73 
74 	function settingTypeLookup(uint256 _settingId) external view returns (uint8);
75 }
76 
77 
78 interface INamePublicKey {
79 	function initialize(address _id, address _defaultKey, address _writerKey) external returns (bool);
80 
81 	function isKeyExist(address _id, address _key) external view returns (bool);
82 
83 	function getDefaultKey(address _id) external view returns (address);
84 
85 	function whitelistAddKey(address _id, address _key) external returns (bool);
86 }
87 
88 
89 interface INameFactory {
90 	function nonces(address _nameId) external view returns (uint256);
91 	function incrementNonce(address _nameId) external returns (uint256);
92 	function ethAddressToNameId(address _ethAddress) external view returns (address);
93 	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
94 	function nameIdToEthAddress(address _nameId) external view returns (address);
95 }
96 
97 
98 interface INameAccountRecovery {
99 	function isCompromised(address _id) external view returns (bool);
100 }
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
112 
113 
114 contract TokenERC20 {
115 	// Public variables of the token
116 	string public name;
117 	string public symbol;
118 	uint8 public decimals = 18;
119 	// 18 decimals is the strongly suggested default, avoid changing it
120 	uint256 public totalSupply;
121 
122 	// This creates an array with all balances
123 	mapping (address => uint256) public balanceOf;
124 	mapping (address => mapping (address => uint256)) public allowance;
125 
126 	// This generates a public event on the blockchain that will notify clients
127 	event Transfer(address indexed from, address indexed to, uint256 value);
128 
129 	// This generates a public event on the blockchain that will notify clients
130 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
131 
132 	// This notifies clients about the amount burnt
133 	event Burn(address indexed from, uint256 value);
134 
135 	/**
136 	 * Constructor function
137 	 *
138 	 * Initializes contract with initial supply tokens to the creator of the contract
139 	 */
140 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
141 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
142 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
143 		name = tokenName;                                   // Set the name for display purposes
144 		symbol = tokenSymbol;                               // Set the symbol for display purposes
145 	}
146 
147 	/**
148 	 * Internal transfer, only can be called by this contract
149 	 */
150 	function _transfer(address _from, address _to, uint _value) internal {
151 		// Prevent transfer to 0x0 address. Use burn() instead
152 		require(_to != address(0));
153 		// Check if the sender has enough
154 		require(balanceOf[_from] >= _value);
155 		// Check for overflows
156 		require(balanceOf[_to] + _value > balanceOf[_to]);
157 		// Save this for an assertion in the future
158 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
159 		// Subtract from the sender
160 		balanceOf[_from] -= _value;
161 		// Add the same to the recipient
162 		balanceOf[_to] += _value;
163 		emit Transfer(_from, _to, _value);
164 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
165 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
166 	}
167 
168 	/**
169 	 * Transfer tokens
170 	 *
171 	 * Send `_value` tokens to `_to` from your account
172 	 *
173 	 * @param _to The address of the recipient
174 	 * @param _value the amount to send
175 	 */
176 	function transfer(address _to, uint256 _value) public returns (bool success) {
177 		_transfer(msg.sender, _to, _value);
178 		return true;
179 	}
180 
181 	/**
182 	 * Transfer tokens from other address
183 	 *
184 	 * Send `_value` tokens to `_to` in behalf of `_from`
185 	 *
186 	 * @param _from The address of the sender
187 	 * @param _to The address of the recipient
188 	 * @param _value the amount to send
189 	 */
190 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
191 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
192 		allowance[_from][msg.sender] -= _value;
193 		_transfer(_from, _to, _value);
194 		return true;
195 	}
196 
197 	/**
198 	 * Set allowance for other address
199 	 *
200 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
201 	 *
202 	 * @param _spender The address authorized to spend
203 	 * @param _value the max amount they can spend
204 	 */
205 	function approve(address _spender, uint256 _value) public returns (bool success) {
206 		allowance[msg.sender][_spender] = _value;
207 		emit Approval(msg.sender, _spender, _value);
208 		return true;
209 	}
210 
211 	/**
212 	 * Set allowance for other address and notify
213 	 *
214 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
215 	 *
216 	 * @param _spender The address authorized to spend
217 	 * @param _value the max amount they can spend
218 	 * @param _extraData some extra information to send to the approved contract
219 	 */
220 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
221 		tokenRecipient spender = tokenRecipient(_spender);
222 		if (approve(_spender, _value)) {
223 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
224 			return true;
225 		}
226 	}
227 
228 	/**
229 	 * Destroy tokens
230 	 *
231 	 * Remove `_value` tokens from the system irreversibly
232 	 *
233 	 * @param _value the amount of money to burn
234 	 */
235 	function burn(uint256 _value) public returns (bool success) {
236 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
237 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
238 		totalSupply -= _value;                      // Updates totalSupply
239 		emit Burn(msg.sender, _value);
240 		return true;
241 	}
242 
243 	/**
244 	 * Destroy tokens from other account
245 	 *
246 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
247 	 *
248 	 * @param _from the address of the sender
249 	 * @param _value the amount of money to burn
250 	 */
251 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
252 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
253 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
254 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
255 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
256 		totalSupply -= _value;                              // Update totalSupply
257 		emit Burn(_from, _value);
258 		return true;
259 	}
260 }
261 
262 
263 /**
264  * @title TAO
265  */
266 contract TAO {
267 	using SafeMath for uint256;
268 
269 	address public vaultAddress;
270 	string public name;				// the name for this TAO
271 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
272 
273 	// TAO's data
274 	string public datHash;
275 	string public database;
276 	string public keyValue;
277 	bytes32 public contentId;
278 
279 	/**
280 	 * 0 = TAO
281 	 * 1 = Name
282 	 */
283 	uint8 public typeId;
284 
285 	/**
286 	 * @dev Constructor function
287 	 */
288 	constructor (string memory _name,
289 		address _originId,
290 		string memory _datHash,
291 		string memory _database,
292 		string memory _keyValue,
293 		bytes32 _contentId,
294 		address _vaultAddress
295 	) public {
296 		name = _name;
297 		originId = _originId;
298 		datHash = _datHash;
299 		database = _database;
300 		keyValue = _keyValue;
301 		contentId = _contentId;
302 
303 		// Creating TAO
304 		typeId = 0;
305 
306 		vaultAddress = _vaultAddress;
307 	}
308 
309 	/**
310 	 * @dev Checks if calling address is Vault contract
311 	 */
312 	modifier onlyVault {
313 		require (msg.sender == vaultAddress);
314 		_;
315 	}
316 
317 	/**
318 	 * Will receive any ETH sent
319 	 */
320 	function () external payable {
321 	}
322 
323 	/**
324 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
325 	 * @param _recipient The recipient address
326 	 * @param _amount The amount to transfer
327 	 * @return true on success
328 	 */
329 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
330 		_recipient.transfer(_amount);
331 		return true;
332 	}
333 
334 	/**
335 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
336 	 * @param _erc20TokenAddress The address of ERC20 Token
337 	 * @param _recipient The recipient address
338 	 * @param _amount The amount to transfer
339 	 * @return true on success
340 	 */
341 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
342 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
343 		_erc20.transfer(_recipient, _amount);
344 		return true;
345 	}
346 }
347 
348 
349 
350 
351 /**
352  * @title Name
353  */
354 contract Name is TAO {
355 	/**
356 	 * @dev Constructor function
357 	 */
358 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
359 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
360 		// Creating Name
361 		typeId = 1;
362 	}
363 }
364 
365 
366 
367 
368 /**
369  * @title AOLibrary
370  */
371 library AOLibrary {
372 	using SafeMath for uint256;
373 
374 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
375 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
376 
377 	/**
378 	 * @dev Check whether or not the given TAO ID is a TAO
379 	 * @param _taoId The ID of the TAO
380 	 * @return true if yes. false otherwise
381 	 */
382 	function isTAO(address _taoId) public view returns (bool) {
383 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
384 	}
385 
386 	/**
387 	 * @dev Check whether or not the given Name ID is a Name
388 	 * @param _nameId The ID of the Name
389 	 * @return true if yes. false otherwise
390 	 */
391 	function isName(address _nameId) public view returns (bool) {
392 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
393 	}
394 
395 	/**
396 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
397 	 * @param _tokenAddress The ERC20 Token address to check
398 	 */
399 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
400 		if (_tokenAddress == address(0)) {
401 			return false;
402 		}
403 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
404 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
405 	}
406 
407 	/**
408 	 * @dev Checks if the calling contract address is The AO
409 	 *		OR
410 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
411 	 * @param _sender The address to check
412 	 * @param _theAO The AO address
413 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
414 	 * @return true if yes, false otherwise
415 	 */
416 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
417 		return (_sender == _theAO ||
418 			(
419 				(isTAO(_theAO) || isName(_theAO)) &&
420 				_nameTAOPositionAddress != address(0) &&
421 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
422 			)
423 		);
424 	}
425 
426 	/**
427 	 * @dev Return the divisor used to correctly calculate percentage.
428 	 *		Percentage stored throughout AO contracts covers 4 decimals,
429 	 *		so 1% is 10000, 1.25% is 12500, etc
430 	 */
431 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
432 		return _PERCENTAGE_DIVISOR;
433 	}
434 
435 	/**
436 	 * @dev Return the divisor used to correctly calculate multiplier.
437 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
438 	 *		so 1 is 1000000, 0.023 is 23000, etc
439 	 */
440 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
441 		return _MULTIPLIER_DIVISOR;
442 	}
443 
444 	/**
445 	 * @dev deploy a TAO
446 	 * @param _name The name of the TAO
447 	 * @param _originId The Name ID the creates the TAO
448 	 * @param _datHash The datHash of this TAO
449 	 * @param _database The database for this TAO
450 	 * @param _keyValue The key/value pair to be checked on the database
451 	 * @param _contentId The contentId related to this TAO
452 	 * @param _nameTAOVaultAddress The address of NameTAOVault
453 	 */
454 	function deployTAO(string memory _name,
455 		address _originId,
456 		string memory _datHash,
457 		string memory _database,
458 		string memory _keyValue,
459 		bytes32 _contentId,
460 		address _nameTAOVaultAddress
461 		) public returns (TAO _tao) {
462 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
463 	}
464 
465 	/**
466 	 * @dev deploy a Name
467 	 * @param _name The name of the Name
468 	 * @param _originId The eth address the creates the Name
469 	 * @param _datHash The datHash of this Name
470 	 * @param _database The database for this Name
471 	 * @param _keyValue The key/value pair to be checked on the database
472 	 * @param _contentId The contentId related to this Name
473 	 * @param _nameTAOVaultAddress The address of NameTAOVault
474 	 */
475 	function deployName(string memory _name,
476 		address _originId,
477 		string memory _datHash,
478 		string memory _database,
479 		string memory _keyValue,
480 		bytes32 _contentId,
481 		address _nameTAOVaultAddress
482 		) public returns (Name _myName) {
483 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
484 	}
485 
486 	/**
487 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
488 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
489 	 * @param _currentPrimordialBalance Account's current primordial ion balance
490 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
491 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
492 	 * @return the new primordial weighted multiplier
493 	 */
494 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
495 		if (_currentWeightedMultiplier > 0) {
496 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
497 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
498 			return _totalWeightedIons.div(_totalIons);
499 		} else {
500 			return _additionalWeightedMultiplier;
501 		}
502 	}
503 
504 	/**
505 	 * @dev Calculate the primordial ion multiplier on a given lot
506 	 *		Total Primordial Mintable = T
507 	 *		Total Primordial Minted = M
508 	 *		Starting Multiplier = S
509 	 *		Ending Multiplier = E
510 	 *		To Purchase = P
511 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
512 	 *
513 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
514 	 * @param _totalPrimordialMintable Total Primordial ion mintable
515 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
516 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
517 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
518 	 * @return The multiplier in (10 ** 6)
519 	 */
520 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
521 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
522 			/**
523 			 * Let temp = M + (P/2)
524 			 * Multiplier = (1 - (temp / T)) x (S-E)
525 			 */
526 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
527 
528 			/**
529 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
530 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
531 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
532 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
533 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
534 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
535 			 */
536 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
537 			/**
538 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
539 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
540 			 */
541 			return multiplier.div(_MULTIPLIER_DIVISOR);
542 		} else {
543 			return 0;
544 		}
545 	}
546 
547 	/**
548 	 * @dev Calculate the bonus percentage of network ion on a given lot
549 	 *		Total Primordial Mintable = T
550 	 *		Total Primordial Minted = M
551 	 *		Starting Network Bonus Multiplier = Bs
552 	 *		Ending Network Bonus Multiplier = Be
553 	 *		To Purchase = P
554 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
555 	 *
556 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
557 	 * @param _totalPrimordialMintable Total Primordial ion intable
558 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
559 	 * @param _startingMultiplier The starting Network ion bonus multiplier
560 	 * @param _endingMultiplier The ending Network ion bonus multiplier
561 	 * @return The bonus percentage
562 	 */
563 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
564 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
565 			/**
566 			 * Let temp = M + (P/2)
567 			 * B% = (1 - (temp / T)) x (Bs-Be)
568 			 */
569 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
570 
571 			/**
572 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
573 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
574 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
575 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
576 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
577 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
578 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
579 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
580 			 */
581 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
582 			return bonusPercentage;
583 		} else {
584 			return 0;
585 		}
586 	}
587 
588 	/**
589 	 * @dev Calculate the bonus amount of network ion on a given lot
590 	 *		AO Bonus Amount = B% x P
591 	 *
592 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
593 	 * @param _totalPrimordialMintable Total Primordial ion intable
594 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
595 	 * @param _startingMultiplier The starting Network ion bonus multiplier
596 	 * @param _endingMultiplier The ending Network ion bonus multiplier
597 	 * @return The bonus percentage
598 	 */
599 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
600 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
601 		/**
602 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
603 		 * when calculating the network ion bonus amount
604 		 */
605 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
606 		return networkBonus;
607 	}
608 
609 	/**
610 	 * @dev Calculate the maximum amount of Primordial an account can burn
611 	 *		_primordialBalance = P
612 	 *		_currentWeightedMultiplier = M
613 	 *		_maximumMultiplier = S
614 	 *		_amountToBurn = B
615 	 *		B = ((S x P) - (P x M)) / S
616 	 *
617 	 * @param _primordialBalance Account's primordial ion balance
618 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
619 	 * @param _maximumMultiplier The maximum multiplier of this account
620 	 * @return The maximum burn amount
621 	 */
622 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
623 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
624 	}
625 
626 	/**
627 	 * @dev Calculate the new multiplier after burning primordial ion
628 	 *		_primordialBalance = P
629 	 *		_currentWeightedMultiplier = M
630 	 *		_amountToBurn = B
631 	 *		_newMultiplier = E
632 	 *		E = (P x M) / (P - B)
633 	 *
634 	 * @param _primordialBalance Account's primordial ion balance
635 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
636 	 * @param _amountToBurn The amount of primordial ion to burn
637 	 * @return The new multiplier
638 	 */
639 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
640 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
641 	}
642 
643 	/**
644 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
645 	 *		_primordialBalance = P
646 	 *		_currentWeightedMultiplier = M
647 	 *		_amountToConvert = C
648 	 *		_newMultiplier = E
649 	 *		E = (P x M) / (P + C)
650 	 *
651 	 * @param _primordialBalance Account's primordial ion balance
652 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
653 	 * @param _amountToConvert The amount of network ion to convert
654 	 * @return The new multiplier
655 	 */
656 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
657 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
658 	}
659 
660 	/**
661 	 * @dev count num of digits
662 	 * @param number uint256 of the nuumber to be checked
663 	 * @return uint8 num of digits
664 	 */
665 	function numDigits(uint256 number) public pure returns (uint8) {
666 		uint8 digits = 0;
667 		while(number != 0) {
668 			number = number.div(10);
669 			digits++;
670 		}
671 		return digits;
672 	}
673 }
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
724 
725 /**
726  * @title NameAccountRecovery
727  */
728 contract NameAccountRecovery is TheAO {
729 	using SafeMath for uint256;
730 
731 	address public settingTAOId;
732 	address public nameFactoryAddress;
733 	address public nameTAOPositionAddress;
734 	address public namePublicKeyAddress;
735 	address public aoSettingAddress;
736 
737 	INameFactory internal _nameFactory;
738 	INameTAOPosition internal _nameTAOPosition;
739 	INamePublicKey internal _namePublicKey;
740 	IAOSetting internal _aoSetting;
741 
742 	struct AccountRecovery {
743 		// If submitted, then Name is locked until lockedUntilTimestamp
744 		// and if no action is taken by the Speaker, then the current
745 		// eth address associated with the Name can resume operation
746 		bool submitted;
747 		uint256 submittedTimestamp;		// Timestamp when this account recovery is submitted
748 		uint256 lockedUntilTimestamp;	// The deadline for the current Speaker of Name to respond and replace the new eth address
749 	}
750 
751 	mapping (address => AccountRecovery) internal accountRecoveries;
752 
753 	// Event to be broadcasted to public when current Listener of Name submitted account recovery for a Name
754 	event SubmitAccountRecovery(address indexed nameId, address listenerId, bool compromised, uint256 submittedTimestamp, uint256 lockedUntilTimestamp, uint256 nonce);
755 
756 	// Event to be broadcasted to public when current Speaker of Name set new ETH Address for a Name
757 	event SetNameNewAddress(address indexed nameId, address speakerId, address newAddress, uint256 timestamp, uint256 nonce);
758 
759 	/**
760 	 * @dev Constructor function
761 	 */
762 	constructor(address _nameFactoryAddress, address _nameTAOPositionAddress) public {
763 		setNameFactoryAddress(_nameFactoryAddress);
764 		setNameTAOPositionAddress(_nameTAOPositionAddress);
765 	}
766 
767 	/**
768 	 * @dev Checks if the calling contract address is The AO
769 	 *		OR
770 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
771 	 */
772 	modifier onlyTheAO {
773 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
774 		_;
775 	}
776 
777 	/**
778 	 * @dev Check if calling address is Factory
779 	 */
780 	modifier onlyFactory {
781 		require (msg.sender == nameFactoryAddress);
782 		_;
783 	}
784 
785 	/**
786 	 * @dev Check is msg.sender address is a Name
787 	 */
788 	 modifier senderIsName() {
789 		require (_nameFactory.ethAddressToNameId(msg.sender) != address(0));
790 		_;
791 	 }
792 
793 	/**
794 	 * @dev Check if `_nameId` is a Name
795 	 */
796 	modifier isName(address _nameId) {
797 		require (AOLibrary.isName(_nameId));
798 		_;
799 	}
800 
801 	/***** The AO ONLY METHODS *****/
802 	/**
803 	 * @dev Transfer ownership of The AO to new address
804 	 * @param _theAO The new address to be transferred
805 	 */
806 	function transferOwnership(address _theAO) public onlyTheAO {
807 		require (_theAO != address(0));
808 		theAO = _theAO;
809 	}
810 
811 	/**
812 	 * @dev Whitelist `_account` address to transact on behalf of others
813 	 * @param _account The address to whitelist
814 	 * @param _whitelist Either to whitelist or not
815 	 */
816 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
817 		require (_account != address(0));
818 		whitelist[_account] = _whitelist;
819 	}
820 
821 	/**
822 	 * @dev The AO set the NameFactory Address
823 	 * @param _nameFactoryAddress The address of NameFactory
824 	 */
825 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
826 		require (_nameFactoryAddress != address(0));
827 		nameFactoryAddress = _nameFactoryAddress;
828 		_nameFactory = INameFactory(_nameFactoryAddress);
829 	}
830 
831 	/**
832 	 * @dev The AO set the NameTAOPosition Address
833 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
834 	 */
835 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
836 		require (_nameTAOPositionAddress != address(0));
837 		nameTAOPositionAddress = _nameTAOPositionAddress;
838 		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
839 	}
840 
841 	/**
842 	 * @dev The AO set the NamePublicKey Address
843 	 * @param _namePublicKeyAddress The address of NamePublicKey
844 	 */
845 	function setNamePublicKeyAddress(address _namePublicKeyAddress) public onlyTheAO {
846 		require (_namePublicKeyAddress != address(0));
847 		namePublicKeyAddress = _namePublicKeyAddress;
848 		_namePublicKey = INamePublicKey(_namePublicKeyAddress);
849 	}
850 
851 	/**
852 	 * @dev The AO sets setting TAO ID
853 	 * @param _settingTAOId The new setting TAO ID to set
854 	 */
855 	function setSettingTAOId(address _settingTAOId) public onlyTheAO {
856 		require (AOLibrary.isTAO(_settingTAOId));
857 		settingTAOId = _settingTAOId;
858 	}
859 
860 	/**
861 	 * @dev The AO sets AO Setting address
862 	 * @param _aoSettingAddress The address of AOSetting
863 	 */
864 	function setAOSettingAddress(address _aoSettingAddress) public onlyTheAO {
865 		require (_aoSettingAddress != address(0));
866 		aoSettingAddress = _aoSettingAddress;
867 		_aoSetting = IAOSetting(_aoSettingAddress);
868 	}
869 
870 	/***** PUBLIC METHODS *****/
871 	/**
872 	 * @dev Get AccountRecovery information given a Name ID
873 	 * @param _id The ID of the Name
874 	 * @return the submit status of the account recovery
875 	 * @return submittedTimestamp - Timestamp when this account recovery is submitted
876 	 * @return lockedUntilTimestamp - The deadline for the current Speaker of Name to respond and replace the new eth address
877 	 */
878 	function getAccountRecovery(address _id) public isName(_id) view returns (bool, uint256, uint256) {
879 		AccountRecovery memory _accountRecovery = accountRecoveries[_id];
880 		return (
881 			_accountRecovery.submitted,
882 			_accountRecovery.submittedTimestamp,
883 			_accountRecovery.lockedUntilTimestamp
884 		);
885 	}
886 
887 	/**
888 	 * @dev Listener of Name submits an account recovery for the Name
889 	 * @param _id The ID of the Name
890 	 */
891 	function submitAccountRecovery(address _id) public isName(_id) senderIsName {
892 		require (_nameTAOPosition.senderIsListener(msg.sender, _id));
893 
894 		// Can't submit account recovery for itself
895 		require (!_nameTAOPosition.senderIsAdvocate(msg.sender, _id));
896 
897 		// Make sure Listener is not currenty compromised
898 		require (!this.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
899 
900 		AccountRecovery storage _accountRecovery = accountRecoveries[_id];
901 
902 		// Make sure currently it's not currently locked
903 		require (now > _accountRecovery.lockedUntilTimestamp);
904 
905 		_accountRecovery.submitted = true;
906 		_accountRecovery.submittedTimestamp = now;
907 		_accountRecovery.lockedUntilTimestamp = _accountRecovery.submittedTimestamp.add(_getAccountRecoveryLockDuration());
908 
909 		uint256 _nonce = _nameFactory.incrementNonce(_id);
910 		require (_nonce > 0);
911 
912 		emit SubmitAccountRecovery(_id, _nameFactory.ethAddressToNameId(msg.sender), true, _accountRecovery.submittedTimestamp, _accountRecovery.lockedUntilTimestamp, _nonce);
913 	}
914 
915 	/**
916 	 * @dev Check whether or not current Name is compromised,
917 	 *		i.e an account recovery has been submitted and waiting for
918 	 *		action from Speaker
919 	 * @param _id The ID of the Name
920 	 * @return true if yes. false otherwise
921 	 */
922 	function isCompromised(address _id) external isName(_id) view returns (bool) {
923 		AccountRecovery memory _accountRecovery = accountRecoveries[_id];
924 		return (_accountRecovery.submitted && now <= _accountRecovery.lockedUntilTimestamp);
925 	}
926 
927 	/**
928 	 * @dev Speaker of Name respond to AccountRecovery and submits a new eth address for Name
929 	 * @param _id The ID of the Name
930 	 * @param _newAddress The new replacement eth address
931 	 */
932 	function setNameNewAddress(address _id, address _newAddress) public isName(_id) senderIsName {
933 		require (_newAddress != address(0));
934 
935 		// Only Speaker can do this action
936 		require (_nameTAOPosition.senderIsSpeaker(msg.sender, _id));
937 
938 		// Make sure Speaker is not currenty compromised
939 		require (!this.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
940 
941 		// Make sure this Name is currently compromised and needs action
942 		require (this.isCompromised(_id));
943 
944 		// Make sure the newAddress is not yet assigned to a Name
945 		require (_nameFactory.ethAddressToNameId(_newAddress) == address(0));
946 
947 		AccountRecovery storage _accountRecovery = accountRecoveries[_id];
948 		_accountRecovery.submitted = false;
949 		_accountRecovery.submittedTimestamp = 0;
950 		_accountRecovery.lockedUntilTimestamp = 0;
951 
952 		// Replace the existing eth address with new address
953 		require (_nameFactory.setNameNewAddress(_id, _newAddress));
954 
955 		// Add this _newAddress to Name's publicKey if needed
956 		if (!_namePublicKey.isKeyExist(_id, _newAddress)) {
957 			require (_namePublicKey.whitelistAddKey(_id, _newAddress));
958 		}
959 
960 		uint256 _nonce = _nameFactory.incrementNonce(_id);
961 		require (_nonce > 0);
962 
963 		emit SetNameNewAddress(_id, _nameFactory.ethAddressToNameId(msg.sender), _newAddress, now, 1);
964 	}
965 
966 	/***** INTERNAL METHOD *****/
967 	/**
968 	 * @dev Get accountRecoveryLockDuration setting
969 	 * @return accountRecoveryLockDuration = The amount of time for current Speaker of Name to response and replace the eth address associated with the Name
970 	 */
971 	function _getAccountRecoveryLockDuration() internal view returns (uint256) {
972 		(uint256 accountRecoveryLockDuration,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'accountRecoveryLockDuration');
973 		return accountRecoveryLockDuration;
974 	}
975 }