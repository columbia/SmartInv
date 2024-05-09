1 pragma solidity ^0.5.0;
2 pragma solidity ^0.5.0;
3 pragma solidity ^0.5.0;
4 pragma solidity ^0.5.0;
5 pragma solidity ^0.5.0;
6 pragma solidity ^0.5.5;
7 pragma solidity ^0.5.0;
8 pragma solidity ^0.5.0;
9 pragma solidity ^0.5.0;
10 
11 
12 /**
13  *Submitted for verification at Etherscan.io on 2020-07-17
14 */
15 /*
16    ____            __   __        __   _
17   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
18  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
19 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
20      /___/
21 
22 * Synthetix: YFIRewards.sol
23 *
24 * Docs: https://docs.synthetix.io/
25 *
26 *
27 * MIT License
28 * ===========
29 *
30 * Copyright (c) 2020 Synthetix
31 *
32 * Permission is hereby granted, free of charge, to any person obtaining a copy
33 * of this software and associated documentation files (the "Software"), to deal
34 * in the Software without restriction, including without limitation the rights
35 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
36 * copies of the Software, and to permit persons to whom the Software is
37 * furnished to do so, subject to the following conditions:
38 *
39 * The above copyright notice and this permission notice shall be included in all
40 * copies or substantial portions of the Software.
41 *
42 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
43 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
44 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
45 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
46 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
47 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
48 */
49 // File: @openzeppelin/contracts/math/Math.sol
50 /**
51  * @dev Standard math utilities missing in the Solidity language.
52  */
53 library Math {
54     /**
55      * @dev Returns the largest of two numbers.
56      */
57     function max(uint256 a, uint256 b) internal pure returns (uint256) {
58         return a >= b ? a : b;
59     }
60 
61     /**
62      * @dev Returns the smallest of two numbers.
63      */
64     function min(uint256 a, uint256 b) internal pure returns (uint256) {
65         return a < b ? a : b;
66     }
67 
68     /**
69      * @dev Returns the average of two numbers. The result is rounded towards
70      * zero.
71      */
72     function average(uint256 a, uint256 b) internal pure returns (uint256) {
73         // (a + b) / 2 can overflow, so we distribute
74         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
75     }
76 }
77 
78 // File: @openzeppelin/contracts/math/SafeMath.sol
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return sub(a, b, "SafeMath: subtraction overflow");
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      * - Subtraction cannot overflow.
130      *
131      * _Available since v2.4.0._
132      */
133     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
147      * - Multiplication cannot overflow.
148      */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151         // benefit is lost if 'b' is also tested.
152         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
153         if (a == 0) {
154             return 0;
155         }
156 
157         uint256 c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers. Reverts on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator. Note: this function uses a
168      * `revert` opcode (which leaves remaining gas untouched) while Solidity
169      * uses an invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      * - The divisor cannot be zero.
173      */
174     function div(uint256 a, uint256 b) internal pure returns (uint256) {
175         return div(a, b, "SafeMath: division by zero");
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      * - The divisor cannot be zero.
188      *
189      * _Available since v2.4.0._
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         // Solidity only automatically asserts when dividing by 0
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212         return mod(a, b, "SafeMath: modulo by zero");
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts with custom message when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      * - The divisor cannot be zero.
225      *
226      * _Available since v2.4.0._
227      */
228     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b != 0, errorMessage);
230         return a % b;
231     }
232 }
233 
234 // File: @openzeppelin/contracts/GSN/Context.sol
235 /*
236  * @dev Provides information about the current execution context, including the
237  * sender of the transaction and its data. While these are generally available
238  * via msg.sender and msg.data, they should not be accessed in such a direct
239  * manner, since when dealing with GSN meta-transactions the account sending and
240  * paying for execution may not be the actual sender (as far as an application
241  * is concerned).
242  *
243  * This contract is only required for intermediate, library-like contracts.
244  */
245 contract Context {
246     // Empty internal constructor, to prevent people from mistakenly deploying
247     // an instance of this contract, which should be used via inheritance.
248     constructor () internal { }
249     // solhint-disable-previous-line no-empty-blocks
250 
251     function _msgSender() internal view returns (address payable) {
252         return msg.sender;
253     }
254 
255     function _msgData() internal view returns (bytes memory) {
256         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
257         return msg.data;
258     }
259 }
260 
261 // File: @openzeppelin/contracts/ownership/Ownable.sol
262 /**
263  * @dev Contract module which provides a basic access control mechanism, where
264  * there is an account (an owner) that can be granted exclusive access to
265  * specific functions.
266  *
267  * This module is used through inheritance. It will make available the modifier
268  * `onlyOwner`, which can be applied to your functions to restrict their use to
269  * the owner.
270  */
271 contract Ownable is Context {
272     address private _owner;
273 
274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
275 
276     /**
277      * @dev Initializes the contract setting the deployer as the initial owner.
278      */
279     constructor () internal {
280         _owner = _msgSender();
281         emit OwnershipTransferred(address(0), _owner);
282     }
283 
284     /**
285      * @dev Returns the address of the current owner.
286      */
287     function owner() public view returns (address) {
288         return _owner;
289     }
290 
291     /**
292      * @dev Throws if called by any account other than the owner.
293      */
294     modifier onlyOwner() {
295         require(isOwner(), "Ownable: caller is not the owner");
296         _;
297     }
298 
299     /**
300      * @dev Returns true if the caller is the current owner.
301      */
302     function isOwner() public view returns (bool) {
303         return _msgSender() == _owner;
304     }
305 
306     /**
307      * @dev Leaves the contract without owner. It will not be possible to call
308      * `onlyOwner` functions anymore. Can only be called by the current owner.
309      *
310      * NOTE: Renouncing ownership will leave the contract without an owner,
311      * thereby removing any functionality that is only available to the owner.
312      */
313     function renounceOwnership() public onlyOwner {
314         emit OwnershipTransferred(_owner, address(0));
315         _owner = address(0);
316     }
317 
318     /**
319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
320      * Can only be called by the current owner.
321      */
322     function transferOwnership(address newOwner) public onlyOwner {
323         _transferOwnership(newOwner);
324     }
325 
326     /**
327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
328      */
329     function _transferOwnership(address newOwner) internal {
330         require(newOwner != address(0), "Ownable: new owner is the zero address");
331         emit OwnershipTransferred(_owner, newOwner);
332         _owner = newOwner;
333     }
334 }
335 
336 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
337 /**
338  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
339  * the optional functions; to access them see {ERC20Detailed}.
340  */
341 interface IERC20 {
342     /**
343      * @dev Returns the amount of tokens in existence.
344      */
345     function totalSupply() external view returns (uint256);
346 
347     /**
348      * @dev Returns the amount of tokens owned by `account`.
349      */
350     function balanceOf(address account) external view returns (uint256);
351 
352     /**
353      * @dev Moves `amount` tokens from the caller's account to `recipient`.
354      *
355      * Returns a boolean value indicating whether the operation succeeded.
356      *
357      * Emits a {Transfer} event.
358      */
359     function transfer(address recipient, uint256 amount) external returns (bool);
360 
361     /**
362      * @dev Returns the remaining number of tokens that `spender` will be
363      * allowed to spend on behalf of `owner` through {transferFrom}. This is
364      * zero by default.
365      *
366      * This value changes when {approve} or {transferFrom} are called.
367      */
368     function allowance(address owner, address spender) external view returns (uint256);
369 
370     /**
371      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
372      *
373      * Returns a boolean value indicating whether the operation succeeded.
374      *
375      * IMPORTANT: Beware that changing an allowance with this method brings the risk
376      * that someone may use both the old and the new allowance by unfortunate
377      * transaction ordering. One possible solution to mitigate this race
378      * condition is to first reduce the spender's allowance to 0 and set the
379      * desired value afterwards:
380      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
381      *
382      * Emits an {Approval} event.
383      */
384     function approve(address spender, uint256 amount) external returns (bool);
385 
386     /**
387      * @dev Moves `amount` tokens from `sender` to `recipient` using the
388      * allowance mechanism. `amount` is then deducted from the caller's
389      * allowance.
390      *
391      * Returns a boolean value indicating whether the operation succeeded.
392      *
393      * Emits a {Transfer} event.
394      */
395     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
396 
397     /**
398      * @dev Emitted when `value` tokens are moved from one account (`from`) to
399      * another (`to`).
400      *
401      * Note that `value` may be zero.
402      */
403     event Transfer(address indexed from, address indexed to, uint256 value);
404 
405     /**
406      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
407      * a call to {approve}. `value` is the new allowance.
408      */
409     event Approval(address indexed owner, address indexed spender, uint256 value);
410 }
411 
412 // File: @openzeppelin/contracts/utils/Address.sol
413 /**
414  * @dev Collection of functions related to the address type
415  */
416 library Address {
417     /**
418      * @dev Returns true if `account` is a contract.
419      *
420      * This test is non-exhaustive, and there may be false-negatives: during the
421      * execution of a contract's constructor, its address will be reported as
422      * not containing a contract.
423      *
424      * IMPORTANT: It is unsafe to assume that an address for which this
425      * function returns false is an externally-owned account (EOA) and not a
426      * contract.
427      */
428     function isContract(address account) internal view returns (bool) {
429         // This method relies in extcodesize, which returns 0 for contracts in
430         // construction, since the code is only stored at the end of the
431         // constructor execution.
432 
433         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
434         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
435         // for accounts without code, i.e. `keccak256('')`
436         bytes32 codehash;
437         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
438         // solhint-disable-next-line no-inline-assembly
439         assembly { codehash := extcodehash(account) }
440         return (codehash != 0x0 && codehash != accountHash);
441     }
442 
443     /**
444      * @dev Converts an `address` into `address payable`. Note that this is
445      * simply a type cast: the actual underlying value is not changed.
446      *
447      * _Available since v2.4.0._
448      */
449     function toPayable(address account) internal pure returns (address payable) {
450         return address(uint160(account));
451     }
452 
453     /**
454      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
455      * `recipient`, forwarding all available gas and reverting on errors.
456      *
457      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
458      * of certain opcodes, possibly making contracts go over the 2300 gas limit
459      * imposed by `transfer`, making them unable to receive funds via
460      * `transfer`. {sendValue} removes this limitation.
461      *
462      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
463      *
464      * IMPORTANT: because control is transferred to `recipient`, care must be
465      * taken to not create reentrancy vulnerabilities. Consider using
466      * {ReentrancyGuard} or the
467      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
468      *
469      * _Available since v2.4.0._
470      */
471     function sendValue(address payable recipient, uint256 amount) internal {
472         require(address(this).balance >= amount, "Address: insufficient balance");
473 
474         // solhint-disable-next-line avoid-call-value
475         (bool success, ) = recipient.call.value(amount)("");
476         require(success, "Address: unable to send value, recipient may have reverted");
477     }
478 }
479 
480 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
481 /**
482  * @title SafeERC20
483  * @dev Wrappers around ERC20 operations that throw on failure (when the token
484  * contract returns false). Tokens that return no value (and instead revert or
485  * throw on failure) are also supported, non-reverting calls are assumed to be
486  * successful.
487  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
488  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
489  */
490 library SafeERC20 {
491     using SafeMath for uint256;
492     using Address for address;
493 
494     function safeTransfer(IERC20 token, address to, uint256 value) internal {
495         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
496     }
497 
498     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
499         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
500     }
501 
502     function safeApprove(IERC20 token, address spender, uint256 value) internal {
503         // safeApprove should only be called when setting an initial allowance,
504         // or when resetting it to zero. To increase and decrease it, use
505         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
506         // solhint-disable-next-line max-line-length
507         require((value == 0) || (token.allowance(address(this), spender) == 0),
508             "SafeERC20: approve from non-zero to non-zero allowance"
509         );
510         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
511     }
512 
513     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
514         uint256 newAllowance = token.allowance(address(this), spender).add(value);
515         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
516     }
517 
518     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
519         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
520         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
521     }
522 
523     /**
524      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
525      * on the return value: the return value is optional (but if data is returned, it must not be false).
526      * @param token The token targeted by the call.
527      * @param data The call data (encoded using abi.encode or one of its variants).
528      */
529     function callOptionalReturn(IERC20 token, bytes memory data) private {
530         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
531         // we're implementing it ourselves.
532 
533         // A Solidity high level call has three parts:
534         //  1. The target address is checked to verify it contains contract code
535         //  2. The call itself is made, and success asserted
536         //  3. The return value is decoded, which in turn checks the size of the returned data.
537         // solhint-disable-next-line max-line-length
538         require(address(token).isContract(), "SafeERC20: call to non-contract");
539 
540         // solhint-disable-next-line avoid-low-level-calls
541         (bool success, bytes memory returndata) = address(token).call(data);
542         require(success, "SafeERC20: low-level call failed");
543 
544         if (returndata.length > 0) { // Return data is optional
545             // solhint-disable-next-line max-line-length
546             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
547         }
548     }
549 }
550 
551 // File: contracts/IRewardDistributionRecipient.sol
552 contract IRewardDistributionRecipient is Ownable {
553     address rewardDistribution;
554 
555     function notifyRewardAmount(uint256 reward) external;
556 
557     modifier onlyRewardDistribution() {
558         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
559         _;
560     }
561 
562     function setRewardDistribution(address _rewardDistribution)
563         external
564         onlyOwner
565     {
566         rewardDistribution = _rewardDistribution;
567     }
568 }
569 
570 // File: contracts/CurveRewards.sol
571 contract LPTokenWrapper {
572     using SafeMath for uint256;
573     using SafeERC20 for IERC20;
574     using Address for address;
575 
576     IERC20 public bpt = IERC20(0x81D258af4f640021a73ceA2A45849D4DfB3222eC);
577 
578     uint256 private _totalSupply;
579     mapping(address => uint256) private _balances;
580 
581     function totalSupply() public view returns (uint256) {
582         return _totalSupply;
583     }
584 
585     function balanceOf(address account) public view returns (uint256) {
586         return _balances[account];
587     }
588 
589     function stake(uint256 amount) public {
590         address sender = msg.sender;
591         require(!address(sender).isContract(), "Andre, we are farming in peace, go harvest somewhere else sir.");
592         require(tx.origin == msg.sender, "Andre, stahp.");
593         _totalSupply = _totalSupply.add(amount);
594         _balances[msg.sender] = _balances[msg.sender].add(amount);
595         bpt.safeTransferFrom(msg.sender, address(this), amount);
596     }
597 
598     function withdraw(uint256 amount) public {
599         _totalSupply = _totalSupply.sub(amount);
600         _balances[msg.sender] = _balances[msg.sender].sub(amount);
601         bpt.safeTransfer(msg.sender, amount);
602     }
603 }
604 
605 contract YFTyCRVYearnRewards is LPTokenWrapper, IRewardDistributionRecipient {
606     IERC20 public yft = IERC20(0x26B3038a7Fc10b36c426846a9086Ef87328dA702);
607     uint256 public constant DURATION = 14 days;
608 
609     uint256 public periodFinish = 0;
610     uint256 public rewardRate = 0;
611     uint256 public lastUpdateTime;
612     uint256 public rewardPerTokenStored;
613     mapping(address => uint256) public userRewardPerTokenPaid;
614     mapping(address => uint256) public rewards;
615 
616     event RewardAdded(uint256 reward);
617     event Staked(address indexed user, uint256 amount);
618     event Withdrawn(address indexed user, uint256 amount);
619     event RewardPaid(address indexed user, uint256 reward);
620 
621     modifier updateReward(address account) {
622         rewardPerTokenStored = rewardPerToken();
623         lastUpdateTime = lastTimeRewardApplicable();
624         if (account != address(0)) {
625             rewards[account] = earned(account);
626             userRewardPerTokenPaid[account] = rewardPerTokenStored;
627         }
628         _;
629     }
630 
631     function lastTimeRewardApplicable() public view returns (uint256) {
632         return Math.min(block.timestamp, periodFinish);
633     }
634 
635     function rewardPerToken() public view returns (uint256) {
636         if (totalSupply() == 0) {
637             return rewardPerTokenStored;
638         }
639         return
640             rewardPerTokenStored.add(
641                 lastTimeRewardApplicable()
642                     .sub(lastUpdateTime)
643                     .mul(rewardRate)
644                     .mul(1e18)
645                     .div(totalSupply())
646             );
647     }
648 
649     function earned(address account) public view returns (uint256) {
650         return
651             balanceOf(account)
652                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
653                 .div(1e18)
654                 .add(rewards[account]);
655     }
656 
657     // stake visibility is public as overriding LPTokenWrapper's stake() function
658     function stake(uint256 amount) public updateReward(msg.sender) {
659         require(amount > 0, "Cannot stake 0");
660         super.stake(amount);
661         emit Staked(msg.sender, amount);
662     }
663 
664     function withdraw(uint256 amount) public updateReward(msg.sender) {
665         require(amount > 0, "Cannot withdraw 0");
666         super.withdraw(amount);
667         emit Withdrawn(msg.sender, amount);
668     }
669 
670     function exit() external {
671         withdraw(balanceOf(msg.sender));
672         getReward();
673     }
674 
675     function getReward() public updateReward(msg.sender) {
676         uint256 reward = earned(msg.sender);
677         if (reward > 0) {
678             rewards[msg.sender] = 0;
679             yft.safeTransfer(msg.sender, reward);
680             emit RewardPaid(msg.sender, reward);
681         }
682     }
683 
684     function notifyRewardAmount(uint256 reward)
685         external
686         onlyRewardDistribution
687         updateReward(address(0))
688     {
689         if (block.timestamp >= periodFinish) {
690             rewardRate = reward.div(DURATION);
691         } else {
692             uint256 remaining = periodFinish.sub(block.timestamp);
693             uint256 leftover = remaining.mul(rewardRate);
694             rewardRate = reward.add(leftover).div(DURATION);
695         }
696         lastUpdateTime = block.timestamp;
697         periodFinish = block.timestamp.add(DURATION);
698         emit RewardAdded(reward);
699     }
700 }