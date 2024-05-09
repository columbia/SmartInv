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
38 pragma solidity ^0.5.0;
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
70 pragma solidity ^0.5.0;
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
229 pragma solidity ^0.5.0;
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
259 pragma solidity ^0.5.0;
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
337 pragma solidity ^0.5.0;
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
416 pragma solidity ^0.5.5;
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
487 pragma solidity ^0.5.0;
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
564 pragma solidity ^0.5.0;
565 
566 
567 
568 contract IRewardDistributionRecipient is Ownable {
569     address rewardDistribution;
570 
571     function notifyRewardAmount(uint256 reward) external;
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
588 pragma solidity ^0.5.0;
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
599     IERC20 public vote = IERC20(0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e);
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
612     function stake(uint256 amount) public {
613         _totalSupply = _totalSupply.add(amount);
614         _balances[msg.sender] = _balances[msg.sender].add(amount);
615         vote.safeTransferFrom(msg.sender, address(this), amount);
616     }
617 
618     function withdraw(uint256 amount) public {
619         _totalSupply = _totalSupply.sub(amount);
620         _balances[msg.sender] = _balances[msg.sender].sub(amount);
621         vote.safeTransfer(msg.sender, amount);
622     }
623 }
624 
625 interface Executor {
626     function execute(uint, uint, uint, uint) external;
627 }
628 
629 contract YearnGovernance is LPTokenWrapper, IRewardDistributionRecipient {
630     
631     /* Fee collection for any other token */
632     
633     function seize(IERC20 _token, uint amount) external {
634         require(msg.sender == governance, "!governance");
635         require(_token != token, "reward");
636         require(_token != vote, "vote");
637         _token.safeTransfer(governance, amount);
638     }
639     
640     /* Fees breaker, to protect withdraws if anything ever goes wrong */
641     
642     bool public breaker = false;
643     
644     function setBreaker(bool _breaker) external {
645         require(msg.sender == governance, "!governance");
646         breaker = _breaker;
647     }
648     
649     /* Modifications for proposals */
650     
651     mapping(address => uint) public voteLock; // period that your sake it locked to keep it for voting
652     
653     struct Proposal {
654         uint id;
655         address proposer;
656         mapping(address => uint) forVotes;
657         mapping(address => uint) againstVotes;
658         uint totalForVotes;
659         uint totalAgainstVotes;
660         uint start; // block start;
661         uint end; // start + period
662         address executor;
663         string hash;
664         uint totalVotesAvailable;
665         uint quorum;
666         uint quorumRequired;
667         bool open;
668     }
669     
670     mapping (uint => Proposal) public proposals;
671     uint public proposalCount;
672     uint public period = 17280; // voting period in blocks ~ 17280 3 days for 15s/block
673     uint public lock = 17280; // vote lock in blocks ~ 17280 3 days for 15s/block
674     uint public minimum = 1e18;
675     uint public quorum = 2000;
676     bool public config = true;
677     
678     
679     address public governance;
680     
681     function setGovernance(address _governance) public {
682         require(msg.sender == governance, "!governance");
683         governance = _governance;
684     }
685     
686     function setQuorum(uint _quorum) public {
687         require(msg.sender == governance, "!governance");
688         quorum = _quorum;
689     }
690     
691     function setMinimum(uint _minimum) public {
692         require(msg.sender == governance, "!governance");
693         minimum = _minimum;
694     }
695     
696     function setPeriod(uint _period) public {
697         require(msg.sender == governance, "!governance");
698         period = _period;
699     }
700     
701     function setLock(uint _lock) public {
702         require(msg.sender == governance, "!governance");
703         lock = _lock;
704     }
705     
706     function initialize(uint id) public {
707         require(config == true, "!config");
708         config = false;
709         proposalCount = id;
710         governance = 0xFEB4acf3df3cDEA7399794D0869ef76A6EfAff52;
711     }
712     
713     event NewProposal(uint id, address creator, uint start, uint duration, address executor);
714     event Vote(uint indexed id, address indexed voter, bool vote, uint weight);
715     
716     function propose(address executor, string memory hash) public {
717         require(votesOf(msg.sender) > minimum, "<minimum");
718         proposals[proposalCount++] = Proposal({
719             id: proposalCount,
720             proposer: msg.sender,
721             totalForVotes: 0,
722             totalAgainstVotes: 0,
723             start: block.number,
724             end: period.add(block.number),
725             executor: executor,
726             hash: hash,
727             totalVotesAvailable: totalVotes,
728             quorum: 0,
729             quorumRequired: quorum,
730             open: true
731         });
732         
733         emit NewProposal(proposalCount, msg.sender, block.number, period, executor);
734         voteLock[msg.sender] = lock.add(block.number);
735     }
736     
737     function execute(uint id) public {
738         (uint _for, uint _against, uint _quorum) = getStats(id);
739         require(proposals[id].quorumRequired < _quorum, "!quorum");
740         require(proposals[id].end < block.number , "!end");
741         if (proposals[id].open == true) {
742             tallyVotes(id);
743         }
744         Executor(proposals[id].executor).execute(id, _for, _against, _quorum);
745     }
746     
747     function getStats(uint id) public view returns (uint _for, uint _against, uint _quorum) {
748         _for = proposals[id].totalForVotes;
749         _against = proposals[id].totalAgainstVotes;
750         
751         uint _total = _for.add(_against);
752         _for = _for.mul(10000).div(_total);
753         _against = _against.mul(10000).div(_total);
754         
755         _quorum = _total.mul(10000).div(proposals[id].totalVotesAvailable);
756     }
757     
758     event ProposalFinished(uint indexed id, uint _for, uint _against, bool quorumReached);
759     
760     function tallyVotes(uint id) public {
761         require(proposals[id].open == true, "!open");
762         require(proposals[id].end < block.number, "!end");
763         
764         (uint _for, uint _against,) = getStats(id);
765         bool _quorum = false;
766         if (proposals[id].quorum >= proposals[id].quorumRequired) {
767             _quorum = true;
768         }
769         proposals[id].open = false;
770         emit ProposalFinished(id, _for, _against, _quorum);
771     }
772     
773     function votesOf(address voter) public view returns (uint) {
774         return votes[voter];
775     }
776     
777     uint public totalVotes;
778     mapping(address => uint) public votes;
779     event RegisterVoter(address voter, uint votes, uint totalVotes);
780     event RevokeVoter(address voter, uint votes, uint totalVotes);
781     
782     function register() public {
783         require(voters[msg.sender] == false, "voter");
784         voters[msg.sender] = true;
785         votes[msg.sender] = balanceOf(msg.sender);
786         totalVotes = totalVotes.add(votes[msg.sender]);
787         emit RegisterVoter(msg.sender, votes[msg.sender], totalVotes);
788     }
789     
790     
791     function revoke() public {
792         require(voters[msg.sender] == true, "!voter");
793         voters[msg.sender] = false;
794         if (totalVotes < votes[msg.sender]) {
795             //edge case, should be impossible, but this is defi
796             totalVotes = 0;
797         } else {
798             totalVotes = totalVotes.sub(votes[msg.sender]);
799         }
800         emit RevokeVoter(msg.sender, votes[msg.sender], totalVotes);
801         votes[msg.sender] = 0;
802     }
803     
804     mapping(address => bool) public voters;
805     
806     function voteFor(uint id) public {
807         require(proposals[id].start < block.number , "<start");
808         require(proposals[id].end > block.number , ">end");
809         
810         uint _against = proposals[id].againstVotes[msg.sender];
811         if (_against > 0) {
812             proposals[id].totalAgainstVotes = proposals[id].totalAgainstVotes.sub(_against);
813             proposals[id].againstVotes[msg.sender] = 0;
814         }
815         
816         uint vote = votesOf(msg.sender).sub(proposals[id].forVotes[msg.sender]);
817         proposals[id].totalForVotes = proposals[id].totalForVotes.add(vote);
818         proposals[id].forVotes[msg.sender] = votesOf(msg.sender);
819         
820         proposals[id].totalVotesAvailable = totalVotes;
821         uint _votes = proposals[id].totalForVotes.add(proposals[id].totalAgainstVotes);
822         proposals[id].quorum = _votes.mul(10000).div(totalVotes);
823         
824         voteLock[msg.sender] = lock.add(block.number);
825         
826         emit Vote(id, msg.sender, true, vote);
827     }
828     
829     function voteAgainst(uint id) public {
830         require(proposals[id].start < block.number , "<start");
831         require(proposals[id].end > block.number , ">end");
832         
833         uint _for = proposals[id].forVotes[msg.sender];
834         if (_for > 0) {
835             proposals[id].totalForVotes = proposals[id].totalForVotes.sub(_for);
836             proposals[id].forVotes[msg.sender] = 0;
837         }
838         
839         uint vote = votesOf(msg.sender).sub(proposals[id].againstVotes[msg.sender]);
840         proposals[id].totalAgainstVotes = proposals[id].totalAgainstVotes.add(vote);
841         proposals[id].againstVotes[msg.sender] = votesOf(msg.sender);
842         
843         proposals[id].totalVotesAvailable = totalVotes;
844         uint _votes = proposals[id].totalForVotes.add(proposals[id].totalAgainstVotes);
845         proposals[id].quorum = _votes.mul(10000).div(totalVotes);
846         
847         voteLock[msg.sender] = lock.add(block.number);
848         
849         emit Vote(id, msg.sender, false, vote);
850     }
851     
852     /* Default rewards contract */
853     
854     IERC20 public token = IERC20(0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8);
855     
856     uint256 public constant DURATION = 7 days;
857 
858     uint256 public periodFinish = 0;
859     uint256 public rewardRate = 0;
860     uint256 public lastUpdateTime;
861     uint256 public rewardPerTokenStored;
862     mapping(address => uint256) public userRewardPerTokenPaid;
863     mapping(address => uint256) public rewards;
864 
865     event RewardAdded(uint256 reward);
866     event Staked(address indexed user, uint256 amount);
867     event Withdrawn(address indexed user, uint256 amount);
868     event RewardPaid(address indexed user, uint256 reward);
869 
870     modifier updateReward(address account) {
871         rewardPerTokenStored = rewardPerToken();
872         lastUpdateTime = lastTimeRewardApplicable();
873         if (account != address(0)) {
874             rewards[account] = earned(account);
875             userRewardPerTokenPaid[account] = rewardPerTokenStored;
876         }
877         _;
878     }
879 
880     function lastTimeRewardApplicable() public view returns (uint256) {
881         return Math.min(block.timestamp, periodFinish);
882     }
883 
884     function rewardPerToken() public view returns (uint256) {
885         if (totalSupply() == 0) {
886             return rewardPerTokenStored;
887         }
888         return
889             rewardPerTokenStored.add(
890                 lastTimeRewardApplicable()
891                     .sub(lastUpdateTime)
892                     .mul(rewardRate)
893                     .mul(1e18)
894                     .div(totalSupply())
895             );
896     }
897 
898     function earned(address account) public view returns (uint256) {
899         return
900             balanceOf(account)
901                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
902                 .div(1e18)
903                 .add(rewards[account]);
904     }
905 
906     // stake visibility is public as overriding LPTokenWrapper's stake() function
907     function stake(uint256 amount) public updateReward(msg.sender) {
908         require(amount > 0, "Cannot stake 0");
909         if (voters[msg.sender] == true) {
910             votes[msg.sender] = votes[msg.sender].add(amount);
911             totalVotes = totalVotes.add(amount);
912         }
913         super.stake(amount);
914         emit Staked(msg.sender, amount);
915     }
916 
917     function withdraw(uint256 amount) public updateReward(msg.sender) {
918         require(amount > 0, "Cannot withdraw 0");
919         if (voters[msg.sender] == true) {
920             votes[msg.sender] = votes[msg.sender].sub(amount);
921             totalVotes = totalVotes.sub(amount);
922         }
923         if (breaker == false) {
924             require(voteLock[msg.sender] < block.number,"!locked");
925         }
926         super.withdraw(amount);
927         emit Withdrawn(msg.sender, amount);
928     }
929 
930     function exit() external {
931         withdraw(balanceOf(msg.sender));
932         getReward();
933     }
934 
935     function getReward() public updateReward(msg.sender) {
936         if (breaker == false) {
937             require(voteLock[msg.sender] > block.number,"!voted");
938         }
939         uint256 reward = earned(msg.sender);
940         if (reward > 0) {
941             rewards[msg.sender] = 0;
942             token.safeTransfer(msg.sender, reward);
943             emit RewardPaid(msg.sender, reward);
944         }
945     }
946 
947     function notifyRewardAmount(uint256 reward)
948         external
949         onlyRewardDistribution
950         updateReward(address(0))
951     {
952         IERC20(token).safeTransferFrom(msg.sender, address(this), reward);
953         if (block.timestamp >= periodFinish) {
954             rewardRate = reward.div(DURATION);
955         } else {
956             uint256 remaining = periodFinish.sub(block.timestamp);
957             uint256 leftover = remaining.mul(rewardRate);
958             rewardRate = reward.add(leftover).div(DURATION);
959         }
960         lastUpdateTime = block.timestamp;
961         periodFinish = block.timestamp.add(DURATION);
962         emit RewardAdded(reward);
963     }
964 }