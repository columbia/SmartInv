1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @dev Standard math utilities missing in the Solidity language.
6  */
7 library Math {
8     /**
9      * @dev Returns the largest of two numbers.
10      */
11     function max(uint256 a, uint256 b) internal pure returns (uint256) {
12         return a >= b ? a : b;
13     }
14 
15     /**
16      * @dev Returns the smallest of two numbers.
17      */
18     function min(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a < b ? a : b;
20     }
21 
22     /**
23      * @dev Returns the average of two numbers. The result is rounded towards
24      * zero.
25      */
26     function average(uint256 a, uint256 b) internal pure returns (uint256) {
27         // (a + b) / 2 can overflow, so we distribute
28         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
29     }
30 }
31 
32 /**
33  * @dev Wrappers over Solidity's arithmetic operations with added overflow
34  * checks.
35  *
36  * Arithmetic operations in Solidity wrap on overflow. This can easily result
37  * in bugs, because programmers usually assume that an overflow raises an
38  * error, which is the standard behavior in high level programming languages.
39  * `SafeMath` restores this intuition by reverting the transaction when an
40  * operation overflows.
41  *
42  * Using this library instead of the unchecked operations eliminates an entire
43  * class of bugs, so it's recommended to use it always.
44  */
45 library SafeMath {
46     /**
47      * @dev Returns the addition of two unsigned integers, reverting on
48      * overflow.
49      *
50      * Counterpart to Solidity's `+` operator.
51      *
52      * Requirements:
53      * - Addition cannot overflow.
54      */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting on
64      * overflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      * - Subtraction cannot overflow.
70      */
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return sub(a, b, "SafeMath: subtraction overflow");
73     }
74 
75     /**
76      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
77      * overflow (when the result is negative).
78      *
79      * Counterpart to Solidity's `-` operator.
80      *
81      * Requirements:
82      * - Subtraction cannot overflow.
83      *
84      * _Available since v2.4.0._
85      */
86     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the multiplication of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `*` operator.
98      *
99      * Requirements:
100      * - Multiplication cannot overflow.
101      */
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
104         // benefit is lost if 'b' is also tested.
105         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
106         if (a == 0) {
107             return 0;
108         }
109 
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the integer division of two unsigned integers. Reverts on
118      * division by zero. The result is rounded towards zero.
119      *
120      * Counterpart to Solidity's `/` operator. Note: this function uses a
121      * `revert` opcode (which leaves remaining gas untouched) while Solidity
122      * uses an invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      * - The divisor cannot be zero.
126      */
127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
128         return div(a, b, "SafeMath: division by zero");
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator. Note: this function uses a
136      * `revert` opcode (which leaves remaining gas untouched) while Solidity
137      * uses an invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      * - The divisor cannot be zero.
141      *
142      * _Available since v2.4.0._
143      */
144     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
145         // Solidity only automatically asserts when dividing by 0
146         require(b > 0, errorMessage);
147         uint256 c = a / b;
148         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * Reverts when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      */
164     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
165         return mod(a, b, "SafeMath: modulo by zero");
166     }
167 
168     /**
169      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
170      * Reverts with custom message when dividing by zero.
171      *
172      * Counterpart to Solidity's `%` operator. This function uses a `revert`
173      * opcode (which leaves remaining gas untouched) while Solidity uses an
174      * invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      *
179      * _Available since v2.4.0._
180      */
181     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         require(b != 0, errorMessage);
183         return a % b;
184     }
185 }
186 
187 /**
188  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
189  * the optional functions; to access them see {ERC20Detailed}.
190  */
191 interface IERC20 {
192     /**
193      * @dev Returns the amount of tokens in existence.
194      */
195     function totalSupply() external view returns (uint256);
196 
197     /**
198      * @dev Returns the amount of tokens owned by `account`.
199      */
200     function balanceOf(address account) external view returns (uint256);
201 
202     /**
203      * @dev Moves `amount` tokens from the caller's account to `recipient`.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transfer(address recipient, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Returns the remaining number of tokens that `spender` will be
213      * allowed to spend on behalf of `owner` through {transferFrom}. This is
214      * zero by default.
215      *
216      * This value changes when {approve} or {transferFrom} are called.
217      */
218     function allowance(address owner, address spender) external view returns (uint256);
219 
220     /**
221      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * IMPORTANT: Beware that changing an allowance with this method brings the risk
226      * that someone may use both the old and the new allowance by unfortunate
227      * transaction ordering. One possible solution to mitigate this race
228      * condition is to first reduce the spender's allowance to 0 and set the
229      * desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      *
232      * Emits an {Approval} event.
233      */
234     function approve(address spender, uint256 amount) external returns (bool);
235 
236     /**
237      * @dev Moves `amount` tokens from `sender` to `recipient` using the
238      * allowance mechanism. `amount` is then deducted from the caller's
239      * allowance.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Emitted when `value` tokens are moved from one account (`from`) to
249      * another (`to`).
250      *
251      * Note that `value` may be zero.
252      */
253     event Transfer(address indexed from, address indexed to, uint256 value);
254 
255     /**
256      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
257      * a call to {approve}. `value` is the new allowance.
258      */
259     event Approval(address indexed owner, address indexed spender, uint256 value);
260 }
261 
262 /**
263  * @dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following 
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
285         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
286         // for accounts without code, i.e. `keccak256('')`
287         bytes32 codehash;
288         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
289         // solhint-disable-next-line no-inline-assembly
290         assembly { codehash := extcodehash(account) }
291         return (codehash != accountHash && codehash != 0x0);
292     }
293 
294     /**
295      * @dev Converts an `address` into `address payable`. Note that this is
296      * simply a type cast: the actual underlying value is not changed.
297      *
298      * _Available since v2.4.0._
299      */
300     function toPayable(address account) internal pure returns (address payable) {
301         return address(uint160(account));
302     }
303 
304     /**
305      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
306      * `recipient`, forwarding all available gas and reverting on errors.
307      *
308      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
309      * of certain opcodes, possibly making contracts go over the 2300 gas limit
310      * imposed by `transfer`, making them unable to receive funds via
311      * `transfer`. {sendValue} removes this limitation.
312      *
313      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
314      *
315      * IMPORTANT: because control is transferred to `recipient`, care must be
316      * taken to not create reentrancy vulnerabilities. Consider using
317      * {ReentrancyGuard} or the
318      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
319      *
320      * _Available since v2.4.0._
321      */
322     function sendValue(address payable recipient, uint256 amount) internal {
323         require(address(this).balance >= amount, "Address: insufficient balance");
324 
325         // solhint-disable-next-line avoid-call-value
326         (bool success, ) = recipient.call.value(amount)("");
327         require(success, "Address: unable to send value, recipient may have reverted");
328     }
329 }
330 
331 /**
332  * @title SafeERC20
333  * @dev Wrappers around ERC20 operations that throw on failure (when the token
334  * contract returns false). Tokens that return no value (and instead revert or
335  * throw on failure) are also supported, non-reverting calls are assumed to be
336  * successful.
337  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
338  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
339  */
340 library SafeERC20 {
341     using SafeMath for uint256;
342     using Address for address;
343 
344     function safeTransfer(IERC20 token, address to, uint256 value) internal {
345         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
346     }
347 
348     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
349         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
350     }
351 
352     function safeApprove(IERC20 token, address spender, uint256 value) internal {
353         // safeApprove should only be called when setting an initial allowance,
354         // or when resetting it to zero. To increase and decrease it, use
355         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
356         // solhint-disable-next-line max-line-length
357         require((value == 0) || (token.allowance(address(this), spender) == 0),
358             "SafeERC20: approve from non-zero to non-zero allowance"
359         );
360         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
361     }
362 
363     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
364         uint256 newAllowance = token.allowance(address(this), spender).add(value);
365         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
366     }
367 
368     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
369         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
370         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
371     }
372 
373     /**
374      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
375      * on the return value: the return value is optional (but if data is returned, it must not be false).
376      * @param token The token targeted by the call.
377      * @param data The call data (encoded using abi.encode or one of its variants).
378      */
379     function callOptionalReturn(IERC20 token, bytes memory data) private {
380         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
381         // we're implementing it ourselves.
382 
383         // A Solidity high level call has three parts:
384         //  1. The target address is checked to verify it contains contract code
385         //  2. The call itself is made, and success asserted
386         //  3. The return value is decoded, which in turn checks the size of the returned data.
387         // solhint-disable-next-line max-line-length
388         require(address(token).isContract(), "SafeERC20: call to non-contract");
389 
390         // solhint-disable-next-line avoid-low-level-calls
391         (bool success, bytes memory returndata) = address(token).call(data);
392         require(success, "SafeERC20: low-level call failed");
393 
394         if (returndata.length > 0) { // Return data is optional
395             // solhint-disable-next-line max-line-length
396             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
397         }
398     }
399 }
400 
401 /**
402  * @dev Contract module that helps prevent reentrant calls to a function.
403  *
404  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
405  * available, which can be applied to functions to make sure there are no nested
406  * (reentrant) calls to them.
407  *
408  * Note that because there is a single `nonReentrant` guard, functions marked as
409  * `nonReentrant` may not call one another. This can be worked around by making
410  * those functions `private`, and then adding `external` `nonReentrant` entry
411  * points to them.
412  *
413  * TIP: If you would like to learn more about reentrancy and alternative ways
414  * to protect against it, check out our blog post
415  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
416  *
417  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
418  * metering changes introduced in the Istanbul hardfork.
419  */
420 contract ReentrancyGuard {
421     bool private _notEntered;
422 
423     constructor () internal {
424         // Storing an initial non-zero value makes deployment a bit more
425         // expensive, but in exchange the refund on every call to nonReentrant
426         // will be lower in amount. Since refunds are capped to a percetange of
427         // the total transaction's gas, it is best to keep them low in cases
428         // like this one, to increase the likelihood of the full refund coming
429         // into effect.
430         _notEntered = true;
431     }
432 
433     /**
434      * @dev Prevents a contract from calling itself, directly or indirectly.
435      * Calling a `nonReentrant` function from another `nonReentrant`
436      * function is not supported. It is possible to prevent this from happening
437      * by making the `nonReentrant` function external, and make it call a
438      * `private` function that does the actual work.
439      */
440     modifier nonReentrant() {
441         // On the first call to nonReentrant, _notEntered will be true
442         require(_notEntered, "ReentrancyGuard: reentrant call");
443 
444         // Any calls to nonReentrant after this point will fail
445         _notEntered = false;
446 
447         _;
448 
449         // By storing the original value once again, a refund is triggered (see
450         // https://eips.ethereum.org/EIPS/eip-2200)
451         _notEntered = true;
452     }
453 }
454 
455 /*
456  * @dev Provides information about the current execution context, including the
457  * sender of the transaction and its data. While these are generally available
458  * via msg.sender and msg.data, they should not be accessed in such a direct
459  * manner, since when dealing with GSN meta-transactions the account sending and
460  * paying for execution may not be the actual sender (as far as an application
461  * is concerned).
462  *
463  * This contract is only required for intermediate, library-like contracts.
464  */
465 contract Context {
466     // Empty internal constructor, to prevent people from mistakenly deploying
467     // an instance of this contract, which should be used via inheritance.
468     constructor () internal { }
469     // solhint-disable-previous-line no-empty-blocks
470 
471     function _msgSender() internal view returns (address payable) {
472         return msg.sender;
473     }
474 
475     function _msgData() internal view returns (bytes memory) {
476         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
477         return msg.data;
478     }
479 }
480 
481 /**
482  * @dev Contract module which provides a basic access control mechanism, where
483  * there is an account (an owner) that can be granted exclusive access to
484  * specific functions.
485  *
486  * This module is used through inheritance. It will make available the modifier
487  * `onlyOwner`, which can be applied to your functions to restrict their use to
488  * the owner.
489  */
490 contract Ownable is Context {
491     address private _owner;
492 
493     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
494 
495     /**
496      * @dev Initializes the contract setting the deployer as the initial owner.
497      */
498     constructor () internal {
499         address msgSender = _msgSender();
500         _owner = msgSender;
501         emit OwnershipTransferred(address(0), msgSender);
502     }
503 
504     /**
505      * @dev Returns the address of the current owner.
506      */
507     function owner() public view returns (address) {
508         return _owner;
509     }
510 
511     /**
512      * @dev Throws if called by any account other than the owner.
513      */
514     modifier onlyOwner() {
515         require(isOwner(), "Ownable: caller is not the owner");
516         _;
517     }
518 
519     /**
520      * @dev Returns true if the caller is the current owner.
521      */
522     function isOwner() public view returns (bool) {
523         return _msgSender() == _owner;
524     }
525 
526     /**
527      * @dev Leaves the contract without owner. It will not be possible to call
528      * `onlyOwner` functions anymore. Can only be called by the current owner.
529      *
530      * NOTE: Renouncing ownership will leave the contract without an owner,
531      * thereby removing any functionality that is only available to the owner.
532      */
533     function renounceOwnership() public onlyOwner {
534         emit OwnershipTransferred(_owner, address(0));
535         _owner = address(0);
536     }
537 
538     /**
539      * @dev Transfers ownership of the contract to a new account (`newOwner`).
540      * Can only be called by the current owner.
541      */
542     function transferOwnership(address newOwner) public onlyOwner {
543         _transferOwnership(newOwner);
544     }
545 
546     /**
547      * @dev Transfers ownership of the contract to a new account (`newOwner`).
548      */
549     function _transferOwnership(address newOwner) internal {
550         require(newOwner != address(0), "Ownable: new owner is the zero address");
551         emit OwnershipTransferred(_owner, newOwner);
552         _owner = newOwner;
553     }
554 }
555 
556 // Inheritance
557 // https://docs.synthetix.io/contracts/RewardsDistributionRecipient
558 contract RewardsDistributionRecipient is Ownable {
559     address public rewardsDistribution;
560 
561     function notifyRewardAmount(uint256 reward) external;
562 
563     modifier onlyRewardsDistribution() {
564         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
565         _;
566     }
567 
568     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
569         rewardsDistribution = _rewardsDistribution;
570     }
571 }
572 
573 // Inheritance
574 // https://docs.synthetix.io/contracts/Pausable
575 contract Pausable is Ownable {
576     uint public lastPauseTime;
577     bool public paused;
578 
579     constructor() internal {
580         // This contract is abstract, and thus cannot be instantiated directly
581         require(owner() != address(0), "Owner must be set");
582         // Paused will be false, and lastPauseTime will be 0 upon initialisation
583     }
584 
585     /**
586      * @notice Change the paused state of the contract
587      * @dev Only the contract owner may call this.
588      */
589     function setPaused(bool _paused) external onlyOwner {
590         // Ensure we're actually changing the state before we do anything
591         if (_paused == paused) {
592             return;
593         }
594 
595         // Set our paused state.
596         paused = _paused;
597 
598         // If applicable, set the last pause time.
599         if (paused) {
600             lastPauseTime = now;
601         }
602 
603         // Let everyone know that our pause state has changed.
604         emit PauseChanged(paused);
605     }
606 
607     event PauseChanged(bool isPaused);
608 
609     modifier notPaused {
610         require(!paused, "This action cannot be performed while the contract is paused");
611         _;
612     }
613 }
614 
615 /**
616  *Submitted for verification at Etherscan.io on 2020-07-29
617 */
618 /*
619    ____            __   __        __   _
620   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
621  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
622 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
623      /___/
624 
625 * Synthetix: YFIRewards.sol
626 *
627 * Docs: https://docs.synthetix.io/
628 *
629 *
630 * MIT License
631 * ===========
632 *
633 * Copyright (c) 2020 Synthetix
634 *
635 * Permission is hereby granted, free of charge, to any person obtaining a copy
636 * of this software and associated documentation files (the "Software"), to deal
637 * in the Software without restriction, including without limitation the rights
638 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
639 * copies of the Software, and to permit persons to whom the Software is
640 * furnished to do so, subject to the following conditions:
641 *
642 * The above copyright notice and this permission notice shall be included in all
643 * copies or substantial portions of the Software.
644 *
645 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
646 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
647 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
648 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
649 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
650 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
651 */
652 // Inheritance
653 contract LPTokenWrapper {
654     using SafeMath for uint256;
655     using SafeERC20 for IERC20;
656 
657     IERC20 public vote;
658 
659     uint256 private _totalSupply;
660     mapping(address => uint256) private _balances;
661 
662     function totalSupply() public view returns (uint256) {
663         return _totalSupply;
664     }
665 
666     function balanceOf(address account) public view returns (uint256) {
667         return _balances[account];
668     }
669 
670     function stake(uint256 amount) public {
671         _totalSupply = _totalSupply.add(amount);
672         _balances[msg.sender] = _balances[msg.sender].add(amount);
673         vote.safeTransferFrom(msg.sender, address(this), amount);
674     }
675 
676     function withdraw(uint256 amount) public {
677         _totalSupply = _totalSupply.sub(amount);
678         _balances[msg.sender] = _balances[msg.sender].sub(amount);
679         vote.safeTransfer(msg.sender, amount);
680     }
681 }
682 
683 interface Executor {
684     function execute(uint, uint, uint, uint) external;
685 }
686 
687 contract ENBGovernance is LPTokenWrapper, RewardsDistributionRecipient {
688     
689     /* Fee collection for any other token */
690     
691     function seize(IERC20 _token, uint amount) external onlyOwner {
692         require(_token != token, "reward");
693         require(_token != vote, "vote");
694         _token.safeTransfer(owner(), amount);
695     }
696     
697     /* Modifications for proposals */
698     
699     mapping(address => uint) public voteLock; // period that your sake it locked to keep it for voting
700     
701     struct Proposal {
702         uint id;
703         address proposer;
704         mapping(address => uint) forVotes;
705         mapping(address => uint) againstVotes;
706         uint totalForVotes;
707         uint totalAgainstVotes;
708         uint start; // block start;
709         uint end; // start + period
710         address executor;
711         string hash;
712         uint totalVotesAvailable;
713         uint quorum;
714         uint quorumRequired;
715         bool open;
716     }
717     
718     mapping (uint => Proposal) public proposals;
719     uint public proposalCount;
720     uint public period = 17280; // voting period in blocks ~ 17280 3 days for 15s/block
721     uint public lock = 17280; // vote lock in blocks ~ 17280 3 days for 15s/block
722     uint public minimum = 1e18;
723     uint public quorum = 2000;
724     bool public config = true;
725 
726     constructor(
727         IERC20 _rewardsToken,
728         IERC20 _voteToken
729     ) public {
730         token = _rewardsToken;
731         vote = _voteToken;
732         rewardsDistribution = msg.sender;
733     }
734     
735     function setQuorum(uint _quorum) public onlyOwner {
736         quorum = _quorum;
737     }
738     
739     function setMinimum(uint _minimum) public onlyOwner {
740         minimum = _minimum;
741     }
742     
743     function setPeriod(uint _period) public onlyOwner {
744         period = _period;
745     }
746     
747     function setLock(uint _lock) public onlyOwner {
748         lock = _lock;
749     }
750     
751     function initialize(uint id) public {
752         require(config == true, "!config");
753         config = false;
754         proposalCount = id;
755     }
756     
757     event NewProposal(uint id, address creator, uint start, uint duration, address executor);
758     event Vote(uint indexed id, address indexed voter, bool vote, uint weight);
759     
760     function propose(address executor, string memory hash) public {
761         require(votesOf(msg.sender) > minimum, "<minimum");
762         proposals[proposalCount++] = Proposal({
763             id: proposalCount,
764             proposer: msg.sender,
765             totalForVotes: 0,
766             totalAgainstVotes: 0,
767             start: block.number,
768             end: period.add(block.number),
769             executor: executor,
770             hash: hash,
771             totalVotesAvailable: totalVotes,
772             quorum: 0,
773             quorumRequired: quorum,
774             open: true
775         });
776         
777         emit NewProposal(proposalCount, msg.sender, block.number, period, executor);
778         voteLock[msg.sender] = lock.add(block.number);
779     }
780     
781     function execute(uint id) public {
782         (uint _for, uint _against, uint _quorum) = getStats(id);
783         require(proposals[id].quorumRequired < _quorum, "!quorum");
784         require(proposals[id].end < block.number , "!end");
785         if (proposals[id].open == true) {
786             tallyVotes(id);
787         }
788         Executor(proposals[id].executor).execute(id, _for, _against, _quorum);
789     }
790     
791     function getStats(uint id) public view returns (uint _for, uint _against, uint _quorum) {
792         _for = proposals[id].totalForVotes;
793         _against = proposals[id].totalAgainstVotes;
794         
795         uint _total = _for.add(_against);
796         _for = _for.mul(10000).div(_total);
797         _against = _against.mul(10000).div(_total);
798         
799         _quorum = _total.mul(10000).div(proposals[id].totalVotesAvailable);
800     }
801     
802     event ProposalFinished(uint indexed id, uint _for, uint _against, bool quorumReached);
803     
804     function tallyVotes(uint id) public {
805         require(proposals[id].open == true, "!open");
806         require(proposals[id].end < block.number, "!end");
807         
808         (uint _for, uint _against,) = getStats(id);
809         bool _quorum = false;
810         if (proposals[id].quorum >= proposals[id].quorumRequired) {
811             _quorum = true;
812         }
813         proposals[id].open = false;
814         emit ProposalFinished(id, _for, _against, _quorum);
815     }
816     
817     function votesOf(address voter) public view returns (uint) {
818         return votes[voter];
819     }
820     
821     uint public totalVotes;
822     mapping(address => uint) public votes;
823     event RegisterVoter(address voter, uint votes, uint totalVotes);
824     event RevokeVoter(address voter, uint votes, uint totalVotes);
825     
826     function register() public {
827         require(voters[msg.sender] == false, "voter");
828         voters[msg.sender] = true;
829         votes[msg.sender] = balanceOf(msg.sender);
830         totalVotes = totalVotes.add(votes[msg.sender]);
831         emit RegisterVoter(msg.sender, votes[msg.sender], totalVotes);
832     }
833     
834     
835     function revoke() public {
836         require(voters[msg.sender] == true, "!voter");
837         voters[msg.sender] = false;
838         if (totalVotes < votes[msg.sender]) {
839             //edge case, should be impossible, but this is defi
840             totalVotes = 0;
841         } else {
842             totalVotes = totalVotes.sub(votes[msg.sender]);
843         }
844         emit RevokeVoter(msg.sender, votes[msg.sender], totalVotes);
845         votes[msg.sender] = 0;
846     }
847     
848     mapping(address => bool) public voters;
849     
850     function voteFor(uint id) public {
851         require(proposals[id].start < block.number , "<start");
852         require(proposals[id].end > block.number , ">end");
853         
854         uint _against = proposals[id].againstVotes[msg.sender];
855         if (_against > 0) {
856             proposals[id].totalAgainstVotes = proposals[id].totalAgainstVotes.sub(_against);
857             proposals[id].againstVotes[msg.sender] = 0;
858         }
859         
860         uint vote = votesOf(msg.sender).sub(proposals[id].forVotes[msg.sender]);
861         proposals[id].totalForVotes = proposals[id].totalForVotes.add(vote);
862         proposals[id].forVotes[msg.sender] = votesOf(msg.sender);
863         
864         proposals[id].totalVotesAvailable = totalVotes;
865         uint _votes = proposals[id].totalForVotes.add(proposals[id].totalAgainstVotes);
866         proposals[id].quorum = _votes.mul(10000).div(totalVotes);
867         
868         voteLock[msg.sender] = lock.add(block.number);
869         
870         emit Vote(id, msg.sender, true, vote);
871     }
872     
873     function voteAgainst(uint id) public {
874         require(proposals[id].start < block.number , "<start");
875         require(proposals[id].end > block.number , ">end");
876         
877         uint _for = proposals[id].forVotes[msg.sender];
878         if (_for > 0) {
879             proposals[id].totalForVotes = proposals[id].totalForVotes.sub(_for);
880             proposals[id].forVotes[msg.sender] = 0;
881         }
882         
883         uint vote = votesOf(msg.sender).sub(proposals[id].againstVotes[msg.sender]);
884         proposals[id].totalAgainstVotes = proposals[id].totalAgainstVotes.add(vote);
885         proposals[id].againstVotes[msg.sender] = votesOf(msg.sender);
886         
887         proposals[id].totalVotesAvailable = totalVotes;
888         uint _votes = proposals[id].totalForVotes.add(proposals[id].totalAgainstVotes);
889         proposals[id].quorum = _votes.mul(10000).div(totalVotes);
890         
891         voteLock[msg.sender] = lock.add(block.number);
892         
893         emit Vote(id, msg.sender, false, vote);
894     }
895     
896     /* Default rewards contract */
897     
898     IERC20 public token;
899     
900     uint256 public constant DURATION = 30 days;
901 
902     uint256 public periodFinish = 0;
903     uint256 public rewardRate = 0;
904     uint256 public lastUpdateTime;
905     uint256 public rewardPerTokenStored;
906     mapping(address => uint256) public userRewardPerTokenPaid;
907     mapping(address => uint256) public rewards;
908 
909     event RewardAdded(uint256 reward);
910     event Staked(address indexed user, uint256 amount);
911     event Withdrawn(address indexed user, uint256 amount);
912     event RewardPaid(address indexed user, uint256 reward);
913 
914     modifier updateReward(address account) {
915         rewardPerTokenStored = rewardPerToken();
916         lastUpdateTime = lastTimeRewardApplicable();
917         if (account != address(0)) {
918             rewards[account] = earned(account);
919             userRewardPerTokenPaid[account] = rewardPerTokenStored;
920         }
921         _;
922     }
923 
924     function lastTimeRewardApplicable() public view returns (uint256) {
925         return Math.min(block.timestamp, periodFinish);
926     }
927 
928     function rewardPerToken() public view returns (uint256) {
929         if (totalSupply() == 0) {
930             return rewardPerTokenStored;
931         }
932         return
933             rewardPerTokenStored.add(
934                 lastTimeRewardApplicable()
935                     .sub(lastUpdateTime)
936                     .mul(rewardRate)
937                     .mul(1e18)
938                     .div(totalSupply())
939             );
940     }
941 
942     function earned(address account) public view returns (uint256) {
943         return
944             balanceOf(account)
945                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
946                 .div(1e18)
947                 .add(rewards[account]);
948     }
949 
950     // stake visibility is public as overriding LPTokenWrapper's stake() function
951     function stake(uint256 amount) public updateReward(msg.sender) {
952         require(amount > 0, "Cannot stake 0");
953         if (voters[msg.sender] == true) {
954             votes[msg.sender] = votes[msg.sender].add(amount);
955             totalVotes = totalVotes.add(amount);
956         }
957         super.stake(amount);
958         emit Staked(msg.sender, amount);
959     }
960 
961     function withdraw(uint256 amount) public updateReward(msg.sender) {
962         require(amount > 0, "Cannot withdraw 0");
963         if (voters[msg.sender] == true) {
964             votes[msg.sender] = votes[msg.sender].sub(amount);
965             totalVotes = totalVotes.sub(amount);
966         }
967         super.withdraw(amount);
968         emit Withdrawn(msg.sender, amount);
969     }
970 
971     function exit() external {
972         withdraw(balanceOf(msg.sender));
973         getReward();
974     }
975 
976     function getReward() public updateReward(msg.sender) {
977         uint256 reward = earned(msg.sender);
978         if (reward > 0) {
979             rewards[msg.sender] = 0;
980             token.safeTransfer(msg.sender, reward);
981             emit RewardPaid(msg.sender, reward);
982         }
983     }
984 
985     function notifyRewardAmount(uint256 reward)
986         external
987         onlyRewardsDistribution
988         updateReward(address(0))
989     {
990         IERC20(token).safeTransferFrom(msg.sender, address(this), reward);
991         if (block.timestamp >= periodFinish) {
992             rewardRate = reward.div(DURATION);
993         } else {
994             uint256 remaining = periodFinish.sub(block.timestamp);
995             uint256 leftover = remaining.mul(rewardRate);
996             rewardRate = reward.add(leftover).div(DURATION);
997         }
998         lastUpdateTime = block.timestamp;
999         periodFinish = block.timestamp.add(DURATION);
1000         emit RewardAdded(reward);
1001     }
1002 }