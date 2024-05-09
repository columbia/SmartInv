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
75 interface IAOSettingValue {
76 	function setPendingValue(uint256 _settingId, address _addressValue, bool _boolValue, bytes32 _bytesValue, string calldata _stringValue, uint256 _uintValue) external returns (bool);
77 
78 	function movePendingToSetting(uint256 _settingId) external returns (bool);
79 
80 	function settingValue(uint256 _settingId) external view returns (address, bool, bytes32, string memory, uint256);
81 }
82 
83 
84 interface IAOSettingAttribute {
85 	function add(uint256 _settingId, address _creatorNameId, string calldata _settingName, address _creatorTAOId, address _associatedTAOId, string calldata _extraData) external returns (bytes32, bytes32);
86 
87 	function getSettingData(uint256 _settingId) external view returns (uint256, address, address, address, string memory, bool, bool, bool, string memory);
88 
89 	function approveAdd(uint256 _settingId, address _associatedTAOAdvocate, bool _approved) external returns (bool);
90 
91 	function finalizeAdd(uint256 _settingId, address _creatorTAOAdvocate) external returns (bool);
92 
93 	function update(uint256 _settingId, address _associatedTAOAdvocate, address _proposalTAOId, string calldata _extraData) external returns (bool);
94 
95 	function getSettingState(uint256 _settingId) external view returns (uint256, bool, address, address, address, string memory);
96 
97 	function approveUpdate(uint256 _settingId, address _proposalTAOAdvocate, bool _approved) external returns (bool);
98 
99 	function finalizeUpdate(uint256 _settingId, address _associatedTAOAdvocate) external returns (bool);
100 
101 	function addDeprecation(uint256 _settingId, address _creatorNameId, address _creatorTAOId, address _associatedTAOId, uint256 _newSettingId, address _newSettingContractAddress) external returns (bytes32, bytes32);
102 
103 	function getSettingDeprecation(uint256 _settingId) external view returns (uint256, address, address, address, bool, bool, bool, bool, uint256, uint256, address, address);
104 
105 	function approveDeprecation(uint256 _settingId, address _associatedTAOAdvocate, bool _approved) external returns (bool);
106 
107 	function finalizeDeprecation(uint256 _settingId, address _creatorTAOAdvocate) external returns (bool);
108 
109 	function settingExist(uint256 _settingId) external view returns (bool);
110 
111 	function getLatestSettingId(uint256 _settingId) external view returns (uint256);
112 }
113 
114 
115 interface INameFactory {
116 	function nonces(address _nameId) external view returns (uint256);
117 	function incrementNonce(address _nameId) external returns (uint256);
118 	function ethAddressToNameId(address _ethAddress) external view returns (address);
119 	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
120 	function nameIdToEthAddress(address _nameId) external view returns (address);
121 }
122 
123 
124 interface IAOSetting {
125 	function getSettingValuesByTAOName(address _taoId, string calldata _settingName) external view returns (uint256, bool, address, bytes32, string memory);
126 	function getSettingTypes() external view returns (uint8, uint8, uint8, uint8, uint8);
127 
128 	function settingTypeLookup(uint256 _settingId) external view returns (uint8);
129 }
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
141 
142 contract TokenERC20 {
143 	// Public variables of the token
144 	string public name;
145 	string public symbol;
146 	uint8 public decimals = 18;
147 	// 18 decimals is the strongly suggested default, avoid changing it
148 	uint256 public totalSupply;
149 
150 	// This creates an array with all balances
151 	mapping (address => uint256) public balanceOf;
152 	mapping (address => mapping (address => uint256)) public allowance;
153 
154 	// This generates a public event on the blockchain that will notify clients
155 	event Transfer(address indexed from, address indexed to, uint256 value);
156 
157 	// This generates a public event on the blockchain that will notify clients
158 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
159 
160 	// This notifies clients about the amount burnt
161 	event Burn(address indexed from, uint256 value);
162 
163 	/**
164 	 * Constructor function
165 	 *
166 	 * Initializes contract with initial supply tokens to the creator of the contract
167 	 */
168 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
169 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
170 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
171 		name = tokenName;                                   // Set the name for display purposes
172 		symbol = tokenSymbol;                               // Set the symbol for display purposes
173 	}
174 
175 	/**
176 	 * Internal transfer, only can be called by this contract
177 	 */
178 	function _transfer(address _from, address _to, uint _value) internal {
179 		// Prevent transfer to 0x0 address. Use burn() instead
180 		require(_to != address(0));
181 		// Check if the sender has enough
182 		require(balanceOf[_from] >= _value);
183 		// Check for overflows
184 		require(balanceOf[_to] + _value > balanceOf[_to]);
185 		// Save this for an assertion in the future
186 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
187 		// Subtract from the sender
188 		balanceOf[_from] -= _value;
189 		// Add the same to the recipient
190 		balanceOf[_to] += _value;
191 		emit Transfer(_from, _to, _value);
192 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
193 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
194 	}
195 
196 	/**
197 	 * Transfer tokens
198 	 *
199 	 * Send `_value` tokens to `_to` from your account
200 	 *
201 	 * @param _to The address of the recipient
202 	 * @param _value the amount to send
203 	 */
204 	function transfer(address _to, uint256 _value) public returns (bool success) {
205 		_transfer(msg.sender, _to, _value);
206 		return true;
207 	}
208 
209 	/**
210 	 * Transfer tokens from other address
211 	 *
212 	 * Send `_value` tokens to `_to` in behalf of `_from`
213 	 *
214 	 * @param _from The address of the sender
215 	 * @param _to The address of the recipient
216 	 * @param _value the amount to send
217 	 */
218 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
219 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
220 		allowance[_from][msg.sender] -= _value;
221 		_transfer(_from, _to, _value);
222 		return true;
223 	}
224 
225 	/**
226 	 * Set allowance for other address
227 	 *
228 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
229 	 *
230 	 * @param _spender The address authorized to spend
231 	 * @param _value the max amount they can spend
232 	 */
233 	function approve(address _spender, uint256 _value) public returns (bool success) {
234 		allowance[msg.sender][_spender] = _value;
235 		emit Approval(msg.sender, _spender, _value);
236 		return true;
237 	}
238 
239 	/**
240 	 * Set allowance for other address and notify
241 	 *
242 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
243 	 *
244 	 * @param _spender The address authorized to spend
245 	 * @param _value the max amount they can spend
246 	 * @param _extraData some extra information to send to the approved contract
247 	 */
248 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
249 		tokenRecipient spender = tokenRecipient(_spender);
250 		if (approve(_spender, _value)) {
251 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
252 			return true;
253 		}
254 	}
255 
256 	/**
257 	 * Destroy tokens
258 	 *
259 	 * Remove `_value` tokens from the system irreversibly
260 	 *
261 	 * @param _value the amount of money to burn
262 	 */
263 	function burn(uint256 _value) public returns (bool success) {
264 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
265 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
266 		totalSupply -= _value;                      // Updates totalSupply
267 		emit Burn(msg.sender, _value);
268 		return true;
269 	}
270 
271 	/**
272 	 * Destroy tokens from other account
273 	 *
274 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
275 	 *
276 	 * @param _from the address of the sender
277 	 * @param _value the amount of money to burn
278 	 */
279 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
280 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
281 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
282 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
283 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
284 		totalSupply -= _value;                              // Update totalSupply
285 		emit Burn(_from, _value);
286 		return true;
287 	}
288 }
289 
290 
291 /**
292  * @title TAO
293  */
294 contract TAO {
295 	using SafeMath for uint256;
296 
297 	address public vaultAddress;
298 	string public name;				// the name for this TAO
299 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
300 
301 	// TAO's data
302 	string public datHash;
303 	string public database;
304 	string public keyValue;
305 	bytes32 public contentId;
306 
307 	/**
308 	 * 0 = TAO
309 	 * 1 = Name
310 	 */
311 	uint8 public typeId;
312 
313 	/**
314 	 * @dev Constructor function
315 	 */
316 	constructor (string memory _name,
317 		address _originId,
318 		string memory _datHash,
319 		string memory _database,
320 		string memory _keyValue,
321 		bytes32 _contentId,
322 		address _vaultAddress
323 	) public {
324 		name = _name;
325 		originId = _originId;
326 		datHash = _datHash;
327 		database = _database;
328 		keyValue = _keyValue;
329 		contentId = _contentId;
330 
331 		// Creating TAO
332 		typeId = 0;
333 
334 		vaultAddress = _vaultAddress;
335 	}
336 
337 	/**
338 	 * @dev Checks if calling address is Vault contract
339 	 */
340 	modifier onlyVault {
341 		require (msg.sender == vaultAddress);
342 		_;
343 	}
344 
345 	/**
346 	 * Will receive any ETH sent
347 	 */
348 	function () external payable {
349 	}
350 
351 	/**
352 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
353 	 * @param _recipient The recipient address
354 	 * @param _amount The amount to transfer
355 	 * @return true on success
356 	 */
357 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
358 		_recipient.transfer(_amount);
359 		return true;
360 	}
361 
362 	/**
363 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
364 	 * @param _erc20TokenAddress The address of ERC20 Token
365 	 * @param _recipient The recipient address
366 	 * @param _amount The amount to transfer
367 	 * @return true on success
368 	 */
369 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
370 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
371 		_erc20.transfer(_recipient, _amount);
372 		return true;
373 	}
374 }
375 
376 
377 
378 
379 /**
380  * @title Name
381  */
382 contract Name is TAO {
383 	/**
384 	 * @dev Constructor function
385 	 */
386 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
387 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
388 		// Creating Name
389 		typeId = 1;
390 	}
391 }
392 
393 
394 
395 
396 /**
397  * @title AOLibrary
398  */
399 library AOLibrary {
400 	using SafeMath for uint256;
401 
402 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
403 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
404 
405 	/**
406 	 * @dev Check whether or not the given TAO ID is a TAO
407 	 * @param _taoId The ID of the TAO
408 	 * @return true if yes. false otherwise
409 	 */
410 	function isTAO(address _taoId) public view returns (bool) {
411 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
412 	}
413 
414 	/**
415 	 * @dev Check whether or not the given Name ID is a Name
416 	 * @param _nameId The ID of the Name
417 	 * @return true if yes. false otherwise
418 	 */
419 	function isName(address _nameId) public view returns (bool) {
420 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
421 	}
422 
423 	/**
424 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
425 	 * @param _tokenAddress The ERC20 Token address to check
426 	 */
427 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
428 		if (_tokenAddress == address(0)) {
429 			return false;
430 		}
431 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
432 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
433 	}
434 
435 	/**
436 	 * @dev Checks if the calling contract address is The AO
437 	 *		OR
438 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
439 	 * @param _sender The address to check
440 	 * @param _theAO The AO address
441 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
442 	 * @return true if yes, false otherwise
443 	 */
444 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
445 		return (_sender == _theAO ||
446 			(
447 				(isTAO(_theAO) || isName(_theAO)) &&
448 				_nameTAOPositionAddress != address(0) &&
449 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
450 			)
451 		);
452 	}
453 
454 	/**
455 	 * @dev Return the divisor used to correctly calculate percentage.
456 	 *		Percentage stored throughout AO contracts covers 4 decimals,
457 	 *		so 1% is 10000, 1.25% is 12500, etc
458 	 */
459 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
460 		return _PERCENTAGE_DIVISOR;
461 	}
462 
463 	/**
464 	 * @dev Return the divisor used to correctly calculate multiplier.
465 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
466 	 *		so 1 is 1000000, 0.023 is 23000, etc
467 	 */
468 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
469 		return _MULTIPLIER_DIVISOR;
470 	}
471 
472 	/**
473 	 * @dev deploy a TAO
474 	 * @param _name The name of the TAO
475 	 * @param _originId The Name ID the creates the TAO
476 	 * @param _datHash The datHash of this TAO
477 	 * @param _database The database for this TAO
478 	 * @param _keyValue The key/value pair to be checked on the database
479 	 * @param _contentId The contentId related to this TAO
480 	 * @param _nameTAOVaultAddress The address of NameTAOVault
481 	 */
482 	function deployTAO(string memory _name,
483 		address _originId,
484 		string memory _datHash,
485 		string memory _database,
486 		string memory _keyValue,
487 		bytes32 _contentId,
488 		address _nameTAOVaultAddress
489 		) public returns (TAO _tao) {
490 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
491 	}
492 
493 	/**
494 	 * @dev deploy a Name
495 	 * @param _name The name of the Name
496 	 * @param _originId The eth address the creates the Name
497 	 * @param _datHash The datHash of this Name
498 	 * @param _database The database for this Name
499 	 * @param _keyValue The key/value pair to be checked on the database
500 	 * @param _contentId The contentId related to this Name
501 	 * @param _nameTAOVaultAddress The address of NameTAOVault
502 	 */
503 	function deployName(string memory _name,
504 		address _originId,
505 		string memory _datHash,
506 		string memory _database,
507 		string memory _keyValue,
508 		bytes32 _contentId,
509 		address _nameTAOVaultAddress
510 		) public returns (Name _myName) {
511 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
512 	}
513 
514 	/**
515 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
516 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
517 	 * @param _currentPrimordialBalance Account's current primordial ion balance
518 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
519 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
520 	 * @return the new primordial weighted multiplier
521 	 */
522 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
523 		if (_currentWeightedMultiplier > 0) {
524 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
525 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
526 			return _totalWeightedIons.div(_totalIons);
527 		} else {
528 			return _additionalWeightedMultiplier;
529 		}
530 	}
531 
532 	/**
533 	 * @dev Calculate the primordial ion multiplier on a given lot
534 	 *		Total Primordial Mintable = T
535 	 *		Total Primordial Minted = M
536 	 *		Starting Multiplier = S
537 	 *		Ending Multiplier = E
538 	 *		To Purchase = P
539 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
540 	 *
541 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
542 	 * @param _totalPrimordialMintable Total Primordial ion mintable
543 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
544 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
545 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
546 	 * @return The multiplier in (10 ** 6)
547 	 */
548 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
549 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
550 			/**
551 			 * Let temp = M + (P/2)
552 			 * Multiplier = (1 - (temp / T)) x (S-E)
553 			 */
554 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
555 
556 			/**
557 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
558 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
559 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
560 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
561 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
562 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
563 			 */
564 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
565 			/**
566 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
567 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
568 			 */
569 			return multiplier.div(_MULTIPLIER_DIVISOR);
570 		} else {
571 			return 0;
572 		}
573 	}
574 
575 	/**
576 	 * @dev Calculate the bonus percentage of network ion on a given lot
577 	 *		Total Primordial Mintable = T
578 	 *		Total Primordial Minted = M
579 	 *		Starting Network Bonus Multiplier = Bs
580 	 *		Ending Network Bonus Multiplier = Be
581 	 *		To Purchase = P
582 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
583 	 *
584 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
585 	 * @param _totalPrimordialMintable Total Primordial ion intable
586 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
587 	 * @param _startingMultiplier The starting Network ion bonus multiplier
588 	 * @param _endingMultiplier The ending Network ion bonus multiplier
589 	 * @return The bonus percentage
590 	 */
591 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
592 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
593 			/**
594 			 * Let temp = M + (P/2)
595 			 * B% = (1 - (temp / T)) x (Bs-Be)
596 			 */
597 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
598 
599 			/**
600 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
601 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
602 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
603 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
604 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
605 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
606 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
607 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
608 			 */
609 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
610 			return bonusPercentage;
611 		} else {
612 			return 0;
613 		}
614 	}
615 
616 	/**
617 	 * @dev Calculate the bonus amount of network ion on a given lot
618 	 *		AO Bonus Amount = B% x P
619 	 *
620 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
621 	 * @param _totalPrimordialMintable Total Primordial ion intable
622 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
623 	 * @param _startingMultiplier The starting Network ion bonus multiplier
624 	 * @param _endingMultiplier The ending Network ion bonus multiplier
625 	 * @return The bonus percentage
626 	 */
627 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
628 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
629 		/**
630 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
631 		 * when calculating the network ion bonus amount
632 		 */
633 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
634 		return networkBonus;
635 	}
636 
637 	/**
638 	 * @dev Calculate the maximum amount of Primordial an account can burn
639 	 *		_primordialBalance = P
640 	 *		_currentWeightedMultiplier = M
641 	 *		_maximumMultiplier = S
642 	 *		_amountToBurn = B
643 	 *		B = ((S x P) - (P x M)) / S
644 	 *
645 	 * @param _primordialBalance Account's primordial ion balance
646 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
647 	 * @param _maximumMultiplier The maximum multiplier of this account
648 	 * @return The maximum burn amount
649 	 */
650 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
651 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
652 	}
653 
654 	/**
655 	 * @dev Calculate the new multiplier after burning primordial ion
656 	 *		_primordialBalance = P
657 	 *		_currentWeightedMultiplier = M
658 	 *		_amountToBurn = B
659 	 *		_newMultiplier = E
660 	 *		E = (P x M) / (P - B)
661 	 *
662 	 * @param _primordialBalance Account's primordial ion balance
663 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
664 	 * @param _amountToBurn The amount of primordial ion to burn
665 	 * @return The new multiplier
666 	 */
667 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
668 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
669 	}
670 
671 	/**
672 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
673 	 *		_primordialBalance = P
674 	 *		_currentWeightedMultiplier = M
675 	 *		_amountToConvert = C
676 	 *		_newMultiplier = E
677 	 *		E = (P x M) / (P + C)
678 	 *
679 	 * @param _primordialBalance Account's primordial ion balance
680 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
681 	 * @param _amountToConvert The amount of network ion to convert
682 	 * @return The new multiplier
683 	 */
684 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
685 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
686 	}
687 
688 	/**
689 	 * @dev count num of digits
690 	 * @param number uint256 of the nuumber to be checked
691 	 * @return uint8 num of digits
692 	 */
693 	function numDigits(uint256 number) public pure returns (uint8) {
694 		uint8 digits = 0;
695 		while(number != 0) {
696 			number = number.div(10);
697 			digits++;
698 		}
699 		return digits;
700 	}
701 }
702 
703 
704 
705 contract TheAO {
706 	address public theAO;
707 	address public nameTAOPositionAddress;
708 
709 	// Check whether an address is whitelisted and granted access to transact
710 	// on behalf of others
711 	mapping (address => bool) public whitelist;
712 
713 	constructor() public {
714 		theAO = msg.sender;
715 	}
716 
717 	/**
718 	 * @dev Checks if msg.sender is in whitelist.
719 	 */
720 	modifier inWhitelist() {
721 		require (whitelist[msg.sender] == true);
722 		_;
723 	}
724 
725 	/**
726 	 * @dev Transfer ownership of The AO to new address
727 	 * @param _theAO The new address to be transferred
728 	 */
729 	function transferOwnership(address _theAO) public {
730 		require (msg.sender == theAO);
731 		require (_theAO != address(0));
732 		theAO = _theAO;
733 	}
734 
735 	/**
736 	 * @dev Whitelist `_account` address to transact on behalf of others
737 	 * @param _account The address to whitelist
738 	 * @param _whitelist Either to whitelist or not
739 	 */
740 	function setWhitelist(address _account, bool _whitelist) public {
741 		require (msg.sender == theAO);
742 		require (_account != address(0));
743 		whitelist[_account] = _whitelist;
744 	}
745 }
746 
747 
748 
749 
750 
751 
752 
753 
754 /**
755  * @title AOSettingUpdate
756  *
757  * This contract purpose is to update existing Setting Value
758  */
759 contract AOSettingUpdate is TheAO {
760 	address public nameFactoryAddress;
761 	address public nameAccountRecoveryAddress;
762 	address public aoSettingAttributeAddress;
763 	address public aoSettingValueAddress;
764 	address public aoSettingAddress;
765 
766 	INameFactory internal _nameFactory;
767 	INameTAOPosition internal _nameTAOPosition;
768 	INameAccountRecovery internal _nameAccountRecovery;
769 	IAOSettingAttribute internal _aoSettingAttribute;
770 	IAOSettingValue internal _aoSettingValue;
771 	IAOSetting internal _aoSetting;
772 
773 	struct UpdateSignature {
774 		uint8 signatureV;
775 		bytes32 signatureR;
776 		bytes32 signatureS;
777 	}
778 
779 	// Mapping from settingId to UpdateSignature
780 	mapping (uint256 => UpdateSignature) public updateSignatures;
781 
782 	// Mapping from updateHashKey to it's settingId
783 	mapping (bytes32 => uint256) public updateHashLookup;
784 
785 	// Event to be broadcasted to public when a proposed update for a setting is created
786 	event SettingUpdate(uint256 indexed settingId, address indexed updateAdvocateNameId, address proposalTAOId);
787 
788 	// Event to be broadcasted to public when setting update is approved/rejected by the advocate of proposalTAOId
789 	event ApproveSettingUpdate(uint256 indexed settingId, address proposalTAOId, address proposalTAOAdvocate, bool approved);
790 
791 	// Event to be broadcasted to public when setting update is finalized by the advocate of associatedTAOId
792 	event FinalizeSettingUpdate(uint256 indexed settingId, address associatedTAOId, address associatedTAOAdvocate);
793 
794 	/**
795 	 * @dev Constructor function
796 	 */
797 	constructor(address _nameFactoryAddress,
798 		address _nameTAOPositionAddress,
799 		address _nameAccountRecoveryAddress,
800 		address _aoSettingAttributeAddress,
801 		address _aoSettingValueAddress,
802 		address _aoSettingAddress
803 		) public {
804 		setNameFactoryAddress(_nameFactoryAddress);
805 		setNameTAOPositionAddress(_nameTAOPositionAddress);
806 		setNameAccountRecoveryAddress(_nameAccountRecoveryAddress);
807 		setAOSettingAttributeAddress(_aoSettingAttributeAddress);
808 		setAOSettingValueAddress(_aoSettingValueAddress);
809 		setAOSettingAddress(_aoSettingAddress);
810 	}
811 
812 	/**
813 	 * @dev Checks if the calling contract address is The AO
814 	 *		OR
815 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
816 	 */
817 	modifier onlyTheAO {
818 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
819 		_;
820 	}
821 
822 	/**
823 	 * @dev Check is msg.sender address is a Name
824 	 */
825 	 modifier senderIsName() {
826 		require (_nameFactory.ethAddressToNameId(msg.sender) != address(0));
827 		_;
828 	 }
829 
830 	/**
831 	 * @dev Only allowed if sender's Name is not compromised
832 	 */
833 	modifier senderNameNotCompromised() {
834 		require (!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
835 		_;
836 	}
837 
838 	/**
839 	 * @dev Check if sender can update setting
840 	 */
841 	modifier canUpdate(address _proposalTAOId) {
842 		require (
843 			AOLibrary.isTAO(_proposalTAOId) &&
844 			_nameFactory.ethAddressToNameId(msg.sender) != address(0) &&
845 			!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender))
846 		);
847 		_;
848 	}
849 
850 	/**
851 	 * @dev Check whether or not setting is of type address
852 	 */
853 	modifier isAddressSetting(uint256 _settingId) {
854 		(uint8 ADDRESS_SETTING_TYPE,,,,) = _aoSetting.getSettingTypes();
855 		// Make sure the setting type is address
856 		require (_aoSetting.settingTypeLookup(_settingId) == ADDRESS_SETTING_TYPE);
857 		_;
858 	}
859 
860 	/**
861 	 * @dev Check whether or not setting is of type bool
862 	 */
863 	modifier isBoolSetting(uint256 _settingId) {
864 		(, uint8 BOOL_SETTING_TYPE,,,) = _aoSetting.getSettingTypes();
865 		// Make sure the setting type is bool
866 		require (_aoSetting.settingTypeLookup(_settingId) == BOOL_SETTING_TYPE);
867 		_;
868 	}
869 
870 	/**
871 	 * @dev Check whether or not setting is of type bytes32
872 	 */
873 	modifier isBytesSetting(uint256 _settingId) {
874 		(,, uint8 BYTES_SETTING_TYPE,,) = _aoSetting.getSettingTypes();
875 		// Make sure the setting type is bytes32
876 		require (_aoSetting.settingTypeLookup(_settingId) == BYTES_SETTING_TYPE);
877 		_;
878 	}
879 
880 	/**
881 	 * @dev Check whether or not setting is of type string
882 	 */
883 	modifier isStringSetting(uint256 _settingId) {
884 		(,,, uint8 STRING_SETTING_TYPE,) = _aoSetting.getSettingTypes();
885 		// Make sure the setting type is string
886 		require (_aoSetting.settingTypeLookup(_settingId) == STRING_SETTING_TYPE);
887 		_;
888 	}
889 
890 	/**
891 	 * @dev Check whether or not setting is of type uint256
892 	 */
893 	modifier isUintSetting(uint256 _settingId) {
894 		(,,,, uint8 UINT_SETTING_TYPE) = _aoSetting.getSettingTypes();
895 		// Make sure the setting type is uint256
896 		require (_aoSetting.settingTypeLookup(_settingId) == UINT_SETTING_TYPE);
897 		_;
898 	}
899 
900 	/***** The AO ONLY METHODS *****/
901 	/**
902 	 * @dev Transfer ownership of The AO to new address
903 	 * @param _theAO The new address to be transferred
904 	 */
905 	function transferOwnership(address _theAO) public onlyTheAO {
906 		require (_theAO != address(0));
907 		theAO = _theAO;
908 	}
909 
910 	/**
911 	 * @dev Whitelist `_account` address to transact on behalf of others
912 	 * @param _account The address to whitelist
913 	 * @param _whitelist Either to whitelist or not
914 	 */
915 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
916 		require (_account != address(0));
917 		whitelist[_account] = _whitelist;
918 	}
919 
920 	/**
921 	 * @dev The AO sets NameFactory address
922 	 * @param _nameFactoryAddress The address of NameFactory
923 	 */
924 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
925 		require (_nameFactoryAddress != address(0));
926 		nameFactoryAddress = _nameFactoryAddress;
927 		_nameFactory = INameFactory(_nameFactoryAddress);
928 	}
929 
930 	/**
931 	 * @dev The AO sets NameTAOPosition address
932 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
933 	 */
934 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
935 		require (_nameTAOPositionAddress != address(0));
936 		nameTAOPositionAddress = _nameTAOPositionAddress;
937 		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
938 	}
939 
940 	/**
941 	 * @dev The AO set the NameAccountRecovery Address
942 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
943 	 */
944 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
945 		require (_nameAccountRecoveryAddress != address(0));
946 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
947 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
948 	}
949 
950 	/**
951 	 * @dev The AO sets AOSettingAttribute address
952 	 * @param _aoSettingAttributeAddress The address of AOSettingAttribute
953 	 */
954 	function setAOSettingAttributeAddress(address _aoSettingAttributeAddress) public onlyTheAO {
955 		require (_aoSettingAttributeAddress != address(0));
956 		aoSettingAttributeAddress = _aoSettingAttributeAddress;
957 		_aoSettingAttribute = IAOSettingAttribute(_aoSettingAttributeAddress);
958 	}
959 
960 	/**
961 	 * @dev The AO sets AOSettingValue address
962 	 * @param _aoSettingValueAddress The address of AOSettingValue
963 	 */
964 	function setAOSettingValueAddress(address _aoSettingValueAddress) public onlyTheAO {
965 		require (_aoSettingValueAddress != address(0));
966 		aoSettingValueAddress = _aoSettingValueAddress;
967 		_aoSettingValue = IAOSettingValue(_aoSettingValueAddress);
968 	}
969 
970 	/**
971 	 * @dev The AO sets AOSetting address
972 	 * @param _aoSettingAddress The address of AOSetting
973 	 */
974 	function setAOSettingAddress(address _aoSettingAddress) public onlyTheAO {
975 		require (_aoSettingAddress != address(0));
976 		aoSettingAddress = _aoSettingAddress;
977 		_aoSetting = IAOSetting(_aoSettingAddress);
978 	}
979 
980 	/***** PUBLIC METHODS *****/
981 	/**
982 	 * @dev Advocate of Setting's _associatedTAOId submits an address setting update after an update has been proposed
983 	 * @param _settingId The ID of the setting to be updated
984 	 * @param _newValue The new address value for this setting
985 	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
986 	 * @param _signatureV The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
987 	 * @param _signatureR The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
988 	 * @param _signatureS The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
989 	 * @param _extraData Catch-all string value to be stored if exist
990 	 */
991 	function updateAddressSetting(
992 		uint256 _settingId,
993 		address _newValue,
994 		address _proposalTAOId,
995 		uint8 _signatureV,
996 		bytes32 _signatureR,
997 		bytes32 _signatureS,
998 		string memory _extraData)
999 		public
1000 		canUpdate(_proposalTAOId)
1001 		isAddressSetting(_settingId) {
1002 
1003 		// Verify and store update address signature
1004 		require (_verifyAndStoreUpdateAddressSignature(_settingId, _newValue, _proposalTAOId, _signatureV, _signatureR, _signatureS));
1005 
1006 		// Store the setting state data
1007 		require (_aoSettingAttribute.update(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId, _extraData));
1008 
1009 		// Store the value as pending value
1010 		_aoSettingValue.setPendingValue(_settingId, _newValue, false, '', '', 0);
1011 
1012 		// Store the update hash key lookup
1013 		_storeUpdateAddressHashLookup(_settingId, _newValue, _proposalTAOId, _extraData);
1014 
1015 		emit SettingUpdate(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId);
1016 	}
1017 
1018 	/**
1019 	 * @dev Advocate of Setting's _associatedTAOId submits a bool setting update after an update has been proposed
1020 	 * @param _settingId The ID of the setting to be updated
1021 	 * @param _newValue The new bool value for this setting
1022 	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
1023 	 * @param _signatureV The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1024 	 * @param _signatureR The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1025 	 * @param _signatureS The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1026 	 * @param _extraData Catch-all string value to be stored if exist
1027 	 */
1028 	function updateBoolSetting(
1029 		uint256 _settingId,
1030 		bool _newValue,
1031 		address _proposalTAOId,
1032 		uint8 _signatureV,
1033 		bytes32 _signatureR,
1034 		bytes32 _signatureS,
1035 		string memory _extraData)
1036 		public
1037 		canUpdate(_proposalTAOId)
1038 		isBoolSetting(_settingId) {
1039 
1040 		// Verify and store update bool signature
1041 		require (_verifyAndStoreUpdateBoolSignature(_settingId, _newValue, _proposalTAOId, _signatureV, _signatureR, _signatureS));
1042 
1043 		// Store the setting state data
1044 		require (_aoSettingAttribute.update(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId, _extraData));
1045 
1046 		// Store the value as pending value
1047 		_aoSettingValue.setPendingValue(_settingId, address(0), _newValue, '', '', 0);
1048 
1049 		// Store the update hash key lookup
1050 		_storeUpdateBoolHashLookup(_settingId, _newValue, _proposalTAOId, _extraData);
1051 
1052 		emit SettingUpdate(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId);
1053 	}
1054 
1055 	/**
1056 	 * @dev Advocate of Setting's _associatedTAOId submits a bytes32 setting update after an update has been proposed
1057 	 * @param _settingId The ID of the setting to be updated
1058 	 * @param _newValue The new bytes32 value for this setting
1059 	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
1060 	 * @param _signatureV The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1061 	 * @param _signatureR The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1062 	 * @param _signatureS The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1063 	 * @param _extraData Catch-all string value to be stored if exist
1064 	 */
1065 	function updateBytesSetting(
1066 		uint256 _settingId,
1067 		bytes32 _newValue,
1068 		address _proposalTAOId,
1069 		uint8 _signatureV,
1070 		bytes32 _signatureR,
1071 		bytes32 _signatureS,
1072 		string memory _extraData)
1073 		public
1074 		canUpdate(_proposalTAOId)
1075 		isBytesSetting(_settingId) {
1076 
1077 		// Verify and store update bytes32 signature
1078 		require (_verifyAndStoreUpdateBytesSignature(_settingId, _newValue, _proposalTAOId, _signatureV, _signatureR, _signatureS));
1079 
1080 		// Store the setting state data
1081 		require (_aoSettingAttribute.update(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId, _extraData));
1082 
1083 		// Store the value as pending value
1084 		_aoSettingValue.setPendingValue(_settingId, address(0), false, _newValue, '', 0);
1085 
1086 		// Store the update hash key lookup
1087 		_storeUpdateBytesHashLookup(_settingId, _newValue, _proposalTAOId, _extraData);
1088 
1089 		emit SettingUpdate(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId);
1090 	}
1091 
1092 	/**
1093 	 * @dev Advocate of Setting's _associatedTAOId submits a string setting update after an update has been proposed
1094 	 * @param _settingId The ID of the setting to be updated
1095 	 * @param _newValue The new string value for this setting
1096 	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
1097 	 * @param _signatureV The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1098 	 * @param _signatureR The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1099 	 * @param _signatureS The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1100 	 * @param _extraData Catch-all string value to be stored if exist
1101 	 */
1102 	function updateStringSetting(
1103 		uint256 _settingId,
1104 		string memory _newValue,
1105 		address _proposalTAOId,
1106 		uint8 _signatureV,
1107 		bytes32 _signatureR,
1108 		bytes32 _signatureS,
1109 		string memory _extraData)
1110 		public
1111 		canUpdate(_proposalTAOId)
1112 		isStringSetting(_settingId) {
1113 
1114 		// Verify and store update string signature
1115 		require (_verifyAndStoreUpdateStringSignature(_settingId, _newValue, _proposalTAOId, _signatureV, _signatureR, _signatureS));
1116 
1117 		// Store the setting state data
1118 		require (_aoSettingAttribute.update(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId, _extraData));
1119 
1120 		// Store the value as pending value
1121 		_aoSettingValue.setPendingValue(_settingId, address(0), false, '', _newValue, 0);
1122 
1123 		// Store the update hash key lookup
1124 		_storeUpdateStringHashLookup(_settingId, _newValue, _proposalTAOId, _extraData);
1125 
1126 		emit SettingUpdate(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId);
1127 	}
1128 
1129 	/**
1130 	 * @dev Advocate of Setting's _associatedTAOId submits a uint256 setting update after an update has been proposed
1131 	 * @param _settingId The ID of the setting to be updated
1132 	 * @param _newValue The new uint256 value for this setting
1133 	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
1134 	 * @param _signatureV The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1135 	 * @param _signatureR The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1136 	 * @param _signatureS The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1137 	 * @param _extraData Catch-all string value to be stored if exist
1138 	 */
1139 	function updateUintSetting(
1140 		uint256 _settingId,
1141 		uint256 _newValue,
1142 		address _proposalTAOId,
1143 		uint8 _signatureV,
1144 		bytes32 _signatureR,
1145 		bytes32 _signatureS,
1146 		string memory _extraData)
1147 		public
1148 		canUpdate(_proposalTAOId)
1149 		isUintSetting(_settingId) {
1150 
1151 		// Verify and store update uint256 signature
1152 		require (_verifyAndStoreUpdateUintSignature(_settingId, _newValue, _proposalTAOId, _signatureV, _signatureR, _signatureS));
1153 
1154 		// Store the setting state data
1155 		require (_aoSettingAttribute.update(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId, _extraData));
1156 
1157 		// Store the value as pending value
1158 		_aoSettingValue.setPendingValue(_settingId, address(0), false, '', '', _newValue);
1159 
1160 		// Store the update hash key lookup
1161 		_storeUpdateUintHashLookup(_settingId, _newValue, _proposalTAOId, _extraData);
1162 
1163 		emit SettingUpdate(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId);
1164 	}
1165 
1166 	/**
1167 	 * @dev Advocate of Setting's proposalTAOId approves the setting update
1168 	 * @param _settingId The ID of the setting to be approved
1169 	 * @param _approved Whether to approve or reject
1170 	 */
1171 	function approveSettingUpdate(uint256 _settingId, bool _approved) public senderIsName senderNameNotCompromised {
1172 		// Make sure setting exist
1173 		require (_aoSetting.settingTypeLookup(_settingId) > 0);
1174 
1175 		address _proposalTAOAdvocate = _nameFactory.ethAddressToNameId(msg.sender);
1176 		(,,, address _proposalTAOId,,) = _aoSettingAttribute.getSettingState(_settingId);
1177 
1178 		require (_aoSettingAttribute.approveUpdate(_settingId, _proposalTAOAdvocate, _approved));
1179 
1180 		emit ApproveSettingUpdate(_settingId, _proposalTAOId, _proposalTAOAdvocate, _approved);
1181 	}
1182 
1183 	/**
1184 	 * @dev Advocate of Setting's _associatedTAOId finalizes the setting update once the setting is approved
1185 	 * @param _settingId The ID of the setting to be finalized
1186 	 */
1187 	function finalizeSettingUpdate(uint256 _settingId) public senderIsName senderNameNotCompromised {
1188 		// Make sure setting exist
1189 		require (_aoSetting.settingTypeLookup(_settingId) > 0);
1190 
1191 		address _associatedTAOAdvocate = _nameFactory.ethAddressToNameId(msg.sender);
1192 		require (_aoSettingAttribute.finalizeUpdate(_settingId, _associatedTAOAdvocate));
1193 
1194 		(,,, address _associatedTAOId,,,,,) = _aoSettingAttribute.getSettingData(_settingId);
1195 
1196 		require (_aoSettingValue.movePendingToSetting(_settingId));
1197 
1198 		emit FinalizeSettingUpdate(_settingId, _associatedTAOId, _associatedTAOAdvocate);
1199 	}
1200 
1201 	/***** Internal Method *****/
1202 	/**
1203 	 * @dev Verify the signature for the address update and store the signature info
1204 	 * @param _settingId The ID of the setting to be updated
1205 	 * @param _newValue The new address value for this setting
1206 	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
1207 	 * @param _v The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1208 	 * @param _r The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1209 	 * @param _s The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1210 	 * @return true if valid, false otherwise
1211 	 */
1212 	function _verifyAndStoreUpdateAddressSignature(
1213 		uint256 _settingId,
1214 		address _newValue,
1215 		address _proposalTAOId,
1216 		uint8 _v,
1217 		bytes32 _r,
1218 		bytes32 _s
1219 		) internal returns (bool) {
1220 		bytes32 _hash = keccak256(abi.encodePacked(address(this), _settingId, _proposalTAOId, _newValue, _nameFactory.ethAddressToNameId(msg.sender)));
1221 		if (ecrecover(_hash, _v, _r, _s) != msg.sender) {
1222 			return false;
1223 		}
1224 		_storeUpdateSignature(_settingId, _v, _r, _s);
1225 		return true;
1226 	}
1227 
1228 	/**
1229 	 * @dev Verify the signature for the bool update and store the signature info
1230 	 * @param _settingId The ID of the setting to be updated
1231 	 * @param _newValue The new bool value for this setting
1232 	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
1233 	 * @param _v The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1234 	 * @param _r The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1235 	 * @param _s The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1236 	 * @return true if valid, false otherwise
1237 	 */
1238 	function _verifyAndStoreUpdateBoolSignature(
1239 		uint256 _settingId,
1240 		bool _newValue,
1241 		address _proposalTAOId,
1242 		uint8 _v,
1243 		bytes32 _r,
1244 		bytes32 _s
1245 		) internal returns (bool) {
1246 		bytes32 _hash = keccak256(abi.encodePacked(address(this), _settingId, _proposalTAOId, _newValue, _nameFactory.ethAddressToNameId(msg.sender)));
1247 		if (ecrecover(_hash, _v, _r, _s) != msg.sender) {
1248 			return false;
1249 		}
1250 		_storeUpdateSignature(_settingId, _v, _r, _s);
1251 		return true;
1252 	}
1253 
1254 	/**
1255 	 * @dev Verify the signature for the bytes32 update and store the signature info
1256 	 * @param _settingId The ID of the setting to be updated
1257 	 * @param _newValue The new bytes32 value for this setting
1258 	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
1259 	 * @param _v The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1260 	 * @param _r The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1261 	 * @param _s The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1262 	 * @return true if valid, false otherwise
1263 	 */
1264 	function _verifyAndStoreUpdateBytesSignature(
1265 		uint256 _settingId,
1266 		bytes32 _newValue,
1267 		address _proposalTAOId,
1268 		uint8 _v,
1269 		bytes32 _r,
1270 		bytes32 _s
1271 		) internal returns (bool) {
1272 		bytes32 _hash = keccak256(abi.encodePacked(address(this), _settingId, _proposalTAOId, _newValue, _nameFactory.ethAddressToNameId(msg.sender)));
1273 		if (ecrecover(_hash, _v, _r, _s) != msg.sender) {
1274 			return false;
1275 		}
1276 		_storeUpdateSignature(_settingId, _v, _r, _s);
1277 		return true;
1278 	}
1279 
1280 	/**
1281 	 * @dev Verify the signature for the string update and store the signature info
1282 	 * @param _settingId The ID of the setting to be updated
1283 	 * @param _newValue The new string value for this setting
1284 	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
1285 	 * @param _v The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1286 	 * @param _r The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1287 	 * @param _s The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1288 	 * @return true if valid, false otherwise
1289 	 */
1290 	function _verifyAndStoreUpdateStringSignature(
1291 		uint256 _settingId,
1292 		string memory _newValue,
1293 		address _proposalTAOId,
1294 		uint8 _v,
1295 		bytes32 _r,
1296 		bytes32 _s
1297 		) internal returns (bool) {
1298 		bytes32 _hash = keccak256(abi.encodePacked(address(this), _settingId, _proposalTAOId, _newValue, _nameFactory.ethAddressToNameId(msg.sender)));
1299 		if (ecrecover(_hash, _v, _r, _s) != msg.sender) {
1300 			return false;
1301 		}
1302 		_storeUpdateSignature(_settingId, _v, _r, _s);
1303 		return true;
1304 	}
1305 
1306 	/**
1307 	 * @dev Verify the signature for the uint256 update and store the signature info
1308 	 * @param _settingId The ID of the setting to be updated
1309 	 * @param _newValue The new uint256 value for this setting
1310 	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
1311 	 * @param _v The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1312 	 * @param _r The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1313 	 * @param _s The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1314 	 * @return true if valid, false otherwise
1315 	 */
1316 	function _verifyAndStoreUpdateUintSignature(
1317 		uint256 _settingId,
1318 		uint256 _newValue,
1319 		address _proposalTAOId,
1320 		uint8 _v,
1321 		bytes32 _r,
1322 		bytes32 _s
1323 		) public returns (bool) {
1324 		bytes32 _hash = keccak256(abi.encodePacked(address(this), _settingId, _proposalTAOId, _newValue, _nameFactory.ethAddressToNameId(msg.sender)));
1325 		if (ecrecover(_hash, _v, _r, _s) != msg.sender) {
1326 			return false;
1327 		}
1328 		_storeUpdateSignature(_settingId, _v, _r, _s);
1329 		return true;
1330 	}
1331 
1332 	/**
1333 	 * @dev Store the update hash lookup for this address setting
1334 	 * @param _settingId The ID of the setting to be updated
1335 	 * @param _newValue The new address value for this setting
1336 	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
1337 	 * @param _extraData Catch-all string value to be stored if exist
1338 	 */
1339 	function _storeUpdateAddressHashLookup(
1340 		uint256 _settingId,
1341 		address _newValue,
1342 		address _proposalTAOId,
1343 		string memory _extraData)
1344 		internal {
1345 		// Store the update hash key lookup
1346 		(address _addressValue,,,,) = _aoSettingValue.settingValue(_settingId);
1347 		updateHashLookup[keccak256(abi.encodePacked(address(this), _proposalTAOId, _addressValue, _newValue, _extraData, _settingId))] = _settingId;
1348 	}
1349 
1350 	/**
1351 	 * @dev Store the update hash lookup for this bool setting
1352 	 * @param _settingId The ID of the setting to be updated
1353 	 * @param _newValue The new bool value for this setting
1354 	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
1355 	 * @param _extraData Catch-all string value to be stored if exist
1356 	 */
1357 	function _storeUpdateBoolHashLookup(
1358 		uint256 _settingId,
1359 		bool _newValue,
1360 		address _proposalTAOId,
1361 		string memory _extraData)
1362 		internal {
1363 		// Store the update hash key lookup
1364 		(, bool _boolValue,,,) = _aoSettingValue.settingValue(_settingId);
1365 		updateHashLookup[keccak256(abi.encodePacked(address(this), _proposalTAOId, _boolValue, _newValue, _extraData, _settingId))] = _settingId;
1366 	}
1367 
1368 	/**
1369 	 * @dev Store the update hash lookup for this bytes32 setting
1370 	 * @param _settingId The ID of the setting to be updated
1371 	 * @param _newValue The new bytes32 value for this setting
1372 	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
1373 	 * @param _extraData Catch-all string value to be stored if exist
1374 	 */
1375 	function _storeUpdateBytesHashLookup(
1376 		uint256 _settingId,
1377 		bytes32 _newValue,
1378 		address _proposalTAOId,
1379 		string memory _extraData)
1380 		internal {
1381 		// Store the update hash key lookup
1382 		(,, bytes32 _bytesValue,,) = _aoSettingValue.settingValue(_settingId);
1383 		updateHashLookup[keccak256(abi.encodePacked(address(this), _proposalTAOId, _bytesValue, _newValue, _extraData, _settingId))] = _settingId;
1384 	}
1385 
1386 	/**
1387 	 * @dev Store the update hash lookup for this string setting
1388 	 * @param _settingId The ID of the setting to be updated
1389 	 * @param _newValue The new string value for this setting
1390 	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
1391 	 * @param _extraData Catch-all string value to be stored if exist
1392 	 */
1393 	function _storeUpdateStringHashLookup(
1394 		uint256 _settingId,
1395 		string memory _newValue,
1396 		address _proposalTAOId,
1397 		string memory _extraData)
1398 		internal {
1399 		// Store the update hash key lookup
1400 		(,,, string memory _stringValue,) = _aoSettingValue.settingValue(_settingId);
1401 		updateHashLookup[keccak256(abi.encodePacked(address(this), _proposalTAOId, _stringValue, _newValue, _extraData, _settingId))] = _settingId;
1402 	}
1403 
1404 	/**
1405 	 * @dev Store the update hash lookup for this uint256 setting
1406 	 * @param _settingId The ID of the setting to be updated
1407 	 * @param _newValue The new address value for this setting
1408 	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
1409 	 * @param _extraData Catch-all string value to be stored if exist
1410 	 */
1411 	function _storeUpdateUintHashLookup(
1412 		uint256 _settingId,
1413 		uint256 _newValue,
1414 		address _proposalTAOId,
1415 		string memory _extraData)
1416 		internal {
1417 		// Store the update hash key lookup
1418 		(,,,, uint256 _uintValue) = _aoSettingValue.settingValue(_settingId);
1419 		updateHashLookup[keccak256(abi.encodePacked(address(this), _proposalTAOId, _uintValue, _newValue, _extraData, _settingId))] = _settingId;
1420 	}
1421 
1422 	/**
1423 	 * @dev Actual storing the UpdateSignature info
1424 	 * @param _settingId The ID of the setting to be updated
1425 	 * @param _v The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1426 	 * @param _r The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1427 	 * @param _s The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
1428 	 */
1429 	function _storeUpdateSignature(uint256 _settingId, uint8 _v, bytes32 _r, bytes32 _s) internal {
1430 		UpdateSignature storage _updateSignature = updateSignatures[_settingId];
1431 		_updateSignature.signatureV = _v;
1432 		_updateSignature.signatureR = _r;
1433 		_updateSignature.signatureS = _s;
1434 	}
1435 }