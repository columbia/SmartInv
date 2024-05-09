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
72 
73 
74 
75 
76 
77 
78 
79 
80 
81 
82 
83 contract TokenERC20 {
84 	// Public variables of the token
85 	string public name;
86 	string public symbol;
87 	uint8 public decimals = 18;
88 	// 18 decimals is the strongly suggested default, avoid changing it
89 	uint256 public totalSupply;
90 
91 	// This creates an array with all balances
92 	mapping (address => uint256) public balanceOf;
93 	mapping (address => mapping (address => uint256)) public allowance;
94 
95 	// This generates a public event on the blockchain that will notify clients
96 	event Transfer(address indexed from, address indexed to, uint256 value);
97 
98 	// This generates a public event on the blockchain that will notify clients
99 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100 
101 	// This notifies clients about the amount burnt
102 	event Burn(address indexed from, uint256 value);
103 
104 	/**
105 	 * Constructor function
106 	 *
107 	 * Initializes contract with initial supply tokens to the creator of the contract
108 	 */
109 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
110 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
111 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
112 		name = tokenName;                                   // Set the name for display purposes
113 		symbol = tokenSymbol;                               // Set the symbol for display purposes
114 	}
115 
116 	/**
117 	 * Internal transfer, only can be called by this contract
118 	 */
119 	function _transfer(address _from, address _to, uint _value) internal {
120 		// Prevent transfer to 0x0 address. Use burn() instead
121 		require(_to != address(0));
122 		// Check if the sender has enough
123 		require(balanceOf[_from] >= _value);
124 		// Check for overflows
125 		require(balanceOf[_to] + _value > balanceOf[_to]);
126 		// Save this for an assertion in the future
127 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
128 		// Subtract from the sender
129 		balanceOf[_from] -= _value;
130 		// Add the same to the recipient
131 		balanceOf[_to] += _value;
132 		emit Transfer(_from, _to, _value);
133 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
134 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
135 	}
136 
137 	/**
138 	 * Transfer tokens
139 	 *
140 	 * Send `_value` tokens to `_to` from your account
141 	 *
142 	 * @param _to The address of the recipient
143 	 * @param _value the amount to send
144 	 */
145 	function transfer(address _to, uint256 _value) public returns (bool success) {
146 		_transfer(msg.sender, _to, _value);
147 		return true;
148 	}
149 
150 	/**
151 	 * Transfer tokens from other address
152 	 *
153 	 * Send `_value` tokens to `_to` in behalf of `_from`
154 	 *
155 	 * @param _from The address of the sender
156 	 * @param _to The address of the recipient
157 	 * @param _value the amount to send
158 	 */
159 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
160 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
161 		allowance[_from][msg.sender] -= _value;
162 		_transfer(_from, _to, _value);
163 		return true;
164 	}
165 
166 	/**
167 	 * Set allowance for other address
168 	 *
169 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
170 	 *
171 	 * @param _spender The address authorized to spend
172 	 * @param _value the max amount they can spend
173 	 */
174 	function approve(address _spender, uint256 _value) public returns (bool success) {
175 		allowance[msg.sender][_spender] = _value;
176 		emit Approval(msg.sender, _spender, _value);
177 		return true;
178 	}
179 
180 	/**
181 	 * Set allowance for other address and notify
182 	 *
183 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
184 	 *
185 	 * @param _spender The address authorized to spend
186 	 * @param _value the max amount they can spend
187 	 * @param _extraData some extra information to send to the approved contract
188 	 */
189 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
190 		tokenRecipient spender = tokenRecipient(_spender);
191 		if (approve(_spender, _value)) {
192 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
193 			return true;
194 		}
195 	}
196 
197 	/**
198 	 * Destroy tokens
199 	 *
200 	 * Remove `_value` tokens from the system irreversibly
201 	 *
202 	 * @param _value the amount of money to burn
203 	 */
204 	function burn(uint256 _value) public returns (bool success) {
205 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
206 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
207 		totalSupply -= _value;                      // Updates totalSupply
208 		emit Burn(msg.sender, _value);
209 		return true;
210 	}
211 
212 	/**
213 	 * Destroy tokens from other account
214 	 *
215 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
216 	 *
217 	 * @param _from the address of the sender
218 	 * @param _value the amount of money to burn
219 	 */
220 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
221 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
222 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
223 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
224 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
225 		totalSupply -= _value;                              // Update totalSupply
226 		emit Burn(_from, _value);
227 		return true;
228 	}
229 }
230 
231 
232 /**
233  * @title TAO
234  */
235 contract TAO {
236 	using SafeMath for uint256;
237 
238 	address public vaultAddress;
239 	string public name;				// the name for this TAO
240 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
241 
242 	// TAO's data
243 	string public datHash;
244 	string public database;
245 	string public keyValue;
246 	bytes32 public contentId;
247 
248 	/**
249 	 * 0 = TAO
250 	 * 1 = Name
251 	 */
252 	uint8 public typeId;
253 
254 	/**
255 	 * @dev Constructor function
256 	 */
257 	constructor (string memory _name,
258 		address _originId,
259 		string memory _datHash,
260 		string memory _database,
261 		string memory _keyValue,
262 		bytes32 _contentId,
263 		address _vaultAddress
264 	) public {
265 		name = _name;
266 		originId = _originId;
267 		datHash = _datHash;
268 		database = _database;
269 		keyValue = _keyValue;
270 		contentId = _contentId;
271 
272 		// Creating TAO
273 		typeId = 0;
274 
275 		vaultAddress = _vaultAddress;
276 	}
277 
278 	/**
279 	 * @dev Checks if calling address is Vault contract
280 	 */
281 	modifier onlyVault {
282 		require (msg.sender == vaultAddress);
283 		_;
284 	}
285 
286 	/**
287 	 * Will receive any ETH sent
288 	 */
289 	function () external payable {
290 	}
291 
292 	/**
293 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
294 	 * @param _recipient The recipient address
295 	 * @param _amount The amount to transfer
296 	 * @return true on success
297 	 */
298 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
299 		_recipient.transfer(_amount);
300 		return true;
301 	}
302 
303 	/**
304 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
305 	 * @param _erc20TokenAddress The address of ERC20 Token
306 	 * @param _recipient The recipient address
307 	 * @param _amount The amount to transfer
308 	 * @return true on success
309 	 */
310 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
311 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
312 		_erc20.transfer(_recipient, _amount);
313 		return true;
314 	}
315 }
316 
317 
318 
319 
320 /**
321  * @title Name
322  */
323 contract Name is TAO {
324 	/**
325 	 * @dev Constructor function
326 	 */
327 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
328 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
329 		// Creating Name
330 		typeId = 1;
331 	}
332 }
333 
334 
335 
336 
337 /**
338  * @title AOLibrary
339  */
340 library AOLibrary {
341 	using SafeMath for uint256;
342 
343 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
344 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
345 
346 	/**
347 	 * @dev Check whether or not the given TAO ID is a TAO
348 	 * @param _taoId The ID of the TAO
349 	 * @return true if yes. false otherwise
350 	 */
351 	function isTAO(address _taoId) public view returns (bool) {
352 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
353 	}
354 
355 	/**
356 	 * @dev Check whether or not the given Name ID is a Name
357 	 * @param _nameId The ID of the Name
358 	 * @return true if yes. false otherwise
359 	 */
360 	function isName(address _nameId) public view returns (bool) {
361 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
362 	}
363 
364 	/**
365 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
366 	 * @param _tokenAddress The ERC20 Token address to check
367 	 */
368 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
369 		if (_tokenAddress == address(0)) {
370 			return false;
371 		}
372 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
373 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
374 	}
375 
376 	/**
377 	 * @dev Checks if the calling contract address is The AO
378 	 *		OR
379 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
380 	 * @param _sender The address to check
381 	 * @param _theAO The AO address
382 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
383 	 * @return true if yes, false otherwise
384 	 */
385 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
386 		return (_sender == _theAO ||
387 			(
388 				(isTAO(_theAO) || isName(_theAO)) &&
389 				_nameTAOPositionAddress != address(0) &&
390 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
391 			)
392 		);
393 	}
394 
395 	/**
396 	 * @dev Return the divisor used to correctly calculate percentage.
397 	 *		Percentage stored throughout AO contracts covers 4 decimals,
398 	 *		so 1% is 10000, 1.25% is 12500, etc
399 	 */
400 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
401 		return _PERCENTAGE_DIVISOR;
402 	}
403 
404 	/**
405 	 * @dev Return the divisor used to correctly calculate multiplier.
406 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
407 	 *		so 1 is 1000000, 0.023 is 23000, etc
408 	 */
409 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
410 		return _MULTIPLIER_DIVISOR;
411 	}
412 
413 	/**
414 	 * @dev deploy a TAO
415 	 * @param _name The name of the TAO
416 	 * @param _originId The Name ID the creates the TAO
417 	 * @param _datHash The datHash of this TAO
418 	 * @param _database The database for this TAO
419 	 * @param _keyValue The key/value pair to be checked on the database
420 	 * @param _contentId The contentId related to this TAO
421 	 * @param _nameTAOVaultAddress The address of NameTAOVault
422 	 */
423 	function deployTAO(string memory _name,
424 		address _originId,
425 		string memory _datHash,
426 		string memory _database,
427 		string memory _keyValue,
428 		bytes32 _contentId,
429 		address _nameTAOVaultAddress
430 		) public returns (TAO _tao) {
431 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
432 	}
433 
434 	/**
435 	 * @dev deploy a Name
436 	 * @param _name The name of the Name
437 	 * @param _originId The eth address the creates the Name
438 	 * @param _datHash The datHash of this Name
439 	 * @param _database The database for this Name
440 	 * @param _keyValue The key/value pair to be checked on the database
441 	 * @param _contentId The contentId related to this Name
442 	 * @param _nameTAOVaultAddress The address of NameTAOVault
443 	 */
444 	function deployName(string memory _name,
445 		address _originId,
446 		string memory _datHash,
447 		string memory _database,
448 		string memory _keyValue,
449 		bytes32 _contentId,
450 		address _nameTAOVaultAddress
451 		) public returns (Name _myName) {
452 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
453 	}
454 
455 	/**
456 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
457 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
458 	 * @param _currentPrimordialBalance Account's current primordial ion balance
459 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
460 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
461 	 * @return the new primordial weighted multiplier
462 	 */
463 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
464 		if (_currentWeightedMultiplier > 0) {
465 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
466 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
467 			return _totalWeightedIons.div(_totalIons);
468 		} else {
469 			return _additionalWeightedMultiplier;
470 		}
471 	}
472 
473 	/**
474 	 * @dev Calculate the primordial ion multiplier on a given lot
475 	 *		Total Primordial Mintable = T
476 	 *		Total Primordial Minted = M
477 	 *		Starting Multiplier = S
478 	 *		Ending Multiplier = E
479 	 *		To Purchase = P
480 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
481 	 *
482 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
483 	 * @param _totalPrimordialMintable Total Primordial ion mintable
484 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
485 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
486 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
487 	 * @return The multiplier in (10 ** 6)
488 	 */
489 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
490 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
491 			/**
492 			 * Let temp = M + (P/2)
493 			 * Multiplier = (1 - (temp / T)) x (S-E)
494 			 */
495 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
496 
497 			/**
498 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
499 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
500 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
501 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
502 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
503 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
504 			 */
505 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
506 			/**
507 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
508 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
509 			 */
510 			return multiplier.div(_MULTIPLIER_DIVISOR);
511 		} else {
512 			return 0;
513 		}
514 	}
515 
516 	/**
517 	 * @dev Calculate the bonus percentage of network ion on a given lot
518 	 *		Total Primordial Mintable = T
519 	 *		Total Primordial Minted = M
520 	 *		Starting Network Bonus Multiplier = Bs
521 	 *		Ending Network Bonus Multiplier = Be
522 	 *		To Purchase = P
523 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
524 	 *
525 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
526 	 * @param _totalPrimordialMintable Total Primordial ion intable
527 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
528 	 * @param _startingMultiplier The starting Network ion bonus multiplier
529 	 * @param _endingMultiplier The ending Network ion bonus multiplier
530 	 * @return The bonus percentage
531 	 */
532 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
533 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
534 			/**
535 			 * Let temp = M + (P/2)
536 			 * B% = (1 - (temp / T)) x (Bs-Be)
537 			 */
538 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
539 
540 			/**
541 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
542 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
543 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
544 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
545 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
546 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
547 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
548 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
549 			 */
550 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
551 			return bonusPercentage;
552 		} else {
553 			return 0;
554 		}
555 	}
556 
557 	/**
558 	 * @dev Calculate the bonus amount of network ion on a given lot
559 	 *		AO Bonus Amount = B% x P
560 	 *
561 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
562 	 * @param _totalPrimordialMintable Total Primordial ion intable
563 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
564 	 * @param _startingMultiplier The starting Network ion bonus multiplier
565 	 * @param _endingMultiplier The ending Network ion bonus multiplier
566 	 * @return The bonus percentage
567 	 */
568 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
569 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
570 		/**
571 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
572 		 * when calculating the network ion bonus amount
573 		 */
574 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
575 		return networkBonus;
576 	}
577 
578 	/**
579 	 * @dev Calculate the maximum amount of Primordial an account can burn
580 	 *		_primordialBalance = P
581 	 *		_currentWeightedMultiplier = M
582 	 *		_maximumMultiplier = S
583 	 *		_amountToBurn = B
584 	 *		B = ((S x P) - (P x M)) / S
585 	 *
586 	 * @param _primordialBalance Account's primordial ion balance
587 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
588 	 * @param _maximumMultiplier The maximum multiplier of this account
589 	 * @return The maximum burn amount
590 	 */
591 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
592 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
593 	}
594 
595 	/**
596 	 * @dev Calculate the new multiplier after burning primordial ion
597 	 *		_primordialBalance = P
598 	 *		_currentWeightedMultiplier = M
599 	 *		_amountToBurn = B
600 	 *		_newMultiplier = E
601 	 *		E = (P x M) / (P - B)
602 	 *
603 	 * @param _primordialBalance Account's primordial ion balance
604 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
605 	 * @param _amountToBurn The amount of primordial ion to burn
606 	 * @return The new multiplier
607 	 */
608 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
609 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
610 	}
611 
612 	/**
613 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
614 	 *		_primordialBalance = P
615 	 *		_currentWeightedMultiplier = M
616 	 *		_amountToConvert = C
617 	 *		_newMultiplier = E
618 	 *		E = (P x M) / (P + C)
619 	 *
620 	 * @param _primordialBalance Account's primordial ion balance
621 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
622 	 * @param _amountToConvert The amount of network ion to convert
623 	 * @return The new multiplier
624 	 */
625 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
626 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
627 	}
628 
629 	/**
630 	 * @dev count num of digits
631 	 * @param number uint256 of the nuumber to be checked
632 	 * @return uint8 num of digits
633 	 */
634 	function numDigits(uint256 number) public pure returns (uint8) {
635 		uint8 digits = 0;
636 		while(number != 0) {
637 			number = number.div(10);
638 			digits++;
639 		}
640 		return digits;
641 	}
642 }
643 
644 
645 
646 contract TheAO {
647 	address public theAO;
648 	address public nameTAOPositionAddress;
649 
650 	// Check whether an address is whitelisted and granted access to transact
651 	// on behalf of others
652 	mapping (address => bool) public whitelist;
653 
654 	constructor() public {
655 		theAO = msg.sender;
656 	}
657 
658 	/**
659 	 * @dev Checks if msg.sender is in whitelist.
660 	 */
661 	modifier inWhitelist() {
662 		require (whitelist[msg.sender] == true);
663 		_;
664 	}
665 
666 	/**
667 	 * @dev Transfer ownership of The AO to new address
668 	 * @param _theAO The new address to be transferred
669 	 */
670 	function transferOwnership(address _theAO) public {
671 		require (msg.sender == theAO);
672 		require (_theAO != address(0));
673 		theAO = _theAO;
674 	}
675 
676 	/**
677 	 * @dev Whitelist `_account` address to transact on behalf of others
678 	 * @param _account The address to whitelist
679 	 * @param _whitelist Either to whitelist or not
680 	 */
681 	function setWhitelist(address _account, bool _whitelist) public {
682 		require (msg.sender == theAO);
683 		require (_account != address(0));
684 		whitelist[_account] = _whitelist;
685 	}
686 }
687 
688 
689 /**
690  * @title TAOCurrency
691  */
692 contract TAOCurrency is TheAO {
693 	using SafeMath for uint256;
694 
695 	// Public variables of the contract
696 	string public name;
697 	string public symbol;
698 	uint8 public decimals;
699 
700 	// To differentiate denomination of TAO Currency
701 	uint256 public powerOfTen;
702 
703 	uint256 public totalSupply;
704 
705 	// This creates an array with all balances
706 	// address is the address of nameId, not the eth public address
707 	mapping (address => uint256) public balanceOf;
708 
709 	// This generates a public event on the blockchain that will notify clients
710 	// address is the address of TAO/Name Id, not eth public address
711 	event Transfer(address indexed from, address indexed to, uint256 value);
712 
713 	// This notifies clients about the amount burnt
714 	// address is the address of TAO/Name Id, not eth public address
715 	event Burn(address indexed from, uint256 value);
716 
717 	/**
718 	 * Constructor function
719 	 *
720 	 * Initializes contract with initial supply TAOCurrency to the creator of the contract
721 	 */
722 	constructor (string memory _name, string memory _symbol, address _nameTAOPositionAddress) public {
723 		name = _name;		// Set the name for display purposes
724 		symbol = _symbol;	// Set the symbol for display purposes
725 
726 		powerOfTen = 0;
727 		decimals = 0;
728 
729 		setNameTAOPositionAddress(_nameTAOPositionAddress);
730 	}
731 
732 	/**
733 	 * @dev Checks if the calling contract address is The AO
734 	 *		OR
735 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
736 	 */
737 	modifier onlyTheAO {
738 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
739 		_;
740 	}
741 
742 	/**
743 	 * @dev Check if `_id` is a Name or a TAO
744 	 */
745 	modifier isNameOrTAO(address _id) {
746 		require (AOLibrary.isName(_id) || AOLibrary.isTAO(_id));
747 		_;
748 	}
749 
750 	/***** The AO ONLY METHODS *****/
751 	/**
752 	 * @dev Transfer ownership of The AO to new address
753 	 * @param _theAO The new address to be transferred
754 	 */
755 	function transferOwnership(address _theAO) public onlyTheAO {
756 		require (_theAO != address(0));
757 		theAO = _theAO;
758 	}
759 
760 	/**
761 	 * @dev Whitelist `_account` address to transact on behalf of others
762 	 * @param _account The address to whitelist
763 	 * @param _whitelist Either to whitelist or not
764 	 */
765 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
766 		require (_account != address(0));
767 		whitelist[_account] = _whitelist;
768 	}
769 
770 	/**
771 	 * @dev The AO set the NameTAOPosition Address
772 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
773 	 */
774 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
775 		require (_nameTAOPositionAddress != address(0));
776 		nameTAOPositionAddress = _nameTAOPositionAddress;
777 	}
778 
779 	/***** PUBLIC METHODS *****/
780 	/**
781 	 * @dev transfer TAOCurrency from other address
782 	 *
783 	 * Send `_value` TAOCurrency to `_to` in behalf of `_from`
784 	 *
785 	 * @param _from The address of the sender
786 	 * @param _to The address of the recipient
787 	 * @param _value the amount to send
788 	 */
789 	function transferFrom(address _from, address _to, uint256 _value) public inWhitelist isNameOrTAO(_from) isNameOrTAO(_to) returns (bool) {
790 		_transfer(_from, _to, _value);
791 		return true;
792 	}
793 
794 	/**
795 	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
796 	 * @param target Address to receive TAOCurrency
797 	 * @param mintedAmount The amount of TAOCurrency it will receive
798 	 * @return true on success
799 	 */
800 	function mint(address target, uint256 mintedAmount) public inWhitelist isNameOrTAO(target) returns (bool) {
801 		_mint(target, mintedAmount);
802 		return true;
803 	}
804 
805 	/**
806 	 *
807 	 * @dev Whitelisted address remove `_value` TAOCurrency from the system irreversibly on behalf of `_from`.
808 	 *
809 	 * @param _from the address of the sender
810 	 * @param _value the amount of money to burn
811 	 */
812 	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist isNameOrTAO(_from) returns (bool success) {
813 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
814 		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
815 		totalSupply = totalSupply.sub(_value);              // Update totalSupply
816 		emit Burn(_from, _value);
817 		return true;
818 	}
819 
820 	/***** INTERNAL METHODS *****/
821 	/**
822 	 * @dev Send `_value` TAOCurrency from `_from` to `_to`
823 	 * @param _from The address of sender
824 	 * @param _to The address of the recipient
825 	 * @param _value The amount to send
826 	 */
827 	function _transfer(address _from, address _to, uint256 _value) internal {
828 		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
829 		require (balanceOf[_from] >= _value);					// Check if the sender has enough
830 		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
831 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
832 		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
833 		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
834 		emit Transfer(_from, _to, _value);
835 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
836 	}
837 
838 	/**
839 	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
840 	 * @param target Address to receive TAOCurrency
841 	 * @param mintedAmount The amount of TAOCurrency it will receive
842 	 */
843 	function _mint(address target, uint256 mintedAmount) internal {
844 		balanceOf[target] = balanceOf[target].add(mintedAmount);
845 		totalSupply = totalSupply.add(mintedAmount);
846 		emit Transfer(address(0), address(this), mintedAmount);
847 		emit Transfer(address(this), target, mintedAmount);
848 	}
849 }
850 
851 
852 contract LogosExa is TAOCurrency {
853 	/**
854 	 * @dev Constructor function
855 	 */
856 	constructor(string memory _name, string memory _symbol, address _nameTAOPositionAddress)
857 		TAOCurrency(_name, _symbol, _nameTAOPositionAddress) public {
858 		powerOfTen = 18;
859 		decimals = 18;
860 	}
861 }