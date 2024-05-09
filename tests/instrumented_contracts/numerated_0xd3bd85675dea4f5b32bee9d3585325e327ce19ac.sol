1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: YFIRewards.sol
9 *
10 * Docs: https://docs.synthetix.io/
11 *
12 *
13 * MIT License
14 * ===========
15 *
16 * Copyright (c) 2020 Synthetix
17 *
18 * Permission is hereby granted, free of charge, to any person obtaining a copy
19 * of this software and associated documentation files (the "Software"), to deal
20 * in the Software without restriction, including without limitation the rights
21 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
22 * copies of the Software, and to permit persons to whom the Software is
23 * furnished to do so, subject to the following conditions:
24 *
25 * The above copyright notice and this permission notice shall be included in all
26 * copies or substantial portions of the Software.
27 *
28 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
31 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
34 */
35 
36 // File: @openzeppelin/contracts/math/Math.sol
37 
38 pragma solidity ^0.6.2;
39 
40 /**
41  * @dev Standard math utilities missing in the Solidity language.
42  */
43 library Math {
44     /**
45      * @dev Returns the largest of two numbers.
46      */
47     function max(uint256 a, uint256 b) internal pure returns (uint256) {
48         return a >= b ? a : b;
49     }
50 
51     /**
52      * @dev Returns the smallest of two numbers.
53      */
54     function min(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a < b ? a : b;
56     }
57 
58     /**
59      * @dev Returns the average of two numbers. The result is rounded towards
60      * zero.
61      */
62     function average(uint256 a, uint256 b) internal pure returns (uint256) {
63         // (a + b) / 2 can overflow, so we distribute
64         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
65     }
66 }
67 
68 // File: @openzeppelin/contracts/math/SafeMath.sol
69 
70 pragma solidity ^0.6.2;
71 
72 /**
73  * @dev Wrappers over Solidity's arithmetic operations with added overflow
74  * checks.
75  *
76  * Arithmetic operations in Solidity wrap on overflow. This can easily result
77  * in bugs, because programmers usually assume that an overflow raises an
78  * error, which is the standard behavior in high level programming languages.
79  * `SafeMath` restores this intuition by reverting the transaction when an
80  * operation overflows.
81  *
82  * Using this library instead of the unchecked operations eliminates an entire
83  * class of bugs, so it's recommended to use it always.
84  */
85 library SafeMath {
86     /**
87      * @dev Returns the addition of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `+` operator.
91      *
92      * Requirements:
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         require(c >= a, "SafeMath: addition overflow");
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the subtraction of two unsigned integers, reverting on
104      * overflow (when the result is negative).
105      *
106      * Counterpart to Solidity's `-` operator.
107      *
108      * Requirements:
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return sub(a, b, "SafeMath: subtraction overflow");
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      * - Subtraction cannot overflow.
123      *
124      * _Available since v2.4.0._
125      */
126     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
127         require(b <= a, errorMessage);
128         uint256 c = a - b;
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the multiplication of two unsigned integers, reverting on
135      * overflow.
136      *
137      * Counterpart to Solidity's `*` operator.
138      *
139      * Requirements:
140      * - Multiplication cannot overflow.
141      */
142     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
144         // benefit is lost if 'b' is also tested.
145         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
146         if (a == 0) {
147             return 0;
148         }
149 
150         uint256 c = a * b;
151         require(c / a == b, "SafeMath: multiplication overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the integer division of two unsigned integers. Reverts on
158      * division by zero. The result is rounded towards zero.
159      *
160      * Counterpart to Solidity's `/` operator. Note: this function uses a
161      * `revert` opcode (which leaves remaining gas untouched) while Solidity
162      * uses an invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      * - The divisor cannot be zero.
166      */
167     function div(uint256 a, uint256 b) internal pure returns (uint256) {
168         return div(a, b, "SafeMath: division by zero");
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      *
182      * _Available since v2.4.0._
183      */
184     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         // Solidity only automatically asserts when dividing by 0
186         require(b > 0, errorMessage);
187         uint256 c = a / b;
188         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
195      * Reverts when dividing by zero.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      * - The divisor cannot be zero.
203      */
204     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
205         return mod(a, b, "SafeMath: modulo by zero");
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts with custom message when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      * - The divisor cannot be zero.
218      *
219      * _Available since v2.4.0._
220      */
221     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
222         require(b != 0, errorMessage);
223         return a % b;
224     }
225 }
226 
227 // File: @openzeppelin/contracts/GSN/Context.sol
228 
229 pragma solidity ^0.6.2;
230 
231 /*
232  * @dev Provides information about the current execution context, including the
233  * sender of the transaction and its data. While these are generally available
234  * via msg.sender and msg.data, they should not be accessed in such a direct
235  * manner, since when dealing with GSN meta-transactions the account sending and
236  * paying for execution may not be the actual sender (as far as an application
237  * is concerned).
238  *
239  * This contract is only required for intermediate, library-like contracts.
240  */
241 contract Context {
242     // Empty internal constructor, to prevent people from mistakenly deploying
243     // an instance of this contract, which should be used via inheritance.
244     constructor () internal { }
245     // solhint-disable-previous-line no-empty-blocks
246 
247     function _msgSender() internal view returns (address payable) {
248         return msg.sender;
249     }
250 
251     function _msgData() internal view returns (bytes memory) {
252         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
253         return msg.data;
254     }
255 }
256 
257 // File: @openzeppelin/contracts/ownership/Ownable.sol
258 
259 pragma solidity ^0.6.2;
260 
261 /**
262  * @dev Contract module which provides a basic access control mechanism, where
263  * there is an account (an owner) that can be granted exclusive access to
264  * specific functions.
265  *
266  * This module is used through inheritance. It will make available the modifier
267  * `onlyOwner`, which can be applied to your functions to restrict their use to
268  * the owner.
269  */
270 contract Ownable is Context {
271     address private _owner;
272 
273     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
274 
275     /**
276      * @dev Initializes the contract setting the deployer as the initial owner.
277      */
278     constructor () internal {
279         _owner = _msgSender();
280         emit OwnershipTransferred(address(0), _owner);
281     }
282 
283     /**
284      * @dev Returns the address of the current owner.
285      */
286     function owner() public view returns (address) {
287         return _owner;
288     }
289 
290     /**
291      * @dev Throws if called by any account other than the owner.
292      */
293     modifier onlyOwner() {
294         require(isOwner(), "Ownable: caller is not the owner");
295         _;
296     }
297 
298     /**
299      * @dev Returns true if the caller is the current owner.
300      */
301     function isOwner() public view returns (bool) {
302         return _msgSender() == _owner;
303     }
304 
305     /**
306      * @dev Leaves the contract without owner. It will not be possible to call
307      * `onlyOwner` functions anymore. Can only be called by the current owner.
308      *
309      * NOTE: Renouncing ownership will leave the contract without an owner,
310      * thereby removing any functionality that is only available to the owner.
311      */
312     function renounceOwnership() public onlyOwner {
313         emit OwnershipTransferred(_owner, address(0));
314         _owner = address(0);
315     }
316 
317     /**
318      * @dev Transfers ownership of the contract to a new account (`newOwner`).
319      * Can only be called by the current owner.
320      */
321     function transferOwnership(address newOwner) public onlyOwner {
322         _transferOwnership(newOwner);
323     }
324 
325     /**
326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
327      */
328     function _transferOwnership(address newOwner) internal {
329         require(newOwner != address(0), "Ownable: new owner is the zero address");
330         emit OwnershipTransferred(_owner, newOwner);
331         _owner = newOwner;
332     }
333 }
334 
335 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
336 
337 pragma solidity ^0.6.2;
338 
339 /**
340  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
341  * the optional functions; to access them see {ERC20Detailed}.
342  */
343 interface IERC20 {
344     /**
345      * @dev Returns the amount of tokens in existence.
346      */
347     function totalSupply() external view returns (uint256);
348 
349     /**
350      * @dev Returns the amount of tokens owned by `account`.
351      */
352     function balanceOf(address account) external view returns (uint256);
353 
354     /**
355      * @dev Moves `amount` tokens from the caller's account to `recipient`.
356      *
357      * Returns a boolean value indicating whether the operation succeeded.
358      *
359      * Emits a {Transfer} event.
360      */
361     function transfer(address recipient, uint256 amount) external returns (bool);
362 
363     /**
364      * @dev Returns the remaining number of tokens that `spender` will be
365      * allowed to spend on behalf of `owner` through {transferFrom}. This is
366      * zero by default.
367      *
368      * This value changes when {approve} or {transferFrom} are called.
369      */
370     function allowance(address owner, address spender) external view returns (uint256);
371 
372     /**
373      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
374      *
375      * Returns a boolean value indicating whether the operation succeeded.
376      *
377      * IMPORTANT: Beware that changing an allowance with this method brings the risk
378      * that someone may use both the old and the new allowance by unfortunate
379      * transaction ordering. One possible solution to mitigate this race
380      * condition is to first reduce the spender's allowance to 0 and set the
381      * desired value afterwards:
382      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
383      *
384      * Emits an {Approval} event.
385      */
386     function approve(address spender, uint256 amount) external returns (bool);
387 
388     /**
389      * @dev Moves `amount` tokens from `sender` to `recipient` using the
390      * allowance mechanism. `amount` is then deducted from the caller's
391      * allowance.
392      *
393      * Returns a boolean value indicating whether the operation succeeded.
394      *
395      * Emits a {Transfer} event.
396      */
397     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
398 
399     /**
400      * @dev Emitted when `value` tokens are moved from one account (`from`) to
401      * another (`to`).
402      *
403      * Note that `value` may be zero.
404      */
405     event Transfer(address indexed from, address indexed to, uint256 value);
406 
407     /**
408      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
409      * a call to {approve}. `value` is the new allowance.
410      */
411     event Approval(address indexed owner, address indexed spender, uint256 value);
412 }
413 
414 // File: @openzeppelin/contracts/utils/Address.sol
415 
416 pragma solidity ^0.6.2;
417 
418 /**
419  * @dev Collection of functions related to the address type
420  */
421 library Address {
422     /**
423      * @dev Returns true if `account` is a contract.
424      *
425      * This test is non-exhaustive, and there may be false-negatives: during the
426      * execution of a contract's constructor, its address will be reported as
427      * not containing a contract.
428      *
429      * IMPORTANT: It is unsafe to assume that an address for which this
430      * function returns false is an externally-owned account (EOA) and not a
431      * contract.
432      */
433     function isContract(address account) internal view returns (bool) {
434         // This method relies in extcodesize, which returns 0 for contracts in
435         // construction, since the code is only stored at the end of the
436         // constructor execution.
437 
438         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
439         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
440         // for accounts without code, i.e. `keccak256('')`
441         bytes32 codehash;
442         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
443         // solhint-disable-next-line no-inline-assembly
444         assembly { codehash := extcodehash(account) }
445         return (codehash != 0x0 && codehash != accountHash);
446     }
447 
448     /**
449      * @dev Converts an `address` into `address payable`. Note that this is
450      * simply a type cast: the actual underlying value is not changed.
451      *
452      * _Available since v2.4.0._
453      */
454     function toPayable(address account) internal pure returns (address payable) {
455         return address(uint160(account));
456     }
457 
458     /**
459      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
460      * `recipient`, forwarding all available gas and reverting on errors.
461      *
462      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
463      * of certain opcodes, possibly making contracts go over the 2300 gas limit
464      * imposed by `transfer`, making them unable to receive funds via
465      * `transfer`. {sendValue} removes this limitation.
466      *
467      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
468      *
469      * IMPORTANT: because control is transferred to `recipient`, care must be
470      * taken to not create reentrancy vulnerabilities. Consider using
471      * {ReentrancyGuard} or the
472      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
473      *
474      * _Available since v2.4.0._
475      */
476     function sendValue(address payable recipient, uint256 amount) internal {
477         require(address(this).balance >= amount, "Address: insufficient balance");
478 
479         // solhint-disable-next-line avoid-call-value
480         (bool success, ) = recipient.call.value(amount)("");
481         require(success, "Address: unable to send value, recipient may have reverted");
482     }
483 }
484 
485 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
486 
487 pragma solidity ^0.6.2;
488 
489 
490 
491 
492 /**
493  * @title SafeERC20
494  * @dev Wrappers around ERC20 operations that throw on failure (when the token
495  * contract returns false). Tokens that return no value (and instead revert or
496  * throw on failure) are also supported, non-reverting calls are assumed to be
497  * successful.
498  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
499  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
500  */
501 library SafeERC20 {
502     using SafeMath for uint256;
503     using Address for address;
504 
505     function safeTransfer(IERC20 token, address to, uint256 value) internal {
506         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
507     }
508 
509     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
510         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
511     }
512 
513     function safeApprove(IERC20 token, address spender, uint256 value) internal {
514         // safeApprove should only be called when setting an initial allowance,
515         // or when resetting it to zero. To increase and decrease it, use
516         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
517         // solhint-disable-next-line max-line-length
518         require((value == 0) || (token.allowance(address(this), spender) == 0),
519             "SafeERC20: approve from non-zero to non-zero allowance"
520         );
521         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
522     }
523 
524     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
525         uint256 newAllowance = token.allowance(address(this), spender).add(value);
526         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
527     }
528 
529     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
530         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
531         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
532     }
533 
534     /**
535      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
536      * on the return value: the return value is optional (but if data is returned, it must not be false).
537      * @param token The token targeted by the call.
538      * @param data The call data (encoded using abi.encode or one of its variants).
539      */
540     function callOptionalReturn(IERC20 token, bytes memory data) private {
541         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
542         // we're implementing it ourselves.
543 
544         // A Solidity high level call has three parts:
545         //  1. The target address is checked to verify it contains contract code
546         //  2. The call itself is made, and success asserted
547         //  3. The return value is decoded, which in turn checks the size of the returned data.
548         // solhint-disable-next-line max-line-length
549         require(address(token).isContract(), "SafeERC20: call to non-contract");
550 
551         // solhint-disable-next-line avoid-low-level-calls
552         (bool success, bytes memory returndata) = address(token).call(data);
553         require(success, "SafeERC20: low-level call failed");
554 
555         if (returndata.length > 0) { // Return data is optional
556             // solhint-disable-next-line max-line-length
557             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
558         }
559     }
560 }
561 
562 // File: contracts/IRewardDistributionRecipient.sol
563 
564 pragma solidity ^0.6.2;
565 
566 
567 
568 abstract contract IRewardDistributionRecipient is Ownable {
569     address rewardDistribution;
570 
571     function notifyRewardAmount(uint256 reward) external virtual;
572 
573     modifier onlyRewardDistribution() {
574         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
575         _;
576     }
577 
578     function setRewardDistribution(address _rewardDistribution)
579         external
580         onlyOwner
581     {
582         rewardDistribution = _rewardDistribution;
583     }
584 }
585 
586 // File: contracts/CurveRewards.sol
587 
588 pragma solidity ^0.6.2;
589 
590 
591 
592 
593 
594 
595 contract LPTokenWrapper {
596     using SafeMath for uint256;
597     using SafeERC20 for IERC20;
598 
599     IERC20 public y;
600 
601     uint256 private _totalSupply;
602     mapping(address => uint256) private _balances;
603 
604     function totalSupply() public view returns (uint256) {
605         return _totalSupply;
606     }
607 
608     function balanceOf(address account) public view returns (uint256) {
609         return _balances[account];
610     }
611 
612     function stake(uint256 amount) public virtual {
613         _totalSupply = _totalSupply.add(amount);
614         _balances[msg.sender] = _balances[msg.sender].add(amount);
615         y.safeTransferFrom(msg.sender, address(this), amount);
616     }
617 
618     function withdraw(uint256 amount) public virtual {
619         _totalSupply = _totalSupply.sub(amount);
620         _balances[msg.sender] = _balances[msg.sender].sub(amount);
621         y.safeTransfer(msg.sender, amount);
622     }
623 
624     function setY(address _y) internal {
625         y = IERC20(_y);
626     }
627 }
628 
629 interface IMintable {
630     function mint(address who, uint256 amount) external;
631 }
632 
633 contract KunBptMining is LPTokenWrapper, IRewardDistributionRecipient {
634     using SafeERC20 for IERC20;
635 
636     IERC20 public kun;
637 
638     uint256 public DURATION = 7 days;
639     uint256 public withdrawDelay = 1 days;
640 
641     uint256 public starttime = 1603456200; //utc+8 2020/10/23 20:30:00
642     uint256 public periodFinish = 0;
643     uint256 public rewardRate = 0;
644     uint256 public lastUpdateTime;
645     uint256 public rewardPerTokenStored;
646 
647     mapping(address => uint256) public userRewardPerTokenPaid;
648     mapping(address => uint256) public rewards;
649 
650     event RewardAdded(uint256 reward);
651     event Staked(address indexed user, uint256 amount);
652     event Withdrawn(address indexed user, uint256 amount);
653     event RewardPaid(address indexed user, uint256 reward);
654     event ClaimedTokens(address token, address owner, uint256 balance);
655 
656     constructor (uint256 _starttime, address _kun, address _bpt) public {
657         starttime = _starttime;
658         kun = IERC20(_kun);
659         y = IERC20(_bpt);
660         
661         lastUpdateTime = starttime;
662     }
663 
664     function setKun(address _kun) external onlyOwner {
665         require(_kun != address(y), "change kun to y is forbidden");
666         kun = IERC20(_kun);
667     }
668 
669     function setLp(address _lp) external onlyOwner {
670         setY(_lp);
671     }
672 
673     function setDuration(uint256 _duration) external onlyOwner {
674         DURATION = _duration;
675     }
676 
677     function setStarttime(uint256 _starttime) external onlyOwner {
678         starttime = _starttime;
679     }
680 
681     function setWithdrawDelay(uint256 _withdrawDelay) external onlyOwner {
682         withdrawDelay = _withdrawDelay;
683     }
684 
685     //更新用户所获得的收益和用户保存的每个质押token获取的奖励数
686     modifier updateReward(address account) {
687         rewardPerTokenStored = rewardPerToken();
688         lastUpdateTime = lastTimeRewardApplicable();
689         if (account != address(0)) {
690             rewards[account] = earned(account);
691             userRewardPerTokenPaid[account] = rewardPerTokenStored;
692         }
693         _;
694     }
695 
696     function lastTimeRewardApplicable() public view returns (uint256) {
697         return Math.min(block.timestamp, periodFinish);
698     }
699 
700     function rewardPerToken() public view returns (uint256) {
701         if (totalSupply() == 0) {
702             return rewardPerTokenStored;//初始为0
703         }
704 
705         return 
706             rewardPerTokenStored.add(
707                 lastTimeRewardApplicable()
708                     .sub(lastUpdateTime)
709                     .mul(rewardRate)
710                     .mul(1e18)
711                     .div(totalSupply())
712             );
713     }
714 
715     function earned(address account) public view returns (uint256) {
716         return
717             balanceOf(account)
718                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
719                 .div(1e18)
720                 .add(rewards[account]);
721     }
722 
723     // stake visibility is public as overriding LPTokenWrapper's stake() function
724     function stake(uint256 amount) public override updateReward(msg.sender) checkStart {
725         require(amount > 0, "Cannot stake 0");
726         super.stake(amount);
727         emit Staked(msg.sender, amount);
728     }
729 
730     function withdraw(uint256 amount) public override updateReward(msg.sender) checkStart {
731         require(amount > 0, "Cannot withdraw 0");
732         super.withdraw(amount);
733         emit Withdrawn(msg.sender, amount);
734     }
735 
736     function exit() external {
737         withdraw(balanceOf(msg.sender));
738         getReward();
739     }
740 
741     //取回截止目前所获得的收益
742     function getReward() public updateReward(msg.sender) checkRewardStart {
743         uint256 reward = earned(msg.sender);
744         if (reward > 0) {
745             rewards[msg.sender] = 0;
746             IMintable(address(kun)).mint(msg.sender, reward);
747             emit RewardPaid(msg.sender, reward);
748         }
749     }
750 
751     modifier checkStart() {
752         require(block.timestamp > starttime,"not start");
753         _;
754     }
755 
756     modifier checkRewardStart() {
757         require(block.timestamp > starttime + withdrawDelay, "withdraw reward not start");
758         _;
759     }
760 
761     function notifyRewardAmount(uint256 reward)
762         external override
763         onlyRewardDistribution
764         updateReward(address(0))
765     {
766         if (block.timestamp >= periodFinish) {
767             rewardRate = reward.div(DURATION);
768         } else {
769             uint256 remaining = periodFinish.sub(block.timestamp);
770             uint256 leftover = remaining.mul(rewardRate);
771             rewardRate = reward.add(leftover).div(DURATION);
772         }
773         lastUpdateTime = block.timestamp;
774         periodFinish = block.timestamp.add(DURATION);
775         emit RewardAdded(reward);
776     }
777 }