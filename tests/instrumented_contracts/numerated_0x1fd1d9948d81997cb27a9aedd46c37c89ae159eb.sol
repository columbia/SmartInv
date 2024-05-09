1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214 
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @title ERC721 token receiver interface
235  * @dev Interface for any contract that wants to support safeTransfers
236  * from ERC721 asset contracts.
237  */
238 interface IERC721Receiver {
239     /**
240      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
241      * by `operator` from `from`, this function is called.
242      *
243      * It must return its Solidity selector to confirm the token transfer.
244      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
245      *
246      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
247      */
248     function onERC721Received(
249         address operator,
250         address from,
251         uint256 tokenId,
252         bytes calldata data
253     ) external returns (bytes4);
254 }
255 
256 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev Library for managing
265  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
266  * types.
267  *
268  * Sets have the following properties:
269  *
270  * - Elements are added, removed, and checked for existence in constant time
271  * (O(1)).
272  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
273  *
274  * ```
275  * contract Example {
276  *     // Add the library methods
277  *     using EnumerableSet for EnumerableSet.AddressSet;
278  *
279  *     // Declare a set state variable
280  *     EnumerableSet.AddressSet private mySet;
281  * }
282  * ```
283  *
284  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
285  * and `uint256` (`UintSet`) are supported.
286  */
287 library EnumerableSet {
288     // To implement this library for multiple types with as little code
289     // repetition as possible, we write it in terms of a generic Set type with
290     // bytes32 values.
291     // The Set implementation uses private functions, and user-facing
292     // implementations (such as AddressSet) are just wrappers around the
293     // underlying Set.
294     // This means that we can only create new EnumerableSets for types that fit
295     // in bytes32.
296 
297     struct Set {
298         // Storage of set values
299         bytes32[] _values;
300         // Position of the value in the `values` array, plus 1 because index 0
301         // means a value is not in the set.
302         mapping(bytes32 => uint256) _indexes;
303     }
304 
305     /**
306      * @dev Add a value to a set. O(1).
307      *
308      * Returns true if the value was added to the set, that is if it was not
309      * already present.
310      */
311     function _add(Set storage set, bytes32 value) private returns (bool) {
312         if (!_contains(set, value)) {
313             set._values.push(value);
314             // The value is stored at length-1, but we add 1 to all indexes
315             // and use 0 as a sentinel value
316             set._indexes[value] = set._values.length;
317             return true;
318         } else {
319             return false;
320         }
321     }
322 
323     /**
324      * @dev Removes a value from a set. O(1).
325      *
326      * Returns true if the value was removed from the set, that is if it was
327      * present.
328      */
329     function _remove(Set storage set, bytes32 value) private returns (bool) {
330         // We read and store the value's index to prevent multiple reads from the same storage slot
331         uint256 valueIndex = set._indexes[value];
332 
333         if (valueIndex != 0) {
334             // Equivalent to contains(set, value)
335             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
336             // the array, and then remove the last element (sometimes called as 'swap and pop').
337             // This modifies the order of the array, as noted in {at}.
338 
339             uint256 toDeleteIndex = valueIndex - 1;
340             uint256 lastIndex = set._values.length - 1;
341 
342             if (lastIndex != toDeleteIndex) {
343                 bytes32 lastvalue = set._values[lastIndex];
344 
345                 // Move the last value to the index where the value to delete is
346                 set._values[toDeleteIndex] = lastvalue;
347                 // Update the index for the moved value
348                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
349             }
350 
351             // Delete the slot where the moved value was stored
352             set._values.pop();
353 
354             // Delete the index for the deleted slot
355             delete set._indexes[value];
356 
357             return true;
358         } else {
359             return false;
360         }
361     }
362 
363     /**
364      * @dev Returns true if the value is in the set. O(1).
365      */
366     function _contains(Set storage set, bytes32 value) private view returns (bool) {
367         return set._indexes[value] != 0;
368     }
369 
370     /**
371      * @dev Returns the number of values on the set. O(1).
372      */
373     function _length(Set storage set) private view returns (uint256) {
374         return set._values.length;
375     }
376 
377     /**
378      * @dev Returns the value stored at position `index` in the set. O(1).
379      *
380      * Note that there are no guarantees on the ordering of values inside the
381      * array, and it may change when more values are added or removed.
382      *
383      * Requirements:
384      *
385      * - `index` must be strictly less than {length}.
386      */
387     function _at(Set storage set, uint256 index) private view returns (bytes32) {
388         return set._values[index];
389     }
390 
391     /**
392      * @dev Return the entire set in an array
393      *
394      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
395      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
396      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
397      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
398      */
399     function _values(Set storage set) private view returns (bytes32[] memory) {
400         return set._values;
401     }
402 
403     // Bytes32Set
404 
405     struct Bytes32Set {
406         Set _inner;
407     }
408 
409     /**
410      * @dev Add a value to a set. O(1).
411      *
412      * Returns true if the value was added to the set, that is if it was not
413      * already present.
414      */
415     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
416         return _add(set._inner, value);
417     }
418 
419     /**
420      * @dev Removes a value from a set. O(1).
421      *
422      * Returns true if the value was removed from the set, that is if it was
423      * present.
424      */
425     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
426         return _remove(set._inner, value);
427     }
428 
429     /**
430      * @dev Returns true if the value is in the set. O(1).
431      */
432     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
433         return _contains(set._inner, value);
434     }
435 
436     /**
437      * @dev Returns the number of values in the set. O(1).
438      */
439     function length(Bytes32Set storage set) internal view returns (uint256) {
440         return _length(set._inner);
441     }
442 
443     /**
444      * @dev Returns the value stored at position `index` in the set. O(1).
445      *
446      * Note that there are no guarantees on the ordering of values inside the
447      * array, and it may change when more values are added or removed.
448      *
449      * Requirements:
450      *
451      * - `index` must be strictly less than {length}.
452      */
453     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
454         return _at(set._inner, index);
455     }
456 
457     /**
458      * @dev Return the entire set in an array
459      *
460      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
461      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
462      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
463      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
464      */
465     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
466         return _values(set._inner);
467     }
468 
469     // AddressSet
470 
471     struct AddressSet {
472         Set _inner;
473     }
474 
475     /**
476      * @dev Add a value to a set. O(1).
477      *
478      * Returns true if the value was added to the set, that is if it was not
479      * already present.
480      */
481     function add(AddressSet storage set, address value) internal returns (bool) {
482         return _add(set._inner, bytes32(uint256(uint160(value))));
483     }
484 
485     /**
486      * @dev Removes a value from a set. O(1).
487      *
488      * Returns true if the value was removed from the set, that is if it was
489      * present.
490      */
491     function remove(AddressSet storage set, address value) internal returns (bool) {
492         return _remove(set._inner, bytes32(uint256(uint160(value))));
493     }
494 
495     /**
496      * @dev Returns true if the value is in the set. O(1).
497      */
498     function contains(AddressSet storage set, address value) internal view returns (bool) {
499         return _contains(set._inner, bytes32(uint256(uint160(value))));
500     }
501 
502     /**
503      * @dev Returns the number of values in the set. O(1).
504      */
505     function length(AddressSet storage set) internal view returns (uint256) {
506         return _length(set._inner);
507     }
508 
509     /**
510      * @dev Returns the value stored at position `index` in the set. O(1).
511      *
512      * Note that there are no guarantees on the ordering of values inside the
513      * array, and it may change when more values are added or removed.
514      *
515      * Requirements:
516      *
517      * - `index` must be strictly less than {length}.
518      */
519     function at(AddressSet storage set, uint256 index) internal view returns (address) {
520         return address(uint160(uint256(_at(set._inner, index))));
521     }
522 
523     /**
524      * @dev Return the entire set in an array
525      *
526      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
527      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
528      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
529      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
530      */
531     function values(AddressSet storage set) internal view returns (address[] memory) {
532         bytes32[] memory store = _values(set._inner);
533         address[] memory result;
534 
535         assembly {
536             result := store
537         }
538 
539         return result;
540     }
541 
542     // UintSet
543 
544     struct UintSet {
545         Set _inner;
546     }
547 
548     /**
549      * @dev Add a value to a set. O(1).
550      *
551      * Returns true if the value was added to the set, that is if it was not
552      * already present.
553      */
554     function add(UintSet storage set, uint256 value) internal returns (bool) {
555         return _add(set._inner, bytes32(value));
556     }
557 
558     /**
559      * @dev Removes a value from a set. O(1).
560      *
561      * Returns true if the value was removed from the set, that is if it was
562      * present.
563      */
564     function remove(UintSet storage set, uint256 value) internal returns (bool) {
565         return _remove(set._inner, bytes32(value));
566     }
567 
568     /**
569      * @dev Returns true if the value is in the set. O(1).
570      */
571     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
572         return _contains(set._inner, bytes32(value));
573     }
574 
575     /**
576      * @dev Returns the number of values on the set. O(1).
577      */
578     function length(UintSet storage set) internal view returns (uint256) {
579         return _length(set._inner);
580     }
581 
582     /**
583      * @dev Returns the value stored at position `index` in the set. O(1).
584      *
585      * Note that there are no guarantees on the ordering of values inside the
586      * array, and it may change when more values are added or removed.
587      *
588      * Requirements:
589      *
590      * - `index` must be strictly less than {length}.
591      */
592     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
593         return uint256(_at(set._inner, index));
594     }
595 
596     /**
597      * @dev Return the entire set in an array
598      *
599      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
600      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
601      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
602      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
603      */
604     function values(UintSet storage set) internal view returns (uint256[] memory) {
605         bytes32[] memory store = _values(set._inner);
606         uint256[] memory result;
607 
608         assembly {
609             result := store
610         }
611 
612         return result;
613     }
614 }
615 
616 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
617 
618 
619 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
620 
621 pragma solidity ^0.8.0;
622 
623 /**
624  * @dev Interface of the ERC165 standard, as defined in the
625  * https://eips.ethereum.org/EIPS/eip-165[EIP].
626  *
627  * Implementers can declare support of contract interfaces, which can then be
628  * queried by others ({ERC165Checker}).
629  *
630  * For an implementation, see {ERC165}.
631  */
632 interface IERC165 {
633     /**
634      * @dev Returns true if this contract implements the interface defined by
635      * `interfaceId`. See the corresponding
636      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
637      * to learn more about how these ids are created.
638      *
639      * This function call must use less than 30 000 gas.
640      */
641     function supportsInterface(bytes4 interfaceId) external view returns (bool);
642 }
643 
644 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
645 
646 
647 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
648 
649 pragma solidity ^0.8.0;
650 
651 
652 /**
653  * @dev Required interface of an ERC721 compliant contract.
654  */
655 interface IERC721 is IERC165 {
656     /**
657      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
658      */
659     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
660 
661     /**
662      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
663      */
664     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
665 
666     /**
667      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
668      */
669     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
670 
671     /**
672      * @dev Returns the number of tokens in ``owner``'s account.
673      */
674     function balanceOf(address owner) external view returns (uint256 balance);
675 
676     /**
677      * @dev Returns the owner of the `tokenId` token.
678      *
679      * Requirements:
680      *
681      * - `tokenId` must exist.
682      */
683     function ownerOf(uint256 tokenId) external view returns (address owner);
684 
685     /**
686      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
687      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
688      *
689      * Requirements:
690      *
691      * - `from` cannot be the zero address.
692      * - `to` cannot be the zero address.
693      * - `tokenId` token must exist and be owned by `from`.
694      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
695      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
696      *
697      * Emits a {Transfer} event.
698      */
699     function safeTransferFrom(
700         address from,
701         address to,
702         uint256 tokenId
703     ) external;
704 
705     /**
706      * @dev Transfers `tokenId` token from `from` to `to`.
707      *
708      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
709      *
710      * Requirements:
711      *
712      * - `from` cannot be the zero address.
713      * - `to` cannot be the zero address.
714      * - `tokenId` token must be owned by `from`.
715      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
716      *
717      * Emits a {Transfer} event.
718      */
719     function transferFrom(
720         address from,
721         address to,
722         uint256 tokenId
723     ) external;
724 
725     /**
726      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
727      * The approval is cleared when the token is transferred.
728      *
729      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
730      *
731      * Requirements:
732      *
733      * - The caller must own the token or be an approved operator.
734      * - `tokenId` must exist.
735      *
736      * Emits an {Approval} event.
737      */
738     function approve(address to, uint256 tokenId) external;
739 
740     /**
741      * @dev Returns the account approved for `tokenId` token.
742      *
743      * Requirements:
744      *
745      * - `tokenId` must exist.
746      */
747     function getApproved(uint256 tokenId) external view returns (address operator);
748 
749     /**
750      * @dev Approve or remove `operator` as an operator for the caller.
751      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
752      *
753      * Requirements:
754      *
755      * - The `operator` cannot be the caller.
756      *
757      * Emits an {ApprovalForAll} event.
758      */
759     function setApprovalForAll(address operator, bool _approved) external;
760 
761     /**
762      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
763      *
764      * See {setApprovalForAll}
765      */
766     function isApprovedForAll(address owner, address operator) external view returns (bool);
767 
768     /**
769      * @dev Safely transfers `tokenId` token from `from` to `to`.
770      *
771      * Requirements:
772      *
773      * - `from` cannot be the zero address.
774      * - `to` cannot be the zero address.
775      * - `tokenId` token must exist and be owned by `from`.
776      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
777      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
778      *
779      * Emits a {Transfer} event.
780      */
781     function safeTransferFrom(
782         address from,
783         address to,
784         uint256 tokenId,
785         bytes calldata data
786     ) external;
787 }
788 
789 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
790 
791 
792 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
793 
794 pragma solidity ^0.8.0;
795 
796 
797 /**
798  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
799  * @dev See https://eips.ethereum.org/EIPS/eip-721
800  */
801 interface IERC721Enumerable is IERC721 {
802     /**
803      * @dev Returns the total amount of tokens stored by the contract.
804      */
805     function totalSupply() external view returns (uint256);
806 
807     /**
808      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
809      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
810      */
811     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
812 
813     /**
814      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
815      * Use along with {totalSupply} to enumerate all tokens.
816      */
817     function tokenByIndex(uint256 index) external view returns (uint256);
818 }
819 
820 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
821 
822 
823 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
824 
825 pragma solidity ^0.8.0;
826 
827 
828 /**
829  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
830  * @dev See https://eips.ethereum.org/EIPS/eip-721
831  */
832 interface IERC721Metadata is IERC721 {
833     /**
834      * @dev Returns the token collection name.
835      */
836     function name() external view returns (string memory);
837 
838     /**
839      * @dev Returns the token collection symbol.
840      */
841     function symbol() external view returns (string memory);
842 
843     /**
844      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
845      */
846     function tokenURI(uint256 tokenId) external view returns (string memory);
847 }
848 
849 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
850 
851 
852 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
853 
854 pragma solidity ^0.8.0;
855 
856 
857 /**
858  * @dev Implementation of the {IERC165} interface.
859  *
860  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
861  * for the additional interface id that will be supported. For example:
862  *
863  * ```solidity
864  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
865  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
866  * }
867  * ```
868  *
869  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
870  */
871 abstract contract ERC165 is IERC165 {
872     /**
873      * @dev See {IERC165-supportsInterface}.
874      */
875     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
876         return interfaceId == type(IERC165).interfaceId;
877     }
878 }
879 
880 // File: @openzeppelin/contracts/utils/Strings.sol
881 
882 
883 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
884 
885 pragma solidity ^0.8.0;
886 
887 /**
888  * @dev String operations.
889  */
890 library Strings {
891     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
892 
893     /**
894      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
895      */
896     function toString(uint256 value) internal pure returns (string memory) {
897         // Inspired by OraclizeAPI's implementation - MIT licence
898         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
899 
900         if (value == 0) {
901             return "0";
902         }
903         uint256 temp = value;
904         uint256 digits;
905         while (temp != 0) {
906             digits++;
907             temp /= 10;
908         }
909         bytes memory buffer = new bytes(digits);
910         while (value != 0) {
911             digits -= 1;
912             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
913             value /= 10;
914         }
915         return string(buffer);
916     }
917 
918     /**
919      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
920      */
921     function toHexString(uint256 value) internal pure returns (string memory) {
922         if (value == 0) {
923             return "0x00";
924         }
925         uint256 temp = value;
926         uint256 length = 0;
927         while (temp != 0) {
928             length++;
929             temp >>= 8;
930         }
931         return toHexString(value, length);
932     }
933 
934     /**
935      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
936      */
937     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
938         bytes memory buffer = new bytes(2 * length + 2);
939         buffer[0] = "0";
940         buffer[1] = "x";
941         for (uint256 i = 2 * length + 1; i > 1; --i) {
942             buffer[i] = _HEX_SYMBOLS[value & 0xf];
943             value >>= 4;
944         }
945         require(value == 0, "Strings: hex length insufficient");
946         return string(buffer);
947     }
948 }
949 
950 // File: @openzeppelin/contracts/access/IAccessControl.sol
951 
952 
953 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
954 
955 pragma solidity ^0.8.0;
956 
957 /**
958  * @dev External interface of AccessControl declared to support ERC165 detection.
959  */
960 interface IAccessControl {
961     /**
962      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
963      *
964      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
965      * {RoleAdminChanged} not being emitted signaling this.
966      *
967      * _Available since v3.1._
968      */
969     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
970 
971     /**
972      * @dev Emitted when `account` is granted `role`.
973      *
974      * `sender` is the account that originated the contract call, an admin role
975      * bearer except when using {AccessControl-_setupRole}.
976      */
977     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
978 
979     /**
980      * @dev Emitted when `account` is revoked `role`.
981      *
982      * `sender` is the account that originated the contract call:
983      *   - if using `revokeRole`, it is the admin role bearer
984      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
985      */
986     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
987 
988     /**
989      * @dev Returns `true` if `account` has been granted `role`.
990      */
991     function hasRole(bytes32 role, address account) external view returns (bool);
992 
993     /**
994      * @dev Returns the admin role that controls `role`. See {grantRole} and
995      * {revokeRole}.
996      *
997      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
998      */
999     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1000 
1001     /**
1002      * @dev Grants `role` to `account`.
1003      *
1004      * If `account` had not been already granted `role`, emits a {RoleGranted}
1005      * event.
1006      *
1007      * Requirements:
1008      *
1009      * - the caller must have ``role``'s admin role.
1010      */
1011     function grantRole(bytes32 role, address account) external;
1012 
1013     /**
1014      * @dev Revokes `role` from `account`.
1015      *
1016      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1017      *
1018      * Requirements:
1019      *
1020      * - the caller must have ``role``'s admin role.
1021      */
1022     function revokeRole(bytes32 role, address account) external;
1023 
1024     /**
1025      * @dev Revokes `role` from the calling account.
1026      *
1027      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1028      * purpose is to provide a mechanism for accounts to lose their privileges
1029      * if they are compromised (such as when a trusted device is misplaced).
1030      *
1031      * If the calling account had been granted `role`, emits a {RoleRevoked}
1032      * event.
1033      *
1034      * Requirements:
1035      *
1036      * - the caller must be `account`.
1037      */
1038     function renounceRole(bytes32 role, address account) external;
1039 }
1040 
1041 // File: @openzeppelin/contracts/access/IAccessControlEnumerable.sol
1042 
1043 
1044 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
1045 
1046 pragma solidity ^0.8.0;
1047 
1048 
1049 /**
1050  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1051  */
1052 interface IAccessControlEnumerable is IAccessControl {
1053     /**
1054      * @dev Returns one of the accounts that have `role`. `index` must be a
1055      * value between 0 and {getRoleMemberCount}, non-inclusive.
1056      *
1057      * Role bearers are not sorted in any particular way, and their ordering may
1058      * change at any point.
1059      *
1060      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1061      * you perform all queries on the same block. See the following
1062      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1063      * for more information.
1064      */
1065     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1066 
1067     /**
1068      * @dev Returns the number of accounts that have `role`. Can be used
1069      * together with {getRoleMember} to enumerate all bearers of a role.
1070      */
1071     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1072 }
1073 
1074 // File: @openzeppelin/contracts/utils/Context.sol
1075 
1076 
1077 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1078 
1079 pragma solidity ^0.8.0;
1080 
1081 /**
1082  * @dev Provides information about the current execution context, including the
1083  * sender of the transaction and its data. While these are generally available
1084  * via msg.sender and msg.data, they should not be accessed in such a direct
1085  * manner, since when dealing with meta-transactions the account sending and
1086  * paying for execution may not be the actual sender (as far as an application
1087  * is concerned).
1088  *
1089  * This contract is only required for intermediate, library-like contracts.
1090  */
1091 abstract contract Context {
1092     function _msgSender() internal view virtual returns (address) {
1093         return msg.sender;
1094     }
1095 
1096     function _msgData() internal view virtual returns (bytes calldata) {
1097         return msg.data;
1098     }
1099 }
1100 
1101 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1102 
1103 
1104 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
1105 
1106 pragma solidity ^0.8.0;
1107 
1108 
1109 
1110 
1111 
1112 
1113 
1114 
1115 /**
1116  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1117  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1118  * {ERC721Enumerable}.
1119  */
1120 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1121     using Address for address;
1122     using Strings for uint256;
1123 
1124     // Token name
1125     string private _name;
1126 
1127     // Token symbol
1128     string private _symbol;
1129 
1130     // Mapping from token ID to owner address
1131     mapping(uint256 => address) private _owners;
1132 
1133     // Mapping owner address to token count
1134     mapping(address => uint256) private _balances;
1135 
1136     // Mapping from token ID to approved address
1137     mapping(uint256 => address) private _tokenApprovals;
1138 
1139     // Mapping from owner to operator approvals
1140     mapping(address => mapping(address => bool)) private _operatorApprovals;
1141 
1142     /**
1143      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1144      */
1145     constructor(string memory name_, string memory symbol_) {
1146         _name = name_;
1147         _symbol = symbol_;
1148     }
1149 
1150     /**
1151      * @dev See {IERC165-supportsInterface}.
1152      */
1153     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1154         return
1155             interfaceId == type(IERC721).interfaceId ||
1156             interfaceId == type(IERC721Metadata).interfaceId ||
1157             super.supportsInterface(interfaceId);
1158     }
1159 
1160     /**
1161      * @dev See {IERC721-balanceOf}.
1162      */
1163     function balanceOf(address owner) public view virtual override returns (uint256) {
1164         require(owner != address(0), "ERC721: balance query for the zero address");
1165         return _balances[owner];
1166     }
1167 
1168     /**
1169      * @dev See {IERC721-ownerOf}.
1170      */
1171     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1172         address owner = _owners[tokenId];
1173         require(owner != address(0), "ERC721: owner query for nonexistent token");
1174         return owner;
1175     }
1176 
1177     /**
1178      * @dev See {IERC721Metadata-name}.
1179      */
1180     function name() public view virtual override returns (string memory) {
1181         return _name;
1182     }
1183 
1184     /**
1185      * @dev See {IERC721Metadata-symbol}.
1186      */
1187     function symbol() public view virtual override returns (string memory) {
1188         return _symbol;
1189     }
1190 
1191     /**
1192      * @dev See {IERC721Metadata-tokenURI}.
1193      */
1194     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1195         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1196 
1197         string memory baseURI = _baseURI();
1198         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1199     }
1200 
1201     /**
1202      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1203      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1204      * by default, can be overriden in child contracts.
1205      */
1206     function _baseURI() internal view virtual returns (string memory) {
1207         return "";
1208     }
1209 
1210     /**
1211      * @dev See {IERC721-approve}.
1212      */
1213     function approve(address to, uint256 tokenId) public virtual override {
1214         address owner = ERC721.ownerOf(tokenId);
1215         require(to != owner, "ERC721: approval to current owner");
1216 
1217         require(
1218             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1219             "ERC721: approve caller is not owner nor approved for all"
1220         );
1221 
1222         _approve(to, tokenId);
1223     }
1224 
1225     /**
1226      * @dev See {IERC721-getApproved}.
1227      */
1228     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1229         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1230 
1231         return _tokenApprovals[tokenId];
1232     }
1233 
1234     /**
1235      * @dev See {IERC721-setApprovalForAll}.
1236      */
1237     function setApprovalForAll(address operator, bool approved) public virtual override {
1238         _setApprovalForAll(_msgSender(), operator, approved);
1239     }
1240 
1241     /**
1242      * @dev See {IERC721-isApprovedForAll}.
1243      */
1244     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1245         return _operatorApprovals[owner][operator];
1246     }
1247 
1248     /**
1249      * @dev See {IERC721-transferFrom}.
1250      */
1251     function transferFrom(
1252         address from,
1253         address to,
1254         uint256 tokenId
1255     ) public virtual override {
1256         //solhint-disable-next-line max-line-length
1257         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1258 
1259         _transfer(from, to, tokenId);
1260     }
1261 
1262     /**
1263      * @dev See {IERC721-safeTransferFrom}.
1264      */
1265     function safeTransferFrom(
1266         address from,
1267         address to,
1268         uint256 tokenId
1269     ) public virtual override {
1270         safeTransferFrom(from, to, tokenId, "");
1271     }
1272 
1273     /**
1274      * @dev See {IERC721-safeTransferFrom}.
1275      */
1276     function safeTransferFrom(
1277         address from,
1278         address to,
1279         uint256 tokenId,
1280         bytes memory _data
1281     ) public virtual override {
1282         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1283         _safeTransfer(from, to, tokenId, _data);
1284     }
1285 
1286     /**
1287      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1288      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1289      *
1290      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1291      *
1292      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1293      * implement alternative mechanisms to perform token transfer, such as signature-based.
1294      *
1295      * Requirements:
1296      *
1297      * - `from` cannot be the zero address.
1298      * - `to` cannot be the zero address.
1299      * - `tokenId` token must exist and be owned by `from`.
1300      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1301      *
1302      * Emits a {Transfer} event.
1303      */
1304     function _safeTransfer(
1305         address from,
1306         address to,
1307         uint256 tokenId,
1308         bytes memory _data
1309     ) internal virtual {
1310         _transfer(from, to, tokenId);
1311         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1312     }
1313 
1314     /**
1315      * @dev Returns whether `tokenId` exists.
1316      *
1317      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1318      *
1319      * Tokens start existing when they are minted (`_mint`),
1320      * and stop existing when they are burned (`_burn`).
1321      */
1322     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1323         return _owners[tokenId] != address(0);
1324     }
1325 
1326     /**
1327      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1328      *
1329      * Requirements:
1330      *
1331      * - `tokenId` must exist.
1332      */
1333     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1334         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1335         address owner = ERC721.ownerOf(tokenId);
1336         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1337     }
1338 
1339     /**
1340      * @dev Safely mints `tokenId` and transfers it to `to`.
1341      *
1342      * Requirements:
1343      *
1344      * - `tokenId` must not exist.
1345      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1346      *
1347      * Emits a {Transfer} event.
1348      */
1349     function _safeMint(address to, uint256 tokenId) internal virtual {
1350         _safeMint(to, tokenId, "");
1351     }
1352 
1353     /**
1354      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1355      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1356      */
1357     function _safeMint(
1358         address to,
1359         uint256 tokenId,
1360         bytes memory _data
1361     ) internal virtual {
1362         _mint(to, tokenId);
1363         require(
1364             _checkOnERC721Received(address(0), to, tokenId, _data),
1365             "ERC721: transfer to non ERC721Receiver implementer"
1366         );
1367     }
1368 
1369     /**
1370      * @dev Mints `tokenId` and transfers it to `to`.
1371      *
1372      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1373      *
1374      * Requirements:
1375      *
1376      * - `tokenId` must not exist.
1377      * - `to` cannot be the zero address.
1378      *
1379      * Emits a {Transfer} event.
1380      */
1381     function _mint(address to, uint256 tokenId) internal virtual {
1382         require(to != address(0), "ERC721: mint to the zero address");
1383         require(!_exists(tokenId), "ERC721: token already minted");
1384 
1385         _beforeTokenTransfer(address(0), to, tokenId);
1386 
1387         _balances[to] += 1;
1388         _owners[tokenId] = to;
1389 
1390         emit Transfer(address(0), to, tokenId);
1391 
1392         _afterTokenTransfer(address(0), to, tokenId);
1393     }
1394 
1395     /**
1396      * @dev Destroys `tokenId`.
1397      * The approval is cleared when the token is burned.
1398      *
1399      * Requirements:
1400      *
1401      * - `tokenId` must exist.
1402      *
1403      * Emits a {Transfer} event.
1404      */
1405     function _burn(uint256 tokenId) internal virtual {
1406         address owner = ERC721.ownerOf(tokenId);
1407 
1408         _beforeTokenTransfer(owner, address(0), tokenId);
1409 
1410         // Clear approvals
1411         _approve(address(0), tokenId);
1412 
1413         _balances[owner] -= 1;
1414         delete _owners[tokenId];
1415 
1416         emit Transfer(owner, address(0), tokenId);
1417 
1418         _afterTokenTransfer(owner, address(0), tokenId);
1419     }
1420 
1421     /**
1422      * @dev Transfers `tokenId` from `from` to `to`.
1423      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1424      *
1425      * Requirements:
1426      *
1427      * - `to` cannot be the zero address.
1428      * - `tokenId` token must be owned by `from`.
1429      *
1430      * Emits a {Transfer} event.
1431      */
1432     function _transfer(
1433         address from,
1434         address to,
1435         uint256 tokenId
1436     ) internal virtual {
1437         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1438         require(to != address(0), "ERC721: transfer to the zero address");
1439 
1440         _beforeTokenTransfer(from, to, tokenId);
1441 
1442         // Clear approvals from the previous owner
1443         _approve(address(0), tokenId);
1444 
1445         _balances[from] -= 1;
1446         _balances[to] += 1;
1447         _owners[tokenId] = to;
1448 
1449         emit Transfer(from, to, tokenId);
1450 
1451         _afterTokenTransfer(from, to, tokenId);
1452     }
1453 
1454     /**
1455      * @dev Approve `to` to operate on `tokenId`
1456      *
1457      * Emits a {Approval} event.
1458      */
1459     function _approve(address to, uint256 tokenId) internal virtual {
1460         _tokenApprovals[tokenId] = to;
1461         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1462     }
1463 
1464     /**
1465      * @dev Approve `operator` to operate on all of `owner` tokens
1466      *
1467      * Emits a {ApprovalForAll} event.
1468      */
1469     function _setApprovalForAll(
1470         address owner,
1471         address operator,
1472         bool approved
1473     ) internal virtual {
1474         require(owner != operator, "ERC721: approve to caller");
1475         _operatorApprovals[owner][operator] = approved;
1476         emit ApprovalForAll(owner, operator, approved);
1477     }
1478 
1479     /**
1480      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1481      * The call is not executed if the target address is not a contract.
1482      *
1483      * @param from address representing the previous owner of the given token ID
1484      * @param to target address that will receive the tokens
1485      * @param tokenId uint256 ID of the token to be transferred
1486      * @param _data bytes optional data to send along with the call
1487      * @return bool whether the call correctly returned the expected magic value
1488      */
1489     function _checkOnERC721Received(
1490         address from,
1491         address to,
1492         uint256 tokenId,
1493         bytes memory _data
1494     ) private returns (bool) {
1495         if (to.isContract()) {
1496             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1497                 return retval == IERC721Receiver.onERC721Received.selector;
1498             } catch (bytes memory reason) {
1499                 if (reason.length == 0) {
1500                     revert("ERC721: transfer to non ERC721Receiver implementer");
1501                 } else {
1502                     assembly {
1503                         revert(add(32, reason), mload(reason))
1504                     }
1505                 }
1506             }
1507         } else {
1508             return true;
1509         }
1510     }
1511 
1512     /**
1513      * @dev Hook that is called before any token transfer. This includes minting
1514      * and burning.
1515      *
1516      * Calling conditions:
1517      *
1518      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1519      * transferred to `to`.
1520      * - When `from` is zero, `tokenId` will be minted for `to`.
1521      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1522      * - `from` and `to` are never both zero.
1523      *
1524      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1525      */
1526     function _beforeTokenTransfer(
1527         address from,
1528         address to,
1529         uint256 tokenId
1530     ) internal virtual {}
1531 
1532     /**
1533      * @dev Hook that is called after any transfer of tokens. This includes
1534      * minting and burning.
1535      *
1536      * Calling conditions:
1537      *
1538      * - when `from` and `to` are both non-zero.
1539      * - `from` and `to` are never both zero.
1540      *
1541      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1542      */
1543     function _afterTokenTransfer(
1544         address from,
1545         address to,
1546         uint256 tokenId
1547     ) internal virtual {}
1548 }
1549 
1550 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1551 
1552 
1553 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1554 
1555 pragma solidity ^0.8.0;
1556 
1557 
1558 
1559 /**
1560  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1561  * enumerability of all the token ids in the contract as well as all token ids owned by each
1562  * account.
1563  */
1564 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1565     // Mapping from owner to list of owned token IDs
1566     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1567 
1568     // Mapping from token ID to index of the owner tokens list
1569     mapping(uint256 => uint256) private _ownedTokensIndex;
1570 
1571     // Array with all token ids, used for enumeration
1572     uint256[] private _allTokens;
1573 
1574     // Mapping from token id to position in the allTokens array
1575     mapping(uint256 => uint256) private _allTokensIndex;
1576 
1577     /**
1578      * @dev See {IERC165-supportsInterface}.
1579      */
1580     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1581         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1582     }
1583 
1584     /**
1585      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1586      */
1587     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1588         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1589         return _ownedTokens[owner][index];
1590     }
1591 
1592     /**
1593      * @dev See {IERC721Enumerable-totalSupply}.
1594      */
1595     function totalSupply() public view virtual override returns (uint256) {
1596         return _allTokens.length;
1597     }
1598 
1599     /**
1600      * @dev See {IERC721Enumerable-tokenByIndex}.
1601      */
1602     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1603         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1604         return _allTokens[index];
1605     }
1606 
1607     /**
1608      * @dev Hook that is called before any token transfer. This includes minting
1609      * and burning.
1610      *
1611      * Calling conditions:
1612      *
1613      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1614      * transferred to `to`.
1615      * - When `from` is zero, `tokenId` will be minted for `to`.
1616      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1617      * - `from` cannot be the zero address.
1618      * - `to` cannot be the zero address.
1619      *
1620      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1621      */
1622     function _beforeTokenTransfer(
1623         address from,
1624         address to,
1625         uint256 tokenId
1626     ) internal virtual override {
1627         super._beforeTokenTransfer(from, to, tokenId);
1628 
1629         if (from == address(0)) {
1630             _addTokenToAllTokensEnumeration(tokenId);
1631         } else if (from != to) {
1632             _removeTokenFromOwnerEnumeration(from, tokenId);
1633         }
1634         if (to == address(0)) {
1635             _removeTokenFromAllTokensEnumeration(tokenId);
1636         } else if (to != from) {
1637             _addTokenToOwnerEnumeration(to, tokenId);
1638         }
1639     }
1640 
1641     /**
1642      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1643      * @param to address representing the new owner of the given token ID
1644      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1645      */
1646     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1647         uint256 length = ERC721.balanceOf(to);
1648         _ownedTokens[to][length] = tokenId;
1649         _ownedTokensIndex[tokenId] = length;
1650     }
1651 
1652     /**
1653      * @dev Private function to add a token to this extension's token tracking data structures.
1654      * @param tokenId uint256 ID of the token to be added to the tokens list
1655      */
1656     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1657         _allTokensIndex[tokenId] = _allTokens.length;
1658         _allTokens.push(tokenId);
1659     }
1660 
1661     /**
1662      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1663      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1664      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1665      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1666      * @param from address representing the previous owner of the given token ID
1667      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1668      */
1669     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1670         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1671         // then delete the last slot (swap and pop).
1672 
1673         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1674         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1675 
1676         // When the token to delete is the last token, the swap operation is unnecessary
1677         if (tokenIndex != lastTokenIndex) {
1678             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1679 
1680             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1681             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1682         }
1683 
1684         // This also deletes the contents at the last position of the array
1685         delete _ownedTokensIndex[tokenId];
1686         delete _ownedTokens[from][lastTokenIndex];
1687     }
1688 
1689     /**
1690      * @dev Private function to remove a token from this extension's token tracking data structures.
1691      * This has O(1) time complexity, but alters the order of the _allTokens array.
1692      * @param tokenId uint256 ID of the token to be removed from the tokens list
1693      */
1694     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1695         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1696         // then delete the last slot (swap and pop).
1697 
1698         uint256 lastTokenIndex = _allTokens.length - 1;
1699         uint256 tokenIndex = _allTokensIndex[tokenId];
1700 
1701         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1702         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1703         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1704         uint256 lastTokenId = _allTokens[lastTokenIndex];
1705 
1706         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1707         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1708 
1709         // This also deletes the contents at the last position of the array
1710         delete _allTokensIndex[tokenId];
1711         _allTokens.pop();
1712     }
1713 }
1714 
1715 // File: @openzeppelin/contracts/access/AccessControl.sol
1716 
1717 
1718 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
1719 
1720 pragma solidity ^0.8.0;
1721 
1722 
1723 
1724 
1725 
1726 /**
1727  * @dev Contract module that allows children to implement role-based access
1728  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1729  * members except through off-chain means by accessing the contract event logs. Some
1730  * applications may benefit from on-chain enumerability, for those cases see
1731  * {AccessControlEnumerable}.
1732  *
1733  * Roles are referred to by their `bytes32` identifier. These should be exposed
1734  * in the external API and be unique. The best way to achieve this is by
1735  * using `public constant` hash digests:
1736  *
1737  * ```
1738  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1739  * ```
1740  *
1741  * Roles can be used to represent a set of permissions. To restrict access to a
1742  * function call, use {hasRole}:
1743  *
1744  * ```
1745  * function foo() public {
1746  *     require(hasRole(MY_ROLE, msg.sender));
1747  *     ...
1748  * }
1749  * ```
1750  *
1751  * Roles can be granted and revoked dynamically via the {grantRole} and
1752  * {revokeRole} functions. Each role has an associated admin role, and only
1753  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1754  *
1755  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1756  * that only accounts with this role will be able to grant or revoke other
1757  * roles. More complex role relationships can be created by using
1758  * {_setRoleAdmin}.
1759  *
1760  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1761  * grant and revoke this role. Extra precautions should be taken to secure
1762  * accounts that have been granted it.
1763  */
1764 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1765     struct RoleData {
1766         mapping(address => bool) members;
1767         bytes32 adminRole;
1768     }
1769 
1770     mapping(bytes32 => RoleData) private _roles;
1771 
1772     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1773 
1774     /**
1775      * @dev Modifier that checks that an account has a specific role. Reverts
1776      * with a standardized message including the required role.
1777      *
1778      * The format of the revert reason is given by the following regular expression:
1779      *
1780      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1781      *
1782      * _Available since v4.1._
1783      */
1784     modifier onlyRole(bytes32 role) {
1785         _checkRole(role, _msgSender());
1786         _;
1787     }
1788 
1789     /**
1790      * @dev See {IERC165-supportsInterface}.
1791      */
1792     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1793         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1794     }
1795 
1796     /**
1797      * @dev Returns `true` if `account` has been granted `role`.
1798      */
1799     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1800         return _roles[role].members[account];
1801     }
1802 
1803     /**
1804      * @dev Revert with a standard message if `account` is missing `role`.
1805      *
1806      * The format of the revert reason is given by the following regular expression:
1807      *
1808      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1809      */
1810     function _checkRole(bytes32 role, address account) internal view virtual {
1811         if (!hasRole(role, account)) {
1812             revert(
1813                 string(
1814                     abi.encodePacked(
1815                         "AccessControl: account ",
1816                         Strings.toHexString(uint160(account), 20),
1817                         " is missing role ",
1818                         Strings.toHexString(uint256(role), 32)
1819                     )
1820                 )
1821             );
1822         }
1823     }
1824 
1825     /**
1826      * @dev Returns the admin role that controls `role`. See {grantRole} and
1827      * {revokeRole}.
1828      *
1829      * To change a role's admin, use {_setRoleAdmin}.
1830      */
1831     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1832         return _roles[role].adminRole;
1833     }
1834 
1835     /**
1836      * @dev Grants `role` to `account`.
1837      *
1838      * If `account` had not been already granted `role`, emits a {RoleGranted}
1839      * event.
1840      *
1841      * Requirements:
1842      *
1843      * - the caller must have ``role``'s admin role.
1844      */
1845     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1846         _grantRole(role, account);
1847     }
1848 
1849     /**
1850      * @dev Revokes `role` from `account`.
1851      *
1852      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1853      *
1854      * Requirements:
1855      *
1856      * - the caller must have ``role``'s admin role.
1857      */
1858     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1859         _revokeRole(role, account);
1860     }
1861 
1862     /**
1863      * @dev Revokes `role` from the calling account.
1864      *
1865      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1866      * purpose is to provide a mechanism for accounts to lose their privileges
1867      * if they are compromised (such as when a trusted device is misplaced).
1868      *
1869      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1870      * event.
1871      *
1872      * Requirements:
1873      *
1874      * - the caller must be `account`.
1875      */
1876     function renounceRole(bytes32 role, address account) public virtual override {
1877         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1878 
1879         _revokeRole(role, account);
1880     }
1881 
1882     /**
1883      * @dev Grants `role` to `account`.
1884      *
1885      * If `account` had not been already granted `role`, emits a {RoleGranted}
1886      * event. Note that unlike {grantRole}, this function doesn't perform any
1887      * checks on the calling account.
1888      *
1889      * [WARNING]
1890      * ====
1891      * This function should only be called from the constructor when setting
1892      * up the initial roles for the system.
1893      *
1894      * Using this function in any other way is effectively circumventing the admin
1895      * system imposed by {AccessControl}.
1896      * ====
1897      *
1898      * NOTE: This function is deprecated in favor of {_grantRole}.
1899      */
1900     function _setupRole(bytes32 role, address account) internal virtual {
1901         _grantRole(role, account);
1902     }
1903 
1904     /**
1905      * @dev Sets `adminRole` as ``role``'s admin role.
1906      *
1907      * Emits a {RoleAdminChanged} event.
1908      */
1909     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1910         bytes32 previousAdminRole = getRoleAdmin(role);
1911         _roles[role].adminRole = adminRole;
1912         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1913     }
1914 
1915     /**
1916      * @dev Grants `role` to `account`.
1917      *
1918      * Internal function without access restriction.
1919      */
1920     function _grantRole(bytes32 role, address account) internal virtual {
1921         if (!hasRole(role, account)) {
1922             _roles[role].members[account] = true;
1923             emit RoleGranted(role, account, _msgSender());
1924         }
1925     }
1926 
1927     /**
1928      * @dev Revokes `role` from `account`.
1929      *
1930      * Internal function without access restriction.
1931      */
1932     function _revokeRole(bytes32 role, address account) internal virtual {
1933         if (hasRole(role, account)) {
1934             _roles[role].members[account] = false;
1935             emit RoleRevoked(role, account, _msgSender());
1936         }
1937     }
1938 }
1939 
1940 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
1941 
1942 
1943 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
1944 
1945 pragma solidity ^0.8.0;
1946 
1947 
1948 
1949 
1950 /**
1951  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1952  */
1953 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1954     using EnumerableSet for EnumerableSet.AddressSet;
1955 
1956     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1957 
1958     /**
1959      * @dev See {IERC165-supportsInterface}.
1960      */
1961     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1962         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
1963     }
1964 
1965     /**
1966      * @dev Returns one of the accounts that have `role`. `index` must be a
1967      * value between 0 and {getRoleMemberCount}, non-inclusive.
1968      *
1969      * Role bearers are not sorted in any particular way, and their ordering may
1970      * change at any point.
1971      *
1972      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1973      * you perform all queries on the same block. See the following
1974      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1975      * for more information.
1976      */
1977     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
1978         return _roleMembers[role].at(index);
1979     }
1980 
1981     /**
1982      * @dev Returns the number of accounts that have `role`. Can be used
1983      * together with {getRoleMember} to enumerate all bearers of a role.
1984      */
1985     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
1986         return _roleMembers[role].length();
1987     }
1988 
1989     /**
1990      * @dev Overload {_grantRole} to track enumerable memberships
1991      */
1992     function _grantRole(bytes32 role, address account) internal virtual override {
1993         super._grantRole(role, account);
1994         _roleMembers[role].add(account);
1995     }
1996 
1997     /**
1998      * @dev Overload {_revokeRole} to track enumerable memberships
1999      */
2000     function _revokeRole(bytes32 role, address account) internal virtual override {
2001         super._revokeRole(role, account);
2002         _roleMembers[role].remove(account);
2003     }
2004 }
2005 
2006 // File: @openzeppelin/contracts/security/Pausable.sol
2007 
2008 
2009 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
2010 
2011 pragma solidity ^0.8.0;
2012 
2013 
2014 /**
2015  * @dev Contract module which allows children to implement an emergency stop
2016  * mechanism that can be triggered by an authorized account.
2017  *
2018  * This module is used through inheritance. It will make available the
2019  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2020  * the functions of your contract. Note that they will not be pausable by
2021  * simply including this module, only once the modifiers are put in place.
2022  */
2023 abstract contract Pausable is Context {
2024     /**
2025      * @dev Emitted when the pause is triggered by `account`.
2026      */
2027     event Paused(address account);
2028 
2029     /**
2030      * @dev Emitted when the pause is lifted by `account`.
2031      */
2032     event Unpaused(address account);
2033 
2034     bool private _paused;
2035 
2036     /**
2037      * @dev Initializes the contract in unpaused state.
2038      */
2039     constructor() {
2040         _paused = false;
2041     }
2042 
2043     /**
2044      * @dev Returns true if the contract is paused, and false otherwise.
2045      */
2046     function paused() public view virtual returns (bool) {
2047         return _paused;
2048     }
2049 
2050     /**
2051      * @dev Modifier to make a function callable only when the contract is not paused.
2052      *
2053      * Requirements:
2054      *
2055      * - The contract must not be paused.
2056      */
2057     modifier whenNotPaused() {
2058         require(!paused(), "Pausable: paused");
2059         _;
2060     }
2061 
2062     /**
2063      * @dev Modifier to make a function callable only when the contract is paused.
2064      *
2065      * Requirements:
2066      *
2067      * - The contract must be paused.
2068      */
2069     modifier whenPaused() {
2070         require(paused(), "Pausable: not paused");
2071         _;
2072     }
2073 
2074     /**
2075      * @dev Triggers stopped state.
2076      *
2077      * Requirements:
2078      *
2079      * - The contract must not be paused.
2080      */
2081     function _pause() internal virtual whenNotPaused {
2082         _paused = true;
2083         emit Paused(_msgSender());
2084     }
2085 
2086     /**
2087      * @dev Returns to normal state.
2088      *
2089      * Requirements:
2090      *
2091      * - The contract must be paused.
2092      */
2093     function _unpause() internal virtual whenPaused {
2094         _paused = false;
2095         emit Unpaused(_msgSender());
2096     }
2097 }
2098 
2099 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2100 
2101 
2102 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
2103 
2104 pragma solidity ^0.8.0;
2105 
2106 /**
2107  * @dev Interface of the ERC20 standard as defined in the EIP.
2108  */
2109 interface IERC20 {
2110     /**
2111      * @dev Returns the amount of tokens in existence.
2112      */
2113     function totalSupply() external view returns (uint256);
2114 
2115     /**
2116      * @dev Returns the amount of tokens owned by `account`.
2117      */
2118     function balanceOf(address account) external view returns (uint256);
2119 
2120     /**
2121      * @dev Moves `amount` tokens from the caller's account to `to`.
2122      *
2123      * Returns a boolean value indicating whether the operation succeeded.
2124      *
2125      * Emits a {Transfer} event.
2126      */
2127     function transfer(address to, uint256 amount) external returns (bool);
2128 
2129     /**
2130      * @dev Returns the remaining number of tokens that `spender` will be
2131      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2132      * zero by default.
2133      *
2134      * This value changes when {approve} or {transferFrom} are called.
2135      */
2136     function allowance(address owner, address spender) external view returns (uint256);
2137 
2138     /**
2139      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2140      *
2141      * Returns a boolean value indicating whether the operation succeeded.
2142      *
2143      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2144      * that someone may use both the old and the new allowance by unfortunate
2145      * transaction ordering. One possible solution to mitigate this race
2146      * condition is to first reduce the spender's allowance to 0 and set the
2147      * desired value afterwards:
2148      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2149      *
2150      * Emits an {Approval} event.
2151      */
2152     function approve(address spender, uint256 amount) external returns (bool);
2153 
2154     /**
2155      * @dev Moves `amount` tokens from `from` to `to` using the
2156      * allowance mechanism. `amount` is then deducted from the caller's
2157      * allowance.
2158      *
2159      * Returns a boolean value indicating whether the operation succeeded.
2160      *
2161      * Emits a {Transfer} event.
2162      */
2163     function transferFrom(
2164         address from,
2165         address to,
2166         uint256 amount
2167     ) external returns (bool);
2168 
2169     /**
2170      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2171      * another (`to`).
2172      *
2173      * Note that `value` may be zero.
2174      */
2175     event Transfer(address indexed from, address indexed to, uint256 value);
2176 
2177     /**
2178      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2179      * a call to {approve}. `value` is the new allowance.
2180      */
2181     event Approval(address indexed owner, address indexed spender, uint256 value);
2182 }
2183 
2184 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
2185 
2186 
2187 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
2188 
2189 pragma solidity ^0.8.0;
2190 
2191 
2192 /**
2193  * @dev Interface for the optional metadata functions from the ERC20 standard.
2194  *
2195  * _Available since v4.1._
2196  */
2197 interface IERC20Metadata is IERC20 {
2198     /**
2199      * @dev Returns the name of the token.
2200      */
2201     function name() external view returns (string memory);
2202 
2203     /**
2204      * @dev Returns the symbol of the token.
2205      */
2206     function symbol() external view returns (string memory);
2207 
2208     /**
2209      * @dev Returns the decimals places of the token.
2210      */
2211     function decimals() external view returns (uint8);
2212 }
2213 
2214 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
2215 
2216 
2217 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
2218 
2219 pragma solidity ^0.8.0;
2220 
2221 
2222 
2223 
2224 /**
2225  * @dev Implementation of the {IERC20} interface.
2226  *
2227  * This implementation is agnostic to the way tokens are created. This means
2228  * that a supply mechanism has to be added in a derived contract using {_mint}.
2229  * For a generic mechanism see {ERC20PresetMinterPauser}.
2230  *
2231  * TIP: For a detailed writeup see our guide
2232  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
2233  * to implement supply mechanisms].
2234  *
2235  * We have followed general OpenZeppelin Contracts guidelines: functions revert
2236  * instead returning `false` on failure. This behavior is nonetheless
2237  * conventional and does not conflict with the expectations of ERC20
2238  * applications.
2239  *
2240  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2241  * This allows applications to reconstruct the allowance for all accounts just
2242  * by listening to said events. Other implementations of the EIP may not emit
2243  * these events, as it isn't required by the specification.
2244  *
2245  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2246  * functions have been added to mitigate the well-known issues around setting
2247  * allowances. See {IERC20-approve}.
2248  */
2249 contract ERC20 is Context, IERC20, IERC20Metadata {
2250     mapping(address => uint256) private _balances;
2251 
2252     mapping(address => mapping(address => uint256)) private _allowances;
2253 
2254     uint256 private _totalSupply;
2255 
2256     string private _name;
2257     string private _symbol;
2258 
2259     /**
2260      * @dev Sets the values for {name} and {symbol}.
2261      *
2262      * The default value of {decimals} is 18. To select a different value for
2263      * {decimals} you should overload it.
2264      *
2265      * All two of these values are immutable: they can only be set once during
2266      * construction.
2267      */
2268     constructor(string memory name_, string memory symbol_) {
2269         _name = name_;
2270         _symbol = symbol_;
2271     }
2272 
2273     /**
2274      * @dev Returns the name of the token.
2275      */
2276     function name() public view virtual override returns (string memory) {
2277         return _name;
2278     }
2279 
2280     /**
2281      * @dev Returns the symbol of the token, usually a shorter version of the
2282      * name.
2283      */
2284     function symbol() public view virtual override returns (string memory) {
2285         return _symbol;
2286     }
2287 
2288     /**
2289      * @dev Returns the number of decimals used to get its user representation.
2290      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2291      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
2292      *
2293      * Tokens usually opt for a value of 18, imitating the relationship between
2294      * Ether and Wei. This is the value {ERC20} uses, unless this function is
2295      * overridden;
2296      *
2297      * NOTE: This information is only used for _display_ purposes: it in
2298      * no way affects any of the arithmetic of the contract, including
2299      * {IERC20-balanceOf} and {IERC20-transfer}.
2300      */
2301     function decimals() public view virtual override returns (uint8) {
2302         return 18;
2303     }
2304 
2305     /**
2306      * @dev See {IERC20-totalSupply}.
2307      */
2308     function totalSupply() public view virtual override returns (uint256) {
2309         return _totalSupply;
2310     }
2311 
2312     /**
2313      * @dev See {IERC20-balanceOf}.
2314      */
2315     function balanceOf(address account) public view virtual override returns (uint256) {
2316         return _balances[account];
2317     }
2318 
2319     /**
2320      * @dev See {IERC20-transfer}.
2321      *
2322      * Requirements:
2323      *
2324      * - `to` cannot be the zero address.
2325      * - the caller must have a balance of at least `amount`.
2326      */
2327     function transfer(address to, uint256 amount) public virtual override returns (bool) {
2328         address owner = _msgSender();
2329         _transfer(owner, to, amount);
2330         return true;
2331     }
2332 
2333     /**
2334      * @dev See {IERC20-allowance}.
2335      */
2336     function allowance(address owner, address spender) public view virtual override returns (uint256) {
2337         return _allowances[owner][spender];
2338     }
2339 
2340     /**
2341      * @dev See {IERC20-approve}.
2342      *
2343      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
2344      * `transferFrom`. This is semantically equivalent to an infinite approval.
2345      *
2346      * Requirements:
2347      *
2348      * - `spender` cannot be the zero address.
2349      */
2350     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2351         address owner = _msgSender();
2352         _approve(owner, spender, amount);
2353         return true;
2354     }
2355 
2356     /**
2357      * @dev See {IERC20-transferFrom}.
2358      *
2359      * Emits an {Approval} event indicating the updated allowance. This is not
2360      * required by the EIP. See the note at the beginning of {ERC20}.
2361      *
2362      * NOTE: Does not update the allowance if the current allowance
2363      * is the maximum `uint256`.
2364      *
2365      * Requirements:
2366      *
2367      * - `from` and `to` cannot be the zero address.
2368      * - `from` must have a balance of at least `amount`.
2369      * - the caller must have allowance for ``from``'s tokens of at least
2370      * `amount`.
2371      */
2372     function transferFrom(
2373         address from,
2374         address to,
2375         uint256 amount
2376     ) public virtual override returns (bool) {
2377         address spender = _msgSender();
2378         _spendAllowance(from, spender, amount);
2379         _transfer(from, to, amount);
2380         return true;
2381     }
2382 
2383     /**
2384      * @dev Atomically increases the allowance granted to `spender` by the caller.
2385      *
2386      * This is an alternative to {approve} that can be used as a mitigation for
2387      * problems described in {IERC20-approve}.
2388      *
2389      * Emits an {Approval} event indicating the updated allowance.
2390      *
2391      * Requirements:
2392      *
2393      * - `spender` cannot be the zero address.
2394      */
2395     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2396         address owner = _msgSender();
2397         _approve(owner, spender, _allowances[owner][spender] + addedValue);
2398         return true;
2399     }
2400 
2401     /**
2402      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2403      *
2404      * This is an alternative to {approve} that can be used as a mitigation for
2405      * problems described in {IERC20-approve}.
2406      *
2407      * Emits an {Approval} event indicating the updated allowance.
2408      *
2409      * Requirements:
2410      *
2411      * - `spender` cannot be the zero address.
2412      * - `spender` must have allowance for the caller of at least
2413      * `subtractedValue`.
2414      */
2415     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2416         address owner = _msgSender();
2417         uint256 currentAllowance = _allowances[owner][spender];
2418         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
2419         unchecked {
2420             _approve(owner, spender, currentAllowance - subtractedValue);
2421         }
2422 
2423         return true;
2424     }
2425 
2426     /**
2427      * @dev Moves `amount` of tokens from `sender` to `recipient`.
2428      *
2429      * This internal function is equivalent to {transfer}, and can be used to
2430      * e.g. implement automatic token fees, slashing mechanisms, etc.
2431      *
2432      * Emits a {Transfer} event.
2433      *
2434      * Requirements:
2435      *
2436      * - `from` cannot be the zero address.
2437      * - `to` cannot be the zero address.
2438      * - `from` must have a balance of at least `amount`.
2439      */
2440     function _transfer(
2441         address from,
2442         address to,
2443         uint256 amount
2444     ) internal virtual {
2445         require(from != address(0), "ERC20: transfer from the zero address");
2446         require(to != address(0), "ERC20: transfer to the zero address");
2447 
2448         _beforeTokenTransfer(from, to, amount);
2449 
2450         uint256 fromBalance = _balances[from];
2451         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
2452         unchecked {
2453             _balances[from] = fromBalance - amount;
2454         }
2455         _balances[to] += amount;
2456 
2457         emit Transfer(from, to, amount);
2458 
2459         _afterTokenTransfer(from, to, amount);
2460     }
2461 
2462     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2463      * the total supply.
2464      *
2465      * Emits a {Transfer} event with `from` set to the zero address.
2466      *
2467      * Requirements:
2468      *
2469      * - `account` cannot be the zero address.
2470      */
2471     function _mint(address account, uint256 amount) internal virtual {
2472         require(account != address(0), "ERC20: mint to the zero address");
2473 
2474         _beforeTokenTransfer(address(0), account, amount);
2475 
2476         _totalSupply += amount;
2477         _balances[account] += amount;
2478         emit Transfer(address(0), account, amount);
2479 
2480         _afterTokenTransfer(address(0), account, amount);
2481     }
2482 
2483     /**
2484      * @dev Destroys `amount` tokens from `account`, reducing the
2485      * total supply.
2486      *
2487      * Emits a {Transfer} event with `to` set to the zero address.
2488      *
2489      * Requirements:
2490      *
2491      * - `account` cannot be the zero address.
2492      * - `account` must have at least `amount` tokens.
2493      */
2494     function _burn(address account, uint256 amount) internal virtual {
2495         require(account != address(0), "ERC20: burn from the zero address");
2496 
2497         _beforeTokenTransfer(account, address(0), amount);
2498 
2499         uint256 accountBalance = _balances[account];
2500         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
2501         unchecked {
2502             _balances[account] = accountBalance - amount;
2503         }
2504         _totalSupply -= amount;
2505 
2506         emit Transfer(account, address(0), amount);
2507 
2508         _afterTokenTransfer(account, address(0), amount);
2509     }
2510 
2511     /**
2512      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2513      *
2514      * This internal function is equivalent to `approve`, and can be used to
2515      * e.g. set automatic allowances for certain subsystems, etc.
2516      *
2517      * Emits an {Approval} event.
2518      *
2519      * Requirements:
2520      *
2521      * - `owner` cannot be the zero address.
2522      * - `spender` cannot be the zero address.
2523      */
2524     function _approve(
2525         address owner,
2526         address spender,
2527         uint256 amount
2528     ) internal virtual {
2529         require(owner != address(0), "ERC20: approve from the zero address");
2530         require(spender != address(0), "ERC20: approve to the zero address");
2531 
2532         _allowances[owner][spender] = amount;
2533         emit Approval(owner, spender, amount);
2534     }
2535 
2536     /**
2537      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
2538      *
2539      * Does not update the allowance amount in case of infinite allowance.
2540      * Revert if not enough allowance is available.
2541      *
2542      * Might emit an {Approval} event.
2543      */
2544     function _spendAllowance(
2545         address owner,
2546         address spender,
2547         uint256 amount
2548     ) internal virtual {
2549         uint256 currentAllowance = allowance(owner, spender);
2550         if (currentAllowance != type(uint256).max) {
2551             require(currentAllowance >= amount, "ERC20: insufficient allowance");
2552             unchecked {
2553                 _approve(owner, spender, currentAllowance - amount);
2554             }
2555         }
2556     }
2557 
2558     /**
2559      * @dev Hook that is called before any transfer of tokens. This includes
2560      * minting and burning.
2561      *
2562      * Calling conditions:
2563      *
2564      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2565      * will be transferred to `to`.
2566      * - when `from` is zero, `amount` tokens will be minted for `to`.
2567      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2568      * - `from` and `to` are never both zero.
2569      *
2570      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2571      */
2572     function _beforeTokenTransfer(
2573         address from,
2574         address to,
2575         uint256 amount
2576     ) internal virtual {}
2577 
2578     /**
2579      * @dev Hook that is called after any transfer of tokens. This includes
2580      * minting and burning.
2581      *
2582      * Calling conditions:
2583      *
2584      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2585      * has been transferred to `to`.
2586      * - when `from` is zero, `amount` tokens have been minted for `to`.
2587      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2588      * - `from` and `to` are never both zero.
2589      *
2590      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2591      */
2592     function _afterTokenTransfer(
2593         address from,
2594         address to,
2595         uint256 amount
2596     ) internal virtual {}
2597 }
2598 
2599 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol
2600 
2601 
2602 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Pausable.sol)
2603 
2604 pragma solidity ^0.8.0;
2605 
2606 
2607 
2608 /**
2609  * @dev ERC20 token with pausable token transfers, minting and burning.
2610  *
2611  * Useful for scenarios such as preventing trades until the end of an evaluation
2612  * period, or having an emergency switch for freezing all token transfers in the
2613  * event of a large bug.
2614  */
2615 abstract contract ERC20Pausable is ERC20, Pausable {
2616     /**
2617      * @dev See {ERC20-_beforeTokenTransfer}.
2618      *
2619      * Requirements:
2620      *
2621      * - the contract must not be paused.
2622      */
2623     function _beforeTokenTransfer(
2624         address from,
2625         address to,
2626         uint256 amount
2627     ) internal virtual override {
2628         super._beforeTokenTransfer(from, to, amount);
2629 
2630         require(!paused(), "ERC20Pausable: token transfer while paused");
2631     }
2632 }
2633 
2634 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
2635 
2636 
2637 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
2638 
2639 pragma solidity ^0.8.0;
2640 
2641 
2642 
2643 /**
2644  * @dev Extension of {ERC20} that allows token holders to destroy both their own
2645  * tokens and those that they have an allowance for, in a way that can be
2646  * recognized off-chain (via event analysis).
2647  */
2648 abstract contract ERC20Burnable is Context, ERC20 {
2649     /**
2650      * @dev Destroys `amount` tokens from the caller.
2651      *
2652      * See {ERC20-_burn}.
2653      */
2654     function burn(uint256 amount) public virtual {
2655         _burn(_msgSender(), amount);
2656     }
2657 
2658     /**
2659      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
2660      * allowance.
2661      *
2662      * See {ERC20-_burn} and {ERC20-allowance}.
2663      *
2664      * Requirements:
2665      *
2666      * - the caller must have allowance for ``accounts``'s tokens of at least
2667      * `amount`.
2668      */
2669     function burnFrom(address account, uint256 amount) public virtual {
2670         _spendAllowance(account, _msgSender(), amount);
2671         _burn(account, amount);
2672     }
2673 }
2674 
2675 // File: @openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol
2676 
2677 
2678 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/presets/ERC20PresetMinterPauser.sol)
2679 
2680 pragma solidity ^0.8.0;
2681 
2682 
2683 
2684 
2685 
2686 
2687 /**
2688  * @dev {ERC20} token, including:
2689  *
2690  *  - ability for holders to burn (destroy) their tokens
2691  *  - a minter role that allows for token minting (creation)
2692  *  - a pauser role that allows to stop all token transfers
2693  *
2694  * This contract uses {AccessControl} to lock permissioned functions using the
2695  * different roles - head to its documentation for details.
2696  *
2697  * The account that deploys the contract will be granted the minter and pauser
2698  * roles, as well as the default admin role, which will let it grant both minter
2699  * and pauser roles to other accounts.
2700  *
2701  * _Deprecated in favor of https://wizard.openzeppelin.com/[Contracts Wizard]._
2702  */
2703 contract ERC20PresetMinterPauser is Context, AccessControlEnumerable, ERC20Burnable, ERC20Pausable {
2704     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2705     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
2706 
2707     /**
2708      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
2709      * account that deploys the contract.
2710      *
2711      * See {ERC20-constructor}.
2712      */
2713     constructor(string memory name, string memory symbol) ERC20(name, symbol) {
2714         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2715 
2716         _setupRole(MINTER_ROLE, _msgSender());
2717         _setupRole(PAUSER_ROLE, _msgSender());
2718     }
2719 
2720     /**
2721      * @dev Creates `amount` new tokens for `to`.
2722      *
2723      * See {ERC20-_mint}.
2724      *
2725      * Requirements:
2726      *
2727      * - the caller must have the `MINTER_ROLE`.
2728      */
2729     function mint(address to, uint256 amount) public virtual {
2730         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
2731         _mint(to, amount);
2732     }
2733 
2734     /**
2735      * @dev Pauses all token transfers.
2736      *
2737      * See {ERC20Pausable} and {Pausable-_pause}.
2738      *
2739      * Requirements:
2740      *
2741      * - the caller must have the `PAUSER_ROLE`.
2742      */
2743     function pause() public virtual {
2744         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
2745         _pause();
2746     }
2747 
2748     /**
2749      * @dev Unpauses all token transfers.
2750      *
2751      * See {ERC20Pausable} and {Pausable-_unpause}.
2752      *
2753      * Requirements:
2754      *
2755      * - the caller must have the `PAUSER_ROLE`.
2756      */
2757     function unpause() public virtual {
2758         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
2759         _unpause();
2760     }
2761 
2762     function _beforeTokenTransfer(
2763         address from,
2764         address to,
2765         uint256 amount
2766     ) internal virtual override(ERC20, ERC20Pausable) {
2767         super._beforeTokenTransfer(from, to, amount);
2768     }
2769 }
2770 
2771 // File: JBACCOIN.sol
2772 
2773 pragma solidity ^0.8.0;
2774 
2775 
2776 
2777 /**
2778  * @title JBAC Token (The native ecosystem token of Jungle Bay Ape Club)
2779  * @dev Extends standard ERC20 contract from OpenZeppelin
2780  */
2781 contract JBACCOIN is ERC20PresetMinterPauser("Jungle Bay Ape Club", "JBAC") {
2782     /// @notice JBAC tokens claimable per day for each Jungle Bay NFT holder
2783     uint256 public constant EMISSION_PER_DAY = 33.30000e18; // ~33.3 JBAC
2784 
2785     /// @notice Start timestamp from contract deployment
2786     uint256 public immutable emissionStart;
2787 
2788     /// @notice End date for JBAC emissions to Jungle Bay NFT holders
2789     uint256 public immutable emissionEnd;
2790 
2791     /// @dev A record of last claimed timestamp for Jungle Bay NFTs
2792     mapping(uint256 => uint256) private _lastClaim;
2793 
2794     /// @dev Contract address for Jungle Bay NFT
2795     address private _nftAddress;
2796 
2797     /// @dev Contract address for Gold Card NFT
2798     address private _nftGoldAddress;
2799 
2800     /**
2801      * @notice Construct the JBAC token
2802      * @param emissionStartTimestamp Timestamp of deployment
2803      */
2804     constructor(uint256 emissionStartTimestamp) {
2805         emissionStart = emissionStartTimestamp;
2806         emissionEnd = emissionStartTimestamp + (1 days * 365 * 3);
2807     }
2808 
2809     // External functions
2810 
2811     /**
2812      * @notice Sets the contract address to jungle bay GOLDCARDs upon deployment
2813      * @param nftGoldAddress Address of verified jungle bay GOLDCARD contract
2814      * @dev Only callable once
2815      */
2816     function setNFTGoldAddress(address nftGoldAddress) external onlyRole(DEFAULT_ADMIN_ROLE) {
2817         require(_nftGoldAddress == address(0), "Already set");
2818         _nftGoldAddress = nftGoldAddress;
2819     }
2820 
2821     /**
2822      * @notice Sets the contract address to jungle bay NFTs upon deployment
2823      * @param nftAddress Address of verified jungle bay NFT contract
2824      * @dev Only callable once
2825      */
2826     function setNFTAddress(address nftAddress) external onlyRole(DEFAULT_ADMIN_ROLE) {
2827         require(_nftAddress == address(0), "Already set");
2828         _nftAddress = nftAddress;
2829     }
2830 
2831     // Public functions
2832 
2833     /**
2834      * @notice Check last claim timestamp of accumulated JBAC for given Jungle Bay NFT
2835      * @param tokenIndex Index of Jungle Bay NFT to check
2836      * @return Last claim timestamp
2837      */
2838     function getLastClaim(uint256 tokenIndex) public view returns (uint256) {
2839         require(tokenIndex <= ERC721Enumerable(_nftAddress).totalSupply(), "NFT at index not been minted");
2840         require(ERC721Enumerable(_nftAddress).ownerOf(tokenIndex) != address(0), "Owner cannot be 0 address");
2841         uint256 lastClaimed = uint256(_lastClaim[tokenIndex]) != 0 ? uint256(_lastClaim[tokenIndex]) : emissionStart;
2842         return lastClaimed;
2843     }
2844 
2845     /**
2846      * @notice Check accumulated JBAC tokens for a Jungle Bay NFT
2847      * @param tokenIndex Index of Jungle Bay NFT to check balance
2848      * @return Total JBAC accumulated and ready to claim
2849      */
2850     function accumulated(uint256 tokenIndex, uint256 multiplier) public view returns (uint256) {
2851         require(block.timestamp > emissionStart, "Emission has not started yet");
2852 
2853         uint256 lastClaimed = getLastClaim(tokenIndex);
2854         // Sanity check if last claim was on or after emission end
2855         if (lastClaimed >= emissionEnd) return 0;
2856 
2857         uint256 accumulationPeriod = block.timestamp < emissionEnd ? block.timestamp : emissionEnd; // Getting the min value of both
2858         uint256 totalAccumulated = ((accumulationPeriod - lastClaimed) * EMISSION_PER_DAY) / 1 days;
2859 
2860         return totalAccumulated * multiplier / 100;
2861     }
2862 
2863     /**
2864      * @notice Check total accumulated JBAC tokens for all Jungle Bay NFTs
2865      * @param tokenIndices Indexes of NFTs to check balance
2866      * @return Total JBAC accumulated and ready to claim
2867      */
2868     function accumulatedMultiCheck(uint256[] memory tokenIndices, uint256 multiplier) public view returns (uint256) {
2869         require(block.timestamp > emissionStart, "Emission has not started yet");
2870         uint256 totalClaimableQty = 0;
2871         for (uint256 i = 0; i < tokenIndices.length; i++) {
2872             uint256 tokenIndex = tokenIndices[i];
2873             // Sanity check for non-minted index
2874             require(tokenIndex <= ERC721Enumerable(_nftAddress).totalSupply(), "NFT at index not been minted");
2875             uint256 claimableQty = accumulated(tokenIndex, multiplier);
2876             totalClaimableQty = totalClaimableQty + claimableQty;
2877         }
2878         return totalClaimableQty;
2879     }
2880 
2881     /**
2882      * @notice Mint and claim available JBAC for each Jungle Bay NFT
2883      * @param tokenIndices Indexes of NFTs to claim for
2884      * @return Total JBAC claimed
2885      */
2886     function claim(uint256[] memory tokenIndices, uint256[] memory goldTokens) public returns (uint256) {
2887         require(block.timestamp > emissionStart, "Emission has not started yet");
2888 
2889         //we need to calculate the multiplier
2890         uint256 multiplier = 100;
2891         for (uint256 i = 0; i < goldTokens.length; i++) {
2892             // Sanity check for non-minted index
2893             require(goldTokens[i] <= ERC721Enumerable(_nftGoldAddress).totalSupply(), "GoldToken at index not been minted");
2894 
2895             // Duplicate token index check
2896             for (uint256 j = i + 1; j < goldTokens.length; j++) {
2897                 require(goldTokens[i] != goldTokens[j], "Duplicate goldtoken index");
2898             }
2899 
2900             uint256 goldIndex = goldTokens[i];
2901 
2902             require(ERC721Enumerable(_nftGoldAddress).ownerOf(goldIndex) == _msgSender(), "Sender is not the owner of goldtoken");
2903             multiplier = multiplier + 50;
2904         }
2905 
2906         uint256 totalClaimQty = 0;
2907         for (uint256 i = 0; i < tokenIndices.length; i++) {
2908             // Sanity check for non-minted index
2909             require(tokenIndices[i] <= ERC721Enumerable(_nftAddress).totalSupply(), "NFT at index not been minted");
2910             // Duplicate token index check
2911             for (uint256 j = i + 1; j < tokenIndices.length; j++) {
2912                 require(tokenIndices[i] != tokenIndices[j], "Duplicate token index");
2913             }
2914 
2915             uint256 tokenIndex = tokenIndices[i];
2916             require(ERC721Enumerable(_nftAddress).ownerOf(tokenIndex) == _msgSender(), "Sender is not the owner of nft");
2917 
2918             uint256 claimQty = accumulated(tokenIndex, multiplier);
2919             if (claimQty != 0) {
2920                 totalClaimQty = totalClaimQty + claimQty;
2921                 _lastClaim[tokenIndex] = block.timestamp;
2922             }
2923         }
2924 
2925         require(totalClaimQty != 0, "No accumulated JBAC");
2926         _mint(_msgSender(), totalClaimQty);
2927         return totalClaimQty;
2928     }
2929 }