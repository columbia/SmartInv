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
70 interface INameFactory {
71 	function nonces(address _nameId) external view returns (uint256);
72 	function incrementNonce(address _nameId) external returns (uint256);
73 	function ethAddressToNameId(address _ethAddress) external view returns (address);
74 	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
75 	function nameIdToEthAddress(address _nameId) external view returns (address);
76 }
77 
78 
79 interface IAOSetting {
80 	function getSettingValuesByTAOName(address _taoId, string calldata _settingName) external view returns (uint256, bool, address, bytes32, string memory);
81 	function getSettingTypes() external view returns (uint8, uint8, uint8, uint8, uint8);
82 
83 	function settingTypeLookup(uint256 _settingId) external view returns (uint8);
84 }
85 
86 
87 interface IAOContent {
88 	function create(address _creator, string calldata _baseChallenge, uint256 _fileSize, bytes32 _contentUsageType, address _taoId) external returns (bytes32);
89 
90 	function isAOContentUsageType(bytes32 _contentId) external view returns (bool);
91 
92 	function getById(bytes32 _contentId) external view returns (address, uint256, bytes32, address, bytes32, uint8, bytes32, bytes32, string memory);
93 
94 	function getBaseChallenge(bytes32 _contentId) external view returns (string memory);
95 }
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
106 
107 
108 contract TokenERC20 {
109 	// Public variables of the token
110 	string public name;
111 	string public symbol;
112 	uint8 public decimals = 18;
113 	// 18 decimals is the strongly suggested default, avoid changing it
114 	uint256 public totalSupply;
115 
116 	// This creates an array with all balances
117 	mapping (address => uint256) public balanceOf;
118 	mapping (address => mapping (address => uint256)) public allowance;
119 
120 	// This generates a public event on the blockchain that will notify clients
121 	event Transfer(address indexed from, address indexed to, uint256 value);
122 
123 	// This generates a public event on the blockchain that will notify clients
124 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
125 
126 	// This notifies clients about the amount burnt
127 	event Burn(address indexed from, uint256 value);
128 
129 	/**
130 	 * Constructor function
131 	 *
132 	 * Initializes contract with initial supply tokens to the creator of the contract
133 	 */
134 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
135 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
136 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
137 		name = tokenName;                                   // Set the name for display purposes
138 		symbol = tokenSymbol;                               // Set the symbol for display purposes
139 	}
140 
141 	/**
142 	 * Internal transfer, only can be called by this contract
143 	 */
144 	function _transfer(address _from, address _to, uint _value) internal {
145 		// Prevent transfer to 0x0 address. Use burn() instead
146 		require(_to != address(0));
147 		// Check if the sender has enough
148 		require(balanceOf[_from] >= _value);
149 		// Check for overflows
150 		require(balanceOf[_to] + _value > balanceOf[_to]);
151 		// Save this for an assertion in the future
152 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
153 		// Subtract from the sender
154 		balanceOf[_from] -= _value;
155 		// Add the same to the recipient
156 		balanceOf[_to] += _value;
157 		emit Transfer(_from, _to, _value);
158 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
159 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
160 	}
161 
162 	/**
163 	 * Transfer tokens
164 	 *
165 	 * Send `_value` tokens to `_to` from your account
166 	 *
167 	 * @param _to The address of the recipient
168 	 * @param _value the amount to send
169 	 */
170 	function transfer(address _to, uint256 _value) public returns (bool success) {
171 		_transfer(msg.sender, _to, _value);
172 		return true;
173 	}
174 
175 	/**
176 	 * Transfer tokens from other address
177 	 *
178 	 * Send `_value` tokens to `_to` in behalf of `_from`
179 	 *
180 	 * @param _from The address of the sender
181 	 * @param _to The address of the recipient
182 	 * @param _value the amount to send
183 	 */
184 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
185 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
186 		allowance[_from][msg.sender] -= _value;
187 		_transfer(_from, _to, _value);
188 		return true;
189 	}
190 
191 	/**
192 	 * Set allowance for other address
193 	 *
194 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
195 	 *
196 	 * @param _spender The address authorized to spend
197 	 * @param _value the max amount they can spend
198 	 */
199 	function approve(address _spender, uint256 _value) public returns (bool success) {
200 		allowance[msg.sender][_spender] = _value;
201 		emit Approval(msg.sender, _spender, _value);
202 		return true;
203 	}
204 
205 	/**
206 	 * Set allowance for other address and notify
207 	 *
208 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
209 	 *
210 	 * @param _spender The address authorized to spend
211 	 * @param _value the max amount they can spend
212 	 * @param _extraData some extra information to send to the approved contract
213 	 */
214 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
215 		tokenRecipient spender = tokenRecipient(_spender);
216 		if (approve(_spender, _value)) {
217 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
218 			return true;
219 		}
220 	}
221 
222 	/**
223 	 * Destroy tokens
224 	 *
225 	 * Remove `_value` tokens from the system irreversibly
226 	 *
227 	 * @param _value the amount of money to burn
228 	 */
229 	function burn(uint256 _value) public returns (bool success) {
230 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
231 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
232 		totalSupply -= _value;                      // Updates totalSupply
233 		emit Burn(msg.sender, _value);
234 		return true;
235 	}
236 
237 	/**
238 	 * Destroy tokens from other account
239 	 *
240 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
241 	 *
242 	 * @param _from the address of the sender
243 	 * @param _value the amount of money to burn
244 	 */
245 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
246 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
247 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
248 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
249 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
250 		totalSupply -= _value;                              // Update totalSupply
251 		emit Burn(_from, _value);
252 		return true;
253 	}
254 }
255 
256 
257 /**
258  * @title TAO
259  */
260 contract TAO {
261 	using SafeMath for uint256;
262 
263 	address public vaultAddress;
264 	string public name;				// the name for this TAO
265 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
266 
267 	// TAO's data
268 	string public datHash;
269 	string public database;
270 	string public keyValue;
271 	bytes32 public contentId;
272 
273 	/**
274 	 * 0 = TAO
275 	 * 1 = Name
276 	 */
277 	uint8 public typeId;
278 
279 	/**
280 	 * @dev Constructor function
281 	 */
282 	constructor (string memory _name,
283 		address _originId,
284 		string memory _datHash,
285 		string memory _database,
286 		string memory _keyValue,
287 		bytes32 _contentId,
288 		address _vaultAddress
289 	) public {
290 		name = _name;
291 		originId = _originId;
292 		datHash = _datHash;
293 		database = _database;
294 		keyValue = _keyValue;
295 		contentId = _contentId;
296 
297 		// Creating TAO
298 		typeId = 0;
299 
300 		vaultAddress = _vaultAddress;
301 	}
302 
303 	/**
304 	 * @dev Checks if calling address is Vault contract
305 	 */
306 	modifier onlyVault {
307 		require (msg.sender == vaultAddress);
308 		_;
309 	}
310 
311 	/**
312 	 * Will receive any ETH sent
313 	 */
314 	function () external payable {
315 	}
316 
317 	/**
318 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
319 	 * @param _recipient The recipient address
320 	 * @param _amount The amount to transfer
321 	 * @return true on success
322 	 */
323 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
324 		_recipient.transfer(_amount);
325 		return true;
326 	}
327 
328 	/**
329 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
330 	 * @param _erc20TokenAddress The address of ERC20 Token
331 	 * @param _recipient The recipient address
332 	 * @param _amount The amount to transfer
333 	 * @return true on success
334 	 */
335 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
336 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
337 		_erc20.transfer(_recipient, _amount);
338 		return true;
339 	}
340 }
341 
342 
343 
344 
345 /**
346  * @title Name
347  */
348 contract Name is TAO {
349 	/**
350 	 * @dev Constructor function
351 	 */
352 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
353 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
354 		// Creating Name
355 		typeId = 1;
356 	}
357 }
358 
359 
360 
361 
362 /**
363  * @title AOLibrary
364  */
365 library AOLibrary {
366 	using SafeMath for uint256;
367 
368 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
369 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
370 
371 	/**
372 	 * @dev Check whether or not the given TAO ID is a TAO
373 	 * @param _taoId The ID of the TAO
374 	 * @return true if yes. false otherwise
375 	 */
376 	function isTAO(address _taoId) public view returns (bool) {
377 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
378 	}
379 
380 	/**
381 	 * @dev Check whether or not the given Name ID is a Name
382 	 * @param _nameId The ID of the Name
383 	 * @return true if yes. false otherwise
384 	 */
385 	function isName(address _nameId) public view returns (bool) {
386 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
387 	}
388 
389 	/**
390 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
391 	 * @param _tokenAddress The ERC20 Token address to check
392 	 */
393 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
394 		if (_tokenAddress == address(0)) {
395 			return false;
396 		}
397 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
398 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
399 	}
400 
401 	/**
402 	 * @dev Checks if the calling contract address is The AO
403 	 *		OR
404 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
405 	 * @param _sender The address to check
406 	 * @param _theAO The AO address
407 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
408 	 * @return true if yes, false otherwise
409 	 */
410 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
411 		return (_sender == _theAO ||
412 			(
413 				(isTAO(_theAO) || isName(_theAO)) &&
414 				_nameTAOPositionAddress != address(0) &&
415 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
416 			)
417 		);
418 	}
419 
420 	/**
421 	 * @dev Return the divisor used to correctly calculate percentage.
422 	 *		Percentage stored throughout AO contracts covers 4 decimals,
423 	 *		so 1% is 10000, 1.25% is 12500, etc
424 	 */
425 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
426 		return _PERCENTAGE_DIVISOR;
427 	}
428 
429 	/**
430 	 * @dev Return the divisor used to correctly calculate multiplier.
431 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
432 	 *		so 1 is 1000000, 0.023 is 23000, etc
433 	 */
434 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
435 		return _MULTIPLIER_DIVISOR;
436 	}
437 
438 	/**
439 	 * @dev deploy a TAO
440 	 * @param _name The name of the TAO
441 	 * @param _originId The Name ID the creates the TAO
442 	 * @param _datHash The datHash of this TAO
443 	 * @param _database The database for this TAO
444 	 * @param _keyValue The key/value pair to be checked on the database
445 	 * @param _contentId The contentId related to this TAO
446 	 * @param _nameTAOVaultAddress The address of NameTAOVault
447 	 */
448 	function deployTAO(string memory _name,
449 		address _originId,
450 		string memory _datHash,
451 		string memory _database,
452 		string memory _keyValue,
453 		bytes32 _contentId,
454 		address _nameTAOVaultAddress
455 		) public returns (TAO _tao) {
456 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
457 	}
458 
459 	/**
460 	 * @dev deploy a Name
461 	 * @param _name The name of the Name
462 	 * @param _originId The eth address the creates the Name
463 	 * @param _datHash The datHash of this Name
464 	 * @param _database The database for this Name
465 	 * @param _keyValue The key/value pair to be checked on the database
466 	 * @param _contentId The contentId related to this Name
467 	 * @param _nameTAOVaultAddress The address of NameTAOVault
468 	 */
469 	function deployName(string memory _name,
470 		address _originId,
471 		string memory _datHash,
472 		string memory _database,
473 		string memory _keyValue,
474 		bytes32 _contentId,
475 		address _nameTAOVaultAddress
476 		) public returns (Name _myName) {
477 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
478 	}
479 
480 	/**
481 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
482 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
483 	 * @param _currentPrimordialBalance Account's current primordial ion balance
484 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
485 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
486 	 * @return the new primordial weighted multiplier
487 	 */
488 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
489 		if (_currentWeightedMultiplier > 0) {
490 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
491 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
492 			return _totalWeightedIons.div(_totalIons);
493 		} else {
494 			return _additionalWeightedMultiplier;
495 		}
496 	}
497 
498 	/**
499 	 * @dev Calculate the primordial ion multiplier on a given lot
500 	 *		Total Primordial Mintable = T
501 	 *		Total Primordial Minted = M
502 	 *		Starting Multiplier = S
503 	 *		Ending Multiplier = E
504 	 *		To Purchase = P
505 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
506 	 *
507 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
508 	 * @param _totalPrimordialMintable Total Primordial ion mintable
509 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
510 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
511 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
512 	 * @return The multiplier in (10 ** 6)
513 	 */
514 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
515 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
516 			/**
517 			 * Let temp = M + (P/2)
518 			 * Multiplier = (1 - (temp / T)) x (S-E)
519 			 */
520 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
521 
522 			/**
523 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
524 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
525 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
526 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
527 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
528 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
529 			 */
530 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
531 			/**
532 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
533 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
534 			 */
535 			return multiplier.div(_MULTIPLIER_DIVISOR);
536 		} else {
537 			return 0;
538 		}
539 	}
540 
541 	/**
542 	 * @dev Calculate the bonus percentage of network ion on a given lot
543 	 *		Total Primordial Mintable = T
544 	 *		Total Primordial Minted = M
545 	 *		Starting Network Bonus Multiplier = Bs
546 	 *		Ending Network Bonus Multiplier = Be
547 	 *		To Purchase = P
548 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
549 	 *
550 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
551 	 * @param _totalPrimordialMintable Total Primordial ion intable
552 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
553 	 * @param _startingMultiplier The starting Network ion bonus multiplier
554 	 * @param _endingMultiplier The ending Network ion bonus multiplier
555 	 * @return The bonus percentage
556 	 */
557 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
558 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
559 			/**
560 			 * Let temp = M + (P/2)
561 			 * B% = (1 - (temp / T)) x (Bs-Be)
562 			 */
563 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
564 
565 			/**
566 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
567 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
568 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
569 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
570 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
571 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
572 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
573 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
574 			 */
575 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
576 			return bonusPercentage;
577 		} else {
578 			return 0;
579 		}
580 	}
581 
582 	/**
583 	 * @dev Calculate the bonus amount of network ion on a given lot
584 	 *		AO Bonus Amount = B% x P
585 	 *
586 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
587 	 * @param _totalPrimordialMintable Total Primordial ion intable
588 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
589 	 * @param _startingMultiplier The starting Network ion bonus multiplier
590 	 * @param _endingMultiplier The ending Network ion bonus multiplier
591 	 * @return The bonus percentage
592 	 */
593 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
594 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
595 		/**
596 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
597 		 * when calculating the network ion bonus amount
598 		 */
599 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
600 		return networkBonus;
601 	}
602 
603 	/**
604 	 * @dev Calculate the maximum amount of Primordial an account can burn
605 	 *		_primordialBalance = P
606 	 *		_currentWeightedMultiplier = M
607 	 *		_maximumMultiplier = S
608 	 *		_amountToBurn = B
609 	 *		B = ((S x P) - (P x M)) / S
610 	 *
611 	 * @param _primordialBalance Account's primordial ion balance
612 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
613 	 * @param _maximumMultiplier The maximum multiplier of this account
614 	 * @return The maximum burn amount
615 	 */
616 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
617 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
618 	}
619 
620 	/**
621 	 * @dev Calculate the new multiplier after burning primordial ion
622 	 *		_primordialBalance = P
623 	 *		_currentWeightedMultiplier = M
624 	 *		_amountToBurn = B
625 	 *		_newMultiplier = E
626 	 *		E = (P x M) / (P - B)
627 	 *
628 	 * @param _primordialBalance Account's primordial ion balance
629 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
630 	 * @param _amountToBurn The amount of primordial ion to burn
631 	 * @return The new multiplier
632 	 */
633 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
634 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
635 	}
636 
637 	/**
638 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
639 	 *		_primordialBalance = P
640 	 *		_currentWeightedMultiplier = M
641 	 *		_amountToConvert = C
642 	 *		_newMultiplier = E
643 	 *		E = (P x M) / (P + C)
644 	 *
645 	 * @param _primordialBalance Account's primordial ion balance
646 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
647 	 * @param _amountToConvert The amount of network ion to convert
648 	 * @return The new multiplier
649 	 */
650 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
651 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
652 	}
653 
654 	/**
655 	 * @dev count num of digits
656 	 * @param number uint256 of the nuumber to be checked
657 	 * @return uint8 num of digits
658 	 */
659 	function numDigits(uint256 number) public pure returns (uint8) {
660 		uint8 digits = 0;
661 		while(number != 0) {
662 			number = number.div(10);
663 			digits++;
664 		}
665 		return digits;
666 	}
667 }
668 
669 
670 
671 contract TheAO {
672 	address public theAO;
673 	address public nameTAOPositionAddress;
674 
675 	// Check whether an address is whitelisted and granted access to transact
676 	// on behalf of others
677 	mapping (address => bool) public whitelist;
678 
679 	constructor() public {
680 		theAO = msg.sender;
681 	}
682 
683 	/**
684 	 * @dev Checks if msg.sender is in whitelist.
685 	 */
686 	modifier inWhitelist() {
687 		require (whitelist[msg.sender] == true);
688 		_;
689 	}
690 
691 	/**
692 	 * @dev Transfer ownership of The AO to new address
693 	 * @param _theAO The new address to be transferred
694 	 */
695 	function transferOwnership(address _theAO) public {
696 		require (msg.sender == theAO);
697 		require (_theAO != address(0));
698 		theAO = _theAO;
699 	}
700 
701 	/**
702 	 * @dev Whitelist `_account` address to transact on behalf of others
703 	 * @param _account The address to whitelist
704 	 * @param _whitelist Either to whitelist or not
705 	 */
706 	function setWhitelist(address _account, bool _whitelist) public {
707 		require (msg.sender == theAO);
708 		require (_account != address(0));
709 		whitelist[_account] = _whitelist;
710 	}
711 }
712 
713 
714 
715 
716 
717 
718 /**
719  * @title AOContent
720  */
721 contract AOContent is TheAO, IAOContent {
722 	uint256 public totalContents;
723 	address public settingTAOId;
724 	address public aoSettingAddress;
725 	address public nameFactoryAddress;
726 
727 	IAOSetting internal _aoSetting;
728 	INameFactory internal _nameFactory;
729 	INameTAOPosition internal _nameTAOPosition;
730 
731 	struct Content {
732 		bytes32 contentId;
733 		address creator;
734 		/**
735 		 * baseChallenge is the content's PUBLIC KEY
736 		 * When a request node wants to be a host, it is required to send a signed base challenge (its content's PUBLIC KEY)
737 		 * so that the contract can verify the authenticity of the content by comparing what the contract has and what the request node
738 		 * submit
739 		 */
740 		string baseChallenge;
741 		uint256 fileSize;
742 		bytes32 contentUsageType; // i.e AO Content, Creative Commons, or T(AO) Content
743 		address taoId;
744 		bytes32 taoContentState; // i.e Submitted, Pending Review, Accepted to TAO
745 		uint8 updateTAOContentStateV;
746 		bytes32 updateTAOContentStateR;
747 		bytes32 updateTAOContentStateS;
748 		string extraData;
749 	}
750 
751 	// Mapping from Content index to the Content object
752 	mapping (uint256 => Content) internal contents;
753 
754 	// Mapping from content ID to index of the contents list
755 	mapping (bytes32 => uint256) internal contentIndex;
756 
757 	// Event to be broadcasted to public when `content` is stored
758 	event StoreContent(address indexed creator, bytes32 indexed contentId, uint256 fileSize, bytes32 contentUsageType);
759 
760 	// Event to be broadcasted to public when Advocate/Listener/Speaker wants to update the TAO Content's State
761 	event UpdateTAOContentState(bytes32 indexed contentId, address indexed taoId, address signer, bytes32 taoContentState);
762 
763 	// Event to be broadcasted to public when content creator updates the content's extra data
764 	event SetExtraData(address indexed creator, bytes32 indexed contentId, string newExtraData);
765 
766 	/**
767 	 * @dev Constructor function
768 	 * @param _settingTAOId The TAO ID that controls the setting
769 	 * @param _aoSettingAddress The address of AOSetting
770 	 * @param _nameFactoryAddress The address of NameFactory
771 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
772 	 */
773 	constructor(address _settingTAOId, address _aoSettingAddress, address _nameFactoryAddress, address _nameTAOPositionAddress) public {
774 		setSettingTAOId(_settingTAOId);
775 		setAOSettingAddress(_aoSettingAddress);
776 		setNameFactoryAddress(_nameFactoryAddress);
777 		setNameTAOPositionAddress(_nameTAOPositionAddress);
778 	}
779 
780 	/**
781 	 * @dev Checks if the calling contract address is The AO
782 	 *		OR
783 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
784 	 */
785 	modifier onlyTheAO {
786 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
787 		_;
788 	}
789 
790 	/***** The AO ONLY METHODS *****/
791 	/**
792 	 * @dev Transfer ownership of The AO to new address
793 	 * @param _theAO The new address to be transferred
794 	 */
795 	function transferOwnership(address _theAO) public onlyTheAO {
796 		require (_theAO != address(0));
797 		theAO = _theAO;
798 	}
799 
800 	/**
801 	 * @dev Whitelist `_account` address to transact on behalf of others
802 	 * @param _account The address to whitelist
803 	 * @param _whitelist Either to whitelist or not
804 	 */
805 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
806 		require (_account != address(0));
807 		whitelist[_account] = _whitelist;
808 	}
809 
810 	/**
811 	 * @dev The AO sets setting TAO ID
812 	 * @param _settingTAOId The new setting TAO ID to set
813 	 */
814 	function setSettingTAOId(address _settingTAOId) public onlyTheAO {
815 		require (AOLibrary.isTAO(_settingTAOId));
816 		settingTAOId = _settingTAOId;
817 	}
818 
819 	/**
820 	 * @dev The AO sets AO Setting address
821 	 * @param _aoSettingAddress The address of AOSetting
822 	 */
823 	function setAOSettingAddress(address _aoSettingAddress) public onlyTheAO {
824 		require (_aoSettingAddress != address(0));
825 		aoSettingAddress = _aoSettingAddress;
826 		_aoSetting = IAOSetting(_aoSettingAddress);
827 	}
828 
829 	/**
830 	 * @dev The AO sets NameFactory address
831 	 * @param _nameFactoryAddress The address of NameFactory
832 	 */
833 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
834 		require (_nameFactoryAddress != address(0));
835 		nameFactoryAddress = _nameFactoryAddress;
836 		_nameFactory = INameFactory(_nameFactoryAddress);
837 	}
838 
839 	/**
840 	 * @dev The AO sets NameTAOPosition address
841 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
842 	 */
843 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
844 		require (_nameTAOPositionAddress != address(0));
845 		nameTAOPositionAddress = _nameTAOPositionAddress;
846 		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
847 	}
848 
849 	/***** PUBLIC METHODS *****/
850 	/**
851 	 * @dev Store the content information (content creation during staking)
852 	 * @param _creator the address of the content creator
853 	 * @param _baseChallenge The base challenge string (PUBLIC KEY) of the content
854 	 * @param _fileSize The size of the file
855 	 * @param _contentUsageType The content usage type, i.e AO Content, Creative Commons, or T(AO) Content
856 	 * @param _taoId The TAO (TAO) ID for this content (if this is a T(AO) Content)
857 	 * @return the ID of the content
858 	 */
859 	function create(address _creator,
860 		string calldata _baseChallenge,
861 		uint256 _fileSize,
862 		bytes32 _contentUsageType,
863 		address _taoId
864 		) external inWhitelist returns (bytes32) {
865 		require (_canCreate(_creator, _baseChallenge, _fileSize, _contentUsageType, _taoId));
866 
867 		// Increment totalContents
868 		totalContents++;
869 
870 		// Generate contentId
871 		bytes32 _contentId = keccak256(abi.encodePacked(this, _creator, totalContents));
872 		Content storage _content = contents[totalContents];
873 
874 		// Make sure the node does't store the same content twice
875 		require (_content.creator == address(0));
876 
877 		(,,bytes32 contentUsageType_taoContent, bytes32 taoContentState_submitted,,) = _getSettingVariables();
878 
879 		_content.contentId = _contentId;
880 		_content.creator = _creator;
881 		_content.baseChallenge = _baseChallenge;
882 		_content.fileSize = _fileSize;
883 		_content.contentUsageType = _contentUsageType;
884 
885 		// If this is a TAO Content
886 		if (_contentUsageType == contentUsageType_taoContent) {
887 			_content.taoContentState = taoContentState_submitted;
888 			_content.taoId = _taoId;
889 		}
890 
891 		contentIndex[_contentId] = totalContents;
892 
893 		emit StoreContent(_content.creator, _content.contentId, _content.fileSize, _content.contentUsageType);
894 		return _content.contentId;
895 	}
896 
897 	/**
898 	 * @dev Return content info at a given ID
899 	 * @param _contentId The ID of the content
900 	 * @return address of the creator
901 	 * @return file size of the content
902 	 * @return the content usage type, i.e AO Content, Creative Commons, or T(AO) Content
903 	 * @return The TAO ID for this content (if this is a T(AO) Content)
904 	 * @return The TAO Content state, i.e Submitted, Pending Review, or Accepted to TAO
905 	 * @return The V part of signature that is used to update the TAO Content State
906 	 * @return The R part of signature that is used to update the TAO Content State
907 	 * @return The S part of signature that is used to update the TAO Content State
908 	 * @return the extra information sent to the contract when creating a content
909 	 */
910 	function getById(bytes32 _contentId) external view returns (address, uint256, bytes32, address, bytes32, uint8, bytes32, bytes32, string memory) {
911 		// Make sure the content exist
912 		require (contentIndex[_contentId] > 0);
913 		Content memory _content = contents[contentIndex[_contentId]];
914 		return (
915 			_content.creator,
916 			_content.fileSize,
917 			_content.contentUsageType,
918 			_content.taoId,
919 			_content.taoContentState,
920 			_content.updateTAOContentStateV,
921 			_content.updateTAOContentStateR,
922 			_content.updateTAOContentStateS,
923 			_content.extraData
924 		);
925 	}
926 
927 	/**
928 	 * @dev Get content base challenge
929 	 * @param _contentId The ID of the content
930 	 * @return the base challenge
931 	 */
932 	function getBaseChallenge(bytes32 _contentId) external view returns (string memory) {
933 		// Make sure the content exist
934 		require (contentIndex[_contentId] > 0);
935 		Content memory _content = contents[contentIndex[_contentId]];
936 		require (whitelist[msg.sender] == true || _content.creator == _nameFactory.ethAddressToNameId(msg.sender));
937 		return _content.baseChallenge;
938 	}
939 
940 	/**
941 	 * @dev Update the TAO Content State of a T(AO) Content
942 	 * @param _contentId The ID of the Content
943 	 * @param _taoId The ID of the TAO that initiates the update
944 	 * @param _taoContentState The TAO Content state value, i.e Submitted, Pending Review, or Accepted to TAO
945 	 * @param _updateTAOContentStateV The V part of the signature for this update
946 	 * @param _updateTAOContentStateR The R part of the signature for this update
947 	 * @param _updateTAOContentStateS The S part of the signature for this update
948 	 */
949 	function updateTAOContentState(
950 		bytes32 _contentId,
951 		address _taoId,
952 		bytes32 _taoContentState,
953 		uint8 _updateTAOContentStateV,
954 		bytes32 _updateTAOContentStateR,
955 		bytes32 _updateTAOContentStateS
956 	) public {
957 		// Make sure the content exist
958 		require (contentIndex[_contentId] > 0);
959 		require (AOLibrary.isTAO(_taoId));
960 		(,, bytes32 _contentUsageType_taoContent, bytes32 taoContentState_submitted, bytes32 taoContentState_pendingReview, bytes32 taoContentState_acceptedToTAO) = _getSettingVariables();
961 		require (_taoContentState == taoContentState_submitted || _taoContentState == taoContentState_pendingReview || _taoContentState == taoContentState_acceptedToTAO);
962 
963 		address _signatureAddress = _getUpdateTAOContentStateSignatureAddress(_contentId, _taoId, _taoContentState, _updateTAOContentStateV, _updateTAOContentStateR, _updateTAOContentStateS);
964 
965 		Content storage _content = contents[contentIndex[_contentId]];
966 		// Make sure that the signature address is one of content's TAO ID's Advocate/Listener/Speaker
967 		require (_signatureAddress == msg.sender && _nameTAOPosition.senderIsPosition(_signatureAddress, _content.taoId));
968 		require (_content.contentUsageType == _contentUsageType_taoContent);
969 
970 		_content.taoContentState = _taoContentState;
971 		_content.updateTAOContentStateV = _updateTAOContentStateV;
972 		_content.updateTAOContentStateR = _updateTAOContentStateR;
973 		_content.updateTAOContentStateS = _updateTAOContentStateS;
974 
975 		emit UpdateTAOContentState(_contentId, _taoId, _signatureAddress, _taoContentState);
976 	}
977 
978 	/**
979 	 * @dev Check whether or not the content is of AO Content Usage Type
980 	 * @param _contentId The ID of the content
981 	 * @return true if yes. false otherwise
982 	 */
983 	function isAOContentUsageType(bytes32 _contentId) external view returns (bool) {
984 		require (contentIndex[_contentId] > 0);
985 		(bytes32 _contentUsageType_aoContent,,,,,) = _getSettingVariables();
986 		return contents[contentIndex[_contentId]].contentUsageType == _contentUsageType_aoContent;
987 	}
988 
989 	/**
990 	 * @dev Set extra data on existing content
991 	 * @param _contentId The ID of the content
992 	 * @param _extraData some extra information to send to the contract for a content
993 	 */
994 	function setExtraData(bytes32 _contentId, string memory _extraData) public {
995 		// Make sure the content exist
996 		require (contentIndex[_contentId] > 0);
997 
998 		Content storage _content = contents[contentIndex[_contentId]];
999 		// Make sure the content creator is the same as the sender
1000 		require (_content.creator == _nameFactory.ethAddressToNameId(msg.sender));
1001 
1002 		_content.extraData = _extraData;
1003 
1004 		emit SetExtraData(_content.creator, _content.contentId, _content.extraData);
1005 	}
1006 
1007 	/***** INTERNAL METHODS *****/
1008 	/**
1009 	 * @dev Checks if create params are valid
1010 	 * @param _creator the address of the content creator
1011 	 * @param _baseChallenge The base challenge string (PUBLIC KEY) of the content
1012 	 * @param _fileSize The size of the file
1013 	 * @param _contentUsageType The content usage type, i.e AO Content, Creative Commons, or T(AO) Content
1014 	 * @param _taoId The TAO (TAO) ID for this content (if this is a T(AO) Content)
1015 	 * @return true if yes. false otherwise
1016 	 */
1017 	function _canCreate(address _creator, string memory _baseChallenge, uint256 _fileSize, bytes32 _contentUsageType, address _taoId) internal view returns (bool) {
1018 		(bytes32 aoContent, bytes32 creativeCommons, bytes32 taoContent,,,) = _getSettingVariables();
1019 		return (_creator != address(0) &&
1020 			AOLibrary.isName(_creator) &&
1021 			bytes(_baseChallenge).length > 0 &&
1022 			_fileSize > 0 &&
1023 			(_contentUsageType == aoContent || _contentUsageType == creativeCommons || _contentUsageType == taoContent) &&
1024 			(
1025 				_contentUsageType != taoContent ||
1026 				(_contentUsageType == taoContent && _taoId != address(0) && AOLibrary.isTAO(_taoId) && _nameTAOPosition.nameIsPosition(_creator, _taoId))
1027 			)
1028 		);
1029 	}
1030 
1031 	/**
1032 	 * @dev Get setting variables
1033 	 * @return contentUsageType_aoContent Content Usage Type = AO Content
1034 	 * @return contentUsageType_creativeCommons Content Usage Type = Creative Commons
1035 	 * @return contentUsageType_taoContent Content Usage Type = T(AO) Content
1036 	 * @return taoContentState_submitted TAO Content State = Submitted
1037 	 * @return taoContentState_pendingReview TAO Content State = Pending Review
1038 	 * @return taoContentState_acceptedToTAO TAO Content State = Accepted to TAO
1039 	 */
1040 	function _getSettingVariables() internal view returns (bytes32, bytes32, bytes32, bytes32, bytes32, bytes32) {
1041 		(,,,bytes32 contentUsageType_aoContent,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'contentUsageType_aoContent');
1042 		(,,,bytes32 contentUsageType_creativeCommons,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'contentUsageType_creativeCommons');
1043 		(,,,bytes32 contentUsageType_taoContent,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'contentUsageType_taoContent');
1044 		(,,,bytes32 taoContentState_submitted,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'taoContentState_submitted');
1045 		(,,,bytes32 taoContentState_pendingReview,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'taoContentState_pendingReview');
1046 		(,,,bytes32 taoContentState_acceptedToTAO,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'taoContentState_acceptedToTAO');
1047 
1048 		return (
1049 			contentUsageType_aoContent,
1050 			contentUsageType_creativeCommons,
1051 			contentUsageType_taoContent,
1052 			taoContentState_submitted,
1053 			taoContentState_pendingReview,
1054 			taoContentState_acceptedToTAO
1055 		);
1056 	}
1057 
1058 	/**
1059 	 * @dev Return the address that signed the TAO content state update
1060 	 * @param _contentId the ID of the content
1061 	 * @param _taoId the ID of the TAO
1062 	 * @param _taoContentState the TAO Content State value, i.e Submitted, Pending Review, or Accepted to TAO
1063 	 * @param _v part of the signature
1064 	 * @param _r part of the signature
1065 	 * @param _s part of the signature
1066 	 * @return the address that signed the message
1067 	 */
1068 	function _getUpdateTAOContentStateSignatureAddress(bytes32 _contentId, address _taoId, bytes32 _taoContentState, uint8 _v, bytes32 _r, bytes32 _s) internal view returns (address) {
1069 		bytes32 _hash = keccak256(abi.encodePacked(address(this), _contentId, _taoId, _taoContentState));
1070 		return ecrecover(_hash, _v, _r, _s);
1071 	}
1072 }