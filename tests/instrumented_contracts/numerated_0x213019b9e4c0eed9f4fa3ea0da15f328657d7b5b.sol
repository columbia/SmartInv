1 // SPDX-License-Identifier: MIT
2 // ERC721A Contracts v3.3.0
3 // Creator: Chiru Labs
4 
5 pragma solidity ^0.8.14;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 /**
29  * @dev Required interface of an ERC721 compliant contract.
30  */
31 interface IERC721 is IERC165 {
32     /**
33      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
34      */
35     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
36 
37     /**
38      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
39      */
40     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
44      */
45     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
46 
47     /**
48      * @dev Returns the number of tokens in ``owner``'s account.
49      */
50     function balanceOf(address owner) external view returns (uint256 balance);
51 
52     /**
53      * @dev Returns the owner of the `tokenId` token.
54      *
55      * Requirements:
56      *
57      * - `tokenId` must exist.
58      */
59     function ownerOf(uint256 tokenId) external view returns (address owner);
60 
61     /**
62      * @dev Safely transfers `tokenId` token from `from` to `to`.
63      *
64      * Requirements:
65      *
66      * - `from` cannot be the zero address.
67      * - `to` cannot be the zero address.
68      * - `tokenId` token must exist and be owned by `from`.
69      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
70      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
71      *
72      * Emits a {Transfer} event.
73      */
74     function safeTransferFrom(
75         address from,
76         address to,
77         uint256 tokenId,
78         bytes calldata data
79     ) external;
80 
81     /**
82      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
83      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must exist and be owned by `from`.
90      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
91      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
92      *
93      * Emits a {Transfer} event.
94      */
95     function safeTransferFrom(
96         address from,
97         address to,
98         uint256 tokenId
99     ) external;
100 
101     /**
102      * @dev Transfers `tokenId` token from `from` to `to`.
103      *
104      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
105      *
106      * Requirements:
107      *
108      * - `from` cannot be the zero address.
109      * - `to` cannot be the zero address.
110      * - `tokenId` token must be owned by `from`.
111      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transferFrom(
116         address from,
117         address to,
118         uint256 tokenId
119     ) external;
120 
121     /**
122      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
123      * The approval is cleared when the token is transferred.
124      *
125      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
126      *
127      * Requirements:
128      *
129      * - The caller must own the token or be an approved operator.
130      * - `tokenId` must exist.
131      *
132      * Emits an {Approval} event.
133      */
134     function approve(address to, uint256 tokenId) external;
135 
136     /**
137      * @dev Approve or remove `operator` as an operator for the caller.
138      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
139      *
140      * Requirements:
141      *
142      * - The `operator` cannot be the caller.
143      *
144      * Emits an {ApprovalForAll} event.
145      */
146     function setApprovalForAll(address operator, bool _approved) external;
147 
148     /**
149      * @dev Returns the account approved for `tokenId` token.
150      *
151      * Requirements:
152      *
153      * - `tokenId` must exist.
154      */
155     function getApproved(uint256 tokenId) external view returns (address operator);
156 
157     /**
158      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
159      *
160      * See {setApprovalForAll}
161      */
162     function isApprovedForAll(address owner, address operator) external view returns (bool);
163 }
164 
165 /**
166  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
167  * @dev See https://eips.ethereum.org/EIPS/eip-721
168  */
169 interface IERC721Metadata is IERC721 {
170     /**
171      * @dev Returns the token collection name.
172      */
173     function name() external view returns (string memory);
174 
175     /**
176      * @dev Returns the token collection symbol.
177      */
178     function symbol() external view returns (string memory);
179 
180     /**
181      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
182      */
183     function tokenURI(uint256 tokenId) external view returns (string memory);
184 }
185 
186 /**
187  * @dev Interface of an ERC721A compliant contract.
188  */
189 interface IERC721A is IERC721, IERC721Metadata {
190     /**
191      * The caller must own the token or be an approved operator.
192      */
193     error ApprovalCallerNotOwnerNorApproved();
194 
195     /**
196      * The token does not exist.
197      */
198     error ApprovalQueryForNonexistentToken();
199 
200     /**
201      * The caller cannot approve to their own address.
202      */
203     error ApproveToCaller();
204 
205     /**
206      * The caller cannot approve to the current owner.
207      */
208     error ApprovalToCurrentOwner();
209 
210     /**
211      * Cannot query the balance for the zero address.
212      */
213     error BalanceQueryForZeroAddress();
214 
215     /**
216      * Cannot mint to the zero address.
217      */
218     error MintToZeroAddress();
219 
220     /**
221      * The quantity of tokens minted must be more than zero.
222      */
223     error MintZeroQuantity();
224 
225     /**
226      * The token does not exist.
227      */
228     error OwnerQueryForNonexistentToken();
229 
230     /**
231      * The caller must own the token or be an approved operator.
232      */
233     error TransferCallerNotOwnerNorApproved();
234 
235     /**
236      * The token must be owned by `from`.
237      */
238     error TransferFromIncorrectOwner();
239 
240     /**
241      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
242      */
243     error TransferToNonERC721ReceiverImplementer();
244 
245     /**
246      * Cannot transfer to the zero address.
247      */
248     error TransferToZeroAddress();
249 
250     /**
251      * The token does not exist.
252      */
253     error URIQueryForNonexistentToken();
254 
255     // Compiler will pack this into a single 256bit word.
256     struct TokenOwnership {
257         // The address of the owner.
258         address addr;
259         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
260         uint64 startTimestamp;
261         // Whether the token has been burned.
262         bool burned;
263     }
264 
265     // Compiler will pack this into a single 256bit word.
266     struct AddressData {
267         // Realistically, 2**64-1 is more than enough.
268         uint64 balance;
269         // Keeps track of mint count with minimal overhead for tokenomics.
270         uint64 numberMinted;
271         // Keeps track of burn count with minimal overhead for tokenomics.
272         uint64 numberBurned;
273         // For miscellaneous variable(s) pertaining to the address
274         // (e.g. number of whitelist mint slots used).
275         // If there are multiple variables, please pack them into a uint64.
276         uint64 aux;
277     }
278 
279     /**
280      * @dev Returns the total amount of tokens stored by the contract.
281      *
282      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
283      */
284     function totalSupply() external view returns (uint256);
285 }
286 
287 /**
288  * @title ERC721 token receiver interface
289  * @dev Interface for any contract that wants to support safeTransfers
290  * from ERC721 asset contracts.
291  */
292 interface IERC721Receiver {
293     /**
294      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
295      * by `operator` from `from`, this function is called.
296      *
297      * It must return its Solidity selector to confirm the token transfer.
298      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
299      *
300      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
301      */
302     function onERC721Received(
303         address operator,
304         address from,
305         uint256 tokenId,
306         bytes calldata data
307     ) external returns (bytes4);
308 }
309 
310 /**
311  * @dev Collection of functions related to the address type
312  */
313 library Address {
314     /**
315      * @dev Returns true if `account` is a contract.
316      *
317      * [IMPORTANT]
318      * ====
319      * It is unsafe to assume that an address for which this function returns
320      * false is an externally-owned account (EOA) and not a contract.
321      *
322      * Among others, `isContract` will return false for the following
323      * types of addresses:
324      *
325      *  - an externally-owned account
326      *  - a contract in construction
327      *  - an address where a contract will be created
328      *  - an address where a contract lived, but was destroyed
329      * ====
330      *
331      * [IMPORTANT]
332      * ====
333      * You shouldn't rely on `isContract` to protect against flash loan attacks!
334      *
335      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
336      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
337      * constructor.
338      * ====
339      */
340     function isContract(address account) internal view returns (bool) {
341         // This method relies on extcodesize/address.code.length, which returns 0
342         // for contracts in construction, since the code is only stored at the end
343         // of the constructor execution.
344 
345         return account.code.length > 0;
346     }
347 
348     /**
349      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
350      * `recipient`, forwarding all available gas and reverting on errors.
351      *
352      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
353      * of certain opcodes, possibly making contracts go over the 2300 gas limit
354      * imposed by `transfer`, making them unable to receive funds via
355      * `transfer`. {sendValue} removes this limitation.
356      *
357      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
358      *
359      * IMPORTANT: because control is transferred to `recipient`, care must be
360      * taken to not create reentrancy vulnerabilities. Consider using
361      * {ReentrancyGuard} or the
362      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
363      */
364     function sendValue(address payable recipient, uint256 amount) internal {
365         require(address(this).balance >= amount, "Address: insufficient balance");
366 
367         (bool success, ) = recipient.call{value: amount}("");
368         require(success, "Address: unable to send value, recipient may have reverted");
369     }
370 
371     /**
372      * @dev Performs a Solidity function call using a low level `call`. A
373      * plain `call` is an unsafe replacement for a function call: use this
374      * function instead.
375      *
376      * If `target` reverts with a revert reason, it is bubbled up by this
377      * function (like regular Solidity function calls).
378      *
379      * Returns the raw returned data. To convert to the expected return value,
380      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
381      *
382      * Requirements:
383      *
384      * - `target` must be a contract.
385      * - calling `target` with `data` must not revert.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
390         return functionCall(target, data, "Address: low-level call failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
395      * `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCall(
400         address target,
401         bytes memory data,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, 0, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but also transferring `value` wei to `target`.
410      *
411      * Requirements:
412      *
413      * - the calling contract must have an ETH balance of at least `value`.
414      * - the called Solidity function must be `payable`.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value
422     ) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
428      * with `errorMessage` as a fallback revert reason when `target` reverts.
429      *
430      * _Available since v3.1._
431      */
432     function functionCallWithValue(
433         address target,
434         bytes memory data,
435         uint256 value,
436         string memory errorMessage
437     ) internal returns (bytes memory) {
438         require(address(this).balance >= value, "Address: insufficient balance for call");
439         require(isContract(target), "Address: call to non-contract");
440 
441         (bool success, bytes memory returndata) = target.call{value: value}(data);
442         return verifyCallResult(success, returndata, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but performing a static call.
448      *
449      * _Available since v3.3._
450      */
451     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
452         return functionStaticCall(target, data, "Address: low-level static call failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
457      * but performing a static call.
458      *
459      * _Available since v3.3._
460      */
461     function functionStaticCall(
462         address target,
463         bytes memory data,
464         string memory errorMessage
465     ) internal view returns (bytes memory) {
466         require(isContract(target), "Address: static call to non-contract");
467 
468         (bool success, bytes memory returndata) = target.staticcall(data);
469         return verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but performing a delegate call.
475      *
476      * _Available since v3.4._
477      */
478     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
479         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
484      * but performing a delegate call.
485      *
486      * _Available since v3.4._
487      */
488     function functionDelegateCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         require(isContract(target), "Address: delegate call to non-contract");
494 
495         (bool success, bytes memory returndata) = target.delegatecall(data);
496         return verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     /**
500      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
501      * revert reason using the provided one.
502      *
503      * _Available since v4.3._
504      */
505     function verifyCallResult(
506         bool success,
507         bytes memory returndata,
508         string memory errorMessage
509     ) internal pure returns (bytes memory) {
510         if (success) {
511             return returndata;
512         } else {
513             // Look for revert reason and bubble it up if present
514             if (returndata.length > 0) {
515                 // The easiest way to bubble the revert reason is using memory via assembly
516 
517                 assembly {
518                     let returndata_size := mload(returndata)
519                     revert(add(32, returndata), returndata_size)
520                 }
521             } else {
522                 revert(errorMessage);
523             }
524         }
525     }
526 }
527 
528 /**
529  * @dev Provides information about the current execution context, including the
530  * sender of the transaction and its data. While these are generally available
531  * via msg.sender and msg.data, they should not be accessed in such a direct
532  * manner, since when dealing with meta-transactions the account sending and
533  * paying for execution may not be the actual sender (as far as an application
534  * is concerned).
535  *
536  * This contract is only required for intermediate, library-like contracts.
537  */
538 abstract contract Context {
539     function _msgSender() internal view virtual returns (address) {
540         return msg.sender;
541     }
542 
543     function _msgData() internal view virtual returns (bytes calldata) {
544         return msg.data;
545     }
546 }
547 
548 /**
549  * @dev String operations.
550  */
551 library Strings {
552     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
553 
554     /**
555      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
556      */
557     function toString(uint256 value) internal pure returns (string memory) {
558         // Inspired by OraclizeAPI's implementation - MIT licence
559         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
560 
561         if (value == 0) {
562             return "0";
563         }
564         uint256 temp = value;
565         uint256 digits;
566         while (temp != 0) {
567             digits++;
568             temp /= 10;
569         }
570         bytes memory buffer = new bytes(digits);
571         while (value != 0) {
572             digits -= 1;
573             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
574             value /= 10;
575         }
576         return string(buffer);
577     }
578 
579     /**
580      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
581      */
582     function toHexString(uint256 value) internal pure returns (string memory) {
583         if (value == 0) {
584             return "0x00";
585         }
586         uint256 temp = value;
587         uint256 length = 0;
588         while (temp != 0) {
589             length++;
590             temp >>= 8;
591         }
592         return toHexString(value, length);
593     }
594 
595     /**
596      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
597      */
598     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
599         bytes memory buffer = new bytes(2 * length + 2);
600         buffer[0] = "0";
601         buffer[1] = "x";
602         for (uint256 i = 2 * length + 1; i > 1; --i) {
603             buffer[i] = _HEX_SYMBOLS[value & 0xf];
604             value >>= 4;
605         }
606         require(value == 0, "Strings: hex length insufficient");
607         return string(buffer);
608     }
609 }
610 
611 /**
612  * @dev Implementation of the {IERC165} interface.
613  *
614  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
615  * for the additional interface id that will be supported. For example:
616  *
617  * ```solidity
618  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
619  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
620  * }
621  * ```
622  *
623  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
624  */
625 abstract contract ERC165 is IERC165 {
626     /**
627      * @dev See {IERC165-supportsInterface}.
628      */
629     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
630         return interfaceId == type(IERC165).interfaceId;
631     }
632 }
633 
634 /**
635  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
636  * the Metadata extension. Built to optimize for lower gas during batch mints.
637  *
638  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
639  *
640  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
641  *
642  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
643  */
644 contract ERC721A is Context, ERC165, IERC721A {
645     using Address for address;
646     using Strings for uint256;
647 
648     // The tokenId of the next token to be minted.
649     uint256 internal _currentIndex;
650 
651     // The number of tokens burned.
652     uint256 internal _burnCounter;
653 
654     // Token name
655     string private _name;
656 
657     // Token symbol
658     string private _symbol;
659 
660     // Mapping from token ID to ownership details
661     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
662     mapping(uint256 => TokenOwnership) internal _ownerships;
663 
664     // Mapping owner address to address data
665     mapping(address => AddressData) private _addressData;
666 
667     // Mapping from token ID to approved address
668     mapping(uint256 => address) private _tokenApprovals;
669 
670     // Mapping from owner to operator approvals
671     mapping(address => mapping(address => bool)) private _operatorApprovals;
672 
673     constructor(string memory name_, string memory symbol_) {
674         _name = name_;
675         _symbol = symbol_;
676         _currentIndex = _startTokenId();
677     }
678 
679     /**
680      * To change the starting tokenId, please override this function.
681      */
682     function _startTokenId() internal view virtual returns (uint256) {
683         return 0;
684     }
685 
686     /**
687      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
688      */
689     function totalSupply() public override view returns (uint256) {
690         // Counter underflow is impossible as _burnCounter cannot be incremented
691         // more than _currentIndex - _startTokenId() times
692     unchecked {
693         return _currentIndex - _burnCounter - _startTokenId();
694     }
695     }
696 
697     /**
698      * Returns the total amount of tokens minted in the contract.
699      */
700     function _totalMinted() internal view returns (uint256) {
701         // Counter underflow is impossible as _currentIndex does not decrement,
702         // and it is initialized to _startTokenId()
703     unchecked {
704         return _currentIndex - _startTokenId();
705     }
706     }
707 
708     /**
709      * @dev See {IERC165-supportsInterface}.
710      */
711     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
712         return
713         interfaceId == type(IERC721).interfaceId ||
714         interfaceId == type(IERC721Metadata).interfaceId ||
715         super.supportsInterface(interfaceId);
716     }
717 
718     /**
719      * @dev See {IERC721-balanceOf}.
720      */
721     function balanceOf(address owner) public view override returns (uint256) {
722         if (owner == address(0)) revert BalanceQueryForZeroAddress();
723         return uint256(_addressData[owner].balance);
724     }
725 
726     /**
727      * Returns the number of tokens minted by `owner`.
728      */
729     function _numberMinted(address owner) internal view returns (uint256) {
730         return uint256(_addressData[owner].numberMinted);
731     }
732 
733     /**
734      * Returns the number of tokens burned by or on behalf of `owner`.
735      */
736     function _numberBurned(address owner) internal view returns (uint256) {
737         return uint256(_addressData[owner].numberBurned);
738     }
739 
740     /**
741      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
742      */
743     function _getAux(address owner) internal view returns (uint64) {
744         return _addressData[owner].aux;
745     }
746 
747     /**
748      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
749      * If there are multiple variables, please pack them into a uint64.
750      */
751     function _setAux(address owner, uint64 aux) internal {
752         _addressData[owner].aux = aux;
753     }
754 
755     /**
756      * Gas spent here starts off proportional to the maximum mint batch size.
757      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
758      */
759     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
760         uint256 curr = tokenId;
761 
762     unchecked {
763         if (_startTokenId() <= curr) if (curr < _currentIndex) {
764             TokenOwnership memory ownership = _ownerships[curr];
765             if (!ownership.burned) {
766                 if (ownership.addr != address(0)) {
767                     return ownership;
768                 }
769                 // Invariant:
770                 // There will always be an ownership that has an address and is not burned
771                 // before an ownership that does not have an address and is not burned.
772                 // Hence, curr will not underflow.
773                 while (true) {
774                     curr--;
775                     ownership = _ownerships[curr];
776                     if (ownership.addr != address(0)) {
777                         return ownership;
778                     }
779                 }
780             }
781         }
782     }
783         revert OwnerQueryForNonexistentToken();
784     }
785 
786     /**
787      * @dev See {IERC721-ownerOf}.
788      */
789     function ownerOf(uint256 tokenId) public view override returns (address) {
790         return _ownershipOf(tokenId).addr;
791     }
792 
793     /**
794      * @dev See {IERC721Metadata-name}.
795      */
796     function name() public view virtual override returns (string memory) {
797         return _name;
798     }
799 
800     /**
801      * @dev See {IERC721Metadata-symbol}.
802      */
803     function symbol() public view virtual override returns (string memory) {
804         return _symbol;
805     }
806 
807     /**
808      * @dev See {IERC721Metadata-tokenURI}.
809      */
810     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
811         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
812 
813         string memory baseURI = _baseURI();
814         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
815     }
816 
817     /**
818      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
819      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
820      * by default, can be overriden in child contracts.
821      */
822     function _baseURI() internal view virtual returns (string memory) {
823         return '';
824     }
825 
826     /**
827      * @dev See {IERC721-approve}.
828      */
829     function approve(address to, uint256 tokenId) public override {
830         address owner = ERC721A.ownerOf(tokenId);
831         if (to == owner) revert ApprovalToCurrentOwner();
832 
833         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
834             revert ApprovalCallerNotOwnerNorApproved();
835         }
836 
837         _tokenApprovals[tokenId] = to;
838         emit Approval(owner, to, tokenId);
839     }
840 
841     /**
842      * @dev See {IERC721-getApproved}.
843      */
844     function getApproved(uint256 tokenId) public view override returns (address) {
845         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
846 
847         return _tokenApprovals[tokenId];
848     }
849 
850     /**
851      * @dev See {IERC721-setApprovalForAll}.
852      */
853     function setApprovalForAll(address operator, bool approved) public virtual override {
854         if (operator == _msgSender()) revert ApproveToCaller();
855 
856         _operatorApprovals[_msgSender()][operator] = approved;
857         emit ApprovalForAll(_msgSender(), operator, approved);
858     }
859 
860     /**
861      * @dev See {IERC721-isApprovedForAll}.
862      */
863     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
864         return _operatorApprovals[owner][operator];
865     }
866 
867     /**
868      * @dev See {IERC721-transferFrom}.
869      */
870     function transferFrom(
871         address from,
872         address to,
873         uint256 tokenId
874     ) public virtual override {
875         _transfer(from, to, tokenId);
876     }
877 
878     /**
879      * @dev See {IERC721-safeTransferFrom}.
880      */
881     function safeTransferFrom(
882         address from,
883         address to,
884         uint256 tokenId
885     ) public virtual override {
886         safeTransferFrom(from, to, tokenId, '');
887     }
888 
889     /**
890      * @dev See {IERC721-safeTransferFrom}.
891      */
892     function safeTransferFrom(
893         address from,
894         address to,
895         uint256 tokenId,
896         bytes memory _data
897     ) public virtual override {
898         _transfer(from, to, tokenId);
899         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
900             revert TransferToNonERC721ReceiverImplementer();
901         }
902     }
903 
904     /**
905      * @dev Returns whether `tokenId` exists.
906      *
907      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
908      *
909      * Tokens start existing when they are minted (`_mint`),
910      */
911     function _exists(uint256 tokenId) internal view returns (bool) {
912         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
913     }
914 
915     /**
916      * @dev Equivalent to `_safeMint(to, quantity, '')`.
917      */
918     function _safeMint(address to, uint256 quantity) internal {
919         _safeMint(to, quantity, '');
920     }
921 
922     /**
923      * @dev Safely mints `quantity` tokens and transfers them to `to`.
924      *
925      * Requirements:
926      *
927      * - If `to` refers to a smart contract, it must implement
928      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
929      * - `quantity` must be greater than 0.
930      *
931      * Emits a {Transfer} event.
932      */
933     function _safeMint(
934         address to,
935         uint256 quantity,
936         bytes memory _data
937     ) internal {
938         uint256 startTokenId = _currentIndex;
939         if (to == address(0)) revert MintToZeroAddress();
940         if (quantity == 0) revert MintZeroQuantity();
941 
942         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
943 
944         // Overflows are incredibly unrealistic.
945         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
946         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
947     unchecked {
948         _addressData[to].balance += uint64(quantity);
949         _addressData[to].numberMinted += uint64(quantity);
950 
951         _ownerships[startTokenId].addr = to;
952         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
953 
954         uint256 updatedIndex = startTokenId;
955         uint256 end = updatedIndex + quantity;
956 
957         if (to.isContract()) {
958             do {
959                 emit Transfer(address(0), to, updatedIndex);
960                 if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
961                     revert TransferToNonERC721ReceiverImplementer();
962                 }
963             } while (updatedIndex < end);
964             // Reentrancy protection
965             if (_currentIndex != startTokenId) revert();
966         } else {
967             do {
968                 emit Transfer(address(0), to, updatedIndex++);
969             } while (updatedIndex < end);
970         }
971         _currentIndex = updatedIndex;
972     }
973         _afterTokenTransfers(address(0), to, startTokenId, quantity);
974     }
975 
976     /**
977      * @dev Mints `quantity` tokens and transfers them to `to`.
978      *
979      * Requirements:
980      *
981      * - `to` cannot be the zero address.
982      * - `quantity` must be greater than 0.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _mint(address to, uint256 quantity) internal {
987         uint256 startTokenId = _currentIndex;
988         if (to == address(0)) revert MintToZeroAddress();
989         if (quantity == 0) revert MintZeroQuantity();
990 
991         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
992 
993         // Overflows are incredibly unrealistic.
994         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
995         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
996     unchecked {
997         _addressData[to].balance += uint64(quantity);
998         _addressData[to].numberMinted += uint64(quantity);
999 
1000         _ownerships[startTokenId].addr = to;
1001         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1002 
1003         uint256 updatedIndex = startTokenId;
1004         uint256 end = updatedIndex + quantity;
1005 
1006         do {
1007             emit Transfer(address(0), to, updatedIndex++);
1008         } while (updatedIndex < end);
1009 
1010         _currentIndex = updatedIndex;
1011     }
1012         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1013     }
1014 
1015     /**
1016      * @dev Transfers `tokenId` from `from` to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - `to` cannot be the zero address.
1021      * - `tokenId` token must be owned by `from`.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _transfer(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) private {
1030         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1031 
1032         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1033 
1034         bool isApprovedOrOwner = (_msgSender() == from ||
1035         isApprovedForAll(from, _msgSender()) ||
1036         getApproved(tokenId) == _msgSender());
1037 
1038         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1039         if (to == address(0)) revert TransferToZeroAddress();
1040 
1041         _beforeTokenTransfers(from, to, tokenId, 1);
1042 
1043         // Clear approvals from the previous owner.
1044         delete _tokenApprovals[tokenId];
1045 
1046         // Underflow of the sender's balance is impossible because we check for
1047         // ownership above and the recipient's balance can't realistically overflow.
1048         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1049     unchecked {
1050         _addressData[from].balance -= 1;
1051         _addressData[to].balance += 1;
1052 
1053         TokenOwnership storage currSlot = _ownerships[tokenId];
1054         currSlot.addr = to;
1055         currSlot.startTimestamp = uint64(block.timestamp);
1056 
1057         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1058         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1059         uint256 nextTokenId = tokenId + 1;
1060         TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1061         if (nextSlot.addr == address(0)) {
1062             // This will suffice for checking _exists(nextTokenId),
1063             // as a burned slot cannot contain the zero address.
1064             if (nextTokenId != _currentIndex) {
1065                 nextSlot.addr = from;
1066                 nextSlot.startTimestamp = prevOwnership.startTimestamp;
1067             }
1068         }
1069     }
1070 
1071         emit Transfer(from, to, tokenId);
1072         _afterTokenTransfers(from, to, tokenId, 1);
1073     }
1074 
1075     /**
1076      * @dev Equivalent to `_burn(tokenId, false)`.
1077      */
1078     function _burn(uint256 tokenId) internal virtual {
1079         _burn(tokenId, false);
1080     }
1081 
1082     /**
1083      * @dev Destroys `tokenId`.
1084      * The approval is cleared when the token is burned.
1085      *
1086      * Requirements:
1087      *
1088      * - `tokenId` must exist.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1093         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1094 
1095         address from = prevOwnership.addr;
1096 
1097         if (approvalCheck) {
1098             bool isApprovedOrOwner = (_msgSender() == from ||
1099             isApprovedForAll(from, _msgSender()) ||
1100             getApproved(tokenId) == _msgSender());
1101 
1102             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1103         }
1104 
1105         _beforeTokenTransfers(from, address(0), tokenId, 1);
1106 
1107         // Clear approvals from the previous owner.
1108         delete _tokenApprovals[tokenId];
1109 
1110         // Underflow of the sender's balance is impossible because we check for
1111         // ownership above and the recipient's balance can't realistically overflow.
1112         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1113     unchecked {
1114         AddressData storage addressData = _addressData[from];
1115         addressData.balance -= 1;
1116         addressData.numberBurned += 1;
1117 
1118         // Keep track of who burned the token, and the timestamp of burning.
1119         TokenOwnership storage currSlot = _ownerships[tokenId];
1120         currSlot.addr = from;
1121         currSlot.startTimestamp = uint64(block.timestamp);
1122         currSlot.burned = true;
1123 
1124         // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1125         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1126         uint256 nextTokenId = tokenId + 1;
1127         TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1128         if (nextSlot.addr == address(0)) {
1129             // This will suffice for checking _exists(nextTokenId),
1130             // as a burned slot cannot contain the zero address.
1131             if (nextTokenId != _currentIndex) {
1132                 nextSlot.addr = from;
1133                 nextSlot.startTimestamp = prevOwnership.startTimestamp;
1134             }
1135         }
1136     }
1137 
1138         emit Transfer(from, address(0), tokenId);
1139         _afterTokenTransfers(from, address(0), tokenId, 1);
1140 
1141         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1142     unchecked {
1143         _burnCounter++;
1144     }
1145     }
1146 
1147     /**
1148      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1149      *
1150      * @param from address representing the previous owner of the given token ID
1151      * @param to target address that will receive the tokens
1152      * @param tokenId uint256 ID of the token to be transferred
1153      * @param _data bytes optional data to send along with the call
1154      * @return bool whether the call correctly returned the expected magic value
1155      */
1156     function _checkContractOnERC721Received(
1157         address from,
1158         address to,
1159         uint256 tokenId,
1160         bytes memory _data
1161     ) private returns (bool) {
1162         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1163             return retval == IERC721Receiver(to).onERC721Received.selector;
1164         } catch (bytes memory reason) {
1165             if (reason.length == 0) {
1166                 revert TransferToNonERC721ReceiverImplementer();
1167             } else {
1168                 assembly {
1169                     revert(add(32, reason), mload(reason))
1170                 }
1171             }
1172         }
1173     }
1174 
1175     /**
1176      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1177      * And also called before burning one token.
1178      *
1179      * startTokenId - the first token id to be transferred
1180      * quantity - the amount to be transferred
1181      *
1182      * Calling conditions:
1183      *
1184      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1185      * transferred to `to`.
1186      * - When `from` is zero, `tokenId` will be minted for `to`.
1187      * - When `to` is zero, `tokenId` will be burned by `from`.
1188      * - `from` and `to` are never both zero.
1189      */
1190     function _beforeTokenTransfers(
1191         address from,
1192         address to,
1193         uint256 startTokenId,
1194         uint256 quantity
1195     ) internal virtual {}
1196 
1197     /**
1198      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1199      * minting.
1200      * And also called after one token has been burned.
1201      *
1202      * startTokenId - the first token id to be transferred
1203      * quantity - the amount to be transferred
1204      *
1205      * Calling conditions:
1206      *
1207      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1208      * transferred to `to`.
1209      * - When `from` is zero, `tokenId` has been minted for `to`.
1210      * - When `to` is zero, `tokenId` has been burned by `from`.
1211      * - `from` and `to` are never both zero.
1212      */
1213     function _afterTokenTransfers(
1214         address from,
1215         address to,
1216         uint256 startTokenId,
1217         uint256 quantity
1218     ) internal virtual {}
1219 }
1220 
1221 abstract contract ContextMixin {
1222     function msgSender()
1223     internal
1224     view
1225     returns (address payable sender)
1226     {
1227         if (msg.sender == address(this)) {
1228             bytes memory array = msg.data;
1229             uint256 index = msg.data.length;
1230             assembly {
1231             // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1232                 sender := and(
1233                 mload(add(array, index)),
1234                 0xffffffffffffffffffffffffffffffffffffffff
1235                 )
1236             }
1237         } else {
1238             sender = payable(msg.sender);
1239         }
1240         return sender;
1241     }
1242 }
1243 
1244 /**
1245  * @dev Wrappers over Solidity's arithmetic operations.
1246  *
1247  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1248  * now has built in overflow checking.
1249  */
1250 library SafeMath {
1251     /**
1252      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1253      *
1254      * _Available since v3.4._
1255      */
1256     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1257     unchecked {
1258         uint256 c = a + b;
1259         if (c < a) return (false, 0);
1260         return (true, c);
1261     }
1262     }
1263 
1264     /**
1265      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1266      *
1267      * _Available since v3.4._
1268      */
1269     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1270     unchecked {
1271         if (b > a) return (false, 0);
1272         return (true, a - b);
1273     }
1274     }
1275 
1276     /**
1277      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1278      *
1279      * _Available since v3.4._
1280      */
1281     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1282     unchecked {
1283         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1284         // benefit is lost if 'b' is also tested.
1285         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1286         if (a == 0) return (true, 0);
1287         uint256 c = a * b;
1288         if (c / a != b) return (false, 0);
1289         return (true, c);
1290     }
1291     }
1292 
1293     /**
1294      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1295      *
1296      * _Available since v3.4._
1297      */
1298     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1299     unchecked {
1300         if (b == 0) return (false, 0);
1301         return (true, a / b);
1302     }
1303     }
1304 
1305     /**
1306      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1307      *
1308      * _Available since v3.4._
1309      */
1310     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1311     unchecked {
1312         if (b == 0) return (false, 0);
1313         return (true, a % b);
1314     }
1315     }
1316 
1317     /**
1318      * @dev Returns the addition of two unsigned integers, reverting on
1319      * overflow.
1320      *
1321      * Counterpart to Solidity's `+` operator.
1322      *
1323      * Requirements:
1324      *
1325      * - Addition cannot overflow.
1326      */
1327     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1328         return a + b;
1329     }
1330 
1331     /**
1332      * @dev Returns the subtraction of two unsigned integers, reverting on
1333      * overflow (when the result is negative).
1334      *
1335      * Counterpart to Solidity's `-` operator.
1336      *
1337      * Requirements:
1338      *
1339      * - Subtraction cannot overflow.
1340      */
1341     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1342         return a - b;
1343     }
1344 
1345     /**
1346      * @dev Returns the multiplication of two unsigned integers, reverting on
1347      * overflow.
1348      *
1349      * Counterpart to Solidity's `*` operator.
1350      *
1351      * Requirements:
1352      *
1353      * - Multiplication cannot overflow.
1354      */
1355     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1356         return a * b;
1357     }
1358 
1359     /**
1360      * @dev Returns the integer division of two unsigned integers, reverting on
1361      * division by zero. The result is rounded towards zero.
1362      *
1363      * Counterpart to Solidity's `/` operator.
1364      *
1365      * Requirements:
1366      *
1367      * - The divisor cannot be zero.
1368      */
1369     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1370         return a / b;
1371     }
1372 
1373     /**
1374      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1375      * reverting when dividing by zero.
1376      *
1377      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1378      * opcode (which leaves remaining gas untouched) while Solidity uses an
1379      * invalid opcode to revert (consuming all remaining gas).
1380      *
1381      * Requirements:
1382      *
1383      * - The divisor cannot be zero.
1384      */
1385     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1386         return a % b;
1387     }
1388 
1389     /**
1390      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1391      * overflow (when the result is negative).
1392      *
1393      * CAUTION: This function is deprecated because it requires allocating memory for the error
1394      * message unnecessarily. For custom revert reasons use {trySub}.
1395      *
1396      * Counterpart to Solidity's `-` operator.
1397      *
1398      * Requirements:
1399      *
1400      * - Subtraction cannot overflow.
1401      */
1402     function sub(
1403         uint256 a,
1404         uint256 b,
1405         string memory errorMessage
1406     ) internal pure returns (uint256) {
1407     unchecked {
1408         require(b <= a, errorMessage);
1409         return a - b;
1410     }
1411     }
1412 
1413     /**
1414      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1415      * division by zero. The result is rounded towards zero.
1416      *
1417      * Counterpart to Solidity's `/` operator. Note: this function uses a
1418      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1419      * uses an invalid opcode to revert (consuming all remaining gas).
1420      *
1421      * Requirements:
1422      *
1423      * - The divisor cannot be zero.
1424      */
1425     function div(
1426         uint256 a,
1427         uint256 b,
1428         string memory errorMessage
1429     ) internal pure returns (uint256) {
1430     unchecked {
1431         require(b > 0, errorMessage);
1432         return a / b;
1433     }
1434     }
1435 
1436     /**
1437      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1438      * reverting with custom message when dividing by zero.
1439      *
1440      * CAUTION: This function is deprecated because it requires allocating memory for the error
1441      * message unnecessarily. For custom revert reasons use {tryMod}.
1442      *
1443      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1444      * opcode (which leaves remaining gas untouched) while Solidity uses an
1445      * invalid opcode to revert (consuming all remaining gas).
1446      *
1447      * Requirements:
1448      *
1449      * - The divisor cannot be zero.
1450      */
1451     function mod(
1452         uint256 a,
1453         uint256 b,
1454         string memory errorMessage
1455     ) internal pure returns (uint256) {
1456     unchecked {
1457         require(b > 0, errorMessage);
1458         return a % b;
1459     }
1460     }
1461 }
1462 
1463 contract Initializable {
1464     bool inited = false;
1465 
1466     modifier initializer() {
1467         require(!inited, "already inited");
1468         _;
1469         inited = true;
1470     }
1471 }
1472 
1473 contract EIP712Base is Initializable {
1474     struct EIP712Domain {
1475         string name;
1476         string version;
1477         address verifyingContract;
1478         bytes32 salt;
1479     }
1480 
1481     string constant public ERC712_VERSION = "1";
1482 
1483     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
1484         bytes(
1485             "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
1486         )
1487     );
1488     bytes32 internal domainSeperator;
1489 
1490     // supposed to be called once while initializing.
1491     // one of the contracts that inherits this contract follows proxy pattern
1492     // so it is not possible to do this in a constructor
1493     function _initializeEIP712(
1494         string memory name
1495     )
1496     internal
1497     initializer
1498     {
1499         _setDomainSeperator(name);
1500     }
1501 
1502     function _setDomainSeperator(string memory name) internal {
1503         domainSeperator = keccak256(
1504             abi.encode(
1505                 EIP712_DOMAIN_TYPEHASH,
1506                 keccak256(bytes(name)),
1507                 keccak256(bytes(ERC712_VERSION)),
1508                 address(this),
1509                 bytes32(getChainId())
1510             )
1511         );
1512     }
1513 
1514     function getDomainSeperator() public view returns (bytes32) {
1515         return domainSeperator;
1516     }
1517 
1518     function getChainId() public view returns (uint256) {
1519         uint256 id;
1520         assembly {
1521             id := chainid()
1522         }
1523         return id;
1524     }
1525 
1526     /**
1527      * Accept message hash and returns hash message in EIP712 compatible form
1528      * So that it can be used to recover signer from signature signed using EIP712 formatted data
1529      * https://eips.ethereum.org/EIPS/eip-712
1530      * "\\x19" makes the encoding deterministic
1531      * "\\x01" is the version byte to make it compatible to EIP-191
1532      */
1533     function toTypedMessageHash(bytes32 messageHash)
1534     internal
1535     view
1536     returns (bytes32)
1537     {
1538         return
1539         keccak256(
1540             abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
1541         );
1542     }
1543 }
1544 
1545 contract NativeMetaTransaction is EIP712Base {
1546     using SafeMath for uint256;
1547     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
1548         bytes(
1549             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
1550         )
1551     );
1552     event MetaTransactionExecuted(
1553         address userAddress,
1554         address payable relayerAddress,
1555         bytes functionSignature
1556     );
1557     mapping(address => uint256) nonces;
1558 
1559     /*
1560      * Meta transaction structure.
1561      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
1562      * He should call the desired function directly in that case.
1563      */
1564     struct MetaTransaction {
1565         uint256 nonce;
1566         address from;
1567         bytes functionSignature;
1568     }
1569 
1570     function executeMetaTransaction(
1571         address userAddress,
1572         bytes memory functionSignature,
1573         bytes32 sigR,
1574         bytes32 sigS,
1575         uint8 sigV
1576     ) public payable returns (bytes memory) {
1577         MetaTransaction memory metaTx = MetaTransaction({
1578         nonce: nonces[userAddress],
1579         from: userAddress,
1580         functionSignature: functionSignature
1581         });
1582 
1583         require(
1584             verify(userAddress, metaTx, sigR, sigS, sigV),
1585             "Signer and signature do not match"
1586         );
1587 
1588         // increase nonce for user (to avoid re-use)
1589         nonces[userAddress] = nonces[userAddress].add(1);
1590 
1591         emit MetaTransactionExecuted(
1592             userAddress,
1593             payable(msg.sender),
1594             functionSignature
1595         );
1596 
1597         // Append userAddress and relayer address at the end to extract it from calling context
1598         (bool success, bytes memory returnData) = address(this).call(
1599             abi.encodePacked(functionSignature, userAddress)
1600         );
1601         require(success, "Function call not successful");
1602 
1603         return returnData;
1604     }
1605 
1606     function hashMetaTransaction(MetaTransaction memory metaTx)
1607     internal
1608     pure
1609     returns (bytes32)
1610     {
1611         return
1612         keccak256(
1613             abi.encode(
1614                 META_TRANSACTION_TYPEHASH,
1615                 metaTx.nonce,
1616                 metaTx.from,
1617                 keccak256(metaTx.functionSignature)
1618             )
1619         );
1620     }
1621 
1622     function getNonce(address user) public view returns (uint256 nonce) {
1623         nonce = nonces[user];
1624     }
1625 
1626     function verify(
1627         address signer,
1628         MetaTransaction memory metaTx,
1629         bytes32 sigR,
1630         bytes32 sigS,
1631         uint8 sigV
1632     ) internal view returns (bool) {
1633         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
1634         return
1635         signer ==
1636         ecrecover(
1637             toTypedMessageHash(hashMetaTransaction(metaTx)),
1638             sigV,
1639             sigR,
1640             sigS
1641         );
1642     }
1643 }
1644 
1645 /**
1646  * @dev Contract module which provides a basic access control mechanism, where
1647  * there is an account (an owner) that can be granted exclusive access to
1648  * specific functions.
1649  *
1650  * By default, the owner account will be the one that deploys the contract. This
1651  * can later be changed with {transferOwnership}.
1652  *
1653  * This module is used through inheritance. It will make available the modifier
1654  * `onlyOwner`, which can be applied to your functions to restrict their use to
1655  * the owner.
1656  */
1657 abstract contract Ownable is Context {
1658     address private _owner;
1659 
1660     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1661 
1662     /**
1663      * @dev Initializes the contract setting the deployer as the initial owner.
1664      */
1665     constructor() {
1666         _transferOwnership(_msgSender());
1667     }
1668 
1669     /**
1670      * @dev Returns the address of the current owner.
1671      */
1672     function owner() public view virtual returns (address) {
1673         return _owner;
1674     }
1675 
1676     /**
1677      * @dev Throws if called by any account other than the owner.
1678      */
1679     modifier onlyOwner() {
1680         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1681         _;
1682     }
1683 
1684     /**
1685      * @dev Leaves the contract without owner. It will not be possible to call
1686      * `onlyOwner` functions anymore. Can only be called by the current owner.
1687      *
1688      * NOTE: Renouncing ownership will leave the contract without an owner,
1689      * thereby removing any functionality that is only available to the owner.
1690      */
1691     function renounceOwnership() public virtual onlyOwner {
1692         _transferOwnership(address(0));
1693     }
1694 
1695     /**
1696      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1697      * Can only be called by the current owner.
1698      */
1699     function transferOwnership(address newOwner) public virtual onlyOwner {
1700         require(newOwner != address(0), "Ownable: new owner is the zero address");
1701         _transferOwnership(newOwner);
1702     }
1703 
1704     /**
1705      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1706      * Internal function without access restriction.
1707      */
1708     function _transferOwnership(address newOwner) internal virtual {
1709         address oldOwner = _owner;
1710         _owner = newOwner;
1711         emit OwnershipTransferred(oldOwner, newOwner);
1712     }
1713 }
1714 
1715 /**
1716  * @dev Contract module that helps prevent reentrant calls to a function.
1717  *
1718  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1719  * available, which can be applied to functions to make sure there are no nested
1720  * (reentrant) calls to them.
1721  *
1722  * Note that because there is a single `nonReentrant` guard, functions marked as
1723  * `nonReentrant` may not call one another. This can be worked around by making
1724  * those functions `private`, and then adding `external` `nonReentrant` entry
1725  * points to them.
1726  *
1727  * TIP: If you would like to learn more about reentrancy and alternative ways
1728  * to protect against it, check out our blog post
1729  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1730  */
1731 abstract contract ReentrancyGuard {
1732     // Booleans are more expensive than uint256 or any type that takes up a full
1733     // word because each write operation emits an extra SLOAD to first read the
1734     // slot's contents, replace the bits taken up by the boolean, and then write
1735     // back. This is the compiler's defense against contract upgrades and
1736     // pointer aliasing, and it cannot be disabled.
1737 
1738     // The values being non-zero value makes deployment a bit more expensive,
1739     // but in exchange the refund on every call to nonReentrant will be lower in
1740     // amount. Since refunds are capped to a percentage of the total
1741     // transaction's gas, it is best to keep them low in cases like this one, to
1742     // increase the likelihood of the full refund coming into effect.
1743     uint256 private constant _NOT_ENTERED = 1;
1744     uint256 private constant _ENTERED = 2;
1745 
1746     uint256 private _status;
1747 
1748     constructor() {
1749         _status = _NOT_ENTERED;
1750     }
1751 
1752     /**
1753      * @dev Prevents a contract from calling itself, directly or indirectly.
1754      * Calling a `nonReentrant` function from another `nonReentrant`
1755      * function is not supported. It is possible to prevent this from happening
1756      * by making the `nonReentrant` function external, and make it call a
1757      * `private` function that does the actual work.
1758      */
1759     modifier nonReentrant() {
1760         // On the first call to nonReentrant, _notEntered will be true
1761         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1762 
1763         // Any calls to nonReentrant after this point will fail
1764         _status = _ENTERED;
1765 
1766         _;
1767 
1768         // By storing the original value once again, a refund is triggered (see
1769         // https://eips.ethereum.org/EIPS/eip-2200)
1770         _status = _NOT_ENTERED;
1771     }
1772 }
1773 
1774 contract OwnableDelegateProxy {}
1775 
1776 /**
1777  * Used to delegate ownership of a contract to another address, to save on unneeded transactions to approve contract use for users
1778  */
1779 contract ProxyRegistry {
1780     mapping(address => OwnableDelegateProxy) public proxies;
1781 }
1782 
1783 contract CyberneticPunks is
1784 ERC721A,
1785 ContextMixin,
1786 NativeMetaTransaction,
1787 Ownable,
1788 ReentrancyGuard
1789 {
1790     using Strings for uint256;
1791 
1792     address proxyRegistryAddress;
1793 
1794     string public constant collectionName = "Cybernetic Punks";
1795     string public constant collectionSymbol = "CPUNK";
1796     uint256 public constant maxQuantityPerMint = 10;
1797     uint256 public mintPrice = 0.022 ether;
1798     uint256 public maxTotalSupply = 3022;
1799 
1800     bool public mintActive = false;
1801 
1802     string public baseTokenURI;
1803     string public _contractURI;
1804     string public baseExtension = ".json";
1805 
1806     constructor(
1807         address _proxyRegistryAddress,
1808         string memory contractURI_
1809     ) ERC721A(collectionName, collectionSymbol) {
1810         _contractURI = contractURI_;
1811         proxyRegistryAddress = _proxyRegistryAddress;
1812         _initializeEIP712(collectionName);
1813     }
1814 
1815     modifier callerIsUser() {
1816         require(tx.origin == msg.sender, "The caller is another contract");
1817         _;
1818     }
1819 
1820     function gift(address to, uint256 quantity) external onlyOwner nonReentrant {
1821         require(totalSupply() + quantity <= maxTotalSupply, "Total supply would be exceeded");
1822         _safeMint(to, quantity);
1823     }
1824 
1825     function mint(uint256 quantity) external payable callerIsUser {
1826         uint256 currentPrice = quantity * mintPrice;
1827         require(mintActive, "Mint is currently paused");
1828         require(quantity <= maxQuantityPerMint, "Mint quantity limit 10");
1829         require(msg.value >= currentPrice, "Not enough payed");
1830         require(totalSupply() + quantity <= maxTotalSupply, "Total supply would be exceeded");
1831 
1832         _safeMint(_msgSender(), quantity);
1833         refundIfOver(currentPrice);
1834     }
1835 
1836     function refundIfOver(uint256 price) private {
1837         require(msg.value >= price, "Need to send more ETH.");
1838         if (msg.value > price) {
1839             payable(msg.sender).transfer(msg.value - price);
1840         }
1841     }
1842 
1843     function setMintActive(bool value) public onlyOwner {
1844         mintActive = value;
1845     }
1846 
1847     function setBaseURI(string calldata baseURI) public onlyOwner {
1848         baseTokenURI = baseURI;
1849     }
1850 
1851     function setContractURI(string calldata contractURI_) public onlyOwner {
1852         _contractURI = contractURI_;
1853     }
1854 
1855     function setBaseExtension(string calldata extension) public onlyOwner {
1856         baseExtension = extension;
1857     }
1858 
1859     function changeMintPrice(uint256 newPrice) public onlyOwner {
1860         mintPrice = newPrice;
1861     }
1862 
1863     function changeTotalSupply(uint256 newSupply) public onlyOwner {
1864         maxTotalSupply = newSupply;
1865     }
1866 
1867     function getMintPrice() public view returns (uint256) {
1868         return mintPrice;
1869     }
1870 
1871     function _baseURI() internal override view virtual returns (string memory) {
1872         return baseTokenURI;
1873     }
1874 
1875     /**
1876      * @dev See {IERC721Metadata-tokenURI}.
1877      */
1878     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1879         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1880 
1881         string memory baseURI = _baseURI();
1882         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), baseExtension)) : '';
1883     }
1884 
1885     function contractURI() public view returns (string memory) {
1886         return _contractURI;
1887     }
1888 
1889     /**
1890      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1891      */
1892     function isApprovedForAll(address owner, address operator)
1893     override
1894     public
1895     view
1896     returns (bool)
1897     {
1898         // Whitelist OpenSea proxy contract for easy trading.
1899         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1900         if (address(proxyRegistry.proxies(owner)) == operator) {
1901             return true;
1902         }
1903 
1904         return super.isApprovedForAll(owner, operator);
1905     }
1906 
1907     /**
1908      * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
1909      */
1910     function _msgSender()
1911     internal
1912     override
1913     view
1914     returns (address sender)
1915     {
1916         return ContextMixin.msgSender();
1917     }
1918 
1919     function withdraw() public onlyOwner nonReentrant {
1920         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1921         require(success, "Transfer failed.");
1922     }
1923 }