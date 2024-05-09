1 // SPDX-License-Identifier: MIT
2 /* First satirical on-chain generative text NFT about NFT firsts.
3    Don't sleep on this historic collection.
4    
5    0xdeafbeef 2021-09-06
6 */
7 
8 
9 /**
10  * @dev Library for managing
11  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
12  * types.
13  *
14  * Sets have the following properties:
15  *
16  * - Elements are added, removed, and checked for existence in constant time
17  * (O(1)).
18  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
19  *
20  * ```
21  * contract Example {
22  *     // Add the library methods
23  *     using EnumerableSet for EnumerableSet.AddressSet;
24  *
25  *     // Declare a set state variable
26  *     EnumerableSet.AddressSet private mySet;
27  * }
28  * ```
29  *
30  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
31  * and `uint256` (`UintSet`) are supported.
32  */
33 library EnumerableSet {
34     // To implement this library for multiple types with as little code
35     // repetition as possible, we write it in terms of a generic Set type with
36     // bytes32 values.
37     // The Set implementation uses private functions, and user-facing
38     // implementations (such as AddressSet) are just wrappers around the
39     // underlying Set.
40     // This means that we can only create new EnumerableSets for types that fit
41     // in bytes32.
42 
43     struct Set {
44         // Storage of set values
45         bytes32[] _values;
46 
47         // Position of the value in the `values` array, plus 1 because index 0
48         // means a value is not in the set.
49         mapping (bytes32 => uint256) _indexes;
50     }
51 
52     /**
53      * @dev Add a value to a set. O(1).
54      *
55      * Returns true if the value was added to the set, that is if it was not
56      * already present.
57      */
58     function _add(Set storage set, bytes32 value) private returns (bool) {
59         if (!_contains(set, value)) {
60             set._values.push(value);
61             // The value is stored at length-1, but we add 1 to all indexes
62             // and use 0 as a sentinel value
63             set._indexes[value] = set._values.length;
64             return true;
65         } else {
66             return false;
67         }
68     }
69 
70     /**
71      * @dev Removes a value from a set. O(1).
72      *
73      * Returns true if the value was removed from the set, that is if it was
74      * present.
75      */
76     function _remove(Set storage set, bytes32 value) private returns (bool) {
77         // We read and store the value's index to prevent multiple reads from the same storage slot
78         uint256 valueIndex = set._indexes[value];
79 
80         if (valueIndex != 0) { // Equivalent to contains(set, value)
81             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
82             // the array, and then remove the last element (sometimes called as 'swap and pop').
83             // This modifies the order of the array, as noted in {at}.
84 
85             uint256 toDeleteIndex = valueIndex - 1;
86             uint256 lastIndex = set._values.length - 1;
87 
88             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
89             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
90 
91             bytes32 lastvalue = set._values[lastIndex];
92 
93             // Move the last value to the index where the value to delete is
94             set._values[toDeleteIndex] = lastvalue;
95             // Update the index for the moved value
96             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
97 
98             // Delete the slot where the moved value was stored
99             set._values.pop();
100 
101             // Delete the index for the deleted slot
102             delete set._indexes[value];
103 
104             return true;
105         } else {
106             return false;
107         }
108     }
109 
110     /**
111      * @dev Returns true if the value is in the set. O(1).
112      */
113     function _contains(Set storage set, bytes32 value) private view returns (bool) {
114         return set._indexes[value] != 0;
115     }
116 
117     /**
118      * @dev Returns the number of values on the set. O(1).
119      */
120     function _length(Set storage set) private view returns (uint256) {
121         return set._values.length;
122     }
123 
124    /**
125     * @dev Returns the value stored at position `index` in the set. O(1).
126     *
127     * Note that there are no guarantees on the ordering of values inside the
128     * array, and it may change when more values are added or removed.
129     *
130     * Requirements:
131     *
132     * - `index` must be strictly less than {length}.
133     */
134     function _at(Set storage set, uint256 index) private view returns (bytes32) {
135         require(set._values.length > index, "EnumerableSet: index out of bounds");
136         return set._values[index];
137     }
138 
139     // Bytes32Set
140 
141     struct Bytes32Set {
142         Set _inner;
143     }
144 
145     /**
146      * @dev Add a value to a set. O(1).
147      *
148      * Returns true if the value was added to the set, that is if it was not
149      * already present.
150      */
151     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
152         return _add(set._inner, value);
153     }
154 
155     /**
156      * @dev Removes a value from a set. O(1).
157      *
158      * Returns true if the value was removed from the set, that is if it was
159      * present.
160      */
161     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
162         return _remove(set._inner, value);
163     }
164 
165     /**
166      * @dev Returns true if the value is in the set. O(1).
167      */
168     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
169         return _contains(set._inner, value);
170     }
171 
172     /**
173      * @dev Returns the number of values in the set. O(1).
174      */
175     function length(Bytes32Set storage set) internal view returns (uint256) {
176         return _length(set._inner);
177     }
178 
179    /**
180     * @dev Returns the value stored at position `index` in the set. O(1).
181     *
182     * Note that there are no guarantees on the ordering of values inside the
183     * array, and it may change when more values are added or removed.
184     *
185     * Requirements:
186     *
187     * - `index` must be strictly less than {length}.
188     */
189     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
190         return _at(set._inner, index);
191     }
192 
193     // AddressSet
194 
195     struct AddressSet {
196         Set _inner;
197     }
198 
199     /**
200      * @dev Add a value to a set. O(1).
201      *
202      * Returns true if the value was added to the set, that is if it was not
203      * already present.
204      */
205     function add(AddressSet storage set, address value) internal returns (bool) {
206         return _add(set._inner, bytes32(uint256(uint160(value))));
207     }
208 
209     /**
210      * @dev Removes a value from a set. O(1).
211      *
212      * Returns true if the value was removed from the set, that is if it was
213      * present.
214      */
215     function remove(AddressSet storage set, address value) internal returns (bool) {
216         return _remove(set._inner, bytes32(uint256(uint160(value))));
217     }
218 
219     /**
220      * @dev Returns true if the value is in the set. O(1).
221      */
222     function contains(AddressSet storage set, address value) internal view returns (bool) {
223         return _contains(set._inner, bytes32(uint256(uint160(value))));
224     }
225 
226     /**
227      * @dev Returns the number of values in the set. O(1).
228      */
229     function length(AddressSet storage set) internal view returns (uint256) {
230         return _length(set._inner);
231     }
232 
233    /**
234     * @dev Returns the value stored at position `index` in the set. O(1).
235     *
236     * Note that there are no guarantees on the ordering of values inside the
237     * array, and it may change when more values are added or removed.
238     *
239     * Requirements:
240     *
241     * - `index` must be strictly less than {length}.
242     */
243     function at(AddressSet storage set, uint256 index) internal view returns (address) {
244         return address(uint160(uint256(_at(set._inner, index))));
245     }
246 
247 
248     // UintSet
249 
250     struct UintSet {
251         Set _inner;
252     }
253 
254     /**
255      * @dev Add a value to a set. O(1).
256      *
257      * Returns true if the value was added to the set, that is if it was not
258      * already present.
259      */
260     function add(UintSet storage set, uint256 value) internal returns (bool) {
261         return _add(set._inner, bytes32(value));
262     }
263 
264     /**
265      * @dev Removes a value from a set. O(1).
266      *
267      * Returns true if the value was removed from the set, that is if it was
268      * present.
269      */
270     function remove(UintSet storage set, uint256 value) internal returns (bool) {
271         return _remove(set._inner, bytes32(value));
272     }
273 
274     /**
275      * @dev Returns true if the value is in the set. O(1).
276      */
277     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
278         return _contains(set._inner, bytes32(value));
279     }
280 
281     /**
282      * @dev Returns the number of values on the set. O(1).
283      */
284     function length(UintSet storage set) internal view returns (uint256) {
285         return _length(set._inner);
286     }
287 
288    /**
289     * @dev Returns the value stored at position `index` in the set. O(1).
290     *
291     * Note that there are no guarantees on the ordering of values inside the
292     * array, and it may change when more values are added or removed.
293     *
294     * Requirements:
295     *
296     * - `index` must be strictly less than {length}.
297     */
298     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
299         return uint256(_at(set._inner, index));
300     }
301 }
302 
303 pragma solidity >=0.6.2 <0.8.0;
304 
305 /**
306  * @dev Collection of functions related to the address type
307  */
308 library Address {
309     /**
310      * @dev Returns true if `account` is a contract.
311      *
312      * [IMPORTANT]
313      * ====
314      * It is unsafe to assume that an address for which this function returns
315      * false is an externally-owned account (EOA) and not a contract.
316      *
317      * Among others, `isContract` will return false for the following
318      * types of addresses:
319      *
320      *  - an externally-owned account
321      *  - a contract in construction
322      *  - an address where a contract will be created
323      *  - an address where a contract lived, but was destroyed
324      * ====
325      */
326     function isContract(address account) internal view returns (bool) {
327         // This method relies on extcodesize, which returns 0 for contracts in
328         // construction, since the code is only stored at the end of the
329         // constructor execution.
330 
331         uint256 size;
332         // solhint-disable-next-line no-inline-assembly
333         assembly { size := extcodesize(account) }
334         return size > 0;
335     }
336 
337     /**
338      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
339      * `recipient`, forwarding all available gas and reverting on errors.
340      *
341      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
342      * of certain opcodes, possibly making contracts go over the 2300 gas limit
343      * imposed by `transfer`, making them unable to receive funds via
344      * `transfer`. {sendValue} removes this limitation.
345      *
346      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
347      *
348      * IMPORTANT: because control is transferred to `recipient`, care must be
349      * taken to not create reentrancy vulnerabilities. Consider using
350      * {ReentrancyGuard} or the
351      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
352      */
353     function sendValue(address payable recipient, uint256 amount) internal {
354         require(address(this).balance >= amount, "Address: insufficient balance");
355 
356         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
357         (bool success, ) = recipient.call{ value: amount }("");
358         require(success, "Address: unable to send value, recipient may have reverted");
359     }
360 
361     /**
362      * @dev Performs a Solidity function call using a low level `call`. A
363      * plain`call` is an unsafe replacement for a function call: use this
364      * function instead.
365      *
366      * If `target` reverts with a revert reason, it is bubbled up by this
367      * function (like regular Solidity function calls).
368      *
369      * Returns the raw returned data. To convert to the expected return value,
370      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
371      *
372      * Requirements:
373      *
374      * - `target` must be a contract.
375      * - calling `target` with `data` must not revert.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
380       return functionCall(target, data, "Address: low-level call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
385      * `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, 0, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but also transferring `value` wei to `target`.
396      *
397      * Requirements:
398      *
399      * - the calling contract must have an ETH balance of at least `value`.
400      * - the called Solidity function must be `payable`.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
410      * with `errorMessage` as a fallback revert reason when `target` reverts.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
415         require(address(this).balance >= value, "Address: insufficient balance for call");
416         require(isContract(target), "Address: call to non-contract");
417 
418         // solhint-disable-next-line avoid-low-level-calls
419         (bool success, bytes memory returndata) = target.call{ value: value }(data);
420         return _verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a static call.
426      *
427      * _Available since v3.3._
428      */
429     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
430         return functionStaticCall(target, data, "Address: low-level static call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a static call.
436      *
437      * _Available since v3.3._
438      */
439     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
440         require(isContract(target), "Address: static call to non-contract");
441 
442         // solhint-disable-next-line avoid-low-level-calls
443         (bool success, bytes memory returndata) = target.staticcall(data);
444         return _verifyCallResult(success, returndata, errorMessage);
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
449      * but performing a delegate call.
450      *
451      * _Available since v3.4._
452      */
453     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
454         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
459      * but performing a delegate call.
460      *
461      * _Available since v3.4._
462      */
463     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
464         require(isContract(target), "Address: delegate call to non-contract");
465 
466         // solhint-disable-next-line avoid-low-level-calls
467         (bool success, bytes memory returndata) = target.delegatecall(data);
468         return _verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
472         if (success) {
473             return returndata;
474         } else {
475             // Look for revert reason and bubble it up if present
476             if (returndata.length > 0) {
477                 // The easiest way to bubble the revert reason is using memory via assembly
478 
479                 // solhint-disable-next-line no-inline-assembly
480                 assembly {
481                     let returndata_size := mload(returndata)
482                     revert(add(32, returndata), returndata_size)
483                 }
484             } else {
485                 revert(errorMessage);
486             }
487         }
488     }
489 }
490 
491 pragma solidity >=0.6.0 <0.8.0;
492 
493 /*
494  * @dev Provides information about the current execution context, including the
495  * sender of the transaction and its data. While these are generally available
496  * via msg.sender and msg.data, they should not be accessed in such a direct
497  * manner, since when dealing with GSN meta-transactions the account sending and
498  * paying for execution may not be the actual sender (as far as an application
499  * is concerned).
500  *
501  * This contract is only required for intermediate, library-like contracts.
502  */
503 abstract contract Context {
504     function _msgSender() internal view virtual returns (address payable) {
505         return msg.sender;
506     }
507 
508     function _msgData() internal view virtual returns (bytes memory) {
509         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
510         return msg.data;
511     }
512 }
513 
514 pragma solidity >=0.6.0 <0.8.0;
515 
516 /**
517  * @dev Interface of the ERC165 standard, as defined in the
518  * https://eips.ethereum.org/EIPS/eip-165[EIP].
519  *
520  * Implementers can declare support of contract interfaces, which can then be
521  * queried by others ({ERC165Checker}).
522  *
523  * For an implementation, see {ERC165}.
524  */
525 interface IERC165 {
526     /**
527      * @dev Returns true if this contract implements the interface defined by
528      * `interfaceId`. See the corresponding
529      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
530      * to learn more about how these ids are created.
531      *
532      * This function call must use less than 30 000 gas.
533      */
534     function supportsInterface(bytes4 interfaceId) external view returns (bool);
535 }
536 
537 pragma solidity >=0.6.2 <0.8.0;
538 
539 
540 /**
541  * @dev Required interface of an ERC721 compliant contract.
542  */
543 interface IERC721 is IERC165 {
544     /**
545      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
546      */
547     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
548 
549     /**
550      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
551      */
552     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
553 
554     /**
555      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
556      */
557     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
558 
559     /**
560      * @dev Returns the number of tokens in ``owner``'s account.
561      */
562     function balanceOf(address owner) external view returns (uint256 balance);
563 
564     /**
565      * @dev Returns the owner of the `tokenId` token.
566      *
567      * Requirements:
568      *
569      * - `tokenId` must exist.
570      */
571     function ownerOf(uint256 tokenId) external view returns (address owner);
572 
573     /**
574      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
575      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
576      *
577      * Requirements:
578      *
579      * - `from` cannot be the zero address.
580      * - `to` cannot be the zero address.
581      * - `tokenId` token must exist and be owned by `from`.
582      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
583      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
584      *
585      * Emits a {Transfer} event.
586      */
587     function safeTransferFrom(address from, address to, uint256 tokenId) external;
588 
589     /**
590      * @dev Transfers `tokenId` token from `from` to `to`.
591      *
592      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
593      *
594      * Requirements:
595      *
596      * - `from` cannot be the zero address.
597      * - `to` cannot be the zero address.
598      * - `tokenId` token must be owned by `from`.
599      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
600      *
601      * Emits a {Transfer} event.
602      */
603     function transferFrom(address from, address to, uint256 tokenId) external;
604 
605     /**
606      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
607      * The approval is cleared when the token is transferred.
608      *
609      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
610      *
611      * Requirements:
612      *
613      * - The caller must own the token or be an approved operator.
614      * - `tokenId` must exist.
615      *
616      * Emits an {Approval} event.
617      */
618     function approve(address to, uint256 tokenId) external;
619 
620     /**
621      * @dev Returns the account approved for `tokenId` token.
622      *
623      * Requirements:
624      *
625      * - `tokenId` must exist.
626      */
627     function getApproved(uint256 tokenId) external view returns (address operator);
628 
629     /**
630      * @dev Approve or remove `operator` as an operator for the caller.
631      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
632      *
633      * Requirements:
634      *
635      * - The `operator` cannot be the caller.
636      *
637      * Emits an {ApprovalForAll} event.
638      */
639     function setApprovalForAll(address operator, bool _approved) external;
640 
641     /**
642      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
643      *
644      * See {setApprovalForAll}
645      */
646     function isApprovedForAll(address owner, address operator) external view returns (bool);
647 
648     /**
649       * @dev Safely transfers `tokenId` token from `from` to `to`.
650       *
651       * Requirements:
652       *
653       * - `from` cannot be the zero address.
654       * - `to` cannot be the zero address.
655       * - `tokenId` token must exist and be owned by `from`.
656       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
657       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
658       *
659       * Emits a {Transfer} event.
660       */
661     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
662 }
663 
664 pragma solidity >=0.6.2 <0.8.0;
665 
666 
667 /**
668  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
669  * @dev See https://eips.ethereum.org/EIPS/eip-721
670  */
671 interface IERC721Metadata is IERC721 {
672 
673     /**
674      * @dev Returns the token collection name.
675      */
676     function name() external view returns (string memory);
677 
678     /**
679      * @dev Returns the token collection symbol.
680      */
681     function symbol() external view returns (string memory);
682 
683     /**
684      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
685      */
686     function tokenURI(uint256 tokenId) external view returns (string memory);
687 }
688 
689 pragma solidity >=0.6.2 <0.8.0;
690 
691 
692 /**
693  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
694  * @dev See https://eips.ethereum.org/EIPS/eip-721
695  */
696 interface IERC721Enumerable is IERC721 {
697 
698     /**
699      * @dev Returns the total amount of tokens stored by the contract.
700      */
701     function totalSupply() external view returns (uint256);
702 
703     /**
704      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
705      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
706      */
707     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
708 
709     /**
710      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
711      * Use along with {totalSupply} to enumerate all tokens.
712      */
713     function tokenByIndex(uint256 index) external view returns (uint256);
714 }
715 
716 pragma solidity >=0.6.0 <0.8.0;
717 
718 /**
719  * @title ERC721 token receiver interface
720  * @dev Interface for any contract that wants to support safeTransfers
721  * from ERC721 asset contracts.
722  */
723 interface IERC721Receiver {
724     /**
725      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
726      * by `operator` from `from`, this function is called.
727      *
728      * It must return its Solidity selector to confirm the token transfer.
729      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
730      *
731      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
732      */
733     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
734 }
735 
736 pragma solidity >=0.6.0 <0.8.0;
737 
738 
739 /**
740  * @dev Implementation of the {IERC165} interface.
741  *
742  * Contracts may inherit from this and call {_registerInterface} to declare
743  * their support of an interface.
744  */
745 abstract contract ERC165 is IERC165 {
746     /*
747      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
748      */
749     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
750 
751     /**
752      * @dev Mapping of interface ids to whether or not it's supported.
753      */
754     mapping(bytes4 => bool) private _supportedInterfaces;
755 
756     constructor () internal {
757         // Derived contracts need only register support for their own interfaces,
758         // we register support for ERC165 itself here
759         _registerInterface(_INTERFACE_ID_ERC165);
760     }
761 
762     /**
763      * @dev See {IERC165-supportsInterface}.
764      *
765      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
766      */
767     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
768         return _supportedInterfaces[interfaceId];
769     }
770 
771     /**
772      * @dev Registers the contract as an implementer of the interface defined by
773      * `interfaceId`. Support of the actual ERC165 interface is automatic and
774      * registering its interface id is not required.
775      *
776      * See {IERC165-supportsInterface}.
777      *
778      * Requirements:
779      *
780      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
781      */
782     function _registerInterface(bytes4 interfaceId) internal virtual {
783         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
784         _supportedInterfaces[interfaceId] = true;
785     }
786 }
787 
788 pragma solidity >=0.6.0 <0.8.0;
789 
790 /**
791  * @dev Library for managing an enumerable variant of Solidity's
792  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
793  * type.
794  *
795  * Maps have the following properties:
796  *
797  * - Entries are added, removed, and checked for existence in constant time
798  * (O(1)).
799  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
800  *
801  * ```
802  * contract Example {
803  *     // Add the library methods
804  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
805  *
806  *     // Declare a set state variable
807  *     EnumerableMap.UintToAddressMap private myMap;
808  * }
809  * ```
810  *
811  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
812  * supported.
813  */
814 library EnumerableMap {
815     // To implement this library for multiple types with as little code
816     // repetition as possible, we write it in terms of a generic Map type with
817     // bytes32 keys and values.
818     // The Map implementation uses private functions, and user-facing
819     // implementations (such as Uint256ToAddressMap) are just wrappers around
820     // the underlying Map.
821     // This means that we can only create new EnumerableMaps for types that fit
822     // in bytes32.
823 
824     struct MapEntry {
825         bytes32 _key;
826         bytes32 _value;
827     }
828 
829     struct Map {
830         // Storage of map keys and values
831         MapEntry[] _entries;
832 
833         // Position of the entry defined by a key in the `entries` array, plus 1
834         // because index 0 means a key is not in the map.
835         mapping (bytes32 => uint256) _indexes;
836     }
837 
838     /**
839      * @dev Adds a key-value pair to a map, or updates the value for an existing
840      * key. O(1).
841      *
842      * Returns true if the key was added to the map, that is if it was not
843      * already present.
844      */
845     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
846         // We read and store the key's index to prevent multiple reads from the same storage slot
847         uint256 keyIndex = map._indexes[key];
848 
849         if (keyIndex == 0) { // Equivalent to !contains(map, key)
850             map._entries.push(MapEntry({ _key: key, _value: value }));
851             // The entry is stored at length-1, but we add 1 to all indexes
852             // and use 0 as a sentinel value
853             map._indexes[key] = map._entries.length;
854             return true;
855         } else {
856             map._entries[keyIndex - 1]._value = value;
857             return false;
858         }
859     }
860 
861     /**
862      * @dev Removes a key-value pair from a map. O(1).
863      *
864      * Returns true if the key was removed from the map, that is if it was present.
865      */
866     function _remove(Map storage map, bytes32 key) private returns (bool) {
867         // We read and store the key's index to prevent multiple reads from the same storage slot
868         uint256 keyIndex = map._indexes[key];
869 
870         if (keyIndex != 0) { // Equivalent to contains(map, key)
871             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
872             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
873             // This modifies the order of the array, as noted in {at}.
874 
875             uint256 toDeleteIndex = keyIndex - 1;
876             uint256 lastIndex = map._entries.length - 1;
877 
878             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
879             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
880 
881             MapEntry storage lastEntry = map._entries[lastIndex];
882 
883             // Move the last entry to the index where the entry to delete is
884             map._entries[toDeleteIndex] = lastEntry;
885             // Update the index for the moved entry
886             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
887 
888             // Delete the slot where the moved entry was stored
889             map._entries.pop();
890 
891             // Delete the index for the deleted slot
892             delete map._indexes[key];
893 
894             return true;
895         } else {
896             return false;
897         }
898     }
899 
900     /**
901      * @dev Returns true if the key is in the map. O(1).
902      */
903     function _contains(Map storage map, bytes32 key) private view returns (bool) {
904         return map._indexes[key] != 0;
905     }
906 
907     /**
908      * @dev Returns the number of key-value pairs in the map. O(1).
909      */
910     function _length(Map storage map) private view returns (uint256) {
911         return map._entries.length;
912     }
913 
914    /**
915     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
916     *
917     * Note that there are no guarantees on the ordering of entries inside the
918     * array, and it may change when more entries are added or removed.
919     *
920     * Requirements:
921     *
922     * - `index` must be strictly less than {length}.
923     */
924     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
925         require(map._entries.length > index, "EnumerableMap: index out of bounds");
926 
927         MapEntry storage entry = map._entries[index];
928         return (entry._key, entry._value);
929     }
930 
931     /**
932      * @dev Tries to returns the value associated with `key`.  O(1).
933      * Does not revert if `key` is not in the map.
934      */
935     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
936         uint256 keyIndex = map._indexes[key];
937         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
938         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
939     }
940 
941     /**
942      * @dev Returns the value associated with `key`.  O(1).
943      *
944      * Requirements:
945      *
946      * - `key` must be in the map.
947      */
948     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
949         uint256 keyIndex = map._indexes[key];
950         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
951         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
952     }
953 
954     /**
955      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
956      *
957      * CAUTION: This function is deprecated because it requires allocating memory for the error
958      * message unnecessarily. For custom revert reasons use {_tryGet}.
959      */
960     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
961         uint256 keyIndex = map._indexes[key];
962         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
963         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
964     }
965 
966     // UintToAddressMap
967 
968     struct UintToAddressMap {
969         Map _inner;
970     }
971 
972     /**
973      * @dev Adds a key-value pair to a map, or updates the value for an existing
974      * key. O(1).
975      *
976      * Returns true if the key was added to the map, that is if it was not
977      * already present.
978      */
979     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
980         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
981     }
982 
983     /**
984      * @dev Removes a value from a set. O(1).
985      *
986      * Returns true if the key was removed from the map, that is if it was present.
987      */
988     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
989         return _remove(map._inner, bytes32(key));
990     }
991 
992     /**
993      * @dev Returns true if the key is in the map. O(1).
994      */
995     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
996         return _contains(map._inner, bytes32(key));
997     }
998 
999     /**
1000      * @dev Returns the number of elements in the map. O(1).
1001      */
1002     function length(UintToAddressMap storage map) internal view returns (uint256) {
1003         return _length(map._inner);
1004     }
1005 
1006    /**
1007     * @dev Returns the element stored at position `index` in the set. O(1).
1008     * Note that there are no guarantees on the ordering of values inside the
1009     * array, and it may change when more values are added or removed.
1010     *
1011     * Requirements:
1012     *
1013     * - `index` must be strictly less than {length}.
1014     */
1015     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1016         (bytes32 key, bytes32 value) = _at(map._inner, index);
1017         return (uint256(key), address(uint160(uint256(value))));
1018     }
1019 
1020     /**
1021      * @dev Tries to returns the value associated with `key`.  O(1).
1022      * Does not revert if `key` is not in the map.
1023      *
1024      * _Available since v3.4._
1025      */
1026     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1027         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1028         return (success, address(uint160(uint256(value))));
1029     }
1030 
1031     /**
1032      * @dev Returns the value associated with `key`.  O(1).
1033      *
1034      * Requirements:
1035      *
1036      * - `key` must be in the map.
1037      */
1038     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1039         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1040     }
1041 
1042     /**
1043      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1044      *
1045      * CAUTION: This function is deprecated because it requires allocating memory for the error
1046      * message unnecessarily. For custom revert reasons use {tryGet}.
1047      */
1048     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1049         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1050     }
1051 }
1052 
1053 
1054 pragma solidity >=0.6.0 <0.8.0;
1055 
1056 /**
1057  * @dev String operations.
1058  */
1059 /*
1060 library Strings {
1061     function toString(uint256 value) internal pure returns (string memory) {
1062         // Inspired by OraclizeAPI's implementation - MIT licence
1063         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1064 
1065         if (value == 0) {
1066             return "0";
1067         }
1068         uint256 temp = value;
1069         uint256 digits;
1070         while (temp != 0) {
1071             digits++;
1072             temp /= 10;
1073         }
1074         bytes memory buffer = new bytes(digits);
1075         uint256 index = digits - 1;
1076         temp = value;
1077         while (temp != 0) {
1078             buffer[index--] = bytes1(uint8(48 + temp % 10));
1079             temp /= 10;
1080         }
1081         return string(buffer);
1082     }
1083 }
1084 */
1085 pragma solidity >=0.6.0 <0.8.0;
1086 
1087 /**
1088  * @title ERC721 Non-Fungible Token Standard basic implementation
1089  * @dev see https://eips.ethereum.org/EIPS/eip-721
1090  */
1091 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1092   //    using SafeMath for uint256;
1093     using Address for address;
1094     using EnumerableSet for EnumerableSet.UintSet;
1095     using EnumerableMap for EnumerableMap.UintToAddressMap;
1096 //    using Strings for uint256;
1097 
1098     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1099     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1100     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1101 
1102     // Mapping from holder address to their (enumerable) set of owned tokens
1103     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1104 
1105     // Enumerable mapping from token ids to their owners
1106     EnumerableMap.UintToAddressMap private _tokenOwners;
1107 
1108     // Mapping from token ID to approved address
1109     mapping (uint256 => address) private _tokenApprovals;
1110 
1111     // Mapping from owner to operator approvals
1112     mapping (address => mapping (address => bool)) private _operatorApprovals;
1113 
1114     // Token name
1115     string private _name;
1116 
1117     // Token symbol
1118     string private _symbol;
1119 
1120     // Optional mapping for token URIs
1121     mapping (uint256 => string) private _tokenURIs;
1122 
1123     // Base URI
1124     string private _baseURI;
1125 
1126     /*
1127      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1128      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1129      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1130      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1131      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1132      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1133      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1134      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1135      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1136      *
1137      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1138      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1139      */
1140     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1141 
1142     /*
1143      *     bytes4(keccak256('name()')) == 0x06fdde03
1144      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1145      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1146      *
1147      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1148      */
1149     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1150 
1151     /*
1152      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1153      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1154      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1155      *
1156      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1157      */
1158     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1159 
1160     /**
1161      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1162      */
1163     constructor (string memory name_, string memory symbol_) public {
1164         _name = name_;
1165         _symbol = symbol_;
1166 
1167         // register the supported interfaces to conform to ERC721 via ERC165
1168         _registerInterface(_INTERFACE_ID_ERC721);
1169         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1170         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1171     }
1172 
1173     /**
1174      * @dev See {IERC721-balanceOf}.
1175      */
1176     function balanceOf(address owner) public view virtual override returns (uint256) {
1177         require(owner != address(0), "ERC721: balance query for the zero address");
1178         return _holderTokens[owner].length();
1179     }
1180 
1181     /**
1182      * @dev See {IERC721-ownerOf}.
1183      */
1184     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1185         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1186     }
1187 
1188     /**
1189      * @dev See {IERC721Metadata-name}.
1190      */
1191     function name() public view virtual override returns (string memory) {
1192         return _name;
1193     }
1194 
1195     /**
1196      * @dev See {IERC721Metadata-symbol}.
1197      */
1198     function symbol() public view virtual override returns (string memory) {
1199         return _symbol;
1200     }
1201 
1202     /**
1203      * @dev See {IERC721Metadata-tokenURI}.
1204      */
1205     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1206     	     return ("");
1207 	     /*
1208         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1209 
1210         string memory _tokenURI = _tokenURIs[tokenId];
1211         string memory base = baseURI();
1212 
1213         // If there is no base URI, return the token URI.
1214         if (bytes(base).length == 0) {
1215             return _tokenURI;
1216         }
1217         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1218         if (bytes(_tokenURI).length > 0) {
1219             return string(abi.encodePacked(base, _tokenURI));
1220         }
1221         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1222         return string(abi.encodePacked(base, tokenId.toString()));
1223 	*/
1224 	
1225     }
1226 
1227     /**
1228     * @dev Returns the base URI set via {_setBaseURI}. This will be
1229     * automatically added as a prefix in {tokenURI} to each token's URI, or
1230     * to the token ID if no specific URI is set for that token ID.
1231     */
1232     function baseURI() public view virtual returns (string memory) {
1233         return _baseURI;
1234     }
1235 
1236     /**
1237      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1238      */
1239     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1240         return _holderTokens[owner].at(index);
1241     }
1242 
1243     /**
1244      * @dev See {IERC721Enumerable-totalSupply}.
1245      */
1246     function totalSupply() public view virtual override returns (uint256) {
1247         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1248         return _tokenOwners.length();
1249     }
1250 
1251     /**
1252      * @dev See {IERC721Enumerable-tokenByIndex}.
1253      */
1254     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1255         (uint256 tokenId, ) = _tokenOwners.at(index);
1256         return tokenId;
1257     }
1258 
1259     /**
1260      * @dev See {IERC721-approve}.
1261      */
1262     function approve(address to, uint256 tokenId) public virtual override {
1263         address owner = ERC721.ownerOf(tokenId);
1264         require(to != owner, "ERC721: approval to current owner");
1265 
1266         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1267             "ERC721: approve caller is not owner nor approved for all"
1268         );
1269 
1270         _approve(to, tokenId);
1271     }
1272 
1273     /**
1274      * @dev See {IERC721-getApproved}.
1275      */
1276     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1277         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1278 
1279         return _tokenApprovals[tokenId];
1280     }
1281 
1282     /**
1283      * @dev See {IERC721-setApprovalForAll}.
1284      */
1285     function setApprovalForAll(address operator, bool approved) public virtual override {
1286         require(operator != _msgSender(), "ERC721: approve to caller");
1287 
1288         _operatorApprovals[_msgSender()][operator] = approved;
1289         emit ApprovalForAll(_msgSender(), operator, approved);
1290     }
1291 
1292     /**
1293      * @dev See {IERC721-isApprovedForAll}.
1294      */
1295     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1296         return _operatorApprovals[owner][operator];
1297     }
1298 
1299     /**
1300      * @dev See {IERC721-transferFrom}.
1301      */
1302     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1303         //solhint-disable-next-line max-line-length
1304         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1305 
1306         _transfer(from, to, tokenId);
1307     }
1308 
1309     /**
1310      * @dev See {IERC721-safeTransferFrom}.
1311      */
1312     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1313         safeTransferFrom(from, to, tokenId, "");
1314     }
1315 
1316     /**
1317      * @dev See {IERC721-safeTransferFrom}.
1318      */
1319     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1320         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1321         _safeTransfer(from, to, tokenId, _data);
1322     }
1323 
1324     /**
1325      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1326      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1327      *
1328      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1329      *
1330      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1331      * implement alternative mechanisms to perform token transfer, such as signature-based.
1332      *
1333      * Requirements:
1334      *
1335      * - `from` cannot be the zero address.
1336      * - `to` cannot be the zero address.
1337      * - `tokenId` token must exist and be owned by `from`.
1338      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1339      *
1340      * Emits a {Transfer} event.
1341      */
1342     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1343         _transfer(from, to, tokenId);
1344 	//	require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1345     }
1346 
1347     /**
1348      * @dev Returns whether `tokenId` exists.
1349      *
1350      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1351      *
1352      * Tokens start existing when they are minted (`_mint`),
1353      * and stop existing when they are burned (`_burn`).
1354      */
1355     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1356         return _tokenOwners.contains(tokenId);
1357     }
1358 
1359     /**
1360      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1361      *
1362      * Requirements:
1363      *
1364      * - `tokenId` must exist.
1365      */
1366     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1367         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1368         address owner = ERC721.ownerOf(tokenId);
1369         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1370     }
1371 
1372     /**
1373      * @dev Safely mints `tokenId` and transfers it to `to`.
1374      *
1375      * Requirements:
1376      d*
1377      * - `tokenId` must not exist.
1378      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1379      *
1380      * Emits a {Transfer} event.
1381      */
1382     function _safeMint(address to, uint256 tokenId) internal virtual {
1383         _safeMint(to, tokenId, "");
1384     }
1385 
1386     /**
1387      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1388      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1389      */
1390     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1391         _mint(to, tokenId);
1392 	//        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1393     }
1394 
1395     /**
1396      * @dev Mints `tokenId` and transfers it to `to`.
1397      *
1398      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1399      *
1400      * Requirements:
1401      *
1402      * - `tokenId` must not exist.
1403      * - `to` cannot be the zero address.
1404      *
1405      * Emits a {Transfer} event.
1406      */
1407     function _mint(address to, uint256 tokenId) internal virtual {
1408         require(to != address(0), "ERC721: mint to the zero address");
1409         require(!_exists(tokenId), "ERC721: token already minted");
1410 
1411         _beforeTokenTransfer(address(0), to, tokenId);
1412 
1413         _holderTokens[to].add(tokenId);
1414 
1415         _tokenOwners.set(tokenId, to);
1416 
1417         emit Transfer(address(0), to, tokenId);
1418     }
1419 
1420     /**
1421      * @dev Destroys `tokenId`.
1422      * The approval is cleared when the token is burned.
1423      *
1424      * Requirements:
1425      *
1426      * - `tokenId` must exist.
1427      *
1428      * Emits a {Transfer} event.
1429      */
1430     function _burn(uint256 tokenId) internal virtual {
1431         address owner = ERC721.ownerOf(tokenId); // internal owner
1432 
1433         _beforeTokenTransfer(owner, address(0), tokenId);
1434 
1435         // Clear approvals
1436         _approve(address(0), tokenId);
1437 
1438         // Clear metadata (if any)
1439         if (bytes(_tokenURIs[tokenId]).length != 0) {
1440             delete _tokenURIs[tokenId];
1441         }
1442 
1443         _holderTokens[owner].remove(tokenId);
1444 
1445         _tokenOwners.remove(tokenId);
1446 
1447         emit Transfer(owner, address(0), tokenId);
1448     }
1449 
1450     /**
1451      * @dev Transfers `tokenId` from `from` to `to`.
1452      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1453      *
1454      * Requirements:
1455      *
1456      * - `to` cannot be the zero address.
1457      * - `tokenId` token must be owned by `from`.
1458      *
1459      * Emits a {Transfer} event.
1460      */
1461     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1462         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1463         require(to != address(0), "ERC721: transfer to the zero address");
1464 
1465         _beforeTokenTransfer(from, to, tokenId);
1466 
1467         // Clear approvals from the previous owner
1468         _approve(address(0), tokenId);
1469 
1470         _holderTokens[from].remove(tokenId);
1471         _holderTokens[to].add(tokenId);
1472 
1473         _tokenOwners.set(tokenId, to);
1474 
1475         emit Transfer(from, to, tokenId);
1476     }
1477 
1478     /**
1479      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1480      *
1481      * Requirements:
1482      *
1483      * - `tokenId` must exist.
1484      */
1485     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1486         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1487         _tokenURIs[tokenId] = _tokenURI;
1488     }
1489 
1490     /**
1491      * @dev Internal function to set the base URI for all token IDs. It is
1492      * automatically added as a prefix to the value returned in {tokenURI},
1493      * or to the token ID if {tokenURI} is empty.
1494      */
1495     function _setBaseURI(string memory baseURI_) internal virtual {
1496         _baseURI = baseURI_;
1497     }
1498 
1499     /*
1500     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1501         private returns (bool)
1502     {
1503         if (!to.isContract()) {
1504             return true;
1505         }
1506         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1507             IERC721Receiver(to).onERC721Received.selector,
1508             _msgSender(),
1509             from,
1510             tokenId,
1511             _data
1512         ), "ERC721: transfer to non ERC721Receiver implementer");
1513         bytes4 retval = abi.decode(returndata, (bytes4));
1514         return (retval == _ERC721_RECEIVED);
1515     }
1516     */
1517     
1518     function _approve(address to, uint256 tokenId) private {
1519         _tokenApprovals[tokenId] = to;
1520         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1521     }
1522 
1523     /**
1524      * @dev Hook that is called before any token transfer. This includes minting
1525      * and burning.
1526      *
1527      * Calling conditions:
1528      *
1529      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1530      * transferred to `to`.
1531      * - When `from` is zero, `tokenId` will be minted for `to`.
1532      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1533      * - `from` cannot be the zero address.
1534      * - `to` cannot be the zero address.
1535      *
1536      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1537      */
1538     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1539 }
1540 
1541 
1542 
1543 pragma solidity >=0.6.0 <0.8.0;
1544 
1545 
1546 /**
1547  * @dev {ERC721} token, including:
1548  *
1549  *  - ability for holders to burn (destroy) their tokens
1550  *  - a minter role that allows for token minting (creation)
1551  *  - token ID and URI autogeneration
1552  *
1553  * This contract uses {AccessControl} to lock permissioned functions using the
1554  * different roles - head to its documentation for details.
1555  *
1556  * The account that deploys the contract will be granted the minter and pauser
1557  * roles, as well as the default admin role, which will let it grant both minter
1558  * and pauser roles to other accounts.
1559  */
1560 
1561 
1562 /**
1563  * @dev Contract module that helps prevent reentrant calls to a function.
1564  *
1565  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1566  * available, which can be applied to functions to make sure there are no nested
1567  * (reentrant) calls to them.
1568  *
1569  * Note that because there is a single `nonReentrant` guard, functions marked as
1570  * `nonReentrant` may not call one another. This can be worked around by making
1571  * those functions `private`, and then adding `external` `nonReentrant` entry
1572  * points to them.
1573  *
1574  * TIP: If you would like to learn more about reentrancy and alternative ways
1575  * to protect against it, check out our blog post
1576  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1577  */
1578 abstract contract ReentrancyGuard {
1579     // Booleans are more expensive than uint256 or any type that takes up a full
1580     // word because each write operation emits an extra SLOAD to first read the
1581     // slot's contents, replace the bits taken up by the boolean, and then write
1582     // back. This is the compiler's defense against contract upgrades and
1583     // pointer aliasing, and it cannot be disabled.
1584 
1585     // The values being non-zero value makes deployment a bit more expensive,
1586     // but in exchange the refund on every call to nonReentrant will be lower in
1587     // amount. Since refunds are capped to a percentage of the total
1588     // transaction's gas, it is best to keep them low in cases like this one, to
1589     // increase the likelihood of the full refund coming into effect.
1590     uint256 private constant _NOT_ENTERED = 1;
1591     uint256 private constant _ENTERED = 2;
1592 
1593     uint256 private _status;
1594 
1595     constructor() {
1596         _status = _NOT_ENTERED;
1597     }
1598 
1599     /**
1600      * @dev Prevents a contract from calling itself, directly or indirectly.
1601      * Calling a `nonReentrant` function from another `nonReentrant`
1602      * function is not supported. It is possible to prevent this from happening
1603      * by making the `nonReentrant` function external, and make it call a
1604      * `private` function that does the actual work.
1605      */
1606     modifier nonReentrant() {
1607         // On the first call to nonReentrant, _notEntered will be true
1608         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1609 
1610         // Any calls to nonReentrant after this point will fail
1611         _status = _ENTERED;
1612 
1613         _;
1614 
1615         // By storing the original value once again, a refund is triggered (see
1616         // https://eips.ethereum.org/EIPS/eip-2200)
1617         _status = _NOT_ENTERED;
1618     }
1619 }
1620 
1621 contract First is ERC721,ReentrancyGuard {
1622   address admin_address;
1623   uint32 public num_minted;
1624   
1625   //after data is written and verified, lock()
1626   // can be called once to permanently lock the contract
1627   // (no further updates permitted)
1628   bool public locked;
1629   bool public paused;  
1630 
1631   bytes[32] public t1; //text data
1632   //pointers to strings in t1
1633   uint16[32][32] public p1;
1634   uint16[32] public n1;   
1635 
1636   modifier requireAdmin() {
1637     require(admin_address == msg.sender,"Requires admin privileges");
1638     _;
1639   }  
1640 
1641   //transfers contract balance to GiveDirectly.org
1642   function donate() public payable requireAdmin {
1643     payable(0xc7464dbcA260A8faF033460622B23467Df5AEA42).transfer(address(this).balance);
1644   }
1645   
1646   function calc_pointers(uint16 cid) internal  {
1647     uint16 k=0;
1648     p1[cid][k] = 0;
1649     for (uint i=0;i<t1[cid].length;i++) {
1650       if (t1[cid][i]=='|') {
1651 	p1[cid][++k] = uint16(i+1);
1652       }
1653     }
1654     n1[cid] = k;
1655   }
1656 
1657   function owner() public view virtual returns (address) {
1658     return admin_address;
1659   }
1660 
1661   constructor() ERC721("First", "FIRST") {
1662     admin_address = msg.sender;
1663     paused = true;
1664     for (uint16 i=0;i<32;i++) {
1665       t1[i] = "||";
1666       calc_pointers(i);
1667     }
1668   }
1669 
1670   /* Lock contract permanently, preventing any further writes */
1671   function lock() public requireAdmin {
1672     locked=true;
1673   }
1674 
1675   //pause or unpause
1676   function setPaused(bool m) public requireAdmin {
1677     paused = m;
1678   }
1679     
1680   /* Returns randomly generated 'first' description, returning string */
1681   function getString(uint256 id) public view returns (string memory) {
1682     return string(generate(id));
1683   }
1684   
1685   /* Returns randomly generated 'first' description, returning bytes */
1686   function generate(uint256 id) public view returns (bytes memory) {
1687     require(id > 0 && id < 1000000);
1688 
1689     //generate a sequence of 25 pseudo random numbers, seeded by id
1690     uint32[25] memory seq;
1691     uint256 r = id + 20000;
1692     uint16 sp = 0;
1693     for (uint i=0;i<25;i++) {
1694       r = r * 16807 % 2147483647; //advance PRNG
1695       seq[i] = uint32(r);
1696     }
1697 
1698     bytes memory h = "The first ";
1699     bytes memory NFT = "NFT ";    
1700     bytes memory s = new bytes(512); //max length
1701     uint p = 0;
1702     uint16 o = 0;
1703     uint16 f = 0;
1704     uint16 slot = 0;
1705     for (uint i=0;i<h.length;i++) s[p++] = h[i];
1706 
1707     f = uint16(seq[sp++] % 100);
1708     if (f < 50) {
1709       //qualifier 1
1710       slot = 2;
1711       o = uint16(seq[sp++] % n1[slot]);
1712       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1713     }
1714 
1715     f = uint16(seq[sp++] % 100);
1716     if (f < 32) {
1717       //generative art category
1718 
1719       slot = 4; 
1720       o = uint16(seq[sp++] % n1[slot]);
1721       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1722 	
1723       bytes memory str = "generative ";
1724       for (uint i=0;i<str.length;i++) s[p++] = str[i];
1725 
1726       uint16 f2 = uint16(seq[sp++] % 100);
1727       if (f2 < 50) {	
1728 	slot = 7; 
1729 	o = uint16(seq[sp++] % n1[slot]);
1730 	for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1731       }
1732 	
1733       slot = 10; 
1734       o = uint16(seq[sp++] % n1[slot]);
1735       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1736     } else if (f < 50) {
1737       //PFP
1738 
1739       uint16 f2 = uint16(seq[sp++] % 100);
1740       if (f2 < 50) {	
1741 	slot = 9; 
1742 	o = uint16(seq[sp++] % n1[slot]);
1743 	for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1744 	p--;
1745 	bytes memory str = "-derivative ";
1746 	for (uint i=0;i<str.length;i++) s[p++] = str[i];
1747       }
1748 	
1749       slot = 3; 
1750       o = uint16(seq[sp++] % n1[slot]);
1751       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1752 
1753       slot = 12; 
1754       o = uint16(seq[sp++] % n1[slot]);
1755       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1756 
1757     } else if (f < 54) {
1758       // 4% with none
1759     } else {
1760       //general category
1761       slot = 0; 
1762       o = uint16(seq[sp++] % n1[slot]);
1763       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1764     }
1765       
1766     for (uint i=0;i<NFT.length;i++) s[p++] = NFT[i];
1767 
1768     f = uint16(seq[sp++] % 100);      
1769     if (f < 50) {      
1770       slot = 1; //which chain
1771       o = uint16(seq[sp++] % n1[slot]);
1772       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1773     }
1774       
1775     f = uint16(seq[sp++] % 110);
1776 
1777     if (f < 5) {
1778       //special stuff
1779       slot = 13;
1780       o = uint16(seq[sp++] % n1[slot]);
1781       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1782     } else if (f < 15) {
1783       //featured in
1784       bytes memory str = "to be featured ";
1785       for (uint i=0;i<str.length;i++) s[p++] = str[i];
1786       
1787       slot = 14; 
1788       o = uint16(seq[sp++] % n1[slot]);
1789       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];	
1790     } else if (f < 23) {
1791       //action by a 'dao vote'
1792       slot = 22;
1793       o = uint16(seq[sp++] % n1[slot]);
1794       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1795 
1796       slot = 26;
1797       o = uint16(seq[sp++] % n1[slot]);
1798       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1799 
1800     } else if (f < 27) {
1801       // 4% with none	
1802     } else if (f < 40) {
1803       //action by a person
1804       slot = 8; 
1805       o = uint16(seq[sp++] % n1[slot]);
1806       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1807 
1808       slot = 5;  
1809       o = uint16(seq[sp++] % n1[slot]);
1810       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];	
1811     } else if (f < 50) {
1812       //airdropped
1813       bytes memory str = "to be airdropped to ";
1814       for (uint i=0;i<str.length;i++) s[p++] = str[i];
1815 	
1816       slot = 9; 
1817       o = uint16(seq[sp++] % n1[slot]);
1818       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1819 
1820       slot = 19;  
1821       o = uint16(seq[sp++] % n1[slot]);
1822       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];	
1823     } else if (f < 60) {
1824       //stakable/burnable for x
1825       slot = 15;
1826       o = uint16(seq[sp++] % n1[slot]);
1827       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1828 	
1829       slot = 6; 
1830       o = uint16(seq[sp++] % n1[slot]);
1831       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1832     } else if (f < 63) {
1833       //redeemable for x
1834       bytes memory str = "redeemable ";
1835       for (uint i=0;i<str.length;i++) s[p++] = str[i];
1836 	
1837       slot = 25;
1838       o = uint16(seq[sp++] % n1[slot]);
1839       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1840     } else if (f < 67) {
1841       //other special stuff
1842       slot = 27;
1843       o = uint16(seq[sp++] % n1[slot]);
1844       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];	
1845     } else if (f < 80) {
1846       //with on-chain
1847       slot = 16;
1848       o = uint16(seq[sp++] % n1[slot]);
1849       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1850 
1851       slot = 17;
1852       o = uint16(seq[sp++] % n1[slot]);
1853       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1854 
1855       slot = 18;
1856       o = uint16(seq[sp++] % n1[slot]);
1857       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1858     } else if (f < 83) {
1859       //that changes over x
1860       slot = 20;
1861       o = uint16(seq[sp++] % n1[slot]);
1862       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1863 
1864       slot = 21;
1865       o = uint16(seq[sp++] % n1[slot]);
1866       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1867     } else if (f < 87) {
1868       //sold on an x price ramp
1869       bytes memory str = "to be sold ";
1870       for (uint i=0;i<str.length;i++) s[p++] = str[i];
1871       slot = 23;
1872       o = uint16(seq[sp++] % n1[slot]);
1873       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1874     } else if (f < 92) {
1875       //made using 100% programming language
1876       bytes memory str = "made entirely with ";
1877       for (uint i=0;i<str.length;i++) s[p++] = str[i];
1878       slot = 24;
1879       o = uint16(seq[sp++] % n1[slot]);
1880       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1881     } else if (f < 99) {
1882       //inspired by
1883       bytes memory str = "inspired by ";
1884       for (uint i=0;i<str.length;i++) s[p++] = str[i];
1885       slot = 28;
1886       o = uint16(seq[sp++] % n1[slot]);
1887       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1888     } else if (f < 110) {
1889       bytes memory str = "to be sold at ";
1890       for (uint i=0;i<str.length;i++) s[p++] = str[i];
1891       
1892       slot = 11; 
1893       o = uint16(seq[sp++] % n1[slot]);
1894       for (uint i=p1[slot][o];t1[slot][i] != '|';i++) s[p++] = t1[slot][i];
1895 
1896       uint16 f2 = uint16(seq[sp++] % 100);
1897       if (f2 < 20) {	
1898 	bytes memory str2 = "for a record price ";
1899 	for (uint i=0;i<str2.length;i++) s[p++] = str2[i];
1900       } else if (f2 < 40) {	
1901 	bytes memory str2 = "for a pittance ";
1902 	for (uint i=0;i<str2.length;i++) s[p++] = str2[i];
1903       }      
1904     }
1905 
1906     s[p-1] = '.';
1907     s[p] = '0';
1908 
1909     bytes memory s2 = new bytes(p);
1910     for (uint i=0;i<p;i++) s2[i] = s[i];
1911     return s2;
1912   }
1913 
1914   /* Upload a chunk of data */
1915   function setT1(uint16 cid, string calldata s) public requireAdmin {
1916     require(!locked,"Can't change data after locked");
1917     require(cid < 32);
1918     t1[cid] = bytes(s);
1919     calc_pointers(cid);
1920   }
1921 
1922   function tokenURI(uint256 tokenId) public view override returns (string memory) {
1923     string memory output = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: Courier New; font-size: 18px; }</style><rect width="100%" height="100%" fill="black" />';
1924     
1925     uint256 j = 25;
1926     bytes memory b = generate(tokenId);
1927     //calculate word wrapping 
1928     uint i = 0;
1929     uint e = 0;    
1930     uint ll = 30; //max length of each line
1931     
1932     while (true) {
1933       e = i + ll;
1934       if (e >= b.length) {
1935 	e = b.length;
1936       } else {
1937 	while (b[e] != ' ' && e > i) { e--; }
1938       }
1939       //splice the line in
1940       bytes memory line = new bytes(e-i);
1941       for (uint k = i; k < e; k++) {
1942 	line[k-i] = b[k];
1943       }
1944 
1945       output = string(abi.encodePacked(output,'<text class="base" x="15" y = "',toString(j),'">',line,'</text>'));
1946       if (j > 200) break;
1947       
1948       j += 22;
1949       if (e >= b.length) break; //finished
1950       i = e + 1;
1951     }
1952     
1953     output = string(abi.encodePacked(output,'</svg>'));
1954 
1955     string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "First NFT #', toString(tokenId), '", "description": "First satirical on-chain generative text NFT about NFT firsts. Don\'t sleep on this historic collection.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
1956     output = string(abi.encodePacked('data:application/json;base64,', json));
1957 
1958     return output;
1959   }
1960   
1961     function claim(uint256 tokenId) public payable nonReentrant {
1962       require(!paused,"Currently paused");      
1963       require(!locked,"Can't mint after locked");
1964       
1965       require(tokenId > 0 && tokenId < 1000000, "Token ID invalid");
1966       require(num_minted < 5000,"All have been claimed.");
1967 
1968       uint price = 10000000000000000; //0.01 ETH
1969       require(msg.value>=10000000000000000, "Must send minimum value to purchase!");
1970 
1971       _mint(_msgSender(), tokenId);
1972       num_minted++;
1973     }
1974     
1975     function toString(uint256 value) internal pure returns (string memory) {
1976     // Inspired by OraclizeAPI's implementation - MIT license
1977     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1978 
1979         if (value == 0) {
1980             return "0";
1981         }
1982         uint256 temp = value;
1983         uint256 digits;
1984         while (temp != 0) {
1985             digits++;
1986             temp /= 10;
1987         }
1988         bytes memory buffer = new bytes(digits);
1989         while (value != 0) {
1990             digits -= 1;
1991             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1992             value /= 10;
1993         }
1994         return string(buffer);
1995     }
1996 
1997 }
1998 
1999 /// [MIT License]
2000 /// @title Base64
2001 /// @notice Provides a function for encoding some bytes in base64
2002 /// @author Brecht Devos <brecht@loopring.org>
2003 library Base64 {
2004     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
2005 
2006     /// @notice Encodes some bytes to the base64 representation
2007     function encode(bytes memory data) internal pure returns (string memory) {
2008         uint256 len = data.length;
2009         if (len == 0) return "";
2010 
2011         // multiply by 4/3 rounded up
2012         uint256 encodedLen = 4 * ((len + 2) / 3);
2013 
2014         // Add some extra buffer at the end
2015         bytes memory result = new bytes(encodedLen + 32);
2016 
2017         bytes memory table = TABLE;
2018 
2019         assembly {
2020             let tablePtr := add(table, 1)
2021             let resultPtr := add(result, 32)
2022 
2023             for {
2024                 let i := 0
2025             } lt(i, len) {
2026 
2027             } {
2028                 i := add(i, 3)
2029                 let input := and(mload(add(data, i)), 0xffffff)
2030 
2031                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
2032                 out := shl(8, out)
2033                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
2034                 out := shl(8, out)
2035                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
2036                 out := shl(8, out)
2037                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
2038                 out := shl(224, out)
2039 
2040                 mstore(resultPtr, out)
2041 
2042                 resultPtr := add(resultPtr, 4)
2043             }
2044 
2045             switch mod(len, 3)
2046             case 1 {
2047                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
2048             }
2049             case 2 {
2050                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
2051             }
2052 
2053             mstore(result, encodedLen)
2054         }
2055 
2056         return string(result);
2057     }
2058 }