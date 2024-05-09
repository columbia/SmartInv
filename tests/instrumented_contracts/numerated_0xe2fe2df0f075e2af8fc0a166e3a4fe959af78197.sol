1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 // File: @openzeppelin/contracts/introspection/IERC165.sol
26 
27 
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Interface of the ERC165 standard, as defined in the
33  * https://eips.ethereum.org/EIPS/eip-165[EIP].
34  *
35  * Implementers can declare support of contract interfaces, which can then be
36  * queried by others ({ERC165Checker}).
37  *
38  * For an implementation, see {ERC165}.
39  */
40 interface IERC165 {
41     /**
42      * @dev Returns true if this contract implements the interface defined by
43      * `interfaceId`. See the corresponding
44      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
45      * to learn more about how these ids are created.
46      *
47      * This function call must use less than 30 000 gas.
48      */
49     function supportsInterface(bytes4 interfaceId) external view returns (bool);
50 }
51 
52 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
53 
54 
55 
56 pragma solidity ^0.8.0;
57 
58 
59 /**
60  * @dev Required interface of an ERC721 compliant contract.
61  */
62 interface IERC721 is IERC165 {
63     /**
64      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
65      */
66     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
67 
68     /**
69      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
70      */
71     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
72 
73     /**
74      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
75      */
76     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
77 
78     /**
79      * @dev Returns the number of tokens in ``owner``'s account.
80      */
81     function balanceOf(address owner) external view returns (uint256 balance);
82 
83     /**
84      * @dev Returns the owner of the `tokenId` token.
85      *
86      * Requirements:
87      *
88      * - `tokenId` must exist.
89      */
90     function ownerOf(uint256 tokenId) external view returns (address owner);
91 
92     /**
93      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
94      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must exist and be owned by `from`.
101      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
102      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
103      *
104      * Emits a {Transfer} event.
105      */
106     function safeTransferFrom(address from, address to, uint256 tokenId) external;
107 
108     /**
109      * @dev Transfers `tokenId` token from `from` to `to`.
110      *
111      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
112      *
113      * Requirements:
114      *
115      * - `from` cannot be the zero address.
116      * - `to` cannot be the zero address.
117      * - `tokenId` token must be owned by `from`.
118      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transferFrom(address from, address to, uint256 tokenId) external;
123 
124     /**
125      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
126      * The approval is cleared when the token is transferred.
127      *
128      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
129      *
130      * Requirements:
131      *
132      * - The caller must own the token or be an approved operator.
133      * - `tokenId` must exist.
134      *
135      * Emits an {Approval} event.
136      */
137     function approve(address to, uint256 tokenId) external;
138 
139     /**
140      * @dev Returns the account approved for `tokenId` token.
141      *
142      * Requirements:
143      *
144      * - `tokenId` must exist.
145      */
146     function getApproved(uint256 tokenId) external view returns (address operator);
147 
148     /**
149      * @dev Approve or remove `operator` as an operator for the caller.
150      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
151      *
152      * Requirements:
153      *
154      * - The `operator` cannot be the caller.
155      *
156      * Emits an {ApprovalForAll} event.
157      */
158     function setApprovalForAll(address operator, bool _approved) external;
159 
160     /**
161      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
162      *
163      * See {setApprovalForAll}
164      */
165     function isApprovedForAll(address owner, address operator) external view returns (bool);
166 
167     /**
168       * @dev Safely transfers `tokenId` token from `from` to `to`.
169       *
170       * Requirements:
171       *
172       * - `from` cannot be the zero address.
173       * - `to` cannot be the zero address.
174       * - `tokenId` token must exist and be owned by `from`.
175       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
176       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
177       *
178       * Emits a {Transfer} event.
179       */
180     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
181 }
182 
183 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
184 
185 
186 
187 pragma solidity ^0.8.0;
188 
189 
190 /**
191  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
192  * @dev See https://eips.ethereum.org/EIPS/eip-721
193  */
194 interface IERC721Metadata is IERC721 {
195 
196     /**
197      * @dev Returns the token collection name.
198      */
199     function name() external view returns (string memory);
200 
201     /**
202      * @dev Returns the token collection symbol.
203      */
204     function symbol() external view returns (string memory);
205 
206     /**
207      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
208      */
209     function tokenURI(uint256 tokenId) external view returns (string memory);
210 }
211 
212 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
213 
214 
215 
216 pragma solidity ^0.8.0;
217 
218 
219 /**
220  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
221  * @dev See https://eips.ethereum.org/EIPS/eip-721
222  */
223 interface IERC721Enumerable is IERC721 {
224 
225     /**
226      * @dev Returns the total amount of tokens stored by the contract.
227      */
228     function totalSupply() external view returns (uint256);
229 
230     /**
231      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
232      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
233      */
234     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
235 
236     /**
237      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
238      * Use along with {totalSupply} to enumerate all tokens.
239      */
240     function tokenByIndex(uint256 index) external view returns (uint256);
241 }
242 
243 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
244 
245 
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @title ERC721 token receiver interface
251  * @dev Interface for any contract that wants to support safeTransfers
252  * from ERC721 asset contracts.
253  */
254 interface IERC721Receiver {
255     /**
256      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
257      * by `operator` from `from`, this function is called.
258      *
259      * It must return its Solidity selector to confirm the token transfer.
260      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
261      *
262      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
263      */
264     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
265 }
266 
267 // File: @openzeppelin/contracts/introspection/ERC165.sol
268 
269 
270 
271 pragma solidity ^0.8.0;
272 
273 
274 /**
275  * @dev Implementation of the {IERC165} interface.
276  *
277  * Contracts may inherit from this and call {_registerInterface} to declare
278  * their support of an interface.
279  */
280 abstract contract ERC165 is IERC165 {
281     /*
282      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
283      */
284     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
285 
286     /**
287      * @dev Mapping of interface ids to whether or not it's supported.
288      */
289     mapping(bytes4 => bool) private _supportedInterfaces;
290 
291     constructor () {
292         // Derived contracts need only register support for their own interfaces,
293         // we register support for ERC165 itself here
294         _registerInterface(_INTERFACE_ID_ERC165);
295     }
296 
297     /**
298      * @dev See {IERC165-supportsInterface}.
299      *
300      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
301      */
302     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
303         return _supportedInterfaces[interfaceId];
304     }
305 
306     /**
307      * @dev Registers the contract as an implementer of the interface defined by
308      * `interfaceId`. Support of the actual ERC165 interface is automatic and
309      * registering its interface id is not required.
310      *
311      * See {IERC165-supportsInterface}.
312      *
313      * Requirements:
314      *
315      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
316      */
317     function _registerInterface(bytes4 interfaceId) internal virtual {
318         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
319         _supportedInterfaces[interfaceId] = true;
320     }
321 }
322 
323 // File: @openzeppelin/contracts/utils/Address.sol
324 
325 
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @dev Collection of functions related to the address type
331  */
332 library Address {
333     /**
334      * @dev Returns true if `account` is a contract.
335      *
336      * [IMPORTANT]
337      * ====
338      * It is unsafe to assume that an address for which this function returns
339      * false is an externally-owned account (EOA) and not a contract.
340      *
341      * Among others, `isContract` will return false for the following
342      * types of addresses:
343      *
344      *  - an externally-owned account
345      *  - a contract in construction
346      *  - an address where a contract will be created
347      *  - an address where a contract lived, but was destroyed
348      * ====
349      */
350     function isContract(address account) internal view returns (bool) {
351         // This method relies on extcodesize, which returns 0 for contracts in
352         // construction, since the code is only stored at the end of the
353         // constructor execution.
354 
355         uint256 size;
356         // solhint-disable-next-line no-inline-assembly
357         assembly { size := extcodesize(account) }
358         return size > 0;
359     }
360 
361     /**
362      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
363      * `recipient`, forwarding all available gas and reverting on errors.
364      *
365      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
366      * of certain opcodes, possibly making contracts go over the 2300 gas limit
367      * imposed by `transfer`, making them unable to receive funds via
368      * `transfer`. {sendValue} removes this limitation.
369      *
370      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
371      *
372      * IMPORTANT: because control is transferred to `recipient`, care must be
373      * taken to not create reentrancy vulnerabilities. Consider using
374      * {ReentrancyGuard} or the
375      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
376      */
377     function sendValue(address payable recipient, uint256 amount) internal {
378         require(address(this).balance >= amount, "Address: insufficient balance");
379 
380         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
381         (bool success, ) = recipient.call{ value: amount }("");
382         require(success, "Address: unable to send value, recipient may have reverted");
383     }
384 
385     /**
386      * @dev Performs a Solidity function call using a low level `call`. A
387      * plain`call` is an unsafe replacement for a function call: use this
388      * function instead.
389      *
390      * If `target` reverts with a revert reason, it is bubbled up by this
391      * function (like regular Solidity function calls).
392      *
393      * Returns the raw returned data. To convert to the expected return value,
394      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
395      *
396      * Requirements:
397      *
398      * - `target` must be a contract.
399      * - calling `target` with `data` must not revert.
400      *
401      * _Available since v3.1._
402      */
403     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
404       return functionCall(target, data, "Address: low-level call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
409      * `errorMessage` as a fallback revert reason when `target` reverts.
410      *
411      * _Available since v3.1._
412      */
413     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
414         return functionCallWithValue(target, data, 0, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but also transferring `value` wei to `target`.
420      *
421      * Requirements:
422      *
423      * - the calling contract must have an ETH balance of at least `value`.
424      * - the called Solidity function must be `payable`.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
429         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
434      * with `errorMessage` as a fallback revert reason when `target` reverts.
435      *
436      * _Available since v3.1._
437      */
438     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
439         require(address(this).balance >= value, "Address: insufficient balance for call");
440         require(isContract(target), "Address: call to non-contract");
441 
442         // solhint-disable-next-line avoid-low-level-calls
443         (bool success, bytes memory returndata) = target.call{ value: value }(data);
444         return _verifyCallResult(success, returndata, errorMessage);
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
454         return functionStaticCall(target, data, "Address: low-level static call failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
459      * but performing a static call.
460      *
461      * _Available since v3.3._
462      */
463     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
464         require(isContract(target), "Address: static call to non-contract");
465 
466         // solhint-disable-next-line avoid-low-level-calls
467         (bool success, bytes memory returndata) = target.staticcall(data);
468         return _verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but performing a delegate call.
474      *
475      * _Available since v3.4._
476      */
477     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
478         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
483      * but performing a delegate call.
484      *
485      * _Available since v3.4._
486      */
487     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
488         require(isContract(target), "Address: delegate call to non-contract");
489 
490         // solhint-disable-next-line avoid-low-level-calls
491         (bool success, bytes memory returndata) = target.delegatecall(data);
492         return _verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
496         if (success) {
497             return returndata;
498         } else {
499             // Look for revert reason and bubble it up if present
500             if (returndata.length > 0) {
501                 // The easiest way to bubble the revert reason is using memory via assembly
502 
503                 // solhint-disable-next-line no-inline-assembly
504                 assembly {
505                     let returndata_size := mload(returndata)
506                     revert(add(32, returndata), returndata_size)
507                 }
508             } else {
509                 revert(errorMessage);
510             }
511         }
512     }
513 }
514 
515 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
516 
517 
518 
519 pragma solidity ^0.8.0;
520 
521 /**
522  * @dev Library for managing
523  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
524  * types.
525  *
526  * Sets have the following properties:
527  *
528  * - Elements are added, removed, and checked for existence in constant time
529  * (O(1)).
530  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
531  *
532  * ```
533  * contract Example {
534  *     // Add the library methods
535  *     using EnumerableSet for EnumerableSet.AddressSet;
536  *
537  *     // Declare a set state variable
538  *     EnumerableSet.AddressSet private mySet;
539  * }
540  * ```
541  *
542  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
543  * and `uint256` (`UintSet`) are supported.
544  */
545 library EnumerableSet {
546     // To implement this library for multiple types with as little code
547     // repetition as possible, we write it in terms of a generic Set type with
548     // bytes32 values.
549     // The Set implementation uses private functions, and user-facing
550     // implementations (such as AddressSet) are just wrappers around the
551     // underlying Set.
552     // This means that we can only create new EnumerableSets for types that fit
553     // in bytes32.
554 
555     struct Set {
556         // Storage of set values
557         bytes32[] _values;
558 
559         // Position of the value in the `values` array, plus 1 because index 0
560         // means a value is not in the set.
561         mapping (bytes32 => uint256) _indexes;
562     }
563 
564     /**
565      * @dev Add a value to a set. O(1).
566      *
567      * Returns true if the value was added to the set, that is if it was not
568      * already present.
569      */
570     function _add(Set storage set, bytes32 value) private returns (bool) {
571         if (!_contains(set, value)) {
572             set._values.push(value);
573             // The value is stored at length-1, but we add 1 to all indexes
574             // and use 0 as a sentinel value
575             set._indexes[value] = set._values.length;
576             return true;
577         } else {
578             return false;
579         }
580     }
581 
582     /**
583      * @dev Removes a value from a set. O(1).
584      *
585      * Returns true if the value was removed from the set, that is if it was
586      * present.
587      */
588     function _remove(Set storage set, bytes32 value) private returns (bool) {
589         // We read and store the value's index to prevent multiple reads from the same storage slot
590         uint256 valueIndex = set._indexes[value];
591 
592         if (valueIndex != 0) { // Equivalent to contains(set, value)
593             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
594             // the array, and then remove the last element (sometimes called as 'swap and pop').
595             // This modifies the order of the array, as noted in {at}.
596 
597             uint256 toDeleteIndex = valueIndex - 1;
598             uint256 lastIndex = set._values.length - 1;
599 
600             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
601             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
602 
603             bytes32 lastvalue = set._values[lastIndex];
604 
605             // Move the last value to the index where the value to delete is
606             set._values[toDeleteIndex] = lastvalue;
607             // Update the index for the moved value
608             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
609 
610             // Delete the slot where the moved value was stored
611             set._values.pop();
612 
613             // Delete the index for the deleted slot
614             delete set._indexes[value];
615 
616             return true;
617         } else {
618             return false;
619         }
620     }
621 
622     /**
623      * @dev Returns true if the value is in the set. O(1).
624      */
625     function _contains(Set storage set, bytes32 value) private view returns (bool) {
626         return set._indexes[value] != 0;
627     }
628 
629     /**
630      * @dev Returns the number of values on the set. O(1).
631      */
632     function _length(Set storage set) private view returns (uint256) {
633         return set._values.length;
634     }
635 
636    /**
637     * @dev Returns the value stored at position `index` in the set. O(1).
638     *
639     * Note that there are no guarantees on the ordering of values inside the
640     * array, and it may change when more values are added or removed.
641     *
642     * Requirements:
643     *
644     * - `index` must be strictly less than {length}.
645     */
646     function _at(Set storage set, uint256 index) private view returns (bytes32) {
647         require(set._values.length > index, "EnumerableSet: index out of bounds");
648         return set._values[index];
649     }
650 
651     // Bytes32Set
652 
653     struct Bytes32Set {
654         Set _inner;
655     }
656 
657     /**
658      * @dev Add a value to a set. O(1).
659      *
660      * Returns true if the value was added to the set, that is if it was not
661      * already present.
662      */
663     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
664         return _add(set._inner, value);
665     }
666 
667     /**
668      * @dev Removes a value from a set. O(1).
669      *
670      * Returns true if the value was removed from the set, that is if it was
671      * present.
672      */
673     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
674         return _remove(set._inner, value);
675     }
676 
677     /**
678      * @dev Returns true if the value is in the set. O(1).
679      */
680     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
681         return _contains(set._inner, value);
682     }
683 
684     /**
685      * @dev Returns the number of values in the set. O(1).
686      */
687     function length(Bytes32Set storage set) internal view returns (uint256) {
688         return _length(set._inner);
689     }
690 
691    /**
692     * @dev Returns the value stored at position `index` in the set. O(1).
693     *
694     * Note that there are no guarantees on the ordering of values inside the
695     * array, and it may change when more values are added or removed.
696     *
697     * Requirements:
698     *
699     * - `index` must be strictly less than {length}.
700     */
701     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
702         return _at(set._inner, index);
703     }
704 
705     // AddressSet
706 
707     struct AddressSet {
708         Set _inner;
709     }
710 
711     /**
712      * @dev Add a value to a set. O(1).
713      *
714      * Returns true if the value was added to the set, that is if it was not
715      * already present.
716      */
717     function add(AddressSet storage set, address value) internal returns (bool) {
718         return _add(set._inner, bytes32(uint256(uint160(value))));
719     }
720 
721     /**
722      * @dev Removes a value from a set. O(1).
723      *
724      * Returns true if the value was removed from the set, that is if it was
725      * present.
726      */
727     function remove(AddressSet storage set, address value) internal returns (bool) {
728         return _remove(set._inner, bytes32(uint256(uint160(value))));
729     }
730 
731     /**
732      * @dev Returns true if the value is in the set. O(1).
733      */
734     function contains(AddressSet storage set, address value) internal view returns (bool) {
735         return _contains(set._inner, bytes32(uint256(uint160(value))));
736     }
737 
738     /**
739      * @dev Returns the number of values in the set. O(1).
740      */
741     function length(AddressSet storage set) internal view returns (uint256) {
742         return _length(set._inner);
743     }
744 
745    /**
746     * @dev Returns the value stored at position `index` in the set. O(1).
747     *
748     * Note that there are no guarantees on the ordering of values inside the
749     * array, and it may change when more values are added or removed.
750     *
751     * Requirements:
752     *
753     * - `index` must be strictly less than {length}.
754     */
755     function at(AddressSet storage set, uint256 index) internal view returns (address) {
756         return address(uint160(uint256(_at(set._inner, index))));
757     }
758 
759 
760     // UintSet
761 
762     struct UintSet {
763         Set _inner;
764     }
765 
766     /**
767      * @dev Add a value to a set. O(1).
768      *
769      * Returns true if the value was added to the set, that is if it was not
770      * already present.
771      */
772     function add(UintSet storage set, uint256 value) internal returns (bool) {
773         return _add(set._inner, bytes32(value));
774     }
775 
776     /**
777      * @dev Removes a value from a set. O(1).
778      *
779      * Returns true if the value was removed from the set, that is if it was
780      * present.
781      */
782     function remove(UintSet storage set, uint256 value) internal returns (bool) {
783         return _remove(set._inner, bytes32(value));
784     }
785 
786     /**
787      * @dev Returns true if the value is in the set. O(1).
788      */
789     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
790         return _contains(set._inner, bytes32(value));
791     }
792 
793     /**
794      * @dev Returns the number of values on the set. O(1).
795      */
796     function length(UintSet storage set) internal view returns (uint256) {
797         return _length(set._inner);
798     }
799 
800    /**
801     * @dev Returns the value stored at position `index` in the set. O(1).
802     *
803     * Note that there are no guarantees on the ordering of values inside the
804     * array, and it may change when more values are added or removed.
805     *
806     * Requirements:
807     *
808     * - `index` must be strictly less than {length}.
809     */
810     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
811         return uint256(_at(set._inner, index));
812     }
813 }
814 
815 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
816 
817 
818 
819 pragma solidity ^0.8.0;
820 
821 /**
822  * @dev Library for managing an enumerable variant of Solidity's
823  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
824  * type.
825  *
826  * Maps have the following properties:
827  *
828  * - Entries are added, removed, and checked for existence in constant time
829  * (O(1)).
830  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
831  *
832  * ```
833  * contract Example {
834  *     // Add the library methods
835  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
836  *
837  *     // Declare a set state variable
838  *     EnumerableMap.UintToAddressMap private myMap;
839  * }
840  * ```
841  *
842  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
843  * supported.
844  */
845 library EnumerableMap {
846     // To implement this library for multiple types with as little code
847     // repetition as possible, we write it in terms of a generic Map type with
848     // bytes32 keys and values.
849     // The Map implementation uses private functions, and user-facing
850     // implementations (such as Uint256ToAddressMap) are just wrappers around
851     // the underlying Map.
852     // This means that we can only create new EnumerableMaps for types that fit
853     // in bytes32.
854 
855     struct MapEntry {
856         bytes32 _key;
857         bytes32 _value;
858     }
859 
860     struct Map {
861         // Storage of map keys and values
862         MapEntry[] _entries;
863 
864         // Position of the entry defined by a key in the `entries` array, plus 1
865         // because index 0 means a key is not in the map.
866         mapping (bytes32 => uint256) _indexes;
867     }
868 
869     /**
870      * @dev Adds a key-value pair to a map, or updates the value for an existing
871      * key. O(1).
872      *
873      * Returns true if the key was added to the map, that is if it was not
874      * already present.
875      */
876     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
877         // We read and store the key's index to prevent multiple reads from the same storage slot
878         uint256 keyIndex = map._indexes[key];
879 
880         if (keyIndex == 0) { // Equivalent to !contains(map, key)
881             map._entries.push(MapEntry({ _key: key, _value: value }));
882             // The entry is stored at length-1, but we add 1 to all indexes
883             // and use 0 as a sentinel value
884             map._indexes[key] = map._entries.length;
885             return true;
886         } else {
887             map._entries[keyIndex - 1]._value = value;
888             return false;
889         }
890     }
891 
892     /**
893      * @dev Removes a key-value pair from a map. O(1).
894      *
895      * Returns true if the key was removed from the map, that is if it was present.
896      */
897     function _remove(Map storage map, bytes32 key) private returns (bool) {
898         // We read and store the key's index to prevent multiple reads from the same storage slot
899         uint256 keyIndex = map._indexes[key];
900 
901         if (keyIndex != 0) { // Equivalent to contains(map, key)
902             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
903             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
904             // This modifies the order of the array, as noted in {at}.
905 
906             uint256 toDeleteIndex = keyIndex - 1;
907             uint256 lastIndex = map._entries.length - 1;
908 
909             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
910             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
911 
912             MapEntry storage lastEntry = map._entries[lastIndex];
913 
914             // Move the last entry to the index where the entry to delete is
915             map._entries[toDeleteIndex] = lastEntry;
916             // Update the index for the moved entry
917             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
918 
919             // Delete the slot where the moved entry was stored
920             map._entries.pop();
921 
922             // Delete the index for the deleted slot
923             delete map._indexes[key];
924 
925             return true;
926         } else {
927             return false;
928         }
929     }
930 
931     /**
932      * @dev Returns true if the key is in the map. O(1).
933      */
934     function _contains(Map storage map, bytes32 key) private view returns (bool) {
935         return map._indexes[key] != 0;
936     }
937 
938     /**
939      * @dev Returns the number of key-value pairs in the map. O(1).
940      */
941     function _length(Map storage map) private view returns (uint256) {
942         return map._entries.length;
943     }
944 
945    /**
946     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
947     *
948     * Note that there are no guarantees on the ordering of entries inside the
949     * array, and it may change when more entries are added or removed.
950     *
951     * Requirements:
952     *
953     * - `index` must be strictly less than {length}.
954     */
955     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
956         require(map._entries.length > index, "EnumerableMap: index out of bounds");
957 
958         MapEntry storage entry = map._entries[index];
959         return (entry._key, entry._value);
960     }
961 
962     /**
963      * @dev Tries to returns the value associated with `key`.  O(1).
964      * Does not revert if `key` is not in the map.
965      */
966     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
967         uint256 keyIndex = map._indexes[key];
968         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
969         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
970     }
971 
972     /**
973      * @dev Returns the value associated with `key`.  O(1).
974      *
975      * Requirements:
976      *
977      * - `key` must be in the map.
978      */
979     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
980         uint256 keyIndex = map._indexes[key];
981         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
982         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
983     }
984 
985     /**
986      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
987      *
988      * CAUTION: This function is deprecated because it requires allocating memory for the error
989      * message unnecessarily. For custom revert reasons use {_tryGet}.
990      */
991     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
992         uint256 keyIndex = map._indexes[key];
993         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
994         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
995     }
996 
997     // UintToAddressMap
998 
999     struct UintToAddressMap {
1000         Map _inner;
1001     }
1002 
1003     /**
1004      * @dev Adds a key-value pair to a map, or updates the value for an existing
1005      * key. O(1).
1006      *
1007      * Returns true if the key was added to the map, that is if it was not
1008      * already present.
1009      */
1010     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1011         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1012     }
1013 
1014     /**
1015      * @dev Removes a value from a set. O(1).
1016      *
1017      * Returns true if the key was removed from the map, that is if it was present.
1018      */
1019     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1020         return _remove(map._inner, bytes32(key));
1021     }
1022 
1023     /**
1024      * @dev Returns true if the key is in the map. O(1).
1025      */
1026     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1027         return _contains(map._inner, bytes32(key));
1028     }
1029 
1030     /**
1031      * @dev Returns the number of elements in the map. O(1).
1032      */
1033     function length(UintToAddressMap storage map) internal view returns (uint256) {
1034         return _length(map._inner);
1035     }
1036 
1037    /**
1038     * @dev Returns the element stored at position `index` in the set. O(1).
1039     * Note that there are no guarantees on the ordering of values inside the
1040     * array, and it may change when more values are added or removed.
1041     *
1042     * Requirements:
1043     *
1044     * - `index` must be strictly less than {length}.
1045     */
1046     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1047         (bytes32 key, bytes32 value) = _at(map._inner, index);
1048         return (uint256(key), address(uint160(uint256(value))));
1049     }
1050 
1051     /**
1052      * @dev Tries to returns the value associated with `key`.  O(1).
1053      * Does not revert if `key` is not in the map.
1054      *
1055      * _Available since v3.4._
1056      */
1057     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1058         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1059         return (success, address(uint160(uint256(value))));
1060     }
1061 
1062     /**
1063      * @dev Returns the value associated with `key`.  O(1).
1064      *
1065      * Requirements:
1066      *
1067      * - `key` must be in the map.
1068      */
1069     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1070         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1071     }
1072 
1073     /**
1074      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1075      *
1076      * CAUTION: This function is deprecated because it requires allocating memory for the error
1077      * message unnecessarily. For custom revert reasons use {tryGet}.
1078      */
1079     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1080         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1081     }
1082 }
1083 
1084 // File: @openzeppelin/contracts/utils/Strings.sol
1085 
1086 
1087 
1088 pragma solidity ^0.8.0;
1089 
1090 /**
1091  * @dev String operations.
1092  */
1093 library Strings {
1094     function toString(uint _i) internal pure returns (string memory _uintAsString) {
1095         if (_i == 0) {
1096             return "0";
1097         }
1098         uint j = _i;
1099         uint len;
1100         while (j != 0) {
1101             len++;
1102             j /= 10;
1103         }
1104         bytes memory bstr = new bytes(len);
1105         uint k = len;
1106         while (_i != 0) {
1107             k = k-1;
1108             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1109             bytes1 b1 = bytes1(temp);
1110             bstr[k] = b1;
1111             _i /= 10;
1112         }
1113         return string(bstr);
1114     }
1115 }
1116 
1117 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1118 
1119 
1120 
1121 pragma solidity ^0.8.0;
1122 
1123 /**
1124  * @title ERC721 Non-Fungible Token Standard basic implementation
1125  * @dev see https://eips.ethereum.org/EIPS/eip-721
1126  */
1127 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1128     using Address for address;
1129     using EnumerableSet for EnumerableSet.UintSet;
1130     using EnumerableMap for EnumerableMap.UintToAddressMap;
1131     using Strings for uint256;
1132 
1133     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1134     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1135     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1136 
1137     // Mapping from holder address to their (enumerable) set of owned tokens
1138     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1139 
1140     // Enumerable mapping from token ids to their owners
1141     EnumerableMap.UintToAddressMap private _tokenOwners;
1142 
1143     // Mapping from token ID to approved address
1144     mapping (uint256 => address) private _tokenApprovals;
1145 
1146     // Mapping from owner to operator approvals
1147     mapping (address => mapping (address => bool)) private _operatorApprovals;
1148 
1149     // Token name
1150     string private _name;
1151 
1152     // Token symbol
1153     string private _symbol;
1154 
1155     // Optional mapping for token URIs
1156     mapping (uint256 => string) private _tokenURIs;
1157 
1158     // Base URI
1159     string private _baseURI;
1160 
1161     /*
1162      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1163      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1164      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1165      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1166      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1167      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1168      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1169      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1170      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1171      *
1172      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1173      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1174      */
1175     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1176 
1177     /*
1178      *     bytes4(keccak256('name()')) == 0x06fdde03
1179      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1180      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1181      *
1182      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1183      */
1184     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1185 
1186     /*
1187      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1188      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1189      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1190      *
1191      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1192      */
1193     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1194 
1195     /**
1196      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1197      */
1198     constructor (string memory name_, string memory symbol_) {
1199         _name = name_;
1200         _symbol = symbol_;
1201 
1202         // register the supported interfaces to conform to ERC721 via ERC165
1203         _registerInterface(_INTERFACE_ID_ERC721);
1204         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1205         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1206     }
1207 
1208     /**
1209      * @dev See {IERC721-balanceOf}.
1210      */
1211     function balanceOf(address owner) public view virtual override returns (uint256) {
1212         require(owner != address(0), "ERC721: balance query for the zero address");
1213         return _holderTokens[owner].length();
1214     }
1215 
1216     /**
1217      * @dev See {IERC721-ownerOf}.
1218      */
1219     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1220         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1221     }
1222 
1223     /**
1224      * @dev See {IERC721Metadata-name}.
1225      */
1226     function name() public view virtual override returns (string memory) {
1227         return _name;
1228     }
1229 
1230     /**
1231      * @dev See {IERC721Metadata-symbol}.
1232      */
1233     function symbol() public view virtual override returns (string memory) {
1234         return _symbol;
1235     }
1236 
1237     /**
1238      * @dev See {IERC721Metadata-tokenURI}.
1239      */
1240     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1241         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1242 
1243         string memory _tokenURI = _tokenURIs[tokenId];
1244         string memory base = baseURI();
1245 
1246         // If there is no base URI, return the token URI.
1247         if (bytes(base).length == 0) {
1248             return _tokenURI;
1249         }
1250         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1251         if (bytes(_tokenURI).length > 0) {
1252             return string(abi.encodePacked(base, _tokenURI));
1253         }
1254         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1255         return string(abi.encodePacked(base, tokenId.toString()));
1256     }
1257 
1258     /**
1259     * @dev Returns the base URI set via {_setBaseURI}. This will be
1260     * automatically added as a prefix in {tokenURI} to each token's URI, or
1261     * to the token ID if no specific URI is set for that token ID.
1262     */
1263     function baseURI() public view virtual returns (string memory) {
1264         return _baseURI;
1265     }
1266 
1267     /**
1268      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1269      */
1270     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1271         return _holderTokens[owner].at(index);
1272     }
1273 
1274     /**
1275      * @dev See {IERC721Enumerable-totalSupply}.
1276      */
1277     function totalSupply() public view virtual override returns (uint256) {
1278         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1279         return _tokenOwners.length();
1280     }
1281 
1282     /**
1283      * @dev See {IERC721Enumerable-tokenByIndex}.
1284      */
1285     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1286         (uint256 tokenId, ) = _tokenOwners.at(index);
1287         return tokenId;
1288     }
1289 
1290     /**
1291      * @dev See {IERC721-approve}.
1292      */
1293     function approve(address to, uint256 tokenId) public virtual override {
1294         address owner = ERC721.ownerOf(tokenId);
1295         require(to != owner, "ERC721: approval to current owner");
1296 
1297         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1298             "ERC721: approve caller is not owner nor approved for all"
1299         );
1300 
1301         _approve(to, tokenId);
1302     }
1303 
1304     /**
1305      * @dev See {IERC721-getApproved}.
1306      */
1307     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1308         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1309 
1310         return _tokenApprovals[tokenId];
1311     }
1312 
1313     /**
1314      * @dev See {IERC721-setApprovalForAll}.
1315      */
1316     function setApprovalForAll(address operator, bool approved) public virtual override {
1317         require(operator != _msgSender(), "ERC721: approve to caller");
1318 
1319         _operatorApprovals[_msgSender()][operator] = approved;
1320         emit ApprovalForAll(_msgSender(), operator, approved);
1321     }
1322 
1323     /**
1324      * @dev See {IERC721-isApprovedForAll}.
1325      */
1326     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1327         return _operatorApprovals[owner][operator];
1328     }
1329 
1330     /**
1331      * @dev See {IERC721-transferFrom}.
1332      */
1333     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1334         //solhint-disable-next-line max-line-length
1335         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1336 
1337         _transfer(from, to, tokenId);
1338     }
1339 
1340     /**
1341      * @dev See {IERC721-safeTransferFrom}.
1342      */
1343     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1344         safeTransferFrom(from, to, tokenId, "");
1345     }
1346 
1347     /**
1348      * @dev See {IERC721-safeTransferFrom}.
1349      */
1350     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1351         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1352         _safeTransfer(from, to, tokenId, _data);
1353     }
1354 
1355     /**
1356      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1357      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1358      *
1359      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1360      *
1361      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1362      * implement alternative mechanisms to perform token transfer, such as signature-based.
1363      *
1364      * Requirements:
1365      *
1366      * - `from` cannot be the zero address.
1367      * - `to` cannot be the zero address.
1368      * - `tokenId` token must exist and be owned by `from`.
1369      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1370      *
1371      * Emits a {Transfer} event.
1372      */
1373     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1374         _transfer(from, to, tokenId);
1375         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1376     }
1377 
1378     /**
1379      * @dev Returns whether `tokenId` exists.
1380      *
1381      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1382      *
1383      * Tokens start existing when they are minted (`_mint`),
1384      * and stop existing when they are burned (`_burn`).
1385      */
1386     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1387         return _tokenOwners.contains(tokenId);
1388     }
1389 
1390     /**
1391      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1392      *
1393      * Requirements:
1394      *
1395      * - `tokenId` must exist.
1396      */
1397     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1398         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1399         address owner = ERC721.ownerOf(tokenId);
1400         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1401     }
1402 
1403     /**
1404      * @dev Safely mints `tokenId` and transfers it to `to`.
1405      *
1406      * Requirements:
1407      d*
1408      * - `tokenId` must not exist.
1409      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1410      *
1411      * Emits a {Transfer} event.
1412      */
1413     function _safeMint(address to, uint256 tokenId) internal virtual {
1414         _safeMint(to, tokenId, "");
1415     }
1416 
1417     /**
1418      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1419      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1420      */
1421     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1422         _mint(to, tokenId);
1423         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1424     }
1425 
1426     /**
1427      * @dev Mints `tokenId` and transfers it to `to`.
1428      *
1429      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1430      *
1431      * Requirements:
1432      *
1433      * - `tokenId` must not exist.
1434      * - `to` cannot be the zero address.
1435      *
1436      * Emits a {Transfer} event.
1437      */
1438     function _mint(address to, uint256 tokenId) internal virtual {
1439         require(to != address(0), "ERC721: mint to the zero address");
1440         require(!_exists(tokenId), "ERC721: token already minted");
1441 
1442         _beforeTokenTransfer(address(0), to, tokenId);
1443 
1444         _holderTokens[to].add(tokenId);
1445 
1446         _tokenOwners.set(tokenId, to);
1447 
1448         emit Transfer(address(0), to, tokenId);
1449     }
1450 
1451     /**
1452      * @dev Destroys `tokenId`.
1453      * The approval is cleared when the token is burned.
1454      *
1455      * Requirements:
1456      *
1457      * - `tokenId` must exist.
1458      *
1459      * Emits a {Transfer} event.
1460      */
1461     function _burn(uint256 tokenId) internal virtual {
1462         address owner = ERC721.ownerOf(tokenId); // internal owner
1463 
1464         _beforeTokenTransfer(owner, address(0), tokenId);
1465 
1466         // Clear approvals
1467         _approve(address(0), tokenId);
1468 
1469         // Clear metadata (if any)
1470         if (bytes(_tokenURIs[tokenId]).length != 0) {
1471             delete _tokenURIs[tokenId];
1472         }
1473 
1474         _holderTokens[owner].remove(tokenId);
1475 
1476         _tokenOwners.remove(tokenId);
1477 
1478         emit Transfer(owner, address(0), tokenId);
1479     }
1480 
1481     /**
1482      * @dev Transfers `tokenId` from `from` to `to`.
1483      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1484      *
1485      * Requirements:
1486      *
1487      * - `to` cannot be the zero address.
1488      * - `tokenId` token must be owned by `from`.
1489      *
1490      * Emits a {Transfer} event.
1491      */
1492     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1493         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1494         require(to != address(0), "ERC721: transfer to the zero address");
1495 
1496         _beforeTokenTransfer(from, to, tokenId);
1497 
1498         // Clear approvals from the previous owner
1499         _approve(address(0), tokenId);
1500 
1501         _holderTokens[from].remove(tokenId);
1502         _holderTokens[to].add(tokenId);
1503 
1504         _tokenOwners.set(tokenId, to);
1505 
1506         emit Transfer(from, to, tokenId);
1507     }
1508 
1509     /**
1510      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1511      *
1512      * Requirements:
1513      *
1514      * - `tokenId` must exist.
1515      */
1516     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1517         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1518         _tokenURIs[tokenId] = _tokenURI;
1519     }
1520 
1521     /**
1522      * @dev Internal function to set the base URI for all token IDs. It is
1523      * automatically added as a prefix to the value returned in {tokenURI},
1524      * or to the token ID if {tokenURI} is empty.
1525      */
1526     function _setBaseURI(string memory baseURI_) internal virtual {
1527         _baseURI = baseURI_;
1528     }
1529 
1530     /**
1531      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1532      * The call is not executed if the target address is not a contract.
1533      *
1534      * @param from address representing the previous owner of the given token ID
1535      * @param to target address that will receive the tokens
1536      * @param tokenId uint256 ID of the token to be transferred
1537      * @param _data bytes optional data to send along with the call
1538      * @return bool whether the call correctly returned the expected magic value
1539      */
1540     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1541         private returns (bool)
1542     {
1543         if (!to.isContract()) {
1544             return true;
1545         }
1546         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1547             IERC721Receiver(to).onERC721Received.selector,
1548             _msgSender(),
1549             from,
1550             tokenId,
1551             _data
1552         ), "ERC721: transfer to non ERC721Receiver implementer");
1553         bytes4 retval = abi.decode(returndata, (bytes4));
1554         return (retval == _ERC721_RECEIVED);
1555     }
1556 
1557     /**
1558      * @dev Approve `to` to operate on `tokenId`
1559      *
1560      * Emits an {Approval} event.
1561      */
1562     function _approve(address to, uint256 tokenId) internal virtual {
1563         _tokenApprovals[tokenId] = to;
1564         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1565     }
1566 
1567     /**
1568      * @dev Hook that is called before any token transfer. This includes minting
1569      * and burning.
1570      *
1571      * Calling conditions:
1572      *
1573      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1574      * transferred to `to`.
1575      * - When `from` is zero, `tokenId` will be minted for `to`.
1576      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1577      * - `from` cannot be the zero address.
1578      * - `to` cannot be the zero address.
1579      *
1580      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1581      */
1582     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1583 }
1584 
1585 // File: @openzeppelin/contracts/access/Ownable.sol
1586 
1587 
1588 
1589 pragma solidity ^0.8.0;
1590 
1591 /**
1592  * @dev Contract module which provides a basic access control mechanism, where
1593  * there is an account (an owner) that can be granted exclusive access to
1594  * specific functions.
1595  *
1596  * By default, the owner account will be the one that deploys the contract. This
1597  * can later be changed with {transferOwnership}.
1598  *
1599  * This module is used through inheritance. It will make available the modifier
1600  * `onlyOwner`, which can be applied to your functions to restrict their use to
1601  * the owner.
1602  */
1603 abstract contract Ownable is Context {
1604     address private _owner;
1605 
1606     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1607 
1608     /**
1609      * @dev Initializes the contract setting the deployer as the initial owner.
1610      */
1611     constructor () {
1612         address msgSender = _msgSender();
1613         _owner = msgSender;
1614         emit OwnershipTransferred(address(0), msgSender);
1615     }
1616 
1617     /**
1618      * @dev Returns the address of the current owner.
1619      */
1620     function owner() public view virtual returns (address) {
1621         return _owner;
1622     }
1623 
1624     /**
1625      * @dev Throws if called by any account other than the owner.
1626      */
1627     modifier onlyOwner() {
1628         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1629         _;
1630     }
1631 
1632     /**
1633      * @dev Leaves the contract without owner. It will not be possible to call
1634      * `onlyOwner` functions anymore. Can only be called by the current owner.
1635      *
1636      * NOTE: Renouncing ownership will leave the contract without an owner,
1637      * thereby removing any functionality that is only available to the owner.
1638      */
1639     function renounceOwnership() public virtual onlyOwner {
1640         emit OwnershipTransferred(_owner, address(0));
1641         _owner = address(0);
1642     }
1643 
1644     /**
1645      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1646      * Can only be called by the current owner.
1647      */
1648     function transferOwnership(address newOwner) public virtual onlyOwner {
1649         require(newOwner != address(0), "Ownable: new owner is the zero address");
1650         emit OwnershipTransferred(_owner, newOwner);
1651         _owner = newOwner;
1652     }
1653 }
1654 
1655 interface IAstro2dInterface {
1656     function balanceOf(address owner) external view returns (uint256);
1657     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1658     function ownerOf(uint256 tokenId) external view returns (address);
1659 }
1660 
1661 
1662 library MerkleProof {
1663     
1664     function verify(
1665         bytes32[] memory proof,
1666         bytes32 root,
1667         bytes32 leaf
1668     ) internal pure returns (bool) {
1669         return processProof(proof, leaf) == root;
1670     }
1671 
1672     
1673     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1674         bytes32 computedHash = leaf;
1675         for (uint256 i = 0; i < proof.length; i++) {
1676             bytes32 proofElement = proof[i];
1677             if (computedHash <= proofElement) {
1678                 // Hash(current computed hash + current element of the proof)
1679                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1680             } else {
1681                 // Hash(current element of the proof + current computed hash)
1682                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1683             }
1684         }
1685         return computedHash;
1686     }
1687 }
1688 
1689 pragma solidity ^0.8.0;
1690 
1691 // MADE BY LOOTEX
1692 /**
1693  * @title AstroGator_VX
1694  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1695  */
1696 contract AstroGator_VX is ERC721, Ownable {
1697     using Strings for uint256;
1698 
1699     uint256 public constant maxAstroGatorPurchase = 20;
1700     uint256 public constant AstroGatorPrice = 0.2e18; //0.2 ETH
1701     uint256 public constant eachPhaseSupply =  1000;
1702     uint256 public immutable MAX_AstroGators;
1703     uint256 public nextTokenId = 10000;
1704     uint256 public startingIndexForFirst;
1705     uint256 public startingIndexForSecond;
1706     uint256 public startingIndexForThird;
1707 
1708     bool public saleIsActive = false;
1709     bool public BaseURIUnchangeable = false;
1710 
1711     address public immutable treasury;
1712 
1713     bytes32 public rootForClaim = 0xba8e582feee9fb682656368941482537b52f094170d0df79b95ee2c0d3cc7b1a;
1714     bytes32 public root;
1715 
1716     mapping(uint256 => bool) public claimedTokenId;
1717 
1718     IAstro2dInterface public immutable astro2dContract;
1719 
1720     event BaseURISet(string baseURI);
1721     event SaleStateFlipped(bool saleIsActive);
1722     event RootSet(bytes32 root);
1723     event RootForClaimSet(bytes32 rootForClaim);
1724     event StartingIndexForFirstSet(uint256 startingIndexForFirst);
1725     event StartingIndexForSecondSet(uint256 startingIndexForSecond);
1726     event StartingIndexForThirdSet(uint256 startingIndexForThird);
1727 
1728     constructor(uint256 maxNftSupply, address fundReceiver, address astro2dContractAddress) ERC721("AstroGator VX", "AGVX") {
1729         MAX_AstroGators = maxNftSupply;
1730         treasury = fundReceiver;
1731         astro2dContract = IAstro2dInterface(astro2dContractAddress);
1732     }
1733 
1734     /**
1735     * Mints AstroGators
1736     */
1737     function mint(uint numberOfTokens, bytes32[] memory proof) external payable {
1738         address operator = _msgSender();
1739         uint256 _nextTokenId = nextTokenId;
1740 
1741         require(operator == tx.origin, "Contract wallet disallowed");
1742         require(saleIsActive, "Sale not active");
1743         require(numberOfTokens <= maxAstroGatorPurchase, "20 tokens once");
1744         require(numberOfTokens + _nextTokenId <= MAX_AstroGators, "Purchase exceed max supply");
1745         require(AstroGatorPrice * numberOfTokens == msg.value, "Ether value sent incorrect");
1746         if (root != 0) {
1747             require(MerkleProof.verify(proof, root, keccak256(abi.encodePacked(operator))), "Not whitelisted");
1748         }
1749 
1750         nextTokenId += numberOfTokens;
1751 
1752         for(uint i = 0; i < numberOfTokens; i++) {
1753             _safeMint(operator, _nextTokenId + i);
1754         }
1755     }
1756 
1757     /**
1758     * For 2d holders to claim 3d AstroGators
1759     */
1760     function claimById(uint256 tokenId, bytes32[] memory proof) external {
1761         address operator = _msgSender();
1762 
1763         require(MerkleProof.verify(proof, rootForClaim, keccak256(abi.encodePacked(tokenId.toString()))), "TokenId unclaimable");
1764         require(astro2dContract.ownerOf(tokenId) == operator, "Not the token owner");
1765         require(!claimedTokenId[tokenId], "Token already claimed");
1766 
1767         claimedTokenId[tokenId] = true;
1768         _safeMint(operator, tokenId);
1769     }
1770 
1771     function claimAll() external {
1772         address operator = _msgSender();
1773 
1774         require(rootForClaim == 0, "not yet");
1775         uint balance = astro2dContract.balanceOf(operator);
1776         require(balance > 0, "You have no 2d astrogators.");
1777         require(balance < 21, "Will run out of gas, please use claimByList instead.");
1778 
1779         for (uint i = 0; i < balance; i++) {
1780             uint256 tokenId = astro2dContract.tokenOfOwnerByIndex(operator, i);
1781             if (!claimedTokenId[tokenId]) {
1782                 claimedTokenId[tokenId] = true;
1783                 _safeMint(operator, tokenId);
1784             }
1785         }
1786     }
1787 
1788     function claimByList(uint256[] memory tokenList) external {
1789         address operator = _msgSender();
1790 
1791         require(rootForClaim == 0, "not yet");
1792         require(tokenList.length < 21, "Will run out of gas, please claim maximum of 20 at once.");
1793 
1794         for (uint i = 0; i < tokenList.length; i++) {
1795             uint256 _tokenId = tokenList[i];
1796             require(astro2dContract.ownerOf(_tokenId) == operator, "You are not the owner of the token.");
1797             if (!claimedTokenId[_tokenId]) {
1798                 claimedTokenId[_tokenId] = true;
1799                 _safeMint(operator, _tokenId);
1800             }
1801         }
1802     }
1803 
1804     /**
1805      * Set some AstroGators aside
1806      */
1807     function reserveAstroGators(uint numberOfTokens) external onlyOwner {
1808         uint256 _nextTokenId = nextTokenId;
1809         require(numberOfTokens + _nextTokenId <= MAX_AstroGators, "Reserve exceed max supply");
1810 
1811         nextTokenId += numberOfTokens;
1812 
1813         for(uint i = 0; i < numberOfTokens; i++) {
1814             _safeMint(_msgSender(), _nextTokenId + i);
1815         }
1816     }
1817 
1818     function setrootForClaim(bytes32 _rootForClaim) external onlyOwner {
1819         rootForClaim = _rootForClaim;
1820         emit RootForClaimSet(_rootForClaim);
1821     }
1822 
1823     function setroot(bytes32 _root) external onlyOwner {
1824         root = _root;
1825         emit RootSet(_root);
1826     }
1827 
1828     // RNG for each phase after fully minted
1829     function setStartingIndexForFirst() external onlyOwner {
1830         require(startingIndexForFirst == 0, "Already set");
1831         
1832         startingIndexForFirst = uint(blockhash(block.number - 1)) % eachPhaseSupply;
1833         emit StartingIndexForFirstSet(startingIndexForFirst);
1834     }
1835 
1836     function setStartingIndexForSecond() external onlyOwner {
1837         require(startingIndexForSecond == 0, "Already set");
1838         
1839         startingIndexForSecond = uint(blockhash(block.number - 1)) % eachPhaseSupply;
1840         emit StartingIndexForSecondSet(startingIndexForSecond);
1841     }
1842 
1843     function setStartingIndexForThird() external onlyOwner {
1844         require(startingIndexForThird == 0, "Already set");
1845         
1846         startingIndexForThird = uint(blockhash(block.number - 1)) % eachPhaseSupply;
1847         emit StartingIndexForThirdSet(startingIndexForThird);
1848     }
1849 
1850     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1851         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1852 
1853         string memory base = baseURI();
1854         string memory unRevealURI = "https://astrogator.mypinata.cloud/ipfs/QmeTqKeKtjKT66YmbhNJe9j8BD1deh4v3qZLZG89hz9r4o/blindbox"; 
1855         uint256 _eachPhaseSupply = eachPhaseSupply;
1856 
1857         if (tokenId < 10000) {
1858             return string(abi.encodePacked(base, tokenId.toString()));
1859         }
1860 
1861         // when first start index has been revealed
1862         if (startingIndexForFirst != 0 && tokenId < 11000 ) {
1863             uint256 _id = tokenId + startingIndexForFirst;
1864             if (_id > 10999) {
1865                 _id -= _eachPhaseSupply;
1866             }
1867             return string(abi.encodePacked(base, _id.toString()));
1868         }
1869 
1870         // when second phase start index has been revealed
1871         if (startingIndexForSecond != 0 && tokenId < 12000) {
1872             uint256 _id = tokenId + startingIndexForSecond;
1873             if (_id > 11999) {
1874                 _id -= _eachPhaseSupply;
1875             }
1876             return string(abi.encodePacked(base, _id.toString()));
1877         }
1878 
1879         // when third phase start index has been revealed
1880         if (startingIndexForThird != 0) {
1881             uint256 _id = tokenId + startingIndexForThird;
1882             if (_id >= MAX_AstroGators) {
1883                 _id -= _eachPhaseSupply;
1884             }
1885             return string(abi.encodePacked(base, _id.toString()));
1886         }
1887 
1888         // when not revealed yet, give the same image
1889         return unRevealURI;
1890     }
1891 
1892     function withdraw() external onlyOwner {
1893         payable(treasury).call{value:address(this).balance}("");
1894     }
1895 
1896     function setBaseURI(string memory baseURI) external onlyOwner {
1897         require(!BaseURIUnchangeable, "BaseURI unchangeable");
1898         _setBaseURI(baseURI);
1899         emit BaseURISet(baseURI);
1900     }
1901 
1902     function lockBaseURI() external onlyOwner {
1903         require(!BaseURIUnchangeable, "Already locked");
1904         BaseURIUnchangeable = true;
1905     }
1906 
1907     /*
1908     * Pause sale if active, make active if paused
1909     */
1910     function flipSaleState() external onlyOwner {
1911         saleIsActive = !saleIsActive;
1912         emit SaleStateFlipped(saleIsActive);
1913     }
1914 }