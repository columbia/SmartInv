1 /*
2 
3     Copyright 2020 dYdX Trading Inc.
4 
5     Licensed under the Apache License, Version 2.0 (the "License");
6     you may not use this file except in compliance with the License.
7     You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11     Unless required by applicable law or agreed to in writing, software
12     distributed under the License is distributed on an "AS IS" BASIS,
13     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14     See the License for the specific language governing permissions and
15     limitations under the License.
16 
17 */
18 
19 pragma solidity 0.5.16;
20 pragma experimental ABIEncoderV2;
21 
22 // File: @openzeppelin/contracts/math/SafeMath.sol
23 
24 /**
25  * @dev Wrappers over Solidity's arithmetic operations with added overflow
26  * checks.
27  *
28  * Arithmetic operations in Solidity wrap on overflow. This can easily result
29  * in bugs, because programmers usually assume that an overflow raises an
30  * error, which is the standard behavior in high level programming languages.
31  * `SafeMath` restores this intuition by reverting the transaction when an
32  * operation overflows.
33  *
34  * Using this library instead of the unchecked operations eliminates an entire
35  * class of bugs, so it's recommended to use it always.
36  */
37 library SafeMath {
38     /**
39      * @dev Returns the addition of two unsigned integers, reverting on
40      * overflow.
41      *
42      * Counterpart to Solidity's `+` operator.
43      *
44      * Requirements:
45      * - Addition cannot overflow.
46      */
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a, "SafeMath: addition overflow");
50 
51         return c;
52     }
53 
54     /**
55      * @dev Returns the subtraction of two unsigned integers, reverting on
56      * overflow (when the result is negative).
57      *
58      * Counterpart to Solidity's `-` operator.
59      *
60      * Requirements:
61      * - Subtraction cannot overflow.
62      */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return sub(a, b, "SafeMath: subtraction overflow");
65     }
66 
67     /**
68      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
69      * overflow (when the result is negative).
70      *
71      * Counterpart to Solidity's `-` operator.
72      *
73      * Requirements:
74      * - Subtraction cannot overflow.
75      *
76      * _Available since v2.4.0._
77      */
78     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
79         require(b <= a, errorMessage);
80         uint256 c = a - b;
81 
82         return c;
83     }
84 
85     /**
86      * @dev Returns the multiplication of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `*` operator.
90      *
91      * Requirements:
92      * - Multiplication cannot overflow.
93      */
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
96         // benefit is lost if 'b' is also tested.
97         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
98         if (a == 0) {
99             return 0;
100         }
101 
102         uint256 c = a * b;
103         require(c / a == b, "SafeMath: multiplication overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the integer division of two unsigned integers. Reverts on
110      * division by zero. The result is rounded towards zero.
111      *
112      * Counterpart to Solidity's `/` operator. Note: this function uses a
113      * `revert` opcode (which leaves remaining gas untouched) while Solidity
114      * uses an invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b) internal pure returns (uint256) {
120         return div(a, b, "SafeMath: division by zero");
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
125      * division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator. Note: this function uses a
128      * `revert` opcode (which leaves remaining gas untouched) while Solidity
129      * uses an invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      * - The divisor cannot be zero.
133      *
134      * _Available since v2.4.0._
135      */
136     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         // Solidity only automatically asserts when dividing by 0
138         require(b > 0, errorMessage);
139         uint256 c = a / b;
140         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         return mod(a, b, "SafeMath: modulo by zero");
158     }
159 
160     /**
161      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
162      * Reverts with custom message when dividing by zero.
163      *
164      * Counterpart to Solidity's `%` operator. This function uses a `revert`
165      * opcode (which leaves remaining gas untouched) while Solidity uses an
166      * invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      * - The divisor cannot be zero.
170      *
171      * _Available since v2.4.0._
172      */
173     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b != 0, errorMessage);
175         return a % b;
176     }
177 }
178 
179 // File: @openzeppelin/contracts/GSN/Context.sol
180 
181 /*
182  * @dev Provides information about the current execution context, including the
183  * sender of the transaction and its data. While these are generally available
184  * via msg.sender and msg.data, they should not be accessed in such a direct
185  * manner, since when dealing with GSN meta-transactions the account sending and
186  * paying for execution may not be the actual sender (as far as an application
187  * is concerned).
188  *
189  * This contract is only required for intermediate, library-like contracts.
190  */
191 contract Context {
192     // Empty internal constructor, to prevent people from mistakenly deploying
193     // an instance of this contract, which should be used via inheritance.
194     constructor () internal { }
195     // solhint-disable-previous-line no-empty-blocks
196 
197     function _msgSender() internal view returns (address payable) {
198         return msg.sender;
199     }
200 
201     function _msgData() internal view returns (bytes memory) {
202         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
203         return msg.data;
204     }
205 }
206 
207 // File: @openzeppelin/contracts/ownership/Ownable.sol
208 
209 /**
210  * @dev Contract module which provides a basic access control mechanism, where
211  * there is an account (an owner) that can be granted exclusive access to
212  * specific functions.
213  *
214  * This module is used through inheritance. It will make available the modifier
215  * `onlyOwner`, which can be applied to your functions to restrict their use to
216  * the owner.
217  */
218 contract Ownable is Context {
219     address private _owner;
220 
221     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223     /**
224      * @dev Initializes the contract setting the deployer as the initial owner.
225      */
226     constructor () internal {
227         address msgSender = _msgSender();
228         _owner = msgSender;
229         emit OwnershipTransferred(address(0), msgSender);
230     }
231 
232     /**
233      * @dev Returns the address of the current owner.
234      */
235     function owner() public view returns (address) {
236         return _owner;
237     }
238 
239     /**
240      * @dev Throws if called by any account other than the owner.
241      */
242     modifier onlyOwner() {
243         require(isOwner(), "Ownable: caller is not the owner");
244         _;
245     }
246 
247     /**
248      * @dev Returns true if the caller is the current owner.
249      */
250     function isOwner() public view returns (bool) {
251         return _msgSender() == _owner;
252     }
253 
254     /**
255      * @dev Leaves the contract without owner. It will not be possible to call
256      * `onlyOwner` functions anymore. Can only be called by the current owner.
257      *
258      * NOTE: Renouncing ownership will leave the contract without an owner,
259      * thereby removing any functionality that is only available to the owner.
260      */
261     function renounceOwnership() public onlyOwner {
262         emit OwnershipTransferred(_owner, address(0));
263         _owner = address(0);
264     }
265 
266     /**
267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
268      * Can only be called by the current owner.
269      */
270     function transferOwnership(address newOwner) public onlyOwner {
271         _transferOwnership(newOwner);
272     }
273 
274     /**
275      * @dev Transfers ownership of the contract to a new account (`newOwner`).
276      */
277     function _transferOwnership(address newOwner) internal {
278         require(newOwner != address(0), "Ownable: new owner is the zero address");
279         emit OwnershipTransferred(_owner, newOwner);
280         _owner = newOwner;
281     }
282 }
283 
284 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
285 
286 /**
287  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
288  * the optional functions; to access them see {ERC20Detailed}.
289  */
290 interface IERC20 {
291     /**
292      * @dev Returns the amount of tokens in existence.
293      */
294     function totalSupply() external view returns (uint256);
295 
296     /**
297      * @dev Returns the amount of tokens owned by `account`.
298      */
299     function balanceOf(address account) external view returns (uint256);
300 
301     /**
302      * @dev Moves `amount` tokens from the caller's account to `recipient`.
303      *
304      * Returns a boolean value indicating whether the operation succeeded.
305      *
306      * Emits a {Transfer} event.
307      */
308     function transfer(address recipient, uint256 amount) external returns (bool);
309 
310     /**
311      * @dev Returns the remaining number of tokens that `spender` will be
312      * allowed to spend on behalf of `owner` through {transferFrom}. This is
313      * zero by default.
314      *
315      * This value changes when {approve} or {transferFrom} are called.
316      */
317     function allowance(address owner, address spender) external view returns (uint256);
318 
319     /**
320      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
321      *
322      * Returns a boolean value indicating whether the operation succeeded.
323      *
324      * IMPORTANT: Beware that changing an allowance with this method brings the risk
325      * that someone may use both the old and the new allowance by unfortunate
326      * transaction ordering. One possible solution to mitigate this race
327      * condition is to first reduce the spender's allowance to 0 and set the
328      * desired value afterwards:
329      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
330      *
331      * Emits an {Approval} event.
332      */
333     function approve(address spender, uint256 amount) external returns (bool);
334 
335     /**
336      * @dev Moves `amount` tokens from `sender` to `recipient` using the
337      * allowance mechanism. `amount` is then deducted from the caller's
338      * allowance.
339      *
340      * Returns a boolean value indicating whether the operation succeeded.
341      *
342      * Emits a {Transfer} event.
343      */
344     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
345 
346     /**
347      * @dev Emitted when `value` tokens are moved from one account (`from`) to
348      * another (`to`).
349      *
350      * Note that `value` may be zero.
351      */
352     event Transfer(address indexed from, address indexed to, uint256 value);
353 
354     /**
355      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
356      * a call to {approve}. `value` is the new allowance.
357      */
358     event Approval(address indexed owner, address indexed spender, uint256 value);
359 }
360 
361 // File: @openzeppelin/contracts/utils/Address.sol
362 
363 /**
364  * @dev Collection of functions related to the address type
365  */
366 library Address {
367     /**
368      * @dev Returns true if `account` is a contract.
369      *
370      * [IMPORTANT]
371      * ====
372      * It is unsafe to assume that an address for which this function returns
373      * false is an externally-owned account (EOA) and not a contract.
374      *
375      * Among others, `isContract` will return false for the following
376      * types of addresses:
377      *
378      *  - an externally-owned account
379      *  - a contract in construction
380      *  - an address where a contract will be created
381      *  - an address where a contract lived, but was destroyed
382      * ====
383      */
384     function isContract(address account) internal view returns (bool) {
385         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
386         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
387         // for accounts without code, i.e. `keccak256('')`
388         bytes32 codehash;
389         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
390         // solhint-disable-next-line no-inline-assembly
391         assembly { codehash := extcodehash(account) }
392         return (codehash != accountHash && codehash != 0x0);
393     }
394 
395     /**
396      * @dev Converts an `address` into `address payable`. Note that this is
397      * simply a type cast: the actual underlying value is not changed.
398      *
399      * _Available since v2.4.0._
400      */
401     function toPayable(address account) internal pure returns (address payable) {
402         return address(uint160(account));
403     }
404 
405     /**
406      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
407      * `recipient`, forwarding all available gas and reverting on errors.
408      *
409      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
410      * of certain opcodes, possibly making contracts go over the 2300 gas limit
411      * imposed by `transfer`, making them unable to receive funds via
412      * `transfer`. {sendValue} removes this limitation.
413      *
414      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
415      *
416      * IMPORTANT: because control is transferred to `recipient`, care must be
417      * taken to not create reentrancy vulnerabilities. Consider using
418      * {ReentrancyGuard} or the
419      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
420      *
421      * _Available since v2.4.0._
422      */
423     function sendValue(address payable recipient, uint256 amount) internal {
424         require(address(this).balance >= amount, "Address: insufficient balance");
425 
426         // solhint-disable-next-line avoid-call-value
427         (bool success, ) = recipient.call.value(amount)("");
428         require(success, "Address: unable to send value, recipient may have reverted");
429     }
430 }
431 
432 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
433 
434 /**
435  * @title SafeERC20
436  * @dev Wrappers around ERC20 operations that throw on failure (when the token
437  * contract returns false). Tokens that return no value (and instead revert or
438  * throw on failure) are also supported, non-reverting calls are assumed to be
439  * successful.
440  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
441  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
442  */
443 library SafeERC20 {
444     using SafeMath for uint256;
445     using Address for address;
446 
447     function safeTransfer(IERC20 token, address to, uint256 value) internal {
448         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
449     }
450 
451     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
452         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
453     }
454 
455     function safeApprove(IERC20 token, address spender, uint256 value) internal {
456         // safeApprove should only be called when setting an initial allowance,
457         // or when resetting it to zero. To increase and decrease it, use
458         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
459         // solhint-disable-next-line max-line-length
460         require((value == 0) || (token.allowance(address(this), spender) == 0),
461             "SafeERC20: approve from non-zero to non-zero allowance"
462         );
463         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
464     }
465 
466     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
467         uint256 newAllowance = token.allowance(address(this), spender).add(value);
468         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
469     }
470 
471     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
472         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
473         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
474     }
475 
476     /**
477      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
478      * on the return value: the return value is optional (but if data is returned, it must not be false).
479      * @param token The token targeted by the call.
480      * @param data The call data (encoded using abi.encode or one of its variants).
481      */
482     function callOptionalReturn(IERC20 token, bytes memory data) private {
483         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
484         // we're implementing it ourselves.
485 
486         // A Solidity high level call has three parts:
487         //  1. The target address is checked to verify it contains contract code
488         //  2. The call itself is made, and success asserted
489         //  3. The return value is decoded, which in turn checks the size of the returned data.
490         // solhint-disable-next-line max-line-length
491         require(address(token).isContract(), "SafeERC20: call to non-contract");
492 
493         // solhint-disable-next-line avoid-low-level-calls
494         (bool success, bytes memory returndata) = address(token).call(data);
495         require(success, "SafeERC20: low-level call failed");
496 
497         if (returndata.length > 0) { // Return data is optional
498             // solhint-disable-next-line max-line-length
499             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
500         }
501     }
502 }
503 
504 // File: contracts/protocol/lib/BaseMath.sol
505 
506 /**
507  * @title BaseMath
508  * @author dYdX
509  *
510  * @dev Arithmetic for fixed-point numbers with 18 decimals of precision.
511  */
512 library BaseMath {
513     using SafeMath for uint256;
514 
515     // The number One in the BaseMath system.
516     uint256 constant internal BASE = 10 ** 18;
517 
518     /**
519      * @dev Getter function since constants can't be read directly from libraries.
520      */
521     function base()
522         internal
523         pure
524         returns (uint256)
525     {
526         return BASE;
527     }
528 
529     /**
530      * @dev Multiplies a value by a base value (result is rounded down).
531      */
532     function baseMul(
533         uint256 value,
534         uint256 baseValue
535     )
536         internal
537         pure
538         returns (uint256)
539     {
540         return value.mul(baseValue).div(BASE);
541     }
542 
543     /**
544      * @dev Multiplies a value by a base value (result is rounded down).
545      *  Intended as an alternaltive to baseMul to prevent overflow, when `value` is known
546      *  to be divisible by `BASE`.
547      */
548     function baseDivMul(
549         uint256 value,
550         uint256 baseValue
551     )
552         internal
553         pure
554         returns (uint256)
555     {
556         return value.div(BASE).mul(baseValue);
557     }
558 
559     /**
560      * @dev Multiplies a value by a base value (result is rounded up).
561      */
562     function baseMulRoundUp(
563         uint256 value,
564         uint256 baseValue
565     )
566         internal
567         pure
568         returns (uint256)
569     {
570         if (value == 0 || baseValue == 0) {
571             return 0;
572         }
573         return value.mul(baseValue).sub(1).div(BASE).add(1);
574     }
575 }
576 
577 // File: contracts/protocol/lib/SignedMath.sol
578 
579 /**
580  * @title SignedMath
581  * @author dYdX
582  *
583  * @dev SignedMath library for doing math with signed integers.
584  */
585 library SignedMath {
586     using SafeMath for uint256;
587 
588     // ============ Structs ============
589 
590     struct Int {
591         uint256 value;
592         bool isPositive;
593     }
594 
595     // ============ Functions ============
596 
597     /**
598      * @dev Returns a new signed integer equal to a signed integer plus an unsigned integer.
599      */
600     function add(
601         Int memory sint,
602         uint256 value
603     )
604         internal
605         pure
606         returns (Int memory)
607     {
608         if (sint.isPositive) {
609             return Int({
610                 value: value.add(sint.value),
611                 isPositive: true
612             });
613         }
614         if (sint.value < value) {
615             return Int({
616                 value: value.sub(sint.value),
617                 isPositive: true
618             });
619         }
620         return Int({
621             value: sint.value.sub(value),
622             isPositive: false
623         });
624     }
625 
626     /**
627      * @dev Returns a new signed integer equal to a signed integer minus an unsigned integer.
628      */
629     function sub(
630         Int memory sint,
631         uint256 value
632     )
633         internal
634         pure
635         returns (Int memory)
636     {
637         if (!sint.isPositive) {
638             return Int({
639                 value: value.add(sint.value),
640                 isPositive: false
641             });
642         }
643         if (sint.value > value) {
644             return Int({
645                 value: sint.value.sub(value),
646                 isPositive: true
647             });
648         }
649         return Int({
650             value: value.sub(sint.value),
651             isPositive: false
652         });
653     }
654 
655     /**
656      * @dev Returns a new signed integer equal to a signed integer plus another signed integer.
657      */
658     function signedAdd(
659         Int memory augend,
660         Int memory addend
661     )
662         internal
663         pure
664         returns (Int memory)
665     {
666         return addend.isPositive
667             ? add(augend, addend.value)
668             : sub(augend, addend.value);
669     }
670 
671     /**
672      * @dev Returns a new signed integer equal to a signed integer minus another signed integer.
673      */
674     function signedSub(
675         Int memory minuend,
676         Int memory subtrahend
677     )
678         internal
679         pure
680         returns (Int memory)
681     {
682         return subtrahend.isPositive
683             ? sub(minuend, subtrahend.value)
684             : add(minuend, subtrahend.value);
685     }
686 
687     /**
688      * @dev Returns true if signed integer `a` is greater than signed integer `b`, false otherwise.
689      */
690     function gt(
691         Int memory a,
692         Int memory b
693     )
694         internal
695         pure
696         returns (bool)
697     {
698         if (a.isPositive) {
699             if (b.isPositive) {
700                 return a.value > b.value;
701             } else {
702                 // True, unless both values are zero.
703                 return a.value != 0 || b.value != 0;
704             }
705         } else {
706             if (b.isPositive) {
707                 return false;
708             } else {
709                 return a.value < b.value;
710             }
711         }
712     }
713 
714     /**
715      * @dev Returns the minimum of signed integers `a` and `b`.
716      */
717     function min(
718         Int memory a,
719         Int memory b
720     )
721         internal
722         pure
723         returns (Int memory)
724     {
725         return gt(b, a) ? a : b;
726     }
727 
728     /**
729      * @dev Returns the maximum of signed integers `a` and `b`.
730      */
731     function max(
732         Int memory a,
733         Int memory b
734     )
735         internal
736         pure
737         returns (Int memory)
738     {
739         return gt(a, b) ? a : b;
740     }
741 }
742 
743 // File: contracts/protocol/v1/lib/P1Types.sol
744 
745 /**
746  * @title P1Types
747  * @author dYdX
748  *
749  * @dev Library for common types used in PerpetualV1 contracts.
750  */
751 library P1Types {
752     // ============ Structs ============
753 
754     /**
755      * @dev Used to represent the global index and each account's cached index.
756      *  Used to settle funding paymennts on a per-account basis.
757      */
758     struct Index {
759         uint32 timestamp;
760         bool isPositive;
761         uint128 value;
762     }
763 
764     /**
765      * @dev Used to track the signed margin balance and position balance values for each account.
766      */
767     struct Balance {
768         bool marginIsPositive;
769         bool positionIsPositive;
770         uint120 margin;
771         uint120 position;
772     }
773 
774     /**
775      * @dev Used to cache commonly-used variables that are relatively gas-intensive to obtain.
776      */
777     struct Context {
778         uint256 price;
779         uint256 minCollateral;
780         Index index;
781     }
782 
783     /**
784      * @dev Used by contracts implementing the I_P1Trader interface to return the result of a trade.
785      */
786     struct TradeResult {
787         uint256 marginAmount;
788         uint256 positionAmount;
789         bool isBuy; // From taker's perspective.
790         bytes32 traderFlags;
791     }
792 }
793 
794 // File: contracts/protocol/v1/intf/I_PerpetualV1.sol
795 
796 /**
797  * @title I_PerpetualV1
798  * @author dYdX
799  *
800  * @notice Interface for PerpetualV1.
801  */
802 interface I_PerpetualV1 {
803 
804     // ============ Structs ============
805 
806     struct TradeArg {
807         uint256 takerIndex;
808         uint256 makerIndex;
809         address trader;
810         bytes data;
811     }
812 
813     // ============ State-Changing Functions ============
814 
815     /**
816      * @notice Submits one or more trades between any number of accounts.
817      *
818      * @param  accounts  The sorted list of accounts that are involved in trades.
819      * @param  trades    The list of trades to execute in-order.
820      */
821     function trade(
822         address[] calldata accounts,
823         TradeArg[] calldata trades
824     )
825         external;
826 
827     /**
828      * @notice Withdraw the number of margin tokens equal to the value of the account at the time
829      *  that final settlement occurred.
830      */
831     function withdrawFinalSettlement()
832         external;
833 
834     /**
835      * @notice Deposit some amount of margin tokens from the msg.sender into an account.
836      *
837      * @param  account  The account for which to credit the deposit.
838      * @param  amount   the amount of tokens to deposit.
839      */
840     function deposit(
841         address account,
842         uint256 amount
843     )
844         external;
845 
846     /**
847      * @notice Withdraw some amount of margin tokens from an account to a destination address.
848      *
849      * @param  account      The account for which to debit the withdrawal.
850      * @param  destination  The address to which the tokens are transferred.
851      * @param  amount       The amount of tokens to withdraw.
852      */
853     function withdraw(
854         address account,
855         address destination,
856         uint256 amount
857     )
858         external;
859 
860     /**
861      * @notice Grants or revokes permission for another account to perform certain actions on behalf
862      *  of the sender.
863      *
864      * @param  operator  The account that is approved or disapproved.
865      * @param  approved  True for approval, false for disapproval.
866      */
867     function setLocalOperator(
868         address operator,
869         bool approved
870     )
871         external;
872 
873     // ============ Account Getters ============
874 
875     /**
876      * @notice Get the balance of an account, without accounting for changes in the index.
877      *
878      * @param  account  The address of the account to query the balances of.
879      * @return          The balances of the account.
880      */
881     function getAccountBalance(
882         address account
883     )
884         external
885         view
886         returns (P1Types.Balance memory);
887 
888     /**
889      * @notice Gets the most recently cached index of an account.
890      *
891      * @param  account  The address of the account to query the index of.
892      * @return          The index of the account.
893      */
894     function getAccountIndex(
895         address account
896     )
897         external
898         view
899         returns (P1Types.Index memory);
900 
901     /**
902      * @notice Gets the local operator status of an operator for a particular account.
903      *
904      * @param  account   The account to query the operator for.
905      * @param  operator  The address of the operator to query the status of.
906      * @return           True if the operator is a local operator of the account, false otherwise.
907      */
908     function getIsLocalOperator(
909         address account,
910         address operator
911     )
912         external
913         view
914         returns (bool);
915 
916     // ============ Global Getters ============
917 
918     /**
919      * @notice Gets the global operator status of an address.
920      *
921      * @param  operator  The address of the operator to query the status of.
922      * @return           True if the address is a global operator, false otherwise.
923      */
924     function getIsGlobalOperator(
925         address operator
926     )
927         external
928         view
929         returns (bool);
930 
931     /**
932      * @notice Gets the address of the ERC20 margin contract used for margin deposits.
933      *
934      * @return The address of the ERC20 token.
935      */
936     function getTokenContract()
937         external
938         view
939         returns (address);
940 
941     /**
942      * @notice Gets the current address of the price oracle contract.
943      *
944      * @return The address of the price oracle contract.
945      */
946     function getOracleContract()
947         external
948         view
949         returns (address);
950 
951     /**
952      * @notice Gets the current address of the funder contract.
953      *
954      * @return The address of the funder contract.
955      */
956     function getFunderContract()
957         external
958         view
959         returns (address);
960 
961     /**
962      * @notice Gets the most recently cached global index.
963      *
964      * @return The most recently cached global index.
965      */
966     function getGlobalIndex()
967         external
968         view
969         returns (P1Types.Index memory);
970 
971     /**
972      * @notice Gets minimum collateralization ratio of the protocol.
973      *
974      * @return The minimum-acceptable collateralization ratio, returned as a fixed-point number with
975      *  18 decimals of precision.
976      */
977     function getMinCollateral()
978         external
979         view
980         returns (uint256);
981 
982     /**
983      * @notice Gets the status of whether final-settlement was initiated by the Admin.
984      *
985      * @return True if final-settlement was enabled, false otherwise.
986      */
987     function getFinalSettlementEnabled()
988         external
989         view
990         returns (bool);
991 
992     // ============ Public Getters ============
993 
994     /**
995      * @notice Gets whether an address has permissions to operate an account.
996      *
997      * @param  account   The account to query.
998      * @param  operator  The address to query.
999      * @return           True if the operator has permission to operate the account,
1000      *                   and false otherwise.
1001      */
1002     function hasAccountPermissions(
1003         address account,
1004         address operator
1005     )
1006         external
1007         view
1008         returns (bool);
1009 
1010     // ============ Authorized Getters ============
1011 
1012     /**
1013      * @notice Gets the price returned by the oracle.
1014      * @dev Only able to be called by global operators.
1015      *
1016      * @return The price returned by the current price oracle.
1017      */
1018     function getOraclePrice()
1019         external
1020         view
1021         returns (uint256);
1022 }
1023 
1024 // File: contracts/protocol/lib/SafeCast.sol
1025 
1026 /**
1027  * @title SafeCast
1028  * @author dYdX
1029  *
1030  * @dev Library for casting uint256 to other types of uint.
1031  */
1032 library SafeCast {
1033 
1034     /**
1035      * @dev Returns the downcasted uint128 from uint256, reverting on
1036      *  overflow (i.e. when the input is greater than largest uint128).
1037      *
1038      *  Counterpart to Solidity's `uint128` operator.
1039      *
1040      *  Requirements:
1041      *  - `value` must fit into 128 bits.
1042      */
1043     function toUint128(
1044         uint256 value
1045     )
1046         internal
1047         pure
1048         returns (uint128)
1049     {
1050         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
1051         return uint128(value);
1052     }
1053 
1054     /**
1055      * @dev Returns the downcasted uint120 from uint256, reverting on
1056      *  overflow (i.e. when the input is greater than largest uint120).
1057      *
1058      *  Counterpart to Solidity's `uint120` operator.
1059      *
1060      *  Requirements:
1061      *  - `value` must fit into 120 bits.
1062      */
1063     function toUint120(
1064         uint256 value
1065     )
1066         internal
1067         pure
1068         returns (uint120)
1069     {
1070         require(value < 2**120, "SafeCast: value doesn\'t fit in 120 bits");
1071         return uint120(value);
1072     }
1073 
1074     /**
1075      * @dev Returns the downcasted uint32 from uint256, reverting on
1076      *  overflow (i.e. when the input is greater than largest uint32).
1077      *
1078      *  Counterpart to Solidity's `uint32` operator.
1079      *
1080      *  Requirements:
1081      *  - `value` must fit into 32 bits.
1082      */
1083     function toUint32(
1084         uint256 value
1085     )
1086         internal
1087         pure
1088         returns (uint32)
1089     {
1090         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
1091         return uint32(value);
1092     }
1093 }
1094 
1095 // File: contracts/protocol/v1/lib/P1BalanceMath.sol
1096 
1097 /**
1098  * @title P1BalanceMath
1099  * @author dYdX
1100  *
1101  * @dev Library for manipulating P1Types.Balance structs.
1102  */
1103 library P1BalanceMath {
1104     using BaseMath for uint256;
1105     using SafeCast for uint256;
1106     using SafeMath for uint256;
1107     using SignedMath for SignedMath.Int;
1108     using P1BalanceMath for P1Types.Balance;
1109 
1110     // ============ Constants ============
1111 
1112     uint256 private constant FLAG_MARGIN_IS_POSITIVE = 1 << (8 * 31);
1113     uint256 private constant FLAG_POSITION_IS_POSITIVE = 1 << (8 * 15);
1114 
1115     // ============ Functions ============
1116 
1117     /**
1118      * @dev Create a copy of the balance struct.
1119      */
1120     function copy(
1121         P1Types.Balance memory balance
1122     )
1123         internal
1124         pure
1125         returns (P1Types.Balance memory)
1126     {
1127         return P1Types.Balance({
1128             marginIsPositive: balance.marginIsPositive,
1129             positionIsPositive: balance.positionIsPositive,
1130             margin: balance.margin,
1131             position: balance.position
1132         });
1133     }
1134 
1135     /**
1136      * @dev In-place add amount to balance.margin.
1137      */
1138     function addToMargin(
1139         P1Types.Balance memory balance,
1140         uint256 amount
1141     )
1142         internal
1143         pure
1144     {
1145         SignedMath.Int memory signedMargin = balance.getMargin();
1146         signedMargin = signedMargin.add(amount);
1147         balance.setMargin(signedMargin);
1148     }
1149 
1150     /**
1151      * @dev In-place subtract amount from balance.margin.
1152      */
1153     function subFromMargin(
1154         P1Types.Balance memory balance,
1155         uint256 amount
1156     )
1157         internal
1158         pure
1159     {
1160         SignedMath.Int memory signedMargin = balance.getMargin();
1161         signedMargin = signedMargin.sub(amount);
1162         balance.setMargin(signedMargin);
1163     }
1164 
1165     /**
1166      * @dev In-place add amount to balance.position.
1167      */
1168     function addToPosition(
1169         P1Types.Balance memory balance,
1170         uint256 amount
1171     )
1172         internal
1173         pure
1174     {
1175         SignedMath.Int memory signedPosition = balance.getPosition();
1176         signedPosition = signedPosition.add(amount);
1177         balance.setPosition(signedPosition);
1178     }
1179 
1180     /**
1181      * @dev In-place subtract amount from balance.position.
1182      */
1183     function subFromPosition(
1184         P1Types.Balance memory balance,
1185         uint256 amount
1186     )
1187         internal
1188         pure
1189     {
1190         SignedMath.Int memory signedPosition = balance.getPosition();
1191         signedPosition = signedPosition.sub(amount);
1192         balance.setPosition(signedPosition);
1193     }
1194 
1195     /**
1196      * @dev Returns the positive and negative values of the margin and position together, given a
1197      *  price, which is used as a conversion rate between the two currencies.
1198      *
1199      *  No rounding occurs here--the returned values are "base values" with extra precision.
1200      */
1201     function getPositiveAndNegativeValue(
1202         P1Types.Balance memory balance,
1203         uint256 price
1204     )
1205         internal
1206         pure
1207         returns (uint256, uint256)
1208     {
1209         uint256 positiveValue = 0;
1210         uint256 negativeValue = 0;
1211 
1212         // add value of margin
1213         if (balance.marginIsPositive) {
1214             positiveValue = uint256(balance.margin).mul(BaseMath.base());
1215         } else {
1216             negativeValue = uint256(balance.margin).mul(BaseMath.base());
1217         }
1218 
1219         // add value of position
1220         uint256 positionValue = uint256(balance.position).mul(price);
1221         if (balance.positionIsPositive) {
1222             positiveValue = positiveValue.add(positionValue);
1223         } else {
1224             negativeValue = negativeValue.add(positionValue);
1225         }
1226 
1227         return (positiveValue, negativeValue);
1228     }
1229 
1230     /**
1231      * @dev Returns a compressed bytes32 representation of the balance for logging.
1232      */
1233     function toBytes32(
1234         P1Types.Balance memory balance
1235     )
1236         internal
1237         pure
1238         returns (bytes32)
1239     {
1240         uint256 result =
1241             uint256(balance.position)
1242             | (uint256(balance.margin) << 128)
1243             | (balance.marginIsPositive ? FLAG_MARGIN_IS_POSITIVE : 0)
1244             | (balance.positionIsPositive ? FLAG_POSITION_IS_POSITIVE : 0);
1245         return bytes32(result);
1246     }
1247 
1248     // ============ Helper Functions ============
1249 
1250     /**
1251      * @dev Returns a SignedMath.Int version of the margin in balance.
1252      */
1253     function getMargin(
1254         P1Types.Balance memory balance
1255     )
1256         internal
1257         pure
1258         returns (SignedMath.Int memory)
1259     {
1260         return SignedMath.Int({
1261             value: balance.margin,
1262             isPositive: balance.marginIsPositive
1263         });
1264     }
1265 
1266     /**
1267      * @dev Returns a SignedMath.Int version of the position in balance.
1268      */
1269     function getPosition(
1270         P1Types.Balance memory balance
1271     )
1272         internal
1273         pure
1274         returns (SignedMath.Int memory)
1275     {
1276         return SignedMath.Int({
1277             value: balance.position,
1278             isPositive: balance.positionIsPositive
1279         });
1280     }
1281 
1282     /**
1283      * @dev In-place modify the signed margin value of a balance.
1284      */
1285     function setMargin(
1286         P1Types.Balance memory balance,
1287         SignedMath.Int memory newMargin
1288     )
1289         internal
1290         pure
1291     {
1292         balance.margin = newMargin.value.toUint120();
1293         balance.marginIsPositive = newMargin.isPositive;
1294     }
1295 
1296     /**
1297      * @dev In-place modify the signed position value of a balance.
1298      */
1299     function setPosition(
1300         P1Types.Balance memory balance,
1301         SignedMath.Int memory newPosition
1302     )
1303         internal
1304         pure
1305     {
1306         balance.position = newPosition.value.toUint120();
1307         balance.positionIsPositive = newPosition.isPositive;
1308     }
1309 }
1310 
1311 // File: contracts/protocol/v1/proxies/P1LiquidatorProxy.sol
1312 
1313 /**
1314  * @title P1LiquidatorProxy
1315  * @author dYdX
1316  *
1317  * @notice Proxy contract for liquidating accounts. A fixed percentage of each liquidation is
1318  * directed to the insurance fund.
1319  */
1320 contract P1LiquidatorProxy is
1321     Ownable
1322 {
1323     using BaseMath for uint256;
1324     using SafeMath for uint256;
1325     using SignedMath for SignedMath.Int;
1326     using P1BalanceMath for P1Types.Balance;
1327     using SafeERC20 for IERC20;
1328 
1329     // ============ Events ============
1330 
1331     event LogLiquidatorProxyUsed(
1332         address indexed liquidatee,
1333         address indexed liquidator,
1334         bool isBuy,
1335         uint256 liquidationAmount,
1336         uint256 feeAmount
1337     );
1338 
1339     event LogInsuranceFundSet(
1340         address insuranceFund
1341     );
1342 
1343     event LogInsuranceFeeSet(
1344         uint256 insuranceFee
1345     );
1346 
1347     // ============ Immutable Storage ============
1348 
1349     // Address of the perpetual contract.
1350     address public _PERPETUAL_V1_;
1351 
1352     // Address of the P1Liquidation contract.
1353     address public _LIQUIDATION_;
1354 
1355     // ============ Mutable Storage ============
1356 
1357     // Address of the insurance fund.
1358     address public _INSURANCE_FUND_;
1359 
1360     // Proportion of liquidation profits that is directed to the insurance fund.
1361     // This number is represented as a fixed-point number with 18 decimals.
1362     uint256 public _INSURANCE_FEE_;
1363 
1364     // ============ Constructor ============
1365 
1366     constructor (
1367         address perpetualV1,
1368         address liquidator,
1369         address insuranceFund,
1370         uint256 insuranceFee
1371     )
1372         public
1373     {
1374         _PERPETUAL_V1_ = perpetualV1;
1375         _LIQUIDATION_ = liquidator;
1376         _INSURANCE_FUND_ = insuranceFund;
1377         _INSURANCE_FEE_ = insuranceFee;
1378 
1379         emit LogInsuranceFundSet(insuranceFund);
1380         emit LogInsuranceFeeSet(insuranceFee);
1381     }
1382 
1383     // ============ External Functions ============
1384 
1385     /**
1386      * @notice Sets the maximum allowance on the perpetual contract. Must be called at least once.
1387      * @dev Cannot be run in the constructor due to technical restrictions in Solidity.
1388      */
1389     function approveMaximumOnPerpetual()
1390         external
1391     {
1392         address perpetual = _PERPETUAL_V1_;
1393         IERC20 tokenContract = IERC20(I_PerpetualV1(perpetual).getTokenContract());
1394 
1395         // safeApprove requires unsetting the allowance first.
1396         tokenContract.safeApprove(perpetual, 0);
1397 
1398         // Set the allowance to the highest possible value.
1399         tokenContract.safeApprove(perpetual, uint256(-1));
1400     }
1401 
1402     /**
1403      * @notice Allows an account below the minimum collateralization to be liquidated by another
1404      *  account. This allows the account to be partially or fully subsumed by the liquidator.
1405      *  A proportion of all liquidation profits is directed to the insurance fund.
1406      * @dev Emits the LogLiquidatorProxyUsed event.
1407      *
1408      * @param  liquidatee   The account to liquidate.
1409      * @param  liquidator   The account that performs the liquidation.
1410      * @param  isBuy        True if the liquidatee has a long position, false otherwise.
1411      * @param  maxPosition  Maximum position size that the liquidator will take post-liquidation.
1412      * @return              The change in position.
1413      */
1414     function liquidate(
1415         address liquidatee,
1416         address liquidator,
1417         bool isBuy,
1418         SignedMath.Int calldata maxPosition
1419     )
1420         external
1421         returns (uint256)
1422     {
1423         I_PerpetualV1 perpetual = I_PerpetualV1(_PERPETUAL_V1_);
1424 
1425         // Verify that this account can liquidate for the liquidator.
1426         require(
1427             liquidator == msg.sender || perpetual.hasAccountPermissions(liquidator, msg.sender),
1428             "msg.sender cannot operate the liquidator account"
1429         );
1430 
1431         // Settle the liquidator's account and get balances.
1432         perpetual.deposit(liquidator, 0);
1433         P1Types.Balance memory initialBalance = perpetual.getAccountBalance(liquidator);
1434 
1435         // Get the maximum liquidatable amount.
1436         SignedMath.Int memory maxPositionDelta = _getMaxPositionDelta(
1437             initialBalance,
1438             isBuy,
1439             maxPosition
1440         );
1441 
1442         // Do the liquidation.
1443         _doLiquidation(
1444             perpetual,
1445             liquidatee,
1446             liquidator,
1447             maxPositionDelta
1448         );
1449 
1450         // Get the balances of the liquidator.
1451         P1Types.Balance memory currentBalance = perpetual.getAccountBalance(liquidator);
1452 
1453         // Get the liquidated amount and fee amount.
1454         (uint256 liqAmount, uint256 feeAmount) = _getLiquidatedAndFeeAmount(
1455             perpetual,
1456             initialBalance,
1457             currentBalance
1458         );
1459 
1460         // Transfer fee from liquidator to insurance fund.
1461         if (feeAmount > 0) {
1462             perpetual.withdraw(liquidator, address(this), feeAmount);
1463             perpetual.deposit(_INSURANCE_FUND_, feeAmount);
1464         }
1465 
1466         // Log the result.
1467         emit LogLiquidatorProxyUsed(
1468             liquidatee,
1469             liquidator,
1470             isBuy,
1471             liqAmount,
1472             feeAmount
1473         );
1474 
1475         return liqAmount;
1476     }
1477 
1478     // ============ Admin Functions ============
1479 
1480     /**
1481      * @dev Allows the owner to set the insurance fund address. Emits the LogInsuranceFundSet event.
1482      *
1483      * @param  insuranceFund  The address to set as the insurance fund.
1484      */
1485     function setInsuranceFund(
1486         address insuranceFund
1487     )
1488         external
1489         onlyOwner
1490     {
1491         _INSURANCE_FUND_ = insuranceFund;
1492         emit LogInsuranceFundSet(insuranceFund);
1493     }
1494 
1495     /**
1496      * @dev Allows the owner to set the insurance fee. Emits the LogInsuranceFeeSet event.
1497      *
1498      * @param  insuranceFee  The new fee as a fixed-point number with 18 decimal places. Max of 50%.
1499      */
1500     function setInsuranceFee(
1501         uint256 insuranceFee
1502     )
1503         external
1504         onlyOwner
1505     {
1506         require(
1507             insuranceFee <= BaseMath.base().div(2),
1508             "insuranceFee cannot be greater than 50%"
1509         );
1510         _INSURANCE_FEE_ = insuranceFee;
1511         emit LogInsuranceFeeSet(insuranceFee);
1512     }
1513 
1514     // ============ Helper Functions ============
1515 
1516     /**
1517      * @dev Calculate (and verify) the maximum amount to liquidate based on the maxPosition input.
1518      */
1519     function _getMaxPositionDelta(
1520         P1Types.Balance memory initialBalance,
1521         bool isBuy,
1522         SignedMath.Int memory maxPosition
1523     )
1524         private
1525         pure
1526         returns (SignedMath.Int memory)
1527     {
1528         SignedMath.Int memory result = maxPosition.signedSub(initialBalance.getPosition());
1529 
1530         require(
1531             result.isPositive == isBuy && result.value > 0,
1532             "Cannot liquidate if it would put liquidator past the specified maxPosition"
1533         );
1534 
1535         return result;
1536     }
1537 
1538     /**
1539      * @dev Perform the liquidation by constructing the correct arguments and sending it to the
1540      * perpetual.
1541      */
1542     function _doLiquidation(
1543         I_PerpetualV1 perpetual,
1544         address liquidatee,
1545         address liquidator,
1546         SignedMath.Int memory maxPositionDelta
1547     )
1548         private
1549     {
1550         // Create accounts. Base protocol requires accounts to be sorted.
1551         bool takerFirst = liquidator < liquidatee;
1552         address[] memory accounts = new address[](2);
1553         uint256 takerIndex = takerFirst ? 0 : 1;
1554         uint256 makerIndex = takerFirst ? 1 : 0;
1555         accounts[takerIndex] = liquidator;
1556         accounts[makerIndex] = liquidatee;
1557 
1558         // Create trade args.
1559         I_PerpetualV1.TradeArg[] memory trades = new I_PerpetualV1.TradeArg[](1);
1560         trades[0] = I_PerpetualV1.TradeArg({
1561             takerIndex: takerIndex,
1562             makerIndex: makerIndex,
1563             trader: _LIQUIDATION_,
1564             data: abi.encode(
1565                 maxPositionDelta.value,
1566                 maxPositionDelta.isPositive,
1567                 false // allOrNothing
1568             )
1569         });
1570 
1571         // Do the liquidation.
1572         perpetual.trade(accounts, trades);
1573     }
1574 
1575     /**
1576      * @dev Calculate the liquidated amount and also the fee amount based on a percentage of the
1577      * value of the repaid debt.
1578      * @return  The position amount bought or sold.
1579      * @return  The fee amount in margin token.
1580      */
1581     function _getLiquidatedAndFeeAmount(
1582         I_PerpetualV1 perpetual,
1583         P1Types.Balance memory initialBalance,
1584         P1Types.Balance memory currentBalance
1585     )
1586         private
1587         view
1588         returns (uint256, uint256)
1589     {
1590         // Get the change in the position and margin of the liquidator.
1591         SignedMath.Int memory deltaPosition =
1592             currentBalance.getPosition().signedSub(initialBalance.getPosition());
1593         SignedMath.Int memory deltaMargin =
1594             currentBalance.getMargin().signedSub(initialBalance.getMargin());
1595 
1596         // Get the change in the balances of the liquidator.
1597         P1Types.Balance memory deltaBalance;
1598         deltaBalance.setPosition(deltaPosition);
1599         deltaBalance.setMargin(deltaMargin);
1600 
1601         // Get the positive and negative value taken by the liquidator.
1602         uint256 price = perpetual.getOraclePrice();
1603         (uint256 posValue, uint256 negValue) = deltaBalance.getPositiveAndNegativeValue(price);
1604 
1605         // Calculate the fee amount based on the liquidation profit.
1606         uint256 feeAmount = posValue > negValue
1607             ? posValue.sub(negValue).baseMul(_INSURANCE_FEE_).div(BaseMath.base())
1608             : 0;
1609 
1610         return (deltaPosition.value, feeAmount);
1611     }
1612 }