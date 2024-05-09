1 /*
2 
3 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
4 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@'~~~     ~~~`@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
5 @@@@@@@@@@@@@@@@@@@@@@@@'                     `@@@@@@@@@@@@@@@@@@@@@@@@@@@@
6 @@@@@@@@@@@@@@@@@@@@@'                           `@@@@@@@@@@@@@@@@@@@@@@@@@
7 @@@@@@@@@@@@@@@@@@@'                               `@@@@@@@@@@@@@@@@@@@@@@@
8 @@@@@@@@@@@@@@@@@'                                   `@@@@@@@@@@@@@@@@@@@@@
9 @@@@@@@@@@@@@@@@'                                     `@@@@@@@@@@@@@@@@@@@@
10 @@@@@@@@@@@@@@@'                                       `@@@@@@@@@@@@@@@@@@@
11 @@@@@@@@@@@@@@@                                         @@@@@@@@@@@@@@@@@@@
12 @@@@@@@@@@@@@@'                                         `@@@@@@@@@@@@@@@@@@
13 @@@@@@@@@@@@@@                                           @@@@@@@@@@@@@@@@@@
14 @@@@@@@@@@@@@@                                           @@@@@@@@@@@@@@@@@@
15 @@@@@@@@@@@@@@                       n,                  @@@@@@@@@@@@@@@@@@
16 @@@@@@@@@@@@@@                     _/ | _                @@@@@@@@@@@@@@@@@@
17 @@@@@@@@@@@@@@                    /'  `'/                @@@@@@@@@@@@@@@@@@
18 @@@@@@@@@@@@@@a                 <~    .'                a@@@@@@@@@@@@@@@@@@
19 @@@@@@@@@@@@@@@                 .'    |                 @@@@@@@@@@@@@@@@@@@
20 @@@@@@@@@@@@@@@a              _/      |                a@@@@@@@@@@@@@@@@@@@
21 @@@@@@@@@@@@@@@@a           _/      `.`.              a@@@@@@@@@@@@@@@@@@@@
22 @@@@@@@@@@@@@@@@@a     ____/ '   \__ | |______       a@@@@@@@@@@@@@@@@@@@@@
23 @@@@@@@@@@@@@@@@@@@a__/___/      /__\ \ \     \___.a@@@@@@@@@@@@@@@@@@@@@@@
24 @@@@@@@@@@@@@@@@@@@/  (___.'\_______)\_|_|        \@@@@@@@@@@@@@@@@@@@@@@@@
25 @@@@@@@@@@@@@@@@@@|\________                       ~~~~~\@@@@@@@@@@@@@@@@@@
26 ~~~\@@@@@@@@@@@@@@||       |\___________________________/|@/~~~~~~~~~~~\@@@
27     |~~~~\@@@@@@@/ |  |    | |           | ||\____________|@@
28 
29 ------------------------------------------------
30 Thank you for visiting https://asciiart.website/
31 This ASCII pic can be found at
32 https://asciiart.website/index.php?art=animals/wolves
33 
34 
35    ____            __   __        __   _
36   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
37  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
38 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
39      /___/
40 
41 * Synthetix: VAMPRewards.sol
42 *
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
68 pragma solidity ^0.5.17;
69 
70 /**
71  * @dev Standard math utilities missing in the Solidity language.
72  */
73 library Math {
74     /**
75      * @dev Returns the largest of two numbers.
76      */
77     function max(uint256 a, uint256 b) internal pure returns (uint256) {
78         return a >= b ? a : b;
79     }
80 
81     /**
82      * @dev Returns the smallest of two numbers.
83      */
84     function min(uint256 a, uint256 b) internal pure returns (uint256) {
85         return a < b ? a : b;
86     }
87 
88     /**
89      * @dev Returns the average of two numbers. The result is rounded towards
90      * zero.
91      */
92     function average(uint256 a, uint256 b) internal pure returns (uint256) {
93         // (a + b) / 2 can overflow, so we distribute
94         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
95     }
96 }
97 
98 // File: @openzeppelin/contracts/math/SafeMath.sol
99 
100 /**
101  * @dev Wrappers over Solidity's arithmetic operations with added overflow
102  * checks.
103  *
104  * Arithmetic operations in Solidity wrap on overflow. This can easily result
105  * in bugs, because programmers usually assume that an overflow raises an
106  * error, which is the standard behavior in high level programming languages.
107  * `SafeMath` restores this intuition by reverting the transaction when an
108  * operation overflows.
109  *
110  * Using this library instead of the unchecked operations eliminates an entire
111  * class of bugs, so it's recommended to use it always.
112  */
113 library SafeMath {
114     /**
115      * @dev Returns the addition of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `+` operator.
119      *
120      * Requirements:
121      * - Addition cannot overflow.
122      */
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         uint256 c = a + b;
125         require(c >= a, "SafeMath: addition overflow");
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140         return sub(a, b, "SafeMath: subtraction overflow");
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      * - Subtraction cannot overflow.
151      *
152      * _Available since v2.4.0._
153      */
154     function sub(
155         uint256 a,
156         uint256 b,
157         string memory errorMessage
158     ) internal pure returns (uint256) {
159         require(b <= a, errorMessage);
160         uint256 c = a - b;
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements:
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         return div(a, b, "SafeMath: division by zero");
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      * - The divisor cannot be zero.
213      *
214      * _Available since v2.4.0._
215      */
216     function div(
217         uint256 a,
218         uint256 b,
219         string memory errorMessage
220     ) internal pure returns (uint256) {
221         // Solidity only automatically asserts when dividing by 0
222         require(b > 0, errorMessage);
223         uint256 c = a / b;
224         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts with custom message when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      * - The divisor cannot be zero.
254      *
255      * _Available since v2.4.0._
256      */
257     function mod(
258         uint256 a,
259         uint256 b,
260         string memory errorMessage
261     ) internal pure returns (uint256) {
262         require(b != 0, errorMessage);
263         return a % b;
264     }
265 }
266 
267 // File: @openzeppelin/contracts/GSN/Context.sol
268 
269 /*
270  * @dev Provides information about the current execution context, including the
271  * sender of the transaction and its data. While these are generally available
272  * via msg.sender and msg.data, they should not be accessed in such a direct
273  * manner, since when dealing with GSN meta-transactions the account sending and
274  * paying for execution may not be the actual sender (as far as an application
275  * is concerned).
276  *
277  * This contract is only required for intermediate, library-like contracts.
278  */
279 contract Context {
280     // Empty internal constructor, to prevent people from mistakenly deploying
281     // an instance of this contract, which should be used via inheritance.
282     constructor() internal {}
283 
284     // solhint-disable-previous-line no-empty-blocks
285 
286     function _msgSender() internal view returns (address payable) {
287         return msg.sender;
288     }
289 
290     function _msgData() internal view returns (bytes memory) {
291         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
292         return msg.data;
293     }
294 }
295 
296 // File: @openzeppelin/contracts/ownership/Ownable.sol
297 
298 /**
299  * @dev Contract module which provides a basic access control mechanism, where
300  * there is an account (an owner) that can be granted exclusive access to
301  * specific functions.
302  *
303  * This module is used through inheritance. It will make available the modifier
304  * `onlyOwner`, which can be applied to your functions to restrict their use to
305  * the owner.
306  */
307 contract Ownable is Context {
308     address private _owner;
309 
310     event OwnershipTransferred(
311         address indexed previousOwner,
312         address indexed newOwner
313     );
314 
315     /**
316      * @dev Initializes the contract setting the deployer as the initial owner.
317      */
318     constructor() internal {
319         _owner = _msgSender();
320         emit OwnershipTransferred(address(0), _owner);
321     }
322 
323     /**
324      * @dev Returns the address of the current owner.
325      */
326     function owner() public view returns (address) {
327         return _owner;
328     }
329 
330     /**
331      * @dev Throws if called by any account other than the owner.
332      */
333     modifier onlyOwner() {
334         require(isOwner(), "Ownable: caller is not the owner");
335         _;
336     }
337 
338     /**
339      * @dev Returns true if the caller is the current owner.
340      */
341     function isOwner() public view returns (bool) {
342         return _msgSender() == _owner;
343     }
344 
345     /**
346      * @dev Leaves the contract without owner. It will not be possible to call
347      * `onlyOwner` functions anymore. Can only be called by the current owner.
348      *
349      * NOTE: Renouncing ownership will leave the contract without an owner,
350      * thereby removing any functionality that is only available to the owner.
351      */
352     function renounceOwnership() public onlyOwner {
353         emit OwnershipTransferred(_owner, address(0));
354         _owner = address(0);
355     }
356 
357     /**
358      * @dev Transfers ownership of the contract to a new account (`newOwner`).
359      * Can only be called by the current owner.
360      */
361     function transferOwnership(address newOwner) public onlyOwner {
362         _transferOwnership(newOwner);
363     }
364 
365     /**
366      * @dev Transfers ownership of the contract to a new account (`newOwner`).
367      */
368     function _transferOwnership(address newOwner) internal {
369         require(
370             newOwner != address(0),
371             "Ownable: new owner is the zero address"
372         );
373         emit OwnershipTransferred(_owner, newOwner);
374         _owner = newOwner;
375     }
376 }
377 
378 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
379 
380 pragma solidity ^0.5.0;
381 
382 /**
383  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
384  * the optional functions; to access them see {ERC20Detailed}.
385  */
386 interface IERC20 {
387     function mint(address account, uint256 amount) external;
388 
389     /**
390      * @dev Returns the amount of tokens in existence.
391      */
392     function totalSupply() external view returns (uint256);
393 
394     /**
395      * @dev Returns the amount of tokens owned by `account`.
396      */
397     function balanceOf(address account) external view returns (uint256);
398 
399     /**
400      * @dev Moves `amount` tokens from the caller's account to `recipient`.
401      *
402      * Returns a boolean value indicating whether the operation succeeded.
403      *
404      * Emits a {Transfer} event.
405      */
406     function transfer(address recipient, uint256 amount)
407         external
408         returns (bool);
409 
410     /**
411      * @dev Returns the remaining number of tokens that `spender` will be
412      * allowed to spend on behalf of `owner` through {transferFrom}. This is
413      * zero by default.
414      *
415      * This value changes when {approve} or {transferFrom} are called.
416      */
417     function allowance(address owner, address spender)
418         external
419         view
420         returns (uint256);
421 
422     /**
423      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
424      *
425      * Returns a boolean value indicating whether the operation succeeded.
426      *
427      * IMPORTANT: Beware that changing an allowance with this method brings the risk
428      * that someone may use both the old and the new allowance by unfortunate
429      * transaction ordering. One possible solution to mitigate this race
430      * condition is to first reduce the spender's allowance to 0 and set the
431      * desired value afterwards:
432      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
433      *
434      * Emits an {Approval} event.
435      */
436     function approve(address spender, uint256 amount) external returns (bool);
437 
438     /**
439      * @dev Moves `amount` tokens from `sender` to `recipient` using the
440      * allowance mechanism. `amount` is then deducted from the caller's
441      * allowance.
442      *
443      * Returns a boolean value indicating whether the operation succeeded.
444      *
445      * Emits a {Transfer} event.
446      */
447     function transferFrom(
448         address sender,
449         address recipient,
450         uint256 amount
451     ) external returns (bool);
452 
453     /**
454      * @dev Emitted when `value` tokens are moved from one account (`from`) to
455      * another (`to`).
456      *
457      * Note that `value` may be zero.
458      */
459     event Transfer(address indexed from, address indexed to, uint256 value);
460 
461     /**
462      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
463      * a call to {approve}. `value` is the new allowance.
464      */
465     event Approval(
466         address indexed owner,
467         address indexed spender,
468         uint256 value
469     );
470 }
471 
472 // File: @openzeppelin/contracts/utils/Address.sol
473 
474 pragma solidity ^0.5.5;
475 
476 /**
477  * @dev Collection of functions related to the address type
478  */
479 library Address {
480     /**
481      * @dev Returns true if `account` is a contract.
482      *
483      * This test is non-exhaustive, and there may be false-negatives: during the
484      * execution of a contract's constructor, its address will be reported as
485      * not containing a contract.
486      *
487      * IMPORTANT: It is unsafe to assume that an address for which this
488      * function returns false is an externally-owned account (EOA) and not a
489      * contract.
490      */
491     function isContract(address account) internal view returns (bool) {
492         // This method relies in extcodesize, which returns 0 for contracts in
493         // construction, since the code is only stored at the end of the
494         // constructor execution.
495 
496         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
497         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
498         // for accounts without code, i.e. `keccak256('')`
499         bytes32 codehash;
500 
501             bytes32 accountHash
502          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
503         // solhint-disable-next-line no-inline-assembly
504         assembly {
505             codehash := extcodehash(account)
506         }
507         return (codehash != 0x0 && codehash != accountHash);
508     }
509 
510     /**
511      * @dev Converts an `address` into `address payable`. Note that this is
512      * simply a type cast: the actual underlying value is not changed.
513      *
514      * _Available since v2.4.0._
515      */
516     function toPayable(address account)
517         internal
518         pure
519         returns (address payable)
520     {
521         return address(uint160(account));
522     }
523 
524     /**
525      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
526      * `recipient`, forwarding all available gas and reverting on errors.
527      *
528      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
529      * of certain opcodes, possibly making contracts go over the 2300 gas limit
530      * imposed by `transfer`, making them unable to receive funds via
531      * `transfer`. {sendValue} removes this limitation.
532      *
533      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
534      *
535      * IMPORTANT: because control is transferred to `recipient`, care must be
536      * taken to not create reentrancy vulnerabilities. Consider using
537      * {ReentrancyGuard} or the
538      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
539      *
540      * _Available since v2.4.0._
541      */
542     function sendValue(address payable recipient, uint256 amount) internal {
543         require(
544             address(this).balance >= amount,
545             "Address: insufficient balance"
546         );
547 
548         // solhint-disable-next-line avoid-call-value
549         (bool success, ) = recipient.call.value(amount)("");
550         require(
551             success,
552             "Address: unable to send value, recipient may have reverted"
553         );
554     }
555 }
556 
557 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
558 
559 pragma solidity ^0.5.0;
560 
561 /**
562  * @title SafeERC20
563  * @dev Wrappers around ERC20 operations that throw on failure (when the token
564  * contract returns false). Tokens that return no value (and instead revert or
565  * throw on failure) are also supported, non-reverting calls are assumed to be
566  * successful.
567  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
568  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
569  */
570 library SafeERC20 {
571     using SafeMath for uint256;
572     using Address for address;
573 
574     function safeTransfer(
575         IERC20 token,
576         address to,
577         uint256 value
578     ) internal {
579         callOptionalReturn(
580             token,
581             abi.encodeWithSelector(token.transfer.selector, to, value)
582         );
583     }
584 
585     function safeTransferFrom(
586         IERC20 token,
587         address from,
588         address to,
589         uint256 value
590     ) internal {
591         callOptionalReturn(
592             token,
593             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
594         );
595     }
596 
597     function safeApprove(
598         IERC20 token,
599         address spender,
600         uint256 value
601     ) internal {
602         // safeApprove should only be called when setting an initial allowance,
603         // or when resetting it to zero. To increase and decrease it, use
604         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
605         // solhint-disable-next-line max-line-length
606         require(
607             (value == 0) || (token.allowance(address(this), spender) == 0),
608             "SafeERC20: approve from non-zero to non-zero allowance"
609         );
610         callOptionalReturn(
611             token,
612             abi.encodeWithSelector(token.approve.selector, spender, value)
613         );
614     }
615 
616     function safeIncreaseAllowance(
617         IERC20 token,
618         address spender,
619         uint256 value
620     ) internal {
621         uint256 newAllowance = token.allowance(address(this), spender).add(
622             value
623         );
624         callOptionalReturn(
625             token,
626             abi.encodeWithSelector(
627                 token.approve.selector,
628                 spender,
629                 newAllowance
630             )
631         );
632     }
633 
634     function safeDecreaseAllowance(
635         IERC20 token,
636         address spender,
637         uint256 value
638     ) internal {
639         uint256 newAllowance = token.allowance(address(this), spender).sub(
640             value,
641             "SafeERC20: decreased allowance below zero"
642         );
643         callOptionalReturn(
644             token,
645             abi.encodeWithSelector(
646                 token.approve.selector,
647                 spender,
648                 newAllowance
649             )
650         );
651     }
652 
653     /**
654      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
655      * on the return value: the return value is optional (but if data is returned, it must not be false).
656      * @param token The token targeted by the call.
657      * @param data The call data (encoded using abi.encode or one of its variants).
658      */
659     function callOptionalReturn(IERC20 token, bytes memory data) private {
660         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
661         // we're implementing it ourselves.
662 
663         // A Solidity high level call has three parts:
664         //  1. The target address is checked to verify it contains contract code
665         //  2. The call itself is made, and success asserted
666         //  3. The return value is decoded, which in turn checks the size of the returned data.
667         // solhint-disable-next-line max-line-length
668         require(address(token).isContract(), "SafeERC20: call to non-contract");
669 
670         // solhint-disable-next-line avoid-low-level-calls
671         (bool success, bytes memory returndata) = address(token).call(data);
672         require(success, "SafeERC20: low-level call failed");
673 
674         if (returndata.length > 0) {
675             // Return data is optional
676             // solhint-disable-next-line max-line-length
677             require(
678                 abi.decode(returndata, (bool)),
679                 "SafeERC20: ERC20 operation did not succeed"
680             );
681         }
682     }
683 }
684 
685 // File: contracts/IRewardDistributionRecipient.sol
686 
687 pragma solidity ^0.5.0;
688 
689 contract IRewardDistributionRecipient is Ownable {
690     address rewardDistribution = 0x45a6b8BdfC1FAa745720165e0B172A3D6D4EC897;
691 
692     function notifyRewardAmount() external;
693 
694     modifier onlyRewardDistribution() {
695         require(
696             _msgSender() == rewardDistribution,
697             "Caller is not reward distribution"
698         );
699         _;
700     }
701 
702     function setRewardDistribution(address _rewardDistribution)
703         external
704         onlyOwner
705     {
706         rewardDistribution = _rewardDistribution;
707     }
708 }
709 
710 // File: contracts/CurveRewards.sol
711 
712 pragma solidity ^0.5.0;
713 
714 pragma solidity ^0.5.17;
715 
716 contract LPTokenWrapper {
717     using SafeMath for uint256;
718     using SafeERC20 for IERC20;
719 
720     IERC20 public wolf = IERC20(0x0D647b11304678a0a7D1cD77Fcd3395263a120F9); //wolf
721 
722     uint256 private _totalSupply;
723     mapping(address => uint256) private _balances;
724 
725     function totalSupply() public view returns (uint256) {
726         return _totalSupply;
727     }
728 
729     function balanceOf(address account) public view returns (uint256) {
730         return _balances[account];
731     }
732 
733     function stake(uint256 amount) public {
734         _totalSupply = _totalSupply.add(amount);
735         _balances[msg.sender] = _balances[msg.sender].add(amount);
736         wolf.safeTransferFrom(msg.sender, address(this), amount);
737     }
738 
739     function withdraw(uint256 amount) public {
740         _totalSupply = _totalSupply.sub(amount);
741         _balances[msg.sender] = _balances[msg.sender].sub(amount);
742         wolf.safeTransfer(msg.sender, amount);
743     }
744 }
745 
746 contract WOLFPool is LPTokenWrapper, IRewardDistributionRecipient {
747     IERC20 public wolf = IERC20(0x0D647b11304678a0a7D1cD77Fcd3395263a120F9); //wolf
748     uint256 public DURATION = 1 days;
749     uint256 public initreward = 61875 ether;
750      uint256 public generation = 3;
751     uint256 public starttime = 1604181600; //Saturday, October 31, 2020 10:00:00 PM GMT+01:00
752     uint256 public periodFinish = 0;
753     uint256 public rewardRate = 0;
754     uint256 public lastUpdateTime;
755     uint256 public rewardPerTokenStored;
756     mapping(address => uint256) public userRewardPerTokenPaid;
757     mapping(address => uint256) public rewards;
758 
759     event RewardAdded(uint256 reward);
760     event Staked(address indexed user, uint256 amount);
761     event Withdrawn(address indexed user, uint256 amount);
762     event RewardPaid(address indexed user, uint256 reward);
763 
764     modifier updateReward(address account) {
765         rewardPerTokenStored = rewardPerToken();
766         lastUpdateTime = lastTimeRewardApplicable();
767         if (account != address(0)) {
768             rewards[account] = earned(account);
769             userRewardPerTokenPaid[account] = rewardPerTokenStored;
770         }
771         _;
772     }
773 
774     function lastTimeRewardApplicable() public view returns (uint256) {
775         return Math.min(block.timestamp, periodFinish);
776     }
777 
778     function rewardPerToken() public view returns (uint256) {
779         if (totalSupply() == 0) {
780             return rewardPerTokenStored;
781         }
782         return
783             rewardPerTokenStored.add(
784                 lastTimeRewardApplicable()
785                     .sub(lastUpdateTime)
786                     .mul(rewardRate)
787                     .mul(1e18)
788                     .div(totalSupply())
789             );
790     }
791 
792     function earned(address account) public view returns (uint256) {
793         return
794             balanceOf(account)
795                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
796                 .div(1e18)
797                 .add(rewards[account]);
798     }
799 
800     // stake visibility is public as overriding LPTokenWrapper's stake() function
801     function stake(uint256 amount) public updateReward(msg.sender) checkStart checkhalve {
802         require(amount > 0, "Cannot stake 0");
803         super.stake(amount);
804         emit Staked(msg.sender, amount);
805     }
806 
807     function withdraw(uint256 amount) public updateReward(msg.sender) {
808         require(amount > 0, "Cannot withdraw 0");
809         super.withdraw(amount);
810         emit Withdrawn(msg.sender, amount);
811     }
812 
813     function exit() external {
814         withdraw(balanceOf(msg.sender));
815         getReward();
816     }
817 
818     function getReward() public updateReward(msg.sender) checkhalve {
819         uint256 reward = earned(msg.sender);
820         if (reward > 0) {
821             rewards[msg.sender] = 0;
822             wolf.safeTransfer(msg.sender, reward);
823             emit RewardPaid(msg.sender, reward);
824         }
825     }
826 
827     modifier checkhalve() {
828         if (block.timestamp >= periodFinish) {
829             generation = generation.add(1);
830             if (generation == 4) {
831                 DURATION = 1 days;
832                 initreward = 24750 ether;
833                 rewardRate = initreward.div(DURATION);
834                 periodFinish = block.timestamp.add(DURATION);
835                 emit RewardAdded(initreward);
836             } else if (generation == 5) {
837                 DURATION = 8 days;
838                 initreward = 99000 ether;
839                 rewardRate = initreward.div(DURATION);
840                 periodFinish = block.timestamp.add(DURATION);
841                 emit RewardAdded(initreward);
842             } else if (generation == 6) {
843                 DURATION = 7 days;
844                 initreward = 129937500000000000000000;
845                 rewardRate = initreward.div(DURATION);
846                 periodFinish = block.timestamp.add(DURATION);
847                 emit RewardAdded(initreward);
848             } else if (generation == 7) {
849                  DURATION = 6 days;
850                 initreward = 148500 ether;
851                 rewardRate = initreward.div(DURATION);
852                 periodFinish = block.timestamp.add(DURATION);
853                 emit RewardAdded(initreward);
854             } else if (generation == 8) {
855                  DURATION = 5 days;
856                 initreward = 154687500000000000000000;
857                 rewardRate = rewardRate.add(initreward.div(DURATION));
858                 periodFinish = block.timestamp.add(DURATION);
859                 emit RewardAdded(initreward);
860             }
861         }
862          _;
863       
864     }
865 
866     modifier checkStart() {
867         require(block.timestamp > starttime, "not start");
868         _;
869     }
870 
871     function drainToken(address _token) public onlyRewardDistribution {
872         //owner can withdraw tokens from contract in case of wrong sending
873         require(
874             block.timestamp > periodFinish,
875             "Can only drain tokens after it's ended"
876         );
877         IERC20 token = IERC20(_token);
878         uint256 tokenBalance = token.balanceOf(address(this));
879         token.transfer(msg.sender, tokenBalance);
880     }
881 
882     function notifyRewardAmount()
883         external
884         onlyRewardDistribution
885         updateReward(address(0))
886     {
887         if (block.timestamp >= periodFinish) {
888             rewardRate = initreward.div(DURATION);
889         } else {
890             uint256 remaining = periodFinish.sub(block.timestamp);
891             uint256 leftover = remaining.mul(rewardRate);
892             rewardRate = initreward.add(leftover).div(DURATION);
893         }
894         lastUpdateTime = block.timestamp;
895         periodFinish = starttime.add(DURATION);
896         emit RewardAdded(initreward);
897     }
898 }