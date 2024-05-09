1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 /**
4 
5 Author: CoFiX Core, https://cofix.io
6 Commit hash: v0.9.5-2-ga3faf75
7 Repository: https://github.com/Computable-Finance/CoFiX
8 Issues: https://github.com/Computable-Finance/CoFiX/issues
9 
10 */
11 
12 pragma solidity 0.6.12;
13 
14 
15 // 
16 interface ICoFiXVaultForCNode {
17 
18     event NewCNodePool(address _new);
19 
20     function setGovernance(address _new) external;
21     function setInitCoFiRate(uint256 _new) external;
22     function setDecayPeriod(uint256 _new) external;
23     function setDecayRate(uint256 _new) external;
24     function setCNodePool(address _new) external;
25 
26     function distributeReward(address to, uint256 amount) external;
27 
28     function getPendingRewardOfCNode() external view returns (uint256);
29     function currentPeriod() external view returns (uint256);
30     function currentCoFiRate() external view returns (uint256);
31     function getCoFiStakingPool() external view returns (address pool);
32 
33 }
34 
35 // 
36 /**
37  * @dev Wrappers over Solidity's arithmetic operations with added overflow
38  * checks.
39  *
40  * Arithmetic operations in Solidity wrap on overflow. This can easily result
41  * in bugs, because programmers usually assume that an overflow raises an
42  * error, which is the standard behavior in high level programming languages.
43  * `SafeMath` restores this intuition by reverting the transaction when an
44  * operation overflows.
45  *
46  * Using this library instead of the unchecked operations eliminates an entire
47  * class of bugs, so it's recommended to use it always.
48  */
49 library SafeMath {
50     /**
51      * @dev Returns the addition of two unsigned integers, reverting on
52      * overflow.
53      *
54      * Counterpart to Solidity's `+` operator.
55      *
56      * Requirements:
57      *
58      * - Addition cannot overflow.
59      */
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the subtraction of two unsigned integers, reverting on
69      * overflow (when the result is negative).
70      *
71      * Counterpart to Solidity's `-` operator.
72      *
73      * Requirements:
74      *
75      * - Subtraction cannot overflow.
76      */
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         return sub(a, b, "SafeMath: subtraction overflow");
79     }
80 
81     /**
82      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
83      * overflow (when the result is negative).
84      *
85      * Counterpart to Solidity's `-` operator.
86      *
87      * Requirements:
88      *
89      * - Subtraction cannot overflow.
90      */
91     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      *
106      * - Multiplication cannot overflow.
107      */
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110         // benefit is lost if 'b' is also tested.
111         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
112         if (a == 0) {
113             return 0;
114         }
115 
116         uint256 c = a * b;
117         require(c / a == b, "SafeMath: multiplication overflow");
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers. Reverts on
124      * division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator. Note: this function uses a
127      * `revert` opcode (which leaves remaining gas untouched) while Solidity
128      * uses an invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return div(a, b, "SafeMath: division by zero");
136     }
137 
138     /**
139      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
140      * division by zero. The result is rounded towards zero.
141      *
142      * Counterpart to Solidity's `/` operator. Note: this function uses a
143      * `revert` opcode (which leaves remaining gas untouched) while Solidity
144      * uses an invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
171         return mod(a, b, "SafeMath: modulo by zero");
172     }
173 
174     /**
175      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
176      * Reverts with custom message when dividing by zero.
177      *
178      * Counterpart to Solidity's `%` operator. This function uses a `revert`
179      * opcode (which leaves remaining gas untouched) while Solidity uses an
180      * invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b != 0, errorMessage);
188         return a % b;
189     }
190 }
191 
192 // 
193 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
194 library TransferHelper {
195     function safeApprove(address token, address to, uint value) internal {
196         // bytes4(keccak256(bytes('approve(address,uint256)')));
197         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
198         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
199     }
200 
201     function safeTransfer(address token, address to, uint value) internal {
202         // bytes4(keccak256(bytes('transfer(address,uint256)')));
203         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
204         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
205     }
206 
207     function safeTransferFrom(address token, address from, address to, uint value) internal {
208         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
209         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
210         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
211     }
212 
213     function safeTransferETH(address to, uint value) internal {
214         (bool success,) = to.call{value:value}(new bytes(0));
215         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
216     }
217 }
218 
219 // 
220 /**
221  * @dev Standard math utilities missing in the Solidity language.
222  */
223 library Math {
224     /**
225      * @dev Returns the largest of two numbers.
226      */
227     function max(uint256 a, uint256 b) internal pure returns (uint256) {
228         return a >= b ? a : b;
229     }
230 
231     /**
232      * @dev Returns the smallest of two numbers.
233      */
234     function min(uint256 a, uint256 b) internal pure returns (uint256) {
235         return a < b ? a : b;
236     }
237 
238     /**
239      * @dev Returns the average of two numbers. The result is rounded towards
240      * zero.
241      */
242     function average(uint256 a, uint256 b) internal pure returns (uint256) {
243         // (a + b) / 2 can overflow, so we distribute
244         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
245     }
246 }
247 
248 // 
249 /**
250  * @dev Contract module that helps prevent reentrant calls to a function.
251  *
252  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
253  * available, which can be applied to functions to make sure there are no nested
254  * (reentrant) calls to them.
255  *
256  * Note that because there is a single `nonReentrant` guard, functions marked as
257  * `nonReentrant` may not call one another. This can be worked around by making
258  * those functions `private`, and then adding `external` `nonReentrant` entry
259  * points to them.
260  *
261  * TIP: If you would like to learn more about reentrancy and alternative ways
262  * to protect against it, check out our blog post
263  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
264  */
265 contract ReentrancyGuard {
266     // Booleans are more expensive than uint256 or any type that takes up a full
267     // word because each write operation emits an extra SLOAD to first read the
268     // slot's contents, replace the bits taken up by the boolean, and then write
269     // back. This is the compiler's defense against contract upgrades and
270     // pointer aliasing, and it cannot be disabled.
271 
272     // The values being non-zero value makes deployment a bit more expensive,
273     // but in exchange the refund on every call to nonReentrant will be lower in
274     // amount. Since refunds are capped to a percentage of the total
275     // transaction's gas, it is best to keep them low in cases like this one, to
276     // increase the likelihood of the full refund coming into effect.
277     uint256 private constant _NOT_ENTERED = 1;
278     uint256 private constant _ENTERED = 2;
279 
280     uint256 private _status;
281 
282     constructor () internal {
283         _status = _NOT_ENTERED;
284     }
285 
286     /**
287      * @dev Prevents a contract from calling itself, directly or indirectly.
288      * Calling a `nonReentrant` function from another `nonReentrant`
289      * function is not supported. It is possible to prevent this from happening
290      * by making the `nonReentrant` function external, and make it call a
291      * `private` function that does the actual work.
292      */
293     modifier nonReentrant() {
294         // On the first call to nonReentrant, _notEntered will be true
295         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
296 
297         // Any calls to nonReentrant after this point will fail
298         _status = _ENTERED;
299 
300         _;
301 
302         // By storing the original value once again, a refund is triggered (see
303         // https://eips.ethereum.org/EIPS/eip-2200)
304         _status = _NOT_ENTERED;
305     }
306 }
307 
308 // 
309 interface ICoFiXStakingRewards {
310     // Views
311 
312     /// @dev The rewards vault contract address set in factory contract
313     /// @return Returns the vault address
314     function rewardsVault() external view returns (address);
315 
316     /// @dev The lastBlock reward applicable
317     /// @return Returns the latest block.number on-chain
318     function lastBlockRewardApplicable() external view returns (uint256);
319 
320     /// @dev Reward amount represents by per staking token
321     function rewardPerToken() external view returns (uint256);
322 
323     /// @dev How many reward tokens a user has earned but not claimed at present
324     /// @param  account The target account
325     /// @return The amount of reward tokens a user earned
326     function earned(address account) external view returns (uint256);
327 
328     /// @dev How many reward tokens accrued recently
329     /// @return The amount of reward tokens accrued recently
330     function accrued() external view returns (uint256);
331 
332     /// @dev Get the latest reward rate of this mining pool (tokens amount per block)
333     /// @return The latest reward rate
334     function rewardRate() external view returns (uint256);
335 
336     /// @dev How many stakingToken (XToken) deposited into to this reward pool (mining pool)
337     /// @return The total amount of XTokens deposited in this mining pool
338     function totalSupply() external view returns (uint256);
339 
340     /// @dev How many stakingToken (XToken) deposited by the target account
341     /// @param  account The target account
342     /// @return The total amount of XToken deposited in this mining pool
343     function balanceOf(address account) external view returns (uint256);
344 
345     /// @dev Get the address of token for staking in this mining pool
346     /// @return The staking token address
347     function stakingToken() external view returns (address);
348 
349     /// @dev Get the address of token for rewards in this mining pool
350     /// @return The rewards token address
351     function rewardsToken() external view returns (address);
352 
353     // Mutative
354 
355     /// @dev Stake/Deposit into the reward pool (mining pool)
356     /// @param  amount The target amount
357     function stake(uint256 amount) external;
358 
359     /// @dev Stake/Deposit into the reward pool (mining pool) for other account
360     /// @param  other The target account
361     /// @param  amount The target amount
362     function stakeForOther(address other, uint256 amount) external;
363 
364     /// @dev Withdraw from the reward pool (mining pool), get the original tokens back
365     /// @param  amount The target amount
366     function withdraw(uint256 amount) external;
367 
368     /// @dev Withdraw without caring about rewards. EMERGENCY ONLY.
369     function emergencyWithdraw() external;
370 
371     /// @dev Claim the reward the user earned
372     function getReward() external;
373 
374     function getRewardAndStake() external;
375 
376     /// @dev User exit the reward pool, it's actually withdraw and getReward
377     function exit() external;
378 
379     /// @dev Add reward to the mining pool
380     function addReward(uint256 amount) external;
381 
382     // Events
383     event RewardAdded(address sender, uint256 reward);
384     event Staked(address indexed user, uint256 amount);
385     event StakedForOther(address indexed user, address indexed other, uint256 amount);
386     event Withdrawn(address indexed user, uint256 amount);
387     event EmergencyWithdraw(address indexed user, uint256 amount);
388     event RewardPaid(address indexed user, uint256 reward);
389 }
390 
391 // 
392 interface ICoFiXVaultForLP {
393 
394     enum POOL_STATE {INVALID, ENABLED, DISABLED}
395 
396     event NewPoolAdded(address pool, uint256 index);
397     event PoolEnabled(address pool);
398     event PoolDisabled(address pool);
399 
400     function setGovernance(address _new) external;
401     function setInitCoFiRate(uint256 _new) external;
402     function setDecayPeriod(uint256 _new) external;
403     function setDecayRate(uint256 _new) external;
404 
405     function addPool(address pool) external;
406     function enablePool(address pool) external;
407     function disablePool(address pool) external;
408     function setPoolWeight(address pool, uint256 weight) external;
409     function batchSetPoolWeight(address[] memory pools, uint256[] memory weights) external;
410     function distributeReward(address to, uint256 amount) external;
411 
412     function getPendingRewardOfLP(address pair) external view returns (uint256);
413     function currentPeriod() external view returns (uint256);
414     function currentCoFiRate() external view returns (uint256);
415     function currentPoolRate(address pool) external view returns (uint256 poolRate);
416     function currentPoolRateByPair(address pair) external view returns (uint256 poolRate);
417 
418     /// @dev Get the award staking pool address of pair (XToken)
419     /// @param  pair The address of XToken(pair) contract
420     /// @return pool The pool address
421     function stakingPoolForPair(address pair) external view returns (address pool);
422 
423     function getPoolInfo(address pool) external view returns (POOL_STATE state, uint256 weight);
424     function getPoolInfoByPair(address pair) external view returns (POOL_STATE state, uint256 weight);
425 
426     function getEnabledPoolCnt() external view returns (uint256);
427 
428     function getCoFiStakingPool() external view returns (address pool);
429 
430 }
431 
432 // 
433 /**
434  * @dev Interface of the ERC20 standard as defined in the EIP.
435  */
436 interface IERC20 {
437     /**
438      * @dev Returns the amount of tokens in existence.
439      */
440     function totalSupply() external view returns (uint256);
441 
442     /**
443      * @dev Returns the amount of tokens owned by `account`.
444      */
445     function balanceOf(address account) external view returns (uint256);
446 
447     /**
448      * @dev Moves `amount` tokens from the caller's account to `recipient`.
449      *
450      * Returns a boolean value indicating whether the operation succeeded.
451      *
452      * Emits a {Transfer} event.
453      */
454     function transfer(address recipient, uint256 amount) external returns (bool);
455 
456     /**
457      * @dev Returns the remaining number of tokens that `spender` will be
458      * allowed to spend on behalf of `owner` through {transferFrom}. This is
459      * zero by default.
460      *
461      * This value changes when {approve} or {transferFrom} are called.
462      */
463     function allowance(address owner, address spender) external view returns (uint256);
464 
465     /**
466      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
467      *
468      * Returns a boolean value indicating whether the operation succeeded.
469      *
470      * IMPORTANT: Beware that changing an allowance with this method brings the risk
471      * that someone may use both the old and the new allowance by unfortunate
472      * transaction ordering. One possible solution to mitigate this race
473      * condition is to first reduce the spender's allowance to 0 and set the
474      * desired value afterwards:
475      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
476      *
477      * Emits an {Approval} event.
478      */
479     function approve(address spender, uint256 amount) external returns (bool);
480 
481     /**
482      * @dev Moves `amount` tokens from `sender` to `recipient` using the
483      * allowance mechanism. `amount` is then deducted from the caller's
484      * allowance.
485      *
486      * Returns a boolean value indicating whether the operation succeeded.
487      *
488      * Emits a {Transfer} event.
489      */
490     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
491 
492     /**
493      * @dev Emitted when `value` tokens are moved from one account (`from`) to
494      * another (`to`).
495      *
496      * Note that `value` may be zero.
497      */
498     event Transfer(address indexed from, address indexed to, uint256 value);
499 
500     /**
501      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
502      * a call to {approve}. `value` is the new allowance.
503      */
504     event Approval(address indexed owner, address indexed spender, uint256 value);
505 }
506 
507 // 
508 interface ICoFiStakingRewards {
509     // Views
510 
511     /// @dev Reward amount represents by per staking token
512     function rewardPerToken() external view returns (uint256);
513 
514     /// @dev How many reward tokens a user has earned but not claimed at present
515     /// @param  account The target account
516     /// @return The amount of reward tokens a user earned
517     function earned(address account) external view returns (uint256);
518 
519     /// @dev How many reward tokens accrued recently
520     /// @return The amount of reward tokens accrued recently
521     function accrued() external view returns (uint256);
522 
523     /// @dev How many stakingToken (XToken) deposited into to this reward pool (staking pool)
524     /// @return The total amount of XTokens deposited in this staking pool
525     function totalSupply() external view returns (uint256);
526 
527     /// @dev How many stakingToken (XToken) deposited by the target account
528     /// @param  account The target account
529     /// @return The total amount of XToken deposited in this staking pool
530     function balanceOf(address account) external view returns (uint256);
531 
532     /// @dev Get the address of token for staking in this staking pool
533     /// @return The staking token address
534     function stakingToken() external view returns (address);
535 
536     /// @dev Get the address of token for rewards in this staking pool
537     /// @return The rewards token address
538     function rewardsToken() external view returns (address);
539 
540     // Mutative
541 
542     /// @dev Stake/Deposit into the reward pool (staking pool)
543     /// @param  amount The target amount
544     function stake(uint256 amount) external;
545 
546     /// @dev Stake/Deposit into the reward pool (staking pool) for other account
547     /// @param  other The target account
548     /// @param  amount The target amount
549     function stakeForOther(address other, uint256 amount) external;
550 
551     /// @dev Withdraw from the reward pool (staking pool), get the original tokens back
552     /// @param  amount The target amount
553     function withdraw(uint256 amount) external;
554     
555     /// @dev Withdraw without caring about rewards. EMERGENCY ONLY.
556     function emergencyWithdraw() external;
557 
558     /// @dev Claim the reward the user earned
559     function getReward() external;
560 
561     /// @dev Add ETH reward to the staking pool
562     function addETHReward() external payable;
563 
564     /// @dev User exit the reward pool, it's actually withdraw and getReward
565     function exit() external;
566 
567     // Events
568     event Staked(address indexed user, uint256 amount);
569     event StakedForOther(address indexed user, address indexed other, uint256 amount);
570     event Withdrawn(address indexed user, uint256 amount);
571     event SavingWithdrawn(address indexed to, uint256 amount);
572     event EmergencyWithdraw(address indexed user, uint256 amount);
573     event RewardPaid(address indexed user, uint256 reward);
574     
575 }
576 
577 // 
578 interface ICoFiXFactory {
579     // All pairs: {ETH <-> ERC20 Token}
580     event PairCreated(address indexed token, address pair, uint256);
581     event NewGovernance(address _new);
582     event NewController(address _new);
583     event NewFeeReceiver(address _new);
584     event NewFeeVaultForLP(address token, address feeVault);
585     event NewVaultForLP(address _new);
586     event NewVaultForTrader(address _new);
587     event NewVaultForCNode(address _new);
588 
589     /// @dev Create a new token pair for trading
590     /// @param  token the address of token to trade
591     /// @return pair the address of new token pair
592     function createPair(
593         address token
594         )
595         external
596         returns (address pair);
597 
598     function getPair(address token) external view returns (address pair);
599     function allPairs(uint256) external view returns (address pair);
600     function allPairsLength() external view returns (uint256);
601 
602     function getTradeMiningStatus(address token) external view returns (bool status);
603     function setTradeMiningStatus(address token, bool status) external;
604     function getFeeVaultForLP(address token) external view returns (address feeVault); // for LPs
605     function setFeeVaultForLP(address token, address feeVault) external;
606 
607     function setGovernance(address _new) external;
608     function setController(address _new) external;
609     function setFeeReceiver(address _new) external;
610     function setVaultForLP(address _new) external;
611     function setVaultForTrader(address _new) external;
612     function setVaultForCNode(address _new) external;
613     function getController() external view returns (address controller);
614     function getFeeReceiver() external view returns (address feeReceiver); // For CoFi Holders
615     function getVaultForLP() external view returns (address vaultForLP);
616     function getVaultForTrader() external view returns (address vaultForTrader);
617     function getVaultForCNode() external view returns (address vaultForCNode);
618 }
619 
620 // 
621 // Stake XToken to earn CoFi Token
622 contract CoFiXStakingRewards is ICoFiXStakingRewards, ReentrancyGuard {
623     using SafeMath for uint256;
624 
625     /* ========== STATE VARIABLES ========== */
626 
627     address public override immutable rewardsToken; // CoFi
628     address public override immutable stakingToken; // XToken or CNode
629 
630     address public immutable factory;
631 
632     uint256 public lastUpdateBlock;
633     uint256 public rewardPerTokenStored;
634 
635     mapping(address => uint256) public userRewardPerTokenPaid;
636     mapping(address => uint256) public rewards;
637 
638     uint256 private _totalSupply;
639     mapping(address => uint256) private _balances;
640 
641     /* ========== CONSTRUCTOR ========== */
642 
643     constructor(
644         address _rewardsToken,
645         address _stakingToken,
646         address _factory
647     ) public {
648         rewardsToken = _rewardsToken;
649         stakingToken = _stakingToken;
650         require(ICoFiXFactory(_factory).getVaultForLP() != address(0), "VaultForLP not set yet"); // check
651         factory = _factory;
652         lastUpdateBlock = 11040688; // https://etherscan.io/block/countdown/11040688    
653     }
654 
655     /* ========== VIEWS ========== */
656 
657     // replace cofixVault with rewardsVault, this could introduce more calls, but clear is more important 
658     function rewardsVault() public virtual override view returns (address) {
659         return ICoFiXFactory(factory).getVaultForLP();
660     }
661 
662     function totalSupply() external override view returns (uint256) {
663         return _totalSupply;
664     }
665 
666     function balanceOf(address account) external override view returns (uint256) {
667         return _balances[account];
668     }
669 
670     function lastBlockRewardApplicable() public override view returns (uint256) {
671         return block.number;
672     }
673 
674     function rewardPerToken() public override view returns (uint256) {
675         if (_totalSupply == 0) {
676             return rewardPerTokenStored;
677         }
678         return
679             rewardPerTokenStored.add(
680                 accrued().mul(1e18).div(_totalSupply)
681             );
682     }
683 
684     function _rewardPerTokenAndAccrued() internal view returns (uint256, uint256) {
685         if (_totalSupply == 0) {
686             // use the old rewardPerTokenStored, and accrued should be zero here
687             // if not the new accrued amount will never be distributed to anyone
688             return (rewardPerTokenStored, 0);
689         }
690         uint256 _accrued = accrued();
691         uint256 _rewardPerToken = rewardPerTokenStored.add(
692                 _accrued.mul(1e18).div(_totalSupply)
693             );
694         return (_rewardPerToken, _accrued);
695     }
696 
697     function rewardRate() public virtual override view returns (uint256) {
698         return ICoFiXVaultForLP(rewardsVault()).currentPoolRate(address(this));
699     }
700 
701     function accrued() public virtual override view returns (uint256) {
702         // calc block rewards
703         uint256 blockReward = lastBlockRewardApplicable().sub(lastUpdateBlock).mul(rewardRate());
704         // query pair trading rewards
705         uint256 tradingReward = ICoFiXVaultForLP(rewardsVault()).getPendingRewardOfLP(stakingToken);
706         return blockReward.add(tradingReward);
707     }
708 
709     function earned(address account) public override view returns (uint256) {
710         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
711     }
712 
713     /* ========== MUTATIVE FUNCTIONS ========== */
714 
715     function stake(uint256 amount) external override nonReentrant updateReward(msg.sender) {
716         require(amount > 0, "Cannot stake 0");
717         _totalSupply = _totalSupply.add(amount);
718         _balances[msg.sender] = _balances[msg.sender].add(amount);
719         TransferHelper.safeTransferFrom(stakingToken, msg.sender, address(this), amount);
720         emit Staked(msg.sender, amount);
721     }
722 
723     function stakeForOther(address other, uint256 amount) external override nonReentrant updateReward(other) {
724         require(amount > 0, "Cannot stake 0");
725         _totalSupply = _totalSupply.add(amount);
726         _balances[other] = _balances[other].add(amount);
727         TransferHelper.safeTransferFrom(stakingToken, msg.sender, address(this), amount);
728         emit StakedForOther(msg.sender, other, amount);
729     }
730 
731     function withdraw(uint256 amount) public override nonReentrant updateReward(msg.sender) {
732         require(amount > 0, "Cannot withdraw 0");
733         _totalSupply = _totalSupply.sub(amount);
734         _balances[msg.sender] = _balances[msg.sender].sub(amount);
735         TransferHelper.safeTransfer(stakingToken, msg.sender, amount);
736         emit Withdrawn(msg.sender, amount);
737     }
738 
739     // Withdraw without caring about rewards. EMERGENCY ONLY.
740     function emergencyWithdraw() external override nonReentrant {
741         uint256 amount = _balances[msg.sender];
742         require(amount > 0, "Cannot withdraw 0");
743         _totalSupply = _totalSupply.sub(amount);
744         _balances[msg.sender] = 0;
745         rewards[msg.sender] = 0;
746         TransferHelper.safeTransfer(stakingToken, msg.sender, amount);
747         emit EmergencyWithdraw(msg.sender, amount);
748     }
749 
750     function getReward() public override nonReentrant updateReward(msg.sender) {
751         uint256 reward = rewards[msg.sender];
752         if (reward > 0) {
753             rewards[msg.sender] = 0;
754             // TransferHelper.safeTransfer(rewardsToken, msg.sender, reward);
755             uint256 transferred = _safeCoFiTransfer(msg.sender, reward);
756             emit RewardPaid(msg.sender, transferred);
757         }
758     }
759 
760     // get CoFi rewards and staking into CoFiStakingRewards pool
761     function getRewardAndStake() external override nonReentrant updateReward(msg.sender) {
762         uint256 reward = rewards[msg.sender];
763         if (reward > 0) {
764             rewards[msg.sender] = 0;
765             address cofiStakingPool = ICoFiXVaultForLP(rewardsVault()).getCoFiStakingPool(); // also work for VaultForCNode
766             require(cofiStakingPool != address(0), "cofiStakingPool not set");
767             // approve to staking pool
768             address _rewardsToken = rewardsToken;
769             IERC20(_rewardsToken).approve(cofiStakingPool, reward);
770             ICoFiStakingRewards(cofiStakingPool).stakeForOther(msg.sender, reward);
771             IERC20(_rewardsToken).approve(cofiStakingPool, 0); // ensure
772             emit RewardPaid(msg.sender, reward);
773         }
774     }
775 
776     function exit() external override {
777         withdraw(_balances[msg.sender]);
778         getReward();
779     }
780 
781     // add reward from trading pool or anyone else
782     function addReward(uint256 amount) public override nonReentrant updateReward(address(0)) {
783         // transfer from caller (router contract)
784         TransferHelper.safeTransferFrom(rewardsToken, msg.sender, address(this), amount);
785         // update rewardPerTokenStored
786         rewardPerTokenStored = rewardPerTokenStored.add(amount.mul(1e18).div(_totalSupply));
787         emit RewardAdded(msg.sender, amount);
788     }
789 
790     // Safe CoFi transfer function, just in case if rounding error or ending of mining causes pool to not have enough CoFis.
791     function _safeCoFiTransfer(address _to, uint256 _amount) internal returns (uint256) {
792         uint256 cofiBal = IERC20(rewardsToken).balanceOf(address(this));
793         if (_amount > cofiBal) {
794             _amount = cofiBal;
795         }
796         TransferHelper.safeTransfer(rewardsToken, _to, _amount); // allow zero amount
797         return _amount;
798     }
799 
800     /* ========== MODIFIERS ========== */
801 
802     modifier updateReward(address account) virtual {
803         // rewardPerTokenStored = rewardPerToken();
804         // uint256 newAccrued = accrued();
805         (uint256 newRewardPerToken, uint256 newAccrued) = _rewardPerTokenAndAccrued();
806         rewardPerTokenStored = newRewardPerToken;
807         if (newAccrued > 0) {
808             // distributeReward could fail if CoFiXVaultForLP is not minter of CoFi anymore
809             // Should set reward rate to zero first, and then do a settlement of pool reward by call getReward
810             ICoFiXVaultForLP(rewardsVault()).distributeReward(address(this), newAccrued);
811         } 
812         lastUpdateBlock = lastBlockRewardApplicable();
813         if (account != address(0)) {
814             rewards[account] = earned(account);
815             userRewardPerTokenPaid[account] = rewardPerTokenStored;
816         }
817         _;
818     }
819 
820     /* ========== EVENTS ========== */
821 
822     event RewardAdded(address sender, uint256 reward);
823     event Staked(address indexed user, uint256 amount);
824     event StakedForOther(address indexed user, address indexed other, uint256 amount);
825     event Withdrawn(address indexed user, uint256 amount);
826     event EmergencyWithdraw(address indexed user, uint256 amount);
827     event RewardPaid(address indexed user, uint256 reward);
828 }
829 
830 // 
831 // Stake CNode Token to earn CoFi Token
832 contract CNodeStakingRewards is CoFiXStakingRewards {
833 
834     constructor(
835         address _rewardsToken,
836         address _stakingToken,
837         address _factory
838     ) public CoFiXStakingRewards(
839         _rewardsToken,
840         _stakingToken,
841         _factory
842     ) {
843         require(ICoFiXFactory(_factory).getVaultForCNode() != address(0), "VaultForCNode not set yet"); // check
844     }
845 
846     // replace cofixVault with rewardsVault, this could introduce more calls, but clear is more important 
847     function rewardsVault() public virtual override view returns (address) {
848         return ICoFiXFactory(factory).getVaultForCNode();
849     }
850 
851     function rewardRate() public virtual override view returns (uint256) {
852         return ICoFiXVaultForCNode(rewardsVault()).currentCoFiRate();
853     }
854 
855     function accrued() public virtual override view returns (uint256) {
856         // calc block rewards
857         uint256 blockReward = lastBlockRewardApplicable().sub(lastUpdateBlock).mul(rewardRate());
858         // query pair trading rewards
859         uint256 tradingReward = ICoFiXVaultForCNode(rewardsVault()).getPendingRewardOfCNode(); // trading rewards
860         return blockReward.add(tradingReward);
861     }
862 
863     modifier updateReward(address account) virtual override {
864         // rewardPerTokenStored = rewardPerToken();
865         // uint256 newAccrued = accrued();
866         (uint256 newRewardPerToken, uint256 newAccrued) = _rewardPerTokenAndAccrued();
867         rewardPerTokenStored = newRewardPerToken;
868         if (newAccrued > 0) {
869             // distributeReward could fail if CoFiXVaultForCNode is not minter of CoFi anymore
870             // Should set reward rate to zero first, and then do a settlement of pool reward by call getReward
871             ICoFiXVaultForCNode(rewardsVault()).distributeReward(address(this), newAccrued);
872         } 
873         lastUpdateBlock = lastBlockRewardApplicable();
874         if (account != address(0)) {
875             rewards[account] = earned(account);
876             userRewardPerTokenPaid[account] = rewardPerTokenStored;
877         }
878         _;
879     }
880 
881 }