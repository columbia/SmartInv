1 // Sources flattened with buidler v1.4.3 https://buidler.dev
2 
3 // File @openzeppelin/contracts/utils/SafeCast.sol@v3.1.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.0;
8 
9 
10 /**
11  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
12  * checks.
13  *
14  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
15  * easily result in undesired exploitation or bugs, since developers usually
16  * assume that overflows raise errors. `SafeCast` restores this intuition by
17  * reverting the transaction when such an operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  *
22  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
23  * all math on `uint256` and `int256` and then downcasting.
24  */
25 library SafeCast {
26 
27     /**
28      * @dev Returns the downcasted uint128 from uint256, reverting on
29      * overflow (when the input is greater than largest uint128).
30      *
31      * Counterpart to Solidity's `uint128` operator.
32      *
33      * Requirements:
34      *
35      * - input must fit into 128 bits
36      */
37     function toUint128(uint256 value) internal pure returns (uint128) {
38         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
39         return uint128(value);
40     }
41 
42     /**
43      * @dev Returns the downcasted uint64 from uint256, reverting on
44      * overflow (when the input is greater than largest uint64).
45      *
46      * Counterpart to Solidity's `uint64` operator.
47      *
48      * Requirements:
49      *
50      * - input must fit into 64 bits
51      */
52     function toUint64(uint256 value) internal pure returns (uint64) {
53         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
54         return uint64(value);
55     }
56 
57     /**
58      * @dev Returns the downcasted uint32 from uint256, reverting on
59      * overflow (when the input is greater than largest uint32).
60      *
61      * Counterpart to Solidity's `uint32` operator.
62      *
63      * Requirements:
64      *
65      * - input must fit into 32 bits
66      */
67     function toUint32(uint256 value) internal pure returns (uint32) {
68         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
69         return uint32(value);
70     }
71 
72     /**
73      * @dev Returns the downcasted uint16 from uint256, reverting on
74      * overflow (when the input is greater than largest uint16).
75      *
76      * Counterpart to Solidity's `uint16` operator.
77      *
78      * Requirements:
79      *
80      * - input must fit into 16 bits
81      */
82     function toUint16(uint256 value) internal pure returns (uint16) {
83         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
84         return uint16(value);
85     }
86 
87     /**
88      * @dev Returns the downcasted uint8 from uint256, reverting on
89      * overflow (when the input is greater than largest uint8).
90      *
91      * Counterpart to Solidity's `uint8` operator.
92      *
93      * Requirements:
94      *
95      * - input must fit into 8 bits.
96      */
97     function toUint8(uint256 value) internal pure returns (uint8) {
98         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
99         return uint8(value);
100     }
101 
102     /**
103      * @dev Converts a signed int256 into an unsigned uint256.
104      *
105      * Requirements:
106      *
107      * - input must be greater than or equal to 0.
108      */
109     function toUint256(int256 value) internal pure returns (uint256) {
110         require(value >= 0, "SafeCast: value must be positive");
111         return uint256(value);
112     }
113 
114     /**
115      * @dev Returns the downcasted int128 from int256, reverting on
116      * overflow (when the input is less than smallest int128 or
117      * greater than largest int128).
118      *
119      * Counterpart to Solidity's `int128` operator.
120      *
121      * Requirements:
122      *
123      * - input must fit into 128 bits
124      *
125      * _Available since v3.1._
126      */
127     function toInt128(int256 value) internal pure returns (int128) {
128         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
129         return int128(value);
130     }
131 
132     /**
133      * @dev Returns the downcasted int64 from int256, reverting on
134      * overflow (when the input is less than smallest int64 or
135      * greater than largest int64).
136      *
137      * Counterpart to Solidity's `int64` operator.
138      *
139      * Requirements:
140      *
141      * - input must fit into 64 bits
142      *
143      * _Available since v3.1._
144      */
145     function toInt64(int256 value) internal pure returns (int64) {
146         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
147         return int64(value);
148     }
149 
150     /**
151      * @dev Returns the downcasted int32 from int256, reverting on
152      * overflow (when the input is less than smallest int32 or
153      * greater than largest int32).
154      *
155      * Counterpart to Solidity's `int32` operator.
156      *
157      * Requirements:
158      *
159      * - input must fit into 32 bits
160      *
161      * _Available since v3.1._
162      */
163     function toInt32(int256 value) internal pure returns (int32) {
164         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
165         return int32(value);
166     }
167 
168     /**
169      * @dev Returns the downcasted int16 from int256, reverting on
170      * overflow (when the input is less than smallest int16 or
171      * greater than largest int16).
172      *
173      * Counterpart to Solidity's `int16` operator.
174      *
175      * Requirements:
176      *
177      * - input must fit into 16 bits
178      *
179      * _Available since v3.1._
180      */
181     function toInt16(int256 value) internal pure returns (int16) {
182         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
183         return int16(value);
184     }
185 
186     /**
187      * @dev Returns the downcasted int8 from int256, reverting on
188      * overflow (when the input is less than smallest int8 or
189      * greater than largest int8).
190      *
191      * Counterpart to Solidity's `int8` operator.
192      *
193      * Requirements:
194      *
195      * - input must fit into 8 bits.
196      *
197      * _Available since v3.1._
198      */
199     function toInt8(int256 value) internal pure returns (int8) {
200         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
201         return int8(value);
202     }
203 
204     /**
205      * @dev Converts an unsigned uint256 into a signed int256.
206      *
207      * Requirements:
208      *
209      * - input must be less than or equal to maxInt256.
210      */
211     function toInt256(uint256 value) internal pure returns (int256) {
212         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
213         return int256(value);
214     }
215 }
216 
217 
218 // File @openzeppelin/contracts/math/SafeMath.sol@v3.1.0
219 
220 pragma solidity ^0.6.0;
221 
222 /**
223  * @dev Wrappers over Solidity's arithmetic operations with added overflow
224  * checks.
225  *
226  * Arithmetic operations in Solidity wrap on overflow. This can easily result
227  * in bugs, because programmers usually assume that an overflow raises an
228  * error, which is the standard behavior in high level programming languages.
229  * `SafeMath` restores this intuition by reverting the transaction when an
230  * operation overflows.
231  *
232  * Using this library instead of the unchecked operations eliminates an entire
233  * class of bugs, so it's recommended to use it always.
234  */
235 library SafeMath {
236     /**
237      * @dev Returns the addition of two unsigned integers, reverting on
238      * overflow.
239      *
240      * Counterpart to Solidity's `+` operator.
241      *
242      * Requirements:
243      *
244      * - Addition cannot overflow.
245      */
246     function add(uint256 a, uint256 b) internal pure returns (uint256) {
247         uint256 c = a + b;
248         require(c >= a, "SafeMath: addition overflow");
249 
250         return c;
251     }
252 
253     /**
254      * @dev Returns the subtraction of two unsigned integers, reverting on
255      * overflow (when the result is negative).
256      *
257      * Counterpart to Solidity's `-` operator.
258      *
259      * Requirements:
260      *
261      * - Subtraction cannot overflow.
262      */
263     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
264         return sub(a, b, "SafeMath: subtraction overflow");
265     }
266 
267     /**
268      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
269      * overflow (when the result is negative).
270      *
271      * Counterpart to Solidity's `-` operator.
272      *
273      * Requirements:
274      *
275      * - Subtraction cannot overflow.
276      */
277     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
278         require(b <= a, errorMessage);
279         uint256 c = a - b;
280 
281         return c;
282     }
283 
284     /**
285      * @dev Returns the multiplication of two unsigned integers, reverting on
286      * overflow.
287      *
288      * Counterpart to Solidity's `*` operator.
289      *
290      * Requirements:
291      *
292      * - Multiplication cannot overflow.
293      */
294     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
295         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
296         // benefit is lost if 'b' is also tested.
297         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
298         if (a == 0) {
299             return 0;
300         }
301 
302         uint256 c = a * b;
303         require(c / a == b, "SafeMath: multiplication overflow");
304 
305         return c;
306     }
307 
308     /**
309      * @dev Returns the integer division of two unsigned integers. Reverts on
310      * division by zero. The result is rounded towards zero.
311      *
312      * Counterpart to Solidity's `/` operator. Note: this function uses a
313      * `revert` opcode (which leaves remaining gas untouched) while Solidity
314      * uses an invalid opcode to revert (consuming all remaining gas).
315      *
316      * Requirements:
317      *
318      * - The divisor cannot be zero.
319      */
320     function div(uint256 a, uint256 b) internal pure returns (uint256) {
321         return div(a, b, "SafeMath: division by zero");
322     }
323 
324     /**
325      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
326      * division by zero. The result is rounded towards zero.
327      *
328      * Counterpart to Solidity's `/` operator. Note: this function uses a
329      * `revert` opcode (which leaves remaining gas untouched) while Solidity
330      * uses an invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      *
334      * - The divisor cannot be zero.
335      */
336     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
337         require(b > 0, errorMessage);
338         uint256 c = a / b;
339         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
340 
341         return c;
342     }
343 
344     /**
345      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
346      * Reverts when dividing by zero.
347      *
348      * Counterpart to Solidity's `%` operator. This function uses a `revert`
349      * opcode (which leaves remaining gas untouched) while Solidity uses an
350      * invalid opcode to revert (consuming all remaining gas).
351      *
352      * Requirements:
353      *
354      * - The divisor cannot be zero.
355      */
356     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
357         return mod(a, b, "SafeMath: modulo by zero");
358     }
359 
360     /**
361      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
362      * Reverts with custom message when dividing by zero.
363      *
364      * Counterpart to Solidity's `%` operator. This function uses a `revert`
365      * opcode (which leaves remaining gas untouched) while Solidity uses an
366      * invalid opcode to revert (consuming all remaining gas).
367      *
368      * Requirements:
369      *
370      * - The divisor cannot be zero.
371      */
372     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
373         require(b != 0, errorMessage);
374         return a % b;
375     }
376 }
377 
378 
379 // File @openzeppelin/contracts/math/SignedSafeMath.sol@v3.1.0
380 
381 pragma solidity ^0.6.0;
382 
383 /**
384  * @title SignedSafeMath
385  * @dev Signed math operations with safety checks that revert on error.
386  */
387 library SignedSafeMath {
388     int256 constant private _INT256_MIN = -2**255;
389 
390         /**
391      * @dev Returns the multiplication of two signed integers, reverting on
392      * overflow.
393      *
394      * Counterpart to Solidity's `*` operator.
395      *
396      * Requirements:
397      *
398      * - Multiplication cannot overflow.
399      */
400     function mul(int256 a, int256 b) internal pure returns (int256) {
401         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
402         // benefit is lost if 'b' is also tested.
403         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
404         if (a == 0) {
405             return 0;
406         }
407 
408         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
409 
410         int256 c = a * b;
411         require(c / a == b, "SignedSafeMath: multiplication overflow");
412 
413         return c;
414     }
415 
416     /**
417      * @dev Returns the integer division of two signed integers. Reverts on
418      * division by zero. The result is rounded towards zero.
419      *
420      * Counterpart to Solidity's `/` operator. Note: this function uses a
421      * `revert` opcode (which leaves remaining gas untouched) while Solidity
422      * uses an invalid opcode to revert (consuming all remaining gas).
423      *
424      * Requirements:
425      *
426      * - The divisor cannot be zero.
427      */
428     function div(int256 a, int256 b) internal pure returns (int256) {
429         require(b != 0, "SignedSafeMath: division by zero");
430         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
431 
432         int256 c = a / b;
433 
434         return c;
435     }
436 
437     /**
438      * @dev Returns the subtraction of two signed integers, reverting on
439      * overflow.
440      *
441      * Counterpart to Solidity's `-` operator.
442      *
443      * Requirements:
444      *
445      * - Subtraction cannot overflow.
446      */
447     function sub(int256 a, int256 b) internal pure returns (int256) {
448         int256 c = a - b;
449         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
450 
451         return c;
452     }
453 
454     /**
455      * @dev Returns the addition of two signed integers, reverting on
456      * overflow.
457      *
458      * Counterpart to Solidity's `+` operator.
459      *
460      * Requirements:
461      *
462      * - Addition cannot overflow.
463      */
464     function add(int256 a, int256 b) internal pure returns (int256) {
465         int256 c = a + b;
466         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
467 
468         return c;
469     }
470 }
471 
472 
473 // File @openzeppelin/contracts/GSN/Context.sol@v3.1.0
474 
475 pragma solidity ^0.6.0;
476 
477 /*
478  * @dev Provides information about the current execution context, including the
479  * sender of the transaction and its data. While these are generally available
480  * via msg.sender and msg.data, they should not be accessed in such a direct
481  * manner, since when dealing with GSN meta-transactions the account sending and
482  * paying for execution may not be the actual sender (as far as an application
483  * is concerned).
484  *
485  * This contract is only required for intermediate, library-like contracts.
486  */
487 abstract contract Context {
488     function _msgSender() internal view virtual returns (address payable) {
489         return msg.sender;
490     }
491 
492     function _msgData() internal view virtual returns (bytes memory) {
493         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
494         return msg.data;
495     }
496 }
497 
498 
499 // File @openzeppelin/contracts/access/Ownable.sol@v3.1.0
500 
501 pragma solidity ^0.6.0;
502 
503 /**
504  * @dev Contract module which provides a basic access control mechanism, where
505  * there is an account (an owner) that can be granted exclusive access to
506  * specific functions.
507  *
508  * By default, the owner account will be the one that deploys the contract. This
509  * can later be changed with {transferOwnership}.
510  *
511  * This module is used through inheritance. It will make available the modifier
512  * `onlyOwner`, which can be applied to your functions to restrict their use to
513  * the owner.
514  */
515 contract Ownable is Context {
516     address private _owner;
517 
518     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
519 
520     /**
521      * @dev Initializes the contract setting the deployer as the initial owner.
522      */
523     constructor () internal {
524         address msgSender = _msgSender();
525         _owner = msgSender;
526         emit OwnershipTransferred(address(0), msgSender);
527     }
528 
529     /**
530      * @dev Returns the address of the current owner.
531      */
532     function owner() public view returns (address) {
533         return _owner;
534     }
535 
536     /**
537      * @dev Throws if called by any account other than the owner.
538      */
539     modifier onlyOwner() {
540         require(_owner == _msgSender(), "Ownable: caller is not the owner");
541         _;
542     }
543 
544     /**
545      * @dev Leaves the contract without owner. It will not be possible to call
546      * `onlyOwner` functions anymore. Can only be called by the current owner.
547      *
548      * NOTE: Renouncing ownership will leave the contract without an owner,
549      * thereby removing any functionality that is only available to the owner.
550      */
551     function renounceOwnership() public virtual onlyOwner {
552         emit OwnershipTransferred(_owner, address(0));
553         _owner = address(0);
554     }
555 
556     /**
557      * @dev Transfers ownership of the contract to a new account (`newOwner`).
558      * Can only be called by the current owner.
559      */
560     function transferOwnership(address newOwner) public virtual onlyOwner {
561         require(newOwner != address(0), "Ownable: new owner is the zero address");
562         emit OwnershipTransferred(_owner, newOwner);
563         _owner = newOwner;
564     }
565 }
566 
567 
568 // File @animoca/ethereum-contracts-erc20_base/contracts/token/ERC20/IERC20.sol@v3.0.0
569 
570 /*
571 https://github.com/OpenZeppelin/openzeppelin-contracts
572 
573 The MIT License (MIT)
574 
575 Copyright (c) 2016-2019 zOS Global Limited
576 
577 Permission is hereby granted, free of charge, to any person obtaining
578 a copy of this software and associated documentation files (the
579 "Software"), to deal in the Software without restriction, including
580 without limitation the rights to use, copy, modify, merge, publish,
581 distribute, sublicense, and/or sell copies of the Software, and to
582 permit persons to whom the Software is furnished to do so, subject to
583 the following conditions:
584 
585 The above copyright notice and this permission notice shall be included
586 in all copies or substantial portions of the Software.
587 
588 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
589 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
590 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
591 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
592 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
593 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
594 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
595 */
596 
597 pragma solidity 0.6.8;
598 
599 /**
600  * @dev Interface of the ERC20 standard as defined in the EIP.
601  */
602 interface IERC20 {
603 
604     /**
605      * @dev Emitted when `value` tokens are moved from one account (`from`) to
606      * another (`to`).
607      *
608      * Note that `value` may be zero.
609      */
610     event Transfer(
611         address indexed _from,
612         address indexed _to,
613         uint256 _value
614     );
615 
616     /**
617      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
618      * a call to {approve}. `value` is the new allowance.
619      */
620     event Approval(
621         address indexed _owner,
622         address indexed _spender,
623         uint256 _value
624     );
625 
626     /**
627      * @dev Returns the amount of tokens in existence.
628      */
629     function totalSupply() external view returns (uint256);
630 
631     /**
632      * @dev Returns the amount of tokens owned by `account`.
633      */
634     function balanceOf(address account) external view returns (uint256);
635 
636     /**
637      * @dev Moves `amount` tokens from the caller's account to `recipient`.
638      *
639      * Returns a boolean value indicating whether the operation succeeded.
640      *
641      * Emits a {Transfer} event.
642      */
643     function transfer(address recipient, uint256 amount) external returns (bool);
644 
645     /**
646      * @dev Returns the remaining number of tokens that `spender` will be
647      * allowed to spend on behalf of `owner` through {transferFrom}. This is
648      * zero by default.
649      *
650      * This value changes when {approve} or {transferFrom} are called.
651      */
652     function allowance(address owner, address spender) external view returns (uint256);
653 
654     /**
655      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
656      *
657      * Returns a boolean value indicating whether the operation succeeded.
658      *
659      * IMPORTANT: Beware that changing an allowance with this method brings the risk
660      * that someone may use both the old and the new allowance by unfortunate
661      * transaction ordering. One possible solution to mitigate this race
662      * condition is to first reduce the spender's allowance to 0 and set the
663      * desired value afterwards:
664      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
665      *
666      * Emits an {Approval} event.
667      */
668     function approve(address spender, uint256 amount) external returns (bool);
669 
670     /**
671      * @dev Moves `amount` tokens from `sender` to `recipient` using the
672      * allowance mechanism. `amount` is then deducted from the caller's
673      * allowance.
674      *
675      * Returns a boolean value indicating whether the operation succeeded.
676      *
677      * Emits a {Transfer} event.
678      */
679     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
680 }
681 
682 
683 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.1.0
684 
685 pragma solidity ^0.6.0;
686 
687 /**
688  * @dev Interface of the ERC165 standard, as defined in the
689  * https://eips.ethereum.org/EIPS/eip-165[EIP].
690  *
691  * Implementers can declare support of contract interfaces, which can then be
692  * queried by others ({ERC165Checker}).
693  *
694  * For an implementation, see {ERC165}.
695  */
696 interface IERC165 {
697     /**
698      * @dev Returns true if this contract implements the interface defined by
699      * `interfaceId`. See the corresponding
700      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
701      * to learn more about how these ids are created.
702      *
703      * This function call must use less than 30 000 gas.
704      */
705     function supportsInterface(bytes4 interfaceId) external view returns (bool);
706 }
707 
708 
709 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.1.0
710 
711 pragma solidity ^0.6.0;
712 
713 
714 /**
715  * @dev Implementation of the {IERC165} interface.
716  *
717  * Contracts may inherit from this and call {_registerInterface} to declare
718  * their support of an interface.
719  */
720 contract ERC165 is IERC165 {
721     /*
722      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
723      */
724     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
725 
726     /**
727      * @dev Mapping of interface ids to whether or not it's supported.
728      */
729     mapping(bytes4 => bool) private _supportedInterfaces;
730 
731     constructor () internal {
732         // Derived contracts need only register support for their own interfaces,
733         // we register support for ERC165 itself here
734         _registerInterface(_INTERFACE_ID_ERC165);
735     }
736 
737     /**
738      * @dev See {IERC165-supportsInterface}.
739      *
740      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
741      */
742     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
743         return _supportedInterfaces[interfaceId];
744     }
745 
746     /**
747      * @dev Registers the contract as an implementer of the interface defined by
748      * `interfaceId`. Support of the actual ERC165 interface is automatic and
749      * registering its interface id is not required.
750      *
751      * See {IERC165-supportsInterface}.
752      *
753      * Requirements:
754      *
755      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
756      */
757     function _registerInterface(bytes4 interfaceId) internal virtual {
758         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
759         _supportedInterfaces[interfaceId] = true;
760     }
761 }
762 
763 
764 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/IERC1155TokenReceiver.sol@v5.0.0
765 
766 pragma solidity 0.6.8;
767 
768 /**
769  * @title ERC-1155 Multi Token Standard, token receiver
770  * @dev See https://eips.ethereum.org/EIPS/eip-1155
771  * Interface for any contract that wants to support transfers from ERC1155 asset contracts.
772  * Note: The ERC-165 identifier for this interface is 0x4e2312e0.
773  */
774 interface IERC1155TokenReceiver {
775 
776     /**
777      * @notice Handle the receipt of a single ERC1155 token type.
778      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
779      * This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
780      * This function MUST revert if it rejects the transfer.
781      * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
782      * @param operator  The address which initiated the transfer (i.e. msg.sender)
783      * @param from      The address which previously owned the token
784      * @param id        The ID of the token being transferred
785      * @param value     The amount of tokens being transferred
786      * @param data      Additional data with no specified format
787      * @return bytes4   `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
788     */
789     function onERC1155Received(
790         address operator,
791         address from,
792         uint256 id,
793         uint256 value,
794         bytes calldata data
795     ) external returns (bytes4);
796 
797     /**
798      * @notice Handle the receipt of multiple ERC1155 token types.
799      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
800      * This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
801      * This function MUST revert if it rejects the transfer(s).
802      * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
803      * @param operator  The address which initiated the batch transfer (i.e. msg.sender)
804      * @param from      The address which previously owned the token
805      * @param ids       An array containing ids of each token being transferred (order and length must match _values array)
806      * @param values    An array containing amounts of each token being transferred (order and length must match _ids array)
807      * @param data      Additional data with no specified format
808      * @return          `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
809     */
810     function onERC1155BatchReceived(
811         address operator,
812         address from,
813         uint256[] calldata ids,
814         uint256[] calldata values,
815         bytes calldata data
816     ) external returns (bytes4);
817 }
818 
819 
820 // File @animoca/ethereum-contracts-assets_inventory/contracts/token/ERC1155/ERC1155TokenReceiver.sol@v5.0.0
821 
822 pragma solidity 0.6.8;
823 
824 
825 
826 abstract contract ERC1155TokenReceiver is IERC1155TokenReceiver, ERC165 {
827 
828     // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
829     bytes4 internal constant _ERC1155_RECEIVED = 0xf23a6e61;
830 
831     // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
832     bytes4 internal constant _ERC1155_BATCH_RECEIVED = 0xbc197c81;
833 
834     bytes4 internal constant _ERC1155_REJECTED = 0xffffffff;
835 
836     constructor() internal {
837         _registerInterface(type(IERC1155TokenReceiver).interfaceId);
838     }
839 }
840 
841 
842 // File @animoca/ethereum-contracts-nft_staking/contracts/staking/NftStaking.sol@v3.0.4
843 
844 pragma solidity 0.6.8;
845 
846 
847 
848 
849 
850 
851 
852 /**
853  * @title NFT Staking
854  * Distribute ERC20 rewards over discrete-time schedules for the staking of NFTs.
855  * This contract is designed on a self-service model, where users will stake NFTs, unstake NFTs and claim rewards through their own transactions only.
856  */
857 abstract contract NftStaking is ERC1155TokenReceiver, Ownable {
858     using SafeCast for uint256;
859     using SafeMath for uint256;
860     using SignedSafeMath for int256;
861 
862     event RewardsAdded(uint256 startPeriod, uint256 endPeriod, uint256 rewardsPerCycle);
863 
864     event Started();
865 
866     event NftStaked(address staker, uint256 cycle, uint256 tokenId, uint256 weight);
867 
868     event NftUnstaked(address staker, uint256 cycle, uint256 tokenId, uint256 weight);
869 
870     event RewardsClaimed(address staker, uint256 cycle, uint256 startPeriod, uint256 periods, uint256 amount);
871 
872     event HistoriesUpdated(address staker, uint256 startCycle, uint256 stakerStake, uint256 globalStake);
873 
874     event Disabled();
875 
876     /**
877      * Used to represent the current staking status of an NFT.
878      * Optimised for use in storage.
879      */
880     struct TokenInfo {
881         address owner;
882         uint64 weight;
883         uint16 depositCycle;
884         uint16 withdrawCycle;
885     }
886 
887     /**
888      * Used as a historical record of change of stake.
889      * Stake represents an aggregation of staked token weights.
890      * Optimised for use in storage.
891      */
892     struct Snapshot {
893         uint128 stake;
894         uint128 startCycle;
895     }
896 
897     /**
898      * Used to represent a staker's information about the next claim.
899      * Optimised for use in storage.
900      */
901     struct NextClaim {
902         uint16 period;
903         uint64 globalSnapshotIndex;
904         uint64 stakerSnapshotIndex;
905     }
906 
907     /**
908      * Used as a container to hold result values from computing rewards.
909      */
910     struct ComputedClaim {
911         uint16 startPeriod;
912         uint16 periods;
913         uint256 amount;
914     }
915 
916     bool public enabled = true;
917 
918     uint256 public totalRewardsPool;
919 
920     uint256 public startTimestamp;
921 
922     IERC20 public immutable rewardsTokenContract;
923     IWhitelistedNftContract public immutable whitelistedNftContract;
924 
925     uint32 public immutable cycleLengthInSeconds;
926     uint16 public immutable periodLengthInCycles;
927 
928     Snapshot[] public globalHistory;
929 
930     /* staker => snapshots*/
931     mapping(address => Snapshot[]) public stakerHistories;
932 
933     /* staker => next claim */
934     mapping(address => NextClaim) public nextClaims;
935 
936     /* tokenId => token info */
937     mapping(uint256 => TokenInfo) public tokenInfos;
938 
939     /* period => rewardsPerCycle */
940     mapping(uint256 => uint256) public rewardsSchedule;
941 
942     modifier hasStarted() {
943         require(startTimestamp != 0, "NftStaking: staking not started");
944         _;
945     }
946 
947     modifier hasNotStarted() {
948         require(startTimestamp == 0, "NftStaking: staking has started");
949         _;
950     }
951 
952     modifier isEnabled() {
953         require(enabled, "NftStaking: contract is not enabled");
954         _;
955     }
956 
957     modifier isNotEnabled() {
958         require(!enabled, "NftStaking: contract is enabled");
959         _;
960     }
961 
962     /**
963      * Constructor.
964      * @dev Reverts if the period length value is zero.
965      * @dev Reverts if the cycle length value is zero.
966      * @dev Warning: cycles and periods need to be calibrated carefully. Small values will increase computation load while estimating and claiming rewards. Big values will increase the time to wait before a new period becomes claimable.
967      * @param cycleLengthInSeconds_ The length of a cycle, in seconds.
968      * @param periodLengthInCycles_ The length of a period, in cycles.
969      * @param whitelistedNftContract_ The ERC1155-compliant (optional ERC721-compliance) contract from which staking is accepted.
970      * @param rewardsTokenContract_ The ERC20-based token used as staking rewards.
971      */
972     constructor(
973         uint32 cycleLengthInSeconds_,
974         uint16 periodLengthInCycles_,
975         IWhitelistedNftContract whitelistedNftContract_,
976         IERC20 rewardsTokenContract_
977     ) internal {
978         require(cycleLengthInSeconds_ >= 1 minutes, "NftStaking: invalid cycle length");
979         require(periodLengthInCycles_ >= 2, "NftStaking: invalid period length");
980 
981         cycleLengthInSeconds = cycleLengthInSeconds_;
982         periodLengthInCycles = periodLengthInCycles_;
983         whitelistedNftContract = whitelistedNftContract_;
984         rewardsTokenContract = rewardsTokenContract_;
985     }
986 
987     /*                                            Admin Public Functions                                            */
988 
989     /**
990      * Adds `rewardsPerCycle` reward amount for the period range from `startPeriod` to `endPeriod`, inclusive, to the rewards schedule.
991      * The necessary amount of reward tokens is transferred to the contract. Cannot be used for past periods.
992      * Can only be used to add rewards and not to remove them.
993      * @dev Reverts if not called by the owner.
994      * @dev Reverts if the start period is zero.
995      * @dev Reverts if the end period precedes the start period.
996      * @dev Reverts if attempting to add rewards for a period earlier than the current, after staking has started.
997      * @dev Reverts if the reward tokens transfer fails.
998      * @dev The rewards token contract emits an ERC20 Transfer event for the reward tokens transfer.
999      * @dev Emits a RewardsAdded event.
1000      * @param startPeriod The starting period (inclusive).
1001      * @param endPeriod The ending period (inclusive).
1002      * @param rewardsPerCycle The reward amount to add for each cycle within range.
1003      */
1004     function addRewardsForPeriods(
1005         uint16 startPeriod,
1006         uint16 endPeriod,
1007         uint256 rewardsPerCycle
1008     ) external onlyOwner {
1009         require(startPeriod != 0 && startPeriod <= endPeriod, "NftStaking: wrong period range");
1010 
1011         uint16 periodLengthInCycles_ = periodLengthInCycles;
1012 
1013         if (startTimestamp != 0) {
1014             require(
1015                 startPeriod >= _getCurrentPeriod(periodLengthInCycles_),
1016                 "NftStaking: already committed reward schedule"
1017             );
1018         }
1019 
1020         for (uint256 period = startPeriod; period <= endPeriod; ++period) {
1021             rewardsSchedule[period] = rewardsSchedule[period].add(rewardsPerCycle);
1022         }
1023 
1024         uint256 addedRewards = rewardsPerCycle.mul(periodLengthInCycles_).mul(endPeriod - startPeriod + 1);
1025 
1026         totalRewardsPool = totalRewardsPool.add(addedRewards);
1027 
1028         require(
1029             rewardsTokenContract.transferFrom(msg.sender, address(this), addedRewards),
1030             "NftStaking: failed to add funds to the reward pool"
1031         );
1032 
1033         emit RewardsAdded(startPeriod, endPeriod, rewardsPerCycle);
1034     }
1035 
1036     /**
1037      * Starts the first cycle of staking, enabling users to stake NFTs.
1038      * @dev Reverts if not called by the owner.
1039      * @dev Reverts if the staking has already started.
1040      * @dev Emits a Started event.
1041      */
1042     function start() public onlyOwner hasNotStarted {
1043         startTimestamp = now;
1044         emit Started();
1045     }
1046 
1047     /**
1048      * Permanently disables all staking and claiming.
1049      * This is an emergency recovery feature which is NOT part of the normal contract operation.
1050      * @dev Reverts if not called by the owner.
1051      * @dev Emits a Disabled event.
1052      */
1053     function disable() public onlyOwner {
1054         enabled = false;
1055         emit Disabled();
1056     }
1057 
1058     /**
1059      * Withdraws a specified amount of reward tokens from the contract it has been disabled.
1060      * @dev Reverts if not called by the owner.
1061      * @dev Reverts if the contract has not been disabled.
1062      * @dev Reverts if the reward tokens transfer fails.
1063      * @dev The rewards token contract emits an ERC20 Transfer event for the reward tokens transfer.
1064      * @param amount The amount to withdraw.
1065      */
1066     function withdrawRewardsPool(uint256 amount) public onlyOwner isNotEnabled {
1067         require(
1068             rewardsTokenContract.transfer(msg.sender, amount),
1069             "NftStaking: failed to withdraw from the rewards pool"
1070         );
1071     }
1072 
1073     /*                                             ERC1155TokenReceiver                                             */
1074 
1075     function onERC1155Received(
1076         address, /*operator*/
1077         address from,
1078         uint256 id,
1079         uint256, /*value*/
1080         bytes calldata /*data*/
1081     ) external virtual override returns (bytes4) {
1082         _stakeNft(id, from);
1083         return _ERC1155_RECEIVED;
1084     }
1085 
1086     function onERC1155BatchReceived(
1087         address, /*operator*/
1088         address from,
1089         uint256[] calldata ids,
1090         uint256[] calldata, /*values*/
1091         bytes calldata /*data*/
1092     ) external virtual override returns (bytes4) {
1093         for (uint256 i = 0; i < ids.length; ++i) {
1094             _stakeNft(ids[i], from);
1095         }
1096         return _ERC1155_BATCH_RECEIVED;
1097     }
1098 
1099     /*                                            Staking Public Functions                                            */
1100 
1101     /**
1102      * Unstakes a deposited NFT from the contract and updates the histories accordingly.
1103      * The NFT's weight will not count for the current cycle.
1104      * @dev Reverts if the caller is not the original owner of the NFT.
1105      * @dev While the contract is enabled, reverts if the NFT is still frozen.
1106      * @dev Reverts if the NFT transfer back to the original owner fails.
1107      * @dev If ERC1155 safe transfers are supported by the receiver wallet, the whitelisted NFT contract emits an ERC1155 TransferSingle event for the NFT transfer back to the staker.
1108      * @dev If ERC1155 safe transfers are not supported by the receiver wallet, the whitelisted NFT contract emits an ERC721 Transfer event for the NFT transfer back to the staker.
1109      * @dev While the contract is enabled, emits a HistoriesUpdated event.
1110      * @dev Emits a NftUnstaked event.
1111      * @param tokenId The token identifier, referencing the NFT being unstaked.
1112      */
1113     function unstakeNft(uint256 tokenId) external virtual {
1114         TokenInfo memory tokenInfo = tokenInfos[tokenId];
1115 
1116         require(tokenInfo.owner == msg.sender, "NftStaking: token not staked or incorrect token owner");
1117 
1118         uint16 currentCycle = _getCycle(now);
1119 
1120         if (enabled) {
1121             // ensure that at least an entire cycle has elapsed before unstaking the token to avoid
1122             // an exploit where a full cycle would be claimable if staking just before the end
1123             // of a cycle and unstaking right after the start of the new cycle
1124             require(currentCycle - tokenInfo.depositCycle >= 2, "NftStaking: token still frozen");
1125 
1126             _updateHistories(msg.sender, -int128(tokenInfo.weight), currentCycle);
1127 
1128             // clear the token owner to ensure it cannot be unstaked again without being re-staked
1129             tokenInfo.owner = address(0);
1130 
1131             // set the withdrawal cycle to ensure it cannot be re-staked during the same cycle
1132             tokenInfo.withdrawCycle = currentCycle;
1133 
1134             tokenInfos[tokenId] = tokenInfo;
1135         }
1136 
1137         try whitelistedNftContract.safeTransferFrom(address(this), msg.sender, tokenId, 1, "")  {} catch {
1138             // the above call to the ERC1155 safeTransferFrom() function may fail if the recipient
1139             // is a contract wallet not implementing the ERC1155TokenReceiver interface
1140             // if this happens, the transfer falls back to a call to the ERC721 (non-safe) transferFrom function.
1141             whitelistedNftContract.transferFrom(address(this), msg.sender, tokenId);
1142         }
1143 
1144         emit NftUnstaked(msg.sender, currentCycle, tokenId, tokenInfo.weight);
1145     }
1146 
1147     /**
1148      * Estimates the claimable rewards for the specified maximum number of past periods, starting at the next claimable period.
1149      * Estimations can be done only for periods which have already ended.
1150      * The maximum number of periods to claim can be calibrated to chunk down claims in several transactions to accomodate gas constraints.
1151      * @param maxPeriods The maximum number of periods to calculate for.
1152      * @return startPeriod The first period on which the computation starts.
1153      * @return periods The number of periods computed for.
1154      * @return amount The total claimable rewards.
1155      */
1156     function estimateRewards(uint16 maxPeriods)
1157         external
1158         view
1159         isEnabled
1160         hasStarted
1161         returns (
1162             uint16 startPeriod,
1163             uint16 periods,
1164             uint256 amount
1165         )
1166     {
1167         (ComputedClaim memory claim, ) = _computeRewards(msg.sender, maxPeriods);
1168         startPeriod = claim.startPeriod;
1169         periods = claim.periods;
1170         amount = claim.amount;
1171     }
1172 
1173     /**
1174      * Claims the claimable rewards for the specified maximum number of past periods, starting at the next claimable period.
1175      * Claims can be done only for periods which have already ended.
1176      * The maximum number of periods to claim can be calibrated to chunk down claims in several transactions to accomodate gas constraints.
1177      * @dev Reverts if the reward tokens transfer fails.
1178      * @dev The rewards token contract emits an ERC20 Transfer event for the reward tokens transfer.
1179      * @dev Emits a RewardsClaimed event.
1180      * @param maxPeriods The maximum number of periods to claim for.
1181      */
1182     function claimRewards(uint16 maxPeriods) external isEnabled hasStarted {
1183         NextClaim memory nextClaim = nextClaims[msg.sender];
1184 
1185         (ComputedClaim memory claim, NextClaim memory newNextClaim) = _computeRewards(msg.sender, maxPeriods);
1186 
1187         // free up memory on already processed staker snapshots
1188         Snapshot[] storage stakerHistory = stakerHistories[msg.sender];
1189         while (nextClaim.stakerSnapshotIndex < newNextClaim.stakerSnapshotIndex) {
1190             delete stakerHistory[nextClaim.stakerSnapshotIndex++];
1191         }
1192 
1193         if (claim.periods == 0) {
1194             return;
1195         }
1196 
1197         if (nextClaims[msg.sender].period == 0) {
1198             return;
1199         }
1200 
1201         Snapshot memory lastStakerSnapshot = stakerHistory[stakerHistory.length - 1];
1202 
1203         uint256 lastClaimedCycle = (claim.startPeriod + claim.periods - 1) * periodLengthInCycles;
1204         if (
1205             lastClaimedCycle >= lastStakerSnapshot.startCycle && // the claim reached the last staker snapshot
1206             lastStakerSnapshot.stake == 0 // and nothing is staked in the last staker snapshot
1207         ) {
1208             // re-init the next claim
1209             delete nextClaims[msg.sender];
1210         } else {
1211             nextClaims[msg.sender] = newNextClaim;
1212         }
1213 
1214         if (claim.amount != 0) {
1215             require(rewardsTokenContract.transfer(msg.sender, claim.amount), "NftStaking: failed to transfer rewards");
1216         }
1217 
1218         emit RewardsClaimed(msg.sender, _getCycle(now), claim.startPeriod, claim.periods, claim.amount);
1219     }
1220 
1221     /*                                            Utility Public Functions                                            */
1222 
1223     /**
1224      * Retrieves the current cycle (index-1 based).
1225      * @return The current cycle (index-1 based).
1226      */
1227     function getCurrentCycle() external view returns (uint16) {
1228         return _getCycle(now);
1229     }
1230 
1231     /**
1232      * Retrieves the current period (index-1 based).
1233      * @return The current period (index-1 based).
1234      */
1235     function getCurrentPeriod() external view returns (uint16) {
1236         return _getCurrentPeriod(periodLengthInCycles);
1237     }
1238 
1239     /**
1240      * Retrieves the last global snapshot index, if any.
1241      * @dev Reverts if the global history is empty.
1242      * @return The last global snapshot index.
1243      */
1244     function lastGlobalSnapshotIndex() external view returns (uint256) {
1245         uint256 length = globalHistory.length;
1246         require(length != 0, "NftStaking: empty global history");
1247         return length - 1;
1248     }
1249 
1250     /**
1251      * Retrieves the last staker snapshot index, if any.
1252      * @dev Reverts if the staker history is empty.
1253      * @return The last staker snapshot index.
1254      */
1255     function lastStakerSnapshotIndex(address staker) external view returns (uint256) {
1256         uint256 length = stakerHistories[staker].length;
1257         require(length != 0, "NftStaking: empty staker history");
1258         return length - 1;
1259     }
1260 
1261     /*                                            Staking Internal Functions                                            */
1262 
1263     /**
1264      * Stakes the NFT received by the contract for its owner. The NFT's weight will count for the current cycle.
1265      * @dev Reverts if the caller is not the whitelisted NFT contract.
1266      * @dev Emits an HistoriesUpdated event.
1267      * @dev Emits an NftStaked event.
1268      * @param tokenId Identifier of the staked NFT.
1269      * @param tokenOwner Owner of the staked NFT.
1270      */
1271     function _stakeNft(uint256 tokenId, address tokenOwner) internal isEnabled hasStarted {
1272         require(address(whitelistedNftContract) == msg.sender, "NftStaking: contract not whitelisted");
1273 
1274         uint64 weight = _validateAndGetNftWeight(tokenId);
1275 
1276         uint16 periodLengthInCycles_ = periodLengthInCycles;
1277         uint16 currentCycle = _getCycle(now);
1278 
1279         _updateHistories(tokenOwner, int128(weight), currentCycle);
1280 
1281         // initialise the next claim if it was the first stake for this staker or if
1282         // the next claim was re-initialised (ie. rewards were claimed until the last
1283         // staker snapshot and the last staker snapshot has no stake)
1284         if (nextClaims[tokenOwner].period == 0) {
1285             uint16 currentPeriod = _getPeriod(currentCycle, periodLengthInCycles_);
1286             nextClaims[tokenOwner] = NextClaim(currentPeriod, uint64(globalHistory.length - 1), 0);
1287         }
1288 
1289         uint16 withdrawCycle = tokenInfos[tokenId].withdrawCycle;
1290         require(currentCycle != withdrawCycle, "NftStaking: unstaked token cooldown");
1291 
1292         // set the staked token's info
1293         tokenInfos[tokenId] = TokenInfo(tokenOwner, weight, currentCycle, 0);
1294 
1295         emit NftStaked(tokenOwner, currentCycle, tokenId, weight);
1296     }
1297 
1298     /**
1299      * Calculates the amount of rewards for a staker over a capped number of periods.
1300      * @dev Processes until the specified maximum number of periods to claim is reached, or the last computable period is reached, whichever occurs first.
1301      * @param staker The staker for whom the rewards will be computed.
1302      * @param maxPeriods Maximum number of periods over which to compute the rewards.
1303      * @return claim the result of computation
1304      * @return nextClaim the next claim which can be used to update the staker's state
1305      */
1306     function _computeRewards(address staker, uint16 maxPeriods)
1307         internal
1308         view
1309         returns (ComputedClaim memory claim, NextClaim memory nextClaim)
1310     {
1311         // computing 0 periods
1312         if (maxPeriods == 0) {
1313             return (claim, nextClaim);
1314         }
1315 
1316         // the history is empty
1317         if (globalHistory.length == 0) {
1318             return (claim, nextClaim);
1319         }
1320 
1321         nextClaim = nextClaims[staker];
1322         claim.startPeriod = nextClaim.period;
1323 
1324         // nothing has been staked yet
1325         if (claim.startPeriod == 0) {
1326             return (claim, nextClaim);
1327         }
1328 
1329         uint16 periodLengthInCycles_ = periodLengthInCycles;
1330         uint16 endClaimPeriod = _getCurrentPeriod(periodLengthInCycles_);
1331 
1332         // current period is not claimable
1333         if (nextClaim.period == endClaimPeriod) {
1334             return (claim, nextClaim);
1335         }
1336 
1337         // retrieve the next snapshots if they exist
1338         Snapshot[] memory stakerHistory = stakerHistories[staker];
1339 
1340         Snapshot memory globalSnapshot = globalHistory[nextClaim.globalSnapshotIndex];
1341         Snapshot memory stakerSnapshot = stakerHistory[nextClaim.stakerSnapshotIndex];
1342         Snapshot memory nextGlobalSnapshot;
1343         Snapshot memory nextStakerSnapshot;
1344 
1345         if (nextClaim.globalSnapshotIndex != globalHistory.length - 1) {
1346             nextGlobalSnapshot = globalHistory[nextClaim.globalSnapshotIndex + 1];
1347         }
1348         if (nextClaim.stakerSnapshotIndex != stakerHistory.length - 1) {
1349             nextStakerSnapshot = stakerHistory[nextClaim.stakerSnapshotIndex + 1];
1350         }
1351 
1352         // excludes the current period
1353         claim.periods = endClaimPeriod - nextClaim.period;
1354 
1355         if (maxPeriods < claim.periods) {
1356             claim.periods = maxPeriods;
1357         }
1358 
1359         // re-calibrate the end claim period based on the actual number of
1360         // periods to claim. nextClaim.period will be updated to this value
1361         // after exiting the loop
1362         endClaimPeriod = nextClaim.period + claim.periods;
1363 
1364         // iterate over periods
1365         while (nextClaim.period != endClaimPeriod) {
1366             uint16 nextPeriodStartCycle = nextClaim.period * periodLengthInCycles_ + 1;
1367             uint256 rewardPerCycle = rewardsSchedule[nextClaim.period];
1368             uint256 startCycle = nextPeriodStartCycle - periodLengthInCycles_;
1369             uint256 endCycle = 0;
1370 
1371             // iterate over global snapshots
1372             while (endCycle != nextPeriodStartCycle) {
1373                 // find the range-to-claim starting cycle, where the current
1374                 // global snapshot, the current staker snapshot, and the current
1375                 // period overlap
1376                 if (globalSnapshot.startCycle > startCycle) {
1377                     startCycle = globalSnapshot.startCycle;
1378                 }
1379                 if (stakerSnapshot.startCycle > startCycle) {
1380                     startCycle = stakerSnapshot.startCycle;
1381                 }
1382 
1383                 // find the range-to-claim ending cycle, where the current
1384                 // global snapshot, the current staker snapshot, and the current
1385                 // period no longer overlap. The end cycle is exclusive of the
1386                 // range-to-claim and represents the beginning cycle of the next
1387                 // range-to-claim
1388                 endCycle = nextPeriodStartCycle;
1389                 if ((nextGlobalSnapshot.startCycle != 0) && (nextGlobalSnapshot.startCycle < endCycle)) {
1390                     endCycle = nextGlobalSnapshot.startCycle;
1391                 }
1392 
1393                 // only calculate and update the claimable rewards if there is
1394                 // something to calculate with
1395                 if ((globalSnapshot.stake != 0) && (stakerSnapshot.stake != 0) && (rewardPerCycle != 0)) {
1396                     uint256 snapshotReward = (endCycle - startCycle).mul(rewardPerCycle).mul(stakerSnapshot.stake);
1397                     snapshotReward /= globalSnapshot.stake;
1398 
1399                     claim.amount = claim.amount.add(snapshotReward);
1400                 }
1401 
1402                 // advance the current global snapshot to the next (if any)
1403                 // if its cycle range has been fully processed and if the next
1404                 // snapshot starts at most on next period first cycle
1405                 if (nextGlobalSnapshot.startCycle == endCycle) {
1406                     globalSnapshot = nextGlobalSnapshot;
1407                     ++nextClaim.globalSnapshotIndex;
1408 
1409                     if (nextClaim.globalSnapshotIndex != globalHistory.length - 1) {
1410                         nextGlobalSnapshot = globalHistory[nextClaim.globalSnapshotIndex + 1];
1411                     } else {
1412                         nextGlobalSnapshot = Snapshot(0, 0);
1413                     }
1414                 }
1415 
1416                 // advance the current staker snapshot to the next (if any)
1417                 // if its cycle range has been fully processed and if the next
1418                 // snapshot starts at most on next period first cycle
1419                 if (nextStakerSnapshot.startCycle == endCycle) {
1420                     stakerSnapshot = nextStakerSnapshot;
1421                     ++nextClaim.stakerSnapshotIndex;
1422 
1423                     if (nextClaim.stakerSnapshotIndex != stakerHistory.length - 1) {
1424                         nextStakerSnapshot = stakerHistory[nextClaim.stakerSnapshotIndex + 1];
1425                     } else {
1426                         nextStakerSnapshot = Snapshot(0, 0);
1427                     }
1428                 }
1429             }
1430 
1431             ++nextClaim.period;
1432         }
1433 
1434         return (claim, nextClaim);
1435     }
1436 
1437     /**
1438      * Updates the global and staker histories at the current cycle with a new difference in stake.
1439      * @dev Emits a HistoriesUpdated event.
1440      * @param staker The staker who is updating the history.
1441      * @param stakeDelta The difference to apply to the current stake.
1442      * @param currentCycle The current cycle.
1443      */
1444     function _updateHistories(
1445         address staker,
1446         int128 stakeDelta,
1447         uint16 currentCycle
1448     ) internal {
1449         uint256 stakerSnapshotIndex = _updateHistory(stakerHistories[staker], stakeDelta, currentCycle);
1450         uint256 globalSnapshotIndex = _updateHistory(globalHistory, stakeDelta, currentCycle);
1451 
1452         emit HistoriesUpdated(
1453             staker,
1454             currentCycle,
1455             stakerHistories[staker][stakerSnapshotIndex].stake,
1456             globalHistory[globalSnapshotIndex].stake
1457         );
1458     }
1459 
1460     /**
1461      * Updates the history at the current cycle with a new difference in stake.
1462      * @dev It will update the latest snapshot if it starts at the current cycle, otherwise will create a new snapshot with the updated stake.
1463      * @param history The history to update.
1464      * @param stakeDelta The difference to apply to the current stake.
1465      * @param currentCycle The current cycle.
1466      * @return snapshotIndex Index of the snapshot that was updated or created (i.e. the latest snapshot index).
1467      */
1468     function _updateHistory(
1469         Snapshot[] storage history,
1470         int128 stakeDelta,
1471         uint16 currentCycle
1472     ) internal returns (uint256 snapshotIndex) {
1473         uint256 historyLength = history.length;
1474         uint128 snapshotStake;
1475 
1476         if (historyLength != 0) {
1477             // there is an existing snapshot
1478             snapshotIndex = historyLength - 1;
1479             Snapshot storage snapshot = history[snapshotIndex];
1480             snapshotStake = uint256(int256(snapshot.stake).add(stakeDelta)).toUint128();
1481 
1482             if (snapshot.startCycle == currentCycle) {
1483                 // update the snapshot if it starts on the current cycle
1484                 snapshot.stake = snapshotStake;
1485                 return snapshotIndex;
1486             }
1487 
1488             // update the snapshot index (as a reflection that a new latest
1489             // snapshot will be added to the history), if there was already an
1490             // existing snapshot
1491             snapshotIndex += 1;
1492         } else {
1493             // the snapshot index (as a reflection that a new latest snapshot
1494             // will be added to the history) should already be initialized
1495             // correctly to the default value 0
1496 
1497             // the stake delta will not be negative, if we have no history, as
1498             // that would indicate that we are unstaking without having staked
1499             // anything first
1500             snapshotStake = uint128(stakeDelta);
1501         }
1502 
1503         Snapshot memory snapshot;
1504         snapshot.stake = snapshotStake;
1505         snapshot.startCycle = currentCycle;
1506 
1507         // add a new snapshot in the history
1508         history.push(snapshot);
1509     }
1510 
1511     /*                                           Utility Internal Functions                                           */
1512 
1513     /**
1514      * Retrieves the cycle (index-1 based) at the specified timestamp.
1515      * @dev Reverts if the specified timestamp is earlier than the beginning of the staking schedule
1516      * @param timestamp The timestamp for which the cycle is derived from.
1517      * @return The cycle (index-1 based) at the specified timestamp.
1518      */
1519     function _getCycle(uint256 timestamp) internal view returns (uint16) {
1520         require(timestamp >= startTimestamp, "NftStaking: timestamp preceeds contract start");
1521         return (((timestamp - startTimestamp) / uint256(cycleLengthInSeconds)) + 1).toUint16();
1522     }
1523 
1524     /**
1525      * Retrieves the period (index-1 based) for the specified cycle and period length.
1526      * @dev reverts if the specified cycle is zero.
1527      * @param cycle The cycle within the period to retrieve.
1528      * @param periodLengthInCycles_ Length of a period, in cycles.
1529      * @return The period (index-1 based) for the specified cycle and period length.
1530      */
1531     function _getPeriod(uint16 cycle, uint16 periodLengthInCycles_) internal pure returns (uint16) {
1532         require(cycle != 0, "NftStaking: cycle cannot be zero");
1533         return (cycle - 1) / periodLengthInCycles_ + 1;
1534     }
1535 
1536     /**
1537      * Retrieves the current period (index-1 based).
1538      * @param periodLengthInCycles_ Length of a period, in cycles.
1539      * @return The current period (index-1 based).
1540      */
1541     function _getCurrentPeriod(uint16 periodLengthInCycles_) internal view returns (uint16) {
1542         return _getPeriod(_getCycle(now), periodLengthInCycles_);
1543     }
1544 
1545     /*                                                Internal Hooks                                                */
1546 
1547     /**
1548      * Abstract function which validates whether or not an NFT is accepted for staking and retrieves its associated weight.
1549      * @dev MUST throw if the token is invalid.
1550      * @param tokenId uint256 token identifier of the NFT.
1551      * @return uint64 the weight of the NFT.
1552      */
1553     function _validateAndGetNftWeight(uint256 tokenId) internal virtual view returns (uint64);
1554 }
1555 
1556 /**
1557  * @notice Interface for the NftStaking whitelisted NFT contract.
1558  */
1559 interface IWhitelistedNftContract {
1560     /**
1561      * ERC1155: Transfers `value` amount of an `id` from  `from` to `to` (with safety call). 
1562      * @dev Caller must be approved to manage the tokens being transferred out of the `from` account (see "Approval" section of the standard).
1563      * @dev MUST revert if `to` is the zero address.
1564      * @dev MUST revert if balance of holder for token `id` is lower than the `value` sent.
1565      * @dev MUST revert on any other error.
1566      * @dev MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
1567      * @dev After the above conditions are met, this function MUST check if `to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `to` and act appropriately (see "Safe Transfer Rules" section of the standard).
1568      * @param from Source address
1569      * @param to Target address
1570      * @param id ID of the token type
1571      * @param value Transfer amount
1572      * @param data Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `to`
1573      */
1574     function safeTransferFrom(
1575         address from,
1576         address to,
1577         uint256 id,
1578         uint256 value,
1579         bytes calldata data
1580     ) external;
1581 
1582     /**
1583      * @notice ERC721: Transfers the ownership of a given token ID to another address.
1584      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
1585      * Requires the msg sender to be the owner, approved, or operator.
1586      * @param from current owner of the token.
1587      * @param to address to receive the ownership of the given token ID.
1588      * @param tokenId uint256 ID of the token to be transferred.
1589      */
1590     function transferFrom(
1591         address from,
1592         address to,
1593         uint256 tokenId
1594     ) external;
1595 }
1596 
1597 
1598 // File @animoca/f1dt-ethereum-contracts/contracts/staking/DeltaTimeStakingBeta.sol@v0.4.0
1599 
1600 pragma solidity 0.6.8;
1601 
1602 
1603 /**
1604  * @title Delta Time Staking Beta
1605  * This contract allows owners of Delta Time 2019 Car NFTs to stake them in exchange for REVV rewards.
1606  */
1607 contract DeltaTimeStakingBeta is NftStaking {
1608     mapping(uint256 => uint64) public weightsByRarity;
1609 
1610     /**
1611      * Constructor.
1612      * @param cycleLengthInSeconds_ The length of a cycle, in seconds.
1613      * @param periodLengthInCycles_ The length of a period, in cycles.
1614      * @param inventoryContract IWhitelistedNftContract the DeltaTimeInventory contract.
1615      * @param revvContract IERC20 the REVV contract.
1616      * @param rarities uint256[] the supported DeltaTimeInventory NFT rarities.
1617      * @param weights uint64[] the staking weights associated to the NFT rarities.
1618      */
1619     constructor(
1620         uint32 cycleLengthInSeconds_,
1621         uint16 periodLengthInCycles_,
1622         IWhitelistedNftContract inventoryContract,
1623         IERC20 revvContract,
1624         uint256[] memory rarities,
1625         uint64[] memory weights
1626     ) public NftStaking(cycleLengthInSeconds_, periodLengthInCycles_, inventoryContract, revvContract) {
1627         require(rarities.length == weights.length, "NftStaking: wrong arguments");
1628         for (uint256 i = 0; i < rarities.length; ++i) {
1629             weightsByRarity[rarities[i]] = weights[i];
1630         }
1631     }
1632 
1633     /**
1634      * Verifes that the token is eligible and returns its associated weight.
1635      * Throws if the token is not a 2019 Car NFT.
1636      * @param nftId uint256 token identifier of the NFT.
1637      * @return uint64 the weight of the NFT.
1638      */
1639     function _validateAndGetNftWeight(uint256 nftId) internal virtual override view returns (uint64) {
1640         // Ids bits layout specification:
1641         // https://github.com/animocabrands/f1dt-core_metadata/blob/v0.1.1/src/constants.js
1642         uint256 nonFungible = (nftId >> 255) & 1;
1643         uint256 tokenType = (nftId >> 240) & 0xFF;
1644         uint256 tokenSeason = (nftId >> 224) & 0xFF;
1645         uint256 tokenRarity = (nftId >> 176) & 0xFF;
1646 
1647         // For interpretation of values, refer to: https://github.com/animocabrands/f1dt-core_metadata/tree/v0.1.1/src/mappings
1648         // Types: https://github.com/animocabrands/f1dt-core_metadata/blob/v0.1.1/src/mappings/Common/Types/NameById.js
1649         // Seasons: https://github.com/animocabrands/f1dt-core_metadata/blob/v0.1.1/src/mappings/Common/Seasons/NameById.js
1650         // Rarities: https://github.com/animocabrands/f1dt-core_metadata/blob/v0.1.1/src/mappings/Common/Rarities/TierByRarity.js
1651         require(nonFungible == 1 && tokenType == 1 && tokenSeason == 2, "NftStaking: wrong token");
1652 
1653         return weightsByRarity[tokenRarity];
1654     }
1655 }