1 pragma solidity 0.5.17;
2 
3 /*
4    ____            __   __        __   _
5   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
6  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
7 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
8      /___/
9 
10 * Synthetix: WARRewards.sol
11 *
12 * Docs: https://docs.synthetix.io/
13 *
14 *
15 * MIT License
16 * ===========
17 *
18 * Copyright (c) 2020 Synthetix
19 *
20 * Permission is hereby granted, free of charge, to any person obtaining a copy
21 * of this software and associated documentation files (the "Software"), to deal
22 * in the Software without restriction, including without limitation the rights
23 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
24 * copies of the Software, and to permit persons to whom the Software is
25 * furnished to do so, subject to the following conditions:
26 *
27 * The above copyright notice and this permission notice shall be included in all
28 * copies or substantial portions of the Software.
29 *
30 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
31 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
32 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
33 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
34 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
35 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
36 */
37 
38 /**
39  * @dev Standard math utilities missing in the Solidity language.
40  */
41 library Math {
42     /**
43      * @dev Returns the largest of two numbers.
44      */
45     function max(uint256 a, uint256 b) internal pure returns (uint256) {
46         return a >= b ? a : b;
47     }
48 
49     /**
50      * @dev Returns the smallest of two numbers.
51      */
52     function min(uint256 a, uint256 b) internal pure returns (uint256) {
53         return a < b ? a : b;
54     }
55 
56     /**
57      * @dev Returns the average of two numbers. The result is rounded towards
58      * zero.
59      */
60     function average(uint256 a, uint256 b) internal pure returns (uint256) {
61         // (a + b) / 2 can overflow, so we distribute
62         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
63     }
64 }
65 
66 /**
67  * @dev Wrappers over Solidity's arithmetic operations with added overflow
68  * checks.
69  *
70  * Arithmetic operations in Solidity wrap on overflow. This can easily result
71  * in bugs, because programmers usually assume that an overflow raises an
72  * error, which is the standard behavior in high level programming languages.
73  * `SafeMath` restores this intuition by reverting the transaction when an
74  * operation overflows.
75  *
76  * Using this library instead of the unchecked operations eliminates an entire
77  * class of bugs, so it's recommended to use it always.
78  */
79 library SafeMath {
80     /**
81      * @dev Returns the addition of two unsigned integers, reverting on
82      * overflow.
83      *
84      * Counterpart to Solidity's `+` operator.
85      *
86      * Requirements:
87      * - Addition cannot overflow.
88      */
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the subtraction of two unsigned integers, reverting on
98      * overflow (when the result is negative).
99      *
100      * Counterpart to Solidity's `-` operator.
101      *
102      * Requirements:
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         return sub(a, b, "SafeMath: subtraction overflow");
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      * - Subtraction cannot overflow.
117      *
118      * _Available since v2.4.0._
119      */
120     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
121         require(b <= a, errorMessage);
122         uint256 c = a - b;
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the multiplication of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `*` operator.
132      *
133      * Requirements:
134      * - Multiplication cannot overflow.
135      */
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
138         // benefit is lost if 'b' is also tested.
139         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
140         if (a == 0) {
141             return 0;
142         }
143 
144         uint256 c = a * b;
145         require(c / a == b, "SafeMath: multiplication overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the integer division of two unsigned integers. Reverts on
152      * division by zero. The result is rounded towards zero.
153      *
154      * Counterpart to Solidity's `/` operator. Note: this function uses a
155      * `revert` opcode (which leaves remaining gas untouched) while Solidity
156      * uses an invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      * - The divisor cannot be zero.
160      */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         return div(a, b, "SafeMath: division by zero");
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      * - The divisor cannot be zero.
175      *
176      * _Available since v2.4.0._
177      */
178     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         // Solidity only automatically asserts when dividing by 0
180         require(b > 0, errorMessage);
181         uint256 c = a / b;
182         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
189      * Reverts when dividing by zero.
190      *
191      * Counterpart to Solidity's `%` operator. This function uses a `revert`
192      * opcode (which leaves remaining gas untouched) while Solidity uses an
193      * invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      * - The divisor cannot be zero.
197      */
198     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
199         return mod(a, b, "SafeMath: modulo by zero");
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts with custom message when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      * - The divisor cannot be zero.
212      *
213      * _Available since v2.4.0._
214      */
215     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
216         require(b != 0, errorMessage);
217         return a % b;
218     }
219 }
220 
221 /*
222  * @dev Provides information about the current execution context, including the
223  * sender of the transaction and its data. While these are generally available
224  * via msg.sender and msg.data, they should not be accessed in such a direct
225  * manner, since when dealing with GSN meta-transactions the account sending and
226  * paying for execution may not be the actual sender (as far as an application
227  * is concerned).
228  *
229  * This contract is only required for intermediate, library-like contracts.
230  */
231 contract Context {
232     // Empty internal constructor, to prevent people from mistakenly deploying
233     // an instance of this contract, which should be used via inheritance.
234     constructor () internal { }
235     // solhint-disable-previous-line no-empty-blocks
236 
237     function _msgSender() internal view returns (address payable) {
238         return msg.sender;
239     }
240 
241     function _msgData() internal view returns (bytes memory) {
242         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
243         return msg.data;
244     }
245 }
246 
247 /**
248  * @dev Contract module which provides a basic access control mechanism, where
249  * there is an account (an owner) that can be granted exclusive access to
250  * specific functions.
251  *
252  * This module is used through inheritance. It will make available the modifier
253  * `onlyOwner`, which can be applied to your functions to restrict their use to
254  * the owner.
255  */
256 contract Ownable is Context {
257     address private _owner;
258 
259     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
260 
261     /**
262      * @dev Initializes the contract setting the deployer as the initial owner.
263      */
264     constructor () internal {
265         _owner = _msgSender();
266         emit OwnershipTransferred(address(0), _owner);
267     }
268 
269     /**
270      * @dev Returns the address of the current owner.
271      */
272     function owner() public view returns (address) {
273         return _owner;
274     }
275 
276     /**
277      * @dev Throws if called by any account other than the owner.
278      */
279     modifier onlyOwner() {
280         require(isOwner(), "Ownable: caller is not the owner");
281         _;
282     }
283 
284     /**
285      * @dev Returns true if the caller is the current owner.
286      */
287     function isOwner() public view returns (bool) {
288         return _msgSender() == _owner;
289     }
290 
291     /**
292      * @dev Leaves the contract without owner. It will not be possible to call
293      * `onlyOwner` functions anymore. Can only be called by the current owner.
294      *
295      * NOTE: Renouncing ownership will leave the contract without an owner,
296      * thereby removing any functionality that is only available to the owner.
297      */
298     function renounceOwnership() public onlyOwner {
299         emit OwnershipTransferred(_owner, address(0));
300         _owner = address(0);
301     }
302 
303     /**
304      * @dev Transfers ownership of the contract to a new account (`newOwner`).
305      * Can only be called by the current owner.
306      */
307     function transferOwnership(address newOwner) public onlyOwner {
308         _transferOwnership(newOwner);
309     }
310 
311     /**
312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
313      */
314     function _transferOwnership(address newOwner) internal {
315         require(newOwner != address(0), "Ownable: new owner is the zero address");
316         emit OwnershipTransferred(_owner, newOwner);
317         _owner = newOwner;
318     }
319 }
320 
321 /**
322  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
323  * the optional functions; to access them see {ERC20Detailed}.
324  */
325 interface IERC20 {
326     /**
327      * @dev Returns the amount of tokens in existence.
328      */
329     function totalSupply() external view returns (uint256);
330 
331     /**
332      * @dev Returns the amount of tokens owned by `account`.
333      */
334     function balanceOf(address account) external view returns (uint256);
335 
336     /**
337      * @dev Moves `amount` tokens from the caller's account to `recipient`.
338      *
339      * Returns a boolean value indicating whether the operation succeeded.
340      *
341      * Emits a {Transfer} event.
342      */
343     function transfer(address recipient, uint256 amount) external returns (bool);
344 
345     /**
346      * @dev Returns the remaining number of tokens that `spender` will be
347      * allowed to spend on behalf of `owner` through {transferFrom}. This is
348      * zero by default.
349      *
350      * This value changes when {approve} or {transferFrom} are called.
351      */
352     function allowance(address owner, address spender) external view returns (uint256);
353 
354     /**
355      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
356      *
357      * Returns a boolean value indicating whether the operation succeeded.
358      *
359      * IMPORTANT: Beware that changing an allowance with this method brings the risk
360      * that someone may use both the old and the new allowance by unfortunate
361      * transaction ordering. One possible solution to mitigate this race
362      * condition is to first reduce the spender's allowance to 0 and set the
363      * desired value afterwards:
364      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
365      *
366      * Emits an {Approval} event.
367      */
368     function approve(address spender, uint256 amount) external returns (bool);
369 
370     /**
371      * @dev Moves `amount` tokens from `sender` to `recipient` using the
372      * allowance mechanism. `amount` is then deducted from the caller's
373      * allowance.
374      *
375      * Returns a boolean value indicating whether the operation succeeded.
376      *
377      * Emits a {Transfer} event.
378      */
379     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
380 
381     /**
382      * @dev Emitted when `value` tokens are moved from one account (`from`) to
383      * another (`to`).
384      *
385      * Note that `value` may be zero.
386      */
387     event Transfer(address indexed from, address indexed to, uint256 value);
388 
389     /**
390      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
391      * a call to {approve}. `value` is the new allowance.
392      */
393     event Approval(address indexed owner, address indexed spender, uint256 value);
394 }
395 
396 
397 /**
398  * @dev Collection of functions related to the address type
399  */
400 library Address {
401     /**
402      * @dev Returns true if `account` is a contract.
403      *
404      * This test is non-exhaustive, and there may be false-negatives: during the
405      * execution of a contract's constructor, its address will be reported as
406      * not containing a contract.
407      *
408      * IMPORTANT: It is unsafe to assume that an address for which this
409      * function returns false is an externally-owned account (EOA) and not a
410      * contract.
411      */
412     function isContract(address account) internal view returns (bool) {
413         // This method relies in extcodesize, which returns 0 for contracts in
414         // construction, since the code is only stored at the end of the
415         // constructor execution.
416 
417         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
418         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
419         // for accounts without code, i.e. `keccak256('')`
420         bytes32 codehash;
421         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
422         // solhint-disable-next-line no-inline-assembly
423         assembly { codehash := extcodehash(account) }
424         return (codehash != 0x0 && codehash != accountHash);
425     }
426 
427     /**
428      * @dev Converts an `address` into `address payable`. Note that this is
429      * simply a type cast: the actual underlying value is not changed.
430      *
431      * _Available since v2.4.0._
432      */
433     function toPayable(address account) internal pure returns (address payable) {
434         return address(uint160(account));
435     }
436 
437     /**
438      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
439      * `recipient`, forwarding all available gas and reverting on errors.
440      *
441      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
442      * of certain opcodes, possibly making contracts go over the 2300 gas limit
443      * imposed by `transfer`, making them unable to receive funds via
444      * `transfer`. {sendValue} removes this limitation.
445      *
446      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
447      *
448      * IMPORTANT: because control is transferred to `recipient`, care must be
449      * taken to not create reentrancy vulnerabilities. Consider using
450      * {ReentrancyGuard} or the
451      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
452      *
453      * _Available since v2.4.0._
454      */
455     function sendValue(address payable recipient, uint256 amount) internal {
456         require(address(this).balance >= amount, "Address: insufficient balance");
457 
458         // solhint-disable-next-line avoid-call-value
459         (bool success, ) = recipient.call.value(amount)("");
460         require(success, "Address: unable to send value, recipient may have reverted");
461     }
462 }
463 
464 
465 
466 /**
467  * @title SafeERC20
468  * @dev Wrappers around ERC20 operations that throw on failure (when the token
469  * contract returns false). Tokens that return no value (and instead revert or
470  * throw on failure) are also supported, non-reverting calls are assumed to be
471  * successful.
472  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
473  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
474  */
475 library SafeERC20 {
476     using SafeMath for uint256;
477     using Address for address;
478 
479     function safeTransfer(IERC20 token, address to, uint256 value) internal {
480         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
481     }
482 
483     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
484         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
485     }
486 
487     function safeApprove(IERC20 token, address spender, uint256 value) internal {
488         // safeApprove should only be called when setting an initial allowance,
489         // or when resetting it to zero. To increase and decrease it, use
490         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
491         // solhint-disable-next-line max-line-length
492         require((value == 0) || (token.allowance(address(this), spender) == 0),
493             "SafeERC20: approve from non-zero to non-zero allowance"
494         );
495         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
496     }
497 
498     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
499         uint256 newAllowance = token.allowance(address(this), spender).add(value);
500         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
501     }
502 
503     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
504         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
505         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
506     }
507 
508     /**
509      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
510      * on the return value: the return value is optional (but if data is returned, it must not be false).
511      * @param token The token targeted by the call.
512      * @param data The call data (encoded using abi.encode or one of its variants).
513      */
514     function callOptionalReturn(IERC20 token, bytes memory data) private {
515         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
516         // we're implementing it ourselves.
517 
518         // A Solidity high level call has three parts:
519         //  1. The target address is checked to verify it contains contract code
520         //  2. The call itself is made, and success asserted
521         //  3. The return value is decoded, which in turn checks the size of the returned data.
522         // solhint-disable-next-line max-line-length
523         require(address(token).isContract(), "SafeERC20: call to non-contract");
524 
525         // solhint-disable-next-line avoid-low-level-calls
526         (bool success, bytes memory returndata) = address(token).call(data);
527         require(success, "SafeERC20: low-level call failed");
528 
529         if (returndata.length > 0) { // Return data is optional
530             // solhint-disable-next-line max-line-length
531             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
532         }
533     }
534 }
535 
536 
537 contract IRewardDistributionRecipient is Ownable {
538     address public rewardDistribution;
539 
540     function notifyRewardAmount(uint256 reward, uint256 _duration) external;
541 
542     modifier onlyRewardDistribution() {
543         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
544         _;
545     }
546 
547     function setRewardDistribution(address _rewardDistribution) external onlyOwner {
548         rewardDistribution = _rewardDistribution;
549     }
550 }
551 
552 contract ElectionBetting is IRewardDistributionRecipient {
553     using SafeMath for uint256;
554     using SafeERC20 for IERC20;
555 
556     enum Candidate {
557         Undecided,
558         Biden,
559         Trump
560     }
561 
562     IERC20 public constant war = IERC20(0xf4A81C18816C9B0AB98FAC51B36Dcb63b0E58Fde);
563 
564     string public constant desc = "US Election 2020 Battle: Biden vs Trump";
565 
566     uint256 public constant endTime = 1604440800;
567     uint256 public constant lastClaimTime = endTime + 1 days * 365 * 0.25;
568 
569     bool public isPaused;
570     bool public isCanceled;
571     bool public isFinal;
572     bool public isFeesClaimed;
573 
574     Candidate public winner;
575 
576     mapping(address => uint256) public bidenETHBet;
577     mapping(address => uint256) public trumpETHBet;
578     mapping(address => uint256) public bidenWARBet;
579     mapping(address => uint256) public trumpWARBet;
580 
581     uint256 public bidenETHPot;
582     uint256 public trumpETHPot;
583     uint256 public bidenWARPot;
584     uint256 public trumpWARPot;
585 
586     event BidenETHBet(address indexed user, uint256 amount);
587     event TrumpETHBet(address indexed user, uint256 amount);
588     event BidenWARBet(address indexed user, uint256 amount);
589     event TrumpWARBet(address indexed user, uint256 amount);
590 
591     event EarningsPaid(address indexed user, uint256 ethEarnings, uint256 warEarnings);
592 
593     modifier checkStatus() {
594         require(!isFinal, "election is decided");
595         require(!isCanceled, "election is canceled, claim your bet");
596         require(!isPaused, "betting not started");
597         require(block.timestamp < endTime, "betting has ended");
598         _;
599     }
600 
601     constructor() public {
602         rewardDistribution = msg.sender;
603     }
604 
605     function ETHBet(Candidate candidate) public payable checkStatus {
606         require(msg.value != 0, "no ether sent");
607         if (candidate == Candidate.Biden) {
608             require(trumpETHBet[msg.sender] == 0, "Sorry. You already bet on Trump with ETH!");
609             bidenETHBet[msg.sender] += msg.value;
610             bidenETHPot += msg.value;
611             emit BidenETHBet(msg.sender, msg.value);
612         } else if (candidate == Candidate.Trump) {
613             require(bidenETHBet[msg.sender] == 0, "Sorry. You already bet on Biden with ETH!");
614             trumpETHBet[msg.sender] += msg.value;
615             trumpETHPot += msg.value;
616             emit TrumpETHBet(msg.sender, msg.value);
617         } else {
618             revert("Come on man! Pick a candidate.");
619         }
620     }
621 
622     function WARBet(Candidate candidate, uint256 amount) public checkStatus {
623         require(amount != 0, "no token sent");
624         if (candidate == Candidate.Biden) {
625             require(trumpWARBet[msg.sender] == 0, "Sorry. You already bet on Trump with WAR!");
626             war.safeTransferFrom(msg.sender, address(this), amount);
627             bidenWARBet[msg.sender] += amount;
628             bidenWARPot += amount;
629             emit BidenWARBet(msg.sender, amount);
630         } else if (candidate == Candidate.Trump) {
631             require(bidenWARBet[msg.sender] == 0, "Sorry. You already bet on Biden with WAR!");
632             war.safeTransferFrom(msg.sender, address(this), amount);
633             trumpWARBet[msg.sender] += amount;
634             trumpWARPot += amount;
635             emit TrumpWARBet(msg.sender, amount);
636         } else {
637             revert("Come on man! Pick a candidate.");
638         }
639     }
640 
641     function pauseBetting() external onlyRewardDistribution {
642         isPaused = true;
643     }
644     function unpauseBetting() external onlyRewardDistribution {
645         isPaused = false;
646     }
647     function cancelElection() external onlyRewardDistribution {
648         require(!isFinal, "election is decided");
649         isCanceled = true;
650     }
651     function finalizeElection(Candidate candidate) external onlyRewardDistribution {
652         require(!isFinal, "election is decided");
653         require(!isCanceled, "election is canceled");
654         require(candidate == Candidate.Biden || candidate == Candidate.Trump, "invalid candidate");
655         winner = candidate;
656         isFinal = true;
657     }
658     function getFees() external onlyRewardDistribution returns (uint256 ethFees, uint256 warFees) {
659         require(!isFeesClaimed, "fees claimed");
660         if (isFinal) {
661             isFeesClaimed = true;
662 
663             if (winner == Candidate.Biden) {
664                 ethFees = trumpETHPot.mul(1e19).div(1e20);
665                 if (ethFees != 0) {
666                     _safeTransfer(ethFees, true);
667                 }
668 
669                 warFees = trumpWARPot.mul(1e19).div(1e20);
670                 if (warFees != 0) {
671                     _safeTransfer(warFees, false);
672                 }
673             } else if (winner == Candidate.Trump) {
674                 ethFees = bidenETHPot.mul(1e19).div(1e20);
675                 if (ethFees != 0) {
676                     _safeTransfer(ethFees, true);
677                 }
678 
679                 warFees = bidenWARPot.mul(1e19).div(1e20);
680                 if (warFees != 0) {
681                     _safeTransfer(warFees, false);
682                 }
683             }
684         }
685     }
686     function rescueFunds(address token) external onlyRewardDistribution {
687         require(block.timestamp >= lastClaimTime, "not allowed yet");
688         if (token == address(0)) {
689             Address.sendValue(msg.sender, address(this).balance);
690         } else {
691             IERC20(token).safeTransfer(msg.sender, IERC20(token).balanceOf(address(this)));
692         }
693     }
694 
695     function earned(address account) public view returns (uint256 ethEarnings, uint256 warEarnings) {
696         if (isFinal) {
697             uint256 _bidenETHBet = bidenETHBet[account];
698             uint256 _trumpETHBet = trumpETHBet[account];
699             uint256 _bidenWARBet = bidenWARBet[account];
700             uint256 _trumpWARBet = trumpWARBet[account];
701             
702             uint256 winnings;
703             uint256 fee;
704 
705             if (winner == Candidate.Biden && _bidenETHBet != 0) {
706                 winnings = trumpETHPot.mul(_bidenETHBet).div(bidenETHPot);
707                 fee = winnings.mul(1e19).div(1e20);
708                 winnings -= fee;
709                 ethEarnings = _bidenETHBet.add(winnings);
710             } else if (winner == Candidate.Trump && _trumpETHBet != 0) {
711                 winnings = bidenETHPot.mul(_trumpETHBet).div(trumpETHPot);
712                 fee = winnings.mul(1e19).div(1e20);
713                 winnings -= fee;
714                 ethEarnings = _trumpETHBet.add(winnings);
715             }
716 
717             if (winner == Candidate.Biden && _bidenWARBet != 0) {
718                 winnings = trumpWARPot.mul(_bidenWARBet).div(bidenWARPot);
719                 fee = winnings.mul(1e19).div(1e20);
720                 winnings -= fee;
721                 warEarnings = _bidenWARBet.add(winnings);
722             } else if (winner == Candidate.Trump && _trumpWARBet != 0) {
723                 winnings = bidenWARPot.mul(_trumpWARBet).div(trumpWARPot);
724                 fee = winnings.mul(1e19).div(1e20);
725                 winnings -= fee;
726                 warEarnings = _trumpWARBet.add(winnings);
727             }
728         } else if (isCanceled) {
729             ethEarnings = bidenETHBet[account] + trumpETHBet[account];
730             warEarnings = bidenWARBet[account] + trumpWARBet[account];
731         }
732     }
733 
734     function getRewards() public {
735         require(isFinal || isCanceled, "election not decided");
736 
737         (uint256 ethEarnings, uint256 warEarnings) = earned(msg.sender);
738         if (ethEarnings != 0) {
739             bidenETHBet[msg.sender] = 0;
740             trumpETHBet[msg.sender] = 0;
741             _safeTransfer(ethEarnings, true);
742         }
743         if (warEarnings != 0) {
744             bidenWARBet[msg.sender] = 0;
745             trumpWARBet[msg.sender] = 0;
746             _safeTransfer(warEarnings, false);
747         }
748         emit EarningsPaid(msg.sender, ethEarnings, warEarnings);
749     }
750 
751     function _safeTransfer(uint256 amount, bool isETH) internal {
752         uint256 balance;
753         if (isETH) {
754             balance = address(this).balance;
755             if (amount > balance) {
756                 amount = balance;
757             }
758             Address.sendValue(msg.sender, amount);
759         } else {
760             balance = war.balanceOf(address(this));
761             if (amount > balance) {
762                 amount = balance;
763             }
764             war.safeTransfer(msg.sender, amount);
765         }
766     }
767 
768     // unused
769     function notifyRewardAmount(uint256 reward, uint256 _duration) external { return; }
770 }