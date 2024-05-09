1 /**
2  *Submitted for verification at BscScan.com on 2021-07-12
3 */
4 
5 pragma solidity ^0.7.0;
6 
7 library DSMath {
8     /// @dev github.com/makerdao/dss implementation
9     /// of exponentiation by squaring
10     //  nth power of x mod b
11     function rpow(uint x, uint n, uint b) internal pure returns (uint z) {
12       assembly {
13         switch x case 0 {switch n case 0 {z := b} default {z := 0}}
14         default {
15           switch mod(n, 2) case 0 { z := b } default { z := x }
16           let half := div(b, 2)  // for rounding.
17           for { n := div(n, 2) } n { n := div(n,2) } {
18             let xx := mul(x, x)
19             if iszero(eq(div(xx, x), x)) { revert(0,0) }
20             let xxRound := add(xx, half)
21             if lt(xxRound, xx) { revert(0,0) }
22             x := div(xxRound, b)
23             if mod(n,2) {
24               let zx := mul(z, x)
25               if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
26               let zxRound := add(zx, half)
27               if lt(zxRound, zx) { revert(0,0) }
28               z := div(zxRound, b)
29             }
30           }
31         }
32       }
33     }
34 }
35 
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address payable) {
38         return msg.sender;
39     }
40 
41     function _msgData() internal view virtual returns (bytes memory) {
42         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
43         return msg.data;
44     }
45 }
46 
47 
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor () internal {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(_owner == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98 }
99 
100 
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `+` operator.
107      *
108      * Requirements:
109      *
110      * - Addition cannot overflow.
111      */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a, "SafeMath: addition overflow");
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      *
127      * - Subtraction cannot overflow.
128      */
129     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130         return sub(a, b, "SafeMath: subtraction overflow");
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         require(b <= a, errorMessage);
145         uint256 c = a - b;
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the multiplication of two unsigned integers, reverting on
152      * overflow.
153      *
154      * Counterpart to Solidity's `*` operator.
155      *
156      * Requirements:
157      *
158      * - Multiplication cannot overflow.
159      */
160     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
162         // benefit is lost if 'b' is also tested.
163         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
164         if (a == 0) {
165             return 0;
166         }
167 
168         uint256 c = a * b;
169         require(c / a == b, "SafeMath: multiplication overflow");
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers. Reverts on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `/` operator. Note: this function uses a
179      * `revert` opcode (which leaves remaining gas untouched) while Solidity
180      * uses an invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function div(uint256 a, uint256 b) internal pure returns (uint256) {
187         return div(a, b, "SafeMath: division by zero");
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
203         require(b > 0, errorMessage);
204         uint256 c = a / b;
205         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * Reverts when dividing by zero.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
223         return mod(a, b, "SafeMath: modulo by zero");
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts with custom message when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b != 0, errorMessage);
240         return a % b;
241     }
242 }
243 
244 interface IERC20 {
245     /**
246      * @dev Returns the amount of tokens in existence.
247      */
248     function totalSupply() external view returns (uint256);
249 
250     /**
251      * @dev Returns the amount of tokens owned by `account`.
252      */
253     function balanceOf(address account) external view returns (uint256);
254 
255     /**
256      * @dev Moves `amount` tokens from the caller's account to `recipient`.
257      *
258      * Returns a boolean value indicating whether the operation succeeded.
259      *
260      * Emits a {Transfer} event.
261      */
262     function transfer(address recipient, uint256 amount) external returns (bool);
263 
264     /**
265      * @dev Returns the remaining number of tokens that `spender` will be
266      * allowed to spend on behalf of `owner` through {transferFrom}. This is
267      * zero by default.
268      *
269      * This value changes when {approve} or {transferFrom} are called.
270      */
271     function allowance(address owner, address spender) external view returns (uint256);
272 
273     /**
274      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
275      *
276      * Returns a boolean value indicating whether the operation succeeded.
277      *
278      * IMPORTANT: Beware that changing an allowance with this method brings the risk
279      * that someone may use both the old and the new allowance by unfortunate
280      * transaction ordering. One possible solution to mitigate this race
281      * condition is to first reduce the spender's allowance to 0 and set the
282      * desired value afterwards:
283      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
284      *
285      * Emits an {Approval} event.
286      */
287     function approve(address spender, uint256 amount) external returns (bool);
288 
289     /**
290      * @dev Moves `amount` tokens from `sender` to `recipient` using the
291      * allowance mechanism. `amount` is then deducted from the caller's
292      * allowance.
293      *
294      * Returns a boolean value indicating whether the operation succeeded.
295      *
296      * Emits a {Transfer} event.
297      */
298     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
299 
300     /**
301      * @dev Emitted when `value` tokens are moved from one account (`from`) to
302      * another (`to`).
303      *
304      * Note that `value` may be zero.
305      */
306     event Transfer(address indexed from, address indexed to, uint256 value);
307 
308     /**
309      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
310      * a call to {approve}. `value` is the new allowance.
311      */
312     event Approval(address indexed owner, address indexed spender, uint256 value);
313 }
314 
315 contract CompoundRateKeeper is Ownable {
316     using SafeMath for uint256;
317 
318     struct CompoundRate {
319         uint256 rate;
320         uint256 lastUpdate;
321     }
322 
323     CompoundRate public compoundRate;
324 
325     constructor () {
326         compoundRate.rate = 1 * 10 ** 27;
327         compoundRate.lastUpdate = block.timestamp;
328     }
329 
330     function getCurrentRate() view external returns(uint256) {
331         return compoundRate.rate;
332     }
333 
334     function getLastUpdate() view external returns(uint256) {
335         return compoundRate.lastUpdate;
336     }
337 
338     function update(uint256 _interestRate) external onlyOwner returns(uint256) {
339         uint256 _decimal = 10 ** 27;
340         uint256 _period = (block.timestamp).sub(compoundRate.lastUpdate);
341         uint256 _newRate = compoundRate.rate
342         .mul(DSMath.rpow(_interestRate.add(_decimal), _period, _decimal)).div(_decimal);
343 
344         compoundRate.rate = _newRate;
345         compoundRate.lastUpdate = block.timestamp;
346 
347         return _newRate;
348     }
349 }
350 
351 interface IMetaxStaking {
352     /**
353      * @notice Update compound rate
354      */
355     function updateCompoundRate() external;
356 
357     /**
358      * @notice Update compound rate timeframe
359      */
360     function updateCompoundRateTimeframe() external;
361 
362     /**
363      * @notice Update both compound rates
364      */
365     function updateCompoundRates() external;
366 
367     /**
368      * @notice Update compound rate and stake tokens to user balance
369      * @param _amount Amount to stake
370      * @param _isTimeframe If true, stake to timeframe structure
371      */
372     function updateCompoundAndStake(uint256 _amount, bool _isTimeframe) external returns (bool);
373 
374     /**
375      * @notice Update compound rate and withdraw tokens from contract
376      * @param _amount Amount to stake
377      * @param _isTimeframe If true, withdraw from timeframe structure
378      */
379     function updateCompoundAndWithdraw(uint256 _amount, bool _isTimeframe) external returns (bool);
380 
381     /**
382      * @notice Stake tokens to user balance
383      * @param _amount Amount to stake
384      * @param _isTimeframe If true, stake to timeframe structure
385      */
386     function stake(uint256 _amount, bool _isTimeframe) external returns (bool);
387 
388     /**
389      * @notice Withdraw tokens from user balance. Only for timeframe stake
390      * @param _amount Amount to withdraw
391      * @param _isTimeframe If true, withdraws from timeframe structure
392      */
393     function withdraw(uint256 _amount, bool _isTimeframe) external returns (bool);
394 
395     /**
396      * @notice Returns the staking balance of the user
397      * @param _isTimeframe If true, return balance from timeframe structure
398      */
399     function getBalance(bool _isTimeframe) external view returns (uint256);
400 
401     /**
402     * @notice Set interest rate
403     */
404     function setInterestRate(uint256 _newInterestRate) external;
405 
406     /**
407     * @notice Set interest rate timeframe
408     * @param _newInterestRate New interest rate
409     */
410     function setInterestRateTimeframe(uint256 _newInterestRate) external;
411 
412     /**
413      * @notice Set interest rates
414      * @param _newInterestRateTimeframe New interest rate timeframe
415      */
416     function setInterestRates(uint256 _newInterestRate, uint256 _newInterestRateTimeframe) external;
417 
418     /**
419      * @notice Add tokens to contract address to be spent as rewards
420      * @param _amount Token amount that will be added to contract as reward
421      */
422     function supplyRewardPool(uint256 _amount) external returns (bool);
423 
424     /**
425      * @notice Get reward amount for sender address
426      * @param _isTimeframe If timeframe, calculate reward for user from timeframe structure
427      */
428     function getRewardAmount(bool _isTimeframe) external view returns (uint256);
429 
430     /**
431      * @notice Get coefficient. Tokens on the contract / reward to be paid
432      */
433     function monitorSecurityMargin() external view returns (uint256);
434 }
435 
436 
437 contract MetaxStaking is IMetaxStaking, Ownable {
438     using SafeMath for uint;
439     
440     uint256 constant INTEREST_500_THRESHOLD = 51034942716352291304;
441 
442     CompoundRateKeeper public compRateKeeper;
443     CompoundRateKeeper public compRateKeeperTimeframe;
444     IERC20 public token;
445 
446     struct Stake {
447         uint256 amount;
448         uint256 normalizedAmount;
449     }
450 
451     struct StakeTimeframe {
452         uint256 amount;
453         uint256 normalizedAmount;
454         uint256 lastStakeTime;
455     }
456 
457     uint256 public interestRate;
458     uint256 public interestRateTimeframe;
459 
460     mapping(address => Stake) public userStakes;
461     mapping(address => StakeTimeframe) public userStakesTimeframe;
462 
463     uint256 public aggregatedNormalizedStake;
464     uint256 public aggregatedNormalizedStakeTimeframe;
465 
466     constructor(address _token, address _compRateKeeper, address _compRateKeeperTimeframe) {
467         compRateKeeper = CompoundRateKeeper(_compRateKeeper);
468         compRateKeeperTimeframe = CompoundRateKeeper(_compRateKeeperTimeframe);
469         token = IERC20(_token);
470     }
471 
472     /**
473      * @notice Update compound rate
474      */
475     function updateCompoundRate() public override {
476         compRateKeeper.update(interestRate);
477     }
478 
479     /**
480      * @notice Update compound rate timeframe
481      */
482     function updateCompoundRateTimeframe() public override {
483         compRateKeeperTimeframe.update(interestRateTimeframe);
484     }
485 
486     /**
487      * @notice Update both compound rates
488      */
489     function updateCompoundRates() public override {
490         updateCompoundRate();
491         updateCompoundRateTimeframe();
492     }
493 
494     /**
495      * @notice Update compound rate and stake tokens to user balance
496      * @param _amount Amount to stake
497      * @param _isTimeframe If true, stake to timeframe structure
498      */
499     function updateCompoundAndStake(uint256 _amount, bool _isTimeframe) external override returns (bool) {
500         updateCompoundRates();
501         return stake(_amount, _isTimeframe);
502     }
503 
504     /**
505      * @notice Update compound rate and withdraw tokens from contract
506      * @param _amount Amount to stake
507      * @param _isTimeframe If true, withdraw from timeframe structure
508      */
509     function updateCompoundAndWithdraw(uint256 _amount, bool _isTimeframe) external override returns (bool) {
510         updateCompoundRates();
511         return withdraw(_amount, _isTimeframe);
512     }
513 
514     /**
515      * @notice Stake tokens to user balance
516      * @param _amount Amount to stake
517      * @param _isTimeframe If true, stake to timeframe structure
518      */
519     function stake(uint256 _amount, bool _isTimeframe) public override returns (bool) {
520         require(_amount > 0, "[E-11]-Invalid value for the stake amount, failed to stake a zero value.");
521 
522         if (_isTimeframe) {
523             StakeTimeframe memory _stake = userStakesTimeframe[msg.sender];
524 
525             uint256 _newAmount = _getBalance(_stake.normalizedAmount, true).add(_amount);
526             uint256 _newNormalizedAmount = _newAmount.mul(10 ** 27).div(compRateKeeperTimeframe.getCurrentRate());
527 
528             aggregatedNormalizedStakeTimeframe = aggregatedNormalizedStakeTimeframe.add(_newNormalizedAmount)
529             .sub(_stake.normalizedAmount);
530 
531             userStakesTimeframe[msg.sender].amount = _stake.amount.add(_amount);
532             userStakesTimeframe[msg.sender].normalizedAmount = _newNormalizedAmount;
533             userStakesTimeframe[msg.sender].lastStakeTime = block.timestamp;
534 
535         } else {
536             Stake memory _stake = userStakes[msg.sender];
537 
538             uint256 _newAmount = _getBalance(_stake.normalizedAmount, false).add(_amount);
539             uint256 _newNormalizedAmount = _newAmount.mul(10 ** 27).div(compRateKeeper.getCurrentRate());
540 
541             aggregatedNormalizedStake = aggregatedNormalizedStake.add(_newNormalizedAmount)
542             .sub(_stake.normalizedAmount);
543 
544             userStakes[msg.sender].amount = _stake.amount.add(_amount);
545             userStakes[msg.sender].normalizedAmount = _newNormalizedAmount;
546         }
547 
548         require(token.transferFrom(msg.sender, address(this), _amount), "[E-12]-Failed to transfer token.");
549 
550         return true;
551     }
552 
553     /**
554      * @notice Withdraw tokens from user balance. Only for timeframe stake
555      * @param _amount Amount to withdraw
556      * @param _isTimeframe If true, withdraws from timeframe structure
557      */
558     function withdraw(uint256 _amount, bool _isTimeframe) public override returns (bool) {
559         uint256 _withdrawAmount = _amount;
560 
561         if (_isTimeframe) {
562             StakeTimeframe memory _stake = userStakesTimeframe[msg.sender];
563 
564             uint256 _userAmount = _getBalance(_stake.normalizedAmount, true);
565 
566             require(_userAmount != 0, "[E-31]-The deposit does not exist, failed to withdraw.");
567             require(block.timestamp - _stake.lastStakeTime > 180 days, "[E-32]-Funds are not available for withdraw.");
568 
569             if (_userAmount < _withdrawAmount) _withdrawAmount = _userAmount;
570 
571             uint256 _newAmount = _userAmount.sub(_withdrawAmount);
572             uint256 _newNormalizedAmount = _newAmount.mul(10 ** 27).div(compRateKeeperTimeframe.getCurrentRate());
573 
574             aggregatedNormalizedStakeTimeframe = aggregatedNormalizedStakeTimeframe.add(_newNormalizedAmount)
575             .sub(_stake.normalizedAmount);
576 
577             if (_withdrawAmount > _getRewardAmount(_stake.amount, _stake.normalizedAmount, _isTimeframe)) {
578                 userStakesTimeframe[msg.sender].amount = _newAmount;
579             }
580             userStakesTimeframe[msg.sender].normalizedAmount = _newNormalizedAmount;
581 
582         } else {
583             Stake memory _stake = userStakes[msg.sender];
584 
585             uint256 _userAmount = _getBalance(_stake.normalizedAmount, false);
586 
587             require(_userAmount != 0, "[E-33]-The deposit does not exist, failed to withdraw.");
588 
589             if (_userAmount < _withdrawAmount) _withdrawAmount = _userAmount;
590 
591             uint256 _newAmount = _getBalance(_stake.normalizedAmount, false).sub(_withdrawAmount);
592             uint256 _newNormalizedAmount = _newAmount.mul(10 ** 27).div(compRateKeeper.getCurrentRate());
593 
594             aggregatedNormalizedStake = aggregatedNormalizedStake.add(_newNormalizedAmount)
595             .sub(_stake.normalizedAmount);
596 
597             if (_withdrawAmount > _getRewardAmount(_stake.amount, _stake.normalizedAmount, _isTimeframe)) {
598                 userStakes[msg.sender].amount = _newAmount;
599             }
600             userStakes[msg.sender].normalizedAmount = _newNormalizedAmount;
601         }
602 
603         require(token.transfer(msg.sender, _withdrawAmount), "[E-34]-Failed to transfer token.");
604 
605         return true;
606     }
607 
608     /**
609      * @notice Returns the staking balance of the user
610      * @param _isTimeframe If true, return balance from timeframe structure
611      */
612     function getBalance(bool _isTimeframe) public view override returns (uint256) {
613         if (_isTimeframe) {
614             return _getBalance(userStakesTimeframe[msg.sender].normalizedAmount, true);
615         }
616         return _getBalance(userStakes[msg.sender].normalizedAmount, false);
617     }
618 
619     /**
620      * @notice Returns the staking balance of the user
621      * @param _normalizedAmount User normalized amount
622      * @param _isTimeframe If true, return balance from timeframe structure
623      */
624     function _getBalance(uint256 _normalizedAmount, bool _isTimeframe) private view returns (uint256) {
625         if (_isTimeframe) {
626             return _normalizedAmount.mul(compRateKeeperTimeframe.getCurrentRate()).div(10 ** 27);
627         }
628         return _normalizedAmount.mul(compRateKeeper.getCurrentRate()).div(10 ** 27);
629     }
630 
631     /**
632      * @notice Set interest rate
633      */
634     function setInterestRate(uint256 _newInterestRate) external override onlyOwner {
635         require(_newInterestRate <= INTEREST_500_THRESHOLD, "[E-202]-Can't be more than 500%.");
636         
637         updateCompoundRate();
638         interestRate = _newInterestRate;
639     }
640 
641     /**
642     * @notice Set interest rate timeframe
643     * @param _newInterestRate New interest rate
644     */
645     function setInterestRateTimeframe(uint256 _newInterestRate) external override onlyOwner {
646         require(_newInterestRate <= INTEREST_500_THRESHOLD, "[E-211]-Can't be more than 500%.");
647 
648         updateCompoundRateTimeframe();
649         interestRateTimeframe = _newInterestRate;
650     }
651 
652     /**
653      * @notice Set interest rates
654      * @param _newInterestRateTimeframe New interest rate timeframe
655      */
656     function setInterestRates(uint256 _newInterestRate, uint256 _newInterestRateTimeframe) external override onlyOwner {
657         require(_newInterestRate <= INTEREST_500_THRESHOLD && _newInterestRateTimeframe <= INTEREST_500_THRESHOLD,
658             "[E-221]-Can't be more than 500%.");
659 
660         updateCompoundRate();
661         updateCompoundRateTimeframe();
662         interestRate = _newInterestRate;
663         interestRateTimeframe = _newInterestRateTimeframe;
664     }
665 
666     /**
667      * @notice Add tokens to contract address to be spent as rewards
668      * @param _amount Token amount that will be added to contract as reward
669      */
670     function supplyRewardPool(uint256 _amount) external override onlyOwner returns (bool) {
671         require(token.transferFrom(msg.sender, address(this), _amount), "[E-231]-Failed to transfer token.");
672         return true;
673     }
674 
675     /**
676      * @notice Get reward amount for sender address
677      * @param _isTimeframe If timeframe, calculate reward for user from timeframe structure
678      */
679     function getRewardAmount(bool _isTimeframe) external view override returns (uint256) {
680         if (_isTimeframe) {
681             StakeTimeframe memory _stake = userStakesTimeframe[msg.sender];
682             return _getRewardAmount(_stake.amount, _stake.normalizedAmount, true);
683         }
684 
685         Stake memory _stake = userStakes[msg.sender];
686         return _getRewardAmount(_stake.amount, _stake.normalizedAmount, false);
687     }
688 
689     /**
690      * @notice Get reward amount by params
691      * @param _amount Token amount
692      * @param _normalizedAmount Normalized token amount
693      * @param _isTimeframe If timeframe, calculate reward for user from timeframe structure
694      */
695     function _getRewardAmount(uint256 _amount, uint256 _normalizedAmount, bool _isTimeframe) private view returns (uint256) {
696         uint256 _balance = 0;
697 
698         if (_isTimeframe) {
699             _balance = _getBalance(_normalizedAmount, _isTimeframe);
700         } else {
701             _balance = _getBalance(_normalizedAmount, _isTimeframe);
702         }
703 
704         if (_balance <= _amount) return 0;
705         return _balance.sub(_amount);
706     }
707 
708     /**
709      * @notice Get coefficient. Tokens on the contract / total stake + total reward to be paid
710      */
711     function monitorSecurityMargin() external view override onlyOwner returns (uint256) {
712         uint256 _contractBalance = token.balanceOf(address(this));
713         uint256 _toReward = aggregatedNormalizedStake.mul(compRateKeeper.getCurrentRate()).div(10 ** 27);
714         uint256 _toRewardTimeframe = aggregatedNormalizedStakeTimeframe.mul(compRateKeeperTimeframe.getCurrentRate())
715         .div(10 ** 27);
716 
717         return _contractBalance.mul(10 ** 27).div(_toReward.add(_toRewardTimeframe));
718     }
719 }