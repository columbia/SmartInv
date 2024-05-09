1 // Sources flattened with hardhat v2.6.6 https://hardhat.org
2 
3 // File @animoca/ethereum-contracts-core/contracts/utils/types/AddressIsContract.sol@v1.1.3
4 
5 // SPDX-License-Identifier: MIT
6 
7 // Partially derived from OpenZeppelin:
8 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/406c83649bd6169fc1b578e08506d78f0873b276/contracts/utils/Address.sol
9 
10 pragma solidity >=0.7.6 <0.8.0;
11 
12 /**
13  * @dev Upgrades the address type to check if it is a contract.
14  */
15 library AddressIsContract {
16     /**
17      * @dev Returns true if `account` is a contract.
18      *
19      * [IMPORTANT]
20      * ====
21      * It is unsafe to assume that an address for which this function returns
22      * false is an externally-owned account (EOA) and not a contract.
23      *
24      * Among others, `isContract` will return false for the following
25      * types of addresses:
26      *
27      *  - an externally-owned account
28      *  - a contract in construction
29      *  - an address where a contract will be created
30      *  - an address where a contract lived, but was destroyed
31      * ====
32      */
33     function isContract(address account) internal view returns (bool) {
34         // This method relies on extcodesize, which returns 0 for contracts in
35         // construction, since the code is only stored at the end of the
36         // constructor execution.
37 
38         uint256 size;
39         assembly {
40             size := extcodesize(account)
41         }
42         return size > 0;
43     }
44 }
45 
46 
47 // File @animoca/ethereum-contracts-core/contracts/utils/ERC20Wrapper.sol@v1.1.3
48 
49 pragma solidity >=0.7.6 <0.8.0;
50 
51 /**
52  * @title ERC20Wrapper
53  * Wraps ERC20 functions to support non-standard implementations which do not return a bool value.
54  * Calls to the wrapped functions revert only if they throw or if they return false.
55  */
56 library ERC20Wrapper {
57     using AddressIsContract for address;
58 
59     function wrappedTransfer(
60         IWrappedERC20 token,
61         address to,
62         uint256 value
63     ) internal {
64         _callWithOptionalReturnData(token, abi.encodeWithSelector(token.transfer.selector, to, value));
65     }
66 
67     function wrappedTransferFrom(
68         IWrappedERC20 token,
69         address from,
70         address to,
71         uint256 value
72     ) internal {
73         _callWithOptionalReturnData(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
74     }
75 
76     function wrappedApprove(
77         IWrappedERC20 token,
78         address spender,
79         uint256 value
80     ) internal {
81         _callWithOptionalReturnData(token, abi.encodeWithSelector(token.approve.selector, spender, value));
82     }
83 
84     function _callWithOptionalReturnData(IWrappedERC20 token, bytes memory callData) internal {
85         address target = address(token);
86         require(target.isContract(), "ERC20Wrapper: non-contract");
87 
88         // solhint-disable-next-line avoid-low-level-calls
89         (bool success, bytes memory data) = target.call(callData);
90         if (success) {
91             if (data.length != 0) {
92                 require(abi.decode(data, (bool)), "ERC20Wrapper: operation failed");
93             }
94         } else {
95             // revert using a standard revert message
96             if (data.length == 0) {
97                 revert("ERC20Wrapper: operation failed");
98             }
99 
100             // revert using the revert message coming from the call
101             assembly {
102                 let size := mload(data)
103                 revert(add(32, data), size)
104             }
105         }
106     }
107 }
108 
109 interface IWrappedERC20 {
110     function transfer(address to, uint256 value) external returns (bool);
111 
112     function transferFrom(
113         address from,
114         address to,
115         uint256 value
116     ) external returns (bool);
117 
118     function approve(address spender, uint256 value) external returns (bool);
119 }
120 
121 
122 // File @openzeppelin/contracts/utils/SafeCast.sol@v3.4.0
123 
124 pragma solidity >=0.6.0 <0.8.0;
125 
126 
127 /**
128  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
129  * checks.
130  *
131  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
132  * easily result in undesired exploitation or bugs, since developers usually
133  * assume that overflows raise errors. `SafeCast` restores this intuition by
134  * reverting the transaction when such an operation overflows.
135  *
136  * Using this library instead of the unchecked operations eliminates an entire
137  * class of bugs, so it's recommended to use it always.
138  *
139  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
140  * all math on `uint256` and `int256` and then downcasting.
141  */
142 library SafeCast {
143 
144     /**
145      * @dev Returns the downcasted uint128 from uint256, reverting on
146      * overflow (when the input is greater than largest uint128).
147      *
148      * Counterpart to Solidity's `uint128` operator.
149      *
150      * Requirements:
151      *
152      * - input must fit into 128 bits
153      */
154     function toUint128(uint256 value) internal pure returns (uint128) {
155         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
156         return uint128(value);
157     }
158 
159     /**
160      * @dev Returns the downcasted uint64 from uint256, reverting on
161      * overflow (when the input is greater than largest uint64).
162      *
163      * Counterpart to Solidity's `uint64` operator.
164      *
165      * Requirements:
166      *
167      * - input must fit into 64 bits
168      */
169     function toUint64(uint256 value) internal pure returns (uint64) {
170         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
171         return uint64(value);
172     }
173 
174     /**
175      * @dev Returns the downcasted uint32 from uint256, reverting on
176      * overflow (when the input is greater than largest uint32).
177      *
178      * Counterpart to Solidity's `uint32` operator.
179      *
180      * Requirements:
181      *
182      * - input must fit into 32 bits
183      */
184     function toUint32(uint256 value) internal pure returns (uint32) {
185         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
186         return uint32(value);
187     }
188 
189     /**
190      * @dev Returns the downcasted uint16 from uint256, reverting on
191      * overflow (when the input is greater than largest uint16).
192      *
193      * Counterpart to Solidity's `uint16` operator.
194      *
195      * Requirements:
196      *
197      * - input must fit into 16 bits
198      */
199     function toUint16(uint256 value) internal pure returns (uint16) {
200         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
201         return uint16(value);
202     }
203 
204     /**
205      * @dev Returns the downcasted uint8 from uint256, reverting on
206      * overflow (when the input is greater than largest uint8).
207      *
208      * Counterpart to Solidity's `uint8` operator.
209      *
210      * Requirements:
211      *
212      * - input must fit into 8 bits.
213      */
214     function toUint8(uint256 value) internal pure returns (uint8) {
215         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
216         return uint8(value);
217     }
218 
219     /**
220      * @dev Converts a signed int256 into an unsigned uint256.
221      *
222      * Requirements:
223      *
224      * - input must be greater than or equal to 0.
225      */
226     function toUint256(int256 value) internal pure returns (uint256) {
227         require(value >= 0, "SafeCast: value must be positive");
228         return uint256(value);
229     }
230 
231     /**
232      * @dev Returns the downcasted int128 from int256, reverting on
233      * overflow (when the input is less than smallest int128 or
234      * greater than largest int128).
235      *
236      * Counterpart to Solidity's `int128` operator.
237      *
238      * Requirements:
239      *
240      * - input must fit into 128 bits
241      *
242      * _Available since v3.1._
243      */
244     function toInt128(int256 value) internal pure returns (int128) {
245         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
246         return int128(value);
247     }
248 
249     /**
250      * @dev Returns the downcasted int64 from int256, reverting on
251      * overflow (when the input is less than smallest int64 or
252      * greater than largest int64).
253      *
254      * Counterpart to Solidity's `int64` operator.
255      *
256      * Requirements:
257      *
258      * - input must fit into 64 bits
259      *
260      * _Available since v3.1._
261      */
262     function toInt64(int256 value) internal pure returns (int64) {
263         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
264         return int64(value);
265     }
266 
267     /**
268      * @dev Returns the downcasted int32 from int256, reverting on
269      * overflow (when the input is less than smallest int32 or
270      * greater than largest int32).
271      *
272      * Counterpart to Solidity's `int32` operator.
273      *
274      * Requirements:
275      *
276      * - input must fit into 32 bits
277      *
278      * _Available since v3.1._
279      */
280     function toInt32(int256 value) internal pure returns (int32) {
281         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
282         return int32(value);
283     }
284 
285     /**
286      * @dev Returns the downcasted int16 from int256, reverting on
287      * overflow (when the input is less than smallest int16 or
288      * greater than largest int16).
289      *
290      * Counterpart to Solidity's `int16` operator.
291      *
292      * Requirements:
293      *
294      * - input must fit into 16 bits
295      *
296      * _Available since v3.1._
297      */
298     function toInt16(int256 value) internal pure returns (int16) {
299         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
300         return int16(value);
301     }
302 
303     /**
304      * @dev Returns the downcasted int8 from int256, reverting on
305      * overflow (when the input is less than smallest int8 or
306      * greater than largest int8).
307      *
308      * Counterpart to Solidity's `int8` operator.
309      *
310      * Requirements:
311      *
312      * - input must fit into 8 bits.
313      *
314      * _Available since v3.1._
315      */
316     function toInt8(int256 value) internal pure returns (int8) {
317         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
318         return int8(value);
319     }
320 
321     /**
322      * @dev Converts an unsigned uint256 into a signed int256.
323      *
324      * Requirements:
325      *
326      * - input must be less than or equal to maxInt256.
327      */
328     function toInt256(uint256 value) internal pure returns (int256) {
329         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
330         return int256(value);
331     }
332 }
333 
334 
335 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.0
336 
337 pragma solidity >=0.6.0 <0.8.0;
338 
339 /**
340  * @dev Wrappers over Solidity's arithmetic operations with added overflow
341  * checks.
342  *
343  * Arithmetic operations in Solidity wrap on overflow. This can easily result
344  * in bugs, because programmers usually assume that an overflow raises an
345  * error, which is the standard behavior in high level programming languages.
346  * `SafeMath` restores this intuition by reverting the transaction when an
347  * operation overflows.
348  *
349  * Using this library instead of the unchecked operations eliminates an entire
350  * class of bugs, so it's recommended to use it always.
351  */
352 library SafeMath {
353     /**
354      * @dev Returns the addition of two unsigned integers, with an overflow flag.
355      *
356      * _Available since v3.4._
357      */
358     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
359         uint256 c = a + b;
360         if (c < a) return (false, 0);
361         return (true, c);
362     }
363 
364     /**
365      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
366      *
367      * _Available since v3.4._
368      */
369     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
370         if (b > a) return (false, 0);
371         return (true, a - b);
372     }
373 
374     /**
375      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
376      *
377      * _Available since v3.4._
378      */
379     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
380         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
381         // benefit is lost if 'b' is also tested.
382         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
383         if (a == 0) return (true, 0);
384         uint256 c = a * b;
385         if (c / a != b) return (false, 0);
386         return (true, c);
387     }
388 
389     /**
390      * @dev Returns the division of two unsigned integers, with a division by zero flag.
391      *
392      * _Available since v3.4._
393      */
394     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
395         if (b == 0) return (false, 0);
396         return (true, a / b);
397     }
398 
399     /**
400      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
401      *
402      * _Available since v3.4._
403      */
404     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
405         if (b == 0) return (false, 0);
406         return (true, a % b);
407     }
408 
409     /**
410      * @dev Returns the addition of two unsigned integers, reverting on
411      * overflow.
412      *
413      * Counterpart to Solidity's `+` operator.
414      *
415      * Requirements:
416      *
417      * - Addition cannot overflow.
418      */
419     function add(uint256 a, uint256 b) internal pure returns (uint256) {
420         uint256 c = a + b;
421         require(c >= a, "SafeMath: addition overflow");
422         return c;
423     }
424 
425     /**
426      * @dev Returns the subtraction of two unsigned integers, reverting on
427      * overflow (when the result is negative).
428      *
429      * Counterpart to Solidity's `-` operator.
430      *
431      * Requirements:
432      *
433      * - Subtraction cannot overflow.
434      */
435     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
436         require(b <= a, "SafeMath: subtraction overflow");
437         return a - b;
438     }
439 
440     /**
441      * @dev Returns the multiplication of two unsigned integers, reverting on
442      * overflow.
443      *
444      * Counterpart to Solidity's `*` operator.
445      *
446      * Requirements:
447      *
448      * - Multiplication cannot overflow.
449      */
450     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
451         if (a == 0) return 0;
452         uint256 c = a * b;
453         require(c / a == b, "SafeMath: multiplication overflow");
454         return c;
455     }
456 
457     /**
458      * @dev Returns the integer division of two unsigned integers, reverting on
459      * division by zero. The result is rounded towards zero.
460      *
461      * Counterpart to Solidity's `/` operator. Note: this function uses a
462      * `revert` opcode (which leaves remaining gas untouched) while Solidity
463      * uses an invalid opcode to revert (consuming all remaining gas).
464      *
465      * Requirements:
466      *
467      * - The divisor cannot be zero.
468      */
469     function div(uint256 a, uint256 b) internal pure returns (uint256) {
470         require(b > 0, "SafeMath: division by zero");
471         return a / b;
472     }
473 
474     /**
475      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
476      * reverting when dividing by zero.
477      *
478      * Counterpart to Solidity's `%` operator. This function uses a `revert`
479      * opcode (which leaves remaining gas untouched) while Solidity uses an
480      * invalid opcode to revert (consuming all remaining gas).
481      *
482      * Requirements:
483      *
484      * - The divisor cannot be zero.
485      */
486     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
487         require(b > 0, "SafeMath: modulo by zero");
488         return a % b;
489     }
490 
491     /**
492      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
493      * overflow (when the result is negative).
494      *
495      * CAUTION: This function is deprecated because it requires allocating memory for the error
496      * message unnecessarily. For custom revert reasons use {trySub}.
497      *
498      * Counterpart to Solidity's `-` operator.
499      *
500      * Requirements:
501      *
502      * - Subtraction cannot overflow.
503      */
504     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
505         require(b <= a, errorMessage);
506         return a - b;
507     }
508 
509     /**
510      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
511      * division by zero. The result is rounded towards zero.
512      *
513      * CAUTION: This function is deprecated because it requires allocating memory for the error
514      * message unnecessarily. For custom revert reasons use {tryDiv}.
515      *
516      * Counterpart to Solidity's `/` operator. Note: this function uses a
517      * `revert` opcode (which leaves remaining gas untouched) while Solidity
518      * uses an invalid opcode to revert (consuming all remaining gas).
519      *
520      * Requirements:
521      *
522      * - The divisor cannot be zero.
523      */
524     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
525         require(b > 0, errorMessage);
526         return a / b;
527     }
528 
529     /**
530      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
531      * reverting with custom message when dividing by zero.
532      *
533      * CAUTION: This function is deprecated because it requires allocating memory for the error
534      * message unnecessarily. For custom revert reasons use {tryMod}.
535      *
536      * Counterpart to Solidity's `%` operator. This function uses a `revert`
537      * opcode (which leaves remaining gas untouched) while Solidity uses an
538      * invalid opcode to revert (consuming all remaining gas).
539      *
540      * Requirements:
541      *
542      * - The divisor cannot be zero.
543      */
544     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
545         require(b > 0, errorMessage);
546         return a % b;
547     }
548 }
549 
550 
551 // File @openzeppelin/contracts/math/SignedSafeMath.sol@v3.4.0
552 
553 pragma solidity >=0.6.0 <0.8.0;
554 
555 /**
556  * @title SignedSafeMath
557  * @dev Signed math operations with safety checks that revert on error.
558  */
559 library SignedSafeMath {
560     int256 constant private _INT256_MIN = -2**255;
561 
562     /**
563      * @dev Returns the multiplication of two signed integers, reverting on
564      * overflow.
565      *
566      * Counterpart to Solidity's `*` operator.
567      *
568      * Requirements:
569      *
570      * - Multiplication cannot overflow.
571      */
572     function mul(int256 a, int256 b) internal pure returns (int256) {
573         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
574         // benefit is lost if 'b' is also tested.
575         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
576         if (a == 0) {
577             return 0;
578         }
579 
580         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
581 
582         int256 c = a * b;
583         require(c / a == b, "SignedSafeMath: multiplication overflow");
584 
585         return c;
586     }
587 
588     /**
589      * @dev Returns the integer division of two signed integers. Reverts on
590      * division by zero. The result is rounded towards zero.
591      *
592      * Counterpart to Solidity's `/` operator. Note: this function uses a
593      * `revert` opcode (which leaves remaining gas untouched) while Solidity
594      * uses an invalid opcode to revert (consuming all remaining gas).
595      *
596      * Requirements:
597      *
598      * - The divisor cannot be zero.
599      */
600     function div(int256 a, int256 b) internal pure returns (int256) {
601         require(b != 0, "SignedSafeMath: division by zero");
602         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
603 
604         int256 c = a / b;
605 
606         return c;
607     }
608 
609     /**
610      * @dev Returns the subtraction of two signed integers, reverting on
611      * overflow.
612      *
613      * Counterpart to Solidity's `-` operator.
614      *
615      * Requirements:
616      *
617      * - Subtraction cannot overflow.
618      */
619     function sub(int256 a, int256 b) internal pure returns (int256) {
620         int256 c = a - b;
621         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
622 
623         return c;
624     }
625 
626     /**
627      * @dev Returns the addition of two signed integers, reverting on
628      * overflow.
629      *
630      * Counterpart to Solidity's `+` operator.
631      *
632      * Requirements:
633      *
634      * - Addition cannot overflow.
635      */
636     function add(int256 a, int256 b) internal pure returns (int256) {
637         int256 c = a + b;
638         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
639 
640         return c;
641     }
642 }
643 
644 
645 // File @animoca/ethereum-contracts-core/contracts/introspection/IERC165.sol@v1.1.3
646 
647 pragma solidity >=0.7.6 <0.8.0;
648 
649 /**
650  * @dev Interface of the ERC165 standard, as defined in the
651  * https://eips.ethereum.org/EIPS/eip-165.
652  */
653 interface IERC165 {
654     /**
655      * @dev Returns true if this contract implements the interface defined by
656      * `interfaceId`. See the corresponding
657      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
658      * to learn more about how these ids are created.
659      *
660      * This function call must use less than 30 000 gas.
661      */
662     function supportsInterface(bytes4 interfaceId) external view returns (bool);
663 }
664 
665 
666 // File @animoca/ethereum-contracts-assets/contracts/token/ERC1155/interfaces/IERC1155TokenReceiver.sol@v3.0.1
667 
668 pragma solidity >=0.7.6 <0.8.0;
669 
670 /**
671  * @title ERC1155 Multi Token Standard, Tokens Receiver.
672  * Interface for any contract that wants to support transfers from ERC1155 asset contracts.
673  * @dev See https://eips.ethereum.org/EIPS/eip-1155
674  * @dev Note: The ERC-165 identifier for this interface is 0x4e2312e0.
675  */
676 interface IERC1155TokenReceiver {
677     /**
678      * @notice Handle the receipt of a single ERC1155 token type.
679      * An ERC1155 contract MUST call this function on a recipient contract, at the end of a `safeTransferFrom` after the balance update.
680      * This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
681      *  (i.e. 0xf23a6e61) to accept the transfer.
682      * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
683      * @param operator  The address which initiated the transfer (i.e. msg.sender)
684      * @param from      The address which previously owned the token
685      * @param id        The ID of the token being transferred
686      * @param value     The amount of tokens being transferred
687      * @param data      Additional data with no specified format
688      * @return bytes4   `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
689      */
690     function onERC1155Received(
691         address operator,
692         address from,
693         uint256 id,
694         uint256 value,
695         bytes calldata data
696     ) external returns (bytes4);
697 
698     /**
699      * @notice Handle the receipt of multiple ERC1155 token types.
700      * An ERC1155 contract MUST call this function on a recipient contract, at the end of a `safeBatchTransferFrom` after the balance updates.
701      * This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
702      *  (i.e. 0xbc197c81) if to accept the transfer(s).
703      * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
704      * @param operator  The address which initiated the batch transfer (i.e. msg.sender)
705      * @param from      The address which previously owned the token
706      * @param ids       An array containing ids of each token being transferred (order and length must match _values array)
707      * @param values    An array containing amounts of each token being transferred (order and length must match _ids array)
708      * @param data      Additional data with no specified format
709      * @return          `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
710      */
711     function onERC1155BatchReceived(
712         address operator,
713         address from,
714         uint256[] calldata ids,
715         uint256[] calldata values,
716         bytes calldata data
717     ) external returns (bytes4);
718 }
719 
720 
721 // File @animoca/ethereum-contracts-assets/contracts/token/ERC1155/ERC1155TokenReceiver.sol@v3.0.1
722 
723 pragma solidity >=0.7.6 <0.8.0;
724 
725 
726 /**
727  * @title ERC1155 Transfers Receiver Contract.
728  * @dev The functions `onERC1155Received(address,address,uint256,uint256,bytes)`
729  *  and `onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)` need to be implemented by a child contract.
730  */
731 abstract contract ERC1155TokenReceiver is IERC165, IERC1155TokenReceiver {
732     // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
733     bytes4 internal constant _ERC1155_RECEIVED = 0xf23a6e61;
734 
735     // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
736     bytes4 internal constant _ERC1155_BATCH_RECEIVED = 0xbc197c81;
737 
738     bytes4 internal constant _ERC1155_REJECTED = 0xffffffff;
739 
740     //======================================================= ERC165 ========================================================//
741 
742     /// @inheritdoc IERC165
743     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
744         return interfaceId == type(IERC165).interfaceId || interfaceId == type(IERC1155TokenReceiver).interfaceId;
745     }
746 }
747 
748 
749 // File @animoca/ethereum-contracts-core/contracts/metatx/ManagedIdentity.sol@v1.1.3
750 
751 pragma solidity >=0.7.6 <0.8.0;
752 
753 /*
754  * Provides information about the current execution context, including the
755  * sender of the transaction and its data. While these are generally available
756  * via msg.sender and msg.data, they should not be accessed in such a direct
757  * manner.
758  */
759 abstract contract ManagedIdentity {
760     function _msgSender() internal view virtual returns (address payable) {
761         return msg.sender;
762     }
763 
764     function _msgData() internal view virtual returns (bytes memory) {
765         return msg.data;
766     }
767 }
768 
769 
770 // File @animoca/ethereum-contracts-core/contracts/access/IERC173.sol@v1.1.3
771 
772 pragma solidity >=0.7.6 <0.8.0;
773 
774 /**
775  * @title ERC-173 Contract Ownership Standard
776  * Note: the ERC-165 identifier for this interface is 0x7f5828d0
777  */
778 interface IERC173 {
779     /**
780      * Event emited when ownership of a contract changes.
781      * @param previousOwner the previous owner.
782      * @param newOwner the new owner.
783      */
784     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
785 
786     /**
787      * Get the address of the owner
788      * @return The address of the owner.
789      */
790     function owner() external view returns (address);
791 
792     /**
793      * Set the address of the new owner of the contract
794      * Set newOwner to address(0) to renounce any ownership.
795      * @dev Emits an {OwnershipTransferred} event.
796      * @param newOwner The address of the new owner of the contract. Using the zero address means renouncing ownership.
797      */
798     function transferOwnership(address newOwner) external;
799 }
800 
801 
802 // File @animoca/ethereum-contracts-core/contracts/access/Ownable.sol@v1.1.3
803 
804 pragma solidity >=0.7.6 <0.8.0;
805 
806 
807 /**
808  * @dev Contract module which provides a basic access control mechanism, where
809  * there is an account (an owner) that can be granted exclusive access to
810  * specific functions.
811  *
812  * By default, the owner account will be the one that deploys the contract. This
813  * can later be changed with {transferOwnership}.
814  *
815  * This module is used through inheritance. It will make available the modifier
816  * `onlyOwner`, which can be applied to your functions to restrict their use to
817  * the owner.
818  */
819 abstract contract Ownable is ManagedIdentity, IERC173 {
820     address internal _owner;
821 
822     /**
823      * Initializes the contract, setting the deployer as the initial owner.
824      * @dev Emits an {IERC173-OwnershipTransferred(address,address)} event.
825      */
826     constructor(address owner_) {
827         _owner = owner_;
828         emit OwnershipTransferred(address(0), owner_);
829     }
830 
831     /**
832      * Gets the address of the current contract owner.
833      */
834     function owner() public view virtual override returns (address) {
835         return _owner;
836     }
837 
838     /**
839      * See {IERC173-transferOwnership(address)}
840      * @dev Reverts if the sender is not the current contract owner.
841      * @param newOwner the address of the new owner. Use the zero address to renounce the ownership.
842      */
843     function transferOwnership(address newOwner) public virtual override {
844         _requireOwnership(_msgSender());
845         _owner = newOwner;
846         emit OwnershipTransferred(_owner, newOwner);
847     }
848 
849     /**
850      * @dev Reverts if `account` is not the contract owner.
851      * @param account the account to test.
852      */
853     function _requireOwnership(address account) internal virtual {
854         require(account == this.owner(), "Ownable: not the owner");
855     }
856 }
857 
858 
859 // File contracts/staking/DeltaTimeStaking2021.sol
860 
861 pragma solidity >=0.7.6 <0.8.0;
862 
863 
864 
865 
866 /**
867  * @title Delta Time Staking 2021
868  * Distribute REVV rewards over discrete-time schedules for the staking of Car NFTs.
869  * This contract is designed on a self-service model, where users will stake NFTs, unstake NFTs and claim rewards through their own transactions only.
870  */
871 contract DeltaTimeStaking2021 is ERC1155TokenReceiver, Ownable {
872     using ERC20Wrapper for IWrappedERC20;
873     using SafeCast for uint256;
874     using SafeMath for uint256;
875     using SignedSafeMath for int256;
876 
877     event RewardsAdded(uint256 startPeriod, uint256 endPeriod, uint256 rewardsPerCycle);
878 
879     event Started();
880 
881     event NftStaked(address staker, uint256 cycle, uint256 tokenId, uint256 weight);
882 
883     event NftUnstaked(address staker, uint256 cycle, uint256 tokenId, uint256 weight);
884 
885     event RewardsClaimed(address staker, uint256 cycle, uint256 startPeriod, uint256 periods, uint256 amount);
886 
887     event HistoriesUpdated(address staker, uint256 startCycle, uint256 stakerStake, uint256 globalStake);
888 
889     event Disabled();
890 
891     /**
892      * Used to represent the current staking status of an NFT.
893      * Optimised for use in storage.
894      */
895     struct TokenInfo {
896         address owner;
897         uint64 weight;
898         uint16 depositCycle;
899         uint16 withdrawCycle;
900     }
901 
902     /**
903      * Used as a historical record of change of stake.
904      * Stake represents an aggregation of staked token weights.
905      * Optimised for use in storage.
906      */
907     struct Snapshot {
908         uint128 stake;
909         uint128 startCycle;
910     }
911 
912     /**
913      * Used to represent a staker's information about the next claim.
914      * Optimised for use in storage.
915      */
916     struct NextClaim {
917         uint16 period;
918         uint64 globalSnapshotIndex;
919         uint64 stakerSnapshotIndex;
920     }
921 
922     /**
923      * Used as a container to hold result values from computing rewards.
924      */
925     struct ComputedClaim {
926         uint16 startPeriod;
927         uint16 periods;
928         uint256 amount;
929     }
930 
931     bool public enabled = true;
932 
933     uint256 public totalRewardsPool;
934 
935     uint256 public startTimestamp;
936 
937     IWrappedERC20 public immutable rewardsTokenContract;
938     IWhitelistedNftContract public immutable whitelistedNftContract;
939 
940     uint32 public immutable cycleLengthInSeconds;
941     uint16 public immutable periodLengthInCycles;
942 
943     Snapshot[] public globalHistory;
944 
945     mapping(uint256 => uint64) public weightsByRarity;
946 
947     /* staker => snapshots*/
948     mapping(address => Snapshot[]) public stakerHistories;
949 
950     /* staker => next claim */
951     mapping(address => NextClaim) public nextClaims;
952 
953     /* tokenId => token info */
954     mapping(uint256 => TokenInfo) public tokenInfos;
955 
956     /* period => rewardsPerCycle */
957     mapping(uint256 => uint256) public rewardsSchedule;
958 
959     modifier hasStarted() {
960         require(startTimestamp != 0, "NftStaking: staking not started");
961         _;
962     }
963 
964     modifier hasNotStarted() {
965         require(startTimestamp == 0, "NftStaking: staking has started");
966         _;
967     }
968 
969     modifier isEnabled() {
970         // solhint-disable-next-line reason-string
971         require(enabled, "NftStaking: contract is not enabled");
972         _;
973     }
974 
975     modifier isNotEnabled() {
976         require(!enabled, "NftStaking: contract is enabled");
977         _;
978     }
979 
980     /**
981      * Constructor.
982      * @dev Reverts if the period length value is zero.
983      * @dev Reverts if the cycle length value is zero.
984      * @dev Warning: cycles and periods need to be calibrated carefully.
985      *  Small values will increase computation load while estimating and claiming rewards.
986      *  Big values will increase the time to wait before a new period becomes claimable.
987      * @param cycleLengthInSeconds_ The length of a cycle, in seconds.
988      * @param periodLengthInCycles_ The length of a period, in cycles.
989      * @param whitelistedNftContract_ The ERC1155-compliant (optional ERC721-compliance) contract from which staking is accepted.
990      * @param rewardsTokenContract_ The ERC20-based token used as staking rewards.
991      */
992     constructor(
993         uint32 cycleLengthInSeconds_,
994         uint16 periodLengthInCycles_,
995         IWhitelistedNftContract whitelistedNftContract_,
996         IWrappedERC20 rewardsTokenContract_,
997         uint256[] memory rarities,
998         uint64[] memory weights
999     ) Ownable(msg.sender) {
1000         require(rarities.length == weights.length, "NftStaking: wrong arguments");
1001 
1002         // solhint-disable-next-line reason-string
1003         require(cycleLengthInSeconds_ >= 1 minutes, "NftStaking: invalid cycle length");
1004         // solhint-disable-next-line reason-string
1005         require(periodLengthInCycles_ >= 2, "NftStaking: invalid period length");
1006 
1007         cycleLengthInSeconds = cycleLengthInSeconds_;
1008         periodLengthInCycles = periodLengthInCycles_;
1009         whitelistedNftContract = whitelistedNftContract_;
1010         rewardsTokenContract = rewardsTokenContract_;
1011 
1012         for (uint256 i = 0; i < rarities.length; ++i) {
1013             weightsByRarity[rarities[i]] = weights[i];
1014         }
1015     }
1016 
1017     /*                                            Admin Public Functions                                            */
1018 
1019     /**
1020      * Adds `rewardsPerCycle` reward amount for the period range from `startPeriod` to `endPeriod`, inclusive, to the rewards schedule.
1021      * The necessary amount of reward tokens is transferred to the contract. Cannot be used for past periods.
1022      * Can only be used to add rewards and not to remove them.
1023      * @dev Reverts if not called by the owner.
1024      * @dev Reverts if the start period is zero.
1025      * @dev Reverts if the end period precedes the start period.
1026      * @dev Reverts if attempting to add rewards for a period earlier than the current, after staking has started.
1027      * @dev Reverts if the reward tokens transfer fails.
1028      * @dev The rewards token contract emits an ERC20 Transfer event for the reward tokens transfer.
1029      * @dev Emits a RewardsAdded event.
1030      * @param startPeriod The starting period (inclusive).
1031      * @param endPeriod The ending period (inclusive).
1032      * @param rewardsPerCycle The reward amount to add for each cycle within range.
1033      */
1034     function addRewardsForPeriods(
1035         uint16 startPeriod,
1036         uint16 endPeriod,
1037         uint256 rewardsPerCycle
1038     ) external {
1039         _requireOwnership(msg.sender);
1040         require(startPeriod != 0 && startPeriod <= endPeriod, "NftStaking: wrong period range");
1041 
1042         uint16 periodLengthInCycles_ = periodLengthInCycles;
1043 
1044         if (startTimestamp != 0) {
1045             // solhint-disable-next-line reason-string
1046             require(startPeriod >= _getCurrentPeriod(periodLengthInCycles_), "NftStaking: already committed reward schedule");
1047         }
1048 
1049         for (uint256 period = startPeriod; period <= endPeriod; ++period) {
1050             rewardsSchedule[period] = rewardsSchedule[period].add(rewardsPerCycle);
1051         }
1052 
1053         uint256 addedRewards = rewardsPerCycle.mul(periodLengthInCycles_).mul(endPeriod - startPeriod + 1);
1054 
1055         totalRewardsPool = totalRewardsPool.add(addedRewards);
1056 
1057         rewardsTokenContract.wrappedTransferFrom(msg.sender, address(this), addedRewards);
1058 
1059         emit RewardsAdded(startPeriod, endPeriod, rewardsPerCycle);
1060     }
1061 
1062     /**
1063      * Starts the first cycle of staking, enabling users to stake NFTs.
1064      * @dev Reverts if not called by the owner.
1065      * @dev Reverts if the staking has already started.
1066      * @dev Emits a Started event.
1067      */
1068     function start() public hasNotStarted {
1069         _requireOwnership(msg.sender);
1070         startTimestamp = block.timestamp;
1071         emit Started();
1072     }
1073 
1074     /**
1075      * Permanently disables all staking and claiming.
1076      * This is an emergency recovery feature which is NOT part of the normal contract operation.
1077      * @dev Reverts if not called by the owner.
1078      * @dev Emits a Disabled event.
1079      */
1080     function disable() public {
1081         _requireOwnership(msg.sender);
1082         enabled = false;
1083         emit Disabled();
1084     }
1085 
1086     /**
1087      * Withdraws a specified amount of reward tokens from the contract it has been disabled.
1088      * @dev Reverts if not called by the owner.
1089      * @dev Reverts if the contract has not been disabled.
1090      * @dev Reverts if the reward tokens transfer fails.
1091      * @dev The rewards token contract emits an ERC20 Transfer event for the reward tokens transfer.
1092      * @param amount The amount to withdraw.
1093      */
1094     function withdrawRewardsPool(uint256 amount) public isNotEnabled {
1095         _requireOwnership(msg.sender);
1096         rewardsTokenContract.wrappedTransfer(msg.sender, amount);
1097     }
1098 
1099     /*                                             ERC1155TokenReceiver                                             */
1100 
1101     function onERC1155Received(
1102         address, /*operator*/
1103         address from,
1104         uint256 id,
1105         uint256, /*value*/
1106         bytes calldata /*data*/
1107     ) external virtual override returns (bytes4) {
1108         _stakeNft(id, from);
1109         return _ERC1155_RECEIVED;
1110     }
1111 
1112     function onERC1155BatchReceived(
1113         address, /*operator*/
1114         address from,
1115         uint256[] calldata ids,
1116         uint256[] calldata, /*values*/
1117         bytes calldata /*data*/
1118     ) external virtual override returns (bytes4) {
1119         for (uint256 i = 0; i < ids.length; ++i) {
1120             _stakeNft(ids[i], from);
1121         }
1122         return _ERC1155_BATCH_RECEIVED;
1123     }
1124 
1125     /*                                            Staking Public Functions                                            */
1126 
1127     /**
1128      * Unstakes a deposited NFT from the contract and updates the histories accordingly.
1129      * The NFT's weight will not count for the current cycle.
1130      * @dev Reverts if the caller is not the original owner of the NFT.
1131      * @dev While the contract is enabled, reverts if the NFT is still frozen.
1132      * @dev Reverts if the NFT transfer back to the original owner fails.
1133      * @dev If ERC1155 safe transfers are supported by the receiver wallet,
1134      *  the whitelisted NFT contract emits an ERC1155 TransferSingle event for the NFT transfer back to the staker.
1135      * @dev If ERC1155 safe transfers are not supported by the receiver wallet,
1136      *  the whitelisted NFT contract emits an ERC721 Transfer event for the NFT transfer back to the staker.
1137      * @dev While the contract is enabled, emits a HistoriesUpdated event.
1138      * @dev Emits a NftUnstaked event.
1139      * @param tokenId The token identifier, referencing the NFT being unstaked.
1140      */
1141     function unstakeNft(uint256 tokenId) external {
1142         TokenInfo memory tokenInfo = tokenInfos[tokenId];
1143 
1144         // solhint-disable-next-line reason-string
1145         require(tokenInfo.owner == msg.sender, "NftStaking: token not staked or incorrect token owner");
1146 
1147         uint16 currentCycle = _getCycle(block.timestamp);
1148 
1149         if (enabled) {
1150             // ensure that at least an entire cycle has elapsed before unstaking the token to avoid
1151             // an exploit where a full cycle would be claimable if staking just before the end
1152             // of a cycle and unstaking right after the start of the new cycle
1153             require(currentCycle - tokenInfo.depositCycle >= 2, "NftStaking: token still frozen");
1154 
1155             _updateHistories(msg.sender, -int128(tokenInfo.weight), currentCycle);
1156 
1157             // clear the token owner to ensure it cannot be unstaked again without being re-staked
1158             tokenInfo.owner = address(0);
1159 
1160             // set the withdrawal cycle to ensure it cannot be re-staked during the same cycle
1161             tokenInfo.withdrawCycle = currentCycle;
1162 
1163             tokenInfos[tokenId] = tokenInfo;
1164         }
1165 
1166         whitelistedNftContract.transferFrom(address(this), msg.sender, tokenId);
1167 
1168         emit NftUnstaked(msg.sender, currentCycle, tokenId, tokenInfo.weight);
1169     }
1170 
1171     /**
1172      * Estimates the claimable rewards for the specified maximum number of past periods, starting at the next claimable period.
1173      * Estimations can be done only for periods which have already ended.
1174      * The maximum number of periods to claim can be calibrated to chunk down claims in several transactions to accomodate gas constraints.
1175      * @param maxPeriods The maximum number of periods to calculate for.
1176      * @return startPeriod The first period on which the computation starts.
1177      * @return periods The number of periods computed for.
1178      * @return amount The total claimable rewards.
1179      */
1180     function estimateRewards(uint16 maxPeriods)
1181         external
1182         view
1183         isEnabled
1184         hasStarted
1185         returns (
1186             uint16 startPeriod,
1187             uint16 periods,
1188             uint256 amount
1189         )
1190     {
1191         (ComputedClaim memory claim, ) = _computeRewards(msg.sender, maxPeriods);
1192         startPeriod = claim.startPeriod;
1193         periods = claim.periods;
1194         amount = claim.amount;
1195     }
1196 
1197     /**
1198      * Claims the claimable rewards for the specified maximum number of past periods, starting at the next claimable period.
1199      * Claims can be done only for periods which have already ended.
1200      * The maximum number of periods to claim can be calibrated to chunk down claims in several transactions to accomodate gas constraints.
1201      * @dev Reverts if the reward tokens transfer fails.
1202      * @dev The rewards token contract emits an ERC20 Transfer event for the reward tokens transfer.
1203      * @dev Emits a RewardsClaimed event.
1204      * @param maxPeriods The maximum number of periods to claim for.
1205      */
1206     function claimRewards(uint16 maxPeriods) external isEnabled hasStarted {
1207         NextClaim memory nextClaim = nextClaims[msg.sender];
1208 
1209         (ComputedClaim memory claim, NextClaim memory newNextClaim) = _computeRewards(msg.sender, maxPeriods);
1210 
1211         // free up memory on already processed staker snapshots
1212         Snapshot[] storage stakerHistory = stakerHistories[msg.sender];
1213         while (nextClaim.stakerSnapshotIndex < newNextClaim.stakerSnapshotIndex) {
1214             delete stakerHistory[nextClaim.stakerSnapshotIndex++];
1215         }
1216 
1217         if (claim.periods == 0) {
1218             return;
1219         }
1220 
1221         if (nextClaims[msg.sender].period == 0) {
1222             return;
1223         }
1224 
1225         Snapshot memory lastStakerSnapshot = stakerHistory[stakerHistory.length - 1];
1226 
1227         uint256 lastClaimedCycle = (claim.startPeriod + claim.periods - 1) * periodLengthInCycles;
1228         if (
1229             lastClaimedCycle >= lastStakerSnapshot.startCycle && // the claim reached the last staker snapshot
1230             lastStakerSnapshot.stake == 0 // and nothing is staked in the last staker snapshot
1231         ) {
1232             // re-init the next claim
1233             delete nextClaims[msg.sender];
1234         } else {
1235             nextClaims[msg.sender] = newNextClaim;
1236         }
1237 
1238         if (claim.amount != 0) {
1239             rewardsTokenContract.wrappedTransfer(msg.sender, claim.amount);
1240         }
1241 
1242         emit RewardsClaimed(msg.sender, _getCycle(block.timestamp), claim.startPeriod, claim.periods, claim.amount);
1243     }
1244 
1245     /*                                            Utility Public Functions                                            */
1246 
1247     /**
1248      * Retrieves the current cycle (index-1 based).
1249      * @return The current cycle (index-1 based).
1250      */
1251     function getCurrentCycle() external view returns (uint16) {
1252         return _getCycle(block.timestamp);
1253     }
1254 
1255     /**
1256      * Retrieves the current period (index-1 based).
1257      * @return The current period (index-1 based).
1258      */
1259     function getCurrentPeriod() external view returns (uint16) {
1260         return _getCurrentPeriod(periodLengthInCycles);
1261     }
1262 
1263     /**
1264      * Retrieves the last global snapshot index, if any.
1265      * @dev Reverts if the global history is empty.
1266      * @return The last global snapshot index.
1267      */
1268     function lastGlobalSnapshotIndex() external view returns (uint256) {
1269         uint256 length = globalHistory.length;
1270         // solhint-disable-next-line reason-string
1271         require(length != 0, "NftStaking: empty global history");
1272         return length - 1;
1273     }
1274 
1275     /**
1276      * Retrieves the last staker snapshot index, if any.
1277      * @dev Reverts if the staker history is empty.
1278      * @return The last staker snapshot index.
1279      */
1280     function lastStakerSnapshotIndex(address staker) external view returns (uint256) {
1281         uint256 length = stakerHistories[staker].length;
1282         // solhint-disable-next-line reason-string
1283         require(length != 0, "NftStaking: empty staker history");
1284         return length - 1;
1285     }
1286 
1287     /*                                            Staking Internal Functions                                            */
1288 
1289     /**
1290      * Stakes the NFT received by the contract for its owner. The NFT's weight will count for the current cycle.
1291      * @dev Reverts if the caller is not the whitelisted NFT contract.
1292      * @dev Emits an HistoriesUpdated event.
1293      * @dev Emits an NftStaked event.
1294      * @param tokenId Identifier of the staked NFT.
1295      * @param tokenOwner Owner of the staked NFT.
1296      */
1297     function _stakeNft(uint256 tokenId, address tokenOwner) internal isEnabled hasStarted {
1298         // solhint-disable-next-line reason-string
1299         require(address(whitelistedNftContract) == msg.sender, "NftStaking: contract not whitelisted");
1300 
1301         uint64 weight = _validateAndGetNftWeight(tokenId);
1302 
1303         uint16 periodLengthInCycles_ = periodLengthInCycles;
1304         uint16 currentCycle = _getCycle(block.timestamp);
1305 
1306         _updateHistories(tokenOwner, int128(weight), currentCycle);
1307 
1308         // initialise the next claim if it was the first stake for this staker or if
1309         // the next claim was re-initialised (ie. rewards were claimed until the last
1310         // staker snapshot and the last staker snapshot has no stake)
1311         if (nextClaims[tokenOwner].period == 0) {
1312             uint16 currentPeriod = _getPeriod(currentCycle, periodLengthInCycles_);
1313             nextClaims[tokenOwner] = NextClaim(currentPeriod, uint64(globalHistory.length - 1), 0);
1314         }
1315 
1316         uint16 withdrawCycle = tokenInfos[tokenId].withdrawCycle;
1317         // solhint-disable-next-line reason-string
1318         require(currentCycle != withdrawCycle, "NftStaking: unstaked token cooldown");
1319 
1320         // set the staked token's info
1321         tokenInfos[tokenId] = TokenInfo(tokenOwner, weight, currentCycle, 0);
1322 
1323         emit NftStaked(tokenOwner, currentCycle, tokenId, weight);
1324     }
1325 
1326     /**
1327      * Calculates the amount of rewards for a staker over a capped number of periods.
1328      * @dev Processes until the specified maximum number of periods to claim is reached,
1329      *  or the last computable period is reached, whichever occurs first.
1330      * @param staker The staker for whom the rewards will be computed.
1331      * @param maxPeriods Maximum number of periods over which to compute the rewards.
1332      * @return claim the result of computation
1333      * @return nextClaim the next claim which can be used to update the staker's state
1334      */
1335     // solhint-disable-next-line code-complexity
1336     function _computeRewards(address staker, uint16 maxPeriods) internal view returns (ComputedClaim memory claim, NextClaim memory nextClaim) {
1337         // computing 0 periods
1338         if (maxPeriods == 0) {
1339             return (claim, nextClaim);
1340         }
1341 
1342         // the history is empty
1343         if (globalHistory.length == 0) {
1344             return (claim, nextClaim);
1345         }
1346 
1347         nextClaim = nextClaims[staker];
1348         claim.startPeriod = nextClaim.period;
1349 
1350         // nothing has been staked yet
1351         if (claim.startPeriod == 0) {
1352             return (claim, nextClaim);
1353         }
1354 
1355         uint16 periodLengthInCycles_ = periodLengthInCycles;
1356         uint16 endClaimPeriod = _getCurrentPeriod(periodLengthInCycles_);
1357 
1358         // current period is not claimable
1359         if (nextClaim.period == endClaimPeriod) {
1360             return (claim, nextClaim);
1361         }
1362 
1363         // retrieve the next snapshots if they exist
1364         Snapshot[] memory stakerHistory = stakerHistories[staker];
1365 
1366         Snapshot memory globalSnapshot = globalHistory[nextClaim.globalSnapshotIndex];
1367         Snapshot memory stakerSnapshot = stakerHistory[nextClaim.stakerSnapshotIndex];
1368         Snapshot memory nextGlobalSnapshot;
1369         Snapshot memory nextStakerSnapshot;
1370 
1371         if (nextClaim.globalSnapshotIndex != globalHistory.length - 1) {
1372             nextGlobalSnapshot = globalHistory[nextClaim.globalSnapshotIndex + 1];
1373         }
1374         if (nextClaim.stakerSnapshotIndex != stakerHistory.length - 1) {
1375             nextStakerSnapshot = stakerHistory[nextClaim.stakerSnapshotIndex + 1];
1376         }
1377 
1378         // excludes the current period
1379         claim.periods = endClaimPeriod - nextClaim.period;
1380 
1381         if (maxPeriods < claim.periods) {
1382             claim.periods = maxPeriods;
1383         }
1384 
1385         // re-calibrate the end claim period based on the actual number of
1386         // periods to claim. nextClaim.period will be updated to this value
1387         // after exiting the loop
1388         endClaimPeriod = nextClaim.period + claim.periods;
1389 
1390         // iterate over periods
1391         while (nextClaim.period != endClaimPeriod) {
1392             uint16 nextPeriodStartCycle = nextClaim.period * periodLengthInCycles_ + 1;
1393             uint256 rewardPerCycle = rewardsSchedule[nextClaim.period];
1394             uint256 startCycle = nextPeriodStartCycle - periodLengthInCycles_;
1395             uint256 endCycle = 0;
1396 
1397             // iterate over global snapshots
1398             while (endCycle != nextPeriodStartCycle) {
1399                 // find the range-to-claim starting cycle, where the current
1400                 // global snapshot, the current staker snapshot, and the current
1401                 // period overlap
1402                 if (globalSnapshot.startCycle > startCycle) {
1403                     startCycle = globalSnapshot.startCycle;
1404                 }
1405                 if (stakerSnapshot.startCycle > startCycle) {
1406                     startCycle = stakerSnapshot.startCycle;
1407                 }
1408 
1409                 // find the range-to-claim ending cycle, where the current
1410                 // global snapshot, the current staker snapshot, and the current
1411                 // period no longer overlap. The end cycle is exclusive of the
1412                 // range-to-claim and represents the beginning cycle of the next
1413                 // range-to-claim
1414                 endCycle = nextPeriodStartCycle;
1415                 if ((nextGlobalSnapshot.startCycle != 0) && (nextGlobalSnapshot.startCycle < endCycle)) {
1416                     endCycle = nextGlobalSnapshot.startCycle;
1417                 }
1418 
1419                 // only calculate and update the claimable rewards if there is
1420                 // something to calculate with
1421                 if ((globalSnapshot.stake != 0) && (stakerSnapshot.stake != 0) && (rewardPerCycle != 0)) {
1422                     uint256 snapshotReward = (endCycle - startCycle).mul(rewardPerCycle).mul(stakerSnapshot.stake);
1423                     snapshotReward /= globalSnapshot.stake;
1424 
1425                     claim.amount = claim.amount.add(snapshotReward);
1426                 }
1427 
1428                 // advance the current global snapshot to the next (if any)
1429                 // if its cycle range has been fully processed and if the next
1430                 // snapshot starts at most on next period first cycle
1431                 if (nextGlobalSnapshot.startCycle == endCycle) {
1432                     globalSnapshot = nextGlobalSnapshot;
1433                     ++nextClaim.globalSnapshotIndex;
1434 
1435                     if (nextClaim.globalSnapshotIndex != globalHistory.length - 1) {
1436                         nextGlobalSnapshot = globalHistory[nextClaim.globalSnapshotIndex + 1];
1437                     } else {
1438                         nextGlobalSnapshot = Snapshot(0, 0);
1439                     }
1440                 }
1441 
1442                 // advance the current staker snapshot to the next (if any)
1443                 // if its cycle range has been fully processed and if the next
1444                 // snapshot starts at most on next period first cycle
1445                 if (nextStakerSnapshot.startCycle == endCycle) {
1446                     stakerSnapshot = nextStakerSnapshot;
1447                     ++nextClaim.stakerSnapshotIndex;
1448 
1449                     if (nextClaim.stakerSnapshotIndex != stakerHistory.length - 1) {
1450                         nextStakerSnapshot = stakerHistory[nextClaim.stakerSnapshotIndex + 1];
1451                     } else {
1452                         nextStakerSnapshot = Snapshot(0, 0);
1453                     }
1454                 }
1455             }
1456 
1457             ++nextClaim.period;
1458         }
1459 
1460         return (claim, nextClaim);
1461     }
1462 
1463     /**
1464      * Updates the global and staker histories at the current cycle with a new difference in stake.
1465      * @dev Emits a HistoriesUpdated event.
1466      * @param staker The staker who is updating the history.
1467      * @param stakeDelta The difference to apply to the current stake.
1468      * @param currentCycle The current cycle.
1469      */
1470     function _updateHistories(
1471         address staker,
1472         int128 stakeDelta,
1473         uint16 currentCycle
1474     ) internal {
1475         uint256 stakerSnapshotIndex = _updateHistory(stakerHistories[staker], stakeDelta, currentCycle);
1476         uint256 globalSnapshotIndex = _updateHistory(globalHistory, stakeDelta, currentCycle);
1477 
1478         emit HistoriesUpdated(staker, currentCycle, stakerHistories[staker][stakerSnapshotIndex].stake, globalHistory[globalSnapshotIndex].stake);
1479     }
1480 
1481     /**
1482      * Updates the history at the current cycle with a new difference in stake.
1483      * @dev It will update the latest snapshot if it starts at the current cycle, otherwise will create a new snapshot with the updated stake.
1484      * @param history The history to update.
1485      * @param stakeDelta The difference to apply to the current stake.
1486      * @param currentCycle The current cycle.
1487      * @return snapshotIndex Index of the snapshot that was updated or created (i.e. the latest snapshot index).
1488      */
1489     function _updateHistory(
1490         Snapshot[] storage history,
1491         int128 stakeDelta,
1492         uint16 currentCycle
1493     ) internal returns (uint256 snapshotIndex) {
1494         uint256 historyLength = history.length;
1495         uint128 snapshotStake;
1496 
1497         if (historyLength != 0) {
1498             // there is an existing snapshot
1499             snapshotIndex = historyLength - 1;
1500             Snapshot storage sSnapshot = history[snapshotIndex];
1501             snapshotStake = uint256(int256(sSnapshot.stake).add(stakeDelta)).toUint128();
1502 
1503             if (sSnapshot.startCycle == currentCycle) {
1504                 // update the snapshot if it starts on the current cycle
1505                 sSnapshot.stake = snapshotStake;
1506                 return snapshotIndex;
1507             }
1508 
1509             // update the snapshot index (as a reflection that a new latest
1510             // snapshot will be added to the history), if there was already an
1511             // existing snapshot
1512             snapshotIndex += 1;
1513         } else {
1514             // the snapshot index (as a reflection that a new latest snapshot
1515             // will be added to the history) should already be initialized
1516             // correctly to the default value 0
1517 
1518             // the stake delta will not be negative, if we have no history, as
1519             // that would indicate that we are unstaking without having staked
1520             // anything first
1521             snapshotStake = uint128(stakeDelta);
1522         }
1523 
1524         Snapshot memory mSnapshot;
1525         mSnapshot.stake = snapshotStake;
1526         mSnapshot.startCycle = currentCycle;
1527 
1528         // add a new snapshot in the history
1529         history.push(mSnapshot);
1530     }
1531 
1532     /*                                           Utility Internal Functions                                           */
1533 
1534     /**
1535      * Retrieves the cycle (index-1 based) at the specified timestamp.
1536      * @param timestamp The timestamp for which the cycle is derived from.
1537      * @return The cycle (index-1 based) at the specified timestamp, or zero if the contract is not started yet.
1538      */
1539     function _getCycle(uint256 timestamp) internal view returns (uint16) {
1540         uint256 startTimestamp_ = startTimestamp;
1541         if (startTimestamp_ == 0) return 0;
1542         return (((timestamp - startTimestamp_) / uint256(cycleLengthInSeconds)) + 1).toUint16();
1543     }
1544 
1545     /**
1546      * Retrieves the period (index-1 based) for the specified cycle and period length.
1547      * @param cycle The cycle within the period to retrieve.
1548      * @param periodLengthInCycles_ Length of a period, in cycles.
1549      * @return The period (index-1 based) for the specified cycle and period length, 0r zero if `cycle` is zero.
1550      */
1551     function _getPeriod(uint16 cycle, uint16 periodLengthInCycles_) internal pure returns (uint16) {
1552         if (cycle == 0) {
1553             return 0;
1554         }
1555         return (cycle - 1) / periodLengthInCycles_ + 1;
1556     }
1557 
1558     /**
1559      * Retrieves the current period (index-1 based).
1560      * @param periodLengthInCycles_ Length of a period, in cycles.
1561      * @return The current period (index-1 based).
1562      */
1563     function _getCurrentPeriod(uint16 periodLengthInCycles_) internal view returns (uint16) {
1564         return _getPeriod(_getCycle(block.timestamp), periodLengthInCycles_);
1565     }
1566 
1567     /*                                                Internal Hooks                                                */
1568 
1569     /**
1570      * Verifies that the token is eligible and returns its associated weight.
1571      * @dev Reverts if the token is not a 2019 or 2020 Car NFT.
1572      * @param nftId uint256 token identifier of the NFT.
1573      * @return uint64 the weight of the NFT.
1574      */
1575     function _validateAndGetNftWeight(uint256 nftId) internal view returns (uint64) {
1576         // Ids bits layout specification:
1577         // https://github.com/animocabrands/f1dt-core_metadata/blob/v0.1.1/src/constants.js
1578         uint256 nonFungible = (nftId >> 255) & 1;
1579         uint256 tokenType = (nftId >> 240) & 0xFF;
1580         uint256 tokenSeason = (nftId >> 224) & 0xFF;
1581         uint256 tokenRarity = (nftId >> 176) & 0xFF;
1582 
1583         // For interpretation of values, refer to https://github.com/animocabrands/f1dt-core_metadata/blob/version-1.0.3/src/mappings/
1584         // Types: https://github.com/animocabrands/f1dt-core_metadata/blob/version-1.0.3/src/mappings/CommonAttributes/Type/Types.js
1585         // Seasons: https://github.com/animocabrands/f1dt-core_metadata/blob/version-1.0.3/src/mappings/CommonAttributes/Season/Seasons.js
1586         // Rarities: https://github.com/animocabrands/f1dt-core_metadata/blob/version-1.0.3/src/mappings/CommonAttributes/Rarity/Rarities.js
1587         require(nonFungible == 1 && tokenType == 1 && (tokenSeason == 2 || tokenSeason == 3), "NftStaking: wrong token");
1588 
1589         return weightsByRarity[tokenRarity];
1590     }
1591 }
1592 
1593 interface IWhitelistedNftContract {
1594     function transferFrom(
1595         address from,
1596         address to,
1597         uint256 tokenId
1598     ) external;
1599 }