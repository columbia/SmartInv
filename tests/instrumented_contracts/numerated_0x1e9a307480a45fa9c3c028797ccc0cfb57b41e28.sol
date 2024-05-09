1 /*
2 
3                                                                                                       
4 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
5 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@'~~~     ~~~`@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
6 @@@@@@@@@@@@@@@@@@@@@@@@'                     `@@@@@@@@@@@@@@@@@@@@@@@@@@@@
7 @@@@@@@@@@@@@@@@@@@@@'                           `@@@@@@@@@@@@@@@@@@@@@@@@@
8 @@@@@@@@@@@@@@@@@@@'                               `@@@@@@@@@@@@@@@@@@@@@@@
9 @@@@@@@@@@@@@@@@@'                                   `@@@@@@@@@@@@@@@@@@@@@
10 @@@@@@@@@@@@@@@@'                                     `@@@@@@@@@@@@@@@@@@@@
11 @@@@@@@@@@@@@@@'                                       `@@@@@@@@@@@@@@@@@@@
12 @@@@@@@@@@@@@@@                                         @@@@@@@@@@@@@@@@@@@
13 @@@@@@@@@@@@@@'                                         `@@@@@@@@@@@@@@@@@@
14 @@@@@@@@@@@@@@                                           @@@@@@@@@@@@@@@@@@
15 @@@@@@@@@@@@@@                                           @@@@@@@@@@@@@@@@@@
16 @@@@@@@@@@@@@@                       n,                  @@@@@@@@@@@@@@@@@@
17 @@@@@@@@@@@@@@                     _/ | _                @@@@@@@@@@@@@@@@@@
18 @@@@@@@@@@@@@@                    /'  `'/                @@@@@@@@@@@@@@@@@@
19 @@@@@@@@@@@@@@a                 <~    .'                a@@@@@@@@@@@@@@@@@@
20 @@@@@@@@@@@@@@@                 .'    |                 @@@@@@@@@@@@@@@@@@@
21 @@@@@@@@@@@@@@@a              _/      |                a@@@@@@@@@@@@@@@@@@@
22 @@@@@@@@@@@@@@@@a           _/      `.`.              a@@@@@@@@@@@@@@@@@@@@
23 @@@@@@@@@@@@@@@@@a     ____/ '   \__ | |______       a@@@@@@@@@@@@@@@@@@@@@
24 @@@@@@@@@@@@@@@@@@@a__/___/      /__\ \ \     \___.a@@@@@@@@@@@@@@@@@@@@@@@
25 @@@@@@@@@@@@@@@@@@@/  (___.'\_______)\_|_|        \@@@@@@@@@@@@@@@@@@@@@@@@
26 @@@@@@@@@@@@@@@@@@|\________                       ~~~~~\@@@@@@@@@@@@@@@@@@
27 ~~~\@@@@@@@@@@@@@@||       |\___________________________/|@/~~~~~~~~~~~\@@@
28     |~~~~\@@@@@@@/ |  |    | |       | ||\____________|@@
29 
30 ------------------------------------------------
31 Thank you for visiting https://asciiart.website/
32 This ASCII pic can be found at
33 https://asciiart.website/index.php?art=animals/wolves
34 
35 
36 
37    ____            __   __        __   _
38   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
39  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
40 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
41      /___/
42 
43 * Synthetix: VAMPRewards.sol
44 *
45 * Docs: https://docs.synthetix.io/
46 *
47 *
48 * MIT License
49 * ===========
50 *
51 * Copyright (c) 2020 Synthetix
52 *
53 * Permission is hereby granted, free of charge, to any person obtaining a copy
54 * of this software and associated documentation files (the "Software"), to deal
55 * in the Software without restriction, including without limitation the rights
56 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
57 * copies of the Software, and to permit persons to whom the Software is
58 * furnished to do so, subject to the following conditions:
59 *
60 * The above copyright notice and this permission notice shall be included in all
61 * copies or substantial portions of the Software.
62 *
63 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
64 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
65 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
66 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
67 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
68 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
69 */
70 pragma solidity ^0.5.17;
71 
72 /**
73  * @dev Standard math utilities missing in the Solidity language.
74  */
75 library Math {
76     /**
77      * @dev Returns the largest of two numbers.
78      */
79     function max(uint256 a, uint256 b) internal pure returns (uint256) {
80         return a >= b ? a : b;
81     }
82 
83     /**
84      * @dev Returns the smallest of two numbers.
85      */
86     function min(uint256 a, uint256 b) internal pure returns (uint256) {
87         return a < b ? a : b;
88     }
89 
90     /**
91      * @dev Returns the average of two numbers. The result is rounded towards
92      * zero.
93      */
94     function average(uint256 a, uint256 b) internal pure returns (uint256) {
95         // (a + b) / 2 can overflow, so we distribute
96         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
97     }
98 }
99 
100 // File: @openzeppelin/contracts/math/SafeMath.sol
101 
102 /**
103  * @dev Wrappers over Solidity's arithmetic operations with added overflow
104  * checks.
105  *
106  * Arithmetic operations in Solidity wrap on overflow. This can easily result
107  * in bugs, because programmers usually assume that an overflow raises an
108  * error, which is the standard behavior in high level programming languages.
109  * `SafeMath` restores this intuition by reverting the transaction when an
110  * operation overflows.
111  *
112  * Using this library instead of the unchecked operations eliminates an entire
113  * class of bugs, so it's recommended to use it always.
114  */
115 library SafeMath {
116     /**
117      * @dev Returns the addition of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `+` operator.
121      *
122      * Requirements:
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         return sub(a, b, "SafeMath: subtraction overflow");
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      * - Subtraction cannot overflow.
153      *
154      * _Available since v2.4.0._
155      */
156     function sub(
157         uint256 a,
158         uint256 b,
159         string memory errorMessage
160     ) internal pure returns (uint256) {
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
218     function div(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         // Solidity only automatically asserts when dividing by 0
224         require(b > 0, errorMessage);
225         uint256 c = a / b;
226         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return mod(a, b, "SafeMath: modulo by zero");
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts with custom message when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      * - The divisor cannot be zero.
256      *
257      * _Available since v2.4.0._
258      */
259     function mod(
260         uint256 a,
261         uint256 b,
262         string memory errorMessage
263     ) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: @openzeppelin/contracts/GSN/Context.sol
270 
271 /*
272  * @dev Provides information about the current execution context, including the
273  * sender of the transaction and its data. While these are generally available
274  * via msg.sender and msg.data, they should not be accessed in such a direct
275  * manner, since when dealing with GSN meta-transactions the account sending and
276  * paying for execution may not be the actual sender (as far as an application
277  * is concerned).
278  *
279  * This contract is only required for intermediate, library-like contracts.
280  */
281 contract Context {
282     // Empty internal constructor, to prevent people from mistakenly deploying
283     // an instance of this contract, which should be used via inheritance.
284     constructor() internal {}
285 
286     // solhint-disable-previous-line no-empty-blocks
287 
288     function _msgSender() internal view returns (address payable) {
289         return msg.sender;
290     }
291 
292     function _msgData() internal view returns (bytes memory) {
293         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
294         return msg.data;
295     }
296 }
297 
298 // File: @openzeppelin/contracts/ownership/Ownable.sol
299 
300 /**
301  * @dev Contract module which provides a basic access control mechanism, where
302  * there is an account (an owner) that can be granted exclusive access to
303  * specific functions.
304  *
305  * This module is used through inheritance. It will make available the modifier
306  * `onlyOwner`, which can be applied to your functions to restrict their use to
307  * the owner.
308  */
309 contract Ownable is Context {
310     address private _owner;
311 
312     event OwnershipTransferred(
313         address indexed previousOwner,
314         address indexed newOwner
315     );
316 
317     /**
318      * @dev Initializes the contract setting the deployer as the initial owner.
319      */
320     constructor() internal {
321         _owner = _msgSender();
322         emit OwnershipTransferred(address(0), _owner);
323     }
324 
325     /**
326      * @dev Returns the address of the current owner.
327      */
328     function owner() public view returns (address) {
329         return _owner;
330     }
331 
332     /**
333      * @dev Throws if called by any account other than the owner.
334      */
335     modifier onlyOwner() {
336         require(isOwner(), "Ownable: caller is not the owner");
337         _;
338     }
339 
340     /**
341      * @dev Returns true if the caller is the current owner.
342      */
343     function isOwner() public view returns (bool) {
344         return _msgSender() == _owner;
345     }
346 
347     /**
348      * @dev Leaves the contract without owner. It will not be possible to call
349      * `onlyOwner` functions anymore. Can only be called by the current owner.
350      *
351      * NOTE: Renouncing ownership will leave the contract without an owner,
352      * thereby removing any functionality that is only available to the owner.
353      */
354     function renounceOwnership() public onlyOwner {
355         emit OwnershipTransferred(_owner, address(0));
356         _owner = address(0);
357     }
358 
359     /**
360      * @dev Transfers ownership of the contract to a new account (`newOwner`).
361      * Can only be called by the current owner.
362      */
363     function transferOwnership(address newOwner) public onlyOwner {
364         _transferOwnership(newOwner);
365     }
366 
367     /**
368      * @dev Transfers ownership of the contract to a new account (`newOwner`).
369      */
370     function _transferOwnership(address newOwner) internal {
371         require(
372             newOwner != address(0),
373             "Ownable: new owner is the zero address"
374         );
375         emit OwnershipTransferred(_owner, newOwner);
376         _owner = newOwner;
377     }
378 }
379 
380 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
381 
382 pragma solidity ^0.5.0;
383 
384 /**
385  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
386  * the optional functions; to access them see {ERC20Detailed}.
387  */
388 interface IERC20 {
389     function mint(address account, uint256 amount) external;
390 
391     /**
392      * @dev Returns the amount of tokens in existence.
393      */
394     function totalSupply() external view returns (uint256);
395 
396     /**
397      * @dev Returns the amount of tokens owned by `account`.
398      */
399     function balanceOf(address account) external view returns (uint256);
400 
401     /**
402      * @dev Moves `amount` tokens from the caller's account to `recipient`.
403      *
404      * Returns a boolean value indicating whether the operation succeeded.
405      *
406      * Emits a {Transfer} event.
407      */
408     function transfer(address recipient, uint256 amount)
409         external
410         returns (bool);
411 
412     /**
413      * @dev Returns the remaining number of tokens that `spender` will be
414      * allowed to spend on behalf of `owner` through {transferFrom}. This is
415      * zero by default.
416      *
417      * This value changes when {approve} or {transferFrom} are called.
418      */
419     function allowance(address owner, address spender)
420         external
421         view
422         returns (uint256);
423 
424     /**
425      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
426      *
427      * Returns a boolean value indicating whether the operation succeeded.
428      *
429      * IMPORTANT: Beware that changing an allowance with this method brings the risk
430      * that someone may use both the old and the new allowance by unfortunate
431      * transaction ordering. One possible solution to mitigate this race
432      * condition is to first reduce the spender's allowance to 0 and set the
433      * desired value afterwards:
434      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
435      *
436      * Emits an {Approval} event.
437      */
438     function approve(address spender, uint256 amount) external returns (bool);
439 
440     /**
441      * @dev Moves `amount` tokens from `sender` to `recipient` using the
442      * allowance mechanism. `amount` is then deducted from the caller's
443      * allowance.
444      *
445      * Returns a boolean value indicating whether the operation succeeded.
446      *
447      * Emits a {Transfer} event.
448      */
449     function transferFrom(
450         address sender,
451         address recipient,
452         uint256 amount
453     ) external returns (bool);
454 
455     /**
456      * @dev Emitted when `value` tokens are moved from one account (`from`) to
457      * another (`to`).
458      *
459      * Note that `value` may be zero.
460      */
461     event Transfer(address indexed from, address indexed to, uint256 value);
462 
463     /**
464      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
465      * a call to {approve}. `value` is the new allowance.
466      */
467     event Approval(
468         address indexed owner,
469         address indexed spender,
470         uint256 value
471     );
472 }
473 
474 // File: @openzeppelin/contracts/utils/Address.sol
475 
476 pragma solidity ^0.5.5;
477 
478 /**
479  * @dev Collection of functions related to the address type
480  */
481 library Address {
482     /**
483      * @dev Returns true if `account` is a contract.
484      *
485      * This test is non-exhaustive, and there may be false-negatives: during the
486      * execution of a contract's constructor, its address will be reported as
487      * not containing a contract.
488      *
489      * IMPORTANT: It is unsafe to assume that an address for which this
490      * function returns false is an externally-owned account (EOA) and not a
491      * contract.
492      */
493     function isContract(address account) internal view returns (bool) {
494         // This method relies in extcodesize, which returns 0 for contracts in
495         // construction, since the code is only stored at the end of the
496         // constructor execution.
497 
498         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
499         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
500         // for accounts without code, i.e. `keccak256('')`
501         bytes32 codehash;
502 
503             bytes32 accountHash
504          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
505         // solhint-disable-next-line no-inline-assembly
506         assembly {
507             codehash := extcodehash(account)
508         }
509         return (codehash != 0x0 && codehash != accountHash);
510     }
511 
512     /**
513      * @dev Converts an `address` into `address payable`. Note that this is
514      * simply a type cast: the actual underlying value is not changed.
515      *
516      * _Available since v2.4.0._
517      */
518     function toPayable(address account)
519         internal
520         pure
521         returns (address payable)
522     {
523         return address(uint160(account));
524     }
525 
526     /**
527      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
528      * `recipient`, forwarding all available gas and reverting on errors.
529      *
530      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
531      * of certain opcodes, possibly making contracts go over the 2300 gas limit
532      * imposed by `transfer`, making them unable to receive funds via
533      * `transfer`. {sendValue} removes this limitation.
534      *
535      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
536      *
537      * IMPORTANT: because control is transferred to `recipient`, care must be
538      * taken to not create reentrancy vulnerabilities. Consider using
539      * {ReentrancyGuard} or the
540      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
541      *
542      * _Available since v2.4.0._
543      */
544     function sendValue(address payable recipient, uint256 amount) internal {
545         require(
546             address(this).balance >= amount,
547             "Address: insufficient balance"
548         );
549 
550         // solhint-disable-next-line avoid-call-value
551         (bool success, ) = recipient.call.value(amount)("");
552         require(
553             success,
554             "Address: unable to send value, recipient may have reverted"
555         );
556     }
557 }
558 
559 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
560 
561 pragma solidity ^0.5.0;
562 
563 /**
564  * @title SafeERC20
565  * @dev Wrappers around ERC20 operations that throw on failure (when the token
566  * contract returns false). Tokens that return no value (and instead revert or
567  * throw on failure) are also supported, non-reverting calls are assumed to be
568  * successful.
569  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
570  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
571  */
572 library SafeERC20 {
573     using SafeMath for uint256;
574     using Address for address;
575 
576     function safeTransfer(
577         IERC20 token,
578         address to,
579         uint256 value
580     ) internal {
581         callOptionalReturn(
582             token,
583             abi.encodeWithSelector(token.transfer.selector, to, value)
584         );
585     }
586 
587     function safeTransferFrom(
588         IERC20 token,
589         address from,
590         address to,
591         uint256 value
592     ) internal {
593         callOptionalReturn(
594             token,
595             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
596         );
597     }
598 
599     function safeApprove(
600         IERC20 token,
601         address spender,
602         uint256 value
603     ) internal {
604         // safeApprove should only be called when setting an initial allowance,
605         // or when resetting it to zero. To increase and decrease it, use
606         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
607         // solhint-disable-next-line max-line-length
608         require(
609             (value == 0) || (token.allowance(address(this), spender) == 0),
610             "SafeERC20: approve from non-zero to non-zero allowance"
611         );
612         callOptionalReturn(
613             token,
614             abi.encodeWithSelector(token.approve.selector, spender, value)
615         );
616     }
617 
618     function safeIncreaseAllowance(
619         IERC20 token,
620         address spender,
621         uint256 value
622     ) internal {
623         uint256 newAllowance = token.allowance(address(this), spender).add(
624             value
625         );
626         callOptionalReturn(
627             token,
628             abi.encodeWithSelector(
629                 token.approve.selector,
630                 spender,
631                 newAllowance
632             )
633         );
634     }
635 
636     function safeDecreaseAllowance(
637         IERC20 token,
638         address spender,
639         uint256 value
640     ) internal {
641         uint256 newAllowance = token.allowance(address(this), spender).sub(
642             value,
643             "SafeERC20: decreased allowance below zero"
644         );
645         callOptionalReturn(
646             token,
647             abi.encodeWithSelector(
648                 token.approve.selector,
649                 spender,
650                 newAllowance
651             )
652         );
653     }
654 
655     /**
656      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
657      * on the return value: the return value is optional (but if data is returned, it must not be false).
658      * @param token The token targeted by the call.
659      * @param data The call data (encoded using abi.encode or one of its variants).
660      */
661     function callOptionalReturn(IERC20 token, bytes memory data) private {
662         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
663         // we're implementing it ourselves.
664 
665         // A Solidity high level call has three parts:
666         //  1. The target address is checked to verify it contains contract code
667         //  2. The call itself is made, and success asserted
668         //  3. The return value is decoded, which in turn checks the size of the returned data.
669         // solhint-disable-next-line max-line-length
670         require(address(token).isContract(), "SafeERC20: call to non-contract");
671 
672         // solhint-disable-next-line avoid-low-level-calls
673         (bool success, bytes memory returndata) = address(token).call(data);
674         require(success, "SafeERC20: low-level call failed");
675 
676         if (returndata.length > 0) {
677             // Return data is optional
678             // solhint-disable-next-line max-line-length
679             require(
680                 abi.decode(returndata, (bool)),
681                 "SafeERC20: ERC20 operation did not succeed"
682             );
683         }
684     }
685 }
686 
687 // File: contracts/IRewardDistributionRecipient.sol
688 
689 pragma solidity ^0.5.0;
690 
691 contract IRewardDistributionRecipient is Ownable {
692     address rewardDistribution = 0x45a6b8BdfC1FAa745720165e0B172A3D6D4EC897;
693 
694     function notifyRewardAmount() external;
695 
696     modifier onlyRewardDistribution() {
697         require(
698             _msgSender() == rewardDistribution,
699             "Caller is not reward distribution"
700         );
701         _;
702     }
703 
704     function setRewardDistribution(address _rewardDistribution)
705         external
706         onlyOwner
707     {
708         rewardDistribution = _rewardDistribution;
709     }
710 }
711 
712 // File: contracts/CurveRewards.sol
713 
714 pragma solidity ^0.5.0;
715 
716 pragma solidity ^0.5.17;
717 
718 contract LPTokenWrapper {
719     using SafeMath for uint256;
720     using SafeERC20 for IERC20;
721 
722     IERC20 public wolf_lp = IERC20(0x41D4a5645FBf6c5eF06Cd49e60Ecf1C192deB147); //wolf_lp
723 
724     uint256 private _totalSupply;
725     mapping(address => uint256) private _balances;
726 
727     function totalSupply() public view returns (uint256) {
728         return _totalSupply;
729     }
730 
731     function balanceOf(address account) public view returns (uint256) {
732         return _balances[account];
733     }
734 
735     function stake(uint256 amount) public {
736         _totalSupply = _totalSupply.add(amount);
737         _balances[msg.sender] = _balances[msg.sender].add(amount);
738         wolf_lp.safeTransferFrom(msg.sender, address(this), amount);
739     }
740 
741     function withdraw(uint256 amount) public {
742         _totalSupply = _totalSupply.sub(amount);
743         _balances[msg.sender] = _balances[msg.sender].sub(amount);
744         wolf_lp.safeTransfer(msg.sender, amount);
745     }
746 }
747 
748 contract WOLFLPPool is LPTokenWrapper, IRewardDistributionRecipient {
749     IERC20 public wolf = IERC20(0x0D647b11304678a0a7D1cD77Fcd3395263a120F9); //wolf
750     uint256 public DURATION = 1 days;
751     uint256 public initreward = 309375 ether;
752      uint256 public generation = 3;
753     uint256 public starttime = 1604181600; //Saturday, October 31, 2020 10:00:00 PM GMT+01:00
754     uint256 public periodFinish = 0;
755     uint256 public rewardRate = 0;
756     uint256 public lastUpdateTime;
757     uint256 public rewardPerTokenStored;
758     mapping(address => uint256) public userRewardPerTokenPaid;
759     mapping(address => uint256) public rewards;
760 
761     event RewardAdded(uint256 reward);
762     event Staked(address indexed user, uint256 amount);
763     event Withdrawn(address indexed user, uint256 amount);
764     event RewardPaid(address indexed user, uint256 reward);
765 
766     modifier updateReward(address account) {
767         rewardPerTokenStored = rewardPerToken();
768         lastUpdateTime = lastTimeRewardApplicable();
769         if (account != address(0)) {
770             rewards[account] = earned(account);
771             userRewardPerTokenPaid[account] = rewardPerTokenStored;
772         }
773         _;
774     }
775 
776     function lastTimeRewardApplicable() public view returns (uint256) {
777         return Math.min(block.timestamp, periodFinish);
778     }
779 
780     function rewardPerToken() public view returns (uint256) {
781         if (totalSupply() == 0) {
782             return rewardPerTokenStored;
783         }
784         return
785             rewardPerTokenStored.add(
786                 lastTimeRewardApplicable()
787                     .sub(lastUpdateTime)
788                     .mul(rewardRate)
789                     .mul(1e18)
790                     .div(totalSupply())
791             );
792     }
793 
794     function earned(address account) public view returns (uint256) {
795         return
796             balanceOf(account)
797                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
798                 .div(1e18)
799                 .add(rewards[account]);
800     }
801 
802     // stake visibility is public as overriding LPTokenWrapper's stake() function
803     function stake(uint256 amount) public updateReward(msg.sender) checkStart checkhalve {
804         require(amount > 0, "Cannot stake 0");
805         super.stake(amount);
806         emit Staked(msg.sender, amount);
807     }
808 
809     function withdraw(uint256 amount) public updateReward(msg.sender) {
810         require(amount > 0, "Cannot withdraw 0");
811         super.withdraw(amount);
812         emit Withdrawn(msg.sender, amount);
813     }
814 
815     function exit() external {
816         withdraw(balanceOf(msg.sender));
817         getReward();
818     }
819 
820     function getReward() public updateReward(msg.sender) checkhalve {
821         uint256 reward = earned(msg.sender);
822         if (reward > 0) {
823             rewards[msg.sender] = 0;
824             wolf.safeTransfer(msg.sender, reward);
825             emit RewardPaid(msg.sender, reward);
826         }
827     }
828 
829     modifier checkhalve() {
830         if (block.timestamp >= periodFinish) {
831             generation = generation.add(1);
832             if (generation == 4) {
833                 DURATION = 1 days;
834                 initreward = 123750 ether;
835                 rewardRate = initreward.div(DURATION);
836                 periodFinish = block.timestamp.add(DURATION);
837                 emit RewardAdded(initreward);
838             } else if (generation == 5) {
839                 DURATION = 8 days;
840                 initreward = 495000 ether;
841                 rewardRate = initreward.div(DURATION);
842                 periodFinish = block.timestamp.add(DURATION);
843                 emit RewardAdded(initreward);
844             } else if (generation == 6) {
845                 DURATION = 7 days;
846                 initreward = 649687500000000000000000;
847                 rewardRate = initreward.div(DURATION);
848                 periodFinish = block.timestamp.add(DURATION);
849                 emit RewardAdded(initreward);
850             } else if (generation == 7) {
851                  DURATION = 6 days;
852                 initreward = 742500 ether;
853                 rewardRate = initreward.div(DURATION);
854                 periodFinish = block.timestamp.add(DURATION);
855                 emit RewardAdded(initreward);
856             } else if (generation == 8) {
857                  DURATION = 5 days;
858                 initreward = 773437500000000000000000;
859                 rewardRate = rewardRate.add(initreward.div(DURATION));
860                 periodFinish = block.timestamp.add(DURATION);
861                 emit RewardAdded(initreward);
862             }
863         }
864          _;
865        
866     }
867 
868     modifier checkStart() {
869         require(block.timestamp > starttime, "not start");
870         _;
871     }
872 
873     function drainToken(address _token) public onlyRewardDistribution {
874         //owner can withdraw tokens from contract in case of wrong sending
875         require(
876             block.timestamp > periodFinish,
877             "Can only drain tokens after it's ended"
878         );
879         IERC20 token = IERC20(_token);
880         uint256 tokenBalance = token.balanceOf(address(this));
881         token.transfer(msg.sender, tokenBalance);
882     }
883 
884     function notifyRewardAmount()
885         external
886         onlyRewardDistribution
887         updateReward(address(0))
888     {
889         if (block.timestamp >= periodFinish) {
890             rewardRate = initreward.div(DURATION);
891         } else {
892             uint256 remaining = periodFinish.sub(block.timestamp);
893             uint256 leftover = remaining.mul(rewardRate);
894             rewardRate = initreward.add(leftover).div(DURATION);
895         }
896         lastUpdateTime = block.timestamp;
897         periodFinish = starttime.add(DURATION);
898         emit RewardAdded(initreward);
899     }
900 }