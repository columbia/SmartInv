1 // SPDX-License-Identifier: MIT
2  
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/introspection/IERC165.sol
29 
30 
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Interface of the ERC165 standard, as defined in the
36  * https://eips.ethereum.org/EIPS/eip-165[EIP].
37  *
38  * Implementers can declare support of contract interfaces, which can then be
39  * queried by others ({ERC165Checker}).
40  *
41  * For an implementation, see {ERC165}.
42  */
43 interface IERC165 {
44     /**
45      * @dev Returns true if this contract implements the interface defined by
46      * `interfaceId`. See the corresponding
47      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
48      * to learn more about how these ids are created.
49      *
50      * This function call must use less than 30 000 gas.
51      */
52     function supportsInterface(bytes4 interfaceId) external view returns (bool);
53 }
54 
55 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
56 
57 
58 
59 pragma solidity >=0.6.2 <0.8.0;
60 
61 
62 /**
63  * @dev Required interface of an ERC721 compliant contract.
64  */
65 interface IERC721 is IERC165 {
66     /**
67      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
70 
71     /**
72      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
73      */
74     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
75 
76     /**
77      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
78      */
79     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
80 
81     /**
82      * @dev Returns the number of tokens in ``owner``'s account.
83      */
84     function balanceOf(address owner) external view returns (uint256 balance);
85 
86     /**
87      * @dev Returns the owner of the `tokenId` token.
88      *
89      * Requirements:
90      *
91      * - `tokenId` must exist.
92      */
93     function ownerOf(uint256 tokenId) external view returns (address owner);
94 
95     /**
96      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
97      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
98      *
99      * Requirements:
100      *
101      * - `from` cannot be the zero address.
102      * - `to` cannot be the zero address.
103      * - `tokenId` token must exist and be owned by `from`.
104      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
105      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
106      *
107      * Emits a {Transfer} event.
108      */
109     function safeTransferFrom(address from, address to, uint256 tokenId) external;
110 
111     /**
112      * @dev Transfers `tokenId` token from `from` to `to`.
113      *
114      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
115      *
116      * Requirements:
117      *
118      * - `from` cannot be the zero address.
119      * - `to` cannot be the zero address.
120      * - `tokenId` token must be owned by `from`.
121      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(address from, address to, uint256 tokenId) external;
126 
127     /**
128      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
129      * The approval is cleared when the token is transferred.
130      *
131      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
132      *
133      * Requirements:
134      *
135      * - The caller must own the token or be an approved operator.
136      * - `tokenId` must exist.
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address to, uint256 tokenId) external;
141 
142     /**
143      * @dev Returns the account approved for `tokenId` token.
144      *
145      * Requirements:
146      *
147      * - `tokenId` must exist.
148      */
149     function getApproved(uint256 tokenId) external view returns (address operator);
150 
151     /**
152      * @dev Approve or remove `operator` as an operator for the caller.
153      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
154      *
155      * Requirements:
156      *
157      * - The `operator` cannot be the caller.
158      *
159      * Emits an {ApprovalForAll} event.
160      */
161     function setApprovalForAll(address operator, bool _approved) external;
162 
163     /**
164      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
165      *
166      * See {setApprovalForAll}
167      */
168     function isApprovedForAll(address owner, address operator) external view returns (bool);
169 
170     /**
171       * @dev Safely transfers `tokenId` token from `from` to `to`.
172       *
173       * Requirements:
174       *
175       * - `from` cannot be the zero address.
176       * - `to` cannot be the zero address.
177       * - `tokenId` token must exist and be owned by `from`.
178       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
179       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
180       *
181       * Emits a {Transfer} event.
182       */
183     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
184 }
185 
186 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
187 
188 
189 
190 pragma solidity >=0.6.2 <0.8.0;
191 
192 
193 /**
194  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
195  * @dev See https://eips.ethereum.org/EIPS/eip-721
196  */
197 interface IERC721Metadata is IERC721 {
198 
199     /**
200      * @dev Returns the token collection name.
201      */
202     function name() external view returns (string memory);
203 
204     /**
205      * @dev Returns the token collection symbol.
206      */
207     function symbol() external view returns (string memory);
208 
209     /**
210      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
211      */
212     function tokenURI(uint256 tokenId) external view returns (string memory);
213 }
214 
215 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
216 
217 
218 
219 pragma solidity >=0.6.2 <0.8.0;
220 
221 
222 /**
223  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
224  * @dev See https://eips.ethereum.org/EIPS/eip-721
225  */
226 interface IERC721Enumerable is IERC721 {
227 
228     /**
229      * @dev Returns the total amount of tokens stored by the contract.
230      */
231     function totalSupply() external view returns (uint256);
232 
233     /**
234      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
235      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
236      */
237     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
238 
239     /**
240      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
241      * Use along with {totalSupply} to enumerate all tokens.
242      */
243     function tokenByIndex(uint256 index) external view returns (uint256);
244 }
245 
246 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
247 
248 
249 
250 pragma solidity >=0.6.0 <0.8.0;
251 
252 /**
253  * @title ERC721 token receiver interface
254  * @dev Interface for any contract that wants to support safeTransfers
255  * from ERC721 asset contracts.
256  */
257 interface IERC721Receiver {
258     /**
259      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
260      * by `operator` from `from`, this function is called.
261      *
262      * It must return its Solidity selector to confirm the token transfer.
263      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
264      *
265      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
266      */
267     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
268 }
269 
270 // File: @openzeppelin/contracts/introspection/ERC165.sol
271 
272 
273 
274 pragma solidity >=0.6.0 <0.8.0;
275 
276 
277 /**
278  * @dev Implementation of the {IERC165} interface.
279  *
280  * Contracts may inherit from this and call {_registerInterface} to declare
281  * their support of an interface.
282  */
283 abstract contract ERC165 is IERC165 {
284     /*
285      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
286      */
287     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
288 
289     /**
290      * @dev Mapping of interface ids to whether or not it's supported.
291      */
292     mapping(bytes4 => bool) private _supportedInterfaces;
293 
294     constructor ()  {
295         // Derived contracts need only register support for their own interfaces,
296         // we register support for ERC165 itself here
297         _registerInterface(_INTERFACE_ID_ERC165);
298     }
299 
300     /**
301      * @dev See {IERC165-supportsInterface}.
302      *
303      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
304      */
305     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
306         return _supportedInterfaces[interfaceId];
307     }
308 
309     /**
310      * @dev Registers the contract as an implementer of the interface defined by
311      * `interfaceId`. Support of the actual ERC165 interface is automatic and
312      * registering its interface id is not required.
313      *
314      * See {IERC165-supportsInterface}.
315      *
316      * Requirements:
317      *
318      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
319      */
320     function _registerInterface(bytes4 interfaceId) internal virtual {
321         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
322         _supportedInterfaces[interfaceId] = true;
323     }
324 }
325 
326 
327 // File: @openzeppelin/contracts/utils/Address.sol
328 
329 
330 
331 pragma solidity >=0.6.2 <0.8.0;
332 
333 /**
334  * @dev Collection of functions related to the address type
335  */
336 library Address {
337     /**
338      * @dev Returns true if `account` is a contract.
339      *
340      * [IMPORTANT]
341      * ====
342      * It is unsafe to assume that an address for which this function returns
343      * false is an externally-owned account (EOA) and not a contract.
344      *
345      * Among others, `isContract` will return false for the following
346      * types of addresses:
347      *
348      *  - an externally-owned account
349      *  - a contract in construction
350      *  - an address where a contract will be created
351      *  - an address where a contract lived, but was destroyed
352      * ====
353      */
354     function isContract(address account) internal view returns (bool) {
355         // This method relies on extcodesize, which returns 0 for contracts in
356         // construction, since the code is only stored at the end of the
357         // constructor execution.
358 
359         uint256 size;
360         // solhint-disable-next-line no-inline-assembly
361         assembly { size := extcodesize(account) }
362         return size > 0;
363     }
364 
365     /**
366      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
367      * `recipient`, forwarding all available gas and reverting on errors.
368      *
369      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
370      * of certain opcodes, possibly making contracts go over the 2300 gas limit
371      * imposed by `transfer`, making them unable to receive funds via
372      * `transfer`. {sendValue} removes this limitation.
373      *
374      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
375      *
376      * IMPORTANT: because control is transferred to `recipient`, care must be
377      * taken to not create reentrancy vulnerabilities. Consider using
378      * {ReentrancyGuard} or the
379      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
380      */
381     function sendValue(address payable recipient, uint256 amount) internal {
382         require(address(this).balance >= amount, "Address: insufficient balance");
383 
384         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
385         (bool success, ) = recipient.call{ value: amount }("");
386         require(success, "Address: unable to send value, recipient may have reverted");
387     }
388 
389     /**
390      * @dev Performs a Solidity function call using a low level `call`. A
391      * plain`call` is an unsafe replacement for a function call: use this
392      * function instead.
393      *
394      * If `target` reverts with a revert reason, it is bubbled up by this
395      * function (like regular Solidity function calls).
396      *
397      * Returns the raw returned data. To convert to the expected return value,
398      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
399      *
400      * Requirements:
401      *
402      * - `target` must be a contract.
403      * - calling `target` with `data` must not revert.
404      *
405      * _Available since v3.1._
406      */
407     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
408       return functionCall(target, data, "Address: low-level call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
413      * `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
418         return functionCallWithValue(target, data, 0, errorMessage);
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
423      * but also transferring `value` wei to `target`.
424      *
425      * Requirements:
426      *
427      * - the calling contract must have an ETH balance of at least `value`.
428      * - the called Solidity function must be `payable`.
429      *
430      * _Available since v3.1._
431      */
432     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
433         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
438      * with `errorMessage` as a fallback revert reason when `target` reverts.
439      *
440      * _Available since v3.1._
441      */
442     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
443         require(address(this).balance >= value, "Address: insufficient balance for call");
444         require(isContract(target), "Address: call to non-contract");
445 
446         // solhint-disable-next-line avoid-low-level-calls
447         (bool success, bytes memory returndata) = target.call{ value: value }(data);
448         return _verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
453      * but performing a static call.
454      *
455      * _Available since v3.3._
456      */
457     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
458         return functionStaticCall(target, data, "Address: low-level static call failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
463      * but performing a static call.
464      *
465      * _Available since v3.3._
466      */
467     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
468         require(isContract(target), "Address: static call to non-contract");
469 
470         // solhint-disable-next-line avoid-low-level-calls
471         (bool success, bytes memory returndata) = target.staticcall(data);
472         return _verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but performing a delegate call.
478      *
479      * _Available since v3.4._
480      */
481     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
482         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
487      * but performing a delegate call.
488      *
489      * _Available since v3.4._
490      */
491     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
492         require(isContract(target), "Address: delegate call to non-contract");
493 
494         // solhint-disable-next-line avoid-low-level-calls
495         (bool success, bytes memory returndata) = target.delegatecall(data);
496         return _verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
500         if (success) {
501             return returndata;
502         } else {
503             // Look for revert reason and bubble it up if present
504             if (returndata.length > 0) {
505                 // The easiest way to bubble the revert reason is using memory via assembly
506 
507                 // solhint-disable-next-line no-inline-assembly
508                 assembly {
509                     let returndata_size := mload(returndata)
510                     revert(add(32, returndata), returndata_size)
511                 }
512             } else {
513                 revert(errorMessage);
514             }
515         }
516     }
517 }
518 
519 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
520 
521 
522 
523 pragma solidity >=0.6.0 <0.8.0;
524 
525 /**
526  * @dev Library for managing
527  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
528  * types.
529  *
530  * Sets have the following properties:
531  *
532  * - Elements are added, removed, and checked for existence in constant time
533  * (O(1)).
534  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
535  *
536  * ```
537  * contract Example {
538  *     // Add the library methods
539  *     using EnumerableSet for EnumerableSet.AddressSet;
540  *
541  *     // Declare a set state variable
542  *     EnumerableSet.AddressSet private mySet;
543  * }
544  * ```
545  *
546  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
547  * and `uint256` (`UintSet`) are supported.
548  */
549 library EnumerableSet {
550     // To implement this library for multiple types with as little code
551     // repetition as possible, we write it in terms of a generic Set type with
552     // bytes32 values.
553     // The Set implementation uses private functions, and user-facing
554     // implementations (such as AddressSet) are just wrappers around the
555     // underlying Set.
556     // This means that we can only create new EnumerableSets for types that fit
557     // in bytes32.
558 
559     struct Set {
560         // Storage of set values
561         bytes32[] _values;
562 
563         // Position of the value in the `values` array, plus 1 because index 0
564         // means a value is not in the set.
565         mapping (bytes32 => uint256) _indexes;
566     }
567 
568     /**
569      * @dev Add a value to a set. O(1).
570      *
571      * Returns true if the value was added to the set, that is if it was not
572      * already present.
573      */
574     function _add(Set storage set, bytes32 value) private returns (bool) {
575         if (!_contains(set, value)) {
576             set._values.push(value);
577             // The value is stored at length-1, but we add 1 to all indexes
578             // and use 0 as a sentinel value
579             set._indexes[value] = set._values.length;
580             return true;
581         } else {
582             return false;
583         }
584     }
585 
586     /**
587      * @dev Removes a value from a set. O(1).
588      *
589      * Returns true if the value was removed from the set, that is if it was
590      * present.
591      */
592     function _remove(Set storage set, bytes32 value) private returns (bool) {
593         // We read and store the value's index to prevent multiple reads from the same storage slot
594         uint256 valueIndex = set._indexes[value];
595 
596         if (valueIndex != 0) { // Equivalent to contains(set, value)
597             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
598             // the array, and then remove the last element (sometimes called as 'swap and pop').
599             // This modifies the order of the array, as noted in {at}.
600 
601             uint256 toDeleteIndex = valueIndex - 1;
602             uint256 lastIndex = set._values.length - 1;
603 
604             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
605             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
606 
607             bytes32 lastvalue = set._values[lastIndex];
608 
609             // Move the last value to the index where the value to delete is
610             set._values[toDeleteIndex] = lastvalue;
611             // Update the index for the moved value
612             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
613 
614             // Delete the slot where the moved value was stored
615             set._values.pop();
616 
617             // Delete the index for the deleted slot
618             delete set._indexes[value];
619 
620             return true;
621         } else {
622             return false;
623         }
624     }
625 
626     /**
627      * @dev Returns true if the value is in the set. O(1).
628      */
629     function _contains(Set storage set, bytes32 value) private view returns (bool) {
630         return set._indexes[value] != 0;
631     }
632 
633     /**
634      * @dev Returns the number of values on the set. O(1).
635      */
636     function _length(Set storage set) private view returns (uint256) {
637         return set._values.length;
638     }
639 
640    /**
641     * @dev Returns the value stored at position `index` in the set. O(1).
642     *
643     * Note that there are no guarantees on the ordering of values inside the
644     * array, and it may change when more values are added or removed.
645     *
646     * Requirements:
647     *
648     * - `index` must be strictly less than {length}.
649     */
650     function _at(Set storage set, uint256 index) private view returns (bytes32) {
651         require(set._values.length > index, "EnumerableSet: index out of bounds");
652         return set._values[index];
653     }
654 
655     // Bytes32Set
656 
657     struct Bytes32Set {
658         Set _inner;
659     }
660 
661     /**
662      * @dev Add a value to a set. O(1).
663      *
664      * Returns true if the value was added to the set, that is if it was not
665      * already present.
666      */
667     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
668         return _add(set._inner, value);
669     }
670 
671     /**
672      * @dev Removes a value from a set. O(1).
673      *
674      * Returns true if the value was removed from the set, that is if it was
675      * present.
676      */
677     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
678         return _remove(set._inner, value);
679     }
680 
681     /**
682      * @dev Returns true if the value is in the set. O(1).
683      */
684     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
685         return _contains(set._inner, value);
686     }
687 
688     /**
689      * @dev Returns the number of values in the set. O(1).
690      */
691     function length(Bytes32Set storage set) internal view returns (uint256) {
692         return _length(set._inner);
693     }
694 
695    /**
696     * @dev Returns the value stored at position `index` in the set. O(1).
697     *
698     * Note that there are no guarantees on the ordering of values inside the
699     * array, and it may change when more values are added or removed.
700     *
701     * Requirements:
702     *
703     * - `index` must be strictly less than {length}.
704     */
705     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
706         return _at(set._inner, index);
707     }
708 
709     // AddressSet
710 
711     struct AddressSet {
712         Set _inner;
713     }
714 
715     /**
716      * @dev Add a value to a set. O(1).
717      *
718      * Returns true if the value was added to the set, that is if it was not
719      * already present.
720      */
721     function add(AddressSet storage set, address value) internal returns (bool) {
722         return _add(set._inner, bytes32(uint256(uint160(value))));
723     }
724 
725     /**
726      * @dev Removes a value from a set. O(1).
727      *
728      * Returns true if the value was removed from the set, that is if it was
729      * present.
730      */
731     function remove(AddressSet storage set, address value) internal returns (bool) {
732         return _remove(set._inner, bytes32(uint256(uint160(value))));
733     }
734 
735     /**
736      * @dev Returns true if the value is in the set. O(1).
737      */
738     function contains(AddressSet storage set, address value) internal view returns (bool) {
739         return _contains(set._inner, bytes32(uint256(uint160(value))));
740     }
741 
742     /**
743      * @dev Returns the number of values in the set. O(1).
744      */
745     function length(AddressSet storage set) internal view returns (uint256) {
746         return _length(set._inner);
747     }
748 
749    /**
750     * @dev Returns the value stored at position `index` in the set. O(1).
751     *
752     * Note that there are no guarantees on the ordering of values inside the
753     * array, and it may change when more values are added or removed.
754     *
755     * Requirements:
756     *
757     * - `index` must be strictly less than {length}.
758     */
759     function at(AddressSet storage set, uint256 index) internal view returns (address) {
760         return address(uint160(uint256(_at(set._inner, index))));
761     }
762 
763 
764     // UintSet
765 
766     struct UintSet {
767         Set _inner;
768     }
769 
770     /**
771      * @dev Add a value to a set. O(1).
772      *
773      * Returns true if the value was added to the set, that is if it was not
774      * already present.
775      */
776     function add(UintSet storage set, uint256 value) internal returns (bool) {
777         return _add(set._inner, bytes32(value));
778     }
779 
780     /**
781      * @dev Removes a value from a set. O(1).
782      *
783      * Returns true if the value was removed from the set, that is if it was
784      * present.
785      */
786     function remove(UintSet storage set, uint256 value) internal returns (bool) {
787         return _remove(set._inner, bytes32(value));
788     }
789 
790     /**
791      * @dev Returns true if the value is in the set. O(1).
792      */
793     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
794         return _contains(set._inner, bytes32(value));
795     }
796 
797     /**
798      * @dev Returns the number of values on the set. O(1).
799      */
800     function length(UintSet storage set) internal view returns (uint256) {
801         return _length(set._inner);
802     }
803 
804    /**
805     * @dev Returns the value stored at position `index` in the set. O(1).
806     *
807     * Note that there are no guarantees on the ordering of values inside the
808     * array, and it may change when more values are added or removed.
809     *
810     * Requirements:
811     *
812     * - `index` must be strictly less than {length}.
813     */
814     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
815         return uint256(_at(set._inner, index));
816     }
817 }
818 
819 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
820 
821 
822 
823 pragma solidity >=0.6.0 <0.8.0;
824 
825 /**
826  * @dev Library for managing an enumerable variant of Solidity's
827  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
828  * type.
829  *
830  * Maps have the following properties:
831  *
832  * - Entries are added, removed, and checked for existence in constant time
833  * (O(1)).
834  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
835  *
836  * ```
837  * contract Example {
838  *     // Add the library methods
839  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
840  *
841  *     // Declare a set state variable
842  *     EnumerableMap.UintToAddressMap private myMap;
843  * }
844  * ```
845  *
846  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
847  * supported.
848  */
849 library EnumerableMap {
850     // To implement this library for multiple types with as little code
851     // repetition as possible, we write it in terms of a generic Map type with
852     // bytes32 keys and values.
853     // The Map implementation uses private functions, and user-facing
854     // implementations (such as Uint256ToAddressMap) are just wrappers around
855     // the underlying Map.
856     // This means that we can only create new EnumerableMaps for types that fit
857     // in bytes32.
858 
859     struct MapEntry {
860         bytes32 _key;
861         bytes32 _value;
862     }
863 
864     struct Map {
865         // Storage of map keys and values
866         MapEntry[] _entries;
867 
868         // Position of the entry defined by a key in the `entries` array, plus 1
869         // because index 0 means a key is not in the map.
870         mapping (bytes32 => uint256) _indexes;
871     }
872 
873     /**
874      * @dev Adds a key-value pair to a map, or updates the value for an existing
875      * key. O(1).
876      *
877      * Returns true if the key was added to the map, that is if it was not
878      * already present.
879      */
880     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
881         // We read and store the key's index to prevent multiple reads from the same storage slot
882         uint256 keyIndex = map._indexes[key];
883 
884         if (keyIndex == 0) { // Equivalent to !contains(map, key)
885             map._entries.push(MapEntry({ _key: key, _value: value }));
886             // The entry is stored at length-1, but we add 1 to all indexes
887             // and use 0 as a sentinel value
888             map._indexes[key] = map._entries.length;
889             return true;
890         } else {
891             map._entries[keyIndex - 1]._value = value;
892             return false;
893         }
894     }
895 
896     /**
897      * @dev Removes a key-value pair from a map. O(1).
898      *
899      * Returns true if the key was removed from the map, that is if it was present.
900      */
901     function _remove(Map storage map, bytes32 key) private returns (bool) {
902         // We read and store the key's index to prevent multiple reads from the same storage slot
903         uint256 keyIndex = map._indexes[key];
904 
905         if (keyIndex != 0) { // Equivalent to contains(map, key)
906             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
907             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
908             // This modifies the order of the array, as noted in {at}.
909 
910             uint256 toDeleteIndex = keyIndex - 1;
911             uint256 lastIndex = map._entries.length - 1;
912 
913             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
914             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
915 
916             MapEntry storage lastEntry = map._entries[lastIndex];
917 
918             // Move the last entry to the index where the entry to delete is
919             map._entries[toDeleteIndex] = lastEntry;
920             // Update the index for the moved entry
921             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
922 
923             // Delete the slot where the moved entry was stored
924             map._entries.pop();
925 
926             // Delete the index for the deleted slot
927             delete map._indexes[key];
928 
929             return true;
930         } else {
931             return false;
932         }
933     }
934 
935     /**
936      * @dev Returns true if the key is in the map. O(1).
937      */
938     function _contains(Map storage map, bytes32 key) private view returns (bool) {
939         return map._indexes[key] != 0;
940     }
941 
942     /**
943      * @dev Returns the number of key-value pairs in the map. O(1).
944      */
945     function _length(Map storage map) private view returns (uint256) {
946         return map._entries.length;
947     }
948 
949    /**
950     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
951     *
952     * Note that there are no guarantees on the ordering of entries inside the
953     * array, and it may change when more entries are added or removed.
954     *
955     * Requirements:
956     *
957     * - `index` must be strictly less than {length}.
958     */
959     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
960         require(map._entries.length > index, "EnumerableMap: index out of bounds");
961 
962         MapEntry storage entry = map._entries[index];
963         return (entry._key, entry._value);
964     }
965 
966     /**
967      * @dev Tries to returns the value associated with `key`.  O(1).
968      * Does not revert if `key` is not in the map.
969      */
970     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
971         uint256 keyIndex = map._indexes[key];
972         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
973         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
974     }
975 
976     /**
977      * @dev Returns the value associated with `key`.  O(1).
978      *
979      * Requirements:
980      *
981      * - `key` must be in the map.
982      */
983     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
984         uint256 keyIndex = map._indexes[key];
985         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
986         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
987     }
988 
989     /**
990      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
991      *
992      * CAUTION: This function is deprecated because it requires allocating memory for the error
993      * message unnecessarily. For custom revert reasons use {_tryGet}.
994      */
995     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
996         uint256 keyIndex = map._indexes[key];
997         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
998         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
999     }
1000 
1001     // UintToAddressMap
1002 
1003     struct UintToAddressMap {
1004         Map _inner;
1005     }
1006 
1007     /**
1008      * @dev Adds a key-value pair to a map, or updates the value for an existing
1009      * key. O(1).
1010      *
1011      * Returns true if the key was added to the map, that is if it was not
1012      * already present.
1013      */
1014     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1015         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1016     }
1017 
1018     /**
1019      * @dev Removes a value from a set. O(1).
1020      *
1021      * Returns true if the key was removed from the map, that is if it was present.
1022      */
1023     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1024         return _remove(map._inner, bytes32(key));
1025     }
1026 
1027     /**
1028      * @dev Returns true if the key is in the map. O(1).
1029      */
1030     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1031         return _contains(map._inner, bytes32(key));
1032     }
1033 
1034     /**
1035      * @dev Returns the number of elements in the map. O(1).
1036      */
1037     function length(UintToAddressMap storage map) internal view returns (uint256) {
1038         return _length(map._inner);
1039     }
1040 
1041    /**
1042     * @dev Returns the element stored at position `index` in the set. O(1).
1043     * Note that there are no guarantees on the ordering of values inside the
1044     * array, and it may change when more values are added or removed.
1045     *
1046     * Requirements:
1047     *
1048     * - `index` must be strictly less than {length}.
1049     */
1050     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1051         (bytes32 key, bytes32 value) = _at(map._inner, index);
1052         return (uint256(key), address(uint160(uint256(value))));
1053     }
1054 
1055     /**
1056      * @dev Tries to returns the value associated with `key`.  O(1).
1057      * Does not revert if `key` is not in the map.
1058      *
1059      * _Available since v3.4._
1060      */
1061     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1062         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1063         return (success, address(uint160(uint256(value))));
1064     }
1065 
1066     /**
1067      * @dev Returns the value associated with `key`.  O(1).
1068      *
1069      * Requirements:
1070      *
1071      * - `key` must be in the map.
1072      */
1073     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1074         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1075     }
1076 
1077     /**
1078      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1079      *
1080      * CAUTION: This function is deprecated because it requires allocating memory for the error
1081      * message unnecessarily. For custom revert reasons use {tryGet}.
1082      */
1083     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1084         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1085     }
1086 }
1087 
1088 // File: @openzeppelin/contracts/utils/Strings.sol
1089 
1090 
1091 
1092 pragma solidity >=0.6.0 <0.8.0;
1093 
1094 /**
1095  * @dev String operations.
1096  */
1097 library Strings {
1098     /**
1099      * @dev Converts a `uint256` to its ASCII `string` representation.
1100      */
1101     function toString(uint256 value) internal pure returns (string memory) {
1102         // Inspired by OraclizeAPI's implementation - MIT licence
1103         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1104 
1105         if (value == 0) {
1106             return "0";
1107         }
1108         uint256 temp = value;
1109         uint256 digits;
1110         while (temp != 0) {
1111             digits++;
1112             temp /= 10;
1113         }
1114         bytes memory buffer = new bytes(digits);
1115         uint256 index = digits - 1;
1116         temp = value;
1117         while (temp != 0) {
1118             buffer[index--] = bytes1(uint8(48 + temp % 10));
1119             temp /= 10;
1120         }
1121         return string(buffer);
1122     }
1123 }
1124 
1125 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1126 
1127 
1128 
1129 pragma solidity >=0.6.0 <0.8.0;
1130 
1131 /**
1132  * @title ERC721 Non-Fungible Token Standard basic implementation
1133  * @dev see https://eips.ethereum.org/EIPS/eip-721
1134  */
1135  
1136 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1137     using Address for address;
1138     using EnumerableSet for EnumerableSet.UintSet;
1139     using EnumerableMap for EnumerableMap.UintToAddressMap;
1140     using Strings for uint256;
1141 
1142     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1143     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1144     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1145 
1146     // Mapping from holder address to their (enumerable) set of owned tokens
1147     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1148 
1149     // Enumerable mapping from token ids to their owners
1150     EnumerableMap.UintToAddressMap private _tokenOwners;
1151 
1152     // Mapping from token ID to approved address
1153     mapping (uint256 => address) private _tokenApprovals;
1154 
1155     // Mapping from owner to operator approvals
1156     mapping (address => mapping (address => bool)) private _operatorApprovals;
1157 
1158     // Token name
1159     string private _name;
1160 
1161     // Token symbol
1162     string private _symbol;
1163 
1164     // Optional mapping for token URIs
1165     mapping (uint256 => string) private _tokenURIs;
1166 
1167     // Base URI
1168     string private _baseURI;
1169 
1170     /*
1171      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1172      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1173      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1174      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1175      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1176      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1177      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1178      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1179      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1180      *
1181      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1182      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1183      */
1184     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1185 
1186     /*
1187      *     bytes4(keccak256('name()')) == 0x06fdde03
1188      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1189      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1190      *
1191      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1192      */
1193     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1194 
1195     /*
1196      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1197      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1198      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1199      *
1200      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1201      */
1202     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1203 
1204     /**
1205      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1206      */
1207     constructor (string memory name_, string memory symbol_) {
1208         _name = name_;
1209         _symbol = symbol_;
1210 
1211         // register the supported interfaces to conform to ERC721 via ERC165
1212         _registerInterface(_INTERFACE_ID_ERC721);
1213         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1214         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1215     }
1216 
1217     /**
1218      * @dev See {IERC721-balanceOf}.
1219      */
1220     function balanceOf(address owner) public view virtual override returns (uint256) {
1221         require(owner != address(0), "ERC721: balance query for the zero address");
1222         return _holderTokens[owner].length();
1223     }
1224 
1225     /**
1226      * @dev See {IERC721-ownerOf}.
1227      */
1228     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1229         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1230     }
1231 
1232     /**
1233      * @dev See {IERC721Metadata-name}.
1234      */
1235     function name() public view virtual override returns (string memory) {
1236         return _name;
1237     }
1238 
1239     /**
1240      * @dev See {IERC721Metadata-symbol}.
1241      */
1242     function symbol() public view virtual override returns (string memory) {
1243         return _symbol;
1244     }
1245 
1246     /**
1247      * @dev See {IERC721Metadata-tokenURI}.
1248      */
1249     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1250         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1251 
1252         string memory _tokenURI = _tokenURIs[tokenId];
1253         string memory base = baseURI();
1254 
1255         // If there is no base URI, return the token URI.
1256         if (bytes(base).length == 0) {
1257             return _tokenURI;
1258         }
1259         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1260         if (bytes(_tokenURI).length > 0) {
1261             return string(abi.encodePacked(base, _tokenURI));
1262         }
1263         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1264         return string(abi.encodePacked(base, tokenId.toString()));
1265     }
1266 
1267     /**
1268     * @dev Returns the base URI set via {_setBaseURI}. This will be
1269     * automatically added as a prefix in {tokenURI} to each token's URI, or
1270     * to the token ID if no specific URI is set for that token ID.
1271     */
1272     function baseURI() public view virtual returns (string memory) {
1273         return _baseURI;
1274     }
1275 
1276     /**
1277      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1278      */
1279     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1280         return _holderTokens[owner].at(index);
1281     }
1282 
1283     /**
1284      * @dev See {IERC721Enumerable-totalSupply}.
1285      */
1286     function totalSupply() public view virtual override returns (uint256) {
1287         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1288         return _tokenOwners.length();
1289     }
1290 
1291     /**
1292      * @dev See {IERC721Enumerable-tokenByIndex}.
1293      */
1294     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1295         (uint256 tokenId, ) = _tokenOwners.at(index);
1296         return tokenId;
1297     }
1298 
1299     /**
1300      * @dev See {IERC721-approve}.
1301      */
1302     function approve(address to, uint256 tokenId) public virtual override {
1303         address owner = ERC721.ownerOf(tokenId);
1304         require(to != owner, "ERC721: approval to current owner");
1305 
1306         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1307             "ERC721: approve caller is not owner nor approved for all"
1308         );
1309 
1310         _approve(to, tokenId);
1311     }
1312 
1313     /**
1314      * @dev See {IERC721-getApproved}.
1315      */
1316     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1317         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1318 
1319         return _tokenApprovals[tokenId];
1320     }
1321 
1322     /**
1323      * @dev See {IERC721-setApprovalForAll}.
1324      */
1325     function setApprovalForAll(address operator, bool approved) public virtual override {
1326         require(operator != _msgSender(), "ERC721: approve to caller");
1327 
1328         _operatorApprovals[_msgSender()][operator] = approved;
1329         emit ApprovalForAll(_msgSender(), operator, approved);
1330     }
1331 
1332     /**
1333      * @dev See {IERC721-isApprovedForAll}.
1334      */
1335     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1336         return _operatorApprovals[owner][operator];
1337     }
1338 
1339     /**
1340      * @dev See {IERC721-transferFrom}.
1341      */
1342     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1343         //solhint-disable-next-line max-line-length
1344         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1345 
1346         _transfer(from, to, tokenId);
1347     }
1348 
1349     /**
1350      * @dev See {IERC721-safeTransferFrom}.
1351      */
1352     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1353         safeTransferFrom(from, to, tokenId, "");
1354     }
1355 
1356     /**
1357      * @dev See {IERC721-safeTransferFrom}.
1358      */
1359     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1360         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1361         _safeTransfer(from, to, tokenId, _data);
1362     }
1363 
1364     /**
1365      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1366      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1367      *
1368      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1369      *
1370      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1371      * implement alternative mechanisms to perform token transfer, such as signature-based.
1372      *
1373      * Requirements:
1374      *
1375      * - `from` cannot be the zero address.
1376      * - `to` cannot be the zero address.
1377      * - `tokenId` token must exist and be owned by `from`.
1378      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1379      *
1380      * Emits a {Transfer} event.
1381      */
1382     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1383         _transfer(from, to, tokenId);
1384         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1385     }
1386 
1387     /**
1388      * @dev Returns whether `tokenId` exists.
1389      *
1390      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1391      *
1392      * Tokens start existing when they are minted (`_mint`),
1393      * and stop existing when they are burned (`_burn`).
1394      */
1395     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1396         return _tokenOwners.contains(tokenId);
1397     }
1398 
1399     /**
1400      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1401      *
1402      * Requirements:
1403      *
1404      * - `tokenId` must exist.
1405      */
1406     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1407         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1408         address owner = ERC721.ownerOf(tokenId);
1409         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1410     }
1411 
1412     /**
1413      * @dev Safely mints `tokenId` and transfers it to `to`.
1414      *
1415      * Requirements:
1416      d*
1417      * - `tokenId` must not exist.
1418      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1419      *
1420      * Emits a {Transfer} event.
1421      */
1422     function _safeMint(address to, uint256 tokenId) internal virtual {
1423         _safeMint(to, tokenId, "");
1424     }
1425 
1426     /**
1427      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1428      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1429      */
1430     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1431         _mint(to, tokenId);
1432         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1433     }
1434 
1435     /**
1436      * @dev Mints `tokenId` and transfers it to `to`.
1437      *
1438      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1439      *
1440      * Requirements:
1441      *
1442      * - `tokenId` must not exist.
1443      * - `to` cannot be the zero address.
1444      *
1445      * Emits a {Transfer} event.
1446      */
1447     function _mint(address to, uint256 tokenId) internal virtual {
1448         require(to != address(0), "ERC721: mint to the zero address");
1449         require(!_exists(tokenId), "ERC721: token already minted");
1450 
1451         _beforeTokenTransfer(address(0), to, tokenId);
1452 
1453         _holderTokens[to].add(tokenId);
1454 
1455         _tokenOwners.set(tokenId, to);
1456 
1457         emit Transfer(address(0), to, tokenId);
1458     }
1459 
1460     /**
1461      * @dev Destroys `tokenId`.
1462      * The approval is cleared when the token is burned.
1463      *
1464      * Requirements:
1465      *
1466      * - `tokenId` must exist.
1467      *
1468      * Emits a {Transfer} event.
1469      */
1470     function _burn(uint256 tokenId) internal virtual {
1471         address owner = ERC721.ownerOf(tokenId); // internal owner
1472 
1473         _beforeTokenTransfer(owner, address(0), tokenId);
1474 
1475         // Clear approvals
1476         _approve(address(0), tokenId);
1477 
1478         // Clear metadata (if any)
1479         if (bytes(_tokenURIs[tokenId]).length != 0) {
1480             delete _tokenURIs[tokenId];
1481         }
1482 
1483         _holderTokens[owner].remove(tokenId);
1484 
1485         _tokenOwners.remove(tokenId);
1486 
1487         emit Transfer(owner, address(0), tokenId);
1488     }
1489 
1490     /**
1491      * @dev Transfers `tokenId` from `from` to `to`.
1492      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1493      *
1494      * Requirements:
1495      *
1496      * - `to` cannot be the zero address.
1497      * - `tokenId` token must be owned by `from`.
1498      *
1499      * Emits a {Transfer} event.
1500      */
1501     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1502         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1503         require(to != address(0), "ERC721: transfer to the zero address");
1504 
1505         _beforeTokenTransfer(from, to, tokenId);
1506 
1507         // Clear approvals from the previous owner
1508         _approve(address(0), tokenId);
1509 
1510         _holderTokens[from].remove(tokenId);
1511         _holderTokens[to].add(tokenId);
1512 
1513         _tokenOwners.set(tokenId, to);
1514 
1515         emit Transfer(from, to, tokenId);
1516     }
1517 
1518     /**
1519      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1520      *
1521      * Requirements:
1522      *
1523      * - `tokenId` must exist.
1524      */
1525     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1526         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1527         _tokenURIs[tokenId] = _tokenURI;
1528     }
1529 
1530     /**
1531      * @dev Internal function to set the base URI for all token IDs. It is
1532      * automatically added as a prefix to the value returned in {tokenURI},
1533      * or to the token ID if {tokenURI} is empty.
1534      */
1535     function _setBaseURI(string memory baseURI_) internal virtual {
1536         _baseURI = baseURI_;
1537     }
1538 
1539     /**
1540      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1541      * The call is not executed if the target address is not a contract.
1542      *
1543      * @param from address representing the previous owner of the given token ID
1544      * @param to target address that will receive the tokens
1545      * @param tokenId uint256 ID of the token to be transferred
1546      * @param _data bytes optional data to send along with the call
1547      * @return bool whether the call correctly returned the expected magic value
1548      */
1549     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1550         private returns (bool)
1551     {
1552         if (!to.isContract()) {
1553             return true;
1554         }
1555         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1556             IERC721Receiver(to).onERC721Received.selector,
1557             _msgSender(),
1558             from,
1559             tokenId,
1560             _data
1561         ), "ERC721: transfer to non ERC721Receiver implementer");
1562         bytes4 retval = abi.decode(returndata, (bytes4));
1563         return (retval == _ERC721_RECEIVED);
1564     }
1565 
1566     /**
1567      * @dev Approve `to` to operate on `tokenId`
1568      *
1569      * Emits an {Approval} event.
1570      */
1571     function _approve(address to, uint256 tokenId) internal virtual {
1572         _tokenApprovals[tokenId] = to;
1573         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1574     }
1575 
1576     /**
1577      * @dev Hook that is called before any token transfer. This includes minting
1578      * and burning.
1579      *
1580      * Calling conditions:
1581      *
1582      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1583      * transferred to `to`.
1584      * - When `from` is zero, `tokenId` will be minted for `to`.
1585      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1586      * - `from` cannot be the zero address.
1587      * - `to` cannot be the zero address.
1588      *
1589      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1590      */
1591     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1592 }
1593 
1594 // File: @openzeppelin/contracts/access/Ownable.sol
1595 
1596 
1597 
1598 pragma solidity >=0.6.0 <0.8.0;
1599 
1600 /**
1601  * @dev Contract module which provides a basic access control mechanism, where
1602  * there is an account (an owner) that can be granted exclusive access to
1603  * specific functions.
1604  *
1605  * By default, the owner account will be the one that deploys the contract. This
1606  * can later be changed with {transferOwnership}.
1607  *
1608  * This module is used through inheritance. It will make available the modifier
1609  * `onlyOwner`, which can be applied to your functions to restrict their use to
1610  * the owner.
1611  */
1612 abstract contract Ownable is Context {
1613     address private _owner;
1614 
1615     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1616 
1617     /**
1618      * @dev Initializes the contract setting the deployer as the initial owner.
1619      */
1620     constructor ()  {
1621         address msgSender = _msgSender();
1622         _owner = msgSender;
1623         emit OwnershipTransferred(address(0), msgSender);
1624     }
1625 
1626     /**
1627      * @dev Returns the address of the current owner.
1628      */
1629     function owner() public view virtual returns (address) {
1630         return _owner;
1631     }
1632 
1633     /**
1634      * @dev Throws if called by any account other than the owner.
1635      */
1636     modifier onlyOwner() {
1637         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1638         _;
1639     }
1640 
1641     /**
1642      * @dev Leaves the contract without owner. It will not be possible to call
1643      * `onlyOwner` functions anymore. Can only be called by the current owner.
1644      *
1645      * NOTE: Renouncing ownership will leave the contract without an owner,
1646      * thereby removing any functionality that is only available to the owner.
1647      */
1648     function renounceOwnership() public virtual onlyOwner {
1649         emit OwnershipTransferred(_owner, address(0));
1650         _owner = address(0);
1651     }
1652 
1653     /**
1654      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1655      * Can only be called by the current owner.
1656      */
1657     function transferOwnership(address newOwner) public virtual onlyOwner {
1658         require(newOwner != address(0), "Ownable: new owner is the zero address");
1659         emit OwnershipTransferred(_owner, newOwner);
1660         _owner = newOwner;
1661     }
1662 }
1663 
1664 pragma solidity ^0.7.0;
1665 pragma abicoder v2;
1666 
1667 contract Djeenies is ERC721, Ownable {
1668 
1669     uint256 public constant MAX_TOKENS = 7777;
1670     uint256 public price = 60 * 10**15; // .06 presale .07 normal
1671     uint public reserve = 200;
1672     bool public isSaleActive = false;
1673     bool public burningEnabled = false;
1674     bool public isClaimActive = false;
1675     mapping(address => bool) private _claimList;
1676     mapping(address => uint256) private _claimListClaimed;
1677     mapping(address => uint256) private _claimable;
1678 
1679     address public constant w1 = 0xc2E3941a6c2B8dbee57CDd9AFC4D5f359F1677a5;
1680     address public constant w2 = 0x80D6364C875b68b5A1e83e5d6dde7Ad9b12b62B6;
1681 
1682     constructor() ERC721("Djeenies", "DJN") payable {}
1683     
1684     function reserveTokens(address _to, uint256 _reserveAmount) public onlyOwner {        
1685         uint supply = totalSupply();
1686         for (uint i = 0; i < _reserveAmount; i++) {
1687             _safeMint(_to, supply + i);
1688         }
1689         reserve = reserve - _reserveAmount;
1690     }
1691     
1692     function mintDjeenies(uint256 _count) public payable {
1693         uint256 totalSupply = totalSupply();
1694 
1695         require(isSaleActive, "Sale is not active" );
1696         require(totalSupply + _count < MAX_TOKENS + 1, "Exceeds available djeenies");
1697         require(msg.value >= price * _count, "Ether value sent is not correct");
1698         
1699         for(uint256 i = 0; i < _count; i++){
1700                 _safeMint(msg.sender, totalSupply + i);
1701         }
1702     }
1703 
1704     function claim(uint256 _count) public {
1705         require(isClaimActive, "Presale is not open");
1706         require(_claimList[msg.sender], "You are not in claimList");
1707         require(_count <= _claimable[msg.sender], "Incorrect amount to claim");
1708         require(_claimListClaimed[msg.sender] + _count <= _claimable[msg.sender], "Purchase exceeds max allowed");
1709         uint256 total = totalSupply();
1710         require(total + _count <= MAX_TOKENS, "Not enough left to mint");
1711 
1712         for (uint256 i = 0; i < _count; i++) {
1713             _claimListClaimed[msg.sender] += 1;
1714             _safeMint(msg.sender, total + i);
1715         }
1716     }
1717 
1718     function burn(uint256 tokenId) public virtual {
1719         require(burningEnabled, "burning is not yet enabled");
1720         require(_isApprovedOrOwner(_msgSender(), tokenId), "caller is not owner nor approved");
1721         super._burn(tokenId);
1722     }
1723 
1724     function addToClaimList(address[] calldata addresses, uint[] calldata _numberToClaim ) external onlyOwner {
1725         for (uint256 i = 0; i < addresses.length; i++) {
1726             require(addresses[i] != address(0), "Null address found");
1727 
1728             _claimList[addresses[i]] = true;
1729             _claimable[addresses[i]] = _numberToClaim[i];
1730             _claimListClaimed[addresses[i]] > 0 ? _claimListClaimed[addresses[i]] : 0;
1731         }
1732     }
1733 
1734     function addressInClaimlist(address addr) external view returns (bool) {
1735         return _claimList[addr];
1736     }
1737 
1738     function removeFromClaimList(address[] calldata addresses) external onlyOwner {
1739         for (uint256 i = 0; i < addresses.length; i++) {
1740             _claimList[addresses[i]] = false;
1741         }
1742     }
1743 
1744     function setPrice(uint256 _price) external onlyOwner{
1745         price = _price;
1746     }
1747 
1748     function setBaseURI(string memory _baseURI) external onlyOwner {
1749         _setBaseURI(_baseURI);
1750     }
1751 
1752     function flipClaimStatus() external onlyOwner {
1753         isClaimActive = !isClaimActive;
1754     }
1755 
1756     function flipSaleStatus() external onlyOwner {
1757         isSaleActive = !isSaleActive;
1758     }
1759 
1760     function toggleBurningEnabled() external onlyOwner {
1761         burningEnabled = !burningEnabled;
1762     }
1763 
1764     function withdrawAll() external onlyOwner {
1765         uint256 balance = address(this).balance;
1766         require(balance > 0);
1767         uint256 withdrawal = (balance * 95) / 100;
1768         _withdraw(w1, withdrawal);
1769         _withdraw(w2, address(this).balance);
1770     }
1771 
1772     function _withdraw(address _address, uint256 _amount) internal {
1773         payable(_address).transfer(_amount);
1774     }
1775 
1776     
1777     function tokensByOwner(address _owner) external view returns(uint256[] memory ) {
1778         uint256 tokenCount = balanceOf(_owner);
1779         if (tokenCount == 0) {
1780             return new uint256[](0);
1781         } else {
1782             uint256[] memory result = new uint256[](tokenCount);
1783             uint256 index;
1784             for (index = 0; index < tokenCount; index++) {
1785                 result[index] = tokenOfOwnerByIndex(_owner, index);
1786             }
1787             return result;
1788         }
1789     }
1790 }