1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-23
3 */
4 
5 // File: contracts/distribution/SnxPool.sol
6 
7 ///
8 /// Cloned from https://etherscan.io/address/0xDCB6A51eA3CA5d3Fd898Fd6564757c7aAeC3ca92#code
9 ///
10 /// Changes: 
11 ///   - CurveRewards were renamed to AuricRewards
12 ///   - Added constructor the AuricRewards instead of a hardcoded token
13 ///   - Added constructor the LPTokenWrapper instead of a hardcoded token
14 ///   - rewardDistribution address was made public
15 ///
16 
17 /**
18 * Submitted for verification at Etherscan.io on 2020-04-22
19 */
20 
21 /*
22    ____            __   __        __   _
23   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
24  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
25 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
26      /___/
27 
28 * Synthetix: CurveRewards.sol
29 *
30 * Docs: https://docs.synthetix.io/
31 *
32 *
33 * MIT License
34 * ===========
35 *
36 * Copyright (c) 2020 Synthetix
37 *
38 * Permission is hereby granted, free of charge, to any person obtaining a copy
39 * of this software and associated documentation files (the "Software"), to deal
40 * in the Software without restriction, including without limitation the rights
41 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
42 * copies of the Software, and to permit persons to whom the Software is
43 * furnished to do so, subject to the following conditions:
44 *
45 * The above copyright notice and this permission notice shall be included in all
46 * copies or substantial portions of the Software.
47 *
48 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
49 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
50 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
51 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
52 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
53 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
54 */
55 
56 // File: @openzeppelin/contracts/math/Math.sol
57 
58 pragma solidity ^0.5.0;
59 
60 /**
61  * @dev Standard math utilities missing in the Solidity language.
62  */
63 library Math {
64     /**
65      * @dev Returns the largest of two numbers.
66      */
67     function max(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a >= b ? a : b;
69     }
70 
71     /**
72      * @dev Returns the smallest of two numbers.
73      */
74     function min(uint256 a, uint256 b) internal pure returns (uint256) {
75         return a < b ? a : b;
76     }
77 
78     /**
79      * @dev Returns the average of two numbers. The result is rounded towards
80      * zero.
81      */
82     function average(uint256 a, uint256 b) internal pure returns (uint256) {
83         // (a + b) / 2 can overflow, so we distribute
84         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
85     }
86 }
87 
88 // File: @openzeppelin/contracts/math/SafeMath.sol
89 
90 pragma solidity ^0.5.0;
91 
92 /**
93  * @dev Wrappers over Solidity's arithmetic operations with added overflow
94  * checks.
95  *
96  * Arithmetic operations in Solidity wrap on overflow. This can easily result
97  * in bugs, because programmers usually assume that an overflow raises an
98  * error, which is the standard behavior in high level programming languages.
99  * `SafeMath` restores this intuition by reverting the transaction when an
100  * operation overflows.
101  *
102  * Using this library instead of the unchecked operations eliminates an entire
103  * class of bugs, so it's recommended to use it always.
104  */
105 library SafeMath {
106     /**
107      * @dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      * - Addition cannot overflow.
114      */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a, "SafeMath: addition overflow");
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132         return sub(a, b, "SafeMath: subtraction overflow");
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      * - Subtraction cannot overflow.
143      *
144      * _Available since v2.4.0._
145      */
146     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         require(b <= a, errorMessage);
148         uint256 c = a - b;
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the multiplication of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `*` operator.
158      *
159      * Requirements:
160      * - Multiplication cannot overflow.
161      */
162     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
164         // benefit is lost if 'b' is also tested.
165         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
166         if (a == 0) {
167             return 0;
168         }
169 
170         uint256 c = a * b;
171         require(c / a == b, "SafeMath: multiplication overflow");
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers. Reverts on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      * - The divisor cannot be zero.
186      */
187     function div(uint256 a, uint256 b) internal pure returns (uint256) {
188         return div(a, b, "SafeMath: division by zero");
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      * - The divisor cannot be zero.
201      *
202      * _Available since v2.4.0._
203      */
204     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205         // Solidity only automatically asserts when dividing by 0
206         require(b > 0, errorMessage);
207         uint256 c = a / b;
208         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      */
224     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
225         return mod(a, b, "SafeMath: modulo by zero");
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts with custom message when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      * - The divisor cannot be zero.
238      *
239      * _Available since v2.4.0._
240      */
241     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
242         require(b != 0, errorMessage);
243         return a % b;
244     }
245 }
246 
247 // File: @openzeppelin/contracts/GSN/Context.sol
248 
249 pragma solidity ^0.5.0;
250 
251 /*
252  * @dev Provides information about the current execution context, including the
253  * sender of the transaction and its data. While these are generally available
254  * via msg.sender and msg.data, they should not be accessed in such a direct
255  * manner, since when dealing with GSN meta-transactions the account sending and
256  * paying for execution may not be the actual sender (as far as an application
257  * is concerned).
258  *
259  * This contract is only required for intermediate, library-like contracts.
260  */
261 contract Context {
262     // Empty internal constructor, to prevent people from mistakenly deploying
263     // an instance of this contract, which should be used via inheritance.
264     constructor () internal { }
265     // solhint-disable-previous-line no-empty-blocks
266 
267     function _msgSender() internal view returns (address payable) {
268         return msg.sender;
269     }
270 
271     function _msgData() internal view returns (bytes memory) {
272         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
273         return msg.data;
274     }
275 }
276 
277 // File: @openzeppelin/contracts/ownership/Ownable.sol
278 
279 pragma solidity ^0.5.0;
280 
281 /**
282  * @dev Contract module which provides a basic access control mechanism, where
283  * there is an account (an owner) that can be granted exclusive access to
284  * specific functions.
285  *
286  * This module is used through inheritance. It will make available the modifier
287  * `onlyOwner`, which can be applied to your functions to restrict their use to
288  * the owner.
289  */
290 contract Ownable is Context {
291     address private _owner;
292 
293     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
294 
295     /**
296      * @dev Initializes the contract setting the deployer as the initial owner.
297      */
298     constructor () internal {
299         _owner = _msgSender();
300         emit OwnershipTransferred(address(0), _owner);
301     }
302 
303     /**
304      * @dev Returns the address of the current owner.
305      */
306     function owner() public view returns (address) {
307         return _owner;
308     }
309 
310     /**
311      * @dev Throws if called by any account other than the owner.
312      */
313     modifier onlyOwner() {
314         require(isOwner(), "Ownable: caller is not the owner");
315         _;
316     }
317 
318     /**
319      * @dev Returns true if the caller is the current owner.
320      */
321     function isOwner() public view returns (bool) {
322         return _msgSender() == _owner;
323     }
324 
325     /**
326      * @dev Leaves the contract without owner. It will not be possible to call
327      * `onlyOwner` functions anymore. Can only be called by the current owner.
328      *
329      * NOTE: Renouncing ownership will leave the contract without an owner,
330      * thereby removing any functionality that is only available to the owner.
331      */
332     function renounceOwnership() public onlyOwner {
333         emit OwnershipTransferred(_owner, address(0));
334         _owner = address(0);
335     }
336 
337     /**
338      * @dev Transfers ownership of the contract to a new account (`newOwner`).
339      * Can only be called by the current owner.
340      */
341     function transferOwnership(address newOwner) public onlyOwner {
342         _transferOwnership(newOwner);
343     }
344 
345     /**
346      * @dev Transfers ownership of the contract to a new account (`newOwner`).
347      */
348     function _transferOwnership(address newOwner) internal {
349         require(newOwner != address(0), "Ownable: new owner is the zero address");
350         emit OwnershipTransferred(_owner, newOwner);
351         _owner = newOwner;
352     }
353 }
354 
355 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
356 
357 pragma solidity ^0.5.0;
358 
359 /**
360  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
361  * the optional functions; to access them see {ERC20Detailed}.
362  */
363 interface IERC20 {
364     /**
365      * @dev Returns the amount of tokens in existence.
366      */
367     function totalSupply() external view returns (uint256);
368 
369     /**
370      * @dev Returns the amount of tokens owned by `account`.
371      */
372     function balanceOf(address account) external view returns (uint256);
373 
374     /**
375      * @dev Moves `amount` tokens from the caller's account to `recipient`.
376      *
377      * Returns a boolean value indicating whether the operation succeeded.
378      *
379      * Emits a {Transfer} event.
380      */
381     function transfer(address recipient, uint256 amount) external returns (bool);
382 
383     /**
384      * @dev Returns the remaining number of tokens that `spender` will be
385      * allowed to spend on behalf of `owner` through {transferFrom}. This is
386      * zero by default.
387      *
388      * This value changes when {approve} or {transferFrom} are called.
389      */
390     function allowance(address owner, address spender) external view returns (uint256);
391 
392     /**
393      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
394      *
395      * Returns a boolean value indicating whether the operation succeeded.
396      *
397      * IMPORTANT: Beware that changing an allowance with this method brings the risk
398      * that someone may use both the old and the new allowance by unfortunate
399      * transaction ordering. One possible solution to mitigate this race
400      * condition is to first reduce the spender's allowance to 0 and set the
401      * desired value afterwards:
402      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
403      *
404      * Emits an {Approval} event.
405      */
406     function approve(address spender, uint256 amount) external returns (bool);
407 
408     /**
409      * @dev Moves `amount` tokens from `sender` to `recipient` using the
410      * allowance mechanism. `amount` is then deducted from the caller's
411      * allowance.
412      *
413      * Returns a boolean value indicating whether the operation succeeded.
414      *
415      * Emits a {Transfer} event.
416      */
417     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
418 
419     /**
420      * @dev Emitted when `value` tokens are moved from one account (`from`) to
421      * another (`to`).
422      *
423      * Note that `value` may be zero.
424      */
425     event Transfer(address indexed from, address indexed to, uint256 value);
426 
427     /**
428      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
429      * a call to {approve}. `value` is the new allowance.
430      */
431     event Approval(address indexed owner, address indexed spender, uint256 value);
432 }
433 
434 // File: @openzeppelin/contracts/utils/Address.sol
435 
436 pragma solidity ^0.5.5;
437 
438 /**
439  * @dev Collection of functions related to the address type
440  */
441 library Address {
442     /**
443      * @dev Returns true if `account` is a contract.
444      *
445      * This test is non-exhaustive, and there may be false-negatives: during the
446      * execution of a contract's constructor, its address will be reported as
447      * not containing a contract.
448      *
449      * IMPORTANT: It is unsafe to assume that an address for which this
450      * function returns false is an externally-owned account (EOA) and not a
451      * contract.
452      */
453     function isContract(address account) internal view returns (bool) {
454         // This method relies in extcodesize, which returns 0 for contracts in
455         // construction, since the code is only stored at the end of the
456         // constructor execution.
457 
458         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
459         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
460         // for accounts without code, i.e. `keccak256('')`
461         bytes32 codehash;
462         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
463         // solhint-disable-next-line no-inline-assembly
464         assembly { codehash := extcodehash(account) }
465         return (codehash != 0x0 && codehash != accountHash);
466     }
467 
468     /**
469      * @dev Converts an `address` into `address payable`. Note that this is
470      * simply a type cast: the actual underlying value is not changed.
471      *
472      * _Available since v2.4.0._
473      */
474     function toPayable(address account) internal pure returns (address payable) {
475         return address(uint160(account));
476     }
477 
478     /**
479      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
480      * `recipient`, forwarding all available gas and reverting on errors.
481      *
482      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
483      * of certain opcodes, possibly making contracts go over the 2300 gas limit
484      * imposed by `transfer`, making them unable to receive funds via
485      * `transfer`. {sendValue} removes this limitation.
486      *
487      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
488      *
489      * IMPORTANT: because control is transferred to `recipient`, care must be
490      * taken to not create reentrancy vulnerabilities. Consider using
491      * {ReentrancyGuard} or the
492      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
493      *
494      * _Available since v2.4.0._
495      */
496     function sendValue(address payable recipient, uint256 amount) internal {
497         require(address(this).balance >= amount, "Address: insufficient balance");
498 
499         // solhint-disable-next-line avoid-call-value
500         (bool success, ) = recipient.call.value(amount)("");
501         require(success, "Address: unable to send value, recipient may have reverted");
502     }
503 }
504 
505 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
506 
507 pragma solidity ^0.5.0;
508 
509 
510 
511 
512 /**
513  * @title SafeERC20
514  * @dev Wrappers around ERC20 operations that throw on failure (when the token
515  * contract returns false). Tokens that return no value (and instead revert or
516  * throw on failure) are also supported, non-reverting calls are assumed to be
517  * successful.
518  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
519  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
520  */
521 library SafeERC20 {
522     using SafeMath for uint256;
523     using Address for address;
524 
525     function safeTransfer(IERC20 token, address to, uint256 value) internal {
526         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
527     }
528 
529     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
530         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
531     }
532 
533     function safeApprove(IERC20 token, address spender, uint256 value) internal {
534         // safeApprove should only be called when setting an initial allowance,
535         // or when resetting it to zero. To increase and decrease it, use
536         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
537         // solhint-disable-next-line max-line-length
538         require((value == 0) || (token.allowance(address(this), spender) == 0),
539             "SafeERC20: approve from non-zero to non-zero allowance"
540         );
541         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
542     }
543 
544     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
545         uint256 newAllowance = token.allowance(address(this), spender).add(value);
546         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
547     }
548 
549     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
550         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
551         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
552     }
553 
554     /**
555      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
556      * on the return value: the return value is optional (but if data is returned, it must not be false).
557      * @param token The token targeted by the call.
558      * @param data The call data (encoded using abi.encode or one of its variants).
559      */
560     function callOptionalReturn(IERC20 token, bytes memory data) private {
561         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
562         // we're implementing it ourselves.
563 
564         // A Solidity high level call has three parts:
565         //  1. The target address is checked to verify it contains contract code
566         //  2. The call itself is made, and success asserted
567         //  3. The return value is decoded, which in turn checks the size of the returned data.
568         // solhint-disable-next-line max-line-length
569         require(address(token).isContract(), "SafeERC20: call to non-contract");
570 
571         // solhint-disable-next-line avoid-low-level-calls
572         (bool success, bytes memory returndata) = address(token).call(data);
573         require(success, "SafeERC20: low-level call failed");
574 
575         if (returndata.length > 0) { // Return data is optional
576             // solhint-disable-next-line max-line-length
577             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
578         }
579     }
580 }
581 
582 // File: contracts/IRewardDistributionRecipient.sol
583 
584 pragma solidity ^0.5.0;
585 
586 
587 
588 contract IRewardDistributionRecipient is Ownable {
589     address public rewardDistribution;
590 
591     function notifyRewardAmount(uint256 reward) external;
592 
593     modifier onlyRewardDistribution() {
594         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
595         _;
596     }
597 
598     function setRewardDistribution(address _rewardDistribution)
599         external
600         onlyOwner
601     {
602         rewardDistribution = _rewardDistribution;
603     }
604 }
605 
606 // File: contracts/CurveRewards.sol
607 
608 pragma solidity ^0.5.0;
609 
610 
611 
612 
613 
614 
615 contract LPTokenWrapper {
616     using SafeMath for uint256;
617     using SafeERC20 for IERC20;
618 
619     IERC20 public uni;
620 
621     constructor (address _uni) public {
622         uni = IERC20(_uni);
623     }
624 
625     uint256 private _totalSupply;
626     mapping(address => uint256) private _balances;
627 
628     function totalSupply() public view returns (uint256) {
629         return _totalSupply;
630     }
631 
632     function balanceOf(address account) public view returns (uint256) {
633         return _balances[account];
634     }
635 
636     function stake(uint256 amount) public {
637         _totalSupply = _totalSupply.add(amount);
638         _balances[msg.sender] = _balances[msg.sender].add(amount);
639         uni.safeTransferFrom(msg.sender, address(this), amount);
640     }
641 
642     function withdraw(uint256 amount) public {
643         _totalSupply = _totalSupply.sub(amount);
644         _balances[msg.sender] = _balances[msg.sender].sub(amount);
645         uni.safeTransfer(msg.sender, amount);
646     }
647 }
648 
649 interface IERC20Burnable {
650     function burn(uint256 amount) external;
651 }
652 
653 interface IERC20Mintable {
654     function mint(address to, uint256 amount) external;
655 }
656 
657 contract PoolEscrow {
658 
659     using SafeERC20 for IERC20;
660     using SafeMath for uint256;
661 
662     modifier onlyGov() {
663         require(msg.sender == governance, "only governance");
664         _;
665     }
666 
667     address public shareToken;
668     address public pool;
669     address public ausc;
670     address public secondary;
671     address public development;
672     address public governancePool;
673     address public dao;
674     address public governance;
675 
676     constructor(address _shareToken,
677         address _pool,
678         address _ausc,
679         address _secondary,
680         address _development,
681         address _governancePool,
682         address _dao) public {
683         shareToken = _shareToken;
684         pool = _pool;
685         ausc = _ausc;
686         secondary = _secondary;
687         development = _development;
688         governancePool = _governancePool;
689         dao = _dao;
690         governance = msg.sender;
691     }
692 
693     function setSecondary(address account) external onlyGov {
694         secondary = account;
695     }
696 
697     function setDevelopment(address account) external onlyGov {
698         development = account;
699     }
700 
701     function setGovernancePool(address account) external onlyGov {
702         governancePool = account;
703     }
704 
705     function setDao(address account) external onlyGov {
706         dao = account;
707     }
708 
709     function setGovernance(address account) external onlyGov {
710         governance = account;
711     }
712 
713     function release(address recipient, uint256 shareAmount) external {
714         require(msg.sender == pool, "only pool can release tokens");
715         IERC20(shareToken).safeTransferFrom(msg.sender, address(this), shareAmount);
716         uint256 endowment = getTokenNumber(shareAmount).mul(5).div(100);
717         uint256 reward = getTokenNumber(shareAmount);
718         if (secondary != address(0)) {
719             IERC20(ausc).safeApprove(secondary, 0);
720             IERC20(ausc).safeApprove(secondary, endowment);
721             PoolEscrow(secondary).notifySecondaryTokens(endowment);
722             reward = reward.sub(endowment);
723         }
724         if (development != address(0)) {
725             IERC20(ausc).safeTransfer(development, endowment);
726             reward = reward.sub(endowment);
727         }
728         if (governancePool != address(0)) {
729             IERC20(ausc).safeTransfer(governancePool, endowment);
730             reward = reward.sub(endowment);
731         }
732         if (dao != address(0)) {
733             IERC20(ausc).safeTransfer(dao, endowment);
734             reward = reward.sub(endowment);
735         }
736         IERC20(ausc).safeTransfer(recipient, reward);
737         IERC20Burnable(shareToken).burn(shareAmount);
738     }
739 
740     function getTokenNumber(uint256 shareAmount) public view returns(uint256) {
741         return IERC20(ausc).balanceOf(address(this))
742             .mul(shareAmount)
743             .div(IERC20(shareToken).totalSupply());
744     }
745 
746     /**
747     * Functionality for secondary pool escrow. Transfers AUSC tokens from msg.sender to this
748     * escrow. At most per day, mints a fixed number of escrow tokens to the pool, and notifies
749     * the pool. The period 1 day should match the secondary pool.
750     */
751     function notifySecondaryTokens(uint256 number) external {
752         IERC20(ausc).safeTransferFrom(msg.sender, address(this), number);
753         uint256 freshMint = number;
754         IERC20Mintable(shareToken).mint(pool, freshMint);
755         AuricRewards(pool).notifyRewardAmount(freshMint);
756     }
757 }
758 
759 contract AuricRewards is LPTokenWrapper, IRewardDistributionRecipient {
760     IERC20 public snx;
761     uint256 public constant DURATION = 10 days;
762 
763     address public escrow;
764     uint256 public periodFinish = 0;
765     uint256 public rewardRate = 0;
766     uint256 public lastUpdateTime;
767     uint256 public rewardPerTokenStored;
768     mapping(address => uint256) public userRewardPerTokenPaid;
769     mapping(address => uint256) public rewards;
770 
771     event RewardAdded(uint256 reward);
772     event Staked(address indexed user, uint256 amount);
773     event Withdrawn(address indexed user, uint256 amount);
774     event RewardPaid(address indexed user, uint256 reward);
775 
776     modifier updateReward(address account) {
777         rewardPerTokenStored = rewardPerToken();
778         lastUpdateTime = lastTimeRewardApplicable();
779         if (account != address(0)) {
780             rewards[account] = earned(account);
781             userRewardPerTokenPaid[account] = rewardPerTokenStored;
782         }
783         _;
784     }
785 
786     constructor (address _token, address _lp) LPTokenWrapper(_lp) public {
787       snx = IERC20(_token);
788     }
789 
790     function lastTimeRewardApplicable() public view returns (uint256) {
791         return Math.min(block.timestamp, periodFinish);
792     }
793 
794     function rewardPerToken() public view returns (uint256) {
795         if (totalSupply() == 0) {
796             return rewardPerTokenStored;
797         }
798         return
799             rewardPerTokenStored.add(
800                 lastTimeRewardApplicable()
801                     .sub(lastUpdateTime)
802                     .mul(rewardRate)
803                     .mul(1e18)
804                     .div(totalSupply())
805             );
806     }
807 
808     function earned(address account) public view returns (uint256) {
809         return
810             balanceOf(account)
811                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
812                 .div(1e18)
813                 .add(rewards[account]);
814     }
815 
816     // returns the earned amount as it will be paid out by the escrow (accounting for rebases)
817     function earnedAusc(address account) public view returns (uint256) {
818         return PoolEscrow(escrow).getTokenNumber(
819             balanceOf(account)
820                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
821                 .div(1e18)
822                 .add(rewards[account])
823         );
824     }
825 
826     // stake visibility is public as overriding LPTokenWrapper's stake() function
827     function stake(uint256 amount) public updateReward(msg.sender) {
828         require(amount > 0, "Cannot stake 0");
829         super.stake(amount);
830         emit Staked(msg.sender, amount);
831     }
832 
833     function withdraw(uint256 amount) public updateReward(msg.sender) {
834         require(amount > 0, "Cannot withdraw 0");
835         super.withdraw(amount);
836         emit Withdrawn(msg.sender, amount);
837     }
838 
839     function exit() external {
840         withdraw(balanceOf(msg.sender));
841         getReward();
842     }
843 
844     function getReward() public updateReward(msg.sender) {
845         uint256 reward = earned(msg.sender);
846         if (reward > 0) {
847             rewards[msg.sender] = 0;
848             // the pool is distributing placeholder tokens with fixed supply
849             snx.safeApprove(escrow, 0);
850             snx.safeApprove(escrow, reward);
851             PoolEscrow(escrow).release(msg.sender, reward);
852             emit RewardPaid(msg.sender, reward);
853         }
854     }
855 
856     function notifyRewardAmount(uint256 reward)
857         external
858         onlyRewardDistribution
859         updateReward(address(0))
860     {
861         // overflow fix https://sips.synthetix.io/sips/sip-77
862         require(reward < uint256(-1) / 1e18, "amount too high");
863 
864         if (block.timestamp >= periodFinish) {
865             rewardRate = reward.div(DURATION);
866         } else {
867             uint256 remaining = periodFinish.sub(block.timestamp);
868             uint256 leftover = remaining.mul(rewardRate);
869             rewardRate = reward.add(leftover).div(DURATION);
870         }
871         lastUpdateTime = block.timestamp;
872         periodFinish = block.timestamp.add(DURATION);
873         emit RewardAdded(reward);
874     }
875 
876     function setEscrow(address newEscrow) external onlyOwner {
877         require(escrow == address(0), "escrow already set");
878         escrow = newEscrow;
879     }
880 }