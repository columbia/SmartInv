1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-17
3 */
4 
5 /*
6    ____            __   __        __   _
7   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
8  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
9 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
10      /___/
11 
12 * Synthetix: VELORewards.sol
13 *
14 * Docs: https://docs.synthetix.io/
15 *
16 *
17 * MIT License
18 * ===========
19 *
20 * Copyright (c) 2020 Synthetix
21 *
22 * Permission is hereby granted, free of charge, to any person obtaining a copy
23 * of this software and associated documentation files (the "Software"), to deal
24 * in the Software without restriction, including without limitation the rights
25 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
26 * copies of the Software, and to permit persons to whom the Software is
27 * furnished to do so, subject to the following conditions:
28 *
29 * The above copyright notice and this permission notice shall be included in all
30 * copies or substantial portions of the Software.
31 *
32 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
33 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
34 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
35 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
36 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
37 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
38 */
39 
40 // File: @openzeppelin/contracts/math/Math.sol
41 
42 pragma solidity ^0.5.0;
43 
44 /**
45  * @dev Standard math utilities missing in the Solidity language.
46  */
47 library Math {
48     /**
49      * @dev Returns the largest of two numbers.
50      */
51     function max(uint256 a, uint256 b) internal pure returns (uint256) {
52         return a >= b ? a : b;
53     }
54 
55     /**
56      * @dev Returns the smallest of two numbers.
57      */
58     function min(uint256 a, uint256 b) internal pure returns (uint256) {
59         return a < b ? a : b;
60     }
61 
62     /**
63      * @dev Returns the average of two numbers. The result is rounded towards
64      * zero.
65      */
66     function average(uint256 a, uint256 b) internal pure returns (uint256) {
67         // (a + b) / 2 can overflow, so we distribute
68         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/math/SafeMath.sol
73 
74 pragma solidity ^0.5.0;
75 
76 /**
77  * @dev Wrappers over Solidity's arithmetic operations with added overflow
78  * checks.
79  *
80  * Arithmetic operations in Solidity wrap on overflow. This can easily result
81  * in bugs, because programmers usually assume that an overflow raises an
82  * error, which is the standard behavior in high level programming languages.
83  * `SafeMath` restores this intuition by reverting the transaction when an
84  * operation overflows.
85  *
86  * Using this library instead of the unchecked operations eliminates an entire
87  * class of bugs, so it's recommended to use it always.
88  */
89 library SafeMath {
90     /**
91      * @dev Returns the addition of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `+` operator.
95      *
96      * Requirements:
97      * - Addition cannot overflow.
98      */
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a + b;
101         require(c >= a, "SafeMath: addition overflow");
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the subtraction of two unsigned integers, reverting on
108      * overflow (when the result is negative).
109      *
110      * Counterpart to Solidity's `-` operator.
111      *
112      * Requirements:
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return sub(a, b, "SafeMath: subtraction overflow");
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      * - Subtraction cannot overflow.
127      *
128      * _Available since v2.4.0._
129      */
130     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131         require(b <= a, errorMessage);
132         uint256 c = a - b;
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the multiplication of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `*` operator.
142      *
143      * Requirements:
144      * - Multiplication cannot overflow.
145      */
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) {
151             return 0;
152         }
153 
154         uint256 c = a * b;
155         require(c / a == b, "SafeMath: multiplication overflow");
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the integer division of two unsigned integers. Reverts on
162      * division by zero. The result is rounded towards zero.
163      *
164      * Counterpart to Solidity's `/` operator. Note: this function uses a
165      * `revert` opcode (which leaves remaining gas untouched) while Solidity
166      * uses an invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      * - The divisor cannot be zero.
170      */
171     function div(uint256 a, uint256 b) internal pure returns (uint256) {
172         return div(a, b, "SafeMath: division by zero");
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
177      * division by zero. The result is rounded towards zero.
178      *
179      * Counterpart to Solidity's `/` operator. Note: this function uses a
180      * `revert` opcode (which leaves remaining gas untouched) while Solidity
181      * uses an invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      * - The divisor cannot be zero.
185      *
186      * _Available since v2.4.0._
187      */
188     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         // Solidity only automatically asserts when dividing by 0
190         require(b > 0, errorMessage);
191         uint256 c = a / b;
192         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * Reverts when dividing by zero.
200      *
201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
202      * opcode (which leaves remaining gas untouched) while Solidity uses an
203      * invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      * - The divisor cannot be zero.
207      */
208     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209         return mod(a, b, "SafeMath: modulo by zero");
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts with custom message when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      * - The divisor cannot be zero.
222      *
223      * _Available since v2.4.0._
224      */
225     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b != 0, errorMessage);
227         return a % b;
228     }
229 }
230 
231 // File: @openzeppelin/contracts/GSN/Context.sol
232 
233 pragma solidity ^0.5.0;
234 
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
262 
263 pragma solidity ^0.5.0;
264 
265 /**
266  * @dev Contract module which provides a basic access control mechanism, where
267  * there is an account (an owner) that can be granted exclusive access to
268  * specific functions.
269  *
270  * This module is used through inheritance. It will make available the modifier
271  * `onlyOwner`, which can be applied to your functions to restrict their use to
272  * the owner.
273  */
274 contract Ownable is Context {
275     address private _owner;
276 
277     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
278 
279     /**
280      * @dev Initializes the contract setting the deployer as the initial owner.
281      */
282     constructor () internal {
283         _owner = _msgSender();
284         emit OwnershipTransferred(address(0), _owner);
285     }
286 
287     /**
288      * @dev Returns the address of the current owner.
289      */
290     function owner() public view returns (address) {
291         return _owner;
292     }
293 
294     /**
295      * @dev Throws if called by any account other than the owner.
296      */
297     modifier onlyOwner() {
298         require(isOwner(), "Ownable: caller is not the owner");
299         _;
300     }
301 
302     /**
303      * @dev Returns true if the caller is the current owner.
304      */
305     function isOwner() public view returns (bool) {
306         return _msgSender() == _owner;
307     }
308 
309     /**
310      * @dev Leaves the contract without owner. It will not be possible to call
311      * `onlyOwner` functions anymore. Can only be called by the current owner.
312      *
313      * NOTE: Renouncing ownership will leave the contract without an owner,
314      * thereby removing any functionality that is only available to the owner.
315      */
316     function renounceOwnership() public onlyOwner {
317         emit OwnershipTransferred(_owner, address(0));
318         _owner = address(0);
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Can only be called by the current owner.
324      */
325     function transferOwnership(address newOwner) public onlyOwner {
326         _transferOwnership(newOwner);
327     }
328 
329     /**
330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
331      */
332     function _transferOwnership(address newOwner) internal {
333         require(newOwner != address(0), "Ownable: new owner is the zero address");
334         emit OwnershipTransferred(_owner, newOwner);
335         _owner = newOwner;
336     }
337 }
338 
339 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
340 
341 pragma solidity ^0.5.0;
342 
343 /**
344  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
345  * the optional functions; to access them see \{ERC20Detailed}.
346  */
347 interface IERC20 {
348     /**
349      * @dev Returns the amount of tokens in existence.
350      */
351     function totalSupply() external view returns (uint256);
352 
353     /**
354      * @dev Returns the amount of tokens owned by `account`.
355      */
356     function balanceOf(address account) external view returns (uint256);
357 
358     /**
359      * @dev Moves `amount` tokens from the caller's account to `recipient`.
360      *
361      * Returns a boolean value indicating whether the operation succeeded.
362      *
363      * Emits a \{Transfer} event.
364      */
365     function transfer(address recipient, uint256 amount) external returns (bool);
366 
367     /**
368      * @dev Returns the remaining number of tokens that `spender` will be
369      * allowed to spend on behalf of `owner` through \{transferFrom}. This is
370      * zero by default.
371      *
372      * This value changes when \{approve} or \{transferFrom} are called.
373      */
374     function allowance(address owner, address spender) external view returns (uint256);
375 
376     /**
377      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
378      *
379      * Returns a boolean value indicating whether the operation succeeded.
380      *
381      * IMPORTANT: Beware that changing an allowance with this method brings the risk
382      * that someone may use both the old and the new allowance by unfortunate
383      * transaction ordering. One possible solution to mitigate this race
384      * condition is to first reduce the spender's allowance to 0 and set the
385      * desired value afterwards:
386      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
387      *
388      * Emits an \{Approval} event.
389      */
390     function approve(address spender, uint256 amount) external returns (bool);
391 
392     /**
393      * @dev Moves `amount` tokens from `sender` to `recipient` using the
394      * allowance mechanism. `amount` is then deducted from the caller's
395      * allowance.
396      *
397      * Returns a boolean value indicating whether the operation succeeded.
398      *
399      * Emits a \{Transfer} event.
400      */
401     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
402 
403     /**
404      * @dev Emitted when `value` tokens are moved from one account (`from`) to
405      * another (`to`).
406      *
407      * Note that `value` may be zero.
408      */
409     event Transfer(address indexed from, address indexed to, uint256 value);
410 
411     /**
412      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
413      * a call to \{approve}. `value` is the new allowance.
414      */
415     event Approval(address indexed owner, address indexed spender, uint256 value);
416 }
417 
418 // File: @openzeppelin/contracts/utils/Address.sol
419 
420 pragma solidity ^0.5.5;
421 
422 /**
423  * @dev Collection of functions related to the address type
424  */
425 library Address {
426     /**
427      * @dev Returns true if `account` is a contract.
428      *
429      * This test is non-exhaustive, and there may be false-negatives: during the
430      * execution of a contract's constructor, its address will be reported as
431      * not containing a contract.
432      *
433      * IMPORTANT: It is unsafe to assume that an address for which this
434      * function returns false is an externally-owned account (EOA) and not a
435      * contract.
436      */
437     function isContract(address account) internal view returns (bool) {
438         // This method relies in extcodesize, which returns 0 for contracts in
439         // construction, since the code is only stored at the end of the
440         // constructor execution.
441 
442         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
443         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
444         // for accounts without code, i.e. `keccak256('')`
445         bytes32 codehash;
446         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
447         // solhint-disable-next-line no-inline-assembly
448         assembly { codehash := extcodehash(account) }
449         return (codehash != 0x0 && codehash != accountHash);
450     }
451 
452     /**
453      * @dev Converts an `address` into `address payable`. Note that this is
454      * simply a type cast: the actual underlying value is not changed.
455      *
456      * _Available since v2.4.0._
457      */
458     function toPayable(address account) internal pure returns (address payable) {
459         return address(uint160(account));
460     }
461 
462     /**
463      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
464      * `recipient`, forwarding all available gas and reverting on errors.
465      *
466      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
467      * of certain opcodes, possibly making contracts go over the 2300 gas limit
468      * imposed by `transfer`, making them unable to receive funds via
469      * `transfer`. \{sendValue} removes this limitation.
470      *
471      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
472      *
473      * IMPORTANT: because control is transferred to `recipient`, care must be
474      * taken to not create reentrancy vulnerabilities. Consider using
475      * 
476      * \{ReentrancyGuard} or the
477      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
478      *
479      * _Available since v2.4.0._
480      */
481     function sendValue(address payable recipient, uint256 amount) internal {
482         require(address(this).balance >= amount, "Address: insufficient balance");
483 
484         // solhint-disable-next-line avoid-call-value
485         (bool success, ) = recipient.call.value(amount)("");
486         require(success, "Address: unable to send value, recipient may have reverted");
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
491 
492 pragma solidity ^0.5.0;
493 
494 
495 
496 
497 /**
498  * @title SafeERC20
499  * @dev Wrappers around ERC20 operations that throw on failure (when the token
500  * contract returns false). Tokens that return no value (and instead revert or
501  * throw on failure) are also supported, non-reverting calls are assumed to be
502  * successful.
503  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
504  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
505  */
506 library SafeERC20 {
507     using SafeMath for uint256;
508     using Address for address;
509 
510     function safeTransfer(IERC20 token, address to, uint256 value) internal {
511         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
512     }
513 
514     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
515         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
516     }
517 
518     function safeApprove(IERC20 token, address spender, uint256 value) internal {
519         // safeApprove should only be called when setting an initial allowance,
520         // or when resetting it to zero. To increase and decrease it, use
521         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
522         // solhint-disable-next-line max-line-length
523         require((value == 0) || (token.allowance(address(this), spender) == 0),
524             "SafeERC20: approve from non-zero to non-zero allowance"
525         );
526         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
527     }
528 
529     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
530         uint256 newAllowance = token.allowance(address(this), spender).add(value);
531         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
532     }
533 
534     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
535         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
536         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
537     }
538 
539     /**
540      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
541      * on the return value: the return value is optional (but if data is returned, it must not be false).
542      * @param token The token targeted by the call.
543      * @param data The call data (encoded using abi.encode or one of its variants).
544      */
545     function callOptionalReturn(IERC20 token, bytes memory data) private {
546         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
547         // we're implementing it ourselves.
548 
549         // A Solidity high level call has three parts:
550         //  1. The target address is checked to verify it contains contract code
551         //  2. The call itself is made, and success asserted
552         //  3. The return value is decoded, which in turn checks the size of the returned data.
553         // solhint-disable-next-line max-line-length
554         require(address(token).isContract(), "SafeERC20: call to non-contract");
555 
556         // solhint-disable-next-line avoid-low-level-calls
557         (bool success, bytes memory returndata) = address(token).call(data);
558         require(success, "SafeERC20: low-level call failed");
559 
560         if (returndata.length > 0) { // Return data is optional
561             // solhint-disable-next-line max-line-length
562             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
563         }
564     }
565 }
566 
567 // File: contracts/IRewardDistributionRecipient.sol
568 
569 pragma solidity ^0.5.0;
570 
571 
572 
573 contract IRewardDistributionRecipient is Ownable {
574     address public rewardDistribution;
575 
576     function notifyRewardAmount(uint256 reward) external;
577 
578     modifier onlyRewardDistribution() {
579         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
580         _;
581     }
582 
583     function setRewardDistribution(address _rewardDistribution)
584         external
585         onlyOwner
586     {
587         rewardDistribution = _rewardDistribution;
588     }
589 }
590 
591 // File: contracts/CurveRewards.sol
592 
593 pragma solidity ^0.5.0;
594 
595 
596 
597 interface VELO {
598     function velosScalingFactor() external returns (uint256);
599 }
600 
601 
602 contract LPTokenWrapper {
603     using SafeMath for uint256;
604     using SafeERC20 for IERC20;
605 
606     IERC20 public erc20_token;
607 
608     uint256 private _totalSupply;
609     mapping(address => uint256) private _balances;
610 
611     constructor(address _erc20_token_address) public {
612       erc20_token = IERC20(_erc20_token_address);
613     }
614 
615     function totalSupply() public view returns (uint256) {
616         return _totalSupply;
617     }
618 
619     function balanceOf(address account) public view returns (uint256) {
620         return _balances[account];
621     }
622 
623     function stake(uint256 amount) public {
624         _totalSupply = _totalSupply.add(amount);
625         _balances[msg.sender] = _balances[msg.sender].add(amount);
626         erc20_token.safeTransferFrom(msg.sender, address(this), amount);
627     }
628 
629     function withdraw(uint256 amount) public {
630         _totalSupply = _totalSupply.sub(amount);
631         _balances[msg.sender] = _balances[msg.sender].sub(amount);
632         erc20_token.safeTransfer(msg.sender, amount);
633     }
634 }
635 
636 contract VELOStakingPool is LPTokenWrapper, IRewardDistributionRecipient {
637     IERC20 public velo;
638     uint256 public duration; 
639 
640     uint256 public starttime; 
641     uint256 public periodFinish = 0;
642     uint256 public rewardRate = 0;
643     uint256 public lastUpdateTime;
644     uint256 public rewardPerTokenStored;
645     mapping(address => uint256) public userRewardPerTokenPaid;
646     mapping(address => uint256) public rewards;
647 
648     event RewardAdded(uint256 reward);
649     event Staked(address indexed user, uint256 amount);
650     event Withdrawn(address indexed user, uint256 amount);
651     event RewardPaid(address indexed user, uint256 reward);
652 
653 
654     constructor(address _velo, 
655 		address _erc20_token_address,
656 		uint256 _starttime,
657 		uint256 _duration) public 
658     LPTokenWrapper(_erc20_token_address)
659     {
660       velo = IERC20(_velo);
661       starttime = _starttime;
662       duration = _duration;
663     }
664 
665     modifier checkStart() {
666         require(block.timestamp >= starttime,"not start");
667         _;
668     }
669 
670     modifier updateReward(address account) {
671         rewardPerTokenStored = rewardPerToken();
672         lastUpdateTime = lastTimeRewardApplicable();
673         if (account != address(0)) {
674             rewards[account] = earned(account);
675             userRewardPerTokenPaid[account] = rewardPerTokenStored;
676         }
677         _;
678     }
679 
680 
681     function lastTimeRewardApplicable() public view returns (uint256) {
682         return Math.min(block.timestamp, periodFinish);
683     }
684 
685     function rewardPerToken() public view returns (uint256) {
686         if (totalSupply() == 0) {
687             return rewardPerTokenStored;
688         }
689         return
690             rewardPerTokenStored.add(
691                 lastTimeRewardApplicable()
692                     .sub(lastUpdateTime)
693                     .mul(rewardRate)
694                     .mul(1e18)
695                     .div(totalSupply())
696             );
697     }
698 
699     function earned(address account) public view returns (uint256) {
700         return
701             balanceOf(account)
702                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
703                 .div(1e18)
704                 .add(rewards[account]);
705     }
706 
707     // stake visibility is public as overriding LPTokenWrapper's stake() function
708     function stake(uint256 amount) public updateReward(msg.sender) checkStart {
709         require(amount > 0, "Cannot stake 0");
710         super.stake(amount);
711         emit Staked(msg.sender, amount);
712     }
713 
714     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {
715         require(amount > 0, "Cannot withdraw 0");
716         super.withdraw(amount);
717         emit Withdrawn(msg.sender, amount);
718     }
719 
720     function exit() external {
721         withdraw(balanceOf(msg.sender));
722         getReward();
723     }
724 
725     function getReward() public updateReward(msg.sender) checkStart {
726         uint256 reward = earned(msg.sender);
727         if (reward > 0) {
728             rewards[msg.sender] = 0;
729             uint256 scalingFactor = VELO(address(velo)).velosScalingFactor();
730             uint256 trueReward = reward.mul(scalingFactor).div(10**18);
731             velo.safeTransfer(msg.sender, trueReward);
732             emit RewardPaid(msg.sender, trueReward);
733         }
734     }
735 
736     function notifyRewardAmount(uint256 reward)
737         external
738         onlyRewardDistribution
739         updateReward(address(0))
740     {
741         if (block.timestamp > starttime) {
742           if (block.timestamp >= periodFinish) {
743               rewardRate = reward.div(duration);
744           } else {
745               uint256 remaining = periodFinish.sub(block.timestamp);
746               uint256 leftover = remaining.mul(rewardRate);
747               rewardRate = reward.add(leftover).div(duration);
748           }
749           lastUpdateTime = block.timestamp;
750           periodFinish = block.timestamp.add(duration);
751           emit RewardAdded(reward);
752         } else {
753           rewardRate = reward.div(duration);
754           lastUpdateTime = starttime;
755           periodFinish = starttime.add(duration);
756           emit RewardAdded(reward);
757         }
758     }
759 }