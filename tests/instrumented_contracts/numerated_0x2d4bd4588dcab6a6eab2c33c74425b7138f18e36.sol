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
75 interface IAOSettingAttribute {
76 	function add(uint256 _settingId, address _creatorNameId, string calldata _settingName, address _creatorTAOId, address _associatedTAOId, string calldata _extraData) external returns (bytes32, bytes32);
77 
78 	function getSettingData(uint256 _settingId) external view returns (uint256, address, address, address, string memory, bool, bool, bool, string memory);
79 
80 	function approveAdd(uint256 _settingId, address _associatedTAOAdvocate, bool _approved) external returns (bool);
81 
82 	function finalizeAdd(uint256 _settingId, address _creatorTAOAdvocate) external returns (bool);
83 
84 	function update(uint256 _settingId, address _associatedTAOAdvocate, address _proposalTAOId, string calldata _extraData) external returns (bool);
85 
86 	function getSettingState(uint256 _settingId) external view returns (uint256, bool, address, address, address, string memory);
87 
88 	function approveUpdate(uint256 _settingId, address _proposalTAOAdvocate, bool _approved) external returns (bool);
89 
90 	function finalizeUpdate(uint256 _settingId, address _associatedTAOAdvocate) external returns (bool);
91 
92 	function addDeprecation(uint256 _settingId, address _creatorNameId, address _creatorTAOId, address _associatedTAOId, uint256 _newSettingId, address _newSettingContractAddress) external returns (bytes32, bytes32);
93 
94 	function getSettingDeprecation(uint256 _settingId) external view returns (uint256, address, address, address, bool, bool, bool, bool, uint256, uint256, address, address);
95 
96 	function approveDeprecation(uint256 _settingId, address _associatedTAOAdvocate, bool _approved) external returns (bool);
97 
98 	function finalizeDeprecation(uint256 _settingId, address _creatorTAOAdvocate) external returns (bool);
99 
100 	function settingExist(uint256 _settingId) external view returns (bool);
101 
102 	function getLatestSettingId(uint256 _settingId) external view returns (uint256);
103 }
104 
105 
106 interface INameFactory {
107 	function nonces(address _nameId) external view returns (uint256);
108 	function incrementNonce(address _nameId) external returns (uint256);
109 	function ethAddressToNameId(address _ethAddress) external view returns (address);
110 	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
111 	function nameIdToEthAddress(address _nameId) external view returns (address);
112 }
113 
114 
115 interface IAOSetting {
116 	function getSettingValuesByTAOName(address _taoId, string calldata _settingName) external view returns (uint256, bool, address, bytes32, string memory);
117 	function getSettingTypes() external view returns (uint8, uint8, uint8, uint8, uint8);
118 
119 	function settingTypeLookup(uint256 _settingId) external view returns (uint8);
120 }
121 
122 
123 
124 
125 
126 
127 
128 
129 
130 
131 
132 
133 contract TokenERC20 {
134 	// Public variables of the token
135 	string public name;
136 	string public symbol;
137 	uint8 public decimals = 18;
138 	// 18 decimals is the strongly suggested default, avoid changing it
139 	uint256 public totalSupply;
140 
141 	// This creates an array with all balances
142 	mapping (address => uint256) public balanceOf;
143 	mapping (address => mapping (address => uint256)) public allowance;
144 
145 	// This generates a public event on the blockchain that will notify clients
146 	event Transfer(address indexed from, address indexed to, uint256 value);
147 
148 	// This generates a public event on the blockchain that will notify clients
149 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
150 
151 	// This notifies clients about the amount burnt
152 	event Burn(address indexed from, uint256 value);
153 
154 	/**
155 	 * Constructor function
156 	 *
157 	 * Initializes contract with initial supply tokens to the creator of the contract
158 	 */
159 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
160 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
161 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
162 		name = tokenName;                                   // Set the name for display purposes
163 		symbol = tokenSymbol;                               // Set the symbol for display purposes
164 	}
165 
166 	/**
167 	 * Internal transfer, only can be called by this contract
168 	 */
169 	function _transfer(address _from, address _to, uint _value) internal {
170 		// Prevent transfer to 0x0 address. Use burn() instead
171 		require(_to != address(0));
172 		// Check if the sender has enough
173 		require(balanceOf[_from] >= _value);
174 		// Check for overflows
175 		require(balanceOf[_to] + _value > balanceOf[_to]);
176 		// Save this for an assertion in the future
177 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
178 		// Subtract from the sender
179 		balanceOf[_from] -= _value;
180 		// Add the same to the recipient
181 		balanceOf[_to] += _value;
182 		emit Transfer(_from, _to, _value);
183 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
184 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
185 	}
186 
187 	/**
188 	 * Transfer tokens
189 	 *
190 	 * Send `_value` tokens to `_to` from your account
191 	 *
192 	 * @param _to The address of the recipient
193 	 * @param _value the amount to send
194 	 */
195 	function transfer(address _to, uint256 _value) public returns (bool success) {
196 		_transfer(msg.sender, _to, _value);
197 		return true;
198 	}
199 
200 	/**
201 	 * Transfer tokens from other address
202 	 *
203 	 * Send `_value` tokens to `_to` in behalf of `_from`
204 	 *
205 	 * @param _from The address of the sender
206 	 * @param _to The address of the recipient
207 	 * @param _value the amount to send
208 	 */
209 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
210 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
211 		allowance[_from][msg.sender] -= _value;
212 		_transfer(_from, _to, _value);
213 		return true;
214 	}
215 
216 	/**
217 	 * Set allowance for other address
218 	 *
219 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
220 	 *
221 	 * @param _spender The address authorized to spend
222 	 * @param _value the max amount they can spend
223 	 */
224 	function approve(address _spender, uint256 _value) public returns (bool success) {
225 		allowance[msg.sender][_spender] = _value;
226 		emit Approval(msg.sender, _spender, _value);
227 		return true;
228 	}
229 
230 	/**
231 	 * Set allowance for other address and notify
232 	 *
233 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
234 	 *
235 	 * @param _spender The address authorized to spend
236 	 * @param _value the max amount they can spend
237 	 * @param _extraData some extra information to send to the approved contract
238 	 */
239 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
240 		tokenRecipient spender = tokenRecipient(_spender);
241 		if (approve(_spender, _value)) {
242 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
243 			return true;
244 		}
245 	}
246 
247 	/**
248 	 * Destroy tokens
249 	 *
250 	 * Remove `_value` tokens from the system irreversibly
251 	 *
252 	 * @param _value the amount of money to burn
253 	 */
254 	function burn(uint256 _value) public returns (bool success) {
255 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
256 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
257 		totalSupply -= _value;                      // Updates totalSupply
258 		emit Burn(msg.sender, _value);
259 		return true;
260 	}
261 
262 	/**
263 	 * Destroy tokens from other account
264 	 *
265 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
266 	 *
267 	 * @param _from the address of the sender
268 	 * @param _value the amount of money to burn
269 	 */
270 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
271 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
272 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
273 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
274 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
275 		totalSupply -= _value;                              // Update totalSupply
276 		emit Burn(_from, _value);
277 		return true;
278 	}
279 }
280 
281 
282 /**
283  * @title TAO
284  */
285 contract TAO {
286 	using SafeMath for uint256;
287 
288 	address public vaultAddress;
289 	string public name;				// the name for this TAO
290 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
291 
292 	// TAO's data
293 	string public datHash;
294 	string public database;
295 	string public keyValue;
296 	bytes32 public contentId;
297 
298 	/**
299 	 * 0 = TAO
300 	 * 1 = Name
301 	 */
302 	uint8 public typeId;
303 
304 	/**
305 	 * @dev Constructor function
306 	 */
307 	constructor (string memory _name,
308 		address _originId,
309 		string memory _datHash,
310 		string memory _database,
311 		string memory _keyValue,
312 		bytes32 _contentId,
313 		address _vaultAddress
314 	) public {
315 		name = _name;
316 		originId = _originId;
317 		datHash = _datHash;
318 		database = _database;
319 		keyValue = _keyValue;
320 		contentId = _contentId;
321 
322 		// Creating TAO
323 		typeId = 0;
324 
325 		vaultAddress = _vaultAddress;
326 	}
327 
328 	/**
329 	 * @dev Checks if calling address is Vault contract
330 	 */
331 	modifier onlyVault {
332 		require (msg.sender == vaultAddress);
333 		_;
334 	}
335 
336 	/**
337 	 * Will receive any ETH sent
338 	 */
339 	function () external payable {
340 	}
341 
342 	/**
343 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
344 	 * @param _recipient The recipient address
345 	 * @param _amount The amount to transfer
346 	 * @return true on success
347 	 */
348 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
349 		_recipient.transfer(_amount);
350 		return true;
351 	}
352 
353 	/**
354 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
355 	 * @param _erc20TokenAddress The address of ERC20 Token
356 	 * @param _recipient The recipient address
357 	 * @param _amount The amount to transfer
358 	 * @return true on success
359 	 */
360 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
361 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
362 		_erc20.transfer(_recipient, _amount);
363 		return true;
364 	}
365 }
366 
367 
368 
369 
370 /**
371  * @title Name
372  */
373 contract Name is TAO {
374 	/**
375 	 * @dev Constructor function
376 	 */
377 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
378 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
379 		// Creating Name
380 		typeId = 1;
381 	}
382 }
383 
384 
385 
386 
387 /**
388  * @title AOLibrary
389  */
390 library AOLibrary {
391 	using SafeMath for uint256;
392 
393 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
394 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
395 
396 	/**
397 	 * @dev Check whether or not the given TAO ID is a TAO
398 	 * @param _taoId The ID of the TAO
399 	 * @return true if yes. false otherwise
400 	 */
401 	function isTAO(address _taoId) public view returns (bool) {
402 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
403 	}
404 
405 	/**
406 	 * @dev Check whether or not the given Name ID is a Name
407 	 * @param _nameId The ID of the Name
408 	 * @return true if yes. false otherwise
409 	 */
410 	function isName(address _nameId) public view returns (bool) {
411 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
412 	}
413 
414 	/**
415 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
416 	 * @param _tokenAddress The ERC20 Token address to check
417 	 */
418 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
419 		if (_tokenAddress == address(0)) {
420 			return false;
421 		}
422 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
423 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
424 	}
425 
426 	/**
427 	 * @dev Checks if the calling contract address is The AO
428 	 *		OR
429 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
430 	 * @param _sender The address to check
431 	 * @param _theAO The AO address
432 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
433 	 * @return true if yes, false otherwise
434 	 */
435 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
436 		return (_sender == _theAO ||
437 			(
438 				(isTAO(_theAO) || isName(_theAO)) &&
439 				_nameTAOPositionAddress != address(0) &&
440 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
441 			)
442 		);
443 	}
444 
445 	/**
446 	 * @dev Return the divisor used to correctly calculate percentage.
447 	 *		Percentage stored throughout AO contracts covers 4 decimals,
448 	 *		so 1% is 10000, 1.25% is 12500, etc
449 	 */
450 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
451 		return _PERCENTAGE_DIVISOR;
452 	}
453 
454 	/**
455 	 * @dev Return the divisor used to correctly calculate multiplier.
456 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
457 	 *		so 1 is 1000000, 0.023 is 23000, etc
458 	 */
459 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
460 		return _MULTIPLIER_DIVISOR;
461 	}
462 
463 	/**
464 	 * @dev deploy a TAO
465 	 * @param _name The name of the TAO
466 	 * @param _originId The Name ID the creates the TAO
467 	 * @param _datHash The datHash of this TAO
468 	 * @param _database The database for this TAO
469 	 * @param _keyValue The key/value pair to be checked on the database
470 	 * @param _contentId The contentId related to this TAO
471 	 * @param _nameTAOVaultAddress The address of NameTAOVault
472 	 */
473 	function deployTAO(string memory _name,
474 		address _originId,
475 		string memory _datHash,
476 		string memory _database,
477 		string memory _keyValue,
478 		bytes32 _contentId,
479 		address _nameTAOVaultAddress
480 		) public returns (TAO _tao) {
481 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
482 	}
483 
484 	/**
485 	 * @dev deploy a Name
486 	 * @param _name The name of the Name
487 	 * @param _originId The eth address the creates the Name
488 	 * @param _datHash The datHash of this Name
489 	 * @param _database The database for this Name
490 	 * @param _keyValue The key/value pair to be checked on the database
491 	 * @param _contentId The contentId related to this Name
492 	 * @param _nameTAOVaultAddress The address of NameTAOVault
493 	 */
494 	function deployName(string memory _name,
495 		address _originId,
496 		string memory _datHash,
497 		string memory _database,
498 		string memory _keyValue,
499 		bytes32 _contentId,
500 		address _nameTAOVaultAddress
501 		) public returns (Name _myName) {
502 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
503 	}
504 
505 	/**
506 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
507 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
508 	 * @param _currentPrimordialBalance Account's current primordial ion balance
509 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
510 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
511 	 * @return the new primordial weighted multiplier
512 	 */
513 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
514 		if (_currentWeightedMultiplier > 0) {
515 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
516 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
517 			return _totalWeightedIons.div(_totalIons);
518 		} else {
519 			return _additionalWeightedMultiplier;
520 		}
521 	}
522 
523 	/**
524 	 * @dev Calculate the primordial ion multiplier on a given lot
525 	 *		Total Primordial Mintable = T
526 	 *		Total Primordial Minted = M
527 	 *		Starting Multiplier = S
528 	 *		Ending Multiplier = E
529 	 *		To Purchase = P
530 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
531 	 *
532 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
533 	 * @param _totalPrimordialMintable Total Primordial ion mintable
534 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
535 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
536 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
537 	 * @return The multiplier in (10 ** 6)
538 	 */
539 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
540 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
541 			/**
542 			 * Let temp = M + (P/2)
543 			 * Multiplier = (1 - (temp / T)) x (S-E)
544 			 */
545 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
546 
547 			/**
548 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
549 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
550 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
551 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
552 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
553 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
554 			 */
555 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
556 			/**
557 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
558 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
559 			 */
560 			return multiplier.div(_MULTIPLIER_DIVISOR);
561 		} else {
562 			return 0;
563 		}
564 	}
565 
566 	/**
567 	 * @dev Calculate the bonus percentage of network ion on a given lot
568 	 *		Total Primordial Mintable = T
569 	 *		Total Primordial Minted = M
570 	 *		Starting Network Bonus Multiplier = Bs
571 	 *		Ending Network Bonus Multiplier = Be
572 	 *		To Purchase = P
573 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
574 	 *
575 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
576 	 * @param _totalPrimordialMintable Total Primordial ion intable
577 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
578 	 * @param _startingMultiplier The starting Network ion bonus multiplier
579 	 * @param _endingMultiplier The ending Network ion bonus multiplier
580 	 * @return The bonus percentage
581 	 */
582 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
583 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
584 			/**
585 			 * Let temp = M + (P/2)
586 			 * B% = (1 - (temp / T)) x (Bs-Be)
587 			 */
588 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
589 
590 			/**
591 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
592 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
593 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
594 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
595 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
596 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
597 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
598 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
599 			 */
600 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
601 			return bonusPercentage;
602 		} else {
603 			return 0;
604 		}
605 	}
606 
607 	/**
608 	 * @dev Calculate the bonus amount of network ion on a given lot
609 	 *		AO Bonus Amount = B% x P
610 	 *
611 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
612 	 * @param _totalPrimordialMintable Total Primordial ion intable
613 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
614 	 * @param _startingMultiplier The starting Network ion bonus multiplier
615 	 * @param _endingMultiplier The ending Network ion bonus multiplier
616 	 * @return The bonus percentage
617 	 */
618 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
619 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
620 		/**
621 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
622 		 * when calculating the network ion bonus amount
623 		 */
624 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
625 		return networkBonus;
626 	}
627 
628 	/**
629 	 * @dev Calculate the maximum amount of Primordial an account can burn
630 	 *		_primordialBalance = P
631 	 *		_currentWeightedMultiplier = M
632 	 *		_maximumMultiplier = S
633 	 *		_amountToBurn = B
634 	 *		B = ((S x P) - (P x M)) / S
635 	 *
636 	 * @param _primordialBalance Account's primordial ion balance
637 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
638 	 * @param _maximumMultiplier The maximum multiplier of this account
639 	 * @return The maximum burn amount
640 	 */
641 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
642 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
643 	}
644 
645 	/**
646 	 * @dev Calculate the new multiplier after burning primordial ion
647 	 *		_primordialBalance = P
648 	 *		_currentWeightedMultiplier = M
649 	 *		_amountToBurn = B
650 	 *		_newMultiplier = E
651 	 *		E = (P x M) / (P - B)
652 	 *
653 	 * @param _primordialBalance Account's primordial ion balance
654 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
655 	 * @param _amountToBurn The amount of primordial ion to burn
656 	 * @return The new multiplier
657 	 */
658 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
659 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
660 	}
661 
662 	/**
663 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
664 	 *		_primordialBalance = P
665 	 *		_currentWeightedMultiplier = M
666 	 *		_amountToConvert = C
667 	 *		_newMultiplier = E
668 	 *		E = (P x M) / (P + C)
669 	 *
670 	 * @param _primordialBalance Account's primordial ion balance
671 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
672 	 * @param _amountToConvert The amount of network ion to convert
673 	 * @return The new multiplier
674 	 */
675 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
676 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
677 	}
678 
679 	/**
680 	 * @dev count num of digits
681 	 * @param number uint256 of the nuumber to be checked
682 	 * @return uint8 num of digits
683 	 */
684 	function numDigits(uint256 number) public pure returns (uint8) {
685 		uint8 digits = 0;
686 		while(number != 0) {
687 			number = number.div(10);
688 			digits++;
689 		}
690 		return digits;
691 	}
692 }
693 
694 
695 
696 contract TheAO {
697 	address public theAO;
698 	address public nameTAOPositionAddress;
699 
700 	// Check whether an address is whitelisted and granted access to transact
701 	// on behalf of others
702 	mapping (address => bool) public whitelist;
703 
704 	constructor() public {
705 		theAO = msg.sender;
706 	}
707 
708 	/**
709 	 * @dev Checks if msg.sender is in whitelist.
710 	 */
711 	modifier inWhitelist() {
712 		require (whitelist[msg.sender] == true);
713 		_;
714 	}
715 
716 	/**
717 	 * @dev Transfer ownership of The AO to new address
718 	 * @param _theAO The new address to be transferred
719 	 */
720 	function transferOwnership(address _theAO) public {
721 		require (msg.sender == theAO);
722 		require (_theAO != address(0));
723 		theAO = _theAO;
724 	}
725 
726 	/**
727 	 * @dev Whitelist `_account` address to transact on behalf of others
728 	 * @param _account The address to whitelist
729 	 * @param _whitelist Either to whitelist or not
730 	 */
731 	function setWhitelist(address _account, bool _whitelist) public {
732 		require (msg.sender == theAO);
733 		require (_account != address(0));
734 		whitelist[_account] = _whitelist;
735 	}
736 }
737 
738 
739 
740 
741 
742 
743 
744 /**
745  * @title AOSettingDeprecation
746  *
747  * This contract responsible for adding setting deprecation
748  */
749 contract AOSettingDeprecation is TheAO {
750 	address public nameFactoryAddress;
751 	address public nameAccountRecoveryAddress;
752 	address public aoSettingAttributeAddress;
753 	address public aoSettingAddress;
754 
755 	INameFactory internal _nameFactory;
756 	INameTAOPosition internal _nameTAOPosition;
757 	INameAccountRecovery internal _nameAccountRecovery;
758 	IAOSettingAttribute internal _aoSettingAttribute;
759 	IAOSetting internal _aoSetting;
760 
761 	// Event to be broadcasted to public when a setting deprecation is created and waiting for approval
762 	event SettingDeprecation(uint256 indexed settingId, address indexed creatorNameId, address creatorTAOId, address associatedTAOId, uint256 newSettingId, address newSettingContractAddress, bytes32 associatedTAOSettingDeprecationId, bytes32 creatorTAOSettingDeprecationId);
763 
764 	// Event to be broadcasted to public when setting deprecation is approved/rejected by the advocate of associatedTAOId
765 	event ApproveSettingDeprecation(uint256 indexed settingId, address associatedTAOId, address associatedTAOAdvocate, bool approved);
766 
767 	// Event to be broadcasted to public when setting deprecation is finalized by the advocate of creatorTAOId
768 	event FinalizeSettingDeprecation(uint256 indexed settingId, address creatorTAOId, address creatorTAOAdvocate);
769 
770 	/**
771 	 * @dev Constructor function
772 	 */
773 	constructor(address _nameFactoryAddress,
774 		address _nameTAOPositionAddress,
775 		address _nameAccountRecoveryAddress,
776 		address _aoSettingAttributeAddress,
777 		address _aoSettingAddress
778 		) public {
779 		setNameFactoryAddress(_nameFactoryAddress);
780 		setNameTAOPositionAddress(_nameTAOPositionAddress);
781 		setNameAccountRecoveryAddress(_nameAccountRecoveryAddress);
782 		setAOSettingAttributeAddress(_aoSettingAttributeAddress);
783 		setAOSettingAddress(_aoSettingAddress);
784 	}
785 
786 	/**
787 	 * @dev Checks if the calling contract address is The AO
788 	 *		OR
789 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
790 	 */
791 	modifier onlyTheAO {
792 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
793 		_;
794 	}
795 
796 	/**
797 	 * @dev Check if `_taoId` is a TAO
798 	 */
799 	modifier isTAO(address _taoId) {
800 		require (AOLibrary.isTAO(_taoId));
801 		_;
802 	}
803 
804 	/**
805 	 * @dev Check if msg.sender is the current advocate of Name ID
806 	 */
807 	modifier onlyAdvocate(address _id) {
808 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _id));
809 		_;
810 	}
811 
812 	/**
813 	 * @dev Check is msg.sender address is a Name
814 	 */
815 	 modifier senderIsName() {
816 		require (_nameFactory.ethAddressToNameId(msg.sender) != address(0));
817 		_;
818 	 }
819 
820 	/**
821 	 * @dev Only allowed if sender's Name is not compromised
822 	 */
823 	modifier senderNameNotCompromised() {
824 		require (!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
825 		_;
826 	}
827 
828 	/***** The AO ONLY METHODS *****/
829 	/**
830 	 * @dev Transfer ownership of The AO to new address
831 	 * @param _theAO The new address to be transferred
832 	 */
833 	function transferOwnership(address _theAO) public onlyTheAO {
834 		require (_theAO != address(0));
835 		theAO = _theAO;
836 	}
837 
838 	/**
839 	 * @dev Whitelist `_account` address to transact on behalf of others
840 	 * @param _account The address to whitelist
841 	 * @param _whitelist Either to whitelist or not
842 	 */
843 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
844 		require (_account != address(0));
845 		whitelist[_account] = _whitelist;
846 	}
847 
848 	/**
849 	 * @dev The AO sets NameFactory address
850 	 * @param _nameFactoryAddress The address of NameFactory
851 	 */
852 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
853 		require (_nameFactoryAddress != address(0));
854 		nameFactoryAddress = _nameFactoryAddress;
855 		_nameFactory = INameFactory(_nameFactoryAddress);
856 	}
857 
858 	/**
859 	 * @dev The AO sets NameTAOPosition address
860 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
861 	 */
862 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
863 		require (_nameTAOPositionAddress != address(0));
864 		nameTAOPositionAddress = _nameTAOPositionAddress;
865 		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
866 	}
867 
868 	/**
869 	 * @dev The AO set the NameAccountRecovery Address
870 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
871 	 */
872 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
873 		require (_nameAccountRecoveryAddress != address(0));
874 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
875 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
876 	}
877 
878 	/**
879 	 * @dev The AO sets AOSettingAttribute address
880 	 * @param _aoSettingAttributeAddress The address of AOSettingAttribute
881 	 */
882 	function setAOSettingAttributeAddress(address _aoSettingAttributeAddress) public onlyTheAO {
883 		require (_aoSettingAttributeAddress != address(0));
884 		aoSettingAttributeAddress = _aoSettingAttributeAddress;
885 		_aoSettingAttribute = IAOSettingAttribute(_aoSettingAttributeAddress);
886 	}
887 
888 	/**
889 	 * @dev The AO sets AOSetting address
890 	 * @param _aoSettingAddress The address of AOSetting
891 	 */
892 	function setAOSettingAddress(address _aoSettingAddress) public onlyTheAO {
893 		require (_aoSettingAddress != address(0));
894 		aoSettingAddress = _aoSettingAddress;
895 		_aoSetting = IAOSetting(_aoSettingAddress);
896 	}
897 
898 	/***** PUBLIC METHODS *****/
899 	/**
900 	 * @dev Advocate of _creatorTAOId adds a setting deprecation
901 	 * @param _settingId The ID of the setting to be deprecated
902 	 * @param _newSettingId The new setting ID to route
903 	 * @param _newSettingContractAddress The new setting contract address to route
904 	 * @param _creatorTAOId The taoId that created the setting
905 	 * @param _associatedTAOId The taoId that the setting affects
906 	 */
907 	function addSettingDeprecation(
908 		uint256 _settingId,
909 		uint256 _newSettingId,
910 		address _newSettingContractAddress,
911 		address _creatorTAOId,
912 		address _associatedTAOId)
913 		public
914 		isTAO(_creatorTAOId)
915 		isTAO(_associatedTAOId)
916 		onlyAdvocate(_creatorTAOId)
917 		senderNameNotCompromised {
918 		// Make sure the settings exist
919 		require (_aoSetting.settingTypeLookup(_settingId) > 0 && _aoSetting.settingTypeLookup(_newSettingId) > 0);
920 
921 		// Make sure it's the same type
922 		require (_aoSetting.settingTypeLookup(_settingId) == _aoSetting.settingTypeLookup(_newSettingId));
923 
924 		(bytes32 _associatedTAOSettingDeprecationId, bytes32 _creatorTAOSettingDeprecationId) = _aoSettingAttribute.addDeprecation(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _creatorTAOId, _associatedTAOId, _newSettingId, _newSettingContractAddress);
925 
926 		emit SettingDeprecation(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _creatorTAOId, _associatedTAOId, _newSettingId, _newSettingContractAddress, _associatedTAOSettingDeprecationId, _creatorTAOSettingDeprecationId);
927 	}
928 
929 	/**
930 	 * @dev Advocate of SettingDeprecation's _associatedTAOId approves setting deprecation
931 	 * @param _settingId The ID of the setting to approve
932 	 * @param _approved Whether to approve or reject
933 	 */
934 	function approveSettingDeprecation(uint256 _settingId, bool _approved) public senderIsName senderNameNotCompromised {
935 		// Make sure setting exist
936 		require (_aoSetting.settingTypeLookup(_settingId) > 0);
937 
938 		address _associatedTAOAdvocate = _nameFactory.ethAddressToNameId(msg.sender);
939 		require (_aoSettingAttribute.approveDeprecation(_settingId, _associatedTAOAdvocate, _approved));
940 
941 		(,,, address _associatedTAOId,,,,,,,,) = _aoSettingAttribute.getSettingDeprecation(_settingId);
942 		emit ApproveSettingDeprecation(_settingId, _associatedTAOId, _associatedTAOAdvocate, _approved);
943 	}
944 
945 	/**
946 	 * @dev Advocate of SettingDeprecation's _creatorTAOId finalizes the setting deprecation once the setting deprecation is approved
947 	 * @param _settingId The ID of the setting to be finalized
948 	 */
949 	function finalizeSettingDeprecation(uint256 _settingId) public senderIsName senderNameNotCompromised {
950 		// Make sure setting exist
951 		require (_aoSetting.settingTypeLookup(_settingId) > 0);
952 
953 		address _creatorTAOAdvocate = _nameFactory.ethAddressToNameId(msg.sender);
954 		require (_aoSettingAttribute.finalizeDeprecation(_settingId, _creatorTAOAdvocate));
955 
956 		(,, address _creatorTAOId,,,,,,,,,) = _aoSettingAttribute.getSettingDeprecation(_settingId);
957 		emit FinalizeSettingDeprecation(_settingId, _creatorTAOId, _creatorTAOAdvocate);
958 	}
959 }