1 // SPDX-License-Identifier: MIT
2 
3 // Scroll down to the bottom to find the contract of interest. 
4 
5 // File: @openzeppelin/contracts@3.4.2/introspection/IERC165.sol
6 
7 
8 pragma solidity >=0.6.0 <0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 // File: @openzeppelin/contracts@3.4.2/utils/Context.sol
32 
33 
34 pragma solidity >=0.6.0 <0.8.0;
35 
36 /*
37  * @dev Provides information about the current execution context, including the
38  * sender of the transaction and its data. While these are generally available
39  * via msg.sender and msg.data, they should not be accessed in such a direct
40  * manner, since when dealing with GSN meta-transactions the account sending and
41  * paying for execution may not be the actual sender (as far as an application
42  * is concerned).
43  *
44  * This contract is only required for intermediate, library-like contracts.
45  */
46 abstract contract Context {
47     function _msgSender() internal view virtual returns (address payable) {
48         return msg.sender;
49     }
50 
51     function _msgData() internal view virtual returns (bytes memory) {
52         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
53         return msg.data;
54     }
55 }
56 
57 
58 // File: @openzeppelin/contracts@3.4.2/token/ERC721/IERC721.sol
59 
60 
61 pragma solidity >=0.6.2 <0.8.0;
62 
63 // import "@openzeppelin/contracts@3.4.2/introspection/IERC165.sol";
64 
65 /**
66  * @dev Required interface of an ERC721 compliant contract.
67  */
68 interface IERC721 is IERC165 {
69     /**
70      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
73 
74     /**
75      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
76      */
77     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
78 
79     /**
80      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
81      */
82     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
83 
84     /**
85      * @dev Returns the number of tokens in ``owner``'s account.
86      */
87     function balanceOf(address owner) external view returns (uint256 balance);
88 
89     /**
90      * @dev Returns the owner of the `tokenId` token.
91      *
92      * Requirements:
93      *
94      * - `tokenId` must exist.
95      */
96     function ownerOf(uint256 tokenId) external view returns (address owner);
97 
98     /**
99      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
100      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
101      *
102      * Requirements:
103      *
104      * - `from` cannot be the zero address.
105      * - `to` cannot be the zero address.
106      * - `tokenId` token must exist and be owned by `from`.
107      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
108      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
109      *
110      * Emits a {Transfer} event.
111      */
112     function safeTransferFrom(address from, address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Transfers `tokenId` token from `from` to `to`.
116      *
117      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
118      *
119      * Requirements:
120      *
121      * - `from` cannot be the zero address.
122      * - `to` cannot be the zero address.
123      * - `tokenId` token must be owned by `from`.
124      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transferFrom(address from, address to, uint256 tokenId) external;
129 
130     /**
131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
132      * The approval is cleared when the token is transferred.
133      *
134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
135      *
136      * Requirements:
137      *
138      * - The caller must own the token or be an approved operator.
139      * - `tokenId` must exist.
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Returns the account approved for `tokenId` token.
147      *
148      * Requirements:
149      *
150      * - `tokenId` must exist.
151      */
152     function getApproved(uint256 tokenId) external view returns (address operator);
153 
154     /**
155      * @dev Approve or remove `operator` as an operator for the caller.
156      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
157      *
158      * Requirements:
159      *
160      * - The `operator` cannot be the caller.
161      *
162      * Emits an {ApprovalForAll} event.
163      */
164     function setApprovalForAll(address operator, bool _approved) external;
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator) external view returns (bool);
172 
173     /**
174       * @dev Safely transfers `tokenId` token from `from` to `to`.
175       *
176       * Requirements:
177       *
178       * - `from` cannot be the zero address.
179       * - `to` cannot be the zero address.
180       * - `tokenId` token must exist and be owned by `from`.
181       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
182       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
183       *
184       * Emits a {Transfer} event.
185       */
186     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
187 }
188 
189 
190 // File: @openzeppelin/contracts@3.4.2/token/ERC721/IERC721Metadata.sol
191 
192 
193 pragma solidity >=0.6.2 <0.8.0;
194 
195 // import "@openzeppelin/contracts@3.4.2/token/ERC721/IERC721.sol";
196 
197 /**
198  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
199  * @dev See https://eips.ethereum.org/EIPS/eip-721
200  */
201 interface IERC721Metadata is IERC721 {
202 
203     /**
204      * @dev Returns the token collection name.
205      */
206     function name() external view returns (string memory);
207 
208     /**
209      * @dev Returns the token collection symbol.
210      */
211     function symbol() external view returns (string memory);
212 
213     /**
214      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
215      */
216     function tokenURI(uint256 tokenId) external view returns (string memory);
217 }
218 
219 
220 // File: @openzeppelin/contracts@3.4.2/token/ERC721/IERC721Enumerable.sol
221 
222 
223 pragma solidity >=0.6.2 <0.8.0;
224 
225 // import "@openzeppelin/contracts@3.4.2/token/ERC721/IERC721.sol";
226 
227 /**
228  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
229  * @dev See https://eips.ethereum.org/EIPS/eip-721
230  */
231 interface IERC721Enumerable is IERC721 {
232 
233     /**
234      * @dev Returns the total amount of tokens stored by the contract.
235      */
236     function totalSupply() external view returns (uint256);
237 
238     /**
239      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
240      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
241      */
242     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
243 
244     /**
245      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
246      * Use along with {totalSupply} to enumerate all tokens.
247      */
248     function tokenByIndex(uint256 index) external view returns (uint256);
249 }
250 
251 
252 // File: @openzeppelin/contracts@3.4.2/token/ERC721/IERC721Receiver.sol
253 
254 
255 pragma solidity >=0.6.0 <0.8.0;
256 
257 /**
258  * @title ERC721 token receiver interface
259  * @dev Interface for any contract that wants to support safeTransfers
260  * from ERC721 asset contracts.
261  */
262 interface IERC721Receiver {
263     /**
264      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
265      * by `operator` from `from`, this function is called.
266      *
267      * It must return its Solidity selector to confirm the token transfer.
268      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
269      *
270      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
271      */
272     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
273 }
274 
275 
276 // File: @openzeppelin/contracts@3.4.2/introspection/ERC165.sol
277 
278 
279 pragma solidity >=0.6.0 <0.8.0;
280 
281 // import "@openzeppelin/contracts@3.4.2/introspection/IERC165.sol";
282 
283 /**
284  * @dev Implementation of the {IERC165} interface.
285  *
286  * Contracts may inherit from this and call {_registerInterface} to declare
287  * their support of an interface.
288  */
289 abstract contract ERC165 is IERC165 {
290     /*
291      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
292      */
293     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
294 
295     /**
296      * @dev Mapping of interface ids to whether or not it's supported.
297      */
298     mapping(bytes4 => bool) private _supportedInterfaces;
299 
300     constructor () internal {
301         // Derived contracts need only register support for their own interfaces,
302         // we register support for ERC165 itself here
303         _registerInterface(_INTERFACE_ID_ERC165);
304     }
305 
306     /**
307      * @dev See {IERC165-supportsInterface}.
308      *
309      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
310      */
311     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
312         return _supportedInterfaces[interfaceId];
313     }
314 
315     /**
316      * @dev Registers the contract as an implementer of the interface defined by
317      * `interfaceId`. Support of the actual ERC165 interface is automatic and
318      * registering its interface id is not required.
319      *
320      * See {IERC165-supportsInterface}.
321      *
322      * Requirements:
323      *
324      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
325      */
326     function _registerInterface(bytes4 interfaceId) internal virtual {
327         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
328         _supportedInterfaces[interfaceId] = true;
329     }
330 }
331 
332 
333 // File: @openzeppelin/contracts@3.4.2/utils/Address.sol
334 
335 
336 pragma solidity >=0.6.2 <0.8.0;
337 
338 /**
339  * @dev Collection of functions related to the address type
340  */
341 library Address {
342     /**
343      * @dev Returns true if `account` is a contract.
344      *
345      * [IMPORTANT]
346      * ====
347      * It is unsafe to assume that an address for which this function returns
348      * false is an externally-owned account (EOA) and not a contract.
349      *
350      * Among others, `isContract` will return false for the following
351      * types of addresses:
352      *
353      *  - an externally-owned account
354      *  - a contract in construction
355      *  - an address where a contract will be created
356      *  - an address where a contract lived, but was destroyed
357      * ====
358      */
359     function isContract(address account) internal view returns (bool) {
360         // This method relies on extcodesize, which returns 0 for contracts in
361         // construction, since the code is only stored at the end of the
362         // constructor execution.
363 
364         uint256 size;
365         // solhint-disable-next-line no-inline-assembly
366         assembly { size := extcodesize(account) }
367         return size > 0;
368     }
369 
370     /**
371      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
372      * `recipient`, forwarding all available gas and reverting on errors.
373      *
374      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
375      * of certain opcodes, possibly making contracts go over the 2300 gas limit
376      * imposed by `transfer`, making them unable to receive funds via
377      * `transfer`. {sendValue} removes this limitation.
378      *
379      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
380      *
381      * IMPORTANT: because control is transferred to `recipient`, care must be
382      * taken to not create reentrancy vulnerabilities. Consider using
383      * {ReentrancyGuard} or the
384      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
385      */
386     function sendValue(address payable recipient, uint256 amount) internal {
387         require(address(this).balance >= amount, "Address: insufficient balance");
388 
389         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
390         (bool success, ) = recipient.call{ value: amount }("");
391         require(success, "Address: unable to send value, recipient may have reverted");
392     }
393 
394     /**
395      * @dev Performs a Solidity function call using a low level `call`. A
396      * plain`call` is an unsafe replacement for a function call: use this
397      * function instead.
398      *
399      * If `target` reverts with a revert reason, it is bubbled up by this
400      * function (like regular Solidity function calls).
401      *
402      * Returns the raw returned data. To convert to the expected return value,
403      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
404      *
405      * Requirements:
406      *
407      * - `target` must be a contract.
408      * - calling `target` with `data` must not revert.
409      *
410      * _Available since v3.1._
411      */
412     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
413       return functionCall(target, data, "Address: low-level call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
418      * `errorMessage` as a fallback revert reason when `target` reverts.
419      *
420      * _Available since v3.1._
421      */
422     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, 0, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but also transferring `value` wei to `target`.
429      *
430      * Requirements:
431      *
432      * - the calling contract must have an ETH balance of at least `value`.
433      * - the called Solidity function must be `payable`.
434      *
435      * _Available since v3.1._
436      */
437     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
438         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
443      * with `errorMessage` as a fallback revert reason when `target` reverts.
444      *
445      * _Available since v3.1._
446      */
447     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
448         require(address(this).balance >= value, "Address: insufficient balance for call");
449         require(isContract(target), "Address: call to non-contract");
450 
451         // solhint-disable-next-line avoid-low-level-calls
452         (bool success, bytes memory returndata) = target.call{ value: value }(data);
453         return _verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
458      * but performing a static call.
459      *
460      * _Available since v3.3._
461      */
462     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
463         return functionStaticCall(target, data, "Address: low-level static call failed");
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
468      * but performing a static call.
469      *
470      * _Available since v3.3._
471      */
472     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
473         require(isContract(target), "Address: static call to non-contract");
474 
475         // solhint-disable-next-line avoid-low-level-calls
476         (bool success, bytes memory returndata) = target.staticcall(data);
477         return _verifyCallResult(success, returndata, errorMessage);
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
482      * but performing a delegate call.
483      *
484      * _Available since v3.4._
485      */
486     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
487         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
492      * but performing a delegate call.
493      *
494      * _Available since v3.4._
495      */
496     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
497         require(isContract(target), "Address: delegate call to non-contract");
498 
499         // solhint-disable-next-line avoid-low-level-calls
500         (bool success, bytes memory returndata) = target.delegatecall(data);
501         return _verifyCallResult(success, returndata, errorMessage);
502     }
503 
504     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
505         if (success) {
506             return returndata;
507         } else {
508             // Look for revert reason and bubble it up if present
509             if (returndata.length > 0) {
510                 // The easiest way to bubble the revert reason is using memory via assembly
511 
512                 // solhint-disable-next-line no-inline-assembly
513                 assembly {
514                     let returndata_size := mload(returndata)
515                     revert(add(32, returndata), returndata_size)
516                 }
517             } else {
518                 revert(errorMessage);
519             }
520         }
521     }
522 }
523 
524 
525 // File: @openzeppelin/contracts@3.4.2/utils/EnumerableSet.sol
526 
527 
528 pragma solidity >=0.6.0 <0.8.0;
529 
530 /**
531  * @dev Library for managing
532  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
533  * types.
534  *
535  * Sets have the following properties:
536  *
537  * - Elements are added, removed, and checked for existence in constant time
538  * (O(1)).
539  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
540  *
541  * ```
542  * contract Example {
543  *     // Add the library methods
544  *     using EnumerableSet for EnumerableSet.AddressSet;
545  *
546  *     // Declare a set state variable
547  *     EnumerableSet.AddressSet private mySet;
548  * }
549  * ```
550  *
551  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
552  * and `uint256` (`UintSet`) are supported.
553  */
554 library EnumerableSet {
555     // To implement this library for multiple types with as little code
556     // repetition as possible, we write it in terms of a generic Set type with
557     // bytes32 values.
558     // The Set implementation uses private functions, and user-facing
559     // implementations (such as AddressSet) are just wrappers around the
560     // underlying Set.
561     // This means that we can only create new EnumerableSets for types that fit
562     // in bytes32.
563 
564     struct Set {
565         // Storage of set values
566         bytes32[] _values;
567 
568         // Position of the value in the `values` array, plus 1 because index 0
569         // means a value is not in the set.
570         mapping (bytes32 => uint256) _indexes;
571     }
572 
573     /**
574      * @dev Add a value to a set. O(1).
575      *
576      * Returns true if the value was added to the set, that is if it was not
577      * already present.
578      */
579     function _add(Set storage set, bytes32 value) private returns (bool) {
580         if (!_contains(set, value)) {
581             set._values.push(value);
582             // The value is stored at length-1, but we add 1 to all indexes
583             // and use 0 as a sentinel value
584             set._indexes[value] = set._values.length;
585             return true;
586         } else {
587             return false;
588         }
589     }
590 
591     /**
592      * @dev Removes a value from a set. O(1).
593      *
594      * Returns true if the value was removed from the set, that is if it was
595      * present.
596      */
597     function _remove(Set storage set, bytes32 value) private returns (bool) {
598         // We read and store the value's index to prevent multiple reads from the same storage slot
599         uint256 valueIndex = set._indexes[value];
600 
601         if (valueIndex != 0) { // Equivalent to contains(set, value)
602             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
603             // the array, and then remove the last element (sometimes called as 'swap and pop').
604             // This modifies the order of the array, as noted in {at}.
605 
606             uint256 toDeleteIndex = valueIndex - 1;
607             uint256 lastIndex = set._values.length - 1;
608 
609             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
610             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
611 
612             bytes32 lastvalue = set._values[lastIndex];
613 
614             // Move the last value to the index where the value to delete is
615             set._values[toDeleteIndex] = lastvalue;
616             // Update the index for the moved value
617             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
618 
619             // Delete the slot where the moved value was stored
620             set._values.pop();
621 
622             // Delete the index for the deleted slot
623             delete set._indexes[value];
624 
625             return true;
626         } else {
627             return false;
628         }
629     }
630 
631     /**
632      * @dev Returns true if the value is in the set. O(1).
633      */
634     function _contains(Set storage set, bytes32 value) private view returns (bool) {
635         return set._indexes[value] != 0;
636     }
637 
638     /**
639      * @dev Returns the number of values on the set. O(1).
640      */
641     function _length(Set storage set) private view returns (uint256) {
642         return set._values.length;
643     }
644 
645    /**
646     * @dev Returns the value stored at position `index` in the set. O(1).
647     *
648     * Note that there are no guarantees on the ordering of values inside the
649     * array, and it may change when more values are added or removed.
650     *
651     * Requirements:
652     *
653     * - `index` must be strictly less than {length}.
654     */
655     function _at(Set storage set, uint256 index) private view returns (bytes32) {
656         require(set._values.length > index, "EnumerableSet: index out of bounds");
657         return set._values[index];
658     }
659 
660     // Bytes32Set
661 
662     struct Bytes32Set {
663         Set _inner;
664     }
665 
666     /**
667      * @dev Add a value to a set. O(1).
668      *
669      * Returns true if the value was added to the set, that is if it was not
670      * already present.
671      */
672     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
673         return _add(set._inner, value);
674     }
675 
676     /**
677      * @dev Removes a value from a set. O(1).
678      *
679      * Returns true if the value was removed from the set, that is if it was
680      * present.
681      */
682     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
683         return _remove(set._inner, value);
684     }
685 
686     /**
687      * @dev Returns true if the value is in the set. O(1).
688      */
689     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
690         return _contains(set._inner, value);
691     }
692 
693     /**
694      * @dev Returns the number of values in the set. O(1).
695      */
696     function length(Bytes32Set storage set) internal view returns (uint256) {
697         return _length(set._inner);
698     }
699 
700    /**
701     * @dev Returns the value stored at position `index` in the set. O(1).
702     *
703     * Note that there are no guarantees on the ordering of values inside the
704     * array, and it may change when more values are added or removed.
705     *
706     * Requirements:
707     *
708     * - `index` must be strictly less than {length}.
709     */
710     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
711         return _at(set._inner, index);
712     }
713 
714     // AddressSet
715 
716     struct AddressSet {
717         Set _inner;
718     }
719 
720     /**
721      * @dev Add a value to a set. O(1).
722      *
723      * Returns true if the value was added to the set, that is if it was not
724      * already present.
725      */
726     function add(AddressSet storage set, address value) internal returns (bool) {
727         return _add(set._inner, bytes32(uint256(uint160(value))));
728     }
729 
730     /**
731      * @dev Removes a value from a set. O(1).
732      *
733      * Returns true if the value was removed from the set, that is if it was
734      * present.
735      */
736     function remove(AddressSet storage set, address value) internal returns (bool) {
737         return _remove(set._inner, bytes32(uint256(uint160(value))));
738     }
739 
740     /**
741      * @dev Returns true if the value is in the set. O(1).
742      */
743     function contains(AddressSet storage set, address value) internal view returns (bool) {
744         return _contains(set._inner, bytes32(uint256(uint160(value))));
745     }
746 
747     /**
748      * @dev Returns the number of values in the set. O(1).
749      */
750     function length(AddressSet storage set) internal view returns (uint256) {
751         return _length(set._inner);
752     }
753 
754    /**
755     * @dev Returns the value stored at position `index` in the set. O(1).
756     *
757     * Note that there are no guarantees on the ordering of values inside the
758     * array, and it may change when more values are added or removed.
759     *
760     * Requirements:
761     *
762     * - `index` must be strictly less than {length}.
763     */
764     function at(AddressSet storage set, uint256 index) internal view returns (address) {
765         return address(uint160(uint256(_at(set._inner, index))));
766     }
767 
768 
769     // UintSet
770 
771     struct UintSet {
772         Set _inner;
773     }
774 
775     /**
776      * @dev Add a value to a set. O(1).
777      *
778      * Returns true if the value was added to the set, that is if it was not
779      * already present.
780      */
781     function add(UintSet storage set, uint256 value) internal returns (bool) {
782         return _add(set._inner, bytes32(value));
783     }
784 
785     /**
786      * @dev Removes a value from a set. O(1).
787      *
788      * Returns true if the value was removed from the set, that is if it was
789      * present.
790      */
791     function remove(UintSet storage set, uint256 value) internal returns (bool) {
792         return _remove(set._inner, bytes32(value));
793     }
794 
795     /**
796      * @dev Returns true if the value is in the set. O(1).
797      */
798     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
799         return _contains(set._inner, bytes32(value));
800     }
801 
802     /**
803      * @dev Returns the number of values on the set. O(1).
804      */
805     function length(UintSet storage set) internal view returns (uint256) {
806         return _length(set._inner);
807     }
808 
809    /**
810     * @dev Returns the value stored at position `index` in the set. O(1).
811     *
812     * Note that there are no guarantees on the ordering of values inside the
813     * array, and it may change when more values are added or removed.
814     *
815     * Requirements:
816     *
817     * - `index` must be strictly less than {length}.
818     */
819     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
820         return uint256(_at(set._inner, index));
821     }
822 }
823 
824 
825 // File: @openzeppelin/contracts@3.4.2/utils/EnumerableMap.sol
826 
827 
828 pragma solidity >=0.6.0 <0.8.0;
829 
830 /**
831  * @dev Library for managing an enumerable variant of Solidity's
832  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
833  * type.
834  *
835  * Maps have the following properties:
836  *
837  * - Entries are added, removed, and checked for existence in constant time
838  * (O(1)).
839  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
840  *
841  * ```
842  * contract Example {
843  *     // Add the library methods
844  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
845  *
846  *     // Declare a set state variable
847  *     EnumerableMap.UintToAddressMap private myMap;
848  * }
849  * ```
850  *
851  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
852  * supported.
853  */
854 library EnumerableMap {
855     // To implement this library for multiple types with as little code
856     // repetition as possible, we write it in terms of a generic Map type with
857     // bytes32 keys and values.
858     // The Map implementation uses private functions, and user-facing
859     // implementations (such as Uint256ToAddressMap) are just wrappers around
860     // the underlying Map.
861     // This means that we can only create new EnumerableMaps for types that fit
862     // in bytes32.
863 
864     struct MapEntry {
865         bytes32 _key;
866         bytes32 _value;
867     }
868 
869     struct Map {
870         // Storage of map keys and values
871         MapEntry[] _entries;
872 
873         // Position of the entry defined by a key in the `entries` array, plus 1
874         // because index 0 means a key is not in the map.
875         mapping (bytes32 => uint256) _indexes;
876     }
877 
878     /**
879      * @dev Adds a key-value pair to a map, or updates the value for an existing
880      * key. O(1).
881      *
882      * Returns true if the key was added to the map, that is if it was not
883      * already present.
884      */
885     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
886         // We read and store the key's index to prevent multiple reads from the same storage slot
887         uint256 keyIndex = map._indexes[key];
888 
889         if (keyIndex == 0) { // Equivalent to !contains(map, key)
890             map._entries.push(MapEntry({ _key: key, _value: value }));
891             // The entry is stored at length-1, but we add 1 to all indexes
892             // and use 0 as a sentinel value
893             map._indexes[key] = map._entries.length;
894             return true;
895         } else {
896             map._entries[keyIndex - 1]._value = value;
897             return false;
898         }
899     }
900 
901     /**
902      * @dev Removes a key-value pair from a map. O(1).
903      *
904      * Returns true if the key was removed from the map, that is if it was present.
905      */
906     function _remove(Map storage map, bytes32 key) private returns (bool) {
907         // We read and store the key's index to prevent multiple reads from the same storage slot
908         uint256 keyIndex = map._indexes[key];
909 
910         if (keyIndex != 0) { // Equivalent to contains(map, key)
911             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
912             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
913             // This modifies the order of the array, as noted in {at}.
914 
915             uint256 toDeleteIndex = keyIndex - 1;
916             uint256 lastIndex = map._entries.length - 1;
917 
918             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
919             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
920 
921             MapEntry storage lastEntry = map._entries[lastIndex];
922 
923             // Move the last entry to the index where the entry to delete is
924             map._entries[toDeleteIndex] = lastEntry;
925             // Update the index for the moved entry
926             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
927 
928             // Delete the slot where the moved entry was stored
929             map._entries.pop();
930 
931             // Delete the index for the deleted slot
932             delete map._indexes[key];
933 
934             return true;
935         } else {
936             return false;
937         }
938     }
939 
940     /**
941      * @dev Returns true if the key is in the map. O(1).
942      */
943     function _contains(Map storage map, bytes32 key) private view returns (bool) {
944         return map._indexes[key] != 0;
945     }
946 
947     /**
948      * @dev Returns the number of key-value pairs in the map. O(1).
949      */
950     function _length(Map storage map) private view returns (uint256) {
951         return map._entries.length;
952     }
953 
954    /**
955     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
956     *
957     * Note that there are no guarantees on the ordering of entries inside the
958     * array, and it may change when more entries are added or removed.
959     *
960     * Requirements:
961     *
962     * - `index` must be strictly less than {length}.
963     */
964     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
965         require(map._entries.length > index, "EnumerableMap: index out of bounds");
966 
967         MapEntry storage entry = map._entries[index];
968         return (entry._key, entry._value);
969     }
970 
971     /**
972      * @dev Tries to returns the value associated with `key`.  O(1).
973      * Does not revert if `key` is not in the map.
974      */
975     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
976         uint256 keyIndex = map._indexes[key];
977         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
978         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
979     }
980 
981     /**
982      * @dev Returns the value associated with `key`.  O(1).
983      *
984      * Requirements:
985      *
986      * - `key` must be in the map.
987      */
988     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
989         uint256 keyIndex = map._indexes[key];
990         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
991         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
992     }
993 
994     /**
995      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
996      *
997      * CAUTION: This function is deprecated because it requires allocating memory for the error
998      * message unnecessarily. For custom revert reasons use {_tryGet}.
999      */
1000     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1001         uint256 keyIndex = map._indexes[key];
1002         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1003         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1004     }
1005 
1006     // UintToAddressMap
1007 
1008     struct UintToAddressMap {
1009         Map _inner;
1010     }
1011 
1012     /**
1013      * @dev Adds a key-value pair to a map, or updates the value for an existing
1014      * key. O(1).
1015      *
1016      * Returns true if the key was added to the map, that is if it was not
1017      * already present.
1018      */
1019     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1020         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1021     }
1022 
1023     /**
1024      * @dev Removes a value from a set. O(1).
1025      *
1026      * Returns true if the key was removed from the map, that is if it was present.
1027      */
1028     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1029         return _remove(map._inner, bytes32(key));
1030     }
1031 
1032     /**
1033      * @dev Returns true if the key is in the map. O(1).
1034      */
1035     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1036         return _contains(map._inner, bytes32(key));
1037     }
1038 
1039     /**
1040      * @dev Returns the number of elements in the map. O(1).
1041      */
1042     function length(UintToAddressMap storage map) internal view returns (uint256) {
1043         return _length(map._inner);
1044     }
1045 
1046    /**
1047     * @dev Returns the element stored at position `index` in the set. O(1).
1048     * Note that there are no guarantees on the ordering of values inside the
1049     * array, and it may change when more values are added or removed.
1050     *
1051     * Requirements:
1052     *
1053     * - `index` must be strictly less than {length}.
1054     */
1055     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1056         (bytes32 key, bytes32 value) = _at(map._inner, index);
1057         return (uint256(key), address(uint160(uint256(value))));
1058     }
1059 
1060     /**
1061      * @dev Tries to returns the value associated with `key`.  O(1).
1062      * Does not revert if `key` is not in the map.
1063      *
1064      * _Available since v3.4._
1065      */
1066     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1067         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1068         return (success, address(uint160(uint256(value))));
1069     }
1070 
1071     /**
1072      * @dev Returns the value associated with `key`.  O(1).
1073      *
1074      * Requirements:
1075      *
1076      * - `key` must be in the map.
1077      */
1078     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1079         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1080     }
1081 
1082     /**
1083      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1084      *
1085      * CAUTION: This function is deprecated because it requires allocating memory for the error
1086      * message unnecessarily. For custom revert reasons use {tryGet}.
1087      */
1088     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1089         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1090     }
1091 }
1092 
1093 
1094 // File: @openzeppelin/contracts@3.4.2/utils/Strings.sol
1095 
1096 
1097 pragma solidity >=0.6.0 <0.8.0;
1098 
1099 /**
1100  * @dev String operations.
1101  */
1102 library Strings {
1103     /**
1104      * @dev Converts a `uint256` to its ASCII `string` representation.
1105      */
1106     function toString(uint256 value) internal pure returns (string memory) {
1107         // Inspired by OraclizeAPI's implementation - MIT licence
1108         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1109 
1110         if (value == 0) {
1111             return "0";
1112         }
1113         uint256 temp = value;
1114         uint256 digits;
1115         while (temp != 0) {
1116             digits++;
1117             temp /= 10;
1118         }
1119         bytes memory buffer = new bytes(digits);
1120         uint256 index = digits - 1;
1121         temp = value;
1122         while (temp != 0) {
1123             buffer[index--] = bytes1(uint8(48 + temp % 10));
1124             temp /= 10;
1125         }
1126         return string(buffer);
1127     }
1128 }
1129 
1130 // File: @chainlink/contracts@0.2.2/src/v0.7/vendor/SafeMathChainlink.sol
1131 
1132 pragma solidity ^0.7.0;
1133 
1134 /**
1135  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1136  * checks.
1137  *
1138  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1139  * in bugs, because programmers usually assume that an overflow raises an
1140  * error, which is the standard behavior in high level programming languages.
1141  * `SafeMath` restores this intuition by reverting the transaction when an
1142  * operation overflows.
1143  *
1144  * Using this library instead of the unchecked operations eliminates an entire
1145  * class of bugs, so it's recommended to use it always.
1146  */
1147 library SafeMathChainlink {
1148   /**
1149     * @dev Returns the addition of two unsigned integers, reverting on
1150     * overflow.
1151     *
1152     * Counterpart to Solidity's `+` operator.
1153     *
1154     * Requirements:
1155     * - Addition cannot overflow.
1156     */
1157   function add(
1158     uint256 a,
1159     uint256 b
1160   )
1161     internal
1162     pure
1163     returns (
1164       uint256
1165     )
1166   {
1167     uint256 c = a + b;
1168     require(c >= a, "SafeMath: addition overflow");
1169 
1170     return c;
1171   }
1172 
1173   /**
1174     * @dev Returns the subtraction of two unsigned integers, reverting on
1175     * overflow (when the result is negative).
1176     *
1177     * Counterpart to Solidity's `-` operator.
1178     *
1179     * Requirements:
1180     * - Subtraction cannot overflow.
1181     */
1182   function sub(
1183     uint256 a,
1184     uint256 b
1185   )
1186     internal
1187     pure
1188     returns (
1189       uint256
1190     )
1191   {
1192     require(b <= a, "SafeMath: subtraction overflow");
1193     uint256 c = a - b;
1194 
1195     return c;
1196   }
1197 
1198   /**
1199     * @dev Returns the multiplication of two unsigned integers, reverting on
1200     * overflow.
1201     *
1202     * Counterpart to Solidity's `*` operator.
1203     *
1204     * Requirements:
1205     * - Multiplication cannot overflow.
1206     */
1207   function mul(
1208     uint256 a,
1209     uint256 b
1210   )
1211     internal
1212     pure
1213     returns (
1214       uint256
1215     )
1216   {
1217     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1218     // benefit is lost if 'b' is also tested.
1219     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1220     if (a == 0) {
1221       return 0;
1222     }
1223 
1224     uint256 c = a * b;
1225     require(c / a == b, "SafeMath: multiplication overflow");
1226 
1227     return c;
1228   }
1229 
1230   /**
1231     * @dev Returns the integer division of two unsigned integers. Reverts on
1232     * division by zero. The result is rounded towards zero.
1233     *
1234     * Counterpart to Solidity's `/` operator. Note: this function uses a
1235     * `revert` opcode (which leaves remaining gas untouched) while Solidity
1236     * uses an invalid opcode to revert (consuming all remaining gas).
1237     *
1238     * Requirements:
1239     * - The divisor cannot be zero.
1240     */
1241   function div(
1242     uint256 a,
1243     uint256 b
1244   )
1245     internal
1246     pure
1247     returns (
1248       uint256
1249     )
1250   {
1251     // Solidity only automatically asserts when dividing by 0
1252     require(b > 0, "SafeMath: division by zero");
1253     uint256 c = a / b;
1254     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1255 
1256     return c;
1257   }
1258 
1259   /**
1260     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1261     * Reverts when dividing by zero.
1262     *
1263     * Counterpart to Solidity's `%` operator. This function uses a `revert`
1264     * opcode (which leaves remaining gas untouched) while Solidity uses an
1265     * invalid opcode to revert (consuming all remaining gas).
1266     *
1267     * Requirements:
1268     * - The divisor cannot be zero.
1269     */
1270   function mod(
1271     uint256 a,
1272     uint256 b
1273   )
1274     internal
1275     pure
1276     returns (
1277       uint256
1278     )
1279   {
1280     require(b != 0, "SafeMath: modulo by zero");
1281     return a % b;
1282   }
1283 }
1284 
1285 
1286 // File: @chainlink/contracts@0.2.2/src/v0.7/interfaces/LinkTokenInterface.sol
1287 
1288 pragma solidity ^0.7.0;
1289 
1290 interface LinkTokenInterface {
1291 
1292   function allowance(
1293     address owner,
1294     address spender
1295   )
1296     external
1297     view
1298     returns (
1299       uint256 remaining
1300     );
1301 
1302   function approve(
1303     address spender,
1304     uint256 value
1305   )
1306     external
1307     returns (
1308       bool success
1309     );
1310 
1311   function balanceOf(
1312     address owner
1313   )
1314     external
1315     view
1316     returns (
1317       uint256 balance
1318     );
1319 
1320   function decimals()
1321     external
1322     view
1323     returns (
1324       uint8 decimalPlaces
1325     );
1326 
1327   function decreaseApproval(
1328     address spender,
1329     uint256 addedValue
1330   )
1331     external
1332     returns (
1333       bool success
1334     );
1335 
1336   function increaseApproval(
1337     address spender,
1338     uint256 subtractedValue
1339   ) external;
1340 
1341   function name()
1342     external
1343     view
1344     returns (
1345       string memory tokenName
1346     );
1347 
1348   function symbol()
1349     external
1350     view
1351     returns (
1352       string memory tokenSymbol
1353     );
1354 
1355   function totalSupply()
1356     external
1357     view
1358     returns (
1359       uint256 totalTokensIssued
1360     );
1361 
1362   function transfer(
1363     address to,
1364     uint256 value
1365   )
1366     external
1367     returns (
1368       bool success
1369     );
1370 
1371   function transferAndCall(
1372     address to,
1373     uint256 value,
1374     bytes calldata data
1375   )
1376     external
1377     returns (
1378       bool success
1379     );
1380 
1381   function transferFrom(
1382     address from,
1383     address to,
1384     uint256 value
1385   )
1386     external
1387     returns (
1388       bool success
1389     );
1390 
1391 }
1392 
1393 
1394 // File: @chainlink/contracts@0.2.2/src/v0.7/VRFRequestIDBase.sol
1395 
1396 pragma solidity ^0.7.0;
1397 
1398 contract VRFRequestIDBase {
1399 
1400   /**
1401    * @notice returns the seed which is actually input to the VRF coordinator
1402    *
1403    * @dev To prevent repetition of VRF output due to repetition of the
1404    * @dev user-supplied seed, that seed is combined in a hash with the
1405    * @dev user-specific nonce, and the address of the consuming contract. The
1406    * @dev risk of repetition is mostly mitigated by inclusion of a blockhash in
1407    * @dev the final seed, but the nonce does protect against repetition in
1408    * @dev requests which are included in a single block.
1409    *
1410    * @param _userSeed VRF seed input provided by user
1411    * @param _requester Address of the requesting contract
1412    * @param _nonce User-specific nonce at the time of the request
1413    */
1414   function makeVRFInputSeed(
1415     bytes32 _keyHash,
1416     uint256 _userSeed,
1417     address _requester,
1418     uint256 _nonce
1419   )
1420     internal
1421     pure
1422     returns (
1423       uint256
1424     )
1425   {
1426     return uint256(keccak256(abi.encode(_keyHash, _userSeed, _requester, _nonce)));
1427   }
1428 
1429   /**
1430    * @notice Returns the id for this request
1431    * @param _keyHash The serviceAgreement ID to be used for this request
1432    * @param _vRFInputSeed The seed to be passed directly to the VRF
1433    * @return The id for this request
1434    *
1435    * @dev Note that _vRFInputSeed is not the seed passed by the consuming
1436    * @dev contract, but the one generated by makeVRFInputSeed
1437    */
1438   function makeRequestId(
1439     bytes32 _keyHash,
1440     uint256 _vRFInputSeed
1441   )
1442     internal
1443     pure
1444     returns (
1445       bytes32
1446     )
1447   {
1448     return keccak256(abi.encodePacked(_keyHash, _vRFInputSeed));
1449   }
1450 }
1451 
1452 
1453 // File: @chainlink/contracts@0.2.2/src/v0.7/VRFConsumerBase.sol
1454 
1455 pragma solidity ^0.7.0;
1456 
1457 // import "@chainlink/contracts@0.2.2/src/v0.7/vendor/SafeMathChainlink.sol";
1458 
1459 // import "@chainlink/contracts@0.2.2/src/v0.7/interfaces/LinkTokenInterface.sol";
1460 
1461 // import "@chainlink/contracts@0.2.2/src/v0.7/VRFRequestIDBase.sol";
1462 
1463 /** ****************************************************************************
1464  * @notice Interface for contracts using VRF randomness
1465  * *****************************************************************************
1466  * @dev PURPOSE
1467  *
1468  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
1469  * @dev to Vera the verifier in such a way that Vera can be sure he's not
1470  * @dev making his output up to suit himself. Reggie provides Vera a public key
1471  * @dev to which he knows the secret key. Each time Vera provides a seed to
1472  * @dev Reggie, he gives back a value which is computed completely
1473  * @dev deterministically from the seed and the secret key.
1474  *
1475  * @dev Reggie provides a proof by which Vera can verify that the output was
1476  * @dev correctly computed once Reggie tells it to her, but without that proof,
1477  * @dev the output is indistinguishable to her from a uniform random sample
1478  * @dev from the output space.
1479  *
1480  * @dev The purpose of this contract is to make it easy for unrelated contracts
1481  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
1482  * @dev simple access to a verifiable source of randomness.
1483  * *****************************************************************************
1484  * @dev USAGE
1485  *
1486  * @dev Calling contracts must inherit from VRFConsumerBase, and can
1487  * @dev initialize VRFConsumerBase's attributes in their constructor as
1488  * @dev shown:
1489  *
1490  * @dev   contract VRFConsumer {
1491  * @dev     constuctor(<other arguments>, address _vrfCoordinator, address _link)
1492  * @dev       VRFConsumerBase(_vrfCoordinator, _link) public {
1493  * @dev         <initialization with other arguments goes here>
1494  * @dev       }
1495  * @dev   }
1496  *
1497  * @dev The oracle will have given you an ID for the VRF keypair they have
1498  * @dev committed to (let's call it keyHash), and have told you the minimum LINK
1499  * @dev price for VRF service. Make sure your contract has sufficient LINK, and
1500  * @dev call requestRandomness(keyHash, fee, seed), where seed is the input you
1501  * @dev want to generate randomness from.
1502  *
1503  * @dev Once the VRFCoordinator has received and validated the oracle's response
1504  * @dev to your request, it will call your contract's fulfillRandomness method.
1505  *
1506  * @dev The randomness argument to fulfillRandomness is the actual random value
1507  * @dev generated from your seed.
1508  *
1509  * @dev The requestId argument is generated from the keyHash and the seed by
1510  * @dev makeRequestId(keyHash, seed). If your contract could have concurrent
1511  * @dev requests open, you can use the requestId to track which seed is
1512  * @dev associated with which randomness. See VRFRequestIDBase.sol for more
1513  * @dev details. (See "SECURITY CONSIDERATIONS" for principles to keep in mind,
1514  * @dev if your contract could have multiple requests in flight simultaneously.)
1515  *
1516  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
1517  * @dev differ. (Which is critical to making unpredictable randomness! See the
1518  * @dev next section.)
1519  *
1520  * *****************************************************************************
1521  * @dev SECURITY CONSIDERATIONS
1522  *
1523  * @dev A method with the ability to call your fulfillRandomness method directly
1524  * @dev could spoof a VRF response with any random value, so it's critical that
1525  * @dev it cannot be directly called by anything other than this base contract
1526  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
1527  *
1528  * @dev For your users to trust that your contract's random behavior is free
1529  * @dev from malicious interference, it's best if you can write it so that all
1530  * @dev behaviors implied by a VRF response are executed *during* your
1531  * @dev fulfillRandomness method. If your contract must store the response (or
1532  * @dev anything derived from it) and use it later, you must ensure that any
1533  * @dev user-significant behavior which depends on that stored value cannot be
1534  * @dev manipulated by a subsequent VRF request.
1535  *
1536  * @dev Similarly, both miners and the VRF oracle itself have some influence
1537  * @dev over the order in which VRF responses appear on the blockchain, so if
1538  * @dev your contract could have multiple VRF requests in flight simultaneously,
1539  * @dev you must ensure that the order in which the VRF responses arrive cannot
1540  * @dev be used to manipulate your contract's user-significant behavior.
1541  *
1542  * @dev Since the ultimate input to the VRF is mixed with the block hash of the
1543  * @dev block in which the request is made, user-provided seeds have no impact
1544  * @dev on its economic security properties. They are only included for API
1545  * @dev compatability with previous versions of this contract.
1546  *
1547  * @dev Since the block hash of the block which contains the requestRandomness
1548  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
1549  * @dev miner could, in principle, fork the blockchain to evict the block
1550  * @dev containing the request, forcing the request to be included in a
1551  * @dev different block with a different hash, and therefore a different input
1552  * @dev to the VRF. However, such an attack would incur a substantial economic
1553  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
1554  * @dev until it calls responds to a request.
1555  */
1556 abstract contract VRFConsumerBase is VRFRequestIDBase {
1557 
1558   using SafeMathChainlink for uint256;
1559 
1560   /**
1561    * @notice fulfillRandomness handles the VRF response. Your contract must
1562    * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
1563    * @notice principles to keep in mind when implementing your fulfillRandomness
1564    * @notice method.
1565    *
1566    * @dev VRFConsumerBase expects its subcontracts to have a method with this
1567    * @dev signature, and will call it once it has verified the proof
1568    * @dev associated with the randomness. (It is triggered via a call to
1569    * @dev rawFulfillRandomness, below.)
1570    *
1571    * @param requestId The Id initially returned by requestRandomness
1572    * @param randomness the VRF output
1573    */
1574   function fulfillRandomness(
1575     bytes32 requestId,
1576     uint256 randomness
1577   )
1578     internal
1579     virtual;
1580 
1581   /**
1582    * @dev In order to keep backwards compatibility we have kept the user
1583    * seed field around. We remove the use of it because given that the blockhash
1584    * enters later, it overrides whatever randomness the used seed provides.
1585    * Given that it adds no security, and can easily lead to misunderstandings,
1586    * we have removed it from usage and can now provide a simpler API.
1587    */
1588   uint256 constant private USER_SEED_PLACEHOLDER = 0;
1589 
1590   /**
1591    * @notice requestRandomness initiates a request for VRF output given _seed
1592    *
1593    * @dev The fulfillRandomness method receives the output, once it's provided
1594    * @dev by the Oracle, and verified by the vrfCoordinator.
1595    *
1596    * @dev The _keyHash must already be registered with the VRFCoordinator, and
1597    * @dev the _fee must exceed the fee specified during registration of the
1598    * @dev _keyHash.
1599    *
1600    * @dev The _seed parameter is vestigial, and is kept only for API
1601    * @dev compatibility with older versions. It can't *hurt* to mix in some of
1602    * @dev your own randomness, here, but it's not necessary because the VRF
1603    * @dev oracle will mix the hash of the block containing your request into the
1604    * @dev VRF seed it ultimately uses.
1605    *
1606    * @param _keyHash ID of public key against which randomness is generated
1607    * @param _fee The amount of LINK to send with the request
1608    *
1609    * @return requestId unique ID for this request
1610    *
1611    * @dev The returned requestId can be used to distinguish responses to
1612    * @dev concurrent requests. It is passed as the first argument to
1613    * @dev fulfillRandomness.
1614    */
1615   function requestRandomness(
1616     bytes32 _keyHash,
1617     uint256 _fee
1618   )
1619     internal
1620     returns (
1621       bytes32 requestId
1622     )
1623   {
1624     LINK.transferAndCall(vrfCoordinator, _fee, abi.encode(_keyHash, USER_SEED_PLACEHOLDER));
1625     // This is the seed passed to VRFCoordinator. The oracle will mix this with
1626     // the hash of the block containing this request to obtain the seed/input
1627     // which is finally passed to the VRF cryptographic machinery.
1628     uint256 vRFSeed  = makeVRFInputSeed(_keyHash, USER_SEED_PLACEHOLDER, address(this), nonces[_keyHash]);
1629     // nonces[_keyHash] must stay in sync with
1630     // VRFCoordinator.nonces[_keyHash][this], which was incremented by the above
1631     // successful LINK.transferAndCall (in VRFCoordinator.randomnessRequest).
1632     // This provides protection against the user repeating their input seed,
1633     // which would result in a predictable/duplicate output, if multiple such
1634     // requests appeared in the same block.
1635     nonces[_keyHash] = nonces[_keyHash].add(1);
1636     return makeRequestId(_keyHash, vRFSeed);
1637   }
1638 
1639   LinkTokenInterface immutable internal LINK;
1640   address immutable private vrfCoordinator;
1641 
1642   // Nonces for each VRF key from which randomness has been requested.
1643   //
1644   // Must stay in sync with VRFCoordinator[_keyHash][this]
1645   mapping(bytes32 /* keyHash */ => uint256 /* nonce */) private nonces;
1646 
1647   /**
1648    * @param _vrfCoordinator address of VRFCoordinator contract
1649    * @param _link address of LINK token contract
1650    *
1651    * @dev https://docs.chain.link/docs/link-token-contracts
1652    */
1653   constructor(
1654     address _vrfCoordinator,
1655     address _link
1656   ) {
1657     vrfCoordinator = _vrfCoordinator;
1658     LINK = LinkTokenInterface(_link);
1659   }
1660 
1661   // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
1662   // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
1663   // the origin of the call
1664   function rawFulfillRandomness(
1665     bytes32 requestId,
1666     uint256 randomness
1667   )
1668     external
1669   {
1670     require(msg.sender == vrfCoordinator, "Only VRFCoordinator can fulfill");
1671     fulfillRandomness(requestId, randomness);
1672   }
1673 }
1674 
1675 
1676 
1677 // File: @openzeppelin/contracts@3.4.2/math/SafeMath.sol
1678 
1679 
1680 pragma solidity >=0.6.0 <0.8.0;
1681 
1682 /**
1683  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1684  * checks.
1685  *
1686  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1687  * in bugs, because programmers usually assume that an overflow raises an
1688  * error, which is the standard behavior in high level programming languages.
1689  * `SafeMath` restores this intuition by reverting the transaction when an
1690  * operation overflows.
1691  *
1692  * Using this library instead of the unchecked operations eliminates an entire
1693  * class of bugs, so it's recommended to use it always.
1694  */
1695 library SafeMath {
1696     /**
1697      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1698      *
1699      * _Available since v3.4._
1700      */
1701     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1702         uint256 c = a + b;
1703         if (c < a) return (false, 0);
1704         return (true, c);
1705     }
1706 
1707     /**
1708      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1709      *
1710      * _Available since v3.4._
1711      */
1712     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1713         if (b > a) return (false, 0);
1714         return (true, a - b);
1715     }
1716 
1717     /**
1718      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1719      *
1720      * _Available since v3.4._
1721      */
1722     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1723         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1724         // benefit is lost if 'b' is also tested.
1725         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1726         if (a == 0) return (true, 0);
1727         uint256 c = a * b;
1728         if (c / a != b) return (false, 0);
1729         return (true, c);
1730     }
1731 
1732     /**
1733      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1734      *
1735      * _Available since v3.4._
1736      */
1737     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1738         if (b == 0) return (false, 0);
1739         return (true, a / b);
1740     }
1741 
1742     /**
1743      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1744      *
1745      * _Available since v3.4._
1746      */
1747     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1748         if (b == 0) return (false, 0);
1749         return (true, a % b);
1750     }
1751 
1752     /**
1753      * @dev Returns the addition of two unsigned integers, reverting on
1754      * overflow.
1755      *
1756      * Counterpart to Solidity's `+` operator.
1757      *
1758      * Requirements:
1759      *
1760      * - Addition cannot overflow.
1761      */
1762     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1763         uint256 c = a + b;
1764         require(c >= a, "SafeMath: addition overflow");
1765         return c;
1766     }
1767 
1768     /**
1769      * @dev Returns the subtraction of two unsigned integers, reverting on
1770      * overflow (when the result is negative).
1771      *
1772      * Counterpart to Solidity's `-` operator.
1773      *
1774      * Requirements:
1775      *
1776      * - Subtraction cannot overflow.
1777      */
1778     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1779         require(b <= a, "SafeMath: subtraction overflow");
1780         return a - b;
1781     }
1782 
1783     /**
1784      * @dev Returns the multiplication of two unsigned integers, reverting on
1785      * overflow.
1786      *
1787      * Counterpart to Solidity's `*` operator.
1788      *
1789      * Requirements:
1790      *
1791      * - Multiplication cannot overflow.
1792      */
1793     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1794         if (a == 0) return 0;
1795         uint256 c = a * b;
1796         require(c / a == b, "SafeMath: multiplication overflow");
1797         return c;
1798     }
1799 
1800     /**
1801      * @dev Returns the integer division of two unsigned integers, reverting on
1802      * division by zero. The result is rounded towards zero.
1803      *
1804      * Counterpart to Solidity's `/` operator. Note: this function uses a
1805      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1806      * uses an invalid opcode to revert (consuming all remaining gas).
1807      *
1808      * Requirements:
1809      *
1810      * - The divisor cannot be zero.
1811      */
1812     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1813         require(b > 0, "SafeMath: division by zero");
1814         return a / b;
1815     }
1816 
1817     /**
1818      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1819      * reverting when dividing by zero.
1820      *
1821      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1822      * opcode (which leaves remaining gas untouched) while Solidity uses an
1823      * invalid opcode to revert (consuming all remaining gas).
1824      *
1825      * Requirements:
1826      *
1827      * - The divisor cannot be zero.
1828      */
1829     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1830         require(b > 0, "SafeMath: modulo by zero");
1831         return a % b;
1832     }
1833 
1834     /**
1835      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1836      * overflow (when the result is negative).
1837      *
1838      * CAUTION: This function is deprecated because it requires allocating memory for the error
1839      * message unnecessarily. For custom revert reasons use {trySub}.
1840      *
1841      * Counterpart to Solidity's `-` operator.
1842      *
1843      * Requirements:
1844      *
1845      * - Subtraction cannot overflow.
1846      */
1847     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1848         require(b <= a, errorMessage);
1849         return a - b;
1850     }
1851 
1852     /**
1853      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1854      * division by zero. The result is rounded towards zero.
1855      *
1856      * CAUTION: This function is deprecated because it requires allocating memory for the error
1857      * message unnecessarily. For custom revert reasons use {tryDiv}.
1858      *
1859      * Counterpart to Solidity's `/` operator. Note: this function uses a
1860      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1861      * uses an invalid opcode to revert (consuming all remaining gas).
1862      *
1863      * Requirements:
1864      *
1865      * - The divisor cannot be zero.
1866      */
1867     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1868         require(b > 0, errorMessage);
1869         return a / b;
1870     }
1871 
1872     /**
1873      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1874      * reverting with custom message when dividing by zero.
1875      *
1876      * CAUTION: This function is deprecated because it requires allocating memory for the error
1877      * message unnecessarily. For custom revert reasons use {tryMod}.
1878      *
1879      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1880      * opcode (which leaves remaining gas untouched) while Solidity uses an
1881      * invalid opcode to revert (consuming all remaining gas).
1882      *
1883      * Requirements:
1884      *
1885      * - The divisor cannot be zero.
1886      */
1887     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1888         require(b > 0, errorMessage);
1889         return a % b;
1890     }
1891 }
1892 
1893 
1894 // File: @openzeppelin/contracts@3.4.2/token/ERC721/ERC721.sol
1895 
1896 
1897 pragma solidity >=0.6.0 <0.8.0;
1898 
1899 // import "@openzeppelin/contracts@3.4.2/utils/Context.sol";
1900 // import "@openzeppelin/contracts@3.4.2/token/ERC721/IERC721.sol";
1901 // import "@openzeppelin/contracts@3.4.2/token/ERC721/IERC721Metadata.sol";
1902 // import "@openzeppelin/contracts@3.4.2/token/ERC721/IERC721Enumerable.sol";
1903 // import "@openzeppelin/contracts@3.4.2/token/ERC721/IERC721Receiver.sol";
1904 // import "@openzeppelin/contracts@3.4.2/introspection/ERC165.sol";
1905 // import "@openzeppelin/contracts@3.4.2/math/SafeMath.sol";
1906 // import "@openzeppelin/contracts@3.4.2/utils/Address.sol";
1907 // import "@openzeppelin/contracts@3.4.2/utils/EnumerableSet.sol";
1908 // import "@openzeppelin/contracts@3.4.2/utils/EnumerableMap.sol";
1909 // import "@openzeppelin/contracts@3.4.2/utils/Strings.sol";
1910 
1911 /**
1912  * @title ERC721 Non-Fungible Token Standard basic implementation
1913  * @dev see https://eips.ethereum.org/EIPS/eip-721
1914  */
1915 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1916     using SafeMath for uint256;
1917     using Address for address;
1918     using EnumerableSet for EnumerableSet.UintSet;
1919     using EnumerableMap for EnumerableMap.UintToAddressMap;
1920     using Strings for uint256;
1921 
1922     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1923     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1924     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1925 
1926     // Mapping from holder address to their (enumerable) set of owned tokens
1927     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1928 
1929     // Enumerable mapping from token ids to their owners
1930     EnumerableMap.UintToAddressMap private _tokenOwners;
1931 
1932     // Mapping from token ID to approved address
1933     mapping (uint256 => address) private _tokenApprovals;
1934 
1935     // Mapping from owner to operator approvals
1936     mapping (address => mapping (address => bool)) private _operatorApprovals;
1937 
1938     // Token name
1939     string private _name;
1940 
1941     // Token symbol
1942     string private _symbol;
1943 
1944     // Optional mapping for token URIs
1945     mapping (uint256 => string) private _tokenURIs;
1946 
1947     // Base URI
1948     string private _baseURI;
1949 
1950     /*
1951      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1952      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1953      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1954      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1955      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1956      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1957      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1958      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1959      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1960      *
1961      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1962      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1963      */
1964     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1965 
1966     /*
1967      *     bytes4(keccak256('name()')) == 0x06fdde03
1968      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1969      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1970      *
1971      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1972      */
1973     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1974 
1975     /*
1976      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1977      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1978      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1979      *
1980      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1981      */
1982     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1983 
1984     /**
1985      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1986      */
1987     constructor (string memory name_, string memory symbol_) public {
1988         _name = name_;
1989         _symbol = symbol_;
1990 
1991         // register the supported interfaces to conform to ERC721 via ERC165
1992         _registerInterface(_INTERFACE_ID_ERC721);
1993         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1994         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1995     }
1996 
1997     /**
1998      * @dev See {IERC721-balanceOf}.
1999      */
2000     function balanceOf(address owner) public view virtual override returns (uint256) {
2001         require(owner != address(0), "ERC721: balance query for the zero address");
2002         return _holderTokens[owner].length();
2003     }
2004 
2005     /**
2006      * @dev See {IERC721-ownerOf}.
2007      */
2008     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2009         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
2010     }
2011 
2012     /**
2013      * @dev See {IERC721Metadata-name}.
2014      */
2015     function name() public view virtual override returns (string memory) {
2016         return _name;
2017     }
2018 
2019     /**
2020      * @dev See {IERC721Metadata-symbol}.
2021      */
2022     function symbol() public view virtual override returns (string memory) {
2023         return _symbol;
2024     }
2025 
2026     /**
2027      * @dev See {IERC721Metadata-tokenURI}.
2028      */
2029     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2030         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2031 
2032         string memory _tokenURI = _tokenURIs[tokenId];
2033         string memory base = baseURI();
2034 
2035         // If there is no base URI, return the token URI.
2036         if (bytes(base).length == 0) {
2037             return _tokenURI;
2038         }
2039         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
2040         if (bytes(_tokenURI).length > 0) {
2041             return string(abi.encodePacked(base, _tokenURI));
2042         }
2043         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
2044         return string(abi.encodePacked(base, tokenId.toString()));
2045     }
2046 
2047     /**
2048     * @dev Returns the base URI set via {_setBaseURI}. This will be
2049     * automatically added as a prefix in {tokenURI} to each token's URI, or
2050     * to the token ID if no specific URI is set for that token ID.
2051     */
2052     function baseURI() public view virtual returns (string memory) {
2053         return _baseURI;
2054     }
2055 
2056     /**
2057      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2058      */
2059     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2060         return _holderTokens[owner].at(index);
2061     }
2062 
2063     /**
2064      * @dev See {IERC721Enumerable-totalSupply}.
2065      */
2066     function totalSupply() public view virtual override returns (uint256) {
2067         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
2068         return _tokenOwners.length();
2069     }
2070 
2071     /**
2072      * @dev See {IERC721Enumerable-tokenByIndex}.
2073      */
2074     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2075         (uint256 tokenId, ) = _tokenOwners.at(index);
2076         return tokenId;
2077     }
2078 
2079     /**
2080      * @dev See {IERC721-approve}.
2081      */
2082     function approve(address to, uint256 tokenId) public virtual override {
2083         address owner = ERC721.ownerOf(tokenId);
2084         require(to != owner, "ERC721: approval to current owner");
2085 
2086         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
2087             "ERC721: approve caller is not owner nor approved for all"
2088         );
2089 
2090         _approve(to, tokenId);
2091     }
2092 
2093     /**
2094      * @dev See {IERC721-getApproved}.
2095      */
2096     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2097         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2098 
2099         return _tokenApprovals[tokenId];
2100     }
2101 
2102     /**
2103      * @dev See {IERC721-setApprovalForAll}.
2104      */
2105     function setApprovalForAll(address operator, bool approved) public virtual override {
2106         require(operator != _msgSender(), "ERC721: approve to caller");
2107 
2108         _operatorApprovals[_msgSender()][operator] = approved;
2109         emit ApprovalForAll(_msgSender(), operator, approved);
2110     }
2111 
2112     /**
2113      * @dev See {IERC721-isApprovedForAll}.
2114      */
2115     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2116         return _operatorApprovals[owner][operator];
2117     }
2118 
2119     /**
2120      * @dev See {IERC721-transferFrom}.
2121      */
2122     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
2123         //solhint-disable-next-line max-line-length
2124         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2125 
2126         _transfer(from, to, tokenId);
2127     }
2128 
2129     /**
2130      * @dev See {IERC721-safeTransferFrom}.
2131      */
2132     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
2133         safeTransferFrom(from, to, tokenId, "");
2134     }
2135 
2136     /**
2137      * @dev See {IERC721-safeTransferFrom}.
2138      */
2139     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
2140         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2141         _safeTransfer(from, to, tokenId, _data);
2142     }
2143 
2144     /**
2145      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2146      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2147      *
2148      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2149      *
2150      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2151      * implement alternative mechanisms to perform token transfer, such as signature-based.
2152      *
2153      * Requirements:
2154      *
2155      * - `from` cannot be the zero address.
2156      * - `to` cannot be the zero address.
2157      * - `tokenId` token must exist and be owned by `from`.
2158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2159      *
2160      * Emits a {Transfer} event.
2161      */
2162     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
2163         _transfer(from, to, tokenId);
2164         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2165     }
2166 
2167     /**
2168      * @dev Returns whether `tokenId` exists.
2169      *
2170      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2171      *
2172      * Tokens start existing when they are minted (`_mint`),
2173      * and stop existing when they are burned (`_burn`).
2174      */
2175     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2176         return _tokenOwners.contains(tokenId);
2177     }
2178 
2179     /**
2180      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2181      *
2182      * Requirements:
2183      *
2184      * - `tokenId` must exist.
2185      */
2186     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2187         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2188         address owner = ERC721.ownerOf(tokenId);
2189         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
2190     }
2191 
2192     /**
2193      * @dev Safely mints `tokenId` and transfers it to `to`.
2194      *
2195      * Requirements:
2196      d*
2197      * - `tokenId` must not exist.
2198      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2199      *
2200      * Emits a {Transfer} event.
2201      */
2202     function _safeMint(address to, uint256 tokenId) internal virtual {
2203         _safeMint(to, tokenId, "");
2204     }
2205 
2206     /**
2207      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2208      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2209      */
2210     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
2211         _mint(to, tokenId);
2212         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2213     }
2214 
2215     /**
2216      * @dev Mints `tokenId` and transfers it to `to`.
2217      *
2218      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2219      *
2220      * Requirements:
2221      *
2222      * - `tokenId` must not exist.
2223      * - `to` cannot be the zero address.
2224      *
2225      * Emits a {Transfer} event.
2226      */
2227     function _mint(address to, uint256 tokenId) internal virtual {
2228         require(to != address(0), "ERC721: mint to the zero address");
2229         require(!_exists(tokenId), "ERC721: token already minted");
2230 
2231         _beforeTokenTransfer(address(0), to, tokenId);
2232 
2233         _holderTokens[to].add(tokenId);
2234 
2235         _tokenOwners.set(tokenId, to);
2236 
2237         emit Transfer(address(0), to, tokenId);
2238     }
2239 
2240     /**
2241      * @dev Destroys `tokenId`.
2242      * The approval is cleared when the token is burned.
2243      *
2244      * Requirements:
2245      *
2246      * - `tokenId` must exist.
2247      *
2248      * Emits a {Transfer} event.
2249      */
2250     function _burn(uint256 tokenId) internal virtual {
2251         address owner = ERC721.ownerOf(tokenId); // internal owner
2252 
2253         _beforeTokenTransfer(owner, address(0), tokenId);
2254 
2255         // Clear approvals
2256         _approve(address(0), tokenId);
2257 
2258         // Clear metadata (if any)
2259         if (bytes(_tokenURIs[tokenId]).length != 0) {
2260             delete _tokenURIs[tokenId];
2261         }
2262 
2263         _holderTokens[owner].remove(tokenId);
2264 
2265         _tokenOwners.remove(tokenId);
2266 
2267         emit Transfer(owner, address(0), tokenId);
2268     }
2269 
2270     /**
2271      * @dev Transfers `tokenId` from `from` to `to`.
2272      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2273      *
2274      * Requirements:
2275      *
2276      * - `to` cannot be the zero address.
2277      * - `tokenId` token must be owned by `from`.
2278      *
2279      * Emits a {Transfer} event.
2280      */
2281     function _transfer(address from, address to, uint256 tokenId) internal virtual {
2282         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
2283         require(to != address(0), "ERC721: transfer to the zero address");
2284 
2285         _beforeTokenTransfer(from, to, tokenId);
2286 
2287         // Clear approvals from the previous owner
2288         _approve(address(0), tokenId);
2289 
2290         _holderTokens[from].remove(tokenId);
2291         _holderTokens[to].add(tokenId);
2292 
2293         _tokenOwners.set(tokenId, to);
2294 
2295         emit Transfer(from, to, tokenId);
2296     }
2297 
2298     /**
2299      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2300      *
2301      * Requirements:
2302      *
2303      * - `tokenId` must exist.
2304      */
2305     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
2306         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
2307         _tokenURIs[tokenId] = _tokenURI;
2308     }
2309 
2310     /**
2311      * @dev Internal function to set the base URI for all token IDs. It is
2312      * automatically added as a prefix to the value returned in {tokenURI},
2313      * or to the token ID if {tokenURI} is empty.
2314      */
2315     function _setBaseURI(string memory baseURI_) internal virtual {
2316         _baseURI = baseURI_;
2317     }
2318 
2319     /**
2320      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2321      * The call is not executed if the target address is not a contract.
2322      *
2323      * @param from address representing the previous owner of the given token ID
2324      * @param to target address that will receive the tokens
2325      * @param tokenId uint256 ID of the token to be transferred
2326      * @param _data bytes optional data to send along with the call
2327      * @return bool whether the call correctly returned the expected magic value
2328      */
2329     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
2330         private returns (bool)
2331     {
2332         if (!to.isContract()) {
2333             return true;
2334         }
2335         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
2336             IERC721Receiver(to).onERC721Received.selector,
2337             _msgSender(),
2338             from,
2339             tokenId,
2340             _data
2341         ), "ERC721: transfer to non ERC721Receiver implementer");
2342         bytes4 retval = abi.decode(returndata, (bytes4));
2343         return (retval == _ERC721_RECEIVED);
2344     }
2345 
2346     /**
2347      * @dev Approve `to` to operate on `tokenId`
2348      *
2349      * Emits an {Approval} event.
2350      */
2351     function _approve(address to, uint256 tokenId) internal virtual {
2352         _tokenApprovals[tokenId] = to;
2353         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
2354     }
2355 
2356     /**
2357      * @dev Hook that is called before any token transfer. This includes minting
2358      * and burning.
2359      *
2360      * Calling conditions:
2361      *
2362      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2363      * transferred to `to`.
2364      * - When `from` is zero, `tokenId` will be minted for `to`.
2365      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2366      * - `from` cannot be the zero address.
2367      * - `to` cannot be the zero address.
2368      *
2369      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2370      */
2371     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
2372 }
2373 
2374 
2375 // File: @openzeppelin/contracts@3.4.2/access/Ownable.sol
2376 
2377 
2378 pragma solidity >=0.6.0 <0.8.0;
2379 
2380 // import "@openzeppelin/contracts@3.4.2/utils/Context.sol";
2381 /**
2382  * @dev Contract module which provides a basic access control mechanism, where
2383  * there is an account (an owner) that can be granted exclusive access to
2384  * specific functions.
2385  *
2386  * By default, the owner account will be the one that deploys the contract. This
2387  * can later be changed with {transferOwnership}.
2388  *
2389  * This module is used through inheritance. It will make available the modifier
2390  * `onlyOwner`, which can be applied to your functions to restrict their use to
2391  * the owner.
2392  */
2393 abstract contract Ownable is Context {
2394     address private _owner;
2395 
2396     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2397 
2398     /**
2399      * @dev Initializes the contract setting the deployer as the initial owner.
2400      */
2401     constructor () internal {
2402         address msgSender = _msgSender();
2403         _owner = msgSender;
2404         emit OwnershipTransferred(address(0), msgSender);
2405     }
2406 
2407     /**
2408      * @dev Returns the address of the current owner.
2409      */
2410     function owner() public view virtual returns (address) {
2411         return _owner;
2412     }
2413 
2414     /**
2415      * @dev Throws if called by any account other than the owner.
2416      */
2417     modifier onlyOwner() {
2418         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2419         _;
2420     }
2421 
2422     /**
2423      * @dev Leaves the contract without owner. It will not be possible to call
2424      * `onlyOwner` functions anymore. Can only be called by the current owner.
2425      *
2426      * NOTE: Renouncing ownership will leave the contract without an owner,
2427      * thereby removing any functionality that is only available to the owner.
2428      */
2429     function renounceOwnership() public virtual onlyOwner {
2430         emit OwnershipTransferred(_owner, address(0));
2431         _owner = address(0);
2432     }
2433 
2434     /**
2435      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2436      * Can only be called by the current owner.
2437      */
2438     function transferOwnership(address newOwner) public virtual onlyOwner {
2439         require(newOwner != address(0), "Ownable: new owner is the zero address");
2440         emit OwnershipTransferred(_owner, newOwner);
2441         _owner = newOwner;
2442     }
2443 }
2444 
2445 // File: Sora.sol
2446 
2447 
2448 pragma solidity >=0.6.0 <0.8.0;
2449 pragma abicoder v2;
2450 
2451 // import "@chainlink/contracts@0.2.2/src/v0.7/vendor/SafeMathChainlink.sol";
2452 // import "@chainlink/contracts@0.2.2/src/v0.7/interfaces/LinkTokenInterface.sol";
2453 // import "@chainlink/contracts@0.2.2/src/v0.7/VRFRequestIDBase.sol";
2454 // import "@chainlink/contracts@0.2.2/src/v0.7/VRFConsumerBase.sol";
2455 
2456 // import "@openzeppelin/contracts@3.4.2/math/SafeMath.sol";
2457 // import "@openzeppelin/contracts@3.4.2/token/ERC721/ERC721.sol";
2458 // import "@openzeppelin/contracts@3.4.2/access/Ownable.sol";
2459 
2460 contract Sora is VRFConsumerBase, ERC721, Ownable {
2461     
2462     using SafeMath for uint256;
2463 
2464     uint public constant TOKEN_PRICE = 80000000000000000; // 0.08 ETH
2465 
2466     uint public constant MAX_TOKENS_PER_PUBLIC_MINT = 10; // Only applies during public sale.
2467 
2468     uint public constant MAX_TOKENS = 10000;
2469 
2470     uint public saleState = 0; // 0: closed, 1: presale, 2: public sale.
2471 
2472     mapping(uint => string) public tokenNames;
2473 
2474     mapping(address => uint) public presaleReservations;
2475 
2476     uint public numPreSaleReservations = 0;
2477 
2478     string public LICENSE = "https://www.nftlicense.org"; // The license text/url for every token.
2479 
2480     string public PROVENANCE = ""; // Link to a json of all the sha256 hashes of the tokens.
2481 
2482     uint public RNG_VRF_RESULT; // rng is seeded with sha256( base10(RNG_VRF_RESULT) + RNG_SEED_KEY )
2483 
2484     uint public RNG_SEED_KEY_HASH; // sha256(RNG_SEED_KEY)
2485 
2486     uint public RNG_CODE_HASH; // sha256(rng code's zip)
2487 
2488     string public RNG_SEED_KEY = ""; // revealed after all sale is over.
2489 
2490     string public RNG_CODE_URI = ""; // The place where you can download the rng code's zip.
2491 
2492     bytes32 internal vrfkeyHash;
2493 
2494     uint256 internal vrfFee;
2495 
2496     event TokenNameChanged(address _by, uint _tokenId, string _name);
2497 
2498     event LicenseChanged(string _license);
2499 
2500     event ProvenanceChanged(string _provenance);
2501 
2502     event RNGSeedRequested(uint _rngSeedKeyHash, uint _rngCodeHash, string _rngCodeURI);
2503 
2504     event RNGSeedFufilled(uint _vrfResult);
2505 
2506     event RNGCodeUriChanged(string _rngCodeURI);
2507 
2508     event RNGSeedKeyRevealed(string _rngSeedKey);
2509 
2510     event SaleClosed();
2511 
2512     event PreSaleOpened();
2513 
2514     event PublicSaleOpened();
2515 
2516     // See https://docs.chain.link/docs/vrf-contracts/ for the values you need.
2517     constructor() 
2518     ERC721("Sora's Dreamworld", "Sora") 
2519     VRFConsumerBase(
2520         0xf0d54349aDdcf704F77AE15b96510dEA15cb7952, // VRF Coordinator
2521         0x514910771AF9Ca656af840dff83E8264EcF986CA  // LINK Token
2522         )
2523     { 
2524         vrfkeyHash = 0xAA77729D3466CA35AE8D28B3BBAC7CC36A5031EFDC430821C02BC31A238AF445;
2525         vrfFee = 2 * 10 ** 18; // 2 LINK (Varies by network)
2526         
2527         _setBaseURI("https://sorasdreamworld.io/tokens/");
2528     }
2529 
2530     function getRngSeed(uint _rngSeedKeyHash, uint _rngCodeHash, string memory _rngCodeURI) public onlyOwner returns (bytes32 requestId) {
2531         require(RNG_VRF_RESULT == 0, "Already generated!");
2532         require(LINK.balanceOf(address(this)) >= vrfFee, "Not enough LINK.");
2533         
2534         RNG_SEED_KEY_HASH = _rngSeedKeyHash;
2535         RNG_CODE_HASH = _rngCodeHash;
2536         RNG_CODE_URI = _rngCodeURI;
2537         emit RNGSeedRequested(_rngSeedKeyHash, _rngCodeHash, _rngCodeURI);
2538         return requestRandomness(vrfkeyHash, vrfFee);
2539     }
2540 
2541     // Callback function used by VRF Coordinator
2542     function fulfillRandomness(bytes32 _requestId, uint256 _randomness) internal override {
2543         RNG_VRF_RESULT = _randomness;
2544         emit RNGSeedFufilled(_randomness);
2545     }
2546 
2547     // Reveal the RNG seed key.
2548     function setRNGSeedKey(string memory _rngSeedKey) public onlyOwner {
2549         RNG_SEED_KEY = _rngSeedKey;
2550         emit RNGSeedKeyRevealed(_rngSeedKey);
2551     }
2552 
2553     // Just incase we need to move the location of the code. 
2554     function setRNGCodeUri(string memory _rngCodeURI) public onlyOwner {
2555         RNG_CODE_URI = _rngCodeURI;
2556         emit RNGCodeUriChanged(_rngCodeURI);
2557     }
2558     
2559     // Withdraws Ether for the owner.    
2560     function withdraw() public onlyOwner {
2561         uint balance = address(this).balance;
2562         msg.sender.transfer(balance);
2563     }
2564 
2565     // Sets the provenance.
2566     function setProvenance(string memory _provenance) public onlyOwner {
2567         PROVENANCE = _provenance;
2568         emit ProvenanceChanged(_provenance);
2569     }
2570 
2571     // Sets base URI for all token IDs. 
2572     // e.g. https://sorasdreamworld.io/tokens/
2573     function setBaseURI(string memory _baseURI) public onlyOwner {
2574         _setBaseURI(_baseURI);
2575     }
2576 
2577     // Open the pre-sale. Only addresses with pre-sale reservations can mint.
2578     function openPreSale() public onlyOwner {
2579         saleState = 1;
2580         emit PreSaleOpened();
2581     }
2582 
2583     // Open the public sale. Any address can mint.
2584     function openPublicSale() public onlyOwner {
2585         saleState = 2;
2586         emit PublicSaleOpened();
2587     }
2588 
2589     // Close the sale.
2590     function closeSale() public onlyOwner {
2591         saleState = 0;
2592         emit SaleClosed();
2593     }
2594 
2595     // Force mint for the addresses. 
2596     // Can be called anytime.
2597     // If called right after the creation of the contract, the tokens 
2598     // are assigned sequentially starting from id 0. 
2599     function forceMint(address[] memory _addresses) public onlyOwner { 
2600         require(totalSupply().add(_addresses.length) <= MAX_TOKENS, "Not enough slots.");
2601         for (uint i = 0; i < _addresses.length; i++) {
2602             uint mintIndex = totalSupply();
2603             if (mintIndex < MAX_TOKENS) {
2604                 _safeMint(_addresses[i], mintIndex);
2605             }
2606         }
2607     }
2608     
2609     // Self mint for the owner. 
2610     // Can be called anytime.
2611     // This does not require the sale to be open.
2612     function selfMint(uint _numTokens) public onlyOwner { 
2613         require(totalSupply().add(_numTokens) <= MAX_TOKENS, "Not enough slots.");
2614         for (uint i = 0; i < _numTokens; i++) {
2615             uint mintIndex = totalSupply();
2616             if (mintIndex < MAX_TOKENS) {
2617                 _safeMint(msg.sender, mintIndex);
2618             }
2619         }
2620     }
2621 
2622     // Reserves pre-sale slots for the addresses.
2623     function reserveForPreSale(address[] memory _addresses, uint _numPerAddress) public onlyOwner {
2624         uint numNeeded = _numPerAddress.mul(_addresses.length);
2625         require(numPreSaleReservations.add(numNeeded) <= MAX_TOKENS, "Not enough slots.");
2626         
2627         for (uint i = 0; i < _addresses.length; i++) {
2628             presaleReservations[_addresses[i]] += _numPerAddress;
2629         }
2630         numPreSaleReservations += numNeeded;
2631     }
2632 
2633     // Remove all the pre-sale reservations for the addresses.
2634     function removePreSaleReservations(address[] memory _addresses) public onlyOwner {
2635         uint numRemoved = 0;
2636         for (uint i = 0; i < _addresses.length; i++) {
2637             numRemoved += presaleReservations[_addresses[i]];
2638             presaleReservations[_addresses[i]] = 0;
2639         }
2640         numPreSaleReservations -= numRemoved; 
2641     }
2642     
2643     // Returns an array of the token ids under the owner.
2644     function tokensOfOwner(address _owner) external view returns(uint[] memory) {
2645         uint tokenCount = balanceOf(_owner);
2646         if (tokenCount == 0) {
2647             return new uint[](0);
2648         } else {
2649             uint[] memory result = new uint[](tokenCount);
2650             for (uint index = 0; index < tokenCount; index++) {
2651                 result[index] = tokenOfOwnerByIndex(_owner, index);
2652             }
2653             return result;
2654         }
2655     }
2656     
2657     // Sets the license text.
2658     function setLicense(string memory _license) public onlyOwner {
2659         LICENSE = _license;
2660         emit LicenseChanged(_license);
2661     }
2662 
2663     // Returns the license for tokens.
2664     function tokenLicense(uint _id) public view returns(string memory) {
2665         require(_id < totalSupply(), "Token not found.");
2666         return LICENSE;
2667     }
2668     
2669     // Mints tokens.
2670     function mint(uint _numTokens) public payable {
2671         require(_numTokens > 0, "Minimum number to mint is 1.");
2672         require(saleState > 0, "Sale not open.");
2673         require(totalSupply().add(_numTokens) <= MAX_TOKENS, "Not enough slots.");
2674 
2675         // This line ensures the minter is paying at enough to cover the tokens.
2676         require(msg.value >= TOKEN_PRICE.mul(_numTokens), "Wrong Ether value.");
2677 
2678         if (saleState == 1) {
2679             require(presaleReservations[msg.sender] >= _numTokens, "Not enough presale slots.");
2680             presaleReservations[msg.sender] -= _numTokens;
2681         } else { // 2
2682             require(_numTokens <= MAX_TOKENS_PER_PUBLIC_MINT, "Tokens per mint exceeded.");
2683         }
2684         
2685         for (uint i = 0; i < _numTokens; i++) {
2686             uint mintIndex = totalSupply();
2687             if (mintIndex < MAX_TOKENS) {
2688                 _safeMint(msg.sender, mintIndex);
2689             }
2690         }
2691     }
2692     
2693     // Change the token name.
2694     function changeTokenName(uint _id, string memory _name) public {
2695         require(ownerOf(_id) == msg.sender, "You do not own this token.");
2696         require(sha256(bytes(_name)) != sha256(bytes(tokenNames[_id])), "Name unchanged.");
2697         tokenNames[_id] = _name;
2698         emit TokenNameChanged(msg.sender, _id, _name);
2699     }
2700     
2701     // Returns the token name.
2702     function viewTokenName(uint _id) public view returns (string memory) {
2703         require(_id < totalSupply(), "Token not found.");
2704         return tokenNames[_id];
2705     }
2706     
2707     // Returns an array of the token names under the owner.
2708     function tokenNamesOfOwner(address _owner) external view returns (string[] memory) {
2709         uint tokenCount = balanceOf(_owner);
2710         if (tokenCount == 0) {
2711             return new string[](0);
2712         } else {
2713             string[] memory result = new string[](tokenCount);
2714             for (uint index = 0; index < tokenCount; index++) {
2715                 result[index] = tokenNames[tokenOfOwnerByIndex(_owner, index)];
2716             }
2717             return result;
2718         }
2719     }
2720 }