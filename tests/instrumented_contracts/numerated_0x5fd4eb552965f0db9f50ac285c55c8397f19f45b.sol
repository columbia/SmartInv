1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 /**
4 
5 Author: CoFiX Core, https://cofix.io
6 Commit hash: v0.9.5-1-g7141c43
7 Repository: https://github.com/Computable-Finance/CoFiX
8 Issues: https://github.com/Computable-Finance/CoFiX/issues
9 
10 */
11 
12 pragma solidity 0.6.12;
13 
14 
15 // 
16 /**
17  * @dev Wrappers over Solidity's arithmetic operations with added overflow
18  * checks.
19  *
20  * Arithmetic operations in Solidity wrap on overflow. This can easily result
21  * in bugs, because programmers usually assume that an overflow raises an
22  * error, which is the standard behavior in high level programming languages.
23  * `SafeMath` restores this intuition by reverting the transaction when an
24  * operation overflows.
25  *
26  * Using this library instead of the unchecked operations eliminates an entire
27  * class of bugs, so it's recommended to use it always.
28  */
29 library SafeMath {
30     /**
31      * @dev Returns the addition of two unsigned integers, reverting on
32      * overflow.
33      *
34      * Counterpart to Solidity's `+` operator.
35      *
36      * Requirements:
37      *
38      * - Addition cannot overflow.
39      */
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43 
44         return c;
45     }
46 
47     /**
48      * @dev Returns the subtraction of two unsigned integers, reverting on
49      * overflow (when the result is negative).
50      *
51      * Counterpart to Solidity's `-` operator.
52      *
53      * Requirements:
54      *
55      * - Subtraction cannot overflow.
56      */
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return sub(a, b, "SafeMath: subtraction overflow");
59     }
60 
61     /**
62      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
63      * overflow (when the result is negative).
64      *
65      * Counterpart to Solidity's `-` operator.
66      *
67      * Requirements:
68      *
69      * - Subtraction cannot overflow.
70      */
71     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b <= a, errorMessage);
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the multiplication of two unsigned integers, reverting on
80      * overflow.
81      *
82      * Counterpart to Solidity's `*` operator.
83      *
84      * Requirements:
85      *
86      * - Multiplication cannot overflow.
87      */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      *
112      * - The divisor cannot be zero.
113      */
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return div(a, b, "SafeMath: division by zero");
116     }
117 
118     /**
119      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
120      * division by zero. The result is rounded towards zero.
121      *
122      * Counterpart to Solidity's `/` operator. Note: this function uses a
123      * `revert` opcode (which leaves remaining gas untouched) while Solidity
124      * uses an invalid opcode to revert (consuming all remaining gas).
125      *
126      * Requirements:
127      *
128      * - The divisor cannot be zero.
129      */
130     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131         require(b > 0, errorMessage);
132         uint256 c = a / b;
133         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * Reverts when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151         return mod(a, b, "SafeMath: modulo by zero");
152     }
153 
154     /**
155      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
156      * Reverts with custom message when dividing by zero.
157      *
158      * Counterpart to Solidity's `%` operator. This function uses a `revert`
159      * opcode (which leaves remaining gas untouched) while Solidity uses an
160      * invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      *
164      * - The divisor cannot be zero.
165      */
166     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b != 0, errorMessage);
168         return a % b;
169     }
170 }
171 
172 // 
173 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
174 library TransferHelper {
175     function safeApprove(address token, address to, uint value) internal {
176         // bytes4(keccak256(bytes('approve(address,uint256)')));
177         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
178         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
179     }
180 
181     function safeTransfer(address token, address to, uint value) internal {
182         // bytes4(keccak256(bytes('transfer(address,uint256)')));
183         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
184         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
185     }
186 
187     function safeTransferFrom(address token, address from, address to, uint value) internal {
188         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
189         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
190         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
191     }
192 
193     function safeTransferETH(address to, uint value) internal {
194         (bool success,) = to.call{value:value}(new bytes(0));
195         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
196     }
197 }
198 
199 // 
200 /**
201  * @dev Standard math utilities missing in the Solidity language.
202  */
203 library Math {
204     /**
205      * @dev Returns the largest of two numbers.
206      */
207     function max(uint256 a, uint256 b) internal pure returns (uint256) {
208         return a >= b ? a : b;
209     }
210 
211     /**
212      * @dev Returns the smallest of two numbers.
213      */
214     function min(uint256 a, uint256 b) internal pure returns (uint256) {
215         return a < b ? a : b;
216     }
217 
218     /**
219      * @dev Returns the average of two numbers. The result is rounded towards
220      * zero.
221      */
222     function average(uint256 a, uint256 b) internal pure returns (uint256) {
223         // (a + b) / 2 can overflow, so we distribute
224         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
225     }
226 }
227 
228 // 
229 /**
230  * @dev Contract module that helps prevent reentrant calls to a function.
231  *
232  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
233  * available, which can be applied to functions to make sure there are no nested
234  * (reentrant) calls to them.
235  *
236  * Note that because there is a single `nonReentrant` guard, functions marked as
237  * `nonReentrant` may not call one another. This can be worked around by making
238  * those functions `private`, and then adding `external` `nonReentrant` entry
239  * points to them.
240  *
241  * TIP: If you would like to learn more about reentrancy and alternative ways
242  * to protect against it, check out our blog post
243  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
244  */
245 contract ReentrancyGuard {
246     // Booleans are more expensive than uint256 or any type that takes up a full
247     // word because each write operation emits an extra SLOAD to first read the
248     // slot's contents, replace the bits taken up by the boolean, and then write
249     // back. This is the compiler's defense against contract upgrades and
250     // pointer aliasing, and it cannot be disabled.
251 
252     // The values being non-zero value makes deployment a bit more expensive,
253     // but in exchange the refund on every call to nonReentrant will be lower in
254     // amount. Since refunds are capped to a percentage of the total
255     // transaction's gas, it is best to keep them low in cases like this one, to
256     // increase the likelihood of the full refund coming into effect.
257     uint256 private constant _NOT_ENTERED = 1;
258     uint256 private constant _ENTERED = 2;
259 
260     uint256 private _status;
261 
262     constructor () internal {
263         _status = _NOT_ENTERED;
264     }
265 
266     /**
267      * @dev Prevents a contract from calling itself, directly or indirectly.
268      * Calling a `nonReentrant` function from another `nonReentrant`
269      * function is not supported. It is possible to prevent this from happening
270      * by making the `nonReentrant` function external, and make it call a
271      * `private` function that does the actual work.
272      */
273     modifier nonReentrant() {
274         // On the first call to nonReentrant, _notEntered will be true
275         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
276 
277         // Any calls to nonReentrant after this point will fail
278         _status = _ENTERED;
279 
280         _;
281 
282         // By storing the original value once again, a refund is triggered (see
283         // https://eips.ethereum.org/EIPS/eip-2200)
284         _status = _NOT_ENTERED;
285     }
286 }
287 
288 // 
289 interface ICoFiXStakingRewards {
290     // Views
291 
292     /// @dev The rewards vault contract address set in factory contract
293     /// @return Returns the vault address
294     function rewardsVault() external view returns (address);
295 
296     /// @dev The lastBlock reward applicable
297     /// @return Returns the latest block.number on-chain
298     function lastBlockRewardApplicable() external view returns (uint256);
299 
300     /// @dev Reward amount represents by per staking token
301     function rewardPerToken() external view returns (uint256);
302 
303     /// @dev How many reward tokens a user has earned but not claimed at present
304     /// @param  account The target account
305     /// @return The amount of reward tokens a user earned
306     function earned(address account) external view returns (uint256);
307 
308     /// @dev How many reward tokens accrued recently
309     /// @return The amount of reward tokens accrued recently
310     function accrued() external view returns (uint256);
311 
312     /// @dev Get the latest reward rate of this mining pool (tokens amount per block)
313     /// @return The latest reward rate
314     function rewardRate() external view returns (uint256);
315 
316     /// @dev How many stakingToken (XToken) deposited into to this reward pool (mining pool)
317     /// @return The total amount of XTokens deposited in this mining pool
318     function totalSupply() external view returns (uint256);
319 
320     /// @dev How many stakingToken (XToken) deposited by the target account
321     /// @param  account The target account
322     /// @return The total amount of XToken deposited in this mining pool
323     function balanceOf(address account) external view returns (uint256);
324 
325     /// @dev Get the address of token for staking in this mining pool
326     /// @return The staking token address
327     function stakingToken() external view returns (address);
328 
329     /// @dev Get the address of token for rewards in this mining pool
330     /// @return The rewards token address
331     function rewardsToken() external view returns (address);
332 
333     // Mutative
334 
335     /// @dev Stake/Deposit into the reward pool (mining pool)
336     /// @param  amount The target amount
337     function stake(uint256 amount) external;
338 
339     /// @dev Stake/Deposit into the reward pool (mining pool) for other account
340     /// @param  other The target account
341     /// @param  amount The target amount
342     function stakeForOther(address other, uint256 amount) external;
343 
344     /// @dev Withdraw from the reward pool (mining pool), get the original tokens back
345     /// @param  amount The target amount
346     function withdraw(uint256 amount) external;
347 
348     /// @dev Withdraw without caring about rewards. EMERGENCY ONLY.
349     function emergencyWithdraw() external;
350 
351     /// @dev Claim the reward the user earned
352     function getReward() external;
353 
354     function getRewardAndStake() external;
355 
356     /// @dev User exit the reward pool, it's actually withdraw and getReward
357     function exit() external;
358 
359     /// @dev Add reward to the mining pool
360     function addReward(uint256 amount) external;
361 
362     // Events
363     event RewardAdded(address sender, uint256 reward);
364     event Staked(address indexed user, uint256 amount);
365     event StakedForOther(address indexed user, address indexed other, uint256 amount);
366     event Withdrawn(address indexed user, uint256 amount);
367     event EmergencyWithdraw(address indexed user, uint256 amount);
368     event RewardPaid(address indexed user, uint256 reward);
369 }
370 
371 // 
372 interface ICoFiXVaultForLP {
373 
374     enum POOL_STATE {INVALID, ENABLED, DISABLED}
375 
376     event NewPoolAdded(address pool, uint256 index);
377     event PoolEnabled(address pool);
378     event PoolDisabled(address pool);
379 
380     function setGovernance(address _new) external;
381     function setInitCoFiRate(uint256 _new) external;
382     function setDecayPeriod(uint256 _new) external;
383     function setDecayRate(uint256 _new) external;
384 
385     function addPool(address pool) external;
386     function enablePool(address pool) external;
387     function disablePool(address pool) external;
388     function setPoolWeight(address pool, uint256 weight) external;
389     function batchSetPoolWeight(address[] memory pools, uint256[] memory weights) external;
390     function distributeReward(address to, uint256 amount) external;
391 
392     function getPendingRewardOfLP(address pair) external view returns (uint256);
393     function currentPeriod() external view returns (uint256);
394     function currentCoFiRate() external view returns (uint256);
395     function currentPoolRate(address pool) external view returns (uint256 poolRate);
396     function currentPoolRateByPair(address pair) external view returns (uint256 poolRate);
397 
398     /// @dev Get the award staking pool address of pair (XToken)
399     /// @param  pair The address of XToken(pair) contract
400     /// @return pool The pool address
401     function stakingPoolForPair(address pair) external view returns (address pool);
402 
403     function getPoolInfo(address pool) external view returns (POOL_STATE state, uint256 weight);
404     function getPoolInfoByPair(address pair) external view returns (POOL_STATE state, uint256 weight);
405 
406     function getEnabledPoolCnt() external view returns (uint256);
407 
408     function getCoFiStakingPool() external view returns (address pool);
409 
410 }
411 
412 // 
413 /**
414  * @dev Interface of the ERC20 standard as defined in the EIP.
415  */
416 interface IERC20 {
417     /**
418      * @dev Returns the amount of tokens in existence.
419      */
420     function totalSupply() external view returns (uint256);
421 
422     /**
423      * @dev Returns the amount of tokens owned by `account`.
424      */
425     function balanceOf(address account) external view returns (uint256);
426 
427     /**
428      * @dev Moves `amount` tokens from the caller's account to `recipient`.
429      *
430      * Returns a boolean value indicating whether the operation succeeded.
431      *
432      * Emits a {Transfer} event.
433      */
434     function transfer(address recipient, uint256 amount) external returns (bool);
435 
436     /**
437      * @dev Returns the remaining number of tokens that `spender` will be
438      * allowed to spend on behalf of `owner` through {transferFrom}. This is
439      * zero by default.
440      *
441      * This value changes when {approve} or {transferFrom} are called.
442      */
443     function allowance(address owner, address spender) external view returns (uint256);
444 
445     /**
446      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
447      *
448      * Returns a boolean value indicating whether the operation succeeded.
449      *
450      * IMPORTANT: Beware that changing an allowance with this method brings the risk
451      * that someone may use both the old and the new allowance by unfortunate
452      * transaction ordering. One possible solution to mitigate this race
453      * condition is to first reduce the spender's allowance to 0 and set the
454      * desired value afterwards:
455      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
456      *
457      * Emits an {Approval} event.
458      */
459     function approve(address spender, uint256 amount) external returns (bool);
460 
461     /**
462      * @dev Moves `amount` tokens from `sender` to `recipient` using the
463      * allowance mechanism. `amount` is then deducted from the caller's
464      * allowance.
465      *
466      * Returns a boolean value indicating whether the operation succeeded.
467      *
468      * Emits a {Transfer} event.
469      */
470     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
471 
472     /**
473      * @dev Emitted when `value` tokens are moved from one account (`from`) to
474      * another (`to`).
475      *
476      * Note that `value` may be zero.
477      */
478     event Transfer(address indexed from, address indexed to, uint256 value);
479 
480     /**
481      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
482      * a call to {approve}. `value` is the new allowance.
483      */
484     event Approval(address indexed owner, address indexed spender, uint256 value);
485 }
486 
487 // 
488 interface ICoFiStakingRewards {
489     // Views
490 
491     /// @dev Reward amount represents by per staking token
492     function rewardPerToken() external view returns (uint256);
493 
494     /// @dev How many reward tokens a user has earned but not claimed at present
495     /// @param  account The target account
496     /// @return The amount of reward tokens a user earned
497     function earned(address account) external view returns (uint256);
498 
499     /// @dev How many reward tokens accrued recently
500     /// @return The amount of reward tokens accrued recently
501     function accrued() external view returns (uint256);
502 
503     /// @dev How many stakingToken (XToken) deposited into to this reward pool (staking pool)
504     /// @return The total amount of XTokens deposited in this staking pool
505     function totalSupply() external view returns (uint256);
506 
507     /// @dev How many stakingToken (XToken) deposited by the target account
508     /// @param  account The target account
509     /// @return The total amount of XToken deposited in this staking pool
510     function balanceOf(address account) external view returns (uint256);
511 
512     /// @dev Get the address of token for staking in this staking pool
513     /// @return The staking token address
514     function stakingToken() external view returns (address);
515 
516     /// @dev Get the address of token for rewards in this staking pool
517     /// @return The rewards token address
518     function rewardsToken() external view returns (address);
519 
520     // Mutative
521 
522     /// @dev Stake/Deposit into the reward pool (staking pool)
523     /// @param  amount The target amount
524     function stake(uint256 amount) external;
525 
526     /// @dev Stake/Deposit into the reward pool (staking pool) for other account
527     /// @param  other The target account
528     /// @param  amount The target amount
529     function stakeForOther(address other, uint256 amount) external;
530 
531     /// @dev Withdraw from the reward pool (staking pool), get the original tokens back
532     /// @param  amount The target amount
533     function withdraw(uint256 amount) external;
534     
535     /// @dev Withdraw without caring about rewards. EMERGENCY ONLY.
536     function emergencyWithdraw() external;
537 
538     /// @dev Claim the reward the user earned
539     function getReward() external;
540 
541     /// @dev Add ETH reward to the staking pool
542     function addETHReward() external payable;
543 
544     /// @dev User exit the reward pool, it's actually withdraw and getReward
545     function exit() external;
546 
547     // Events
548     event Staked(address indexed user, uint256 amount);
549     event StakedForOther(address indexed user, address indexed other, uint256 amount);
550     event Withdrawn(address indexed user, uint256 amount);
551     event SavingWithdrawn(address indexed to, uint256 amount);
552     event EmergencyWithdraw(address indexed user, uint256 amount);
553     event RewardPaid(address indexed user, uint256 reward);
554     
555 }
556 
557 // 
558 interface ICoFiXFactory {
559     // All pairs: {ETH <-> ERC20 Token}
560     event PairCreated(address indexed token, address pair, uint256);
561     event NewGovernance(address _new);
562     event NewController(address _new);
563     event NewFeeReceiver(address _new);
564     event NewFeeVaultForLP(address token, address feeVault);
565     event NewVaultForLP(address _new);
566     event NewVaultForTrader(address _new);
567     event NewVaultForCNode(address _new);
568 
569     /// @dev Create a new token pair for trading
570     /// @param  token the address of token to trade
571     /// @return pair the address of new token pair
572     function createPair(
573         address token
574         )
575         external
576         returns (address pair);
577 
578     function getPair(address token) external view returns (address pair);
579     function allPairs(uint256) external view returns (address pair);
580     function allPairsLength() external view returns (uint256);
581 
582     function getTradeMiningStatus(address token) external view returns (bool status);
583     function setTradeMiningStatus(address token, bool status) external;
584     function getFeeVaultForLP(address token) external view returns (address feeVault); // for LPs
585     function setFeeVaultForLP(address token, address feeVault) external;
586 
587     function setGovernance(address _new) external;
588     function setController(address _new) external;
589     function setFeeReceiver(address _new) external;
590     function setVaultForLP(address _new) external;
591     function setVaultForTrader(address _new) external;
592     function setVaultForCNode(address _new) external;
593     function getController() external view returns (address controller);
594     function getFeeReceiver() external view returns (address feeReceiver); // For CoFi Holders
595     function getVaultForLP() external view returns (address vaultForLP);
596     function getVaultForTrader() external view returns (address vaultForTrader);
597     function getVaultForCNode() external view returns (address vaultForCNode);
598 }
599 
600 // 
601 // Stake XToken to earn CoFi Token
602 contract CoFiXStakingRewards is ICoFiXStakingRewards, ReentrancyGuard {
603     using SafeMath for uint256;
604 
605     /* ========== STATE VARIABLES ========== */
606 
607     address public override immutable rewardsToken; // CoFi
608     address public override immutable stakingToken; // XToken or CNode
609 
610     address public immutable factory;
611 
612     uint256 public lastUpdateBlock;
613     uint256 public rewardPerTokenStored;
614 
615     mapping(address => uint256) public userRewardPerTokenPaid;
616     mapping(address => uint256) public rewards;
617 
618     uint256 private _totalSupply;
619     mapping(address => uint256) private _balances;
620 
621     /* ========== CONSTRUCTOR ========== */
622 
623     constructor(
624         address _rewardsToken,
625         address _stakingToken,
626         address _factory
627     ) public {
628         rewardsToken = _rewardsToken;
629         stakingToken = _stakingToken;
630         require(ICoFiXFactory(_factory).getVaultForLP() != address(0), "VaultForLP not set yet"); // check
631         factory = _factory;
632         lastUpdateBlock = 11040688; // https://etherscan.io/block/countdown/11040688    
633     }
634 
635     /* ========== VIEWS ========== */
636 
637     // replace cofixVault with rewardsVault, this could introduce more calls, but clear is more important 
638     function rewardsVault() public virtual override view returns (address) {
639         return ICoFiXFactory(factory).getVaultForLP();
640     }
641 
642     function totalSupply() external override view returns (uint256) {
643         return _totalSupply;
644     }
645 
646     function balanceOf(address account) external override view returns (uint256) {
647         return _balances[account];
648     }
649 
650     function lastBlockRewardApplicable() public override view returns (uint256) {
651         return block.number;
652     }
653 
654     function rewardPerToken() public override view returns (uint256) {
655         if (_totalSupply == 0) {
656             return rewardPerTokenStored;
657         }
658         return
659             rewardPerTokenStored.add(
660                 accrued().mul(1e18).div(_totalSupply)
661             );
662     }
663 
664     function _rewardPerTokenAndAccrued() internal view returns (uint256, uint256) {
665         if (_totalSupply == 0) {
666             // use the old rewardPerTokenStored, and accrued should be zero here
667             // if not the new accrued amount will never be distributed to anyone
668             return (rewardPerTokenStored, 0);
669         }
670         uint256 _accrued = accrued();
671         uint256 _rewardPerToken = rewardPerTokenStored.add(
672                 _accrued.mul(1e18).div(_totalSupply)
673             );
674         return (_rewardPerToken, _accrued);
675     }
676 
677     function rewardRate() public virtual override view returns (uint256) {
678         return ICoFiXVaultForLP(rewardsVault()).currentPoolRate(address(this));
679     }
680 
681     function accrued() public virtual override view returns (uint256) {
682         // calc block rewards
683         uint256 blockReward = lastBlockRewardApplicable().sub(lastUpdateBlock).mul(rewardRate());
684         // query pair trading rewards
685         uint256 tradingReward = ICoFiXVaultForLP(rewardsVault()).getPendingRewardOfLP(stakingToken);
686         return blockReward.add(tradingReward);
687     }
688 
689     function earned(address account) public override view returns (uint256) {
690         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
691     }
692 
693     /* ========== MUTATIVE FUNCTIONS ========== */
694 
695     function stake(uint256 amount) external override nonReentrant updateReward(msg.sender) {
696         require(amount > 0, "Cannot stake 0");
697         _totalSupply = _totalSupply.add(amount);
698         _balances[msg.sender] = _balances[msg.sender].add(amount);
699         TransferHelper.safeTransferFrom(stakingToken, msg.sender, address(this), amount);
700         emit Staked(msg.sender, amount);
701     }
702 
703     function stakeForOther(address other, uint256 amount) external override nonReentrant updateReward(other) {
704         require(amount > 0, "Cannot stake 0");
705         _totalSupply = _totalSupply.add(amount);
706         _balances[other] = _balances[other].add(amount);
707         TransferHelper.safeTransferFrom(stakingToken, msg.sender, address(this), amount);
708         emit StakedForOther(msg.sender, other, amount);
709     }
710 
711     function withdraw(uint256 amount) public override nonReentrant updateReward(msg.sender) {
712         require(amount > 0, "Cannot withdraw 0");
713         _totalSupply = _totalSupply.sub(amount);
714         _balances[msg.sender] = _balances[msg.sender].sub(amount);
715         TransferHelper.safeTransfer(stakingToken, msg.sender, amount);
716         emit Withdrawn(msg.sender, amount);
717     }
718 
719     // Withdraw without caring about rewards. EMERGENCY ONLY.
720     function emergencyWithdraw() external override nonReentrant {
721         uint256 amount = _balances[msg.sender];
722         require(amount > 0, "Cannot withdraw 0");
723         _totalSupply = _totalSupply.sub(amount);
724         _balances[msg.sender] = 0;
725         rewards[msg.sender] = 0;
726         TransferHelper.safeTransfer(stakingToken, msg.sender, amount);
727         emit EmergencyWithdraw(msg.sender, amount);
728     }
729 
730     function getReward() public override nonReentrant updateReward(msg.sender) {
731         uint256 reward = rewards[msg.sender];
732         if (reward > 0) {
733             rewards[msg.sender] = 0;
734             // TransferHelper.safeTransfer(rewardsToken, msg.sender, reward);
735             uint256 transferred = _safeCoFiTransfer(msg.sender, reward);
736             emit RewardPaid(msg.sender, transferred);
737         }
738     }
739 
740     // get CoFi rewards and staking into CoFiStakingRewards pool
741     function getRewardAndStake() external override nonReentrant updateReward(msg.sender) {
742         uint256 reward = rewards[msg.sender];
743         if (reward > 0) {
744             rewards[msg.sender] = 0;
745             address cofiStakingPool = ICoFiXVaultForLP(rewardsVault()).getCoFiStakingPool(); // also work for VaultForCNode
746             require(cofiStakingPool != address(0), "cofiStakingPool not set");
747             // approve to staking pool
748             address _rewardsToken = rewardsToken;
749             IERC20(_rewardsToken).approve(cofiStakingPool, reward);
750             ICoFiStakingRewards(cofiStakingPool).stakeForOther(msg.sender, reward);
751             IERC20(_rewardsToken).approve(cofiStakingPool, 0); // ensure
752             emit RewardPaid(msg.sender, reward);
753         }
754     }
755 
756     function exit() external override {
757         withdraw(_balances[msg.sender]);
758         getReward();
759     }
760 
761     // add reward from trading pool or anyone else
762     function addReward(uint256 amount) public override nonReentrant updateReward(address(0)) {
763         // transfer from caller (router contract)
764         TransferHelper.safeTransferFrom(rewardsToken, msg.sender, address(this), amount);
765         // update rewardPerTokenStored
766         rewardPerTokenStored = rewardPerTokenStored.add(amount.mul(1e18).div(_totalSupply));
767         emit RewardAdded(msg.sender, amount);
768     }
769 
770     // Safe CoFi transfer function, just in case if rounding error or ending of mining causes pool to not have enough CoFis.
771     function _safeCoFiTransfer(address _to, uint256 _amount) internal returns (uint256) {
772         uint256 cofiBal = IERC20(rewardsToken).balanceOf(address(this));
773         if (_amount > cofiBal) {
774             _amount = cofiBal;
775         }
776         TransferHelper.safeTransfer(rewardsToken, _to, _amount); // allow zero amount
777         return _amount;
778     }
779 
780     /* ========== MODIFIERS ========== */
781 
782     modifier updateReward(address account) virtual {
783         // rewardPerTokenStored = rewardPerToken();
784         // uint256 newAccrued = accrued();
785         (uint256 newRewardPerToken, uint256 newAccrued) = _rewardPerTokenAndAccrued();
786         rewardPerTokenStored = newRewardPerToken;
787         if (newAccrued > 0) {
788             // distributeReward could fail if CoFiXVaultForLP is not minter of CoFi anymore
789             // Should set reward rate to zero first, and then do a settlement of pool reward by call getReward
790             ICoFiXVaultForLP(rewardsVault()).distributeReward(address(this), newAccrued);
791         } 
792         lastUpdateBlock = lastBlockRewardApplicable();
793         if (account != address(0)) {
794             rewards[account] = earned(account);
795             userRewardPerTokenPaid[account] = rewardPerTokenStored;
796         }
797         _;
798     }
799 
800     /* ========== EVENTS ========== */
801 
802     event RewardAdded(address sender, uint256 reward);
803     event Staked(address indexed user, uint256 amount);
804     event StakedForOther(address indexed user, address indexed other, uint256 amount);
805     event Withdrawn(address indexed user, uint256 amount);
806     event EmergencyWithdraw(address indexed user, uint256 amount);
807     event RewardPaid(address indexed user, uint256 reward);
808 }