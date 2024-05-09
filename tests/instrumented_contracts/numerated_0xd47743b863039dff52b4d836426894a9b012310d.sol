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
575 
576     /**
577      * @dev Divide a value by a base value (result is rounded down).
578      */
579     function baseDiv(
580         uint256 value,
581         uint256 baseValue
582     )
583         internal
584         pure
585         returns (uint256)
586     {
587         return value.mul(BASE).div(baseValue);
588     }
589 
590     /**
591      * @dev Returns a base value representing the reciprocal of another base value (result is
592      *  rounded down).
593      */
594     function baseReciprocal(
595         uint256 baseValue
596     )
597         internal
598         pure
599         returns (uint256)
600     {
601         return baseDiv(BASE, baseValue);
602     }
603 }
604 
605 // File: contracts/protocol/lib/SignedMath.sol
606 
607 /**
608  * @title SignedMath
609  * @author dYdX
610  *
611  * @dev SignedMath library for doing math with signed integers.
612  */
613 library SignedMath {
614     using SafeMath for uint256;
615 
616     // ============ Structs ============
617 
618     struct Int {
619         uint256 value;
620         bool isPositive;
621     }
622 
623     // ============ Functions ============
624 
625     /**
626      * @dev Returns a new signed integer equal to a signed integer plus an unsigned integer.
627      */
628     function add(
629         Int memory sint,
630         uint256 value
631     )
632         internal
633         pure
634         returns (Int memory)
635     {
636         if (sint.isPositive) {
637             return Int({
638                 value: value.add(sint.value),
639                 isPositive: true
640             });
641         }
642         if (sint.value < value) {
643             return Int({
644                 value: value.sub(sint.value),
645                 isPositive: true
646             });
647         }
648         return Int({
649             value: sint.value.sub(value),
650             isPositive: false
651         });
652     }
653 
654     /**
655      * @dev Returns a new signed integer equal to a signed integer minus an unsigned integer.
656      */
657     function sub(
658         Int memory sint,
659         uint256 value
660     )
661         internal
662         pure
663         returns (Int memory)
664     {
665         if (!sint.isPositive) {
666             return Int({
667                 value: value.add(sint.value),
668                 isPositive: false
669             });
670         }
671         if (sint.value > value) {
672             return Int({
673                 value: sint.value.sub(value),
674                 isPositive: true
675             });
676         }
677         return Int({
678             value: value.sub(sint.value),
679             isPositive: false
680         });
681     }
682 
683     /**
684      * @dev Returns a new signed integer equal to a signed integer plus another signed integer.
685      */
686     function signedAdd(
687         Int memory augend,
688         Int memory addend
689     )
690         internal
691         pure
692         returns (Int memory)
693     {
694         return addend.isPositive
695             ? add(augend, addend.value)
696             : sub(augend, addend.value);
697     }
698 
699     /**
700      * @dev Returns a new signed integer equal to a signed integer minus another signed integer.
701      */
702     function signedSub(
703         Int memory minuend,
704         Int memory subtrahend
705     )
706         internal
707         pure
708         returns (Int memory)
709     {
710         return subtrahend.isPositive
711             ? sub(minuend, subtrahend.value)
712             : add(minuend, subtrahend.value);
713     }
714 
715     /**
716      * @dev Returns true if signed integer `a` is greater than signed integer `b`, false otherwise.
717      */
718     function gt(
719         Int memory a,
720         Int memory b
721     )
722         internal
723         pure
724         returns (bool)
725     {
726         if (a.isPositive) {
727             if (b.isPositive) {
728                 return a.value > b.value;
729             } else {
730                 // True, unless both values are zero.
731                 return a.value != 0 || b.value != 0;
732             }
733         } else {
734             if (b.isPositive) {
735                 return false;
736             } else {
737                 return a.value < b.value;
738             }
739         }
740     }
741 
742     /**
743      * @dev Returns the minimum of signed integers `a` and `b`.
744      */
745     function min(
746         Int memory a,
747         Int memory b
748     )
749         internal
750         pure
751         returns (Int memory)
752     {
753         return gt(b, a) ? a : b;
754     }
755 
756     /**
757      * @dev Returns the maximum of signed integers `a` and `b`.
758      */
759     function max(
760         Int memory a,
761         Int memory b
762     )
763         internal
764         pure
765         returns (Int memory)
766     {
767         return gt(a, b) ? a : b;
768     }
769 }
770 
771 // File: contracts/protocol/v1/lib/P1Types.sol
772 
773 /**
774  * @title P1Types
775  * @author dYdX
776  *
777  * @dev Library for common types used in PerpetualV1 contracts.
778  */
779 library P1Types {
780     // ============ Structs ============
781 
782     /**
783      * @dev Used to represent the global index and each account's cached index.
784      *  Used to settle funding paymennts on a per-account basis.
785      */
786     struct Index {
787         uint32 timestamp;
788         bool isPositive;
789         uint128 value;
790     }
791 
792     /**
793      * @dev Used to track the signed margin balance and position balance values for each account.
794      */
795     struct Balance {
796         bool marginIsPositive;
797         bool positionIsPositive;
798         uint120 margin;
799         uint120 position;
800     }
801 
802     /**
803      * @dev Used to cache commonly-used variables that are relatively gas-intensive to obtain.
804      */
805     struct Context {
806         uint256 price;
807         uint256 minCollateral;
808         Index index;
809     }
810 
811     /**
812      * @dev Used by contracts implementing the I_P1Trader interface to return the result of a trade.
813      */
814     struct TradeResult {
815         uint256 marginAmount;
816         uint256 positionAmount;
817         bool isBuy; // From taker's perspective.
818         bytes32 traderFlags;
819     }
820 }
821 
822 // File: contracts/protocol/v1/intf/I_PerpetualV1.sol
823 
824 /**
825  * @title I_PerpetualV1
826  * @author dYdX
827  *
828  * @notice Interface for PerpetualV1.
829  */
830 interface I_PerpetualV1 {
831 
832     // ============ Structs ============
833 
834     struct TradeArg {
835         uint256 takerIndex;
836         uint256 makerIndex;
837         address trader;
838         bytes data;
839     }
840 
841     // ============ State-Changing Functions ============
842 
843     /**
844      * @notice Submits one or more trades between any number of accounts.
845      *
846      * @param  accounts  The sorted list of accounts that are involved in trades.
847      * @param  trades    The list of trades to execute in-order.
848      */
849     function trade(
850         address[] calldata accounts,
851         TradeArg[] calldata trades
852     )
853         external;
854 
855     /**
856      * @notice Withdraw the number of margin tokens equal to the value of the account at the time
857      *  that final settlement occurred.
858      */
859     function withdrawFinalSettlement()
860         external;
861 
862     /**
863      * @notice Deposit some amount of margin tokens from the msg.sender into an account.
864      *
865      * @param  account  The account for which to credit the deposit.
866      * @param  amount   the amount of tokens to deposit.
867      */
868     function deposit(
869         address account,
870         uint256 amount
871     )
872         external;
873 
874     /**
875      * @notice Withdraw some amount of margin tokens from an account to a destination address.
876      *
877      * @param  account      The account for which to debit the withdrawal.
878      * @param  destination  The address to which the tokens are transferred.
879      * @param  amount       The amount of tokens to withdraw.
880      */
881     function withdraw(
882         address account,
883         address destination,
884         uint256 amount
885     )
886         external;
887 
888     /**
889      * @notice Grants or revokes permission for another account to perform certain actions on behalf
890      *  of the sender.
891      *
892      * @param  operator  The account that is approved or disapproved.
893      * @param  approved  True for approval, false for disapproval.
894      */
895     function setLocalOperator(
896         address operator,
897         bool approved
898     )
899         external;
900 
901     // ============ Account Getters ============
902 
903     /**
904      * @notice Get the balance of an account, without accounting for changes in the index.
905      *
906      * @param  account  The address of the account to query the balances of.
907      * @return          The balances of the account.
908      */
909     function getAccountBalance(
910         address account
911     )
912         external
913         view
914         returns (P1Types.Balance memory);
915 
916     /**
917      * @notice Gets the most recently cached index of an account.
918      *
919      * @param  account  The address of the account to query the index of.
920      * @return          The index of the account.
921      */
922     function getAccountIndex(
923         address account
924     )
925         external
926         view
927         returns (P1Types.Index memory);
928 
929     /**
930      * @notice Gets the local operator status of an operator for a particular account.
931      *
932      * @param  account   The account to query the operator for.
933      * @param  operator  The address of the operator to query the status of.
934      * @return           True if the operator is a local operator of the account, false otherwise.
935      */
936     function getIsLocalOperator(
937         address account,
938         address operator
939     )
940         external
941         view
942         returns (bool);
943 
944     // ============ Global Getters ============
945 
946     /**
947      * @notice Gets the global operator status of an address.
948      *
949      * @param  operator  The address of the operator to query the status of.
950      * @return           True if the address is a global operator, false otherwise.
951      */
952     function getIsGlobalOperator(
953         address operator
954     )
955         external
956         view
957         returns (bool);
958 
959     /**
960      * @notice Gets the address of the ERC20 margin contract used for margin deposits.
961      *
962      * @return The address of the ERC20 token.
963      */
964     function getTokenContract()
965         external
966         view
967         returns (address);
968 
969     /**
970      * @notice Gets the current address of the price oracle contract.
971      *
972      * @return The address of the price oracle contract.
973      */
974     function getOracleContract()
975         external
976         view
977         returns (address);
978 
979     /**
980      * @notice Gets the current address of the funder contract.
981      *
982      * @return The address of the funder contract.
983      */
984     function getFunderContract()
985         external
986         view
987         returns (address);
988 
989     /**
990      * @notice Gets the most recently cached global index.
991      *
992      * @return The most recently cached global index.
993      */
994     function getGlobalIndex()
995         external
996         view
997         returns (P1Types.Index memory);
998 
999     /**
1000      * @notice Gets minimum collateralization ratio of the protocol.
1001      *
1002      * @return The minimum-acceptable collateralization ratio, returned as a fixed-point number with
1003      *  18 decimals of precision.
1004      */
1005     function getMinCollateral()
1006         external
1007         view
1008         returns (uint256);
1009 
1010     /**
1011      * @notice Gets the status of whether final-settlement was initiated by the Admin.
1012      *
1013      * @return True if final-settlement was enabled, false otherwise.
1014      */
1015     function getFinalSettlementEnabled()
1016         external
1017         view
1018         returns (bool);
1019 
1020     // ============ Public Getters ============
1021 
1022     /**
1023      * @notice Gets whether an address has permissions to operate an account.
1024      *
1025      * @param  account   The account to query.
1026      * @param  operator  The address to query.
1027      * @return           True if the operator has permission to operate the account,
1028      *                   and false otherwise.
1029      */
1030     function hasAccountPermissions(
1031         address account,
1032         address operator
1033     )
1034         external
1035         view
1036         returns (bool);
1037 
1038     // ============ Authorized Getters ============
1039 
1040     /**
1041      * @notice Gets the price returned by the oracle.
1042      * @dev Only able to be called by global operators.
1043      *
1044      * @return The price returned by the current price oracle.
1045      */
1046     function getOraclePrice()
1047         external
1048         view
1049         returns (uint256);
1050 }
1051 
1052 // File: contracts/protocol/lib/SafeCast.sol
1053 
1054 /**
1055  * @title SafeCast
1056  * @author dYdX
1057  *
1058  * @dev Library for casting uint256 to other types of uint.
1059  */
1060 library SafeCast {
1061 
1062     /**
1063      * @dev Returns the downcasted uint128 from uint256, reverting on
1064      *  overflow (i.e. when the input is greater than largest uint128).
1065      *
1066      *  Counterpart to Solidity's `uint128` operator.
1067      *
1068      *  Requirements:
1069      *  - `value` must fit into 128 bits.
1070      */
1071     function toUint128(
1072         uint256 value
1073     )
1074         internal
1075         pure
1076         returns (uint128)
1077     {
1078         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
1079         return uint128(value);
1080     }
1081 
1082     /**
1083      * @dev Returns the downcasted uint120 from uint256, reverting on
1084      *  overflow (i.e. when the input is greater than largest uint120).
1085      *
1086      *  Counterpart to Solidity's `uint120` operator.
1087      *
1088      *  Requirements:
1089      *  - `value` must fit into 120 bits.
1090      */
1091     function toUint120(
1092         uint256 value
1093     )
1094         internal
1095         pure
1096         returns (uint120)
1097     {
1098         require(value < 2**120, "SafeCast: value doesn\'t fit in 120 bits");
1099         return uint120(value);
1100     }
1101 
1102     /**
1103      * @dev Returns the downcasted uint32 from uint256, reverting on
1104      *  overflow (i.e. when the input is greater than largest uint32).
1105      *
1106      *  Counterpart to Solidity's `uint32` operator.
1107      *
1108      *  Requirements:
1109      *  - `value` must fit into 32 bits.
1110      */
1111     function toUint32(
1112         uint256 value
1113     )
1114         internal
1115         pure
1116         returns (uint32)
1117     {
1118         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
1119         return uint32(value);
1120     }
1121 }
1122 
1123 // File: contracts/protocol/v1/lib/P1BalanceMath.sol
1124 
1125 /**
1126  * @title P1BalanceMath
1127  * @author dYdX
1128  *
1129  * @dev Library for manipulating P1Types.Balance structs.
1130  */
1131 library P1BalanceMath {
1132     using BaseMath for uint256;
1133     using SafeCast for uint256;
1134     using SafeMath for uint256;
1135     using SignedMath for SignedMath.Int;
1136     using P1BalanceMath for P1Types.Balance;
1137 
1138     // ============ Constants ============
1139 
1140     uint256 private constant FLAG_MARGIN_IS_POSITIVE = 1 << (8 * 31);
1141     uint256 private constant FLAG_POSITION_IS_POSITIVE = 1 << (8 * 15);
1142 
1143     // ============ Functions ============
1144 
1145     /**
1146      * @dev Create a copy of the balance struct.
1147      */
1148     function copy(
1149         P1Types.Balance memory balance
1150     )
1151         internal
1152         pure
1153         returns (P1Types.Balance memory)
1154     {
1155         return P1Types.Balance({
1156             marginIsPositive: balance.marginIsPositive,
1157             positionIsPositive: balance.positionIsPositive,
1158             margin: balance.margin,
1159             position: balance.position
1160         });
1161     }
1162 
1163     /**
1164      * @dev In-place add amount to balance.margin.
1165      */
1166     function addToMargin(
1167         P1Types.Balance memory balance,
1168         uint256 amount
1169     )
1170         internal
1171         pure
1172     {
1173         SignedMath.Int memory signedMargin = balance.getMargin();
1174         signedMargin = signedMargin.add(amount);
1175         balance.setMargin(signedMargin);
1176     }
1177 
1178     /**
1179      * @dev In-place subtract amount from balance.margin.
1180      */
1181     function subFromMargin(
1182         P1Types.Balance memory balance,
1183         uint256 amount
1184     )
1185         internal
1186         pure
1187     {
1188         SignedMath.Int memory signedMargin = balance.getMargin();
1189         signedMargin = signedMargin.sub(amount);
1190         balance.setMargin(signedMargin);
1191     }
1192 
1193     /**
1194      * @dev In-place add amount to balance.position.
1195      */
1196     function addToPosition(
1197         P1Types.Balance memory balance,
1198         uint256 amount
1199     )
1200         internal
1201         pure
1202     {
1203         SignedMath.Int memory signedPosition = balance.getPosition();
1204         signedPosition = signedPosition.add(amount);
1205         balance.setPosition(signedPosition);
1206     }
1207 
1208     /**
1209      * @dev In-place subtract amount from balance.position.
1210      */
1211     function subFromPosition(
1212         P1Types.Balance memory balance,
1213         uint256 amount
1214     )
1215         internal
1216         pure
1217     {
1218         SignedMath.Int memory signedPosition = balance.getPosition();
1219         signedPosition = signedPosition.sub(amount);
1220         balance.setPosition(signedPosition);
1221     }
1222 
1223     /**
1224      * @dev Returns the positive and negative values of the margin and position together, given a
1225      *  price, which is used as a conversion rate between the two currencies.
1226      *
1227      *  No rounding occurs here--the returned values are "base values" with extra precision.
1228      */
1229     function getPositiveAndNegativeValue(
1230         P1Types.Balance memory balance,
1231         uint256 price
1232     )
1233         internal
1234         pure
1235         returns (uint256, uint256)
1236     {
1237         uint256 positiveValue = 0;
1238         uint256 negativeValue = 0;
1239 
1240         // add value of margin
1241         if (balance.marginIsPositive) {
1242             positiveValue = uint256(balance.margin).mul(BaseMath.base());
1243         } else {
1244             negativeValue = uint256(balance.margin).mul(BaseMath.base());
1245         }
1246 
1247         // add value of position
1248         uint256 positionValue = uint256(balance.position).mul(price);
1249         if (balance.positionIsPositive) {
1250             positiveValue = positiveValue.add(positionValue);
1251         } else {
1252             negativeValue = negativeValue.add(positionValue);
1253         }
1254 
1255         return (positiveValue, negativeValue);
1256     }
1257 
1258     /**
1259      * @dev Returns a compressed bytes32 representation of the balance for logging.
1260      */
1261     function toBytes32(
1262         P1Types.Balance memory balance
1263     )
1264         internal
1265         pure
1266         returns (bytes32)
1267     {
1268         uint256 result =
1269             uint256(balance.position)
1270             | (uint256(balance.margin) << 128)
1271             | (balance.marginIsPositive ? FLAG_MARGIN_IS_POSITIVE : 0)
1272             | (balance.positionIsPositive ? FLAG_POSITION_IS_POSITIVE : 0);
1273         return bytes32(result);
1274     }
1275 
1276     // ============ Helper Functions ============
1277 
1278     /**
1279      * @dev Returns a SignedMath.Int version of the margin in balance.
1280      */
1281     function getMargin(
1282         P1Types.Balance memory balance
1283     )
1284         internal
1285         pure
1286         returns (SignedMath.Int memory)
1287     {
1288         return SignedMath.Int({
1289             value: balance.margin,
1290             isPositive: balance.marginIsPositive
1291         });
1292     }
1293 
1294     /**
1295      * @dev Returns a SignedMath.Int version of the position in balance.
1296      */
1297     function getPosition(
1298         P1Types.Balance memory balance
1299     )
1300         internal
1301         pure
1302         returns (SignedMath.Int memory)
1303     {
1304         return SignedMath.Int({
1305             value: balance.position,
1306             isPositive: balance.positionIsPositive
1307         });
1308     }
1309 
1310     /**
1311      * @dev In-place modify the signed margin value of a balance.
1312      */
1313     function setMargin(
1314         P1Types.Balance memory balance,
1315         SignedMath.Int memory newMargin
1316     )
1317         internal
1318         pure
1319     {
1320         balance.margin = newMargin.value.toUint120();
1321         balance.marginIsPositive = newMargin.isPositive;
1322     }
1323 
1324     /**
1325      * @dev In-place modify the signed position value of a balance.
1326      */
1327     function setPosition(
1328         P1Types.Balance memory balance,
1329         SignedMath.Int memory newPosition
1330     )
1331         internal
1332         pure
1333     {
1334         balance.position = newPosition.value.toUint120();
1335         balance.positionIsPositive = newPosition.isPositive;
1336     }
1337 }
1338 
1339 // File: contracts/protocol/v1/proxies/P1LiquidatorProxy.sol
1340 
1341 /**
1342  * @title P1LiquidatorProxy
1343  * @author dYdX
1344  *
1345  * @notice Proxy contract for liquidating accounts. A fixed percentage of each liquidation is
1346  * directed to the insurance fund.
1347  */
1348 contract P1LiquidatorProxy is
1349     Ownable
1350 {
1351     using BaseMath for uint256;
1352     using SafeMath for uint256;
1353     using SignedMath for SignedMath.Int;
1354     using P1BalanceMath for P1Types.Balance;
1355     using SafeERC20 for IERC20;
1356 
1357     // ============ Events ============
1358 
1359     event LogLiquidatorProxyUsed(
1360         address indexed liquidatee,
1361         address indexed liquidator,
1362         bool isBuy,
1363         uint256 liquidationAmount,
1364         uint256 feeAmount
1365     );
1366 
1367     event LogInsuranceFundSet(
1368         address insuranceFund
1369     );
1370 
1371     event LogInsuranceFeeSet(
1372         uint256 insuranceFee
1373     );
1374 
1375     // ============ Immutable Storage ============
1376 
1377     // Address of the perpetual contract.
1378     address public _PERPETUAL_V1_;
1379 
1380     // Address of the P1Liquidation contract.
1381     address public _LIQUIDATION_;
1382 
1383     // ============ Mutable Storage ============
1384 
1385     // Address of the insurance fund.
1386     address public _INSURANCE_FUND_;
1387 
1388     // Proportion of liquidation profits that is directed to the insurance fund.
1389     // This number is represented as a fixed-point number with 18 decimals.
1390     uint256 public _INSURANCE_FEE_;
1391 
1392     // ============ Constructor ============
1393 
1394     constructor (
1395         address perpetualV1,
1396         address liquidator,
1397         address insuranceFund,
1398         uint256 insuranceFee
1399     )
1400         public
1401     {
1402         _PERPETUAL_V1_ = perpetualV1;
1403         _LIQUIDATION_ = liquidator;
1404         _INSURANCE_FUND_ = insuranceFund;
1405         _INSURANCE_FEE_ = insuranceFee;
1406 
1407         emit LogInsuranceFundSet(insuranceFund);
1408         emit LogInsuranceFeeSet(insuranceFee);
1409     }
1410 
1411     // ============ External Functions ============
1412 
1413     /**
1414      * @notice Sets the maximum allowance on the perpetual contract. Must be called at least once.
1415      * @dev Cannot be run in the constructor due to technical restrictions in Solidity.
1416      */
1417     function approveMaximumOnPerpetual()
1418         external
1419     {
1420         address perpetual = _PERPETUAL_V1_;
1421         IERC20 tokenContract = IERC20(I_PerpetualV1(perpetual).getTokenContract());
1422 
1423         // safeApprove requires unsetting the allowance first.
1424         tokenContract.safeApprove(perpetual, 0);
1425 
1426         // Set the allowance to the highest possible value.
1427         tokenContract.safeApprove(perpetual, uint256(-1));
1428     }
1429 
1430     /**
1431      * @notice Allows an account below the minimum collateralization to be liquidated by another
1432      *  account. This allows the account to be partially or fully subsumed by the liquidator.
1433      *  A proportion of all liquidation profits is directed to the insurance fund.
1434      * @dev Emits the LogLiquidatorProxyUsed event.
1435      *
1436      * @param  liquidatee   The account to liquidate.
1437      * @param  liquidator   The account that performs the liquidation.
1438      * @param  isBuy        True if the liquidatee has a long position, false otherwise.
1439      * @param  maxPosition  Maximum position size that the liquidator will take post-liquidation.
1440      * @return              The change in position.
1441      */
1442     function liquidate(
1443         address liquidatee,
1444         address liquidator,
1445         bool isBuy,
1446         SignedMath.Int calldata maxPosition
1447     )
1448         external
1449         returns (uint256)
1450     {
1451         I_PerpetualV1 perpetual = I_PerpetualV1(_PERPETUAL_V1_);
1452 
1453         // Verify that this account can liquidate for the liquidator.
1454         require(
1455             liquidator == msg.sender || perpetual.hasAccountPermissions(liquidator, msg.sender),
1456             "msg.sender cannot operate the liquidator account"
1457         );
1458 
1459         // Settle the liquidator's account and get balances.
1460         perpetual.deposit(liquidator, 0);
1461         P1Types.Balance memory initialBalance = perpetual.getAccountBalance(liquidator);
1462 
1463         // Get the maximum liquidatable amount.
1464         SignedMath.Int memory maxPositionDelta = _getMaxPositionDelta(
1465             initialBalance,
1466             isBuy,
1467             maxPosition
1468         );
1469 
1470         // Do the liquidation.
1471         _doLiquidation(
1472             perpetual,
1473             liquidatee,
1474             liquidator,
1475             maxPositionDelta
1476         );
1477 
1478         // Get the balances of the liquidator.
1479         P1Types.Balance memory currentBalance = perpetual.getAccountBalance(liquidator);
1480 
1481         // Get the liquidated amount and fee amount.
1482         (uint256 liqAmount, uint256 feeAmount) = _getLiquidatedAndFeeAmount(
1483             perpetual,
1484             initialBalance,
1485             currentBalance
1486         );
1487 
1488         // Transfer fee from liquidator to insurance fund.
1489         if (feeAmount > 0) {
1490             perpetual.withdraw(liquidator, address(this), feeAmount);
1491             perpetual.deposit(_INSURANCE_FUND_, feeAmount);
1492         }
1493 
1494         // Log the result.
1495         emit LogLiquidatorProxyUsed(
1496             liquidatee,
1497             liquidator,
1498             isBuy,
1499             liqAmount,
1500             feeAmount
1501         );
1502 
1503         return liqAmount;
1504     }
1505 
1506     // ============ Admin Functions ============
1507 
1508     /**
1509      * @dev Allows the owner to set the insurance fund address. Emits the LogInsuranceFundSet event.
1510      *
1511      * @param  insuranceFund  The address to set as the insurance fund.
1512      */
1513     function setInsuranceFund(
1514         address insuranceFund
1515     )
1516         external
1517         onlyOwner
1518     {
1519         _INSURANCE_FUND_ = insuranceFund;
1520         emit LogInsuranceFundSet(insuranceFund);
1521     }
1522 
1523     /**
1524      * @dev Allows the owner to set the insurance fee. Emits the LogInsuranceFeeSet event.
1525      *
1526      * @param  insuranceFee  The new fee as a fixed-point number with 18 decimal places. Max of 50%.
1527      */
1528     function setInsuranceFee(
1529         uint256 insuranceFee
1530     )
1531         external
1532         onlyOwner
1533     {
1534         require(
1535             insuranceFee <= BaseMath.base().div(2),
1536             "insuranceFee cannot be greater than 50%"
1537         );
1538         _INSURANCE_FEE_ = insuranceFee;
1539         emit LogInsuranceFeeSet(insuranceFee);
1540     }
1541 
1542     // ============ Helper Functions ============
1543 
1544     /**
1545      * @dev Calculate (and verify) the maximum amount to liquidate based on the maxPosition input.
1546      */
1547     function _getMaxPositionDelta(
1548         P1Types.Balance memory initialBalance,
1549         bool isBuy,
1550         SignedMath.Int memory maxPosition
1551     )
1552         private
1553         pure
1554         returns (SignedMath.Int memory)
1555     {
1556         SignedMath.Int memory result = maxPosition.signedSub(initialBalance.getPosition());
1557 
1558         require(
1559             result.isPositive == isBuy && result.value > 0,
1560             "Cannot liquidate if it would put liquidator past the specified maxPosition"
1561         );
1562 
1563         return result;
1564     }
1565 
1566     /**
1567      * @dev Perform the liquidation by constructing the correct arguments and sending it to the
1568      * perpetual.
1569      */
1570     function _doLiquidation(
1571         I_PerpetualV1 perpetual,
1572         address liquidatee,
1573         address liquidator,
1574         SignedMath.Int memory maxPositionDelta
1575     )
1576         private
1577     {
1578         // Create accounts. Base protocol requires accounts to be sorted.
1579         bool takerFirst = liquidator < liquidatee;
1580         address[] memory accounts = new address[](2);
1581         uint256 takerIndex = takerFirst ? 0 : 1;
1582         uint256 makerIndex = takerFirst ? 1 : 0;
1583         accounts[takerIndex] = liquidator;
1584         accounts[makerIndex] = liquidatee;
1585 
1586         // Create trade args.
1587         I_PerpetualV1.TradeArg[] memory trades = new I_PerpetualV1.TradeArg[](1);
1588         trades[0] = I_PerpetualV1.TradeArg({
1589             takerIndex: takerIndex,
1590             makerIndex: makerIndex,
1591             trader: _LIQUIDATION_,
1592             data: abi.encode(
1593                 maxPositionDelta.value,
1594                 maxPositionDelta.isPositive,
1595                 false // allOrNothing
1596             )
1597         });
1598 
1599         // Do the liquidation.
1600         perpetual.trade(accounts, trades);
1601     }
1602 
1603     /**
1604      * @dev Calculate the liquidated amount and also the fee amount based on a percentage of the
1605      * value of the repaid debt.
1606      * @return  The position amount bought or sold.
1607      * @return  The fee amount in margin token.
1608      */
1609     function _getLiquidatedAndFeeAmount(
1610         I_PerpetualV1 perpetual,
1611         P1Types.Balance memory initialBalance,
1612         P1Types.Balance memory currentBalance
1613     )
1614         private
1615         view
1616         returns (uint256, uint256)
1617     {
1618         // Get the change in the position and margin of the liquidator.
1619         SignedMath.Int memory deltaPosition =
1620             currentBalance.getPosition().signedSub(initialBalance.getPosition());
1621         SignedMath.Int memory deltaMargin =
1622             currentBalance.getMargin().signedSub(initialBalance.getMargin());
1623 
1624         // Get the change in the balances of the liquidator.
1625         P1Types.Balance memory deltaBalance;
1626         deltaBalance.setPosition(deltaPosition);
1627         deltaBalance.setMargin(deltaMargin);
1628 
1629         // Get the positive and negative value taken by the liquidator.
1630         uint256 price = perpetual.getOraclePrice();
1631         (uint256 posValue, uint256 negValue) = deltaBalance.getPositiveAndNegativeValue(price);
1632 
1633         // Calculate the fee amount based on the liquidation profit.
1634         uint256 feeAmount = posValue > negValue
1635             ? posValue.sub(negValue).baseMul(_INSURANCE_FEE_).div(BaseMath.base())
1636             : 0;
1637 
1638         return (deltaPosition.value, feeAmount);
1639     }
1640 }