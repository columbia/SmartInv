1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SpinWinInterface
5  */
6 interface SpinWinInterface {
7 	function refundPendingBets() external returns (bool);
8 }
9 
10 
11 /**
12  * @title AdvertisingInterface
13  */
14 interface AdvertisingInterface {
15 	function incrementBetCounter() external returns (bool);
16 }
17 
18 
19 contract SpinWinLibraryInterface {
20 	function calculateWinningReward(uint256 betValue, uint256 playerNumber, uint256 houseEdge) external pure returns (uint256);
21 	function calculateTokenReward(address settingAddress, uint256 betValue, uint256 playerNumber, uint256 houseEdge) external constant returns (uint256);
22 	function generateRandomNumber(address settingAddress, uint256 betBlockNumber, uint256 extraData, uint256 divisor) external constant returns (uint256);
23 	function calculateClearBetBlocksReward(address settingAddress, address lotteryAddress) external constant returns (uint256);
24 	function calculateLotteryContribution(address settingAddress, address lotteryAddress, uint256 betValue) external constant returns (uint256);
25 	function calculateExchangeTokenValue(address settingAddress, uint256 tokenAmount) external constant returns (uint256, uint256, uint256, uint256);
26 }
27 
28 
29 /**
30  * @title LotteryInterface
31  */
32 interface LotteryInterface {
33 	function claimReward(address playerAddress, uint256 tokenAmount) external returns (bool);
34 	function calculateLotteryContributionPercentage() external constant returns (uint256);
35 	function getNumLottery() external constant returns (uint256);
36 	function isActive() external constant returns (bool);
37 	function getCurrentTicketMultiplierHonor() external constant returns (uint256);
38 	function getCurrentLotteryTargetBalance() external constant returns (uint256, uint256);
39 }
40 
41 
42 /**
43  * @title SettingInterface
44  */
45 interface SettingInterface {
46 	function uintSettings(bytes32 name) external constant returns (uint256);
47 	function boolSettings(bytes32 name) external constant returns (bool);
48 	function isActive() external constant returns (bool);
49 	function canBet(uint256 rewardValue, uint256 betValue, uint256 playerNumber, uint256 houseEdge) external constant returns (bool);
50 	function isExchangeAllowed(address playerAddress, uint256 tokenAmount) external constant returns (bool);
51 
52 	/******************************************/
53 	/*          SPINWIN ONLY METHODS          */
54 	/******************************************/
55 	function spinwinSetUintSetting(bytes32 name, uint256 value) external;
56 	function spinwinIncrementUintSetting(bytes32 name) external;
57 	function spinwinSetBoolSetting(bytes32 name, bool value) external;
58 	function spinwinAddFunds(uint256 amount) external;
59 	function spinwinUpdateTokenToWeiExchangeRate() external;
60 	function spinwinRollDice(uint256 betValue) external;
61 	function spinwinUpdateWinMetric(uint256 playerProfit) external;
62 	function spinwinUpdateLoseMetric(uint256 betValue, uint256 tokenRewardValue) external;
63 	function spinwinUpdateLotteryContributionMetric(uint256 lotteryContribution) external;
64 	function spinwinUpdateExchangeMetric(uint256 exchangeAmount) external;
65 
66 	/******************************************/
67 	/*      SPINLOTTERY ONLY METHODS          */
68 	/******************************************/
69 	function spinlotterySetUintSetting(bytes32 name, uint256 value) external;
70 	function spinlotteryIncrementUintSetting(bytes32 name) external;
71 	function spinlotterySetBoolSetting(bytes32 name, bool value) external;
72 	function spinlotteryUpdateTokenToWeiExchangeRate() external;
73 	function spinlotterySetMinBankroll(uint256 _minBankroll) external returns (bool);
74 }
75 
76 
77 /**
78  * @title TokenInterface
79  */
80 interface TokenInterface {
81 	function getTotalSupply() external constant returns (uint256);
82 	function getBalanceOf(address account) external constant returns (uint256);
83 	function transfer(address _to, uint256 _value) external returns (bool);
84 	function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
85 	function approve(address _spender, uint256 _value) external returns (bool success);
86 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) external returns (bool success);
87 	function burn(uint256 _value) external returns (bool success);
88 	function burnFrom(address _from, uint256 _value) external returns (bool success);
89 	function mintTransfer(address _to, uint _value) external returns (bool);
90 	function burnAt(address _at, uint _value) external returns (bool);
91 }
92 
93 
94 
95 
96 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
97 
98 /**
99  * @title SafeMath
100  * @dev Math operations with safety checks that throw on error
101  */
102 library SafeMath {
103 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104 		if (a == 0) {
105 			return 0;
106 		}
107 		uint256 c = a * b;
108 		assert(c / a == b);
109 		return c;
110 	}
111 
112 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
113 		// assert(b > 0); // Solidity automatically throws when dividing by 0
114 		uint256 c = a / b;
115 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
116 		return c;
117 	}
118 
119 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120 		assert(b <= a);
121 		return a - b;
122 	}
123 
124 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
125 		uint256 c = a + b;
126 		assert(c >= a);
127 		return c;
128 	}
129 }
130 
131 
132 
133 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
134 
135 contract TokenERC20 {
136 	// Public variables of the token
137 	string public name;
138 	string public symbol;
139 	uint8 public decimals = 18;
140 	// 18 decimals is the strongly suggested default, avoid changing it
141 	uint256 public totalSupply;
142 
143 	// This creates an array with all balances
144 	mapping (address => uint256) public balanceOf;
145 	mapping (address => mapping (address => uint256)) public allowance;
146 
147 	// This generates a public event on the blockchain that will notify clients
148 	event Transfer(address indexed from, address indexed to, uint256 value);
149 
150 	// This generates a public event on the blockchain that will notify clients
151 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
152 
153 	// This notifies clients about the amount burnt
154 	event Burn(address indexed from, uint256 value);
155 
156 	/**
157 	 * Constructor function
158 	 *
159 	 * Initializes contract with initial supply tokens to the creator of the contract
160 	 */
161 	constructor(
162 		uint256 initialSupply,
163 		string tokenName,
164 		string tokenSymbol
165 	) public {
166 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
167 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
168 		name = tokenName;                                   // Set the name for display purposes
169 		symbol = tokenSymbol;                               // Set the symbol for display purposes
170 	}
171 
172 	/**
173 	 * Internal transfer, only can be called by this contract
174 	 */
175 	function _transfer(address _from, address _to, uint _value) internal {
176 		// Prevent transfer to 0x0 address. Use burn() instead
177 		require(_to != 0x0);
178 		// Check if the sender has enough
179 		require(balanceOf[_from] >= _value);
180 		// Check for overflows
181 		require(balanceOf[_to] + _value > balanceOf[_to]);
182 		// Save this for an assertion in the future
183 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
184 		// Subtract from the sender
185 		balanceOf[_from] -= _value;
186 		// Add the same to the recipient
187 		balanceOf[_to] += _value;
188 		emit Transfer(_from, _to, _value);
189 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
190 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
191 	}
192 
193 	/**
194 	 * Transfer tokens
195 	 *
196 	 * Send `_value` tokens to `_to` from your account
197 	 *
198 	 * @param _to The address of the recipient
199 	 * @param _value the amount to send
200 	 */
201 	function transfer(address _to, uint256 _value) public returns (bool success) {
202 		_transfer(msg.sender, _to, _value);
203 		return true;
204 	}
205 
206 	/**
207 	 * Transfer tokens from other address
208 	 *
209 	 * Send `_value` tokens to `_to` in behalf of `_from`
210 	 *
211 	 * @param _from The address of the sender
212 	 * @param _to The address of the recipient
213 	 * @param _value the amount to send
214 	 */
215 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
216 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
217 		allowance[_from][msg.sender] -= _value;
218 		_transfer(_from, _to, _value);
219 		return true;
220 	}
221 
222 	/**
223 	 * Set allowance for other address
224 	 *
225 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
226 	 *
227 	 * @param _spender The address authorized to spend
228 	 * @param _value the max amount they can spend
229 	 */
230 	function approve(address _spender, uint256 _value) public returns (bool success) {
231 		allowance[msg.sender][_spender] = _value;
232 		emit Approval(msg.sender, _spender, _value);
233 		return true;
234 	}
235 
236 	/**
237 	 * Set allowance for other address and notify
238 	 *
239 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
240 	 *
241 	 * @param _spender The address authorized to spend
242 	 * @param _value the max amount they can spend
243 	 * @param _extraData some extra information to send to the approved contract
244 	 */
245 	function approveAndCall(address _spender, uint256 _value, bytes _extraData)
246 		public
247 		returns (bool success) {
248 		tokenRecipient spender = tokenRecipient(_spender);
249 		if (approve(_spender, _value)) {
250 			spender.receiveApproval(msg.sender, _value, this, _extraData);
251 			return true;
252 		}
253 	}
254 
255 	/**
256 	 * Destroy tokens
257 	 *
258 	 * Remove `_value` tokens from the system irreversibly
259 	 *
260 	 * @param _value the amount of money to burn
261 	 */
262 	function burn(uint256 _value) public returns (bool success) {
263 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
264 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
265 		totalSupply -= _value;                      // Updates totalSupply
266 		emit Burn(msg.sender, _value);
267 		return true;
268 	}
269 
270 	/**
271 	 * Destroy tokens from other account
272 	 *
273 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
274 	 *
275 	 * @param _from the address of the sender
276 	 * @param _value the amount of money to burn
277 	 */
278 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
279 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
280 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
281 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
282 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
283 		totalSupply -= _value;                              // Update totalSupply
284 		emit Burn(_from, _value);
285 		return true;
286 	}
287 }
288 
289 contract developed {
290 	address public developer;
291 
292 	/**
293 	 * Constructor
294 	 */
295 	constructor() public {
296 		developer = msg.sender;
297 	}
298 
299 	/**
300 	 * @dev Checks only developer address is calling
301 	 */
302 	modifier onlyDeveloper {
303 		require(msg.sender == developer);
304 		_;
305 	}
306 
307 	/**
308 	 * @dev Allows developer to switch developer address
309 	 * @param _developer The new developer address to be set
310 	 */
311 	function changeDeveloper(address _developer) public onlyDeveloper {
312 		developer = _developer;
313 	}
314 
315 	/**
316 	 * @dev Allows developer to withdraw ERC20 Token
317 	 */
318 	function withdrawToken(address tokenContractAddress) public onlyDeveloper {
319 		TokenERC20 _token = TokenERC20(tokenContractAddress);
320 		if (_token.balanceOf(this) > 0) {
321 			_token.transfer(developer, _token.balanceOf(this));
322 		}
323 	}
324 }
325 
326 
327 
328 
329 
330 
331 
332 
333 /**
334  * @title SpinWin
335  */
336 contract SpinWin is developed, SpinWinInterface {
337 	using SafeMath for uint256;
338 
339 	address public tokenAddress;
340 	address public settingAddress;
341 	address public lotteryAddress;
342 
343 	TokenInterface internal _spintoken;
344 	SettingInterface internal _setting;
345 	LotteryInterface internal _lottery;
346 	SpinWinLibraryInterface internal _lib;
347 	AdvertisingInterface internal _advertising;
348 
349 	/**
350 	 * @dev Player variables
351 	 */
352 	struct Bet {
353 		address playerAddress;
354 		bytes32 betId;
355 		uint256 betValue;
356 		uint256 diceResult;
357 		uint256 playerNumber;
358 		uint256 houseEdge;
359 		uint256 rewardValue;
360 		uint256 tokenRewardValue;
361 		uint256 blockNumber;
362 		bool processed;
363 	}
364 	struct TokenExchange {
365 		address playerAddress;
366 		bytes32 exchangeId;
367 		bool processed;
368 	}
369 
370 	mapping (uint256 => Bet) internal bets;
371 	mapping (bytes32 => uint256) internal betIdLookup;
372 	mapping (address => uint256) public playerPendingWithdrawals;
373 	mapping (address => uint256) public playerPendingTokenWithdrawals;
374 	mapping (address => address) public referees;
375 	mapping (bytes32 => TokenExchange) public tokenExchanges;
376 	mapping (address => uint256) public lotteryBlocksAmount;
377 
378 	uint256 constant public TWO_DECIMALS = 100;
379 	uint256 constant public PERCENTAGE_DIVISOR = 10 ** 6;   // 1000000 = 100%
380 	uint256 constant public CURRENCY_DIVISOR = 10**18;
381 
382 	uint256 public totalPendingBets;
383 
384 	/**
385 	 * @dev Log when bet is placed
386 	 */
387 	event LogBet(bytes32 indexed betId, address indexed playerAddress, uint256 playerNumber, uint256 betValue, uint256 houseEdge, uint256 rewardValue, uint256 tokenRewardValue);
388 
389 	/**
390 	 * @dev Log when bet is cleared
391 	 *
392 	 * Status:
393 	 * -2 = lose + failed mint and transfer
394 	 * -1 = lose + failed send
395 	 * 0 = lose
396 	 * 1 = win
397 	 * 2 = win + failed send
398 	 * 3 = refund
399 	 * 4 = refund + failed send
400 	 * 5 = owner cancel + refund
401 	 * 6 = owner cancel + refund + failed send
402 	 */
403 	event LogResult(bytes32 indexed betId, address indexed playerAddress, uint256 playerNumber, uint256 diceResult, uint256 betValue, uint256 houseEdge, uint256 rewardValue, uint256 tokenRewardValue, int256 status);
404 
405 	/**
406 	 * @dev Log when spinwin contributes some ETH to the lottery contract address
407 	 */
408 	event LogLotteryContribution(bytes32 indexed betId, address indexed playerAddress, uint256 weiValue);
409 
410 	/**
411 	 * @dev Log when spinwin rewards the referee of a bet or the person clears bet
412 	 * rewardType
413 	 * 1 = referral
414 	 * 2 = clearBet
415 	 */
416 	event LogRewardLotteryBlocks(address indexed receiver, bytes32 indexed betId, uint256 lottoBlocksAmount, uint256 rewardType, uint256 status);
417 
418 	/**
419 	 * @dev Log when player clears bets
420 	 */
421 	event LogClearBets(address indexed playerAddress);
422 
423 	/**
424 	 * @dev Log when player claims the lottery blocks reward
425 	 *
426 	 * Status:
427 	 * 0 = failed
428 	 * 1 = success
429 	 */
430 	event LogClaimLotteryBlocks(address indexed playerAddress, uint256 numLottery, uint256 claimAmount, uint256 claimStatus);
431 
432 	/**
433 	 * @dev Log when player exchanges token to Wei
434 	 *
435 	 * Status:
436 	 * 0 = failed send
437 	 * 1 = success
438 	 * 2 = failed destroy token
439 	 */
440 	event LogTokenExchange(bytes32 indexed exchangeId, address indexed playerAddress, uint256 tokenValue, uint256 tokenToWeiExchangeRate, uint256 weiValue, uint256 receivedWeiValue, uint256 remainderTokenValue, uint256 status);
441 
442 	/**
443 	 * @dev Log when player withdraws balance from failed transfer
444 	 *
445 	 * Status:
446 	 * 0 = failed
447 	 * 1 = success
448 	 */
449 	event LogPlayerWithdrawBalance(address indexed playerAddress, uint256 withdrawAmount, uint256 status);
450 
451 	/**
452 	 * @dev Log when player withdraw token balance from failed token transfer
453 	 *
454 	 * Status:
455 	 * 0 = failed
456 	 * 1 = success
457 	 */
458 	event LogPlayerWithdrawTokenBalance(address indexed playerAddress, uint256 withdrawAmount, uint256 status);
459 
460 	/**
461 	 * @dev Log when a bet ID is not found during clear bet
462 	 */
463 	event LogBetNotFound(bytes32 indexed betId);
464 
465 	/**
466 	 * @dev Log when developer cancel existing active bet
467 	 */
468 	event LogDeveloperCancelBet(bytes32 indexed betId, address indexed playerAddress);
469 
470 	/**
471 	 * Constructor
472 	 * @param _tokenAddress SpinToken contract address
473 	 * @param _settingAddress GameSetting contract address
474 	 * @param _libraryAddress SpinWinLibrary contract address
475 	 */
476 	constructor(address _tokenAddress, address _settingAddress, address _libraryAddress) public {
477 		tokenAddress = _tokenAddress;
478 		settingAddress = _settingAddress;
479 		_spintoken = TokenInterface(_tokenAddress);
480 		_setting = SettingInterface(_settingAddress);
481 		_lib = SpinWinLibraryInterface(_libraryAddress);
482 	}
483 
484 	/**
485 	 * @dev Checks if contract is active
486 	 */
487 	modifier isActive {
488 		require(_setting.isActive() == true);
489 		_;
490 	}
491 
492 	/**
493 	 * @dev Checks whether a bet is allowed, and player profit, bet value, house edge and player number are within range
494 	 */
495 	modifier canBet(uint256 _betValue, uint256 _playerNumber, uint256 _houseEdge) {
496 		require(_setting.canBet(_lib.calculateWinningReward(_betValue, _playerNumber, _houseEdge), _betValue, _playerNumber, _houseEdge) == true);
497 		_;
498 	}
499 
500 	/**
501 	 * @dev Checks if bet exist
502 	 */
503 	modifier betExist(bytes32 betId, address playerAddress) {
504 		require(betIdLookup[betId] > 0 && bets[betIdLookup[betId]].betId == betId && bets[betIdLookup[betId]].playerAddress == playerAddress);
505 		_;
506 	}
507 
508 	/**
509 	 * @dev Checks if token exchange is allowed
510 	 */
511 	modifier isExchangeAllowed(address playerAddress, uint256 tokenAmount) {
512 		require(_setting.isExchangeAllowed(playerAddress, tokenAmount) == true);
513 		_;
514 	}
515 
516 	/******************************************/
517 	/*       DEVELOPER ONLY METHODS           */
518 	/******************************************/
519 	/**
520 	 * @dev Allows developer to set lottery contract address
521 	 * @param _lotteryAddress The new lottery contract address to be set
522 	 */
523 	function devSetLotteryAddress(address _lotteryAddress) public onlyDeveloper {
524 		require (_lotteryAddress != address(0));
525 		lotteryAddress = _lotteryAddress;
526 		_lottery = LotteryInterface(_lotteryAddress);
527 	}
528 
529 	/**
530 	 * @dev Allows developer to set advertising contract address
531 	 * @param _advertisingAddress The new advertising contract address to be set
532 	 */
533 	function devSetAdvertisingAddress(address _advertisingAddress) public onlyDeveloper {
534 		require (_advertisingAddress != address(0));
535 		_advertising = AdvertisingInterface(_advertisingAddress);
536 	}
537 
538 	/**
539 	 * @dev Allows developer to get bet internal ID based on public betId
540 	 * @param betId The public betId
541 	 * @return The bet internal ID
542 	 */
543 	function devGetBetInternalId(bytes32 betId) public onlyDeveloper constant returns (uint256) {
544 		return (betIdLookup[betId]);
545 	}
546 
547 	/**
548 	 * @dev Allows developer to get bet info based on `betInternalId`
549 	 * @param betInternalId The bet internal ID to be queried
550 	 * @return The bet information
551 	 */
552 	function devGetBet(uint256 betInternalId) public
553 		onlyDeveloper
554 		constant returns (address, uint256, uint256, uint256, uint256, uint256, uint256, uint256, bool) {
555 		Bet memory _bet = bets[betInternalId];
556 		return (_bet.playerAddress, _bet.betValue, _bet.diceResult, _bet.playerNumber, _bet.houseEdge, _bet.rewardValue, _bet.tokenRewardValue, _bet.blockNumber, _bet.processed);
557 	}
558 
559 	/**
560 	 * @dev Allows developer to manually refund existing active bet.
561 	 * @param betId The ID of the bet to be cancelled
562 	 * @return Return true if success
563 	 */
564 	function devRefundBet(bytes32 betId) public onlyDeveloper returns (bool) {
565 		require (betIdLookup[betId] > 0);
566 
567 		Bet storage _bet = bets[betIdLookup[betId]];
568 
569 		require(_bet.processed == false);
570 
571 		_bet.processed = true;
572 		uint256 betValue = _bet.betValue;
573 		_bet.betValue = 0;
574 		_bet.rewardValue = 0;
575 		_bet.tokenRewardValue = 0;
576 
577 		_refundPlayer(betIdLookup[betId], betValue);
578 		return true;
579 	}
580 
581 	/**
582 	 * @dev Add funds to the contract
583 	 */
584 	function () public payable isActive {
585 		_setting.spinwinAddFunds(msg.value);
586 	}
587 
588 	/******************************************/
589 	/*           SETTING METHODS              */
590 	/******************************************/
591 	/**
592 	 * @dev Triggered during escape hatch. Go through each pending bets
593 	 * and move the bet value to playerPendingWithdrawals so that player
594 	 * can withdraw later
595 	 */
596 	function refundPendingBets() public returns (bool) {
597 		require (msg.sender == settingAddress);
598 		uint256 totalBets = _setting.uintSettings('totalBets');
599 		if (totalBets > 0) {
600 			for (uint256 i = 1; i <= totalBets; i++) {
601 				Bet storage _bet = bets[i];
602 				if (_bet.processed == false) {
603 					uint256 _betValue = _bet.betValue;
604 					_bet.processed = true;
605 					_bet.betValue = 0;
606 					playerPendingWithdrawals[_bet.playerAddress] = playerPendingWithdrawals[_bet.playerAddress].add(_betValue);
607 					emit LogResult(_bet.betId, _bet.playerAddress, _bet.playerNumber, 0, _betValue, _bet.houseEdge, 0, 0, 4);
608 				}
609 			}
610 		}
611 		return true;
612 	}
613 
614 	/******************************************/
615 	/*            PUBLIC METHODS              */
616 	/******************************************/
617 	/**
618 	 * @dev Player places a bet. If it has a `referrerAddress`, we want to give reward to the referrer accordingly.
619 	 * @dev If there is a bet that needs to be cleared, we will do it here too.
620 	 * @param playerNumber The number that the player chose
621 	 * @param houseEdge The house edge percentage that the player chose
622 	 * @param clearBetId The bet ID to be cleared
623 	 * @param referreeAddress The referree address if exist
624 	 * @return Return true if success
625 	 */
626 	function rollDice(uint256 playerNumber, uint256 houseEdge, bytes32 clearBetId, address referreeAddress) public
627 		payable
628 		canBet(msg.value, playerNumber, houseEdge)
629 		returns (bool) {
630 		uint256 betInternalId = _storeBet(msg.value, msg.sender, playerNumber, houseEdge);
631 
632 		// Check if we need to clear a pending bet
633 		if (clearBetId != '') {
634 			_clearSingleBet(msg.sender, clearBetId, _setting.uintSettings('blockSecurityCount'));
635 		}
636 
637 		// Check if we need to reward the referree
638 		_rewardReferree(referreeAddress, betInternalId);
639 
640 		_advertising.incrementBetCounter();
641 
642 		return true;
643 	}
644 
645 	/**
646 	 * @dev Player can clear multiple bets
647 	 * @param betIds The bet ids to be cleared
648 	 */
649 	function clearBets(bytes32[] betIds) public isActive {
650 		require (betIds.length > 0 && betIds.length <= _setting.uintSettings('maxNumClearBets'));
651 		bool canClear = false;
652 		uint256 blockSecurityCount = _setting.uintSettings('blockSecurityCount');
653 		for (uint256 i = 0; i < betIds.length; i++) {
654 			Bet memory _bet = bets[betIdLookup[betIds[i]]];
655 			if (_bet.processed == false && _setting.uintSettings('contractBalance') >= _bet.rewardValue && (block.number.sub(_bet.blockNumber)) >= blockSecurityCount) {
656 				canClear = true;
657 				break;
658 			}
659 		}
660 		require(canClear == true);
661 
662 		// Loop through each bets and clear it if possible
663 		for (i = 0; i < betIds.length; i++) {
664 			_clearSingleBet(msg.sender, betIds[i], blockSecurityCount);
665 		}
666 		emit LogClearBets(msg.sender);
667 	}
668 
669 	/**
670 	 * @dev Allow player to claim lottery blocks reward
671 	 * and spend it on lottery blocks
672 	 */
673 	function claimLotteryBlocks() public isActive {
674 		require (_lottery.isActive() == true);
675 		require (lotteryBlocksAmount[msg.sender] > 0);
676 		uint256 claimAmount = lotteryBlocksAmount[msg.sender];
677 		lotteryBlocksAmount[msg.sender] = 0;
678 		uint256 claimStatus = 1;
679 		if (!_lottery.claimReward(msg.sender, claimAmount)) {
680 			claimStatus = 0;
681 			lotteryBlocksAmount[msg.sender] = claimAmount;
682 		}
683 		emit LogClaimLotteryBlocks(msg.sender, _lottery.getNumLottery(), claimAmount, claimStatus);
684 	}
685 
686 	/**
687 	 * @dev Player exchanges token for Wei
688 	 * @param tokenAmount The amount of token to be exchanged
689 	 * @return Return true if success
690 	 */
691 	function exchangeToken(uint256 tokenAmount) public
692 		isExchangeAllowed(msg.sender, tokenAmount) {
693 		(uint256 weiValue, uint256 sendWei, uint256 tokenRemainder, uint256 burnToken) = _lib.calculateExchangeTokenValue(settingAddress, tokenAmount);
694 
695 		_setting.spinwinIncrementUintSetting('totalTokenExchanges');
696 
697 		// Generate exchangeId
698 		bytes32 _exchangeId = keccak256(abi.encodePacked(this, msg.sender, _setting.uintSettings('totalTokenExchanges')));
699 		TokenExchange storage _tokenExchange = tokenExchanges[_exchangeId];
700 
701 		// Make sure we don't process the exchange bet twice
702 		require (_tokenExchange.processed == false);
703 
704 		// Update exchange metric
705 		_setting.spinwinUpdateExchangeMetric(sendWei);
706 
707 		/*
708 		 * Store the info about this exchange
709 		 */
710 		_tokenExchange.playerAddress = msg.sender;
711 		_tokenExchange.exchangeId = _exchangeId;
712 		_tokenExchange.processed = true;
713 
714 		/*
715 		 * Burn token at this address
716 		 */
717 		if (!_spintoken.burnAt(_tokenExchange.playerAddress, burnToken)) {
718 			uint256 exchangeStatus = 2; // status = failed destroy token
719 
720 		} else {
721 			if (!_tokenExchange.playerAddress.send(sendWei)) {
722 				exchangeStatus = 0; // status = failed send
723 
724 				// If send failed, let player withdraw via playerWithdrawPendingTransactions
725 				playerPendingWithdrawals[_tokenExchange.playerAddress] = playerPendingWithdrawals[_tokenExchange.playerAddress].add(sendWei);
726 			} else {
727 				exchangeStatus = 1; // status = success
728 			}
729 		}
730 		// Update the token to wei exchange rate
731 		_setting.spinwinUpdateTokenToWeiExchangeRate();
732 
733 		emit LogTokenExchange(_tokenExchange.exchangeId, _tokenExchange.playerAddress, tokenAmount, _setting.uintSettings('tokenToWeiExchangeRateHonor'), weiValue, sendWei, tokenRemainder, exchangeStatus);
734 	}
735 
736 	/**
737 	 * @dev Calculate winning ETH when player wins
738 	 * @param betValue The amount of ETH for this bet
739 	 * @param playerNumber The number that player chose
740 	 * @param houseEdge The house edge for this bet
741 	 * @return The amount of ETH to be sent to player if he/she wins
742 	 */
743 	function calculateWinningReward(uint256 betValue, uint256 playerNumber, uint256 houseEdge) public view returns (uint256) {
744 		return _lib.calculateWinningReward(betValue, playerNumber, houseEdge);
745 	}
746 
747 	/**
748 	 * @dev Calculates token reward amount when player loses
749 	 * @param betValue The amount of ETH for this bet
750 	 * @param playerNumber The number that player chose
751 	 * @param houseEdge The house edge for this bet
752 	 * @return The amount of token to be sent to player if he/she loses
753 	 */
754 	function calculateTokenReward(uint256 betValue, uint256 playerNumber, uint256 houseEdge) public constant returns (uint256) {
755 		return _lib.calculateTokenReward(settingAddress, betValue, playerNumber, houseEdge);
756 	}
757 
758 	/**
759 	 * @dev Player withdraws balance in case of a failed refund or failed win send
760 	 */
761 	function playerWithdrawPendingTransactions() public {
762 		require(playerPendingWithdrawals[msg.sender] > 0);
763 		uint256 withdrawAmount = playerPendingWithdrawals[msg.sender];
764 		playerPendingWithdrawals[msg.sender] = 0;
765 
766 		// External call to untrusted contract
767 		uint256 status = 1; // status = success
768 		if (!msg.sender.send(withdrawAmount)) {
769 			status = 0; // status = failed
770 
771 			/*
772 			 * If send failed, revert playerPendingWithdrawals[msg.sender] = 0
773 			 * so that player can try to withdraw again later
774 			 */
775 			playerPendingWithdrawals[msg.sender] = withdrawAmount;
776 		}
777 		emit LogPlayerWithdrawBalance(msg.sender, withdrawAmount, status);
778 	}
779 
780 	/**
781 	 * @dev Players withdraws SPIN token balance in case of a failed token transfer
782 	 */
783 	function playerWithdrawPendingTokenTransactions() public {
784 		require(playerPendingTokenWithdrawals[msg.sender] > 0);
785 		uint256 withdrawAmount = playerPendingTokenWithdrawals[msg.sender];
786 		playerPendingTokenWithdrawals[msg.sender] = 0;
787 
788 		// Mint and transfer token to msg.sender
789 		uint256 status = 1; // status = success
790 		if (!_spintoken.mintTransfer(msg.sender, withdrawAmount)) {
791 			status = 0; // status = failed
792 			/*
793 			 * If transfer failed, revert playerPendingTokenWithdrawals[msg.sender] = 0
794 			 * so that player can try to withdraw again later
795 			 */
796 			playerPendingTokenWithdrawals[msg.sender] = withdrawAmount;
797 		}
798 		emit LogPlayerWithdrawTokenBalance(msg.sender, withdrawAmount, status);
799 	}
800 
801 	/**
802 	 * @dev Player gets bet information based on betId
803 	 * @return The bet information
804 	 */
805 	function playerGetBet(bytes32 betId) public
806 		constant returns (uint256, uint256, uint256, uint256, uint256, uint256, bool) {
807 		require(betIdLookup[betId] > 0 && bets[betIdLookup[betId]].betId == betId);
808 		Bet memory _bet = bets[betIdLookup[betId]];
809 		return (_bet.betValue, _bet.diceResult, _bet.playerNumber, _bet.houseEdge, _bet.rewardValue, _bet.tokenRewardValue, _bet.processed);
810 	}
811 
812 	/**
813 	 * @dev Player gets pending bet IDs
814 	 * @return The pending bet IDs
815 	 */
816 	function playerGetPendingBetIds() public constant returns (bytes32[]) {
817 		bytes32[] memory pendingBetIds = new bytes32[](totalPendingBets);
818 		if (totalPendingBets > 0) {
819 			uint256 counter = 0;
820 			for (uint256 i = 1; i <= _setting.uintSettings('totalBets'); i++) {
821 				Bet memory _bet = bets[i];
822 				if (_bet.processed == false) {
823 					pendingBetIds[counter] = _bet.betId;
824 					counter++;
825 				}
826 				if (counter == totalPendingBets) {
827 					break;
828 				}
829 			}
830 		}
831 		return pendingBetIds;
832 	}
833 
834 	/**
835 	 * @dev Player gets pending bet information based on betId
836 	 * @return The bet information
837 	 */
838 	function playerGetPendingBet(bytes32 betId) public
839 		constant returns (address, uint256, uint256, uint256, uint256) {
840 		require(betIdLookup[betId] > 0 && bets[betIdLookup[betId]].betId == betId);
841 		Bet memory _bet = bets[betIdLookup[betId]];
842 		return (_bet.playerAddress, _bet.playerNumber, _bet.betValue, _bet.houseEdge, _bet.blockNumber);
843 	}
844 
845 	/**
846 	 * @dev Calculates lottery block rewards when player clears a bet
847 	 * @return The amount of lottery blocks to be rewarded when player clears bet
848 	 */
849 	function calculateClearBetBlocksReward() public constant returns (uint256) {
850 		return _lib.calculateClearBetBlocksReward(settingAddress, lotteryAddress);
851 	}
852 
853 
854 	/******************************************/
855 	/*           INTERNAL METHODS             */
856 	/******************************************/
857 
858 	/**
859 	 * @dev Stores bet information.
860 	 * @param betValue The value of the bet
861 	 * @param playerAddress The player address
862 	 * @param playerNumber The number that player chose
863 	 * @param houseEdge The house edge for this bet
864 	 * @return The internal  bet ID of this bet
865 	 */
866 	function _storeBet (uint256 betValue, address playerAddress, uint256 playerNumber, uint256 houseEdge) internal returns (uint256) {
867 		// Update the setting metric
868 		_setting.spinwinRollDice(betValue);
869 
870 		uint256 betInternalId = _setting.uintSettings('totalBets');
871 
872 		// Generate betId
873 		bytes32 betId = keccak256(abi.encodePacked(this, playerAddress, betInternalId));
874 
875 		Bet storage _bet = bets[betInternalId];
876 
877 		// Make sure we don't process the same bet twice
878 		require (_bet.processed == false);
879 
880 		// Store the info about this bet
881 		betIdLookup[betId] = betInternalId;
882 		_bet.playerAddress = playerAddress;
883 		_bet.betId = betId;
884 		_bet.betValue = betValue;
885 		_bet.playerNumber = playerNumber;
886 		_bet.houseEdge = houseEdge;
887 
888 		// Safely calculate winning reward
889 		_bet.rewardValue = calculateWinningReward(betValue, playerNumber, houseEdge);
890 
891 		// Safely calculate token payout
892 		_bet.tokenRewardValue = calculateTokenReward(betValue, playerNumber, houseEdge);
893 		_bet.blockNumber = block.number;
894 
895 		// Update the pendingBets counter
896 		totalPendingBets++;
897 
898 		emit LogBet(_bet.betId, _bet.playerAddress, _bet.playerNumber, _bet.betValue, _bet.houseEdge, _bet.rewardValue, _bet.tokenRewardValue);
899 		return betInternalId;
900 	}
901 
902 	/**
903 	 * @dev Internal function to clear single bet
904 	 * @param playerAddress The player who clears this bet
905 	 * @param betId The bet ID to be cleared
906 	 * @param blockSecurityCount The block security count to be checked
907 	 * @return true if success, false otherwise
908 	 */
909 	function _clearSingleBet(address playerAddress, bytes32 betId, uint256 blockSecurityCount) internal returns (bool) {
910 		if (betIdLookup[betId] > 0) {
911 			Bet memory _bet = bets[betIdLookup[betId]];
912 
913 			/* Check if we can clear this bet
914 			 * - Make sure we don't process the same bet twice
915 			 * - Check if contract can payout on win
916 			 * - block number difference >= blockSecurityCount
917 			 */
918 			if (_bet.processed == false && _setting.uintSettings('contractBalance') >= _bet.rewardValue && (block.number.sub(_bet.blockNumber)) >= blockSecurityCount) {
919 				_processBet(playerAddress, betIdLookup[betId], true);
920 			} else {
921 				emit LogRewardLotteryBlocks(playerAddress, _bet.betId, 0, 2, 0);
922 			}
923 			return true;
924 		} else {
925 			emit LogBetNotFound(betId);
926 			return false;
927 		}
928 	}
929 
930 	/**
931 	 * @dev Internal function to process existing bet.
932 	 * If no dice result, then we initiate a refund.
933 	 * If player wins (dice result < player number), we send player winning ETH.
934 	 * If player loses (dice result >= player number), we send player some SPIN token.
935 	 * If player loses and bankroll goal is reached, spinwin will contribute some ETH to lottery contract address.
936 	 *
937 	 * @param triggerAddress The player who clears this bet
938 	 * @param betInternalId The bet internal ID to be processed
939 	 * @param isClearMultiple Whether or not this is part of clear multiple bets transaction
940 	 * @return Return true if success
941 	 */
942 	function _processBet(address triggerAddress, uint256 betInternalId, bool isClearMultiple) internal returns (bool) {
943 		Bet storage _bet =  bets[betInternalId];
944 		uint256 _betValue = _bet.betValue;
945 		uint256 _rewardValue = _bet.rewardValue;
946 		uint256 _tokenRewardValue = _bet.tokenRewardValue;
947 
948 		// Prevent re-entrancy
949 		_bet.processed = true;
950 		_bet.betValue = 0;
951 		_bet.rewardValue = 0;
952 		_bet.tokenRewardValue = 0;
953 
954 		// Generate the result
955 		_bet.diceResult = _lib.generateRandomNumber(settingAddress, _bet.blockNumber, _setting.uintSettings('totalBets').add(_setting.uintSettings('totalWeiWagered')), 100);
956 
957 		if (_bet.diceResult == 0) {
958 			/*
959 			 * Invalid random number. Refund the player
960 			 */
961 			_refundPlayer(betInternalId, _betValue);
962 		} else if (_bet.diceResult < _bet.playerNumber) {
963 			/*
964 			 * Player wins. Send the player the winning eth amount
965 			 */
966 			_payWinner(betInternalId, _betValue, _rewardValue);
967 		} else {
968 			/*
969 			 * Player loses. Send the player 1 wei and the spintoken amount
970 			 */
971 			_payLoser(betInternalId, _betValue, _tokenRewardValue);
972 		}
973 		// Update the pendingBets counter
974 		totalPendingBets--;
975 
976 		// Update the token to wei exchange rate
977 		_setting.spinwinUpdateTokenToWeiExchangeRate();
978 
979 		// Calculate the lottery blocks reward for this transaction
980 		uint256 lotteryBlocksReward = calculateClearBetBlocksReward();
981 
982 		// If this is a single clear (from placing bet), we want to multiply this with clearSingleBetMultiplier
983 		if (isClearMultiple == false) {
984 			uint256 multiplier = _setting.uintSettings('clearSingleBetMultiplier');
985 		} else {
986 			multiplier = _setting.uintSettings('clearMultipleBetsMultiplier');
987 		}
988 		lotteryBlocksReward = (lotteryBlocksReward.mul(multiplier)).div(TWO_DECIMALS);
989 
990 		lotteryBlocksAmount[triggerAddress] = lotteryBlocksAmount[triggerAddress].add(lotteryBlocksReward);
991 		emit LogRewardLotteryBlocks(triggerAddress, _bet.betId, lotteryBlocksReward, 2, 1);
992 		return true;
993 	}
994 
995 	/**
996 	 * @dev Refund the player when we are unable to determine the dice result
997 	 * @param betInternalId The bet internal ID
998 	 * @param refundAmount The amount to be refunded
999 	 */
1000 	function _refundPlayer(uint256 betInternalId, uint256 refundAmount) internal {
1001 		Bet memory _bet =  bets[betInternalId];
1002 		/*
1003 		 * Send refund - external call to an untrusted contract
1004 		 * If send fails, map refund value to playerPendingWithdrawals[address]
1005 		 * for withdrawal later via playerWithdrawPendingTransactions
1006 		 */
1007 		int256 betStatus = 3; // status = refund
1008 		if (!_bet.playerAddress.send(refundAmount)) {
1009 			betStatus = 4; // status = refund + failed send
1010 
1011 			// If send failed, let player withdraw via playerWithdrawPendingTransactions
1012 			playerPendingWithdrawals[_bet.playerAddress] = playerPendingWithdrawals[_bet.playerAddress].add(refundAmount);
1013 		}
1014 		emit LogResult(_bet.betId, _bet.playerAddress, _bet.playerNumber, _bet.diceResult, refundAmount, _bet.houseEdge, 0, 0, betStatus);
1015 	}
1016 
1017 	/**
1018 	 * @dev Pays the player the winning eth amount
1019 	 * @param betInternalId The bet internal ID
1020 	 * @param betValue The original wager
1021 	 * @param playerProfit The player profit
1022 	 */
1023 	function _payWinner(uint256 betInternalId, uint256 betValue, uint256 playerProfit) internal {
1024 		Bet memory _bet =  bets[betInternalId];
1025 		// Update setting's contract balance and total wei won
1026 		_setting.spinwinUpdateWinMetric(playerProfit);
1027 
1028 		// Safely calculate payout via profit plus original wager
1029 		playerProfit = playerProfit.add(betValue);
1030 
1031 		/*
1032 		 * Send win - external call to an untrusted contract
1033 		 * If send fails, map reward value to playerPendingWithdrawals[address]
1034 		 * for withdrawal later via playerWithdrawPendingTransactions
1035 		 */
1036 		int256 betStatus = 1; // status = win
1037 		if (!_bet.playerAddress.send(playerProfit)) {
1038 			betStatus = 2; // status = win + failed send
1039 
1040 			// If send failed, let player withdraw via playerWithdrawPendingTransactions
1041 			playerPendingWithdrawals[_bet.playerAddress] = playerPendingWithdrawals[_bet.playerAddress].add(playerProfit);
1042 		}
1043 		emit LogResult(_bet.betId, _bet.playerAddress, _bet.playerNumber, _bet.diceResult, betValue, _bet.houseEdge, playerProfit, 0, betStatus);
1044 	}
1045 
1046 	/**
1047 	 * @dev Pays the player 1 wei and the spintoken amount
1048 	 * @param betInternalId The bet internal ID
1049 	 * @param betValue The original wager
1050 	 * @param tokenRewardValue The token reward for this bet
1051 	 */
1052 	function _payLoser(uint256 betInternalId, uint256 betValue, uint256 tokenRewardValue) internal {
1053 		Bet memory _bet =  bets[betInternalId];
1054 		/*
1055 		 * Update the game setting metric when player loses
1056 		 */
1057 		_setting.spinwinUpdateLoseMetric(betValue, tokenRewardValue);
1058 
1059 		int256 betStatus; // status = lose
1060 
1061 		/*
1062 		 * Send 1 Wei to losing bet - external call to an untrusted contract
1063 		 */
1064 		if (!_bet.playerAddress.send(1)) {
1065 			betStatus = -1; // status = lose + failed send
1066 
1067 			// If send failed, let player withdraw via playerWithdrawPendingTransactions
1068 			playerPendingWithdrawals[_bet.playerAddress] = playerPendingWithdrawals[_bet.playerAddress].add(1);
1069 		}
1070 
1071 		/*
1072 		 * Mint and transfer token reward to this player
1073 		 */
1074 		if (tokenRewardValue > 0) {
1075 			if (!_spintoken.mintTransfer(_bet.playerAddress, tokenRewardValue)) {
1076 				betStatus = -2; // status = lose + failed mint and transfer
1077 
1078 				// If transfer token failed, let player withdraw via playerWithdrawPendingTokenTransactions
1079 				playerPendingTokenWithdrawals[_bet.playerAddress] = playerPendingTokenWithdrawals[_bet.playerAddress].add(tokenRewardValue);
1080 			}
1081 		}
1082 		emit LogResult(_bet.betId, _bet.playerAddress, _bet.playerNumber, _bet.diceResult, betValue, _bet.houseEdge, 1, tokenRewardValue, betStatus);
1083 		_sendLotteryContribution(betInternalId, betValue);
1084 	}
1085 
1086 	/**
1087 	 * @dev Contribute the house win to lottery address
1088 	 * @param betInternalId The bet internal ID
1089 	 * @param betValue The original wager
1090 	 * @return Return true if success
1091 	 */
1092 	function _sendLotteryContribution(uint256 betInternalId, uint256 betValue) internal returns (bool) {
1093 		/*
1094 		 * If contractBalance >= minBankroll, contribute the a percentage of the winning to lottery
1095 		 */
1096 		uint256 contractBalance = _setting.uintSettings('contractBalance');
1097 		if (contractBalance >= _setting.uintSettings('minBankroll')) {
1098 			Bet memory _bet =  bets[betInternalId];
1099 			uint256 lotteryContribution = _lib.calculateLotteryContribution(settingAddress, lotteryAddress, betValue);
1100 
1101 			if (lotteryContribution > 0 && contractBalance >= lotteryContribution) {
1102 				// Safely adjust contractBalance
1103 				_setting.spinwinUpdateLotteryContributionMetric(lotteryContribution);
1104 
1105 				emit LogLotteryContribution(_bet.betId, _bet.playerAddress, lotteryContribution);
1106 
1107 				// Contribute to the lottery
1108 				if (!lotteryAddress.call.gas(_setting.uintSettings('gasForLottery')).value(lotteryContribution)()) {
1109 					return false;
1110 				}
1111 			}
1112 		}
1113 		return true;
1114 	}
1115 
1116 	/**
1117 	 * @dev Reward the referree if necessary.
1118 	 * @param referreeAddress The address of the referree
1119 	 * @param betInternalId The internal bet ID
1120 	 */
1121 	function _rewardReferree(address referreeAddress, uint256 betInternalId) internal {
1122 		Bet memory _bet = bets[betInternalId];
1123 
1124 		// If the player already has a referee, use that address
1125 		if (referees[_bet.playerAddress] != address(0)) {
1126 			referreeAddress = referees[_bet.playerAddress];
1127 		}
1128 		if (referreeAddress != address(0) && referreeAddress != _bet.playerAddress) {
1129 			referees[_bet.playerAddress] = referreeAddress;
1130 			uint256 _tokenForLotto = _bet.tokenRewardValue.mul(_setting.uintSettings('referralPercent')).div(PERCENTAGE_DIVISOR);
1131 			lotteryBlocksAmount[referreeAddress] = lotteryBlocksAmount[referreeAddress].add(_tokenForLotto);
1132 			emit LogRewardLotteryBlocks(referreeAddress, _bet.betId, _tokenForLotto, 1, 1);
1133 		}
1134 	}
1135 }