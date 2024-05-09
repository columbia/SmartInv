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
81 contract TokenERC20 {
82 	// Public variables of the token
83 	string public name;
84 	string public symbol;
85 	uint8 public decimals = 18;
86 	// 18 decimals is the strongly suggested default, avoid changing it
87 	uint256 public totalSupply;
88 
89 	// This creates an array with all balances
90 	mapping (address => uint256) public balanceOf;
91 	mapping (address => mapping (address => uint256)) public allowance;
92 
93 	// This generates a public event on the blockchain that will notify clients
94 	event Transfer(address indexed from, address indexed to, uint256 value);
95 
96 	// This generates a public event on the blockchain that will notify clients
97 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
98 
99 	// This notifies clients about the amount burnt
100 	event Burn(address indexed from, uint256 value);
101 
102 	/**
103 	 * Constructor function
104 	 *
105 	 * Initializes contract with initial supply tokens to the creator of the contract
106 	 */
107 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
108 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
109 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
110 		name = tokenName;                                   // Set the name for display purposes
111 		symbol = tokenSymbol;                               // Set the symbol for display purposes
112 	}
113 
114 	/**
115 	 * Internal transfer, only can be called by this contract
116 	 */
117 	function _transfer(address _from, address _to, uint _value) internal {
118 		// Prevent transfer to 0x0 address. Use burn() instead
119 		require(_to != address(0));
120 		// Check if the sender has enough
121 		require(balanceOf[_from] >= _value);
122 		// Check for overflows
123 		require(balanceOf[_to] + _value > balanceOf[_to]);
124 		// Save this for an assertion in the future
125 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
126 		// Subtract from the sender
127 		balanceOf[_from] -= _value;
128 		// Add the same to the recipient
129 		balanceOf[_to] += _value;
130 		emit Transfer(_from, _to, _value);
131 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
132 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
133 	}
134 
135 	/**
136 	 * Transfer tokens
137 	 *
138 	 * Send `_value` tokens to `_to` from your account
139 	 *
140 	 * @param _to The address of the recipient
141 	 * @param _value the amount to send
142 	 */
143 	function transfer(address _to, uint256 _value) public returns (bool success) {
144 		_transfer(msg.sender, _to, _value);
145 		return true;
146 	}
147 
148 	/**
149 	 * Transfer tokens from other address
150 	 *
151 	 * Send `_value` tokens to `_to` in behalf of `_from`
152 	 *
153 	 * @param _from The address of the sender
154 	 * @param _to The address of the recipient
155 	 * @param _value the amount to send
156 	 */
157 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
158 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
159 		allowance[_from][msg.sender] -= _value;
160 		_transfer(_from, _to, _value);
161 		return true;
162 	}
163 
164 	/**
165 	 * Set allowance for other address
166 	 *
167 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
168 	 *
169 	 * @param _spender The address authorized to spend
170 	 * @param _value the max amount they can spend
171 	 */
172 	function approve(address _spender, uint256 _value) public returns (bool success) {
173 		allowance[msg.sender][_spender] = _value;
174 		emit Approval(msg.sender, _spender, _value);
175 		return true;
176 	}
177 
178 	/**
179 	 * Set allowance for other address and notify
180 	 *
181 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
182 	 *
183 	 * @param _spender The address authorized to spend
184 	 * @param _value the max amount they can spend
185 	 * @param _extraData some extra information to send to the approved contract
186 	 */
187 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
188 		tokenRecipient spender = tokenRecipient(_spender);
189 		if (approve(_spender, _value)) {
190 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
191 			return true;
192 		}
193 	}
194 
195 	/**
196 	 * Destroy tokens
197 	 *
198 	 * Remove `_value` tokens from the system irreversibly
199 	 *
200 	 * @param _value the amount of money to burn
201 	 */
202 	function burn(uint256 _value) public returns (bool success) {
203 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
204 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
205 		totalSupply -= _value;                      // Updates totalSupply
206 		emit Burn(msg.sender, _value);
207 		return true;
208 	}
209 
210 	/**
211 	 * Destroy tokens from other account
212 	 *
213 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
214 	 *
215 	 * @param _from the address of the sender
216 	 * @param _value the amount of money to burn
217 	 */
218 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
219 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
220 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
221 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
222 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
223 		totalSupply -= _value;                              // Update totalSupply
224 		emit Burn(_from, _value);
225 		return true;
226 	}
227 }
228 
229 
230 /**
231  * @title TAO
232  */
233 contract TAO {
234 	using SafeMath for uint256;
235 
236 	address public vaultAddress;
237 	string public name;				// the name for this TAO
238 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
239 
240 	// TAO's data
241 	string public datHash;
242 	string public database;
243 	string public keyValue;
244 	bytes32 public contentId;
245 
246 	/**
247 	 * 0 = TAO
248 	 * 1 = Name
249 	 */
250 	uint8 public typeId;
251 
252 	/**
253 	 * @dev Constructor function
254 	 */
255 	constructor (string memory _name,
256 		address _originId,
257 		string memory _datHash,
258 		string memory _database,
259 		string memory _keyValue,
260 		bytes32 _contentId,
261 		address _vaultAddress
262 	) public {
263 		name = _name;
264 		originId = _originId;
265 		datHash = _datHash;
266 		database = _database;
267 		keyValue = _keyValue;
268 		contentId = _contentId;
269 
270 		// Creating TAO
271 		typeId = 0;
272 
273 		vaultAddress = _vaultAddress;
274 	}
275 
276 	/**
277 	 * @dev Checks if calling address is Vault contract
278 	 */
279 	modifier onlyVault {
280 		require (msg.sender == vaultAddress);
281 		_;
282 	}
283 
284 	/**
285 	 * Will receive any ETH sent
286 	 */
287 	function () external payable {
288 	}
289 
290 	/**
291 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
292 	 * @param _recipient The recipient address
293 	 * @param _amount The amount to transfer
294 	 * @return true on success
295 	 */
296 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
297 		_recipient.transfer(_amount);
298 		return true;
299 	}
300 
301 	/**
302 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
303 	 * @param _erc20TokenAddress The address of ERC20 Token
304 	 * @param _recipient The recipient address
305 	 * @param _amount The amount to transfer
306 	 * @return true on success
307 	 */
308 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
309 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
310 		_erc20.transfer(_recipient, _amount);
311 		return true;
312 	}
313 }
314 
315 
316 
317 
318 /**
319  * @title Name
320  */
321 contract Name is TAO {
322 	/**
323 	 * @dev Constructor function
324 	 */
325 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
326 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
327 		// Creating Name
328 		typeId = 1;
329 	}
330 }
331 
332 
333 
334 
335 /**
336  * @title AOLibrary
337  */
338 library AOLibrary {
339 	using SafeMath for uint256;
340 
341 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
342 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
343 
344 	/**
345 	 * @dev Check whether or not the given TAO ID is a TAO
346 	 * @param _taoId The ID of the TAO
347 	 * @return true if yes. false otherwise
348 	 */
349 	function isTAO(address _taoId) public view returns (bool) {
350 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
351 	}
352 
353 	/**
354 	 * @dev Check whether or not the given Name ID is a Name
355 	 * @param _nameId The ID of the Name
356 	 * @return true if yes. false otherwise
357 	 */
358 	function isName(address _nameId) public view returns (bool) {
359 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
360 	}
361 
362 	/**
363 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
364 	 * @param _tokenAddress The ERC20 Token address to check
365 	 */
366 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
367 		if (_tokenAddress == address(0)) {
368 			return false;
369 		}
370 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
371 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
372 	}
373 
374 	/**
375 	 * @dev Checks if the calling contract address is The AO
376 	 *		OR
377 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
378 	 * @param _sender The address to check
379 	 * @param _theAO The AO address
380 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
381 	 * @return true if yes, false otherwise
382 	 */
383 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
384 		return (_sender == _theAO ||
385 			(
386 				(isTAO(_theAO) || isName(_theAO)) &&
387 				_nameTAOPositionAddress != address(0) &&
388 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
389 			)
390 		);
391 	}
392 
393 	/**
394 	 * @dev Return the divisor used to correctly calculate percentage.
395 	 *		Percentage stored throughout AO contracts covers 4 decimals,
396 	 *		so 1% is 10000, 1.25% is 12500, etc
397 	 */
398 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
399 		return _PERCENTAGE_DIVISOR;
400 	}
401 
402 	/**
403 	 * @dev Return the divisor used to correctly calculate multiplier.
404 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
405 	 *		so 1 is 1000000, 0.023 is 23000, etc
406 	 */
407 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
408 		return _MULTIPLIER_DIVISOR;
409 	}
410 
411 	/**
412 	 * @dev deploy a TAO
413 	 * @param _name The name of the TAO
414 	 * @param _originId The Name ID the creates the TAO
415 	 * @param _datHash The datHash of this TAO
416 	 * @param _database The database for this TAO
417 	 * @param _keyValue The key/value pair to be checked on the database
418 	 * @param _contentId The contentId related to this TAO
419 	 * @param _nameTAOVaultAddress The address of NameTAOVault
420 	 */
421 	function deployTAO(string memory _name,
422 		address _originId,
423 		string memory _datHash,
424 		string memory _database,
425 		string memory _keyValue,
426 		bytes32 _contentId,
427 		address _nameTAOVaultAddress
428 		) public returns (TAO _tao) {
429 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
430 	}
431 
432 	/**
433 	 * @dev deploy a Name
434 	 * @param _name The name of the Name
435 	 * @param _originId The eth address the creates the Name
436 	 * @param _datHash The datHash of this Name
437 	 * @param _database The database for this Name
438 	 * @param _keyValue The key/value pair to be checked on the database
439 	 * @param _contentId The contentId related to this Name
440 	 * @param _nameTAOVaultAddress The address of NameTAOVault
441 	 */
442 	function deployName(string memory _name,
443 		address _originId,
444 		string memory _datHash,
445 		string memory _database,
446 		string memory _keyValue,
447 		bytes32 _contentId,
448 		address _nameTAOVaultAddress
449 		) public returns (Name _myName) {
450 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
451 	}
452 
453 	/**
454 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
455 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
456 	 * @param _currentPrimordialBalance Account's current primordial ion balance
457 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
458 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
459 	 * @return the new primordial weighted multiplier
460 	 */
461 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
462 		if (_currentWeightedMultiplier > 0) {
463 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
464 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
465 			return _totalWeightedIons.div(_totalIons);
466 		} else {
467 			return _additionalWeightedMultiplier;
468 		}
469 	}
470 
471 	/**
472 	 * @dev Calculate the primordial ion multiplier on a given lot
473 	 *		Total Primordial Mintable = T
474 	 *		Total Primordial Minted = M
475 	 *		Starting Multiplier = S
476 	 *		Ending Multiplier = E
477 	 *		To Purchase = P
478 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
479 	 *
480 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
481 	 * @param _totalPrimordialMintable Total Primordial ion mintable
482 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
483 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
484 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
485 	 * @return The multiplier in (10 ** 6)
486 	 */
487 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
488 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
489 			/**
490 			 * Let temp = M + (P/2)
491 			 * Multiplier = (1 - (temp / T)) x (S-E)
492 			 */
493 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
494 
495 			/**
496 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
497 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
498 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
499 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
500 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
501 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
502 			 */
503 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
504 			/**
505 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
506 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
507 			 */
508 			return multiplier.div(_MULTIPLIER_DIVISOR);
509 		} else {
510 			return 0;
511 		}
512 	}
513 
514 	/**
515 	 * @dev Calculate the bonus percentage of network ion on a given lot
516 	 *		Total Primordial Mintable = T
517 	 *		Total Primordial Minted = M
518 	 *		Starting Network Bonus Multiplier = Bs
519 	 *		Ending Network Bonus Multiplier = Be
520 	 *		To Purchase = P
521 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
522 	 *
523 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
524 	 * @param _totalPrimordialMintable Total Primordial ion intable
525 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
526 	 * @param _startingMultiplier The starting Network ion bonus multiplier
527 	 * @param _endingMultiplier The ending Network ion bonus multiplier
528 	 * @return The bonus percentage
529 	 */
530 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
531 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
532 			/**
533 			 * Let temp = M + (P/2)
534 			 * B% = (1 - (temp / T)) x (Bs-Be)
535 			 */
536 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
537 
538 			/**
539 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
540 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
541 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
542 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
543 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
544 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
545 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
546 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
547 			 */
548 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
549 			return bonusPercentage;
550 		} else {
551 			return 0;
552 		}
553 	}
554 
555 	/**
556 	 * @dev Calculate the bonus amount of network ion on a given lot
557 	 *		AO Bonus Amount = B% x P
558 	 *
559 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
560 	 * @param _totalPrimordialMintable Total Primordial ion intable
561 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
562 	 * @param _startingMultiplier The starting Network ion bonus multiplier
563 	 * @param _endingMultiplier The ending Network ion bonus multiplier
564 	 * @return The bonus percentage
565 	 */
566 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
567 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
568 		/**
569 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
570 		 * when calculating the network ion bonus amount
571 		 */
572 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
573 		return networkBonus;
574 	}
575 
576 	/**
577 	 * @dev Calculate the maximum amount of Primordial an account can burn
578 	 *		_primordialBalance = P
579 	 *		_currentWeightedMultiplier = M
580 	 *		_maximumMultiplier = S
581 	 *		_amountToBurn = B
582 	 *		B = ((S x P) - (P x M)) / S
583 	 *
584 	 * @param _primordialBalance Account's primordial ion balance
585 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
586 	 * @param _maximumMultiplier The maximum multiplier of this account
587 	 * @return The maximum burn amount
588 	 */
589 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
590 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
591 	}
592 
593 	/**
594 	 * @dev Calculate the new multiplier after burning primordial ion
595 	 *		_primordialBalance = P
596 	 *		_currentWeightedMultiplier = M
597 	 *		_amountToBurn = B
598 	 *		_newMultiplier = E
599 	 *		E = (P x M) / (P - B)
600 	 *
601 	 * @param _primordialBalance Account's primordial ion balance
602 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
603 	 * @param _amountToBurn The amount of primordial ion to burn
604 	 * @return The new multiplier
605 	 */
606 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
607 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
608 	}
609 
610 	/**
611 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
612 	 *		_primordialBalance = P
613 	 *		_currentWeightedMultiplier = M
614 	 *		_amountToConvert = C
615 	 *		_newMultiplier = E
616 	 *		E = (P x M) / (P + C)
617 	 *
618 	 * @param _primordialBalance Account's primordial ion balance
619 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
620 	 * @param _amountToConvert The amount of network ion to convert
621 	 * @return The new multiplier
622 	 */
623 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
624 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
625 	}
626 
627 	/**
628 	 * @dev count num of digits
629 	 * @param number uint256 of the nuumber to be checked
630 	 * @return uint8 num of digits
631 	 */
632 	function numDigits(uint256 number) public pure returns (uint8) {
633 		uint8 digits = 0;
634 		while(number != 0) {
635 			number = number.div(10);
636 			digits++;
637 		}
638 		return digits;
639 	}
640 }
641 
642 
643 
644 contract TheAO {
645 	address public theAO;
646 	address public nameTAOPositionAddress;
647 
648 	// Check whether an address is whitelisted and granted access to transact
649 	// on behalf of others
650 	mapping (address => bool) public whitelist;
651 
652 	constructor() public {
653 		theAO = msg.sender;
654 	}
655 
656 	/**
657 	 * @dev Checks if msg.sender is in whitelist.
658 	 */
659 	modifier inWhitelist() {
660 		require (whitelist[msg.sender] == true);
661 		_;
662 	}
663 
664 	/**
665 	 * @dev Transfer ownership of The AO to new address
666 	 * @param _theAO The new address to be transferred
667 	 */
668 	function transferOwnership(address _theAO) public {
669 		require (msg.sender == theAO);
670 		require (_theAO != address(0));
671 		theAO = _theAO;
672 	}
673 
674 	/**
675 	 * @dev Whitelist `_account` address to transact on behalf of others
676 	 * @param _account The address to whitelist
677 	 * @param _whitelist Either to whitelist or not
678 	 */
679 	function setWhitelist(address _account, bool _whitelist) public {
680 		require (msg.sender == theAO);
681 		require (_account != address(0));
682 		whitelist[_account] = _whitelist;
683 	}
684 }
685 
686 
687 /**
688  * @title Voice
689  */
690 contract Voice is TheAO {
691 	using SafeMath for uint256;
692 
693 	// Public variables of the contract
694 	string public name;
695 	string public symbol;
696 	uint8 public decimals = 4;
697 
698 	uint256 constant public MAX_SUPPLY_PER_NAME = 100 * (10 ** 4);
699 
700 	uint256 public totalSupply;
701 
702 	// Mapping from Name ID to bool value whether or not it has received Voice
703 	mapping (address => bool) public hasReceived;
704 
705 	// Mapping from Name/TAO ID to its total available balance
706 	mapping (address => uint256) public balanceOf;
707 
708 	// Mapping from Name ID to TAO ID and its staked amount
709 	mapping (address => mapping(address => uint256)) public taoStakedBalance;
710 
711 	// This generates a public event on the blockchain that will notify clients
712 	event Mint(address indexed nameId, uint256 value);
713 	event Stake(address indexed nameId, address indexed taoId, uint256 value);
714 	event Unstake(address indexed nameId, address indexed taoId, uint256 value);
715 
716 	/**
717 	 * Constructor function
718 	 */
719 	constructor (string memory _name, string memory _symbol) public {
720 		name = _name;						// Set the name for display purposes
721 		symbol = _symbol;					// Set the symbol for display purposes
722 	}
723 
724 	/**
725 	 * @dev Checks if the calling contract address is The AO
726 	 *		OR
727 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
728 	 */
729 	modifier onlyTheAO {
730 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
731 		_;
732 	}
733 
734 	/**
735 	 * @dev Check if `_taoId` is a TAO
736 	 */
737 	modifier isTAO(address _taoId) {
738 		require (AOLibrary.isTAO(_taoId));
739 		_;
740 	}
741 
742 	/**
743 	 * @dev Check if `_nameId` is a Name
744 	 */
745 	modifier isName(address _nameId) {
746 		require (AOLibrary.isName(_nameId));
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
781 	 * @dev Create `MAX_SUPPLY_PER_NAME` Voice and send it to `_nameId`
782 	 * @param _nameId Address to receive Voice
783 	 * @return true on success
784 	 */
785 	function mint(address _nameId) public inWhitelist isName(_nameId) returns (bool) {
786 		// Make sure _nameId has not received Voice
787 		require (hasReceived[_nameId] == false);
788 
789 		hasReceived[_nameId] = true;
790 		balanceOf[_nameId] = balanceOf[_nameId].add(MAX_SUPPLY_PER_NAME);
791 		totalSupply = totalSupply.add(MAX_SUPPLY_PER_NAME);
792 		emit Mint(_nameId, MAX_SUPPLY_PER_NAME);
793 		return true;
794 	}
795 
796 	/**
797 	 * @dev Get staked balance of `_nameId`
798 	 * @param _nameId The Name ID to be queried
799 	 * @return total staked balance
800 	 */
801 	function stakedBalance(address _nameId) public isName(_nameId) view returns (uint256) {
802 		return MAX_SUPPLY_PER_NAME.sub(balanceOf[_nameId]);
803 	}
804 
805 	/**
806 	 * @dev Stake `_value` Voice on `_taoId` from `_nameId`
807 	 * @param _nameId The Name ID that wants to stake
808 	 * @param _taoId The TAO ID to stake
809 	 * @param _value The amount to stake
810 	 * @return true on success
811 	 */
812 	function stake(address _nameId, address _taoId, uint256 _value) public inWhitelist isName(_nameId) isTAO(_taoId) returns (bool) {
813 		require (_value > 0 && _value <= MAX_SUPPLY_PER_NAME);
814 		require (balanceOf[_nameId] >= _value);							// Check if the targeted balance is enough
815 		balanceOf[_nameId] = balanceOf[_nameId].sub(_value);			// Subtract from the targeted balance
816 		taoStakedBalance[_nameId][_taoId] = taoStakedBalance[_nameId][_taoId].add(_value);	// Add to the targeted staked balance
817 		balanceOf[_taoId] = balanceOf[_taoId].add(_value);
818 		emit Stake(_nameId, _taoId, _value);
819 		return true;
820 	}
821 
822 	/**
823 	 * @dev Unstake `_value` Voice from `_nameId`'s `_taoId`
824 	 * @param _nameId The Name ID that wants to unstake
825 	 * @param _taoId The TAO ID to unstake
826 	 * @param _value The amount to unstake
827 	 * @return true on success
828 	 */
829 	function unstake(address _nameId, address _taoId, uint256 _value) public inWhitelist isName(_nameId) isTAO(_taoId) returns (bool) {
830 		require (_value > 0 && _value <= MAX_SUPPLY_PER_NAME);
831 		require (taoStakedBalance[_nameId][_taoId] >= _value);	// Check if the targeted staked balance is enough
832 		require (balanceOf[_taoId] >= _value);	// Check if the total targeted staked balance is enough
833 		taoStakedBalance[_nameId][_taoId] = taoStakedBalance[_nameId][_taoId].sub(_value);	// Subtract from the targeted staked balance
834 		balanceOf[_taoId] = balanceOf[_taoId].sub(_value);
835 		balanceOf[_nameId] = balanceOf[_nameId].add(_value);			// Add to the targeted balance
836 		emit Unstake(_nameId, _taoId, _value);
837 		return true;
838 	}
839 }