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
70 interface IAOIonLot {
71 	function createPrimordialLot(address _account, uint256 _primordialAmount, uint256 _multiplier, uint256 _networkBonusAmount) external returns (bytes32);
72 
73 	function createWeightedMultiplierLot(address _account, uint256 _amount, uint256 _weightedMultiplier) external returns (bytes32);
74 
75 	function lotById(bytes32 _lotId) external view returns (bytes32, address, uint256, uint256);
76 
77 	function totalLotsByAddress(address _lotOwner) external view returns (uint256);
78 
79 	function createBurnLot(address _account, uint256 _amount, uint256 _multiplierAfterBurn) external returns (bool);
80 
81 	function createConvertLot(address _account, uint256 _amount, uint256 _multiplierAfterConversion) external returns (bool);
82 }
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
96 contract TokenERC20 {
97 	// Public variables of the token
98 	string public name;
99 	string public symbol;
100 	uint8 public decimals = 18;
101 	// 18 decimals is the strongly suggested default, avoid changing it
102 	uint256 public totalSupply;
103 
104 	// This creates an array with all balances
105 	mapping (address => uint256) public balanceOf;
106 	mapping (address => mapping (address => uint256)) public allowance;
107 
108 	// This generates a public event on the blockchain that will notify clients
109 	event Transfer(address indexed from, address indexed to, uint256 value);
110 
111 	// This generates a public event on the blockchain that will notify clients
112 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
113 
114 	// This notifies clients about the amount burnt
115 	event Burn(address indexed from, uint256 value);
116 
117 	/**
118 	 * Constructor function
119 	 *
120 	 * Initializes contract with initial supply tokens to the creator of the contract
121 	 */
122 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
123 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
124 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
125 		name = tokenName;                                   // Set the name for display purposes
126 		symbol = tokenSymbol;                               // Set the symbol for display purposes
127 	}
128 
129 	/**
130 	 * Internal transfer, only can be called by this contract
131 	 */
132 	function _transfer(address _from, address _to, uint _value) internal {
133 		// Prevent transfer to 0x0 address. Use burn() instead
134 		require(_to != address(0));
135 		// Check if the sender has enough
136 		require(balanceOf[_from] >= _value);
137 		// Check for overflows
138 		require(balanceOf[_to] + _value > balanceOf[_to]);
139 		// Save this for an assertion in the future
140 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
141 		// Subtract from the sender
142 		balanceOf[_from] -= _value;
143 		// Add the same to the recipient
144 		balanceOf[_to] += _value;
145 		emit Transfer(_from, _to, _value);
146 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
147 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
148 	}
149 
150 	/**
151 	 * Transfer tokens
152 	 *
153 	 * Send `_value` tokens to `_to` from your account
154 	 *
155 	 * @param _to The address of the recipient
156 	 * @param _value the amount to send
157 	 */
158 	function transfer(address _to, uint256 _value) public returns (bool success) {
159 		_transfer(msg.sender, _to, _value);
160 		return true;
161 	}
162 
163 	/**
164 	 * Transfer tokens from other address
165 	 *
166 	 * Send `_value` tokens to `_to` in behalf of `_from`
167 	 *
168 	 * @param _from The address of the sender
169 	 * @param _to The address of the recipient
170 	 * @param _value the amount to send
171 	 */
172 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
173 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
174 		allowance[_from][msg.sender] -= _value;
175 		_transfer(_from, _to, _value);
176 		return true;
177 	}
178 
179 	/**
180 	 * Set allowance for other address
181 	 *
182 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
183 	 *
184 	 * @param _spender The address authorized to spend
185 	 * @param _value the max amount they can spend
186 	 */
187 	function approve(address _spender, uint256 _value) public returns (bool success) {
188 		allowance[msg.sender][_spender] = _value;
189 		emit Approval(msg.sender, _spender, _value);
190 		return true;
191 	}
192 
193 	/**
194 	 * Set allowance for other address and notify
195 	 *
196 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
197 	 *
198 	 * @param _spender The address authorized to spend
199 	 * @param _value the max amount they can spend
200 	 * @param _extraData some extra information to send to the approved contract
201 	 */
202 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
203 		tokenRecipient spender = tokenRecipient(_spender);
204 		if (approve(_spender, _value)) {
205 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
206 			return true;
207 		}
208 	}
209 
210 	/**
211 	 * Destroy tokens
212 	 *
213 	 * Remove `_value` tokens from the system irreversibly
214 	 *
215 	 * @param _value the amount of money to burn
216 	 */
217 	function burn(uint256 _value) public returns (bool success) {
218 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
219 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
220 		totalSupply -= _value;                      // Updates totalSupply
221 		emit Burn(msg.sender, _value);
222 		return true;
223 	}
224 
225 	/**
226 	 * Destroy tokens from other account
227 	 *
228 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
229 	 *
230 	 * @param _from the address of the sender
231 	 * @param _value the amount of money to burn
232 	 */
233 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
234 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
235 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
236 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
237 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
238 		totalSupply -= _value;                              // Update totalSupply
239 		emit Burn(_from, _value);
240 		return true;
241 	}
242 }
243 
244 
245 /**
246  * @title TAO
247  */
248 contract TAO {
249 	using SafeMath for uint256;
250 
251 	address public vaultAddress;
252 	string public name;				// the name for this TAO
253 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
254 
255 	// TAO's data
256 	string public datHash;
257 	string public database;
258 	string public keyValue;
259 	bytes32 public contentId;
260 
261 	/**
262 	 * 0 = TAO
263 	 * 1 = Name
264 	 */
265 	uint8 public typeId;
266 
267 	/**
268 	 * @dev Constructor function
269 	 */
270 	constructor (string memory _name,
271 		address _originId,
272 		string memory _datHash,
273 		string memory _database,
274 		string memory _keyValue,
275 		bytes32 _contentId,
276 		address _vaultAddress
277 	) public {
278 		name = _name;
279 		originId = _originId;
280 		datHash = _datHash;
281 		database = _database;
282 		keyValue = _keyValue;
283 		contentId = _contentId;
284 
285 		// Creating TAO
286 		typeId = 0;
287 
288 		vaultAddress = _vaultAddress;
289 	}
290 
291 	/**
292 	 * @dev Checks if calling address is Vault contract
293 	 */
294 	modifier onlyVault {
295 		require (msg.sender == vaultAddress);
296 		_;
297 	}
298 
299 	/**
300 	 * Will receive any ETH sent
301 	 */
302 	function () external payable {
303 	}
304 
305 	/**
306 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
307 	 * @param _recipient The recipient address
308 	 * @param _amount The amount to transfer
309 	 * @return true on success
310 	 */
311 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
312 		_recipient.transfer(_amount);
313 		return true;
314 	}
315 
316 	/**
317 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
318 	 * @param _erc20TokenAddress The address of ERC20 Token
319 	 * @param _recipient The recipient address
320 	 * @param _amount The amount to transfer
321 	 * @return true on success
322 	 */
323 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
324 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
325 		_erc20.transfer(_recipient, _amount);
326 		return true;
327 	}
328 }
329 
330 
331 
332 
333 /**
334  * @title Name
335  */
336 contract Name is TAO {
337 	/**
338 	 * @dev Constructor function
339 	 */
340 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
341 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
342 		// Creating Name
343 		typeId = 1;
344 	}
345 }
346 
347 
348 
349 
350 /**
351  * @title AOLibrary
352  */
353 library AOLibrary {
354 	using SafeMath for uint256;
355 
356 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
357 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
358 
359 	/**
360 	 * @dev Check whether or not the given TAO ID is a TAO
361 	 * @param _taoId The ID of the TAO
362 	 * @return true if yes. false otherwise
363 	 */
364 	function isTAO(address _taoId) public view returns (bool) {
365 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
366 	}
367 
368 	/**
369 	 * @dev Check whether or not the given Name ID is a Name
370 	 * @param _nameId The ID of the Name
371 	 * @return true if yes. false otherwise
372 	 */
373 	function isName(address _nameId) public view returns (bool) {
374 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
375 	}
376 
377 	/**
378 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
379 	 * @param _tokenAddress The ERC20 Token address to check
380 	 */
381 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
382 		if (_tokenAddress == address(0)) {
383 			return false;
384 		}
385 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
386 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
387 	}
388 
389 	/**
390 	 * @dev Checks if the calling contract address is The AO
391 	 *		OR
392 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
393 	 * @param _sender The address to check
394 	 * @param _theAO The AO address
395 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
396 	 * @return true if yes, false otherwise
397 	 */
398 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
399 		return (_sender == _theAO ||
400 			(
401 				(isTAO(_theAO) || isName(_theAO)) &&
402 				_nameTAOPositionAddress != address(0) &&
403 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
404 			)
405 		);
406 	}
407 
408 	/**
409 	 * @dev Return the divisor used to correctly calculate percentage.
410 	 *		Percentage stored throughout AO contracts covers 4 decimals,
411 	 *		so 1% is 10000, 1.25% is 12500, etc
412 	 */
413 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
414 		return _PERCENTAGE_DIVISOR;
415 	}
416 
417 	/**
418 	 * @dev Return the divisor used to correctly calculate multiplier.
419 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
420 	 *		so 1 is 1000000, 0.023 is 23000, etc
421 	 */
422 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
423 		return _MULTIPLIER_DIVISOR;
424 	}
425 
426 	/**
427 	 * @dev deploy a TAO
428 	 * @param _name The name of the TAO
429 	 * @param _originId The Name ID the creates the TAO
430 	 * @param _datHash The datHash of this TAO
431 	 * @param _database The database for this TAO
432 	 * @param _keyValue The key/value pair to be checked on the database
433 	 * @param _contentId The contentId related to this TAO
434 	 * @param _nameTAOVaultAddress The address of NameTAOVault
435 	 */
436 	function deployTAO(string memory _name,
437 		address _originId,
438 		string memory _datHash,
439 		string memory _database,
440 		string memory _keyValue,
441 		bytes32 _contentId,
442 		address _nameTAOVaultAddress
443 		) public returns (TAO _tao) {
444 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
445 	}
446 
447 	/**
448 	 * @dev deploy a Name
449 	 * @param _name The name of the Name
450 	 * @param _originId The eth address the creates the Name
451 	 * @param _datHash The datHash of this Name
452 	 * @param _database The database for this Name
453 	 * @param _keyValue The key/value pair to be checked on the database
454 	 * @param _contentId The contentId related to this Name
455 	 * @param _nameTAOVaultAddress The address of NameTAOVault
456 	 */
457 	function deployName(string memory _name,
458 		address _originId,
459 		string memory _datHash,
460 		string memory _database,
461 		string memory _keyValue,
462 		bytes32 _contentId,
463 		address _nameTAOVaultAddress
464 		) public returns (Name _myName) {
465 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
466 	}
467 
468 	/**
469 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
470 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
471 	 * @param _currentPrimordialBalance Account's current primordial ion balance
472 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
473 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
474 	 * @return the new primordial weighted multiplier
475 	 */
476 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
477 		if (_currentWeightedMultiplier > 0) {
478 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
479 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
480 			return _totalWeightedIons.div(_totalIons);
481 		} else {
482 			return _additionalWeightedMultiplier;
483 		}
484 	}
485 
486 	/**
487 	 * @dev Calculate the primordial ion multiplier on a given lot
488 	 *		Total Primordial Mintable = T
489 	 *		Total Primordial Minted = M
490 	 *		Starting Multiplier = S
491 	 *		Ending Multiplier = E
492 	 *		To Purchase = P
493 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
494 	 *
495 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
496 	 * @param _totalPrimordialMintable Total Primordial ion mintable
497 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
498 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
499 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
500 	 * @return The multiplier in (10 ** 6)
501 	 */
502 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
503 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
504 			/**
505 			 * Let temp = M + (P/2)
506 			 * Multiplier = (1 - (temp / T)) x (S-E)
507 			 */
508 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
509 
510 			/**
511 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
512 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
513 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
514 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
515 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
516 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
517 			 */
518 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
519 			/**
520 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
521 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
522 			 */
523 			return multiplier.div(_MULTIPLIER_DIVISOR);
524 		} else {
525 			return 0;
526 		}
527 	}
528 
529 	/**
530 	 * @dev Calculate the bonus percentage of network ion on a given lot
531 	 *		Total Primordial Mintable = T
532 	 *		Total Primordial Minted = M
533 	 *		Starting Network Bonus Multiplier = Bs
534 	 *		Ending Network Bonus Multiplier = Be
535 	 *		To Purchase = P
536 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
537 	 *
538 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
539 	 * @param _totalPrimordialMintable Total Primordial ion intable
540 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
541 	 * @param _startingMultiplier The starting Network ion bonus multiplier
542 	 * @param _endingMultiplier The ending Network ion bonus multiplier
543 	 * @return The bonus percentage
544 	 */
545 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
546 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
547 			/**
548 			 * Let temp = M + (P/2)
549 			 * B% = (1 - (temp / T)) x (Bs-Be)
550 			 */
551 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
552 
553 			/**
554 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
555 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
556 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
557 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
558 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
559 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
560 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
561 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
562 			 */
563 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
564 			return bonusPercentage;
565 		} else {
566 			return 0;
567 		}
568 	}
569 
570 	/**
571 	 * @dev Calculate the bonus amount of network ion on a given lot
572 	 *		AO Bonus Amount = B% x P
573 	 *
574 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
575 	 * @param _totalPrimordialMintable Total Primordial ion intable
576 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
577 	 * @param _startingMultiplier The starting Network ion bonus multiplier
578 	 * @param _endingMultiplier The ending Network ion bonus multiplier
579 	 * @return The bonus percentage
580 	 */
581 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
582 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
583 		/**
584 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
585 		 * when calculating the network ion bonus amount
586 		 */
587 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
588 		return networkBonus;
589 	}
590 
591 	/**
592 	 * @dev Calculate the maximum amount of Primordial an account can burn
593 	 *		_primordialBalance = P
594 	 *		_currentWeightedMultiplier = M
595 	 *		_maximumMultiplier = S
596 	 *		_amountToBurn = B
597 	 *		B = ((S x P) - (P x M)) / S
598 	 *
599 	 * @param _primordialBalance Account's primordial ion balance
600 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
601 	 * @param _maximumMultiplier The maximum multiplier of this account
602 	 * @return The maximum burn amount
603 	 */
604 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
605 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
606 	}
607 
608 	/**
609 	 * @dev Calculate the new multiplier after burning primordial ion
610 	 *		_primordialBalance = P
611 	 *		_currentWeightedMultiplier = M
612 	 *		_amountToBurn = B
613 	 *		_newMultiplier = E
614 	 *		E = (P x M) / (P - B)
615 	 *
616 	 * @param _primordialBalance Account's primordial ion balance
617 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
618 	 * @param _amountToBurn The amount of primordial ion to burn
619 	 * @return The new multiplier
620 	 */
621 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
622 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
623 	}
624 
625 	/**
626 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
627 	 *		_primordialBalance = P
628 	 *		_currentWeightedMultiplier = M
629 	 *		_amountToConvert = C
630 	 *		_newMultiplier = E
631 	 *		E = (P x M) / (P + C)
632 	 *
633 	 * @param _primordialBalance Account's primordial ion balance
634 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
635 	 * @param _amountToConvert The amount of network ion to convert
636 	 * @return The new multiplier
637 	 */
638 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
639 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
640 	}
641 
642 	/**
643 	 * @dev count num of digits
644 	 * @param number uint256 of the nuumber to be checked
645 	 * @return uint8 num of digits
646 	 */
647 	function numDigits(uint256 number) public pure returns (uint8) {
648 		uint8 digits = 0;
649 		while(number != 0) {
650 			number = number.div(10);
651 			digits++;
652 		}
653 		return digits;
654 	}
655 }
656 
657 
658 
659 contract TheAO {
660 	address public theAO;
661 	address public nameTAOPositionAddress;
662 
663 	// Check whether an address is whitelisted and granted access to transact
664 	// on behalf of others
665 	mapping (address => bool) public whitelist;
666 
667 	constructor() public {
668 		theAO = msg.sender;
669 	}
670 
671 	/**
672 	 * @dev Checks if msg.sender is in whitelist.
673 	 */
674 	modifier inWhitelist() {
675 		require (whitelist[msg.sender] == true);
676 		_;
677 	}
678 
679 	/**
680 	 * @dev Transfer ownership of The AO to new address
681 	 * @param _theAO The new address to be transferred
682 	 */
683 	function transferOwnership(address _theAO) public {
684 		require (msg.sender == theAO);
685 		require (_theAO != address(0));
686 		theAO = _theAO;
687 	}
688 
689 	/**
690 	 * @dev Whitelist `_account` address to transact on behalf of others
691 	 * @param _account The address to whitelist
692 	 * @param _whitelist Either to whitelist or not
693 	 */
694 	function setWhitelist(address _account, bool _whitelist) public {
695 		require (msg.sender == theAO);
696 		require (_account != address(0));
697 		whitelist[_account] = _whitelist;
698 	}
699 }
700 
701 
702 
703 /**
704  * @title AOIonLot
705  */
706 contract AOIonLot is TheAO {
707 	using SafeMath for uint256;
708 
709 	address public aoIonAddress;
710 
711 	uint256 public totalLots;
712 	uint256 public totalBurnLots;
713 	uint256 public totalConvertLots;
714 
715 	/**
716 	 * Stores Lot creation data (during network exchange)
717 	 */
718 	struct Lot {
719 		bytes32 lotId;
720 		uint256 multiplier;	// This value is in 10^6, so 1000000 = 1
721 		address lotOwner;
722 		uint256 amount;
723 	}
724 
725 	/**
726 	 * Struct to store info when account burns primordial ion
727 	 */
728 	struct BurnLot {
729 		bytes32 burnLotId;
730 		address lotOwner;
731 		uint256 amount;
732 	}
733 
734 	/**
735 	 * Struct to store info when account converts network ion to primordial ion
736 	 */
737 	struct ConvertLot {
738 		bytes32 convertLotId;
739 		address lotOwner;
740 		uint256 amount;
741 	}
742 
743 	// Mapping from Lot ID to Lot object
744 	mapping (bytes32 => Lot) internal lots;
745 
746 	// Mapping from Burn Lot ID to BurnLot object
747 	mapping (bytes32 => BurnLot) internal burnLots;
748 
749 	// Mapping from Convert Lot ID to ConvertLot object
750 	mapping (bytes32 => ConvertLot) internal convertLots;
751 
752 	// Mapping from owner to list of owned lot IDs
753 	mapping (address => bytes32[]) internal ownedLots;
754 
755 	// Mapping from owner to list of owned burn lot IDs
756 	mapping (address => bytes32[]) internal ownedBurnLots;
757 
758 	// Mapping from owner to list of owned convert lot IDs
759 	mapping (address => bytes32[]) internal ownedConvertLots;
760 
761 	// Event to be broadcasted to public when a lot is created
762 	// multiplier value is in 10^6 to account for 6 decimal points
763 	event LotCreation(address indexed lotOwner, bytes32 indexed lotId, uint256 multiplier, uint256 primordialAmount, uint256 networkBonusAmount);
764 
765 	// Event to be broadcasted to public when burn lot is created (when account burns primordial ions)
766 	event BurnLotCreation(address indexed lotOwner, bytes32 indexed burnLotId, uint256 burnAmount, uint256 multiplierAfterBurn);
767 
768 	// Event to be broadcasted to public when convert lot is created (when account convert network ions to primordial ions)
769 	event ConvertLotCreation(address indexed lotOwner, bytes32 indexed convertLotId, uint256 convertAmount, uint256 multiplierAfterConversion);
770 
771 	/**
772 	 * @dev Constructor function
773 	 */
774 	constructor(address _aoIonAddress, address _nameTAOPositionAddress) public {
775 		setAOIonAddress(_aoIonAddress);
776 		setNameTAOPositionAddress(_nameTAOPositionAddress);
777 	}
778 
779 	/**
780 	 * @dev Checks if the calling contract address is The AO
781 	 *		OR
782 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
783 	 */
784 	modifier onlyTheAO {
785 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
786 		_;
787 	}
788 
789 	/**
790 	 * @dev Check if calling address is AOIon
791 	 */
792 	modifier onlyAOIon {
793 		require (msg.sender == aoIonAddress);
794 		_;
795 	}
796 
797 	/***** The AO ONLY METHODS *****/
798 	/**
799 	 * @dev Transfer ownership of The AO to new address
800 	 * @param _theAO The new address to be transferred
801 	 */
802 	function transferOwnership(address _theAO) public onlyTheAO {
803 		require (_theAO != address(0));
804 		theAO = _theAO;
805 	}
806 
807 	/**
808 	 * @dev Whitelist `_account` address to transact on behalf of others
809 	 * @param _account The address to whitelist
810 	 * @param _whitelist Either to whitelist or not
811 	 */
812 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
813 		require (_account != address(0));
814 		whitelist[_account] = _whitelist;
815 	}
816 
817 	/**
818 	 * @dev The AO set the AOIon Address
819 	 * @param _aoIonAddress The address of AOIon
820 	 */
821 	function setAOIonAddress(address _aoIonAddress) public onlyTheAO {
822 		require (_aoIonAddress != address(0));
823 		aoIonAddress = _aoIonAddress;
824 	}
825 
826 	/**
827 	 * @dev The AO set the NameTAOPosition Address
828 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
829 	 */
830 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
831 		require (_nameTAOPositionAddress != address(0));
832 		nameTAOPositionAddress = _nameTAOPositionAddress;
833 	}
834 
835 	/***** PUBLIC METHODS *****/
836 	/**
837 	 * @dev Create a lot with `primordialAmount` of primordial ions with `_multiplier` for an `account`
838 	 *		during network exchange, and reward `_networkBonusAmount` if exist
839 	 * @param _account Address of the lot owner
840 	 * @param _primordialAmount The amount of primordial ions to be stored in the lot
841 	 * @param _multiplier The multiplier for this lot in (10 ** 6)
842 	 * @param _networkBonusAmount The network ion bonus amount
843 	 * @return Created lot Id
844 	 */
845 	function createPrimordialLot(address _account, uint256 _primordialAmount, uint256 _multiplier, uint256 _networkBonusAmount) external onlyAOIon returns (bytes32) {
846 		return _createWeightedMultiplierLot(_account, _primordialAmount, _multiplier, _networkBonusAmount);
847 	}
848 
849 	/**
850 	 * @dev Create a lot with `amount` of ions at `weightedMultiplier` for an `account`
851 	 * @param _account Address of lot owner
852 	 * @param _amount The amount of ions
853 	 * @param _weightedMultiplier The multiplier of the lot (in 10^6)
854 	 * @return bytes32 of new created lot ID
855 	 */
856 	function createWeightedMultiplierLot(address _account, uint256 _amount, uint256 _weightedMultiplier) external onlyAOIon returns (bytes32) {
857 		require (_account != address(0));
858 		require (_amount > 0);
859 		return _createWeightedMultiplierLot(_account, _amount, _weightedMultiplier, 0);
860 	}
861 
862 	/**
863 	 * @dev Return the lot information at a given ID
864 	 * @param _lotId The lot ID in question
865 	 * @return id of the lot
866 	 * @return The lot owner address
867 	 * @return multiplier of the lot in (10 ** 6)
868 	 * @return Primordial ion amount in the lot
869 	 */
870 	function lotById(bytes32 _lotId) external view returns (bytes32, address, uint256, uint256) {
871 		Lot memory _lot = lots[_lotId];
872 		return (_lot.lotId, _lot.lotOwner, _lot.multiplier, _lot.amount);
873 	}
874 
875 	/**
876 	 * @dev Return all lot IDs owned by an address
877 	 * @param _lotOwner The address of the lot owner
878 	 * @return array of lot IDs
879 	 */
880 	function lotIdsByAddress(address _lotOwner) public view returns (bytes32[] memory) {
881 		return ownedLots[_lotOwner];
882 	}
883 
884 	/**
885 	 * @dev Return the total lots owned by an address
886 	 * @param _lotOwner The address of the lot owner
887 	 * @return total lots owner by the address
888 	 */
889 	function totalLotsByAddress(address _lotOwner) external view returns (uint256) {
890 		return ownedLots[_lotOwner].length;
891 	}
892 
893 	/**
894 	 * @dev Return the lot information at a given index of the lots list of the requested owner
895 	 * @param _lotOwner The address owning the lots list to be accessed
896 	 * @param _index uint256 representing the index to be accessed of the requested lots list
897 	 * @return id of the lot
898 	 * @return The address of the lot owner
899 	 * @return multiplier of the lot in (10 ** 6)
900 	 * @return Primordial ion amount in the lot
901 	 */
902 	function lotOfOwnerByIndex(address _lotOwner, uint256 _index) public view returns (bytes32, address, uint256, uint256) {
903 		require (_index < ownedLots[_lotOwner].length);
904 		Lot memory _lot = lots[ownedLots[_lotOwner][_index]];
905 		return (_lot.lotId, _lot.lotOwner, _lot.multiplier, _lot.amount);
906 	}
907 
908 	/**
909 	 * @dev Store burn lot information
910 	 * @param _account The address of the account
911 	 * @param _amount The amount of primordial ions to burn
912 	 * @param _multiplierAfterBurn The owner's weighted multiplier after burn
913 	 * @return true on success
914 	 */
915 	function createBurnLot(address _account, uint256 _amount, uint256 _multiplierAfterBurn) external onlyAOIon returns (bool) {
916 		totalBurnLots++;
917 
918 		// Generate burn lot Id
919 		bytes32 burnLotId = keccak256(abi.encodePacked(this, _account, totalBurnLots));
920 
921 		// Make sure no one owns this lot yet
922 		require (burnLots[burnLotId].lotOwner == address(0));
923 
924 		BurnLot storage burnLot = burnLots[burnLotId];
925 		burnLot.burnLotId = burnLotId;
926 		burnLot.lotOwner = _account;
927 		burnLot.amount = _amount;
928 		ownedBurnLots[_account].push(burnLotId);
929 		emit BurnLotCreation(burnLot.lotOwner, burnLot.burnLotId, burnLot.amount, _multiplierAfterBurn);
930 		return true;
931 	}
932 
933 	/**
934 	 * @dev Return all Burn Lot IDs owned by an address
935 	 * @param _lotOwner The address of the burn lot owner
936 	 * @return array of Burn Lot IDs
937 	 */
938 	function burnLotIdsByAddress(address _lotOwner) public view returns (bytes32[] memory) {
939 		return ownedBurnLots[_lotOwner];
940 	}
941 
942 	/**
943 	 * @dev Return the total burn lots owned by an address
944 	 * @param _lotOwner The address of the burn lot owner
945 	 * @return total burn lots owner by the address
946 	 */
947 	function totalBurnLotsByAddress(address _lotOwner) public view returns (uint256) {
948 		return ownedBurnLots[_lotOwner].length;
949 	}
950 
951 	/**
952 	 * @dev Return the burn lot information at a given ID
953 	 * @param _burnLotId The burn lot ID in question
954 	 * @return id of the lot
955 	 * @return The address of the burn lot owner
956 	 * @return Primordial ion amount in the burn lot
957 	 */
958 	function burnLotById(bytes32 _burnLotId) public view returns (bytes32, address, uint256) {
959 		BurnLot memory _burnLot = burnLots[_burnLotId];
960 		return (_burnLot.burnLotId, _burnLot.lotOwner, _burnLot.amount);
961 	}
962 
963 	/**
964 	 * @dev Store convert lot information
965 	 * @param _account The address of the account
966 	 * @param _amount The amount to convert
967 	 * @param _multiplierAfterConversion The owner's weighted multiplier after conversion
968 	 * @return true on success
969 	 */
970 	function createConvertLot(address _account, uint256 _amount, uint256 _multiplierAfterConversion) external onlyAOIon returns (bool) {
971 		// Store convert lot info
972 		totalConvertLots++;
973 
974 		// Generate convert lot Id
975 		bytes32 convertLotId = keccak256(abi.encodePacked(this, _account, totalConvertLots));
976 
977 		// Make sure no one owns this lot yet
978 		require (convertLots[convertLotId].lotOwner == address(0));
979 
980 		ConvertLot storage convertLot = convertLots[convertLotId];
981 		convertLot.convertLotId = convertLotId;
982 		convertLot.lotOwner = _account;
983 		convertLot.amount = _amount;
984 		ownedConvertLots[_account].push(convertLotId);
985 		emit ConvertLotCreation(convertLot.lotOwner, convertLot.convertLotId, convertLot.amount, _multiplierAfterConversion);
986 		return true;
987 	}
988 
989 	/**
990 	 * @dev Return all Convert Lot IDs owned by an address
991 	 * @param _lotOwner The address of the convert lot owner
992 	 * @return array of Convert Lot IDs
993 	 */
994 	function convertLotIdsByAddress(address _lotOwner) public view returns (bytes32[] memory) {
995 		return ownedConvertLots[_lotOwner];
996 	}
997 
998 	/**
999 	 * @dev Return the total convert lots owned by an address
1000 	 * @param _lotOwner The address of the convert lot owner
1001 	 * @return total convert lots owner by the address
1002 	 */
1003 	function totalConvertLotsByAddress(address _lotOwner) public view returns (uint256) {
1004 		return ownedConvertLots[_lotOwner].length;
1005 	}
1006 
1007 	/**
1008 	 * @dev Return the convert lot information at a given ID
1009 	 * @param _convertLotId The convert lot ID in question
1010 	 * @return id of the lot
1011 	 * @return The address of the convert lot owner
1012 	 * @return Primordial ion amount in the convert lot
1013 	 */
1014 	function convertLotById(bytes32 _convertLotId) public view returns (bytes32, address, uint256) {
1015 		ConvertLot memory _convertLot = convertLots[_convertLotId];
1016 		return (_convertLot.convertLotId, _convertLot.lotOwner, _convertLot.amount);
1017 	}
1018 
1019 	/***** INTERNAL METHOD *****/
1020 	/**
1021 	 * @dev Actual creating a lot with `amount` of ions at `weightedMultiplier` for an `account`
1022 	 * @param _account Address of lot owner
1023 	 * @param _amount The amount of ions
1024 	 * @param _weightedMultiplier The multiplier of the lot (in 10^6)
1025 	 * @param _networkBonusAmount The network ion bonus amount
1026 	 * @return bytes32 of new created lot ID
1027 	 */
1028 	function _createWeightedMultiplierLot(address _account, uint256 _amount, uint256 _weightedMultiplier, uint256 _networkBonusAmount) internal returns (bytes32) {
1029 		totalLots++;
1030 
1031 		// Generate lotId
1032 		bytes32 lotId = keccak256(abi.encodePacked(address(this), _account, totalLots));
1033 
1034 		// Make sure no one owns this lot yet
1035 		require (lots[lotId].lotOwner == address(0));
1036 
1037 		Lot storage lot = lots[lotId];
1038 		lot.lotId = lotId;
1039 		lot.multiplier = _weightedMultiplier;
1040 		lot.lotOwner = _account;
1041 		lot.amount = _amount;
1042 		ownedLots[_account].push(lotId);
1043 
1044 		emit LotCreation(lot.lotOwner, lot.lotId, lot.multiplier, lot.amount, _networkBonusAmount);
1045 		return lotId;
1046 	}
1047 }