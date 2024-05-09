1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.5.17;
4 
5 /*
6  * Docs: https://docs.synthetix.io/
7  *
8  *
9  * MIT License
10  * ===========
11  *
12  * Copyright (c) 2020 Synthetix
13  *
14  * Permission is hereby granted, free of charge, to any person obtaining a copy
15  * of this software and associated documentation files (the "Software"), to deal
16  * in the Software without restriction, including without limitation the rights
17  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
18  * copies of the Software, and to permit persons to whom the Software is
19  * furnished to do so, subject to the following conditions:
20  *
21  * The above copyright notice and this permission notice shall be included in all
22  * copies or substantial portions of the Software.
23  *
24  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
25  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
26  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
27  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
28  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
29  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
30  */
31 
32 library Address {
33     /**
34      * @dev Returns true if `account` is a contract.
35      *
36      * This test is non-exhaustive, and there may be false-negatives: during the
37      * execution of a contract's constructor, its address will be reported as
38      * not containing a contract.
39      *
40      * > It is unsafe to assume that an address for which this function returns
41      * false is an externally-owned account (EOA) and not a contract.
42      */
43     function isContract(address account) internal view returns (bool) {
44         // This method relies in extcodesize, which returns 0 for contracts in
45         // construction, since the code is only stored at the end of the
46         // constructor execution.
47 
48         uint256 size;
49         // solhint-disable-next-line no-inline-assembly
50         assembly {
51             size := extcodesize(account)
52         }
53         return size > 0;
54     }
55 }
56 
57 interface IERC20 {
58     /**
59      * @dev Returns the amount of tokens in existence.
60      */
61     function totalSupply() external view returns (uint256);
62 
63     /**
64      * @dev Returns the amount of tokens owned by `account`.
65      */
66     function balanceOf(address account) external view returns (uint256);
67 
68     /**
69      * @dev Moves `amount` tokens from the caller's account to `recipient`.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a `Transfer` event.
74      */
75     function transfer(address recipient, uint256 amount)
76         external
77         returns (bool);
78 
79     /**
80      * @dev Returns the remaining number of tokens that `spender` will be
81      * allowed to spend on behalf of `owner` through `transferFrom`. This is
82      * zero by default.
83      *
84      * This value changes when `approve` or `transferFrom` are called.
85      */
86     function allowance(address owner, address spender)
87         external
88         view
89         returns (uint256);
90 
91     /**
92      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * > Beware that changing an allowance with this method brings the risk
97      * that someone may use both the old and the new allowance by unfortunate
98      * transaction ordering. One possible solution to mitigate this race
99      * condition is to first reduce the spender's allowance to 0 and set the
100      * desired value afterwards:
101      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
102      *
103      * Emits an `Approval` event.
104      */
105     function approve(address spender, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Moves `amount` tokens from `sender` to `recipient` using the
109      * allowance mechanism. `amount` is then deducted from the caller's
110      * allowance.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * Emits a `Transfer` event.
115      */
116     function transferFrom(
117         address sender,
118         address recipient,
119         uint256 amount
120     ) external returns (bool);
121 
122     /**
123      * @dev Emitted when `value` tokens are moved from one account (`from`) to
124      * another (`to`).
125      *
126      * Note that `value` may be zero.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 value);
129 
130     /**
131      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
132      * a call to `approve`. `value` is the new allowance.
133      */
134     event Approval(
135         address indexed owner,
136         address indexed spender,
137         uint256 value
138     );
139 }
140 
141 interface IStakingRewards {
142     // Views
143     function lastTimeRewardApplicable() external view returns (uint256);
144 
145     function rewardPerToken() external view returns (uint256);
146 
147     function earned(address account) external view returns (uint256);
148 
149     function getRewardForDuration() external view returns (uint256);
150 
151     function totalSupply() external view returns (uint256);
152 
153     function balanceOf(address account) external view returns (uint256);
154 
155     // Mutative
156 
157     function stake(uint256 amount) external;
158 
159     function withdraw(uint256 amount) external;
160 
161     function getReward() external;
162 
163     function exit() external;
164 }
165 
166 library Math {
167     /**
168      * @dev Returns the largest of two numbers.
169      */
170     function max(uint256 a, uint256 b) internal pure returns (uint256) {
171         return a >= b ? a : b;
172     }
173 
174     /**
175      * @dev Returns the smallest of two numbers.
176      */
177     function min(uint256 a, uint256 b) internal pure returns (uint256) {
178         return a < b ? a : b;
179     }
180 
181     /**
182      * @dev Returns the average of two numbers. The result is rounded towards
183      * zero.
184      */
185     function average(uint256 a, uint256 b) internal pure returns (uint256) {
186         // (a + b) / 2 can overflow, so we distribute
187         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
188     }
189 }
190 
191 contract Owned {
192     address public owner;
193     address public nominatedOwner;
194 
195     constructor(address _owner) public {
196         require(_owner != address(0), "Owner address cannot be 0");
197         owner = _owner;
198         emit OwnerChanged(address(0), _owner);
199     }
200 
201     function nominateNewOwner(address _owner) external onlyOwner {
202         nominatedOwner = _owner;
203         emit OwnerNominated(_owner);
204     }
205 
206     function acceptOwnership() external {
207         require(
208             msg.sender == nominatedOwner,
209             "You must be nominated before you can accept ownership"
210         );
211         emit OwnerChanged(owner, nominatedOwner);
212         owner = nominatedOwner;
213         nominatedOwner = address(0);
214     }
215 
216     modifier onlyOwner {
217         _onlyOwner();
218         _;
219     }
220 
221     function _onlyOwner() private view {
222         require(
223             msg.sender == owner,
224             "Only the contract owner may perform this action"
225         );
226     }
227 
228     event OwnerNominated(address newOwner);
229     event OwnerChanged(address oldOwner, address newOwner);
230 }
231 
232 contract Pausable is Owned {
233     uint256 public lastPauseTime;
234     bool public paused;
235 
236     constructor() internal {
237         // This contract is abstract, and thus cannot be instantiated directly
238         require(owner != address(0), "Owner must be set");
239         // Paused will be false, and lastPauseTime will be 0 upon initialisation
240     }
241 
242     /**
243      * @notice Change the paused state of the contract
244      * @dev Only the contract owner may call this.
245      */
246     function setPaused(bool _paused) external onlyOwner {
247         // Ensure we're actually changing the state before we do anything
248         if (_paused == paused) {
249             return;
250         }
251 
252         // Set our paused state.
253         paused = _paused;
254 
255         // If applicable, set the last pause time.
256         if (paused) {
257             lastPauseTime = now;
258         }
259 
260         // Let everyone know that our pause state has changed.
261         emit PauseChanged(paused);
262     }
263 
264     event PauseChanged(bool isPaused);
265 
266     modifier notPaused {
267         require(
268             !paused,
269             "This action cannot be performed while the contract is paused"
270         );
271         _;
272     }
273 }
274 
275 contract ReentrancyGuard {
276     /// @dev counter to allow mutex lock with only one SSTORE operation
277     uint256 private _guardCounter;
278 
279     constructor() internal {
280         // The counter starts at one to prevent changing it from zero to a non-zero
281         // value, which is a more expensive operation.
282         _guardCounter = 1;
283     }
284 
285     /**
286      * @dev Prevents a contract from calling itself, directly or indirectly.
287      * Calling a `nonReentrant` function from another `nonReentrant`
288      * function is not supported. It is possible to prevent this from happening
289      * by making the `nonReentrant` function external, and make it call a
290      * `private` function that does the actual work.
291      */
292     modifier nonReentrant() {
293         _guardCounter += 1;
294         uint256 localCounter = _guardCounter;
295         _;
296         require(
297             localCounter == _guardCounter,
298             "ReentrancyGuard: reentrant call"
299         );
300     }
301 }
302 
303 contract RewardsDistributionRecipient is Owned {
304     address public rewardsDistribution;
305 
306     function notifyRewardAmount(uint256 reward, address rewardHolder) external;
307 
308     modifier onlyRewardsDistribution() {
309         require(
310             msg.sender == rewardsDistribution,
311             "Caller is not RewardsDistribution contract"
312         );
313         _;
314     }
315 
316     function setRewardsDistribution(address _rewardsDistribution)
317         external
318         onlyOwner
319     {
320         rewardsDistribution = _rewardsDistribution;
321     }
322 }
323 
324 library SafeERC20 {
325     using SafeMath for uint256;
326     using Address for address;
327 
328     function safeTransfer(
329         IERC20 token,
330         address to,
331         uint256 value
332     ) internal {
333         callOptionalReturn(
334             token,
335             abi.encodeWithSelector(token.transfer.selector, to, value)
336         );
337     }
338 
339     function safeTransferFrom(
340         IERC20 token,
341         address from,
342         address to,
343         uint256 value
344     ) internal {
345         callOptionalReturn(
346             token,
347             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
348         );
349     }
350 
351     function safeApprove(
352         IERC20 token,
353         address spender,
354         uint256 value
355     ) internal {
356         // safeApprove should only be called when setting an initial allowance,
357         // or when resetting it to zero. To increase and decrease it, use
358         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
359         // solhint-disable-next-line max-line-length
360         require(
361             (value == 0) || (token.allowance(address(this), spender) == 0),
362             "SafeERC20: approve from non-zero to non-zero allowance"
363         );
364         callOptionalReturn(
365             token,
366             abi.encodeWithSelector(token.approve.selector, spender, value)
367         );
368     }
369 
370     function safeIncreaseAllowance(
371         IERC20 token,
372         address spender,
373         uint256 value
374     ) internal {
375         uint256 newAllowance =
376             token.allowance(address(this), spender).add(value);
377         callOptionalReturn(
378             token,
379             abi.encodeWithSelector(
380                 token.approve.selector,
381                 spender,
382                 newAllowance
383             )
384         );
385     }
386 
387     function safeDecreaseAllowance(
388         IERC20 token,
389         address spender,
390         uint256 value
391     ) internal {
392         uint256 newAllowance =
393             token.allowance(address(this), spender).sub(value);
394         callOptionalReturn(
395             token,
396             abi.encodeWithSelector(
397                 token.approve.selector,
398                 spender,
399                 newAllowance
400             )
401         );
402     }
403 
404     /**
405      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
406      * on the return value: the return value is optional (but if data is returned, it must not be false).
407      * @param token The token targeted by the call.
408      * @param data The call data (encoded using abi.encode or one of its variants).
409      */
410     function callOptionalReturn(IERC20 token, bytes memory data) private {
411         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
412         // we're implementing it ourselves.
413 
414         // A Solidity high level call has three parts:
415         //  1. The target address is checked to verify it contains contract code
416         //  2. The call itself is made, and success asserted
417         //  3. The return value is decoded, which in turn checks the size of the returned data.
418         // solhint-disable-next-line max-line-length
419         require(address(token).isContract(), "SafeERC20: call to non-contract");
420 
421         // solhint-disable-next-line avoid-low-level-calls
422         (bool success, bytes memory returndata) = address(token).call(data);
423         require(success, "SafeERC20: low-level call failed");
424 
425         if (returndata.length > 0) {
426             // Return data is optional
427             // solhint-disable-next-line max-line-length
428             require(
429                 abi.decode(returndata, (bool)),
430                 "SafeERC20: ERC20 operation did not succeed"
431             );
432         }
433     }
434 }
435 
436 library SafeMath {
437     /**
438      * @dev Returns the addition of two unsigned integers, reverting on
439      * overflow.
440      *
441      * Counterpart to Solidity's `+` operator.
442      *
443      * Requirements:
444      * - Addition cannot overflow.
445      */
446     function add(uint256 a, uint256 b) internal pure returns (uint256) {
447         uint256 c = a + b;
448         require(c >= a, "SafeMath: addition overflow");
449 
450         return c;
451     }
452 
453     /**
454      * @dev Returns the subtraction of two unsigned integers, reverting on
455      * overflow (when the result is negative).
456      *
457      * Counterpart to Solidity's `-` operator.
458      *
459      * Requirements:
460      * - Subtraction cannot overflow.
461      */
462     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
463         require(b <= a, "SafeMath: subtraction overflow");
464         uint256 c = a - b;
465 
466         return c;
467     }
468 
469     /**
470      * @dev Returns the multiplication of two unsigned integers, reverting on
471      * overflow.
472      *
473      * Counterpart to Solidity's `*` operator.
474      *
475      * Requirements:
476      * - Multiplication cannot overflow.
477      */
478     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
479         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
480         // benefit is lost if 'b' is also tested.
481         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
482         if (a == 0) {
483             return 0;
484         }
485 
486         uint256 c = a * b;
487         require(c / a == b, "SafeMath: multiplication overflow");
488 
489         return c;
490     }
491 
492     /**
493      * @dev Returns the integer division of two unsigned integers. Reverts on
494      * division by zero. The result is rounded towards zero.
495      *
496      * Counterpart to Solidity's `/` operator. Note: this function uses a
497      * `revert` opcode (which leaves remaining gas untouched) while Solidity
498      * uses an invalid opcode to revert (consuming all remaining gas).
499      *
500      * Requirements:
501      * - The divisor cannot be zero.
502      */
503     function div(uint256 a, uint256 b) internal pure returns (uint256) {
504         // Solidity only automatically asserts when dividing by 0
505         require(b > 0, "SafeMath: division by zero");
506         uint256 c = a / b;
507         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
508 
509         return c;
510     }
511 
512     /**
513      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
514      * Reverts when dividing by zero.
515      *
516      * Counterpart to Solidity's `%` operator. This function uses a `revert`
517      * opcode (which leaves remaining gas untouched) while Solidity uses an
518      * invalid opcode to revert (consuming all remaining gas).
519      *
520      * Requirements:
521      * - The divisor cannot be zero.
522      */
523     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
524         require(b != 0, "SafeMath: modulo by zero");
525         return a % b;
526     }
527 }
528 
529 interface IChainLinkFeed {
530     function latestAnswer() external view returns (int256);
531 }
532 
533 contract StakingRewards is
534     IStakingRewards,
535     RewardsDistributionRecipient,
536     ReentrancyGuard,
537     Pausable
538 {
539     using SafeMath for uint256;
540     using SafeERC20 for IERC20;
541 
542     /* ========== STATE VARIABLES ========== */
543     IChainLinkFeed public constant FASTGAS =
544         IChainLinkFeed(0x169E633A2D1E6c10dD91238Ba11c4A708dfEF37C);
545 
546     IERC20 public rewardsToken;
547     IERC20 public stakingToken;
548     uint256 public periodFinish = 0;
549     uint256 public rewardRate = 0;
550     uint256 public rewardsDuration;
551     uint256 public lastUpdateTime;
552     uint256 public rewardPerTokenStored;
553 
554     mapping(address => uint256) public userRewardPerTokenPaid;
555     mapping(address => uint256) public rewards;
556 
557     uint256 private _totalSupply;
558     mapping(address => uint256) private _balances;
559 
560     /* ========== CONSTRUCTOR ========== */
561 
562     constructor(
563         address _owner,
564         address _rewardsDistribution,
565         address _rewardsToken,
566         address _stakingToken,
567         uint256 _rewardsDuration
568     ) public Owned(_owner) {
569         rewardsToken = IERC20(_rewardsToken);
570         stakingToken = IERC20(_stakingToken);
571         rewardsDistribution = _rewardsDistribution;
572         rewardsDuration = _rewardsDuration;
573     }
574 
575     /* ========== VIEWS ========== */
576 
577     function totalSupply() external view returns (uint256) {
578         return _totalSupply;
579     }
580 
581     function getFastGas() external view returns (uint256) {
582         return uint256(FASTGAS.latestAnswer());
583     }
584 
585     function balanceOf(address account) external view returns (uint256) {
586         return _balances[account];
587     }
588 
589     function lastTimeRewardApplicable() public view returns (uint256) {
590         return Math.min(block.timestamp, periodFinish);
591     }
592 
593     function rewardPerToken() public view returns (uint256) {
594         if (_totalSupply == 0) {
595             return rewardPerTokenStored;
596         }
597         return
598             rewardPerTokenStored.add(
599                 lastTimeRewardApplicable()
600                     .sub(lastUpdateTime)
601                     .mul(rewardRate)
602                     .mul(1e18)
603                     .div(_totalSupply)
604             );
605     }
606 
607     function earned(address account) public view returns (uint256) {
608         return
609             _balances[account]
610                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
611                 .div(1e18)
612                 .add(rewards[account]);
613     }
614 
615     function getRewardForDuration() external view returns (uint256) {
616         return rewardRate.mul(rewardsDuration);
617     }
618 
619     /* ========== MUTATIVE FUNCTIONS ========== */
620 
621     function stake(uint256 amount)
622         external
623         nonReentrant
624         notPaused
625         updateReward(msg.sender)
626     {
627         require(amount > 0, "Cannot stake 0");
628         _totalSupply = _totalSupply.add(amount);
629         _balances[msg.sender] = _balances[msg.sender].add(amount);
630         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
631         emit Staked(msg.sender, amount);
632     }
633 
634     function withdraw(uint256 amount)
635         public
636         nonReentrant
637         updateReward(msg.sender)
638     {
639         require(amount > 0, "Cannot withdraw 0");
640         _totalSupply = _totalSupply.sub(amount);
641         _balances[msg.sender] = _balances[msg.sender].sub(amount);
642         stakingToken.safeTransfer(msg.sender, amount);
643         emit Withdrawn(msg.sender, amount);
644     }
645 
646     function getReward() public nonReentrant updateReward(msg.sender) {
647         uint256 reward = rewards[msg.sender];
648         if (reward > 0) {
649             // Safe gaurd against error if reward is greater than balance in contract
650             uint256 balance = rewardsToken.balanceOf(address(this));
651             if (rewards[msg.sender] > balance) {
652                 reward = balance;
653             }
654             rewards[msg.sender] = 0;
655             rewardsToken.safeTransfer(msg.sender, reward);
656             emit RewardPaid(msg.sender, reward);
657         }
658     }
659 
660     function exit() external {
661         withdraw(_balances[msg.sender]);
662         getReward();
663     }
664 
665     /* ========== RESTRICTED FUNCTIONS ========== */
666 
667     function notifyRewardAmount(uint256 reward, address rewardHolder)
668         external
669         onlyRewardsDistribution
670         updateReward(address(0))
671     {
672         // handle the transfer of reward tokens via `transferFrom` to reduce the number
673         // of transactions required and ensure correctness of the reward amount
674 
675         rewardsToken.safeTransferFrom(rewardHolder, address(this), reward);
676 
677         if (block.timestamp >= periodFinish) {
678             rewardRate = reward.div(rewardsDuration);
679         } else {
680             uint256 remaining = periodFinish.sub(block.timestamp);
681             uint256 leftover = remaining.mul(rewardRate);
682             rewardRate = reward.add(leftover).div(rewardsDuration);
683         }
684 
685         lastUpdateTime = block.timestamp;
686         periodFinish = block.timestamp.add(rewardsDuration);
687         emit RewardAdded(reward);
688     }
689 
690     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
691     function recoverERC20(address tokenAddress, uint256 tokenAmount)
692         external
693         onlyOwner
694     {
695         require(
696             tokenAddress != address(stakingToken),
697             "Cannot withdraw the staking token"
698         );
699         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
700         emit Recovered(tokenAddress, tokenAmount);
701     }
702 
703     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
704         require(
705             block.timestamp > periodFinish,
706             "Previous rewards period must be complete before changing the duration for the new period"
707         );
708         rewardsDuration = _rewardsDuration;
709         emit RewardsDurationUpdated(rewardsDuration);
710     }
711 
712     /* ========== MODIFIERS ========== */
713 
714     modifier updateReward(address account) {
715         rewardPerTokenStored = rewardPerToken();
716         lastUpdateTime = lastTimeRewardApplicable();
717         if (account != address(0)) {
718             rewards[account] = earned(account);
719             userRewardPerTokenPaid[account] = rewardPerTokenStored;
720         }
721         _;
722     }
723 
724     /* ========== EVENTS ========== */
725 
726     event RewardAdded(uint256 reward);
727     event Staked(address indexed user, uint256 amount);
728     event Withdrawn(address indexed user, uint256 amount);
729     event RewardPaid(address indexed user, uint256 reward);
730     event RewardsDurationUpdated(uint256 newDuration);
731     event Recovered(address token, uint256 amount);
732 }
733 
734 /**
735  * @dev Contract module which provides a basic access control mechanism, where
736  * there is an account (an owner) that can be granted exclusive access to
737  * specific functions.
738  *
739  * This module is used through inheritance. It will make available the modifier
740  * `onlyOwner`, which can be aplied to your functions to restrict their use to
741  * the owner.
742  */
743 contract Ownable {
744     address private _owner;
745 
746     event OwnershipTransferred(
747         address indexed previousOwner,
748         address indexed newOwner
749     );
750 
751     /**
752      * @dev Initializes the contract setting the deployer as the initial owner.
753      */
754     constructor() internal {
755         _owner = msg.sender;
756         emit OwnershipTransferred(address(0), _owner);
757     }
758 
759     /**
760      * @dev Returns the address of the current owner.
761      */
762     function owner() public view returns (address) {
763         return _owner;
764     }
765 
766     /**
767      * @dev Throws if called by any account other than the owner.
768      */
769     modifier onlyOwner() {
770         require(isOwner(), "Ownable: caller is not the owner");
771         _;
772     }
773 
774     /**
775      * @dev Returns true if the caller is the current owner.
776      */
777     function isOwner() public view returns (bool) {
778         return msg.sender == _owner;
779     }
780 
781     /**
782      * @dev Leaves the contract without owner. It will not be possible to call
783      * `onlyOwner` functions anymore. Can only be called by the current owner.
784      *
785      * > Note: Renouncing ownership will leave the contract without an owner,
786      * thereby removing any functionality that is only available to the owner.
787      */
788     function renounceOwnership() public onlyOwner {
789         emit OwnershipTransferred(_owner, address(0));
790         _owner = address(0);
791     }
792 
793     /**
794      * @dev Transfers ownership of the contract to a new account (`newOwner`).
795      * Can only be called by the current owner.
796      */
797     function transferOwnership(address newOwner) public onlyOwner {
798         _transferOwnership(newOwner);
799     }
800 
801     /**
802      * @dev Transfers ownership of the contract to a new account (`newOwner`).
803      */
804     function _transferOwnership(address newOwner) internal {
805         require(
806             newOwner != address(0),
807             "Ownable: new owner is the zero address"
808         );
809         emit OwnershipTransferred(_owner, newOwner);
810         _owner = newOwner;
811     }
812 }
813 
814 contract StakingRewardsFactory is Ownable {
815     // immutables
816     address public rewardsToken;
817     uint256 public stakingRewardsGenesis;
818 
819     // the staking tokens for which the rewards contract has been deployed
820     address[] public stakingTokens;
821 
822     // info about rewards for a particular staking token
823     struct StakingRewardsInfo {
824         address stakingRewards;
825         uint256 rewardAmount;
826     }
827 
828     // rewards info by staking token
829     mapping(address => StakingRewardsInfo)
830         public stakingRewardsInfoByStakingToken;
831 
832     constructor(address _rewardsToken, uint256 _stakingRewardsGenesis)
833         public
834         Ownable()
835     {
836         require(
837             _stakingRewardsGenesis >= block.timestamp,
838             "StakingRewardsFactory::constructor: genesis too soon"
839         );
840 
841         rewardsToken = _rewardsToken;
842         stakingRewardsGenesis = _stakingRewardsGenesis;
843     }
844 
845     ///// permissioned functions
846 
847     // deploy a staking reward contract for the staking token, and store the reward amount
848     // the reward will be distributed to the staking reward contract no sooner than the genesis
849     function deploy(
850         address stakingToken,
851         uint256 rewardAmount,
852         uint256 rewardsDuration
853     ) public onlyOwner {
854         StakingRewardsInfo storage info =
855             stakingRewardsInfoByStakingToken[stakingToken];
856         require(
857             info.stakingRewards == address(0),
858             "StakingRewardsFactory::deploy: already deployed"
859         );
860 
861         // Args on the StakingRewards
862         // address _owner,
863         // address _rewardsDistribution,
864         // address _rewardsToken,
865         // address _stakingToken,
866         // uint256 _rewardsDuration
867         info.stakingRewards = address(
868             new StakingRewards(
869                 /*_rewardsDistribution=*/
870                 owner(),
871                 address(this),
872                 rewardsToken,
873                 stakingToken,
874                 rewardsDuration
875             )
876         );
877         info.rewardAmount = rewardAmount;
878         stakingTokens.push(stakingToken);
879     }
880 
881     // Fallback function to return money to reward distributer via pool deployer
882     // In case of issues or incorrect calls or errors
883     function refund(uint256 amount, address refundAddress) public onlyOwner {
884         require(
885             IERC20(rewardsToken).transfer(refundAddress, amount),
886             "StakingRewardsFactory::notifyRewardAmount: transfer failed"
887         );
888     }
889 
890     ///// permissionless functions
891 
892     // call notifyRewardAmount for all staking tokens.
893     function notifyRewardAmounts() public {
894         require(
895             stakingTokens.length > 0,
896             "StakingRewardsFactory::notifyRewardAmounts: called before any deploys"
897         );
898         for (uint256 i = 0; i < stakingTokens.length; i++) {
899             notifyRewardAmount(stakingTokens[i]);
900         }
901     }
902 
903     // notify reward amount for an individual staking token.
904     // this is a fallback in case the notifyRewardAmounts costs too much gas to call for all contracts
905     function notifyRewardAmount(address stakingToken) public {
906         require(
907             block.timestamp >= stakingRewardsGenesis,
908             "StakingRewardsFactory::notifyRewardAmount: not ready"
909         );
910 
911         StakingRewardsInfo storage info =
912             stakingRewardsInfoByStakingToken[stakingToken];
913         require(
914             info.stakingRewards != address(0),
915             "StakingRewardsFactory::notifyRewardAmount: not deployed"
916         );
917 
918         if (info.rewardAmount > 0) {
919             uint256 rewardAmount = info.rewardAmount;
920             info.rewardAmount = 0;
921 
922             IERC20(rewardsToken).approve(info.stakingRewards, rewardAmount);
923             StakingRewards(info.stakingRewards).notifyRewardAmount(
924                 rewardAmount,
925                 address(this)
926             );
927         }
928     }
929 }