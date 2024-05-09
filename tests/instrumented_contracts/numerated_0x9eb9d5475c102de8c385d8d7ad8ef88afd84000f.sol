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
256 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev Interface of the ERC165 standard, as defined in the
265  * https://eips.ethereum.org/EIPS/eip-165[EIP].
266  *
267  * Implementers can declare support of contract interfaces, which can then be
268  * queried by others ({ERC165Checker}).
269  *
270  * For an implementation, see {ERC165}.
271  */
272 interface IERC165 {
273     /**
274      * @dev Returns true if this contract implements the interface defined by
275      * `interfaceId`. See the corresponding
276      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
277      * to learn more about how these ids are created.
278      *
279      * This function call must use less than 30 000 gas.
280      */
281     function supportsInterface(bytes4 interfaceId) external view returns (bool);
282 }
283 
284 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 
292 /**
293  * @dev Implementation of the {IERC165} interface.
294  *
295  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
296  * for the additional interface id that will be supported. For example:
297  *
298  * ```solidity
299  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
300  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
301  * }
302  * ```
303  *
304  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
305  */
306 abstract contract ERC165 is IERC165 {
307     /**
308      * @dev See {IERC165-supportsInterface}.
309      */
310     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
311         return interfaceId == type(IERC165).interfaceId;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
316 
317 
318 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Required interface of an ERC721 compliant contract.
325  */
326 interface IERC721 is IERC165 {
327     /**
328      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
334      */
335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
339      */
340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
341 
342     /**
343      * @dev Returns the number of tokens in ``owner``'s account.
344      */
345     function balanceOf(address owner) external view returns (uint256 balance);
346 
347     /**
348      * @dev Returns the owner of the `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function ownerOf(uint256 tokenId) external view returns (address owner);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
358      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
359      *
360      * Requirements:
361      *
362      * - `from` cannot be the zero address.
363      * - `to` cannot be the zero address.
364      * - `tokenId` token must exist and be owned by `from`.
365      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
366      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
367      *
368      * Emits a {Transfer} event.
369      */
370     function safeTransferFrom(
371         address from,
372         address to,
373         uint256 tokenId
374     ) external;
375 
376     /**
377      * @dev Transfers `tokenId` token from `from` to `to`.
378      *
379      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
380      *
381      * Requirements:
382      *
383      * - `from` cannot be the zero address.
384      * - `to` cannot be the zero address.
385      * - `tokenId` token must be owned by `from`.
386      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
387      *
388      * Emits a {Transfer} event.
389      */
390     function transferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
398      * The approval is cleared when the token is transferred.
399      *
400      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
401      *
402      * Requirements:
403      *
404      * - The caller must own the token or be an approved operator.
405      * - `tokenId` must exist.
406      *
407      * Emits an {Approval} event.
408      */
409     function approve(address to, uint256 tokenId) external;
410 
411     /**
412      * @dev Returns the account approved for `tokenId` token.
413      *
414      * Requirements:
415      *
416      * - `tokenId` must exist.
417      */
418     function getApproved(uint256 tokenId) external view returns (address operator);
419 
420     /**
421      * @dev Approve or remove `operator` as an operator for the caller.
422      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
423      *
424      * Requirements:
425      *
426      * - The `operator` cannot be the caller.
427      *
428      * Emits an {ApprovalForAll} event.
429      */
430     function setApprovalForAll(address operator, bool _approved) external;
431 
432     /**
433      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
434      *
435      * See {setApprovalForAll}
436      */
437     function isApprovedForAll(address owner, address operator) external view returns (bool);
438 
439     /**
440      * @dev Safely transfers `tokenId` token from `from` to `to`.
441      *
442      * Requirements:
443      *
444      * - `from` cannot be the zero address.
445      * - `to` cannot be the zero address.
446      * - `tokenId` token must exist and be owned by `from`.
447      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
448      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
449      *
450      * Emits a {Transfer} event.
451      */
452     function safeTransferFrom(
453         address from,
454         address to,
455         uint256 tokenId,
456         bytes calldata data
457     ) external;
458 }
459 
460 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
461 
462 
463 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
470  * @dev See https://eips.ethereum.org/EIPS/eip-721
471  */
472 interface IERC721Enumerable is IERC721 {
473     /**
474      * @dev Returns the total amount of tokens stored by the contract.
475      */
476     function totalSupply() external view returns (uint256);
477 
478     /**
479      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
480      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
481      */
482     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
483 
484     /**
485      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
486      * Use along with {totalSupply} to enumerate all tokens.
487      */
488     function tokenByIndex(uint256 index) external view returns (uint256);
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
501  * @dev See https://eips.ethereum.org/EIPS/eip-721
502  */
503 interface IERC721Metadata is IERC721 {
504     /**
505      * @dev Returns the token collection name.
506      */
507     function name() external view returns (string memory);
508 
509     /**
510      * @dev Returns the token collection symbol.
511      */
512     function symbol() external view returns (string memory);
513 
514     /**
515      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
516      */
517     function tokenURI(uint256 tokenId) external view returns (string memory);
518 }
519 
520 // File: @openzeppelin/contracts/utils/Strings.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev String operations.
529  */
530 library Strings {
531     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
532 
533     /**
534      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
535      */
536     function toString(uint256 value) internal pure returns (string memory) {
537         // Inspired by OraclizeAPI's implementation - MIT licence
538         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
539 
540         if (value == 0) {
541             return "0";
542         }
543         uint256 temp = value;
544         uint256 digits;
545         while (temp != 0) {
546             digits++;
547             temp /= 10;
548         }
549         bytes memory buffer = new bytes(digits);
550         while (value != 0) {
551             digits -= 1;
552             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
553             value /= 10;
554         }
555         return string(buffer);
556     }
557 
558     /**
559      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
560      */
561     function toHexString(uint256 value) internal pure returns (string memory) {
562         if (value == 0) {
563             return "0x00";
564         }
565         uint256 temp = value;
566         uint256 length = 0;
567         while (temp != 0) {
568             length++;
569             temp >>= 8;
570         }
571         return toHexString(value, length);
572     }
573 
574     /**
575      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
576      */
577     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
578         bytes memory buffer = new bytes(2 * length + 2);
579         buffer[0] = "0";
580         buffer[1] = "x";
581         for (uint256 i = 2 * length + 1; i > 1; --i) {
582             buffer[i] = _HEX_SYMBOLS[value & 0xf];
583             value >>= 4;
584         }
585         require(value == 0, "Strings: hex length insufficient");
586         return string(buffer);
587     }
588 }
589 
590 // File: @openzeppelin/contracts/utils/Context.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 /**
598  * @dev Provides information about the current execution context, including the
599  * sender of the transaction and its data. While these are generally available
600  * via msg.sender and msg.data, they should not be accessed in such a direct
601  * manner, since when dealing with meta-transactions the account sending and
602  * paying for execution may not be the actual sender (as far as an application
603  * is concerned).
604  *
605  * This contract is only required for intermediate, library-like contracts.
606  */
607 abstract contract Context {
608     function _msgSender() internal view virtual returns (address) {
609         return msg.sender;
610     }
611 
612     function _msgData() internal view virtual returns (bytes calldata) {
613         return msg.data;
614     }
615 }
616 
617 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
618 
619 
620 // Creator: Chiru Labs
621 
622 pragma solidity ^0.8.4;
623 
624 
625 
626 
627 
628 
629 
630 
631 
632 error ApprovalCallerNotOwnerNorApproved();
633 error ApprovalQueryForNonexistentToken();
634 error ApproveToCaller();
635 error ApprovalToCurrentOwner();
636 error BalanceQueryForZeroAddress();
637 error MintedQueryForZeroAddress();
638 error BurnedQueryForZeroAddress();
639 error AuxQueryForZeroAddress();
640 error MintToZeroAddress();
641 error MintZeroQuantity();
642 error OwnerIndexOutOfBounds();
643 error OwnerQueryForNonexistentToken();
644 error TokenIndexOutOfBounds();
645 error TransferCallerNotOwnerNorApproved();
646 error TransferFromIncorrectOwner();
647 error TransferToNonERC721ReceiverImplementer();
648 error TransferToZeroAddress();
649 error URIQueryForNonexistentToken();
650 
651 /**
652  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
653  * the Metadata extension. Built to optimize for lower gas during batch mints.
654  *
655  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
656  *
657  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
658  *
659  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
660  */
661 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
662     using Address for address;
663     using Strings for uint256;
664 
665     // Compiler will pack this into a single 256bit word.
666     struct TokenOwnership {
667         // The address of the owner.
668         address addr;
669         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
670         uint64 startTimestamp;
671         // Whether the token has been burned.
672         bool burned;
673     }
674 
675     // Compiler will pack this into a single 256bit word.
676     struct AddressData {
677         // Realistically, 2**64-1 is more than enough.
678         uint64 balance;
679         // Keeps track of mint count with minimal overhead for tokenomics.
680         uint64 numberMinted;
681         // Keeps track of burn count with minimal overhead for tokenomics.
682         uint64 numberBurned;
683         // For miscellaneous variable(s) pertaining to the address
684         // (e.g. number of whitelist mint slots used).
685         // If there are multiple variables, please pack them into a uint64.
686         uint64 aux;
687     }
688 
689     // The tokenId of the next token to be minted.
690     uint256 internal _currentIndex;
691 
692     // The number of tokens burned.
693     uint256 internal _burnCounter;
694 
695     // Token name
696     string private _name;
697 
698     // Token symbol
699     string private _symbol;
700 
701     // Mapping from token ID to ownership details
702     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
703     mapping(uint256 => TokenOwnership) internal _ownerships;
704 
705     // Mapping owner address to address data
706     mapping(address => AddressData) private _addressData;
707 
708     // Mapping from token ID to approved address
709     mapping(uint256 => address) private _tokenApprovals;
710 
711     // Mapping from owner to operator approvals
712     mapping(address => mapping(address => bool)) private _operatorApprovals;
713 
714     constructor(string memory name_, string memory symbol_) {
715         _name = name_;
716         _symbol = symbol_;
717         _currentIndex = _startTokenId();
718     }
719 
720     /**
721      * To change the starting tokenId, please override this function.
722      */
723     function _startTokenId() internal view virtual returns (uint256) {
724         return 0;
725     }
726 
727     /**
728      * @dev See {IERC721Enumerable-totalSupply}.
729      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
730      */
731     function totalSupply() public view returns (uint256) {
732         // Counter underflow is impossible as _burnCounter cannot be incremented
733         // more than _currentIndex - _startTokenId() times
734         unchecked {
735             return _currentIndex - _burnCounter - _startTokenId();
736         }
737     }
738 
739     /**
740      * Returns the total amount of tokens minted in the contract.
741      */
742     function _totalMinted() internal view returns (uint256) {
743         // Counter underflow is impossible as _currentIndex does not decrement,
744         // and it is initialized to _startTokenId()
745         unchecked {
746             return _currentIndex - _startTokenId();
747         }
748     }
749 
750     /**
751      * @dev See {IERC165-supportsInterface}.
752      */
753     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
754         return
755             interfaceId == type(IERC721).interfaceId ||
756             interfaceId == type(IERC721Metadata).interfaceId ||
757             super.supportsInterface(interfaceId);
758     }
759 
760     /**
761      * @dev See {IERC721-balanceOf}.
762      */
763     function balanceOf(address owner) public view override returns (uint256) {
764         if (owner == address(0)) revert BalanceQueryForZeroAddress();
765         return uint256(_addressData[owner].balance);
766     }
767 
768     /**
769      * Returns the number of tokens minted by `owner`.
770      */
771     function _numberMinted(address owner) internal view returns (uint256) {
772         if (owner == address(0)) revert MintedQueryForZeroAddress();
773         return uint256(_addressData[owner].numberMinted);
774     }
775 
776     /**
777      * Returns the number of tokens burned by or on behalf of `owner`.
778      */
779     function _numberBurned(address owner) internal view returns (uint256) {
780         if (owner == address(0)) revert BurnedQueryForZeroAddress();
781         return uint256(_addressData[owner].numberBurned);
782     }
783 
784     /**
785      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
786      */
787     function _getAux(address owner) internal view returns (uint64) {
788         if (owner == address(0)) revert AuxQueryForZeroAddress();
789         return _addressData[owner].aux;
790     }
791 
792     /**
793      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
794      * If there are multiple variables, please pack them into a uint64.
795      */
796     function _setAux(address owner, uint64 aux) internal {
797         if (owner == address(0)) revert AuxQueryForZeroAddress();
798         _addressData[owner].aux = aux;
799     }
800 
801     /**
802      * Gas spent here starts off proportional to the maximum mint batch size.
803      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
804      */
805     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
806         uint256 curr = tokenId;
807 
808         unchecked {
809             if (_startTokenId() <= curr && curr < _currentIndex) {
810                 TokenOwnership memory ownership = _ownerships[curr];
811                 if (!ownership.burned) {
812                     if (ownership.addr != address(0)) {
813                         return ownership;
814                     }
815                     // Invariant:
816                     // There will always be an ownership that has an address and is not burned
817                     // before an ownership that does not have an address and is not burned.
818                     // Hence, curr will not underflow.
819                     while (true) {
820                         curr--;
821                         ownership = _ownerships[curr];
822                         if (ownership.addr != address(0)) {
823                             return ownership;
824                         }
825                     }
826                 }
827             }
828         }
829         revert OwnerQueryForNonexistentToken();
830     }
831 
832     /**
833      * @dev See {IERC721-ownerOf}.
834      */
835     function ownerOf(uint256 tokenId) public view override returns (address) {
836         return ownershipOf(tokenId).addr;
837     }
838 
839     /**
840      * @dev See {IERC721Metadata-name}.
841      */
842     function name() public view virtual override returns (string memory) {
843         return _name;
844     }
845 
846     /**
847      * @dev See {IERC721Metadata-symbol}.
848      */
849     function symbol() public view virtual override returns (string memory) {
850         return _symbol;
851     }
852 
853     /**
854      * @dev See {IERC721Metadata-tokenURI}.
855      */
856     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
857         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
858 
859         string memory baseURI = _baseURI();
860         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
861     }
862 
863     /**
864      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
865      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
866      * by default, can be overriden in child contracts.
867      */
868     function _baseURI() internal view virtual returns (string memory) {
869         return '';
870     }
871 
872     /**
873      * @dev See {IERC721-approve}.
874      */
875     function approve(address to, uint256 tokenId) public override {
876         address owner = ERC721A.ownerOf(tokenId);
877         if (to == owner) revert ApprovalToCurrentOwner();
878 
879         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
880             revert ApprovalCallerNotOwnerNorApproved();
881         }
882 
883         _approve(to, tokenId, owner);
884     }
885 
886     /**
887      * @dev See {IERC721-getApproved}.
888      */
889     function getApproved(uint256 tokenId) public view override returns (address) {
890         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
891 
892         return _tokenApprovals[tokenId];
893     }
894 
895     /**
896      * @dev See {IERC721-setApprovalForAll}.
897      */
898     function setApprovalForAll(address operator, bool approved) public override {
899         if (operator == _msgSender()) revert ApproveToCaller();
900 
901         _operatorApprovals[_msgSender()][operator] = approved;
902         emit ApprovalForAll(_msgSender(), operator, approved);
903     }
904 
905     /**
906      * @dev See {IERC721-isApprovedForAll}.
907      */
908     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
909         return _operatorApprovals[owner][operator];
910     }
911 
912     /**
913      * @dev See {IERC721-transferFrom}.
914      */
915     function transferFrom(
916         address from,
917         address to,
918         uint256 tokenId
919     ) public virtual override {
920         _transfer(from, to, tokenId);
921     }
922 
923     /**
924      * @dev See {IERC721-safeTransferFrom}.
925      */
926     function safeTransferFrom(
927         address from,
928         address to,
929         uint256 tokenId
930     ) public virtual override {
931         safeTransferFrom(from, to, tokenId, '');
932     }
933 
934     /**
935      * @dev See {IERC721-safeTransferFrom}.
936      */
937     function safeTransferFrom(
938         address from,
939         address to,
940         uint256 tokenId,
941         bytes memory _data
942     ) public virtual override {
943         _transfer(from, to, tokenId);
944         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
945             revert TransferToNonERC721ReceiverImplementer();
946         }
947     }
948 
949     /**
950      * @dev Returns whether `tokenId` exists.
951      *
952      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
953      *
954      * Tokens start existing when they are minted (`_mint`),
955      */
956     function _exists(uint256 tokenId) internal view returns (bool) {
957         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
958             !_ownerships[tokenId].burned;
959     }
960 
961     function _safeMint(address to, uint256 quantity) internal {
962         _safeMint(to, quantity, '');
963     }
964 
965     /**
966      * @dev Safely mints `quantity` tokens and transfers them to `to`.
967      *
968      * Requirements:
969      *
970      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
971      * - `quantity` must be greater than 0.
972      *
973      * Emits a {Transfer} event.
974      */
975     function _safeMint(
976         address to,
977         uint256 quantity,
978         bytes memory _data
979     ) internal {
980         _mint(to, quantity, _data, true);
981     }
982 
983     /**
984      * @dev Mints `quantity` tokens and transfers them to `to`.
985      *
986      * Requirements:
987      *
988      * - `to` cannot be the zero address.
989      * - `quantity` must be greater than 0.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _mint(
994         address to,
995         uint256 quantity,
996         bytes memory _data,
997         bool safe
998     ) internal {
999         uint256 startTokenId = _currentIndex;
1000         if (to == address(0)) revert MintToZeroAddress();
1001         if (quantity == 0) revert MintZeroQuantity();
1002 
1003         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1004 
1005         // Overflows are incredibly unrealistic.
1006         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1007         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1008         unchecked {
1009             _addressData[to].balance += uint64(quantity);
1010             _addressData[to].numberMinted += uint64(quantity);
1011 
1012             _ownerships[startTokenId].addr = to;
1013             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1014 
1015             uint256 updatedIndex = startTokenId;
1016             uint256 end = updatedIndex + quantity;
1017 
1018             if (safe && to.isContract()) {
1019                 do {
1020                     emit Transfer(address(0), to, updatedIndex);
1021                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1022                         revert TransferToNonERC721ReceiverImplementer();
1023                     }
1024                 } while (updatedIndex != end);
1025                 // Reentrancy protection
1026                 if (_currentIndex != startTokenId) revert();
1027             } else {
1028                 do {
1029                     emit Transfer(address(0), to, updatedIndex++);
1030                 } while (updatedIndex != end);
1031             }
1032             _currentIndex = updatedIndex;
1033         }
1034         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1035     }
1036 
1037     /**
1038      * @dev Transfers `tokenId` from `from` to `to`.
1039      *
1040      * Requirements:
1041      *
1042      * - `to` cannot be the zero address.
1043      * - `tokenId` token must be owned by `from`.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function _transfer(
1048         address from,
1049         address to,
1050         uint256 tokenId
1051     ) private {
1052         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1053 
1054         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1055             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1056             getApproved(tokenId) == _msgSender());
1057 
1058         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1059         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1060         if (to == address(0)) revert TransferToZeroAddress();
1061 
1062         _beforeTokenTransfers(from, to, tokenId, 1);
1063 
1064         // Clear approvals from the previous owner
1065         _approve(address(0), tokenId, prevOwnership.addr);
1066 
1067         // Underflow of the sender's balance is impossible because we check for
1068         // ownership above and the recipient's balance can't realistically overflow.
1069         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1070         unchecked {
1071             _addressData[from].balance -= 1;
1072             _addressData[to].balance += 1;
1073 
1074             _ownerships[tokenId].addr = to;
1075             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1076 
1077             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1078             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1079             uint256 nextTokenId = tokenId + 1;
1080             if (_ownerships[nextTokenId].addr == address(0)) {
1081                 // This will suffice for checking _exists(nextTokenId),
1082                 // as a burned slot cannot contain the zero address.
1083                 if (nextTokenId < _currentIndex) {
1084                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1085                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1086                 }
1087             }
1088         }
1089 
1090         emit Transfer(from, to, tokenId);
1091         _afterTokenTransfers(from, to, tokenId, 1);
1092     }
1093 
1094     /**
1095      * @dev Destroys `tokenId`.
1096      * The approval is cleared when the token is burned.
1097      *
1098      * Requirements:
1099      *
1100      * - `tokenId` must exist.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _burn(uint256 tokenId) internal virtual {
1105         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1106 
1107         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1108 
1109         // Clear approvals from the previous owner
1110         _approve(address(0), tokenId, prevOwnership.addr);
1111 
1112         // Underflow of the sender's balance is impossible because we check for
1113         // ownership above and the recipient's balance can't realistically overflow.
1114         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1115         unchecked {
1116             _addressData[prevOwnership.addr].balance -= 1;
1117             _addressData[prevOwnership.addr].numberBurned += 1;
1118 
1119             // Keep track of who burned the token, and the timestamp of burning.
1120             _ownerships[tokenId].addr = prevOwnership.addr;
1121             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1122             _ownerships[tokenId].burned = true;
1123 
1124             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1125             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1126             uint256 nextTokenId = tokenId + 1;
1127             if (_ownerships[nextTokenId].addr == address(0)) {
1128                 // This will suffice for checking _exists(nextTokenId),
1129                 // as a burned slot cannot contain the zero address.
1130                 if (nextTokenId < _currentIndex) {
1131                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1132                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1133                 }
1134             }
1135         }
1136 
1137         emit Transfer(prevOwnership.addr, address(0), tokenId);
1138         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1139 
1140         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1141         unchecked {
1142             _burnCounter++;
1143         }
1144     }
1145 
1146     /**
1147      * @dev Approve `to` to operate on `tokenId`
1148      *
1149      * Emits a {Approval} event.
1150      */
1151     function _approve(
1152         address to,
1153         uint256 tokenId,
1154         address owner
1155     ) private {
1156         _tokenApprovals[tokenId] = to;
1157         emit Approval(owner, to, tokenId);
1158     }
1159 
1160     /**
1161      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1162      *
1163      * @param from address representing the previous owner of the given token ID
1164      * @param to target address that will receive the tokens
1165      * @param tokenId uint256 ID of the token to be transferred
1166      * @param _data bytes optional data to send along with the call
1167      * @return bool whether the call correctly returned the expected magic value
1168      */
1169     function _checkContractOnERC721Received(
1170         address from,
1171         address to,
1172         uint256 tokenId,
1173         bytes memory _data
1174     ) private returns (bool) {
1175         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1176             return retval == IERC721Receiver(to).onERC721Received.selector;
1177         } catch (bytes memory reason) {
1178             if (reason.length == 0) {
1179                 revert TransferToNonERC721ReceiverImplementer();
1180             } else {
1181                 assembly {
1182                     revert(add(32, reason), mload(reason))
1183                 }
1184             }
1185         }
1186     }
1187 
1188     /**
1189      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1190      * And also called before burning one token.
1191      *
1192      * startTokenId - the first token id to be transferred
1193      * quantity - the amount to be transferred
1194      *
1195      * Calling conditions:
1196      *
1197      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1198      * transferred to `to`.
1199      * - When `from` is zero, `tokenId` will be minted for `to`.
1200      * - When `to` is zero, `tokenId` will be burned by `from`.
1201      * - `from` and `to` are never both zero.
1202      */
1203     function _beforeTokenTransfers(
1204         address from,
1205         address to,
1206         uint256 startTokenId,
1207         uint256 quantity
1208     ) internal virtual {}
1209 
1210     /**
1211      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1212      * minting.
1213      * And also called after one token has been burned.
1214      *
1215      * startTokenId - the first token id to be transferred
1216      * quantity - the amount to be transferred
1217      *
1218      * Calling conditions:
1219      *
1220      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1221      * transferred to `to`.
1222      * - When `from` is zero, `tokenId` has been minted for `to`.
1223      * - When `to` is zero, `tokenId` has been burned by `from`.
1224      * - `from` and `to` are never both zero.
1225      */
1226     function _afterTokenTransfers(
1227         address from,
1228         address to,
1229         uint256 startTokenId,
1230         uint256 quantity
1231     ) internal virtual {}
1232 }
1233 
1234 // File: @openzeppelin/contracts/access/Ownable.sol
1235 
1236 
1237 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1238 
1239 pragma solidity ^0.8.0;
1240 
1241 
1242 /**
1243  * @dev Contract module which provides a basic access control mechanism, where
1244  * there is an account (an owner) that can be granted exclusive access to
1245  * specific functions.
1246  *
1247  * By default, the owner account will be the one that deploys the contract. This
1248  * can later be changed with {transferOwnership}.
1249  *
1250  * This module is used through inheritance. It will make available the modifier
1251  * `onlyOwner`, which can be applied to your functions to restrict their use to
1252  * the owner.
1253  */
1254 abstract contract Ownable is Context {
1255     address private _owner;
1256 
1257     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1258 
1259     /**
1260      * @dev Initializes the contract setting the deployer as the initial owner.
1261      */
1262     constructor() {
1263         _transferOwnership(_msgSender());
1264     }
1265 
1266     /**
1267      * @dev Returns the address of the current owner.
1268      */
1269     function owner() public view virtual returns (address) {
1270         return _owner;
1271     }
1272 
1273     /**
1274      * @dev Throws if called by any account other than the owner.
1275      */
1276     modifier onlyOwner() {
1277         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1278         _;
1279     }
1280 
1281     /**
1282      * @dev Leaves the contract without owner. It will not be possible to call
1283      * `onlyOwner` functions anymore. Can only be called by the current owner.
1284      *
1285      * NOTE: Renouncing ownership will leave the contract without an owner,
1286      * thereby removing any functionality that is only available to the owner.
1287      */
1288     function renounceOwnership() public virtual onlyOwner {
1289         _transferOwnership(address(0));
1290     }
1291 
1292     /**
1293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1294      * Can only be called by the current owner.
1295      */
1296     function transferOwnership(address newOwner) public virtual onlyOwner {
1297         require(newOwner != address(0), "Ownable: new owner is the zero address");
1298         _transferOwnership(newOwner);
1299     }
1300 
1301     /**
1302      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1303      * Internal function without access restriction.
1304      */
1305     function _transferOwnership(address newOwner) internal virtual {
1306         address oldOwner = _owner;
1307         _owner = newOwner;
1308         emit OwnershipTransferred(oldOwner, newOwner);
1309     }
1310 }
1311 
1312 // File: contracts/cyberpunk_mfers.sol
1313 
1314 
1315 pragma solidity >=0.7.0 <0.9.0;
1316 
1317 
1318 
1319 
1320 contract cyberpunk_mfers is ERC721A, Ownable {
1321   using Strings for uint256;
1322 
1323   uint256 public cost = 0.02019 ether;
1324   uint256 public maxSupply = 10728;
1325   uint256 public maxMintAmountPerTx = 10;
1326   uint256 public freeMaxMintPerWallet = 5;
1327 
1328   uint256 FREE_MINT_MAX = 1049;
1329 
1330   mapping(address => uint256) public freeWallets;
1331 
1332   string _baseTokenURI;
1333 
1334   constructor(
1335     string memory _name,
1336     string memory _symbol,
1337     string memory baseURI
1338   ) ERC721A(_name, _symbol) {
1339       _baseTokenURI = baseURI;
1340   }
1341 
1342   modifier mfKnowsWhatTheyDoing(uint256 _mintAmount) {
1343     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded, MF!");
1344     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount, mf. Try something below 11.");
1345     _;
1346   }
1347 
1348   function mintForFree(uint256 _mintAmount) public mfKnowsWhatTheyDoing(_mintAmount) {
1349     require(isFreeMint(), "Too late for free mint, mf.");
1350     require(freeWallets[msg.sender] + _mintAmount <= freeMaxMintPerWallet, "You've already got enough for free, mf!");
1351     freeWallets[msg.sender] = freeWallets[msg.sender] + _mintAmount;
1352     _safeMint(msg.sender, _mintAmount);
1353   }
1354 
1355   function mintForMoney(uint256 _mintAmount)
1356     external
1357     payable
1358     mfKnowsWhatTheyDoing(_mintAmount)
1359   {
1360     require(msg.value >= cost * _mintAmount, "Damn, send more eth, mf.");
1361     _safeMint(msg.sender, _mintAmount);
1362 
1363     // Refund the mf if they sent more money. lol.
1364     if (msg.value > cost * _mintAmount) {
1365         payable(msg.sender).transfer(msg.value - (cost * _mintAmount));
1366     }
1367   }
1368 
1369   function isFreeMint() internal view returns (bool) {
1370     return totalSupply() <= FREE_MINT_MAX;
1371   }
1372   
1373   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1374     _safeMint(_receiver, _mintAmount);
1375   }
1376 
1377   function setCost(uint256 _cost) public onlyOwner {
1378     cost = _cost;
1379   }
1380 
1381   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1382     maxMintAmountPerTx = _maxMintAmountPerTx;
1383   }
1384 
1385   function setMaxFreeMint(uint256 _max) public onlyOwner {
1386     FREE_MINT_MAX = _max;
1387   }
1388 
1389   function withdraw() public onlyOwner {
1390     uint256 bal = address(this).balance;
1391     // Ukraine War Crisis Relief - check twitter.com/Ukraine for their official tweet on their address. And fuck Putin.
1392     (bool ukraine,) = payable(0x165CD37b4C644C2921454429E7F9358d18A45e14).call{value: bal * 15 / 100}("");
1393     require(ukraine);
1394     // Sartoshi address - The @sartoshi_nft - sartoshi.eth
1395     (bool sartoshi,) = payable(0xeD98464BDA3cE53a95B50f897556bEDE4316361c).call{value: bal * 10 / 100}("");
1396     require(sartoshi);
1397     // Creator
1398     (bool creator,) = payable(0xC62F73f7dcfF8Ac5Fb2287f26566a1533514C786).call{value: bal * 35 / 100}("");
1399     require(creator);
1400     // Deployer
1401     (bool deployer,) = payable(0xa3F61d1eEB1c5a1379a4DCf1890f71Ca835b9454).call{value: bal * 34 / 100}("");
1402     require(deployer);
1403     // Hashlips
1404     (bool hashlips,) = payable(0x943590A42C27D08e3744202c4Ae5eD55c2dE240D).call{value: bal * 5 / 100}("");
1405     require(hashlips);
1406     // Contract Dev
1407     (bool developer,) = payable(0x446B7f1EC4749fddAfC50CcaA0c8f82d4665FB61).call{value: bal * 1 / 100}("");
1408     require(developer);
1409     if (address(this).balance > 0) { // Fail-safe. Just in case my math skills have outskilled me.
1410       (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1411       require(os);
1412     }
1413   }
1414 
1415   // Metadata
1416   function _baseURI() internal view virtual override returns (string memory) {
1417     return _baseTokenURI;
1418   }
1419 
1420   function setBaseURI(string calldata baseURI) external onlyOwner {
1421     _baseTokenURI = baseURI;
1422   }
1423 
1424   function tokenURI(uint256 _tokenId)
1425     public
1426     view
1427     virtual
1428     override
1429     returns (string memory)
1430   {
1431     require(
1432       _exists(_tokenId),
1433       "ERC721Metadata: URI query for nonexistent token"
1434     );
1435 
1436     string memory currentBaseURI = _baseURI();
1437     return bytes(currentBaseURI).length > 0
1438         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
1439         : "";
1440   }
1441 
1442 }