1 pragma solidity ^0.7.0;
2 
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      *
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      *
57      * - Subtraction cannot overflow.
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      *
74      * - Multiplication cannot overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      *
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 
161 /**
162  * @dev Collection of functions related to the address type
163  */
164 library Address {
165     /**
166      * @dev Returns true if `account` is a contract.
167      *
168      * [IMPORTANT]
169      * ====
170      * It is unsafe to assume that an address for which this function returns
171      * false is an externally-owned account (EOA) and not a contract.
172      *
173      * Among others, `isContract` will return false for the following
174      * types of addresses:
175      *
176      *  - an externally-owned account
177      *  - a contract in construction
178      *  - an address where a contract will be created
179      *  - an address where a contract lived, but was destroyed
180      * ====
181      */
182     function isContract(address account) internal view returns (bool) {
183         // This method relies on extcodesize, which returns 0 for contracts in
184         // construction, since the code is only stored at the end of the
185         // constructor execution.
186 
187         uint256 size;
188         // solhint-disable-next-line no-inline-assembly
189         assembly { size := extcodesize(account) }
190         return size > 0;
191     }
192 
193     /**
194      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
195      * `recipient`, forwarding all available gas and reverting on errors.
196      *
197      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
198      * of certain opcodes, possibly making contracts go over the 2300 gas limit
199      * imposed by `transfer`, making them unable to receive funds via
200      * `transfer`. {sendValue} removes this limitation.
201      *
202      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
203      *
204      * IMPORTANT: because control is transferred to `recipient`, care must be
205      * taken to not create reentrancy vulnerabilities. Consider using
206      * {ReentrancyGuard} or the
207      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
208      */
209     function sendValue(address payable recipient, uint256 amount) internal {
210         require(address(this).balance >= amount, "Address: insufficient balance");
211 
212         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
213         (bool success, ) = recipient.call{ value: amount }("");
214         require(success, "Address: unable to send value, recipient may have reverted");
215     }
216 
217     /**
218      * @dev Performs a Solidity function call using a low level `call`. A
219      * plain`call` is an unsafe replacement for a function call: use this
220      * function instead.
221      *
222      * If `target` reverts with a revert reason, it is bubbled up by this
223      * function (like regular Solidity function calls).
224      *
225      * Returns the raw returned data. To convert to the expected return value,
226      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
227      *
228      * Requirements:
229      *
230      * - `target` must be a contract.
231      * - calling `target` with `data` must not revert.
232      *
233      * _Available since v3.1._
234      */
235     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
236       return functionCall(target, data, "Address: low-level call failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
241      * `errorMessage` as a fallback revert reason when `target` reverts.
242      *
243      * _Available since v3.1._
244      */
245     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
246         return functionCallWithValue(target, data, 0, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but also transferring `value` wei to `target`.
252      *
253      * Requirements:
254      *
255      * - the calling contract must have an ETH balance of at least `value`.
256      * - the called Solidity function must be `payable`.
257      *
258      * _Available since v3.1._
259      */
260     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
261         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
266      * with `errorMessage` as a fallback revert reason when `target` reverts.
267      *
268      * _Available since v3.1._
269      */
270     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
271         require(address(this).balance >= value, "Address: insufficient balance for call");
272         require(isContract(target), "Address: call to non-contract");
273 
274         // solhint-disable-next-line avoid-low-level-calls
275         (bool success, bytes memory returndata) = target.call{ value: value }(data);
276         return _verifyCallResult(success, returndata, errorMessage);
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
281      * but performing a static call.
282      *
283      * _Available since v3.3._
284      */
285     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
286         return functionStaticCall(target, data, "Address: low-level static call failed");
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
291      * but performing a static call.
292      *
293      * _Available since v3.3._
294      */
295     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
296         require(isContract(target), "Address: static call to non-contract");
297 
298         // solhint-disable-next-line avoid-low-level-calls
299         (bool success, bytes memory returndata) = target.staticcall(data);
300         return _verifyCallResult(success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but performing a delegate call.
306      *
307      * _Available since v3.3._
308      */
309     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
315      * but performing a delegate call.
316      *
317      * _Available since v3.3._
318      */
319     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
320         require(isContract(target), "Address: delegate call to non-contract");
321 
322         // solhint-disable-next-line avoid-low-level-calls
323         (bool success, bytes memory returndata) = target.delegatecall(data);
324         return _verifyCallResult(success, returndata, errorMessage);
325     }
326 
327     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
328         if (success) {
329             return returndata;
330         } else {
331             // Look for revert reason and bubble it up if present
332             if (returndata.length > 0) {
333                 // The easiest way to bubble the revert reason is using memory via assembly
334 
335                 // solhint-disable-next-line no-inline-assembly
336                 assembly {
337                     let returndata_size := mload(returndata)
338                     revert(add(32, returndata), returndata_size)
339                 }
340             } else {
341                 revert(errorMessage);
342             }
343         }
344     }
345 }
346 
347 /**
348  * @dev Interface of the ERC165 standard, as defined in the
349  * https://eips.ethereum.org/EIPS/eip-165[EIP].
350  *
351  * Implementers can declare support of contract interfaces, which can then be
352  * queried by others ({ERC165Checker}).
353  *
354  * For an implementation, see {ERC165}.
355  */
356 interface IERC165 {
357     /**
358      * @dev Returns true if this contract implements the interface defined by
359      * `interfaceId`. See the corresponding
360      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
361      * to learn more about how these ids are created.
362      *
363      * This function call must use less than 30 000 gas.
364      */
365     function supportsInterface(bytes4 interfaceId) external view returns (bool);
366 }
367 
368 /**
369  * @dev interface of MomijiToken
370  *
371  */
372 interface IMomijiToken {
373     function tokenQuantityWithId(uint256 tokenId) view external returns(uint256);
374     function tokenMaxQuantityWithId(uint256 tokenId) view external returns(uint256);
375     function mintManuallyQuantityWithId(uint256 tokenId) view external returns(uint256);
376     function creators(uint256 tokenId) view external returns(address);
377     function removeMintManuallyQuantity(uint256 tokenId, uint256 amount) external;
378     function addMintManuallyQuantity(uint256 tokenId, uint256 amount) external;
379     function mint(uint256 tokenId, address to, uint256 quantity, bytes memory data) external;
380     function balanceOf(address account, uint256 id) external view returns (uint256);
381     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes memory data) external;
382 }
383 
384 /**
385  * @dev Implementation of the {IERC165} interface.
386  *
387  * Contracts may inherit from this and call {_registerInterface} to declare
388  * their support of an interface.
389  */
390 abstract contract ERC165 is IERC165 {
391     /*
392      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
393      */
394     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
395 
396     /**
397      * @dev Mapping of interface ids to whether or not it's supported.
398      */
399     mapping(bytes4 => bool) private _supportedInterfaces;
400 
401     constructor () internal {
402         // Derived contracts need only register support for their own interfaces,
403         // we register support for ERC165 itself here
404         _registerInterface(_INTERFACE_ID_ERC165);
405     }
406 
407     /**
408      * @dev See {IERC165-supportsInterface}.
409      *
410      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
411      */
412     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
413         return _supportedInterfaces[interfaceId];
414     }
415 
416     /**
417      * @dev Registers the contract as an implementer of the interface defined by
418      * `interfaceId`. Support of the actual ERC165 interface is automatic and
419      * registering its interface id is not required.
420      *
421      * See {IERC165-supportsInterface}.
422      *
423      * Requirements:
424      *
425      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
426      */
427     function _registerInterface(bytes4 interfaceId) internal virtual {
428         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
429         _supportedInterfaces[interfaceId] = true;
430     }
431 }
432 
433 
434 /**
435  * _Available since v3.1._
436  */
437 interface IERC1155Receiver is IERC165 {
438 
439     /**
440         @dev Handles the receipt of a single ERC1155 token type. This function is
441         called at the end of a `safeTransferFrom` after the balance has been updated.
442         To accept the transfer, this must return
443         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
444         (i.e. 0xf23a6e61, or its own function selector).
445         @param operator The address which initiated the transfer (i.e. msg.sender)
446         @param from The address which previously owned the token
447         @param id The ID of the token being transferred
448         @param value The amount of tokens being transferred
449         @param data Additional data with no specified format
450         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
451     */
452     function onERC1155Received(
453         address operator,
454         address from,
455         uint256 id,
456         uint256 value,
457         bytes calldata data
458     )
459         external
460         returns(bytes4);
461 
462     /**
463         @dev Handles the receipt of a multiple ERC1155 token types. This function
464         is called at the end of a `safeBatchTransferFrom` after the balances have
465         been updated. To accept the transfer(s), this must return
466         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
467         (i.e. 0xbc197c81, or its own function selector).
468         @param operator The address which initiated the batch transfer (i.e. msg.sender)
469         @param from The address which previously owned the token
470         @param ids An array containing ids of each token being transferred (order and length must match values array)
471         @param values An array containing amounts of each token being transferred (order and length must match ids array)
472         @param data Additional data with no specified format
473         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
474     */
475     function onERC1155BatchReceived(
476         address operator,
477         address from,
478         uint256[] calldata ids,
479         uint256[] calldata values,
480         bytes calldata data
481     )
482         external
483         returns(bytes4);
484 }
485 
486 /**
487  * @dev _Available since v3.1._
488  */
489 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
490     constructor() internal {
491         _registerInterface(
492             ERC1155Receiver(0).onERC1155Received.selector ^
493             ERC1155Receiver(0).onERC1155BatchReceived.selector
494         );
495     }
496 }
497 
498 /**
499  * @dev _Available since v3.1._
500  */
501 contract ERC1155Holder is ERC1155Receiver {
502     function onERC1155Received(address, address, uint256, uint256, bytes memory) public virtual override returns (bytes4) {
503         return this.onERC1155Received.selector;
504     }
505 
506     function onERC1155BatchReceived(address, address, uint256[] memory, uint256[] memory, bytes memory) public virtual override returns (bytes4) {
507         return this.onERC1155BatchReceived.selector;
508     }
509 }
510 
511 /**
512  * @dev Library for managing
513  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
514  * types.
515  *
516  * Sets have the following properties:
517  *
518  * - Elements are added, removed, and checked for existence in constant time
519  * (O(1)).
520  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
521  *
522  * ```
523  * contract Example {
524  *     // Add the library methods
525  *     using EnumerableSet for EnumerableSet.AddressSet;
526  *
527  *     // Declare a set state variable
528  *     EnumerableSet.AddressSet private mySet;
529  * }
530  * ```
531  *
532  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
533  * and `uint256` (`UintSet`) are supported.
534  */
535 library EnumerableSet {
536     // To implement this library for multiple types with as little code
537     // repetition as possible, we write it in terms of a generic Set type with
538     // bytes32 values.
539     // The Set implementation uses private functions, and user-facing
540     // implementations (such as AddressSet) are just wrappers around the
541     // underlying Set.
542     // This means that we can only create new EnumerableSets for types that fit
543     // in bytes32.
544 
545     struct Set {
546         // Storage of set values
547         bytes32[] _values;
548 
549         // Position of the value in the `values` array, plus 1 because index 0
550         // means a value is not in the set.
551         mapping (bytes32 => uint256) _indexes;
552     }
553 
554     /**
555      * @dev Add a value to a set. O(1).
556      *
557      * Returns true if the value was added to the set, that is if it was not
558      * already present.
559      */
560     function _add(Set storage set, bytes32 value) private returns (bool) {
561         if (!_contains(set, value)) {
562             set._values.push(value);
563             // The value is stored at length-1, but we add 1 to all indexes
564             // and use 0 as a sentinel value
565             set._indexes[value] = set._values.length;
566             return true;
567         } else {
568             return false;
569         }
570     }
571 
572     /**
573      * @dev Removes a value from a set. O(1).
574      *
575      * Returns true if the value was removed from the set, that is if it was
576      * present.
577      */
578     function _remove(Set storage set, bytes32 value) private returns (bool) {
579         // We read and store the value's index to prevent multiple reads from the same storage slot
580         uint256 valueIndex = set._indexes[value];
581 
582         if (valueIndex != 0) { // Equivalent to contains(set, value)
583             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
584             // the array, and then remove the last element (sometimes called as 'swap and pop').
585             // This modifies the order of the array, as noted in {at}.
586 
587             uint256 toDeleteIndex = valueIndex - 1;
588             uint256 lastIndex = set._values.length - 1;
589 
590             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
591             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
592 
593             bytes32 lastvalue = set._values[lastIndex];
594 
595             // Move the last value to the index where the value to delete is
596             set._values[toDeleteIndex] = lastvalue;
597             // Update the index for the moved value
598             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
599 
600             // Delete the slot where the moved value was stored
601             set._values.pop();
602 
603             // Delete the index for the deleted slot
604             delete set._indexes[value];
605 
606             return true;
607         } else {
608             return false;
609         }
610     }
611 
612     /**
613      * @dev Returns true if the value is in the set. O(1).
614      */
615     function _contains(Set storage set, bytes32 value) private view returns (bool) {
616         return set._indexes[value] != 0;
617     }
618 
619     /**
620      * @dev Returns the number of values on the set. O(1).
621      */
622     function _length(Set storage set) private view returns (uint256) {
623         return set._values.length;
624     }
625 
626    /**
627     * @dev Returns the value stored at position `index` in the set. O(1).
628     *
629     * Note that there are no guarantees on the ordering of values inside the
630     * array, and it may change when more values are added or removed.
631     *
632     * Requirements:
633     *
634     * - `index` must be strictly less than {length}.
635     */
636     function _at(Set storage set, uint256 index) private view returns (bytes32) {
637         require(set._values.length > index, "EnumerableSet: index out of bounds");
638         return set._values[index];
639     }
640 
641     // Bytes32Set
642 
643     struct Bytes32Set {
644         Set _inner;
645     }
646 
647     /**
648      * @dev Add a value to a set. O(1).
649      *
650      * Returns true if the value was added to the set, that is if it was not
651      * already present.
652      */
653     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
654         return _add(set._inner, value);
655     }
656 
657     /**
658      * @dev Removes a value from a set. O(1).
659      *
660      * Returns true if the value was removed from the set, that is if it was
661      * present.
662      */
663     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
664         return _remove(set._inner, value);
665     }
666 
667     /**
668      * @dev Returns true if the value is in the set. O(1).
669      */
670     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
671         return _contains(set._inner, value);
672     }
673 
674     /**
675      * @dev Returns the number of values in the set. O(1).
676      */
677     function length(Bytes32Set storage set) internal view returns (uint256) {
678         return _length(set._inner);
679     }
680 
681    /**
682     * @dev Returns the value stored at position `index` in the set. O(1).
683     *
684     * Note that there are no guarantees on the ordering of values inside the
685     * array, and it may change when more values are added or removed.
686     *
687     * Requirements:
688     *
689     * - `index` must be strictly less than {length}.
690     */
691     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
692         return _at(set._inner, index);
693     }
694 
695     // AddressSet
696 
697     struct AddressSet {
698         Set _inner;
699     }
700 
701     /**
702      * @dev Add a value to a set. O(1).
703      *
704      * Returns true if the value was added to the set, that is if it was not
705      * already present.
706      */
707     function add(AddressSet storage set, address value) internal returns (bool) {
708         return _add(set._inner, bytes32(uint256(value)));
709     }
710 
711     /**
712      * @dev Removes a value from a set. O(1).
713      *
714      * Returns true if the value was removed from the set, that is if it was
715      * present.
716      */
717     function remove(AddressSet storage set, address value) internal returns (bool) {
718         return _remove(set._inner, bytes32(uint256(value)));
719     }
720 
721     /**
722      * @dev Returns true if the value is in the set. O(1).
723      */
724     function contains(AddressSet storage set, address value) internal view returns (bool) {
725         return _contains(set._inner, bytes32(uint256(value)));
726     }
727 
728     /**
729      * @dev Returns the number of values in the set. O(1).
730      */
731     function length(AddressSet storage set) internal view returns (uint256) {
732         return _length(set._inner);
733     }
734 
735    /**
736     * @dev Returns the value stored at position `index` in the set. O(1).
737     *
738     * Note that there are no guarantees on the ordering of values inside the
739     * array, and it may change when more values are added or removed.
740     *
741     * Requirements:
742     *
743     * - `index` must be strictly less than {length}.
744     */
745     function at(AddressSet storage set, uint256 index) internal view returns (address) {
746         return address(uint256(_at(set._inner, index)));
747     }
748 
749 
750     // UintSet
751 
752     struct UintSet {
753         Set _inner;
754     }
755 
756     /**
757      * @dev Add a value to a set. O(1).
758      *
759      * Returns true if the value was added to the set, that is if it was not
760      * already present.
761      */
762     function add(UintSet storage set, uint256 value) internal returns (bool) {
763         return _add(set._inner, bytes32(value));
764     }
765 
766     /**
767      * @dev Removes a value from a set. O(1).
768      *
769      * Returns true if the value was removed from the set, that is if it was
770      * present.
771      */
772     function remove(UintSet storage set, uint256 value) internal returns (bool) {
773         return _remove(set._inner, bytes32(value));
774     }
775 
776     /**
777      * @dev Returns true if the value is in the set. O(1).
778      */
779     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
780         return _contains(set._inner, bytes32(value));
781     }
782 
783     /**
784      * @dev Returns the number of values on the set. O(1).
785      */
786     function length(UintSet storage set) internal view returns (uint256) {
787         return _length(set._inner);
788     }
789 
790    /**
791     * @dev Returns the value stored at position `index` in the set. O(1).
792     *
793     * Note that there are no guarantees on the ordering of values inside the
794     * array, and it may change when more values are added or removed.
795     *
796     * Requirements:
797     *
798     * - `index` must be strictly less than {length}.
799     */
800     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
801         return uint256(_at(set._inner, index));
802     }
803 }
804 
805 
806 /*
807  * @dev Provides information about the current execution context, including the
808  * sender of the transaction and its data. While these are generally available
809  * via msg.sender and msg.data, they should not be accessed in such a direct
810  * manner, since when dealing with GSN meta-transactions the account sending and
811  * paying for execution may not be the actual sender (as far as an application
812  * is concerned).
813  *
814  * This contract is only required for intermediate, library-like contracts.
815  */
816 abstract contract Context {
817     function _msgSender() internal view virtual returns (address payable) {
818         return msg.sender;
819     }
820 
821     function _msgData() internal view virtual returns (bytes memory) {
822         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
823         return msg.data;
824     }
825 }
826 
827 /**
828  * @dev Contract module which provides a basic access control mechanism, where
829  * there is an account (an owner) that can be granted exclusive access to
830  * specific functions.
831  *
832  * By default, the owner account will be the one that deploys the contract. This
833  * can later be changed with {transferOwnership}.
834  *
835  * This module is used through inheritance. It will make available the modifier
836  * `onlyOwner`, which can be applied to your functions to restrict their use to
837  * the owner.
838  */
839 abstract contract Ownable is Context {
840     address private _owner;
841 
842     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
843 
844     /**
845      * @dev Initializes the contract setting the deployer as the initial owner.
846      */
847     constructor () internal {
848         address msgSender = _msgSender();
849         _owner = msgSender;
850         emit OwnershipTransferred(address(0), msgSender);
851     }
852 
853     /**
854      * @dev Returns the address of the current owner.
855      */
856     function owner() public view returns (address) {
857         return _owner;
858     }
859 
860     /**
861      * @dev Throws if called by any account other than the owner.
862      */
863     modifier onlyOwner() {
864         require(_owner == _msgSender(), "Ownable: caller is not the owner");
865         _;
866     }
867 
868     /**
869      * @dev Leaves the contract without owner. It will not be possible to call
870      * `onlyOwner` functions anymore. Can only be called by the current owner.
871      *
872      * NOTE: Renouncing ownership will leave the contract without an owner,
873      * thereby removing any functionality that is only available to the owner.
874      */
875     function renounceOwnership() public virtual onlyOwner {
876         emit OwnershipTransferred(_owner, address(0));
877         _owner = address(0);
878     }
879 
880     /**
881      * @dev Transfers ownership of the contract to a new account (`newOwner`).
882      * Can only be called by the current owner.
883      */
884     function transferOwnership(address newOwner) public virtual onlyOwner {
885         require(newOwner != address(0), "Ownable: new owner is the zero address");
886         emit OwnershipTransferred(_owner, newOwner);
887         _owner = newOwner;
888     }
889 }
890 
891 interface IERC20 {
892 
893     function burn(uint256 amount) external;
894     /**
895      * @dev Returns the amount of tokens in existence.
896      */
897     function totalSupply() external view returns (uint256);
898 
899     /**
900      * @dev Returns the amount of tokens owned by `account`.
901      */
902     function balanceOf(address account) external view returns (uint256);
903 
904     /**
905      * @dev Moves `amount` tokens from the caller's account to `recipient`.
906      *
907      * Returns a boolean value indicating whether the operation succeeded.
908      *
909      * Emits a {Transfer} event.
910      */
911     function transfer(address recipient, uint256 amount) external returns (bool);
912 
913     /**
914      * @dev Returns the remaining number of tokens that `spender` will be
915      * allowed to spend on behalf of `owner` through {transferFrom}. This is
916      * zero by default.
917      *
918      * This value changes when {approve} or {transferFrom} are called.
919      */
920     function allowance(address owner, address spender) external view returns (uint256);
921 
922     /**
923      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
924      *
925      * Returns a boolean value indicating whether the operation succeeded.
926      *
927      * IMPORTANT: Beware that changing an allowance with this method brings the risk
928      * that someone may use both the old and the new allowance by unfortunate
929      * transaction ordering. One possible solution to mitigate this race
930      * condition is to first reduce the spender's allowance to 0 and set the
931      * desired value afterwards:
932      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
933      *
934      * Emits an {Approval} event.
935      */
936     function approve(address spender, uint256 amount) external returns (bool);
937 
938     /**
939      * @dev Moves `amount` tokens from `sender` to `recipient` using the
940      * allowance mechanism. `amount` is then deducted from the caller's
941      * allowance.
942      *
943      * Returns a boolean value indicating whether the operation succeeded.
944      *
945      * Emits a {Transfer} event.
946      */
947     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
948 
949     /**
950      * @dev Emitted when `value` tokens are moved from one account (`from`) to
951      * another (`to`).
952      *
953      * Note that `value` may be zero.
954      */
955     event Transfer(address indexed from, address indexed to, uint256 value);
956 
957     /**
958      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
959      * a call to {approve}. `value` is the new allowance.
960      */
961     event Approval(address indexed owner, address indexed spender, uint256 value);
962 }
963 
964 /**
965  * @title SafeERC20
966  * @dev Wrappers around ERC20 operations that throw on failure (when the token
967  * contract returns false). Tokens that return no value (and instead revert or
968  * throw on failure) are also supported, non-reverting calls are assumed to be
969  * successful.
970  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
971  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
972  */
973 library SafeERC20 {
974     using SafeMath for uint256;
975     using Address for address;
976 
977     function safeTransfer(IERC20 token, address to, uint256 value) internal {
978         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
979     }
980 
981     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
982         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
983     }
984 
985     /**
986      * @dev Deprecated. This function has issues similar to the ones found in
987      * {IERC20-approve}, and its usage is discouraged.
988      *
989      * Whenever possible, use {safeIncreaseAllowance} and
990      * {safeDecreaseAllowance} instead.
991      */
992     function safeApprove(IERC20 token, address spender, uint256 value) internal {
993         // safeApprove should only be called when setting an initial allowance,
994         // or when resetting it to zero. To increase and decrease it, use
995         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
996         // solhint-disable-next-line max-line-length
997         require((value == 0) || (token.allowance(address(this), spender) == 0),
998             "SafeERC20: approve from non-zero to non-zero allowance"
999         );
1000         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1001     }
1002 
1003     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1004         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1005         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1006     }
1007 
1008     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1009         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1010         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1011     }
1012 
1013     /**
1014      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1015      * on the return value: the return value is optional (but if data is returned, it must not be false).
1016      * @param token The token targeted by the call.
1017      * @param data The call data (encoded using abi.encode or one of its variants).
1018      */
1019     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1020         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1021         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1022         // the target address contains contract code and also asserts for success in the low-level call.
1023 
1024         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1025         if (returndata.length > 0) { // Return data is optional
1026             // solhint-disable-next-line max-line-length
1027             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1028         }
1029     }
1030 }
1031 
1032 
1033 contract GameMachine is Ownable, ERC1155Holder {
1034     using SafeERC20 for IERC20;
1035     using SafeMath for uint256;
1036     using Address for address;
1037     using EnumerableSet for EnumerableSet.UintSet;
1038     using EnumerableSet for EnumerableSet.AddressSet;
1039 
1040     /**
1041      * @dev Game round
1042      */
1043     struct Round {
1044         uint256 id; // request id.
1045         address player; // address of player.
1046         RoundStatus status; // status of the round.
1047         uint256 times; // how many times of this round;
1048         uint256[20] cards; // Prize card ot this round.
1049     }
1050     enum RoundStatus { Pending, Finished } // status of this round
1051     mapping(address => Round) public gameRounds;
1052     uint256 public roundCount; //until now, the total round of this Gamemachine.
1053 
1054     /***********************************
1055      * @dev Configuration of this GameMachine
1056      ***********************************/
1057     uint256 public machineId;
1058     string public machineTitle;
1059     string public machineDescription;
1060     string public machineUri;
1061     bool public maintaining = true;
1062     bool public banned = false;
1063 
1064     // This is a set which contains cradID
1065     EnumerableSet.UintSet private _cardsSet;
1066     // This mapping contains cardId => amount
1067     mapping(uint256 => uint256) public amountWithId;
1068     mapping(uint256 => uint256) public cardMintedAmountWithId;
1069     // Prize pool with a random number to cardId
1070     mapping(uint256 => uint256) private _prizePool;
1071     // The amount of cards in this machine.
1072     uint256 public cardAmount;
1073 
1074     uint256 private _salt;
1075     uint256 public shuffleCount = 10;
1076     event ShuffleCount(uint256 shaffle);
1077 
1078     /*******************************
1079      * somehting about token
1080      *******************************/
1081     //  burn rate 0 - 10
1082     uint256 public currencyBurnRate = 7;
1083     // Currency of the game machine, like DOKI, AZUKI.
1084     IERC20 public currencyToken;
1085     // the price of playing one time.
1086     uint256 public playOncePrice;
1087     // ERC1155 Token
1088     IMomijiToken public momijiToken;
1089 
1090     EnumerableSet.AddressSet private _profitAccountSet;
1091 
1092     address public administrator;
1093 
1094     event AddCardNotMinted(uint256 cardId, uint256 amount, uint256 cardAmount);
1095     event AddCardMinted(uint256 cardId, uint256 amount, uint256 cardAmount);
1096     event RemoveCard(uint256 card, uint256 removeAmount, uint256 cardAmount);
1097     event RunMachineSuccessfully(address account, uint256 times);
1098     event ChangePlayOncePrice(uint256 newPrice);
1099     event LockMachine(bool locked);
1100 
1101     constructor(uint256 _machineId, string memory _machineTitle, IMomijiToken _momijiToken, IERC20 _currencyToken) {
1102         machineId = _machineId;
1103         machineTitle = _machineTitle;
1104         machineDescription = _machineTitle;
1105         momijiToken = _momijiToken;
1106         currencyToken = _currencyToken;
1107         administrator = owner();
1108         _salt = uint256(keccak256(abi.encodePacked(_momijiToken, _currencyToken, block.timestamp))).mod(10000);
1109     }
1110 
1111     /**
1112      * @dev add cards which have not been minted into machine.
1113      * @param cardId. Card id you want to add.
1114      * @param amount. How many cards you want to add.
1115      */
1116     function addCardNotMintedWithAmount(uint256 cardId, uint256 amount) public onlyOwner {
1117         require((momijiToken.tokenQuantityWithId(cardId) + amount) <= momijiToken.tokenMaxQuantityWithId(cardId), "You add too much.");
1118         require(momijiToken.creators(cardId) == msg.sender, "You are not the creator of this Card.");
1119         _cardsSet.add(cardId);
1120         for (uint256 i = 0; i < amount; i ++) {
1121             _prizePool[cardAmount + i] = cardId;
1122         }
1123         amountWithId[cardId] = amountWithId[cardId].add(amount);
1124         momijiToken.removeMintManuallyQuantity(cardId, amount);
1125         cardAmount = cardAmount.add(amount);
1126         emit AddCardNotMinted(cardId, amount, cardAmount);
1127     }
1128 
1129     /**
1130      * @dev Add cards which have been minted, and your owned cards
1131      * @param cardId. Card id you want to add.
1132      * @param amount. How many cards you want to add.
1133      */
1134     function addCardMintedWithAmount(uint256 cardId, uint256 amount) public onlyOwner {
1135         require(momijiToken.balanceOf(msg.sender, cardId) >= amount, "You don't have enough Cards");
1136         momijiToken.safeTransferFrom(msg.sender, address(this), cardId, amount, "Add Card");
1137         cardMintedAmountWithId[cardId] = cardMintedAmountWithId[cardId].add(amount);
1138         amountWithId[cardId] = amountWithId[cardId].add(amount);
1139         for (uint256 i = 0; i < amount; i ++) {
1140             _prizePool[cardAmount + i] = cardId;
1141         }
1142         cardAmount = cardAmount.add(amount);
1143         emit AddCardMinted(cardId, amount, cardAmount);
1144     }
1145 
1146     function runMachine(uint256 userProvidedSeed, uint256 times) public onlyHuman unbanned {
1147         require(times > 0, "Times can not be 0");
1148         require(times <= 20, "Over times.");
1149         require(!maintaining, "The machine is under maintenance");
1150         require(times <= cardAmount, "You play too many times.");
1151         _createARound(times);
1152         // get random seed with userProvidedSeed and address of sender.
1153         uint256 seed = uint256(keccak256(abi.encode(userProvidedSeed, msg.sender)));
1154         _shufflePrizePool(seed);
1155 
1156         for (uint256 i = 0; i < times; i ++) {
1157             // get randomResult with seed and salt, then mod cardAmount.
1158             uint256 randomResult = _getRandomNumebr(seed, _salt, cardAmount);
1159             // update random salt.
1160             _salt = ((randomResult + cardAmount + _salt) * (i + 1) * block.timestamp).mod(cardAmount) + 1;
1161             // transfer the cards.
1162             uint256 result = (randomResult * _salt).mod(cardAmount);
1163             _updateRound(result, i);
1164         }
1165 
1166         uint256 price = playOncePrice.mul(times);
1167         _transferAndBurnToken(price);
1168         _distributePrize();
1169 
1170         emit RunMachineSuccessfully(msg.sender, times);
1171     }
1172 
1173     /**
1174      * @param amount how much token will be needed and will be burned.
1175      */
1176     function _transferAndBurnToken(uint256 amount) private {
1177         _burnCurrencyTokenBalance();
1178         // 1. burn token
1179         uint256 burnAmount = amount.mul(currencyBurnRate).div(10);
1180         // 2. transfer token from use to this machine
1181         currencyToken.transferFrom(msg.sender, address(this), burnAmount);
1182         // 3. tansfer token remaining to dev account.
1183         uint256 remainingAmount = amount.sub(burnAmount);
1184         uint256 profitAccountAmount = _profitAccountSet.length();
1185         uint256 transferAmount = remainingAmount.div(profitAccountAmount);
1186 
1187         for (uint256 i = 0; i < profitAccountAmount; i ++) {
1188             address toAddress = _profitAccountSet.at(i);
1189             currencyToken.safeTransferFrom(msg.sender, toAddress, transferAmount);
1190         }
1191     }
1192 
1193     function _distributePrize() private {
1194         for (uint i = 0; i < gameRounds[msg.sender].times; i ++) {
1195             uint256 cardId = gameRounds[msg.sender].cards[i];
1196             require(amountWithId[cardId] > 0, "No enough cards of this kind in the Mchine.");
1197             require(_calculateLastQuantityWithId(cardId) > 0, "Can not mint more cards of this kind.");
1198 
1199             if (cardMintedAmountWithId[cardId] > 0) {
1200                 momijiToken.safeTransferFrom(address(this), msg.sender, cardId, 1, '');
1201                 cardMintedAmountWithId[cardId] = cardMintedAmountWithId[cardId].sub(1);
1202             } else {
1203                 momijiToken.mint(cardId, msg.sender, 1, "Minted by Gacha Machine.");
1204             }
1205 
1206             amountWithId[cardId] = amountWithId[cardId].sub(1);
1207         }
1208         gameRounds[msg.sender].status = RoundStatus.Finished;
1209     }
1210 
1211     function _updateRound(uint256 randomResult, uint256 rand) private {
1212         uint256 cardId = _prizePool[randomResult];
1213         _prizePool[randomResult] = _prizePool[cardAmount - 1];
1214         cardAmount = cardAmount.sub(1);
1215         gameRounds[msg.sender].cards[rand] = cardId;
1216     }
1217 
1218     function _getRandomNumebr(uint256 seed, uint256 salt, uint256 mod) view private returns(uint256) {
1219         return uint256(keccak256(abi.encode(block.timestamp, block.difficulty, block.coinbase, block.gaslimit, seed, block.number))).mod(mod).add(seed).add(salt);
1220     }
1221 
1222     function _calculateLastQuantityWithId(uint256 cardId) view private returns(uint256) {
1223         return momijiToken.tokenMaxQuantityWithId(cardId)
1224                           .sub(momijiToken.tokenQuantityWithId(cardId));
1225     }
1226 
1227     function _createARound(uint256 times) private {
1228         gameRounds[msg.sender].id = roundCount + 1;
1229         gameRounds[msg.sender].player = msg.sender;
1230         gameRounds[msg.sender].status = RoundStatus.Pending;
1231         gameRounds[msg.sender].times = times;
1232         roundCount = roundCount.add(1);
1233     }
1234 
1235     function _burnCurrencyTokenBalance() private {
1236         uint256 balance = currencyToken.balanceOf(address(this));
1237         if (balance > 0) {
1238             currencyToken.burn(balance);
1239         }
1240     }
1241 
1242     // shuffle the prize pool again.
1243     function _shufflePrizePool(uint256 seed) private {
1244         for (uint256 i = 0; i < shuffleCount; i++) {
1245             uint256 randomResult = _getRandomNumebr(seed, _salt, cardAmount);
1246             _salt = ((randomResult + cardAmount + _salt) * (i + 1) * block.timestamp).mod(cardAmount);
1247             emit ShuffleCount(_salt);
1248             _swapPrize(i, _salt);
1249         }
1250     }
1251 
1252     function _swapPrize(uint256 a, uint256 b) private {
1253         uint256 temp = _prizePool[a];
1254         _prizePool[a] = _prizePool[b];
1255         _prizePool[b] = temp;
1256     }
1257 
1258     function cardIdCount() view public returns(uint256) {
1259         return _cardsSet.length();
1260     }
1261 
1262     function cardIdWithIndex(uint256 index) view public returns(uint256) {
1263         return _cardsSet.at(index);
1264     }
1265 
1266     function changeShuffleCount(uint256 _shuffleCount) public onlyAdministrator {
1267         shuffleCount = _shuffleCount;
1268     }
1269 
1270     function changePlayOncePrice(uint256 newPrice) public onlyOwner {
1271         playOncePrice = newPrice;
1272         emit ChangePlayOncePrice(newPrice);
1273     }
1274 
1275     function getCardId(address account, uint256 at) view public returns(uint256) {
1276         return gameRounds[account].cards[at];
1277     }
1278 
1279     function unlockMachine() public onlyOwner {
1280         maintaining = false;
1281         emit LockMachine(false);
1282     }
1283 
1284     function lockMachine() public onlyOwner {
1285         maintaining = true;
1286         emit LockMachine(true);
1287     }
1288 
1289     function addProfitAccount(address account) public onlyAdministrator {
1290         _profitAccountSet.add(account);
1291     }
1292 
1293     function removeProfitAccount(address account) public onlyAdministrator {
1294         _profitAccountSet.remove(account);
1295     }
1296 
1297     function changeBurnRate(uint256 rate) public onlyAdministrator {
1298         require(rate <= 10, "Rate is too big.");
1299         currencyBurnRate = rate;
1300     }
1301 
1302     function transferAdministrator(address account) public onlyAdministrator {
1303         require(account != address(0), "Ownable: new owner is the zero address");
1304         administrator = account;
1305     }
1306 
1307     function banThisMachine() public onlyAdministrator {
1308         banned = true;
1309     }
1310 
1311     function unbanThisMachine() public onlyAdministrator {
1312         banned = false;
1313     }
1314 
1315     function changeMachineTitle(string memory title) public onlyOwner {
1316         machineTitle = title;
1317     }
1318 
1319     function changeMachineDescription(string memory description) public onlyOwner {
1320         machineDescription = description;
1321     }
1322 
1323     /**
1324      * Modifiers
1325      */
1326     modifier onlyHuman() {
1327         require(!address(msg.sender).isContract() && tx.origin == msg.sender, "Only for human.");
1328         _;
1329     }
1330 
1331     modifier onlyAdministrator() {
1332         require(address(msg.sender) == administrator, "Only for administrator.");
1333         _;
1334     }
1335 
1336     modifier unbanned() {
1337         require(!banned, "This machine is banned.");
1338         _;
1339     }
1340 }