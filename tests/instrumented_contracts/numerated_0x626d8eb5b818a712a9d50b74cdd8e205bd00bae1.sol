1 pragma solidity ^0.7.0;
2 
3 library DSMath {
4     /// @dev github.com/makerdao/dss implementation
5     /// of exponentiation by squaring
6     //  nth power of x mod b
7     function rpow(uint x, uint n, uint b) internal pure returns (uint z) {
8       assembly {
9         switch x case 0 {switch n case 0 {z := b} default {z := 0}}
10         default {
11           switch mod(n, 2) case 0 { z := b } default { z := x }
12           let half := div(b, 2)  // for rounding.
13           for { n := div(n, 2) } n { n := div(n,2) } {
14             let xx := mul(x, x)
15             if iszero(eq(div(xx, x), x)) { revert(0,0) }
16             let xxRound := add(xx, half)
17             if lt(xxRound, xx) { revert(0,0) }
18             x := div(xxRound, b)
19             if mod(n,2) {
20               let zx := mul(z, x)
21               if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
22               let zxRound := add(zx, half)
23               if lt(zxRound, zx) { revert(0,0) }
24               z := div(zxRound, b)
25             }
26           }
27         }
28       }
29     }
30 }
31 
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address payable) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes memory) {
38         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
39         return msg.data;
40     }
41 }
42 
43 
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(_owner == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      *
106      * - Addition cannot overflow.
107      */
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         require(c >= a, "SafeMath: addition overflow");
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      *
123      * - Subtraction cannot overflow.
124      */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         return sub(a, b, "SafeMath: subtraction overflow");
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b <= a, errorMessage);
141         uint256 c = a - b;
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the multiplication of two unsigned integers, reverting on
148      * overflow.
149      *
150      * Counterpart to Solidity's `*` operator.
151      *
152      * Requirements:
153      *
154      * - Multiplication cannot overflow.
155      */
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158         // benefit is lost if 'b' is also tested.
159         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
160         if (a == 0) {
161             return 0;
162         }
163 
164         uint256 c = a * b;
165         require(c / a == b, "SafeMath: multiplication overflow");
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the integer division of two unsigned integers. Reverts on
172      * division by zero. The result is rounded towards zero.
173      *
174      * Counterpart to Solidity's `/` operator. Note: this function uses a
175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
176      * uses an invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      *
180      * - The divisor cannot be zero.
181      */
182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
183         return div(a, b, "SafeMath: division by zero");
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b > 0, errorMessage);
200         uint256 c = a / b;
201         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * Reverts when dividing by zero.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
219         return mod(a, b, "SafeMath: modulo by zero");
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts with custom message when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b != 0, errorMessage);
236         return a % b;
237     }
238 }
239 
240 interface IERC20 {
241     /**
242      * @dev Returns the amount of tokens in existence.
243      */
244     function totalSupply() external view returns (uint256);
245 
246     /**
247      * @dev Returns the amount of tokens owned by `account`.
248      */
249     function balanceOf(address account) external view returns (uint256);
250 
251     /**
252      * @dev Moves `amount` tokens from the caller's account to `recipient`.
253      *
254      * Returns a boolean value indicating whether the operation succeeded.
255      *
256      * Emits a {Transfer} event.
257      */
258     function transfer(address recipient, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Returns the remaining number of tokens that `spender` will be
262      * allowed to spend on behalf of `owner` through {transferFrom}. This is
263      * zero by default.
264      *
265      * This value changes when {approve} or {transferFrom} are called.
266      */
267     function allowance(address owner, address spender) external view returns (uint256);
268 
269     /**
270      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
271      *
272      * Returns a boolean value indicating whether the operation succeeded.
273      *
274      * IMPORTANT: Beware that changing an allowance with this method brings the risk
275      * that someone may use both the old and the new allowance by unfortunate
276      * transaction ordering. One possible solution to mitigate this race
277      * condition is to first reduce the spender's allowance to 0 and set the
278      * desired value afterwards:
279      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
280      *
281      * Emits an {Approval} event.
282      */
283     function approve(address spender, uint256 amount) external returns (bool);
284 
285     /**
286      * @dev Moves `amount` tokens from `sender` to `recipient` using the
287      * allowance mechanism. `amount` is then deducted from the caller's
288      * allowance.
289      *
290      * Returns a boolean value indicating whether the operation succeeded.
291      *
292      * Emits a {Transfer} event.
293      */
294     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
295 
296     /**
297      * @dev Emitted when `value` tokens are moved from one account (`from`) to
298      * another (`to`).
299      *
300      * Note that `value` may be zero.
301      */
302     event Transfer(address indexed from, address indexed to, uint256 value);
303 
304     /**
305      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
306      * a call to {approve}. `value` is the new allowance.
307      */
308     event Approval(address indexed owner, address indexed spender, uint256 value);
309 }
310 
311 contract CompoundRateKeeper is Ownable {
312     using SafeMath for uint256;
313 
314     struct CompoundRate {
315         uint256 rate;
316         uint256 lastUpdate;
317     }
318 
319     CompoundRate public compoundRate;
320 
321     constructor () {
322         compoundRate.rate = 1 * 10 ** 27;
323         compoundRate.lastUpdate = block.timestamp;
324     }
325 
326     function getCurrentRate() view external returns(uint256) {
327         return compoundRate.rate;
328     }
329 
330     function getLastUpdate() view external returns(uint256) {
331         return compoundRate.lastUpdate;
332     }
333 
334     function update(uint256 _interestRate) external onlyOwner returns(uint256) {
335         uint256 _decimal = 10 ** 27;
336         uint256 _period = (block.timestamp).sub(compoundRate.lastUpdate);
337         uint256 _newRate = compoundRate.rate
338         .mul(DSMath.rpow(_interestRate.add(_decimal), _period, _decimal)).div(_decimal);
339 
340         compoundRate.rate = _newRate;
341         compoundRate.lastUpdate = block.timestamp;
342 
343         return _newRate;
344     }
345 }
346 
347 interface IEpanStaking {
348     /**
349      * @notice Update compound rate
350      */
351     function updateCompoundRate() external;
352 
353     /**
354      * @notice Update compound rate timeframe
355      */
356     function updateCompoundRateTimeframe() external;
357 
358     /**
359      * @notice Update both compound rates
360      */
361     function updateCompoundRates() external;
362 
363     /**
364      * @notice Update compound rate and stake tokens to user balance
365      * @param _amount Amount to stake
366      * @param _isTimeframe If true, stake to timeframe structure
367      */
368     function updateCompoundAndStake(uint256 _amount, bool _isTimeframe) external returns (bool);
369 
370     /**
371      * @notice Update compound rate and withdraw tokens from contract
372      * @param _amount Amount to stake
373      * @param _isTimeframe If true, withdraw from timeframe structure
374      */
375     function updateCompoundAndWithdraw(uint256 _amount, bool _isTimeframe) external returns (bool);
376 
377     /**
378      * @notice Stake tokens to user balance
379      * @param _amount Amount to stake
380      * @param _isTimeframe If true, stake to timeframe structure
381      */
382     function stake(uint256 _amount, bool _isTimeframe) external returns (bool);
383 
384     /**
385      * @notice Withdraw tokens from user balance. Only for timeframe stake
386      * @param _amount Amount to withdraw
387      * @param _isTimeframe If true, withdraws from timeframe structure
388      */
389     function withdraw(uint256 _amount, bool _isTimeframe) external returns (bool);
390 
391     /**
392      * @notice Returns the staking balance of the user
393      * @param _isTimeframe If true, return balance from timeframe structure
394      */
395     function getBalance(bool _isTimeframe) external view returns (uint256);
396 
397     /**
398     * @notice Set interest rate
399     */
400     function setInterestRate(uint256 _newInterestRate) external;
401 
402     /**
403     * @notice Set interest rate timeframe
404     * @param _newInterestRate New interest rate
405     */
406     function setInterestRateTimeframe(uint256 _newInterestRate) external;
407 
408     /**
409      * @notice Set interest rates
410      * @param _newInterestRateTimeframe New interest rate timeframe
411      */
412     function setInterestRates(uint256 _newInterestRate, uint256 _newInterestRateTimeframe) external;
413 
414     /**
415      * @notice Add tokens to contract address to be spent as rewards
416      * @param _amount Token amount that will be added to contract as reward
417      */
418     function supplyRewardPool(uint256 _amount) external returns (bool);
419 
420     /**
421      * @notice Get reward amount for sender address
422      * @param _isTimeframe If timeframe, calculate reward for user from timeframe structure
423      */
424     function getRewardAmount(bool _isTimeframe) external view returns (uint256);
425 
426     /**
427      * @notice Get coefficient. Tokens on the contract / reward to be paid
428      */
429     function monitorSecurityMargin() external view returns (uint256);
430 }
431 
432 
433 contract EpanStaking is IEpanStaking, Ownable {
434     using SafeMath for uint;
435 
436     CompoundRateKeeper public compRateKeeper;
437     CompoundRateKeeper public compRateKeeperTimeframe;
438     IERC20 public epanToken;
439 
440     struct Stake {
441         uint256 amount;
442         uint256 normalizedAmount;
443     }
444 
445     struct StakeTimeframe {
446         uint256 amount;
447         uint256 normalizedAmount;
448         uint256 lastStakeTime;
449     }
450 
451     uint256 public interestRate;
452     uint256 public interestRateTimeframe;
453 
454     mapping(address => Stake) public userStakes;
455     mapping(address => StakeTimeframe) public userStakesTimeframe;
456 
457     uint256 public aggregatedNormalizedStake;
458     uint256 public aggregatedNormalizedStakeTimeframe;
459 
460     constructor(address _token, address _compRateKeeper, address _compRateKeeperTimeframe) {
461         compRateKeeper = CompoundRateKeeper(_compRateKeeper);
462         compRateKeeperTimeframe = CompoundRateKeeper(_compRateKeeperTimeframe);
463         epanToken = IERC20(_token);
464     }
465 
466     /**
467      * @notice Update compound rate
468      */
469     function updateCompoundRate() public override {
470         compRateKeeper.update(interestRate);
471     }
472 
473     /**
474      * @notice Update compound rate timeframe
475      */
476     function updateCompoundRateTimeframe() public override {
477         compRateKeeperTimeframe.update(interestRateTimeframe);
478     }
479 
480     /**
481      * @notice Update both compound rates
482      */
483     function updateCompoundRates() public override {
484         updateCompoundRate();
485         updateCompoundRateTimeframe();
486     }
487 
488     /**
489      * @notice Update compound rate and stake tokens to user balance
490      * @param _amount Amount to stake
491      * @param _isTimeframe If true, stake to timeframe structure
492      */
493     function updateCompoundAndStake(uint256 _amount, bool _isTimeframe) external override returns (bool) {
494         updateCompoundRates();
495         return stake(_amount, _isTimeframe);
496     }
497 
498     /**
499      * @notice Update compound rate and withdraw tokens from contract
500      * @param _amount Amount to stake
501      * @param _isTimeframe If true, withdraw from timeframe structure
502      */
503     function updateCompoundAndWithdraw(uint256 _amount, bool _isTimeframe) external override returns (bool) {
504         updateCompoundRates();
505         return withdraw(_amount, _isTimeframe);
506     }
507 
508     /**
509      * @notice Stake tokens to user balance
510      * @param _amount Amount to stake
511      * @param _isTimeframe If true, stake to timeframe structure
512      */
513     function stake(uint256 _amount, bool _isTimeframe) public override returns (bool) {
514         require(_amount > 0, "[E-11]-Invalid value for the stake amount, failed to stake a zero value.");
515 
516         if (_isTimeframe) {
517             StakeTimeframe memory _stake = userStakesTimeframe[msg.sender];
518 
519             uint256 _newAmount = _getBalance(_stake.normalizedAmount, true).add(_amount);
520             uint256 _newNormalizedAmount = _newAmount.mul(10 ** 27).div(compRateKeeperTimeframe.getCurrentRate());
521 
522             aggregatedNormalizedStakeTimeframe = aggregatedNormalizedStakeTimeframe.add(_newNormalizedAmount)
523             .sub(_stake.normalizedAmount);
524 
525             userStakesTimeframe[msg.sender].amount = _stake.amount.add(_amount);
526             userStakesTimeframe[msg.sender].normalizedAmount = _newNormalizedAmount;
527             userStakesTimeframe[msg.sender].lastStakeTime = block.timestamp;
528 
529         } else {
530             Stake memory _stake = userStakes[msg.sender];
531 
532             uint256 _newAmount = _getBalance(_stake.normalizedAmount, false).add(_amount);
533             uint256 _newNormalizedAmount = _newAmount.mul(10 ** 27).div(compRateKeeper.getCurrentRate());
534 
535             aggregatedNormalizedStake = aggregatedNormalizedStake.add(_newNormalizedAmount)
536             .sub(_stake.normalizedAmount);
537 
538             userStakes[msg.sender].amount = _stake.amount.add(_amount);
539             userStakes[msg.sender].normalizedAmount = _newNormalizedAmount;
540         }
541 
542         require(epanToken.transferFrom(msg.sender, address(this), _amount), "[E-12]-Failed to transfer token.");
543 
544         return true;
545     }
546 
547     /**
548      * @notice Withdraw tokens from user balance. Only for timeframe stake
549      * @param _amount Amount to withdraw
550      * @param _isTimeframe If true, withdraws from timeframe structure
551      */
552     function withdraw(uint256 _amount, bool _isTimeframe) public override returns (bool) {
553         uint256 _withdrawAmount = _amount;
554 
555         if (_isTimeframe) {
556             StakeTimeframe memory _stake = userStakesTimeframe[msg.sender];
557 
558             uint256 _userAmount = _getBalance(_stake.normalizedAmount, true);
559 
560             require(_userAmount != 0, "[E-31]-The deposit does not exist, failed to withdraw.");
561             require(block.timestamp - _stake.lastStakeTime > 180 days, "[E-32]-Funds are not available for withdraw.");
562 
563             if (_userAmount < _withdrawAmount) _withdrawAmount = _userAmount;
564 
565             uint256 _newAmount = _userAmount.sub(_withdrawAmount);
566             uint256 _newNormalizedAmount = _newAmount.mul(10 ** 27).div(compRateKeeperTimeframe.getCurrentRate());
567 
568             aggregatedNormalizedStakeTimeframe = aggregatedNormalizedStakeTimeframe.add(_newNormalizedAmount)
569             .sub(_stake.normalizedAmount);
570 
571             if (_withdrawAmount > _getRewardAmount(_stake.amount, _stake.normalizedAmount, _isTimeframe)) {
572                 userStakesTimeframe[msg.sender].amount = _newAmount;
573             }
574             userStakesTimeframe[msg.sender].normalizedAmount = _newNormalizedAmount;
575 
576         } else {
577             Stake memory _stake = userStakes[msg.sender];
578 
579             uint256 _userAmount = _getBalance(_stake.normalizedAmount, false);
580 
581             require(_userAmount != 0, "[E-33]-The deposit does not exist, failed to withdraw.");
582 
583             if (_userAmount < _withdrawAmount) _withdrawAmount = _userAmount;
584 
585             uint256 _newAmount = _getBalance(_stake.normalizedAmount, false).sub(_withdrawAmount);
586             uint256 _newNormalizedAmount = _newAmount.mul(10 ** 27).div(compRateKeeper.getCurrentRate());
587 
588             aggregatedNormalizedStake = aggregatedNormalizedStake.add(_newNormalizedAmount)
589             .sub(_stake.normalizedAmount);
590 
591             if (_withdrawAmount > _getRewardAmount(_stake.amount, _stake.normalizedAmount, _isTimeframe)) {
592                 userStakes[msg.sender].amount = _newAmount;
593             }
594             userStakes[msg.sender].normalizedAmount = _newNormalizedAmount;
595         }
596 
597         require(epanToken.transfer(msg.sender, _withdrawAmount), "[E-34]-Failed to transfer token.");
598 
599         return true;
600     }
601 
602     /**
603      * @notice Returns the staking balance of the user
604      * @param _isTimeframe If true, return balance from timeframe structure
605      */
606     function getBalance(bool _isTimeframe) public view override returns (uint256) {
607         if (_isTimeframe) {
608             return _getBalance(userStakesTimeframe[msg.sender].normalizedAmount, true);
609         }
610         return _getBalance(userStakes[msg.sender].normalizedAmount, false);
611     }
612 
613     /**
614      * @notice Returns the staking balance of the user
615      * @param _normalizedAmount User normalized amount
616      * @param _isTimeframe If true, return balance from timeframe structure
617      */
618     function _getBalance(uint256 _normalizedAmount, bool _isTimeframe) private view returns (uint256) {
619         if (_isTimeframe) {
620             return _normalizedAmount.mul(compRateKeeperTimeframe.getCurrentRate()).div(10 ** 27);
621         }
622         return _normalizedAmount.mul(compRateKeeper.getCurrentRate()).div(10 ** 27);
623     }
624 
625     /**
626      * @notice Set interest rate
627      */
628     function setInterestRate(uint256 _newInterestRate) external override onlyOwner {
629         require(_newInterestRate <= 158548959918822932522, "[E-202]-Can't be more than 500%.");
630         
631         updateCompoundRate();
632         interestRate = _newInterestRate;
633     }
634 
635     /**
636     * @notice Set interest rate timeframe
637     * @param _newInterestRate New interest rate
638     */
639     function setInterestRateTimeframe(uint256 _newInterestRate) external override onlyOwner {
640         require(_newInterestRate <= 158548959918822932522, "[E-211]-Can't be more than 500%.");
641 
642         updateCompoundRateTimeframe();
643         interestRateTimeframe = _newInterestRate;
644     }
645 
646     /**
647      * @notice Set interest rates
648      * @param _newInterestRateTimeframe New interest rate timeframe
649      */
650     function setInterestRates(uint256 _newInterestRate, uint256 _newInterestRateTimeframe) external override onlyOwner {
651         require(_newInterestRate <= 158548959918822932522 && _newInterestRateTimeframe <= 158548959918822932522,
652             "[E-221]-Can't be more than 500%.");
653 
654         updateCompoundRate();
655         updateCompoundRateTimeframe();
656         interestRate = _newInterestRate;
657         interestRateTimeframe = _newInterestRateTimeframe;
658     }
659 
660     /**
661      * @notice Add tokens to contract address to be spent as rewards
662      * @param _amount Token amount that will be added to contract as reward
663      */
664     function supplyRewardPool(uint256 _amount) external override onlyOwner returns (bool) {
665         require(epanToken.transferFrom(msg.sender, address(this), _amount), "[E-231]-Failed to transfer token.");
666         return true;
667     }
668 
669     /**
670      * @notice Get reward amount for sender address
671      * @param _isTimeframe If timeframe, calculate reward for user from timeframe structure
672      */
673     function getRewardAmount(bool _isTimeframe) external view override returns (uint256) {
674         if (_isTimeframe) {
675             StakeTimeframe memory _stake = userStakesTimeframe[msg.sender];
676             return _getRewardAmount(_stake.amount, _stake.normalizedAmount, true);
677         }
678 
679         Stake memory _stake = userStakes[msg.sender];
680         return _getRewardAmount(_stake.amount, _stake.normalizedAmount, false);
681     }
682 
683     /**
684      * @notice Get reward amount by params
685      * @param _amount Token amount
686      * @param _normalizedAmount Normalized token amount
687      * @param _isTimeframe If timeframe, calculate reward for user from timeframe structure
688      */
689     function _getRewardAmount(uint256 _amount, uint256 _normalizedAmount, bool _isTimeframe) private view returns (uint256) {
690         uint256 _balance = 0;
691 
692         if (_isTimeframe) {
693             _balance = _getBalance(_normalizedAmount, _isTimeframe);
694         } else {
695             _balance = _getBalance(_normalizedAmount, _isTimeframe);
696         }
697 
698         if (_balance <= _amount) return 0;
699         return _balance.sub(_amount);
700     }
701 
702     /**
703      * @notice Get coefficient. Tokens on the contract / total stake + total reward to be paid
704      */
705     function monitorSecurityMargin() external view override onlyOwner returns (uint256) {
706         uint256 _contractBalance = epanToken.balanceOf(address(this));
707         uint256 _toReward = aggregatedNormalizedStake.mul(compRateKeeper.getCurrentRate()).div(10 ** 27);
708         uint256 _toRewardTimeframe = aggregatedNormalizedStakeTimeframe.mul(compRateKeeperTimeframe.getCurrentRate())
709         .div(10 ** 27);
710 
711         return _contractBalance.mul(10 ** 27).div(_toReward.add(_toRewardTimeframe));
712     }
713 }