1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-29
3 */
4 
5 /*
6    ____            __   __        __   _
7   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
8  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
9 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
10      /___/
11 
12 * Synthetix: YFIRewards.sol
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
345  * the optional functions; to access them see {ERC20Detailed}.
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
363      * Emits a {Transfer} event.
364      */
365     function transfer(address recipient, uint256 amount) external returns (bool);
366 
367     /**
368      * @dev Returns the remaining number of tokens that `spender` will be
369      * allowed to spend on behalf of `owner` through {transferFrom}. This is
370      * zero by default.
371      *
372      * This value changes when {approve} or {transferFrom} are called.
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
388      * Emits an {Approval} event.
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
399      * Emits a {Transfer} event.
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
413      * a call to {approve}. `value` is the new allowance.
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
469      * `transfer`. {sendValue} removes this limitation.
470      *
471      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
472      *
473      * IMPORTANT: because control is transferred to `recipient`, care must be
474      * taken to not create reentrancy vulnerabilities. Consider using
475      * {ReentrancyGuard} or the
476      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
477      *
478      * _Available since v2.4.0._
479      */
480     function sendValue(address payable recipient, uint256 amount) internal {
481         require(address(this).balance >= amount, "Address: insufficient balance");
482 
483         // solhint-disable-next-line avoid-call-value
484         (bool success, ) = recipient.call.value(amount)("");
485         require(success, "Address: unable to send value, recipient may have reverted");
486     }
487 }
488 
489 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
490 
491 pragma solidity ^0.5.0;
492 
493 
494 
495 
496 /**
497  * @title SafeERC20
498  * @dev Wrappers around ERC20 operations that throw on failure (when the token
499  * contract returns false). Tokens that return no value (and instead revert or
500  * throw on failure) are also supported, non-reverting calls are assumed to be
501  * successful.
502  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
503  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
504  */
505 library SafeERC20 {
506     using SafeMath for uint256;
507     using Address for address;
508 
509     function safeTransfer(IERC20 token, address to, uint256 value) internal {
510         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
511     }
512 
513     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
514         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
515     }
516 
517     function safeApprove(IERC20 token, address spender, uint256 value) internal {
518         // safeApprove should only be called when setting an initial allowance,
519         // or when resetting it to zero. To increase and decrease it, use
520         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
521         // solhint-disable-next-line max-line-length
522         require((value == 0) || (token.allowance(address(this), spender) == 0),
523             "SafeERC20: approve from non-zero to non-zero allowance"
524         );
525         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
526     }
527 
528     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
529         uint256 newAllowance = token.allowance(address(this), spender).add(value);
530         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
531     }
532 
533     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
534         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
535         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
536     }
537 
538     /**
539      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
540      * on the return value: the return value is optional (but if data is returned, it must not be false).
541      * @param token The token targeted by the call.
542      * @param data The call data (encoded using abi.encode or one of its variants).
543      */
544     function callOptionalReturn(IERC20 token, bytes memory data) private {
545         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
546         // we're implementing it ourselves.
547 
548         // A Solidity high level call has three parts:
549         //  1. The target address is checked to verify it contains contract code
550         //  2. The call itself is made, and success asserted
551         //  3. The return value is decoded, which in turn checks the size of the returned data.
552         // solhint-disable-next-line max-line-length
553         require(address(token).isContract(), "SafeERC20: call to non-contract");
554 
555         // solhint-disable-next-line avoid-low-level-calls
556         (bool success, bytes memory returndata) = address(token).call(data);
557         require(success, "SafeERC20: low-level call failed");
558 
559         if (returndata.length > 0) { // Return data is optional
560             // solhint-disable-next-line max-line-length
561             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
562         }
563     }
564 }
565 
566 // File: contracts/IRewardDistributionRecipient.sol
567 
568 pragma solidity ^0.5.0;
569 
570 
571 
572 contract IRewardDistributionRecipient is Ownable {
573     address rewardDistribution;
574 
575     function notifyRewardAmount(uint256 reward) external;
576 
577     modifier onlyRewardDistribution() {
578         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
579         _;
580     }
581 
582     function setRewardDistribution(address _rewardDistribution)
583         external
584         onlyOwner
585     {
586         rewardDistribution = _rewardDistribution;
587     }
588 }
589 
590 // File: contracts/CurveRewards.sol
591 
592 pragma solidity ^0.5.0;
593 
594 
595 
596 
597 
598 
599 contract LPTokenWrapper {
600     using SafeMath for uint256;
601     using SafeERC20 for IERC20;
602 
603     IERC20 public vote = IERC20(0xa1d0E215a23d7030842FC67cE582a6aFa3CCaB83);
604 
605     uint256 private _totalSupply;
606     mapping(address => uint256) private _balances;
607 
608     function totalSupply() public view returns (uint256) {
609         return _totalSupply;
610     }
611 
612     function balanceOf(address account) public view returns (uint256) {
613         return _balances[account];
614     }
615 
616     function stake(uint256 amount) public {
617         _totalSupply = _totalSupply.add(amount);
618         _balances[msg.sender] = _balances[msg.sender].add(amount);
619         vote.safeTransferFrom(msg.sender, address(this), amount);
620     }
621 
622     function withdraw(uint256 amount) public {
623         _totalSupply = _totalSupply.sub(amount);
624         _balances[msg.sender] = _balances[msg.sender].sub(amount);
625         vote.safeTransfer(msg.sender, amount);
626     }
627 }
628 
629 interface Executor {
630     function execute(uint, uint, uint, uint) external;
631 }
632 
633 contract YearnGovernance is LPTokenWrapper, IRewardDistributionRecipient {
634     
635     /* Fee collection for any other token */
636     
637     function seize(IERC20 _token, uint amount) external {
638         require(msg.sender == governance, "!governance");
639         require(_token != token, "reward");
640         require(_token != vote, "vote");
641         _token.safeTransfer(governance, amount);
642     }
643     
644     /* Fees breaker, to protect withdraws if anything ever goes wrong */
645     
646     bool public breaker = false;
647     
648     function setBreaker(bool _breaker) external {
649         require(msg.sender == governance, "!governance");
650         breaker = _breaker;
651     }
652     
653     /* Modifications for proposals */
654     
655     mapping(address => uint) public voteLock; // period that your sake it locked to keep it for voting
656     
657     struct Proposal {
658         uint id;
659         address proposer;
660         mapping(address => uint) forVotes;
661         mapping(address => uint) againstVotes;
662         uint totalForVotes;
663         uint totalAgainstVotes;
664         uint start; // block start;
665         uint end; // start + period
666         address executor;
667         string hash;
668         uint totalVotesAvailable;
669         uint quorum;
670         uint quorumRequired;
671         bool open;
672     }
673     
674     mapping (uint => Proposal) public proposals;
675     uint public proposalCount;
676     uint public period = 17280; // voting period in blocks ~ 17280 3 days for 15s/block
677     uint public lock = 17280; // vote lock in blocks ~ 17280 3 days for 15s/block
678     uint public minimum = 1e18;
679     uint public quorum = 2000;
680     bool public config = true;
681     
682     
683     address public governance;
684     
685     function setGovernance(address _governance) public {
686         require(msg.sender == governance, "!governance");
687         governance = _governance;
688     }
689     
690     function setQuorum(uint _quorum) public {
691         require(msg.sender == governance, "!governance");
692         quorum = _quorum;
693     }
694     
695     function setMinimum(uint _minimum) public {
696         require(msg.sender == governance, "!governance");
697         minimum = _minimum;
698     }
699     
700     function setPeriod(uint _period) public {
701         require(msg.sender == governance, "!governance");
702         period = _period;
703     }
704     
705     function setLock(uint _lock) public {
706         require(msg.sender == governance, "!governance");
707         lock = _lock;
708     }
709     
710     function initialize(uint id) public {
711         require(config == true, "!config");
712         config = false;
713         proposalCount = id;
714         governance = 0xc487E91aac75D048EeACA7360E479Ae7cCEa0b86;
715     }
716     
717     event NewProposal(uint id, address creator, uint start, uint duration, address executor);
718     event Vote(uint indexed id, address indexed voter, bool vote, uint weight);
719     
720     function propose(address executor, string memory hash) public {
721         require(votesOf(msg.sender) > minimum, "<minimum");
722         proposals[proposalCount++] = Proposal({
723             id: proposalCount,
724             proposer: msg.sender,
725             totalForVotes: 0,
726             totalAgainstVotes: 0,
727             start: block.number,
728             end: period.add(block.number),
729             executor: executor,
730             hash: hash,
731             totalVotesAvailable: totalVotes,
732             quorum: 0,
733             quorumRequired: quorum,
734             open: true
735         });
736         
737         emit NewProposal(proposalCount, msg.sender, block.number, period, executor);
738         voteLock[msg.sender] = lock.add(block.number);
739     }
740     
741     function execute(uint id) public {
742         (uint _for, uint _against, uint _quorum) = getStats(id);
743         require(proposals[id].quorumRequired < _quorum, "!quorum");
744         require(proposals[id].end < block.number , "!end");
745         if (proposals[id].open == true) {
746             tallyVotes(id);
747         }
748         Executor(proposals[id].executor).execute(id, _for, _against, _quorum);
749     }
750     
751     function getStats(uint id) public view returns (uint _for, uint _against, uint _quorum) {
752         _for = proposals[id].totalForVotes;
753         _against = proposals[id].totalAgainstVotes;
754         
755         uint _total = _for.add(_against);
756         _for = _for.mul(10000).div(_total);
757         _against = _against.mul(10000).div(_total);
758         
759         _quorum = _total.mul(10000).div(proposals[id].totalVotesAvailable);
760     }
761     
762     event ProposalFinished(uint indexed id, uint _for, uint _against, bool quorumReached);
763     
764     function tallyVotes(uint id) public {
765         require(proposals[id].open == true, "!open");
766         require(proposals[id].end < block.number, "!end");
767         
768         (uint _for, uint _against,) = getStats(id);
769         bool _quorum = false;
770         if (proposals[id].quorum >= proposals[id].quorumRequired) {
771             _quorum = true;
772         }
773         proposals[id].open = false;
774         emit ProposalFinished(id, _for, _against, _quorum);
775     }
776     
777     function votesOf(address voter) public view returns (uint) {
778         return votes[voter];
779     }
780     
781     uint public totalVotes;
782     mapping(address => uint) public votes;
783     event RegisterVoter(address voter, uint votes, uint totalVotes);
784     event RevokeVoter(address voter, uint votes, uint totalVotes);
785     
786     function register() public {
787         require(voters[msg.sender] == false, "voter");
788         voters[msg.sender] = true;
789         votes[msg.sender] = balanceOf(msg.sender);
790         totalVotes = totalVotes.add(votes[msg.sender]);
791         emit RegisterVoter(msg.sender, votes[msg.sender], totalVotes);
792     }
793     
794     
795     function revoke() public {
796         require(voters[msg.sender] == true, "!voter");
797         voters[msg.sender] = false;
798         if (totalVotes < votes[msg.sender]) {
799             //edge case, should be impossible, but this is defi
800             totalVotes = 0;
801         } else {
802             totalVotes = totalVotes.sub(votes[msg.sender]);
803         }
804         emit RevokeVoter(msg.sender, votes[msg.sender], totalVotes);
805         votes[msg.sender] = 0;
806     }
807     
808     mapping(address => bool) public voters;
809     
810     function voteFor(uint id) public {
811         require(proposals[id].start < block.number , "<start");
812         require(proposals[id].end > block.number , ">end");
813         
814         uint _against = proposals[id].againstVotes[msg.sender];
815         if (_against > 0) {
816             proposals[id].totalAgainstVotes = proposals[id].totalAgainstVotes.sub(_against);
817             proposals[id].againstVotes[msg.sender] = 0;
818         }
819         
820         uint vote = votesOf(msg.sender).sub(proposals[id].forVotes[msg.sender]);
821         proposals[id].totalForVotes = proposals[id].totalForVotes.add(vote);
822         proposals[id].forVotes[msg.sender] = votesOf(msg.sender);
823         
824         proposals[id].totalVotesAvailable = totalVotes;
825         uint _votes = proposals[id].totalForVotes.add(proposals[id].totalAgainstVotes);
826         proposals[id].quorum = _votes.mul(10000).div(totalVotes);
827         
828         voteLock[msg.sender] = lock.add(block.number);
829         
830         emit Vote(id, msg.sender, true, vote);
831     }
832     
833     function voteAgainst(uint id) public {
834         require(proposals[id].start < block.number , "<start");
835         require(proposals[id].end > block.number , ">end");
836         
837         uint _for = proposals[id].forVotes[msg.sender];
838         if (_for > 0) {
839             proposals[id].totalForVotes = proposals[id].totalForVotes.sub(_for);
840             proposals[id].forVotes[msg.sender] = 0;
841         }
842         
843         uint vote = votesOf(msg.sender).sub(proposals[id].againstVotes[msg.sender]);
844         proposals[id].totalAgainstVotes = proposals[id].totalAgainstVotes.add(vote);
845         proposals[id].againstVotes[msg.sender] = votesOf(msg.sender);
846         
847         proposals[id].totalVotesAvailable = totalVotes;
848         uint _votes = proposals[id].totalForVotes.add(proposals[id].totalAgainstVotes);
849         proposals[id].quorum = _votes.mul(10000).div(totalVotes);
850         
851         voteLock[msg.sender] = lock.add(block.number);
852         
853         emit Vote(id, msg.sender, false, vote);
854     }
855     
856     /* Default rewards contract */
857     
858     IERC20 public token = IERC20(0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8);
859     
860     uint256 public constant DURATION = 7 days;
861 
862     uint256 public periodFinish = 0;
863     uint256 public rewardRate = 0;
864     uint256 public lastUpdateTime;
865     uint256 public rewardPerTokenStored;
866     mapping(address => uint256) public userRewardPerTokenPaid;
867     mapping(address => uint256) public rewards;
868 
869     event RewardAdded(uint256 reward);
870     event Staked(address indexed user, uint256 amount);
871     event Withdrawn(address indexed user, uint256 amount);
872     event RewardPaid(address indexed user, uint256 reward);
873 
874     modifier updateReward(address account) {
875         rewardPerTokenStored = rewardPerToken();
876         lastUpdateTime = lastTimeRewardApplicable();
877         if (account != address(0)) {
878             rewards[account] = earned(account);
879             userRewardPerTokenPaid[account] = rewardPerTokenStored;
880         }
881         _;
882     }
883 
884     function lastTimeRewardApplicable() public view returns (uint256) {
885         return Math.min(block.timestamp, periodFinish);
886     }
887 
888     function rewardPerToken() public view returns (uint256) {
889         if (totalSupply() == 0) {
890             return rewardPerTokenStored;
891         }
892         return
893             rewardPerTokenStored.add(
894                 lastTimeRewardApplicable()
895                     .sub(lastUpdateTime)
896                     .mul(rewardRate)
897                     .mul(1e18)
898                     .div(totalSupply())
899             );
900     }
901 
902     function earned(address account) public view returns (uint256) {
903         return
904             balanceOf(account)
905                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
906                 .div(1e18)
907                 .add(rewards[account]);
908     }
909 
910     // stake visibility is public as overriding LPTokenWrapper's stake() function
911     function stake(uint256 amount) public updateReward(msg.sender) {
912         require(amount > 0, "Cannot stake 0");
913         if (voters[msg.sender] == true) {
914             votes[msg.sender] = votes[msg.sender].add(amount);
915             totalVotes = totalVotes.add(amount);
916         }
917         super.stake(amount);
918         emit Staked(msg.sender, amount);
919     }
920 
921     function withdraw(uint256 amount) public updateReward(msg.sender) {
922         require(amount > 0, "Cannot withdraw 0");
923         if (voters[msg.sender] == true) {
924             votes[msg.sender] = votes[msg.sender].sub(amount);
925             totalVotes = totalVotes.sub(amount);
926         }
927         if (breaker == false) {
928             require(voteLock[msg.sender] < block.number,"!locked");
929         }
930         super.withdraw(amount);
931         emit Withdrawn(msg.sender, amount);
932     }
933 
934     function exit() external {
935         withdraw(balanceOf(msg.sender));
936         getReward();
937     }
938 
939     function getReward() public updateReward(msg.sender) {
940         if (breaker == false) {
941             require(voteLock[msg.sender] > block.number,"!voted");
942         }
943         uint256 reward = earned(msg.sender);
944         if (reward > 0) {
945             rewards[msg.sender] = 0;
946             token.safeTransfer(msg.sender, reward);
947             emit RewardPaid(msg.sender, reward);
948         }
949     }
950 
951     function notifyRewardAmount(uint256 reward)
952         external
953         onlyRewardDistribution
954         updateReward(address(0))
955     {
956         IERC20(token).safeTransferFrom(msg.sender, address(this), reward);
957         if (block.timestamp >= periodFinish) {
958             rewardRate = reward.div(DURATION);
959         } else {
960             uint256 remaining = periodFinish.sub(block.timestamp);
961             uint256 leftover = remaining.mul(rewardRate);
962             rewardRate = reward.add(leftover).div(DURATION);
963         }
964         lastUpdateTime = block.timestamp;
965         periodFinish = block.timestamp.add(DURATION);
966         emit RewardAdded(reward);
967     }
968 }