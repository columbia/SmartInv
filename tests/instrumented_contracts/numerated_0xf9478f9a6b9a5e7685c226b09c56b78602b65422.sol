1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title LotteryInterface
5  */
6 interface LotteryInterface {
7 	function claimReward(address playerAddress, uint256 tokenAmount) external returns (bool);
8 	function calculateLotteryContributionPercentage() external constant returns (uint256);
9 	function getNumLottery() external constant returns (uint256);
10 	function isActive() external constant returns (bool);
11 	function getCurrentTicketMultiplierHonor() external constant returns (uint256);
12 	function getCurrentLotteryTargetBalance() external constant returns (uint256, uint256);
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
107 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
108 
109 contract TokenERC20 {
110 	// Public variables of the token
111 	string public name;
112 	string public symbol;
113 	uint8 public decimals = 18;
114 	// 18 decimals is the strongly suggested default, avoid changing it
115 	uint256 public totalSupply;
116 
117 	// This creates an array with all balances
118 	mapping (address => uint256) public balanceOf;
119 	mapping (address => mapping (address => uint256)) public allowance;
120 
121 	// This generates a public event on the blockchain that will notify clients
122 	event Transfer(address indexed from, address indexed to, uint256 value);
123 
124 	// This generates a public event on the blockchain that will notify clients
125 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
126 
127 	// This notifies clients about the amount burnt
128 	event Burn(address indexed from, uint256 value);
129 
130 	/**
131 	 * Constructor function
132 	 *
133 	 * Initializes contract with initial supply tokens to the creator of the contract
134 	 */
135 	constructor(
136 		uint256 initialSupply,
137 		string tokenName,
138 		string tokenSymbol
139 	) public {
140 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
141 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
142 		name = tokenName;                                   // Set the name for display purposes
143 		symbol = tokenSymbol;                               // Set the symbol for display purposes
144 	}
145 
146 	/**
147 	 * Internal transfer, only can be called by this contract
148 	 */
149 	function _transfer(address _from, address _to, uint _value) internal {
150 		// Prevent transfer to 0x0 address. Use burn() instead
151 		require(_to != 0x0);
152 		// Check if the sender has enough
153 		require(balanceOf[_from] >= _value);
154 		// Check for overflows
155 		require(balanceOf[_to] + _value > balanceOf[_to]);
156 		// Save this for an assertion in the future
157 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
158 		// Subtract from the sender
159 		balanceOf[_from] -= _value;
160 		// Add the same to the recipient
161 		balanceOf[_to] += _value;
162 		emit Transfer(_from, _to, _value);
163 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
164 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
165 	}
166 
167 	/**
168 	 * Transfer tokens
169 	 *
170 	 * Send `_value` tokens to `_to` from your account
171 	 *
172 	 * @param _to The address of the recipient
173 	 * @param _value the amount to send
174 	 */
175 	function transfer(address _to, uint256 _value) public returns (bool success) {
176 		_transfer(msg.sender, _to, _value);
177 		return true;
178 	}
179 
180 	/**
181 	 * Transfer tokens from other address
182 	 *
183 	 * Send `_value` tokens to `_to` in behalf of `_from`
184 	 *
185 	 * @param _from The address of the sender
186 	 * @param _to The address of the recipient
187 	 * @param _value the amount to send
188 	 */
189 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
190 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
191 		allowance[_from][msg.sender] -= _value;
192 		_transfer(_from, _to, _value);
193 		return true;
194 	}
195 
196 	/**
197 	 * Set allowance for other address
198 	 *
199 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
200 	 *
201 	 * @param _spender The address authorized to spend
202 	 * @param _value the max amount they can spend
203 	 */
204 	function approve(address _spender, uint256 _value) public returns (bool success) {
205 		allowance[msg.sender][_spender] = _value;
206 		emit Approval(msg.sender, _spender, _value);
207 		return true;
208 	}
209 
210 	/**
211 	 * Set allowance for other address and notify
212 	 *
213 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
214 	 *
215 	 * @param _spender The address authorized to spend
216 	 * @param _value the max amount they can spend
217 	 * @param _extraData some extra information to send to the approved contract
218 	 */
219 	function approveAndCall(address _spender, uint256 _value, bytes _extraData)
220 		public
221 		returns (bool success) {
222 		tokenRecipient spender = tokenRecipient(_spender);
223 		if (approve(_spender, _value)) {
224 			spender.receiveApproval(msg.sender, _value, this, _extraData);
225 			return true;
226 		}
227 	}
228 
229 	/**
230 	 * Destroy tokens
231 	 *
232 	 * Remove `_value` tokens from the system irreversibly
233 	 *
234 	 * @param _value the amount of money to burn
235 	 */
236 	function burn(uint256 _value) public returns (bool success) {
237 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
238 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
239 		totalSupply -= _value;                      // Updates totalSupply
240 		emit Burn(msg.sender, _value);
241 		return true;
242 	}
243 
244 	/**
245 	 * Destroy tokens from other account
246 	 *
247 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
248 	 *
249 	 * @param _from the address of the sender
250 	 * @param _value the amount of money to burn
251 	 */
252 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
253 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
254 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
255 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
256 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
257 		totalSupply -= _value;                              // Update totalSupply
258 		emit Burn(_from, _value);
259 		return true;
260 	}
261 }
262 
263 contract developed {
264 	address public developer;
265 
266 	/**
267 	 * Constructor
268 	 */
269 	constructor() public {
270 		developer = msg.sender;
271 	}
272 
273 	/**
274 	 * @dev Checks only developer address is calling
275 	 */
276 	modifier onlyDeveloper {
277 		require(msg.sender == developer);
278 		_;
279 	}
280 
281 	/**
282 	 * @dev Allows developer to switch developer address
283 	 * @param _developer The new developer address to be set
284 	 */
285 	function changeDeveloper(address _developer) public onlyDeveloper {
286 		developer = _developer;
287 	}
288 
289 	/**
290 	 * @dev Allows developer to withdraw ERC20 Token
291 	 */
292 	function withdrawToken(address tokenContractAddress) public onlyDeveloper {
293 		TokenERC20 _token = TokenERC20(tokenContractAddress);
294 		if (_token.balanceOf(this) > 0) {
295 			_token.transfer(developer, _token.balanceOf(this));
296 		}
297 	}
298 }
299 
300 
301 
302 contract escaped {
303 	address public escapeActivator;
304 
305 	/**
306 	 * Constructor
307 	 */
308 	constructor() public {
309 		escapeActivator = 0xB15C54b4B9819925Cd2A7eE3079544402Ac33cEe;
310 	}
311 
312 	/**
313 	 * @dev Checks only escapeActivator address is calling
314 	 */
315 	modifier onlyEscapeActivator {
316 		require(msg.sender == escapeActivator);
317 		_;
318 	}
319 
320 	/**
321 	 * @dev Allows escapeActivator to switch escapeActivator address
322 	 * @param _escapeActivator The new escapeActivator address to be set
323 	 */
324 	function changeAddress(address _escapeActivator) public onlyEscapeActivator {
325 		escapeActivator = _escapeActivator;
326 	}
327 }
328 
329 
330 
331 
332 
333 /**
334  * @title SpinLottery
335  */
336 contract SpinLottery is developed, escaped, LotteryInterface {
337 	using SafeMath for uint256;
338 
339 	/**
340 	 * @dev Game variables
341 	 */
342 	address public owner;
343 	address public spinwinAddress;
344 
345 	bool public contractKilled;
346 	bool public gamePaused;
347 
348 	uint256 public numLottery;
349 	uint256 public lotteryTarget;
350 	uint256 public totalBankroll;
351 	uint256 public totalBuyTickets;
352 	uint256 public totalTokenWagered;
353 	uint256 public lotteryTargetIncreasePercentage;
354 	uint256 public lastBlockNumber;
355 	uint256 public lastLotteryTotalBlocks;
356 
357 	uint256 public currentTicketMultiplier;
358 	uint256 public currentTicketMultiplierHonor;
359 	uint256 public currentTicketMultiplierBlockNumber;
360 
361 	uint256 public maxBlockSecurityCount;
362 	uint256 public blockSecurityCount;
363 	uint256 public currentTicketMultiplierBlockSecurityCount;
364 
365 	uint256 public ticketMultiplierModifier;
366 
367 	uint256 public avgLotteryHours; // Average hours needed to complete a lottery
368 	uint256 public totalLotteryHours; // Total accumulative lottery hours
369 	uint256 public minBankrollDecreaseRate; // The rate to use to decrease spinwin's min bankroll
370 	uint256 public minBankrollIncreaseRate; // The rate to use to increase spinwin's min bankroll
371 	uint256 public lotteryContributionPercentageModifier; // The lottery contribution percentage modifier, used to calculate lottery contribution percentage
372 	uint256 public rateConfidenceModifier; // The rate confidence modifier, used to calculate lottery contribution percentage
373 	uint256 public currentLotteryPaceModifier; // The current lottery pace modifier, used to calculate lottery contribution percentage
374 	uint256 public maxLotteryContributionPercentage; // The maximum percent that we can contribute to the lottery
375 
376 	uint256 constant public PERCENTAGE_DIVISOR = 1000000;
377 	uint256 constant public TWO_DECIMALS = 100; // To account for calculation with 2 decimal points
378 	uint256 constant public CURRENCY_DIVISOR = 10 ** 18;
379 
380 	uint256 public startLotteryRewardPercentage; // The percentage of blocks that we want to reward player for starting next lottery
381 	uint256 internal lotteryContribution;
382 	uint256 internal carryOverContribution;
383 	uint256 public minRewardBlocksAmount;
384 
385 	TokenInterface internal _spintoken;
386 	SettingInterface internal _setting;
387 
388 	struct Lottery {
389 		uint256 lotteryTarget;
390 		uint256 bankroll;
391 		uint256 tokenWagered;
392 		uint256 lotteryResult;
393 		uint256 totalBlocks;
394 		uint256 totalBlocksRewarded;
395 		uint256 startTimestamp;
396 		uint256 endTimestamp;
397 		address winnerPlayerAddress;
398 		bool ended;
399 		bool cashedOut;
400 	}
401 
402 	struct Ticket {
403 		bytes32 ticketId;
404 		uint256 numLottery;
405 		address playerAddress;
406 		uint256 minNumber;
407 		uint256 maxNumber;
408 		bool claimed;
409 	}
410 	mapping (uint256 => Lottery) public lotteries;
411 	mapping (bytes32 => Ticket) public tickets;
412 	mapping (uint256 => mapping (address => uint256)) public playerTokenWagered;
413 	mapping (address => uint256) public playerPendingWithdrawals;
414 	mapping (uint256 => mapping (address => uint256)) public playerTotalBlocks;
415 	mapping (uint256 => mapping (address => uint256)) public playerTotalBlocksRewarded;
416 
417 	/**
418 	 * @dev Log when new lottery is created
419 	 */
420 	event LogCreateLottery(uint256 indexed numLottery, uint256 lotteryBankrollGoal);
421 
422 	/**
423 	 * @dev Log when lottery is ended
424 	 */
425 	event LogEndLottery(uint256 indexed numLottery, uint256 lotteryResult);
426 
427 	/**
428 	 * @dev Log when spinwin adds some funds
429 	 */
430 	event LogAddBankRoll(uint256 indexed numLottery, uint256 amount);
431 
432 	/**
433 	 * @dev Log when player buys ticket
434 	 * Ticket type
435 	 * 1 = normal purchase
436 	 * 2 = Spinwin Reward
437 	 * 3 = Start Lottery Reward
438 	 */
439 	event LogBuyTicket(uint256 indexed numLottery, bytes32 indexed ticketId, address indexed playerAddress, uint256 tokenAmount, uint256 ticketMultiplier, uint256 minNumber, uint256 maxNumber, uint256 ticketType);
440 
441 	/**
442 	 * @dev Log when player claims lotto ticket
443 	 *
444 	 * Status:
445 	 * 0: Lose
446 	 * 1: Win
447 	 * 2: Win + Failed send
448 	 */
449 	event LogClaimTicket(uint256 indexed numLottery, bytes32 indexed ticketId, address indexed playerAddress, uint256 lotteryResult, uint256 playerMinNumber, uint256 playerMaxNumber, uint256 winningReward, uint256 status);
450 
451 	/**
452 	 * @dev Log when player withdraw balance
453 	 *
454 	 * Status:
455 	 * 0 = failed
456 	 * 1 = success
457 	 */
458 	event LogPlayerWithdrawBalance(address indexed playerAddress, uint256 withdrawAmount, uint256 status);
459 
460 	/**
461 	 * @dev Log when current ticket multiplier is updated
462 	 */
463 	event LogUpdateCurrentTicketMultiplier(uint256 currentTicketMultiplier, uint256 currentTicketMultiplierBlockNumber);
464 
465 	/**
466 	 * @dev Log when developer set contract to emergency mode
467 	 */
468 	event LogEscapeHatch();
469 
470 	/**
471 	 * Constructor
472 	 */
473 	constructor(address _settingAddress, address _tokenAddress, address _spinwinAddress) public {
474 		_setting = SettingInterface(_settingAddress);
475 		_spintoken = TokenInterface(_tokenAddress);
476 		spinwinAddress = _spinwinAddress;
477 		lastLotteryTotalBlocks = 100 * CURRENCY_DIVISOR;                // init last lottery total blocks (10^20 blocks)
478 		devSetLotteryTargetIncreasePercentage(150000);                  // init lottery target increase percentage (15%);
479 		devSetMaxBlockSecurityCount(256);                               // init max block security count (256)
480 		devSetBlockSecurityCount(3);                                    // init block security count (3)
481 		devSetCurrentTicketMultiplierBlockSecurityCount(3);             // init current ticket multiplier block security count (3)
482 		devSetTicketMultiplierModifier(300);                            // init ticket multiplier modifier (3)
483 		devSetMinBankrollDecreaseRate(80);                              // init min bankroll decrease rate (0.8)
484 		devSetMinBankrollIncreaseRate(170);                             // init min bankroll increase rate (1.7)
485 		devSetLotteryContributionPercentageModifier(10);                // init lottery contribution percentage modifier (0.1)
486 		devSetRateConfidenceModifier(200);                              // init rate confidence modifier (2)
487 		devSetCurrentLotteryPaceModifier(200);                          // init current lottery pace modifier (2)
488 		devSetStartLotteryRewardPercentage(10000);                      // init start lottery reward percentage (1%)
489 		devSetMinRewardBlocksAmount(1);                                 // init min reward blocks amount (1)
490 		devSetMaxLotteryContributionPercentage(100);                    // init max lottery contribution percentage (1)
491 		_createNewLottery();                                            // start lottery
492 	}
493 
494 	/**
495 	 * @dev Checks if the contract is currently alive
496 	 */
497 	modifier contractIsAlive {
498 		require(contractKilled == false);
499 		_;
500 	}
501 
502 	/**
503 	 * @dev Checks if the game is currently active
504 	 */
505 	modifier gameIsActive {
506 		require(gamePaused == false);
507 		_;
508 	}
509 
510 	/**
511 	 * @dev Checks only spinwin address is calling
512 	 */
513 	modifier onlySpinwin {
514 		require(msg.sender == spinwinAddress);
515 		_;
516 	}
517 
518 	/******************************************/
519 	/*       DEVELOPER ONLY METHODS           */
520 	/******************************************/
521 
522 	/**
523 	 * @dev Allows developer to set lotteryTarget
524 	 * @param _lotteryTarget The new lottery target value to be set
525 	 */
526 	function devSetLotteryTarget(uint256 _lotteryTarget) public onlyDeveloper {
527 		require (_lotteryTarget >= 0);
528 		lotteryTarget = _lotteryTarget;
529 		Lottery storage _lottery = lotteries[numLottery];
530 		_lottery.lotteryTarget = lotteryTarget;
531 	}
532 
533 	/**
534 	 * @dev Allows developer to set lottery target increase percentage
535 	 * @param _lotteryTargetIncreasePercentage The new value to be set
536 	 * 1% = 10000
537 	 */
538 	function devSetLotteryTargetIncreasePercentage(uint256 _lotteryTargetIncreasePercentage) public onlyDeveloper {
539 		lotteryTargetIncreasePercentage = _lotteryTargetIncreasePercentage;
540 	}
541 
542 	/**
543 	 * @dev Allows developer to set block security count
544 	 * @param _blockSecurityCount The new value to be set
545 	 */
546 	function devSetBlockSecurityCount(uint256 _blockSecurityCount) public onlyDeveloper {
547 		require (_blockSecurityCount > 0);
548 		blockSecurityCount = _blockSecurityCount;
549 	}
550 
551 	/**
552 	 * @dev Allows developer to set max block security count
553 	 * @param _maxBlockSecurityCount The new value to be set
554 	 */
555 	function devSetMaxBlockSecurityCount(uint256 _maxBlockSecurityCount) public onlyDeveloper {
556 		require (_maxBlockSecurityCount > 0);
557 		maxBlockSecurityCount = _maxBlockSecurityCount;
558 	}
559 
560 	/**
561 	 * @dev Allows developer to set current ticket multiplier block security count
562 	 * @param _currentTicketMultiplierBlockSecurityCount The new value to be set
563 	 */
564 	function devSetCurrentTicketMultiplierBlockSecurityCount(uint256 _currentTicketMultiplierBlockSecurityCount) public onlyDeveloper {
565 		require (_currentTicketMultiplierBlockSecurityCount > 0);
566 		currentTicketMultiplierBlockSecurityCount = _currentTicketMultiplierBlockSecurityCount;
567 	}
568 
569 	/**
570 	 * @dev Allows developer to set ticket multiplier modifier
571 	 * @param _ticketMultiplierModifier The new value to be set (in two decimals)
572 	 * 1 = 100
573 	 */
574 	function devSetTicketMultiplierModifier(uint256 _ticketMultiplierModifier) public onlyDeveloper {
575 		require (_ticketMultiplierModifier > 0);
576 		ticketMultiplierModifier = _ticketMultiplierModifier;
577 	}
578 
579 	/**
580 	 * @dev Allows developer to set min bankroll decrease rate
581 	 * @param _minBankrollDecreaseRate The new value to be set  (in two decimals)
582 	 * 1 = 100
583 	 */
584 	function devSetMinBankrollDecreaseRate(uint256 _minBankrollDecreaseRate) public onlyDeveloper {
585 		require (_minBankrollDecreaseRate >= 0);
586 		minBankrollDecreaseRate = _minBankrollDecreaseRate;
587 	}
588 
589 	/**
590 	 * @dev Allows developer to set min bankroll increase rate
591 	 * @param _minBankrollIncreaseRate The new value to be set  (in two decimals)
592 	 * 1 = 100
593 	 */
594 	function devSetMinBankrollIncreaseRate(uint256 _minBankrollIncreaseRate) public onlyDeveloper {
595 		require (_minBankrollIncreaseRate > minBankrollDecreaseRate);
596 		minBankrollIncreaseRate = _minBankrollIncreaseRate;
597 	}
598 
599 	/**
600 	 * @dev Allows developer to set lottery contribution percentage modifier
601 	 * @param _lotteryContributionPercentageModifier The new value to be set (in two decimals)
602 	 * 1 = 100
603 	 */
604 	function devSetLotteryContributionPercentageModifier(uint256 _lotteryContributionPercentageModifier) public onlyDeveloper {
605 		lotteryContributionPercentageModifier = _lotteryContributionPercentageModifier;
606 	}
607 
608 	/**
609 	 * @dev Allows developer to set rate confidence modifier
610 	 * @param _rateConfidenceModifier The new value to be set (in two decimals)
611 	 * 1 = 100
612 	 */
613 	function devSetRateConfidenceModifier(uint256 _rateConfidenceModifier) public onlyDeveloper {
614 		rateConfidenceModifier = _rateConfidenceModifier;
615 	}
616 
617 	/**
618 	 * @dev Allows developer to set current lottery pace modifier
619 	 * @param _currentLotteryPaceModifier The new value to be set (in two decimals)
620 	 * 1 = 100
621 	 */
622 	function devSetCurrentLotteryPaceModifier(uint256 _currentLotteryPaceModifier) public onlyDeveloper {
623 		currentLotteryPaceModifier = _currentLotteryPaceModifier;
624 	}
625 
626 	/**
627 	 * @dev Allows developer to pause the game
628 	 * @param paused The new paused value to be set
629 	 */
630 	function devPauseGame(bool paused) public onlyDeveloper {
631 		gamePaused = paused;
632 	}
633 
634 	/**
635 	 * @dev Allows developer to start new lottery (only when current lottery is ended)
636 	 * @return Return true if success
637 	 */
638 	function devStartLottery() public onlyDeveloper returns (bool) {
639 		Lottery memory _currentLottery = lotteries[numLottery];
640 		require (_currentLottery.ended == true);
641 		_createNewLottery();
642 		return true;
643 	}
644 
645 	/**
646 	 * @dev Allows developer to end current lottery
647 	 * @param _startNextLottery Boolean value whether or not we should start next lottery
648 	 * @return Return true if success
649 	 */
650 	function devEndLottery(bool _startNextLottery) public onlyDeveloper returns (bool) {
651 		_endLottery();
652 		if (_startNextLottery) {
653 			_createNewLottery();
654 		}
655 		return true;
656 	}
657 
658 	/**
659 	 * @dev Allows developer to set start lottery reward percentage
660 	 * @param _startLotteryRewardPercentage The new value to be set
661 	 * 1% = 10000
662 	 */
663 	function devSetStartLotteryRewardPercentage(uint256 _startLotteryRewardPercentage) public onlyDeveloper {
664 		startLotteryRewardPercentage = _startLotteryRewardPercentage;
665 	}
666 
667 	/**
668 	 * @dev Allows developer to set start lottery min reward blocks amount
669 	 * @param _minRewardBlocksAmount The new value to be set
670 	 */
671 	function devSetMinRewardBlocksAmount(uint256 _minRewardBlocksAmount) public onlyDeveloper {
672 		minRewardBlocksAmount = _minRewardBlocksAmount;
673 	}
674 
675 	/**
676 	 * @dev Allows developer to set max lottery contribution percentage
677 	 * @param _maxLotteryContributionPercentage The new value to be set
678 	 * 1 = 100
679 	 */
680 	function devSetMaxLotteryContributionPercentage(uint256 _maxLotteryContributionPercentage) public onlyDeveloper {
681 		maxLotteryContributionPercentage = _maxLotteryContributionPercentage;
682 	}
683 
684 	/******************************************/
685 	/*      ESCAPE ACTIVATOR ONLY METHODS     */
686 	/******************************************/
687 
688 	/**
689 	 * @dev Allows escapeActivator to trigger emergency mode. Will end current lottery and stop the game.
690 	 * @return Return true if success
691 	 */
692 	function escapeHatch() public
693 		onlyEscapeActivator
694 		contractIsAlive
695 		returns (bool) {
696 		contractKilled = true;
697 		_endLottery();
698 		emit LogEscapeHatch();
699 		return true;
700 	}
701 
702 	/******************************************/
703 	/*         SPINWIN ONLY METHODS           */
704 	/******************************************/
705 	/**
706 	 * @dev Allows spinwin to buy ticket on behalf of playerAddress as part of claiming spinwin reward
707 	 * @param playerAddress The player address to be rewarded
708 	 * @param tokenAmount The amount of token to be spent
709 	 * @return The ticket ID
710 	 */
711 	function claimReward(address playerAddress, uint256 tokenAmount) public
712 		contractIsAlive
713 		gameIsActive
714 		onlySpinwin
715 		returns (bool) {
716 		return _buyTicket(playerAddress, tokenAmount, 2);
717 	}
718 
719 	/******************************************/
720 	/*             PUBLIC METHODS             */
721 	/******************************************/
722 	/**
723 	 * @dev Add funds to the contract
724 	 * If the bankroll goal is reached, we want to end current lottery and start new lottery.
725 	 */
726 	function () payable public
727 		contractIsAlive
728 		gameIsActive {
729 		// Update the last block number
730 		lastBlockNumber = block.number;
731 
732 		Lottery storage _currentLottery = lotteries[numLottery];
733 		if (_currentLottery.bankroll.add(msg.value) > lotteryTarget) {
734 			lotteryContribution = lotteryTarget.sub(_currentLottery.bankroll);
735 			carryOverContribution = carryOverContribution.add(msg.value.sub(lotteryContribution));
736 		} else {
737 			lotteryContribution = msg.value;
738 		}
739 
740 		// Safely update bankroll
741 		if (lotteryContribution > 0) {
742 			_currentLottery.bankroll = _currentLottery.bankroll.add(lotteryContribution);
743 			totalBankroll = totalBankroll.add(lotteryContribution);
744 			emit LogAddBankRoll(numLottery, lotteryContribution);
745 		}
746 	}
747 
748 	/**
749 	 * @dev Player buys lottery ticket
750 	 * @param tokenAmount The amount of token to spend
751 	 * @return Return the ticket ID
752 	 */
753 	function buyTicket(uint tokenAmount) public
754 		contractIsAlive
755 		gameIsActive
756 		returns (bool) {
757 		require (_spintoken.burnAt(msg.sender, tokenAmount));
758 		return _buyTicket(msg.sender, tokenAmount, 1);
759 	}
760 
761 	/**
762 	 * @dev Player claims lottery ticket
763 	 * @param ticketId The ticket ID to be claimed
764 	 * @return Return true if success
765 	 */
766 	function claimTicket(bytes32 ticketId) public
767 		gameIsActive
768 		returns (bool) {
769 		Ticket storage _ticket = tickets[ticketId];
770 		require(_ticket.claimed == false && _ticket.playerAddress == msg.sender);
771 
772 		Lottery storage _lottery = lotteries[_ticket.numLottery];
773 		require(_lottery.ended == true && _lottery.cashedOut == false && _lottery.bankroll > 0 && _lottery.totalBlocks.add(_lottery.totalBlocksRewarded) > 0 && _lottery.lotteryResult > 0);
774 
775 		// Mark this ticket as claimed
776 		_ticket.claimed = true;
777 		uint256 status = 0; // status = failed
778 		if (_lottery.lotteryResult >= _ticket.minNumber && _lottery.lotteryResult <= _ticket.maxNumber) {
779 			uint256 lotteryReward = _lottery.bankroll;
780 
781 			// Check if contract has enough bankroll to payout
782 			require(totalBankroll >= lotteryReward);
783 
784 			// Safely adjust totalBankroll
785 			totalBankroll = totalBankroll.sub(lotteryReward);
786 
787 			_lottery.bankroll = 0;
788 			_lottery.winnerPlayerAddress = msg.sender;
789 			_lottery.cashedOut = true;
790 
791 
792 			if (!msg.sender.send(lotteryReward)) {
793 				status = 2; // status = win + failed send
794 				// If send failed, let player withdraw via playerWithdrawPendingTransactions
795 				playerPendingWithdrawals[msg.sender] = playerPendingWithdrawals[msg.sender].add(lotteryReward);
796 			} else {
797 				status = 1; // status = win
798 			}
799 		}
800 		emit LogClaimTicket(_ticket.numLottery, ticketId, msg.sender, _lottery.lotteryResult, _ticket.minNumber, _ticket.maxNumber, lotteryReward, status);
801 		return true;
802 	}
803 
804 	/**
805 	 * @dev Allows player to withdraw balance in case of a failed win send
806 	 * @return Return true if success
807 	 */
808 	function playerWithdrawPendingTransactions() public
809 		gameIsActive {
810 		require(playerPendingWithdrawals[msg.sender] > 0);
811 		uint256 withdrawAmount = playerPendingWithdrawals[msg.sender];
812 
813 		playerPendingWithdrawals[msg.sender] = 0;
814 
815 		// External call to untrusted contract
816 		uint256 status = 1; // status = success
817 		if (!msg.sender.send(withdrawAmount)) {
818 			status = 0; // status = failed
819 
820 			/*
821 			 * If send failed, revert playerPendingWithdrawals[msg.sender] = 0
822 			 * so that player can try to withdraw again later
823 			 */
824 			playerPendingWithdrawals[msg.sender] = withdrawAmount;
825 		}
826 		emit LogPlayerWithdrawBalance(msg.sender, withdrawAmount, status);
827 	}
828 
829 	/**
830 	 * @dev Calculates number of blocks the player will get when he/she buys the lottery ticket
831 	 *      based on player's entered token amount and current multiplier honor
832 	 * @return ticketMultiplier The ticket multiplier during this transaction
833 	 * @return numBlocks The lotto block count for this ticket
834 	 */
835 	function calculateNumBlocks(uint256 tokenAmount) public constant returns (uint256 ticketMultiplier, uint256 numBlocks) {
836 		return (currentTicketMultiplierHonor, currentTicketMultiplierHonor.mul(tokenAmount).div(TWO_DECIMALS));
837 	}
838 
839 	/**
840 	 * @dev Get current num lottery
841 	 * @return Current num lottery
842 	 */
843 	function getNumLottery() public constant returns (uint256) {
844 		return numLottery;
845 	}
846 
847 	/**
848 	 * @dev Check if contract is active
849 	 * @return Current state of contract
850 	 */
851 	function isActive() public constant returns (bool) {
852 		if (gamePaused == true || contractKilled == true) {
853 			return false;
854 		} else {
855 			return true;
856 		}
857 	}
858 
859 	/**
860 	 * @dev Determines the lottery contribution percentage
861 	 * @return lotteryContributionPercentage (in two decimals)
862 	 */
863 	function calculateLotteryContributionPercentage() public
864 		contractIsAlive
865 		gameIsActive
866 		constant returns (uint256) {
867 		Lottery memory _currentLottery = lotteries[numLottery];
868 		uint256 currentTotalLotteryHours = _getHoursBetween(_currentLottery.startTimestamp, now);
869 
870 		uint256 currentWeiToLotteryRate = 0;
871 		// To prevent division by 0
872 		if (currentTotalLotteryHours > 0) {
873 			/*
874 			 * currentWeiToLotteryRate = _currentLottery.bankroll / currentTotalLotteryHours;
875 			 * But since we need to account for decimal points
876 			 * currentWeiToLotteryRate = (_currentLottery.bankroll * TWO_DECIMALS)/currentTotalLotteryHours;
877 			 * currentWeiToLotteryRate needs to be divided by TWO_DECIMALS later on
878 			 */
879 			currentWeiToLotteryRate = (_currentLottery.bankroll.mul(TWO_DECIMALS)).div(currentTotalLotteryHours);
880 		}
881 
882 		uint256 predictedCurrentLotteryHours = currentTotalLotteryHours;
883 		// To prevent division by 0
884 		if (currentWeiToLotteryRate > 0) {
885 			/*
886 			 * predictedCurrentLotteryHours = currentTotalLotteryHours + ((lotteryTarget - _currentLottery.bankroll)/currentWeiToLotteryRate);
887 			 * Let temp = (lotteryTarget - _currentLottery.bankroll)/currentWeiToLotteryRate;
888 			 * Since we need to account for decimal points
889 			 * temp = ((lotteryTarget - _currentLottery.bankroll)*TWO_DECIMALS)/currentWeiToLotteryRate;
890 			 * But currentWeiToLotteryRate is already in decimals
891 			 * temp = ((lotteryTarget - _currentLottery.bankroll)*TWO_DECIMALS)/(currentWeiToLotteryRate/TWO_DECIMALS);
892 			 * temp = ((lotteryTarget - _currentLottery.bankroll)*TWO_DECIMALS*TWO_DECIMALS)/currentWeiToLotteryRate;
893 			 * predictedCurrentLotteryHours = currentTotalLotteryHours + (temp/TWO_DECIMALS);
894 			 */
895 			uint256 temp = (lotteryTarget.sub(_currentLottery.bankroll)).mul(TWO_DECIMALS).mul(TWO_DECIMALS).div(currentWeiToLotteryRate);
896 			predictedCurrentLotteryHours = currentTotalLotteryHours.add(temp.div(TWO_DECIMALS));
897 		}
898 
899 		uint256 currentLotteryPace = 0;
900 		// To prevent division by 0
901 		if (avgLotteryHours > 0) {
902 			/*
903 			 * currentLotteryPace = predictedCurrentLotteryHours/avgLotteryHours;
904 			 * But since we need to account for decimal points
905 			 * currentLotteryPace = (predictedCurrentLotteryHours*TWO_DECIMALS)/avgLotteryHours;
906 			 * But avgLotteryHours is already in decimals so we need to divide it by TWO_DECIMALS as well
907 			 * currentLotteryPace = (predictedCurrentLotteryHours*TWO_DECIMALS)/(avgLotteryHours/TWO_DECIMALS);
908 			 * OR
909 			 * currentLotteryPace = (predictedCurrentLotteryHours*TWO_DECIMALS*TWO_DECIMALS)/avgLotteryHours;
910 			 * currentLotteryPace needs to be divided by TWO_DECIMALS later on
911 			 */
912 			currentLotteryPace = (predictedCurrentLotteryHours.mul(TWO_DECIMALS).mul(TWO_DECIMALS)).div(avgLotteryHours);
913 		}
914 
915 		uint256 percentageOverTarget = 0;
916 		// To prevent division by 0
917 		if (_setting.uintSettings('minBankroll') > 0) {
918 			/*
919 			 * percentageOverTarget = _spinwin.contractBalance() / _spinwin.minBankroll();
920 			 * But since we need to account for decimal points
921 			 * percentageOverTarget = (_spinwin.contractBalance()*TWO_DECIMALS) / _spinwin.minBankroll();
922 			 * percentageOverTarget needs to be divided by TWO_DECIMALS later on
923 			 */
924 			percentageOverTarget = (_setting.uintSettings('contractBalance').mul(TWO_DECIMALS)).div(_setting.uintSettings('minBankroll'));
925 		}
926 
927 		currentTotalLotteryHours = currentTotalLotteryHours.mul(TWO_DECIMALS); // So that it has two decimals
928 		uint256 rateConfidence = 0;
929 		// To prevent division by 0
930 		if (avgLotteryHours.add(currentTotalLotteryHours) > 0) {
931 			/*
932 			 * rateConfidence = currentTotalLotteryHours / (avgLotteryHours + currentTotalLotteryHours);
933 			 * But since we need to account for decimal points
934 			 * rateConfidence = (currentTotalLotteryHours*TWO_DECIMALS) / (avgLotteryHours + currentTotalLotteryHours);
935 			 * rateConfidence needs to be divided by TWO_DECIMALS later on
936 			 */
937 			rateConfidence = currentTotalLotteryHours.mul(TWO_DECIMALS).div(avgLotteryHours.add(currentTotalLotteryHours));
938 		}
939 
940 		/*
941 		 * lotteryContributionPercentage = 0.1 + (1-(1/percentageOverTarget))+(rateConfidence*2*(currentLotteryPace/(currentLotteryPace+2)))
942 		 * Replace the static number with modifier variables (that are already in decimals, so 0.1 is actually 10, 2 is actually 200)
943 		 * lotteryContributionPercentage = lotteryContributionPercentageModifier + (1-(1/percentageOverTarget)) + (rateConfidence*rateConfidenceModifier*(currentLotteryPace/(currentLotteryPace+currentLotteryPaceModifier)));
944 		 *
945 		 * Split to 3 sections
946 		 * lotteryContributionPercentage = calc1 + calc2 + calc3
947 		 * calc1 = lotteryContributionPercentageModifier
948 		 * calc2 = (1-(1/percentageOverTarget))
949 		 * calc3 = (rateConfidence*rateConfidenceModifier*(currentLotteryPace/(currentLotteryPace+currentLotteryPaceModifier)))
950 		 */
951 		uint256 lotteryContributionPercentage = lotteryContributionPercentageModifier;
952 
953 		/*
954 		 * calc2 = 1-(1/percentageOverTarget)
955 		 * Since percentageOverTarget is already in two decimals
956 		 * calc2 = 1-(1/(percentageOverTarget/TWO_DECIMALS))
957 		 * calc2 = 1-(TWO_DECIMALS/percentageOverTarget)
958 		 * mult TWO_DECIMALS/TWO_DECIMALS to calculate fraction
959 		 * calc2 = (TWO_DECIMALS-((TWO_DECIMALS*TWO_DECIMALS)/percentageOverTarget))/TWO_DECIMALS
960 		 * since lotteryContributionPercentage needs to be in decimals, we can take out the division by TWO_DECIMALS
961 		 * calc2 = TWO_DECIMALS-((TWO_DECIMALS*TWO_DECIMALS)/percentageOverTarget)
962 		 */
963 		// To prevent division by 0
964 		if (percentageOverTarget > 0) {
965 			lotteryContributionPercentage = lotteryContributionPercentage.add(TWO_DECIMALS.sub((TWO_DECIMALS.mul(TWO_DECIMALS)).div(percentageOverTarget)));
966 		} else {
967 			lotteryContributionPercentage = lotteryContributionPercentage.add(TWO_DECIMALS);
968 		}
969 
970 		/*
971 		 * calc3 = rateConfidence*rateConfidenceModifier*(currentLotteryPace/(currentLotteryPace+currentLotteryPaceModifier))
972 		 * But since rateConfidence, rateConfidenceModifier are already in decimals, we need to divide them by TWO_DECIMALS
973 		 * calc3 = (rateConfidence/TWO_DECIMALS)*(rateConfidenceModifier/TWO_DECIMALS)*(currentLotteryPace/(currentLotteryPace+currentLotteryPaceModifier))
974 		 * since we need to account for decimal points, mult the numerator `currentLotteryPace` with TWO_DECIMALS
975 		 * calc3 = (rateConfidence/TWO_DECIMALS)*(rateConfidenceModifier/TWO_DECIMALS)*((currentLotteryPace*TWO_DECIMALS)/(currentLotteryPace+currentLotteryPaceModifier))
976 		 * OR
977 		 * calc3 = (rateConfidence*rateConfidenceModifier*currentLotteryPace)/(TWO_DECIMALS*(currentLotteryPace+currentLotteryPaceModifier))
978 		 */
979 		// To prevent division by 0
980 		if (currentLotteryPace.add(currentLotteryPaceModifier) > 0) {
981 			lotteryContributionPercentage = lotteryContributionPercentage.add((rateConfidence.mul(rateConfidenceModifier).mul(currentLotteryPace)).div(TWO_DECIMALS.mul(currentLotteryPace.add(currentLotteryPaceModifier))));
982 		}
983 		if (lotteryContributionPercentage > maxLotteryContributionPercentage) {
984 			lotteryContributionPercentage = maxLotteryContributionPercentage;
985 		}
986 		return lotteryContributionPercentage;
987 	}
988 
989 	/**
990 	 * @dev Allows player to start next lottery and reward player a percentage of last lottery total blocks
991 	 */
992 	function startNextLottery() public
993 		contractIsAlive
994 		gameIsActive {
995 		Lottery storage _currentLottery = lotteries[numLottery];
996 		require (_currentLottery.bankroll >= lotteryTarget && _currentLottery.totalBlocks.add(_currentLottery.totalBlocksRewarded) > 0);
997 		uint256 startLotteryRewardBlocks = calculateStartLotteryRewardBlocks();
998 		_endLottery();
999 		_createNewLottery();
1000 
1001 		// If we have carry over contribution from prev contribution
1002 		// add it to the next lottery
1003 		if (carryOverContribution > 0) {
1004 			_currentLottery = lotteries[numLottery];
1005 			if (_currentLottery.bankroll.add(carryOverContribution) > lotteryTarget) {
1006 				lotteryContribution = lotteryTarget.sub(_currentLottery.bankroll);
1007 				carryOverContribution = carryOverContribution.sub(lotteryContribution);
1008 			} else {
1009 				lotteryContribution = carryOverContribution;
1010 				carryOverContribution = 0;
1011 			}
1012 
1013 			// Safely update bankroll
1014 			_currentLottery.bankroll = _currentLottery.bankroll.add(lotteryContribution);
1015 			totalBankroll = totalBankroll.add(lotteryContribution);
1016 			emit LogAddBankRoll(numLottery, lotteryContribution);
1017 		}
1018 		_buyTicket(msg.sender, startLotteryRewardBlocks, 3);
1019 	}
1020 
1021 	/**
1022 	 * @dev Calculate start lottery reward blocks amount
1023 	 * @return The reward blocks amount
1024 	 */
1025 	function calculateStartLotteryRewardBlocks() public constant returns (uint256) {
1026 		uint256 totalRewardBlocks = lastLotteryTotalBlocks.mul(startLotteryRewardPercentage).div(PERCENTAGE_DIVISOR);
1027 		if (totalRewardBlocks == 0) {
1028 			totalRewardBlocks = minRewardBlocksAmount;
1029 		}
1030 		return totalRewardBlocks;
1031 	}
1032 
1033 	/**
1034 	 * @dev Get current ticket multiplier honor
1035 	 * @return Current ticket multiplier honor
1036 	 */
1037 	function getCurrentTicketMultiplierHonor() public constant returns (uint256) {
1038 		return currentTicketMultiplierHonor;
1039 	}
1040 
1041 	/**
1042 	 * @dev Get current lottery target and bankroll
1043 	 * @return Current lottery target
1044 	 * @return Current lottery bankroll
1045 	 */
1046 	function getCurrentLotteryTargetBalance() public constant returns (uint256, uint256) {
1047 		Lottery memory _lottery = lotteries[numLottery];
1048 		return (_lottery.lotteryTarget, _lottery.bankroll);
1049 	}
1050 
1051 	/*****************************************/
1052 	/*          INTERNAL METHODS              */
1053 	/******************************************/
1054 
1055 	/**
1056 	 * @dev Creates new lottery
1057 	 */
1058 	function _createNewLottery() internal returns (bool) {
1059 		numLottery++;
1060 		lotteryTarget = _setting.uintSettings('minBankroll').add(_setting.uintSettings('minBankroll').mul(lotteryTargetIncreasePercentage).div(PERCENTAGE_DIVISOR));
1061 		Lottery storage _lottery = lotteries[numLottery];
1062 		_lottery.lotteryTarget = lotteryTarget;
1063 		_lottery.startTimestamp = now;
1064 		_updateCurrentTicketMultiplier();
1065 		emit LogCreateLottery(numLottery, lotteryTarget);
1066 		return true;
1067 	}
1068 
1069 	/**
1070 	 * @dev Ends current lottery
1071 	 */
1072 	function _endLottery() internal returns (bool) {
1073 		Lottery storage _currentLottery = lotteries[numLottery];
1074 		require (_currentLottery.totalBlocks.add(_currentLottery.totalBlocksRewarded) > 0);
1075 
1076 		uint256 blockNumberDifference = block.number - lastBlockNumber;
1077 		uint256 targetBlockNumber = 0;
1078 		if (blockNumberDifference < maxBlockSecurityCount.sub(blockSecurityCount)) {
1079 			targetBlockNumber = lastBlockNumber.add(blockSecurityCount);
1080 		} else {
1081 			targetBlockNumber = lastBlockNumber.add(maxBlockSecurityCount.mul(blockNumberDifference.div(maxBlockSecurityCount))).add(blockSecurityCount);
1082 		}
1083 		_currentLottery.lotteryResult = _generateRandomNumber(_currentLottery.totalBlocks.add(_currentLottery.totalBlocksRewarded), targetBlockNumber);
1084 
1085 		// If contract is killed, we don't want any leftover eth sits in the contract
1086 		// Add the carry over contribution to current lottery
1087 		if (contractKilled == true && carryOverContribution > 0) {
1088 			lotteryTarget = lotteryTarget.add(carryOverContribution);
1089 			_currentLottery.lotteryTarget = lotteryTarget;
1090 			_currentLottery.bankroll = _currentLottery.bankroll.add(carryOverContribution);
1091 			totalBankroll = totalBankroll.add(carryOverContribution);
1092 			emit LogAddBankRoll(numLottery, carryOverContribution);
1093 		}
1094 		_currentLottery.endTimestamp = now;
1095 		_currentLottery.ended = true;
1096 		uint256 endingLotteryHours = _getHoursBetween(_currentLottery.startTimestamp, now);
1097 		totalLotteryHours = totalLotteryHours.add(endingLotteryHours);
1098 
1099 		/*
1100 		 * avgLotteryHours = totalLotteryHours/numLottery
1101 		 * But since we are doing division in integer, needs to account for the decimal points
1102 		 * avgLotteryHours = totalLotteryHours * TWO_DECIMALS / numLottery; // TWO_DECIMALS = 100
1103 		 * avgLotteryHours needs to be divided by TWO_DECIMALS again later on
1104 		 */
1105 		avgLotteryHours = totalLotteryHours.mul(TWO_DECIMALS).div(numLottery);
1106 		lastLotteryTotalBlocks = _currentLottery.totalBlocks.add(_currentLottery.totalBlocksRewarded);
1107 
1108 		// Update spinwin's min bankroll
1109 		if (_setting.boolSettings('contractKilled') == false && _setting.boolSettings('gamePaused') == false) {
1110 			uint256 lotteryPace = 0;
1111 			if (endingLotteryHours > 0) {
1112 				/*
1113 				 * lotteryPace = avgLotteryHours/endingLotteryHours
1114 				 * Mult avgLotteryHours with TWO_DECIMALS to account for two decimal points
1115 				 * lotteryPace = (avgLotteryHours * TWO_DECIMALS) / endingLotteryHours
1116 				 * But from previous calculation, we already know that avgLotteryHours is already in decimals
1117 				 * So, lotteryPace = ((avgLotteryHours*TWO_DECIMALS)/endingLotteryHours)/TWO_DECIMALS
1118 				 * lotteryPace needs to be divided by TWO_DECIMALS again later on
1119 				 */
1120 				lotteryPace = avgLotteryHours.mul(TWO_DECIMALS).div(endingLotteryHours).div(TWO_DECIMALS);
1121 			}
1122 
1123 			uint256 newMinBankroll = 0;
1124 			if (lotteryPace <= minBankrollDecreaseRate) {
1125 				// If the pace is too slow, then we want to decrease spinwin min bankroll
1126 				newMinBankroll = _setting.uintSettings('minBankroll').mul(minBankrollDecreaseRate).div(TWO_DECIMALS);
1127 			} else if (lotteryPace <= minBankrollIncreaseRate) {
1128 				// If the pace is too fast, then we want to increase spinwin min bankroll
1129 				newMinBankroll = _setting.uintSettings('minBankroll').mul(minBankrollIncreaseRate).div(TWO_DECIMALS);
1130 			} else {
1131 				// Otherwise, set new min bankroll according to the lottery pace
1132 				newMinBankroll = _setting.uintSettings('minBankroll').mul(lotteryPace).div(TWO_DECIMALS);
1133 			}
1134 			_setting.spinlotterySetMinBankroll(newMinBankroll);
1135 		}
1136 
1137 		emit LogEndLottery(numLottery, _currentLottery.lotteryResult);
1138 	}
1139 
1140 	/**
1141 	 * @dev Buys ticket
1142 	 * @param _playerAddress The player address that buys this ticket
1143 	 * @param _tokenAmount The amount of SPIN token to spend
1144 	 * @param _ticketType Is this a normal purchase / part of spinwin's reward program / start lottery reward?
1145 	 * 1 = normal purchase
1146 	 * 2 = spinwin reward
1147 	 * 3 = start lottery reward
1148 	 * @return Return true if success
1149 	 */
1150 	function _buyTicket(address _playerAddress, uint256 _tokenAmount, uint256 _ticketType) internal returns (bool) {
1151 		require (_ticketType >=1 && _ticketType <= 3);
1152 		totalBuyTickets++;
1153 		Lottery storage _currentLottery = lotteries[numLottery];
1154 
1155 		if (_ticketType > 1) {
1156 			uint256 _ticketMultiplier = TWO_DECIMALS; // Ticket multiplier is 1
1157 			uint256 _numBlocks = _tokenAmount;
1158 			_tokenAmount = 0;  // Set token amount to 0 since we are not charging player any SPIN
1159 		} else {
1160 			_currentLottery.tokenWagered = _currentLottery.tokenWagered.add(_tokenAmount);
1161 			totalTokenWagered = totalTokenWagered.add(_tokenAmount);
1162 			(_ticketMultiplier, _numBlocks) = calculateNumBlocks(_tokenAmount);
1163 		}
1164 
1165 		// Generate ticketId
1166 		bytes32 _ticketId = keccak256(abi.encodePacked(this, _playerAddress, numLottery, totalBuyTickets));
1167 		Ticket storage _ticket = tickets[_ticketId];
1168 		_ticket.ticketId = _ticketId;
1169 		_ticket.numLottery = numLottery;
1170 		_ticket.playerAddress = _playerAddress;
1171 		_ticket.minNumber = _currentLottery.totalBlocks.add(_currentLottery.totalBlocksRewarded).add(1);
1172 		_ticket.maxNumber = _currentLottery.totalBlocks.add(_currentLottery.totalBlocksRewarded).add(_numBlocks);
1173 
1174 		playerTokenWagered[numLottery][_playerAddress] = playerTokenWagered[numLottery][_playerAddress].add(_tokenAmount);
1175 		if (_ticketType > 1) {
1176 			_currentLottery.totalBlocksRewarded = _currentLottery.totalBlocksRewarded.add(_numBlocks);
1177 			playerTotalBlocksRewarded[numLottery][_playerAddress] = playerTotalBlocksRewarded[numLottery][_playerAddress].add(_numBlocks);
1178 		} else {
1179 			_currentLottery.totalBlocks = _currentLottery.totalBlocks.add(_numBlocks);
1180 			playerTotalBlocks[numLottery][_playerAddress] = playerTotalBlocks[numLottery][_playerAddress].add(_numBlocks);
1181 		}
1182 
1183 		emit LogBuyTicket(numLottery, _ticket.ticketId, _ticket.playerAddress, _tokenAmount, _ticketMultiplier, _ticket.minNumber, _ticket.maxNumber, _ticketType);
1184 
1185 		// Safely update current ticket multiplier
1186 		_updateCurrentTicketMultiplier();
1187 
1188 		// Call spinwin update token to wei exchange rate
1189 		_setting.spinlotteryUpdateTokenToWeiExchangeRate();
1190 		return true;
1191 	}
1192 
1193 	/**
1194 	 * @dev Updates current ticket multiplier
1195 	 */
1196 	function _updateCurrentTicketMultiplier() internal returns (bool) {
1197 		// Safely update current ticket multiplier
1198 		Lottery memory _currentLottery = lotteries[numLottery];
1199 		if (lastLotteryTotalBlocks > _currentLottery.totalBlocks.add(_currentLottery.totalBlocksRewarded)) {
1200 			/*
1201 			 * currentTicketMultiplier = 1 + (ticketMultiplierModifier * ((lastLotteryTotalBlocks-currentLotteryBlocks)/lastLotteryTotalBlocks))
1202 			 * Since we are calculating in decimals so 1 is actually 100 or TWO_DECIMALS
1203 			 * currentTicketMultiplier = TWO_DECIMALS + (ticketMultiplierModifier * ((lastLotteryTotalBlocks-currentLotteryBlocks)/lastLotteryTotalBlocks))
1204 			 * Let temp = (lastLotteryTotalBlocks-currentLotteryBlocks)/lastLotteryTotalBlocks
1205 			 * To account for decimal points, we mult (lastLotteryTotalBlocks-currentLotteryBlocks) with TWO_DECIMALS
1206 			 * temp = ((lastLotteryTotalBlocks-currentLotteryBlocks)*TWO_DECIMALS)/lastLotteryTotalBlocks
1207 			 * We need to divide temp with TWO_DECIMALS later
1208 			 *
1209 			 * currentTicketMultiplier = TWO_DECIMALS + ((ticketMultiplierModifier * temp)/TWO_DECIMALS);
1210 			 */
1211 			uint256 temp = (lastLotteryTotalBlocks.sub(_currentLottery.totalBlocks.add(_currentLottery.totalBlocksRewarded))).mul(TWO_DECIMALS).div(lastLotteryTotalBlocks);
1212 			currentTicketMultiplier = TWO_DECIMALS.add(ticketMultiplierModifier.mul(temp).div(TWO_DECIMALS));
1213 		} else {
1214 			currentTicketMultiplier = TWO_DECIMALS;
1215 		}
1216 		if (block.number > currentTicketMultiplierBlockNumber.add(currentTicketMultiplierBlockSecurityCount) || _currentLottery.tokenWagered == 0) {
1217 			currentTicketMultiplierHonor = currentTicketMultiplier;
1218 			currentTicketMultiplierBlockNumber = block.number;
1219 			emit LogUpdateCurrentTicketMultiplier(currentTicketMultiplierHonor, currentTicketMultiplierBlockNumber);
1220 		}
1221 		return true;
1222 	}
1223 
1224 	/**
1225 	 * @dev Generates random number between 1 to maxNumber based on targetBlockNumber
1226 	 * @return The random number integer between 1 to maxNumber
1227 	 */
1228 	function _generateRandomNumber(uint256 maxNumber, uint256 targetBlockNumber) internal constant returns (uint256) {
1229 		uint256 randomNumber = 0;
1230 		for (uint256 i = 1; i < blockSecurityCount; i++) {
1231 			randomNumber = ((uint256(keccak256(abi.encodePacked(randomNumber, blockhash(targetBlockNumber-i), numLottery + totalBuyTickets + totalTokenWagered))) % maxNumber)+1);
1232 		}
1233 		return randomNumber;
1234 	}
1235 
1236 	/**
1237 	 * @dev Get hours between two timestamp
1238 	 * @param _startTimestamp Starting timestamp
1239 	 * @param _endTimestamp End timestamp
1240 	 * @return Hours in between starting and ending timestamp
1241 	 */
1242 	function _getHoursBetween(uint256 _startTimestamp, uint256 _endTimestamp) internal pure returns (uint256) {
1243 		uint256 _timestampDiff = _endTimestamp.sub(_startTimestamp);
1244 
1245 		uint256 _hours = 0;
1246 		while(_timestampDiff >= 3600) {
1247 			_timestampDiff -= 3600;
1248 			_hours++;
1249 		}
1250 		return _hours;
1251 	}
1252 }