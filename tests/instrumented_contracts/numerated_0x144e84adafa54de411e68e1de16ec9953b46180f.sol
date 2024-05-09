1 pragma solidity ^0.8.0;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes calldata) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 
14 abstract contract Ownable is Context {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor () {
23         address msgSender = _msgSender();
24         _owner = msgSender;
25         emit OwnershipTransferred(address(0), msgSender);
26     }
27 
28     /**
29      * @dev Returns the address of the current owner.
30      */
31     function owner() public view virtual returns (address) {
32         return _owner;
33     }
34 
35     /**
36      * @dev Throws if called by any account other than the owner.
37      */
38     modifier onlyOwner() {
39         require(owner() == _msgSender(), "Ownable: caller is not the owner");
40         _;
41     }
42 
43     /**
44      * @dev Leaves the contract without owner. It will not be possible to call
45      * `onlyOwner` functions anymore. Can only be called by the current owner.
46      *
47      * NOTE: Renouncing ownership will leave the contract without an owner,
48      * thereby removing any functionality that is only available to the owner.
49      */
50     function renounceOwnership() public virtual onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Transfers ownership of the contract to a new account (`newOwner`).
57      * Can only be called by the current owner.
58      */
59     function transferOwnership(address newOwner) public virtual onlyOwner {
60         require(newOwner != address(0), "Ownable: new owner is the zero address");
61         emit OwnershipTransferred(_owner, newOwner);
62         _owner = newOwner;
63     }
64 }
65 
66 interface IERC721Receiver {
67     /**
68      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
69      * by `operator` from `from`, this function is called.
70      *
71      * It must return its Solidity selector to confirm the token transfer.
72      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
73      *
74      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
75      */
76     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
77 }
78 
79 interface IERC165 {
80     /**
81      * @dev Returns true if this contract implements the interface defined by
82      * `interfaceId`. See the corresponding
83      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
84      * to learn more about how these ids are created.
85      *
86      * This function call must use less than 30 000 gas.
87      */
88     function supportsInterface(bytes4 interfaceId) external view returns (bool);
89 }
90 
91 interface IERC721 is IERC165 {
92     /**
93      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
96 
97     /**
98      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
99      */
100     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
101 
102     /**
103      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
104      */
105     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
106 
107     /**
108      * @dev Returns the number of tokens in ``owner``'s account.
109      */
110     function balanceOf(address owner) external view returns (uint256 balance);
111 
112     /**
113      * @dev Returns the owner of the `tokenId` token.
114      *
115      * Requirements:
116      *
117      * - `tokenId` must exist.
118      */
119     function ownerOf(uint256 tokenId) external view returns (address owner);
120 
121     /**
122      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
123      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
124      *
125      * Requirements:
126      *
127      * - `from` cannot be the zero address.
128      * - `to` cannot be the zero address.
129      * - `tokenId` token must exist and be owned by `from`.
130      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
131      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
132      *
133      * Emits a {Transfer} event.
134      */
135     function safeTransferFrom(address from, address to, uint256 tokenId) external;
136 
137     /**
138      * @dev Transfers `tokenId` token from `from` to `to`.
139      *
140      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
141      *
142      * Requirements:
143      *
144      * - `from` cannot be the zero address.
145      * - `to` cannot be the zero address.
146      * - `tokenId` token must be owned by `from`.
147      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transferFrom(address from, address to, uint256 tokenId) external;
152 
153     /**
154      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
155      * The approval is cleared when the token is transferred.
156      *
157      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
158      *
159      * Requirements:
160      *
161      * - The caller must own the token or be an approved operator.
162      * - `tokenId` must exist.
163      *
164      * Emits an {Approval} event.
165      */
166     function approve(address to, uint256 tokenId) external;
167 
168     /**
169      * @dev Returns the account approved for `tokenId` token.
170      *
171      * Requirements:
172      *
173      * - `tokenId` must exist.
174      */
175     function getApproved(uint256 tokenId) external view returns (address operator);
176 
177     /**
178      * @dev Approve or remove `operator` as an operator for the caller.
179      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
180      *
181      * Requirements:
182      *
183      * - The `operator` cannot be the caller.
184      *
185      * Emits an {ApprovalForAll} event.
186      */
187     function setApprovalForAll(address operator, bool _approved) external;
188 
189     /**
190      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
191      *
192      * See {setApprovalForAll}
193      */
194     function isApprovedForAll(address owner, address operator) external view returns (bool);
195 
196     /**
197       * @dev Safely transfers `tokenId` token from `from` to `to`.
198       *
199       * Requirements:
200       *
201       * - `from` cannot be the zero address.
202       * - `to` cannot be the zero address.
203       * - `tokenId` token must exist and be owned by `from`.
204       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
205       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
206       *
207       * Emits a {Transfer} event.
208       */
209     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
210 }
211 
212 interface IERC721Metadata is IERC721 {
213 
214     /**
215      * @dev Returns the token collection name.
216      */
217     function name() external view returns (string memory);
218 
219     /**
220      * @dev Returns the token collection symbol.
221      */
222     function symbol() external view returns (string memory);
223 
224     /**
225      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
226      */
227     function tokenURI(uint256 tokenId) external view returns (string memory);
228 }
229 
230 interface IERC721Enumerable is IERC721 {
231 
232     /**
233      * @dev Returns the total amount of tokens stored by the contract.
234      */
235     function totalSupply() external view returns (uint256);
236 
237     /**
238      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
239      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
240      */
241     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
242 
243     /**
244      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
245      * Use along with {totalSupply} to enumerate all tokens.
246      */
247     function tokenByIndex(uint256 index) external view returns (uint256);
248 }
249 
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // This method relies on extcodesize, which returns 0 for contracts in
270         // construction, since the code is only stored at the end of the
271         // constructor execution.
272 
273         uint256 size;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { size := extcodesize(account) }
276         return size > 0;
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299         (bool success, ) = recipient.call{ value: amount }("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain`call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322       return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         require(isContract(target), "Address: call to non-contract");
359 
360         // solhint-disable-next-line avoid-low-level-calls
361         (bool success, bytes memory returndata) = target.call{ value: value }(data);
362         return _verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
372         return functionStaticCall(target, data, "Address: low-level static call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
382         require(isContract(target), "Address: static call to non-contract");
383 
384         // solhint-disable-next-line avoid-low-level-calls
385         (bool success, bytes memory returndata) = target.staticcall(data);
386         return _verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
391      * but performing a delegate call.
392      *
393      * _Available since v3.4._
394      */
395     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
396         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
401      * but performing a delegate call.
402      *
403      * _Available since v3.4._
404      */
405     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
406         require(isContract(target), "Address: delegate call to non-contract");
407 
408         // solhint-disable-next-line avoid-low-level-calls
409         (bool success, bytes memory returndata) = target.delegatecall(data);
410         return _verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
414         if (success) {
415             return returndata;
416         } else {
417             // Look for revert reason and bubble it up if present
418             if (returndata.length > 0) {
419                 // The easiest way to bubble the revert reason is using memory via assembly
420 
421                 // solhint-disable-next-line no-inline-assembly
422                 assembly {
423                     let returndata_size := mload(returndata)
424                     revert(add(32, returndata), returndata_size)
425                 }
426             } else {
427                 revert(errorMessage);
428             }
429         }
430     }
431 }
432 
433 library Strings {
434     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
435 
436     /**
437      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
438      */
439     function toString(uint256 value) internal pure returns (string memory) {
440         // Inspired by OraclizeAPI's implementation - MIT licence
441         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
442 
443         if (value == 0) {
444             return "0";
445         }
446         uint256 temp = value;
447         uint256 digits;
448         while (temp != 0) {
449             digits++;
450             temp /= 10;
451         }
452         bytes memory buffer = new bytes(digits);
453         while (value != 0) {
454             digits -= 1;
455             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
456             value /= 10;
457         }
458         return string(buffer);
459     }
460 }
461 
462 library EnumerableSet {
463     // To implement this library for multiple types with as little code
464     // repetition as possible, we write it in terms of a generic Set type with
465     // bytes32 values.
466     // The Set implementation uses private functions, and user-facing
467     // implementations (such as AddressSet) are just wrappers around the
468     // underlying Set.
469     // This means that we can only create new EnumerableSets for types that fit
470     // in bytes32.
471 
472     struct Set {
473         // Storage of set values
474         bytes32[] _values;
475 
476         // Position of the value in the `values` array, plus 1 because index 0
477         // means a value is not in the set.
478         mapping (bytes32 => uint256) _indexes;
479     }
480 
481     /**
482      * @dev Add a value to a set. O(1).
483      *
484      * Returns true if the value was added to the set, that is if it was not
485      * already present.
486      */
487     function _add(Set storage set, bytes32 value) private returns (bool) {
488         if (!_contains(set, value)) {
489             set._values.push(value);
490             // The value is stored at length-1, but we add 1 to all indexes
491             // and use 0 as a sentinel value
492             set._indexes[value] = set._values.length;
493             return true;
494         } else {
495             return false;
496         }
497     }
498 
499     /**
500      * @dev Removes a value from a set. O(1).
501      *
502      * Returns true if the value was removed from the set, that is if it was
503      * present.
504      */
505     function _remove(Set storage set, bytes32 value) private returns (bool) {
506         // We read and store the value's index to prevent multiple reads from the same storage slot
507         uint256 valueIndex = set._indexes[value];
508 
509         if (valueIndex != 0) { // Equivalent to contains(set, value)
510             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
511             // the array, and then remove the last element (sometimes called as 'swap and pop').
512             // This modifies the order of the array, as noted in {at}.
513 
514             uint256 toDeleteIndex = valueIndex - 1;
515             uint256 lastIndex = set._values.length - 1;
516 
517             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
518             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
519 
520             bytes32 lastvalue = set._values[lastIndex];
521 
522             // Move the last value to the index where the value to delete is
523             set._values[toDeleteIndex] = lastvalue;
524             // Update the index for the moved value
525             set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
526 
527             // Delete the slot where the moved value was stored
528             set._values.pop();
529 
530             // Delete the index for the deleted slot
531             delete set._indexes[value];
532 
533             return true;
534         } else {
535             return false;
536         }
537     }
538 
539     /**
540      * @dev Returns true if the value is in the set. O(1).
541      */
542     function _contains(Set storage set, bytes32 value) private view returns (bool) {
543         return set._indexes[value] != 0;
544     }
545 
546     /**
547      * @dev Returns the number of values on the set. O(1).
548      */
549     function _length(Set storage set) private view returns (uint256) {
550         return set._values.length;
551     }
552 
553    /**
554     * @dev Returns the value stored at position `index` in the set. O(1).
555     *
556     * Note that there are no guarantees on the ordering of values inside the
557     * array, and it may change when more values are added or removed.
558     *
559     * Requirements:
560     *
561     * - `index` must be strictly less than {length}.
562     */
563     function _at(Set storage set, uint256 index) private view returns (bytes32) {
564         require(set._values.length > index, "EnumerableSet: index out of bounds");
565         return set._values[index];
566     }
567 
568     // Bytes32Set
569 
570     struct Bytes32Set {
571         Set _inner;
572     }
573 
574     /**
575      * @dev Add a value to a set. O(1).
576      *
577      * Returns true if the value was added to the set, that is if it was not
578      * already present.
579      */
580     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
581         return _add(set._inner, value);
582     }
583 
584     /**
585      * @dev Removes a value from a set. O(1).
586      *
587      * Returns true if the value was removed from the set, that is if it was
588      * present.
589      */
590     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
591         return _remove(set._inner, value);
592     }
593 
594     /**
595      * @dev Returns true if the value is in the set. O(1).
596      */
597     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
598         return _contains(set._inner, value);
599     }
600 
601     /**
602      * @dev Returns the number of values in the set. O(1).
603      */
604     function length(Bytes32Set storage set) internal view returns (uint256) {
605         return _length(set._inner);
606     }
607 
608    /**
609     * @dev Returns the value stored at position `index` in the set. O(1).
610     *
611     * Note that there are no guarantees on the ordering of values inside the
612     * array, and it may change when more values are added or removed.
613     *
614     * Requirements:
615     *
616     * - `index` must be strictly less than {length}.
617     */
618     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
619         return _at(set._inner, index);
620     }
621 
622     // AddressSet
623 
624     struct AddressSet {
625         Set _inner;
626     }
627 
628     /**
629      * @dev Add a value to a set. O(1).
630      *
631      * Returns true if the value was added to the set, that is if it was not
632      * already present.
633      */
634     function add(AddressSet storage set, address value) internal returns (bool) {
635         return _add(set._inner, bytes32(uint256(uint160(value))));
636     }
637 
638     /**
639      * @dev Removes a value from a set. O(1).
640      *
641      * Returns true if the value was removed from the set, that is if it was
642      * present.
643      */
644     function remove(AddressSet storage set, address value) internal returns (bool) {
645         return _remove(set._inner, bytes32(uint256(uint160(value))));
646     }
647 
648     /**
649      * @dev Returns true if the value is in the set. O(1).
650      */
651     function contains(AddressSet storage set, address value) internal view returns (bool) {
652         return _contains(set._inner, bytes32(uint256(uint160(value))));
653     }
654 
655     /**
656      * @dev Returns the number of values in the set. O(1).
657      */
658     function length(AddressSet storage set) internal view returns (uint256) {
659         return _length(set._inner);
660     }
661 
662    /**
663     * @dev Returns the value stored at position `index` in the set. O(1).
664     *
665     * Note that there are no guarantees on the ordering of values inside the
666     * array, and it may change when more values are added or removed.
667     *
668     * Requirements:
669     *
670     * - `index` must be strictly less than {length}.
671     */
672     function at(AddressSet storage set, uint256 index) internal view returns (address) {
673         return address(uint160(uint256(_at(set._inner, index))));
674     }
675 
676 
677     // UintSet
678 
679     struct UintSet {
680         Set _inner;
681     }
682 
683     /**
684      * @dev Add a value to a set. O(1).
685      *
686      * Returns true if the value was added to the set, that is if it was not
687      * already present.
688      */
689     function add(UintSet storage set, uint256 value) internal returns (bool) {
690         return _add(set._inner, bytes32(value));
691     }
692 
693     /**
694      * @dev Removes a value from a set. O(1).
695      *
696      * Returns true if the value was removed from the set, that is if it was
697      * present.
698      */
699     function remove(UintSet storage set, uint256 value) internal returns (bool) {
700         return _remove(set._inner, bytes32(value));
701     }
702 
703     /**
704      * @dev Returns true if the value is in the set. O(1).
705      */
706     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
707         return _contains(set._inner, bytes32(value));
708     }
709 
710     /**
711      * @dev Returns the number of values on the set. O(1).
712      */
713     function length(UintSet storage set) internal view returns (uint256) {
714         return _length(set._inner);
715     }
716 
717    /**
718     * @dev Returns the value stored at position `index` in the set. O(1).
719     *
720     * Note that there are no guarantees on the ordering of values inside the
721     * array, and it may change when more values are added or removed.
722     *
723     * Requirements:
724     *
725     * - `index` must be strictly less than {length}.
726     */
727     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
728         return uint256(_at(set._inner, index));
729     }
730 }
731 
732 library EnumerableMap {
733     using EnumerableSet for EnumerableSet.Bytes32Set;
734 
735     // To implement this library for multiple types with as little code
736     // repetition as possible, we write it in terms of a generic Map type with
737     // bytes32 keys and values.
738     // The Map implementation uses private functions, and user-facing
739     // implementations (such as Uint256ToAddressMap) are just wrappers around
740     // the underlying Map.
741     // This means that we can only create new EnumerableMaps for types that fit
742     // in bytes32.
743 
744     struct Map {
745         // Storage of keys
746         EnumerableSet.Bytes32Set _keys;
747 
748         mapping (bytes32 => bytes32) _values;
749     }
750 
751     /**
752      * @dev Adds a key-value pair to a map, or updates the value for an existing
753      * key. O(1).
754      *
755      * Returns true if the key was added to the map, that is if it was not
756      * already present.
757      */
758     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
759         map._values[key] = value;
760         return map._keys.add(key);
761     }
762 
763     /**
764      * @dev Removes a key-value pair from a map. O(1).
765      *
766      * Returns true if the key was removed from the map, that is if it was present.
767      */
768     function _remove(Map storage map, bytes32 key) private returns (bool) {
769         delete map._values[key];
770         return map._keys.remove(key);
771     }
772 
773     /**
774      * @dev Returns true if the key is in the map. O(1).
775      */
776     function _contains(Map storage map, bytes32 key) private view returns (bool) {
777         return map._keys.contains(key);
778     }
779 
780     /**
781      * @dev Returns the number of key-value pairs in the map. O(1).
782      */
783     function _length(Map storage map) private view returns (uint256) {
784         return map._keys.length();
785     }
786 
787    /**
788     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
789     *
790     * Note that there are no guarantees on the ordering of entries inside the
791     * array, and it may change when more entries are added or removed.
792     *
793     * Requirements:
794     *
795     * - `index` must be strictly less than {length}.
796     */
797     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
798         bytes32 key = map._keys.at(index);
799         return (key, map._values[key]);
800     }
801 
802     /**
803      * @dev Tries to returns the value associated with `key`.  O(1).
804      * Does not revert if `key` is not in the map.
805      */
806     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
807         bytes32 value = map._values[key];
808         if (value == bytes32(0)) {
809             return (_contains(map, key), bytes32(0));
810         } else {
811             return (true, value);
812         }
813     }
814 
815     /**
816      * @dev Returns the value associated with `key`.  O(1).
817      *
818      * Requirements:
819      *
820      * - `key` must be in the map.
821      */
822     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
823         bytes32 value = map._values[key];
824         require(value != 0 || _contains(map, key), "EnumerableMap: nonexistent key");
825         return value;
826     }
827 
828     /**
829      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
830      *
831      * CAUTION: This function is deprecated because it requires allocating memory for the error
832      * message unnecessarily. For custom revert reasons use {_tryGet}.
833      */
834     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
835         bytes32 value = map._values[key];
836         require(value != 0 || _contains(map, key), errorMessage);
837         return value;
838     }
839 
840     // UintToAddressMap
841 
842     struct UintToAddressMap {
843         Map _inner;
844     }
845 
846     /**
847      * @dev Adds a key-value pair to a map, or updates the value for an existing
848      * key. O(1).
849      *
850      * Returns true if the key was added to the map, that is if it was not
851      * already present.
852      */
853     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
854         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
855     }
856 
857     /**
858      * @dev Removes a value from a set. O(1).
859      *
860      * Returns true if the key was removed from the map, that is if it was present.
861      */
862     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
863         return _remove(map._inner, bytes32(key));
864     }
865 
866     /**
867      * @dev Returns true if the key is in the map. O(1).
868      */
869     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
870         return _contains(map._inner, bytes32(key));
871     }
872 
873     /**
874      * @dev Returns the number of elements in the map. O(1).
875      */
876     function length(UintToAddressMap storage map) internal view returns (uint256) {
877         return _length(map._inner);
878     }
879 
880    /**
881     * @dev Returns the element stored at position `index` in the set. O(1).
882     * Note that there are no guarantees on the ordering of values inside the
883     * array, and it may change when more values are added or removed.
884     *
885     * Requirements:
886     *
887     * - `index` must be strictly less than {length}.
888     */
889     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
890         (bytes32 key, bytes32 value) = _at(map._inner, index);
891         return (uint256(key), address(uint160(uint256(value))));
892     }
893 
894     /**
895      * @dev Tries to returns the value associated with `key`.  O(1).
896      * Does not revert if `key` is not in the map.
897      *
898      * _Available since v3.4._
899      */
900     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
901         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
902         return (success, address(uint160(uint256(value))));
903     }
904 
905     /**
906      * @dev Returns the value associated with `key`.  O(1).
907      *
908      * Requirements:
909      *
910      * - `key` must be in the map.
911      */
912     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
913         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
914     }
915 
916     /**
917      * @dev Same as {get}, with a custom error message when `key` is not in the map.
918      *
919      * CAUTION: This function is deprecated because it requires allocating memory for the error
920      * message unnecessarily. For custom revert reasons use {tryGet}.
921      */
922     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
923         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
924     }
925 }
926 
927 library SafeMath {
928     /**
929      * @dev Returns the addition of two unsigned integers, with an overflow flag.
930      *
931      * _Available since v3.4._
932      */
933     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
934         uint256 c = a + b;
935         if (c < a) return (false, 0);
936         return (true, c);
937     }
938 
939     /**
940      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
941      *
942      * _Available since v3.4._
943      */
944     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
945         if (b > a) return (false, 0);
946         return (true, a - b);
947     }
948 
949     /**
950      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
951      *
952      * _Available since v3.4._
953      */
954     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
955         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
956         // benefit is lost if 'b' is also tested.
957         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
958         if (a == 0) return (true, 0);
959         uint256 c = a * b;
960         if (c / a != b) return (false, 0);
961         return (true, c);
962     }
963 
964     /**
965      * @dev Returns the division of two unsigned integers, with a division by zero flag.
966      *
967      * _Available since v3.4._
968      */
969     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
970         if (b == 0) return (false, 0);
971         return (true, a / b);
972     }
973 
974     /**
975      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
976      *
977      * _Available since v3.4._
978      */
979     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
980         if (b == 0) return (false, 0);
981         return (true, a % b);
982     }
983 
984     /**
985      * @dev Returns the addition of two unsigned integers, reverting on
986      * overflow.
987      *
988      * Counterpart to Solidity's `+` operator.
989      *
990      * Requirements:
991      *
992      * - Addition cannot overflow.
993      */
994     function add(uint256 a, uint256 b) internal pure returns (uint256) {
995         uint256 c = a + b;
996         require(c >= a, "SafeMath: addition overflow");
997         return c;
998     }
999 
1000     /**
1001      * @dev Returns the subtraction of two unsigned integers, reverting on
1002      * overflow (when the result is negative).
1003      *
1004      * Counterpart to Solidity's `-` operator.
1005      *
1006      * Requirements:
1007      *
1008      * - Subtraction cannot overflow.
1009      */
1010     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1011         require(b <= a, "SafeMath: subtraction overflow");
1012         return a - b;
1013     }
1014 
1015     /**
1016      * @dev Returns the multiplication of two unsigned integers, reverting on
1017      * overflow.
1018      *
1019      * Counterpart to Solidity's `*` operator.
1020      *
1021      * Requirements:
1022      *
1023      * - Multiplication cannot overflow.
1024      */
1025     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1026         if (a == 0) return 0;
1027         uint256 c = a * b;
1028         require(c / a == b, "SafeMath: multiplication overflow");
1029         return c;
1030     }
1031 
1032     /**
1033      * @dev Returns the integer division of two unsigned integers, reverting on
1034      * division by zero. The result is rounded towards zero.
1035      *
1036      * Counterpart to Solidity's `/` operator. Note: this function uses a
1037      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1038      * uses an invalid opcode to revert (consuming all remaining gas).
1039      *
1040      * Requirements:
1041      *
1042      * - The divisor cannot be zero.
1043      */
1044     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1045         require(b > 0, "SafeMath: division by zero");
1046         return a / b;
1047     }
1048 
1049     /**
1050      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1051      * reverting when dividing by zero.
1052      *
1053      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1054      * opcode (which leaves remaining gas untouched) while Solidity uses an
1055      * invalid opcode to revert (consuming all remaining gas).
1056      *
1057      * Requirements:
1058      *
1059      * - The divisor cannot be zero.
1060      */
1061     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1062         require(b > 0, "SafeMath: modulo by zero");
1063         return a % b;
1064     }
1065 
1066     /**
1067      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1068      * overflow (when the result is negative).
1069      *
1070      * CAUTION: This function is deprecated because it requires allocating memory for the error
1071      * message unnecessarily. For custom revert reasons use {trySub}.
1072      *
1073      * Counterpart to Solidity's `-` operator.
1074      *
1075      * Requirements:
1076      *
1077      * - Subtraction cannot overflow.
1078      */
1079     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1080         require(b <= a, errorMessage);
1081         return a - b;
1082     }
1083 
1084     /**
1085      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1086      * division by zero. The result is rounded towards zero.
1087      *
1088      * CAUTION: This function is deprecated because it requires allocating memory for the error
1089      * message unnecessarily. For custom revert reasons use {tryDiv}.
1090      *
1091      * Counterpart to Solidity's `/` operator. Note: this function uses a
1092      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1093      * uses an invalid opcode to revert (consuming all remaining gas).
1094      *
1095      * Requirements:
1096      *
1097      * - The divisor cannot be zero.
1098      */
1099     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1100         require(b > 0, errorMessage);
1101         return a / b;
1102     }
1103 
1104     /**
1105      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1106      * reverting with custom message when dividing by zero.
1107      *
1108      * CAUTION: This function is deprecated because it requires allocating memory for the error
1109      * message unnecessarily. For custom revert reasons use {tryMod}.
1110      *
1111      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1112      * opcode (which leaves remaining gas untouched) while Solidity uses an
1113      * invalid opcode to revert (consuming all remaining gas).
1114      *
1115      * Requirements:
1116      *
1117      * - The divisor cannot be zero.
1118      */
1119     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1120         require(b > 0, errorMessage);
1121         return a % b;
1122     }
1123 }
1124 
1125 abstract contract ERC165 is IERC165 {
1126     /*
1127      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1128      */
1129     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1130 
1131     /**
1132      * @dev Mapping of interface ids to whether or not it's supported.
1133      */
1134     mapping(bytes4 => bool) private _supportedInterfaces;
1135 
1136     constructor () {
1137         // Derived contracts need only register support for their own interfaces,
1138         // we register support for ERC165 itself here
1139         _registerInterface(_INTERFACE_ID_ERC165);
1140     }
1141 
1142     /**
1143      * @dev See {IERC165-supportsInterface}.
1144      *
1145      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1146      */
1147     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1148         return _supportedInterfaces[interfaceId];
1149     }
1150 
1151     /**
1152      * @dev Registers the contract as an implementer of the interface defined by
1153      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1154      * registering its interface id is not required.
1155      *
1156      * See {IERC165-supportsInterface}.
1157      *
1158      * Requirements:
1159      *
1160      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1161      */
1162     function _registerInterface(bytes4 interfaceId) internal virtual {
1163         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1164         _supportedInterfaces[interfaceId] = true;
1165     }
1166 }
1167 
1168 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1169     using SafeMath for uint256;
1170     using Address for address;
1171     using EnumerableSet for EnumerableSet.UintSet;
1172     using EnumerableMap for EnumerableMap.UintToAddressMap;
1173     using Strings for uint256;
1174 
1175     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1176     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1177     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1178 
1179     // Mapping from holder address to their (enumerable) set of owned tokens
1180     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1181 
1182     // Enumerable mapping from token ids to their owners
1183     EnumerableMap.UintToAddressMap private _tokenOwners;
1184 
1185     // Mapping from token ID to approved address
1186     mapping (uint256 => address) private _tokenApprovals;
1187 
1188     // Mapping from owner to operator approvals
1189     mapping (address => mapping (address => bool)) private _operatorApprovals;
1190 
1191     // Token name
1192     string private _name;
1193 
1194     // Token symbol
1195     string private _symbol;
1196 
1197     // Optional mapping for token URIs
1198     mapping (uint256 => string) private _tokenURIs;
1199 
1200     // Base URI
1201     string private _baseURI;
1202 
1203     /*
1204      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1205      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1206      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1207      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1208      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1209      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1210      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1211      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1212      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1213      *
1214      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1215      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1216      */
1217     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1218 
1219     /*
1220      *     bytes4(keccak256('name()')) == 0x06fdde03
1221      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1222      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1223      *
1224      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1225      */
1226     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1227 
1228     /*
1229      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1230      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1231      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1232      *
1233      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1234      */
1235     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1236 
1237     /**
1238      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1239      */
1240     constructor (string memory name_, string memory symbol_) {
1241         _name = name_;
1242         _symbol = symbol_;
1243 
1244         // register the supported interfaces to conform to ERC721 via ERC165
1245         _registerInterface(_INTERFACE_ID_ERC721);
1246         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1247         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1248     }
1249 
1250     /**
1251      * @dev See {IERC721-balanceOf}.
1252      */
1253     function balanceOf(address owner) public view virtual override returns (uint256) {
1254         require(owner != address(0), "ERC721: balance query for the zero address");
1255         return _holderTokens[owner].length();
1256     }
1257 
1258     /**
1259      * @dev See {IERC721-ownerOf}.
1260      */
1261     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1262         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1263     }
1264 
1265     /**
1266      * @dev See {IERC721Metadata-name}.
1267      */
1268     function name() public view virtual override returns (string memory) {
1269         return _name;
1270     }
1271 
1272     /**
1273      * @dev See {IERC721Metadata-symbol}.
1274      */
1275     function symbol() public view virtual override returns (string memory) {
1276         return _symbol;
1277     }
1278 
1279     /**
1280      * @dev See {IERC721Metadata-tokenURI}.
1281      */
1282     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1283         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1284 
1285         string memory _tokenURI = _tokenURIs[tokenId];
1286         string memory base = baseURI();
1287 
1288         // If there is no base URI, return the token URI.
1289         if (bytes(base).length == 0) {
1290             return _tokenURI;
1291         }
1292         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1293         if (bytes(_tokenURI).length > 0) {
1294             return string(abi.encodePacked(base, _tokenURI));
1295         }
1296         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1297         return string(abi.encodePacked(base, tokenId.toString()));
1298     }
1299 
1300     /**
1301     * @dev Returns the base URI set via {_setBaseURI}. This will be
1302     * automatically added as a prefix in {tokenURI} to each token's URI, or
1303     * to the token ID if no specific URI is set for that token ID.
1304     */
1305     function baseURI() public view virtual returns (string memory) {
1306         return _baseURI;
1307     }
1308 
1309     /**
1310      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1311      */
1312     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1313         return _holderTokens[owner].at(index);
1314     }
1315 
1316     /**
1317      * @dev See {IERC721Enumerable-totalSupply}.
1318      */
1319     function totalSupply() public view virtual override returns (uint256) {
1320         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1321         return _tokenOwners.length();
1322     }
1323 
1324     /**
1325      * @dev See {IERC721Enumerable-tokenByIndex}.
1326      */
1327     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1328         (uint256 tokenId, ) = _tokenOwners.at(index);
1329         return tokenId;
1330     }
1331 
1332     /**
1333      * @dev See {IERC721-approve}.
1334      */
1335     function approve(address to, uint256 tokenId) public virtual override {
1336         address owner = ERC721.ownerOf(tokenId);
1337         require(to != owner, "ERC721: approval to current owner");
1338 
1339         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1340             "ERC721: approve caller is not owner nor approved for all"
1341         );
1342 
1343         _approve(to, tokenId);
1344     }
1345 
1346     /**
1347      * @dev See {IERC721-getApproved}.
1348      */
1349     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1350         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1351 
1352         return _tokenApprovals[tokenId];
1353     }
1354 
1355     /**
1356      * @dev See {IERC721-setApprovalForAll}.
1357      */
1358     function setApprovalForAll(address operator, bool approved) public virtual override {
1359         require(operator != _msgSender(), "ERC721: approve to caller");
1360 
1361         _operatorApprovals[_msgSender()][operator] = approved;
1362         emit ApprovalForAll(_msgSender(), operator, approved);
1363     }
1364 
1365     /**
1366      * @dev See {IERC721-isApprovedForAll}.
1367      */
1368     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1369         return _operatorApprovals[owner][operator];
1370     }
1371 
1372     /**
1373      * @dev See {IERC721-transferFrom}.
1374      */
1375     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1376         //solhint-disable-next-line max-line-length
1377         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1378 
1379         _transfer(from, to, tokenId);
1380     }
1381 
1382     /**
1383      * @dev See {IERC721-safeTransferFrom}.
1384      */
1385     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1386         safeTransferFrom(from, to, tokenId, "");
1387     }
1388 
1389     /**
1390      * @dev See {IERC721-safeTransferFrom}.
1391      */
1392     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1393         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1394         _safeTransfer(from, to, tokenId, _data);
1395     }
1396 
1397     /**
1398      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1399      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1400      *
1401      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1402      *
1403      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1404      * implement alternative mechanisms to perform token transfer, such as signature-based.
1405      *
1406      * Requirements:
1407      *
1408      * - `from` cannot be the zero address.
1409      * - `to` cannot be the zero address.
1410      * - `tokenId` token must exist and be owned by `from`.
1411      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1412      *
1413      * Emits a {Transfer} event.
1414      */
1415     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1416         _transfer(from, to, tokenId);
1417         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1418     }
1419 
1420     /**
1421      * @dev Returns whether `tokenId` exists.
1422      *
1423      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1424      *
1425      * Tokens start existing when they are minted (`_mint`),
1426      * and stop existing when they are burned (`_burn`).
1427      */
1428     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1429         return _tokenOwners.contains(tokenId);
1430     }
1431 
1432     /**
1433      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1434      *
1435      * Requirements:
1436      *
1437      * - `tokenId` must exist.
1438      */
1439     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1440         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1441         address owner = ERC721.ownerOf(tokenId);
1442         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1443     }
1444 
1445     /**
1446      * @dev Safely mints `tokenId` and transfers it to `to`.
1447      *
1448      * Requirements:
1449      *
1450      * - `tokenId` must not exist.
1451      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1452      *
1453      * Emits a {Transfer} event.
1454      */
1455     function _safeMint(address to, uint256 tokenId) internal virtual {
1456         _safeMint(to, tokenId, "");
1457     }
1458 
1459     /**
1460      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1461      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1462      */
1463     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1464         _mint(to, tokenId);
1465         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1466     }
1467 
1468     /**
1469      * @dev Mints `tokenId` and transfers it to `to`.
1470      *
1471      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1472      *
1473      * Requirements:
1474      *
1475      * - `tokenId` must not exist.
1476      * - `to` cannot be the zero address.
1477      *
1478      * Emits a {Transfer} event.
1479      */
1480     function _mint(address to, uint256 tokenId) internal virtual {
1481         require(to != address(0), "ERC721: mint to the zero address");
1482         require(!_exists(tokenId), "ERC721: token already minted");
1483 
1484         _beforeTokenTransfer(address(0), to, tokenId);
1485 
1486         _holderTokens[to].add(tokenId);
1487 
1488         _tokenOwners.set(tokenId, to);
1489 
1490         emit Transfer(address(0), to, tokenId);
1491     }
1492 
1493     /**
1494      * @dev Destroys `tokenId`.
1495      * The approval is cleared when the token is burned.
1496      *
1497      * Requirements:
1498      *
1499      * - `tokenId` must exist.
1500      *
1501      * Emits a {Transfer} event.
1502      */
1503     function _burn(uint256 tokenId) internal virtual {
1504         address owner = ERC721.ownerOf(tokenId); // internal owner
1505 
1506         _beforeTokenTransfer(owner, address(0), tokenId);
1507 
1508         // Clear approvals
1509         _approve(address(0), tokenId);
1510 
1511         // Clear metadata (if any)
1512         if (bytes(_tokenURIs[tokenId]).length != 0) {
1513             delete _tokenURIs[tokenId];
1514         }
1515 
1516         _holderTokens[owner].remove(tokenId);
1517 
1518         _tokenOwners.remove(tokenId);
1519 
1520         emit Transfer(owner, address(0), tokenId);
1521     }
1522 
1523     /**
1524      * @dev Transfers `tokenId` from `from` to `to`.
1525      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1526      *
1527      * Requirements:
1528      *
1529      * - `to` cannot be the zero address.
1530      * - `tokenId` token must be owned by `from`.
1531      *
1532      * Emits a {Transfer} event.
1533      */
1534     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1535         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1536         require(to != address(0), "ERC721: transfer to the zero address");
1537 
1538         _beforeTokenTransfer(from, to, tokenId);
1539 
1540         // Clear approvals from the previous owner
1541         _approve(address(0), tokenId);
1542 
1543         _holderTokens[from].remove(tokenId);
1544         _holderTokens[to].add(tokenId);
1545 
1546         _tokenOwners.set(tokenId, to);
1547 
1548         emit Transfer(from, to, tokenId);
1549     }
1550 
1551     /**
1552      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1553      *
1554      * Requirements:
1555      *
1556      * - `tokenId` must exist.
1557      */
1558     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1559         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1560         _tokenURIs[tokenId] = _tokenURI;
1561     }
1562 
1563     /**
1564      * @dev Internal function to set the base URI for all token IDs. It is
1565      * automatically added as a prefix to the value returned in {tokenURI},
1566      * or to the token ID if {tokenURI} is empty.
1567      */
1568     function _setBaseURI(string memory baseURI_) internal virtual {
1569         _baseURI = baseURI_;
1570     }
1571 
1572     /**
1573      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1574      * The call is not executed if the target address is not a contract.
1575      *
1576      * @param from address representing the previous owner of the given token ID
1577      * @param to target address that will receive the tokens
1578      * @param tokenId uint256 ID of the token to be transferred
1579      * @param _data bytes optional data to send along with the call
1580      * @return bool whether the call correctly returned the expected magic value
1581      */
1582     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1583         private returns (bool)
1584     {
1585         if (!to.isContract()) {
1586             return true;
1587         }
1588         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1589             IERC721Receiver(to).onERC721Received.selector,
1590             _msgSender(),
1591             from,
1592             tokenId,
1593             _data
1594         ), "ERC721: transfer to non ERC721Receiver implementer");
1595         bytes4 retval = abi.decode(returndata, (bytes4));
1596         return (retval == _ERC721_RECEIVED);
1597     }
1598 
1599     /**
1600      * @dev Approve `to` to operate on `tokenId`
1601      *
1602      * Emits an {Approval} event.
1603      */
1604     function _approve(address to, uint256 tokenId) internal virtual {
1605         _tokenApprovals[tokenId] = to;
1606         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1607     }
1608 
1609     /**
1610      * @dev Hook that is called before any token transfer. This includes minting
1611      * and burning.
1612      *
1613      * Calling conditions:
1614      *
1615      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1616      * transferred to `to`.
1617      * - When `from` is zero, `tokenId` will be minted for `to`.
1618      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1619      * - `from` cannot be the zero address.
1620      * - `to` cannot be the zero address.
1621      *
1622      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1623      */
1624     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1625 }
1626 
1627 
1628 contract Shiitake is ERC721, Ownable {
1629     address passwordSigner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
1630     
1631     uint256 public maxSupply = 2000;
1632     
1633     uint16 public reserved = 60;
1634 
1635     bool public whitelistSale = false;
1636     bool public sale = false;
1637     bool public revealed = false;
1638     
1639     string unrevealedUri = "ipfs://bafybeihdr2tmpjnnwe6cqksiudiztb7lyj3ofjbkgr5d4vwkqodvpmszue";
1640 
1641     mapping (address => bool) public alreadyMinted;
1642     
1643     constructor() ERC721("Shiitakes", "SHII") {
1644         _setBaseURI("ipfs://QmSfv7hJ1rs2faSd9pzSrHS67XbXm7aUKtm14HabY59WGf/");
1645     }
1646     
1647     function mint(uint256 tokenAmt, bytes memory signature) external {
1648         require(whitelistSale ? isWhitelisted(msg.sender, signature) : sale, "You were not added to the whitelist. Please contact a mod if you think this was a mistake.");
1649         
1650         require(!alreadyMinted[msg.sender], "You have already minted Shiitakes.");
1651         
1652         require(tokenAmt <= 2, "Max per transaction is 2");
1653         
1654         require(totalSupply() + tokenAmt <= maxSupply - reserved, "Would exceed max supply");
1655         
1656         for(uint256 i = 0; i < tokenAmt; i++) {
1657             uint256 mintIndex = totalSupply () + 1;
1658             _safeMint(msg.sender, mintIndex);
1659         }
1660         
1661         alreadyMinted[msg.sender] = true;
1662     }
1663     
1664     function claimToAdmin(uint16 tokenAmt) public onlyOwner {
1665         require(totalSupply() + tokenAmt <= maxSupply, "This would exceed max supply");
1666         require(reserved > 0, "This would exceed reserved supply");
1667         
1668         for(uint256 i = 0; i < tokenAmt; i++) {
1669             uint256 mintIndex = totalSupply () + 1;
1670             _safeMint(msg.sender, mintIndex);
1671             reserved--;
1672         }
1673     }
1674 
1675     function tokenURI(uint tokenId) public view override returns(string memory) {
1676         return revealed ? super.tokenURI(tokenId) : unrevealedUri;
1677     }
1678       
1679     function setBaseURI(string calldata baseURI_) external onlyOwner {
1680         _setBaseURI(baseURI_);
1681     }
1682 
1683     function setSale() external onlyOwner {
1684         sale = !sale;
1685     }
1686 
1687     function setWhitelistSale() external onlyOwner {
1688         whitelistSale = !whitelistSale;
1689     }
1690     
1691     function setRevealed() external onlyOwner {
1692         revealed = !revealed;
1693     }
1694 
1695     function setTokenURI(uint256 tokenId, string calldata _tokenURI) external onlyOwner {
1696         _setTokenURI(tokenId, _tokenURI);
1697     }
1698     
1699     function getEthSignedMessageHash(bytes32 _messageHash) private pure returns (bytes32) {
1700         /*
1701         Signature is produced by signing a keccak256 hash with the following format:
1702         "\x19Ethereum Signed Message\n" + len(msg) + msg
1703         */
1704         return
1705         keccak256(
1706             abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
1707         );
1708     }
1709     
1710     function isWhitelisted(address user, bytes memory signature) public view returns (bool) {
1711         bytes32 messageHash = keccak256(abi.encodePacked(user));
1712         bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
1713     
1714         return recoverSigner(ethSignedMessageHash, signature) == passwordSigner;
1715     }
1716     
1717     function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) private pure returns (address) {
1718         (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
1719         return ecrecover(_ethSignedMessageHash, v, r, s);
1720     }
1721     
1722     function splitSignature(bytes memory sig)
1723     private
1724     pure
1725     returns (
1726         bytes32 r,
1727         bytes32 s,
1728         uint8 v
1729     )
1730     {
1731         require(sig.length == 65, "invalid signature length");
1732     
1733         assembly {
1734         /*
1735         First 32 bytes stores the length of the signature
1736         add(sig, 32) = pointer of sig + 32
1737         effectively, skips first 32 bytes of signature
1738         mload(p) loads next 32 bytes starting at the memory address p into memory
1739         */
1740     
1741         // first 32 bytes, after the length prefix
1742             r := mload(add(sig, 32))
1743         // second 32 bytes
1744             s := mload(add(sig, 64))
1745         // final byte (first byte of the next 32 bytes)
1746             v := byte(0, mload(add(sig, 96)))
1747         }
1748     
1749         // implicitly return (r, s, v)
1750     }
1751 }