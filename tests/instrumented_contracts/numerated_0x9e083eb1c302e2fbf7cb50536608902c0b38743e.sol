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
70 interface IAOSettingAttribute {
71 	function add(uint256 _settingId, address _creatorNameId, string calldata _settingName, address _creatorTAOId, address _associatedTAOId, string calldata _extraData) external returns (bytes32, bytes32);
72 
73 	function getSettingData(uint256 _settingId) external view returns (uint256, address, address, address, string memory, bool, bool, bool, string memory);
74 
75 	function approveAdd(uint256 _settingId, address _associatedTAOAdvocate, bool _approved) external returns (bool);
76 
77 	function finalizeAdd(uint256 _settingId, address _creatorTAOAdvocate) external returns (bool);
78 
79 	function update(uint256 _settingId, address _associatedTAOAdvocate, address _proposalTAOId, string calldata _extraData) external returns (bool);
80 
81 	function getSettingState(uint256 _settingId) external view returns (uint256, bool, address, address, address, string memory);
82 
83 	function approveUpdate(uint256 _settingId, address _proposalTAOAdvocate, bool _approved) external returns (bool);
84 
85 	function finalizeUpdate(uint256 _settingId, address _associatedTAOAdvocate) external returns (bool);
86 
87 	function addDeprecation(uint256 _settingId, address _creatorNameId, address _creatorTAOId, address _associatedTAOId, uint256 _newSettingId, address _newSettingContractAddress) external returns (bytes32, bytes32);
88 
89 	function getSettingDeprecation(uint256 _settingId) external view returns (uint256, address, address, address, bool, bool, bool, bool, uint256, uint256, address, address);
90 
91 	function approveDeprecation(uint256 _settingId, address _associatedTAOAdvocate, bool _approved) external returns (bool);
92 
93 	function finalizeDeprecation(uint256 _settingId, address _creatorTAOAdvocate) external returns (bool);
94 
95 	function settingExist(uint256 _settingId) external view returns (bool);
96 
97 	function getLatestSettingId(uint256 _settingId) external view returns (uint256);
98 }
99 
100 
101 
102 
103 
104 
105 
106 
107 
108 
109 
110 
111 contract TokenERC20 {
112 	// Public variables of the token
113 	string public name;
114 	string public symbol;
115 	uint8 public decimals = 18;
116 	// 18 decimals is the strongly suggested default, avoid changing it
117 	uint256 public totalSupply;
118 
119 	// This creates an array with all balances
120 	mapping (address => uint256) public balanceOf;
121 	mapping (address => mapping (address => uint256)) public allowance;
122 
123 	// This generates a public event on the blockchain that will notify clients
124 	event Transfer(address indexed from, address indexed to, uint256 value);
125 
126 	// This generates a public event on the blockchain that will notify clients
127 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
128 
129 	// This notifies clients about the amount burnt
130 	event Burn(address indexed from, uint256 value);
131 
132 	/**
133 	 * Constructor function
134 	 *
135 	 * Initializes contract with initial supply tokens to the creator of the contract
136 	 */
137 	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
138 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
139 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
140 		name = tokenName;                                   // Set the name for display purposes
141 		symbol = tokenSymbol;                               // Set the symbol for display purposes
142 	}
143 
144 	/**
145 	 * Internal transfer, only can be called by this contract
146 	 */
147 	function _transfer(address _from, address _to, uint _value) internal {
148 		// Prevent transfer to 0x0 address. Use burn() instead
149 		require(_to != address(0));
150 		// Check if the sender has enough
151 		require(balanceOf[_from] >= _value);
152 		// Check for overflows
153 		require(balanceOf[_to] + _value > balanceOf[_to]);
154 		// Save this for an assertion in the future
155 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
156 		// Subtract from the sender
157 		balanceOf[_from] -= _value;
158 		// Add the same to the recipient
159 		balanceOf[_to] += _value;
160 		emit Transfer(_from, _to, _value);
161 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
162 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
163 	}
164 
165 	/**
166 	 * Transfer tokens
167 	 *
168 	 * Send `_value` tokens to `_to` from your account
169 	 *
170 	 * @param _to The address of the recipient
171 	 * @param _value the amount to send
172 	 */
173 	function transfer(address _to, uint256 _value) public returns (bool success) {
174 		_transfer(msg.sender, _to, _value);
175 		return true;
176 	}
177 
178 	/**
179 	 * Transfer tokens from other address
180 	 *
181 	 * Send `_value` tokens to `_to` in behalf of `_from`
182 	 *
183 	 * @param _from The address of the sender
184 	 * @param _to The address of the recipient
185 	 * @param _value the amount to send
186 	 */
187 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
188 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
189 		allowance[_from][msg.sender] -= _value;
190 		_transfer(_from, _to, _value);
191 		return true;
192 	}
193 
194 	/**
195 	 * Set allowance for other address
196 	 *
197 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
198 	 *
199 	 * @param _spender The address authorized to spend
200 	 * @param _value the max amount they can spend
201 	 */
202 	function approve(address _spender, uint256 _value) public returns (bool success) {
203 		allowance[msg.sender][_spender] = _value;
204 		emit Approval(msg.sender, _spender, _value);
205 		return true;
206 	}
207 
208 	/**
209 	 * Set allowance for other address and notify
210 	 *
211 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
212 	 *
213 	 * @param _spender The address authorized to spend
214 	 * @param _value the max amount they can spend
215 	 * @param _extraData some extra information to send to the approved contract
216 	 */
217 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
218 		tokenRecipient spender = tokenRecipient(_spender);
219 		if (approve(_spender, _value)) {
220 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
221 			return true;
222 		}
223 	}
224 
225 	/**
226 	 * Destroy tokens
227 	 *
228 	 * Remove `_value` tokens from the system irreversibly
229 	 *
230 	 * @param _value the amount of money to burn
231 	 */
232 	function burn(uint256 _value) public returns (bool success) {
233 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
234 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
235 		totalSupply -= _value;                      // Updates totalSupply
236 		emit Burn(msg.sender, _value);
237 		return true;
238 	}
239 
240 	/**
241 	 * Destroy tokens from other account
242 	 *
243 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
244 	 *
245 	 * @param _from the address of the sender
246 	 * @param _value the amount of money to burn
247 	 */
248 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
249 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
250 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
251 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
252 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
253 		totalSupply -= _value;                              // Update totalSupply
254 		emit Burn(_from, _value);
255 		return true;
256 	}
257 }
258 
259 
260 /**
261  * @title TAO
262  */
263 contract TAO {
264 	using SafeMath for uint256;
265 
266 	address public vaultAddress;
267 	string public name;				// the name for this TAO
268 	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address
269 
270 	// TAO's data
271 	string public datHash;
272 	string public database;
273 	string public keyValue;
274 	bytes32 public contentId;
275 
276 	/**
277 	 * 0 = TAO
278 	 * 1 = Name
279 	 */
280 	uint8 public typeId;
281 
282 	/**
283 	 * @dev Constructor function
284 	 */
285 	constructor (string memory _name,
286 		address _originId,
287 		string memory _datHash,
288 		string memory _database,
289 		string memory _keyValue,
290 		bytes32 _contentId,
291 		address _vaultAddress
292 	) public {
293 		name = _name;
294 		originId = _originId;
295 		datHash = _datHash;
296 		database = _database;
297 		keyValue = _keyValue;
298 		contentId = _contentId;
299 
300 		// Creating TAO
301 		typeId = 0;
302 
303 		vaultAddress = _vaultAddress;
304 	}
305 
306 	/**
307 	 * @dev Checks if calling address is Vault contract
308 	 */
309 	modifier onlyVault {
310 		require (msg.sender == vaultAddress);
311 		_;
312 	}
313 
314 	/**
315 	 * Will receive any ETH sent
316 	 */
317 	function () external payable {
318 	}
319 
320 	/**
321 	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
322 	 * @param _recipient The recipient address
323 	 * @param _amount The amount to transfer
324 	 * @return true on success
325 	 */
326 	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
327 		_recipient.transfer(_amount);
328 		return true;
329 	}
330 
331 	/**
332 	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
333 	 * @param _erc20TokenAddress The address of ERC20 Token
334 	 * @param _recipient The recipient address
335 	 * @param _amount The amount to transfer
336 	 * @return true on success
337 	 */
338 	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
339 		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
340 		_erc20.transfer(_recipient, _amount);
341 		return true;
342 	}
343 }
344 
345 
346 
347 
348 /**
349  * @title Name
350  */
351 contract Name is TAO {
352 	/**
353 	 * @dev Constructor function
354 	 */
355 	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
356 		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
357 		// Creating Name
358 		typeId = 1;
359 	}
360 }
361 
362 
363 
364 
365 /**
366  * @title AOLibrary
367  */
368 library AOLibrary {
369 	using SafeMath for uint256;
370 
371 	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
372 	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000
373 
374 	/**
375 	 * @dev Check whether or not the given TAO ID is a TAO
376 	 * @param _taoId The ID of the TAO
377 	 * @return true if yes. false otherwise
378 	 */
379 	function isTAO(address _taoId) public view returns (bool) {
380 		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
381 	}
382 
383 	/**
384 	 * @dev Check whether or not the given Name ID is a Name
385 	 * @param _nameId The ID of the Name
386 	 * @return true if yes. false otherwise
387 	 */
388 	function isName(address _nameId) public view returns (bool) {
389 		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
390 	}
391 
392 	/**
393 	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
394 	 * @param _tokenAddress The ERC20 Token address to check
395 	 */
396 	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
397 		if (_tokenAddress == address(0)) {
398 			return false;
399 		}
400 		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
401 		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
402 	}
403 
404 	/**
405 	 * @dev Checks if the calling contract address is The AO
406 	 *		OR
407 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
408 	 * @param _sender The address to check
409 	 * @param _theAO The AO address
410 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
411 	 * @return true if yes, false otherwise
412 	 */
413 	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
414 		return (_sender == _theAO ||
415 			(
416 				(isTAO(_theAO) || isName(_theAO)) &&
417 				_nameTAOPositionAddress != address(0) &&
418 				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
419 			)
420 		);
421 	}
422 
423 	/**
424 	 * @dev Return the divisor used to correctly calculate percentage.
425 	 *		Percentage stored throughout AO contracts covers 4 decimals,
426 	 *		so 1% is 10000, 1.25% is 12500, etc
427 	 */
428 	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
429 		return _PERCENTAGE_DIVISOR;
430 	}
431 
432 	/**
433 	 * @dev Return the divisor used to correctly calculate multiplier.
434 	 *		Multiplier stored throughout AO contracts covers 6 decimals,
435 	 *		so 1 is 1000000, 0.023 is 23000, etc
436 	 */
437 	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
438 		return _MULTIPLIER_DIVISOR;
439 	}
440 
441 	/**
442 	 * @dev deploy a TAO
443 	 * @param _name The name of the TAO
444 	 * @param _originId The Name ID the creates the TAO
445 	 * @param _datHash The datHash of this TAO
446 	 * @param _database The database for this TAO
447 	 * @param _keyValue The key/value pair to be checked on the database
448 	 * @param _contentId The contentId related to this TAO
449 	 * @param _nameTAOVaultAddress The address of NameTAOVault
450 	 */
451 	function deployTAO(string memory _name,
452 		address _originId,
453 		string memory _datHash,
454 		string memory _database,
455 		string memory _keyValue,
456 		bytes32 _contentId,
457 		address _nameTAOVaultAddress
458 		) public returns (TAO _tao) {
459 		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
460 	}
461 
462 	/**
463 	 * @dev deploy a Name
464 	 * @param _name The name of the Name
465 	 * @param _originId The eth address the creates the Name
466 	 * @param _datHash The datHash of this Name
467 	 * @param _database The database for this Name
468 	 * @param _keyValue The key/value pair to be checked on the database
469 	 * @param _contentId The contentId related to this Name
470 	 * @param _nameTAOVaultAddress The address of NameTAOVault
471 	 */
472 	function deployName(string memory _name,
473 		address _originId,
474 		string memory _datHash,
475 		string memory _database,
476 		string memory _keyValue,
477 		bytes32 _contentId,
478 		address _nameTAOVaultAddress
479 		) public returns (Name _myName) {
480 		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
481 	}
482 
483 	/**
484 	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
485 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
486 	 * @param _currentPrimordialBalance Account's current primordial ion balance
487 	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
488 	 * @param _additionalPrimordialAmount The primordial ion amount to be added
489 	 * @return the new primordial weighted multiplier
490 	 */
491 	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
492 		if (_currentWeightedMultiplier > 0) {
493 			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
494 			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
495 			return _totalWeightedIons.div(_totalIons);
496 		} else {
497 			return _additionalWeightedMultiplier;
498 		}
499 	}
500 
501 	/**
502 	 * @dev Calculate the primordial ion multiplier on a given lot
503 	 *		Total Primordial Mintable = T
504 	 *		Total Primordial Minted = M
505 	 *		Starting Multiplier = S
506 	 *		Ending Multiplier = E
507 	 *		To Purchase = P
508 	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
509 	 *
510 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
511 	 * @param _totalPrimordialMintable Total Primordial ion mintable
512 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
513 	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
514 	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
515 	 * @return The multiplier in (10 ** 6)
516 	 */
517 	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
518 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
519 			/**
520 			 * Let temp = M + (P/2)
521 			 * Multiplier = (1 - (temp / T)) x (S-E)
522 			 */
523 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
524 
525 			/**
526 			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
527 			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
528 			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
529 			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
530 			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
531 			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
532 			 */
533 			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
534 			/**
535 			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
536 			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
537 			 */
538 			return multiplier.div(_MULTIPLIER_DIVISOR);
539 		} else {
540 			return 0;
541 		}
542 	}
543 
544 	/**
545 	 * @dev Calculate the bonus percentage of network ion on a given lot
546 	 *		Total Primordial Mintable = T
547 	 *		Total Primordial Minted = M
548 	 *		Starting Network Bonus Multiplier = Bs
549 	 *		Ending Network Bonus Multiplier = Be
550 	 *		To Purchase = P
551 	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
552 	 *
553 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
554 	 * @param _totalPrimordialMintable Total Primordial ion intable
555 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
556 	 * @param _startingMultiplier The starting Network ion bonus multiplier
557 	 * @param _endingMultiplier The ending Network ion bonus multiplier
558 	 * @return The bonus percentage
559 	 */
560 	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
561 		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
562 			/**
563 			 * Let temp = M + (P/2)
564 			 * B% = (1 - (temp / T)) x (Bs-Be)
565 			 */
566 			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));
567 
568 			/**
569 			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
570 			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
571 			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
572 			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
573 			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
574 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
575 			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
576 			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
577 			 */
578 			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
579 			return bonusPercentage;
580 		} else {
581 			return 0;
582 		}
583 	}
584 
585 	/**
586 	 * @dev Calculate the bonus amount of network ion on a given lot
587 	 *		AO Bonus Amount = B% x P
588 	 *
589 	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
590 	 * @param _totalPrimordialMintable Total Primordial ion intable
591 	 * @param _totalPrimordialMinted Total Primordial ion minted so far
592 	 * @param _startingMultiplier The starting Network ion bonus multiplier
593 	 * @param _endingMultiplier The ending Network ion bonus multiplier
594 	 * @return The bonus percentage
595 	 */
596 	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
597 		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
598 		/**
599 		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
600 		 * when calculating the network ion bonus amount
601 		 */
602 		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
603 		return networkBonus;
604 	}
605 
606 	/**
607 	 * @dev Calculate the maximum amount of Primordial an account can burn
608 	 *		_primordialBalance = P
609 	 *		_currentWeightedMultiplier = M
610 	 *		_maximumMultiplier = S
611 	 *		_amountToBurn = B
612 	 *		B = ((S x P) - (P x M)) / S
613 	 *
614 	 * @param _primordialBalance Account's primordial ion balance
615 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
616 	 * @param _maximumMultiplier The maximum multiplier of this account
617 	 * @return The maximum burn amount
618 	 */
619 	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
620 		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
621 	}
622 
623 	/**
624 	 * @dev Calculate the new multiplier after burning primordial ion
625 	 *		_primordialBalance = P
626 	 *		_currentWeightedMultiplier = M
627 	 *		_amountToBurn = B
628 	 *		_newMultiplier = E
629 	 *		E = (P x M) / (P - B)
630 	 *
631 	 * @param _primordialBalance Account's primordial ion balance
632 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
633 	 * @param _amountToBurn The amount of primordial ion to burn
634 	 * @return The new multiplier
635 	 */
636 	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
637 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
638 	}
639 
640 	/**
641 	 * @dev Calculate the new multiplier after converting network ion to primordial ion
642 	 *		_primordialBalance = P
643 	 *		_currentWeightedMultiplier = M
644 	 *		_amountToConvert = C
645 	 *		_newMultiplier = E
646 	 *		E = (P x M) / (P + C)
647 	 *
648 	 * @param _primordialBalance Account's primordial ion balance
649 	 * @param _currentWeightedMultiplier Account's current weighted multiplier
650 	 * @param _amountToConvert The amount of network ion to convert
651 	 * @return The new multiplier
652 	 */
653 	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
654 		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
655 	}
656 
657 	/**
658 	 * @dev count num of digits
659 	 * @param number uint256 of the nuumber to be checked
660 	 * @return uint8 num of digits
661 	 */
662 	function numDigits(uint256 number) public pure returns (uint8) {
663 		uint8 digits = 0;
664 		while(number != 0) {
665 			number = number.div(10);
666 			digits++;
667 		}
668 		return digits;
669 	}
670 }
671 
672 
673 
674 contract TheAO {
675 	address public theAO;
676 	address public nameTAOPositionAddress;
677 
678 	// Check whether an address is whitelisted and granted access to transact
679 	// on behalf of others
680 	mapping (address => bool) public whitelist;
681 
682 	constructor() public {
683 		theAO = msg.sender;
684 	}
685 
686 	/**
687 	 * @dev Checks if msg.sender is in whitelist.
688 	 */
689 	modifier inWhitelist() {
690 		require (whitelist[msg.sender] == true);
691 		_;
692 	}
693 
694 	/**
695 	 * @dev Transfer ownership of The AO to new address
696 	 * @param _theAO The new address to be transferred
697 	 */
698 	function transferOwnership(address _theAO) public {
699 		require (msg.sender == theAO);
700 		require (_theAO != address(0));
701 		theAO = _theAO;
702 	}
703 
704 	/**
705 	 * @dev Whitelist `_account` address to transact on behalf of others
706 	 * @param _account The address to whitelist
707 	 * @param _whitelist Either to whitelist or not
708 	 */
709 	function setWhitelist(address _account, bool _whitelist) public {
710 		require (msg.sender == theAO);
711 		require (_account != address(0));
712 		whitelist[_account] = _whitelist;
713 	}
714 }
715 
716 
717 
718 
719 /**
720  * @title AOSettingAttribute
721  *
722  * This contract stores all AO setting data/state
723  */
724 contract AOSettingAttribute is TheAO, IAOSettingAttribute {
725 	INameTAOPosition internal _nameTAOPosition;
726 
727 	struct SettingData {
728 		uint256 settingId;				// Identifier of this setting
729 		address creatorNameId;			// The nameId that created the setting
730 		address creatorTAOId;		// The taoId that created the setting
731 		address associatedTAOId;	// The taoId that the setting affects
732 		string settingName;				// The human-readable name of the setting
733 		bool pendingCreate;				// State when associatedTAOId has not accepted setting
734 		bool locked;					// State when pending anything (cannot change if locked)
735 		bool rejected;					// State when associatedTAOId rejected this setting
736 		string settingDataJSON;			// Catch-all
737 	}
738 
739 	struct SettingState {
740 		uint256 settingId;				// Identifier of this setting
741 		bool pendingUpdate;				// State when setting is in process of being updated
742 		address updateAdvocateNameId;	// The nameId of the Advocate that performed the update
743 
744 		/**
745 		 * A child of the associatedTAOId with the update Logos.
746 		 * This tells the setting contract that there is a proposal TAO that is a Child TAO
747 		 * of the associated TAO, which will be responsible for deciding if the update to the
748 		 * setting is accepted or rejected.
749 		 */
750 		address proposalTAOId;
751 
752 		/**
753 		 * The proposalTAOId moves here when setting value changes successfully
754 		 */
755 		address lastUpdateTAOId;
756 
757 		string settingStateJSON;		// Catch-all
758 	}
759 
760 	struct SettingDeprecation {
761 		uint256 settingId;				// Identifier of this setting
762 		address creatorNameId;			// The nameId that created this deprecation
763 		address creatorTAOId;		// The taoId that created this deprecation
764 		address associatedTAOId;	// The taoId that the setting affects
765 		bool pendingDeprecated;			// State when associatedTAOId has not accepted setting
766 		bool locked;					// State when pending anything (cannot change if locked)
767 		bool rejected;					// State when associatedTAOId rejected this setting
768 		bool migrated;					// State when this setting is fully migrated
769 
770 		// holds the pending new settingId value when a deprecation is set
771 		uint256 pendingNewSettingId;
772 
773 		// holds the new settingId that has been approved by associatedTAOId
774 		uint256 newSettingId;
775 
776 		// holds the pending new contract address for this setting
777 		address pendingNewSettingContractAddress;
778 
779 		// holds the new contract address for this setting
780 		address newSettingContractAddress;
781 	}
782 
783 	struct AssociatedTAOSetting {
784 		bytes32 associatedTAOSettingId;		// Identifier
785 		address associatedTAOId;			// The TAO ID that the setting is associated to
786 		uint256 settingId;						// The Setting ID that is associated with the TAO ID
787 	}
788 
789 	struct CreatorTAOSetting {
790 		bytes32 creatorTAOSettingId;		// Identifier
791 		address creatorTAOId;				// The TAO ID that the setting was created from
792 		uint256 settingId;						// The Setting ID created from the TAO ID
793 	}
794 
795 	struct AssociatedTAOSettingDeprecation {
796 		bytes32 associatedTAOSettingDeprecationId;		// Identifier
797 		address associatedTAOId;						// The TAO ID that the setting is associated to
798 		uint256 settingId;									// The Setting ID that is associated with the TAO ID
799 	}
800 
801 	struct CreatorTAOSettingDeprecation {
802 		bytes32 creatorTAOSettingDeprecationId;			// Identifier
803 		address creatorTAOId;							// The TAO ID that the setting was created from
804 		uint256 settingId;									// The Setting ID created from the TAO ID
805 	}
806 
807 	// Mapping from settingId to it's data
808 	mapping (uint256 => SettingData) internal settingDatas;
809 
810 	// Mapping from settingId to it's state
811 	mapping (uint256 => SettingState) internal settingStates;
812 
813 	// Mapping from settingId to it's deprecation info
814 	mapping (uint256 => SettingDeprecation) internal settingDeprecations;
815 
816 	// Mapping from associatedTAOSettingId to AssociatedTAOSetting
817 	mapping (bytes32 => AssociatedTAOSetting) internal associatedTAOSettings;
818 
819 	// Mapping from creatorTAOSettingId to CreatorTAOSetting
820 	mapping (bytes32 => CreatorTAOSetting) internal creatorTAOSettings;
821 
822 	// Mapping from associatedTAOSettingDeprecationId to AssociatedTAOSettingDeprecation
823 	mapping (bytes32 => AssociatedTAOSettingDeprecation) internal associatedTAOSettingDeprecations;
824 
825 	// Mapping from creatorTAOSettingDeprecationId to CreatorTAOSettingDeprecation
826 	mapping (bytes32 => CreatorTAOSettingDeprecation) internal creatorTAOSettingDeprecations;
827 
828 	/**
829 	 * @dev Constructor function
830 	 */
831 	constructor(address _nameTAOPositionAddress) public {
832 		setNameTAOPositionAddress(_nameTAOPositionAddress);
833 	}
834 
835 	/**
836 	 * @dev Checks if the calling contract address is The AO
837 	 *		OR
838 	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
839 	 */
840 	modifier onlyTheAO {
841 		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
842 		_;
843 	}
844 
845 	/***** The AO ONLY METHODS *****/
846 	/**
847 	 * @dev Transfer ownership of The AO to new address
848 	 * @param _theAO The new address to be transferred
849 	 */
850 	function transferOwnership(address _theAO) public onlyTheAO {
851 		require (_theAO != address(0));
852 		theAO = _theAO;
853 	}
854 
855 	/**
856 	 * @dev Whitelist `_account` address to transact on behalf of others
857 	 * @param _account The address to whitelist
858 	 * @param _whitelist Either to whitelist or not
859 	 */
860 	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
861 		require (_account != address(0));
862 		whitelist[_account] = _whitelist;
863 	}
864 
865 	/**
866 	 * @dev The AO sets NameTAOPosition address
867 	 * @param _nameTAOPositionAddress The address of NameTAOPosition
868 	 */
869 	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
870 		require (_nameTAOPositionAddress != address(0));
871 		nameTAOPositionAddress = _nameTAOPositionAddress;
872 		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
873 	}
874 
875 	/***** PUBLIC METHODS *****/
876 	/**
877 	 * @dev Add setting data/state
878 	 * @param _settingId The ID of the setting
879 	 * @param _creatorNameId The nameId that created the setting
880 	 * @param _settingName The human-readable name of the setting
881 	 * @param _creatorTAOId The taoId that created the setting
882 	 * @param _associatedTAOId The taoId that the setting affects
883 	 * @param _extraData Catch-all string value to be stored if exist
884 	 * @return The ID of the "Associated" setting
885 	 * @return The ID of the "Creator" setting
886 	 */
887 	function add(uint256 _settingId, address _creatorNameId, string calldata _settingName, address _creatorTAOId, address _associatedTAOId, string calldata _extraData) external inWhitelist returns (bytes32, bytes32) {
888 		// Store setting data/state
889 		require (_storeSettingDataState(_settingId, _creatorNameId, _settingName, _creatorTAOId, _associatedTAOId, _extraData));
890 
891 		// Store the associatedTAOSetting/creatorTAOSetting info
892 		return (
893 			_storeAssociatedTAOSetting(_associatedTAOId, _settingId),
894 			_storeCreatorTAOSetting(_creatorTAOId, _settingId)
895 		);
896 	}
897 
898 	/**
899 	 * @dev Get Setting Data of a setting ID
900 	 * @param _settingId The ID of the setting
901 	 */
902 	function getSettingData(uint256 _settingId) external view returns (uint256, address, address, address, string memory, bool, bool, bool, string memory) {
903 		SettingData memory _settingData = settingDatas[_settingId];
904 		return (
905 			_settingData.settingId,
906 			_settingData.creatorNameId,
907 			_settingData.creatorTAOId,
908 			_settingData.associatedTAOId,
909 			_settingData.settingName,
910 			_settingData.pendingCreate,
911 			_settingData.locked,
912 			_settingData.rejected,
913 			_settingData.settingDataJSON
914 		);
915 	}
916 
917 	/**
918 	 * @dev Get Associated TAO Setting info
919 	 * @param _associatedTAOSettingId The ID of the associated tao setting
920 	 */
921 	function getAssociatedTAOSetting(bytes32 _associatedTAOSettingId) public view returns (bytes32, address, uint256) {
922 		AssociatedTAOSetting memory _associatedTAOSetting = associatedTAOSettings[_associatedTAOSettingId];
923 		return (
924 			_associatedTAOSetting.associatedTAOSettingId,
925 			_associatedTAOSetting.associatedTAOId,
926 			_associatedTAOSetting.settingId
927 		);
928 	}
929 
930 	/**
931 	 * @dev Get Creator TAO Setting info
932 	 * @param _creatorTAOSettingId The ID of the creator tao setting
933 	 */
934 	function getCreatorTAOSetting(bytes32 _creatorTAOSettingId) public view returns (bytes32, address, uint256) {
935 		CreatorTAOSetting memory _creatorTAOSetting = creatorTAOSettings[_creatorTAOSettingId];
936 		return (
937 			_creatorTAOSetting.creatorTAOSettingId,
938 			_creatorTAOSetting.creatorTAOId,
939 			_creatorTAOSetting.settingId
940 		);
941 	}
942 
943 	/**
944 	 * @dev Advocate of Setting's _associatedTAOId approves setting creation
945 	 * @param _settingId The ID of the setting to approve
946 	 * @param _associatedTAOAdvocate The advocate of the associated TAO
947 	 * @param _approved Whether to approve or reject
948 	 * @return true on success
949 	 */
950 	function approveAdd(uint256 _settingId, address _associatedTAOAdvocate, bool _approved) external inWhitelist returns (bool) {
951 		// Make sure setting exists and needs approval
952 		SettingData storage _settingData = settingDatas[_settingId];
953 		require (_settingData.settingId == _settingId &&
954 			_settingData.pendingCreate == true &&
955 			_settingData.locked == true &&
956 			_settingData.rejected == false &&
957 			_associatedTAOAdvocate != address(0) &&
958 			_associatedTAOAdvocate == _nameTAOPosition.getAdvocate(_settingData.associatedTAOId)
959 		);
960 
961 		if (_approved) {
962 			// Unlock the setting so that advocate of creatorTAOId can finalize the creation
963 			_settingData.locked = false;
964 		} else {
965 			// Reject the setting
966 			_settingData.pendingCreate = false;
967 			_settingData.rejected = true;
968 		}
969 
970 		return true;
971 	}
972 
973 	/**
974 	 * @dev Advocate of Setting's _creatorTAOId finalizes the setting creation once the setting is approved
975 	 * @param _settingId The ID of the setting to be finalized
976 	 * @param _creatorTAOAdvocate The advocate of the creator TAO
977 	 * @return true on success
978 	 */
979 	function finalizeAdd(uint256 _settingId, address _creatorTAOAdvocate) external inWhitelist returns (bool) {
980 		// Make sure setting exists and needs approval
981 		SettingData storage _settingData = settingDatas[_settingId];
982 		require (_settingData.settingId == _settingId &&
983 			_settingData.pendingCreate == true &&
984 			_settingData.locked == false &&
985 			_settingData.rejected == false &&
986 			_creatorTAOAdvocate != address(0) &&
987 			_creatorTAOAdvocate == _nameTAOPosition.getAdvocate(_settingData.creatorTAOId)
988 		);
989 
990 		// Update the setting data
991 		_settingData.pendingCreate = false;
992 		_settingData.locked = true;
993 
994 		return true;
995 	}
996 
997 	/**
998 	 * @dev Store setting update data
999 	 * @param _settingId The ID of the setting to be updated
1000 	 * @param _associatedTAOAdvocate The setting's associatedTAOId's advocate's name address
1001 	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
1002 	 * @param _extraData Catch-all string value to be stored if exist
1003 	 * @return true on success
1004 	 */
1005 	function update(uint256 _settingId, address _associatedTAOAdvocate, address _proposalTAOId, string calldata _extraData) external inWhitelist returns (bool) {
1006 		// Make sure setting is created
1007 		SettingData memory _settingData = settingDatas[_settingId];
1008 		require (_settingData.settingId == _settingId &&
1009 			_settingData.pendingCreate == false &&
1010 			_settingData.locked == true &&
1011 			_settingData.rejected == false &&
1012 			_associatedTAOAdvocate != address(0) &&
1013 			_associatedTAOAdvocate == _nameTAOPosition.getAdvocate(_settingData.associatedTAOId)
1014 		);
1015 
1016 		// Make sure setting is not in the middle of updating
1017 		SettingState storage _settingState = settingStates[_settingId];
1018 		require (_settingState.pendingUpdate == false);
1019 
1020 		// Make sure setting is not yet deprecated
1021 		SettingDeprecation memory _settingDeprecation = settingDeprecations[_settingId];
1022 		if (_settingDeprecation.settingId == _settingId) {
1023 			require (_settingDeprecation.migrated == false);
1024 		}
1025 
1026 		// Store the SettingState data
1027 		_settingState.pendingUpdate = true;
1028 		_settingState.updateAdvocateNameId = _associatedTAOAdvocate;
1029 		_settingState.proposalTAOId = _proposalTAOId;
1030 		_settingState.settingStateJSON = _extraData;
1031 
1032 		return true;
1033 	}
1034 
1035 	/**
1036 	 * @dev Get setting state
1037 	 * @param _settingId The ID of the setting
1038 	 */
1039 	function getSettingState(uint256 _settingId) external view returns (uint256, bool, address, address, address, string memory) {
1040 		SettingState memory _settingState = settingStates[_settingId];
1041 		return (
1042 			_settingState.settingId,
1043 			_settingState.pendingUpdate,
1044 			_settingState.updateAdvocateNameId,
1045 			_settingState.proposalTAOId,
1046 			_settingState.lastUpdateTAOId,
1047 			_settingState.settingStateJSON
1048 		);
1049 	}
1050 
1051 	/**
1052 	 * @dev Advocate of Setting's proposalTAOId approves the setting update
1053 	 * @param _settingId The ID of the setting to be approved
1054 	 * @param _proposalTAOAdvocate The advocate of the proposal TAO
1055 	 * @param _approved Whether to approve or reject
1056 	 * @return true on success
1057 	 */
1058 	function approveUpdate(uint256 _settingId, address _proposalTAOAdvocate, bool _approved) external inWhitelist returns (bool) {
1059 		// Make sure setting is created
1060 		SettingData storage _settingData = settingDatas[_settingId];
1061 		require (_settingData.settingId == _settingId && _settingData.pendingCreate == false && _settingData.locked == true && _settingData.rejected == false);
1062 
1063 		// Make sure setting update exists and needs approval
1064 		SettingState storage _settingState = settingStates[_settingId];
1065 		require (_settingState.settingId == _settingId &&
1066 			_settingState.pendingUpdate == true &&
1067 			_proposalTAOAdvocate != address(0) &&
1068 			_proposalTAOAdvocate == _nameTAOPosition.getAdvocate(_settingState.proposalTAOId)
1069 		);
1070 
1071 		if (_approved) {
1072 			// Unlock the setting so that advocate of associatedTAOId can finalize the update
1073 			_settingData.locked = false;
1074 		} else {
1075 			// Set pendingUpdate to false
1076 			_settingState.pendingUpdate = false;
1077 			_settingState.proposalTAOId = address(0);
1078 		}
1079 		return true;
1080 	}
1081 
1082 	/**
1083 	 * @dev Advocate of Setting's _associatedTAOId finalizes the setting update once the setting is approved
1084 	 * @param _settingId The ID of the setting to be finalized
1085 	 * @param _associatedTAOAdvocate The advocate of the associated TAO
1086 	 * @return true on success
1087 	 */
1088 	function finalizeUpdate(uint256 _settingId, address _associatedTAOAdvocate) external inWhitelist returns (bool) {
1089 		// Make sure setting is created
1090 		SettingData storage _settingData = settingDatas[_settingId];
1091 		require (_settingData.settingId == _settingId &&
1092 			_settingData.pendingCreate == false &&
1093 			_settingData.locked == false &&
1094 			_settingData.rejected == false &&
1095 			_associatedTAOAdvocate != address(0) &&
1096 			_associatedTAOAdvocate == _nameTAOPosition.getAdvocate(_settingData.associatedTAOId)
1097 		);
1098 
1099 		// Make sure setting update exists and needs approval
1100 		SettingState storage _settingState = settingStates[_settingId];
1101 		require (_settingState.settingId == _settingId && _settingState.pendingUpdate == true && _settingState.proposalTAOId != address(0));
1102 
1103 		// Update the setting data
1104 		_settingData.locked = true;
1105 
1106 		// Update the setting state
1107 		_settingState.pendingUpdate = false;
1108 		_settingState.updateAdvocateNameId = _associatedTAOAdvocate;
1109 		address _proposalTAOId = _settingState.proposalTAOId;
1110 		_settingState.proposalTAOId = address(0);
1111 		_settingState.lastUpdateTAOId = _proposalTAOId;
1112 
1113 		return true;
1114 	}
1115 
1116 	/**
1117 	 * @dev Add setting deprecation
1118 	 * @param _settingId The ID of the setting
1119 	 * @param _creatorNameId The nameId that created the setting
1120 	 * @param _creatorTAOId The taoId that created the setting
1121 	 * @param _associatedTAOId The taoId that the setting affects
1122 	 * @param _newSettingId The new settingId value to route
1123 	 * @param _newSettingContractAddress The address of the new setting contract to route
1124 	 * @return The ID of the "Associated" setting deprecation
1125 	 * @return The ID of the "Creator" setting deprecation
1126 	 */
1127 	function addDeprecation(uint256 _settingId, address _creatorNameId, address _creatorTAOId, address _associatedTAOId, uint256 _newSettingId, address _newSettingContractAddress) external inWhitelist returns (bytes32, bytes32) {
1128 		require (_storeSettingDeprecation(_settingId, _creatorNameId, _creatorTAOId, _associatedTAOId, _newSettingId, _newSettingContractAddress));
1129 
1130 		// Store the associatedTAOSettingDeprecation info
1131 		bytes32 _associatedTAOSettingDeprecationId = keccak256(abi.encodePacked(this, _associatedTAOId, _settingId));
1132 		AssociatedTAOSettingDeprecation storage _associatedTAOSettingDeprecation = associatedTAOSettingDeprecations[_associatedTAOSettingDeprecationId];
1133 		_associatedTAOSettingDeprecation.associatedTAOSettingDeprecationId = _associatedTAOSettingDeprecationId;
1134 		_associatedTAOSettingDeprecation.associatedTAOId = _associatedTAOId;
1135 		_associatedTAOSettingDeprecation.settingId = _settingId;
1136 
1137 		// Store the creatorTAOSettingDeprecation info
1138 		bytes32 _creatorTAOSettingDeprecationId = keccak256(abi.encodePacked(this, _creatorTAOId, _settingId));
1139 		CreatorTAOSettingDeprecation storage _creatorTAOSettingDeprecation = creatorTAOSettingDeprecations[_creatorTAOSettingDeprecationId];
1140 		_creatorTAOSettingDeprecation.creatorTAOSettingDeprecationId = _creatorTAOSettingDeprecationId;
1141 		_creatorTAOSettingDeprecation.creatorTAOId = _creatorTAOId;
1142 		_creatorTAOSettingDeprecation.settingId = _settingId;
1143 
1144 		return (_associatedTAOSettingDeprecationId, _creatorTAOSettingDeprecationId);
1145 	}
1146 
1147 	/**
1148 	 * @dev Get Setting Deprecation info of a setting ID
1149 	 * @param _settingId The ID of the setting
1150 	 */
1151 	function getSettingDeprecation(uint256 _settingId) external view returns (uint256, address, address, address, bool, bool, bool, bool, uint256, uint256, address, address) {
1152 		SettingDeprecation memory _settingDeprecation = settingDeprecations[_settingId];
1153 		return (
1154 			_settingDeprecation.settingId,
1155 			_settingDeprecation.creatorNameId,
1156 			_settingDeprecation.creatorTAOId,
1157 			_settingDeprecation.associatedTAOId,
1158 			_settingDeprecation.pendingDeprecated,
1159 			_settingDeprecation.locked,
1160 			_settingDeprecation.rejected,
1161 			_settingDeprecation.migrated,
1162 			_settingDeprecation.pendingNewSettingId,
1163 			_settingDeprecation.newSettingId,
1164 			_settingDeprecation.pendingNewSettingContractAddress,
1165 			_settingDeprecation.newSettingContractAddress
1166 		);
1167 	}
1168 
1169 	/**
1170 	 * @dev Get Associated TAO Setting Deprecation info
1171 	 * @param _associatedTAOSettingDeprecationId The ID of the associated tao setting deprecation
1172 	 */
1173 	function getAssociatedTAOSettingDeprecation(bytes32 _associatedTAOSettingDeprecationId) external view returns (bytes32, address, uint256) {
1174 		AssociatedTAOSettingDeprecation memory _associatedTAOSettingDeprecation = associatedTAOSettingDeprecations[_associatedTAOSettingDeprecationId];
1175 		return (
1176 			_associatedTAOSettingDeprecation.associatedTAOSettingDeprecationId,
1177 			_associatedTAOSettingDeprecation.associatedTAOId,
1178 			_associatedTAOSettingDeprecation.settingId
1179 		);
1180 	}
1181 
1182 	/**
1183 	 * @dev Get Creator TAO Setting Deprecation info
1184 	 * @param _creatorTAOSettingDeprecationId The ID of the creator tao setting deprecation
1185 	 */
1186 	function getCreatorTAOSettingDeprecation(bytes32 _creatorTAOSettingDeprecationId) public view returns (bytes32, address, uint256) {
1187 		CreatorTAOSettingDeprecation memory _creatorTAOSettingDeprecation = creatorTAOSettingDeprecations[_creatorTAOSettingDeprecationId];
1188 		return (
1189 			_creatorTAOSettingDeprecation.creatorTAOSettingDeprecationId,
1190 			_creatorTAOSettingDeprecation.creatorTAOId,
1191 			_creatorTAOSettingDeprecation.settingId
1192 		);
1193 	}
1194 
1195 	/**
1196 	 * @dev Advocate of SettingDeprecation's _associatedTAOId approves deprecation
1197 	 * @param _settingId The ID of the setting to approve
1198 	 * @param _associatedTAOAdvocate The advocate of the associated TAO
1199 	 * @param _approved Whether to approve or reject
1200 	 * @return true on success
1201 	 */
1202 	function approveDeprecation(uint256 _settingId, address _associatedTAOAdvocate, bool _approved) external inWhitelist returns (bool) {
1203 		// Make sure setting exists and needs approval
1204 		SettingDeprecation storage _settingDeprecation = settingDeprecations[_settingId];
1205 		require (_settingDeprecation.settingId == _settingId &&
1206 			_settingDeprecation.migrated == false &&
1207 			_settingDeprecation.pendingDeprecated == true &&
1208 			_settingDeprecation.locked == true &&
1209 			_settingDeprecation.rejected == false &&
1210 			_associatedTAOAdvocate != address(0) &&
1211 			_associatedTAOAdvocate == _nameTAOPosition.getAdvocate(_settingDeprecation.associatedTAOId)
1212 		);
1213 
1214 		if (_approved) {
1215 			// Unlock the setting so that advocate of creatorTAOId can finalize the creation
1216 			_settingDeprecation.locked = false;
1217 		} else {
1218 			// Reject the setting
1219 			_settingDeprecation.pendingDeprecated = false;
1220 			_settingDeprecation.rejected = true;
1221 		}
1222 		return true;
1223 	}
1224 
1225 	/**
1226 	 * @dev Advocate of SettingDeprecation's _creatorTAOId finalizes the deprecation once the setting deprecation is approved
1227 	 * @param _settingId The ID of the setting to be finalized
1228 	 * @param _creatorTAOAdvocate The advocate of the creator TAO
1229 	 * @return true on success
1230 	 */
1231 	function finalizeDeprecation(uint256 _settingId, address _creatorTAOAdvocate) external inWhitelist returns (bool) {
1232 		// Make sure setting exists and needs approval
1233 		SettingDeprecation storage _settingDeprecation = settingDeprecations[_settingId];
1234 		require (_settingDeprecation.settingId == _settingId &&
1235 			_settingDeprecation.migrated == false &&
1236 			_settingDeprecation.pendingDeprecated == true &&
1237 			_settingDeprecation.locked == false &&
1238 			_settingDeprecation.rejected == false &&
1239 			_creatorTAOAdvocate != address(0) &&
1240 			_creatorTAOAdvocate == _nameTAOPosition.getAdvocate(_settingDeprecation.creatorTAOId)
1241 		);
1242 
1243 		// Update the setting data
1244 		_settingDeprecation.pendingDeprecated = false;
1245 		_settingDeprecation.locked = true;
1246 		_settingDeprecation.migrated = true;
1247 		uint256 _newSettingId = _settingDeprecation.pendingNewSettingId;
1248 		_settingDeprecation.pendingNewSettingId = 0;
1249 		_settingDeprecation.newSettingId = _newSettingId;
1250 
1251 		address _newSettingContractAddress = _settingDeprecation.pendingNewSettingContractAddress;
1252 		_settingDeprecation.pendingNewSettingContractAddress = address(0);
1253 		_settingDeprecation.newSettingContractAddress = _newSettingContractAddress;
1254 		return true;
1255 	}
1256 
1257 	/**
1258 	 * @dev Check if a setting exist and not rejected
1259 	 * @param _settingId The ID of the setting
1260 	 * @return true if exist. false otherwise
1261 	 */
1262 	function settingExist(uint256 _settingId) external view returns (bool) {
1263 		SettingData memory _settingData = settingDatas[_settingId];
1264 		return (_settingData.settingId == _settingId && _settingData.rejected == false);
1265 	}
1266 
1267 	/**
1268 	 * @dev Get the latest ID of a deprecated setting, if exist
1269 	 * @param _settingId The ID of the setting
1270 	 * @return The latest setting ID
1271 	 */
1272 	function getLatestSettingId(uint256 _settingId) external view returns (uint256) {
1273 		uint256 _latestSettingId = _settingId;
1274 		(,,,,,,, bool _migrated,, uint256 _newSettingId,,) = this.getSettingDeprecation(_latestSettingId);
1275 		while (_migrated && _newSettingId > 0) {
1276 			_latestSettingId = _newSettingId;
1277 			(,,,,,,, _migrated,, _newSettingId,,) = this.getSettingDeprecation(_latestSettingId);
1278 		}
1279 		return _latestSettingId;
1280 	}
1281 
1282 	/***** Internal Method *****/
1283 	/**
1284 	 * @dev Store setting data/state
1285 	 * @param _settingId The ID of the setting
1286 	 * @param _creatorNameId The nameId that created the setting
1287 	 * @param _settingName The human-readable name of the setting
1288 	 * @param _creatorTAOId The taoId that created the setting
1289 	 * @param _associatedTAOId The taoId that the setting affects
1290 	 * @param _extraData Catch-all string value to be stored if exist
1291 	 * @return true on success
1292 	 */
1293 	function _storeSettingDataState(uint256 _settingId, address _creatorNameId, string memory _settingName, address _creatorTAOId, address _associatedTAOId, string memory _extraData) internal returns (bool) {
1294 		// Store setting data
1295 		SettingData storage _settingData = settingDatas[_settingId];
1296 		_settingData.settingId = _settingId;
1297 		_settingData.creatorNameId = _creatorNameId;
1298 		_settingData.creatorTAOId = _creatorTAOId;
1299 		_settingData.associatedTAOId = _associatedTAOId;
1300 		_settingData.settingName = _settingName;
1301 		_settingData.pendingCreate = true;
1302 		_settingData.locked = true;
1303 		_settingData.settingDataJSON = _extraData;
1304 
1305 		// Store setting state
1306 		SettingState storage _settingState = settingStates[_settingId];
1307 		_settingState.settingId = _settingId;
1308 		return true;
1309 	}
1310 
1311 	/**
1312 	 * @dev Store setting deprecation
1313 	 * @param _settingId The ID of the setting
1314 	 * @param _creatorNameId The nameId that created the setting
1315 	 * @param _creatorTAOId The taoId that created the setting
1316 	 * @param _associatedTAOId The taoId that the setting affects
1317 	 * @param _newSettingId The new settingId value to route
1318 	 * @param _newSettingContractAddress The address of the new setting contract to route
1319 	 * @return true on success
1320 	 */
1321 	function _storeSettingDeprecation(uint256 _settingId, address _creatorNameId, address _creatorTAOId, address _associatedTAOId, uint256 _newSettingId, address _newSettingContractAddress) internal returns (bool) {
1322 		// Make sure this setting exists
1323 		require (settingDatas[_settingId].creatorNameId != address(0) && settingDatas[_settingId].rejected == false && settingDatas[_settingId].pendingCreate == false);
1324 
1325 		// Make sure deprecation is not yet exist for this setting Id
1326 		require (settingDeprecations[_settingId].creatorNameId == address(0));
1327 
1328 		// Make sure newSettingId exists
1329 		require (settingDatas[_newSettingId].creatorNameId != address(0) && settingDatas[_newSettingId].rejected == false && settingDatas[_newSettingId].pendingCreate == false);
1330 
1331 		// Store setting deprecation info
1332 		SettingDeprecation storage _settingDeprecation = settingDeprecations[_settingId];
1333 		_settingDeprecation.settingId = _settingId;
1334 		_settingDeprecation.creatorNameId = _creatorNameId;
1335 		_settingDeprecation.creatorTAOId = _creatorTAOId;
1336 		_settingDeprecation.associatedTAOId = _associatedTAOId;
1337 		_settingDeprecation.pendingDeprecated = true;
1338 		_settingDeprecation.locked = true;
1339 		_settingDeprecation.pendingNewSettingId = _newSettingId;
1340 		_settingDeprecation.pendingNewSettingContractAddress = _newSettingContractAddress;
1341 		return true;
1342 	}
1343 
1344 	/**
1345 	 * @dev Store the associated TAO Setting info
1346 	 * @param _associatedTAOId The Associated TAO ID
1347 	 * @param _settingId The setting ID
1348 	 * @return The newly created associated TAO setting ID
1349 	 */
1350 	function _storeAssociatedTAOSetting(address _associatedTAOId, uint256 _settingId) internal returns (bytes32) {
1351 		// Store the associatedTAOSetting info
1352 		bytes32 _associatedTAOSettingId = keccak256(abi.encodePacked(this, _associatedTAOId, _settingId));
1353 		AssociatedTAOSetting storage _associatedTAOSetting = associatedTAOSettings[_associatedTAOSettingId];
1354 		_associatedTAOSetting.associatedTAOSettingId = _associatedTAOSettingId;
1355 		_associatedTAOSetting.associatedTAOId = _associatedTAOId;
1356 		_associatedTAOSetting.settingId = _settingId;
1357 		return _associatedTAOSettingId;
1358 	}
1359 
1360 	/**
1361 	 * @dev Store the creator TAO Setting info
1362 	 * @param _creatorTAOId The Creator TAO ID
1363 	 * @param _settingId The setting ID
1364 	 * @return The newly created creator TAO setting ID
1365 	 */
1366 	function _storeCreatorTAOSetting(address _creatorTAOId, uint256 _settingId) internal returns (bytes32) {
1367 		// Store the creatorTAOSetting info
1368 		bytes32 _creatorTAOSettingId = keccak256(abi.encodePacked(this, _creatorTAOId, _settingId));
1369 		CreatorTAOSetting storage _creatorTAOSetting = creatorTAOSettings[_creatorTAOSettingId];
1370 		_creatorTAOSetting.creatorTAOSettingId = _creatorTAOSettingId;
1371 		_creatorTAOSetting.creatorTAOId = _creatorTAOId;
1372 		_creatorTAOSetting.settingId = _settingId;
1373 		return _creatorTAOSettingId;
1374 	}
1375 }