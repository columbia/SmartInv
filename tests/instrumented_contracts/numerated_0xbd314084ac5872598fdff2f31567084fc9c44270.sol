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
755  * @title AOSetting
756  *
757  * This contract stores all AO setting variables
758  */
759 contract AOSetting is TheAO, IAOSetting {
760 	address public nameFactoryAddress;
761 	address public nameAccountRecoveryAddress;
762 	address public aoSettingAttributeAddress;
763 	address public aoSettingValueAddress;
764 
765 	INameFactory internal _nameFactory;
766 	INameTAOPosition internal _nameTAOPosition;
767 	INameAccountRecovery internal _nameAccountRecovery;
768 	IAOSettingAttribute internal _aoSettingAttribute;
769 	IAOSettingValue internal _aoSettingValue;
770 
771 	uint8 constant public ADDRESS_SETTING_TYPE = 1;
772 	uint8 constant public BOOL_SETTING_TYPE = 2;
773 	uint8 constant public BYTES_SETTING_TYPE = 3;
774 	uint8 constant public STRING_SETTING_TYPE = 4;
775 	uint8 constant public UINT_SETTING_TYPE = 5;
776 
777 	uint256 public totalSetting;
778 
779 	/**
780 	 * Mapping from associatedTAOId's setting name to Setting ID.
781 	 *
782 	 * Instead of concatenating the associatedTAOID and setting name to create a unique ID for lookup,
783 	 * use nested mapping to achieve the same result.
784 	 *
785 	 * The setting's name needs to be converted to bytes32 since solidity does not support mapping by string.
786 	 */
787 	mapping (address => mapping (bytes32 => uint256)) internal nameSettingLookup;
788 
789 	// Mapping from updateHashKey to it's settingId
790 	mapping (bytes32 => uint256) public updateHashLookup;
791 
792 	// Mapping from setting ID to it's type
793 	// setting type 1 => uint256, 2 => bool, 3 => address, 4 => bytes32, 5 => string
794 	mapping (uint256 => uint8) internal _settingTypeLookup;
795 
796 	// Event to be broadcasted to public when a setting is created and waiting for approval
797 	event SettingCreation(uint256 indexed settingId, address indexed creatorNameId, address creatorTAOId, address associatedTAOId, string settingName, bytes32 associatedTAOSettingId, bytes32 creatorTAOSettingId);
798 
799 	// Event to be broadcasted to public when setting creation is approved/rejected by the advocate of associatedTAOId
800 	event ApproveSettingCreation(uint256 indexed settingId, address associatedTAOId, address associatedTAOAdvocate, bool approved);
801 	// Event to be broadcasted to public when setting creation is finalized by the advocate of creatorTAOId
802 	event FinalizeSettingCreation(uint256 indexed settingId, address creatorTAOId, address creatorTAOAdvocate);
803 
804 	/**
805 	 * @dev Constructor function
806 	 */
807 	constructor(address _nameFactoryAddress,
808 		address _nameTAOPositionAddress,
809 		address _nameAccountRecoveryAddress,
810 		address _aoSettingAttributeAddress,
811 		address _aoSettingValueAddress
812 		) public {
813 		setNameFactoryAddress(_nameFactoryAddress);
814 		setNameTAOPositionAddress(_nameTAOPositionAddress);
815 		setNameAccountRecoveryAddress(_nameAccountRecoveryAddress);
816 		setAOSettingAttributeAddress(_aoSettingAttributeAddress);
817 		setAOSettingValueAddress(_aoSettingValueAddress);
818 	}
819 
820 	/**
821 	 * @dev Checks if the calling contract address is The AO
822 	 *		OR
823 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
824 	 */
825 	modifier onlyTheAO {
826 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
827 		_;
828 	}
829 
830 	/**
831 	 * @dev Check if `_taoId` is a TAO
832 	 */
833 	modifier isTAO(address _taoId) {
834 		require (AOLibrary.isTAO(_taoId));
835 		_;
836 	}
837 
838 	/**
839 	 * @dev Check if `_settingName` of `_associatedTAOId` is taken
840 	 */
841 	modifier settingNameNotTaken(string memory _settingName, address _associatedTAOId) {
842 		require (settingNameExist(_settingName, _associatedTAOId) == false);
843 		_;
844 	}
845 
846 	/**
847 	 * @dev Check if msg.sender is the current advocate of Name ID
848 	 */
849 	modifier onlyAdvocate(address _id) {
850 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _id));
851 		_;
852 	}
853 
854 	/**
855 	 * @dev Check is msg.sender address is a Name
856 	 */
857 	 modifier senderIsName() {
858 		require (_nameFactory.ethAddressToNameId(msg.sender) != address(0));
859 		_;
860 	 }
861 
862 	/**
863 	 * @dev Only allowed if sender's Name is not compromised
864 	 */
865 	modifier senderNameNotCompromised() {
866 		require (!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
867 		_;
868 	}
869 
870 	/***** The AO ONLY METHODS *****/
871 	/**
872 	 * @dev Transfer ownership of The AO to new address
873 	 * @param _theAO The new address to be transferred
874 	 */
875 	function transferOwnership(address _theAO) public onlyTheAO {
876 		require (_theAO != address(0));
877 		theAO = _theAO;
878 	}
879 
880 	/**
881 	 * @dev Whitelist `_account` address to transact on behalf of others
882 	 * @param _account The address to whitelist
883 	 * @param _whitelist Either to whitelist or not
884 	 */
885 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
886 		require (_account != address(0));
887 		whitelist[_account] = _whitelist;
888 	}
889 
890 	/**
891 	 * @dev The AO sets NameFactory address
892 	 * @param _nameFactoryAddress The address of NameFactory
893 	 */
894 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
895 		require (_nameFactoryAddress != address(0));
896 		nameFactoryAddress = _nameFactoryAddress;
897 		_nameFactory = INameFactory(_nameFactoryAddress);
898 	}
899 
900 	/**
901 	 * @dev The AO sets NameTAOPosition address
902 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
903 	 */
904 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
905 		require (_nameTAOPositionAddress != address(0));
906 		nameTAOPositionAddress = _nameTAOPositionAddress;
907 		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
908 	}
909 
910 	/**
911 	 * @dev The AO set the NameAccountRecovery Address
912 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
913 	 */
914 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
915 		require (_nameAccountRecoveryAddress != address(0));
916 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
917 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
918 	}
919 
920 	/**
921 	 * @dev The AO sets AOSettingAttribute address
922 	 * @param _aoSettingAttributeAddress The address of AOSettingAttribute
923 	 */
924 	function setAOSettingAttributeAddress(address _aoSettingAttributeAddress) public onlyTheAO {
925 		require (_aoSettingAttributeAddress != address(0));
926 		aoSettingAttributeAddress = _aoSettingAttributeAddress;
927 		_aoSettingAttribute = IAOSettingAttribute(_aoSettingAttributeAddress);
928 	}
929 
930 	/**
931 	 * @dev The AO sets AOSettingValue address
932 	 * @param _aoSettingValueAddress The address of AOSettingValue
933 	 */
934 	function setAOSettingValueAddress(address _aoSettingValueAddress) public onlyTheAO {
935 		require (_aoSettingValueAddress != address(0));
936 		aoSettingValueAddress = _aoSettingValueAddress;
937 		_aoSettingValue = IAOSettingValue(_aoSettingValueAddress);
938 	}
939 
940 	/***** PUBLIC METHODS *****/
941 	/**
942 	 * @dev Check whether or not a setting name of an associatedTAOId exist
943 	 * @param _settingName The human-readable name of the setting
944 	 * @param _associatedTAOId The taoId that the setting affects
945 	 * @return true if yes. false otherwise
946 	 */
947 	function settingNameExist(string memory _settingName, address _associatedTAOId) public view returns (bool) {
948 		return (nameSettingLookup[_associatedTAOId][keccak256(abi.encodePacked(this, _settingName))] > 0);
949 	}
950 
951 	/**
952 	 * @dev Advocate of _creatorTAOId adds a uint setting
953 	 * @param _settingName The human-readable name of the setting
954 	 * @param _value The uint256 value of the setting
955 	 * @param _creatorTAOId The taoId that created the setting
956 	 * @param _associatedTAOId The taoId that the setting affects
957 	 * @param _extraData Catch-all string value to be stored if exist
958 	 */
959 	function addUintSetting(
960 		string memory _settingName,
961 		uint256 _value,
962 		address _creatorTAOId,
963 		address _associatedTAOId,
964 		string memory _extraData)
965 		public
966 		isTAO(_creatorTAOId)
967 		isTAO(_associatedTAOId)
968 		settingNameNotTaken(_settingName, _associatedTAOId)
969 		onlyAdvocate(_creatorTAOId)
970 		senderNameNotCompromised {
971 		// Update global variables
972 		totalSetting++;
973 
974 		_settingTypeLookup[totalSetting] = UINT_SETTING_TYPE;
975 
976 		// Store the value as pending value
977 		_aoSettingValue.setPendingValue(totalSetting, address(0), false, '', '', _value);
978 
979 		// Store setting creation data
980 		_storeSettingCreation(_nameFactory.ethAddressToNameId(msg.sender), _settingName, _creatorTAOId, _associatedTAOId, _extraData);
981 	}
982 
983 	/**
984 	 * @dev Advocate of _creatorTAOId adds a bool setting
985 	 * @param _settingName The human-readable name of the setting
986 	 * @param _value The bool value of the setting
987 	 * @param _creatorTAOId The taoId that created the setting
988 	 * @param _associatedTAOId The taoId that the setting affects
989 	 * @param _extraData Catch-all string value to be stored if exist
990 	 */
991 	function addBoolSetting(
992 		string memory _settingName,
993 		bool _value,
994 		address _creatorTAOId,
995 		address _associatedTAOId,
996 		string memory _extraData)
997 		public
998 		isTAO(_creatorTAOId)
999 		isTAO(_associatedTAOId)
1000 		settingNameNotTaken(_settingName, _associatedTAOId)
1001 		onlyAdvocate(_creatorTAOId)
1002 		senderNameNotCompromised {
1003 		// Update global variables
1004 		totalSetting++;
1005 
1006 		_settingTypeLookup[totalSetting] = BOOL_SETTING_TYPE;
1007 
1008 		// Store the value as pending value
1009 		_aoSettingValue.setPendingValue(totalSetting, address(0), _value, '', '', 0);
1010 
1011 		// Store setting creation data
1012 		_storeSettingCreation(_nameFactory.ethAddressToNameId(msg.sender), _settingName, _creatorTAOId, _associatedTAOId, _extraData);
1013 	}
1014 
1015 	/**
1016 	 * @dev Advocate of _creatorTAOId adds an address setting
1017 	 * @param _settingName The human-readable name of the setting
1018 	 * @param _value The address value of the setting
1019 	 * @param _creatorTAOId The taoId that created the setting
1020 	 * @param _associatedTAOId The taoId that the setting affects
1021 	 * @param _extraData Catch-all string value to be stored if exist
1022 	 */
1023 	function addAddressSetting(
1024 		string memory _settingName,
1025 		address _value,
1026 		address _creatorTAOId,
1027 		address _associatedTAOId,
1028 		string memory _extraData)
1029 		public
1030 		isTAO(_creatorTAOId)
1031 		isTAO(_associatedTAOId)
1032 		settingNameNotTaken(_settingName, _associatedTAOId)
1033 		onlyAdvocate(_creatorTAOId)
1034 		senderNameNotCompromised {
1035 		// Update global variables
1036 		totalSetting++;
1037 
1038 		_settingTypeLookup[totalSetting] = ADDRESS_SETTING_TYPE;
1039 
1040 		// Store the value as pending value
1041 		_aoSettingValue.setPendingValue(totalSetting, _value, false, '', '', 0);
1042 
1043 		// Store setting creation data
1044 		_storeSettingCreation(_nameFactory.ethAddressToNameId(msg.sender), _settingName, _creatorTAOId, _associatedTAOId, _extraData);
1045 	}
1046 
1047 	/**
1048 	 * @dev Advocate of _creatorTAOId adds a bytes32 setting
1049 	 * @param _settingName The human-readable name of the setting
1050 	 * @param _value The bytes32 value of the setting
1051 	 * @param _creatorTAOId The taoId that created the setting
1052 	 * @param _associatedTAOId The taoId that the setting affects
1053 	 * @param _extraData Catch-all string value to be stored if exist
1054 	 */
1055 	function addBytesSetting(
1056 		string memory _settingName,
1057 		bytes32 _value,
1058 		address _creatorTAOId,
1059 		address _associatedTAOId,
1060 		string memory _extraData)
1061 		public
1062 		isTAO(_creatorTAOId)
1063 		isTAO(_associatedTAOId)
1064 		settingNameNotTaken(_settingName, _associatedTAOId)
1065 		onlyAdvocate(_creatorTAOId)
1066 		senderNameNotCompromised {
1067 		// Update global variables
1068 		totalSetting++;
1069 
1070 		_settingTypeLookup[totalSetting] = BYTES_SETTING_TYPE;
1071 
1072 		// Store the value as pending value
1073 		_aoSettingValue.setPendingValue(totalSetting, address(0), false, _value, '', 0);
1074 
1075 		// Store setting creation data
1076 		_storeSettingCreation(_nameFactory.ethAddressToNameId(msg.sender), _settingName, _creatorTAOId, _associatedTAOId, _extraData);
1077 	}
1078 
1079 	/**
1080 	 * @dev Advocate of _creatorTAOId adds a string setting
1081 	 * @param _settingName The human-readable name of the setting
1082 	 * @param _value The string value of the setting
1083 	 * @param _creatorTAOId The taoId that created the setting
1084 	 * @param _associatedTAOId The taoId that the setting affects
1085 	 * @param _extraData Catch-all string value to be stored if exist
1086 	 */
1087 	function addStringSetting(
1088 		string memory _settingName,
1089 		string memory _value,
1090 		address _creatorTAOId,
1091 		address _associatedTAOId,
1092 		string memory _extraData)
1093 		public
1094 		isTAO(_creatorTAOId)
1095 		isTAO(_associatedTAOId)
1096 		settingNameNotTaken(_settingName, _associatedTAOId)
1097 		onlyAdvocate(_creatorTAOId)
1098 		senderNameNotCompromised {
1099 		// Update global variables
1100 		totalSetting++;
1101 
1102 		_settingTypeLookup[totalSetting] = STRING_SETTING_TYPE;
1103 
1104 		// Store the value as pending value
1105 		_aoSettingValue.setPendingValue(totalSetting, address(0), false, '', _value, 0);
1106 
1107 		// Store setting creation data
1108 		_storeSettingCreation(_nameFactory.ethAddressToNameId(msg.sender), _settingName, _creatorTAOId, _associatedTAOId, _extraData);
1109 	}
1110 
1111 	/**
1112 	 * @dev Advocate of Setting's _associatedTAOId approves setting creation
1113 	 * @param _settingId The ID of the setting to approve
1114 	 * @param _approved Whether to approve or reject
1115 	 */
1116 	function approveSettingCreation(uint256 _settingId, bool _approved) public senderIsName senderNameNotCompromised {
1117 		address _associatedTAOAdvocate = _nameFactory.ethAddressToNameId(msg.sender);
1118 		require (_aoSettingAttribute.approveAdd(_settingId, _associatedTAOAdvocate, _approved));
1119 		(,,, address _associatedTAOId, string memory _settingName,,,,) = _aoSettingAttribute.getSettingData(_settingId);
1120 		if (!_approved) {
1121 			// Clear the settingName from nameSettingLookup so it can be added again in the future
1122 			delete nameSettingLookup[_associatedTAOId][keccak256(abi.encodePacked(this, _settingName))];
1123 			delete _settingTypeLookup[_settingId];
1124 		}
1125 		emit ApproveSettingCreation(_settingId, _associatedTAOId, _associatedTAOAdvocate, _approved);
1126 	}
1127 
1128 	/**
1129 	 * @dev Advocate of Setting's _creatorTAOId finalizes the setting creation once the setting is approved
1130 	 * @param _settingId The ID of the setting to be finalized
1131 	 */
1132 	function finalizeSettingCreation(uint256 _settingId) public senderIsName senderNameNotCompromised {
1133 		address _creatorTAOAdvocate = _nameFactory.ethAddressToNameId(msg.sender);
1134 		require (_aoSettingAttribute.finalizeAdd(_settingId, _creatorTAOAdvocate));
1135 
1136 		(,,address _creatorTAOId,,,,,,) = _aoSettingAttribute.getSettingData(_settingId);
1137 
1138 		require (_aoSettingValue.movePendingToSetting(_settingId));
1139 
1140 		emit FinalizeSettingCreation(_settingId, _creatorTAOId, _creatorTAOAdvocate);
1141 	}
1142 
1143 	/**
1144 	 * @dev Get setting type of a setting ID
1145 	 * @param _settingId The ID of the setting
1146 	 * @return the setting type value
1147 	 *		   setting type 1 => uint256, 2 => bool, 3 => address, 4 => bytes32, 5 => string
1148 	 */
1149 	function settingTypeLookup(uint256 _settingId) external view returns (uint8) {
1150 		return _settingTypeLookup[_settingId];
1151 	}
1152 
1153 	/**
1154 	 * @dev Get setting Id given an associatedTAOId and settingName
1155 	 * @param _associatedTAOId The ID of the AssociatedTAO
1156 	 * @param _settingName The name of the setting
1157 	 * @return the ID of the setting
1158 	 */
1159 	function getSettingIdByTAOName(address _associatedTAOId, string memory _settingName) public view returns (uint256) {
1160 		return nameSettingLookup[_associatedTAOId][keccak256(abi.encodePacked(this, _settingName))];
1161 	}
1162 
1163 	/**
1164 	 * @dev Get setting values by setting ID.
1165 	 *		Will throw error if the setting is not exist or rejected.
1166 	 * @param _settingId The ID of the setting
1167 	 * @return the uint256 value of this setting ID
1168 	 * @return the bool value of this setting ID
1169 	 * @return the address value of this setting ID
1170 	 * @return the bytes32 value of this setting ID
1171 	 * @return the string value of this setting ID
1172 	 */
1173 	function getSettingValuesById(uint256 _settingId) public view returns (uint256, bool, address, bytes32, string memory) {
1174 		require (_aoSettingAttribute.settingExist(_settingId));
1175 		_settingId = _aoSettingAttribute.getLatestSettingId(_settingId);
1176 		(address _addressValue, bool _boolValue, bytes32 _bytesValue, string memory _stringValue, uint256 _uintValue) = _aoSettingValue.settingValue(_settingId);
1177 		return (_uintValue, _boolValue, _addressValue, _bytesValue, _stringValue);
1178 	}
1179 
1180 	/**
1181 	 * @dev Get setting values by taoId and settingName.
1182 	 *		Will throw error if the setting is not exist or rejected.
1183 	 * @param _taoId The ID of the TAO
1184 	 * @param _settingName The name of the setting
1185 	 * @return the uint256 value of this setting ID
1186 	 * @return the bool value of this setting ID
1187 	 * @return the address value of this setting ID
1188 	 * @return the bytes32 value of this setting ID
1189 	 * @return the string value of this setting ID
1190 	 */
1191 	function getSettingValuesByTAOName(address _taoId, string calldata _settingName) external view returns (uint256, bool, address, bytes32, string memory) {
1192 		return getSettingValuesById(getSettingIdByTAOName(_taoId, _settingName));
1193 	}
1194 
1195 	/**
1196 	 * @dev Return the setting type values
1197 	 * @return The setting type value for address
1198 	 * @return The setting type value for bool
1199 	 * @return The setting type value for bytes
1200 	 * @return The setting type value for string
1201 	 * @return The setting type value for uint
1202 	 */
1203 	function getSettingTypes() external view returns (uint8, uint8, uint8, uint8, uint8) {
1204 		return (
1205 			ADDRESS_SETTING_TYPE,
1206 			BOOL_SETTING_TYPE,
1207 			BYTES_SETTING_TYPE,
1208 			STRING_SETTING_TYPE,
1209 			UINT_SETTING_TYPE
1210 		);
1211 	}
1212 
1213 	/***** Internal Method *****/
1214 	/**
1215 	 * @dev Store setting creation data
1216 	 * @param _creatorNameId The nameId that created the setting
1217 	 * @param _settingName The human-readable name of the setting
1218 	 * @param _creatorTAOId The taoId that created the setting
1219 	 * @param _associatedTAOId The taoId that the setting affects
1220 	 * @param _extraData Catch-all string value to be stored if exist
1221 	 */
1222 	function _storeSettingCreation(address _creatorNameId, string memory _settingName, address _creatorTAOId, address _associatedTAOId, string memory _extraData) internal {
1223 		// Store nameSettingLookup
1224 		nameSettingLookup[_associatedTAOId][keccak256(abi.encodePacked(address(this), _settingName))] = totalSetting;
1225 
1226 		// Store setting data/state
1227 		(bytes32 _associatedTAOSettingId, bytes32 _creatorTAOSettingId) = _aoSettingAttribute.add(totalSetting, _creatorNameId, _settingName, _creatorTAOId, _associatedTAOId, _extraData);
1228 
1229 		emit SettingCreation(totalSetting, _creatorNameId, _creatorTAOId, _associatedTAOId, _settingName, _associatedTAOSettingId, _creatorTAOSettingId);
1230 	}
1231 }