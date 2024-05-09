1 pragma solidity ^0.4.24;
2 
3 // https://www.ethereum.org/token
4 
5 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
6 
7 
8 /**
9  * @title SpinWinInterface
10  */
11 interface SpinWinInterface {
12 	function refundPendingBets() external returns (bool);
13 }
14 
15 
16 /**
17  * @title SettingInterface
18  */
19 interface SettingInterface {
20 	function uintSettings(bytes32 name) external constant returns (uint256);
21 	function boolSettings(bytes32 name) external constant returns (bool);
22 	function isActive() external constant returns (bool);
23 	function canBet(uint256 rewardValue, uint256 betValue, uint256 playerNumber, uint256 houseEdge) external constant returns (bool);
24 	function isExchangeAllowed(address playerAddress, uint256 tokenAmount) external constant returns (bool);
25 
26 	/******************************************/
27 	/*          SPINWIN ONLY METHODS          */
28 	/******************************************/
29 	function spinwinSetUintSetting(bytes32 name, uint256 value) external;
30 	function spinwinIncrementUintSetting(bytes32 name) external;
31 	function spinwinSetBoolSetting(bytes32 name, bool value) external;
32 	function spinwinAddFunds(uint256 amount) external;
33 	function spinwinUpdateTokenToWeiExchangeRate() external;
34 	function spinwinRollDice(uint256 betValue) external;
35 	function spinwinUpdateWinMetric(uint256 playerProfit) external;
36 	function spinwinUpdateLoseMetric(uint256 betValue, uint256 tokenRewardValue) external;
37 	function spinwinUpdateLotteryContributionMetric(uint256 lotteryContribution) external;
38 	function spinwinUpdateExchangeMetric(uint256 exchangeAmount) external;
39 
40 	/******************************************/
41 	/*      SPINLOTTERY ONLY METHODS          */
42 	/******************************************/
43 	function spinlotterySetUintSetting(bytes32 name, uint256 value) external;
44 	function spinlotteryIncrementUintSetting(bytes32 name) external;
45 	function spinlotterySetBoolSetting(bytes32 name, bool value) external;
46 	function spinlotteryUpdateTokenToWeiExchangeRate() external;
47 	function spinlotterySetMinBankroll(uint256 _minBankroll) external returns (bool);
48 }
49 
50 
51 /**
52  * @title TokenInterface
53  */
54 interface TokenInterface {
55 	function getTotalSupply() external constant returns (uint256);
56 	function getBalanceOf(address account) external constant returns (uint256);
57 	function transfer(address _to, uint256 _value) external returns (bool);
58 	function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
59 	function approve(address _spender, uint256 _value) external returns (bool success);
60 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) external returns (bool success);
61 	function burn(uint256 _value) external returns (bool success);
62 	function burnFrom(address _from, uint256 _value) external returns (bool success);
63 	function mintTransfer(address _to, uint _value) external returns (bool);
64 	function burnAt(address _at, uint _value) external returns (bool);
65 }
66 
67 
68 
69 
70 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 library SafeMath {
77 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78 		if (a == 0) {
79 			return 0;
80 		}
81 		uint256 c = a * b;
82 		assert(c / a == b);
83 		return c;
84 	}
85 
86 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
87 		// assert(b > 0); // Solidity automatically throws when dividing by 0
88 		uint256 c = a / b;
89 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 		return c;
91 	}
92 
93 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94 		assert(b <= a);
95 		return a - b;
96 	}
97 
98 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
99 		uint256 c = a + b;
100 		assert(c >= a);
101 		return c;
102 	}
103 }
104 
105 
106 
107 
108 
109 // https://github.com/ethereum/ethereum-org/blob/master/solidity/token-advanced.sol
110 
111 
112 
113 contract TokenERC20 {
114 	// Public variables of the token
115 	string public name;
116 	string public symbol;
117 	uint8 public decimals = 18;
118 	// 18 decimals is the strongly suggested default, avoid changing it
119 	uint256 public totalSupply;
120 
121 	// This creates an array with all balances
122 	mapping (address => uint256) public balanceOf;
123 	mapping (address => mapping (address => uint256)) public allowance;
124 
125 	// This generates a public event on the blockchain that will notify clients
126 	event Transfer(address indexed from, address indexed to, uint256 value);
127 
128 	// This generates a public event on the blockchain that will notify clients
129 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
130 
131 	// This notifies clients about the amount burnt
132 	event Burn(address indexed from, uint256 value);
133 
134 	/**
135 	 * Constructor function
136 	 *
137 	 * Initializes contract with initial supply tokens to the creator of the contract
138 	 */
139 	constructor(
140 		uint256 initialSupply,
141 		string tokenName,
142 		string tokenSymbol
143 	) public {
144 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
145 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
146 		name = tokenName;                                   // Set the name for display purposes
147 		symbol = tokenSymbol;                               // Set the symbol for display purposes
148 	}
149 
150 	/**
151 	 * Internal transfer, only can be called by this contract
152 	 */
153 	function _transfer(address _from, address _to, uint _value) internal {
154 		// Prevent transfer to 0x0 address. Use burn() instead
155 		require(_to != 0x0);
156 		// Check if the sender has enough
157 		require(balanceOf[_from] >= _value);
158 		// Check for overflows
159 		require(balanceOf[_to] + _value > balanceOf[_to]);
160 		// Save this for an assertion in the future
161 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
162 		// Subtract from the sender
163 		balanceOf[_from] -= _value;
164 		// Add the same to the recipient
165 		balanceOf[_to] += _value;
166 		emit Transfer(_from, _to, _value);
167 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
168 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
169 	}
170 
171 	/**
172 	 * Transfer tokens
173 	 *
174 	 * Send `_value` tokens to `_to` from your account
175 	 *
176 	 * @param _to The address of the recipient
177 	 * @param _value the amount to send
178 	 */
179 	function transfer(address _to, uint256 _value) public returns (bool success) {
180 		_transfer(msg.sender, _to, _value);
181 		return true;
182 	}
183 
184 	/**
185 	 * Transfer tokens from other address
186 	 *
187 	 * Send `_value` tokens to `_to` in behalf of `_from`
188 	 *
189 	 * @param _from The address of the sender
190 	 * @param _to The address of the recipient
191 	 * @param _value the amount to send
192 	 */
193 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
194 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
195 		allowance[_from][msg.sender] -= _value;
196 		_transfer(_from, _to, _value);
197 		return true;
198 	}
199 
200 	/**
201 	 * Set allowance for other address
202 	 *
203 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
204 	 *
205 	 * @param _spender The address authorized to spend
206 	 * @param _value the max amount they can spend
207 	 */
208 	function approve(address _spender, uint256 _value) public returns (bool success) {
209 		allowance[msg.sender][_spender] = _value;
210 		emit Approval(msg.sender, _spender, _value);
211 		return true;
212 	}
213 
214 	/**
215 	 * Set allowance for other address and notify
216 	 *
217 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
218 	 *
219 	 * @param _spender The address authorized to spend
220 	 * @param _value the max amount they can spend
221 	 * @param _extraData some extra information to send to the approved contract
222 	 */
223 	function approveAndCall(address _spender, uint256 _value, bytes _extraData)
224 		public
225 		returns (bool success) {
226 		tokenRecipient spender = tokenRecipient(_spender);
227 		if (approve(_spender, _value)) {
228 			spender.receiveApproval(msg.sender, _value, this, _extraData);
229 			return true;
230 		}
231 	}
232 
233 	/**
234 	 * Destroy tokens
235 	 *
236 	 * Remove `_value` tokens from the system irreversibly
237 	 *
238 	 * @param _value the amount of money to burn
239 	 */
240 	function burn(uint256 _value) public returns (bool success) {
241 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
242 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
243 		totalSupply -= _value;                      // Updates totalSupply
244 		emit Burn(msg.sender, _value);
245 		return true;
246 	}
247 
248 	/**
249 	 * Destroy tokens from other account
250 	 *
251 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
252 	 *
253 	 * @param _from the address of the sender
254 	 * @param _value the amount of money to burn
255 	 */
256 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
257 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
258 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
259 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
260 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
261 		totalSupply -= _value;                              // Update totalSupply
262 		emit Burn(_from, _value);
263 		return true;
264 	}
265 }
266 
267 
268 contract developed {
269 	address public developer;
270 
271 	/**
272 	 * Constructor
273 	 */
274 	constructor() public {
275 		developer = msg.sender;
276 	}
277 
278 	/**
279 	 * @dev Checks only developer address is calling
280 	 */
281 	modifier onlyDeveloper {
282 		require(msg.sender == developer);
283 		_;
284 	}
285 
286 	/**
287 	 * @dev Allows developer to switch developer address
288 	 * @param _developer The new developer address to be set
289 	 */
290 	function changeDeveloper(address _developer) public onlyDeveloper {
291 		developer = _developer;
292 	}
293 
294 	/**
295 	 * @dev Allows developer to withdraw ERC20 Token
296 	 */
297 	function withdrawToken(address tokenContractAddress) public onlyDeveloper {
298 		TokenERC20 _token = TokenERC20(tokenContractAddress);
299 		if (_token.balanceOf(this) > 0) {
300 			_token.transfer(developer, _token.balanceOf(this));
301 		}
302 	}
303 }
304 
305 
306 
307 contract escaped {
308 	address public escapeActivator;
309 
310 	/**
311 	 * Constructor
312 	 */
313 	constructor() public {
314 		escapeActivator = 0xB15C54b4B9819925Cd2A7eE3079544402Ac33cEe;
315 	}
316 
317 	/**
318 	 * @dev Checks only escapeActivator address is calling
319 	 */
320 	modifier onlyEscapeActivator {
321 		require(msg.sender == escapeActivator);
322 		_;
323 	}
324 
325 	/**
326 	 * @dev Allows escapeActivator to switch escapeActivator address
327 	 * @param _escapeActivator The new escapeActivator address to be set
328 	 */
329 	function changeAddress(address _escapeActivator) public onlyEscapeActivator {
330 		escapeActivator = _escapeActivator;
331 	}
332 }
333 
334 
335 
336 
337 
338 /**
339  * @title GameSetting
340  */
341 contract GameSetting is developed, escaped, SettingInterface {
342 	using SafeMath for uint256;
343 
344 	address public spinwinAddress;
345 	address public spinlotteryAddress;
346 
347 	mapping(bytes32 => uint256) internal _uintSettings;    // Array containing all uint256 settings
348 	mapping(bytes32 => bool) internal _boolSettings;       // Array containing all bool settings
349 
350 	uint256 constant public PERCENTAGE_DIVISOR = 10 ** 6;   // 1000000 = 100%
351 	uint256 constant public HOUSE_EDGE_DIVISOR = 1000;
352 	uint256 constant public CURRENCY_DIVISOR = 10**18;
353 	uint256 constant public TWO_DECIMALS = 100;
354 	uint256 constant public MAX_NUMBER = 99;
355 	uint256 constant public MIN_NUMBER = 2;
356 	uint256 constant public MAX_HOUSE_EDGE = 1000;          // 0% House Edge
357 	uint256 constant public MIN_HOUSE_EDGE = 0;             // 100% House edge
358 
359 	TokenInterface internal _spintoken;
360 	SpinWinInterface internal _spinwin;
361 
362 	/**
363 	 * @dev Log dev sets uint setting
364 	 */
365 	event LogSetUintSetting(address indexed who, bytes32 indexed name, uint256 value);
366 
367 	/**
368 	 * @dev Log dev sets bool setting
369 	 */
370 	event LogSetBoolSetting(address indexed who, bytes32 indexed name, bool value);
371 
372 	/**
373 	 * @dev Log when dev adds some funds
374 	 */
375 	event LogAddBankRoll(uint256 amount);
376 
377 	/**
378 	 * @dev Log when the token to Wei exchange rate is updated
379 	 */
380 	event LogUpdateTokenToWeiExchangeRate(uint256 exchangeRate, uint256 exchangeRateBlockNumber);
381 
382 	/**
383 	 * @dev Log when developer set spinwin contract to emergency mode
384 	 */
385 	event LogSpinwinEscapeHatch();
386 
387 	/**
388 	 * Constructor
389 	 */
390 	constructor(address _spintokenAddress) public {
391 		_spintoken = TokenInterface(_spintokenAddress);
392 		devSetUintSetting('minBet', CURRENCY_DIVISOR.div(100));			// init min bet (0.01 ether)
393 		devSetUintSetting('maxProfitAsPercentOfHouse', 200000);         // init 200000 = 20% commission
394 		devSetUintSetting('minBankroll', CURRENCY_DIVISOR.mul(20));     // init min bank roll (20 eth)
395 		devSetTokenExchangeMinBankrollPercent(900000);                  // init token exchange min bank roll percentage (90%)
396 		devSetUintSetting('referralPercent', 10000);                    // init referral percentage (1%)
397 		devSetUintSetting('gasForLottery', 250000);                     // init gas for lottery
398 		devSetUintSetting('maxBlockSecurityCount', 256);                // init max block security count (256)
399 		devSetUintSetting('blockSecurityCount', 3);                     // init block security count (3)
400 		devSetUintSetting('tokenExchangeBlockSecurityCount', 3);        // init token exchange block security count (3)
401 		devSetUintSetting('maxProfitBlockSecurityCount', 3);            // init max profit block security count (3)
402 		devSetUintSetting('spinEdgeModifier', 80);                      // init spin edge modifier (0.8)
403 		devSetUintSetting('spinBankModifier', 50);                      // init spin bank modifier (0.5)
404 		devSetUintSetting('spinNumberModifier', 5);                     // init spin number modifier (0.05)
405 		devSetUintSetting('maxMinBankroll', CURRENCY_DIVISOR.mul(5000));   // init max value for min bankroll (5,000 eth)
406 		devSetUintSetting('lastProcessedBetInternalId', 1);             // init lastProcessedBetInternalId = 1
407 		devSetUintSetting('exchangeAmountDivisor', 2);                  // init exchangeAmountDivisor = 2
408 		devSetUintSetting('tokenExchangeRatio', 10);                    // init tokenExchangeRatio = 0.1 (divided by TWO_DECIMALS)
409 		devSetUintSetting('spinToWeiRate', CURRENCY_DIVISOR);           // init spinToWeiRate = 1
410 		devSetUintSetting('blockToSpinRate', CURRENCY_DIVISOR);         // init blockToSpinRate = 1
411 		devSetUintSetting('blockToWeiRate', CURRENCY_DIVISOR);          // init blockToWeiRate = 1
412 		devSetUintSetting('gasForClearingBet', 320000);                 // init gasForClearingBet = 320000 gas
413 		devSetUintSetting('gasPrice', 40000000000);                     // init gasPrice = 40 gwei
414 		devSetUintSetting('clearSingleBetMultiplier', 200);             // init clearSingleBetMultiplier = 2x (divided by TWO_DECIMALS)
415 		devSetUintSetting('clearMultipleBetsMultiplier', 100);          // init clearMultipleBetMultiplier = 1x (divided by TWO_DECIMALS)
416 		devSetUintSetting('maxNumClearBets', 4);                        // init maxNumClearBets = 4
417 		devSetUintSetting('lotteryTargetMultiplier', 200);              // init lotteryTargetMultiplier = 2x (divided by TWO_DECIMALS)
418 		_setMaxProfit(true);
419 	}
420 
421 	/**
422 	 * @dev Checks only spinwinAddress is calling
423 	 */
424 	modifier onlySpinwin {
425 		require(msg.sender == spinwinAddress);
426 		_;
427 	}
428 
429 	/**
430 	 * @dev Checks only spinlotteryAddress is calling
431 	 */
432 	modifier onlySpinlottery {
433 		require(msg.sender == spinlotteryAddress);
434 		_;
435 	}
436 
437 	/******************************************/
438 	/*       DEVELOPER ONLY METHODS           */
439 	/******************************************/
440 
441 	/**
442 	 * @dev Allows developer to set spinwin contract address
443 	 * @param _address The contract address to be set
444 	 */
445 	function devSetSpinwinAddress(address _address) public onlyDeveloper {
446 		require (_address != address(0));
447 		spinwinAddress = _address;
448 		_spinwin = SpinWinInterface(spinwinAddress);
449 	}
450 
451 	/**
452 	 * @dev Allows developer to set spinlottery contract address
453 	 * @param _address The contract address to be set
454 	 */
455 	function devSetSpinlotteryAddress(address _address) public onlyDeveloper {
456 		require (_address != address(0));
457 		spinlotteryAddress = _address;
458 	}
459 
460 	/**
461 	 * @dev Allows dev to set uint setting
462 	 * @param name The setting name to be set
463 	 * @param value The value to be set
464 	 */
465 	function devSetUintSetting(bytes32 name, uint256 value) public onlyDeveloper {
466 		_uintSettings[name] = value;
467 		emit LogSetUintSetting(developer, name, value);
468 	}
469 
470 	/**
471 	 * @dev Allows dev to set bool setting
472 	 * @param name The setting name to be set
473 	 * @param value The value to be set
474 	 */
475 	function devSetBoolSetting(bytes32 name, bool value) public onlyDeveloper {
476 		_boolSettings[name] = value;
477 		emit LogSetBoolSetting(developer, name, value);
478 	}
479 
480 	/**
481 	 * @dev Allows developer to set min bank roll
482 	 * @param minBankroll The new min bankroll value to be set
483 	 */
484 	function devSetMinBankroll(uint256 minBankroll) public onlyDeveloper {
485 		_uintSettings['minBankroll'] = minBankroll;
486 		_uintSettings['tokenExchangeMinBankroll'] = _uintSettings['minBankroll'].mul(_uintSettings['tokenExchangeMinBankrollPercent']).div(PERCENTAGE_DIVISOR);
487 	}
488 
489 	/**
490 	 * @dev Allows developer to set token exchange min bank roll percent
491 	 * @param tokenExchangeMinBankrollPercent The new value to be set
492 	 */
493 	function devSetTokenExchangeMinBankrollPercent(uint256 tokenExchangeMinBankrollPercent) public onlyDeveloper {
494 		_uintSettings['tokenExchangeMinBankrollPercent'] = tokenExchangeMinBankrollPercent;
495 		_uintSettings['tokenExchangeMinBankroll'] = _uintSettings['minBankroll'].mul(_uintSettings['tokenExchangeMinBankrollPercent']).div(PERCENTAGE_DIVISOR);
496 	}
497 
498 	/******************************************/
499 	/*      ESCAPE ACTIVATOR ONLY METHODS     */
500 	/******************************************/
501 
502 	/**
503 	 * @dev Allows escapeActivator to trigger spinwin emergency mode. Will disable all bets and only allow token exchange at a fixed rate
504 	 */
505 	function spinwinEscapeHatch() public onlyEscapeActivator {
506 		_spinwin.refundPendingBets();
507 		_boolSettings['contractKilled'] = true;
508 		_uintSettings['contractBalanceHonor'] = _uintSettings['contractBalance'];
509 		_uintSettings['tokenExchangeMinBankroll'] = 0;
510 		_uintSettings['tokenExchangeMinBankrollHonor'] = 0;
511 		/**
512 		 * tokenToWeiExchangeRate is ETH in 36 decimals or WEI in 18 decimals to account for
513 		 * the state when token's totalSupply is 10^18 more than contractBalance.
514 		 * Otherwise the tokenToWeiExchangeRate will always be 0.
515 		 * This means, in the exchange token function, we need to divide
516 		 * tokenToWeiExchangeRate with CURRENCY_DIVISOR
517 		 */
518 		_uintSettings['tokenToWeiExchangeRate'] = _spintoken.getTotalSupply() > 0 ? _uintSettings['contractBalance'].mul(CURRENCY_DIVISOR).mul(CURRENCY_DIVISOR).div(_spintoken.getTotalSupply()) : 0;
519 		_uintSettings['tokenToWeiExchangeRateHonor'] = _uintSettings['tokenToWeiExchangeRate'];
520 		_uintSettings['tokenToWeiExchangeRateBlockNum'] = block.number;
521 		emit LogUpdateTokenToWeiExchangeRate(_uintSettings['tokenToWeiExchangeRateHonor'], _uintSettings['tokenToWeiExchangeRateBlockNum']);
522 		emit LogSpinwinEscapeHatch();
523 	}
524 
525 	/******************************************/
526 	/*         SPINWIN ONLY METHODS           */
527 	/******************************************/
528 	/**
529 	 * @dev Allows spinwin to set uint setting
530 	 * @param name The setting name to be set
531 	 * @param value The value to be set
532 	 */
533 	function spinwinSetUintSetting(bytes32 name, uint256 value) public onlySpinwin {
534 		_uintSettings[name] = value;
535 		emit LogSetUintSetting(spinwinAddress, name, value);
536 	}
537 
538 	/**
539 	 * @dev Allows spinwin to increment existing uint setting value
540 	 * @param name The setting name to be set
541 	 */
542 	function spinwinIncrementUintSetting(bytes32 name) public onlySpinwin {
543 		_uintSettings[name] = _uintSettings[name].add(1);
544 		emit LogSetUintSetting(spinwinAddress, name, _uintSettings[name]);
545 	}
546 
547 	/**
548 	 * @dev Allows spinwin to set bool setting
549 	 * @param name The setting name to be set
550 	 * @param value The value to be set
551 	 */
552 	function spinwinSetBoolSetting(bytes32 name, bool value) public onlySpinwin {
553 		_boolSettings[name] = value;
554 		emit LogSetBoolSetting(spinwinAddress, name, value);
555 	}
556 
557 	/**
558 	 * @dev Add funds to the spinwin contract
559 	 * @param amount The amount of eth sent
560 	 */
561 	function spinwinAddFunds(uint256 amount) public onlySpinwin {
562 		// Safely update contract balance
563 		_uintSettings['contractBalance'] = _uintSettings['contractBalance'].add(amount);
564 
565 		// Update max profit
566 		_setMaxProfit(false);
567 
568 		emit LogAddBankRoll(amount);
569 	}
570 
571 	/**
572 	 * @dev Allow spinwin to update token to Wei exchange rate.
573 	 */
574 	function spinwinUpdateTokenToWeiExchangeRate() public onlySpinwin {
575 		_updateTokenToWeiExchangeRate();
576 	}
577 
578 	/**
579 	 * @dev Allow spinwin to update settings when roll dice
580 	 * Increment totalBets
581 	 * Add betValue to totalWeiWagered
582 	 *
583 	 * @param betValue The bet value
584 	 * @return The internal bet ID
585 	 */
586 	function spinwinRollDice(uint256 betValue) public onlySpinwin {
587 		_uintSettings['totalBets']++;
588 		_uintSettings['totalWeiWagered'] = _uintSettings['totalWeiWagered'].add(betValue);
589 	}
590 
591 	/**
592 	 * @dev Allows spinwin to update uint setting when player wins
593 	 * @param playerProfit The player profit to be subtracted from contractBalance and added to totalWeiWon
594 	 */
595 	function spinwinUpdateWinMetric(uint256 playerProfit) public onlySpinwin {
596 		_uintSettings['contractBalance'] = _uintSettings['contractBalance'].sub(playerProfit);
597 		_uintSettings['totalWeiWon'] = _uintSettings['totalWeiWon'].add(playerProfit);
598 		_setMaxProfit(false);
599 	}
600 
601 	/**
602 	 * @dev Allows spinwin to update uint setting when player loses
603 	 * @param betValue The original wager
604 	 * @param tokenRewardValue The amount of token to be rewarded
605 	 */
606 	function spinwinUpdateLoseMetric(uint256 betValue, uint256 tokenRewardValue) public onlySpinwin {
607 		_uintSettings['contractBalance'] = _uintSettings['contractBalance'].add(betValue).sub(1);
608 		_uintSettings['totalWeiWon'] = _uintSettings['totalWeiWon'].add(1);
609 		_uintSettings['totalWeiLost'] = _uintSettings['totalWeiLost'].add(betValue).sub(1);
610 		_uintSettings['totalTokenPayouts'] = _uintSettings['totalTokenPayouts'].add(tokenRewardValue);
611 		_setMaxProfit(false);
612 	}
613 
614 	/**
615 	 * @dev Allows spinwin to update uint setting when there is a lottery contribution
616 	 * @param lotteryContribution The amount to be contributed to lottery
617 	 */
618 	function spinwinUpdateLotteryContributionMetric(uint256 lotteryContribution) public onlySpinwin {
619 		_uintSettings['contractBalance'] = _uintSettings['contractBalance'].sub(lotteryContribution);
620 		_setMaxProfit(true);
621 	}
622 
623 	/**
624 	 * @dev Allows spinwin to update uint setting when there is a token exchange transaction
625 	 * @param exchangeAmount The converted exchange amount
626 	 */
627 	function spinwinUpdateExchangeMetric(uint256 exchangeAmount) public onlySpinwin {
628 		_uintSettings['contractBalance'] = _uintSettings['contractBalance'].sub(exchangeAmount);
629 		_setMaxProfit(false);
630 	}
631 
632 
633 	/******************************************/
634 	/*      SPINLOTTERY ONLY METHODS          */
635 	/******************************************/
636 	/**
637 	 * @dev Allows spinlottery to set uint setting
638 	 * @param name The setting name to be set
639 	 * @param value The value to be set
640 	 */
641 	function spinlotterySetUintSetting(bytes32 name, uint256 value) public onlySpinlottery {
642 		_uintSettings[name] = value;
643 		emit LogSetUintSetting(spinlotteryAddress, name, value);
644 	}
645 
646 	/**
647 	 * @dev Allows spinlottery to increment existing uint setting value
648 	 * @param name The setting name to be set
649 	 */
650 	function spinlotteryIncrementUintSetting(bytes32 name) public onlySpinlottery {
651 		_uintSettings[name] = _uintSettings[name].add(1);
652 		emit LogSetUintSetting(spinwinAddress, name, _uintSettings[name]);
653 	}
654 
655 	/**
656 	 * @dev Allows spinlottery to set bool setting
657 	 * @param name The setting name to be set
658 	 * @param value The value to be set
659 	 */
660 	function spinlotterySetBoolSetting(bytes32 name, bool value) public onlySpinlottery {
661 		_boolSettings[name] = value;
662 		emit LogSetBoolSetting(spinlotteryAddress, name, value);
663 	}
664 
665 	/**
666 	 * @dev Allow spinlottery to update token to Wei exchange rate.
667 	 */
668 	function spinlotteryUpdateTokenToWeiExchangeRate() public onlySpinlottery {
669 		_updateTokenToWeiExchangeRate();
670 	}
671 
672 	/**
673 	 * @dev Allows lottery to set spinwin minBankroll value
674 	 * @param _minBankroll The new value to be set
675 	 * @return Return true if success
676 	 */
677 	function spinlotterySetMinBankroll(uint256 _minBankroll) public onlySpinlottery returns (bool) {
678 		if (_minBankroll > _uintSettings['maxMinBankroll']) {
679 			_minBankroll = _uintSettings['maxMinBankroll'];
680 		} else if (_minBankroll < _uintSettings['contractBalance']) {
681 			_minBankroll = _uintSettings['contractBalance'];
682 		}
683 		_uintSettings['minBankroll'] = _minBankroll;
684 		_uintSettings['tokenExchangeMinBankroll'] = _uintSettings['minBankroll'].mul(_uintSettings['tokenExchangeMinBankrollPercent']).div(PERCENTAGE_DIVISOR);
685 
686 		// Update max profit
687 		_setMaxProfit(false);
688 
689 		return true;
690 	}
691 
692 	/******************************************/
693 	/*         PUBLIC ONLY METHODS            */
694 	/******************************************/
695 	/**
696 	 * @dev Gets uint setting value
697 	 * @param name The name of the uint setting
698 	 * @return The value of the setting
699 	 */
700 	function uintSettings(bytes32 name) public constant returns (uint256) {
701 		return _uintSettings[name];
702 	}
703 
704 	/**
705 	 * @dev Gets bool setting value
706 	 * @param name The name of the bool setting
707 	 * @return The value of the setting
708 	 */
709 	function boolSettings(bytes32 name) public constant returns (bool) {
710 		return _boolSettings[name];
711 	}
712 
713 	/**
714 	 * @dev Check if contract is active
715 	 * @return Return true if yes, false otherwise.
716 	 */
717 	function isActive() public constant returns (bool) {
718 		if (_boolSettings['contractKilled'] == false && _boolSettings['gamePaused'] == false) {
719 			return true;
720 		} else {
721 			return false;
722 		}
723 	}
724 
725 	/**
726 	 * @dev Check whether current bet is valid
727 	 * @param rewardValue The winning amount
728 	 * @param betValue The original wager
729 	 * @param playerNumber The player chosen number
730 	 * @param houseEdge The house edge
731 	 * @return Return true if yes, false otherwise.
732 	 */
733 	function canBet(uint256 rewardValue, uint256 betValue, uint256 playerNumber, uint256 houseEdge) public constant returns (bool) {
734 		if (_boolSettings['contractKilled'] == false && _boolSettings['gamePaused'] == false && rewardValue <= _uintSettings['maxProfitHonor'] && betValue >= _uintSettings['minBet'] && houseEdge >= MIN_HOUSE_EDGE && houseEdge <= MAX_HOUSE_EDGE && playerNumber >= MIN_NUMBER && playerNumber <= MAX_NUMBER) {
735 			return true;
736 		} else {
737 			return false;
738 		}
739 	}
740 
741 	/**
742 	 * @dev Check whether token exchange is allowed
743 	 * @param playerAddress The player address to be checked
744 	 * @param tokenAmount The amount of token to be exchanged
745 	 * @return Return true if yes, false otherwise.
746 	 */
747 	function isExchangeAllowed(address playerAddress, uint256 tokenAmount) public constant returns (bool) {
748 		if (_boolSettings['gamePaused'] == false && _boolSettings['tokenExchangePaused'] == false && _uintSettings['contractBalanceHonor'] >= _uintSettings['tokenExchangeMinBankrollHonor'] && _uintSettings['tokenToWeiExchangeRateHonor'] > 0 && _spintoken.getBalanceOf(playerAddress) >= tokenAmount) {
749 			return true;
750 		} else {
751 			return false;
752 		}
753 	}
754 
755 	/******************************************/
756 	/*        INTERNAL ONLY METHODS           */
757 	/******************************************/
758 
759 	/**
760 	 * @dev Calculates and sets the latest max profit a bet can possibly earn. Also update the honor variables that we are going to promise players.
761 	 * @param force If true, bypass the block security check and update honor settings
762 	 */
763 	function _setMaxProfit(bool force) internal {
764 		_uintSettings['maxProfit'] = _uintSettings['contractBalance'].mul(_uintSettings['maxProfitAsPercentOfHouse']).div(PERCENTAGE_DIVISOR);
765 		if (force || block.number > _uintSettings['maxProfitBlockNum'].add(_uintSettings['maxProfitBlockSecurityCount'])) {
766 			if (_uintSettings['contractBalance'] < 10 ether) {
767 				_uintSettings['maxProfitAsPercentOfHouse'] = 200000; // 20%
768 			} else if (_uintSettings['contractBalance'] >= 10 ether && _uintSettings['contractBalance'] < 100 ether) {
769 				_uintSettings['maxProfitAsPercentOfHouse'] = 100000; // 10%
770 			} else if (_uintSettings['contractBalance'] >= 100 ether && _uintSettings['contractBalance'] < 1000 ether) {
771 				_uintSettings['maxProfitAsPercentOfHouse'] = 50000; // 5%
772 			} else {
773 				_uintSettings['maxProfitAsPercentOfHouse'] = 10000; // 1%
774 			}
775 			_uintSettings['maxProfitHonor'] = _uintSettings['maxProfit'];
776 			_uintSettings['contractBalanceHonor'] = _uintSettings['contractBalance'];
777 			_uintSettings['minBankrollHonor'] = _uintSettings['minBankroll'];
778 			_uintSettings['tokenExchangeMinBankrollHonor'] = _uintSettings['tokenExchangeMinBankroll'];
779 			_uintSettings['totalWeiLostHonor'] = _uintSettings['totalWeiLost'];
780 			_uintSettings['maxProfitBlockNum'] = block.number;
781 		}
782 	}
783 
784 	/**
785 	 * @dev Updates token to Wei exchange rate.
786 	 * The exchange rate will be updated everytime there is a transaction happens in spinwin.
787 	 * If contract is killed, we don't need to do anything
788 	 */
789 	function _updateTokenToWeiExchangeRate() internal {
790 		if (!_boolSettings['contractKilled']) {
791 			if (_uintSettings['contractBalance'] >= _uintSettings['tokenExchangeMinBankroll'] && _spintoken.getTotalSupply() > 0) {
792 				/**
793 				 * tokenToWeiExchangeRate is ETH in 36 decimals or WEI in 18 decimals to account for
794 				 * the state when token's totalSupply is 10^18 more than contractBalance.
795 				 * Otherwise the tokenToWeiExchangeRate will always be 0.
796 				 * This means, in the exchange token function, we need to divide
797 				 * tokenToWeiExchangeRate with CURRENCY_DIVISOR
798 				 */
799 				_uintSettings['tokenToWeiExchangeRate'] = ((_uintSettings['contractBalance'].sub(_uintSettings['tokenExchangeMinBankroll'])).mul(CURRENCY_DIVISOR).mul(CURRENCY_DIVISOR).div(_uintSettings['exchangeAmountDivisor'])).div(_spintoken.getTotalSupply().mul(_uintSettings['tokenExchangeRatio']).div(TWO_DECIMALS));
800 			} else {
801 				_uintSettings['tokenToWeiExchangeRate'] = 0;
802 			}
803 
804 			if (block.number > _uintSettings['tokenToWeiExchangeRateBlockNum'].add(_uintSettings['tokenExchangeBlockSecurityCount'])) {
805 				_uintSettings['tokenToWeiExchangeRateHonor'] = _uintSettings['tokenToWeiExchangeRate'];
806 				_uintSettings['tokenToWeiExchangeRateBlockNum'] = block.number;
807 				emit LogUpdateTokenToWeiExchangeRate(_uintSettings['tokenToWeiExchangeRateHonor'], _uintSettings['tokenToWeiExchangeRateBlockNum']);
808 			}
809 		}
810 	}
811 }