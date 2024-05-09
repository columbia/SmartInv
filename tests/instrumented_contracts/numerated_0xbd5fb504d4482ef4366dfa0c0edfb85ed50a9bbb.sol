1 pragma solidity 0.8.16;
2 
3 // SPDX-License-Identifier: MIT
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
27 /**
28  * @dev Required interface of an ERC721 compliant contract.
29  */
30 interface IERC721 is IERC165 {
31     /**
32      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
33      */
34     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
35 
36     /**
37      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
38      */
39     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
43      */
44     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
45 
46     /**
47      * @dev Returns the number of tokens in ``owner``'s account.
48      */
49     function balanceOf(address owner) external view returns (uint256 balance);
50 
51     /**
52      * @dev Returns the owner of the `tokenId` token.
53      *
54      * Requirements:
55      *
56      * - `tokenId` must exist.
57      */
58     function ownerOf(uint256 tokenId) external view returns (address owner);
59 
60     /**
61      * @dev Safely transfers `tokenId` token from `from` to `to`.
62      *
63      * Requirements:
64      *
65      * - `from` cannot be the zero address.
66      * - `to` cannot be the zero address.
67      * - `tokenId` token must exist and be owned by `from`.
68      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
69      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
70      *
71      * Emits a {Transfer} event.
72      */
73     function safeTransferFrom(
74         address from,
75         address to,
76         uint256 tokenId,
77         bytes calldata data
78     ) external;
79 
80     /**
81      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
82      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must exist and be owned by `from`.
89      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
90      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
91      *
92      * Emits a {Transfer} event.
93      */
94     function safeTransferFrom(
95         address from,
96         address to,
97         uint256 tokenId
98     ) external;
99 
100     /**
101      * @dev Transfers `tokenId` token from `from` to `to`.
102      *
103      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
104      *
105      * Requirements:
106      *
107      * - `from` cannot be the zero address.
108      * - `to` cannot be the zero address.
109      * - `tokenId` token must be owned by `from`.
110      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transferFrom(
115         address from,
116         address to,
117         uint256 tokenId
118     ) external;
119 
120     /**
121      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
122      * The approval is cleared when the token is transferred.
123      *
124      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
125      *
126      * Requirements:
127      *
128      * - The caller must own the token or be an approved operator.
129      * - `tokenId` must exist.
130      *
131      * Emits an {Approval} event.
132      */
133     function approve(address to, uint256 tokenId) external;
134 
135     /**
136      * @dev Approve or remove `operator` as an operator for the caller.
137      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
138      *
139      * Requirements:
140      *
141      * - The `operator` cannot be the caller.
142      *
143      * Emits an {ApprovalForAll} event.
144      */
145     function setApprovalForAll(address operator, bool _approved) external;
146 
147     /**
148      * @dev Returns the account approved for `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function getApproved(uint256 tokenId) external view returns (address operator);
155 
156     /**
157      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
158      *
159      * See {setApprovalForAll}
160      */
161     function isApprovedForAll(address owner, address operator) external view returns (bool);
162 }
163 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
164 /**
165  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
166  * @dev See https://eips.ethereum.org/EIPS/eip-721
167  */
168 interface IERC721Metadata is IERC721 {
169     /**
170      * @dev Returns the token collection name.
171      */
172     function name() external view returns (string memory);
173 
174     /**
175      * @dev Returns the token collection symbol.
176      */
177     function symbol() external view returns (string memory);
178 
179     /**
180      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
181      */
182     function tokenURI(uint256 tokenId) external view returns (string memory);
183 }
184 // ERC721A Contracts v3.3.0
185 // Creator: Chiru Labs
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
286 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
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
309 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
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
527 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
547 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
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
610 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
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
633 // ERC721A Contracts v3.3.0
634 // Creator: Chiru Labs
635 /**
636  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
637  * the Metadata extension. Built to optimize for lower gas during batch mints.
638  *
639  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
640  *
641  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
642  *
643  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
644  */
645 contract ERC721A is Context, ERC165, IERC721A {
646     using Address for address;
647     using Strings for uint256;
648 
649     // The tokenId of the next token to be minted.
650     uint256 internal _currentIndex;
651 
652     // The number of tokens burned.
653     uint256 internal _burnCounter;
654 
655     // Token name
656     string private _name;
657 
658     // Token symbol
659     string private _symbol;
660 
661     // Mapping from token ID to ownership details
662     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
663     mapping(uint256 => TokenOwnership) internal _ownerships;
664 
665     // Mapping owner address to address data
666     mapping(address => AddressData) private _addressData;
667 
668     // Mapping from token ID to approved address
669     mapping(uint256 => address) private _tokenApprovals;
670 
671     // Mapping from owner to operator approvals
672     mapping(address => mapping(address => bool)) private _operatorApprovals;
673 
674     constructor(string memory name_, string memory symbol_) {
675         _name = name_;
676         _symbol = symbol_;
677         _currentIndex = _startTokenId();
678     }
679 
680     /**
681      * To change the starting tokenId, please override this function.
682      */
683     function _startTokenId() internal view virtual returns (uint256) {
684         return 0;
685     }
686 
687     /**
688      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
689      */
690     function totalSupply() public view override returns (uint256) {
691         // Counter underflow is impossible as _burnCounter cannot be incremented
692         // more than _currentIndex - _startTokenId() times
693         unchecked {
694             return _currentIndex - _burnCounter - _startTokenId();
695         }
696     }
697 
698     /**
699      * Returns the total amount of tokens minted in the contract.
700      */
701     function _totalMinted() internal view returns (uint256) {
702         // Counter underflow is impossible as _currentIndex does not decrement,
703         // and it is initialized to _startTokenId()
704         unchecked {
705             return _currentIndex - _startTokenId();
706         }
707     }
708 
709     /**
710      * @dev See {IERC165-supportsInterface}.
711      */
712     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
713         return
714             interfaceId == type(IERC721).interfaceId ||
715             interfaceId == type(IERC721Metadata).interfaceId ||
716             super.supportsInterface(interfaceId);
717     }
718 
719     /**
720      * @dev See {IERC721-balanceOf}.
721      */
722     function balanceOf(address owner) public view override returns (uint256) {
723         if (owner == address(0)) revert BalanceQueryForZeroAddress();
724         return uint256(_addressData[owner].balance);
725     }
726 
727     /**
728      * Returns the number of tokens minted by `owner`.
729      */
730     function _numberMinted(address owner) internal view returns (uint256) {
731         return uint256(_addressData[owner].numberMinted);
732     }
733 
734     /**
735      * Returns the number of tokens burned by or on behalf of `owner`.
736      */
737     function _numberBurned(address owner) internal view returns (uint256) {
738         return uint256(_addressData[owner].numberBurned);
739     }
740 
741     /**
742      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
743      */
744     function _getAux(address owner) internal view returns (uint64) {
745         return _addressData[owner].aux;
746     }
747 
748     /**
749      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
750      * If there are multiple variables, please pack them into a uint64.
751      */
752     function _setAux(address owner, uint64 aux) internal {
753         _addressData[owner].aux = aux;
754     }
755 
756     /**
757      * Gas spent here starts off proportional to the maximum mint batch size.
758      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
759      */
760     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
761         uint256 curr = tokenId;
762 
763         unchecked {
764             if (_startTokenId() <= curr) if (curr < _currentIndex) {
765                 TokenOwnership memory ownership = _ownerships[curr];
766                 if (!ownership.burned) {
767                     if (ownership.addr != address(0)) {
768                         return ownership;
769                     }
770                     // Invariant:
771                     // There will always be an ownership that has an address and is not burned
772                     // before an ownership that does not have an address and is not burned.
773                     // Hence, curr will not underflow.
774                     while (true) {
775                         curr--;
776                         ownership = _ownerships[curr];
777                         if (ownership.addr != address(0)) {
778                             return ownership;
779                         }
780                     }
781                 }
782             }
783         }
784         revert OwnerQueryForNonexistentToken();
785     }
786 
787     /**
788      * @dev See {IERC721-ownerOf}.
789      */
790     function ownerOf(uint256 tokenId) public view override returns (address) {
791         return _ownershipOf(tokenId).addr;
792     }
793 
794     /**
795      * @dev See {IERC721Metadata-name}.
796      */
797     function name() public view virtual override returns (string memory) {
798         return _name;
799     }
800 
801     /**
802      * @dev See {IERC721Metadata-symbol}.
803      */
804     function symbol() public view virtual override returns (string memory) {
805         return _symbol;
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-tokenURI}.
810      */
811     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
812         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
813 
814         string memory baseURI = _baseURI();
815         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
816     }
817 
818     /**
819      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
820      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
821      * by default, can be overriden in child contracts.
822      */
823     function _baseURI() internal view virtual returns (string memory) {
824         return '';
825     }
826 
827     /**
828      * @dev See {IERC721-approve}.
829      */
830     function approve(address to, uint256 tokenId) public override {
831         address owner = ERC721A.ownerOf(tokenId);
832         if (to == owner) revert ApprovalToCurrentOwner();
833 
834         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
835             revert ApprovalCallerNotOwnerNorApproved();
836         }
837 
838         _approve(to, tokenId, owner);
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
947         unchecked {
948             _addressData[to].balance += uint64(quantity);
949             _addressData[to].numberMinted += uint64(quantity);
950 
951             _ownerships[startTokenId].addr = to;
952             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
953 
954             uint256 updatedIndex = startTokenId;
955             uint256 end = updatedIndex + quantity;
956 
957             if (to.isContract()) {
958                 do {
959                     emit Transfer(address(0), to, updatedIndex);
960                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
961                         revert TransferToNonERC721ReceiverImplementer();
962                     }
963                 } while (updatedIndex < end);
964                 // Reentrancy protection
965                 if (_currentIndex != startTokenId) revert();
966             } else {
967                 do {
968                     emit Transfer(address(0), to, updatedIndex++);
969                 } while (updatedIndex < end);
970             }
971             _currentIndex = updatedIndex;
972         }
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
996         unchecked {
997             _addressData[to].balance += uint64(quantity);
998             _addressData[to].numberMinted += uint64(quantity);
999 
1000             _ownerships[startTokenId].addr = to;
1001             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1002 
1003             uint256 updatedIndex = startTokenId;
1004             uint256 end = updatedIndex + quantity;
1005 
1006             do {
1007                 emit Transfer(address(0), to, updatedIndex++);
1008             } while (updatedIndex < end);
1009 
1010             _currentIndex = updatedIndex;
1011         }
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
1035             isApprovedForAll(from, _msgSender()) ||
1036             getApproved(tokenId) == _msgSender());
1037 
1038         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1039         if (to == address(0)) revert TransferToZeroAddress();
1040 
1041         _beforeTokenTransfers(from, to, tokenId, 1);
1042 
1043         // Clear approvals from the previous owner
1044         _approve(address(0), tokenId, from);
1045 
1046         // Underflow of the sender's balance is impossible because we check for
1047         // ownership above and the recipient's balance can't realistically overflow.
1048         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1049         unchecked {
1050             _addressData[from].balance -= 1;
1051             _addressData[to].balance += 1;
1052 
1053             TokenOwnership storage currSlot = _ownerships[tokenId];
1054             currSlot.addr = to;
1055             currSlot.startTimestamp = uint64(block.timestamp);
1056 
1057             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1058             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1059             uint256 nextTokenId = tokenId + 1;
1060             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1061             if (nextSlot.addr == address(0)) {
1062                 // This will suffice for checking _exists(nextTokenId),
1063                 // as a burned slot cannot contain the zero address.
1064                 if (nextTokenId != _currentIndex) {
1065                     nextSlot.addr = from;
1066                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1067                 }
1068             }
1069         }
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
1099                 isApprovedForAll(from, _msgSender()) ||
1100                 getApproved(tokenId) == _msgSender());
1101 
1102             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1103         }
1104 
1105         _beforeTokenTransfers(from, address(0), tokenId, 1);
1106 
1107         // Clear approvals from the previous owner
1108         _approve(address(0), tokenId, from);
1109 
1110         // Underflow of the sender's balance is impossible because we check for
1111         // ownership above and the recipient's balance can't realistically overflow.
1112         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1113         unchecked {
1114             AddressData storage addressData = _addressData[from];
1115             addressData.balance -= 1;
1116             addressData.numberBurned += 1;
1117 
1118             // Keep track of who burned the token, and the timestamp of burning.
1119             TokenOwnership storage currSlot = _ownerships[tokenId];
1120             currSlot.addr = from;
1121             currSlot.startTimestamp = uint64(block.timestamp);
1122             currSlot.burned = true;
1123 
1124             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1125             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1126             uint256 nextTokenId = tokenId + 1;
1127             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1128             if (nextSlot.addr == address(0)) {
1129                 // This will suffice for checking _exists(nextTokenId),
1130                 // as a burned slot cannot contain the zero address.
1131                 if (nextTokenId != _currentIndex) {
1132                     nextSlot.addr = from;
1133                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1134                 }
1135             }
1136         }
1137 
1138         emit Transfer(from, address(0), tokenId);
1139         _afterTokenTransfers(from, address(0), tokenId, 1);
1140 
1141         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1142         unchecked {
1143             _burnCounter++;
1144         }
1145     }
1146 
1147     /**
1148      * @dev Approve `to` to operate on `tokenId`
1149      *
1150      * Emits a {Approval} event.
1151      */
1152     function _approve(
1153         address to,
1154         uint256 tokenId,
1155         address owner
1156     ) private {
1157         _tokenApprovals[tokenId] = to;
1158         emit Approval(owner, to, tokenId);
1159     }
1160 
1161     /**
1162      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1163      *
1164      * @param from address representing the previous owner of the given token ID
1165      * @param to target address that will receive the tokens
1166      * @param tokenId uint256 ID of the token to be transferred
1167      * @param _data bytes optional data to send along with the call
1168      * @return bool whether the call correctly returned the expected magic value
1169      */
1170     function _checkContractOnERC721Received(
1171         address from,
1172         address to,
1173         uint256 tokenId,
1174         bytes memory _data
1175     ) private returns (bool) {
1176         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1177             return retval == IERC721Receiver(to).onERC721Received.selector;
1178         } catch (bytes memory reason) {
1179             if (reason.length == 0) {
1180                 revert TransferToNonERC721ReceiverImplementer();
1181             } else {
1182                 assembly {
1183                     revert(add(32, reason), mload(reason))
1184                 }
1185             }
1186         }
1187     }
1188 
1189     /**
1190      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1191      * And also called before burning one token.
1192      *
1193      * startTokenId - the first token id to be transferred
1194      * quantity - the amount to be transferred
1195      *
1196      * Calling conditions:
1197      *
1198      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1199      * transferred to `to`.
1200      * - When `from` is zero, `tokenId` will be minted for `to`.
1201      * - When `to` is zero, `tokenId` will be burned by `from`.
1202      * - `from` and `to` are never both zero.
1203      */
1204     function _beforeTokenTransfers(
1205         address from,
1206         address to,
1207         uint256 startTokenId,
1208         uint256 quantity
1209     ) internal virtual {}
1210 
1211     /**
1212      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1213      * minting.
1214      * And also called after one token has been burned.
1215      *
1216      * startTokenId - the first token id to be transferred
1217      * quantity - the amount to be transferred
1218      *
1219      * Calling conditions:
1220      *
1221      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1222      * transferred to `to`.
1223      * - When `from` is zero, `tokenId` has been minted for `to`.
1224      * - When `to` is zero, `tokenId` has been burned by `from`.
1225      * - `from` and `to` are never both zero.
1226      */
1227     function _afterTokenTransfers(
1228         address from,
1229         address to,
1230         uint256 startTokenId,
1231         uint256 quantity
1232     ) internal virtual {}
1233 }
1234 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1235 /**
1236  * @dev Contract module which provides a basic access control mechanism, where
1237  * there is an account (an owner) that can be granted exclusive access to
1238  * specific functions.
1239  *
1240  * By default, the owner account will be the one that deploys the contract. This
1241  * can later be changed with {transferOwnership}.
1242  *
1243  * This module is used through inheritance. It will make available the modifier
1244  * `onlyOwner`, which can be applied to your functions to restrict their use to
1245  * the owner.
1246  */
1247 abstract contract Ownable is Context {
1248     address private _owner;
1249 
1250     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1251 
1252     /**
1253      * @dev Initializes the contract setting the deployer as the initial owner.
1254      */
1255     constructor() {
1256         _transferOwnership(_msgSender());
1257     }
1258 
1259     /**
1260      * @dev Returns the address of the current owner.
1261      */
1262     function owner() public view virtual returns (address) {
1263         return _owner;
1264     }
1265 
1266     /**
1267      * @dev Throws if called by any account other than the owner.
1268      */
1269     modifier onlyOwner() {
1270         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1271         _;
1272     }
1273 
1274     /**
1275      * @dev Leaves the contract without owner. It will not be possible to call
1276      * `onlyOwner` functions anymore. Can only be called by the current owner.
1277      *
1278      * NOTE: Renouncing ownership will leave the contract without an owner,
1279      * thereby removing any functionality that is only available to the owner.
1280      */
1281     function renounceOwnership() public virtual onlyOwner {
1282         _transferOwnership(address(0));
1283     }
1284 
1285     /**
1286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1287      * Can only be called by the current owner.
1288      */
1289     function transferOwnership(address newOwner) public virtual onlyOwner {
1290         require(newOwner != address(0), "Ownable: new owner is the zero address");
1291         _transferOwnership(newOwner);
1292     }
1293 
1294     /**
1295      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1296      * Internal function without access restriction.
1297      */
1298     function _transferOwnership(address newOwner) internal virtual {
1299         address oldOwner = _owner;
1300         _owner = newOwner;
1301         emit OwnershipTransferred(oldOwner, newOwner);
1302     }
1303 }
1304 interface ICornTown is IERC721A {
1305   function mint(address initialOwner, uint256 amounts) external;
1306 
1307   function maxSupply() external view returns (uint256);
1308 
1309   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) external;
1310   
1311   function ownerOf(uint256 tokenId) external view returns (address);
1312 }
1313 contract CornTown is Ownable, ERC721A {
1314   using Strings for uint256;
1315 
1316   string public baseURI;
1317   address public saleManager;
1318   uint256 public maxSupply;
1319 
1320   mapping (address => bool) private cornMasterOperators;
1321 
1322   /**
1323   @dev tokenId to seeding start time (0 = not seeding).
1324     */
1325   mapping(uint256 => uint256) private seedingStarted;
1326   /**
1327   @dev Cumulative per-token seeding, excluding the current period.
1328     */
1329   mapping(uint256 => uint256) private seedingTotal;
1330   /**
1331   @dev MUST only be modified by safeTransferWhileSeeding(); if set to 2 then
1332   the _beforeTokenTransfer() block while seeding is disabled.
1333     */
1334   bool private blockSeedingTransfer = true;
1335 
1336   /**
1337   @notice Whether seeding is currently allowed.
1338   @dev If false then seeding is blocked, but unseeding is always allowed.
1339     */
1340   bool public seedingOpen = false;
1341 
1342   /**
1343   @dev Emitted when a CornTown begins seeding.
1344     */
1345   event Planted(uint256 indexed tokenId);
1346 
1347   /**
1348   @dev Emitted when a CornTown stops seeding; either through standard means or
1349   by expulsion.
1350     */
1351   event Cropped(uint256 indexed tokenId);
1352 
1353   /**
1354   @dev Emitted when a CornTown is expelled from the seed.
1355     */
1356   event Expelled(uint256 indexed tokenId);
1357 
1358   event BaseURI(string baseUri);
1359 
1360   constructor(
1361     string memory name,
1362     string memory symbol,
1363     uint256 _maxSupply
1364   ) ERC721A(name, symbol) {
1365     maxSupply = _maxSupply;
1366   }
1367 
1368   modifier onlySaleManager() {
1369     require(msg.sender == saleManager, "only sale manager");
1370     _;
1371   }
1372 
1373   /// @notice Requires that msg.sender owns or is approved for the token.
1374   modifier onlyApprovedOrTokenOwner(uint256 tokenId) {
1375     require(
1376       _ownershipOf(tokenId).addr == msg.sender || getApproved(tokenId) == msg.sender,
1377       "CornTown: Not approved nor owner"
1378     );
1379     _;
1380   }
1381 
1382   function setBaseURI(string memory _baseUri) external onlyOwner {
1383     baseURI = _baseUri;
1384   }
1385 
1386   function _baseURI() internal view override returns (string memory) {
1387     return baseURI;
1388   }
1389 
1390   function mint(
1391     address initialOwner,
1392     uint256 amount
1393   ) external onlySaleManager {
1394     require(totalSupply() + amount <= maxSupply, "maxSupply");
1395     _mint(initialOwner, amount);
1396   }
1397 
1398   /// @notice Set the address for the saleManager
1399   /// @param _saleManager: address of the sale contract
1400   function setSaleManager(address _saleManager) external onlyOwner {
1401     saleManager = _saleManager;
1402   }
1403 
1404   function setOperator(address _operator) external onlyOwner {
1405     cornMasterOperators[_operator] = true;
1406   }
1407 
1408   function disableOperator(address _operator) external onlyOwner {
1409     cornMasterOperators[_operator] = false;
1410   }
1411 
1412   function isApprovedForAll(address owner, address operator) public override view returns (bool) {
1413     if (cornMasterOperators[operator]) {
1414       return true;
1415     }
1416 
1417     return super.isApprovedForAll(owner, operator);
1418   }
1419 
1420   /**
1421     @notice Returns the length of time, in seconds, that the CornTown has
1422     been seeding.
1423     @dev Seeding is tied to a specific CornTown, not to the owner, so it doesn't
1424     reset upon sale.
1425     @return seeding Whether the CornTown is currently seeding. MAY be true with
1426     zero current seeding if in the same block as seeding began.
1427     @return current Zero if not currently seeding, otherwise the length of time
1428     since the most recent seeding began.
1429     @return total Total period of time for which the CornTown has seeded across
1430     its life, including the current period.
1431   */
1432   function seedingPeriod(uint256 tokenId) external view returns (
1433     bool seeding,
1434     uint256 current,
1435     uint256 total
1436   ) {
1437     uint256 start = seedingStarted[tokenId];
1438 
1439     if (start != 0) {
1440       seeding = true;
1441       current = block.timestamp - start;
1442     }
1443 
1444     total = current + seedingTotal[tokenId];
1445   }
1446 
1447   /**
1448     @notice Transfer a token between addresses while the CornTown is minting,
1449     thus not resetting the seeding period.
1450   */
1451   function safeTransferWhileSeeding(
1452     address from,
1453     address to,
1454     uint256 tokenId
1455   ) external {
1456     require(ownerOf(tokenId) == msg.sender, "CornTown: Only owner");
1457 
1458     blockSeedingTransfer = false;
1459     safeTransferFrom(from, to, tokenId);
1460     blockSeedingTransfer = true;
1461   }
1462 
1463   /**
1464     @dev Block transfers while seeding.
1465   */
1466   function _beforeTokenTransfers(
1467     address,
1468     address,
1469     uint256 startTokenId,
1470     uint256 quantity
1471   ) internal view override {
1472     uint256 tokenId = startTokenId;
1473 
1474     for (uint256 end = tokenId + quantity; tokenId < end; ++tokenId) {
1475       require(
1476         seedingStarted[tokenId] == 0 || !blockSeedingTransfer,
1477         "CornTown: seeding"
1478       );
1479     }
1480   }
1481 
1482   /**
1483     @notice Toggles the `seedingOpen` flag.
1484   */
1485   function setSeedingOpen(bool open) external onlyOwner {
1486     seedingOpen = open;
1487   }
1488 
1489   /**
1490     @notice Changes the CornTown's seeding status.
1491   */
1492   function _toggleSeeding(uint256 tokenId) internal onlyApprovedOrTokenOwner(tokenId) {
1493     uint256 start = seedingStarted[tokenId];
1494 
1495     if (start == 0) {
1496       require(seedingOpen, "CornTown: seeding closed");
1497 
1498       seedingStarted[tokenId] = block.timestamp;
1499 
1500       emit Planted(tokenId);
1501     } else {
1502       seedingTotal[tokenId] += block.timestamp - start;
1503       seedingStarted[tokenId] = 0;
1504 
1505       emit Cropped(tokenId);
1506     }
1507   }
1508 
1509   /**
1510     @notice Changes the CornTown' seeding statuses  .
1511     @dev Changes the CornTown' seeding sheep (see @notice).
1512   */
1513   function toggleSeeding(uint256[] calldata tokenIds) external {
1514     uint256 n = tokenIds.length;
1515 
1516     for (uint256 i = 0; i < n; ++i) {
1517       _toggleSeeding(tokenIds[i]);
1518     }
1519   }
1520 
1521   /**
1522     @notice Admin-only ability to expel a CornTown from the seed.
1523     @dev As most sales listings use off-chain signatures it's impossible to
1524     detect someone who has seeded and then deliberately undercuts the floor
1525     price in the knowledge that the sale can't proceed. This function allows for
1526     monitoring of such practices and expulsion if abuse is detected, allowing
1527     the undercutting bird to be sold on the open market. Since OpenSea uses
1528     isApprovedForAll() in its pre-listing checks, we can't block by that means
1529     because seeding would then be all-or-nothing for all of a particular owner's
1530     CornTown.
1531   */
1532   function expelFromSeed(uint256 tokenId) external onlyOwner {
1533       require(seedingStarted[tokenId] != 0, "CornTown: not seeding");
1534 
1535       seedingTotal[tokenId] += block.timestamp - seedingStarted[tokenId];
1536       seedingStarted[tokenId] = 0;
1537 
1538       emit Cropped(tokenId);
1539       emit Expelled(tokenId);
1540   }
1541 }