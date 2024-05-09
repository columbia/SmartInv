1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Deeper Network: DPRRewards.sol
9 *
10 * MIT License
11 * ===========
12 *
13 * Copyright (c) 2020 Synthetix
14 *
15 * Permission is hereby granted, free of charge, to any person obtaining a copy
16 * of this software and associated documentation files (the "Software"), to deal
17 * in the Software without restriction, including without limitation the rights
18 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
19 * copies of the Software, and to permit persons to whom the Software is
20 * furnished to do so, subject to the following conditions:
21 *
22 * The above copyright notice and this permission notice shall be included in all
23 * copies or substantial portions of the Software.
24 *
25 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
26 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
27 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
28 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
29 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
30 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
31 */
32 
33 // File: @openzeppelin/contracts/math/Math.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Standard math utilities missing in the Solidity language.
39  */
40 library Math {
41     /**
42      * @dev Returns the largest of two numbers.
43      */
44     function max(uint256 a, uint256 b) internal pure returns (uint256) {
45         return a >= b ? a : b;
46     }
47 
48     /**
49      * @dev Returns the smallest of two numbers.
50      */
51     function min(uint256 a, uint256 b) internal pure returns (uint256) {
52         return a < b ? a : b;
53     }
54 
55     /**
56      * @dev Returns the average of two numbers. The result is rounded towards
57      * zero.
58      */
59     function average(uint256 a, uint256 b) internal pure returns (uint256) {
60         // (a + b) / 2 can overflow, so we distribute
61         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
62     }
63 }
64 
65 // File: @openzeppelin/contracts/math/SafeMath.sol
66 
67 pragma solidity ^0.5.0;
68 
69 
70 library SafeMath {
71     /**
72      * @dev Returns the addition of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `+` operator.
76      *
77      * Requirements:
78      * - Addition cannot overflow.
79      */
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a, "SafeMath: addition overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the subtraction of two unsigned integers, reverting on
89      * overflow (when the result is negative).
90      *
91      * Counterpart to Solidity's `-` operator.
92      *
93      * Requirements:
94      * - Subtraction cannot overflow.
95      */
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         return sub(a, b, "SafeMath: subtraction overflow");
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      * - Subtraction cannot overflow.
108      *
109      * _Available since v2.4.0._
110      */
111     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
112         require(b <= a, errorMessage);
113         uint256 c = a - b;
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the multiplication of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `*` operator.
123      *
124      * Requirements:
125      * - Multiplication cannot overflow.
126      */
127     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
129         // benefit is lost if 'b' is also tested.
130         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
131         if (a == 0) {
132             return 0;
133         }
134 
135         uint256 c = a * b;
136         require(c / a == b, "SafeMath: multiplication overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the integer division of two unsigned integers. Reverts on
143      * division by zero. The result is rounded towards zero.
144      *
145      * Counterpart to Solidity's `/` operator. Note: this function uses a
146      * `revert` opcode (which leaves remaining gas untouched) while Solidity
147      * uses an invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      */
152     function div(uint256 a, uint256 b) internal pure returns (uint256) {
153         return div(a, b, "SafeMath: division by zero");
154     }
155 
156     /**
157      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
158      * division by zero. The result is rounded towards zero.
159      *
160      * Counterpart to Solidity's `/` operator. Note: this function uses a
161      * `revert` opcode (which leaves remaining gas untouched) while Solidity
162      * uses an invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      * - The divisor cannot be zero.
166      *
167      * _Available since v2.4.0._
168      */
169     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         // Solidity only automatically asserts when dividing by 0
171         require(b > 0, errorMessage);
172         uint256 c = a / b;
173         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
180      * Reverts when dividing by zero.
181      *
182      * Counterpart to Solidity's `%` operator. This function uses a `revert`
183      * opcode (which leaves remaining gas untouched) while Solidity uses an
184      * invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      * - The divisor cannot be zero.
188      */
189     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
190         return mod(a, b, "SafeMath: modulo by zero");
191     }
192 
193     /**
194      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
195      * Reverts with custom message when dividing by zero.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      * - The divisor cannot be zero.
203      *
204      * _Available since v2.4.0._
205      */
206     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b != 0, errorMessage);
208         return a % b;
209     }
210 }
211 
212 // File: @openzeppelin/contracts/GSN/Context.sol
213 
214 pragma solidity ^0.5.0;
215 
216 /*
217  * @dev Provides information about the current execution context, including the
218  * sender of the transaction and its data. While these are generally available
219  * via msg.sender and msg.data, they should not be accessed in such a direct
220  * manner, since when dealing with GSN meta-transactions the account sending and
221  * paying for execution may not be the actual sender (as far as an application
222  * is concerned).
223  *
224  * This contract is only required for intermediate, library-like contracts.
225  */
226 contract Context {
227     // Empty internal constructor, to prevent people from mistakenly deploying
228     // an instance of this contract, which should be used via inheritance.
229     constructor () internal { }
230     // solhint-disable-previous-line no-empty-blocks
231 
232     function _msgSender() internal view returns (address payable) {
233         return msg.sender;
234     }
235 
236     function _msgData() internal view returns (bytes memory) {
237         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
238         return msg.data;
239     }
240 }
241 
242 // File: @openzeppelin/contracts/ownership/Ownable.sol
243 
244 pragma solidity ^0.5.0;
245 
246 /**
247  * @dev Contract module which provides a basic access control mechanism, where
248  * there is an account (an owner) that can be granted exclusive access to
249  * specific functions.
250  *
251  * This module is used through inheritance. It will make available the modifier
252  * `onlyOwner`, which can be applied to your functions to restrict their use to
253  * the owner.
254  */
255 contract Ownable is Context {
256     address private _owner;
257 
258     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
259 
260     /**
261      * @dev Initializes the contract setting the deployer as the initial owner.
262      */
263     constructor () internal {
264         _owner = _msgSender();
265         emit OwnershipTransferred(address(0), _owner);
266     }
267 
268     /**
269      * @dev Returns the address of the current owner.
270      */
271     function owner() public view returns (address) {
272         return _owner;
273     }
274 
275     /**
276      * @dev Throws if called by any account other than the owner.
277      */
278     modifier onlyOwner() {
279         require(isOwner(), "Ownable: caller is not the owner");
280         _;
281     }
282 
283     /**
284      * @dev Returns true if the caller is the current owner.
285      */
286     function isOwner() public view returns (bool) {
287         return _msgSender() == _owner;
288     }
289 
290     /**
291      * @dev Leaves the contract without owner. It will not be possible to call
292      * `onlyOwner` functions anymore. Can only be called by the current owner.
293      *
294      * NOTE: Renouncing ownership will leave the contract without an owner,
295      * thereby removing any functionality that is only available to the owner.
296      */
297     function renounceOwnership() public onlyOwner {
298         emit OwnershipTransferred(_owner, address(0));
299         _owner = address(0);
300     }
301 
302     /**
303      * @dev Transfers ownership of the contract to a new account (`newOwner`).
304      * Can only be called by the current owner.
305      */
306     function transferOwnership(address newOwner) public onlyOwner {
307         _transferOwnership(newOwner);
308     }
309 
310     /**
311      * @dev Transfers ownership of the contract to a new account (`newOwner`).
312      */
313     function _transferOwnership(address newOwner) internal {
314         require(newOwner != address(0), "Ownable: new owner is the zero address");
315         emit OwnershipTransferred(_owner, newOwner);
316         _owner = newOwner;
317     }
318 }
319 
320 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
321 
322 pragma solidity ^0.5.0;
323 
324 /**
325  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
326  * the optional functions; to access them see {ERC20Detailed}.
327  */
328 interface IERC20 {
329     /**
330      * @dev Returns the amount of tokens in existence.
331      */
332     function totalSupply() external view returns (uint256);
333 
334     /**
335      * @dev Returns the amount of tokens owned by `account`.
336      */
337     function balanceOf(address account) external view returns (uint256);
338 
339     /**
340      * @dev Moves `amount` tokens from the caller's account to `recipient`.
341      *
342      * Returns a boolean value indicating whether the operation succeeded.
343      *
344      * Emits a {Transfer} event.
345      */
346     function transfer(address recipient, uint256 amount) external returns (bool);
347 
348     /**
349      * @dev Returns the remaining number of tokens that `spender` will be
350      * allowed to spend on behalf of `owner` through {transferFrom}. This is
351      * zero by default.
352      *
353      * This value changes when {approve} or {transferFrom} are called.
354      */
355     function allowance(address owner, address spender) external view returns (uint256);
356 
357     /**
358      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
359      *
360      * Returns a boolean value indicating whether the operation succeeded.
361      *
362      * IMPORTANT: Beware that changing an allowance with this method brings the risk
363      * that someone may use both the old and the new allowance by unfortunate
364      * transaction ordering. One possible solution to mitigate this race
365      * condition is to first reduce the spender's allowance to 0 and set the
366      * desired value afterwards:
367      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
368      *
369      * Emits an {Approval} event.
370      */
371     function approve(address spender, uint256 amount) external returns (bool);
372 
373     /**
374      * @dev Moves `amount` tokens from `sender` to `recipient` using the
375      * allowance mechanism. `amount` is then deducted from the caller's
376      * allowance.
377      *
378      * Returns a boolean value indicating whether the operation succeeded.
379      *
380      * Emits a {Transfer} event.
381      */
382     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
383 
384     /**
385      * @dev Emitted when `value` tokens are moved from one account (`from`) to
386      * another (`to`).
387      *
388      * Note that `value` may be zero.
389      */
390     event Transfer(address indexed from, address indexed to, uint256 value);
391 
392     /**
393      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
394      * a call to {approve}. `value` is the new allowance.
395      */
396     event Approval(address indexed owner, address indexed spender, uint256 value);
397 }
398 
399 // File: @openzeppelin/contracts/utils/Address.sol
400 
401 pragma solidity ^0.5.5;
402 
403 /**
404  * @dev Collection of functions related to the address type
405  */
406 library Address {
407     /**
408      * @dev Returns true if `account` is a contract.
409      *
410      * This test is non-exhaustive, and there may be false-negatives: during the
411      * execution of a contract's constructor, its address will be reported as
412      * not containing a contract.
413      *
414      * IMPORTANT: It is unsafe to assume that an address for which this
415      * function returns false is an externally-owned account (EOA) and not a
416      * contract.
417      */
418     function isContract(address account) internal view returns (bool) {
419         // This method relies in extcodesize, which returns 0 for contracts in
420         // construction, since the code is only stored at the end of the
421         // constructor execution.
422 
423         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
424         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
425         // for accounts without code, i.e. `keccak256('')`
426         bytes32 codehash;
427         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
428         // solhint-disable-next-line no-inline-assembly
429         assembly { codehash := extcodehash(account) }
430         return (codehash != 0x0 && codehash != accountHash);
431     }
432 
433     /**
434      * @dev Converts an `address` into `address payable`. Note that this is
435      * simply a type cast: the actual underlying value is not changed.
436      *
437      * _Available since v2.4.0._
438      */
439     function toPayable(address account) internal pure returns (address payable) {
440         return address(uint160(account));
441     }
442 
443     /**
444      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
445      * `recipient`, forwarding all available gas and reverting on errors.
446      *
447      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
448      * of certain opcodes, possibly making contracts go over the 2300 gas limit
449      * imposed by `transfer`, making them unable to receive funds via
450      * `transfer`. {sendValue} removes this limitation.
451      *
452      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
453      *
454      * IMPORTANT: because control is transferred to `recipient`, care must be
455      * taken to not create reentrancy vulnerabilities. Consider using
456      * {ReentrancyGuard} or the
457      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
458      *
459      * _Available since v2.4.0._
460      */
461     function sendValue(address payable recipient, uint256 amount) internal {
462         require(address(this).balance >= amount, "Address: insufficient balance");
463 
464         // solhint-disable-next-line avoid-call-value
465         (bool success, ) = recipient.call.value(amount)("");
466         require(success, "Address: unable to send value, recipient may have reverted");
467     }
468 }
469 
470 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
471 
472 pragma solidity ^0.5.0;
473 
474 
475 
476 
477 /**
478  * @title SafeERC20
479  * @dev Wrappers around ERC20 operations that throw on failure (when the token
480  * contract returns false). Tokens that return no value (and instead revert or
481  * throw on failure) are also supported, non-reverting calls are assumed to be
482  * successful.
483  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
484  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
485  */
486 library SafeERC20 {
487     using SafeMath for uint256;
488     using Address for address;
489 
490     function safeTransfer(IERC20 token, address to, uint256 value) internal {
491         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
492     }
493 
494     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
495         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
496     }
497 
498     function safeApprove(IERC20 token, address spender, uint256 value) internal {
499         // safeApprove should only be called when setting an initial allowance,
500         // or when resetting it to zero. To increase and decrease it, use
501         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
502         // solhint-disable-next-line max-line-length
503         require((value == 0) || (token.allowance(address(this), spender) == 0),
504             "SafeERC20: approve from non-zero to non-zero allowance"
505         );
506         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
507     }
508 
509     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
510         uint256 newAllowance = token.allowance(address(this), spender).add(value);
511         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
512     }
513 
514     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
515         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
516         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
517     }
518 
519     /**
520      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
521      * on the return value: the return value is optional (but if data is returned, it must not be false).
522      * @param token The token targeted by the call.
523      * @param data The call data (encoded using abi.encode or one of its variants).
524      */
525     function callOptionalReturn(IERC20 token, bytes memory data) private {
526         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
527         // we're implementing it ourselves.
528 
529         // A Solidity high level call has three parts:
530         //  1. The target address is checked to verify it contains contract code
531         //  2. The call itself is made, and success asserted
532         //  3. The return value is decoded, which in turn checks the size of the returned data.
533         // solhint-disable-next-line max-line-length
534         require(address(token).isContract(), "SafeERC20: call to non-contract");
535 
536         // solhint-disable-next-line avoid-low-level-calls
537         (bool success, bytes memory returndata) = address(token).call(data);
538         require(success, "SafeERC20: low-level call failed");
539 
540         if (returndata.length > 0) { // Return data is optional
541             // solhint-disable-next-line max-line-length
542             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
543         }
544     }
545 }
546 
547 // File: contracts/IRewardDistributionRecipient.sol
548 
549 pragma solidity ^0.5.0;
550 
551 
552 
553 contract IRewardDistributionRecipient is Ownable {
554     address rewardDistribution;
555 
556     function notifyRewardAmount(uint256 reward) external;
557 
558     modifier onlyRewardDistribution() {
559         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
560         _;
561     }
562 
563     function setRewardDistribution(address _rewardDistribution)
564         external
565         onlyOwner
566     {
567         rewardDistribution = _rewardDistribution;
568     }
569 }
570 
571 // File: contracts/CurveRewards.sol
572 
573 pragma solidity ^0.5.0;
574 
575 
576 
577 
578 
579 
580 contract StakeTokenWrapper {
581     using SafeMath for uint256;
582     using SafeERC20 for IERC20;
583 
584     IERC20 public stakeToken;
585 
586     uint256 private _totalSupply;
587     mapping(address => uint256) private _balances;
588 
589     constructor(address _stakeTokenAddress) public  {
590          stakeToken = IERC20(_stakeTokenAddress);
591     }
592     
593 
594     function totalSupply() public view returns (uint256) {
595         return _totalSupply;
596     }
597 
598     function balanceOf(address account) public view returns (uint256) {
599         return _balances[account];
600     }
601 
602     function stake(uint256 amount) public {
603         _totalSupply = _totalSupply.add(amount);
604         _balances[msg.sender] = _balances[msg.sender].add(amount);
605         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
606     }
607 
608     function withdraw(uint256 amount) public {
609         _totalSupply = _totalSupply.sub(amount);
610         _balances[msg.sender] = _balances[msg.sender].sub(amount);
611         stakeToken.safeTransfer(msg.sender, amount);
612     }
613 }
614 
615 contract DPRRewards is StakeTokenWrapper, IRewardDistributionRecipient {
616     IERC20 public rewardToken; 
617     uint256 public constant DURATION = 15 days;
618     uint256 public constant LOCK_PERIOD = 0; // LOCK_PERIOD <= DURATION
619 
620     uint256 public periodFinish = 0;
621     uint256 public rewardRate = 0;
622     uint256 public lastUpdateTime;
623     uint256 public rewardPerTokenStored;
624     mapping(address => uint256) public userRewardPerTokenPaid;
625     mapping(address => uint256) public rewards;
626     mapping(address => uint256) public withdrawTime;
627 
628     event RewardAdded(uint256 reward);
629     event Staked(address indexed user, uint256 amount);
630     event Withdrawn(address indexed user, uint256 amount);
631     event RewardPaid(address indexed user, uint256 reward);
632 
633     constructor(address _rewardTokenAddress, address _stakeTokenAddress) StakeTokenWrapper(_stakeTokenAddress) public {
634         rewardToken = IERC20(_rewardTokenAddress);
635     }
636 
637     modifier updateReward(address account) {
638         rewardPerTokenStored = rewardPerToken();
639         lastUpdateTime = lastTimeRewardApplicable();
640         if (account != address(0)) {
641             rewards[account] = earned(account);
642             userRewardPerTokenPaid[account] = rewardPerTokenStored;
643         }
644         _;
645     }
646 
647     function lockedUntil(address account) public view returns (uint256) {
648         return withdrawTime[account];
649     }
650 
651     function isUnlocked(address account) public view returns (bool) {
652         if (now >= withdrawTime[account]) {
653             return true;
654         }
655         return false;
656     }
657 
658     function lastTimeRewardApplicable() public view returns (uint256) {
659         return Math.min(block.timestamp, periodFinish);
660     }
661 
662     function rewardPerToken() public view returns (uint256) {
663         if (totalSupply() == 0) {
664             return rewardPerTokenStored;
665         }
666         return
667             rewardPerTokenStored.add(
668                 lastTimeRewardApplicable()
669                     .sub(lastUpdateTime)
670                     .mul(rewardRate)
671                     .mul(1e18)
672                     .div(totalSupply())
673             );
674     }
675 
676     function earned(address account) public view returns (uint256) {
677         return
678             balanceOf(account)
679                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
680                 .div(1e18)
681                 .add(rewards[account]);
682     }
683 
684     // stake visibility is public as overriding StakeTokenWrapper's stake() function
685     function stake(uint256 amount) public updateReward(msg.sender) {
686         require(amount > 0, "Cannot stake 0");
687         super.stake(amount);
688         uint256 canWithdrawTime  = now.add(LOCK_PERIOD);
689         if (canWithdrawTime > periodFinish) {
690             canWithdrawTime = periodFinish;
691         } 
692         withdrawTime[msg.sender] = canWithdrawTime;
693         emit Staked(msg.sender, amount);
694     }
695 
696     function withdraw(uint256 amount) public updateReward(msg.sender) {
697         require(amount > 0, "Cannot withdraw 0");
698         require(now >= withdrawTime[msg.sender], "Account still in lock");
699         super.withdraw(amount);  // no need to update withdrawTime here
700         emit Withdrawn(msg.sender, amount);
701     }
702 
703     function exit() external {
704         withdraw(balanceOf(msg.sender));
705         getReward();
706     }
707 
708     function getReward() public updateReward(msg.sender) {
709         uint256 reward = earned(msg.sender);
710         if (reward > 0) {
711             rewards[msg.sender] = 0;
712             rewardToken.safeTransfer(msg.sender, reward);
713             emit RewardPaid(msg.sender, reward);
714         }
715     }
716 
717     function notifyRewardAmount(uint256 reward)
718         external
719         onlyRewardDistribution
720         updateReward(address(0))
721     {
722         if (block.timestamp >= periodFinish) {
723             rewardRate = reward.div(DURATION);
724         } else {
725             uint256 remaining = periodFinish.sub(block.timestamp);
726             uint256 leftover = remaining.mul(rewardRate);
727             rewardRate = reward.add(leftover).div(DURATION);
728         }
729         lastUpdateTime = block.timestamp;
730         periodFinish = block.timestamp.add(DURATION);
731         emit RewardAdded(reward);
732     }
733 }