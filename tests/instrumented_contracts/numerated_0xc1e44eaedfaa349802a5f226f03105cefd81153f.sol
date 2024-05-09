1 // File: contracts/distribution/SnxPool.sol
2 
3 ///
4 /// Cloned from https://etherscan.io/address/0xDCB6A51eA3CA5d3Fd898Fd6564757c7aAeC3ca92#code
5 ///
6 /// Changes: 
7 ///   - CurveRewards were renamed to AuricRewards
8 ///   - Added constructor the AuricRewards instead of a hardcoded token
9 ///   - Added constructor the LPTokenWrapper instead of a hardcoded token
10 ///   - rewardDistribution address was made public
11 ///
12 
13 /**
14 * Submitted for verification at Etherscan.io on 2020-04-22
15 */
16 
17 /*
18    ____            __   __        __   _
19   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
20  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
21 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
22      /___/
23 
24 * Synthetix: CurveRewards.sol
25 *
26 * Docs: https://docs.synthetix.io/
27 *
28 *
29 * MIT License
30 * ===========
31 *
32 * Copyright (c) 2020 Synthetix
33 *
34 * Permission is hereby granted, free of charge, to any person obtaining a copy
35 * of this software and associated documentation files (the "Software"), to deal
36 * in the Software without restriction, including without limitation the rights
37 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
38 * copies of the Software, and to permit persons to whom the Software is
39 * furnished to do so, subject to the following conditions:
40 *
41 * The above copyright notice and this permission notice shall be included in all
42 * copies or substantial portions of the Software.
43 *
44 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
45 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
46 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
47 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
48 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
49 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
50 */
51 
52 // File: @openzeppelin/contracts/math/Math.sol
53 
54 pragma solidity ^0.5.0;
55 
56 /**
57  * @dev Standard math utilities missing in the Solidity language.
58  */
59 library Math {
60     /**
61      * @dev Returns the largest of two numbers.
62      */
63     function max(uint256 a, uint256 b) internal pure returns (uint256) {
64         return a >= b ? a : b;
65     }
66 
67     /**
68      * @dev Returns the smallest of two numbers.
69      */
70     function min(uint256 a, uint256 b) internal pure returns (uint256) {
71         return a < b ? a : b;
72     }
73 
74     /**
75      * @dev Returns the average of two numbers. The result is rounded towards
76      * zero.
77      */
78     function average(uint256 a, uint256 b) internal pure returns (uint256) {
79         // (a + b) / 2 can overflow, so we distribute
80         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
81     }
82 }
83 
84 // File: @openzeppelin/contracts/math/SafeMath.sol
85 
86 pragma solidity ^0.5.0;
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations with added overflow
90  * checks.
91  *
92  * Arithmetic operations in Solidity wrap on overflow. This can easily result
93  * in bugs, because programmers usually assume that an overflow raises an
94  * error, which is the standard behavior in high level programming languages.
95  * `SafeMath` restores this intuition by reverting the transaction when an
96  * operation overflows.
97  *
98  * Using this library instead of the unchecked operations eliminates an entire
99  * class of bugs, so it's recommended to use it always.
100  */
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `+` operator.
107      *
108      * Requirements:
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      * - Subtraction cannot overflow.
139      *
140      * _Available since v2.4.0._
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      * - Multiplication cannot overflow.
157      */
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint256 c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      * - The divisor cannot be zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return div(a, b, "SafeMath: division by zero");
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      * - The divisor cannot be zero.
197      *
198      * _Available since v2.4.0._
199      */
200     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         // Solidity only automatically asserts when dividing by 0
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return mod(a, b, "SafeMath: modulo by zero");
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts with custom message when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      * - The divisor cannot be zero.
234      *
235      * _Available since v2.4.0._
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/GSN/Context.sol
244 
245 pragma solidity ^0.5.0;
246 
247 /*
248  * @dev Provides information about the current execution context, including the
249  * sender of the transaction and its data. While these are generally available
250  * via msg.sender and msg.data, they should not be accessed in such a direct
251  * manner, since when dealing with GSN meta-transactions the account sending and
252  * paying for execution may not be the actual sender (as far as an application
253  * is concerned).
254  *
255  * This contract is only required for intermediate, library-like contracts.
256  */
257 contract Context {
258     // Empty internal constructor, to prevent people from mistakenly deploying
259     // an instance of this contract, which should be used via inheritance.
260     constructor () internal { }
261     // solhint-disable-previous-line no-empty-blocks
262 
263     function _msgSender() internal view returns (address payable) {
264         return msg.sender;
265     }
266 
267     function _msgData() internal view returns (bytes memory) {
268         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
269         return msg.data;
270     }
271 }
272 
273 // File: @openzeppelin/contracts/ownership/Ownable.sol
274 
275 pragma solidity ^0.5.0;
276 
277 /**
278  * @dev Contract module which provides a basic access control mechanism, where
279  * there is an account (an owner) that can be granted exclusive access to
280  * specific functions.
281  *
282  * This module is used through inheritance. It will make available the modifier
283  * `onlyOwner`, which can be applied to your functions to restrict their use to
284  * the owner.
285  */
286 contract Ownable is Context {
287     address private _owner;
288 
289     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
290 
291     /**
292      * @dev Initializes the contract setting the deployer as the initial owner.
293      */
294     constructor () internal {
295         _owner = _msgSender();
296         emit OwnershipTransferred(address(0), _owner);
297     }
298 
299     /**
300      * @dev Returns the address of the current owner.
301      */
302     function owner() public view returns (address) {
303         return _owner;
304     }
305 
306     /**
307      * @dev Throws if called by any account other than the owner.
308      */
309     modifier onlyOwner() {
310         require(isOwner(), "Ownable: caller is not the owner");
311         _;
312     }
313 
314     /**
315      * @dev Returns true if the caller is the current owner.
316      */
317     function isOwner() public view returns (bool) {
318         return _msgSender() == _owner;
319     }
320 
321     /**
322      * @dev Leaves the contract without owner. It will not be possible to call
323      * `onlyOwner` functions anymore. Can only be called by the current owner.
324      *
325      * NOTE: Renouncing ownership will leave the contract without an owner,
326      * thereby removing any functionality that is only available to the owner.
327      */
328     function renounceOwnership() public onlyOwner {
329         emit OwnershipTransferred(_owner, address(0));
330         _owner = address(0);
331     }
332 
333     /**
334      * @dev Transfers ownership of the contract to a new account (`newOwner`).
335      * Can only be called by the current owner.
336      */
337     function transferOwnership(address newOwner) public onlyOwner {
338         _transferOwnership(newOwner);
339     }
340 
341     /**
342      * @dev Transfers ownership of the contract to a new account (`newOwner`).
343      */
344     function _transferOwnership(address newOwner) internal {
345         require(newOwner != address(0), "Ownable: new owner is the zero address");
346         emit OwnershipTransferred(_owner, newOwner);
347         _owner = newOwner;
348     }
349 }
350 
351 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
352 
353 pragma solidity ^0.5.0;
354 
355 /**
356  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
357  * the optional functions; to access them see {ERC20Detailed}.
358  */
359 interface IERC20 {
360     /**
361      * @dev Returns the amount of tokens in existence.
362      */
363     function totalSupply() external view returns (uint256);
364 
365     /**
366      * @dev Returns the amount of tokens owned by `account`.
367      */
368     function balanceOf(address account) external view returns (uint256);
369 
370     /**
371      * @dev Moves `amount` tokens from the caller's account to `recipient`.
372      *
373      * Returns a boolean value indicating whether the operation succeeded.
374      *
375      * Emits a {Transfer} event.
376      */
377     function transfer(address recipient, uint256 amount) external returns (bool);
378 
379     /**
380      * @dev Returns the remaining number of tokens that `spender` will be
381      * allowed to spend on behalf of `owner` through {transferFrom}. This is
382      * zero by default.
383      *
384      * This value changes when {approve} or {transferFrom} are called.
385      */
386     function allowance(address owner, address spender) external view returns (uint256);
387 
388     /**
389      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
390      *
391      * Returns a boolean value indicating whether the operation succeeded.
392      *
393      * IMPORTANT: Beware that changing an allowance with this method brings the risk
394      * that someone may use both the old and the new allowance by unfortunate
395      * transaction ordering. One possible solution to mitigate this race
396      * condition is to first reduce the spender's allowance to 0 and set the
397      * desired value afterwards:
398      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
399      *
400      * Emits an {Approval} event.
401      */
402     function approve(address spender, uint256 amount) external returns (bool);
403 
404     /**
405      * @dev Moves `amount` tokens from `sender` to `recipient` using the
406      * allowance mechanism. `amount` is then deducted from the caller's
407      * allowance.
408      *
409      * Returns a boolean value indicating whether the operation succeeded.
410      *
411      * Emits a {Transfer} event.
412      */
413     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
414 
415     /**
416      * @dev Emitted when `value` tokens are moved from one account (`from`) to
417      * another (`to`).
418      *
419      * Note that `value` may be zero.
420      */
421     event Transfer(address indexed from, address indexed to, uint256 value);
422 
423     /**
424      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
425      * a call to {approve}. `value` is the new allowance.
426      */
427     event Approval(address indexed owner, address indexed spender, uint256 value);
428 }
429 
430 // File: @openzeppelin/contracts/utils/Address.sol
431 
432 pragma solidity ^0.5.5;
433 
434 /**
435  * @dev Collection of functions related to the address type
436  */
437 library Address {
438     /**
439      * @dev Returns true if `account` is a contract.
440      *
441      * This test is non-exhaustive, and there may be false-negatives: during the
442      * execution of a contract's constructor, its address will be reported as
443      * not containing a contract.
444      *
445      * IMPORTANT: It is unsafe to assume that an address for which this
446      * function returns false is an externally-owned account (EOA) and not a
447      * contract.
448      */
449     function isContract(address account) internal view returns (bool) {
450         // This method relies in extcodesize, which returns 0 for contracts in
451         // construction, since the code is only stored at the end of the
452         // constructor execution.
453 
454         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
455         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
456         // for accounts without code, i.e. `keccak256('')`
457         bytes32 codehash;
458         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
459         // solhint-disable-next-line no-inline-assembly
460         assembly { codehash := extcodehash(account) }
461         return (codehash != 0x0 && codehash != accountHash);
462     }
463 
464     /**
465      * @dev Converts an `address` into `address payable`. Note that this is
466      * simply a type cast: the actual underlying value is not changed.
467      *
468      * _Available since v2.4.0._
469      */
470     function toPayable(address account) internal pure returns (address payable) {
471         return address(uint160(account));
472     }
473 
474     /**
475      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
476      * `recipient`, forwarding all available gas and reverting on errors.
477      *
478      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
479      * of certain opcodes, possibly making contracts go over the 2300 gas limit
480      * imposed by `transfer`, making them unable to receive funds via
481      * `transfer`. {sendValue} removes this limitation.
482      *
483      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
484      *
485      * IMPORTANT: because control is transferred to `recipient`, care must be
486      * taken to not create reentrancy vulnerabilities. Consider using
487      * {ReentrancyGuard} or the
488      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
489      *
490      * _Available since v2.4.0._
491      */
492     function sendValue(address payable recipient, uint256 amount) internal {
493         require(address(this).balance >= amount, "Address: insufficient balance");
494 
495         // solhint-disable-next-line avoid-call-value
496         (bool success, ) = recipient.call.value(amount)("");
497         require(success, "Address: unable to send value, recipient may have reverted");
498     }
499 }
500 
501 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
502 
503 pragma solidity ^0.5.0;
504 
505 
506 
507 
508 /**
509  * @title SafeERC20
510  * @dev Wrappers around ERC20 operations that throw on failure (when the token
511  * contract returns false). Tokens that return no value (and instead revert or
512  * throw on failure) are also supported, non-reverting calls are assumed to be
513  * successful.
514  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
515  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
516  */
517 library SafeERC20 {
518     using SafeMath for uint256;
519     using Address for address;
520 
521     function safeTransfer(IERC20 token, address to, uint256 value) internal {
522         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
523     }
524 
525     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
526         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
527     }
528 
529     function safeApprove(IERC20 token, address spender, uint256 value) internal {
530         // safeApprove should only be called when setting an initial allowance,
531         // or when resetting it to zero. To increase and decrease it, use
532         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
533         // solhint-disable-next-line max-line-length
534         require((value == 0) || (token.allowance(address(this), spender) == 0),
535             "SafeERC20: approve from non-zero to non-zero allowance"
536         );
537         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
538     }
539 
540     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
541         uint256 newAllowance = token.allowance(address(this), spender).add(value);
542         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
543     }
544 
545     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
546         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
547         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
548     }
549 
550     /**
551      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
552      * on the return value: the return value is optional (but if data is returned, it must not be false).
553      * @param token The token targeted by the call.
554      * @param data The call data (encoded using abi.encode or one of its variants).
555      */
556     function callOptionalReturn(IERC20 token, bytes memory data) private {
557         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
558         // we're implementing it ourselves.
559 
560         // A Solidity high level call has three parts:
561         //  1. The target address is checked to verify it contains contract code
562         //  2. The call itself is made, and success asserted
563         //  3. The return value is decoded, which in turn checks the size of the returned data.
564         // solhint-disable-next-line max-line-length
565         require(address(token).isContract(), "SafeERC20: call to non-contract");
566 
567         // solhint-disable-next-line avoid-low-level-calls
568         (bool success, bytes memory returndata) = address(token).call(data);
569         require(success, "SafeERC20: low-level call failed");
570 
571         if (returndata.length > 0) { // Return data is optional
572             // solhint-disable-next-line max-line-length
573             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
574         }
575     }
576 }
577 
578 // File: contracts/IRewardDistributionRecipient.sol
579 
580 pragma solidity ^0.5.0;
581 
582 
583 
584 contract IRewardDistributionRecipient is Ownable {
585     address public rewardDistribution;
586 
587     function notifyRewardAmount(uint256 reward) external;
588 
589     modifier onlyRewardDistribution() {
590         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
591         _;
592     }
593 
594     function setRewardDistribution(address _rewardDistribution)
595         external
596         onlyOwner
597     {
598         rewardDistribution = _rewardDistribution;
599     }
600 }
601 
602 // File: contracts/CurveRewards.sol
603 
604 pragma solidity ^0.5.0;
605 
606 
607 
608 
609 
610 
611 contract LPTokenWrapper {
612     using SafeMath for uint256;
613     using SafeERC20 for IERC20;
614 
615     IERC20 public uni;
616 
617     constructor (address _uni) public {
618         uni = IERC20(_uni);
619     }
620 
621     uint256 private _totalSupply;
622     mapping(address => uint256) private _balances;
623 
624     function totalSupply() public view returns (uint256) {
625         return _totalSupply;
626     }
627 
628     function balanceOf(address account) public view returns (uint256) {
629         return _balances[account];
630     }
631 
632     function stake(uint256 amount) public {
633         _totalSupply = _totalSupply.add(amount);
634         _balances[msg.sender] = _balances[msg.sender].add(amount);
635         uni.safeTransferFrom(msg.sender, address(this), amount);
636     }
637 
638     function withdraw(uint256 amount) public {
639         _totalSupply = _totalSupply.sub(amount);
640         _balances[msg.sender] = _balances[msg.sender].sub(amount);
641         uni.safeTransfer(msg.sender, amount);
642     }
643 }
644 
645 interface IERC20Burnable {
646     function burn(uint256 amount) external;
647 }
648 
649 interface IERC20Mintable {
650     function mint(address to, uint256 amount) external;
651 }
652 
653 contract PoolEscrow {
654 
655     using SafeERC20 for IERC20;
656     using SafeMath for uint256;
657 
658     modifier onlyGov() {
659         require(msg.sender == governance, "only governance");
660         _;
661     }
662 
663     address public shareToken;
664     address public pool;
665     address public ausc;
666     address public secondary;
667     address public development;
668     address public governancePool;
669     address public dao;
670     address public governance;
671     uint256 public lastMint;
672 
673     constructor(address _shareToken,
674         address _pool,
675         address _ausc,
676         address _secondary,
677         address _development,
678         address _governancePool,
679         address _dao) public {
680         shareToken = _shareToken;
681         pool = _pool;
682         ausc = _ausc;
683         secondary = _secondary;
684         development = _development;
685         governancePool = _governancePool;
686         dao = _dao;
687         governance = msg.sender;
688         lastMint = block.timestamp + 3 hours;
689     }
690 
691     function setSecondary(address account) external onlyGov {
692         secondary = account;
693     }
694 
695     function setDevelopment(address account) external onlyGov {
696         development = account;
697     }
698 
699     function setGovernancePool(address account) external onlyGov {
700         governancePool = account;
701     }
702 
703     function setDao(address account) external onlyGov {
704         dao = account;
705     }
706 
707     function setGovernance(address account) external onlyGov {
708         governance = account;
709     }
710 
711     function release(address recipient, uint256 shareAmount) external {
712         require(msg.sender == pool, "only pool can release tokens");
713         IERC20(shareToken).safeTransferFrom(msg.sender, address(this), shareAmount);
714         uint256 endowment = getTokenNumber(shareAmount).mul(5).div(100);
715         uint256 reward = getTokenNumber(shareAmount);
716         if (secondary != address(0)) {
717             IERC20(ausc).safeApprove(secondary, 0);
718             IERC20(ausc).safeApprove(secondary, endowment);
719             PoolEscrow(secondary).notifySecondaryTokens(endowment);
720             reward = reward.sub(endowment);
721         }
722         if (development != address(0)) {
723             IERC20(ausc).safeTransfer(development, endowment);
724             reward = reward.sub(endowment);
725         }
726         if (governancePool != address(0)) {
727             IERC20(ausc).safeTransfer(governancePool, endowment);
728             reward = reward.sub(endowment);
729         }
730         if (dao != address(0)) {
731             IERC20(ausc).safeTransfer(dao, endowment);
732             reward = reward.sub(endowment);
733         }
734         IERC20(ausc).safeTransfer(recipient, reward);
735         IERC20Burnable(shareToken).burn(shareAmount);
736     }
737 
738     function getTokenNumber(uint256 shareAmount) public view returns(uint256) {
739         return IERC20(ausc).balanceOf(address(this))
740             .mul(shareAmount)
741             .div(IERC20(shareToken).totalSupply());
742     }
743 
744     /**
745     * Functionality for secondary pool escrow. Transfers AUSC tokens from msg.sender to this
746     * escrow. At most per day, mints a fixed number of escrow tokens to the pool, and notifies
747     * the pool. The period 1 day should match the secondary pool.
748     */
749     function notifySecondaryTokens(uint256 number) external {
750         IERC20(ausc).safeTransferFrom(msg.sender, address(this), number);
751         if (lastMint.add(14 days) < block.timestamp) {
752             uint256 dailyMint = 1000000 * 1e18;
753             IERC20Mintable(shareToken).mint(pool, dailyMint);
754             AuricRewards(pool).notifyRewardAmount(dailyMint);
755             lastMint = block.timestamp;
756         }
757     }
758 }
759 
760 contract AuricRewards is LPTokenWrapper, IRewardDistributionRecipient {
761     IERC20 public snx;
762     uint256 public constant DURATION = 14 days;
763 
764     address public escrow;
765     uint256 public periodFinish = 0;
766     uint256 public rewardRate = 0;
767     uint256 public lastUpdateTime;
768     uint256 public rewardPerTokenStored;
769     mapping(address => uint256) public userRewardPerTokenPaid;
770     mapping(address => uint256) public rewards;
771 
772     event RewardAdded(uint256 reward);
773     event Staked(address indexed user, uint256 amount);
774     event Withdrawn(address indexed user, uint256 amount);
775     event RewardPaid(address indexed user, uint256 reward);
776 
777     modifier updateReward(address account) {
778         rewardPerTokenStored = rewardPerToken();
779         lastUpdateTime = lastTimeRewardApplicable();
780         if (account != address(0)) {
781             rewards[account] = earned(account);
782             userRewardPerTokenPaid[account] = rewardPerTokenStored;
783         }
784         _;
785     }
786 
787     constructor (address _token, address _lp) LPTokenWrapper(_lp) public {
788       snx = IERC20(_token);
789     }
790 
791     function lastTimeRewardApplicable() public view returns (uint256) {
792         return Math.min(block.timestamp, periodFinish);
793     }
794 
795     function rewardPerToken() public view returns (uint256) {
796         if (totalSupply() == 0) {
797             return rewardPerTokenStored;
798         }
799         return
800             rewardPerTokenStored.add(
801                 lastTimeRewardApplicable()
802                     .sub(lastUpdateTime)
803                     .mul(rewardRate)
804                     .mul(1e18)
805                     .div(totalSupply())
806             );
807     }
808 
809     function earned(address account) public view returns (uint256) {
810         return
811             balanceOf(account)
812                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
813                 .div(1e18)
814                 .add(rewards[account]);
815     }
816 
817     // returns the earned amount as it will be paid out by the escrow (accounting for rebases)
818     function earnedAusc(address account) public view returns (uint256) {
819         return PoolEscrow(escrow).getTokenNumber(
820             balanceOf(account)
821                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
822                 .div(1e18)
823                 .add(rewards[account])
824         );
825     }
826 
827     // stake visibility is public as overriding LPTokenWrapper's stake() function
828     function stake(uint256 amount) public updateReward(msg.sender) {
829         require(amount > 0, "Cannot stake 0");
830         super.stake(amount);
831         emit Staked(msg.sender, amount);
832     }
833 
834     function withdraw(uint256 amount) public updateReward(msg.sender) {
835         require(amount > 0, "Cannot withdraw 0");
836         super.withdraw(amount);
837         emit Withdrawn(msg.sender, amount);
838     }
839 
840     function exit() external {
841         withdraw(balanceOf(msg.sender));
842         getReward();
843     }
844 
845     function getReward() public updateReward(msg.sender) {
846         uint256 reward = earned(msg.sender);
847         if (reward > 0) {
848             rewards[msg.sender] = 0;
849             // the pool is distributing placeholder tokens with fixed supply
850             snx.safeApprove(escrow, 0);
851             snx.safeApprove(escrow, reward);
852             PoolEscrow(escrow).release(msg.sender, reward);
853             emit RewardPaid(msg.sender, reward);
854         }
855     }
856 
857     function notifyRewardAmount(uint256 reward)
858         external
859         onlyRewardDistribution
860         updateReward(address(0))
861     {
862         // overflow fix https://sips.synthetix.io/sips/sip-77
863         require(reward < uint256(-1) / 1e18, "amount too high");
864 
865         if (block.timestamp >= periodFinish) {
866             rewardRate = reward.div(DURATION);
867         } else {
868             uint256 remaining = periodFinish.sub(block.timestamp);
869             uint256 leftover = remaining.mul(rewardRate);
870             rewardRate = reward.add(leftover).div(DURATION);
871         }
872         lastUpdateTime = block.timestamp;
873         periodFinish = block.timestamp.add(DURATION);
874         emit RewardAdded(reward);
875     }
876 
877     function setEscrow(address newEscrow) external onlyOwner {
878         require(escrow == address(0), "escrow already set");
879         escrow = newEscrow;
880     }
881 }