1 /**
2 
3 Link marines the time has finally come. Presenting YFLink governance token:
4 
5 #     # ####### #
6  #   #  #       #       # #    # #    #     #  ####
7   # #   #       #       # ##   # #   #      # #    #
8    #    #####   #       # # #  # ####       # #    #
9    #    #       #       # #  # # #  #   ### # #    #
10    #    #       #       # #   ## #   #  ### # #    #
11    #    #       ####### # #    # #    # ### #  ####
12 
13 
14 ######                                            #
15 #     # #  ####  #####  #        ##   #   #      # #   #####    ##   #####  #####   ##   #####  # #      # ##### #   #
16 #     # # #      #    # #       #  #   # #      #   #  #    #  #  #  #    #   #    #  #  #    # # #      #   #    # #
17 #     # #  ####  #    # #      #    #   #      #     # #    # #    # #    #   #   #    # #####  # #      #   #     #
18 #     # #      # #####  #      ######   #      ####### #    # ###### #####    #   ###### #    # # #      #   #     #
19 #     # # #    # #      #      #    #   #      #     # #    # #    # #        #   #    # #    # # #      #   #     #
20 ######  #  ####  #      ###### #    #   #      #     # #####  #    # #        #   #    # #####  # ###### #   #     #
21 
22 
23 This code was forked from Andre Cronje's YFI and modified.
24 It has not been audited and may contain bugs - be warned.
25 Similarly as YFI, it has zero initial supply and has zero financial value.
26 There is no sale of it either, it can only be minted by staking Link.
27 
28 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
31 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
34 SOFTWARE.
35 
36 
37    ____            __   __        __   _
38   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
39  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
40 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
41      /___/
42 
43 * Docs: https://docs.synthetix.io/
44 *
45 *
46 * MIT License
47 * ===========
48 *
49 * Copyright (c) 2020 Synthetix
50 *
51 * Permission is hereby granted, free of charge, to any person obtaining a copy
52 * of this software and associated documentation files (the "Software"), to deal
53 * in the Software without restriction, including without limitation the rights
54 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
55 * copies of the Software, and to permit persons to whom the Software is
56 * furnished to do so, subject to the following conditions:
57 *
58 * The above copyright notice and this permission notice shall be included in all
59 * copies or substantial portions of the Software.
60 *
61 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
62 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
63 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
64 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
65 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
66 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
67 */
68 
69 // File: @openzeppelin/contracts/math/Math.sol
70 
71 pragma solidity ^0.5.0;
72 
73 /**
74  * @dev Standard math utilities missing in the Solidity language.
75  */
76 library Math {
77     /**
78      * @dev Returns the largest of two numbers.
79      */
80     function max(uint256 a, uint256 b) internal pure returns (uint256) {
81         return a >= b ? a : b;
82     }
83 
84     /**
85      * @dev Returns the smallest of two numbers.
86      */
87     function min(uint256 a, uint256 b) internal pure returns (uint256) {
88         return a < b ? a : b;
89     }
90 
91     /**
92      * @dev Returns the average of two numbers. The result is rounded towards
93      * zero.
94      */
95     function average(uint256 a, uint256 b) internal pure returns (uint256) {
96         // (a + b) / 2 can overflow, so we distribute
97         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
98     }
99 }
100 
101 // File: @openzeppelin/contracts/math/SafeMath.sol
102 
103 pragma solidity ^0.5.0;
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         return sub(a, b, "SafeMath: subtraction overflow");
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      * - Subtraction cannot overflow.
156      *
157      * _Available since v2.4.0._
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      * - Multiplication cannot overflow.
174      */
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
177         // benefit is lost if 'b' is also tested.
178         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
179         if (a == 0) {
180             return 0;
181         }
182 
183         uint256 c = a * b;
184         require(c / a == b, "SafeMath: multiplication overflow");
185 
186         return c;
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      * - The divisor cannot be zero.
214      *
215      * _Available since v2.4.0._
216      */
217     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
218         // Solidity only automatically asserts when dividing by 0
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         return mod(a, b, "SafeMath: modulo by zero");
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts with custom message when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      * - The divisor cannot be zero.
251      *
252      * _Available since v2.4.0._
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 // File: @openzeppelin/contracts/GSN/Context.sol
261 
262 pragma solidity ^0.5.0;
263 
264 /*
265  * @dev Provides information about the current execution context, including the
266  * sender of the transaction and its data. While these are generally available
267  * via msg.sender and msg.data, they should not be accessed in such a direct
268  * manner, since when dealing with GSN meta-transactions the account sending and
269  * paying for execution may not be the actual sender (as far as an application
270  * is concerned).
271  *
272  * This contract is only required for intermediate, library-like contracts.
273  */
274 contract Context {
275     // Empty internal constructor, to prevent people from mistakenly deploying
276     // an instance of this contract, which should be used via inheritance.
277     constructor () internal { }
278     // solhint-disable-previous-line no-empty-blocks
279 
280     function _msgSender() internal view returns (address payable) {
281         return msg.sender;
282     }
283 
284     function _msgData() internal view returns (bytes memory) {
285         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
286         return msg.data;
287     }
288 }
289 
290 // File: @openzeppelin/contracts/ownership/Ownable.sol
291 
292 pragma solidity ^0.5.0;
293 
294 /**
295  * @dev Contract module which provides a basic access control mechanism, where
296  * there is an account (an owner) that can be granted exclusive access to
297  * specific functions.
298  *
299  * This module is used through inheritance. It will make available the modifier
300  * `onlyOwner`, which can be applied to your functions to restrict their use to
301  * the owner.
302  */
303 contract Ownable is Context {
304     address private _owner;
305 
306     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
307 
308     /**
309      * @dev Initializes the contract setting the deployer as the initial owner.
310      */
311     constructor () internal {
312         _owner = _msgSender();
313         emit OwnershipTransferred(address(0), _owner);
314     }
315 
316     /**
317      * @dev Returns the address of the current owner.
318      */
319     function owner() public view returns (address) {
320         return _owner;
321     }
322 
323     /**
324      * @dev Throws if called by any account other than the owner.
325      */
326     modifier onlyOwner() {
327         require(isOwner(), "Ownable: caller is not the owner");
328         _;
329     }
330 
331     /**
332      * @dev Returns true if the caller is the current owner.
333      */
334     function isOwner() public view returns (bool) {
335         return _msgSender() == _owner;
336     }
337 
338     /**
339      * @dev Leaves the contract without owner. It will not be possible to call
340      * `onlyOwner` functions anymore. Can only be called by the current owner.
341      *
342      * NOTE: Renouncing ownership will leave the contract without an owner,
343      * thereby removing any functionality that is only available to the owner.
344      */
345     function renounceOwnership() public onlyOwner {
346         emit OwnershipTransferred(_owner, address(0));
347         _owner = address(0);
348     }
349 
350     /**
351      * @dev Transfers ownership of the contract to a new account (`newOwner`).
352      * Can only be called by the current owner.
353      */
354     function transferOwnership(address newOwner) public onlyOwner {
355         _transferOwnership(newOwner);
356     }
357 
358     /**
359      * @dev Transfers ownership of the contract to a new account (`newOwner`).
360      */
361     function _transferOwnership(address newOwner) internal {
362         require(newOwner != address(0), "Ownable: new owner is the zero address");
363         emit OwnershipTransferred(_owner, newOwner);
364         _owner = newOwner;
365     }
366 }
367 
368 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
369 
370 pragma solidity ^0.5.0;
371 
372 /**
373  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
374  * the optional functions; to access them see {ERC20Detailed}.
375  */
376 interface IERC20 {
377     /**
378      * @dev Returns the amount of tokens in existence.
379      */
380     function totalSupply() external view returns (uint256);
381 
382     /**
383      * @dev Returns the amount of tokens owned by `account`.
384      */
385     function balanceOf(address account) external view returns (uint256);
386 
387     /**
388      * @dev Moves `amount` tokens from the caller's account to `recipient`.
389      *
390      * Returns a boolean value indicating whether the operation succeeded.
391      *
392      * Emits a {Transfer} event.
393      */
394     function transfer(address recipient, uint256 amount) external returns (bool);
395 
396 
397     function mint(address account, uint amount) external;
398 
399     /**
400      * @dev Returns the remaining number of tokens that `spender` will be
401      * allowed to spend on behalf of `owner` through {transferFrom}. This is
402      * zero by default.
403      *
404      * This value changes when {approve} or {transferFrom} are called.
405      */
406     function allowance(address owner, address spender) external view returns (uint256);
407 
408     /**
409      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
410      *
411      * Returns a boolean value indicating whether the operation succeeded.
412      *
413      * IMPORTANT: Beware that changing an allowance with this method brings the risk
414      * that someone may use both the old and the new allowance by unfortunate
415      * transaction ordering. One possible solution to mitigate this race
416      * condition is to first reduce the spender's allowance to 0 and set the
417      * desired value afterwards:
418      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
419      *
420      * Emits an {Approval} event.
421      */
422     function approve(address spender, uint256 amount) external returns (bool);
423 
424     /**
425      * @dev Moves `amount` tokens from `sender` to `recipient` using the
426      * allowance mechanism. `amount` is then deducted from the caller's
427      * allowance.
428      *
429      * Returns a boolean value indicating whether the operation succeeded.
430      *
431      * Emits a {Transfer} event.
432      */
433     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
434 
435     /**
436      * @dev Emitted when `value` tokens are moved from one account (`from`) to
437      * another (`to`).
438      *
439      * Note that `value` may be zero.
440      */
441     event Transfer(address indexed from, address indexed to, uint256 value);
442 
443     /**
444      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
445      * a call to {approve}. `value` is the new allowance.
446      */
447     event Approval(address indexed owner, address indexed spender, uint256 value);
448 }
449 
450 // File: @openzeppelin/contracts/utils/Address.sol
451 
452 pragma solidity ^0.5.5;
453 
454 /**
455  * @dev Collection of functions related to the address type
456  */
457 library Address {
458     /**
459      * @dev Returns true if `account` is a contract.
460      *
461      * This test is non-exhaustive, and there may be false-negatives: during the
462      * execution of a contract's constructor, its address will be reported as
463      * not containing a contract.
464      *
465      * IMPORTANT: It is unsafe to assume that an address for which this
466      * function returns false is an externally-owned account (EOA) and not a
467      * contract.
468      */
469     function isContract(address account) internal view returns (bool) {
470         // This method relies in extcodesize, which returns 0 for contracts in
471         // construction, since the code is only stored at the end of the
472         // constructor execution.
473 
474         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
475         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
476         // for accounts without code, i.e. `keccak256('')`
477         bytes32 codehash;
478         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
479         // solhint-disable-next-line no-inline-assembly
480         assembly { codehash := extcodehash(account) }
481         return (codehash != 0x0 && codehash != accountHash);
482     }
483 
484     /**
485      * @dev Converts an `address` into `address payable`. Note that this is
486      * simply a type cast: the actual underlying value is not changed.
487      *
488      * _Available since v2.4.0._
489      */
490     function toPayable(address account) internal pure returns (address payable) {
491         return address(uint160(account));
492     }
493 
494     /**
495      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
496      * `recipient`, forwarding all available gas and reverting on errors.
497      *
498      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
499      * of certain opcodes, possibly making contracts go over the 2300 gas limit
500      * imposed by `transfer`, making them unable to receive funds via
501      * `transfer`. {sendValue} removes this limitation.
502      *
503      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
504      *
505      * IMPORTANT: because control is transferred to `recipient`, care must be
506      * taken to not create reentrancy vulnerabilities. Consider using
507      * {ReentrancyGuard} or the
508      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
509      *
510      * _Available since v2.4.0._
511      */
512     function sendValue(address payable recipient, uint256 amount) internal {
513         require(address(this).balance >= amount, "Address: insufficient balance");
514 
515         // solhint-disable-next-line avoid-call-value
516         (bool success, ) = recipient.call.value(amount)("");
517         require(success, "Address: unable to send value, recipient may have reverted");
518     }
519 }
520 
521 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
522 
523 pragma solidity ^0.5.0;
524 
525 
526 
527 
528 /**
529  * @title SafeERC20
530  * @dev Wrappers around ERC20 operations that throw on failure (when the token
531  * contract returns false). Tokens that return no value (and instead revert or
532  * throw on failure) are also supported, non-reverting calls are assumed to be
533  * successful.
534  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
535  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
536  */
537 library SafeERC20 {
538     using SafeMath for uint256;
539     using Address for address;
540 
541     function safeTransfer(IERC20 token, address to, uint256 value) internal {
542         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
543     }
544 
545     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
546         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
547     }
548 
549     function safeApprove(IERC20 token, address spender, uint256 value) internal {
550         // safeApprove should only be called when setting an initial allowance,
551         // or when resetting it to zero. To increase and decrease it, use
552         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
553         // solhint-disable-next-line max-line-length
554         require((value == 0) || (token.allowance(address(this), spender) == 0),
555             "SafeERC20: approve from non-zero to non-zero allowance"
556         );
557         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
558     }
559 
560     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
561         uint256 newAllowance = token.allowance(address(this), spender).add(value);
562         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
563     }
564 
565     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
566         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
567         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
568     }
569 
570     /**
571      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
572      * on the return value: the return value is optional (but if data is returned, it must not be false).
573      * @param token The token targeted by the call.
574      * @param data The call data (encoded using abi.encode or one of its variants).
575      */
576     function callOptionalReturn(IERC20 token, bytes memory data) private {
577         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
578         // we're implementing it ourselves.
579 
580         // A Solidity high level call has three parts:
581         //  1. The target address is checked to verify it contains contract code
582         //  2. The call itself is made, and success asserted
583         //  3. The return value is decoded, which in turn checks the size of the returned data.
584         // solhint-disable-next-line max-line-length
585         require(address(token).isContract(), "SafeERC20: call to non-contract");
586 
587         // solhint-disable-next-line avoid-low-level-calls
588         (bool success, bytes memory returndata) = address(token).call(data);
589         require(success, "SafeERC20: low-level call failed");
590 
591         if (returndata.length > 0) { // Return data is optional
592             // solhint-disable-next-line max-line-length
593             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
594         }
595     }
596 }
597 
598 // File: contracts/CurveRewards.sol
599 
600 pragma solidity ^0.5.0;
601 
602 contract LPTokenWrapper {
603     using SafeMath for uint256;
604     using SafeERC20 for IERC20;
605     using Address for address;
606 
607     IERC20 public bpt = IERC20(0x8194EFab90A290b987616F687Bc380b041A2Cc25);
608 
609     uint256 private _totalSupply;
610     mapping(address => uint256) private _balances;
611 
612     function totalSupply() public view returns (uint256) {
613         return _totalSupply;
614     }
615 
616     function balanceOf(address account) public view returns (uint256) {
617         return _balances[account];
618     }
619 
620     function stake(uint256 amount) public {
621         address staker = msg.sender;
622         require(!staker.isContract() && tx.origin == staker, "contracts speed bump");
623         _totalSupply = _totalSupply.add(amount);
624         _balances[staker] = _balances[staker].add(amount);
625         bpt.safeTransferFrom(staker, address(this), amount);
626     }
627 
628     function withdraw(uint256 amount) public {
629         _totalSupply = _totalSupply.sub(amount);
630         _balances[msg.sender] = _balances[msg.sender].sub(amount);
631         bpt.safeTransfer(msg.sender, amount);
632     }
633 }
634 
635 contract YFLinkBalancerYCRVRewards is LPTokenWrapper, Ownable {
636 
637     IERC20 public yflink = IERC20(0x28cb7e841ee97947a86B06fA4090C8451f64c0be);
638     uint256 public constant DURATION = 7 days;
639 
640     uint256 public initReward = 10000*1e18;
641     bool public lastWeek = false;
642     uint256 public startTime = 1597240800; //08/12/2020 @ 2:00pm (UTC)
643     bool public started = false;
644     uint256 public periodFinish = 0;
645     uint256 public rewardRate = 0;
646     uint256 public lastUpdateTime;
647     uint256 public rewardPerTokenStored;
648     mapping(address => uint256) public userRewardPerTokenPaid;
649     mapping(address => uint256) public rewards;
650 
651     event RewardAdded(uint256 reward);
652     event Staked(address indexed user, uint256 amount);
653     event Withdrawn(address indexed user, uint256 amount);
654     event RewardPaid(address indexed user, uint256 reward);
655 
656     modifier updateReward(address account) {
657         rewardPerTokenStored = rewardPerToken();
658         lastUpdateTime = lastTimeRewardApplicable();
659         if (account != address(0)) {
660             rewards[account] = earned(account);
661             userRewardPerTokenPaid[account] = rewardPerTokenStored;
662         }
663         _;
664     }
665 
666     modifier checkNewRewards() {
667         if (startTime > 0 && !lastWeek && block.timestamp >= periodFinish) {
668             lastWeek = true;
669             initReward = initReward.mul(50).div(100);
670             notifyRewardAmount(initReward);
671         }
672         _;
673     }
674 
675     modifier checkStart(){
676         require(now >= startTime, "not ready yet");
677         _;
678     }
679 
680     //can be called by anyone
681     function start() public checkStart {
682         require(!started, "already started");
683         started = true;
684         startTime = now;
685         notifyRewardAmount(initReward);
686     }
687 
688     function lastTimeRewardApplicable() public view returns (uint256) {
689         return Math.min(block.timestamp, periodFinish);
690     }
691 
692     function rewardPerToken() public view returns (uint256) {
693         if (totalSupply() == 0) {
694             return rewardPerTokenStored;
695         }
696         return
697         rewardPerTokenStored.add(
698             lastTimeRewardApplicable()
699             .sub(lastUpdateTime)
700             .mul(rewardRate)
701             .mul(1e18)
702             .div(totalSupply())
703         );
704     }
705 
706     function earned(address account) public view returns (uint256) {
707         return
708         balanceOf(account)
709         .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
710         .div(1e18)
711         .add(rewards[account]);
712     }
713 
714     // stake visibility is public as overriding LPTokenWrapper's stake() function
715     function stake(uint256 amount) public updateReward(msg.sender) checkNewRewards checkStart {
716         require(amount > 0, "Cannot stake 0");
717         super.stake(amount);
718         emit Staked(msg.sender, amount);
719     }
720 
721     function withdraw(uint256 amount) public updateReward(msg.sender) checkNewRewards checkStart {
722         require(amount > 0, "Cannot withdraw 0");
723         super.withdraw(amount);
724         emit Withdrawn(msg.sender, amount);
725     }
726 
727     function exit() external {
728         withdraw(balanceOf(msg.sender));
729         getReward();
730     }
731 
732     function getReward() public updateReward(msg.sender) checkNewRewards checkStart {
733         uint256 reward = earned(msg.sender);
734         if (reward > 0) {
735             rewards[msg.sender] = 0;
736             yflink.safeTransfer(msg.sender, reward);
737             emit RewardPaid(msg.sender, reward);
738         }
739     }
740 
741     function notifyRewardAmount(uint256 reward) internal updateReward(address(0)) {
742         if (block.timestamp >= periodFinish) {
743             rewardRate = reward.div(DURATION);
744         } else {
745             uint256 remaining = periodFinish.sub(block.timestamp);
746             uint256 leftover = remaining.mul(rewardRate);
747             rewardRate = reward.add(leftover).div(DURATION);
748         }
749         yflink.mint(address(this), reward);
750         lastUpdateTime = block.timestamp;
751         periodFinish = block.timestamp.add(DURATION);
752         emit RewardAdded(reward);
753     }
754 
755 
756     function withdrawOther(IERC20 token) external onlyOwner {
757         require(token != yflink, "cannot withdraw YFLink");
758         require(token != bpt, "cannot withdraw BPT");
759 
760         token.safeTransfer(msg.sender, token.balanceOf(address(this)));
761     }
762 
763 }