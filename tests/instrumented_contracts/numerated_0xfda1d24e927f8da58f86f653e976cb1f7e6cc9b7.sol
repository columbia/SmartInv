1 /**
2  UNSHADED ROCKS                                                                                                                                                                                                      
3  Sculptures by Loucas Braconnier/Figure31, contract by Jonathan Chomko. 
4  December 2021                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
5 **/
6 
7 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity  ^0.8.0;
11 
12 /**
13  * @dev Library for managing
14  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
15  * types.
16  *
17  * Sets have the following properties:
18  *
19  * - Elements are added, removed, and checked for existence in constant time
20  * (O(1)).
21  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
22  *
23  * ```
24  * contract Example {
25  *     // Add the library methods
26  *     using EnumerableSet for EnumerableSet.AddressSet;
27  *
28  *     // Declare a set state variable
29  *     EnumerableSet.AddressSet private mySet;
30  * }
31  * ```
32  *
33  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
34  * and `uint256` (`UintSet`) are supported.
35  */
36 library EnumerableSet {
37     // To implement this library for multiple types with as little code
38     // repetition as possible, we write it in terms of a generic Set type with
39     // bytes32 values.
40     // The Set implementation uses private functions, and user-facing
41     // implementations (such as AddressSet) are just wrappers around the
42     // underlying Set.
43     // This means that we can only create new EnumerableSets for types that fit
44     // in bytes32.
45 
46     struct Set {
47         // Storage of set values
48         bytes32[] _values;
49 
50         // Position of the value in the `values` array, plus 1 because index 0
51         // means a value is not in the set.
52         mapping (bytes32 => uint256) _indexes;
53     }
54 
55     /**
56      * @dev Add a value to a set. O(1).
57      *
58      * Returns true if the value was added to the set, that is if it was not
59      * already present.
60      */
61     function _add(Set storage set, bytes32 value) private returns (bool) {
62         if (!_contains(set, value)) {
63             set._values.push(value);
64             // The value is stored at length-1, but we add 1 to all indexes
65             // and use 0 as a sentinel value
66             set._indexes[value] = set._values.length;
67             return true;
68         } else {
69             return false;
70         }
71     }
72 
73     /**
74      * @dev Removes a value from a set. O(1).
75      *
76      * Returns true if the value was removed from the set, that is if it was
77      * present.
78      */
79     function _remove(Set storage set, bytes32 value) private returns (bool) {
80         // We read and store the value's index to prevent multiple reads from the same storage slot
81         uint256 valueIndex = set._indexes[value];
82 
83         if (valueIndex != 0) { // Equivalent to contains(set, value)
84             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
85             // the array, and then remove the last element (sometimes called as 'swap and pop').
86             // This modifies the order of the array, as noted in {at}.
87 
88             uint256 toDeleteIndex = valueIndex - 1;
89             uint256 lastIndex = set._values.length - 1;
90 
91             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
92             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
93 
94             bytes32 lastvalue = set._values[lastIndex];
95 
96             // Move the last value to the index where the value to delete is
97             set._values[toDeleteIndex] = lastvalue;
98             // Update the index for the moved value
99             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
100 
101             // Delete the slot where the moved value was stored
102             set._values.pop();
103 
104             // Delete the index for the deleted slot
105             delete set._indexes[value];
106 
107             return true;
108         } else {
109             return false;
110         }
111     }
112 
113     /**
114      * @dev Returns true if the value is in the set. O(1).
115      */
116     function _contains(Set storage set, bytes32 value) private view returns (bool) {
117         return set._indexes[value] != 0;
118     }
119 
120     /**
121      * @dev Returns the number of values on the set. O(1).
122      */
123     function _length(Set storage set) private view returns (uint256) {
124         return set._values.length;
125     }
126 
127   /**
128     * @dev Returns the value stored at position `index` in the set. O(1).
129     *
130     * Note that there are no guarantees on the ordering of values inside the
131     * array, and it may change when more values are added or removed.
132     *
133     * Requirements:
134     *
135     * - `index` must be strictly less than {length}.
136     */
137     function _at(Set storage set, uint256 index) private view returns (bytes32) {
138         require(set._values.length > index, "EnumerableSet: index out of bounds");
139         return set._values[index];
140     }
141 
142     // Bytes32Set
143 
144     struct Bytes32Set {
145         Set _inner;
146     }
147 
148     /**
149      * @dev Add a value to a set. O(1).
150      *
151      * Returns true if the value was added to the set, that is if it was not
152      * already present.
153      */
154     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
155         return _add(set._inner, value);
156     }
157 
158     /**
159      * @dev Removes a value from a set. O(1).
160      *
161      * Returns true if the value was removed from the set, that is if it was
162      * present.
163      */
164     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
165         return _remove(set._inner, value);
166     }
167 
168     /**
169      * @dev Returns true if the value is in the set. O(1).
170      */
171     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
172         return _contains(set._inner, value);
173     }
174 
175     /**
176      * @dev Returns the number of values in the set. O(1).
177      */
178     function length(Bytes32Set storage set) internal view returns (uint256) {
179         return _length(set._inner);
180     }
181 
182   /**
183     * @dev Returns the value stored at position `index` in the set. O(1).
184     *
185     * Note that there are no guarantees on the ordering of values inside the
186     * array, and it may change when more values are added or removed.
187     *
188     * Requirements:
189     *
190     * - `index` must be strictly less than {length}.
191     */
192     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
193         return _at(set._inner, index);
194     }
195 
196     // AddressSet
197 
198     struct AddressSet {
199         Set _inner;
200     }
201 
202     /**
203      * @dev Add a value to a set. O(1).
204      *
205      * Returns true if the value was added to the set, that is if it was not
206      * already present.
207      */
208     function add(AddressSet storage set, address value) internal returns (bool) {
209         return _add(set._inner, bytes32(uint256(uint160(value))));
210     }
211 
212     /**
213      * @dev Removes a value from a set. O(1).
214      *
215      * Returns true if the value was removed from the set, that is if it was
216      * present.
217      */
218     function remove(AddressSet storage set, address value) internal returns (bool) {
219         return _remove(set._inner, bytes32(uint256(uint160(value))));
220     }
221 
222     /**
223      * @dev Returns true if the value is in the set. O(1).
224      */
225     function contains(AddressSet storage set, address value) internal view returns (bool) {
226         return _contains(set._inner, bytes32(uint256(uint160(value))));
227     }
228 
229     /**
230      * @dev Returns the number of values in the set. O(1).
231      */
232     function length(AddressSet storage set) internal view returns (uint256) {
233         return _length(set._inner);
234     }
235 
236   /**
237     * @dev Returns the value stored at position `index` in the set. O(1).
238     *
239     * Note that there are no guarantees on the ordering of values inside the
240     * array, and it may change when more values are added or removed.
241     *
242     * Requirements:
243     *
244     * - `index` must be strictly less than {length}.
245     */
246     function at(AddressSet storage set, uint256 index) internal view returns (address) {
247         return address(uint160(uint256(_at(set._inner, index))));
248     }
249 
250 
251     // UintSet
252 
253     struct UintSet {
254         Set _inner;
255     }
256 
257     /**
258      * @dev Add a value to a set. O(1).
259      *
260      * Returns true if the value was added to the set, that is if it was not
261      * already present.
262      */
263     function add(UintSet storage set, uint256 value) internal returns (bool) {
264         return _add(set._inner, bytes32(value));
265     }
266 
267     /**
268      * @dev Removes a value from a set. O(1).
269      *
270      * Returns true if the value was removed from the set, that is if it was
271      * present.
272      */
273     function remove(UintSet storage set, uint256 value) internal returns (bool) {
274         return _remove(set._inner, bytes32(value));
275     }
276 
277     /**
278      * @dev Returns true if the value is in the set. O(1).
279      */
280     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
281         return _contains(set._inner, bytes32(value));
282     }
283 
284     /**
285      * @dev Returns the number of values on the set. O(1).
286      */
287     function length(UintSet storage set) internal view returns (uint256) {
288         return _length(set._inner);
289     }
290 
291   /**
292     * @dev Returns the value stored at position `index` in the set. O(1).
293     *
294     * Note that there are no guarantees on the ordering of values inside the
295     * array, and it may change when more values are added or removed.
296     *
297     * Requirements:
298     *
299     * - `index` must be strictly less than {length}.
300     */
301     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
302         return uint256(_at(set._inner, index));
303     }
304 }
305 
306 // File: @openzeppelin/contracts/utils/Address.sol
307 
308 
309 
310 pragma solidity  ^0.8.0;
311 
312 
313 /**
314  * @dev Collection of functions related to the address type
315  */
316 library Address {
317     /**
318      * @dev Returns true if `account` is a contract.
319      *
320      * [IMPORTANT]
321      * ====
322      * It is unsafe to assume that an address for which this function returns
323      * false is an externally-owned account (EOA) and not a contract.
324      *
325      * Among others, `isContract` will return false for the following
326      * types of addresses:
327      *
328      *  - an externally-owned account
329      *  - a contract in construction
330      *  - an address where a contract will be created
331      *  - an address where a contract lived, but was destroyed
332      * ====
333      */
334     function isContract(address account) internal view returns (bool) {
335         // This method relies on extcodesize, which returns 0 for contracts in
336         // construction, since the code is only stored at the end of the
337         // constructor execution.
338 
339         uint256 size;
340         // solhint-disable-next-line no-inline-assembly
341         assembly { size := extcodesize(account) }
342         return size > 0;
343     }
344 
345     /**
346      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
347      * `recipient`, forwarding all available gas and reverting on errors.
348      *
349      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
350      * of certain opcodes, possibly making contracts go over the 2300 gas limit
351      * imposed by `transfer`, making them unable to receive funds via
352      * `transfer`. {sendValue} removes this limitation.
353      *
354      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
355      *
356      * IMPORTANT: because control is transferred to `recipient`, care must be
357      * taken to not create reentrancy vulnerabilities. Consider using
358      * {ReentrancyGuard} or the
359      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
360      */
361     function sendValue(address payable recipient, uint256 amount) internal {
362         require(address(this).balance >= amount, "Address: insufficient balance");
363 
364         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
365         (bool success, ) = recipient.call{ value: amount }("");
366         require(success, "Address: unable to send value, recipient may have reverted");
367     }
368 
369     /**
370      * @dev Performs a Solidity function call using a low level `call`. A
371      * plain`call` is an unsafe replacement for a function call: use this
372      * function instead.
373      *
374      * If `target` reverts with a revert reason, it is bubbled up by this
375      * function (like regular Solidity function calls).
376      *
377      * Returns the raw returned data. To convert to the expected return value,
378      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
379      *
380      * Requirements:
381      *
382      * - `target` must be a contract.
383      * - calling `target` with `data` must not revert.
384      *
385      * _Available since v3.1._
386      */
387     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
388       return functionCall(target, data, "Address: low-level call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
393      * `errorMessage` as a fallback revert reason when `target` reverts.
394      *
395      * _Available since v3.1._
396      */
397     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
398         return functionCallWithValue(target, data, 0, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but also transferring `value` wei to `target`.
404      *
405      * Requirements:
406      *
407      * - the calling contract must have an ETH balance of at least `value`.
408      * - the called Solidity function must be `payable`.
409      *
410      * _Available since v3.1._
411      */
412     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
413         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
418      * with `errorMessage` as a fallback revert reason when `target` reverts.
419      *
420      * _Available since v3.1._
421      */
422     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
423         require(address(this).balance >= value, "Address: insufficient balance for call");
424         require(isContract(target), "Address: call to non-contract");
425 
426         // solhint-disable-next-line avoid-low-level-calls
427         (bool success, bytes memory returndata) = target.call{ value: value }(data);
428         return _verifyCallResult(success, returndata, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but performing a static call.
434      *
435      * _Available since v3.3._
436      */
437     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
438         return functionStaticCall(target, data, "Address: low-level static call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
443      * but performing a static call.
444      *
445      * _Available since v3.3._
446      */
447     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
448         require(isContract(target), "Address: static call to non-contract");
449 
450         // solhint-disable-next-line avoid-low-level-calls
451         (bool success, bytes memory returndata) = target.staticcall(data);
452         return _verifyCallResult(success, returndata, errorMessage);
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
457      * but performing a delegate call.
458      *
459      * _Available since v3.4._
460      */
461     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
462         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
467      * but performing a delegate call.
468      *
469      * _Available since v3.4._
470      */
471     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
472         require(isContract(target), "Address: delegate call to non-contract");
473 
474         // solhint-disable-next-line avoid-low-level-calls
475         (bool success, bytes memory returndata) = target.delegatecall(data);
476         return _verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
480         if (success) {
481             return returndata;
482         } else {
483             // Look for revert reason and bubble it up if present
484             if (returndata.length > 0) {
485                 // The easiest way to bubble the revert reason is using memory via assembly
486 
487                 // solhint-disable-next-line no-inline-assembly
488                 assembly {
489                     let returndata_size := mload(returndata)
490                     revert(add(32, returndata), returndata_size)
491                 }
492             } else {
493                 revert(errorMessage);
494             }
495         }
496     }
497 }
498 
499 // File: @openzeppelin/contracts/utils/Context.sol
500 
501 
502 
503 pragma solidity  ^0.8.0;
504 
505 /*
506  * @dev Provides information about the current execution context, including the
507  * sender of the transaction and its data. While these are generally available
508  * via msg.sender and msg.data, they should not be accessed in such a direct
509  * manner, since when dealing with GSN meta-transactions the account sending and
510  * paying for execution may not be the actual sender (as far as an application
511  * is concerned).
512  *
513  * This contract is only required for intermediate, library-like contracts.
514  */
515  abstract contract Context {
516     function _msgSender() internal view virtual returns (address) {
517         return msg.sender;
518     }
519 
520     function _msgData() internal view virtual returns (bytes calldata) {
521         return msg.data;
522     }
523 }
524 
525 // File: @openzeppelin/contracts/access/AccessControl.sol
526 
527 
528 
529 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.0
530 pragma solidity  ^0.8.0;
531 
532 /**
533  * @dev Contract module which provides a basic access control mechanism, where
534  * there is an account (an owner) that can be granted exclusive access to
535  * specific functions.
536  *
537  * By default, the owner account will be the one that deploys the contract. This
538  * can later be changed with {transferOwnership}.
539  *
540  * This module is used through inheritance. It will make available the modifier
541  * `onlyOwner`, which can be applied to your functions to restrict their use to
542  * the owner.
543  */
544 
545 abstract contract Ownable is Context {
546     address private _owner;
547 
548     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
549 
550     /**
551      * @dev Initializes the contract setting the deployer as the initial owner.
552      */
553     constructor() {
554         address msgSender = _msgSender();
555         _owner = msgSender;
556         emit OwnershipTransferred(address(0), msgSender);
557     }
558 
559     /**
560      * @dev Returns the address of the current owner.
561      */
562     function owner() public view virtual returns (address) {
563         return _owner;
564     }
565 
566     /**
567      * @dev Throws if called by any account other than the owner.
568      */
569     modifier onlyOwner() {
570         require(owner() == _msgSender(), "Ownable: caller is not the owner");
571         _;
572     }
573 
574     /**
575      * @dev Leaves the contract without owner. It will not be possible to call
576      * `onlyOwner` functions anymore. Can only be called by the current owner.
577      *
578      * NOTE: Renouncing ownership will leave the contract without an owner,
579      * thereby removing any functionality that is only available to the owner.
580      */
581     function renounceOwnership() public virtual onlyOwner {
582         emit OwnershipTransferred(_owner, address(0));
583         _owner = address(0);
584     }
585 
586     /**
587      * @dev Transfers ownership of the contract to a new account (`newOwner`).
588      * Can only be called by the current owner.
589      */
590     function transferOwnership(address newOwner) public virtual onlyOwner {
591         require(newOwner != address(0), "Ownable: new owner is the zero address");
592         emit OwnershipTransferred(_owner, newOwner);
593         _owner = newOwner;
594     }
595 }
596 
597 
598 // File: @openzeppelin/contracts/introspection/IERC165.sol
599 
600 pragma solidity  ^0.8.0;
601 
602 /**
603  * @dev Interface of the ERC165 standard, as defined in the
604  * https://eips.ethereum.org/EIPS/eip-165[EIP].
605  *
606  * Implementers can declare support of contract interfaces, which can then be
607  * queried by others ({ERC165Checker}).
608  *
609  * For an implementation, see {ERC165}.
610  */
611 interface IERC165 {
612     /**
613      * @dev Returns true if this contract implements the interface defined by
614      * `interfaceId`. See the corresponding
615      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
616      * to learn more about how these ids are created.
617      *
618      * This function call must use less than 30 000 gas.
619      */
620     function supportsInterface(bytes4 interfaceId) external view returns (bool);
621 }
622 
623 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
624 
625 
626 
627 pragma solidity  ^0.8.0;
628 
629 
630 
631 /**
632  * @dev Required interface of an ERC721 compliant contract.
633  */
634 interface IERC721 is IERC165 {
635     /**
636      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
637      */
638     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
639 
640     /**
641      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
642      */
643     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
644 
645     /**
646      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
647      */
648     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
649 
650     /**
651      * @dev Returns the number of tokens in ``owner``'s account.
652      */
653     function balanceOf(address owner) external view returns (uint256 balance);
654 
655     /**
656      * @dev Returns the owner of the `tokenId` token.
657      *
658      * Requirements:
659      *
660      * - `tokenId` must exist.
661      */
662     function ownerOf(uint256 tokenId) external view returns (address owner);
663 
664     /**
665      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
666      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
667      *
668      * Requirements:
669      *
670      * - `from` cannot be the zero address.
671      * - `to` cannot be the zero address.
672      * - `tokenId` token must exist and be owned by `from`.
673      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
674      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
675      *
676      * Emits a {Transfer} event.
677      */
678     function safeTransferFrom(address from, address to, uint256 tokenId) external;
679 
680     /**
681      * @dev Transfers `tokenId` token from `from` to `to`.
682      *
683      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
684      *
685      * Requirements:
686      *
687      * - `from` cannot be the zero address.
688      * - `to` cannot be the zero address.
689      * - `tokenId` token must be owned by `from`.
690      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
691      *
692      * Emits a {Transfer} event.
693      */
694     function transferFrom(address from, address to, uint256 tokenId) external;
695 
696     /**
697      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
698      * The approval is cleared when the token is transferred.
699      *
700      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
701      *
702      * Requirements:
703      *
704      * - The caller must own the token or be an approved operator.
705      * - `tokenId` must exist.
706      *
707      * Emits an {Approval} event.
708      */
709     function approve(address to, uint256 tokenId) external;
710 
711     /**
712      * @dev Returns the account approved for `tokenId` token.
713      *
714      * Requirements:
715      *
716      * - `tokenId` must exist.
717      */
718     function getApproved(uint256 tokenId) external view returns (address operator);
719 
720     /**
721      * @dev Approve or remove `operator` as an operator for the caller.
722      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
723      *
724      * Requirements:
725      *
726      * - The `operator` cannot be the caller.
727      *
728      * Emits an {ApprovalForAll} event.
729      */
730     function setApprovalForAll(address operator, bool _approved) external;
731 
732     /**
733      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
734      *
735      * See {setApprovalForAll}
736      */
737     function isApprovedForAll(address owner, address operator) external view returns (bool);
738 
739     /**
740       * @dev Safely transfers `tokenId` token from `from` to `to`.
741       *
742       * Requirements:
743       *
744       * - `from` cannot be the zero address.
745       * - `to` cannot be the zero address.
746       * - `tokenId` token must exist and be owned by `from`.
747       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
748       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
749       *
750       * Emits a {Transfer} event.
751       */
752     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
753 }
754 
755 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
756 
757 
758 
759 pragma solidity  ^0.8.0;
760 
761 
762 
763 /**
764  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
765  * @dev See https://eips.ethereum.org/EIPS/eip-721
766  */
767 interface IERC721Metadata is IERC721 {
768 
769     /**
770      * @dev Returns the token collection name.
771      */
772     function name() external view returns (string memory);
773 
774     /**
775      * @dev Returns the token collection symbol.
776      */
777     function symbol() external view returns (string memory);
778 
779     /**
780      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
781      */
782     function tokenURI(uint256 tokenId) external view returns (string memory);
783 }
784 
785 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
786 
787 
788 pragma solidity  ^0.8.0;
789 
790 // /**
791 //  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
792 //  * @dev See https://eips.ethereum.org/EIPS/eip-721
793 //  */
794 interface IERC721Enumerable is IERC721 {
795 
796     /**
797      * @dev Returns the total amount of tokens stored by the contract.
798      */
799     function totalSupply() external view returns (uint256);
800 
801     /**
802      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
803      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
804      */
805     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
806 
807     /**
808      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
809      * Use along with {totalSupply} to enumerate all tokens.
810      */
811     function tokenByIndex(uint256 index) external view returns (uint256);
812 }
813 
814 
815 
816 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
817 
818 
819 
820 pragma solidity  ^0.8.0;
821 
822 /**
823  * @title ERC721 token receiver interface
824  * @dev Interface for any contract that wants to support safeTransfers
825  * from ERC721 asset contracts.
826  */
827 interface IERC721Receiver {
828     /**
829      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
830      * by `operator` from `from`, this function is called.
831      *
832      * It must return its Solidity selector to confirm the token transfer.
833      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
834      *
835      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
836      */
837     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
838 }
839 
840 // File: @openzeppelin/contracts/introspection/ERC165.sol
841 
842 
843 
844 pragma solidity  ^0.8.0;
845 
846 
847 /**
848  * @dev Implementation of the {IERC165} interface.
849  *
850  * Contracts may inherit from this and call {_registerInterface} to declare
851  * their support of an interface.
852  */
853 abstract contract ERC165 is IERC165 {
854     /*
855      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
856      */
857     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
858 
859     /**
860      * @dev Mapping of interface ids to whether or not it's supported.
861      */
862     mapping(bytes4 => bool) private _supportedInterfaces;
863 
864     constructor () {
865         // Derived contracts need only register support for their own interfaces,
866         // we register support for ERC165 itself here
867         _registerInterface(_INTERFACE_ID_ERC165);
868     }
869 
870     /**
871      * @dev See {IERC165-supportsInterface}.
872      *
873      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
874      */
875     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
876         return _supportedInterfaces[interfaceId];
877     }
878 
879     /**
880      * @dev Registers the contract as an implementer of the interface defined by
881      * `interfaceId`. Support of the actual ERC165 interface is automatic and
882      * registering its interface id is not required.
883      *
884      * See {IERC165-supportsInterface}.
885      *
886      * Requirements:
887      *
888      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
889      */
890     function _registerInterface(bytes4 interfaceId) internal virtual {
891         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
892         _supportedInterfaces[interfaceId] = true;
893     }
894 }
895 
896 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
897 
898 
899 
900 pragma solidity  ^0.8.0;
901 
902 /**
903  * @dev Library for managing an enumerable variant of Solidity's
904  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
905  * type.
906  *
907  * Maps have the following properties:
908  *
909  * - Entries are added, removed, and checked for existence in constant time
910  * (O(1)).
911  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
912  *
913  * ```
914  * contract Example {
915  *     // Add the library methods
916  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
917  *
918  *     // Declare a set state variable
919  *     EnumerableMap.UintToAddressMap private myMap;
920  * }
921  * ```
922  *
923  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
924  * supported.
925  */
926 library EnumerableMap {
927     // To implement this library for multiple types with as little code
928     // repetition as possible, we write it in terms of a generic Map type with
929     // bytes32 keys and values.
930     // The Map implementation uses private functions, and user-facing
931     // implementations (such as Uint256ToAddressMap) are just wrappers around
932     // the underlying Map.
933     // This means that we can only create new EnumerableMaps for types that fit
934     // in bytes32.
935 
936     struct MapEntry {
937         bytes32 _key;
938         bytes32 _value;
939     }
940 
941     struct Map {
942         // Storage of map keys and values
943         MapEntry[] _entries;
944 
945         // Position of the entry defined by a key in the `entries` array, plus 1
946         // because index 0 means a key is not in the map.
947         mapping (bytes32 => uint256) _indexes;
948     }
949 
950     /**
951      * @dev Adds a key-value pair to a map, or updates the value for an existing
952      * key. O(1).
953      *
954      * Returns true if the key was added to the map, that is if it was not
955      * already present.
956      */
957     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
958         // We read and store the key's index to prevent multiple reads from the same storage slot
959         uint256 keyIndex = map._indexes[key];
960 
961         if (keyIndex == 0) { // Equivalent to !contains(map, key)
962             map._entries.push(MapEntry({ _key: key, _value: value }));
963             // The entry is stored at length-1, but we add 1 to all indexes
964             // and use 0 as a sentinel value
965             map._indexes[key] = map._entries.length;
966             return true;
967         } else {
968             map._entries[keyIndex - 1]._value = value;
969             return false;
970         }
971     }
972 
973     /**
974      * @dev Removes a key-value pair from a map. O(1).
975      *
976      * Returns true if the key was removed from the map, that is if it was present.
977      */
978     function _remove(Map storage map, bytes32 key) private returns (bool) {
979         // We read and store the key's index to prevent multiple reads from the same storage slot
980         uint256 keyIndex = map._indexes[key];
981 
982         if (keyIndex != 0) { // Equivalent to contains(map, key)
983             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
984             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
985             // This modifies the order of the array, as noted in {at}.
986 
987             uint256 toDeleteIndex = keyIndex - 1;
988             uint256 lastIndex = map._entries.length - 1;
989 
990             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
991             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
992 
993             MapEntry storage lastEntry = map._entries[lastIndex];
994 
995             // Move the last entry to the index where the entry to delete is
996             map._entries[toDeleteIndex] = lastEntry;
997             // Update the index for the moved entry
998             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
999 
1000             // Delete the slot where the moved entry was stored
1001             map._entries.pop();
1002 
1003             // Delete the index for the deleted slot
1004             delete map._indexes[key];
1005 
1006             return true;
1007         } else {
1008             return false;
1009         }
1010     }
1011 
1012     /**
1013      * @dev Returns true if the key is in the map. O(1).
1014      */
1015     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1016         return map._indexes[key] != 0;
1017     }
1018 
1019     /**
1020      * @dev Returns the number of key-value pairs in the map. O(1).
1021      */
1022     function _length(Map storage map) private view returns (uint256) {
1023         return map._entries.length;
1024     }
1025 
1026    /**
1027     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1028     *
1029     * Note that there are no guarantees on the ordering of entries inside the
1030     * array, and it may change when more entries are added or removed.
1031     *
1032     * Requirements:
1033     *
1034     * - `index` must be strictly less than {length}.
1035     */
1036     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1037         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1038 
1039         MapEntry storage entry = map._entries[index];
1040         return (entry._key, entry._value);
1041     }
1042 
1043     /**
1044      * @dev Tries to returns the value associated with `key`.  O(1).
1045      * Does not revert if `key` is not in the map.
1046      */
1047     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1048         uint256 keyIndex = map._indexes[key];
1049         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1050         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1051     }
1052 
1053     /**
1054      * @dev Returns the value associated with `key`.  O(1).
1055      *
1056      * Requirements:
1057      *
1058      * - `key` must be in the map.
1059      */
1060     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1061         uint256 keyIndex = map._indexes[key];
1062         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1063         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1064     }
1065 
1066     /**
1067      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1068      *
1069      * CAUTION: This function is deprecated because it requires allocating memory for the error
1070      * message unnecessarily. For custom revert reasons use {_tryGet}.
1071      */
1072     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1073         uint256 keyIndex = map._indexes[key];
1074         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1075         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1076     }
1077 
1078     // UintToAddressMap
1079 
1080     struct UintToAddressMap {
1081         Map _inner;
1082     }
1083 
1084     /**
1085      * @dev Adds a key-value pair to a map, or updates the value for an existing
1086      * key. O(1).
1087      *
1088      * Returns true if the key was added to the map, that is if it was not
1089      * already present.
1090      */
1091     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1092         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1093     }
1094 
1095     /**
1096      * @dev Removes a value from a set. O(1).
1097      *
1098      * Returns true if the key was removed from the map, that is if it was present.
1099      */
1100     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1101         return _remove(map._inner, bytes32(key));
1102     }
1103 
1104     /**
1105      * @dev Returns true if the key is in the map. O(1).
1106      */
1107     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1108         return _contains(map._inner, bytes32(key));
1109     }
1110 
1111     /**
1112      * @dev Returns the number of elements in the map. O(1).
1113      */
1114     function length(UintToAddressMap storage map) internal view returns (uint256) {
1115         return _length(map._inner);
1116     }
1117 
1118    /**
1119     * @dev Returns the element stored at position `index` in the set. O(1).
1120     * Note that there are no guarantees on the ordering of values inside the
1121     * array, and it may change when more values are added or removed.
1122     *
1123     * Requirements:
1124     *
1125     * - `index` must be strictly less than {length}.
1126     */
1127     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1128         (bytes32 key, bytes32 value) = _at(map._inner, index);
1129         return (uint256(key), address(uint160(uint256(value))));
1130     }
1131 
1132     /**
1133      * @dev Tries to returns the value associated with `key`.  O(1).
1134      * Does not revert if `key` is not in the map.
1135      *
1136      * _Available since v3.4._
1137      */
1138     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1139         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1140         return (success, address(uint160(uint256(value))));
1141     }
1142 
1143     /**
1144      * @dev Returns the value associated with `key`.  O(1).
1145      *
1146      * Requirements:
1147      *
1148      * - `key` must be in the map.
1149      */
1150     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1151         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1152     }
1153 
1154     /**
1155      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1156      *
1157      * CAUTION: This function is deprecated because it requires allocating memory for the error
1158      * message unnecessarily. For custom revert reasons use {tryGet}.
1159      */
1160     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1161         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1162     }
1163 }
1164 pragma solidity ^0.8.0;
1165 
1166 /**
1167  * @dev String operations.
1168  */
1169 library Strings {
1170     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1171 
1172     /**
1173      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1174      */
1175     function toString(uint256 value) internal pure returns (string memory) {
1176         // Inspired by OraclizeAPI's implementation - MIT licence
1177         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1178 
1179         if (value == 0) {
1180             return "0";
1181         }
1182         uint256 temp = value;
1183         uint256 digits;
1184         while (temp != 0) {
1185             digits++;
1186             temp /= 10;
1187         }
1188         bytes memory buffer = new bytes(digits);
1189         while (value != 0) {
1190             digits -= 1;
1191             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1192             value /= 10;
1193         }
1194         return string(buffer);
1195     }
1196 
1197     /**
1198      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1199      */
1200     function toHexString(uint256 value) internal pure returns (string memory) {
1201         if (value == 0) {
1202             return "0x00";
1203         }
1204         uint256 temp = value;
1205         uint256 length = 0;
1206         while (temp != 0) {
1207             length++;
1208             temp >>= 8;
1209         }
1210         return toHexString(value, length);
1211     }
1212 
1213     /**
1214      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1215      */
1216     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1217         bytes memory buffer = new bytes(2 * length + 2);
1218         buffer[0] = "0";
1219         buffer[1] = "x";
1220         for (uint256 i = 2 * length + 1; i > 1; --i) {
1221             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1222             value >>= 4;
1223         }
1224         require(value == 0, "Strings: hex length insufficient");
1225         return string(buffer);
1226     }
1227 }
1228 
1229 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1230 pragma solidity  ^0.8.0;
1231 
1232 /**
1233  * @title ERC721 Non-Fungible Token Standard basic implementation
1234  * @dev see https://eips.ethereum.org/EIPS/eip-721
1235  */
1236 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1237     using Address for address;
1238     using EnumerableSet for EnumerableSet.UintSet;
1239     using EnumerableMap for EnumerableMap.UintToAddressMap;
1240     using Strings for uint256;
1241 
1242     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1243     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1244     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1245 
1246     // Mapping from holder address to their (enumerable) set of owned tokens
1247     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1248 
1249     // Enumerable mapping from token ids to their owners
1250     EnumerableMap.UintToAddressMap private _tokenOwners;
1251 
1252     // Mapping from token ID to approved address
1253     mapping (uint256 => address) private _tokenApprovals;
1254 
1255     // Mapping from owner to operator approvals
1256     mapping (address => mapping (address => bool)) private _operatorApprovals;
1257 
1258     // Token name
1259     string private _name;
1260 
1261     // Token symbol
1262     string private _symbol;
1263 
1264 
1265     // Optional mapping for token URIs - not used with on-chain
1266     // mapping (uint256 => string) private _tokenURIs;
1267 
1268     // Base URI
1269     string private _baseURI;
1270 
1271     /*
1272      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1273      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1274      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1275      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1276      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1277      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1278      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1279      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1280      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1281      *
1282      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1283      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1284      */
1285     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1286 
1287     /*
1288      *     bytes4(keccak256('name()')) == 0x06fdde03
1289      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1290      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1291      *
1292      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1293      */
1294     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1295 
1296     /*
1297      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1298      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1299      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1300      *
1301      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1302      */
1303     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1304 
1305     /**
1306      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1307      */
1308     constructor (string memory name_, string memory symbol_) {
1309         _name = name_;
1310         _symbol = symbol_;
1311 
1312         // register the supported interfaces to conform to ERC721 via ERC165
1313         _registerInterface(_INTERFACE_ID_ERC721);
1314         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1315         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1316     }
1317 
1318 
1319 
1320     /**
1321      * @dev See {IERC721-balanceOf}.
1322      */
1323     function balanceOf(address owner) public view virtual override returns (uint256) {
1324         require(owner != address(0), "ERC721: balance query for the zero address");
1325         return _holderTokens[owner].length();
1326     }
1327 
1328     /**
1329      * @dev See {IERC721-ownerOf}.
1330      */
1331     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1332         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1333     }
1334 
1335     /**
1336      * @dev See {IERC721Metadata-name}.
1337      */
1338     function name() public view virtual override returns (string memory) {
1339         return _name;
1340     }
1341 
1342     /**
1343      * @dev See {IERC721Metadata-symbol}.
1344      */
1345     function symbol() public view virtual override returns (string memory) {
1346         return _symbol;
1347     }
1348 
1349     /**
1350      * @dev See {IERC721Metadata-tokenURI}.
1351      */
1352     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1353         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1354         // return json from folder
1355         // string memory output = string(abi.encodePacked(baseURI(), tokenId.toString(), ".json"));
1356         // return string(abi.encodePacked(baseURI(), tokenId.toString(), ".json"));
1357         return string(abi.encodePacked(baseURI(),tokenId.toString(),".json"));
1358 
1359         // return "hello";
1360     }
1361 
1362 
1363     //Return contract metadata for opensea view
1364     function contractURI() public view returns (string memory) {
1365         return string(abi.encodePacked(baseURI(), "contract_metadata", '.json'));
1366     }
1367 
1368     /**
1369     * @dev Returns the base URI set via {_setBaseURI}. This will be
1370     * automatically added as a prefix in {tokenURI} to each token's URI, or
1371     * to the token ID if no specific URI is set for that token ID.
1372     */
1373     function baseURI() public view virtual returns (string memory) {
1374         return _baseURI;
1375     }
1376 
1377      /**
1378      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1379      */
1380     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1381         return _holderTokens[owner].at(index);
1382     }
1383 
1384     /**
1385      * @dev See {IERC721Enumerable-totalSupply}.
1386      */
1387     function totalSupply() public view virtual override returns (uint256) {
1388         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1389         return _tokenOwners.length();
1390     }
1391 
1392     /**
1393      * @dev See {IERC721Enumerable-tokenByIndex}.
1394      */
1395     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1396         (uint256 tokenId, ) = _tokenOwners.at(index);
1397         return tokenId;
1398     }
1399 
1400     /**
1401      * @dev See {IERC721-approve}.
1402      */
1403     function approve(address to, uint256 tokenId) public virtual override {
1404         address owner = ERC721.ownerOf(tokenId);
1405         require(to != owner, "ERC721: approval to current owner");
1406 
1407         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1408             "ERC721: approve caller is not owner nor approved for all"
1409         );
1410 
1411         _approve(to, tokenId);
1412     }
1413 
1414     /**
1415      * @dev See {IERC721-getApproved}.
1416      */
1417     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1418         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1419 
1420         return _tokenApprovals[tokenId];
1421     }
1422 
1423     /**
1424      * @dev See {IERC721-setApprovalForAll}.
1425      */
1426     function setApprovalForAll(address operator, bool approved) public virtual override {
1427         require(operator != _msgSender(), "ERC721: approve to caller");
1428 
1429         _operatorApprovals[_msgSender()][operator] = approved;
1430         emit ApprovalForAll(_msgSender(), operator, approved);
1431     }
1432 
1433     /**
1434      * @dev See {IERC721-isApprovedForAll}.
1435      */
1436     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1437         return _operatorApprovals[owner][operator];
1438     }
1439 
1440     /**
1441      * @dev See {IERC721-transferFrom}.
1442      */
1443     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1444         //solhint-disable-next-line max-line-length
1445         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1446 
1447         _transfer(from, to, tokenId);
1448     }
1449 
1450     /**
1451      * @dev See {IERC721-safeTransferFrom}.
1452      */
1453     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1454         safeTransferFrom(from, to, tokenId, "");
1455     }
1456 
1457     /**
1458      * @dev See {IERC721-safeTransferFrom}.
1459      */
1460     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1461         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1462         _safeTransfer(from, to, tokenId, _data);
1463     }
1464 
1465     /**
1466      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1467      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1468      *
1469      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1470      *
1471      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1472      * implement alternative mechanisms to perform token transfer, such as signature-based.
1473      *
1474      * Requirements:
1475      *
1476      * - `from` cannot be the zero address.
1477      * - `to` cannot be the zero address.
1478      * - `tokenId` token must exist and be owned by `from`.
1479      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1480      *
1481      * Emits a {Transfer} event.
1482      */
1483     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1484         _transfer(from, to, tokenId);
1485         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1486     }
1487 
1488     /**
1489      * @dev Returns whether `tokenId` exists.
1490      *
1491      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1492      *
1493      * Tokens start existing when they are minted (`_mint`),
1494      * and stop existing when they are burned (`_burn`).
1495      */
1496     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1497         return _tokenOwners.contains(tokenId);
1498     }
1499 
1500     /**
1501      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1502      *
1503      * Requirements:
1504      *
1505      * - `tokenId` must exist.
1506      */
1507     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1508         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1509         address owner = ERC721.ownerOf(tokenId);
1510         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1511     }
1512 
1513     /**
1514      * @dev Safely mints `tokenId` and transfers it to `to`.
1515      *
1516      * Requirements:
1517      d*
1518      * - `tokenId` must not exist.
1519      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1520      *
1521      * Emits a {Transfer} event.
1522      */
1523     function _safeMint(address to, uint256 tokenId) internal virtual {
1524         _safeMint(to, tokenId, "");
1525     }
1526 
1527     /**
1528      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1529      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1530      */
1531     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1532         _mint(to, tokenId);
1533         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1534     }
1535 
1536     /**
1537      * @dev Mints `tokenId` and transfers it to `to`.
1538      *
1539      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1540      *
1541      * Requirements:
1542      *
1543      * - `tokenId` must not exist.
1544      * - `to` cannot be the zero address.
1545      *
1546      * Emits a {Transfer} event.
1547      */
1548     function _mint(address to, uint256 tokenId) internal virtual {
1549         require(to != address(0), "ERC721: mint to the zero address");
1550         require(!_exists(tokenId), "ERC721: token already minted");
1551 
1552         _beforeTokenTransfer(address(0), to, tokenId);
1553 
1554         _holderTokens[to].add(tokenId);
1555 
1556         _tokenOwners.set(tokenId, to);
1557 
1558         emit Transfer(address(0), to, tokenId);
1559     }
1560 
1561     /**
1562      * @dev Destroys `tokenId`.
1563      * The approval is cleared when the token is burned.
1564      *
1565      * Requirements:
1566      *
1567      * - `tokenId` must exist.
1568      *
1569      * Emits a {Transfer} event.
1570      */
1571     function _burn(uint256 tokenId) internal virtual {
1572         address owner = ERC721.ownerOf(tokenId); // internal owner
1573 
1574         _beforeTokenTransfer(owner, address(0), tokenId);
1575 
1576         // Clear approvals
1577         _approve(address(0), tokenId);
1578 
1579         // Clear metadata (if any)
1580         // if (bytes(_tokenURIs[tokenId]).length != 0) {
1581         //     delete _tokenURIs[tokenId];
1582         // }
1583 
1584         _holderTokens[owner].remove(tokenId);
1585 
1586         _tokenOwners.remove(tokenId);
1587 
1588         emit Transfer(owner, address(0), tokenId);
1589     }
1590 
1591     /**
1592      * @dev Transfers `tokenId` from `from` to `to`.
1593      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1594      *
1595      * Requirements:
1596      *
1597      * - `to` cannot be the zero address.
1598      * - `tokenId` token must be owned by `from`.
1599      *
1600      * Emits a {Transfer} event.
1601      */
1602     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1603         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1604         require(to != address(0), "ERC721: transfer to the zero address");
1605 
1606         _beforeTokenTransfer(from, to, tokenId);
1607 
1608         // Clear approvals from the previous owner
1609         _approve(address(0), tokenId);
1610 
1611         _holderTokens[from].remove(tokenId);
1612         _holderTokens[to].add(tokenId);
1613 
1614         _tokenOwners.set(tokenId, to);
1615 
1616         emit Transfer(from, to, tokenId);
1617     }
1618 
1619     /**
1620      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1621      *
1622      * Requirements:
1623      *
1624      * - `tokenId` must exist.
1625      */
1626     // function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1627     //     require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1628     //     _tokenURIs[tokenId] = _tokenURI;
1629     // }
1630 
1631     /**
1632      * @dev Internal function to set the base URI for all token IDs. It is
1633      * automatically added as a prefix to the value returned in {tokenURI},
1634      * or to the token ID if {tokenURI} is empty.
1635      */
1636     function _setBaseURI(string memory baseURI_) internal virtual {
1637         _baseURI = baseURI_;
1638     }
1639 
1640     /**
1641      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1642      * The call is not executed if the target address is not a contract.
1643      *
1644      * @param from address representing the previous owner of the given token ID
1645      * @param to target address that will receive the tokens
1646      * @param tokenId uint256 ID of the token to be transferred
1647      * @param _data bytes optional data to send along with the call
1648      * @return bool whether the call correctly returned the expected magic value
1649      */
1650     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1651         private returns (bool)
1652     {
1653         if (!to.isContract()) {
1654             return true;
1655         }
1656         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1657             IERC721Receiver(to).onERC721Received.selector,
1658             _msgSender(),
1659             from,
1660             tokenId,
1661             _data
1662         ), "ERC721: transfer to non ERC721Receiver implementer");
1663         bytes4 retval = abi.decode(returndata, (bytes4));
1664         return (retval == _ERC721_RECEIVED);
1665     }
1666 
1667     function _approve(address to, uint256 tokenId) private {
1668         _tokenApprovals[tokenId] = to;
1669         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1670     }
1671 
1672     /**
1673      * @dev Hook that is called before any token transfer. This includes minting
1674      * and burning.
1675      *
1676      * Calling conditions:
1677      *
1678      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1679      * transferred to `to`.
1680      * - When `from` is zero, `tokenId` will be minted for `to`.
1681      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1682      * - `from` cannot be the zero address.
1683      * - `to` cannot be the zero address.
1684      *
1685      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1686      */
1687     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1688 }
1689 
1690 
1691 // File: contracts/Rocks721.sol
1692 pragma solidity  ^0.8.0;
1693 
1694 /**
1695  * @dev {ERC721} token, including:
1696  *
1697  *  - ability for holders to burn (destroy) their tokens
1698  *  - a minter role that allows for token minting (creation)
1699  *  - token ID and URI autogeneration
1700  *
1701  * This contract uses {AccessControl} to lock permissioned functions using the
1702  * different roles - head to its documentation for details.
1703  *
1704  * The account that deploys the contract will be granted the minter and pauser
1705  * roles, as well as the default admin role, which will let it grant both minter
1706  * and pauser roles to other accounts.
1707  */
1708 
1709 contract Rocks721 is Context, ERC721, Ownable {
1710 
1711     address payable public withdrawalAddress;
1712 
1713     //Token sale control logic
1714     uint256 public maxNumberOfPieces;
1715     uint256 public tokenCounter;
1716 
1717     //Standard sale
1718     bool public standardSaleActive;
1719     uint256 public pricePerPiece;
1720 
1721     //Presale
1722     bool public preSaleActive;
1723     mapping (address => uint256) public whitelisted;
1724     mapping (address => uint256) public preSaleMinted;
1725     mapping (uint256 => uint256) public reservedTokens;
1726     mapping (address => uint256[]) public giftTokens;
1727 
1728     event Purchase(address buyer, uint256 price, uint256 [] tokenIds);
1729     event MetadataUpdated(string newTokenUriBase);
1730 
1731     constructor(
1732         uint256 givenPricePerPiece,
1733         address payable givenWithdrawalAddress,
1734         string memory givenTokenURIBase
1735     ) ERC721("UNSHADED ROCKS", "ROCK") {
1736         pricePerPiece = givenPricePerPiece;
1737         withdrawalAddress = givenWithdrawalAddress;
1738         _setBaseURI(givenTokenURIBase);
1739         maxNumberOfPieces = 9999;
1740         tokenCounter = 0;
1741     }
1742 
1743     //Change base uri 
1744      function updateBaseURI(string memory givenTokenURIBase) public onlyOwner{
1745         _setBaseURI(givenTokenURIBase);
1746     }
1747 
1748     function setWhitelistAddress(address[] memory users, uint256[][] memory givenGiftTokens) public onlyOwner {
1749         for (uint256 i = 0; i < users.length; i++) {
1750             //use the users address as a key and set the limit to 100
1751             whitelisted[users[i]] = 100;
1752             giftTokens[users[i]] = givenGiftTokens[i];
1753             for( uint256 j = 0; j< givenGiftTokens[i].length; j ++){
1754                 reservedTokens[givenGiftTokens[i][j]] = 1;
1755             }
1756         }
1757     }
1758 
1759     function claimGift() public {
1760         require(whitelisted[msg.sender] > 0, "address not on whitelist ");
1761         for(uint256 i = 0; i < giftTokens[msg.sender].length; i ++){
1762             _safeMint( msg.sender, giftTokens[msg.sender][i]);
1763         }
1764     }
1765 
1766     //Input list of reserved tokens 
1767     function setReservedTokens(uint256[] memory givenReservedTokens) public onlyOwner{
1768         for(uint256 i = 0; i < givenReservedTokens.length; i ++){
1769             reservedTokens[givenReservedTokens[i]] = 1;
1770         }
1771     }
1772 
1773     //Sale logic
1774     function setPresaleActive(bool isActive) public onlyOwner{
1775         preSaleActive = isActive;
1776     }
1777 
1778     function setSaleActive(bool isActive) public onlyOwner {
1779         standardSaleActive = isActive;
1780     }
1781 
1782     //Price setting
1783     function setPrice(uint256 givenPrice) external onlyOwner {
1784         pricePerPiece = givenPrice;
1785     }
1786 
1787     //Withdrawal
1788     function setWithdrawalAddress(address payable givenWithdrawalAddress) public onlyOwner {
1789         withdrawalAddress = givenWithdrawalAddress;
1790     }
1791 
1792     function withdrawEth() public onlyOwner {
1793         Address.sendValue(withdrawalAddress, address(this).balance);
1794     }
1795 
1796     //Owner info
1797     function tokenInfo(uint256 tokenId) public view returns (address) {
1798         return (ownerOf(tokenId));
1799     }
1800 
1801     function getOwners(uint256 start, uint256 end) public view returns (address[] memory){
1802         address[] memory re = new address[](end - start);
1803         for (uint256 i = start; i < end; i++) {
1804                 re[i - start] = ownerOf(i);
1805         }
1806         return re;
1807     }
1808 
1809     //Update the token counter position
1810     function setTokenCounter(uint256 givenTokenCounter) public onlyOwner{
1811         tokenCounter = givenTokenCounter;
1812     }
1813 
1814     function artistMint(uint256 tokenId) public onlyOwner {
1815         reservedTokens[tokenId] = 1;
1816         _safeMint(msg.sender, tokenId);
1817     }
1818     
1819     function earlyMint() public payable {
1820         require(preSaleActive, "early sale not open");
1821         require(whitelisted[msg.sender] > 0, "address not on whitelist ");
1822         require(whitelisted[msg.sender] > preSaleMinted[msg.sender], "exceeded number allowed");
1823         preSaleMinted[msg.sender] += 1;
1824         mintItem();
1825     }
1826 
1827     function mint() public payable {
1828         require(standardSaleActive || msg.sender == owner(), "sale not open");
1829         mintItem();
1830     }
1831 
1832     function mintItem() private returns (uint256 [] memory) {
1833         require(msg.value >= pricePerPiece, "not enough eth sent");
1834         require(msg.value <= 1000000000000000000, "cannot send in more than 1 eth");
1835                              
1836         uint256 amount = msg.value / pricePerPiece;  
1837         //amount will always be at least one so we need to add one to our max for proper comparison
1838         require(tokenCounter + amount <= maxNumberOfPieces + 1, " tokens sold out or too many tokens requested ");
1839         uint256 [] memory tokensMinted = new uint256[](amount);
1840 
1841         for(uint256 i = 0; i < amount; i ++){
1842             
1843             //If the token has been reserved or already minted then skip it 
1844             while(reservedTokens[tokenCounter] > 0 || _exists(tokenCounter)){
1845                 tokenCounter += 1;
1846             }
1847 
1848             _safeMint(msg.sender, tokenCounter);
1849             //save minted tokens to list
1850             tokensMinted[i] = tokenCounter;
1851             tokenCounter += 1;
1852         }
1853 
1854         emit Purchase(msg.sender, msg.value, tokensMinted);
1855         return tokensMinted;
1856     }
1857 }