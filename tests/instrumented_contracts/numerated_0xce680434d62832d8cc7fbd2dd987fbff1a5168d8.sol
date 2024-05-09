1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/Address.sol
48 
49 
50 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
51 
52 pragma solidity ^0.8.1;
53 
54 /**
55  * @dev Collection of functions related to the address type
56  */
57 library Address {
58     /**
59      * @dev Returns true if `account` is a contract.
60      *
61      * [IMPORTANT]
62      * ====
63      * It is unsafe to assume that an address for which this function returns
64      * false is an externally-owned account (EOA) and not a contract.
65      *
66      * Among others, `isContract` will return false for the following
67      * types of addresses:
68      *
69      *  - an externally-owned account
70      *  - a contract in construction
71      *  - an address where a contract will be created
72      *  - an address where a contract lived, but was destroyed
73      * ====
74      *
75      * [IMPORTANT]
76      * ====
77      * You shouldn't rely on `isContract` to protect against flash loan attacks!
78      *
79      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
80      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
81      * constructor.
82      * ====
83      */
84     function isContract(address account) internal view returns (bool) {
85         // This method relies on extcodesize/address.code.length, which returns 0
86         // for contracts in construction, since the code is only stored at the end
87         // of the constructor execution.
88 
89         return account.code.length > 0;
90     }
91 
92     /**
93      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
94      * `recipient`, forwarding all available gas and reverting on errors.
95      *
96      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
97      * of certain opcodes, possibly making contracts go over the 2300 gas limit
98      * imposed by `transfer`, making them unable to receive funds via
99      * `transfer`. {sendValue} removes this limitation.
100      *
101      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
102      *
103      * IMPORTANT: because control is transferred to `recipient`, care must be
104      * taken to not create reentrancy vulnerabilities. Consider using
105      * {ReentrancyGuard} or the
106      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
107      */
108     function sendValue(address payable recipient, uint256 amount) internal {
109         require(address(this).balance >= amount, "Address: insufficient balance");
110 
111         (bool success, ) = recipient.call{value: amount}("");
112         require(success, "Address: unable to send value, recipient may have reverted");
113     }
114 
115     /**
116      * @dev Performs a Solidity function call using a low level `call`. A
117      * plain `call` is an unsafe replacement for a function call: use this
118      * function instead.
119      *
120      * If `target` reverts with a revert reason, it is bubbled up by this
121      * function (like regular Solidity function calls).
122      *
123      * Returns the raw returned data. To convert to the expected return value,
124      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
125      *
126      * Requirements:
127      *
128      * - `target` must be a contract.
129      * - calling `target` with `data` must not revert.
130      *
131      * _Available since v3.1._
132      */
133     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
134         return functionCall(target, data, "Address: low-level call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
139      * `errorMessage` as a fallback revert reason when `target` reverts.
140      *
141      * _Available since v3.1._
142      */
143     function functionCall(
144         address target,
145         bytes memory data,
146         string memory errorMessage
147     ) internal returns (bytes memory) {
148         return functionCallWithValue(target, data, 0, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but also transferring `value` wei to `target`.
154      *
155      * Requirements:
156      *
157      * - the calling contract must have an ETH balance of at least `value`.
158      * - the called Solidity function must be `payable`.
159      *
160      * _Available since v3.1._
161      */
162     function functionCallWithValue(
163         address target,
164         bytes memory data,
165         uint256 value
166     ) internal returns (bytes memory) {
167         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
172      * with `errorMessage` as a fallback revert reason when `target` reverts.
173      *
174      * _Available since v3.1._
175      */
176     function functionCallWithValue(
177         address target,
178         bytes memory data,
179         uint256 value,
180         string memory errorMessage
181     ) internal returns (bytes memory) {
182         require(address(this).balance >= value, "Address: insufficient balance for call");
183         require(isContract(target), "Address: call to non-contract");
184 
185         (bool success, bytes memory returndata) = target.call{value: value}(data);
186         return verifyCallResult(success, returndata, errorMessage);
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
191      * but performing a static call.
192      *
193      * _Available since v3.3._
194      */
195     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
196         return functionStaticCall(target, data, "Address: low-level static call failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
201      * but performing a static call.
202      *
203      * _Available since v3.3._
204      */
205     function functionStaticCall(
206         address target,
207         bytes memory data,
208         string memory errorMessage
209     ) internal view returns (bytes memory) {
210         require(isContract(target), "Address: static call to non-contract");
211 
212         (bool success, bytes memory returndata) = target.staticcall(data);
213         return verifyCallResult(success, returndata, errorMessage);
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
218      * but performing a delegate call.
219      *
220      * _Available since v3.4._
221      */
222     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
223         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
228      * but performing a delegate call.
229      *
230      * _Available since v3.4._
231      */
232     function functionDelegateCall(
233         address target,
234         bytes memory data,
235         string memory errorMessage
236     ) internal returns (bytes memory) {
237         require(isContract(target), "Address: delegate call to non-contract");
238 
239         (bool success, bytes memory returndata) = target.delegatecall(data);
240         return verifyCallResult(success, returndata, errorMessage);
241     }
242 
243     /**
244      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
245      * revert reason using the provided one.
246      *
247      * _Available since v4.3._
248      */
249     function verifyCallResult(
250         bool success,
251         bytes memory returndata,
252         string memory errorMessage
253     ) internal pure returns (bytes memory) {
254         if (success) {
255             return returndata;
256         } else {
257             // Look for revert reason and bubble it up if present
258             if (returndata.length > 0) {
259                 // The easiest way to bubble the revert reason is using memory via assembly
260 
261                 assembly {
262                     let returndata_size := mload(returndata)
263                     revert(add(32, returndata), returndata_size)
264                 }
265             } else {
266                 revert(errorMessage);
267             }
268         }
269     }
270 }
271 
272 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
273 
274 
275 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @title ERC721 token receiver interface
281  * @dev Interface for any contract that wants to support safeTransfers
282  * from ERC721 asset contracts.
283  */
284 interface IERC721Receiver {
285     /**
286      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
287      * by `operator` from `from`, this function is called.
288      *
289      * It must return its Solidity selector to confirm the token transfer.
290      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
291      *
292      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
293      */
294     function onERC721Received(
295         address operator,
296         address from,
297         uint256 tokenId,
298         bytes calldata data
299     ) external returns (bytes4);
300 }
301 
302 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
303 
304 
305 // OpenZeppelin Contracts (last updated v4.6.0) (utils/structs/EnumerableSet.sol)
306 
307 pragma solidity ^0.8.0;
308 
309 /**
310  * @dev Library for managing
311  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
312  * types.
313  *
314  * Sets have the following properties:
315  *
316  * - Elements are added, removed, and checked for existence in constant time
317  * (O(1)).
318  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
319  *
320  * ```
321  * contract Example {
322  *     // Add the library methods
323  *     using EnumerableSet for EnumerableSet.AddressSet;
324  *
325  *     // Declare a set state variable
326  *     EnumerableSet.AddressSet private mySet;
327  * }
328  * ```
329  *
330  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
331  * and `uint256` (`UintSet`) are supported.
332  */
333 library EnumerableSet {
334     // To implement this library for multiple types with as little code
335     // repetition as possible, we write it in terms of a generic Set type with
336     // bytes32 values.
337     // The Set implementation uses private functions, and user-facing
338     // implementations (such as AddressSet) are just wrappers around the
339     // underlying Set.
340     // This means that we can only create new EnumerableSets for types that fit
341     // in bytes32.
342 
343     struct Set {
344         // Storage of set values
345         bytes32[] _values;
346         // Position of the value in the `values` array, plus 1 because index 0
347         // means a value is not in the set.
348         mapping(bytes32 => uint256) _indexes;
349     }
350 
351     /**
352      * @dev Add a value to a set. O(1).
353      *
354      * Returns true if the value was added to the set, that is if it was not
355      * already present.
356      */
357     function _add(Set storage set, bytes32 value) private returns (bool) {
358         if (!_contains(set, value)) {
359             set._values.push(value);
360             // The value is stored at length-1, but we add 1 to all indexes
361             // and use 0 as a sentinel value
362             set._indexes[value] = set._values.length;
363             return true;
364         } else {
365             return false;
366         }
367     }
368 
369     /**
370      * @dev Removes a value from a set. O(1).
371      *
372      * Returns true if the value was removed from the set, that is if it was
373      * present.
374      */
375     function _remove(Set storage set, bytes32 value) private returns (bool) {
376         // We read and store the value's index to prevent multiple reads from the same storage slot
377         uint256 valueIndex = set._indexes[value];
378 
379         if (valueIndex != 0) {
380             // Equivalent to contains(set, value)
381             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
382             // the array, and then remove the last element (sometimes called as 'swap and pop').
383             // This modifies the order of the array, as noted in {at}.
384 
385             uint256 toDeleteIndex = valueIndex - 1;
386             uint256 lastIndex = set._values.length - 1;
387 
388             if (lastIndex != toDeleteIndex) {
389                 bytes32 lastValue = set._values[lastIndex];
390 
391                 // Move the last value to the index where the value to delete is
392                 set._values[toDeleteIndex] = lastValue;
393                 // Update the index for the moved value
394                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
395             }
396 
397             // Delete the slot where the moved value was stored
398             set._values.pop();
399 
400             // Delete the index for the deleted slot
401             delete set._indexes[value];
402 
403             return true;
404         } else {
405             return false;
406         }
407     }
408 
409     /**
410      * @dev Returns true if the value is in the set. O(1).
411      */
412     function _contains(Set storage set, bytes32 value) private view returns (bool) {
413         return set._indexes[value] != 0;
414     }
415 
416     /**
417      * @dev Returns the number of values on the set. O(1).
418      */
419     function _length(Set storage set) private view returns (uint256) {
420         return set._values.length;
421     }
422 
423     /**
424      * @dev Returns the value stored at position `index` in the set. O(1).
425      *
426      * Note that there are no guarantees on the ordering of values inside the
427      * array, and it may change when more values are added or removed.
428      *
429      * Requirements:
430      *
431      * - `index` must be strictly less than {length}.
432      */
433     function _at(Set storage set, uint256 index) private view returns (bytes32) {
434         return set._values[index];
435     }
436 
437     /**
438      * @dev Return the entire set in an array
439      *
440      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
441      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
442      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
443      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
444      */
445     function _values(Set storage set) private view returns (bytes32[] memory) {
446         return set._values;
447     }
448 
449     // Bytes32Set
450 
451     struct Bytes32Set {
452         Set _inner;
453     }
454 
455     /**
456      * @dev Add a value to a set. O(1).
457      *
458      * Returns true if the value was added to the set, that is if it was not
459      * already present.
460      */
461     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
462         return _add(set._inner, value);
463     }
464 
465     /**
466      * @dev Removes a value from a set. O(1).
467      *
468      * Returns true if the value was removed from the set, that is if it was
469      * present.
470      */
471     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
472         return _remove(set._inner, value);
473     }
474 
475     /**
476      * @dev Returns true if the value is in the set. O(1).
477      */
478     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
479         return _contains(set._inner, value);
480     }
481 
482     /**
483      * @dev Returns the number of values in the set. O(1).
484      */
485     function length(Bytes32Set storage set) internal view returns (uint256) {
486         return _length(set._inner);
487     }
488 
489     /**
490      * @dev Returns the value stored at position `index` in the set. O(1).
491      *
492      * Note that there are no guarantees on the ordering of values inside the
493      * array, and it may change when more values are added or removed.
494      *
495      * Requirements:
496      *
497      * - `index` must be strictly less than {length}.
498      */
499     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
500         return _at(set._inner, index);
501     }
502 
503     /**
504      * @dev Return the entire set in an array
505      *
506      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
507      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
508      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
509      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
510      */
511     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
512         return _values(set._inner);
513     }
514 
515     // AddressSet
516 
517     struct AddressSet {
518         Set _inner;
519     }
520 
521     /**
522      * @dev Add a value to a set. O(1).
523      *
524      * Returns true if the value was added to the set, that is if it was not
525      * already present.
526      */
527     function add(AddressSet storage set, address value) internal returns (bool) {
528         return _add(set._inner, bytes32(uint256(uint160(value))));
529     }
530 
531     /**
532      * @dev Removes a value from a set. O(1).
533      *
534      * Returns true if the value was removed from the set, that is if it was
535      * present.
536      */
537     function remove(AddressSet storage set, address value) internal returns (bool) {
538         return _remove(set._inner, bytes32(uint256(uint160(value))));
539     }
540 
541     /**
542      * @dev Returns true if the value is in the set. O(1).
543      */
544     function contains(AddressSet storage set, address value) internal view returns (bool) {
545         return _contains(set._inner, bytes32(uint256(uint160(value))));
546     }
547 
548     /**
549      * @dev Returns the number of values in the set. O(1).
550      */
551     function length(AddressSet storage set) internal view returns (uint256) {
552         return _length(set._inner);
553     }
554 
555     /**
556      * @dev Returns the value stored at position `index` in the set. O(1).
557      *
558      * Note that there are no guarantees on the ordering of values inside the
559      * array, and it may change when more values are added or removed.
560      *
561      * Requirements:
562      *
563      * - `index` must be strictly less than {length}.
564      */
565     function at(AddressSet storage set, uint256 index) internal view returns (address) {
566         return address(uint160(uint256(_at(set._inner, index))));
567     }
568 
569     /**
570      * @dev Return the entire set in an array
571      *
572      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
573      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
574      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
575      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
576      */
577     function values(AddressSet storage set) internal view returns (address[] memory) {
578         bytes32[] memory store = _values(set._inner);
579         address[] memory result;
580 
581         assembly {
582             result := store
583         }
584 
585         return result;
586     }
587 
588     // UintSet
589 
590     struct UintSet {
591         Set _inner;
592     }
593 
594     /**
595      * @dev Add a value to a set. O(1).
596      *
597      * Returns true if the value was added to the set, that is if it was not
598      * already present.
599      */
600     function add(UintSet storage set, uint256 value) internal returns (bool) {
601         return _add(set._inner, bytes32(value));
602     }
603 
604     /**
605      * @dev Removes a value from a set. O(1).
606      *
607      * Returns true if the value was removed from the set, that is if it was
608      * present.
609      */
610     function remove(UintSet storage set, uint256 value) internal returns (bool) {
611         return _remove(set._inner, bytes32(value));
612     }
613 
614     /**
615      * @dev Returns true if the value is in the set. O(1).
616      */
617     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
618         return _contains(set._inner, bytes32(value));
619     }
620 
621     /**
622      * @dev Returns the number of values on the set. O(1).
623      */
624     function length(UintSet storage set) internal view returns (uint256) {
625         return _length(set._inner);
626     }
627 
628     /**
629      * @dev Returns the value stored at position `index` in the set. O(1).
630      *
631      * Note that there are no guarantees on the ordering of values inside the
632      * array, and it may change when more values are added or removed.
633      *
634      * Requirements:
635      *
636      * - `index` must be strictly less than {length}.
637      */
638     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
639         return uint256(_at(set._inner, index));
640     }
641 
642     /**
643      * @dev Return the entire set in an array
644      *
645      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
646      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
647      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
648      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
649      */
650     function values(UintSet storage set) internal view returns (uint256[] memory) {
651         bytes32[] memory store = _values(set._inner);
652         uint256[] memory result;
653 
654         assembly {
655             result := store
656         }
657 
658         return result;
659     }
660 }
661 
662 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
663 
664 
665 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 /**
670  * @dev Interface of the ERC165 standard, as defined in the
671  * https://eips.ethereum.org/EIPS/eip-165[EIP].
672  *
673  * Implementers can declare support of contract interfaces, which can then be
674  * queried by others ({ERC165Checker}).
675  *
676  * For an implementation, see {ERC165}.
677  */
678 interface IERC165 {
679     /**
680      * @dev Returns true if this contract implements the interface defined by
681      * `interfaceId`. See the corresponding
682      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
683      * to learn more about how these ids are created.
684      *
685      * This function call must use less than 30 000 gas.
686      */
687     function supportsInterface(bytes4 interfaceId) external view returns (bool);
688 }
689 
690 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
691 
692 
693 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
694 
695 pragma solidity ^0.8.0;
696 
697 
698 /**
699  * @dev Interface for the NFT Royalty Standard.
700  *
701  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
702  * support for royalty payments across all NFT marketplaces and ecosystem participants.
703  *
704  * _Available since v4.5._
705  */
706 interface IERC2981 is IERC165 {
707     /**
708      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
709      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
710      */
711     function royaltyInfo(uint256 tokenId, uint256 salePrice)
712         external
713         view
714         returns (address receiver, uint256 royaltyAmount);
715 }
716 
717 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
718 
719 
720 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
721 
722 pragma solidity ^0.8.0;
723 
724 
725 /**
726  * @dev Required interface of an ERC721 compliant contract.
727  */
728 interface IERC721 is IERC165 {
729     /**
730      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
731      */
732     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
733 
734     /**
735      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
736      */
737     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
738 
739     /**
740      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
741      */
742     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
743 
744     /**
745      * @dev Returns the number of tokens in ``owner``'s account.
746      */
747     function balanceOf(address owner) external view returns (uint256 balance);
748 
749     /**
750      * @dev Returns the owner of the `tokenId` token.
751      *
752      * Requirements:
753      *
754      * - `tokenId` must exist.
755      */
756     function ownerOf(uint256 tokenId) external view returns (address owner);
757 
758     /**
759      * @dev Safely transfers `tokenId` token from `from` to `to`.
760      *
761      * Requirements:
762      *
763      * - `from` cannot be the zero address.
764      * - `to` cannot be the zero address.
765      * - `tokenId` token must exist and be owned by `from`.
766      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
767      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
768      *
769      * Emits a {Transfer} event.
770      */
771     function safeTransferFrom(
772         address from,
773         address to,
774         uint256 tokenId,
775         bytes calldata data
776     ) external;
777 
778     /**
779      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
780      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
781      *
782      * Requirements:
783      *
784      * - `from` cannot be the zero address.
785      * - `to` cannot be the zero address.
786      * - `tokenId` token must exist and be owned by `from`.
787      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
788      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
789      *
790      * Emits a {Transfer} event.
791      */
792     function safeTransferFrom(
793         address from,
794         address to,
795         uint256 tokenId
796     ) external;
797 
798     /**
799      * @dev Transfers `tokenId` token from `from` to `to`.
800      *
801      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
802      *
803      * Requirements:
804      *
805      * - `from` cannot be the zero address.
806      * - `to` cannot be the zero address.
807      * - `tokenId` token must be owned by `from`.
808      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
809      *
810      * Emits a {Transfer} event.
811      */
812     function transferFrom(
813         address from,
814         address to,
815         uint256 tokenId
816     ) external;
817 
818     /**
819      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
820      * The approval is cleared when the token is transferred.
821      *
822      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
823      *
824      * Requirements:
825      *
826      * - The caller must own the token or be an approved operator.
827      * - `tokenId` must exist.
828      *
829      * Emits an {Approval} event.
830      */
831     function approve(address to, uint256 tokenId) external;
832 
833     /**
834      * @dev Approve or remove `operator` as an operator for the caller.
835      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
836      *
837      * Requirements:
838      *
839      * - The `operator` cannot be the caller.
840      *
841      * Emits an {ApprovalForAll} event.
842      */
843     function setApprovalForAll(address operator, bool _approved) external;
844 
845     /**
846      * @dev Returns the account approved for `tokenId` token.
847      *
848      * Requirements:
849      *
850      * - `tokenId` must exist.
851      */
852     function getApproved(uint256 tokenId) external view returns (address operator);
853 
854     /**
855      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
856      *
857      * See {setApprovalForAll}
858      */
859     function isApprovedForAll(address owner, address operator) external view returns (bool);
860 }
861 
862 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
863 
864 
865 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
866 
867 pragma solidity ^0.8.0;
868 
869 
870 /**
871  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
872  * @dev See https://eips.ethereum.org/EIPS/eip-721
873  */
874 interface IERC721Enumerable is IERC721 {
875     /**
876      * @dev Returns the total amount of tokens stored by the contract.
877      */
878     function totalSupply() external view returns (uint256);
879 
880     /**
881      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
882      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
883      */
884     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
885 
886     /**
887      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
888      * Use along with {totalSupply} to enumerate all tokens.
889      */
890     function tokenByIndex(uint256 index) external view returns (uint256);
891 }
892 
893 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
894 
895 
896 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
897 
898 pragma solidity ^0.8.0;
899 
900 
901 /**
902  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
903  * @dev See https://eips.ethereum.org/EIPS/eip-721
904  */
905 interface IERC721Metadata is IERC721 {
906     /**
907      * @dev Returns the token collection name.
908      */
909     function name() external view returns (string memory);
910 
911     /**
912      * @dev Returns the token collection symbol.
913      */
914     function symbol() external view returns (string memory);
915 
916     /**
917      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
918      */
919     function tokenURI(uint256 tokenId) external view returns (string memory);
920 }
921 
922 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
923 
924 
925 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
926 
927 pragma solidity ^0.8.0;
928 
929 
930 /**
931  * @dev Implementation of the {IERC165} interface.
932  *
933  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
934  * for the additional interface id that will be supported. For example:
935  *
936  * ```solidity
937  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
938  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
939  * }
940  * ```
941  *
942  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
943  */
944 abstract contract ERC165 is IERC165 {
945     /**
946      * @dev See {IERC165-supportsInterface}.
947      */
948     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
949         return interfaceId == type(IERC165).interfaceId;
950     }
951 }
952 
953 // File: @openzeppelin/contracts/token/common/ERC2981.sol
954 
955 
956 // OpenZeppelin Contracts (last updated v4.6.0) (token/common/ERC2981.sol)
957 
958 pragma solidity ^0.8.0;
959 
960 
961 
962 /**
963  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
964  *
965  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
966  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
967  *
968  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
969  * fee is specified in basis points by default.
970  *
971  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
972  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
973  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
974  *
975  * _Available since v4.5._
976  */
977 abstract contract ERC2981 is IERC2981, ERC165 {
978     struct RoyaltyInfo {
979         address receiver;
980         uint96 royaltyFraction;
981     }
982 
983     RoyaltyInfo private _defaultRoyaltyInfo;
984     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
985 
986     /**
987      * @dev See {IERC165-supportsInterface}.
988      */
989     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
990         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
991     }
992 
993     /**
994      * @inheritdoc IERC2981
995      */
996     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
997         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
998 
999         if (royalty.receiver == address(0)) {
1000             royalty = _defaultRoyaltyInfo;
1001         }
1002 
1003         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1004 
1005         return (royalty.receiver, royaltyAmount);
1006     }
1007 
1008     /**
1009      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1010      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1011      * override.
1012      */
1013     function _feeDenominator() internal pure virtual returns (uint96) {
1014         return 10000;
1015     }
1016 
1017     /**
1018      * @dev Sets the royalty information that all ids in this contract will default to.
1019      *
1020      * Requirements:
1021      *
1022      * - `receiver` cannot be the zero address.
1023      * - `feeNumerator` cannot be greater than the fee denominator.
1024      */
1025     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1026         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1027         require(receiver != address(0), "ERC2981: invalid receiver");
1028 
1029         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1030     }
1031 
1032     /**
1033      * @dev Removes default royalty information.
1034      */
1035     function _deleteDefaultRoyalty() internal virtual {
1036         delete _defaultRoyaltyInfo;
1037     }
1038 
1039     /**
1040      * @dev Sets the royalty information for a specific token id, overriding the global default.
1041      *
1042      * Requirements:
1043      *
1044      * - `tokenId` must be already minted.
1045      * - `receiver` cannot be the zero address.
1046      * - `feeNumerator` cannot be greater than the fee denominator.
1047      */
1048     function _setTokenRoyalty(
1049         uint256 tokenId,
1050         address receiver,
1051         uint96 feeNumerator
1052     ) internal virtual {
1053         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1054         require(receiver != address(0), "ERC2981: Invalid parameters");
1055 
1056         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1057     }
1058 
1059     /**
1060      * @dev Resets royalty information for the token id back to the global default.
1061      */
1062     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1063         delete _tokenRoyaltyInfo[tokenId];
1064     }
1065 }
1066 
1067 // File: @openzeppelin/contracts/utils/Strings.sol
1068 
1069 
1070 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1071 
1072 pragma solidity ^0.8.0;
1073 
1074 /**
1075  * @dev String operations.
1076  */
1077 library Strings {
1078     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1079 
1080     /**
1081      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1082      */
1083     function toString(uint256 value) internal pure returns (string memory) {
1084         // Inspired by OraclizeAPI's implementation - MIT licence
1085         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1086 
1087         if (value == 0) {
1088             return "0";
1089         }
1090         uint256 temp = value;
1091         uint256 digits;
1092         while (temp != 0) {
1093             digits++;
1094             temp /= 10;
1095         }
1096         bytes memory buffer = new bytes(digits);
1097         while (value != 0) {
1098             digits -= 1;
1099             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1100             value /= 10;
1101         }
1102         return string(buffer);
1103     }
1104 
1105     /**
1106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1107      */
1108     function toHexString(uint256 value) internal pure returns (string memory) {
1109         if (value == 0) {
1110             return "0x00";
1111         }
1112         uint256 temp = value;
1113         uint256 length = 0;
1114         while (temp != 0) {
1115             length++;
1116             temp >>= 8;
1117         }
1118         return toHexString(value, length);
1119     }
1120 
1121     /**
1122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1123      */
1124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1125         bytes memory buffer = new bytes(2 * length + 2);
1126         buffer[0] = "0";
1127         buffer[1] = "x";
1128         for (uint256 i = 2 * length + 1; i > 1; --i) {
1129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1130             value >>= 4;
1131         }
1132         require(value == 0, "Strings: hex length insufficient");
1133         return string(buffer);
1134     }
1135 }
1136 
1137 // File: @openzeppelin/contracts/utils/Context.sol
1138 
1139 
1140 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1141 
1142 pragma solidity ^0.8.0;
1143 
1144 /**
1145  * @dev Provides information about the current execution context, including the
1146  * sender of the transaction and its data. While these are generally available
1147  * via msg.sender and msg.data, they should not be accessed in such a direct
1148  * manner, since when dealing with meta-transactions the account sending and
1149  * paying for execution may not be the actual sender (as far as an application
1150  * is concerned).
1151  *
1152  * This contract is only required for intermediate, library-like contracts.
1153  */
1154 abstract contract Context {
1155     function _msgSender() internal view virtual returns (address) {
1156         return msg.sender;
1157     }
1158 
1159     function _msgData() internal view virtual returns (bytes calldata) {
1160         return msg.data;
1161     }
1162 }
1163 
1164 // File: @openzeppelin/contracts/security/Pausable.sol
1165 
1166 
1167 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1168 
1169 pragma solidity ^0.8.0;
1170 
1171 
1172 /**
1173  * @dev Contract module which allows children to implement an emergency stop
1174  * mechanism that can be triggered by an authorized account.
1175  *
1176  * This module is used through inheritance. It will make available the
1177  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1178  * the functions of your contract. Note that they will not be pausable by
1179  * simply including this module, only once the modifiers are put in place.
1180  */
1181 abstract contract Pausable is Context {
1182     /**
1183      * @dev Emitted when the pause is triggered by `account`.
1184      */
1185     event Paused(address account);
1186 
1187     /**
1188      * @dev Emitted when the pause is lifted by `account`.
1189      */
1190     event Unpaused(address account);
1191 
1192     bool private _paused;
1193 
1194     /**
1195      * @dev Initializes the contract in unpaused state.
1196      */
1197     constructor() {
1198         _paused = false;
1199     }
1200 
1201     /**
1202      * @dev Returns true if the contract is paused, and false otherwise.
1203      */
1204     function paused() public view virtual returns (bool) {
1205         return _paused;
1206     }
1207 
1208     /**
1209      * @dev Modifier to make a function callable only when the contract is not paused.
1210      *
1211      * Requirements:
1212      *
1213      * - The contract must not be paused.
1214      */
1215     modifier whenNotPaused() {
1216         require(!paused(), "Pausable: paused");
1217         _;
1218     }
1219 
1220     /**
1221      * @dev Modifier to make a function callable only when the contract is paused.
1222      *
1223      * Requirements:
1224      *
1225      * - The contract must be paused.
1226      */
1227     modifier whenPaused() {
1228         require(paused(), "Pausable: not paused");
1229         _;
1230     }
1231 
1232     /**
1233      * @dev Triggers stopped state.
1234      *
1235      * Requirements:
1236      *
1237      * - The contract must not be paused.
1238      */
1239     function _pause() internal virtual whenNotPaused {
1240         _paused = true;
1241         emit Paused(_msgSender());
1242     }
1243 
1244     /**
1245      * @dev Returns to normal state.
1246      *
1247      * Requirements:
1248      *
1249      * - The contract must be paused.
1250      */
1251     function _unpause() internal virtual whenPaused {
1252         _paused = false;
1253         emit Unpaused(_msgSender());
1254     }
1255 }
1256 
1257 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1258 
1259 
1260 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1261 
1262 pragma solidity ^0.8.0;
1263 
1264 
1265 
1266 
1267 
1268 
1269 
1270 
1271 /**
1272  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1273  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1274  * {ERC721Enumerable}.
1275  */
1276 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1277     using Address for address;
1278     using Strings for uint256;
1279 
1280     // Token name
1281     string private _name;
1282 
1283     // Token symbol
1284     string private _symbol;
1285 
1286     // Mapping from token ID to owner address
1287     mapping(uint256 => address) private _owners;
1288 
1289     // Mapping owner address to token count
1290     mapping(address => uint256) private _balances;
1291 
1292     // Mapping from token ID to approved address
1293     mapping(uint256 => address) private _tokenApprovals;
1294 
1295     // Mapping from owner to operator approvals
1296     mapping(address => mapping(address => bool)) private _operatorApprovals;
1297 
1298     /**
1299      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1300      */
1301     constructor(string memory name_, string memory symbol_) {
1302         _name = name_;
1303         _symbol = symbol_;
1304     }
1305 
1306     /**
1307      * @dev See {IERC165-supportsInterface}.
1308      */
1309     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1310         return
1311             interfaceId == type(IERC721).interfaceId ||
1312             interfaceId == type(IERC721Metadata).interfaceId ||
1313             super.supportsInterface(interfaceId);
1314     }
1315 
1316     /**
1317      * @dev See {IERC721-balanceOf}.
1318      */
1319     function balanceOf(address owner) public view virtual override returns (uint256) {
1320         require(owner != address(0), "ERC721: balance query for the zero address");
1321         return _balances[owner];
1322     }
1323 
1324     /**
1325      * @dev See {IERC721-ownerOf}.
1326      */
1327     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1328         address owner = _owners[tokenId];
1329         require(owner != address(0), "ERC721: owner query for nonexistent token");
1330         return owner;
1331     }
1332 
1333     /**
1334      * @dev See {IERC721Metadata-name}.
1335      */
1336     function name() public view virtual override returns (string memory) {
1337         return _name;
1338     }
1339 
1340     /**
1341      * @dev See {IERC721Metadata-symbol}.
1342      */
1343     function symbol() public view virtual override returns (string memory) {
1344         return _symbol;
1345     }
1346 
1347     /**
1348      * @dev See {IERC721Metadata-tokenURI}.
1349      */
1350     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1351         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1352 
1353         string memory baseURI = _baseURI();
1354         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1355     }
1356 
1357     /**
1358      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1359      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1360      * by default, can be overridden in child contracts.
1361      */
1362     function _baseURI() internal view virtual returns (string memory) {
1363         return "";
1364     }
1365 
1366     /**
1367      * @dev See {IERC721-approve}.
1368      */
1369     function approve(address to, uint256 tokenId) public virtual override {
1370         address owner = ERC721.ownerOf(tokenId);
1371         require(to != owner, "ERC721: approval to current owner");
1372 
1373         require(
1374             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1375             "ERC721: approve caller is not owner nor approved for all"
1376         );
1377 
1378         _approve(to, tokenId);
1379     }
1380 
1381     /**
1382      * @dev See {IERC721-getApproved}.
1383      */
1384     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1385         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1386 
1387         return _tokenApprovals[tokenId];
1388     }
1389 
1390     /**
1391      * @dev See {IERC721-setApprovalForAll}.
1392      */
1393     function setApprovalForAll(address operator, bool approved) public virtual override {
1394         _setApprovalForAll(_msgSender(), operator, approved);
1395     }
1396 
1397     /**
1398      * @dev See {IERC721-isApprovedForAll}.
1399      */
1400     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1401         return _operatorApprovals[owner][operator];
1402     }
1403 
1404     /**
1405      * @dev See {IERC721-transferFrom}.
1406      */
1407     function transferFrom(
1408         address from,
1409         address to,
1410         uint256 tokenId
1411     ) public virtual override {
1412         //solhint-disable-next-line max-line-length
1413         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1414 
1415         _transfer(from, to, tokenId);
1416     }
1417 
1418     /**
1419      * @dev See {IERC721-safeTransferFrom}.
1420      */
1421     function safeTransferFrom(
1422         address from,
1423         address to,
1424         uint256 tokenId
1425     ) public virtual override {
1426         safeTransferFrom(from, to, tokenId, "");
1427     }
1428 
1429     /**
1430      * @dev See {IERC721-safeTransferFrom}.
1431      */
1432     function safeTransferFrom(
1433         address from,
1434         address to,
1435         uint256 tokenId,
1436         bytes memory _data
1437     ) public virtual override {
1438         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1439         _safeTransfer(from, to, tokenId, _data);
1440     }
1441 
1442     /**
1443      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1444      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1445      *
1446      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1447      *
1448      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1449      * implement alternative mechanisms to perform token transfer, such as signature-based.
1450      *
1451      * Requirements:
1452      *
1453      * - `from` cannot be the zero address.
1454      * - `to` cannot be the zero address.
1455      * - `tokenId` token must exist and be owned by `from`.
1456      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1457      *
1458      * Emits a {Transfer} event.
1459      */
1460     function _safeTransfer(
1461         address from,
1462         address to,
1463         uint256 tokenId,
1464         bytes memory _data
1465     ) internal virtual {
1466         _transfer(from, to, tokenId);
1467         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1468     }
1469 
1470     /**
1471      * @dev Returns whether `tokenId` exists.
1472      *
1473      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1474      *
1475      * Tokens start existing when they are minted (`_mint`),
1476      * and stop existing when they are burned (`_burn`).
1477      */
1478     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1479         return _owners[tokenId] != address(0);
1480     }
1481 
1482     /**
1483      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1484      *
1485      * Requirements:
1486      *
1487      * - `tokenId` must exist.
1488      */
1489     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1490         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1491         address owner = ERC721.ownerOf(tokenId);
1492         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1493     }
1494 
1495     /**
1496      * @dev Safely mints `tokenId` and transfers it to `to`.
1497      *
1498      * Requirements:
1499      *
1500      * - `tokenId` must not exist.
1501      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1502      *
1503      * Emits a {Transfer} event.
1504      */
1505     function _safeMint(address to, uint256 tokenId) internal virtual {
1506         _safeMint(to, tokenId, "");
1507     }
1508 
1509     /**
1510      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1511      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1512      */
1513     function _safeMint(
1514         address to,
1515         uint256 tokenId,
1516         bytes memory _data
1517     ) internal virtual {
1518         _mint(to, tokenId);
1519         require(
1520             _checkOnERC721Received(address(0), to, tokenId, _data),
1521             "ERC721: transfer to non ERC721Receiver implementer"
1522         );
1523     }
1524 
1525     /**
1526      * @dev Mints `tokenId` and transfers it to `to`.
1527      *
1528      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1529      *
1530      * Requirements:
1531      *
1532      * - `tokenId` must not exist.
1533      * - `to` cannot be the zero address.
1534      *
1535      * Emits a {Transfer} event.
1536      */
1537     function _mint(address to, uint256 tokenId) internal virtual {
1538         require(to != address(0), "ERC721: mint to the zero address");
1539         require(!_exists(tokenId), "ERC721: token already minted");
1540 
1541         _beforeTokenTransfer(address(0), to, tokenId);
1542 
1543         _balances[to] += 1;
1544         _owners[tokenId] = to;
1545 
1546         emit Transfer(address(0), to, tokenId);
1547 
1548         _afterTokenTransfer(address(0), to, tokenId);
1549     }
1550 
1551     /**
1552      * @dev Destroys `tokenId`.
1553      * The approval is cleared when the token is burned.
1554      *
1555      * Requirements:
1556      *
1557      * - `tokenId` must exist.
1558      *
1559      * Emits a {Transfer} event.
1560      */
1561     function _burn(uint256 tokenId) internal virtual {
1562         address owner = ERC721.ownerOf(tokenId);
1563 
1564         _beforeTokenTransfer(owner, address(0), tokenId);
1565 
1566         // Clear approvals
1567         _approve(address(0), tokenId);
1568 
1569         _balances[owner] -= 1;
1570         delete _owners[tokenId];
1571 
1572         emit Transfer(owner, address(0), tokenId);
1573 
1574         _afterTokenTransfer(owner, address(0), tokenId);
1575     }
1576 
1577     /**
1578      * @dev Transfers `tokenId` from `from` to `to`.
1579      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1580      *
1581      * Requirements:
1582      *
1583      * - `to` cannot be the zero address.
1584      * - `tokenId` token must be owned by `from`.
1585      *
1586      * Emits a {Transfer} event.
1587      */
1588     function _transfer(
1589         address from,
1590         address to,
1591         uint256 tokenId
1592     ) internal virtual {
1593         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1594         require(to != address(0), "ERC721: transfer to the zero address");
1595 
1596         _beforeTokenTransfer(from, to, tokenId);
1597 
1598         // Clear approvals from the previous owner
1599         _approve(address(0), tokenId);
1600 
1601         _balances[from] -= 1;
1602         _balances[to] += 1;
1603         _owners[tokenId] = to;
1604 
1605         emit Transfer(from, to, tokenId);
1606 
1607         _afterTokenTransfer(from, to, tokenId);
1608     }
1609 
1610     /**
1611      * @dev Approve `to` to operate on `tokenId`
1612      *
1613      * Emits a {Approval} event.
1614      */
1615     function _approve(address to, uint256 tokenId) internal virtual {
1616         _tokenApprovals[tokenId] = to;
1617         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1618     }
1619 
1620     /**
1621      * @dev Approve `operator` to operate on all of `owner` tokens
1622      *
1623      * Emits a {ApprovalForAll} event.
1624      */
1625     function _setApprovalForAll(
1626         address owner,
1627         address operator,
1628         bool approved
1629     ) internal virtual {
1630         require(owner != operator, "ERC721: approve to caller");
1631         _operatorApprovals[owner][operator] = approved;
1632         emit ApprovalForAll(owner, operator, approved);
1633     }
1634 
1635     /**
1636      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1637      * The call is not executed if the target address is not a contract.
1638      *
1639      * @param from address representing the previous owner of the given token ID
1640      * @param to target address that will receive the tokens
1641      * @param tokenId uint256 ID of the token to be transferred
1642      * @param _data bytes optional data to send along with the call
1643      * @return bool whether the call correctly returned the expected magic value
1644      */
1645     function _checkOnERC721Received(
1646         address from,
1647         address to,
1648         uint256 tokenId,
1649         bytes memory _data
1650     ) private returns (bool) {
1651         if (to.isContract()) {
1652             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1653                 return retval == IERC721Receiver.onERC721Received.selector;
1654             } catch (bytes memory reason) {
1655                 if (reason.length == 0) {
1656                     revert("ERC721: transfer to non ERC721Receiver implementer");
1657                 } else {
1658                     assembly {
1659                         revert(add(32, reason), mload(reason))
1660                     }
1661                 }
1662             }
1663         } else {
1664             return true;
1665         }
1666     }
1667 
1668     /**
1669      * @dev Hook that is called before any token transfer. This includes minting
1670      * and burning.
1671      *
1672      * Calling conditions:
1673      *
1674      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1675      * transferred to `to`.
1676      * - When `from` is zero, `tokenId` will be minted for `to`.
1677      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1678      * - `from` and `to` are never both zero.
1679      *
1680      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1681      */
1682     function _beforeTokenTransfer(
1683         address from,
1684         address to,
1685         uint256 tokenId
1686     ) internal virtual {}
1687 
1688     /**
1689      * @dev Hook that is called after any transfer of tokens. This includes
1690      * minting and burning.
1691      *
1692      * Calling conditions:
1693      *
1694      * - when `from` and `to` are both non-zero.
1695      * - `from` and `to` are never both zero.
1696      *
1697      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1698      */
1699     function _afterTokenTransfer(
1700         address from,
1701         address to,
1702         uint256 tokenId
1703     ) internal virtual {}
1704 }
1705 
1706 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
1707 
1708 
1709 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Pausable.sol)
1710 
1711 pragma solidity ^0.8.0;
1712 
1713 
1714 
1715 /**
1716  * @dev ERC721 token with pausable token transfers, minting and burning.
1717  *
1718  * Useful for scenarios such as preventing trades until the end of an evaluation
1719  * period, or having an emergency switch for freezing all token transfers in the
1720  * event of a large bug.
1721  */
1722 abstract contract ERC721Pausable is ERC721, Pausable {
1723     /**
1724      * @dev See {ERC721-_beforeTokenTransfer}.
1725      *
1726      * Requirements:
1727      *
1728      * - the contract must not be paused.
1729      */
1730     function _beforeTokenTransfer(
1731         address from,
1732         address to,
1733         uint256 tokenId
1734     ) internal virtual override {
1735         super._beforeTokenTransfer(from, to, tokenId);
1736 
1737         require(!paused(), "ERC721Pausable: token transfer while paused");
1738     }
1739 }
1740 
1741 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1742 
1743 
1744 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1745 
1746 pragma solidity ^0.8.0;
1747 
1748 
1749 /**
1750  * @dev ERC721 token with storage based token URI management.
1751  */
1752 abstract contract ERC721URIStorage is ERC721 {
1753     using Strings for uint256;
1754 
1755     // Optional mapping for token URIs
1756     mapping(uint256 => string) private _tokenURIs;
1757 
1758     /**
1759      * @dev See {IERC721Metadata-tokenURI}.
1760      */
1761     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1762         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1763 
1764         string memory _tokenURI = _tokenURIs[tokenId];
1765         string memory base = _baseURI();
1766 
1767         // If there is no base URI, return the token URI.
1768         if (bytes(base).length == 0) {
1769             return _tokenURI;
1770         }
1771         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1772         if (bytes(_tokenURI).length > 0) {
1773             return string(abi.encodePacked(base, _tokenURI));
1774         }
1775 
1776         return super.tokenURI(tokenId);
1777     }
1778 
1779     /**
1780      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1781      *
1782      * Requirements:
1783      *
1784      * - `tokenId` must exist.
1785      */
1786     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1787         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1788         _tokenURIs[tokenId] = _tokenURI;
1789     }
1790 
1791     /**
1792      * @dev Destroys `tokenId`.
1793      * The approval is cleared when the token is burned.
1794      *
1795      * Requirements:
1796      *
1797      * - `tokenId` must exist.
1798      *
1799      * Emits a {Transfer} event.
1800      */
1801     function _burn(uint256 tokenId) internal virtual override {
1802         super._burn(tokenId);
1803 
1804         if (bytes(_tokenURIs[tokenId]).length != 0) {
1805             delete _tokenURIs[tokenId];
1806         }
1807     }
1808 }
1809 
1810 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1811 
1812 
1813 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1814 
1815 pragma solidity ^0.8.0;
1816 
1817 
1818 
1819 /**
1820  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1821  * enumerability of all the token ids in the contract as well as all token ids owned by each
1822  * account.
1823  */
1824 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1825     // Mapping from owner to list of owned token IDs
1826     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1827 
1828     // Mapping from token ID to index of the owner tokens list
1829     mapping(uint256 => uint256) private _ownedTokensIndex;
1830 
1831     // Array with all token ids, used for enumeration
1832     uint256[] private _allTokens;
1833 
1834     // Mapping from token id to position in the allTokens array
1835     mapping(uint256 => uint256) private _allTokensIndex;
1836 
1837     /**
1838      * @dev See {IERC165-supportsInterface}.
1839      */
1840     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1841         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1842     }
1843 
1844     /**
1845      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1846      */
1847     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1848         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1849         return _ownedTokens[owner][index];
1850     }
1851 
1852     /**
1853      * @dev See {IERC721Enumerable-totalSupply}.
1854      */
1855     function totalSupply() public view virtual override returns (uint256) {
1856         return _allTokens.length;
1857     }
1858 
1859     /**
1860      * @dev See {IERC721Enumerable-tokenByIndex}.
1861      */
1862     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1863         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1864         return _allTokens[index];
1865     }
1866 
1867     /**
1868      * @dev Hook that is called before any token transfer. This includes minting
1869      * and burning.
1870      *
1871      * Calling conditions:
1872      *
1873      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1874      * transferred to `to`.
1875      * - When `from` is zero, `tokenId` will be minted for `to`.
1876      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1877      * - `from` cannot be the zero address.
1878      * - `to` cannot be the zero address.
1879      *
1880      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1881      */
1882     function _beforeTokenTransfer(
1883         address from,
1884         address to,
1885         uint256 tokenId
1886     ) internal virtual override {
1887         super._beforeTokenTransfer(from, to, tokenId);
1888 
1889         if (from == address(0)) {
1890             _addTokenToAllTokensEnumeration(tokenId);
1891         } else if (from != to) {
1892             _removeTokenFromOwnerEnumeration(from, tokenId);
1893         }
1894         if (to == address(0)) {
1895             _removeTokenFromAllTokensEnumeration(tokenId);
1896         } else if (to != from) {
1897             _addTokenToOwnerEnumeration(to, tokenId);
1898         }
1899     }
1900 
1901     /**
1902      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1903      * @param to address representing the new owner of the given token ID
1904      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1905      */
1906     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1907         uint256 length = ERC721.balanceOf(to);
1908         _ownedTokens[to][length] = tokenId;
1909         _ownedTokensIndex[tokenId] = length;
1910     }
1911 
1912     /**
1913      * @dev Private function to add a token to this extension's token tracking data structures.
1914      * @param tokenId uint256 ID of the token to be added to the tokens list
1915      */
1916     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1917         _allTokensIndex[tokenId] = _allTokens.length;
1918         _allTokens.push(tokenId);
1919     }
1920 
1921     /**
1922      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1923      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1924      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1925      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1926      * @param from address representing the previous owner of the given token ID
1927      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1928      */
1929     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1930         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1931         // then delete the last slot (swap and pop).
1932 
1933         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1934         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1935 
1936         // When the token to delete is the last token, the swap operation is unnecessary
1937         if (tokenIndex != lastTokenIndex) {
1938             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1939 
1940             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1941             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1942         }
1943 
1944         // This also deletes the contents at the last position of the array
1945         delete _ownedTokensIndex[tokenId];
1946         delete _ownedTokens[from][lastTokenIndex];
1947     }
1948 
1949     /**
1950      * @dev Private function to remove a token from this extension's token tracking data structures.
1951      * This has O(1) time complexity, but alters the order of the _allTokens array.
1952      * @param tokenId uint256 ID of the token to be removed from the tokens list
1953      */
1954     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1955         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1956         // then delete the last slot (swap and pop).
1957 
1958         uint256 lastTokenIndex = _allTokens.length - 1;
1959         uint256 tokenIndex = _allTokensIndex[tokenId];
1960 
1961         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1962         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1963         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1964         uint256 lastTokenId = _allTokens[lastTokenIndex];
1965 
1966         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1967         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1968 
1969         // This also deletes the contents at the last position of the array
1970         delete _allTokensIndex[tokenId];
1971         _allTokens.pop();
1972     }
1973 }
1974 
1975 // File: @openzeppelin/contracts/access/IAccessControl.sol
1976 
1977 
1978 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1979 
1980 pragma solidity ^0.8.0;
1981 
1982 /**
1983  * @dev External interface of AccessControl declared to support ERC165 detection.
1984  */
1985 interface IAccessControl {
1986     /**
1987      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1988      *
1989      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1990      * {RoleAdminChanged} not being emitted signaling this.
1991      *
1992      * _Available since v3.1._
1993      */
1994     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1995 
1996     /**
1997      * @dev Emitted when `account` is granted `role`.
1998      *
1999      * `sender` is the account that originated the contract call, an admin role
2000      * bearer except when using {AccessControl-_setupRole}.
2001      */
2002     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
2003 
2004     /**
2005      * @dev Emitted when `account` is revoked `role`.
2006      *
2007      * `sender` is the account that originated the contract call:
2008      *   - if using `revokeRole`, it is the admin role bearer
2009      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
2010      */
2011     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
2012 
2013     /**
2014      * @dev Returns `true` if `account` has been granted `role`.
2015      */
2016     function hasRole(bytes32 role, address account) external view returns (bool);
2017 
2018     /**
2019      * @dev Returns the admin role that controls `role`. See {grantRole} and
2020      * {revokeRole}.
2021      *
2022      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
2023      */
2024     function getRoleAdmin(bytes32 role) external view returns (bytes32);
2025 
2026     /**
2027      * @dev Grants `role` to `account`.
2028      *
2029      * If `account` had not been already granted `role`, emits a {RoleGranted}
2030      * event.
2031      *
2032      * Requirements:
2033      *
2034      * - the caller must have ``role``'s admin role.
2035      */
2036     function grantRole(bytes32 role, address account) external;
2037 
2038     /**
2039      * @dev Revokes `role` from `account`.
2040      *
2041      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2042      *
2043      * Requirements:
2044      *
2045      * - the caller must have ``role``'s admin role.
2046      */
2047     function revokeRole(bytes32 role, address account) external;
2048 
2049     /**
2050      * @dev Revokes `role` from the calling account.
2051      *
2052      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2053      * purpose is to provide a mechanism for accounts to lose their privileges
2054      * if they are compromised (such as when a trusted device is misplaced).
2055      *
2056      * If the calling account had been granted `role`, emits a {RoleRevoked}
2057      * event.
2058      *
2059      * Requirements:
2060      *
2061      * - the caller must be `account`.
2062      */
2063     function renounceRole(bytes32 role, address account) external;
2064 }
2065 
2066 // File: @openzeppelin/contracts/access/AccessControl.sol
2067 
2068 
2069 // OpenZeppelin Contracts (last updated v4.6.0) (access/AccessControl.sol)
2070 
2071 pragma solidity ^0.8.0;
2072 
2073 
2074 
2075 
2076 
2077 /**
2078  * @dev Contract module that allows children to implement role-based access
2079  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
2080  * members except through off-chain means by accessing the contract event logs. Some
2081  * applications may benefit from on-chain enumerability, for those cases see
2082  * {AccessControlEnumerable}.
2083  *
2084  * Roles are referred to by their `bytes32` identifier. These should be exposed
2085  * in the external API and be unique. The best way to achieve this is by
2086  * using `public constant` hash digests:
2087  *
2088  * ```
2089  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
2090  * ```
2091  *
2092  * Roles can be used to represent a set of permissions. To restrict access to a
2093  * function call, use {hasRole}:
2094  *
2095  * ```
2096  * function foo() public {
2097  *     require(hasRole(MY_ROLE, msg.sender));
2098  *     ...
2099  * }
2100  * ```
2101  *
2102  * Roles can be granted and revoked dynamically via the {grantRole} and
2103  * {revokeRole} functions. Each role has an associated admin role, and only
2104  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
2105  *
2106  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
2107  * that only accounts with this role will be able to grant or revoke other
2108  * roles. More complex role relationships can be created by using
2109  * {_setRoleAdmin}.
2110  *
2111  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
2112  * grant and revoke this role. Extra precautions should be taken to secure
2113  * accounts that have been granted it.
2114  */
2115 abstract contract AccessControl is Context, IAccessControl, ERC165 {
2116     struct RoleData {
2117         mapping(address => bool) members;
2118         bytes32 adminRole;
2119     }
2120 
2121     mapping(bytes32 => RoleData) private _roles;
2122 
2123     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
2124 
2125     /**
2126      * @dev Modifier that checks that an account has a specific role. Reverts
2127      * with a standardized message including the required role.
2128      *
2129      * The format of the revert reason is given by the following regular expression:
2130      *
2131      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2132      *
2133      * _Available since v4.1._
2134      */
2135     modifier onlyRole(bytes32 role) {
2136         _checkRole(role);
2137         _;
2138     }
2139 
2140     /**
2141      * @dev See {IERC165-supportsInterface}.
2142      */
2143     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2144         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
2145     }
2146 
2147     /**
2148      * @dev Returns `true` if `account` has been granted `role`.
2149      */
2150     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
2151         return _roles[role].members[account];
2152     }
2153 
2154     /**
2155      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
2156      * Overriding this function changes the behavior of the {onlyRole} modifier.
2157      *
2158      * Format of the revert message is described in {_checkRole}.
2159      *
2160      * _Available since v4.6._
2161      */
2162     function _checkRole(bytes32 role) internal view virtual {
2163         _checkRole(role, _msgSender());
2164     }
2165 
2166     /**
2167      * @dev Revert with a standard message if `account` is missing `role`.
2168      *
2169      * The format of the revert reason is given by the following regular expression:
2170      *
2171      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2172      */
2173     function _checkRole(bytes32 role, address account) internal view virtual {
2174         if (!hasRole(role, account)) {
2175             revert(
2176                 string(
2177                     abi.encodePacked(
2178                         "AccessControl: account ",
2179                         Strings.toHexString(uint160(account), 20),
2180                         " is missing role ",
2181                         Strings.toHexString(uint256(role), 32)
2182                     )
2183                 )
2184             );
2185         }
2186     }
2187 
2188     /**
2189      * @dev Returns the admin role that controls `role`. See {grantRole} and
2190      * {revokeRole}.
2191      *
2192      * To change a role's admin, use {_setRoleAdmin}.
2193      */
2194     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
2195         return _roles[role].adminRole;
2196     }
2197 
2198     /**
2199      * @dev Grants `role` to `account`.
2200      *
2201      * If `account` had not been already granted `role`, emits a {RoleGranted}
2202      * event.
2203      *
2204      * Requirements:
2205      *
2206      * - the caller must have ``role``'s admin role.
2207      */
2208     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2209         _grantRole(role, account);
2210     }
2211 
2212     /**
2213      * @dev Revokes `role` from `account`.
2214      *
2215      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2216      *
2217      * Requirements:
2218      *
2219      * - the caller must have ``role``'s admin role.
2220      */
2221     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2222         _revokeRole(role, account);
2223     }
2224 
2225     /**
2226      * @dev Revokes `role` from the calling account.
2227      *
2228      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2229      * purpose is to provide a mechanism for accounts to lose their privileges
2230      * if they are compromised (such as when a trusted device is misplaced).
2231      *
2232      * If the calling account had been revoked `role`, emits a {RoleRevoked}
2233      * event.
2234      *
2235      * Requirements:
2236      *
2237      * - the caller must be `account`.
2238      */
2239     function renounceRole(bytes32 role, address account) public virtual override {
2240         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2241 
2242         _revokeRole(role, account);
2243     }
2244 
2245     /**
2246      * @dev Grants `role` to `account`.
2247      *
2248      * If `account` had not been already granted `role`, emits a {RoleGranted}
2249      * event. Note that unlike {grantRole}, this function doesn't perform any
2250      * checks on the calling account.
2251      *
2252      * [WARNING]
2253      * ====
2254      * This function should only be called from the constructor when setting
2255      * up the initial roles for the system.
2256      *
2257      * Using this function in any other way is effectively circumventing the admin
2258      * system imposed by {AccessControl}.
2259      * ====
2260      *
2261      * NOTE: This function is deprecated in favor of {_grantRole}.
2262      */
2263     function _setupRole(bytes32 role, address account) internal virtual {
2264         _grantRole(role, account);
2265     }
2266 
2267     /**
2268      * @dev Sets `adminRole` as ``role``'s admin role.
2269      *
2270      * Emits a {RoleAdminChanged} event.
2271      */
2272     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2273         bytes32 previousAdminRole = getRoleAdmin(role);
2274         _roles[role].adminRole = adminRole;
2275         emit RoleAdminChanged(role, previousAdminRole, adminRole);
2276     }
2277 
2278     /**
2279      * @dev Grants `role` to `account`.
2280      *
2281      * Internal function without access restriction.
2282      */
2283     function _grantRole(bytes32 role, address account) internal virtual {
2284         if (!hasRole(role, account)) {
2285             _roles[role].members[account] = true;
2286             emit RoleGranted(role, account, _msgSender());
2287         }
2288     }
2289 
2290     /**
2291      * @dev Revokes `role` from `account`.
2292      *
2293      * Internal function without access restriction.
2294      */
2295     function _revokeRole(bytes32 role, address account) internal virtual {
2296         if (hasRole(role, account)) {
2297             _roles[role].members[account] = false;
2298             emit RoleRevoked(role, account, _msgSender());
2299         }
2300     }
2301 }
2302 
2303 // File: @openzeppelin/contracts/access/IAccessControlEnumerable.sol
2304 
2305 
2306 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
2307 
2308 pragma solidity ^0.8.0;
2309 
2310 
2311 /**
2312  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
2313  */
2314 interface IAccessControlEnumerable is IAccessControl {
2315     /**
2316      * @dev Returns one of the accounts that have `role`. `index` must be a
2317      * value between 0 and {getRoleMemberCount}, non-inclusive.
2318      *
2319      * Role bearers are not sorted in any particular way, and their ordering may
2320      * change at any point.
2321      *
2322      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
2323      * you perform all queries on the same block. See the following
2324      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
2325      * for more information.
2326      */
2327     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
2328 
2329     /**
2330      * @dev Returns the number of accounts that have `role`. Can be used
2331      * together with {getRoleMember} to enumerate all bearers of a role.
2332      */
2333     function getRoleMemberCount(bytes32 role) external view returns (uint256);
2334 }
2335 
2336 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
2337 
2338 
2339 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
2340 
2341 pragma solidity ^0.8.0;
2342 
2343 
2344 
2345 
2346 /**
2347  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
2348  */
2349 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
2350     using EnumerableSet for EnumerableSet.AddressSet;
2351 
2352     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
2353 
2354     /**
2355      * @dev See {IERC165-supportsInterface}.
2356      */
2357     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2358         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
2359     }
2360 
2361     /**
2362      * @dev Returns one of the accounts that have `role`. `index` must be a
2363      * value between 0 and {getRoleMemberCount}, non-inclusive.
2364      *
2365      * Role bearers are not sorted in any particular way, and their ordering may
2366      * change at any point.
2367      *
2368      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
2369      * you perform all queries on the same block. See the following
2370      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
2371      * for more information.
2372      */
2373     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
2374         return _roleMembers[role].at(index);
2375     }
2376 
2377     /**
2378      * @dev Returns the number of accounts that have `role`. Can be used
2379      * together with {getRoleMember} to enumerate all bearers of a role.
2380      */
2381     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
2382         return _roleMembers[role].length();
2383     }
2384 
2385     /**
2386      * @dev Overload {_grantRole} to track enumerable memberships
2387      */
2388     function _grantRole(bytes32 role, address account) internal virtual override {
2389         super._grantRole(role, account);
2390         _roleMembers[role].add(account);
2391     }
2392 
2393     /**
2394      * @dev Overload {_revokeRole} to track enumerable memberships
2395      */
2396     function _revokeRole(bytes32 role, address account) internal virtual override {
2397         super._revokeRole(role, account);
2398         _roleMembers[role].remove(account);
2399     }
2400 }
2401 
2402 // File: imperium.sol
2403 
2404 
2405 pragma solidity ^0.8.7;
2406 
2407 
2408 
2409 
2410 
2411 
2412 
2413 contract AccessControlContract is AccessControlEnumerable {
2414     bytes32 public constant NFT_ROLE = keccak256("NFT_ROLE");
2415     bytes32 public constant WHITELIST_ROLE = keccak256("WHITELIST_ROLE");
2416     bytes32 public constant BACKEND_ROLE = keccak256("BACKEND_ROLE");
2417 
2418     constructor() {
2419         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2420         
2421         super._setRoleAdmin(NFT_ROLE, DEFAULT_ADMIN_ROLE);
2422         super._setRoleAdmin(WHITELIST_ROLE, DEFAULT_ADMIN_ROLE);  
2423         super._setRoleAdmin(BACKEND_ROLE, DEFAULT_ADMIN_ROLE);
2424 
2425         _setupRole(NFT_ROLE, _msgSender());
2426         _setupRole(WHITELIST_ROLE, _msgSender());
2427         _setupRole(BACKEND_ROLE, _msgSender());
2428     }
2429 
2430     function ifNftRole(address addressNft) public view returns (bool) {
2431         return hasRole(NFT_ROLE,addressNft);
2432     }
2433 
2434     function ifWhiteListRole(address addressWhiteList) public view returns (bool) {
2435         return hasRole(WHITELIST_ROLE,addressWhiteList);
2436     }
2437 
2438     function ifBackEndRole(address addressBackend) public view returns (bool) {
2439         return hasRole(BACKEND_ROLE,addressBackend);
2440     }    
2441 }
2442 
2443 contract NFT is ERC721Enumerable,ERC721Pausable,ERC721URIStorage,ERC2981 {
2444     AccessControlContract accessControl;
2445     using Counters for Counters.Counter;
2446     Counters.Counter private nftIds;
2447 
2448     uint96 feeNumerator;
2449 
2450     mapping (uint256 => address) creatoraddress;
2451 
2452     constructor(address accessControlAddress,uint96 _feeNumerator, string memory name, string memory symbol) ERC721(name, symbol) {
2453         accessControl = AccessControlContract(accessControlAddress); 
2454         feeNumerator=_feeNumerator;       
2455     }
2456 
2457     modifier onlyNftRole() {
2458         require(accessControl.ifNftRole(msg.sender), "must have nft role to nft contract");
2459         _;
2460     }
2461 
2462     function mint(address mintAddress, string memory _tokenURI) public onlyNftRole returns(uint256) {
2463         nftIds.increment();
2464         uint256 idNft = nftIds.current();
2465         _safeMint(mintAddress,idNft);
2466         _setTokenURI(idNft, _tokenURI);
2467         creatoraddress[idNft]=mintAddress;
2468 
2469         return idNft;
2470     }
2471 
2472     function burn(uint256 tokenId) public onlyNftRole {
2473          _burn(tokenId);
2474     }
2475 
2476     function pause() public onlyNftRole virtual {
2477          _pause();
2478     }
2479 
2480     function unpause() public onlyNftRole virtual {
2481         _unpause();
2482     }
2483 
2484     function setRoyalties(uint96 newroyalties) public onlyNftRole virtual{
2485         require(newroyalties <= 10000,"ERC2981: royalty fee will exceed salePrice");
2486         feeNumerator = newroyalties;
2487     }
2488 
2489     /* override methods */
2490     function _beforeTokenTransfer(address from,address to,uint256 tokenId) internal  override(ERC721, ERC721Enumerable, ERC721Pausable) {
2491         super._beforeTokenTransfer(from, to, tokenId);
2492     }
2493 
2494     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC2981, ERC721Enumerable) returns (bool) {
2495         return super.supportsInterface(interfaceId);
2496     }
2497     
2498     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
2499         super._burn(tokenId);
2500     }
2501     
2502     function tokenURI(uint256 tokenId) public view  override(ERC721, ERC721URIStorage) returns (string memory) {
2503         return super.tokenURI(tokenId);
2504     }
2505 
2506     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256){
2507         uint256 royaltyAmount = (_salePrice * feeNumerator) / 10000;
2508 
2509         return (creatoraddress[_tokenId], royaltyAmount);
2510     }
2511 
2512     function getFee () view public onlyNftRole returns (uint96){
2513         return feeNumerator;
2514     }
2515 }
2516 
2517 contract WhiteList {
2518     mapping(address => bool)[2] whitelist;
2519     uint256 statoWhite=0;
2520     AccessControlContract accessControl;
2521     bool paused; 
2522 
2523     constructor(address accessControlAddress,address[] memory walletsList1, address[] memory walletsList2) {
2524         accessControl = AccessControlContract(accessControlAddress);
2525         for(uint i=0; i < walletsList1.length; i++){
2526             whitelist[statoWhite][walletsList1[i]] = true; 
2527         }
2528         for(uint i=0; i < walletsList2.length; i++){
2529             whitelist[1][walletsList2[i]] = true; 
2530         }
2531     }
2532 
2533     modifier onlyWhiteListerRole() {
2534         require(accessControl.ifWhiteListRole(msg.sender), "must have white lister role to whitelist");
2535         _;
2536     }
2537 
2538     function pauseWhiteList() public onlyWhiteListerRole {
2539         paused = true; 
2540     }
2541 
2542     function unpauseWhiteList() public onlyWhiteListerRole {
2543         paused = false; 
2544     }
2545 
2546     function addWalletWhiteList(address walletWhiteList) public onlyWhiteListerRole {
2547         whitelist[statoWhite][walletWhiteList] = true;
2548     }
2549 
2550     function removeWalletWhiteList(address walletWhiteList) public onlyWhiteListerRole {
2551         delete whitelist[statoWhite][walletWhiteList];
2552     }
2553 
2554     function clearWhiteList() public onlyWhiteListerRole{
2555             require(statoWhite==0,"Whitelist Already Clreared");
2556             statoWhite=1;
2557     }
2558 
2559     function isWhiteList(address walletWhiteList) public view returns (bool) {
2560         return whitelist[statoWhite][walletWhiteList];
2561     }
2562 
2563     function isPauseWhiteList() public view returns (bool) {
2564         return paused;
2565     }
2566 }
2567 
2568 contract Implementation {
2569     NFT nft;
2570     WhiteList whiteList; 
2571     AccessControlContract accessControl;
2572     
2573     constructor(address accessControlAddress,address nftAddress, address whiteListAddress) {
2574         accessControl = AccessControlContract(accessControlAddress);
2575         nft = NFT(nftAddress); 
2576         whiteList = WhiteList(whiteListAddress); 
2577     }
2578 
2579     modifier onlyBackEndRole() {
2580         require(accessControl.ifBackEndRole(msg.sender), "must have back end role to backend call");
2581         _;
2582     }
2583 
2584     modifier permitMint(address mintWallet) {
2585         require(whiteList.isPauseWhiteList() || isWhiteList(mintWallet), "the current wallet is not present in the whitelist");
2586         _;
2587     }
2588 
2589     function mint(address mintWallet, string memory uri) public onlyBackEndRole permitMint(mintWallet) returns (uint256) {
2590         return nft.mint(mintWallet,uri); 
2591     }
2592 
2593     function getFee() view public onlyBackEndRole returns (uint96){
2594         return nft.getFee();
2595     }
2596 
2597     function setFee(uint96 fee) public onlyBackEndRole{
2598         nft.setRoyalties(fee);
2599     }
2600 
2601     function burn(uint256 tokenId) public onlyBackEndRole {
2602         nft.burn(tokenId); 
2603     }    
2604 
2605     function pauseNFT() public onlyBackEndRole {
2606          nft.pause();
2607     }
2608 
2609     function unpauseNFT() public onlyBackEndRole {
2610          nft.unpause();
2611     }
2612 
2613     function isWhiteList(address walletWhiteList) public onlyBackEndRole view returns (bool) {
2614         return whiteList.isWhiteList(walletWhiteList); 
2615     }
2616 
2617     function pauseWhiteList() public onlyBackEndRole {
2618         whiteList.pauseWhiteList(); 
2619     }
2620 
2621     function unpauseWhiteList() public onlyBackEndRole {
2622         whiteList.unpauseWhiteList(); 
2623     }
2624 
2625     function addWalletWhiteList(address walletWhiteList) public onlyBackEndRole {
2626         whiteList.addWalletWhiteList(walletWhiteList); 
2627     }
2628 
2629     function removeWalletWhiteList(address walletWhiteList) public onlyBackEndRole {
2630         whiteList.removeWalletWhiteList(walletWhiteList); 
2631     }
2632 
2633     function clearWhiteList () public onlyBackEndRole{
2634         whiteList.clearWhiteList();
2635     }
2636 
2637     function tokenURI(uint256 tokenId) public onlyBackEndRole view returns (string memory) {
2638         return nft.tokenURI(tokenId); 
2639     }
2640 
2641     function ownerOf(uint256 tokenId) public onlyBackEndRole view returns (address) {
2642         return nft.ownerOf(tokenId); 
2643     }
2644 
2645     function totalNft() public onlyBackEndRole view returns (uint256) {
2646         return nft.totalSupply(); 
2647     }
2648 
2649     function balanceOf(address addressOwner) public onlyBackEndRole view returns (uint256) {
2650         return nft.balanceOf(addressOwner); 
2651     }    
2652 }