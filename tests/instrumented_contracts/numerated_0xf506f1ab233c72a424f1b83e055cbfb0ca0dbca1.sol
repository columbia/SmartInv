1 // Sources flattened with hardhat v2.6.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.3.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.0
31 
32 
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _setOwner(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _setOwner(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _setOwner(newOwner);
93     }
94 
95     function _setOwner(address newOwner) private {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 
103 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.0
104 
105 
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev String operations.
111  */
112 library Strings {
113     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
114 
115     /**
116      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
117      */
118     function toString(uint256 value) internal pure returns (string memory) {
119         // Inspired by OraclizeAPI's implementation - MIT licence
120         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
121 
122         if (value == 0) {
123             return "0";
124         }
125         uint256 temp = value;
126         uint256 digits;
127         while (temp != 0) {
128             digits++;
129             temp /= 10;
130         }
131         bytes memory buffer = new bytes(digits);
132         while (value != 0) {
133             digits -= 1;
134             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
135             value /= 10;
136         }
137         return string(buffer);
138     }
139 
140     /**
141      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
142      */
143     function toHexString(uint256 value) internal pure returns (string memory) {
144         if (value == 0) {
145             return "0x00";
146         }
147         uint256 temp = value;
148         uint256 length = 0;
149         while (temp != 0) {
150             length++;
151             temp >>= 8;
152         }
153         return toHexString(value, length);
154     }
155 
156     /**
157      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
158      */
159     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
160         bytes memory buffer = new bytes(2 * length + 2);
161         buffer[0] = "0";
162         buffer[1] = "x";
163         for (uint256 i = 2 * length + 1; i > 1; --i) {
164             buffer[i] = _HEX_SYMBOLS[value & 0xf];
165             value >>= 4;
166         }
167         require(value == 0, "Strings: hex length insufficient");
168         return string(buffer);
169     }
170 }
171 
172 
173 // File @openzeppelin/contracts/utils/Address.sol@v4.3.0
174 
175 
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @dev Collection of functions related to the address type
181  */
182 library Address {
183     /**
184      * @dev Returns true if `account` is a contract.
185      *
186      * [IMPORTANT]
187      * ====
188      * It is unsafe to assume that an address for which this function returns
189      * false is an externally-owned account (EOA) and not a contract.
190      *
191      * Among others, `isContract` will return false for the following
192      * types of addresses:
193      *
194      *  - an externally-owned account
195      *  - a contract in construction
196      *  - an address where a contract will be created
197      *  - an address where a contract lived, but was destroyed
198      * ====
199      */
200     function isContract(address account) internal view returns (bool) {
201         // This method relies on extcodesize, which returns 0 for contracts in
202         // construction, since the code is only stored at the end of the
203         // constructor execution.
204 
205         uint256 size;
206         assembly {
207             size := extcodesize(account)
208         }
209         return size > 0;
210     }
211 
212     /**
213      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
214      * `recipient`, forwarding all available gas and reverting on errors.
215      *
216      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
217      * of certain opcodes, possibly making contracts go over the 2300 gas limit
218      * imposed by `transfer`, making them unable to receive funds via
219      * `transfer`. {sendValue} removes this limitation.
220      *
221      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
222      *
223      * IMPORTANT: because control is transferred to `recipient`, care must be
224      * taken to not create reentrancy vulnerabilities. Consider using
225      * {ReentrancyGuard} or the
226      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
227      */
228     function sendValue(address payable recipient, uint256 amount) internal {
229         require(address(this).balance >= amount, "Address: insufficient balance");
230 
231         (bool success, ) = recipient.call{value: amount}("");
232         require(success, "Address: unable to send value, recipient may have reverted");
233     }
234 
235     /**
236      * @dev Performs a Solidity function call using a low level `call`. A
237      * plain `call` is an unsafe replacement for a function call: use this
238      * function instead.
239      *
240      * If `target` reverts with a revert reason, it is bubbled up by this
241      * function (like regular Solidity function calls).
242      *
243      * Returns the raw returned data. To convert to the expected return value,
244      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
245      *
246      * Requirements:
247      *
248      * - `target` must be a contract.
249      * - calling `target` with `data` must not revert.
250      *
251      * _Available since v3.1._
252      */
253     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
254         return functionCall(target, data, "Address: low-level call failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
259      * `errorMessage` as a fallback revert reason when `target` reverts.
260      *
261      * _Available since v3.1._
262      */
263     function functionCall(
264         address target,
265         bytes memory data,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         return functionCallWithValue(target, data, 0, errorMessage);
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
273      * but also transferring `value` wei to `target`.
274      *
275      * Requirements:
276      *
277      * - the calling contract must have an ETH balance of at least `value`.
278      * - the called Solidity function must be `payable`.
279      *
280      * _Available since v3.1._
281      */
282     function functionCallWithValue(
283         address target,
284         bytes memory data,
285         uint256 value
286     ) internal returns (bytes memory) {
287         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
292      * with `errorMessage` as a fallback revert reason when `target` reverts.
293      *
294      * _Available since v3.1._
295      */
296     function functionCallWithValue(
297         address target,
298         bytes memory data,
299         uint256 value,
300         string memory errorMessage
301     ) internal returns (bytes memory) {
302         require(address(this).balance >= value, "Address: insufficient balance for call");
303         require(isContract(target), "Address: call to non-contract");
304 
305         (bool success, bytes memory returndata) = target.call{value: value}(data);
306         return verifyCallResult(success, returndata, errorMessage);
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
311      * but performing a static call.
312      *
313      * _Available since v3.3._
314      */
315     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
316         return functionStaticCall(target, data, "Address: low-level static call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
321      * but performing a static call.
322      *
323      * _Available since v3.3._
324      */
325     function functionStaticCall(
326         address target,
327         bytes memory data,
328         string memory errorMessage
329     ) internal view returns (bytes memory) {
330         require(isContract(target), "Address: static call to non-contract");
331 
332         (bool success, bytes memory returndata) = target.staticcall(data);
333         return verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but performing a delegate call.
339      *
340      * _Available since v3.4._
341      */
342     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
343         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
348      * but performing a delegate call.
349      *
350      * _Available since v3.4._
351      */
352     function functionDelegateCall(
353         address target,
354         bytes memory data,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         require(isContract(target), "Address: delegate call to non-contract");
358 
359         (bool success, bytes memory returndata) = target.delegatecall(data);
360         return verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     /**
364      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
365      * revert reason using the provided one.
366      *
367      * _Available since v4.3._
368      */
369     function verifyCallResult(
370         bool success,
371         bytes memory returndata,
372         string memory errorMessage
373     ) internal pure returns (bytes memory) {
374         if (success) {
375             return returndata;
376         } else {
377             // Look for revert reason and bubble it up if present
378             if (returndata.length > 0) {
379                 // The easiest way to bubble the revert reason is using memory via assembly
380 
381                 assembly {
382                     let returndata_size := mload(returndata)
383                     revert(add(32, returndata), returndata_size)
384                 }
385             } else {
386                 revert(errorMessage);
387             }
388         }
389     }
390 }
391 
392 
393 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.0
394 
395 
396 
397 pragma solidity ^0.8.0;
398 
399 // CAUTION
400 // This version of SafeMath should only be used with Solidity 0.8 or later,
401 // because it relies on the compiler's built in overflow checks.
402 
403 /**
404  * @dev Wrappers over Solidity's arithmetic operations.
405  *
406  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
407  * now has built in overflow checking.
408  */
409 library SafeMath {
410     /**
411      * @dev Returns the addition of two unsigned integers, with an overflow flag.
412      *
413      * _Available since v3.4._
414      */
415     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
416         unchecked {
417             uint256 c = a + b;
418             if (c < a) return (false, 0);
419             return (true, c);
420         }
421     }
422 
423     /**
424      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
425      *
426      * _Available since v3.4._
427      */
428     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
429         unchecked {
430             if (b > a) return (false, 0);
431             return (true, a - b);
432         }
433     }
434 
435     /**
436      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
437      *
438      * _Available since v3.4._
439      */
440     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
441         unchecked {
442             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
443             // benefit is lost if 'b' is also tested.
444             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
445             if (a == 0) return (true, 0);
446             uint256 c = a * b;
447             if (c / a != b) return (false, 0);
448             return (true, c);
449         }
450     }
451 
452     /**
453      * @dev Returns the division of two unsigned integers, with a division by zero flag.
454      *
455      * _Available since v3.4._
456      */
457     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
458         unchecked {
459             if (b == 0) return (false, 0);
460             return (true, a / b);
461         }
462     }
463 
464     /**
465      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
466      *
467      * _Available since v3.4._
468      */
469     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
470         unchecked {
471             if (b == 0) return (false, 0);
472             return (true, a % b);
473         }
474     }
475 
476     /**
477      * @dev Returns the addition of two unsigned integers, reverting on
478      * overflow.
479      *
480      * Counterpart to Solidity's `+` operator.
481      *
482      * Requirements:
483      *
484      * - Addition cannot overflow.
485      */
486     function add(uint256 a, uint256 b) internal pure returns (uint256) {
487         return a + b;
488     }
489 
490     /**
491      * @dev Returns the subtraction of two unsigned integers, reverting on
492      * overflow (when the result is negative).
493      *
494      * Counterpart to Solidity's `-` operator.
495      *
496      * Requirements:
497      *
498      * - Subtraction cannot overflow.
499      */
500     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
501         return a - b;
502     }
503 
504     /**
505      * @dev Returns the multiplication of two unsigned integers, reverting on
506      * overflow.
507      *
508      * Counterpart to Solidity's `*` operator.
509      *
510      * Requirements:
511      *
512      * - Multiplication cannot overflow.
513      */
514     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
515         return a * b;
516     }
517 
518     /**
519      * @dev Returns the integer division of two unsigned integers, reverting on
520      * division by zero. The result is rounded towards zero.
521      *
522      * Counterpart to Solidity's `/` operator.
523      *
524      * Requirements:
525      *
526      * - The divisor cannot be zero.
527      */
528     function div(uint256 a, uint256 b) internal pure returns (uint256) {
529         return a / b;
530     }
531 
532     /**
533      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
534      * reverting when dividing by zero.
535      *
536      * Counterpart to Solidity's `%` operator. This function uses a `revert`
537      * opcode (which leaves remaining gas untouched) while Solidity uses an
538      * invalid opcode to revert (consuming all remaining gas).
539      *
540      * Requirements:
541      *
542      * - The divisor cannot be zero.
543      */
544     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
545         return a % b;
546     }
547 
548     /**
549      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
550      * overflow (when the result is negative).
551      *
552      * CAUTION: This function is deprecated because it requires allocating memory for the error
553      * message unnecessarily. For custom revert reasons use {trySub}.
554      *
555      * Counterpart to Solidity's `-` operator.
556      *
557      * Requirements:
558      *
559      * - Subtraction cannot overflow.
560      */
561     function sub(
562         uint256 a,
563         uint256 b,
564         string memory errorMessage
565     ) internal pure returns (uint256) {
566         unchecked {
567             require(b <= a, errorMessage);
568             return a - b;
569         }
570     }
571 
572     /**
573      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
574      * division by zero. The result is rounded towards zero.
575      *
576      * Counterpart to Solidity's `/` operator. Note: this function uses a
577      * `revert` opcode (which leaves remaining gas untouched) while Solidity
578      * uses an invalid opcode to revert (consuming all remaining gas).
579      *
580      * Requirements:
581      *
582      * - The divisor cannot be zero.
583      */
584     function div(
585         uint256 a,
586         uint256 b,
587         string memory errorMessage
588     ) internal pure returns (uint256) {
589         unchecked {
590             require(b > 0, errorMessage);
591             return a / b;
592         }
593     }
594 
595     /**
596      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
597      * reverting with custom message when dividing by zero.
598      *
599      * CAUTION: This function is deprecated because it requires allocating memory for the error
600      * message unnecessarily. For custom revert reasons use {tryMod}.
601      *
602      * Counterpart to Solidity's `%` operator. This function uses a `revert`
603      * opcode (which leaves remaining gas untouched) while Solidity uses an
604      * invalid opcode to revert (consuming all remaining gas).
605      *
606      * Requirements:
607      *
608      * - The divisor cannot be zero.
609      */
610     function mod(
611         uint256 a,
612         uint256 b,
613         string memory errorMessage
614     ) internal pure returns (uint256) {
615         unchecked {
616             require(b > 0, errorMessage);
617             return a % b;
618         }
619     }
620 }
621 
622 
623 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.3.0
624 
625 
626 
627 pragma solidity ^0.8.0;
628 
629 /**
630  * @dev Library for managing
631  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
632  * types.
633  *
634  * Sets have the following properties:
635  *
636  * - Elements are added, removed, and checked for existence in constant time
637  * (O(1)).
638  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
639  *
640  * ```
641  * contract Example {
642  *     // Add the library methods
643  *     using EnumerableSet for EnumerableSet.AddressSet;
644  *
645  *     // Declare a set state variable
646  *     EnumerableSet.AddressSet private mySet;
647  * }
648  * ```
649  *
650  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
651  * and `uint256` (`UintSet`) are supported.
652  */
653 library EnumerableSet {
654     // To implement this library for multiple types with as little code
655     // repetition as possible, we write it in terms of a generic Set type with
656     // bytes32 values.
657     // The Set implementation uses private functions, and user-facing
658     // implementations (such as AddressSet) are just wrappers around the
659     // underlying Set.
660     // This means that we can only create new EnumerableSets for types that fit
661     // in bytes32.
662 
663     struct Set {
664         // Storage of set values
665         bytes32[] _values;
666         // Position of the value in the `values` array, plus 1 because index 0
667         // means a value is not in the set.
668         mapping(bytes32 => uint256) _indexes;
669     }
670 
671     /**
672      * @dev Add a value to a set. O(1).
673      *
674      * Returns true if the value was added to the set, that is if it was not
675      * already present.
676      */
677     function _add(Set storage set, bytes32 value) private returns (bool) {
678         if (!_contains(set, value)) {
679             set._values.push(value);
680             // The value is stored at length-1, but we add 1 to all indexes
681             // and use 0 as a sentinel value
682             set._indexes[value] = set._values.length;
683             return true;
684         } else {
685             return false;
686         }
687     }
688 
689     /**
690      * @dev Removes a value from a set. O(1).
691      *
692      * Returns true if the value was removed from the set, that is if it was
693      * present.
694      */
695     function _remove(Set storage set, bytes32 value) private returns (bool) {
696         // We read and store the value's index to prevent multiple reads from the same storage slot
697         uint256 valueIndex = set._indexes[value];
698 
699         if (valueIndex != 0) {
700             // Equivalent to contains(set, value)
701             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
702             // the array, and then remove the last element (sometimes called as 'swap and pop').
703             // This modifies the order of the array, as noted in {at}.
704 
705             uint256 toDeleteIndex = valueIndex - 1;
706             uint256 lastIndex = set._values.length - 1;
707 
708             if (lastIndex != toDeleteIndex) {
709                 bytes32 lastvalue = set._values[lastIndex];
710 
711                 // Move the last value to the index where the value to delete is
712                 set._values[toDeleteIndex] = lastvalue;
713                 // Update the index for the moved value
714                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
715             }
716 
717             // Delete the slot where the moved value was stored
718             set._values.pop();
719 
720             // Delete the index for the deleted slot
721             delete set._indexes[value];
722 
723             return true;
724         } else {
725             return false;
726         }
727     }
728 
729     /**
730      * @dev Returns true if the value is in the set. O(1).
731      */
732     function _contains(Set storage set, bytes32 value) private view returns (bool) {
733         return set._indexes[value] != 0;
734     }
735 
736     /**
737      * @dev Returns the number of values on the set. O(1).
738      */
739     function _length(Set storage set) private view returns (uint256) {
740         return set._values.length;
741     }
742 
743     /**
744      * @dev Returns the value stored at position `index` in the set. O(1).
745      *
746      * Note that there are no guarantees on the ordering of values inside the
747      * array, and it may change when more values are added or removed.
748      *
749      * Requirements:
750      *
751      * - `index` must be strictly less than {length}.
752      */
753     function _at(Set storage set, uint256 index) private view returns (bytes32) {
754         return set._values[index];
755     }
756 
757     /**
758      * @dev Return the entire set in an array
759      *
760      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
761      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
762      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
763      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
764      */
765     function _values(Set storage set) private view returns (bytes32[] memory) {
766         return set._values;
767     }
768 
769     // Bytes32Set
770 
771     struct Bytes32Set {
772         Set _inner;
773     }
774 
775     /**
776      * @dev Add a value to a set. O(1).
777      *
778      * Returns true if the value was added to the set, that is if it was not
779      * already present.
780      */
781     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
782         return _add(set._inner, value);
783     }
784 
785     /**
786      * @dev Removes a value from a set. O(1).
787      *
788      * Returns true if the value was removed from the set, that is if it was
789      * present.
790      */
791     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
792         return _remove(set._inner, value);
793     }
794 
795     /**
796      * @dev Returns true if the value is in the set. O(1).
797      */
798     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
799         return _contains(set._inner, value);
800     }
801 
802     /**
803      * @dev Returns the number of values in the set. O(1).
804      */
805     function length(Bytes32Set storage set) internal view returns (uint256) {
806         return _length(set._inner);
807     }
808 
809     /**
810      * @dev Returns the value stored at position `index` in the set. O(1).
811      *
812      * Note that there are no guarantees on the ordering of values inside the
813      * array, and it may change when more values are added or removed.
814      *
815      * Requirements:
816      *
817      * - `index` must be strictly less than {length}.
818      */
819     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
820         return _at(set._inner, index);
821     }
822 
823     /**
824      * @dev Return the entire set in an array
825      *
826      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
827      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
828      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
829      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
830      */
831     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
832         return _values(set._inner);
833     }
834 
835     // AddressSet
836 
837     struct AddressSet {
838         Set _inner;
839     }
840 
841     /**
842      * @dev Add a value to a set. O(1).
843      *
844      * Returns true if the value was added to the set, that is if it was not
845      * already present.
846      */
847     function add(AddressSet storage set, address value) internal returns (bool) {
848         return _add(set._inner, bytes32(uint256(uint160(value))));
849     }
850 
851     /**
852      * @dev Removes a value from a set. O(1).
853      *
854      * Returns true if the value was removed from the set, that is if it was
855      * present.
856      */
857     function remove(AddressSet storage set, address value) internal returns (bool) {
858         return _remove(set._inner, bytes32(uint256(uint160(value))));
859     }
860 
861     /**
862      * @dev Returns true if the value is in the set. O(1).
863      */
864     function contains(AddressSet storage set, address value) internal view returns (bool) {
865         return _contains(set._inner, bytes32(uint256(uint160(value))));
866     }
867 
868     /**
869      * @dev Returns the number of values in the set. O(1).
870      */
871     function length(AddressSet storage set) internal view returns (uint256) {
872         return _length(set._inner);
873     }
874 
875     /**
876      * @dev Returns the value stored at position `index` in the set. O(1).
877      *
878      * Note that there are no guarantees on the ordering of values inside the
879      * array, and it may change when more values are added or removed.
880      *
881      * Requirements:
882      *
883      * - `index` must be strictly less than {length}.
884      */
885     function at(AddressSet storage set, uint256 index) internal view returns (address) {
886         return address(uint160(uint256(_at(set._inner, index))));
887     }
888 
889     /**
890      * @dev Return the entire set in an array
891      *
892      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
893      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
894      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
895      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
896      */
897     function values(AddressSet storage set) internal view returns (address[] memory) {
898         bytes32[] memory store = _values(set._inner);
899         address[] memory result;
900 
901         assembly {
902             result := store
903         }
904 
905         return result;
906     }
907 
908     // UintSet
909 
910     struct UintSet {
911         Set _inner;
912     }
913 
914     /**
915      * @dev Add a value to a set. O(1).
916      *
917      * Returns true if the value was added to the set, that is if it was not
918      * already present.
919      */
920     function add(UintSet storage set, uint256 value) internal returns (bool) {
921         return _add(set._inner, bytes32(value));
922     }
923 
924     /**
925      * @dev Removes a value from a set. O(1).
926      *
927      * Returns true if the value was removed from the set, that is if it was
928      * present.
929      */
930     function remove(UintSet storage set, uint256 value) internal returns (bool) {
931         return _remove(set._inner, bytes32(value));
932     }
933 
934     /**
935      * @dev Returns true if the value is in the set. O(1).
936      */
937     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
938         return _contains(set._inner, bytes32(value));
939     }
940 
941     /**
942      * @dev Returns the number of values on the set. O(1).
943      */
944     function length(UintSet storage set) internal view returns (uint256) {
945         return _length(set._inner);
946     }
947 
948     /**
949      * @dev Returns the value stored at position `index` in the set. O(1).
950      *
951      * Note that there are no guarantees on the ordering of values inside the
952      * array, and it may change when more values are added or removed.
953      *
954      * Requirements:
955      *
956      * - `index` must be strictly less than {length}.
957      */
958     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
959         return uint256(_at(set._inner, index));
960     }
961 
962     /**
963      * @dev Return the entire set in an array
964      *
965      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
966      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
967      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
968      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
969      */
970     function values(UintSet storage set) internal view returns (uint256[] memory) {
971         bytes32[] memory store = _values(set._inner);
972         uint256[] memory result;
973 
974         assembly {
975             result := store
976         }
977 
978         return result;
979     }
980 }
981 
982 
983 // File @openzeppelin/contracts/utils/structs/EnumerableMap.sol@v4.3.0
984 
985 
986 
987 pragma solidity ^0.8.0;
988 
989 /**
990  * @dev Library for managing an enumerable variant of Solidity's
991  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
992  * type.
993  *
994  * Maps have the following properties:
995  *
996  * - Entries are added, removed, and checked for existence in constant time
997  * (O(1)).
998  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
999  *
1000  * ```
1001  * contract Example {
1002  *     // Add the library methods
1003  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1004  *
1005  *     // Declare a set state variable
1006  *     EnumerableMap.UintToAddressMap private myMap;
1007  * }
1008  * ```
1009  *
1010  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1011  * supported.
1012  */
1013 library EnumerableMap {
1014     using EnumerableSet for EnumerableSet.Bytes32Set;
1015 
1016     // To implement this library for multiple types with as little code
1017     // repetition as possible, we write it in terms of a generic Map type with
1018     // bytes32 keys and values.
1019     // The Map implementation uses private functions, and user-facing
1020     // implementations (such as Uint256ToAddressMap) are just wrappers around
1021     // the underlying Map.
1022     // This means that we can only create new EnumerableMaps for types that fit
1023     // in bytes32.
1024 
1025     struct Map {
1026         // Storage of keys
1027         EnumerableSet.Bytes32Set _keys;
1028         mapping(bytes32 => bytes32) _values;
1029     }
1030 
1031     /**
1032      * @dev Adds a key-value pair to a map, or updates the value for an existing
1033      * key. O(1).
1034      *
1035      * Returns true if the key was added to the map, that is if it was not
1036      * already present.
1037      */
1038     function _set(
1039         Map storage map,
1040         bytes32 key,
1041         bytes32 value
1042     ) private returns (bool) {
1043         map._values[key] = value;
1044         return map._keys.add(key);
1045     }
1046 
1047     /**
1048      * @dev Removes a key-value pair from a map. O(1).
1049      *
1050      * Returns true if the key was removed from the map, that is if it was present.
1051      */
1052     function _remove(Map storage map, bytes32 key) private returns (bool) {
1053         delete map._values[key];
1054         return map._keys.remove(key);
1055     }
1056 
1057     /**
1058      * @dev Returns true if the key is in the map. O(1).
1059      */
1060     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1061         return map._keys.contains(key);
1062     }
1063 
1064     /**
1065      * @dev Returns the number of key-value pairs in the map. O(1).
1066      */
1067     function _length(Map storage map) private view returns (uint256) {
1068         return map._keys.length();
1069     }
1070 
1071     /**
1072      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1073      *
1074      * Note that there are no guarantees on the ordering of entries inside the
1075      * array, and it may change when more entries are added or removed.
1076      *
1077      * Requirements:
1078      *
1079      * - `index` must be strictly less than {length}.
1080      */
1081     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1082         bytes32 key = map._keys.at(index);
1083         return (key, map._values[key]);
1084     }
1085 
1086     /**
1087      * @dev Tries to returns the value associated with `key`.  O(1).
1088      * Does not revert if `key` is not in the map.
1089      */
1090     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1091         bytes32 value = map._values[key];
1092         if (value == bytes32(0)) {
1093             return (_contains(map, key), bytes32(0));
1094         } else {
1095             return (true, value);
1096         }
1097     }
1098 
1099     /**
1100      * @dev Returns the value associated with `key`.  O(1).
1101      *
1102      * Requirements:
1103      *
1104      * - `key` must be in the map.
1105      */
1106     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1107         bytes32 value = map._values[key];
1108         require(value != 0 || _contains(map, key), "EnumerableMap: nonexistent key");
1109         return value;
1110     }
1111 
1112     /**
1113      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1114      *
1115      * CAUTION: This function is deprecated because it requires allocating memory for the error
1116      * message unnecessarily. For custom revert reasons use {_tryGet}.
1117      */
1118     function _get(
1119         Map storage map,
1120         bytes32 key,
1121         string memory errorMessage
1122     ) private view returns (bytes32) {
1123         bytes32 value = map._values[key];
1124         require(value != 0 || _contains(map, key), errorMessage);
1125         return value;
1126     }
1127 
1128     // UintToAddressMap
1129 
1130     struct UintToAddressMap {
1131         Map _inner;
1132     }
1133 
1134     /**
1135      * @dev Adds a key-value pair to a map, or updates the value for an existing
1136      * key. O(1).
1137      *
1138      * Returns true if the key was added to the map, that is if it was not
1139      * already present.
1140      */
1141     function set(
1142         UintToAddressMap storage map,
1143         uint256 key,
1144         address value
1145     ) internal returns (bool) {
1146         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1147     }
1148 
1149     /**
1150      * @dev Removes a value from a set. O(1).
1151      *
1152      * Returns true if the key was removed from the map, that is if it was present.
1153      */
1154     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1155         return _remove(map._inner, bytes32(key));
1156     }
1157 
1158     /**
1159      * @dev Returns true if the key is in the map. O(1).
1160      */
1161     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1162         return _contains(map._inner, bytes32(key));
1163     }
1164 
1165     /**
1166      * @dev Returns the number of elements in the map. O(1).
1167      */
1168     function length(UintToAddressMap storage map) internal view returns (uint256) {
1169         return _length(map._inner);
1170     }
1171 
1172     /**
1173      * @dev Returns the element stored at position `index` in the set. O(1).
1174      * Note that there are no guarantees on the ordering of values inside the
1175      * array, and it may change when more values are added or removed.
1176      *
1177      * Requirements:
1178      *
1179      * - `index` must be strictly less than {length}.
1180      */
1181     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1182         (bytes32 key, bytes32 value) = _at(map._inner, index);
1183         return (uint256(key), address(uint160(uint256(value))));
1184     }
1185 
1186     /**
1187      * @dev Tries to returns the value associated with `key`.  O(1).
1188      * Does not revert if `key` is not in the map.
1189      *
1190      * _Available since v3.4._
1191      */
1192     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1193         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1194         return (success, address(uint160(uint256(value))));
1195     }
1196 
1197     /**
1198      * @dev Returns the value associated with `key`.  O(1).
1199      *
1200      * Requirements:
1201      *
1202      * - `key` must be in the map.
1203      */
1204     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1205         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1206     }
1207 
1208     /**
1209      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1210      *
1211      * CAUTION: This function is deprecated because it requires allocating memory for the error
1212      * message unnecessarily. For custom revert reasons use {tryGet}.
1213      */
1214     function get(
1215         UintToAddressMap storage map,
1216         uint256 key,
1217         string memory errorMessage
1218     ) internal view returns (address) {
1219         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1220     }
1221 }
1222 
1223 
1224 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.0
1225 
1226 
1227 
1228 pragma solidity ^0.8.0;
1229 
1230 /**
1231  * @dev Interface of the ERC165 standard, as defined in the
1232  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1233  *
1234  * Implementers can declare support of contract interfaces, which can then be
1235  * queried by others ({ERC165Checker}).
1236  *
1237  * For an implementation, see {ERC165}.
1238  */
1239 interface IERC165 {
1240     /**
1241      * @dev Returns true if this contract implements the interface defined by
1242      * `interfaceId`. See the corresponding
1243      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1244      * to learn more about how these ids are created.
1245      *
1246      * This function call must use less than 30 000 gas.
1247      */
1248     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1249 }
1250 
1251 
1252 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.0
1253 
1254 
1255 
1256 pragma solidity ^0.8.0;
1257 
1258 /**
1259  * @dev Required interface of an ERC721 compliant contract.
1260  */
1261 interface IERC721 is IERC165 {
1262     /**
1263      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1264      */
1265     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1266 
1267     /**
1268      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1269      */
1270     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1271 
1272     /**
1273      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1274      */
1275     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1276 
1277     /**
1278      * @dev Returns the number of tokens in ``owner``'s account.
1279      */
1280     function balanceOf(address owner) external view returns (uint256 balance);
1281 
1282     /**
1283      * @dev Returns the owner of the `tokenId` token.
1284      *
1285      * Requirements:
1286      *
1287      * - `tokenId` must exist.
1288      */
1289     function ownerOf(uint256 tokenId) external view returns (address owner);
1290 
1291     /**
1292      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1293      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1294      *
1295      * Requirements:
1296      *
1297      * - `from` cannot be the zero address.
1298      * - `to` cannot be the zero address.
1299      * - `tokenId` token must exist and be owned by `from`.
1300      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1301      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1302      *
1303      * Emits a {Transfer} event.
1304      */
1305     function safeTransferFrom(
1306         address from,
1307         address to,
1308         uint256 tokenId
1309     ) external;
1310 
1311     /**
1312      * @dev Transfers `tokenId` token from `from` to `to`.
1313      *
1314      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1315      *
1316      * Requirements:
1317      *
1318      * - `from` cannot be the zero address.
1319      * - `to` cannot be the zero address.
1320      * - `tokenId` token must be owned by `from`.
1321      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1322      *
1323      * Emits a {Transfer} event.
1324      */
1325     function transferFrom(
1326         address from,
1327         address to,
1328         uint256 tokenId
1329     ) external;
1330 
1331     /**
1332      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1333      * The approval is cleared when the token is transferred.
1334      *
1335      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1336      *
1337      * Requirements:
1338      *
1339      * - The caller must own the token or be an approved operator.
1340      * - `tokenId` must exist.
1341      *
1342      * Emits an {Approval} event.
1343      */
1344     function approve(address to, uint256 tokenId) external;
1345 
1346     /**
1347      * @dev Returns the account approved for `tokenId` token.
1348      *
1349      * Requirements:
1350      *
1351      * - `tokenId` must exist.
1352      */
1353     function getApproved(uint256 tokenId) external view returns (address operator);
1354 
1355     /**
1356      * @dev Approve or remove `operator` as an operator for the caller.
1357      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1358      *
1359      * Requirements:
1360      *
1361      * - The `operator` cannot be the caller.
1362      *
1363      * Emits an {ApprovalForAll} event.
1364      */
1365     function setApprovalForAll(address operator, bool _approved) external;
1366 
1367     /**
1368      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1369      *
1370      * See {setApprovalForAll}
1371      */
1372     function isApprovedForAll(address owner, address operator) external view returns (bool);
1373 
1374     /**
1375      * @dev Safely transfers `tokenId` token from `from` to `to`.
1376      *
1377      * Requirements:
1378      *
1379      * - `from` cannot be the zero address.
1380      * - `to` cannot be the zero address.
1381      * - `tokenId` token must exist and be owned by `from`.
1382      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1383      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1384      *
1385      * Emits a {Transfer} event.
1386      */
1387     function safeTransferFrom(
1388         address from,
1389         address to,
1390         uint256 tokenId,
1391         bytes calldata data
1392     ) external;
1393 }
1394 
1395 
1396 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.0
1397 
1398 
1399 
1400 pragma solidity ^0.8.0;
1401 
1402 /**
1403  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1404  * @dev See https://eips.ethereum.org/EIPS/eip-721
1405  */
1406 interface IERC721Enumerable is IERC721 {
1407     /**
1408      * @dev Returns the total amount of tokens stored by the contract.
1409      */
1410     function totalSupply() external view returns (uint256);
1411 
1412     /**
1413      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1414      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1415      */
1416     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1417 
1418     /**
1419      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1420      * Use along with {totalSupply} to enumerate all tokens.
1421      */
1422     function tokenByIndex(uint256 index) external view returns (uint256);
1423 }
1424 
1425 
1426 // File contracts/ERC165.sol
1427 
1428 
1429 
1430 pragma solidity ^0.8.7;
1431 
1432 
1433 contract ERC165 is IERC165 {
1434     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1435 
1436     mapping(bytes4 => bool) private _supportedInterfaces;
1437 
1438     constructor () {
1439         _registerInterface(_INTERFACE_ID_ERC165);
1440     }
1441 
1442     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1443         return _supportedInterfaces[interfaceId];
1444     }
1445 
1446     function _registerInterface(bytes4 interfaceId) internal virtual {
1447         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1448         _supportedInterfaces[interfaceId] = true;
1449     }
1450 }
1451 
1452 
1453 // File contracts/Drrt.sol
1454 
1455 
1456 
1457 pragma solidity ^0.8.7;
1458 
1459 
1460 
1461 
1462 
1463 
1464 
1465 
1466 interface IERC721Metadata is IERC721 {
1467     function name() external view returns (string memory);
1468     function symbol() external view returns (string memory);
1469 }
1470 
1471 interface IERC721Receiver {
1472     function onERC721Received(address operator, address from, uint tokenIndex, bytes calldata data) external returns (bytes4);
1473 }
1474 
1475 contract Drrt is Context, ERC165, Ownable, IERC721Metadata {
1476     using SafeMath for uint;
1477     using Strings for uint;
1478     using Address for address;
1479     using EnumerableSet for EnumerableSet.UintSet;
1480     using EnumerableMap for EnumerableMap.UintToAddressMap;
1481 
1482     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1483 
1484     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x93254542;
1485 
1486     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1487 
1488     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1489 
1490     uint public constant MAX_TOKENS_MINT_AT_ONCE = 10;
1491 
1492     uint public constant MAX_TOKENS_SUPPLY = 9090;
1493 
1494     uint public constant TOKEN_PRICE = 60000000000000000;
1495 
1496     uint public constant TOKEN_REDUCED_PRICE = 50000000000000000;
1497 
1498     uint private constant MAX_GIVEAWAY_TOKENS = 110;
1499 
1500     string private constant NAME = 'DRRT';
1501 
1502     string private constant SYMBOL = 'DRRT';
1503 
1504     uint private _saleStart;
1505 
1506     string private _baseURI;
1507 
1508     uint private _givenTokens;
1509 
1510     EnumerableMap.UintToAddressMap private _tokenOwners;
1511 
1512     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1513 
1514     mapping (uint => address) private _tokenApprovals;
1515 
1516     mapping (address => mapping (address => bool)) private _operatorApprovals;
1517 
1518     constructor() {
1519         _registerInterface(_INTERFACE_ID_ERC721);
1520         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1521         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1522     }
1523 
1524     /**
1525      * @dev Gets the balance of the specified address.
1526      * @param tokenOowner address to query the balance of
1527      * @return uint256 representing the amount owned by the passed address
1528     */
1529     function balanceOf(address tokenOowner) external view override returns (uint) {
1530         require(tokenOowner != address(0), "ERC721: balance query for the zero address");
1531 
1532         return _holderTokens[tokenOowner].length();
1533     }
1534 
1535     /**
1536      * @dev Gets the owner of the specified token ID.
1537      * @param tokenIndex uint256 ID of the token to query the owner of
1538      * @return address currently marked as the owner of the given token ID
1539     */
1540     function ownerOf(uint tokenIndex) public view override returns (address) {
1541         return _tokenOwners.get(tokenIndex, "ERC721: owner query for nonexistent token");
1542     }
1543 
1544     /**
1545      * @dev A descriptive name for a collection of NFTs in this contract
1546      *
1547      * @return descriptive name.
1548     */
1549     function name() external pure override returns (string memory) {
1550         return NAME;
1551     }
1552 
1553     /**
1554      * @dev An abbreviated name for NFTs in this contract
1555      *
1556      * @return abbreviated name (symbol).
1557     */
1558     function symbol() external pure override returns (string memory) {
1559         return SYMBOL;
1560     }
1561 
1562     /**
1563      * @dev function to set the base URI of the collection
1564      *
1565      * @param baseURI base URI string.
1566     */
1567     function setBaseURI(string memory baseURI) external onlyOwner {
1568         _baseURI = baseURI;
1569     }
1570 
1571     /**
1572      * @dev Returns the NFT index owned by the user
1573      *
1574      * @param tokenOowner address.
1575      * @param index Index in the list of owned tokens by address.
1576      *
1577      * @return token index in the collection.
1578     */
1579     function tokenOfOwnerByIndex(address tokenOowner, uint index) external view returns (uint) {
1580         return _holderTokens[tokenOowner].at(index);
1581     }
1582 
1583     /**
1584      * @dev Returns the total amount of tokens stored by the contract.
1585      *
1586      * @return total amount of tokens.
1587     */
1588     function totalSupply() public view returns (uint) {
1589         return _tokenOwners.length();
1590     }
1591 
1592     /**
1593      * @dev Starts the sale of NFTs
1594     */
1595     function startSale() external onlyOwner {
1596         require(_saleStart == 0, "Sale already started");
1597 
1598         _saleStart = block.timestamp;
1599     }
1600 
1601     /**
1602      * @dev Function checks if the sale already started
1603      *
1604      * @return true if sale started or false if sale not started.
1605     */
1606     function isSaleStarted() external view returns (bool) {
1607         return _saleStart > 0;
1608     }
1609 
1610     /**
1611      * @dev Function mints one giveaway NFT and sends to the address
1612      *
1613      * @param to address of NFT reciever.
1614     */
1615     function mintGiveaway(address to) external onlyOwner {
1616         require(_givenTokens <= MAX_GIVEAWAY_TOKENS, "Giveaway limit exceeded");
1617 
1618         _givenTokens++;
1619 
1620         _safeMint(to, totalSupply());
1621     }
1622 
1623     /**
1624      * @dev Function mints the amount of NFTs and sends them to the executor's address
1625      *
1626      * @param tokenAmount amount of NFTs for minting.
1627     */
1628     function mint(uint tokenAmount) external payable {
1629         require(_saleStart != 0, "Sale is not started");
1630         require(tokenAmount > 0, "Tokens amount cannot be 0");
1631         require(totalSupply().add(tokenAmount) - _givenTokens <= MAX_TOKENS_SUPPLY - MAX_GIVEAWAY_TOKENS, "Purchase would exceed max supply");
1632         require(tokenAmount <= MAX_TOKENS_MINT_AT_ONCE, "Can only mint 10 tokens per request");
1633 
1634         uint price;
1635 
1636         if (block.timestamp < _saleStart + 86400) {
1637             price = TOKEN_REDUCED_PRICE * tokenAmount;
1638         } else {
1639             price = TOKEN_PRICE * tokenAmount;
1640         }
1641 
1642         require(msg.value >= price, "Ether value sent is not correct");
1643 
1644         for (uint i = 0; i < tokenAmount; i++) {
1645             _safeMint(_msgSender(), totalSupply());
1646         }
1647 
1648         if (msg.value - price > 0) {
1649             payable(_msgSender()).transfer(msg.value - price);
1650         }
1651     }
1652 
1653     /**
1654      * @dev Returns the URI for a given token ID. May return an empty string.
1655      *
1656      * If the token's URI is non-empty and a base URI was set (via
1657      * {_setBaseURI}), it will be added to the token ID's URI as a prefix.
1658      *
1659      * Reverts if the token ID does not exist.
1660      * @param tokenIndex uint256 ID of the token
1661      */
1662     function tokenURI(uint tokenIndex) external view returns (string memory) {
1663         require(_exists(tokenIndex), "Token does not exist");
1664 
1665         return bytes(_baseURI).length != 0 ? string(abi.encodePacked(_baseURI, tokenIndex.toString())) : "";
1666     }
1667 
1668     /**
1669      * @dev Transfers all founds to the owner's address
1670      * Can only be called by the owner of the contract.
1671     */
1672     function withdraw() onlyOwner external {
1673         uint balance = address(this).balance;
1674         if (balance > 0) {
1675             payable(_msgSender()).transfer(balance);
1676         }
1677     }
1678 
1679     /**
1680      * @dev Approves another address to transfer the given token ID
1681      * Can only be called by the token owner or an approved operator.
1682      * @param to address to be approved for the given token ID
1683      * @param tokenIndex uint256 ID of the token to be approved
1684     */
1685     function approve(address to, uint tokenIndex) external virtual override {
1686         address tokenOowner = ownerOf(tokenIndex);
1687 
1688         require(to != tokenOowner, "ERC721: approval to current owner");
1689         require(_msgSender() == tokenOowner || isApprovedForAll(tokenOowner, _msgSender()),
1690             "ERC721: approve caller is not owner nor approved for all"
1691         );
1692 
1693         _approve(to, tokenIndex);
1694     }
1695 
1696     /**
1697      * @dev Gets the approved address for a token ID, or zero if no address set
1698      * Reverts if the token ID does not exist.
1699      * @param tokenIndex uint256 ID of the token to query the approval of
1700      * @return address currently approved for the given token ID
1701     */
1702     function getApproved(uint tokenIndex) public view override returns (address) {
1703         require(_exists(tokenIndex), "ERC721: approved query for nonexistent token");
1704 
1705         return _tokenApprovals[tokenIndex];
1706     }
1707 
1708     /**
1709      * @dev Sets or unsets the approval of a given operator
1710      * An operator is allowed to transfer all tokens of the sender on their behalf.
1711      * @param operator operator address to set the approval
1712      * @param approved representing the status of the approval to be set
1713     */
1714     function setApprovalForAll(address operator, bool approved) public virtual override {
1715         require(operator != _msgSender(), "ERC721: approve to caller");
1716 
1717         _operatorApprovals[_msgSender()][operator] = approved;
1718         emit ApprovalForAll(_msgSender(), operator, approved);
1719     }
1720 
1721     /**
1722      * @dev Tells whether an operator is approved by a given owner.
1723      * @param tokenOowner owner address which you want to query the approval of
1724      * @param operator operator address which you want to query the approval of
1725      * @return bool whether the given operator is approved by the given owner
1726     */
1727     function isApprovedForAll(address tokenOowner, address operator) public view override returns (bool) {
1728         return _operatorApprovals[tokenOowner][operator];
1729     }
1730 
1731     /**
1732      * @dev Transfers the ownership of a given token ID to another address.
1733      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.
1734      * Requires the msg.sender to be the owner, approved, or operator.
1735      * @param from current owner of the token
1736      * @param to address to receive the ownership of the given token ID
1737      * @param tokenIndex uint256 ID of the token to be transferred
1738     */
1739     function transferFrom(address from, address to, uint tokenIndex) public virtual override {
1740         require(_isApprovedOrOwner(_msgSender(), tokenIndex), "ERC721: transfer caller is not owner nor approved");
1741 
1742         _transfer(from, to, tokenIndex);
1743     }
1744 
1745     /**
1746      * @dev Safely transfers the ownership of a given token ID to another address
1747      * If the target address is a contract, it must implement `onERC721Received`,
1748      * which is called upon a safe transfer, and return the magic value
1749      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1750      * the transfer is reverted.
1751      * Requires the msg.sender to be the owner, approved, or operator
1752      * @param from current owner of the token
1753      * @param to address to receive the ownership of the given token ID
1754      * @param tokenIndex uint256 ID of the token to be transferred
1755     */
1756     function safeTransferFrom(address from, address to, uint tokenIndex) public virtual override {
1757         safeTransferFrom(from, to, tokenIndex, "");
1758     }
1759 
1760     /**
1761      * @dev Safely transfers the ownership of a given token ID to another address
1762      * If the target address is a contract, it must implement `onERC721Received`,
1763      * which is called upon a safe transfer, and return the magic value
1764      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1765      * the transfer is reverted.
1766      * Requires the msg.sender to be the owner, approved, or operator
1767      * @param from current owner of the token
1768      * @param to address to receive the ownership of the given token ID
1769      * @param tokenIndex uint256 ID of the token to be transferred
1770      * @param _data bytes data to send along with a safe transfer check
1771     */
1772     function safeTransferFrom(address from, address to, uint tokenIndex, bytes memory _data) public virtual override {
1773         require(_isApprovedOrOwner(_msgSender(), tokenIndex), "ERC721: transfer caller is not owner nor approved");
1774         _safeTransfer(from, to, tokenIndex, _data);
1775     }
1776 
1777     /**
1778      * @dev Internal function for safe transfer
1779      * @param from current owner of the token
1780      * @param to address to receive the ownership of the given token ID
1781      * @param tokenIndex uint256 ID of the token to be transferred
1782      * @param _data bytes data to send along with a safe transfer check
1783     */
1784     function _safeTransfer(address from, address to, uint tokenIndex, bytes memory _data) internal virtual {
1785         _transfer(from, to, tokenIndex);
1786         require(_checkOnERC721Received(from, to, tokenIndex, _data), "ERC721: transfer to non ERC721Receiver implementer");
1787     }
1788 
1789     /**
1790      * @dev Returns whether the specified token exists.
1791      * @param tokenIndex uint256 ID of the token to query the existence of
1792      * @return bool whether the token exists
1793     */
1794     function _exists(uint tokenIndex) internal view returns (bool) {
1795         return _tokenOwners.contains(tokenIndex);
1796     }
1797 
1798     /**
1799      * @dev Returns whether the given spender can transfer a given token ID.
1800      * @param spender address of the spender to query
1801      * @param tokenIndex uint256 ID of the token to be transferred
1802      * @return bool whether the msg.sender is approved for the given token ID,
1803      * is an operator of the owner, or is the owner of the token
1804     */
1805     function _isApprovedOrOwner(address spender, uint tokenIndex) internal view returns (bool) {
1806         require(_exists(tokenIndex), "ERC721: operator query for nonexistent token");
1807         address tokenOowner = ownerOf(tokenIndex);
1808         return (spender == tokenOowner || getApproved(tokenIndex) == spender || isApprovedForAll(tokenOowner, spender));
1809     }
1810 
1811     /**
1812      * @dev Internal function to safely mint a new token.
1813      * Reverts if the given token ID already exists.
1814      * @param to The address that will own the minted token
1815      * @param tokenIndex uint256 ID of the token to be minted
1816      */
1817     function _safeMint(address to, uint tokenIndex) internal virtual {
1818         _safeMint(to, tokenIndex, "");
1819     }
1820 
1821     /**
1822      * @dev Internal function to safely mint a new token.
1823      * Reverts if the given token ID already exists.
1824      * @param to The address that will own the minted token
1825      * @param tokenIndex uint256 ID of the token to be minted
1826      * @param _data bytes data to send along with a safe transfer check
1827      */
1828     function _safeMint(address to, uint tokenIndex, bytes memory _data) internal virtual {
1829         _mint(to, tokenIndex);
1830         require(_checkOnERC721Received(address(0), to, tokenIndex, _data), "ERC721: transfer to non ERC721Receiver implementer");
1831     }
1832 
1833     /**
1834      * @dev Internal function to mint a new token.
1835      * Reverts if the given token ID already exists.
1836      * @param to The address that will own the minted token
1837      * @param tokenIndex uint256 ID of the token to be minted
1838     */
1839     function _mint(address to, uint tokenIndex) internal virtual {
1840         require(to != address(0), "ERC721: mint to the zero address");
1841         require(!_exists(tokenIndex), "ERC721: token already minted");
1842 
1843         _beforeTokenTransfer(address(0), to, tokenIndex);
1844         _holderTokens[to].add(tokenIndex);
1845         _tokenOwners.set(tokenIndex, to);
1846 
1847         emit Transfer(address(0), to, tokenIndex);
1848     }
1849 
1850     /**
1851      * @dev Internal function for transfer
1852      * @param from current owner of the token
1853      * @param to address to receive the ownership of the given token ID
1854      * @param tokenIndex uint256 ID of the token to be transferred
1855     */
1856     function _transfer(address from, address to, uint tokenIndex) internal virtual {
1857         require(ownerOf(tokenIndex) == from, "ERC721: transfer of token that is not own");
1858         require(to != address(0), "ERC721: transfer to the zero address");
1859 
1860         _beforeTokenTransfer(from, to, tokenIndex);
1861         _approve(address(0), tokenIndex);
1862         _holderTokens[from].remove(tokenIndex);
1863         _holderTokens[to].add(tokenIndex);
1864         _tokenOwners.set(tokenIndex, to);
1865 
1866         emit Transfer(from, to, tokenIndex);
1867     }
1868 
1869     /**
1870      * @dev Internal function to invoke `onERC721Received` on a target address.
1871      * The call is not executed if the target address is not a contract.
1872      *
1873      * This function is deprecated.
1874      * @param from address representing the previous owner of the given token ID
1875      * @param to target address that will receive the tokens
1876      * @param tokenIndex uint256 ID of the token to be transferred
1877      * @param _data bytes optional data to send along with the call
1878      * @return bool whether the call correctly returned the expected magic value
1879     */
1880     function _checkOnERC721Received(address from, address to, uint tokenIndex, bytes memory _data) private returns (bool) {
1881         if (!to.isContract()) return true;
1882         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1883                 IERC721Receiver(to).onERC721Received.selector,
1884                 _msgSender(),
1885                 from,
1886                 tokenIndex,
1887                 _data
1888             ), "ERC721: transfer to non ERC721Receiver implementer");
1889         bytes4 retval = abi.decode(returndata, (bytes4));
1890 
1891         return (retval == _ERC721_RECEIVED);
1892     }
1893 
1894     /**
1895      * @dev Internal function for approve another address to transfer the given token ID
1896      * @param to address to be approved for the given token ID
1897      * @param tokenIndex uint256 ID of the token to be approved
1898     */
1899     function _approve(address to, uint tokenIndex) private {
1900         _tokenApprovals[tokenIndex] = to;
1901         emit Approval(ownerOf(tokenIndex), to, tokenIndex);
1902     }
1903 
1904     /**
1905      * @dev Hook that is called before any transfer of tokens. This includes
1906      * minting and burning.
1907      *
1908      * Calling conditions:
1909      *
1910      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1911      * will be transferred to `to`.
1912      * - when `from` is zero, `amount` tokens will be minted for `to`.
1913      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1914      * - `from` and `to` are never both zero.
1915      *
1916      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1917     */
1918     function _beforeTokenTransfer(address from, address to, uint tokenIndex) internal virtual {}
1919 }