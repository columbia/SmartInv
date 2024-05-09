1 pragma solidity ^0.5.16;
2 
3 
4 /**
5  * Game Credits Rewards Contract
6  * https://www.gamecredits.org
7  * (c) 2020 GAME Credits. All Rights Reserved. This code is not open source.
8  */
9 
10 
11 
12 
13 
14 /**
15  * @dev Wrappers over Solidity's arithmetic operations with added overflow
16  * checks.
17  *
18  * Arithmetic operations in Solidity wrap on overflow. This can easily result
19  * in bugs, because programmers usually assume that an overflow raises an
20  * error, which is the standard behavior in high level programming languages.
21  * `SafeMath` restores this intuition by reverting the transaction when an
22  * operation overflows.
23  *
24  * Using this library instead of the unchecked operations eliminates an entire
25  * class of bugs, so it's recommended to use it always.
26  */
27 library SafeMath {
28   /**
29     * @dev Returns the addition of two unsigned integers, reverting on
30     * overflow.
31     *
32     * Counterpart to Solidity's `+` operator.
33     *
34     * Requirements:
35     * - Addition cannot overflow.
36     */
37   function add(uint a, uint b) internal pure returns (uint) {
38     uint c = a + b;
39     require(c >= a, "SafeMath: addition overflow");
40 
41     return c;
42   }
43 
44   /**
45     * @dev Returns the subtraction of two unsigned integers, reverting on
46     * overflow (when the result is negative).
47     *
48     * Counterpart to Solidity's `-` operator.
49     *
50     * Requirements:
51     * - Subtraction cannot overflow.
52     */
53   function sub(uint a, uint b) internal pure returns (uint) {
54     return sub(a, b, "SafeMath: subtraction overflow");
55   }
56 
57   /**
58     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
59     * overflow (when the result is negative).
60     *
61     * Counterpart to Solidity's `-` operator.
62     *
63     * Requirements:
64     * - Subtraction cannot overflow.
65     *
66     * _Available since v2.4.0._
67     */
68   function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
69     require(b <= a, errorMessage);
70     uint c = a - b;
71 
72     return c;
73   }
74 
75   /**
76     * @dev Returns the multiplication of two unsigned integers, reverting on
77     * overflow.
78     *
79     * Counterpart to Solidity's `*` operator.
80     *
81     * Requirements:
82     * - Multiplication cannot overflow.
83     */
84   function mul(uint a, uint b) internal pure returns (uint) {
85     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
86     // benefit is lost if 'b' is also tested.
87     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
88     if (a == 0) {
89       return 0;
90     }
91 
92     uint c = a * b;
93     require(c / a == b, "SafeMath: multiplication overflow");
94 
95     return c;
96   }
97 
98   /**
99     * @dev Returns the integer division of two unsigned integers. Reverts on
100     * division by zero. The result is rounded towards zero.
101     *
102     * Counterpart to Solidity's `/` operator. Note: this function uses a
103     * `revert` opcode (which leaves remaining gas untouched) while Solidity
104     * uses an invalid opcode to revert (consuming all remaining gas).
105     *
106     * Requirements:
107     * - The divisor cannot be zero.
108     */
109   function div(uint a, uint b) internal pure returns (uint) {
110     return div(a, b, "SafeMath: division by zero");
111   }
112 
113   /**
114     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
115     * division by zero. The result is rounded towards zero.
116     *
117     * Counterpart to Solidity's `/` operator. Note: this function uses a
118     * `revert` opcode (which leaves remaining gas untouched) while Solidity
119     * uses an invalid opcode to revert (consuming all remaining gas).
120     *
121     * Requirements:
122     * - The divisor cannot be zero.
123     *
124     * _Available since v2.4.0._
125     */
126   function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
127     // Solidity only automatically asserts when dividing by 0
128     require(b > 0, errorMessage);
129     uint c = a / b;
130     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
131 
132     return c;
133   }
134 
135   /**
136     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
137     * Reverts when dividing by zero.
138     *
139     * Counterpart to Solidity's `%` operator. This function uses a `revert`
140     * opcode (which leaves remaining gas untouched) while Solidity uses an
141     * invalid opcode to revert (consuming all remaining gas).
142     *
143     * Requirements:
144     * - The divisor cannot be zero.
145     */
146   function mod(uint a, uint b) internal pure returns (uint) {
147     return mod(a, b, "SafeMath: modulo by zero");
148   }
149 
150   /**
151     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152     * Reverts with custom message when dividing by zero.
153     *
154     * Counterpart to Solidity's `%` operator. This function uses a `revert`
155     * opcode (which leaves remaining gas untouched) while Solidity uses an
156     * invalid opcode to revert (consuming all remaining gas).
157     *
158     * Requirements:
159     * - The divisor cannot be zero.
160     *
161     * _Available since v2.4.0._
162     */
163   function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
164     require(b != 0, errorMessage);
165     return a % b;
166   }
167 }
168 
169 
170 
171 
172 
173 
174 
175 // @title iSupportContract
176 // @dev The interface for cross-contract calls to Support contracts
177 // @author GAME Credits Platform (https://www.gamecredits.org)
178 // (c) 2020 GAME Credits. All Rights Reserved. This code is not open source.
179 contract iSupportContract {
180 
181   function isSupportContract() external pure returns(bool);
182 
183   function getGameAccountSupport(uint _game, address _account) external view returns(uint);
184   function updateSupport(uint _game, address _account, uint _supportAmount) external;
185   function fundRewardsPool(uint _amount, uint _startWeek, uint _numberOfWeeks) external;
186 
187   function receiveGameCredits(uint _game, address _account, uint _tokenId, uint _payment, bytes32 _data) external;
188   function receiveLoyaltyPayment(uint _game, address _account, uint _tokenId, uint _payment, bytes32 _data) external;
189   function contestEntry(uint _game, address _account, uint _tokenId, uint _contestId, uint _payment, bytes32 _data) external;
190 
191   event GameCreditsPayment(uint indexed _game, address indexed account, uint indexed _tokenId, uint _payment, bytes32 _data);
192   event LoyaltyPayment(uint indexed _game, address indexed account, uint indexed _tokenId, uint _payment, bytes32 _data);
193   event EnterContest(uint indexed _game, address indexed account, uint _tokenId, uint indexed _contestId, uint _payment, bytes32 _data);
194 }
195 
196 
197 
198 // @title iGameContract
199 // @dev The interface for cross-contract calls to the Game contract
200 // @author GAME Credits Platform (https://www.gamecredits.org)
201 // (c) 2020 GAME Credits. All Rights Reserved. This code is not open source.
202 contract iGameContract {
203   function isAdminForGame(uint _game, address account) external view returns(bool);
204 
205   // List of all games tracked by the Game contract
206   uint[] public games;
207 }
208 
209 
210 
211 
212 
213 
214 
215 // @title RewardsAccess
216 // @dev RewardsAccess contract for controlling access to Rewards contract functions
217 // @author GAME Credits Platform (https://www.gamecredits.org)
218 // (c) 2020 GAME Credits. All Rights Reserved. This code is not open source.
219 contract RewardsAccess {
220   using SafeMath for uint;
221 
222   event OwnershipTransferred(address previousOwner, address newOwner);
223 
224   // Reference to the address of the Game contract
225   iGameContract public gameContract;
226 
227   // Reference to the address of the ERC20 contract
228   iERC20 public erc20Contract;
229 
230   // The Owner can perform all admin tasks, including setting the recovery account.
231   address public owner;
232 
233   // The Recovery account can change the Owner account.
234   address public recoveryAddress;
235 
236 
237   // @dev The original `owner` of the contract is the contract creator.
238   // @dev Internal constructor to ensure this contract can't be deployed alone
239   constructor()
240     internal
241   {
242     owner = msg.sender;
243   }
244 
245   // @dev Access control modifier to limit access to game admin accounts
246   modifier onlyGameAdmin(uint _game) {
247     require(gameContract.isAdminForGame(_game, msg.sender), "caller must be game admin");
248     _;
249   }
250 
251   // @dev Access control modifier to limit access to the Owner account
252   modifier onlyOwner() {
253     require(msg.sender == owner, "sender must be owner");
254     _;
255   }
256 
257   // @dev Access control modifier to limit access to the Recovery account
258   modifier onlyRecovery() {
259     require(msg.sender == recoveryAddress, "sender must be recovery");
260     _;
261   }
262 
263   // @dev Access control modifier to limit access to the Owner or Recovery account
264   modifier ownerOrRecovery() {
265     require(msg.sender == owner || msg.sender == recoveryAddress, "sender must be owner or recovery");
266     _;
267   }
268 
269   // @dev Access control modifier to limit access to the Recovery account
270   modifier onlyERC20Contract() {
271     require(msg.sender == address(erc20Contract), "Can only be called from the ERC20 contract");
272     _;
273   }
274 
275   // @dev Assigns a new address to act as the Owner.
276   // @notice Can only be called by the recovery account
277   // @param _newOwner The address of the new Owner
278   function setOwner(address _newOwner)
279     external
280     onlyRecovery
281   {
282     require(_newOwner != address(0), "new owner must be a non-zero address");
283     require(_newOwner != recoveryAddress, "new owner can't be the recovery address");
284 
285     owner = _newOwner;
286     emit OwnershipTransferred(owner, _newOwner);
287   }
288 
289   // @dev Assigns a new address to act as the Recovery address.
290   // @notice Can only be called by the Owner account
291   // @param _newRecovery The address of the new Recovery account
292   function setRecovery(address _newRecovery)
293     external
294     onlyOwner
295   {
296     require(_newRecovery != address(0), "new owner must be a non-zero address");
297     require(_newRecovery != owner, "new recovery can't be the owner address");
298 
299     recoveryAddress = _newRecovery;
300   }
301 }
302 
303 
304 
305 // @title ERC20 Rewards manager imlpementation
306 // @dev Utility contract that manages supporting games
307 // @author GAME Credits Platform (https://www.gamecredits.org)
308 // (c) 2020 GAME Credits. All Rights Reserved. This code is not open source.
309 contract RewardsBase is RewardsAccess, iSupportContract {
310   using SafeMath for uint;
311 
312   uint public constant WEEK_ZERO_START = 1538352000; // 10/1/2018 @ 00:00:00
313   uint public constant SECONDS_PER_WEEK = 604800;
314 
315   // Emitted whenever a user or game takes a payout from the system
316   event Payout(address indexed supporter, uint indexed game, uint amount, uint endWeek);
317 
318   // Emitted whenever a user's support is increased or decreased.
319   event ChangeSupport(
320     uint week, uint indexed game, address indexed supporter, uint prevSupport, uint newSupport,
321     uint accountSupport, uint gameSupport, uint totalSupport
322   );
323 
324   // @dev Tracks current support levels for all accounts and games.
325   //   Tracks separately for accounts by game, accounts, games, and the total support on the system
326   // Mapping(Game => Mapping(Account => Support))
327   mapping(uint => mapping(address => uint)) public gameAccountSupport;
328   // Mapping(Account => Support)
329   mapping(address => uint) public accountSupport;
330   // Mapping(Game => Support)
331   mapping(uint => uint) public gameSupport;
332   // Support
333   uint public totalSupport;
334 
335   // @dev Tracks support by week for accounts and games. Each is updated when a user changes their support.
336   //   These can be zero if they haven't been updated during the current week, so "zero"
337   //     just means "look at the week before", as no support have been changed.
338   //   When setting a support to zero, the system records a "1". This is safe, because it's stored
339   //     with 18 significant digits, and the calculation looks at 0 significant digits
340   // Mapping(Week => Mapping(Game => Mapping(Account => Support)))
341   mapping(uint => mapping(uint => mapping(address => uint))) public weekGameAccountSupport;
342   // Mapping(Week => Mapping(Account => Support))
343   mapping(uint => mapping(address => uint)) public weekAccountSupport;
344   // Mapping(Week => Mapping(Game => Support))
345   mapping(uint => mapping(uint => uint)) public weekGameSupport;
346   // Mapping(Week => Support)
347   mapping(uint => uint) public weekTotalSupport;
348 
349   // The last week that an account took a payout. Used for calculating the remaining payout for the account
350   mapping(address => uint) public lastPayoutWeekByAccount;
351   // The last week that a game took a payout. Used for calculating the remaining payout for the game
352   mapping(uint => uint) public lastPayoutWeekByGame;
353 
354   // @dev Internal constructor to ensure this contract can't be deployed alone
355   constructor()
356     internal
357   {
358     weekTotalSupport[getCurrentWeek() - 1] = 1;
359   }
360 
361   // @dev Function to calculate and return the current week
362   // @returns uint - the current week
363   function getCurrentWeek()
364     public
365     view
366   returns(uint) {
367     return (now - WEEK_ZERO_START) / SECONDS_PER_WEEK;
368   }
369 
370   // @dev confirms that this contract is a support contract
371   // @returns bool - always returns true because this is a support contract
372   function isSupportContract()
373     external
374     pure
375   returns(bool)
376   {
377     return true;
378   }
379 
380   // @dev Internal function to increase support on a game by an amount.
381   // @param _game - the game to increase support on
382   // @param _account - the account to increase support on
383   // @param _increase - The increase must be non-zero, and less than
384   //   or equal to the _account's available GAME credits balance
385   function _increaseSupport(uint _game, address _account, uint _increase)
386     internal
387   returns(uint newSupport) {
388     require(_increase > 0, "Must be a non-zero change");
389 
390     uint prevSupport = gameAccountSupport[_game][_account];
391     newSupport = prevSupport.add(_increase);
392     uint _gameSupport = gameSupport[_game].add(_increase);
393     uint _accountSupport = accountSupport[_account].add(_increase);
394     uint _totalSupport = totalSupport.add(_increase);
395 
396     _storeSupport(_game, _account, prevSupport, newSupport, _gameSupport, _accountSupport, _totalSupport);
397   }
398 
399   // @dev Internal function to decrease support on a game by an amount.
400   // @param _game - the game to decrease support on
401   // @param _account - the account to decrease
402   // @param _decrease - The decrease must be non-zero, and less than
403   //   or equal to the _account's support on the game
404   function _decreaseSupport(uint _game, address _account, uint _decrease)
405     internal
406   returns(uint newSupport) {
407     require(_decrease > 0, "Must be a non-zero change");
408 
409     uint prevSupport = gameAccountSupport[_game][_account];
410     newSupport = prevSupport.sub(_decrease);
411     uint _gameSupport = gameSupport[_game].sub(_decrease);
412     uint _accountSupport = accountSupport[_account].sub(_decrease);
413     uint _totalSupport = totalSupport.sub(_decrease);
414 
415     _storeSupport(_game, _account, prevSupport, newSupport, _gameSupport, _accountSupport, _totalSupport);
416   }
417 
418   // @dev Internal function to calculate the game, account, and total support on a support change
419   // @param _game - the game to be supported
420   // @param _supporter - the account doing the supporting
421   // @param _prevSupport - the previous support of the supporter on that game
422   // @param _newSupport - the newly updated support of the supporter on that game
423   // @param _gameSupport - the new total support for the game
424   // @param _accountSupport - the new total support for the supporter's account
425   // @param _totalSupport - the new total support for the system as a whole
426   function _storeSupport(
427     uint _game, address _supporter, uint _prevSupport, uint _newSupport,
428     uint _gameSupport, uint _accountSupport, uint _totalSupport)
429     internal
430   {
431     uint _currentWeek = getCurrentWeek();
432 
433     gameAccountSupport[_game][_supporter] = _newSupport;
434     gameSupport[_game] = _gameSupport;
435     accountSupport[_supporter] = _accountSupport;
436     totalSupport = _totalSupport;
437 
438     // Each of these stores the weekly support as "1" if it's been set to 0.
439     // This tracks the difference between "not set this week" and "set to zero this week"
440     weekGameAccountSupport[_currentWeek][_game][_supporter] = _newSupport > 0 ? _newSupport : 1;
441     weekAccountSupport[_currentWeek][_supporter] = _accountSupport > 0 ? _accountSupport : 1;
442     weekGameSupport[_currentWeek][_game] = _gameSupport > 0 ? _gameSupport : 1;
443     weekTotalSupport[_currentWeek] = _totalSupport > 0 ? _totalSupport : 1;
444 
445     // Get the last payout week; set it to this week if there hasn't been a week.
446     // This lets the user iterate payouts correctly.
447     if(lastPayoutWeekByAccount[_supporter] == 0) {
448       lastPayoutWeekByAccount[_supporter] = _currentWeek - 1;
449     }
450     if (lastPayoutWeekByGame[_game] == 0) {
451       lastPayoutWeekByGame[_game] = _currentWeek - 1;
452     }
453 
454     emit ChangeSupport(
455       _currentWeek, _game, _supporter, _prevSupport, _newSupport,
456       _accountSupport, _gameSupport, _totalSupport);
457   }
458 
459   // @dev Internal function to get the total support for a given week
460   // @notice This updates the stored values for intervening weeks,
461   //   as that's more efficient at 100 or more users
462   // @param _week - the week in which to calculate the total support
463   // @returns _support - the total support in that week
464   function _getWeekTotalSupport(uint _week)
465     internal
466   returns(uint _support) {
467     _support = weekTotalSupport[_week];
468     if(_support == 0) {
469       uint backWeek = _week;
470       while(_support == 0) {
471         backWeek--;
472         _support = weekTotalSupport[backWeek];
473       }
474       weekTotalSupport[_week] = _support;
475     }
476   }
477 
478   // @dev Internal function to get the end week based on start, number of weeks, and current week
479   // @param _startWeek - the start of the range
480   // @param _numberOfWeeks - the length of the range
481   // @returns endWeek - either the current week, or the end of the range
482   // @notice This throws if it tries to get a week range longer than the current week
483   function _getEndWeek(uint _startWeek, uint _numberOfWeeks)
484     internal
485     view
486   returns(uint endWeek) {
487     uint _currentWeek = getCurrentWeek();
488     require(_startWeek < _currentWeek, "must get at least one week");
489     endWeek = _numberOfWeeks == 0 ? _currentWeek : _startWeek + _numberOfWeeks;
490     require(endWeek <= _currentWeek, "can't get more than the current week");
491   }
492 }
493 
494 
495 
496 /**
497  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
498  * the optional functions; to access them see {ERC20Detailed}.
499  */
500 interface iERC20 {
501 
502   /**
503     * @dev Returns the amount of tokens in existence.
504     */
505   function totalSupply() external view returns (uint);
506 
507   /**
508     * @dev Returns the amount of tokens owned by `account`.
509     */
510   function balanceOf(address account) external view returns (uint);
511 
512   /**
513     * @dev Moves `amount` tokens from the caller's account to `recipient`.
514     *
515     * Returns a boolean value indicating whether the operation succeeded.
516     *
517     * Emits a {Transfer} event.
518     */
519   function transfer(address recipient, uint amount) external returns (bool);
520 
521   /**
522     * @dev Returns the remaining number of tokens that `spender` will be
523     * allowed to spend on behalf of `owner` through {transferFrom}. This is
524     * zero by default.
525     *
526     * This value changes when {approve} or {transferFrom} are called.
527     */
528   function allowance(address owner, address spender) external view returns (uint);
529 
530   /**
531     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
532     *
533     * Returns a boolean value indicating whether the operation succeeded.
534     *
535     * IMPORTANT: Beware that changing an allowance with this method brings the risk
536     * that someone may use both the old and the new allowance by unfortunate
537     * transaction ordering. One possible solution to mitigate this race
538     * condition is to first reduce the spender's allowance to 0 and set the
539     * desired value afterwards:
540     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
541     *
542     * Emits an {Approval} event.
543     */
544   function approve(address spender, uint amount) external returns (bool);
545 
546   /**
547     * @dev Moves `amount` tokens from `sender` to `recipient` using the
548     * allowance mechanism. `amount` is then deducted from the caller's
549     * allowance.
550     *
551     * Returns a boolean value indicating whether the operation succeeded.
552     *
553     * Emits a {Transfer} event.
554     */
555   function transferFrom(address sender, address recipient, uint amount) external returns (bool);
556 
557   /**
558     * @dev Emitted when `value` tokens are moved from one account (`from`) to
559     * another (`to`).
560     *
561     * Note that `value` may be zero.
562     */
563   event Transfer(address indexed from, address indexed to, uint value);
564 
565   /**
566     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
567     * a call to {approve}. `value` is the new allowance.
568     */
569   event Approval(address indexed owner, address indexed spender, uint value);
570 }
571 
572 
573 // @title Rewards contract
574 // @dev ERC20 management contract, designed to make supporting ERC-20 tokens easier
575 // @author GAME Credits Platform (https://www.gamecredits.org)
576 // (c) 2020 GAME Credits. All Rights Reserved. This code is not open source.
577 contract RewardsContract is RewardsBase {
578 
579   string public url = "https://www.gamecredits.org";
580 
581   event WeeklyRewardsPoolUpdated(uint week, uint stored);
582   event PromotedGame(uint game, bool isPromoted, string json);
583   event SuppressedGame(uint game, bool isSuppressed);
584 
585   // The number of erc20 Tokens stored as income each week
586   mapping(uint => uint) public weeklyRewardsPool;
587 
588   // @dev Constructor creates a reference to the NFT ownership contract.
589   // @param _erc20Contract - address of the mainnet erc20 contract
590   // @param _gameContract - address of the mainnet Game Data contract
591   constructor(iERC20 _erc20Contract, iGameContract _gameContract)
592     public
593   {
594     erc20Contract = _erc20Contract;
595     gameContract = _gameContract;
596   }
597 
598   // @notice The fallback function reverts
599   function ()
600     external
601     payable
602   {
603     revert("this contract is not payable");
604   }
605 
606   // @dev Gets an account's support on a specific game
607   // @param _game - the game to query
608   // @param _account - the account to query
609   // @returns support - the amount supported that game by that account
610   function getGameAccountSupport(uint _game, address _account)
611     external
612     view
613   returns(uint support)
614   {
615     return gameAccountSupport[_game][_account];
616   }
617 
618   // @dev Sets an account's support on a game to an amount.
619   // @param _game - the game to increase or decrease support on
620   // @param _account - the account to change support
621   // @param _newSupport - The new support value. Can be an increase or decrease,
622   //   but must be different than their current support.
623   // @notice - this will throw if called from a contract other than the GAME credits contract
624   // @notice - this will throw if the _account doesn't have enough funds
625   function updateSupport(uint _game, address _account, uint _newSupport)
626     public
627     onlyERC20Contract()
628   {
629     uint currentSupport = gameAccountSupport[_game][_account];
630     if (currentSupport < _newSupport) {
631       _increaseSupport(_game, _account, _newSupport.sub(currentSupport));
632     } else
633     if (currentSupport > _newSupport) {
634       _decreaseSupport(_game, _account, currentSupport.sub(_newSupport));
635     }
636   }
637 
638   // @dev Lets any user add funds to the supporting pool spread over a period of weeks
639   // @param _amount - the total amount of GAME credits to add to the support pool
640   // @param _startWeek - the first week in which credits will be added to the support pool
641   // @param _numberOfWeeks - the number of weeks over which the _amount will be spread
642   // @notice - The _amount must be exactly divisible by the _numberOfWeeks
643   // @notice - this will throw if called from a contract other than the GAME token contract
644   function fundRewardsPool(uint _amount, uint _startWeek, uint _numberOfWeeks)
645     external
646     onlyERC20Contract()
647   {
648     require(_startWeek >= getCurrentWeek(), "Start Week must be equal or greater than current week");
649     uint _amountPerWeek = _amount.div(_numberOfWeeks);
650     uint _checkAmount = _amountPerWeek.mul(_numberOfWeeks);
651     require(_amount == _checkAmount, "Amount must divide exactly by number of weeks");
652 
653     for(uint week = _startWeek; week < _startWeek.add(_numberOfWeeks); week++) {
654       uint stored = weeklyRewardsPool[week].add(_amountPerWeek);
655       weeklyRewardsPool[week] = stored;
656       emit WeeklyRewardsPoolUpdated(week, stored);
657     }
658   }
659 
660   // @dev Lets a supporter collect the current rewards for all their support.
661   // @param _numberOfWeeks - the number of weeks to collect. Set to 0 to collect all weeks.
662   // @returns _payout - the total rewards payout over all the collected weeks
663   function collectRewards(uint _numberOfWeeks)
664     public
665   returns(uint _payout) {
666     uint startWeek = lastPayoutWeekByAccount[msg.sender];
667     require(startWeek > 0, "must be a valid start week");
668     uint endWeek = _getEndWeek(startWeek, _numberOfWeeks);
669     require(startWeek < endWeek, "must be at least one week to pay out");
670 
671     uint lastWeekSupport;
672     for (uint i = startWeek; i < endWeek; i++) {
673       // Get the support for the week. Use the last week's support if the support hasn't changed
674       uint weeklySupport = weekAccountSupport[i][msg.sender] == 0
675         ? lastWeekSupport
676         : weekAccountSupport[i][msg.sender];
677       lastWeekSupport = weeklySupport;
678 
679       uint weekSupport = _getWeekTotalSupport(i);
680       uint storedGAME = weeklyRewardsPool[i];
681       uint weeklyPayout = storedGAME > 1 && weeklySupport > 1 && weekSupport > 1
682         ? weeklySupport.mul(storedGAME).div(weekSupport).div(2)
683         : 0;
684       _payout = _payout.add(weeklyPayout);
685 
686     }
687     // If the weekly support for the end week is not set, set it to the
688     //   last week's support, to ensure we know what to pay out.
689     // This works even if the end week is the current week; the value
690     //   will be overwritten if necessary by future support changes
691     if(weekAccountSupport[endWeek][msg.sender] == 0) {
692       weekAccountSupport[endWeek][msg.sender] = lastWeekSupport;
693     }
694     // Always update the last payout week
695     lastPayoutWeekByAccount[msg.sender] = endWeek;
696 
697     erc20Contract.transfer(msg.sender, _payout);
698     emit Payout(msg.sender, 0, _payout, endWeek);
699   }
700 
701   // @dev Lets a game admin collect the current payout for their game.
702   // @param _game - the game to collect
703   // @param _numberOfWeeks - the number of weeks to collect. Set to 0 to collect all weeks.
704   // @returns _payout - the total payout over all the collected weeks
705   function collectGamePayout(uint _game, uint _numberOfWeeks)
706     external
707     onlyGameAdmin(_game)
708   returns(uint _payout) {
709     uint week = lastPayoutWeekByGame[_game];
710     require(week > 0, "must be a valid start week");
711     uint endWeek = _getEndWeek(week, _numberOfWeeks);
712     require(week < endWeek, "must be at least one week to pay out");
713 
714     uint lastWeekSupport;
715     for (week; week < endWeek; week++) {
716       // Get the support for the week. Use the last week's support if the support hasn't changed
717       uint weeklySupport = weekGameSupport[week][_game] == 0
718         ? lastWeekSupport
719         : weekGameSupport[week][_game];
720       lastWeekSupport = weeklySupport;
721 
722       uint weekSupport = _getWeekTotalSupport(week);
723       uint storedGAME = weeklyRewardsPool[week];
724       uint weeklyPayout = storedGAME > 1 && weeklySupport > 1 && weekSupport > 1
725         ? weeklySupport.mul(storedGAME).div(weekSupport).div(2)
726         : 0;
727       _payout = _payout.add(weeklyPayout);
728     }
729     // If the weekly support for the end week is not set, set it to
730     //   the last week's support, to ensure we know what to pay out
731     //   This works even if the end week is the current week; the value
732     //   will be overwritten if necessary by future support changes
733     if(weekGameSupport[endWeek][_game] == 0) {
734       weekGameSupport[endWeek][_game] = lastWeekSupport;
735     }
736     // Always update the last payout week
737     lastPayoutWeekByGame[_game] = endWeek;
738 
739     erc20Contract.transfer(msg.sender, _payout);
740     emit Payout(msg.sender, _game, _payout, endWeek);
741   }
742 
743   // @dev Adds or removes a game from the list of promoted games
744   // @param _game - the game to be promoted
745   // @param _isPromoted - true for promoted, false for not
746   // @param _json - A json string to be used to display promotional information
747   function setPromotedGame(uint _game, bool _isPromoted, string calldata _json)
748     external
749     ownerOrRecovery
750   {
751     uint gameId = gameContract.games(_game);
752     require(gameId == _game, "gameIds must match");
753     emit PromotedGame(_game, _isPromoted, _isPromoted ? _json : "");
754   }
755 
756   // @dev Adds or removes a game from the list of suppressed games.
757   //   Suppressed games won't show up on the site, but can still be interacted with
758   //   by users.
759   // @param _game - the game to be promoted
760   // @param _isSuppressed - true for suppressed, false for not
761   function setSuppressedGame(uint _game, bool _isSuppressed)
762     external
763     ownerOrRecovery
764   {
765     uint gameId = gameContract.games(_game);
766     require(gameId == _game, "gameIds must match");
767     emit SuppressedGame(_game, _isSuppressed);
768   }
769 
770   // @dev This support contract doesn't implement receiveGameCredits
771   function receiveGameCredits(uint, address, uint, uint, bytes32)
772     external
773   {
774     revert("This support contract doesn't implement receiveGameCredits");
775   }
776 
777   // @dev This support contract doesn't implement receiveLoyaltyPayment
778   function receiveLoyaltyPayment(uint, address, uint, uint, bytes32)
779     external
780   {
781     revert("This support contract doesn't implement receiveLoyaltyPayment");
782   }
783 
784   // @dev This support contract doesn't implement contestEntry
785   function contestEntry(uint, address, uint, uint, uint, bytes32)
786     external
787   {
788     revert("This support contract doesn't implement contestEntry");
789   }
790 }