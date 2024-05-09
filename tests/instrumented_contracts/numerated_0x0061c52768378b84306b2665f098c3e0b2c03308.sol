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
289 interface ICoFiStakingRewards {
290     // Views
291 
292     /// @dev Reward amount represents by per staking token
293     function rewardPerToken() external view returns (uint256);
294 
295     /// @dev How many reward tokens a user has earned but not claimed at present
296     /// @param  account The target account
297     /// @return The amount of reward tokens a user earned
298     function earned(address account) external view returns (uint256);
299 
300     /// @dev How many reward tokens accrued recently
301     /// @return The amount of reward tokens accrued recently
302     function accrued() external view returns (uint256);
303 
304     /// @dev How many stakingToken (XToken) deposited into to this reward pool (staking pool)
305     /// @return The total amount of XTokens deposited in this staking pool
306     function totalSupply() external view returns (uint256);
307 
308     /// @dev How many stakingToken (XToken) deposited by the target account
309     /// @param  account The target account
310     /// @return The total amount of XToken deposited in this staking pool
311     function balanceOf(address account) external view returns (uint256);
312 
313     /// @dev Get the address of token for staking in this staking pool
314     /// @return The staking token address
315     function stakingToken() external view returns (address);
316 
317     /// @dev Get the address of token for rewards in this staking pool
318     /// @return The rewards token address
319     function rewardsToken() external view returns (address);
320 
321     // Mutative
322 
323     /// @dev Stake/Deposit into the reward pool (staking pool)
324     /// @param  amount The target amount
325     function stake(uint256 amount) external;
326 
327     /// @dev Stake/Deposit into the reward pool (staking pool) for other account
328     /// @param  other The target account
329     /// @param  amount The target amount
330     function stakeForOther(address other, uint256 amount) external;
331 
332     /// @dev Withdraw from the reward pool (staking pool), get the original tokens back
333     /// @param  amount The target amount
334     function withdraw(uint256 amount) external;
335     
336     /// @dev Withdraw without caring about rewards. EMERGENCY ONLY.
337     function emergencyWithdraw() external;
338 
339     /// @dev Claim the reward the user earned
340     function getReward() external;
341 
342     /// @dev Add ETH reward to the staking pool
343     function addETHReward() external payable;
344 
345     /// @dev User exit the reward pool, it's actually withdraw and getReward
346     function exit() external;
347 
348     // Events
349     event Staked(address indexed user, uint256 amount);
350     event StakedForOther(address indexed user, address indexed other, uint256 amount);
351     event Withdrawn(address indexed user, uint256 amount);
352     event SavingWithdrawn(address indexed to, uint256 amount);
353     event EmergencyWithdraw(address indexed user, uint256 amount);
354     event RewardPaid(address indexed user, uint256 reward);
355     
356 }
357 
358 // 
359 /**
360  * @dev Interface of the ERC20 standard as defined in the EIP.
361  */
362 interface IERC20 {
363     /**
364      * @dev Returns the amount of tokens in existence.
365      */
366     function totalSupply() external view returns (uint256);
367 
368     /**
369      * @dev Returns the amount of tokens owned by `account`.
370      */
371     function balanceOf(address account) external view returns (uint256);
372 
373     /**
374      * @dev Moves `amount` tokens from the caller's account to `recipient`.
375      *
376      * Returns a boolean value indicating whether the operation succeeded.
377      *
378      * Emits a {Transfer} event.
379      */
380     function transfer(address recipient, uint256 amount) external returns (bool);
381 
382     /**
383      * @dev Returns the remaining number of tokens that `spender` will be
384      * allowed to spend on behalf of `owner` through {transferFrom}. This is
385      * zero by default.
386      *
387      * This value changes when {approve} or {transferFrom} are called.
388      */
389     function allowance(address owner, address spender) external view returns (uint256);
390 
391     /**
392      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
393      *
394      * Returns a boolean value indicating whether the operation succeeded.
395      *
396      * IMPORTANT: Beware that changing an allowance with this method brings the risk
397      * that someone may use both the old and the new allowance by unfortunate
398      * transaction ordering. One possible solution to mitigate this race
399      * condition is to first reduce the spender's allowance to 0 and set the
400      * desired value afterwards:
401      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
402      *
403      * Emits an {Approval} event.
404      */
405     function approve(address spender, uint256 amount) external returns (bool);
406 
407     /**
408      * @dev Moves `amount` tokens from `sender` to `recipient` using the
409      * allowance mechanism. `amount` is then deducted from the caller's
410      * allowance.
411      *
412      * Returns a boolean value indicating whether the operation succeeded.
413      *
414      * Emits a {Transfer} event.
415      */
416     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
417 
418     /**
419      * @dev Emitted when `value` tokens are moved from one account (`from`) to
420      * another (`to`).
421      *
422      * Note that `value` may be zero.
423      */
424     event Transfer(address indexed from, address indexed to, uint256 value);
425 
426     /**
427      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
428      * a call to {approve}. `value` is the new allowance.
429      */
430     event Approval(address indexed owner, address indexed spender, uint256 value);
431 }
432 
433 // 
434 interface IWETH {
435     function deposit() external payable;
436     function transfer(address to, uint value) external returns (bool);
437     function withdraw(uint) external;
438     function balanceOf(address account) external view returns (uint);
439 }
440 
441 // 
442 // Stake CoFi to earn ETH
443 contract CoFiStakingRewards is ICoFiStakingRewards, ReentrancyGuard {
444     using SafeMath for uint256;
445 
446     /* ========== STATE VARIABLES ========== */
447 
448     address public override immutable rewardsToken; // WETH, received from CoFiXPair, to reduce gas cost for each swap
449     address public override immutable stakingToken; // CoFi
450 
451     address public governance;
452     uint256 public dividendShare = 20; // 20% to CoFi holders as dividend, 80% to saving for buying back
453 
454     uint256 public pendingSavingAmount;
455 
456     uint256 public lastUpdateRewardsTokenBalance; // must refresh after each WETH balance change
457     uint256 public rewardPerTokenStored;
458 
459     mapping(address => uint256) public userRewardPerTokenPaid;
460     mapping(address => uint256) public rewards;
461 
462     uint256 private _totalSupply;
463     mapping(address => uint256) private _balances;
464 
465     /* ========== CONSTRUCTOR ========== */
466 
467     constructor(
468         address _rewardsToken,
469         address _stakingToken
470     ) public {
471         rewardsToken = _rewardsToken;
472         stakingToken = _stakingToken;
473         governance = msg.sender;
474     }
475 
476     receive() external payable {}
477 
478     /* ========== VIEWS ========== */
479 
480     function totalSupply() external override view returns (uint256) {
481         return _totalSupply;
482     }
483 
484     function balanceOf(address account) external override view returns (uint256) {
485         return _balances[account];
486     }
487 
488     function rewardPerToken() public override view returns (uint256) {
489         if (_totalSupply == 0) {
490             // use the old rewardPerTokenStored
491             // if not, the new accrued amount will never be distributed to anyone
492             return rewardPerTokenStored;
493         }
494         return
495             rewardPerTokenStored.add(
496                 accrued().mul(1e18).mul(dividendShare).div(_totalSupply).div(100)
497             );
498     }
499 
500     function _rewardPerTokenAndAccrued() internal view returns (uint256, uint256) {
501         if (_totalSupply == 0) {
502             // use the old rewardPerTokenStored, and accrued should be zero here
503             // if not the new accrued amount will never be distributed to anyone
504             return (rewardPerTokenStored, 0);
505         }
506         uint256 _accrued = accrued();
507         uint256 _rewardPerToken = rewardPerTokenStored.add(
508                 _accrued.mul(1e18).mul(dividendShare).div(_totalSupply).div(100) // 50% of accrued to CoFi holders as dividend
509             );
510         return (_rewardPerToken, _accrued);
511     }
512 
513     function accrued() public override view returns (uint256) {
514         // balance increment of WETH between the last update and now
515         uint256 newest = IWETH(rewardsToken).balanceOf(address(this));
516         return newest.sub(lastUpdateRewardsTokenBalance); // lastest must be larger than lastUpdate
517     }
518 
519     function earned(address account) public override view returns (uint256) {
520         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
521     }
522 
523     /* ========== MUTATIVE FUNCTIONS ========== */
524 
525     function stake(uint256 amount) external override nonReentrant updateReward(msg.sender) {
526         require(amount > 0, "Cannot stake 0");
527         _totalSupply = _totalSupply.add(amount);
528         _balances[msg.sender] = _balances[msg.sender].add(amount);
529         TransferHelper.safeTransferFrom(stakingToken, msg.sender, address(this), amount);
530         emit Staked(msg.sender, amount);
531     }
532 
533     function stakeForOther(address other, uint256 amount) external override nonReentrant updateReward(other) {
534         require(amount > 0, "Cannot stake 0");
535         _totalSupply = _totalSupply.add(amount);
536         _balances[other] = _balances[other].add(amount);
537         // be careful: caller should approve to zero after usage
538         TransferHelper.safeTransferFrom(stakingToken, msg.sender, address(this), amount);
539         emit StakedForOther(msg.sender, other, amount);
540     }
541 
542     function withdraw(uint256 amount) public override nonReentrant updateReward(msg.sender) {
543         require(amount > 0, "Cannot withdraw 0");
544         _totalSupply = _totalSupply.sub(amount);
545         _balances[msg.sender] = _balances[msg.sender].sub(amount);
546         TransferHelper.safeTransfer(stakingToken, msg.sender, amount);
547         emit Withdrawn(msg.sender, amount);
548     }
549 
550     // Withdraw without caring about rewards. EMERGENCY ONLY.
551     function emergencyWithdraw() public override nonReentrant {
552         uint256 amount = _balances[msg.sender];
553         require(amount > 0, "Cannot withdraw 0");
554         _totalSupply = _totalSupply.sub(amount);
555         _balances[msg.sender] = 0;
556         rewards[msg.sender] = 0;
557         TransferHelper.safeTransfer(stakingToken, msg.sender, amount);
558         emit EmergencyWithdraw(msg.sender, amount);
559     }
560 
561     function getReward() public override nonReentrant updateReward(msg.sender) {
562         uint256 reward = rewards[msg.sender];
563         if (reward > 0) {
564             rewards[msg.sender] = 0;
565             // WETH balance decreased after this
566             uint256 transferred = _safeWETHTransfer(msg.sender, reward);
567             // must refresh WETH balance record after updating WETH balance
568             // or lastUpdateRewardsTokenBalance could be less than the newest WETH balance in the next update
569             lastUpdateRewardsTokenBalance = IWETH(rewardsToken).balanceOf(address(this));
570             emit RewardPaid(msg.sender, transferred);
571         }
572     }
573 
574     function addETHReward() external payable override { // no need to update reward here
575         IWETH(rewardsToken).deposit{value: msg.value}(); // support for sending ETH for rewards
576     }
577 
578     function exit() external override {
579         withdraw(_balances[msg.sender]);
580         getReward();
581     }
582 
583     function setGovernance(address _new) external {
584         require(msg.sender == governance, "CoFiStaking: !governance");
585         governance = _new;
586     }
587 
588     function setDividendShare(uint256 share) external {
589         require(msg.sender == governance, "CoFiStaking: !governance");
590         require(share <= 100, "CoFiStaking: invalid share setting");
591         dividendShare = share;
592     }
593 
594     function withdrawSavingByGov(address _to, uint256 _amount) external nonReentrant {
595         require(msg.sender == governance, "CoFiStaking: !governance");
596         pendingSavingAmount = pendingSavingAmount.sub(_amount);
597         IWETH(rewardsToken).withdraw(_amount);
598         TransferHelper.safeTransferETH(_to, _amount);
599         // must refresh WETH balance record after updating WETH balance
600         // or lastUpdateRewardsTokenBalance could be less than the newest WETH balance in the next update
601         lastUpdateRewardsTokenBalance = IWETH(rewardsToken).balanceOf(address(this));
602         emit SavingWithdrawn(_to, _amount);
603     }
604 
605     // Safe WETH transfer function, just in case if rounding error or ending of mining causes pool to not have enough WETHs.
606     function _safeWETHTransfer(address _to, uint256 _amount) internal returns (uint256) {
607         uint256 bal = IWETH(rewardsToken).balanceOf(address(this));
608         if (_amount > bal) {
609             _amount = bal;
610         }
611         // convert WETH to ETH, and send to `_to`
612         IWETH(rewardsToken).withdraw(_amount);
613         TransferHelper.safeTransferETH(_to, _amount);
614         return _amount;
615     }
616 
617     /* ========== MODIFIERS ========== */
618 
619     modifier updateReward(address account) {
620         (uint256 _rewardPerToken, uint256 _accrued) = _rewardPerTokenAndAccrued();
621         rewardPerTokenStored = _rewardPerToken;
622         if (_accrued > 0) {
623             uint256 newSaving = _accrued.sub(_accrued.mul(dividendShare).div(100)); // left 80%
624             pendingSavingAmount = pendingSavingAmount.add(newSaving);
625         }
626         // means it's the first update
627         // add this check to ensure the WETH transferred in before the first user stake in, could be distributed in the next update
628         if (_totalSupply != 0) { // we can use _accrued here too
629             lastUpdateRewardsTokenBalance = IWETH(rewardsToken).balanceOf(address(this));
630         }
631         if (account != address(0)) {
632             rewards[account] = earned(account);
633             userRewardPerTokenPaid[account] = rewardPerTokenStored;
634         }
635         _;
636     }
637 
638     /* ========== EVENTS ========== */
639 
640     event RewardAdded(address sender, uint256 reward);
641     event Staked(address indexed user, uint256 amount);
642     event StakedForOther(address indexed user, address indexed other, uint256 amount);
643     event Withdrawn(address indexed user, uint256 amount);
644     event SavingWithdrawn(address indexed to, uint256 amount);
645     event EmergencyWithdraw(address indexed user, uint256 amount);
646     event RewardPaid(address indexed user, uint256 reward);
647 }