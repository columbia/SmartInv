1 pragma solidity ^0.5.0;
2 
3 
4 interface IERC20 {
5     /**
6      * @dev Returns the amount of tokens in existence.
7      */
8     function totalSupply() external view returns (uint256);
9 
10     /**
11      * @dev Returns the amount of tokens owned by `account`.
12      */
13     function balanceOf(address account) external view returns (uint256);
14 
15     /**
16      * @dev Moves `amount` tokens from the caller's account to `recipient`.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * Emits a {Transfer} event.
21      */
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through {transferFrom}. This is
27      * zero by default.
28      *
29      * This value changes when {approve} or {transferFrom} are called.
30      */
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     /**
34      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * IMPORTANT: Beware that changing an allowance with this method brings the risk
39      * that someone may use both the old and the new allowance by unfortunate
40      * transaction ordering. One possible solution to mitigate this race
41      * condition is to first reduce the spender's allowance to 0 and set the
42      * desired value afterwards:
43      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
44      *
45      * Emits an {Approval} event.
46      */
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Moves `amount` tokens from `sender` to `recipient` using the
51      * allowance mechanism. `amount` is then deducted from the caller's
52      * allowance.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Emitted when `value` tokens are moved from one account (`from`) to
62      * another (`to`).
63      *
64      * Note that `value` may be zero.
65      */
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     /**
69      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
70      * a call to {approve}. `value` is the new allowance.
71      */
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 /**
76  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
77  * the optional functions; to access them see {ERC20Detailed}.
78  */
79 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      * - Subtraction cannot overflow.
131      *
132      * _Available since v2.4.0._
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      * - Multiplication cannot overflow.
149      */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return div(a, b, "SafeMath: division by zero");
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      * - The divisor cannot be zero.
189      *
190      * _Available since v2.4.0._
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         // Solidity only automatically asserts when dividing by 0
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         return mod(a, b, "SafeMath: modulo by zero");
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts with custom message when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      * - The divisor cannot be zero.
226      *
227      * _Available since v2.4.0._
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following 
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
258         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
259         // for accounts without code, i.e. `keccak256('')`
260         bytes32 codehash;
261         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
262         // solhint-disable-next-line no-inline-assembly
263         assembly { codehash := extcodehash(account) }
264         return (codehash != accountHash && codehash != 0x0);
265     }
266 
267     /**
268      * @dev Converts an `address` into `address payable`. Note that this is
269      * simply a type cast: the actual underlying value is not changed.
270      *
271      * _Available since v2.4.0._
272      */
273     function toPayable(address account) internal pure returns (address payable) {
274         return address(uint160(account));
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      *
293      * _Available since v2.4.0._
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-call-value
299         (bool success, ) = recipient.call.value(amount)("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 }
303 
304 library SafeERC20 {
305     using SafeMath for uint256;
306     using Address for address;
307 
308     function safeTransfer(IERC20 token, address to, uint256 value) internal {
309         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
310     }
311 
312     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
313         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
314     }
315 
316     function safeApprove(IERC20 token, address spender, uint256 value) internal {
317         // safeApprove should only be called when setting an initial allowance,
318         // or when resetting it to zero. To increase and decrease it, use
319         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
320         // solhint-disable-next-line max-line-length
321         require((value == 0) || (token.allowance(address(this), spender) == 0),
322             "SafeERC20: approve from non-zero to non-zero allowance"
323         );
324         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
325     }
326 
327     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
328         uint256 newAllowance = token.allowance(address(this), spender).add(value);
329         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
330     }
331 
332     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
333         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
334         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
335     }
336 
337     /**
338      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
339      * on the return value: the return value is optional (but if data is returned, it must not be false).
340      * @param token The token targeted by the call.
341      * @param data The call data (encoded using abi.encode or one of its variants).
342      */
343     function callOptionalReturn(IERC20 token, bytes memory data) private {
344         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
345         // we're implementing it ourselves.
346 
347         // A Solidity high level call has three parts:
348         //  1. The target address is checked to verify it contains contract code
349         //  2. The call itself is made, and success asserted
350         //  3. The return value is decoded, which in turn checks the size of the returned data.
351         // solhint-disable-next-line max-line-length
352         require(address(token).isContract(), "SafeERC20: call to non-contract");
353 
354         // solhint-disable-next-line avoid-low-level-calls
355         (bool success, bytes memory returndata) = address(token).call(data);
356         require(success, "SafeERC20: low-level call failed");
357 
358         if (returndata.length > 0) { // Return data is optional
359             // solhint-disable-next-line max-line-length
360             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
361         }
362     }
363 }
364 
365 library Math {
366     /**
367      * @dev Returns the largest of two numbers.
368      */
369     function max(uint256 a, uint256 b) internal pure returns (uint256) {
370         return a >= b ? a : b;
371     }
372 
373     /**
374      * @dev Returns the smallest of two numbers.
375      */
376     function min(uint256 a, uint256 b) internal pure returns (uint256) {
377         return a < b ? a : b;
378     }
379 
380     /**
381      * @dev Returns the average of two numbers. The result is rounded towards
382      * zero.
383      */
384     function average(uint256 a, uint256 b) internal pure returns (uint256) {
385         // (a + b) / 2 can overflow, so we distribute
386         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
387     }
388 }
389 
390 /*
391  * @dev Provides information about the current execution context, including the
392  * sender of the transaction and its data. While these are generally available
393  * via msg.sender and msg.data, they should not be accessed in such a direct
394  * manner, since when dealing with GSN meta-transactions the account sending and
395  * paying for execution may not be the actual sender (as far as an application
396  * is concerned).
397  *
398  * This contract is only required for intermediate, library-like contracts.
399  */
400 contract Context {
401     // Empty internal constructor, to prevent people from mistakenly deploying
402     // an instance of this contract, which should be used via inheritance.
403     constructor () internal { }
404     // solhint-disable-previous-line no-empty-blocks
405 
406     function _msgSender() internal view returns (address payable) {
407         return msg.sender;
408     }
409 
410     function _msgData() internal view returns (bytes memory) {
411         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
412         return msg.data;
413     }
414 }
415 
416 contract Ownable is Context {
417     address private _owner;
418 
419     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
420 
421     /**
422      * @dev Initializes the contract setting the deployer as the initial owner.
423      */
424     constructor () internal {
425         address msgSender = _msgSender();
426         _owner = msgSender;
427         emit OwnershipTransferred(address(0), msgSender);
428     }
429 
430     /**
431      * @dev Returns the address of the current owner.
432      */
433     function owner() public view returns (address) {
434         return _owner;
435     }
436 
437     /**
438      * @dev Throws if called by any account other than the owner.
439      */
440     modifier onlyOwner() {
441         require(isOwner(), "Ownable: caller is not the owner");
442         _;
443     }
444 
445     /**
446      * @dev Returns true if the caller is the current owner.
447      */
448     function isOwner() public view returns (bool) {
449         return _msgSender() == _owner;
450     }
451 
452     /**
453      * @dev Leaves the contract without owner. It will not be possible to call
454      * `onlyOwner` functions anymore. Can only be called by the current owner.
455      *
456      * NOTE: Renouncing ownership will leave the contract without an owner,
457      * thereby removing any functionality that is only available to the owner.
458      */
459     function renounceOwnership() public onlyOwner {
460         emit OwnershipTransferred(_owner, address(0));
461         _owner = address(0);
462     }
463 
464     /**
465      * @dev Transfers ownership of the contract to a new account (`newOwner`).
466      * Can only be called by the current owner.
467      */
468     function transferOwnership(address newOwner) public onlyOwner {
469         _transferOwnership(newOwner);
470     }
471 
472     /**
473      * @dev Transfers ownership of the contract to a new account (`newOwner`).
474      */
475     function _transferOwnership(address newOwner) internal {
476         require(newOwner != address(0), "Ownable: new owner is the zero address");
477         emit OwnershipTransferred(_owner, newOwner);
478         _owner = newOwner;
479     }
480 }
481 
482 /**
483  *Submitted for verification at Etherscan.io on 2020-11-04
484 */
485 /**
486  *Submitted for verification at Etherscan.io on 2020-10-21
487 */
488 /**
489  *Submitted for verification at Etherscan.io on 2020-04-22
490 */
491 /*
492    ____            __   __        __   _
493   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
494  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
495 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
496      /___/
497 
498 * Synthetix: DefiDollarRewards.sol
499 *
500 * Docs: https://docs.synthetix.io/
501 *
502 *
503 * MIT License
504 * ===========
505 *
506 * Copyright (c) 2020 Synthetix
507 *
508 * Permission is hereby granted, free of charge, to any person obtaining a copy
509 * of this software and associated documentation files (the "Software"), to deal
510 * in the Software without restriction, including without limitation the rights
511 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
512 * copies of the Software, and to permit persons to whom the Software is
513 * furnished to do so, subject to the following conditions:
514 *
515 * The above copyright notice and this permission notice shall be included in all
516 * copies or substantial portions of the Software.
517 *
518 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
519 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
520 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
521 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
522 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
523 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
524 */
525 // File: @openzeppelin/contracts/math/Math.sol
526 contract IRewardDistributionRecipient is Ownable {
527     address public rewardDistribution;
528 
529     function notifyRewardAmount(uint256 reward) external;
530 
531     modifier onlyRewardDistribution() {
532         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
533         _;
534     }
535 
536     function setRewardDistribution(address _rewardDistribution)
537         external
538         onlyOwner
539     {
540         rewardDistribution = _rewardDistribution;
541     }
542 }
543 
544 contract LPTokenWrapper {
545     using SafeMath for uint256;
546     using SafeERC20 for IERC20;
547 
548     IERC20 public uni;
549 
550     uint256 private _totalSupply;
551     mapping(address => uint256) private _balances;
552 
553     function totalSupply() public view returns (uint256) {
554         return _totalSupply;
555     }
556 
557     function balanceOf(address account) public view returns (uint256) {
558         return _balances[account];
559     }
560 
561     function stake(uint256 amount) public {
562         _totalSupply = _totalSupply.add(amount);
563         _balances[msg.sender] = _balances[msg.sender].add(amount);
564         uni.safeTransferFrom(msg.sender, address(this), amount);
565     }
566 
567     function withdraw(uint256 amount) public {
568         _totalSupply = _totalSupply.sub(amount);
569         _balances[msg.sender] = _balances[msg.sender].sub(amount);
570         uni.safeTransfer(msg.sender, amount);
571     }
572 }
573 
574 contract DefiDollarRewards is LPTokenWrapper, IRewardDistributionRecipient {
575     IERC20 public snx;
576     uint256 public constant DURATION = 7 days;
577 
578     uint256 public periodFinish = 0;
579     uint256 public rewardRate = 0;
580     uint256 public lastUpdateTime;
581     uint256 public rewardPerTokenStored;
582     mapping(address => uint256) public userRewardPerTokenPaid;
583     mapping(address => uint256) public rewards;
584 
585     event RewardAdded(uint256 reward);
586     event Staked(address indexed user, uint256 amount);
587     event Withdrawn(address indexed user, uint256 amount);
588     event RewardPaid(address indexed user, uint256 reward);
589 
590     constructor(IERC20 rewardToken, IERC20 lpToken) public {
591         require(
592            address(rewardToken) != address(0x0) &&
593            address(lpToken) != address(0x0),
594            "ZERO Addresses"
595         );
596         snx = rewardToken;
597         uni = lpToken;
598     }
599 
600     modifier updateReward(address account) {
601         rewardPerTokenStored = rewardPerToken();
602         lastUpdateTime = lastTimeRewardApplicable();
603         if (account != address(0)) {
604             rewards[account] = earned(account);
605             userRewardPerTokenPaid[account] = rewardPerTokenStored;
606         }
607         _;
608     }
609 
610     function lastTimeRewardApplicable() public view returns (uint256) {
611         return Math.min(block.timestamp, periodFinish);
612     }
613 
614     function rewardPerToken() public view returns (uint256) {
615         if (totalSupply() == 0) {
616             return rewardPerTokenStored;
617         }
618         return
619             rewardPerTokenStored.add(
620                 lastTimeRewardApplicable()
621                     .sub(lastUpdateTime)
622                     .mul(rewardRate)
623                     .mul(1e18)
624                     .div(totalSupply())
625             );
626     }
627 
628     function earned(address account) public view returns (uint256) {
629         return
630             balanceOf(account)
631                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
632                 .div(1e18)
633                 .add(rewards[account]);
634     }
635 
636     // stake visibility is public as overriding LPTokenWrapper's stake() function
637     function stake(uint256 amount) public updateReward(msg.sender) {
638         require(amount > 0, "Cannot stake 0");
639         super.stake(amount);
640         emit Staked(msg.sender, amount);
641     }
642 
643     function withdraw(uint256 amount) public updateReward(msg.sender) {
644         require(amount > 0, "Cannot withdraw 0");
645         super.withdraw(amount);
646         emit Withdrawn(msg.sender, amount);
647     }
648 
649     function exit() external {
650         withdraw(balanceOf(msg.sender));
651         getReward();
652     }
653 
654     function getReward() public updateReward(msg.sender) {
655         uint256 reward = earned(msg.sender);
656         if (reward > 0) {
657             rewards[msg.sender] = 0;
658             snx.safeTransfer(msg.sender, reward);
659             emit RewardPaid(msg.sender, reward);
660         }
661     }
662 
663     function notifyRewardAmount(uint256 reward)
664         external
665         onlyRewardDistribution
666         updateReward(address(0))
667     {
668         snx.safeTransferFrom(msg.sender, address(this), reward);
669 
670         if (block.timestamp >= periodFinish) {
671             rewardRate = reward.div(DURATION);
672         } else {
673             uint256 remaining = periodFinish.sub(block.timestamp);
674             uint256 leftover = remaining.mul(rewardRate);
675             rewardRate = reward.add(leftover).div(DURATION);
676         }
677         lastUpdateTime = block.timestamp;
678         periodFinish = block.timestamp.add(DURATION);
679         emit RewardAdded(reward);
680     }
681 }