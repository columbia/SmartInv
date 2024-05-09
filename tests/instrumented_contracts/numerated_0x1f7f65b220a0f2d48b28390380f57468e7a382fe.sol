1 pragma solidity >=0.5.4 <0.6.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9 	/**
10 	 * @dev Multiplies two numbers, throws on overflow.
11 	 */
12 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13 		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14 		// benefit is lost if 'b' is also tested.
15 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16 		if (a == 0) {
17 			return 0;
18 		}
19 
20 		c = a * b;
21 		assert(c / a == b);
22 		return c;
23 	}
24 
25 	/**
26 	 * @dev Integer division of two numbers, truncating the quotient.
27 	 */
28 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
29 		// assert(b > 0); // Solidity automatically throws when dividing by 0
30 		// uint256 c = a / b;
31 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
32 		return a / b;
33 	}
34 
35 	/**
36 	 * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37 	 */
38 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39 		assert(b <= a);
40 		return a - b;
41 	}
42 
43 	/**
44 	 * @dev Adds two numbers, throws on overflow.
45 	 */
46 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47 		c = a + b;
48 		assert(c >= a);
49 		return c;
50 	}
51 }
52 
53 
54 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
55 
56 
57 
58 
59 contract TokenERC20 {
60 	// Public variables of the token
61 	string public name;
62 	string public symbol;
63 	uint8 public decimals = 18;
64 	// 18 decimals is the strongly suggested default, avoid changing it
65 	uint256 public totalSupply;
66 
67 	// This creates an array with all balances
68 	mapping (address => uint256) public balanceOf;
69 	mapping (address => mapping (address => uint256)) public allowance;
70 
71 	// This generates a public event on the blockchain that will notify clients
72 	event Transfer(address indexed from, address indexed to, uint256 value);
73 
74 	// This generates a public event on the blockchain that will notify clients
75 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 
77 	// This notifies clients about the amount burnt
78 	event Burn(address indexed from, uint256 value);
79 
80 	/**
81 	 * Constructor function
82 	 *
83 	 * Initializes contract with initial supply tokens to the creator of the contract
84 	 */
85 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
86 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
87 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
88 		name = tokenName;                                   // Set the name for display purposes
89 		symbol = tokenSymbol;                               // Set the symbol for display purposes
90 	}
91 
92 	/**
93 	 * Internal transfer, only can be called by this contract
94 	 */
95 	function _transfer(address _from, address _to, uint _value) internal {
96 		// Prevent transfer to 0x0 address. Use burn() instead
97 		require(_to != address(0));
98 		// Check if the sender has enough
99 		require(balanceOf[_from] >= _value);
100 		// Check for overflows
101 		require(balanceOf[_to] + _value > balanceOf[_to]);
102 		// Save this for an assertion in the future
103 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
104 		// Subtract from the sender
105 		balanceOf[_from] -= _value;
106 		// Add the same to the recipient
107 		balanceOf[_to] += _value;
108 		emit Transfer(_from, _to, _value);
109 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
110 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
111 	}
112 
113 	/**
114 	 * Transfer tokens
115 	 *
116 	 * Send `_value` tokens to `_to` from your account
117 	 *
118 	 * @param _to The address of the recipient
119 	 * @param _value the amount to send
120 	 */
121 	function transfer(address _to, uint256 _value) public returns (bool success) {
122 		_transfer(msg.sender, _to, _value);
123 		return true;
124 	}
125 
126 	/**
127 	 * Transfer tokens from other address
128 	 *
129 	 * Send `_value` tokens to `_to` in behalf of `_from`
130 	 *
131 	 * @param _from The address of the sender
132 	 * @param _to The address of the recipient
133 	 * @param _value the amount to send
134 	 */
135 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
136 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
137 		allowance[_from][msg.sender] -= _value;
138 		_transfer(_from, _to, _value);
139 		return true;
140 	}
141 
142 	/**
143 	 * Set allowance for other address
144 	 *
145 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
146 	 *
147 	 * @param _spender The address authorized to spend
148 	 * @param _value the max amount they can spend
149 	 */
150 	function approve(address _spender, uint256 _value) public returns (bool success) {
151 		allowance[msg.sender][_spender] = _value;
152 		emit Approval(msg.sender, _spender, _value);
153 		return true;
154 	}
155 
156 	/**
157 	 * Set allowance for other address and notify
158 	 *
159 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
160 	 *
161 	 * @param _spender The address authorized to spend
162 	 * @param _value the max amount they can spend
163 	 * @param _extraData some extra information to send to the approved contract
164 	 */
165 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
166 		tokenRecipient spender = tokenRecipient(_spender);
167 		if (approve(_spender, _value)) {
168 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
169 			return true;
170 		}
171 	}
172 
173 	/**
174 	 * Destroy tokens
175 	 *
176 	 * Remove `_value` tokens from the system irreversibly
177 	 *
178 	 * @param _value the amount of money to burn
179 	 */
180 	function burn(uint256 _value) public returns (bool success) {
181 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
182 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
183 		totalSupply -= _value;                      // Updates totalSupply
184 		emit Burn(msg.sender, _value);
185 		return true;
186 	}
187 
188 	/**
189 	 * Destroy tokens from other account
190 	 *
191 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
192 	 *
193 	 * @param _from the address of the sender
194 	 * @param _value the amount of money to burn
195 	 */
196 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
197 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
198 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
199 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
200 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
201 		totalSupply -= _value;                              // Update totalSupply
202 		emit Burn(_from, _value);
203 		return true;
204 	}
205 }
206 
207 
208 interface INameAccountRecovery {
209 	function isCompromised(address _id) external view returns (bool);
210 }
211 
212 
213 interface INameTAOPosition {
214 	function senderIsAdvocate(address _sender, address _id) external view returns (bool);
215 	function senderIsListener(address _sender, address _id) external view returns (bool);
216 	function senderIsSpeaker(address _sender, address _id) external view returns (bool);
217 	function senderIsPosition(address _sender, address _id) external view returns (bool);
218 	function getAdvocate(address _id) external view returns (address);
219 	function nameIsAdvocate(address _nameId, address _id) external view returns (bool);
220 	function nameIsPosition(address _nameId, address _id) external view returns (bool);
221 	function initialize(address _id, address _advocateId, address _listenerId, address _speakerId) external returns (bool);
222 	function determinePosition(address _sender, address _id) external view returns (uint256);
223 }
224 
225 
226 interface INameFactory {
227 	function nonces(address _nameId) external view returns (uint256);
228 	function incrementNonce(address _nameId) external returns (uint256);
229 	function ethAddressToNameId(address _ethAddress) external view returns (address);
230 	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
231 	function nameIdToEthAddress(address _nameId) external view returns (address);
232 }
233 
234 
235 
236 
237 
238 /**
239  * @title TAO
240  */
241 contract TAO {
242 	using SafeMath for uint256;
243 
244 	address public vaultAddress;
245 	string public name;				// the name for this TAO
246 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
247 
248 	// TAO's data
249 	string public datHash;
250 	string public database;
251 	string public keyValue;
252 	bytes32 public contentId;
253 
254 	/**
255 	 * 0 = TAO
256 	 * 1 = Name
257 	 */
258 	uint8 public typeId;
259 
260 	/**
261 	 * @dev Constructor function
262 	 */
263 	constructor (string memory _name,
264 		address _originId,
265 		string memory _datHash,
266 		string memory _database,
267 		string memory _keyValue,
268 		bytes32 _contentId,
269 		address _vaultAddress
270 	) public {
271 		name = _name;
272 		originId = _originId;
273 		datHash = _datHash;
274 		database = _database;
275 		keyValue = _keyValue;
276 		contentId = _contentId;
277 
278 		// Creating TAO
279 		typeId = 0;
280 
281 		vaultAddress = _vaultAddress;
282 	}
283 
284 	/**
285 	 * @dev Checks if calling address is Vault contract
286 	 */
287 	modifier onlyVault {
288 		require (msg.sender == vaultAddress);
289 		_;
290 	}
291 
292 	/**
293 	 * Will receive any ETH sent
294 	 */
295 	function () external payable {
296 	}
297 
298 	/**
299 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
300 	 * @param _recipient The recipient address
301 	 * @param _amount The amount to transfer
302 	 * @return true on success
303 	 */
304 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
305 		_recipient.transfer(_amount);
306 		return true;
307 	}
308 
309 	/**
310 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
311 	 * @param _erc20TokenAddress The address of ERC20 Token
312 	 * @param _recipient The recipient address
313 	 * @param _amount The amount to transfer
314 	 * @return true on success
315 	 */
316 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
317 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
318 		_erc20.transfer(_recipient, _amount);
319 		return true;
320 	}
321 }
322 
323 
324 interface IAOSetting {
325 	function getSettingValuesByTAOName(address _taoId, string calldata _settingName) external view returns (uint256, bool, address, bytes32, string memory);
326 	function getSettingTypes() external view returns (uint8, uint8, uint8, uint8, uint8);
327 
328 	function settingTypeLookup(uint256 _settingId) external view returns (uint8);
329 }
330 
331 
332 interface ITAOAncestry {
333 	function initialize(address _id, address _parentId, uint256 _childMinLogos) external returns (bool);
334 
335 	function getAncestryById(address _id) external view returns (address, uint256, uint256);
336 
337 	function addChild(address _taoId, address _childId) external returns (bool);
338 
339 	function isChild(address _taoId, address _childId) external view returns (bool);
340 }
341 
342 
343 interface ITAOFactory {
344 	function nonces(address _taoId) external view returns (uint256);
345 	function incrementNonce(address _taoId) external returns (uint256);
346 }
347 
348 
349 
350 
351 
352 
353 
354 
355 
356 
357 /**
358  * @title Name
359  */
360 contract Name is TAO {
361 	/**
362 	 * @dev Constructor function
363 	 */
364 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
365 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
366 		// Creating Name
367 		typeId = 1;
368 	}
369 }
370 
371 
372 
373 
374 /**
375  * @title AOLibrary
376  */
377 library AOLibrary {
378 	using SafeMath for uint256;
379 
380 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
381 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
382 
383 	/**
384 	 * @dev Check whether or not the given TAO ID is a TAO
385 	 * @param _taoId The ID of the TAO
386 	 * @return true if yes. false otherwise
387 	 */
388 	function isTAO(address _taoId) public view returns (bool) {
389 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
390 	}
391 
392 	/**
393 	 * @dev Check whether or not the given Name ID is a Name
394 	 * @param _nameId The ID of the Name
395 	 * @return true if yes. false otherwise
396 	 */
397 	function isName(address _nameId) public view returns (bool) {
398 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
399 	}
400 
401 	/**
402 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
403 	 * @param _tokenAddress The ERC20 Token address to check
404 	 */
405 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
406 		if (_tokenAddress == address(0)) {
407 			return false;
408 		}
409 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
410 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
411 	}
412 
413 	/**
414 	 * @dev Checks if the calling contract address is The AO
415 	 *		OR
416 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
417 	 * @param _sender The address to check
418 	 * @param _theAO The AO address
419 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
420 	 * @return true if yes, false otherwise
421 	 */
422 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
423 		return (_sender == _theAO ||
424 			(
425 				(isTAO(_theAO) || isName(_theAO)) &&
426 				_nameTAOPositionAddress != address(0) &&
427 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
428 			)
429 		);
430 	}
431 
432 	/**
433 	 * @dev Return the divisor used to correctly calculate percentage.
434 	 *		Percentage stored throughout AO contracts covers 4 decimals,
435 	 *		so 1% is 10000, 1.25% is 12500, etc
436 	 */
437 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
438 		return _PERCENTAGE_DIVISOR;
439 	}
440 
441 	/**
442 	 * @dev Return the divisor used to correctly calculate multiplier.
443 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
444 	 *		so 1 is 1000000, 0.023 is 23000, etc
445 	 */
446 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
447 		return _MULTIPLIER_DIVISOR;
448 	}
449 
450 	/**
451 	 * @dev deploy a TAO
452 	 * @param _name The name of the TAO
453 	 * @param _originId The Name ID the creates the TAO
454 	 * @param _datHash The datHash of this TAO
455 	 * @param _database The database for this TAO
456 	 * @param _keyValue The key/value pair to be checked on the database
457 	 * @param _contentId The contentId related to this TAO
458 	 * @param _nameTAOVaultAddress The address of NameTAOVault
459 	 */
460 	function deployTAO(string memory _name,
461 		address _originId,
462 		string memory _datHash,
463 		string memory _database,
464 		string memory _keyValue,
465 		bytes32 _contentId,
466 		address _nameTAOVaultAddress
467 		) public returns (TAO _tao) {
468 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
469 	}
470 
471 	/**
472 	 * @dev deploy a Name
473 	 * @param _name The name of the Name
474 	 * @param _originId The eth address the creates the Name
475 	 * @param _datHash The datHash of this Name
476 	 * @param _database The database for this Name
477 	 * @param _keyValue The key/value pair to be checked on the database
478 	 * @param _contentId The contentId related to this Name
479 	 * @param _nameTAOVaultAddress The address of NameTAOVault
480 	 */
481 	function deployName(string memory _name,
482 		address _originId,
483 		string memory _datHash,
484 		string memory _database,
485 		string memory _keyValue,
486 		bytes32 _contentId,
487 		address _nameTAOVaultAddress
488 		) public returns (Name _myName) {
489 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
490 	}
491 
492 	/**
493 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
494 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
495 	 * @param _currentPrimordialBalance Account's current primordial ion balance
496 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
497 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
498 	 * @return the new primordial weighted multiplier
499 	 */
500 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
501 		if (_currentWeightedMultiplier > 0) {
502 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
503 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
504 			return _totalWeightedIons.div(_totalIons);
505 		} else {
506 			return _additionalWeightedMultiplier;
507 		}
508 	}
509 
510 	/**
511 	 * @dev Calculate the primordial ion multiplier on a given lot
512 	 *		Total Primordial Mintable = T
513 	 *		Total Primordial Minted = M
514 	 *		Starting Multiplier = S
515 	 *		Ending Multiplier = E
516 	 *		To Purchase = P
517 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
518 	 *
519 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
520 	 * @param _totalPrimordialMintable Total Primordial ion mintable
521 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
522 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
523 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
524 	 * @return The multiplier in (10 ** 6)
525 	 */
526 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
527 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
528 			/**
529 			 * Let temp = M + (P/2)
530 			 * Multiplier = (1 - (temp / T)) x (S-E)
531 			 */
532 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
533 
534 			/**
535 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
536 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
537 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
538 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
539 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
540 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
541 			 */
542 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
543 			/**
544 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
545 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
546 			 */
547 			return multiplier.div(_MULTIPLIER_DIVISOR);
548 		} else {
549 			return 0;
550 		}
551 	}
552 
553 	/**
554 	 * @dev Calculate the bonus percentage of network ion on a given lot
555 	 *		Total Primordial Mintable = T
556 	 *		Total Primordial Minted = M
557 	 *		Starting Network Bonus Multiplier = Bs
558 	 *		Ending Network Bonus Multiplier = Be
559 	 *		To Purchase = P
560 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
561 	 *
562 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
563 	 * @param _totalPrimordialMintable Total Primordial ion intable
564 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
565 	 * @param _startingMultiplier The starting Network ion bonus multiplier
566 	 * @param _endingMultiplier The ending Network ion bonus multiplier
567 	 * @return The bonus percentage
568 	 */
569 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
570 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
571 			/**
572 			 * Let temp = M + (P/2)
573 			 * B% = (1 - (temp / T)) x (Bs-Be)
574 			 */
575 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
576 
577 			/**
578 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
579 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
580 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
581 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
582 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
583 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
584 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
585 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
586 			 */
587 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
588 			return bonusPercentage;
589 		} else {
590 			return 0;
591 		}
592 	}
593 
594 	/**
595 	 * @dev Calculate the bonus amount of network ion on a given lot
596 	 *		AO Bonus Amount = B% x P
597 	 *
598 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
599 	 * @param _totalPrimordialMintable Total Primordial ion intable
600 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
601 	 * @param _startingMultiplier The starting Network ion bonus multiplier
602 	 * @param _endingMultiplier The ending Network ion bonus multiplier
603 	 * @return The bonus percentage
604 	 */
605 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
606 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
607 		/**
608 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
609 		 * when calculating the network ion bonus amount
610 		 */
611 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
612 		return networkBonus;
613 	}
614 
615 	/**
616 	 * @dev Calculate the maximum amount of Primordial an account can burn
617 	 *		_primordialBalance = P
618 	 *		_currentWeightedMultiplier = M
619 	 *		_maximumMultiplier = S
620 	 *		_amountToBurn = B
621 	 *		B = ((S x P) - (P x M)) / S
622 	 *
623 	 * @param _primordialBalance Account's primordial ion balance
624 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
625 	 * @param _maximumMultiplier The maximum multiplier of this account
626 	 * @return The maximum burn amount
627 	 */
628 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
629 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
630 	}
631 
632 	/**
633 	 * @dev Calculate the new multiplier after burning primordial ion
634 	 *		_primordialBalance = P
635 	 *		_currentWeightedMultiplier = M
636 	 *		_amountToBurn = B
637 	 *		_newMultiplier = E
638 	 *		E = (P x M) / (P - B)
639 	 *
640 	 * @param _primordialBalance Account's primordial ion balance
641 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
642 	 * @param _amountToBurn The amount of primordial ion to burn
643 	 * @return The new multiplier
644 	 */
645 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
646 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
647 	}
648 
649 	/**
650 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
651 	 *		_primordialBalance = P
652 	 *		_currentWeightedMultiplier = M
653 	 *		_amountToConvert = C
654 	 *		_newMultiplier = E
655 	 *		E = (P x M) / (P + C)
656 	 *
657 	 * @param _primordialBalance Account's primordial ion balance
658 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
659 	 * @param _amountToConvert The amount of network ion to convert
660 	 * @return The new multiplier
661 	 */
662 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
663 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
664 	}
665 
666 	/**
667 	 * @dev count num of digits
668 	 * @param number uint256 of the nuumber to be checked
669 	 * @return uint8 num of digits
670 	 */
671 	function numDigits(uint256 number) public pure returns (uint8) {
672 		uint8 digits = 0;
673 		while(number != 0) {
674 			number = number.div(10);
675 			digits++;
676 		}
677 		return digits;
678 	}
679 }
680 
681 
682 
683 contract TheAO {
684 	address public theAO;
685 	address public nameTAOPositionAddress;
686 
687 	// Check whether an address is whitelisted and granted access to transact
688 	// on behalf of others
689 	mapping (address => bool) public whitelist;
690 
691 	constructor() public {
692 		theAO = msg.sender;
693 	}
694 
695 	/**
696 	 * @dev Checks if msg.sender is in whitelist.
697 	 */
698 	modifier inWhitelist() {
699 		require (whitelist[msg.sender] == true);
700 		_;
701 	}
702 
703 	/**
704 	 * @dev Transfer ownership of The AO to new address
705 	 * @param _theAO The new address to be transferred
706 	 */
707 	function transferOwnership(address _theAO) public {
708 		require (msg.sender == theAO);
709 		require (_theAO != address(0));
710 		theAO = _theAO;
711 	}
712 
713 	/**
714 	 * @dev Whitelist `_account` address to transact on behalf of others
715 	 * @param _account The address to whitelist
716 	 * @param _whitelist Either to whitelist or not
717 	 */
718 	function setWhitelist(address _account, bool _whitelist) public {
719 		require (msg.sender == theAO);
720 		require (_account != address(0));
721 		whitelist[_account] = _whitelist;
722 	}
723 }
724 
725 
726 
727 
728 
729 
730 
731 
732 
733 
734 
735 
736 
737 
738 
739 /**
740  * @title TAOCurrency
741  */
742 contract TAOCurrency is TheAO {
743 	using SafeMath for uint256;
744 
745 	// Public variables of the contract
746 	string public name;
747 	string public symbol;
748 	uint8 public decimals;
749 
750 	// To differentiate denomination of TAO Currency
751 	uint256 public powerOfTen;
752 
753 	uint256 public totalSupply;
754 
755 	// This creates an array with all balances
756 	// address is the address of nameId, not the eth public address
757 	mapping (address => uint256) public balanceOf;
758 
759 	// This generates a public event on the blockchain that will notify clients
760 	// address is the address of TAO/Name Id, not eth public address
761 	event Transfer(address indexed from, address indexed to, uint256 value);
762 
763 	// This notifies clients about the amount burnt
764 	// address is the address of TAO/Name Id, not eth public address
765 	event Burn(address indexed from, uint256 value);
766 
767 	/**
768 	 * Constructor function
769 	 *
770 	 * Initializes contract with initial supply TAOCurrency to the creator of the contract
771 	 */
772 	constructor (string memory _name, string memory _symbol, address _nameTAOPositionAddress) public {
773 		name = _name;		// Set the name for display purposes
774 		symbol = _symbol;	// Set the symbol for display purposes
775 
776 		powerOfTen = 0;
777 		decimals = 0;
778 
779 		setNameTAOPositionAddress(_nameTAOPositionAddress);
780 	}
781 
782 	/**
783 	 * @dev Checks if the calling contract address is The AO
784 	 *		OR
785 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
786 	 */
787 	modifier onlyTheAO {
788 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
789 		_;
790 	}
791 
792 	/**
793 	 * @dev Check if `_id` is a Name or a TAO
794 	 */
795 	modifier isNameOrTAO(address _id) {
796 		require (AOLibrary.isName(_id) || AOLibrary.isTAO(_id));
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
821 	 * @dev The AO set the NameTAOPosition Address
822 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
823 	 */
824 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
825 		require (_nameTAOPositionAddress != address(0));
826 		nameTAOPositionAddress = _nameTAOPositionAddress;
827 	}
828 
829 	/***** PUBLIC METHODS *****/
830 	/**
831 	 * @dev transfer TAOCurrency from other address
832 	 *
833 	 * Send `_value` TAOCurrency to `_to` in behalf of `_from`
834 	 *
835 	 * @param _from The address of the sender
836 	 * @param _to The address of the recipient
837 	 * @param _value the amount to send
838 	 */
839 	function transferFrom(address _from, address _to, uint256 _value) public inWhitelist isNameOrTAO(_from) isNameOrTAO(_to) returns (bool) {
840 		_transfer(_from, _to, _value);
841 		return true;
842 	}
843 
844 	/**
845 	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
846 	 * @param target Address to receive TAOCurrency
847 	 * @param mintedAmount The amount of TAOCurrency it will receive
848 	 * @return true on success
849 	 */
850 	function mint(address target, uint256 mintedAmount) public inWhitelist isNameOrTAO(target) returns (bool) {
851 		_mint(target, mintedAmount);
852 		return true;
853 	}
854 
855 	/**
856 	 *
857 	 * @dev Whitelisted address remove `_value` TAOCurrency from the system irreversibly on behalf of `_from`.
858 	 *
859 	 * @param _from the address of the sender
860 	 * @param _value the amount of money to burn
861 	 */
862 	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist isNameOrTAO(_from) returns (bool success) {
863 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
864 		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
865 		totalSupply = totalSupply.sub(_value);              // Update totalSupply
866 		emit Burn(_from, _value);
867 		return true;
868 	}
869 
870 	/***** INTERNAL METHODS *****/
871 	/**
872 	 * @dev Send `_value` TAOCurrency from `_from` to `_to`
873 	 * @param _from The address of sender
874 	 * @param _to The address of the recipient
875 	 * @param _value The amount to send
876 	 */
877 	function _transfer(address _from, address _to, uint256 _value) internal {
878 		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
879 		require (balanceOf[_from] >= _value);					// Check if the sender has enough
880 		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
881 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
882 		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
883 		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
884 		emit Transfer(_from, _to, _value);
885 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
886 	}
887 
888 	/**
889 	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
890 	 * @param target Address to receive TAOCurrency
891 	 * @param mintedAmount The amount of TAOCurrency it will receive
892 	 */
893 	function _mint(address target, uint256 mintedAmount) internal {
894 		balanceOf[target] = balanceOf[target].add(mintedAmount);
895 		totalSupply = totalSupply.add(mintedAmount);
896 		emit Transfer(address(0), address(this), mintedAmount);
897 		emit Transfer(address(this), target, mintedAmount);
898 	}
899 }
900 
901 
902 
903 
904 
905 contract Logos is TAOCurrency {
906 	address public nameFactoryAddress;
907 	address public nameAccountRecoveryAddress;
908 
909 	INameFactory internal _nameFactory;
910 	INameTAOPosition internal _nameTAOPosition;
911 	INameAccountRecovery internal _nameAccountRecovery;
912 
913 	// Mapping of a Name ID to the amount of Logos positioned by others to itself
914 	// address is the address of nameId, not the eth public address
915 	mapping (address => uint256) public positionFromOthers;
916 
917 	// Mapping of Name ID to other Name ID and the amount of Logos positioned by itself
918 	mapping (address => mapping(address => uint256)) public positionOnOthers;
919 
920 	// Mapping of a Name ID to the total amount of Logos positioned by itself on others
921 	mapping (address => uint256) public totalPositionOnOthers;
922 
923 	// Mapping of Name ID to it's advocated TAO ID and the amount of Logos earned
924 	mapping (address => mapping(address => uint256)) public advocatedTAOLogos;
925 
926 	// Mapping of a Name ID to the total amount of Logos earned from advocated TAO
927 	mapping (address => uint256) public totalAdvocatedTAOLogos;
928 
929 	// Event broadcasted to public when `from` address position `value` Logos to `to`
930 	event PositionFrom(address indexed from, address indexed to, uint256 value);
931 
932 	// Event broadcasted to public when `from` address unposition `value` Logos from `to`
933 	event UnpositionFrom(address indexed from, address indexed to, uint256 value);
934 
935 	// Event broadcasted to public when `nameId` receives `amount` of Logos from advocating `taoId`
936 	event AddAdvocatedTAOLogos(address indexed nameId, address indexed taoId, uint256 amount);
937 
938 	// Event broadcasted to public when Logos from advocating `taoId` is transferred from `fromNameId` to `toNameId`
939 	event TransferAdvocatedTAOLogos(address indexed fromNameId, address indexed toNameId, address indexed taoId, uint256 amount);
940 
941 	/**
942 	 * @dev Constructor function
943 	 */
944 	constructor(string memory _name, string memory _symbol, address _nameFactoryAddress, address _nameTAOPositionAddress)
945 		TAOCurrency(_name, _symbol, _nameTAOPositionAddress) public {
946 		setNameFactoryAddress(_nameFactoryAddress);
947 		setNameTAOPositionAddress(_nameTAOPositionAddress);
948 	}
949 
950 	/**
951 	 * @dev Check if `_taoId` is a TAO
952 	 */
953 	modifier isTAO(address _taoId) {
954 		require (AOLibrary.isTAO(_taoId));
955 		_;
956 	}
957 
958 	/**
959 	 * @dev Check if `_nameId` is a Name
960 	 */
961 	modifier isName(address _nameId) {
962 		require (AOLibrary.isName(_nameId));
963 		_;
964 	}
965 
966 	/**
967 	 * @dev Check if msg.sender is the current advocate of _id
968 	 */
969 	modifier onlyAdvocate(address _id) {
970 		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _id));
971 		_;
972 	}
973 
974 	/**
975 	 * @dev Only allowed if Name is not compromised
976 	 */
977 	modifier nameNotCompromised(address _id) {
978 		require (!_nameAccountRecovery.isCompromised(_id));
979 		_;
980 	}
981 
982 	/**
983 	 * @dev Only allowed if sender's Name is not compromised
984 	 */
985 	modifier senderNameNotCompromised() {
986 		require (!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
987 		_;
988 	}
989 
990 	/***** THE AO ONLY METHODS *****/
991 	/**
992 	 * @dev The AO sets NameFactory address
993 	 * @param _nameFactoryAddress The address of NameFactory
994 	 */
995 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
996 		require (_nameFactoryAddress != address(0));
997 		nameFactoryAddress = _nameFactoryAddress;
998 		_nameFactory = INameFactory(_nameFactoryAddress);
999 	}
1000 
1001 	/**
1002 	 * @dev The AO set the NameTAOPosition Address
1003 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
1004 	 */
1005 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
1006 		require (_nameTAOPositionAddress != address(0));
1007 		nameTAOPositionAddress = _nameTAOPositionAddress;
1008 		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
1009 	}
1010 
1011 	/**
1012 	 * @dev The AO set the NameAccountRecovery Address
1013 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
1014 	 */
1015 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
1016 		require (_nameAccountRecoveryAddress != address(0));
1017 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
1018 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
1019 	}
1020 
1021 	/***** PUBLIC METHODS *****/
1022 	/**
1023 	 * @dev Get the total sum of Logos for an address
1024 	 * @param _target The address to check
1025 	 * @return The total sum of Logos (own + positioned + advocated TAOs)
1026 	 */
1027 	function sumBalanceOf(address _target) public isName(_target) view returns (uint256) {
1028 		return balanceOf[_target].add(positionFromOthers[_target]).add(totalAdvocatedTAOLogos[_target]);
1029 	}
1030 
1031 	/**
1032 	 * @dev Return the amount of Logos that are available to be positioned on other
1033 	 * @param _sender The sender address to check
1034 	 * @return The amount of Logos that are available to be positioned on other
1035 	 */
1036 	function availableToPositionAmount(address _sender) public isName(_sender) view returns (uint256) {
1037 		return balanceOf[_sender].sub(totalPositionOnOthers[_sender]);
1038 	}
1039 
1040 	/**
1041 	 * @dev `_from` Name position `_value` Logos onto `_to` Name
1042 	 *
1043 	 * @param _from The address of the sender
1044 	 * @param _to The address of the recipient
1045 	 * @param _value the amount to position
1046 	 * @return true on success
1047 	 */
1048 	function positionFrom(address _from, address _to, uint256 _value) public isName(_from) isName(_to) nameNotCompromised(_from) nameNotCompromised(_to) onlyAdvocate(_from) senderNameNotCompromised returns (bool) {
1049 		require (_from != _to);	// Can't position Logos to itself
1050 		require (availableToPositionAmount(_from) >= _value); // should have enough balance to position
1051 		require (positionFromOthers[_to].add(_value) >= positionFromOthers[_to]); // check for overflows
1052 
1053 		positionOnOthers[_from][_to] = positionOnOthers[_from][_to].add(_value);
1054 		totalPositionOnOthers[_from] = totalPositionOnOthers[_from].add(_value);
1055 		positionFromOthers[_to] = positionFromOthers[_to].add(_value);
1056 
1057 		emit PositionFrom(_from, _to, _value);
1058 		return true;
1059 	}
1060 
1061 	/**
1062 	 * @dev `_from` Name unposition `_value` Logos from `_to` Name
1063 	 *
1064 	 * @param _from The address of the sender
1065 	 * @param _to The address of the recipient
1066 	 * @param _value the amount to unposition
1067 	 * @return true on success
1068 	 */
1069 	function unpositionFrom(address _from, address _to, uint256 _value) public isName(_from) isName(_to) nameNotCompromised(_from) nameNotCompromised(_to) onlyAdvocate(_from) senderNameNotCompromised returns (bool) {
1070 		require (_from != _to);	// Can't unposition Logos to itself
1071 		require (positionOnOthers[_from][_to] >= _value);
1072 
1073 		positionOnOthers[_from][_to] = positionOnOthers[_from][_to].sub(_value);
1074 		totalPositionOnOthers[_from] = totalPositionOnOthers[_from].sub(_value);
1075 		positionFromOthers[_to] = positionFromOthers[_to].sub(_value);
1076 
1077 		emit UnpositionFrom(_from, _to, _value);
1078 		return true;
1079 	}
1080 
1081 	/**
1082 	 * @dev Add `_amount` logos earned from advocating a TAO `_taoId` to its Advocate
1083 	 * @param _taoId The ID of the advocated TAO
1084 	 * @param _amount the amount to reward
1085 	 * @return true on success
1086 	 */
1087 	function addAdvocatedTAOLogos(address _taoId, uint256 _amount) public inWhitelist isTAO(_taoId) returns (bool) {
1088 		require (_amount > 0);
1089 		address _nameId = _nameTAOPosition.getAdvocate(_taoId);
1090 
1091 		advocatedTAOLogos[_nameId][_taoId] = advocatedTAOLogos[_nameId][_taoId].add(_amount);
1092 		totalAdvocatedTAOLogos[_nameId] = totalAdvocatedTAOLogos[_nameId].add(_amount);
1093 
1094 		emit AddAdvocatedTAOLogos(_nameId, _taoId, _amount);
1095 		return true;
1096 	}
1097 
1098 	/**
1099 	 * @dev Transfer logos earned from advocating a TAO `_taoId` from `_fromNameId` to the Advocate of `_taoId`
1100 	 * @param _fromNameId The ID of the Name that sends the Logos
1101 	 * @param _taoId The ID of the advocated TAO
1102 	 * @return true on success
1103 	 */
1104 	function transferAdvocatedTAOLogos(address _fromNameId, address _taoId) public inWhitelist isName(_fromNameId) isTAO(_taoId) returns (bool) {
1105 		address _toNameId = _nameTAOPosition.getAdvocate(_taoId);
1106 		require (_fromNameId != _toNameId);
1107 		require (totalAdvocatedTAOLogos[_fromNameId] >= advocatedTAOLogos[_fromNameId][_taoId]);
1108 
1109 		uint256 _amount = advocatedTAOLogos[_fromNameId][_taoId];
1110 		advocatedTAOLogos[_fromNameId][_taoId] = 0;
1111 		totalAdvocatedTAOLogos[_fromNameId] = totalAdvocatedTAOLogos[_fromNameId].sub(_amount);
1112 		advocatedTAOLogos[_toNameId][_taoId] = advocatedTAOLogos[_toNameId][_taoId].add(_amount);
1113 		totalAdvocatedTAOLogos[_toNameId] = totalAdvocatedTAOLogos[_toNameId].add(_amount);
1114 
1115 		emit TransferAdvocatedTAOLogos(_fromNameId, _toNameId, _taoId, _amount);
1116 		return true;
1117 	}
1118 }
1119 
1120 
1121 
1122 /**
1123  * @title NameTAOPosition
1124  */
1125 contract NameTAOPosition is TheAO, INameTAOPosition {
1126 	using SafeMath for uint256;
1127 
1128 	address public settingTAOId;
1129 	address public nameFactoryAddress;
1130 	address public nameAccountRecoveryAddress;
1131 	address public taoFactoryAddress;
1132 	address public aoSettingAddress;
1133 	address public taoAncestryAddress;
1134 	address public logosAddress;
1135 
1136 	uint256 public totalTAOAdvocateChallenges;
1137 
1138 	INameFactory internal _nameFactory;
1139 	INameAccountRecovery internal _nameAccountRecovery;
1140 	ITAOFactory internal _taoFactory;
1141 	IAOSetting internal _aoSetting;
1142 	ITAOAncestry internal _taoAncestry;
1143 	Logos internal _logos;
1144 
1145 	struct PositionDetail {
1146 		address advocateId;
1147 		address listenerId;
1148 		address speakerId;
1149 		bool created;
1150 	}
1151 
1152 	struct TAOAdvocateChallenge {
1153 		bytes32 challengeId;
1154 		address newAdvocateId;		// The Name ID that wants to be the new Advocate
1155 		address taoId;				// The TAO ID being challenged
1156 		bool completed;				// Status of the challenge
1157 		uint256 createdTimestamp;	// Timestamp when this challenge is created
1158 		uint256 lockedUntilTimestamp;	// The deadline for current Advocate to respond
1159 		uint256 completeBeforeTimestamp; // The deadline for the challenger to respond and complete the challenge
1160 	}
1161 
1162 	// Mapping from Name/TAO ID to its PositionDetail info
1163 	mapping (address => PositionDetail) internal positionDetails;
1164 
1165 	// Mapping from challengeId to TAOAdvocateChallenge info
1166 	mapping (bytes32 => TAOAdvocateChallenge) internal taoAdvocateChallenges;
1167 
1168 	// Event to be broadcasted to public when current Advocate of TAO sets New Advocate
1169 	event SetAdvocate(address indexed taoId, address oldAdvocateId, address newAdvocateId, uint256 nonce);
1170 
1171 	// Event to be broadcasted to public when current Advocate of Name/TAO sets New Listener
1172 	event SetListener(address indexed taoId, address oldListenerId, address newListenerId, uint256 nonce);
1173 
1174 	// Event to be broadcasted to public when current Advocate of Name/TAO sets New Speaker
1175 	event SetSpeaker(address indexed taoId, address oldSpeakerId, address newSpeakerId, uint256 nonce);
1176 
1177 	// Event to be broadcasted to public when a Name challenges to become TAO's new Advocate
1178 	event ChallengeTAOAdvocate(address indexed taoId, bytes32 indexed challengeId, address currentAdvocateId, address challengerAdvocateId, uint256 createdTimestamp, uint256 lockedUntilTimestamp, uint256 completeBeforeTimestamp);
1179 
1180 	// Event to be broadcasted to public when Challenger completes the TAO Advocate challenge
1181 	event CompleteTAOAdvocateChallenge(address indexed taoId, bytes32 indexed challengeId);
1182 
1183 	/**
1184 	 * @dev Constructor function
1185 	 */
1186 	constructor(address _nameFactoryAddress, address _taoFactoryAddress) public {
1187 		setNameFactoryAddress(_nameFactoryAddress);
1188 		setTAOFactoryAddress(_taoFactoryAddress);
1189 
1190 		nameTAOPositionAddress = address(this);
1191 	}
1192 
1193 	/**
1194 	 * @dev Checks if the calling contract address is The AO
1195 	 *		OR
1196 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
1197 	 */
1198 	modifier onlyTheAO {
1199 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
1200 		_;
1201 	}
1202 
1203 	/**
1204 	 * @dev Check if calling address is Factory
1205 	 */
1206 	modifier onlyFactory {
1207 		require (msg.sender == nameFactoryAddress || msg.sender == taoFactoryAddress);
1208 		_;
1209 	}
1210 
1211 	/**
1212 	 * @dev Check if `_taoId` is a TAO
1213 	 */
1214 	modifier isTAO(address _taoId) {
1215 		require (AOLibrary.isTAO(_taoId));
1216 		_;
1217 	}
1218 
1219 	/**
1220 	 * @dev Check if `_nameId` is a Name
1221 	 */
1222 	modifier isName(address _nameId) {
1223 		require (AOLibrary.isName(_nameId));
1224 		_;
1225 	}
1226 
1227 	/**
1228 	 * @dev Check if `_id` is a Name or a TAO
1229 	 */
1230 	modifier isNameOrTAO(address _id) {
1231 		require (AOLibrary.isName(_id) || AOLibrary.isTAO(_id));
1232 		_;
1233 	}
1234 
1235 	/**
1236 	 * @dev Check is msg.sender address is a Name
1237 	 */
1238 	 modifier senderIsName() {
1239 		require (_nameFactory.ethAddressToNameId(msg.sender) != address(0));
1240 		_;
1241 	 }
1242 
1243 	/**
1244 	 * @dev Check if msg.sender is the current advocate of a Name/TAO ID
1245 	 */
1246 	modifier onlyAdvocate(address _id) {
1247 		require (this.senderIsAdvocate(msg.sender, _id));
1248 		_;
1249 	}
1250 
1251 	/**
1252 	 * @dev Only allowed if sender's Name is not compromised
1253 	 */
1254 	modifier senderNameNotCompromised() {
1255 		require (!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
1256 		_;
1257 	}
1258 
1259 	/***** The AO ONLY METHODS *****/
1260 	/**
1261 	 * @dev Transfer ownership of The AO to new address
1262 	 * @param _theAO The new address to be transferred
1263 	 */
1264 	function transferOwnership(address _theAO) public onlyTheAO {
1265 		require (_theAO != address(0));
1266 		theAO = _theAO;
1267 	}
1268 
1269 	/**
1270 	 * @dev Whitelist `_account` address to transact on behalf of others
1271 	 * @param _account The address to whitelist
1272 	 * @param _whitelist Either to whitelist or not
1273 	 */
1274 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
1275 		require (_account != address(0));
1276 		whitelist[_account] = _whitelist;
1277 	}
1278 
1279 	/**
1280 	 * @dev The AO set the NameFactory Address
1281 	 * @param _nameFactoryAddress The address of NameFactory
1282 	 */
1283 	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
1284 		require (_nameFactoryAddress != address(0));
1285 		nameFactoryAddress = _nameFactoryAddress;
1286 		_nameFactory = INameFactory(_nameFactoryAddress);
1287 	}
1288 
1289 	/**
1290 	 * @dev The AO set the NameAccountRecovery Address
1291 	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
1292 	 */
1293 	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
1294 		require (_nameAccountRecoveryAddress != address(0));
1295 		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
1296 		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
1297 	}
1298 
1299 	/**
1300 	 * @dev The AO set the TAOFactory Address
1301 	 * @param _taoFactoryAddress The address of TAOFactory
1302 	 */
1303 	function setTAOFactoryAddress(address _taoFactoryAddress) public onlyTheAO {
1304 		require (_taoFactoryAddress != address(0));
1305 		taoFactoryAddress = _taoFactoryAddress;
1306 		_taoFactory = ITAOFactory(_taoFactoryAddress);
1307 	}
1308 
1309 	/**
1310 	 * @dev The AO sets setting TAO ID
1311 	 * @param _settingTAOId The new setting TAO ID to set
1312 	 */
1313 	function setSettingTAOId(address _settingTAOId) public onlyTheAO {
1314 		require (AOLibrary.isTAO(_settingTAOId));
1315 		settingTAOId = _settingTAOId;
1316 	}
1317 
1318 	/**
1319 	 * @dev The AO sets AO Setting address
1320 	 * @param _aoSettingAddress The address of AOSetting
1321 	 */
1322 	function setAOSettingAddress(address _aoSettingAddress) public onlyTheAO {
1323 		require (_aoSettingAddress != address(0));
1324 		aoSettingAddress = _aoSettingAddress;
1325 		_aoSetting = IAOSetting(_aoSettingAddress);
1326 	}
1327 
1328 	/**
1329 	 * @dev The AO set the TAOAncestry Address
1330 	 * @param _taoAncestryAddress The address of TAOAncestry
1331 	 */
1332 	function setTAOAncestryAddress(address _taoAncestryAddress) public onlyTheAO {
1333 		require (_taoAncestryAddress != address(0));
1334 		taoAncestryAddress = _taoAncestryAddress;
1335 		_taoAncestry = ITAOAncestry(taoAncestryAddress);
1336 	}
1337 
1338 	/**
1339 	 * @dev The AO set the logosAddress Address
1340 	 * @param _logosAddress The address of Logos
1341 	 */
1342 	function setLogosAddress(address _logosAddress) public onlyTheAO {
1343 		require (_logosAddress != address(0));
1344 		logosAddress = _logosAddress;
1345 		_logos = Logos(_logosAddress);
1346 	}
1347 
1348 	/***** PUBLIC METHODS *****/
1349 	/**
1350 	 * @dev Check whether or not a Name/TAO ID exist in the list
1351 	 * @param _id The ID to be checked
1352 	 * @return true if yes, false otherwise
1353 	 */
1354 	function isExist(address _id) public view returns (bool) {
1355 		return positionDetails[_id].created;
1356 	}
1357 
1358 	/**
1359 	 * @dev Check whether or not `_sender` eth address is Advocate of _id
1360 	 * @param _sender The eth address to check
1361 	 * @param _id The ID to be checked
1362 	 * @return true if yes, false otherwise
1363 	 */
1364 	function senderIsAdvocate(address _sender, address _id) external view returns (bool) {
1365 		return (positionDetails[_id].created && positionDetails[_id].advocateId == _nameFactory.ethAddressToNameId(_sender));
1366 	}
1367 
1368 	/**
1369 	 * @dev Check whether or not `_sender` eth address is Listener of _id
1370 	 * @param _sender The eth address to check
1371 	 * @param _id The ID to be checked
1372 	 * @return true if yes, false otherwise
1373 	 */
1374 	function senderIsListener(address _sender, address _id) external view returns (bool) {
1375 		return (positionDetails[_id].created && positionDetails[_id].listenerId == _nameFactory.ethAddressToNameId(_sender));
1376 	}
1377 
1378 	/**
1379 	 * @dev Check whether or not `_sender` eth address is Speaker of _id
1380 	 * @param _sender The eth address to check
1381 	 * @param _id The ID to be checked
1382 	 * @return true if yes, false otherwise
1383 	 */
1384 	function senderIsSpeaker(address _sender, address _id) external view returns (bool) {
1385 		return (positionDetails[_id].created && positionDetails[_id].speakerId == _nameFactory.ethAddressToNameId(_sender));
1386 	}
1387 
1388 	/**
1389 	 * @dev Check whether or not `_sender` eth address is Advocate of Parent of _id
1390 	 * @param _sender The eth address to check
1391 	 * @param _id The ID to be checked
1392 	 * @return true if yes, false otherwise
1393 	 */
1394 	function senderIsAdvocateOfParent(address _sender, address _id) public view returns (bool) {
1395 		(address _parentId,,) = _taoAncestry.getAncestryById(_id);
1396 		 return ((AOLibrary.isName(_parentId) || (AOLibrary.isTAO(_parentId) && _taoAncestry.isChild(_parentId, _id))) && this.senderIsAdvocate(_sender, _parentId));
1397 	}
1398 
1399 	/**
1400 	 * @dev Check whether or not eth address is either Advocate/Listener/Speaker of _id
1401 	 * @param _sender The eth address to check
1402 	 * @param _id The ID to be checked
1403 	 * @return true if yes, false otherwise
1404 	 */
1405 	function senderIsPosition(address _sender, address _id) external view returns (bool) {
1406 		address _nameId = _nameFactory.ethAddressToNameId(_sender);
1407 		if (_nameId == address(0)) {
1408 			return false;
1409 		} else {
1410 			return this.nameIsPosition(_nameId, _id);
1411 		}
1412 	}
1413 
1414 	/**
1415 	 * @dev Check whether or not _nameId is advocate of _id
1416 	 * @param _nameId The name ID to be checked
1417 	 * @param _id The ID to be checked
1418 	 * @return true if yes, false otherwise
1419 	 */
1420 	function nameIsAdvocate(address _nameId, address _id) external view returns (bool) {
1421 		return (positionDetails[_id].created && positionDetails[_id].advocateId == _nameId);
1422 	}
1423 
1424 	/**
1425 	 * @dev Check whether or not _nameId is either Advocate/Listener/Speaker of _id
1426 	 * @param _nameId The name ID to be checked
1427 	 * @param _id The ID to be checked
1428 	 * @return true if yes, false otherwise
1429 	 */
1430 	function nameIsPosition(address _nameId, address _id) external view returns (bool) {
1431 		return (positionDetails[_id].created &&
1432 			(positionDetails[_id].advocateId == _nameId ||
1433 			 positionDetails[_id].listenerId == _nameId ||
1434 			 positionDetails[_id].speakerId == _nameId
1435 			)
1436 	   );
1437 	}
1438 
1439 	/**
1440 	 * @dev Determine whether or not `_sender` is Advocate/Listener/Speaker of the Name/TAO
1441 	 * @param _sender The ETH address that to check
1442 	 * @param _id The ID of the Name/TAO
1443 	 * @return 1 if Advocate. 2 if Listener. 3 if Speaker
1444 	 */
1445 	function determinePosition(address _sender, address _id) external view returns (uint256) {
1446 		require (this.senderIsPosition(_sender, _id));
1447 		PositionDetail memory _positionDetail = positionDetails[_id];
1448 		address _nameId = _nameFactory.ethAddressToNameId(_sender);
1449 		if (_nameId == _positionDetail.advocateId) {
1450 			return 1;
1451 		} else if (_nameId == _positionDetail.listenerId) {
1452 			return 2;
1453 		} else {
1454 			return 3;
1455 		}
1456 	}
1457 
1458 	/**
1459 	 * @dev Initialize Position for a Name/TAO
1460 	 * @param _id The ID of the Name/TAO
1461 	 * @param _advocateId The Advocate ID of the Name/TAO
1462 	 * @param _listenerId The Listener ID of the Name/TAO
1463 	 * @param _speakerId The Speaker ID of the Name/TAO
1464 	 * @return true on success
1465 	 */
1466 	function initialize(address _id, address _advocateId, address _listenerId, address _speakerId)
1467 		external
1468 		isNameOrTAO(_id)
1469 		isName(_advocateId)
1470 		isNameOrTAO(_listenerId)
1471 		isNameOrTAO(_speakerId)
1472 		onlyFactory returns (bool) {
1473 		require (!isExist(_id));
1474 
1475 		PositionDetail storage _positionDetail = positionDetails[_id];
1476 		_positionDetail.advocateId = _advocateId;
1477 		_positionDetail.listenerId = _listenerId;
1478 		_positionDetail.speakerId = _speakerId;
1479 		_positionDetail.created = true;
1480 		return true;
1481 	}
1482 
1483 	/**
1484 	 * @dev Get Name/TAO's Position info
1485 	 * @param _id The ID of the Name/TAO
1486 	 * @return the Advocate name
1487 	 * @return the Advocate ID of Name/TAO
1488 	 * @return the Listener name
1489 	 * @return the Listener ID of Name/TAO
1490 	 * @return the Speaker name
1491 	 * @return the Speaker ID of Name/TAO
1492 	 */
1493 	function getPositionById(address _id) public view returns (string memory, address, string memory, address, string memory, address) {
1494 		require (isExist(_id));
1495 		PositionDetail memory _positionDetail = positionDetails[_id];
1496 		return (
1497 			TAO(address(uint160(_positionDetail.advocateId))).name(),
1498 			_positionDetail.advocateId,
1499 			TAO(address(uint160(_positionDetail.listenerId))).name(),
1500 			_positionDetail.listenerId,
1501 			TAO(address(uint160(_positionDetail.speakerId))).name(),
1502 			_positionDetail.speakerId
1503 		);
1504 	}
1505 
1506 	/**
1507 	 * @dev Get Name/TAO's Advocate
1508 	 * @param _id The ID of the Name/TAO
1509 	 * @return the Advocate ID of Name/TAO
1510 	 */
1511 	function getAdvocate(address _id) external view returns (address) {
1512 		require (isExist(_id));
1513 		PositionDetail memory _positionDetail = positionDetails[_id];
1514 		return _positionDetail.advocateId;
1515 	}
1516 
1517 	/**
1518 	 * @dev Get Name/TAO's Listener
1519 	 * @param _id The ID of the Name/TAO
1520 	 * @return the Listener ID of Name/TAO
1521 	 */
1522 	function getListener(address _id) public view returns (address) {
1523 		require (isExist(_id));
1524 		PositionDetail memory _positionDetail = positionDetails[_id];
1525 		return _positionDetail.listenerId;
1526 	}
1527 
1528 	/**
1529 	 * @dev Get Name/TAO's Speaker
1530 	 * @param _id The ID of the Name/TAO
1531 	 * @return the Speaker ID of Name/TAO
1532 	 */
1533 	function getSpeaker(address _id) public view returns (address) {
1534 		require (isExist(_id));
1535 		PositionDetail memory _positionDetail = positionDetails[_id];
1536 		return _positionDetail.speakerId;
1537 	}
1538 
1539 	/**
1540 	 * @dev Set Advocate for a TAO
1541 	 * @param _taoId The ID of the TAO
1542 	 * @param _newAdvocateId The new advocate ID to be set
1543 	 */
1544 	function setAdvocate(address _taoId, address _newAdvocateId)
1545 		public
1546 		isTAO(_taoId)
1547 		isName(_newAdvocateId)
1548 		onlyAdvocate(_taoId)
1549 		senderIsName
1550 		senderNameNotCompromised {
1551 		require (isExist(_taoId));
1552 		// Make sure the newAdvocate is not compromised
1553 		require (!_nameAccountRecovery.isCompromised(_newAdvocateId));
1554 		_setAdvocate(_taoId, _newAdvocateId);
1555 	}
1556 
1557 	/**
1558 	 * Only Advocate of Parent of `_taoId` can replace child `_taoId` 's Advocate with himself
1559 	 * @param _taoId The ID of the TAO
1560 	 */
1561 	function parentReplaceChildAdvocate(address _taoId)
1562 		public
1563 		isTAO(_taoId)
1564 		senderIsName
1565 		senderNameNotCompromised {
1566 		require (isExist(_taoId));
1567 		require (senderIsAdvocateOfParent(msg.sender, _taoId));
1568 		address _parentNameId = _nameFactory.ethAddressToNameId(msg.sender);
1569 		address _currentAdvocateId = this.getAdvocate(_taoId);
1570 
1571 		// Make sure it's not replacing itself
1572 		require (_parentNameId != _currentAdvocateId);
1573 
1574 		// Parent has to have more Logos than current Advocate
1575 		require (_logos.sumBalanceOf(_parentNameId) > _logos.sumBalanceOf(this.getAdvocate(_taoId)));
1576 
1577 		_setAdvocate(_taoId, _parentNameId);
1578 	}
1579 
1580 	/**
1581 	 * A Name challenges current TAO's Advocate to be its new Advocate
1582 	 * @param _taoId The ID of the TAO
1583 	 */
1584 	function challengeTAOAdvocate(address _taoId)
1585 		public
1586 		isTAO(_taoId)
1587 		senderIsName
1588 		senderNameNotCompromised {
1589 		require (isExist(_taoId));
1590 		address _newAdvocateId = _nameFactory.ethAddressToNameId(msg.sender);
1591 		address _currentAdvocateId = this.getAdvocate(_taoId);
1592 
1593 		// Make sure it's not challenging itself
1594 		require (_newAdvocateId != _currentAdvocateId);
1595 
1596 		// New Advocate has to have more Logos than current Advocate
1597 		require (_logos.sumBalanceOf(_newAdvocateId) > _logos.sumBalanceOf(_currentAdvocateId));
1598 
1599 		(uint256 _lockDuration, uint256 _completeDuration) = _getSettingVariables();
1600 
1601 		totalTAOAdvocateChallenges++;
1602 		bytes32 _challengeId = keccak256(abi.encodePacked(this, _taoId, _newAdvocateId, totalTAOAdvocateChallenges));
1603 		TAOAdvocateChallenge storage _taoAdvocateChallenge = taoAdvocateChallenges[_challengeId];
1604 		_taoAdvocateChallenge.challengeId = _challengeId;
1605 		_taoAdvocateChallenge.newAdvocateId = _newAdvocateId;
1606 		_taoAdvocateChallenge.taoId = _taoId;
1607 		_taoAdvocateChallenge.createdTimestamp = now;
1608 		_taoAdvocateChallenge.lockedUntilTimestamp = _taoAdvocateChallenge.createdTimestamp.add(_lockDuration);
1609 		_taoAdvocateChallenge.completeBeforeTimestamp = _taoAdvocateChallenge.lockedUntilTimestamp.add(_completeDuration);
1610 
1611 		emit ChallengeTAOAdvocate(_taoId, _challengeId, _currentAdvocateId, _newAdvocateId, _taoAdvocateChallenge.createdTimestamp, _taoAdvocateChallenge.lockedUntilTimestamp, _taoAdvocateChallenge.completeBeforeTimestamp);
1612 	}
1613 
1614 	/**
1615 	 * Get status of a TAOAdvocateChallenge given a `_challengeId` and a `_sender` eth address
1616 	 * @param _challengeId The ID of TAOAdvocateChallenge
1617 	 * @param _sender The sender address
1618 	 * @return status of the challenge
1619 	 *		1 = Can complete challenge
1620 	 *		2 = Challenge not exist
1621 	 *		3 = Sender is not the creator of the challenge
1622 	 *		4 = Transaction is not in the allowed period of time (locking period of time)
1623 	 *		5 = Transaction has expired
1624 	 *		6 = Challenge has been completed
1625 	 *		7 = Challenger has less Logos than current Advocate of TAO
1626 	 */
1627 	function getChallengeStatus(bytes32 _challengeId, address _sender) public view returns (uint8) {
1628 		address _challengerNameId = _nameFactory.ethAddressToNameId(_sender);
1629 		TAOAdvocateChallenge storage _taoAdvocateChallenge = taoAdvocateChallenges[_challengeId];
1630 
1631 		// If the challenge does not exist
1632 		if (_taoAdvocateChallenge.taoId == address(0)) {
1633 			return 2;
1634 		} else if (_challengerNameId != _taoAdvocateChallenge.newAdvocateId) {
1635 			// If the calling address is not the creator of the challenge
1636 			return 3;
1637 		} else if (now < _taoAdvocateChallenge.lockedUntilTimestamp) {
1638 			// If this transaction is not in the allowed period of time
1639 			return 4;
1640 		} else if (now > _taoAdvocateChallenge.completeBeforeTimestamp) {
1641 			// Transaction has expired
1642 			return 5;
1643 		} else if (_taoAdvocateChallenge.completed) {
1644 			// If the challenge has been completed
1645 			return 6;
1646 		} else if (_logos.sumBalanceOf(_challengerNameId) <= _logos.sumBalanceOf(this.getAdvocate(_taoAdvocateChallenge.taoId))) {
1647 			// If challenger has less Logos than current Advocate of TAO
1648 			return 7;
1649 		} else {
1650 			// Can complete!
1651 			return 1;
1652 		}
1653 	}
1654 
1655 	/**
1656 	 * Only owner of challenge can respond and complete of the challenge
1657 	 * @param _challengeId The ID of the TAOAdvocateChallenge
1658 	 */
1659 	function completeTAOAdvocateChallenge(bytes32 _challengeId)
1660 		public
1661 		senderIsName
1662 		senderNameNotCompromised {
1663 		TAOAdvocateChallenge storage _taoAdvocateChallenge = taoAdvocateChallenges[_challengeId];
1664 
1665 		// Make sure the challenger can complete this challenge
1666 		require (getChallengeStatus(_challengeId, msg.sender) == 1);
1667 
1668 		_taoAdvocateChallenge.completed = true;
1669 
1670 		_setAdvocate(_taoAdvocateChallenge.taoId, _taoAdvocateChallenge.newAdvocateId);
1671 
1672 		emit CompleteTAOAdvocateChallenge(_taoAdvocateChallenge.taoId, _challengeId);
1673 	}
1674 
1675 	/**
1676 	 * @dev Get TAOAdvocateChallenge info given an ID
1677 	 * @param _challengeId The ID of TAOAdvocateChallenge
1678 	 * @return the new Advocate ID in the challenge
1679 	 * @return the ID of Name/TAO
1680 	 * @return the completion status of the challenge
1681 	 * @return the created timestamp
1682 	 * @return the lockedUntil timestamp (The deadline for current Advocate to respond)
1683 	 * @return the completeBefore timestamp (The deadline for the challenger to respond and complete the challenge)
1684 	 */
1685 	function getTAOAdvocateChallengeById(bytes32 _challengeId) public view returns (address, address, bool, uint256, uint256, uint256) {
1686 		TAOAdvocateChallenge memory _taoAdvocateChallenge = taoAdvocateChallenges[_challengeId];
1687 		require (_taoAdvocateChallenge.taoId != address(0));
1688 		return (
1689 			_taoAdvocateChallenge.newAdvocateId,
1690 			_taoAdvocateChallenge.taoId,
1691 			_taoAdvocateChallenge.completed,
1692 			_taoAdvocateChallenge.createdTimestamp,
1693 			_taoAdvocateChallenge.lockedUntilTimestamp,
1694 			_taoAdvocateChallenge.completeBeforeTimestamp
1695 		);
1696 	}
1697 
1698 	/**
1699 	 * @dev Set Listener for a Name/TAO
1700 	 * @param _id The ID of the Name/TAO
1701 	 * @param _newListenerId The new listener ID to be set
1702 	 */
1703 	function setListener(address _id, address _newListenerId)
1704 		public
1705 		isNameOrTAO(_id)
1706 		isNameOrTAO(_newListenerId)
1707 		senderIsName
1708 		senderNameNotCompromised
1709 		onlyAdvocate(_id) {
1710 		require (isExist(_id));
1711 
1712 		// If _id is a Name, then new Listener can only be a Name
1713 		// If _id is a TAO, then new Listener can be a TAO/Name
1714 		bool _isName = false;
1715 		if (AOLibrary.isName(_id)) {
1716 			_isName = true;
1717 			require (AOLibrary.isName(_newListenerId));
1718 			require (!_nameAccountRecovery.isCompromised(_id));
1719 			require (!_nameAccountRecovery.isCompromised(_newListenerId));
1720 		}
1721 
1722 		PositionDetail storage _positionDetail = positionDetails[_id];
1723 		address _currentListenerId = _positionDetail.listenerId;
1724 		_positionDetail.listenerId = _newListenerId;
1725 
1726 		uint256 _nonce;
1727 		if (_isName) {
1728 			_nonce = _nameFactory.incrementNonce(_id);
1729 		} else {
1730 			_nonce = _taoFactory.incrementNonce(_id);
1731 		}
1732 		emit SetListener(_id, _currentListenerId, _positionDetail.listenerId, _nonce);
1733 	}
1734 
1735 	/**
1736 	 * @dev Set Speaker for a Name/TAO
1737 	 * @param _id The ID of the Name/TAO
1738 	 * @param _newSpeakerId The new speaker ID to be set
1739 	 */
1740 	function setSpeaker(address _id, address _newSpeakerId)
1741 		public
1742 		isNameOrTAO(_id)
1743 		isNameOrTAO(_newSpeakerId)
1744 		senderIsName
1745 		senderNameNotCompromised
1746 		onlyAdvocate(_id) {
1747 		require (isExist(_id));
1748 
1749 		// If _id is a Name, then new Speaker can only be a Name
1750 		// If _id is a TAO, then new Speaker can be a TAO/Name
1751 		bool _isName = false;
1752 		if (AOLibrary.isName(_id)) {
1753 			_isName = true;
1754 			require (AOLibrary.isName(_newSpeakerId));
1755 			require (!_nameAccountRecovery.isCompromised(_id));
1756 			require (!_nameAccountRecovery.isCompromised(_newSpeakerId));
1757 		}
1758 
1759 		PositionDetail storage _positionDetail = positionDetails[_id];
1760 		address _currentSpeakerId = _positionDetail.speakerId;
1761 		_positionDetail.speakerId = _newSpeakerId;
1762 
1763 		uint256 _nonce;
1764 		if (_isName) {
1765 			_nonce = _nameFactory.incrementNonce(_id);
1766 		} else {
1767 			_nonce = _taoFactory.incrementNonce(_id);
1768 		}
1769 		emit SetSpeaker(_id, _currentSpeakerId, _positionDetail.speakerId, _nonce);
1770 	}
1771 
1772 	/***** INTERNAL METHOD *****/
1773 	/**
1774 	 * @dev Actually setting Advocate for a TAO
1775 	 * @param _taoId The ID of the TAO
1776 	 * @param _newAdvocateId The new advocate ID to be set
1777 	 */
1778 	function _setAdvocate(address _taoId, address _newAdvocateId) internal {
1779 		PositionDetail storage _positionDetail = positionDetails[_taoId];
1780 		address _currentAdvocateId = _positionDetail.advocateId;
1781 		_positionDetail.advocateId = _newAdvocateId;
1782 
1783 		uint256 _nonce = _taoFactory.incrementNonce(_taoId);
1784 		require (_nonce > 0);
1785 
1786 		// Transfer Advocated TAO Logos to the new Advocate
1787 		require (_logos.transferAdvocatedTAOLogos(_currentAdvocateId, _taoId));
1788 
1789 		emit SetAdvocate(_taoId, _currentAdvocateId, _positionDetail.advocateId, _nonce);
1790 	}
1791 
1792 	/**
1793 	 * @dev Get setting variables
1794 	 * @return challengeTAOAdvocateLockDuration = The amount of time for current Advocate to respond to TAO Advocate challenge from another Name
1795 	 * @return challengeTAOAdvocateCompleteDuration = The amount of time for challenger Advocate to respond and complete the challenge after the lock period ends
1796 	 */
1797 	function _getSettingVariables() internal view returns (uint256, uint256) {
1798 		(uint256 challengeTAOAdvocateLockDuration,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'challengeTAOAdvocateLockDuration');
1799 		(uint256 challengeTAOAdvocateCompleteDuration,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'challengeTAOAdvocateCompleteDuration');
1800 
1801 		return (
1802 			challengeTAOAdvocateLockDuration,
1803 			challengeTAOAdvocateCompleteDuration
1804 		);
1805 	}
1806 }