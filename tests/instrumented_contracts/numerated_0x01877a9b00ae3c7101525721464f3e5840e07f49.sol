1 /**
2 --- THIS IS THE ERROR/BONUS POOL ---
3 
4 Link marines the time has finally come. Presenting YFLink governance token:
5 
6 #     # ####### #
7  #   #  #       #       # #    # #    #     #  ####
8   # #   #       #       # ##   # #   #      # #    #
9    #    #####   #       # # #  # ####       # #    #
10    #    #       #       # #  # # #  #   ### # #    #
11    #    #       #       # #   ## #   #  ### # #    #
12    #    #       ####### # #    # #    # ### #  ####
13 
14 
15 ######                                            #
16 #     # #  ####  #####  #        ##   #   #      # #   #####    ##   #####  #####   ##   #####  # #      # ##### #   #
17 #     # # #      #    # #       #  #   # #      #   #  #    #  #  #  #    #   #    #  #  #    # # #      #   #    # #
18 #     # #  ####  #    # #      #    #   #      #     # #    # #    # #    #   #   #    # #####  # #      #   #     #
19 #     # #      # #####  #      ######   #      ####### #    # ###### #####    #   ###### #    # # #      #   #     #
20 #     # # #    # #      #      #    #   #      #     # #    # #    # #        #   #    # #    # # #      #   #     #
21 ######  #  ####  #      ###### #    #   #      #     # #####  #    # #        #   #    # #####  # ###### #   #     #
22 
23 
24 This code was forked from Andre Cronje's YFI and modified.
25 It has not been audited and may contain bugs - be warned.
26 Similarly as YFI, it has zero initial supply and has zero financial value.
27 There is no sale of it either, it can only be minted by staking Link.
28 
29 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
30 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
31 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
32 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
33 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
34 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
35 SOFTWARE.
36 
37 
38    ____            __   __        __   _
39   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
40  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
41 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
42      /___/
43 
44 * Docs: https://docs.synthetix.io/
45 *
46 *
47 * MIT License
48 * ===========
49 *
50 * Copyright (c) 2020 Synthetix
51 *
52 * Permission is hereby granted, free of charge, to any person obtaining a copy
53 * of this software and associated documentation files (the "Software"), to deal
54 * in the Software without restriction, including without limitation the rights
55 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
56 * copies of the Software, and to permit persons to whom the Software is
57 * furnished to do so, subject to the following conditions:
58 *
59 * The above copyright notice and this permission notice shall be included in all
60 * copies or substantial portions of the Software.
61 *
62 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
63 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
64 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
65 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
66 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
67 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
68 */
69 
70 // File: @openzeppelin/contracts/math/Math.sol
71 
72 pragma solidity ^0.5.0;
73 
74 /**
75  * @dev Standard math utilities missing in the Solidity language.
76  */
77 library Math {
78     /**
79      * @dev Returns the largest of two numbers.
80      */
81     function max(uint256 a, uint256 b) internal pure returns (uint256) {
82         return a >= b ? a : b;
83     }
84 
85     /**
86      * @dev Returns the smallest of two numbers.
87      */
88     function min(uint256 a, uint256 b) internal pure returns (uint256) {
89         return a < b ? a : b;
90     }
91 
92     /**
93      * @dev Returns the average of two numbers. The result is rounded towards
94      * zero.
95      */
96     function average(uint256 a, uint256 b) internal pure returns (uint256) {
97         // (a + b) / 2 can overflow, so we distribute
98         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
99     }
100 }
101 
102 // File: @openzeppelin/contracts/math/SafeMath.sol
103 
104 pragma solidity ^0.5.0;
105 
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `+` operator.
125      *
126      * Requirements:
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      * - Subtraction cannot overflow.
157      *
158      * _Available since v2.4.0._
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         return div(a, b, "SafeMath: division by zero");
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      * - The divisor cannot be zero.
215      *
216      * _Available since v2.4.0._
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         // Solidity only automatically asserts when dividing by 0
220         require(b > 0, errorMessage);
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      * - The divisor cannot be zero.
252      *
253      * _Available since v2.4.0._
254      */
255     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b != 0, errorMessage);
257         return a % b;
258     }
259 }
260 
261 // File: @openzeppelin/contracts/GSN/Context.sol
262 
263 pragma solidity ^0.5.0;
264 
265 /*
266  * @dev Provides information about the current execution context, including the
267  * sender of the transaction and its data. While these are generally available
268  * via msg.sender and msg.data, they should not be accessed in such a direct
269  * manner, since when dealing with GSN meta-transactions the account sending and
270  * paying for execution may not be the actual sender (as far as an application
271  * is concerned).
272  *
273  * This contract is only required for intermediate, library-like contracts.
274  */
275 contract Context {
276     // Empty internal constructor, to prevent people from mistakenly deploying
277     // an instance of this contract, which should be used via inheritance.
278     constructor () internal { }
279     // solhint-disable-previous-line no-empty-blocks
280 
281     function _msgSender() internal view returns (address payable) {
282         return msg.sender;
283     }
284 
285     function _msgData() internal view returns (bytes memory) {
286         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
287         return msg.data;
288     }
289 }
290 
291 // File: @openzeppelin/contracts/ownership/Ownable.sol
292 
293 pragma solidity ^0.5.0;
294 
295 /**
296  * @dev Contract module which provides a basic access control mechanism, where
297  * there is an account (an owner) that can be granted exclusive access to
298  * specific functions.
299  *
300  * This module is used through inheritance. It will make available the modifier
301  * `onlyOwner`, which can be applied to your functions to restrict their use to
302  * the owner.
303  */
304 contract Ownable is Context {
305     address private _owner;
306 
307     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
308 
309     /**
310      * @dev Initializes the contract setting the deployer as the initial owner.
311      */
312     constructor () internal {
313         _owner = _msgSender();
314         emit OwnershipTransferred(address(0), _owner);
315     }
316 
317     /**
318      * @dev Returns the address of the current owner.
319      */
320     function owner() public view returns (address) {
321         return _owner;
322     }
323 
324     /**
325      * @dev Throws if called by any account other than the owner.
326      */
327     modifier onlyOwner() {
328         require(isOwner(), "Ownable: caller is not the owner");
329         _;
330     }
331 
332     /**
333      * @dev Returns true if the caller is the current owner.
334      */
335     function isOwner() public view returns (bool) {
336         return _msgSender() == _owner;
337     }
338 
339     /**
340      * @dev Leaves the contract without owner. It will not be possible to call
341      * `onlyOwner` functions anymore. Can only be called by the current owner.
342      *
343      * NOTE: Renouncing ownership will leave the contract without an owner,
344      * thereby removing any functionality that is only available to the owner.
345      */
346     function renounceOwnership() public onlyOwner {
347         emit OwnershipTransferred(_owner, address(0));
348         _owner = address(0);
349     }
350 
351     /**
352      * @dev Transfers ownership of the contract to a new account (`newOwner`).
353      * Can only be called by the current owner.
354      */
355     function transferOwnership(address newOwner) public onlyOwner {
356         _transferOwnership(newOwner);
357     }
358 
359     /**
360      * @dev Transfers ownership of the contract to a new account (`newOwner`).
361      */
362     function _transferOwnership(address newOwner) internal {
363         require(newOwner != address(0), "Ownable: new owner is the zero address");
364         emit OwnershipTransferred(_owner, newOwner);
365         _owner = newOwner;
366     }
367 }
368 
369 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
370 
371 pragma solidity ^0.5.0;
372 
373 /**
374  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
375  * the optional functions; to access them see {ERC20Detailed}.
376  */
377 interface IERC20 {
378     /**
379      * @dev Returns the amount of tokens in existence.
380      */
381     function totalSupply() external view returns (uint256);
382 
383     /**
384      * @dev Returns the amount of tokens owned by `account`.
385      */
386     function balanceOf(address account) external view returns (uint256);
387 
388     /**
389      * @dev Moves `amount` tokens from the caller's account to `recipient`.
390      *
391      * Returns a boolean value indicating whether the operation succeeded.
392      *
393      * Emits a {Transfer} event.
394      */
395     function transfer(address recipient, uint256 amount) external returns (bool);
396 
397 
398     function mint(address account, uint amount) external;
399 
400     /**
401      * @dev Returns the remaining number of tokens that `spender` will be
402      * allowed to spend on behalf of `owner` through {transferFrom}. This is
403      * zero by default.
404      *
405      * This value changes when {approve} or {transferFrom} are called.
406      */
407     function allowance(address owner, address spender) external view returns (uint256);
408 
409     /**
410      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
411      *
412      * Returns a boolean value indicating whether the operation succeeded.
413      *
414      * IMPORTANT: Beware that changing an allowance with this method brings the risk
415      * that someone may use both the old and the new allowance by unfortunate
416      * transaction ordering. One possible solution to mitigate this race
417      * condition is to first reduce the spender's allowance to 0 and set the
418      * desired value afterwards:
419      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
420      *
421      * Emits an {Approval} event.
422      */
423     function approve(address spender, uint256 amount) external returns (bool);
424 
425     /**
426      * @dev Moves `amount` tokens from `sender` to `recipient` using the
427      * allowance mechanism. `amount` is then deducted from the caller's
428      * allowance.
429      *
430      * Returns a boolean value indicating whether the operation succeeded.
431      *
432      * Emits a {Transfer} event.
433      */
434     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
435 
436     /**
437      * @dev Emitted when `value` tokens are moved from one account (`from`) to
438      * another (`to`).
439      *
440      * Note that `value` may be zero.
441      */
442     event Transfer(address indexed from, address indexed to, uint256 value);
443 
444     /**
445      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
446      * a call to {approve}. `value` is the new allowance.
447      */
448     event Approval(address indexed owner, address indexed spender, uint256 value);
449 }
450 
451 // File: @openzeppelin/contracts/utils/Address.sol
452 
453 pragma solidity ^0.5.5;
454 
455 /**
456  * @dev Collection of functions related to the address type
457  */
458 library Address {
459     /**
460      * @dev Returns true if `account` is a contract.
461      *
462      * This test is non-exhaustive, and there may be false-negatives: during the
463      * execution of a contract's constructor, its address will be reported as
464      * not containing a contract.
465      *
466      * IMPORTANT: It is unsafe to assume that an address for which this
467      * function returns false is an externally-owned account (EOA) and not a
468      * contract.
469      */
470     function isContract(address account) internal view returns (bool) {
471         // This method relies in extcodesize, which returns 0 for contracts in
472         // construction, since the code is only stored at the end of the
473         // constructor execution.
474 
475         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
476         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
477         // for accounts without code, i.e. `keccak256('')`
478         bytes32 codehash;
479         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
480         // solhint-disable-next-line no-inline-assembly
481         assembly { codehash := extcodehash(account) }
482         return (codehash != 0x0 && codehash != accountHash);
483     }
484 
485     /**
486      * @dev Converts an `address` into `address payable`. Note that this is
487      * simply a type cast: the actual underlying value is not changed.
488      *
489      * _Available since v2.4.0._
490      */
491     function toPayable(address account) internal pure returns (address payable) {
492         return address(uint160(account));
493     }
494 
495     /**
496      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
497      * `recipient`, forwarding all available gas and reverting on errors.
498      *
499      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
500      * of certain opcodes, possibly making contracts go over the 2300 gas limit
501      * imposed by `transfer`, making them unable to receive funds via
502      * `transfer`. {sendValue} removes this limitation.
503      *
504      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
505      *
506      * IMPORTANT: because control is transferred to `recipient`, care must be
507      * taken to not create reentrancy vulnerabilities. Consider using
508      * {ReentrancyGuard} or the
509      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
510      *
511      * _Available since v2.4.0._
512      */
513     function sendValue(address payable recipient, uint256 amount) internal {
514         require(address(this).balance >= amount, "Address: insufficient balance");
515 
516         // solhint-disable-next-line avoid-call-value
517         (bool success, ) = recipient.call.value(amount)("");
518         require(success, "Address: unable to send value, recipient may have reverted");
519     }
520 }
521 
522 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
523 
524 pragma solidity ^0.5.0;
525 
526 
527 
528 
529 /**
530  * @title SafeERC20
531  * @dev Wrappers around ERC20 operations that throw on failure (when the token
532  * contract returns false). Tokens that return no value (and instead revert or
533  * throw on failure) are also supported, non-reverting calls are assumed to be
534  * successful.
535  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
536  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
537  */
538 library SafeERC20 {
539     using SafeMath for uint256;
540     using Address for address;
541 
542     function safeTransfer(IERC20 token, address to, uint256 value) internal {
543         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
544     }
545 
546     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
547         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
548     }
549 
550     function safeApprove(IERC20 token, address spender, uint256 value) internal {
551         // safeApprove should only be called when setting an initial allowance,
552         // or when resetting it to zero. To increase and decrease it, use
553         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
554         // solhint-disable-next-line max-line-length
555         require((value == 0) || (token.allowance(address(this), spender) == 0),
556             "SafeERC20: approve from non-zero to non-zero allowance"
557         );
558         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
559     }
560 
561     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
562         uint256 newAllowance = token.allowance(address(this), spender).add(value);
563         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
564     }
565 
566     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
567         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
568         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
569     }
570 
571     /**
572      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
573      * on the return value: the return value is optional (but if data is returned, it must not be false).
574      * @param token The token targeted by the call.
575      * @param data The call data (encoded using abi.encode or one of its variants).
576      */
577     function callOptionalReturn(IERC20 token, bytes memory data) private {
578         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
579         // we're implementing it ourselves.
580 
581         // A Solidity high level call has three parts:
582         //  1. The target address is checked to verify it contains contract code
583         //  2. The call itself is made, and success asserted
584         //  3. The return value is decoded, which in turn checks the size of the returned data.
585         // solhint-disable-next-line max-line-length
586         require(address(token).isContract(), "SafeERC20: call to non-contract");
587 
588         // solhint-disable-next-line avoid-low-level-calls
589         (bool success, bytes memory returndata) = address(token).call(data);
590         require(success, "SafeERC20: low-level call failed");
591 
592         if (returndata.length > 0) { // Return data is optional
593             // solhint-disable-next-line max-line-length
594             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
595         }
596     }
597 }
598 
599 // File: contracts/CurveRewards.sol
600 
601 pragma solidity ^0.5.0;
602 
603 contract LPTokenWrapper {
604     using SafeMath for uint256;
605     using SafeERC20 for IERC20;
606     using Address for address;
607 
608     IERC20 public bpt = IERC20(0x8194EFab90A290b987616F687Bc380b041A2Cc25);
609 
610     uint256 private _totalSupply;
611     mapping(address => uint256) private _balances;
612 
613     function totalSupply() public view returns (uint256) {
614         return _totalSupply;
615     }
616 
617     function balanceOf(address account) public view returns (uint256) {
618         return _balances[account];
619     }
620 
621     function stake(uint256 amount) public {
622         address staker = msg.sender;
623         require(!staker.isContract() && tx.origin == staker, "contracts speed bump");
624         _totalSupply = _totalSupply.add(amount);
625         _balances[staker] = _balances[staker].add(amount);
626         bpt.safeTransferFrom(staker, address(this), amount);
627     }
628 
629     function withdraw(uint256 amount) public {
630         _totalSupply = _totalSupply.sub(amount);
631         _balances[msg.sender] = _balances[msg.sender].sub(amount);
632         bpt.safeTransfer(msg.sender, amount);
633     }
634 }
635 
636 contract YFLinkBalancerYCRVRewards is LPTokenWrapper, Ownable {
637 
638     IERC20 public yflink = IERC20(0x28cb7e841ee97947a86B06fA4090C8451f64c0be);
639     uint256 public constant DURATION = 7 days;
640 
641     uint256 public initReward = 10000*1e18;
642     bool public lastWeek = false;
643     uint256 public startTime = 1597240800; //08/12/2020 @ 2:00pm (UTC)
644     bool public started = false;
645     uint256 public periodFinish = 0;
646     uint256 public rewardRate = 0;
647     uint256 public lastUpdateTime;
648     uint256 public rewardPerTokenStored;
649     mapping(address => uint256) public userRewardPerTokenPaid;
650     mapping(address => uint256) public rewards;
651 
652     event RewardAdded(uint256 reward);
653     event Staked(address indexed user, uint256 amount);
654     event Withdrawn(address indexed user, uint256 amount);
655     event RewardPaid(address indexed user, uint256 reward);
656 
657     modifier updateReward(address account) {
658         rewardPerTokenStored = rewardPerToken();
659         lastUpdateTime = lastTimeRewardApplicable();
660         if (account != address(0)) {
661             rewards[account] = earned(account);
662             userRewardPerTokenPaid[account] = rewardPerTokenStored;
663         }
664         _;
665     }
666 
667     //can be called by anyone
668     function start() public {
669         require(now >= startTime, "not ready yet");
670         require(!started, "already started");
671         started = true;
672         startTime = now;
673         notifyRewardAmount(initReward);
674     }
675 
676     function lastTimeRewardApplicable() public view returns (uint256) {
677         return Math.min(block.timestamp, periodFinish);
678     }
679 
680     function rewardPerToken() public view returns (uint256) {
681         if (totalSupply() == 0) {
682             return rewardPerTokenStored;
683         }
684         return
685         rewardPerTokenStored.add(
686             lastTimeRewardApplicable()
687             .sub(lastUpdateTime)
688             .mul(rewardRate)
689             .mul(1e18)
690             .div(totalSupply())
691         );
692     }
693 
694     function earned(address account) public view returns (uint256) {
695         return
696         balanceOf(account)
697         .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
698         .div(1e18)
699         .add(rewards[account]);
700     }
701 
702     // stake visibility is public as overriding LPTokenWrapper's stake() function
703     function stake(uint256 amount) public updateReward(msg.sender) checkNewRewards {
704         require(amount > 0, "Cannot stake 0");
705         super.stake(amount);
706         emit Staked(msg.sender, amount);
707     }
708 
709     function withdraw(uint256 amount) public updateReward(msg.sender) checkNewRewards {
710         require(amount > 0, "Cannot withdraw 0");
711         super.withdraw(amount);
712         emit Withdrawn(msg.sender, amount);
713     }
714 
715     function exit() external {
716         withdraw(balanceOf(msg.sender));
717         getReward();
718     }
719 
720     function getReward() public updateReward(msg.sender) checkNewRewards {
721         uint256 reward = earned(msg.sender);
722         if (reward > 0) {
723             rewards[msg.sender] = 0;
724             yflink.safeTransfer(msg.sender, reward);
725             emit RewardPaid(msg.sender, reward);
726         }
727     }
728 
729     modifier checkNewRewards() {
730         if (startTime > 0 && !lastWeek && block.timestamp >= periodFinish) {
731             lastWeek = true;
732             initReward = initReward.mul(50).div(100);
733             notifyRewardAmount(initReward);
734         }
735         _;
736     }
737 
738     function notifyRewardAmount(uint256 reward) internal updateReward(address(0)) {
739         if (block.timestamp >= periodFinish) {
740             rewardRate = reward.div(DURATION);
741         } else {
742             uint256 remaining = periodFinish.sub(block.timestamp);
743             uint256 leftover = remaining.mul(rewardRate);
744             rewardRate = reward.add(leftover).div(DURATION);
745         }
746         yflink.mint(address(this), reward);
747         lastUpdateTime = block.timestamp;
748         periodFinish = block.timestamp.add(DURATION);
749         emit RewardAdded(reward);
750     }
751 
752 
753     function withdrawOther(IERC20 token) external onlyOwner {
754         require(token != yflink, "cannot withdraw YFLink");
755         require(token != bpt, "cannot withdraw BPT");
756 
757         token.safeTransfer(msg.sender, token.balanceOf(address(this)));
758     }
759 
760 }