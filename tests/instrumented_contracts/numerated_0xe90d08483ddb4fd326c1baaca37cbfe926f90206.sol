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
70 
71 
72 contract TheAO {
73 	address public theAO;
74 	address public nameTAOPositionAddress;
75 
76 	// Check whether an address is whitelisted and granted access to transact
77 	// on behalf of others
78 	mapping (address => bool) public whitelist;
79 
80 	constructor() public {
81 		theAO = msg.sender;
82 	}
83 
84 	/**
85 	 * @dev Checks if msg.sender is in whitelist.
86 	 */
87 	modifier inWhitelist() {
88 		require (whitelist[msg.sender] == true);
89 		_;
90 	}
91 
92 	/**
93 	 * @dev Transfer ownership of The AO to new address
94 	 * @param _theAO The new address to be transferred
95 	 */
96 	function transferOwnership(address _theAO) public {
97 		require (msg.sender == theAO);
98 		require (_theAO != address(0));
99 		theAO = _theAO;
100 	}
101 
102 	/**
103 	 * @dev Whitelist `_account` address to transact on behalf of others
104 	 * @param _account The address to whitelist
105 	 * @param _whitelist Either to whitelist or not
106 	 */
107 	function setWhitelist(address _account, bool _whitelist) public {
108 		require (msg.sender == theAO);
109 		require (_account != address(0));
110 		whitelist[_account] = _whitelist;
111 	}
112 }
113 
114 
115 
116 
117 
118 
119 
120 
121 
122 
123 
124 contract TokenERC20 {
125 	// Public variables of the token
126 	string public name;
127 	string public symbol;
128 	uint8 public decimals = 18;
129 	// 18 decimals is the strongly suggested default, avoid changing it
130 	uint256 public totalSupply;
131 
132 	// This creates an array with all balances
133 	mapping (address => uint256) public balanceOf;
134 	mapping (address => mapping (address => uint256)) public allowance;
135 
136 	// This generates a public event on the blockchain that will notify clients
137 	event Transfer(address indexed from, address indexed to, uint256 value);
138 
139 	// This generates a public event on the blockchain that will notify clients
140 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
141 
142 	// This notifies clients about the amount burnt
143 	event Burn(address indexed from, uint256 value);
144 
145 	/**
146 	 * Constructor function
147 	 *
148 	 * Initializes contract with initial supply tokens to the creator of the contract
149 	 */
150 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
151 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
152 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
153 		name = tokenName;                                   // Set the name for display purposes
154 		symbol = tokenSymbol;                               // Set the symbol for display purposes
155 	}
156 
157 	/**
158 	 * Internal transfer, only can be called by this contract
159 	 */
160 	function _transfer(address _from, address _to, uint _value) internal {
161 		// Prevent transfer to 0x0 address. Use burn() instead
162 		require(_to != address(0));
163 		// Check if the sender has enough
164 		require(balanceOf[_from] >= _value);
165 		// Check for overflows
166 		require(balanceOf[_to] + _value > balanceOf[_to]);
167 		// Save this for an assertion in the future
168 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
169 		// Subtract from the sender
170 		balanceOf[_from] -= _value;
171 		// Add the same to the recipient
172 		balanceOf[_to] += _value;
173 		emit Transfer(_from, _to, _value);
174 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
175 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
176 	}
177 
178 	/**
179 	 * Transfer tokens
180 	 *
181 	 * Send `_value` tokens to `_to` from your account
182 	 *
183 	 * @param _to The address of the recipient
184 	 * @param _value the amount to send
185 	 */
186 	function transfer(address _to, uint256 _value) public returns (bool success) {
187 		_transfer(msg.sender, _to, _value);
188 		return true;
189 	}
190 
191 	/**
192 	 * Transfer tokens from other address
193 	 *
194 	 * Send `_value` tokens to `_to` in behalf of `_from`
195 	 *
196 	 * @param _from The address of the sender
197 	 * @param _to The address of the recipient
198 	 * @param _value the amount to send
199 	 */
200 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
201 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
202 		allowance[_from][msg.sender] -= _value;
203 		_transfer(_from, _to, _value);
204 		return true;
205 	}
206 
207 	/**
208 	 * Set allowance for other address
209 	 *
210 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
211 	 *
212 	 * @param _spender The address authorized to spend
213 	 * @param _value the max amount they can spend
214 	 */
215 	function approve(address _spender, uint256 _value) public returns (bool success) {
216 		allowance[msg.sender][_spender] = _value;
217 		emit Approval(msg.sender, _spender, _value);
218 		return true;
219 	}
220 
221 	/**
222 	 * Set allowance for other address and notify
223 	 *
224 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
225 	 *
226 	 * @param _spender The address authorized to spend
227 	 * @param _value the max amount they can spend
228 	 * @param _extraData some extra information to send to the approved contract
229 	 */
230 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
231 		tokenRecipient spender = tokenRecipient(_spender);
232 		if (approve(_spender, _value)) {
233 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
234 			return true;
235 		}
236 	}
237 
238 	/**
239 	 * Destroy tokens
240 	 *
241 	 * Remove `_value` tokens from the system irreversibly
242 	 *
243 	 * @param _value the amount of money to burn
244 	 */
245 	function burn(uint256 _value) public returns (bool success) {
246 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
247 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
248 		totalSupply -= _value;                      // Updates totalSupply
249 		emit Burn(msg.sender, _value);
250 		return true;
251 	}
252 
253 	/**
254 	 * Destroy tokens from other account
255 	 *
256 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
257 	 *
258 	 * @param _from the address of the sender
259 	 * @param _value the amount of money to burn
260 	 */
261 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
262 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
263 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
264 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
265 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
266 		totalSupply -= _value;                              // Update totalSupply
267 		emit Burn(_from, _value);
268 		return true;
269 	}
270 }
271 
272 
273 /**
274  * @title TAO
275  */
276 contract TAO {
277 	using SafeMath for uint256;
278 
279 	address public vaultAddress;
280 	string public name;				// the name for this TAO
281 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
282 
283 	// TAO's data
284 	string public datHash;
285 	string public database;
286 	string public keyValue;
287 	bytes32 public contentId;
288 
289 	/**
290 	 * 0 = TAO
291 	 * 1 = Name
292 	 */
293 	uint8 public typeId;
294 
295 	/**
296 	 * @dev Constructor function
297 	 */
298 	constructor (string memory _name,
299 		address _originId,
300 		string memory _datHash,
301 		string memory _database,
302 		string memory _keyValue,
303 		bytes32 _contentId,
304 		address _vaultAddress
305 	) public {
306 		name = _name;
307 		originId = _originId;
308 		datHash = _datHash;
309 		database = _database;
310 		keyValue = _keyValue;
311 		contentId = _contentId;
312 
313 		// Creating TAO
314 		typeId = 0;
315 
316 		vaultAddress = _vaultAddress;
317 	}
318 
319 	/**
320 	 * @dev Checks if calling address is Vault contract
321 	 */
322 	modifier onlyVault {
323 		require (msg.sender == vaultAddress);
324 		_;
325 	}
326 
327 	/**
328 	 * Will receive any ETH sent
329 	 */
330 	function () external payable {
331 	}
332 
333 	/**
334 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
335 	 * @param _recipient The recipient address
336 	 * @param _amount The amount to transfer
337 	 * @return true on success
338 	 */
339 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
340 		_recipient.transfer(_amount);
341 		return true;
342 	}
343 
344 	/**
345 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
346 	 * @param _erc20TokenAddress The address of ERC20 Token
347 	 * @param _recipient The recipient address
348 	 * @param _amount The amount to transfer
349 	 * @return true on success
350 	 */
351 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
352 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
353 		_erc20.transfer(_recipient, _amount);
354 		return true;
355 	}
356 }
357 
358 
359 
360 
361 /**
362  * @title Name
363  */
364 contract Name is TAO {
365 	/**
366 	 * @dev Constructor function
367 	 */
368 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
369 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
370 		// Creating Name
371 		typeId = 1;
372 	}
373 }
374 
375 
376 
377 
378 /**
379  * @title AOLibrary
380  */
381 library AOLibrary {
382 	using SafeMath for uint256;
383 
384 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
385 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
386 
387 	/**
388 	 * @dev Check whether or not the given TAO ID is a TAO
389 	 * @param _taoId The ID of the TAO
390 	 * @return true if yes. false otherwise
391 	 */
392 	function isTAO(address _taoId) public view returns (bool) {
393 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
394 	}
395 
396 	/**
397 	 * @dev Check whether or not the given Name ID is a Name
398 	 * @param _nameId The ID of the Name
399 	 * @return true if yes. false otherwise
400 	 */
401 	function isName(address _nameId) public view returns (bool) {
402 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
403 	}
404 
405 	/**
406 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
407 	 * @param _tokenAddress The ERC20 Token address to check
408 	 */
409 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
410 		if (_tokenAddress == address(0)) {
411 			return false;
412 		}
413 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
414 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
415 	}
416 
417 	/**
418 	 * @dev Checks if the calling contract address is The AO
419 	 *		OR
420 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
421 	 * @param _sender The address to check
422 	 * @param _theAO The AO address
423 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
424 	 * @return true if yes, false otherwise
425 	 */
426 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
427 		return (_sender == _theAO ||
428 			(
429 				(isTAO(_theAO) || isName(_theAO)) &&
430 				_nameTAOPositionAddress != address(0) &&
431 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
432 			)
433 		);
434 	}
435 
436 	/**
437 	 * @dev Return the divisor used to correctly calculate percentage.
438 	 *		Percentage stored throughout AO contracts covers 4 decimals,
439 	 *		so 1% is 10000, 1.25% is 12500, etc
440 	 */
441 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
442 		return _PERCENTAGE_DIVISOR;
443 	}
444 
445 	/**
446 	 * @dev Return the divisor used to correctly calculate multiplier.
447 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
448 	 *		so 1 is 1000000, 0.023 is 23000, etc
449 	 */
450 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
451 		return _MULTIPLIER_DIVISOR;
452 	}
453 
454 	/**
455 	 * @dev deploy a TAO
456 	 * @param _name The name of the TAO
457 	 * @param _originId The Name ID the creates the TAO
458 	 * @param _datHash The datHash of this TAO
459 	 * @param _database The database for this TAO
460 	 * @param _keyValue The key/value pair to be checked on the database
461 	 * @param _contentId The contentId related to this TAO
462 	 * @param _nameTAOVaultAddress The address of NameTAOVault
463 	 */
464 	function deployTAO(string memory _name,
465 		address _originId,
466 		string memory _datHash,
467 		string memory _database,
468 		string memory _keyValue,
469 		bytes32 _contentId,
470 		address _nameTAOVaultAddress
471 		) public returns (TAO _tao) {
472 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
473 	}
474 
475 	/**
476 	 * @dev deploy a Name
477 	 * @param _name The name of the Name
478 	 * @param _originId The eth address the creates the Name
479 	 * @param _datHash The datHash of this Name
480 	 * @param _database The database for this Name
481 	 * @param _keyValue The key/value pair to be checked on the database
482 	 * @param _contentId The contentId related to this Name
483 	 * @param _nameTAOVaultAddress The address of NameTAOVault
484 	 */
485 	function deployName(string memory _name,
486 		address _originId,
487 		string memory _datHash,
488 		string memory _database,
489 		string memory _keyValue,
490 		bytes32 _contentId,
491 		address _nameTAOVaultAddress
492 		) public returns (Name _myName) {
493 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
494 	}
495 
496 	/**
497 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
498 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
499 	 * @param _currentPrimordialBalance Account's current primordial ion balance
500 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
501 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
502 	 * @return the new primordial weighted multiplier
503 	 */
504 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
505 		if (_currentWeightedMultiplier > 0) {
506 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
507 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
508 			return _totalWeightedIons.div(_totalIons);
509 		} else {
510 			return _additionalWeightedMultiplier;
511 		}
512 	}
513 
514 	/**
515 	 * @dev Calculate the primordial ion multiplier on a given lot
516 	 *		Total Primordial Mintable = T
517 	 *		Total Primordial Minted = M
518 	 *		Starting Multiplier = S
519 	 *		Ending Multiplier = E
520 	 *		To Purchase = P
521 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
522 	 *
523 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
524 	 * @param _totalPrimordialMintable Total Primordial ion mintable
525 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
526 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
527 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
528 	 * @return The multiplier in (10 ** 6)
529 	 */
530 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
531 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
532 			/**
533 			 * Let temp = M + (P/2)
534 			 * Multiplier = (1 - (temp / T)) x (S-E)
535 			 */
536 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
537 
538 			/**
539 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
540 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
541 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
542 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
543 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
544 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
545 			 */
546 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
547 			/**
548 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
549 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
550 			 */
551 			return multiplier.div(_MULTIPLIER_DIVISOR);
552 		} else {
553 			return 0;
554 		}
555 	}
556 
557 	/**
558 	 * @dev Calculate the bonus percentage of network ion on a given lot
559 	 *		Total Primordial Mintable = T
560 	 *		Total Primordial Minted = M
561 	 *		Starting Network Bonus Multiplier = Bs
562 	 *		Ending Network Bonus Multiplier = Be
563 	 *		To Purchase = P
564 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
565 	 *
566 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
567 	 * @param _totalPrimordialMintable Total Primordial ion intable
568 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
569 	 * @param _startingMultiplier The starting Network ion bonus multiplier
570 	 * @param _endingMultiplier The ending Network ion bonus multiplier
571 	 * @return The bonus percentage
572 	 */
573 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
574 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
575 			/**
576 			 * Let temp = M + (P/2)
577 			 * B% = (1 - (temp / T)) x (Bs-Be)
578 			 */
579 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
580 
581 			/**
582 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
583 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
584 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
585 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
586 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
587 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
588 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
589 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
590 			 */
591 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
592 			return bonusPercentage;
593 		} else {
594 			return 0;
595 		}
596 	}
597 
598 	/**
599 	 * @dev Calculate the bonus amount of network ion on a given lot
600 	 *		AO Bonus Amount = B% x P
601 	 *
602 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
603 	 * @param _totalPrimordialMintable Total Primordial ion intable
604 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
605 	 * @param _startingMultiplier The starting Network ion bonus multiplier
606 	 * @param _endingMultiplier The ending Network ion bonus multiplier
607 	 * @return The bonus percentage
608 	 */
609 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
610 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
611 		/**
612 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
613 		 * when calculating the network ion bonus amount
614 		 */
615 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
616 		return networkBonus;
617 	}
618 
619 	/**
620 	 * @dev Calculate the maximum amount of Primordial an account can burn
621 	 *		_primordialBalance = P
622 	 *		_currentWeightedMultiplier = M
623 	 *		_maximumMultiplier = S
624 	 *		_amountToBurn = B
625 	 *		B = ((S x P) - (P x M)) / S
626 	 *
627 	 * @param _primordialBalance Account's primordial ion balance
628 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
629 	 * @param _maximumMultiplier The maximum multiplier of this account
630 	 * @return The maximum burn amount
631 	 */
632 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
633 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
634 	}
635 
636 	/**
637 	 * @dev Calculate the new multiplier after burning primordial ion
638 	 *		_primordialBalance = P
639 	 *		_currentWeightedMultiplier = M
640 	 *		_amountToBurn = B
641 	 *		_newMultiplier = E
642 	 *		E = (P x M) / (P - B)
643 	 *
644 	 * @param _primordialBalance Account's primordial ion balance
645 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
646 	 * @param _amountToBurn The amount of primordial ion to burn
647 	 * @return The new multiplier
648 	 */
649 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
650 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
651 	}
652 
653 	/**
654 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
655 	 *		_primordialBalance = P
656 	 *		_currentWeightedMultiplier = M
657 	 *		_amountToConvert = C
658 	 *		_newMultiplier = E
659 	 *		E = (P x M) / (P + C)
660 	 *
661 	 * @param _primordialBalance Account's primordial ion balance
662 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
663 	 * @param _amountToConvert The amount of network ion to convert
664 	 * @return The new multiplier
665 	 */
666 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
667 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
668 	}
669 
670 	/**
671 	 * @dev count num of digits
672 	 * @param number uint256 of the nuumber to be checked
673 	 * @return uint8 num of digits
674 	 */
675 	function numDigits(uint256 number) public pure returns (uint8) {
676 		uint8 digits = 0;
677 		while(number != 0) {
678 			number = number.div(10);
679 			digits++;
680 		}
681 		return digits;
682 	}
683 }
684 
685 
686 contract Epiphany is TheAO {
687 	string public what;
688 	string public when;
689 	string public why;
690 	string public who;
691 	address public where;
692 	string public aSign;
693 	string public logos;
694 
695 	constructor() public {
696 		what = 'The AO';
697 		when = 'January 6th, 2019 a.d, year 1 a.c. Epiphany. An appearance or manifestation especially of a divine being. An illuminating discovery, realization, or disclosure.';
698 		why = 'To Hear, See, and Speak the Human inside Humanity.';
699 		who = 'You.  Set the world, Free. – Truth';
700 		aSign = '08e2c4e1ccf3bccfb3b8eef14679b28442649a2a733960661210a0b00d9c93bf';
701 		logos = '0920c6ab1848df83a332a21e8c9ec1a393e694c396b872aee053722d023e2a32';
702 	}
703 
704 	/**
705 	 * @dev Checks if the calling contract address is The AO
706 	 *		OR
707 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
708 	 */
709 	modifier onlyTheAO {
710 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
711 		_;
712 	}
713 
714 	/***** The AO ONLY METHODS *****/
715 	/**
716 	 * @dev The AO set the NameTAOPosition Address
717 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
718 	 */
719 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
720 		require (_nameTAOPositionAddress != address(0));
721 		nameTAOPositionAddress = _nameTAOPositionAddress;
722 	}
723 
724 	/**
725 	 * @dev Transfer ownership of The AO to new address
726 	 * @param _theAO The new address to be transferred
727 	 */
728 	function transferOwnership(address _theAO) public onlyTheAO {
729 		require (_theAO != address(0));
730 		theAO = _theAO;
731 	}
732 
733 	/**
734 	 * @dev Whitelist `_account` address to transact on behalf of others
735 	 * @param _account The address to whitelist
736 	 * @param _whitelist Either to whitelist or not
737 	 */
738 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
739 		require (_account != address(0));
740 		whitelist[_account] = _whitelist;
741 	}
742 
743 	/**
744 	 * @dev Set `where` value
745 	 * @param _where The new value to be set
746 	 */
747 	function setWhere(address _where) public onlyTheAO {
748 		where = _where;
749 	}
750 }