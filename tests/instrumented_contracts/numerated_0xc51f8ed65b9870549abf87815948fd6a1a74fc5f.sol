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
70 interface IAOSettingValue {
71 	function setPendingValue(uint256 _settingId, address _addressValue, bool _boolValue, bytes32 _bytesValue, string calldata _stringValue, uint256 _uintValue) external returns (bool);
72 
73 	function movePendingToSetting(uint256 _settingId) external returns (bool);
74 
75 	function settingValue(uint256 _settingId) external view returns (address, bool, bytes32, string memory, uint256);
76 }
77 
78 
79 
80 
81 
82 
83 
84 
85 
86 
87 
88 
89 contract TokenERC20 {
90 	// Public variables of the token
91 	string public name;
92 	string public symbol;
93 	uint8 public decimals = 18;
94 	// 18 decimals is the strongly suggested default, avoid changing it
95 	uint256 public totalSupply;
96 
97 	// This creates an array with all balances
98 	mapping (address => uint256) public balanceOf;
99 	mapping (address => mapping (address => uint256)) public allowance;
100 
101 	// This generates a public event on the blockchain that will notify clients
102 	event Transfer(address indexed from, address indexed to, uint256 value);
103 
104 	// This generates a public event on the blockchain that will notify clients
105 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
106 
107 	// This notifies clients about the amount burnt
108 	event Burn(address indexed from, uint256 value);
109 
110 	/**
111 	 * Constructor function
112 	 *
113 	 * Initializes contract with initial supply tokens to the creator of the contract
114 	 */
115 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
116 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
117 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
118 		name = tokenName;                                   // Set the name for display purposes
119 		symbol = tokenSymbol;                               // Set the symbol for display purposes
120 	}
121 
122 	/**
123 	 * Internal transfer, only can be called by this contract
124 	 */
125 	function _transfer(address _from, address _to, uint _value) internal {
126 		// Prevent transfer to 0x0 address. Use burn() instead
127 		require(_to != address(0));
128 		// Check if the sender has enough
129 		require(balanceOf[_from] >= _value);
130 		// Check for overflows
131 		require(balanceOf[_to] + _value > balanceOf[_to]);
132 		// Save this for an assertion in the future
133 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
134 		// Subtract from the sender
135 		balanceOf[_from] -= _value;
136 		// Add the same to the recipient
137 		balanceOf[_to] += _value;
138 		emit Transfer(_from, _to, _value);
139 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
140 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
141 	}
142 
143 	/**
144 	 * Transfer tokens
145 	 *
146 	 * Send `_value` tokens to `_to` from your account
147 	 *
148 	 * @param _to The address of the recipient
149 	 * @param _value the amount to send
150 	 */
151 	function transfer(address _to, uint256 _value) public returns (bool success) {
152 		_transfer(msg.sender, _to, _value);
153 		return true;
154 	}
155 
156 	/**
157 	 * Transfer tokens from other address
158 	 *
159 	 * Send `_value` tokens to `_to` in behalf of `_from`
160 	 *
161 	 * @param _from The address of the sender
162 	 * @param _to The address of the recipient
163 	 * @param _value the amount to send
164 	 */
165 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
166 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
167 		allowance[_from][msg.sender] -= _value;
168 		_transfer(_from, _to, _value);
169 		return true;
170 	}
171 
172 	/**
173 	 * Set allowance for other address
174 	 *
175 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
176 	 *
177 	 * @param _spender The address authorized to spend
178 	 * @param _value the max amount they can spend
179 	 */
180 	function approve(address _spender, uint256 _value) public returns (bool success) {
181 		allowance[msg.sender][_spender] = _value;
182 		emit Approval(msg.sender, _spender, _value);
183 		return true;
184 	}
185 
186 	/**
187 	 * Set allowance for other address and notify
188 	 *
189 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
190 	 *
191 	 * @param _spender The address authorized to spend
192 	 * @param _value the max amount they can spend
193 	 * @param _extraData some extra information to send to the approved contract
194 	 */
195 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
196 		tokenRecipient spender = tokenRecipient(_spender);
197 		if (approve(_spender, _value)) {
198 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
199 			return true;
200 		}
201 	}
202 
203 	/**
204 	 * Destroy tokens
205 	 *
206 	 * Remove `_value` tokens from the system irreversibly
207 	 *
208 	 * @param _value the amount of money to burn
209 	 */
210 	function burn(uint256 _value) public returns (bool success) {
211 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
212 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
213 		totalSupply -= _value;                      // Updates totalSupply
214 		emit Burn(msg.sender, _value);
215 		return true;
216 	}
217 
218 	/**
219 	 * Destroy tokens from other account
220 	 *
221 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
222 	 *
223 	 * @param _from the address of the sender
224 	 * @param _value the amount of money to burn
225 	 */
226 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
227 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
228 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
229 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
230 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
231 		totalSupply -= _value;                              // Update totalSupply
232 		emit Burn(_from, _value);
233 		return true;
234 	}
235 }
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
324 
325 
326 /**
327  * @title Name
328  */
329 contract Name is TAO {
330 	/**
331 	 * @dev Constructor function
332 	 */
333 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
334 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
335 		// Creating Name
336 		typeId = 1;
337 	}
338 }
339 
340 
341 
342 
343 /**
344  * @title AOLibrary
345  */
346 library AOLibrary {
347 	using SafeMath for uint256;
348 
349 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
350 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
351 
352 	/**
353 	 * @dev Check whether or not the given TAO ID is a TAO
354 	 * @param _taoId The ID of the TAO
355 	 * @return true if yes. false otherwise
356 	 */
357 	function isTAO(address _taoId) public view returns (bool) {
358 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
359 	}
360 
361 	/**
362 	 * @dev Check whether or not the given Name ID is a Name
363 	 * @param _nameId The ID of the Name
364 	 * @return true if yes. false otherwise
365 	 */
366 	function isName(address _nameId) public view returns (bool) {
367 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
368 	}
369 
370 	/**
371 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
372 	 * @param _tokenAddress The ERC20 Token address to check
373 	 */
374 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
375 		if (_tokenAddress == address(0)) {
376 			return false;
377 		}
378 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
379 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
380 	}
381 
382 	/**
383 	 * @dev Checks if the calling contract address is The AO
384 	 *		OR
385 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
386 	 * @param _sender The address to check
387 	 * @param _theAO The AO address
388 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
389 	 * @return true if yes, false otherwise
390 	 */
391 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
392 		return (_sender == _theAO ||
393 			(
394 				(isTAO(_theAO) || isName(_theAO)) &&
395 				_nameTAOPositionAddress != address(0) &&
396 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
397 			)
398 		);
399 	}
400 
401 	/**
402 	 * @dev Return the divisor used to correctly calculate percentage.
403 	 *		Percentage stored throughout AO contracts covers 4 decimals,
404 	 *		so 1% is 10000, 1.25% is 12500, etc
405 	 */
406 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
407 		return _PERCENTAGE_DIVISOR;
408 	}
409 
410 	/**
411 	 * @dev Return the divisor used to correctly calculate multiplier.
412 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
413 	 *		so 1 is 1000000, 0.023 is 23000, etc
414 	 */
415 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
416 		return _MULTIPLIER_DIVISOR;
417 	}
418 
419 	/**
420 	 * @dev deploy a TAO
421 	 * @param _name The name of the TAO
422 	 * @param _originId The Name ID the creates the TAO
423 	 * @param _datHash The datHash of this TAO
424 	 * @param _database The database for this TAO
425 	 * @param _keyValue The key/value pair to be checked on the database
426 	 * @param _contentId The contentId related to this TAO
427 	 * @param _nameTAOVaultAddress The address of NameTAOVault
428 	 */
429 	function deployTAO(string memory _name,
430 		address _originId,
431 		string memory _datHash,
432 		string memory _database,
433 		string memory _keyValue,
434 		bytes32 _contentId,
435 		address _nameTAOVaultAddress
436 		) public returns (TAO _tao) {
437 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
438 	}
439 
440 	/**
441 	 * @dev deploy a Name
442 	 * @param _name The name of the Name
443 	 * @param _originId The eth address the creates the Name
444 	 * @param _datHash The datHash of this Name
445 	 * @param _database The database for this Name
446 	 * @param _keyValue The key/value pair to be checked on the database
447 	 * @param _contentId The contentId related to this Name
448 	 * @param _nameTAOVaultAddress The address of NameTAOVault
449 	 */
450 	function deployName(string memory _name,
451 		address _originId,
452 		string memory _datHash,
453 		string memory _database,
454 		string memory _keyValue,
455 		bytes32 _contentId,
456 		address _nameTAOVaultAddress
457 		) public returns (Name _myName) {
458 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
459 	}
460 
461 	/**
462 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
463 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
464 	 * @param _currentPrimordialBalance Account's current primordial ion balance
465 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
466 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
467 	 * @return the new primordial weighted multiplier
468 	 */
469 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
470 		if (_currentWeightedMultiplier > 0) {
471 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
472 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
473 			return _totalWeightedIons.div(_totalIons);
474 		} else {
475 			return _additionalWeightedMultiplier;
476 		}
477 	}
478 
479 	/**
480 	 * @dev Calculate the primordial ion multiplier on a given lot
481 	 *		Total Primordial Mintable = T
482 	 *		Total Primordial Minted = M
483 	 *		Starting Multiplier = S
484 	 *		Ending Multiplier = E
485 	 *		To Purchase = P
486 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
487 	 *
488 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
489 	 * @param _totalPrimordialMintable Total Primordial ion mintable
490 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
491 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
492 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
493 	 * @return The multiplier in (10 ** 6)
494 	 */
495 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
496 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
497 			/**
498 			 * Let temp = M + (P/2)
499 			 * Multiplier = (1 - (temp / T)) x (S-E)
500 			 */
501 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
502 
503 			/**
504 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
505 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
506 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
507 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
508 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
509 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
510 			 */
511 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
512 			/**
513 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
514 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
515 			 */
516 			return multiplier.div(_MULTIPLIER_DIVISOR);
517 		} else {
518 			return 0;
519 		}
520 	}
521 
522 	/**
523 	 * @dev Calculate the bonus percentage of network ion on a given lot
524 	 *		Total Primordial Mintable = T
525 	 *		Total Primordial Minted = M
526 	 *		Starting Network Bonus Multiplier = Bs
527 	 *		Ending Network Bonus Multiplier = Be
528 	 *		To Purchase = P
529 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
530 	 *
531 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
532 	 * @param _totalPrimordialMintable Total Primordial ion intable
533 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
534 	 * @param _startingMultiplier The starting Network ion bonus multiplier
535 	 * @param _endingMultiplier The ending Network ion bonus multiplier
536 	 * @return The bonus percentage
537 	 */
538 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
539 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
540 			/**
541 			 * Let temp = M + (P/2)
542 			 * B% = (1 - (temp / T)) x (Bs-Be)
543 			 */
544 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
545 
546 			/**
547 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
548 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
549 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
550 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
551 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
552 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
553 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
554 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
555 			 */
556 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
557 			return bonusPercentage;
558 		} else {
559 			return 0;
560 		}
561 	}
562 
563 	/**
564 	 * @dev Calculate the bonus amount of network ion on a given lot
565 	 *		AO Bonus Amount = B% x P
566 	 *
567 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
568 	 * @param _totalPrimordialMintable Total Primordial ion intable
569 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
570 	 * @param _startingMultiplier The starting Network ion bonus multiplier
571 	 * @param _endingMultiplier The ending Network ion bonus multiplier
572 	 * @return The bonus percentage
573 	 */
574 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
575 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
576 		/**
577 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
578 		 * when calculating the network ion bonus amount
579 		 */
580 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
581 		return networkBonus;
582 	}
583 
584 	/**
585 	 * @dev Calculate the maximum amount of Primordial an account can burn
586 	 *		_primordialBalance = P
587 	 *		_currentWeightedMultiplier = M
588 	 *		_maximumMultiplier = S
589 	 *		_amountToBurn = B
590 	 *		B = ((S x P) - (P x M)) / S
591 	 *
592 	 * @param _primordialBalance Account's primordial ion balance
593 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
594 	 * @param _maximumMultiplier The maximum multiplier of this account
595 	 * @return The maximum burn amount
596 	 */
597 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
598 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
599 	}
600 
601 	/**
602 	 * @dev Calculate the new multiplier after burning primordial ion
603 	 *		_primordialBalance = P
604 	 *		_currentWeightedMultiplier = M
605 	 *		_amountToBurn = B
606 	 *		_newMultiplier = E
607 	 *		E = (P x M) / (P - B)
608 	 *
609 	 * @param _primordialBalance Account's primordial ion balance
610 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
611 	 * @param _amountToBurn The amount of primordial ion to burn
612 	 * @return The new multiplier
613 	 */
614 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
615 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
616 	}
617 
618 	/**
619 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
620 	 *		_primordialBalance = P
621 	 *		_currentWeightedMultiplier = M
622 	 *		_amountToConvert = C
623 	 *		_newMultiplier = E
624 	 *		E = (P x M) / (P + C)
625 	 *
626 	 * @param _primordialBalance Account's primordial ion balance
627 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
628 	 * @param _amountToConvert The amount of network ion to convert
629 	 * @return The new multiplier
630 	 */
631 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
632 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
633 	}
634 
635 	/**
636 	 * @dev count num of digits
637 	 * @param number uint256 of the nuumber to be checked
638 	 * @return uint8 num of digits
639 	 */
640 	function numDigits(uint256 number) public pure returns (uint8) {
641 		uint8 digits = 0;
642 		while(number != 0) {
643 			number = number.div(10);
644 			digits++;
645 		}
646 		return digits;
647 	}
648 }
649 
650 
651 
652 contract TheAO {
653 	address public theAO;
654 	address public nameTAOPositionAddress;
655 
656 	// Check whether an address is whitelisted and granted access to transact
657 	// on behalf of others
658 	mapping (address => bool) public whitelist;
659 
660 	constructor() public {
661 		theAO = msg.sender;
662 	}
663 
664 	/**
665 	 * @dev Checks if msg.sender is in whitelist.
666 	 */
667 	modifier inWhitelist() {
668 		require (whitelist[msg.sender] == true);
669 		_;
670 	}
671 
672 	/**
673 	 * @dev Transfer ownership of The AO to new address
674 	 * @param _theAO The new address to be transferred
675 	 */
676 	function transferOwnership(address _theAO) public {
677 		require (msg.sender == theAO);
678 		require (_theAO != address(0));
679 		theAO = _theAO;
680 	}
681 
682 	/**
683 	 * @dev Whitelist `_account` address to transact on behalf of others
684 	 * @param _account The address to whitelist
685 	 * @param _whitelist Either to whitelist or not
686 	 */
687 	function setWhitelist(address _account, bool _whitelist) public {
688 		require (msg.sender == theAO);
689 		require (_account != address(0));
690 		whitelist[_account] = _whitelist;
691 	}
692 }
693 
694 
695 
696 /**
697  * @title AOSettingValue
698  *
699  */
700 contract AOSettingValue is TheAO, IAOSettingValue {
701 	struct PendingValue {
702 		address addressValue;
703 		bool boolValue;
704 		bytes32 bytesValue;
705 		string stringValue;
706 		uint256 uintValue;
707 	}
708 
709 	struct SettingValue {
710 		address addressValue;
711 		bool boolValue;
712 		bytes32 bytesValue;
713 		string stringValue;
714 		uint256 uintValue;
715 	}
716 
717 	// Mapping from settingId to PendingValue
718 	mapping (uint256 => PendingValue) internal pendingValues;
719 
720 	// Mapping from settingId to SettingValue
721 	mapping (uint256 => SettingValue) internal settingValues;
722 
723 	/**
724 	 * @dev Constructor function
725 	 */
726 	constructor(address _nameTAOPositionAddress) public {
727 		setNameTAOPositionAddress(_nameTAOPositionAddress);
728 	}
729 
730 	/**
731 	 * @dev Checks if the calling contract address is The AO
732 	 *		OR
733 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
734 	 */
735 	modifier onlyTheAO {
736 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
737 		_;
738 	}
739 
740 	/***** The AO ONLY METHODS *****/
741 	/**
742 	 * @dev Transfer ownership of The AO to new address
743 	 * @param _theAO The new address to be transferred
744 	 */
745 	function transferOwnership(address _theAO) public onlyTheAO {
746 		require (_theAO != address(0));
747 		theAO = _theAO;
748 	}
749 
750 	/**
751 	 * @dev Whitelist `_account` address to transact on behalf of others
752 	 * @param _account The address to whitelist
753 	 * @param _whitelist Either to whitelist or not
754 	 */
755 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
756 		require (_account != address(0));
757 		whitelist[_account] = _whitelist;
758 	}
759 
760 	/**
761 	 * @dev The AO set the NameTAOPosition Address
762 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
763 	 */
764 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
765 		require (_nameTAOPositionAddress != address(0));
766 		nameTAOPositionAddress = _nameTAOPositionAddress;
767 	}
768 
769 	/***** PUBLIC METHODS *****/
770 	/**
771 	 * @dev Set pending value
772 	 * @param _settingId The ID of the setting
773 	 * @param _addressValue The address value to be set
774 	 * @param _boolValue The bool value to be set
775 	 * @param _bytesValue The bytes32 value to be set
776 	 * @param _stringValue The string value to be set
777 	 * @param _uintValue The uint256 value to be set
778 	 * @return true on success
779 	 */
780 	function setPendingValue(uint256 _settingId,
781 		address _addressValue,
782 		bool _boolValue,
783 		bytes32 _bytesValue,
784 		string calldata _stringValue,
785 		uint256 _uintValue) external inWhitelist returns (bool) {
786 		PendingValue storage _pendingValue = pendingValues[_settingId];
787 		_pendingValue.addressValue = _addressValue;
788 		_pendingValue.boolValue = _boolValue;
789 		_pendingValue.bytesValue = _bytesValue;
790 		_pendingValue.stringValue = _stringValue;
791 		_pendingValue.uintValue = _uintValue;
792 		return true;
793 	}
794 
795 	/**
796 	 * @dev Move value from pending to setting
797 	 * @param _settingId The ID of the setting
798 	 * @return true on success
799 	 */
800 	function movePendingToSetting(uint256 _settingId) external inWhitelist returns (bool) {
801 		PendingValue memory _pendingValue = pendingValues[_settingId];
802 		SettingValue storage _settingValue = settingValues[_settingId];
803 		_settingValue.addressValue = _pendingValue.addressValue;
804 		_settingValue.boolValue = _pendingValue.boolValue;
805 		_settingValue.bytesValue = _pendingValue.bytesValue;
806 		_settingValue.stringValue = _pendingValue.stringValue;
807 		_settingValue.uintValue = _pendingValue.uintValue;
808 		delete pendingValues[_settingId];
809 		return true;
810 	}
811 
812 	/**
813 	 * @dev Get setting value given a setting ID
814 	 * @return The address setting value
815 	 * @return The bool setting value
816 	 * @return The bytes32 setting value
817 	 * @return The string setting value
818 	 * @return The uint256 setting value
819 	 */
820 	function settingValue(uint256 _settingId) external view returns (address, bool, bytes32, string memory, uint256) {
821 		SettingValue memory _settingValue = settingValues[_settingId];
822 		return (
823 			_settingValue.addressValue,
824 			_settingValue.boolValue,
825 			_settingValue.bytesValue,
826 			_settingValue.stringValue,
827 			_settingValue.uintValue
828 		);
829 	}
830 
831 	/**
832 	 * @dev Get pending value given a setting ID
833 	 * @return The address pending value
834 	 * @return The bool pending value
835 	 * @return The bytes32 pending value
836 	 * @return The string pending value
837 	 * @return The uint256 pending value
838 	 */
839 	function pendingValue(uint256 _settingId) public view returns (address, bool, bytes32, string memory, uint256) {
840 		PendingValue memory _pendingValue = pendingValues[_settingId];
841 		return (
842 			_pendingValue.addressValue,
843 			_pendingValue.boolValue,
844 			_pendingValue.bytesValue,
845 			_pendingValue.stringValue,
846 			_pendingValue.uintValue
847 		);
848 	}
849 }