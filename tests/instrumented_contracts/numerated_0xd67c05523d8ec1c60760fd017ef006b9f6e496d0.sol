1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: YAMIncentives.sol
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
38 pragma solidity 0.5.15;
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
70 pragma solidity 0.5.15;
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
229 pragma solidity 0.5.15;
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
259 pragma solidity 0.5.15;
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
337 pragma solidity 0.5.15;
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
362     function mint(address account, uint amount) external;
363 
364     /**
365      * @dev Returns the remaining number of tokens that `spender` will be
366      * allowed to spend on behalf of `owner` through {transferFrom}. This is
367      * zero by default.
368      *
369      * This value changes when {approve} or {transferFrom} are called.
370      */
371     function allowance(address owner, address spender) external view returns (uint256);
372 
373     /**
374      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
375      *
376      * Returns a boolean value indicating whether the operation succeeded.
377      *
378      * IMPORTANT: Beware that changing an allowance with this method brings the risk
379      * that someone may use both the old and the new allowance by unfortunate
380      * transaction ordering. One possible solution to mitigate this race
381      * condition is to first reduce the spender's allowance to 0 and set the
382      * desired value afterwards:
383      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
384      *
385      * Emits an {Approval} event.
386      */
387     function approve(address spender, uint256 amount) external returns (bool);
388 
389     /**
390      * @dev Moves `amount` tokens from `sender` to `recipient` using the
391      * allowance mechanism. `amount` is then deducted from the caller's
392      * allowance.
393      *
394      * Returns a boolean value indicating whether the operation succeeded.
395      *
396      * Emits a {Transfer} event.
397      */
398     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
399 
400     /**
401      * @dev Emitted when `value` tokens are moved from one account (`from`) to
402      * another (`to`).
403      *
404      * Note that `value` may be zero.
405      */
406     event Transfer(address indexed from, address indexed to, uint256 value);
407 
408     /**
409      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
410      * a call to {approve}. `value` is the new allowance.
411      */
412     event Approval(address indexed owner, address indexed spender, uint256 value);
413 }
414 
415 // File: @openzeppelin/contracts/utils/Address.sol
416 
417 pragma solidity 0.5.15;
418 
419 /**
420  * @dev Collection of functions related to the address type
421  */
422 library Address {
423     /**
424      * @dev Returns true if `account` is a contract.
425      *
426      * This test is non-exhaustive, and there may be false-negatives: during the
427      * execution of a contract's constructor, its address will be reported as
428      * not containing a contract.
429      *
430      * IMPORTANT: It is unsafe to assume that an address for which this
431      * function returns false is an externally-owned account (EOA) and not a
432      * contract.
433      */
434     function isContract(address account) internal view returns (bool) {
435         // This method relies in extcodesize, which returns 0 for contracts in
436         // construction, since the code is only stored at the end of the
437         // constructor execution.
438 
439         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
440         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
441         // for accounts without code, i.e. `keccak256('')`
442         bytes32 codehash;
443         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
444         // solhint-disable-next-line no-inline-assembly
445         assembly { codehash := extcodehash(account) }
446         return (codehash != 0x0 && codehash != accountHash);
447     }
448 
449     /**
450      * @dev Converts an `address` into `address payable`. Note that this is
451      * simply a type cast: the actual underlying value is not changed.
452      *
453      * _Available since v2.4.0._
454      */
455     function toPayable(address account) internal pure returns (address payable) {
456         return address(uint160(account));
457     }
458 
459     /**
460      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
461      * `recipient`, forwarding all available gas and reverting on errors.
462      *
463      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
464      * of certain opcodes, possibly making contracts go over the 2300 gas limit
465      * imposed by `transfer`, making them unable to receive funds via
466      * `transfer`. {sendValue} removes this limitation.
467      *
468      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
469      *
470      * IMPORTANT: because control is transferred to `recipient`, care must be
471      * taken to not create reentrancy vulnerabilities. Consider using
472      * {ReentrancyGuard} or the
473      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
474      *
475      * _Available since v2.4.0._
476      */
477     function sendValue(address payable recipient, uint256 amount) internal {
478         require(address(this).balance >= amount, "Address: insufficient balance");
479 
480         // solhint-disable-next-line avoid-call-value
481         (bool success, ) = recipient.call.value(amount)("");
482         require(success, "Address: unable to send value, recipient may have reverted");
483     }
484 }
485 
486 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
487 
488 pragma solidity 0.5.15;
489 
490 
491 
492 
493 /**
494  * @title SafeERC20
495  * @dev Wrappers around ERC20 operations that throw on failure (when the token
496  * contract returns false). Tokens that return no value (and instead revert or
497  * throw on failure) are also supported, non-reverting calls are assumed to be
498  * successful.
499  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
500  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
501  */
502 library SafeERC20 {
503     using SafeMath for uint256;
504     using Address for address;
505 
506     function safeTransfer(IERC20 token, address to, uint256 value) internal {
507         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
508     }
509 
510     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
511         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
512     }
513 
514     function safeApprove(IERC20 token, address spender, uint256 value) internal {
515         // safeApprove should only be called when setting an initial allowance,
516         // or when resetting it to zero. To increase and decrease it, use
517         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
518         // solhint-disable-next-line max-line-length
519         require((value == 0) || (token.allowance(address(this), spender) == 0),
520             "SafeERC20: approve from non-zero to non-zero allowance"
521         );
522         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
523     }
524 
525     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
526         uint256 newAllowance = token.allowance(address(this), spender).add(value);
527         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
528     }
529 
530     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
531         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
532         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
533     }
534 
535     /**
536      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
537      * on the return value: the return value is optional (but if data is returned, it must not be false).
538      * @param token The token targeted by the call.
539      * @param data The call data (encoded using abi.encode or one of its variants).
540      */
541     function callOptionalReturn(IERC20 token, bytes memory data) private {
542         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
543         // we're implementing it ourselves.
544 
545         // A Solidity high level call has three parts:
546         //  1. The target address is checked to verify it contains contract code
547         //  2. The call itself is made, and success asserted
548         //  3. The return value is decoded, which in turn checks the size of the returned data.
549         // solhint-disable-next-line max-line-length
550         require(address(token).isContract(), "SafeERC20: call to non-contract");
551 
552         // solhint-disable-next-line avoid-low-level-calls
553         (bool success, bytes memory returndata) = address(token).call(data);
554         require(success, "SafeERC20: low-level call failed");
555 
556         if (returndata.length > 0) { // Return data is optional
557             // solhint-disable-next-line max-line-length
558             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
559         }
560     }
561 }
562 
563 // File: contracts/IRewardDistributionRecipient.sol
564 
565 pragma solidity 0.5.15;
566 
567 
568 
569 contract IRewardDistributionRecipient is Ownable {
570     address public rewardDistribution;
571 
572     function notifyRewardAmount(uint256 reward) external;
573 
574     modifier onlyRewardDistribution() {
575         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
576         _;
577     }
578 
579     function setRewardDistribution(address _rewardDistribution)
580         external
581         onlyOwner
582     {
583         rewardDistribution = _rewardDistribution;
584     }
585 }
586 
587 // File: contracts/CurveRewards.sol
588 
589 pragma solidity 0.5.15;
590 
591 
592 
593 interface MasterChef {
594     function deposit(uint256, uint256) external;
595     function withdraw(uint256, uint256) external;
596     function emergencyWithdraw(uint256) external;
597 }
598 
599 interface SushiBar {
600     function enter(uint256) external;
601     function leave(uint256) external;
602 }
603 
604 contract LPTokenWrapper is Ownable {
605     using SafeMath for uint256;
606     using SafeERC20 for IERC20;
607 
608     // -- yam things
609     IERC20 public slp = IERC20(0x0F82E57804D0B1F6FAb2370A43dcFAd3c7cB239c);
610     IERC20 public yam = IERC20(0x0AaCfbeC6a24756c20D41914F2caba817C0d8521);
611     address public reserves = address(0x97990B693835da58A281636296D2Bf02787DEa17);
612 
613     // -- Sushi things
614     IERC20 public sushi = IERC20(0x6B3595068778DD592e39A122f4f5a5cF09C90fE2);
615     SushiBar public sushibar = SushiBar(0x8798249c2E607446EfB7Ad49eC89dD1865Ff4272);
616     MasterChef public masterchef = MasterChef(0xc2EdaD668740f1aA35E4D8f227fB8E17dcA888Cd);
617     uint256 public pid = 44; // YAM/ETH pool id
618     bool public chefEmergency;
619 
620     // approve masterchef on initiation
621     constructor () internal {
622         slp.approve(address(masterchef), uint256(-1));
623     }
624 
625     uint256 public minBlockBeforeVoting;
626     bool public minBlockSet;
627 
628     uint256 private _totalSupply;
629 
630     uint256 public constant BASE = 10**18;
631 
632     mapping(address => uint256) private _balances;
633 
634 
635     mapping(address => address) public delegates;
636 
637     /// @notice A checkpoint for marking number of lp tokens staked from a given block
638     struct Checkpoint {
639         uint32 fromBlock;
640         uint256 lpStake;
641     }
642 
643     /// @notice A record of votes checkpoints for each account, by index
644     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
645 
646     /// @notice The number of checkpoints for each account
647     mapping (address => uint32) public numCheckpoints;
648 
649     /// @notice The number of checkpoints for total supply
650     mapping (uint32 => Checkpoint) public totalSupplyCheckpoints;
651 
652     uint32 public numSupplyCheckpoints;
653 
654     function totalSupply() public view returns (uint256) {
655         return _totalSupply;
656     }
657 
658     function balanceOf(address account) public view returns (uint256) {
659         return _balances[account];
660     }
661 
662     function delegate(address delegatee) public {
663         _delegate(msg.sender, delegatee);
664     }
665 
666     function _delegate(address delegator, address delegatee)
667         internal
668     {
669         address currentDelegate = delegates[msg.sender];
670         uint256 delegatorBalance = _balances[msg.sender];
671         delegates[msg.sender] = delegatee;
672 
673         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
674     }
675 
676     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
677         if (srcRep != dstRep && amount > 0) {
678             if (srcRep != address(0)) {
679                 // decrease old representative
680                 uint32 srcRepNum = numCheckpoints[srcRep];
681                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].lpStake : 0;
682                 uint256 srcRepNew = srcRepOld.sub(amount);
683                 _writeCheckpoint(srcRep, srcRepNum, srcRepNew);
684             }
685 
686             if (dstRep != address(0)) {
687                 // increase new representative
688                 uint32 dstRepNum = numCheckpoints[dstRep];
689                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].lpStake : 0;
690                 uint256 dstRepNew = dstRepOld.add(amount);
691                 _writeCheckpoint(dstRep, dstRepNum, dstRepNew);
692             }
693         }
694     }
695 
696 
697     function stake(uint256 amount) public {
698         _totalSupply = _totalSupply.add(amount);
699         uint256 new_bal = _balances[msg.sender].add(amount);
700         _balances[msg.sender] = new_bal;
701         address delegate = delegates[msg.sender];
702         if (delegate == address(0)) {
703           delegates[msg.sender] = msg.sender;
704           delegate = msg.sender;
705         }
706         _moveDelegates(address(0), delegate, amount);
707         _writeSupplyCheckpoint();
708         // deposit here
709         slp.safeTransferFrom(msg.sender, address(this), amount);
710         // deposit to masterchef
711         depositToMasterChef(amount);
712     }
713 
714     function withdraw(uint256 amount) public {
715         _totalSupply = _totalSupply.sub(amount);
716         uint256 new_bal = _balances[msg.sender].sub(amount);
717         _balances[msg.sender] = new_bal;
718         _moveDelegates(delegates[msg.sender], address(0), amount);
719         _writeSupplyCheckpoint();
720         // withdraw from masterchef
721         withdrawFromMasterChef(amount);
722         // send to user
723         slp.safeTransfer(msg.sender, amount);
724     }
725 
726     function depositToMasterChef(uint256 amount) internal {
727         // LP token allowance does not decrease when set to -1
728         if (!chefEmergency) {
729             masterchef.deposit(pid, amount);
730         }
731     }
732 
733     function withdrawFromMasterChef(uint256 amount) internal {
734         if (!chefEmergency) {
735             masterchef.withdraw(pid, amount);
736         }
737     }
738 
739     // callable by anyone, this function sweeps earned rewards into sushibar
740     function sweepToXSushi() public {
741         masterchef.withdraw(pid, 0);
742         uint256 sushi_bal = sushi.balanceOf(address(this));
743         if (sushi.allowance(address(this), address(sushibar)) < sushi_bal) {
744             sushi.approve(address(sushibar), uint256(-1));
745         }
746         sushibar.enter(sushi_bal);
747     }
748 
749     function sushiToReserves(uint256 xsushi_amt) public {
750         require(owner() == msg.sender, "!owner");
751 
752         // if -1, sweep all
753         if (xsushi_amt == uint256(-1)) {
754           xsushi_amt = IERC20(address(sushibar)).balanceOf(address(this));
755         }
756 
757         sushibar.leave(xsushi_amt);
758         sushi.transfer(reserves, sushi.balanceOf(address(this)));
759     }
760 
761     function setReserves(address newReserves) public {
762         require(owner() == msg.sender, "!owner");
763         reserves = newReserves;
764     }
765 
766     function emergencyMasterChefWithdraw() public {
767         require(owner() == msg.sender, "!owner");
768         masterchef.emergencyWithdraw(pid);
769         chefEmergency = true;
770     }
771 
772     function reenableChef() public {
773         require(owner() == msg.sender, "!owner");
774         require(chefEmergency, "!emergency");
775         masterchef.deposit(pid, slp.balanceOf(address(this)));
776         chefEmergency = false;
777     }
778 
779     /**
780      * @notice Gets the current votes balance for `account`
781      * @param account The address to get votes balance
782      * @return The number of current votes for `account`
783      */
784     function getCurrentVotes(address account)
785         external
786         view
787         returns (uint256)
788     {
789         if (!minBlockSet || block.number < minBlockBeforeVoting) {
790             return 0;
791         }
792         uint256 poolVotes = YAM(address(yam)).getCurrentVotes(address(slp));
793         uint32 nCheckpoints = numCheckpoints[account];
794         uint256 lpStake = nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].lpStake : 0;
795         uint256 percOfVotes = lpStake.mul(BASE).div(_totalSupply);
796         return poolVotes.mul(percOfVotes).div(BASE);
797     }
798 
799     function getPriorVotes(address account, uint256 blockNumber)
800         public
801         view
802         returns (uint256)
803     {
804         require(blockNumber < block.number, "Incentivizer::getPriorVotes: not yet determined");
805         if (!minBlockSet || blockNumber < minBlockBeforeVoting) {
806             return 0;
807         }
808         // get incentivizer's uniswap pool yam votes
809         uint256 poolVotes = YAM(address(yam)).getPriorVotes(address(slp), blockNumber);
810 
811         if (poolVotes == 0) {
812             return 0;
813         }
814 
815         // get prior stake
816         uint256 priorStake = _getPriorLPStake(account, blockNumber);
817 
818         if (priorStake == 0) {
819             return 0;
820         }
821 
822         // get prior LP stake
823         uint256 lpTotalSupply = getPriorSupply(blockNumber);
824 
825         if (lpTotalSupply == 0) {
826             return 0;
827         }
828 
829         // get percent ownership of staked LPs
830         uint256 percentOfVote = priorStake.mul(BASE).div(lpTotalSupply);
831 
832         // votes * percentage / percentage max
833         // note: this will overestimate the number of votes based on
834         //       % of LP pool tokens staked here
835         return poolVotes.mul(percentOfVote).div(BASE);
836     }
837 
838     function getPriorLPStake(address account, uint256 blockNumber)
839         public
840         view
841         returns (uint256)
842     {
843         require(blockNumber < block.number, "Incentivizer::_getPriorLPStake: not yet determined");
844         return _getPriorLPStake(account, blockNumber);
845     }
846 
847     function _getPriorLPStake(address account, uint256 blockNumber)
848         internal
849         view
850         returns (uint256)
851     {
852         uint32 nCheckpoints = numCheckpoints[account];
853         if (nCheckpoints == 0) {
854             return 0;
855         }
856 
857         // First check most recent balance
858         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
859             return checkpoints[account][nCheckpoints - 1].lpStake;
860         }
861 
862         // Next check implicit zero balance
863         if (checkpoints[account][0].fromBlock > blockNumber) {
864             return 0;
865         }
866 
867         uint32 lower = 0;
868         uint32 upper = nCheckpoints - 1;
869         while (upper > lower) {
870             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
871             Checkpoint memory cp = checkpoints[account][center];
872             if (cp.fromBlock == blockNumber) {
873                 return cp.lpStake;
874             } else if (cp.fromBlock < blockNumber) {
875                 lower = center;
876             } else {
877                 upper = center - 1;
878             }
879         }
880         return checkpoints[account][lower].lpStake;
881     }
882 
883     function _writeCheckpoint(
884         address delegatee,
885         uint32 nCheckpoints,
886         uint256 newStake
887     )
888         internal
889     {
890         // this means this contract can lock funds in approximately 1766 years from now.
891         uint32 blockNumber = safe32(block.number, "Incentivizer::_writeCheckpoint: block number exceeds 32 bits");
892 
893         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
894             checkpoints[delegatee][nCheckpoints - 1].lpStake = newStake;
895         } else {
896             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newStake);
897             numCheckpoints[delegatee] = nCheckpoints + 1;
898         }
899     }
900 
901     function _writeSupplyCheckpoint()
902         internal
903     {
904         uint32 blockNumber = safe32(block.number, "Incentivizer::_writeSupplyCheckpoint: block number exceeds 32 bits");
905 
906         // overwrite totalSupplyCheckpoint for block, increment counter if needed
907         if (numSupplyCheckpoints > 0 && totalSupplyCheckpoints[numSupplyCheckpoints - 1].fromBlock == blockNumber) {
908             totalSupplyCheckpoints[numSupplyCheckpoints - 1].lpStake = _totalSupply;
909         } else {
910             totalSupplyCheckpoints[numSupplyCheckpoints] = Checkpoint(blockNumber, _totalSupply);
911             numSupplyCheckpoints += 1;
912         }
913     }
914 
915     function getPriorSupply(uint256 blockNumber)
916         public
917         view
918         returns (uint256)
919     {
920         if (numSupplyCheckpoints == 0) {
921             return 0;
922         }
923 
924         // First check most recent balance
925         if (totalSupplyCheckpoints[numSupplyCheckpoints - 1].fromBlock <= blockNumber) {
926             return totalSupplyCheckpoints[numSupplyCheckpoints - 1].lpStake;
927         }
928 
929         // Next check implicit zero balance
930         if (totalSupplyCheckpoints[0].fromBlock > blockNumber) {
931             return 0;
932         }
933 
934         uint32 lower = 0;
935         uint32 upper = numSupplyCheckpoints - 1;
936         while (upper > lower) {
937             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
938             Checkpoint memory cp = totalSupplyCheckpoints[center];
939             if (cp.fromBlock == blockNumber) {
940                 return cp.lpStake;
941             } else if (cp.fromBlock < blockNumber) {
942                 lower = center;
943             } else {
944                 upper = center - 1;
945             }
946         }
947         return totalSupplyCheckpoints[lower].lpStake;
948     }
949 
950     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
951         require(n < 2**32, errorMessage);
952         return uint32(n);
953     }
954 
955     function setMinBlockBeforeVoting(uint256 blockNum)
956         external
957     {
958         // only gov
959         require(msg.sender == owner(), "!governance");
960         require(!minBlockSet, "minBlockSet");
961         minBlockBeforeVoting = blockNum;
962         minBlockSet = true;
963     }
964 }
965 
966 interface YAM {
967     function yamsScalingFactor() external returns (uint256);
968     function mint(address to, uint256 amount) external;
969     function getPriorVotes(address account, uint256 blockNumber) external view returns (uint256);
970     function getCurrentVotes(address account) external view returns (uint256);
971 }
972 
973 contract YAMIncentivizerWithVoting is LPTokenWrapper, IRewardDistributionRecipient {
974     uint256 public constant DURATION = 7 days;
975 
976     uint256 public initreward = 5000 * 10**18; // 5000 yams
977     uint256 public starttime = 1605204000; //  Thursday, November 12, 2020 18:00:00 GMT
978 
979     uint256 public periodFinish = 0;
980     uint256 public rewardRate = 0;
981     uint256 public lastUpdateTime;
982     uint256 public rewardPerTokenStored;
983 
984     bool public initialized = false;
985     bool public breaker;
986 
987 
988     mapping(address => uint256) public userRewardPerTokenPaid;
989     mapping(address => uint256) public rewards;
990 
991 
992     event RewardAdded(uint256 reward);
993     event Staked(address indexed user, uint256 amount);
994     event Withdrawn(address indexed user, uint256 amount);
995     event RewardPaid(address indexed user, uint256 reward);
996 
997     modifier updateReward(address account) {
998         rewardPerTokenStored = rewardPerToken();
999         lastUpdateTime = lastTimeRewardApplicable();
1000         if (account != address(0)) {
1001             rewards[account] = earned(account);
1002             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1003         }
1004         _;
1005     }
1006 
1007     function lastTimeRewardApplicable() public view returns (uint256) {
1008         return Math.max(starttime, Math.min(block.timestamp, periodFinish));
1009     }
1010 
1011     function rewardPerToken() public view returns (uint256) {
1012         if (totalSupply() == 0) {
1013             return rewardPerTokenStored;
1014         }
1015         return
1016             rewardPerTokenStored.add(
1017                 lastTimeRewardApplicable()
1018                     .sub(lastUpdateTime)
1019                     .mul(rewardRate)
1020                     .mul(1e18)
1021                     .div(totalSupply())
1022             );
1023     }
1024 
1025     function earned(address account) public view returns (uint256) {
1026         return
1027             balanceOf(account)
1028                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
1029                 .div(1e18)
1030                 .add(rewards[account]);
1031     }
1032 
1033     // stake visibility is public as overriding LPTokenWrapper's stake() function
1034     function stake(uint256 amount) public updateReward(msg.sender) checkhalve {
1035         require(amount > 0, "Cannot stake 0");
1036         super.stake(amount);
1037         emit Staked(msg.sender, amount);
1038     }
1039 
1040     function withdraw(uint256 amount) public updateReward(msg.sender) {
1041         require(amount > 0, "Cannot withdraw 0");
1042         super.withdraw(amount);
1043         emit Withdrawn(msg.sender, amount);
1044     }
1045 
1046     function exit() external {
1047         withdraw(balanceOf(msg.sender));
1048         getReward();
1049     }
1050 
1051     function getReward() public updateReward(msg.sender) checkhalve {
1052         uint256 reward = rewards[msg.sender];
1053         if (reward > 0) {
1054             rewards[msg.sender] = 0;
1055             uint256 scalingFactor = YAM(address(yam)).yamsScalingFactor();
1056             uint256 trueReward = reward.mul(scalingFactor).div(10**18);
1057             yam.safeTransfer(msg.sender, trueReward);
1058             emit RewardPaid(msg.sender, trueReward);
1059         }
1060     }
1061 
1062     modifier checkhalve() {
1063         if (breaker) {
1064           // do nothing
1065         } else if (block.timestamp >= periodFinish && initialized) {
1066             /* initreward = initreward.mul(90).div(100); */ // static 5k per week
1067             uint256 scalingFactor = YAM(address(yam)).yamsScalingFactor();
1068             uint256 newRewards = initreward.mul(scalingFactor).div(10**18);
1069             yam.mint(address(this), newRewards);
1070             lastUpdateTime = block.timestamp;
1071             rewardRate = initreward.div(DURATION);
1072             periodFinish = block.timestamp.add(DURATION);
1073             emit RewardAdded(newRewards);
1074         }
1075         _;
1076     }
1077 
1078     function notifyRewardAmount(uint256 reward)
1079         external
1080         onlyRewardDistribution
1081         updateReward(address(0))
1082     {
1083         // https://sips.synthetix.io/sips/sip-77
1084         // increased buffer for scaling factor ( supports up to 10**4 * 10**18 scaling factor)
1085         require(reward < uint256(-1) / 10**22, "rewards too large, would lock");
1086         if (block.timestamp > starttime && initialized) {
1087           if (block.timestamp >= periodFinish) {
1088               rewardRate = reward.div(DURATION);
1089           } else {
1090               uint256 remaining = periodFinish.sub(block.timestamp);
1091               uint256 leftover = remaining.mul(rewardRate);
1092               rewardRate = reward.add(leftover).div(DURATION);
1093           }
1094           lastUpdateTime = block.timestamp;
1095           periodFinish = block.timestamp.add(DURATION);
1096           uint256 scalingFactor = YAM(address(yam)).yamsScalingFactor();
1097           uint256 newRewards = reward.mul(scalingFactor).div(10**18);
1098           emit RewardAdded(newRewards);
1099         } else {
1100           // increased buffer for scaling factor
1101           require(initreward < uint256(-1) / 10**22, "rewards too large, would lock");
1102           require(!initialized, "already initialized");
1103           initialized = true;
1104           uint256 scalingFactor = YAM(address(yam)).yamsScalingFactor();
1105           uint256 newRewards = initreward.mul(scalingFactor).div(10**18);
1106           yam.mint(address(this), newRewards);
1107           rewardRate = initreward.div(DURATION);
1108           lastUpdateTime = starttime;
1109           periodFinish = starttime.add(DURATION);
1110           emit RewardAdded(newRewards);
1111         }
1112     }
1113 
1114 
1115     // This function allows governance to take unsupported tokens out of the
1116     // contract, since this one exists longer than the other pools.
1117     // This is in an effort to make someone whole, should they seriously
1118     // mess up. There is no guarantee governance will vote to return these.
1119     // It also allows for removal of airdropped tokens.
1120     function rescueTokens(IERC20 _token, uint256 amount, address to)
1121         external
1122     {
1123         // only gov
1124         require(msg.sender == owner(), "!governance");
1125         // cant take staked asset
1126         require(_token != slp, "slp");
1127         // cant take reward asset
1128         require(_token != yam, "yam");
1129 
1130         // transfer to
1131         _token.safeTransfer(to, amount);
1132     }
1133 
1134     function setBreaker(bool breaker_)
1135         external
1136     {
1137         // only gov
1138         require(msg.sender == owner(), "!governance");
1139         breaker = breaker_;
1140     }
1141 }