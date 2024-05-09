1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
75 
76 pragma solidity ^0.8.1;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      *
99      * [IMPORTANT]
100      * ====
101      * You shouldn't rely on `isContract` to protect against flash loan attacks!
102      *
103      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
104      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
105      * constructor.
106      * ====
107      */
108     function isContract(address account) internal view returns (bool) {
109         // This method relies on extcodesize/address.code.length, which returns 0
110         // for contracts in construction, since the code is only stored at the end
111         // of the constructor execution.
112 
113         return account.code.length > 0;
114     }
115 
116     /**
117      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
118      * `recipient`, forwarding all available gas and reverting on errors.
119      *
120      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
121      * of certain opcodes, possibly making contracts go over the 2300 gas limit
122      * imposed by `transfer`, making them unable to receive funds via
123      * `transfer`. {sendValue} removes this limitation.
124      *
125      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
126      *
127      * IMPORTANT: because control is transferred to `recipient`, care must be
128      * taken to not create reentrancy vulnerabilities. Consider using
129      * {ReentrancyGuard} or the
130      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
131      */
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         (bool success, ) = recipient.call{value: amount}("");
136         require(success, "Address: unable to send value, recipient may have reverted");
137     }
138 
139     /**
140      * @dev Performs a Solidity function call using a low level `call`. A
141      * plain `call` is an unsafe replacement for a function call: use this
142      * function instead.
143      *
144      * If `target` reverts with a revert reason, it is bubbled up by this
145      * function (like regular Solidity function calls).
146      *
147      * Returns the raw returned data. To convert to the expected return value,
148      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
149      *
150      * Requirements:
151      *
152      * - `target` must be a contract.
153      * - calling `target` with `data` must not revert.
154      *
155      * _Available since v3.1._
156      */
157     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionCall(target, data, "Address: low-level call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
163      * `errorMessage` as a fallback revert reason when `target` reverts.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, 0, errorMessage);
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
177      * but also transferring `value` wei to `target`.
178      *
179      * Requirements:
180      *
181      * - the calling contract must have an ETH balance of at least `value`.
182      * - the called Solidity function must be `payable`.
183      *
184      * _Available since v3.1._
185      */
186     function functionCallWithValue(
187         address target,
188         bytes memory data,
189         uint256 value
190     ) internal returns (bytes memory) {
191         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
196      * with `errorMessage` as a fallback revert reason when `target` reverts.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(
201         address target,
202         bytes memory data,
203         uint256 value,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         require(address(this).balance >= value, "Address: insufficient balance for call");
207         require(isContract(target), "Address: call to non-contract");
208 
209         (bool success, bytes memory returndata) = target.call{value: value}(data);
210         return verifyCallResult(success, returndata, errorMessage);
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215      * but performing a static call.
216      *
217      * _Available since v3.3._
218      */
219     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
220         return functionStaticCall(target, data, "Address: low-level static call failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(
230         address target,
231         bytes memory data,
232         string memory errorMessage
233     ) internal view returns (bytes memory) {
234         require(isContract(target), "Address: static call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.staticcall(data);
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a delegate call.
243      *
244      * _Available since v3.4._
245      */
246     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
247         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal returns (bytes memory) {
261         require(isContract(target), "Address: delegate call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.delegatecall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
269      * revert reason using the provided one.
270      *
271      * _Available since v4.3._
272      */
273     function verifyCallResult(
274         bool success,
275         bytes memory returndata,
276         string memory errorMessage
277     ) internal pure returns (bytes memory) {
278         if (success) {
279             return returndata;
280         } else {
281             // Look for revert reason and bubble it up if present
282             if (returndata.length > 0) {
283                 // The easiest way to bubble the revert reason is using memory via assembly
284 
285                 assembly {
286                     let returndata_size := mload(returndata)
287                     revert(add(32, returndata), returndata_size)
288                 }
289             } else {
290                 revert(errorMessage);
291             }
292         }
293     }
294 }
295 
296 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
297 
298 
299 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @title ERC721 token receiver interface
305  * @dev Interface for any contract that wants to support safeTransfers
306  * from ERC721 asset contracts.
307  */
308 interface IERC721Receiver {
309     /**
310      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
311      * by `operator` from `from`, this function is called.
312      *
313      * It must return its Solidity selector to confirm the token transfer.
314      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
315      *
316      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
317      */
318     function onERC721Received(
319         address operator,
320         address from,
321         uint256 tokenId,
322         bytes calldata data
323     ) external returns (bytes4);
324 }
325 
326 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @dev Interface of the ERC165 standard, as defined in the
335  * https://eips.ethereum.org/EIPS/eip-165[EIP].
336  *
337  * Implementers can declare support of contract interfaces, which can then be
338  * queried by others ({ERC165Checker}).
339  *
340  * For an implementation, see {ERC165}.
341  */
342 interface IERC165 {
343     /**
344      * @dev Returns true if this contract implements the interface defined by
345      * `interfaceId`. See the corresponding
346      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
347      * to learn more about how these ids are created.
348      *
349      * This function call must use less than 30 000 gas.
350      */
351     function supportsInterface(bytes4 interfaceId) external view returns (bool);
352 }
353 
354 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 
362 /**
363  * @dev Implementation of the {IERC165} interface.
364  *
365  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
366  * for the additional interface id that will be supported. For example:
367  *
368  * ```solidity
369  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
370  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
371  * }
372  * ```
373  *
374  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
375  */
376 abstract contract ERC165 is IERC165 {
377     /**
378      * @dev See {IERC165-supportsInterface}.
379      */
380     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
381         return interfaceId == type(IERC165).interfaceId;
382     }
383 }
384 
385 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
386 
387 
388 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
389 
390 pragma solidity ^0.8.0;
391 
392 
393 /**
394  * @dev Required interface of an ERC721 compliant contract.
395  */
396 interface IERC721 is IERC165 {
397     /**
398      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
399      */
400     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
404      */
405     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
406 
407     /**
408      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
409      */
410     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
411 
412     /**
413      * @dev Returns the number of tokens in ``owner``'s account.
414      */
415     function balanceOf(address owner) external view returns (uint256 balance);
416 
417     /**
418      * @dev Returns the owner of the `tokenId` token.
419      *
420      * Requirements:
421      *
422      * - `tokenId` must exist.
423      */
424     function ownerOf(uint256 tokenId) external view returns (address owner);
425 
426     /**
427      * @dev Safely transfers `tokenId` token from `from` to `to`.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must exist and be owned by `from`.
434      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
435      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
436      *
437      * Emits a {Transfer} event.
438      */
439     function safeTransferFrom(
440         address from,
441         address to,
442         uint256 tokenId,
443         bytes calldata data
444     ) external;
445 
446     /**
447      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
448      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
449      *
450      * Requirements:
451      *
452      * - `from` cannot be the zero address.
453      * - `to` cannot be the zero address.
454      * - `tokenId` token must exist and be owned by `from`.
455      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
456      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
457      *
458      * Emits a {Transfer} event.
459      */
460     function safeTransferFrom(
461         address from,
462         address to,
463         uint256 tokenId
464     ) external;
465 
466     /**
467      * @dev Transfers `tokenId` token from `from` to `to`.
468      *
469      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
470      *
471      * Requirements:
472      *
473      * - `from` cannot be the zero address.
474      * - `to` cannot be the zero address.
475      * - `tokenId` token must be owned by `from`.
476      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
477      *
478      * Emits a {Transfer} event.
479      */
480     function transferFrom(
481         address from,
482         address to,
483         uint256 tokenId
484     ) external;
485 
486     /**
487      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
488      * The approval is cleared when the token is transferred.
489      *
490      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
491      *
492      * Requirements:
493      *
494      * - The caller must own the token or be an approved operator.
495      * - `tokenId` must exist.
496      *
497      * Emits an {Approval} event.
498      */
499     function approve(address to, uint256 tokenId) external;
500 
501     /**
502      * @dev Approve or remove `operator` as an operator for the caller.
503      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
504      *
505      * Requirements:
506      *
507      * - The `operator` cannot be the caller.
508      *
509      * Emits an {ApprovalForAll} event.
510      */
511     function setApprovalForAll(address operator, bool _approved) external;
512 
513     /**
514      * @dev Returns the account approved for `tokenId` token.
515      *
516      * Requirements:
517      *
518      * - `tokenId` must exist.
519      */
520     function getApproved(uint256 tokenId) external view returns (address operator);
521 
522     /**
523      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
524      *
525      * See {setApprovalForAll}
526      */
527     function isApprovedForAll(address owner, address operator) external view returns (bool);
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
540  * @dev See https://eips.ethereum.org/EIPS/eip-721
541  */
542 interface IERC721Metadata is IERC721 {
543     /**
544      * @dev Returns the token collection name.
545      */
546     function name() external view returns (string memory);
547 
548     /**
549      * @dev Returns the token collection symbol.
550      */
551     function symbol() external view returns (string memory);
552 
553     /**
554      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
555      */
556     function tokenURI(uint256 tokenId) external view returns (string memory);
557 }
558 
559 // File: erc721a/contracts/IERC721A.sol
560 
561 
562 // ERC721A Contracts v3.3.0
563 // Creator: Chiru Labs
564 
565 pragma solidity ^0.8.4;
566 
567 
568 
569 /**
570  * @dev Interface of an ERC721A compliant contract.
571  */
572 interface IERC721A is IERC721, IERC721Metadata {
573     /**
574      * The caller must own the token or be an approved operator.
575      */
576     error ApprovalCallerNotOwnerNorApproved();
577 
578     /**
579      * The token does not exist.
580      */
581     error ApprovalQueryForNonexistentToken();
582 
583     /**
584      * The caller cannot approve to their own address.
585      */
586     error ApproveToCaller();
587 
588     /**
589      * The caller cannot approve to the current owner.
590      */
591     error ApprovalToCurrentOwner();
592 
593     /**
594      * Cannot query the balance for the zero address.
595      */
596     error BalanceQueryForZeroAddress();
597 
598     /**
599      * Cannot mint to the zero address.
600      */
601     error MintToZeroAddress();
602 
603     /**
604      * The quantity of tokens minted must be more than zero.
605      */
606     error MintZeroQuantity();
607 
608     /**
609      * The token does not exist.
610      */
611     error OwnerQueryForNonexistentToken();
612 
613     /**
614      * The caller must own the token or be an approved operator.
615      */
616     error TransferCallerNotOwnerNorApproved();
617 
618     /**
619      * The token must be owned by `from`.
620      */
621     error TransferFromIncorrectOwner();
622 
623     /**
624      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
625      */
626     error TransferToNonERC721ReceiverImplementer();
627 
628     /**
629      * Cannot transfer to the zero address.
630      */
631     error TransferToZeroAddress();
632 
633     /**
634      * The token does not exist.
635      */
636     error URIQueryForNonexistentToken();
637 
638     // Compiler will pack this into a single 256bit word.
639     struct TokenOwnership {
640         // The address of the owner.
641         address addr;
642         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
643         uint64 startTimestamp;
644         // Whether the token has been burned.
645         bool burned;
646     }
647 
648     // Compiler will pack this into a single 256bit word.
649     struct AddressData {
650         // Realistically, 2**64-1 is more than enough.
651         uint64 balance;
652         // Keeps track of mint count with minimal overhead for tokenomics.
653         uint64 numberMinted;
654         // Keeps track of burn count with minimal overhead for tokenomics.
655         uint64 numberBurned;
656         // For miscellaneous variable(s) pertaining to the address
657         // (e.g. number of whitelist mint slots used).
658         // If there are multiple variables, please pack them into a uint64.
659         uint64 aux;
660     }
661 
662     /**
663      * @dev Returns the total amount of tokens stored by the contract.
664      * 
665      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
666      */
667     function totalSupply() external view returns (uint256);
668 }
669 
670 // File: @openzeppelin/contracts/utils/Context.sol
671 
672 
673 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
674 
675 pragma solidity ^0.8.0;
676 
677 /**
678  * @dev Provides information about the current execution context, including the
679  * sender of the transaction and its data. While these are generally available
680  * via msg.sender and msg.data, they should not be accessed in such a direct
681  * manner, since when dealing with meta-transactions the account sending and
682  * paying for execution may not be the actual sender (as far as an application
683  * is concerned).
684  *
685  * This contract is only required for intermediate, library-like contracts.
686  */
687 abstract contract Context {
688     function _msgSender() internal view virtual returns (address) {
689         return msg.sender;
690     }
691 
692     function _msgData() internal view virtual returns (bytes calldata) {
693         return msg.data;
694     }
695 }
696 
697 // File: erc721a/contracts/ERC721A.sol
698 
699 
700 // ERC721A Contracts v3.3.0
701 // Creator: Chiru Labs
702 
703 pragma solidity ^0.8.4;
704 
705 
706 
707 
708 
709 
710 
711 /**
712  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
713  * the Metadata extension. Built to optimize for lower gas during batch mints.
714  *
715  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
716  *
717  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
718  *
719  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
720  */
721 contract ERC721A is Context, ERC165, IERC721A {
722     using Address for address;
723     using Strings for uint256;
724 
725     // The tokenId of the next token to be minted.
726     uint256 internal _currentIndex;
727 
728     // The number of tokens burned.
729     uint256 internal _burnCounter;
730 
731     // Token name
732     string private _name;
733 
734     // Token symbol
735     string private _symbol;
736 
737     // Mapping from token ID to ownership details
738     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
739     mapping(uint256 => TokenOwnership) internal _ownerships;
740 
741     // Mapping owner address to address data
742     mapping(address => AddressData) private _addressData;
743 
744     // Mapping from token ID to approved address
745     mapping(uint256 => address) private _tokenApprovals;
746 
747     // Mapping from owner to operator approvals
748     mapping(address => mapping(address => bool)) private _operatorApprovals;
749 
750     constructor(string memory name_, string memory symbol_) {
751         _name = name_;
752         _symbol = symbol_;
753         _currentIndex = _startTokenId();
754     }
755 
756     /**
757      * To change the starting tokenId, please override this function.
758      */
759     function _startTokenId() internal view virtual returns (uint256) {
760         return 0;
761     }
762 
763     /**
764      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
765      */
766     function totalSupply() public view override returns (uint256) {
767         // Counter underflow is impossible as _burnCounter cannot be incremented
768         // more than _currentIndex - _startTokenId() times
769         unchecked {
770             return _currentIndex - _burnCounter - _startTokenId();
771         }
772     }
773 
774     /**
775      * Returns the total amount of tokens minted in the contract.
776      */
777     function _totalMinted() internal view returns (uint256) {
778         // Counter underflow is impossible as _currentIndex does not decrement,
779         // and it is initialized to _startTokenId()
780         unchecked {
781             return _currentIndex - _startTokenId();
782         }
783     }
784 
785     /**
786      * @dev See {IERC165-supportsInterface}.
787      */
788     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
789         return
790             interfaceId == type(IERC721).interfaceId ||
791             interfaceId == type(IERC721Metadata).interfaceId ||
792             super.supportsInterface(interfaceId);
793     }
794 
795     /**
796      * @dev See {IERC721-balanceOf}.
797      */
798     function balanceOf(address owner) public view override returns (uint256) {
799         if (owner == address(0)) revert BalanceQueryForZeroAddress();
800         return uint256(_addressData[owner].balance);
801     }
802 
803     /**
804      * Returns the number of tokens minted by `owner`.
805      */
806     function _numberMinted(address owner) internal view returns (uint256) {
807         return uint256(_addressData[owner].numberMinted);
808     }
809 
810     /**
811      * Returns the number of tokens burned by or on behalf of `owner`.
812      */
813     function _numberBurned(address owner) internal view returns (uint256) {
814         return uint256(_addressData[owner].numberBurned);
815     }
816 
817     /**
818      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
819      */
820     function _getAux(address owner) internal view returns (uint64) {
821         return _addressData[owner].aux;
822     }
823 
824     /**
825      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
826      * If there are multiple variables, please pack them into a uint64.
827      */
828     function _setAux(address owner, uint64 aux) internal {
829         _addressData[owner].aux = aux;
830     }
831 
832     /**
833      * Gas spent here starts off proportional to the maximum mint batch size.
834      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
835      */
836     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
837         uint256 curr = tokenId;
838 
839         unchecked {
840             if (_startTokenId() <= curr) if (curr < _currentIndex) {
841                 TokenOwnership memory ownership = _ownerships[curr];
842                 if (!ownership.burned) {
843                     if (ownership.addr != address(0)) {
844                         return ownership;
845                     }
846                     // Invariant:
847                     // There will always be an ownership that has an address and is not burned
848                     // before an ownership that does not have an address and is not burned.
849                     // Hence, curr will not underflow.
850                     while (true) {
851                         curr--;
852                         ownership = _ownerships[curr];
853                         if (ownership.addr != address(0)) {
854                             return ownership;
855                         }
856                     }
857                 }
858             }
859         }
860         revert OwnerQueryForNonexistentToken();
861     }
862 
863     /**
864      * @dev See {IERC721-ownerOf}.
865      */
866     function ownerOf(uint256 tokenId) public view override returns (address) {
867         return _ownershipOf(tokenId).addr;
868     }
869 
870     /**
871      * @dev See {IERC721Metadata-name}.
872      */
873     function name() public view virtual override returns (string memory) {
874         return _name;
875     }
876 
877     /**
878      * @dev See {IERC721Metadata-symbol}.
879      */
880     function symbol() public view virtual override returns (string memory) {
881         return _symbol;
882     }
883 
884     /**
885      * @dev See {IERC721Metadata-tokenURI}.
886      */
887     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
888         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
889 
890         string memory baseURI = _baseURI();
891         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
892     }
893 
894     /**
895      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
896      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
897      * by default, can be overriden in child contracts.
898      */
899     function _baseURI() internal view virtual returns (string memory) {
900         return '';
901     }
902 
903     /**
904      * @dev See {IERC721-approve}.
905      */
906     function approve(address to, uint256 tokenId) public override {
907         address owner = ERC721A.ownerOf(tokenId);
908         if (to == owner) revert ApprovalToCurrentOwner();
909 
910         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
911             revert ApprovalCallerNotOwnerNorApproved();
912         }
913 
914         _approve(to, tokenId, owner);
915     }
916 
917     /**
918      * @dev See {IERC721-getApproved}.
919      */
920     function getApproved(uint256 tokenId) public view override returns (address) {
921         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
922 
923         return _tokenApprovals[tokenId];
924     }
925 
926     /**
927      * @dev See {IERC721-setApprovalForAll}.
928      */
929     function setApprovalForAll(address operator, bool approved) public virtual override {
930         if (operator == _msgSender()) revert ApproveToCaller();
931 
932         _operatorApprovals[_msgSender()][operator] = approved;
933         emit ApprovalForAll(_msgSender(), operator, approved);
934     }
935 
936     /**
937      * @dev See {IERC721-isApprovedForAll}.
938      */
939     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
940         return _operatorApprovals[owner][operator];
941     }
942 
943     /**
944      * @dev See {IERC721-transferFrom}.
945      */
946     function transferFrom(
947         address from,
948         address to,
949         uint256 tokenId
950     ) public virtual override {
951         _transfer(from, to, tokenId);
952     }
953 
954     /**
955      * @dev See {IERC721-safeTransferFrom}.
956      */
957     function safeTransferFrom(
958         address from,
959         address to,
960         uint256 tokenId
961     ) public virtual override {
962         safeTransferFrom(from, to, tokenId, '');
963     }
964 
965     /**
966      * @dev See {IERC721-safeTransferFrom}.
967      */
968     function safeTransferFrom(
969         address from,
970         address to,
971         uint256 tokenId,
972         bytes memory _data
973     ) public virtual override {
974         _transfer(from, to, tokenId);
975         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
976             revert TransferToNonERC721ReceiverImplementer();
977         }
978     }
979 
980     /**
981      * @dev Returns whether `tokenId` exists.
982      *
983      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
984      *
985      * Tokens start existing when they are minted (`_mint`),
986      */
987     function _exists(uint256 tokenId) internal view returns (bool) {
988         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
989     }
990 
991     /**
992      * @dev Equivalent to `_safeMint(to, quantity, '')`.
993      */
994     function _safeMint(address to, uint256 quantity) internal {
995         _safeMint(to, quantity, '');
996     }
997 
998     /**
999      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1000      *
1001      * Requirements:
1002      *
1003      * - If `to` refers to a smart contract, it must implement
1004      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1005      * - `quantity` must be greater than 0.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _safeMint(
1010         address to,
1011         uint256 quantity,
1012         bytes memory _data
1013     ) internal {
1014         uint256 startTokenId = _currentIndex;
1015         if (to == address(0)) revert MintToZeroAddress();
1016         if (quantity == 0) revert MintZeroQuantity();
1017 
1018         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1019 
1020         // Overflows are incredibly unrealistic.
1021         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1022         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1023         unchecked {
1024             _addressData[to].balance += uint64(quantity);
1025             _addressData[to].numberMinted += uint64(quantity);
1026 
1027             _ownerships[startTokenId].addr = to;
1028             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1029 
1030             uint256 updatedIndex = startTokenId;
1031             uint256 end = updatedIndex + quantity;
1032 
1033             if (to.isContract()) {
1034                 do {
1035                     emit Transfer(address(0), to, updatedIndex);
1036                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1037                         revert TransferToNonERC721ReceiverImplementer();
1038                     }
1039                 } while (updatedIndex < end);
1040                 // Reentrancy protection
1041                 if (_currentIndex != startTokenId) revert();
1042             } else {
1043                 do {
1044                     emit Transfer(address(0), to, updatedIndex++);
1045                 } while (updatedIndex < end);
1046             }
1047             _currentIndex = updatedIndex;
1048         }
1049         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1050     }
1051 
1052     /**
1053      * @dev Mints `quantity` tokens and transfers them to `to`.
1054      *
1055      * Requirements:
1056      *
1057      * - `to` cannot be the zero address.
1058      * - `quantity` must be greater than 0.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _mint(address to, uint256 quantity) internal {
1063         uint256 startTokenId = _currentIndex;
1064         if (to == address(0)) revert MintToZeroAddress();
1065         if (quantity == 0) revert MintZeroQuantity();
1066 
1067         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1068 
1069         // Overflows are incredibly unrealistic.
1070         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1071         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1072         unchecked {
1073             _addressData[to].balance += uint64(quantity);
1074             _addressData[to].numberMinted += uint64(quantity);
1075 
1076             _ownerships[startTokenId].addr = to;
1077             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1078 
1079             uint256 updatedIndex = startTokenId;
1080             uint256 end = updatedIndex + quantity;
1081 
1082             do {
1083                 emit Transfer(address(0), to, updatedIndex++);
1084             } while (updatedIndex < end);
1085 
1086             _currentIndex = updatedIndex;
1087         }
1088         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1089     }
1090 
1091     /**
1092      * @dev Transfers `tokenId` from `from` to `to`.
1093      *
1094      * Requirements:
1095      *
1096      * - `to` cannot be the zero address.
1097      * - `tokenId` token must be owned by `from`.
1098      *
1099      * Emits a {Transfer} event.
1100      */
1101     function _transfer(
1102         address from,
1103         address to,
1104         uint256 tokenId
1105     ) private {
1106         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1107 
1108         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1109 
1110         bool isApprovedOrOwner = (_msgSender() == from ||
1111             isApprovedForAll(from, _msgSender()) ||
1112             getApproved(tokenId) == _msgSender());
1113 
1114         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1115         if (to == address(0)) revert TransferToZeroAddress();
1116 
1117         _beforeTokenTransfers(from, to, tokenId, 1);
1118 
1119         // Clear approvals from the previous owner
1120         _approve(address(0), tokenId, from);
1121 
1122         // Underflow of the sender's balance is impossible because we check for
1123         // ownership above and the recipient's balance can't realistically overflow.
1124         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1125         unchecked {
1126             _addressData[from].balance -= 1;
1127             _addressData[to].balance += 1;
1128 
1129             TokenOwnership storage currSlot = _ownerships[tokenId];
1130             currSlot.addr = to;
1131             currSlot.startTimestamp = uint64(block.timestamp);
1132 
1133             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1134             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1135             uint256 nextTokenId = tokenId + 1;
1136             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1137             if (nextSlot.addr == address(0)) {
1138                 // This will suffice for checking _exists(nextTokenId),
1139                 // as a burned slot cannot contain the zero address.
1140                 if (nextTokenId != _currentIndex) {
1141                     nextSlot.addr = from;
1142                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1143                 }
1144             }
1145         }
1146 
1147         emit Transfer(from, to, tokenId);
1148         _afterTokenTransfers(from, to, tokenId, 1);
1149     }
1150 
1151     /**
1152      * @dev Equivalent to `_burn(tokenId, false)`.
1153      */
1154     function _burn(uint256 tokenId) internal virtual {
1155         _burn(tokenId, false);
1156     }
1157 
1158     /**
1159      * @dev Destroys `tokenId`.
1160      * The approval is cleared when the token is burned.
1161      *
1162      * Requirements:
1163      *
1164      * - `tokenId` must exist.
1165      *
1166      * Emits a {Transfer} event.
1167      */
1168     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1169         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1170 
1171         address from = prevOwnership.addr;
1172 
1173         if (approvalCheck) {
1174             bool isApprovedOrOwner = (_msgSender() == from ||
1175                 isApprovedForAll(from, _msgSender()) ||
1176                 getApproved(tokenId) == _msgSender());
1177 
1178             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1179         }
1180 
1181         _beforeTokenTransfers(from, address(0), tokenId, 1);
1182 
1183         // Clear approvals from the previous owner
1184         _approve(address(0), tokenId, from);
1185 
1186         // Underflow of the sender's balance is impossible because we check for
1187         // ownership above and the recipient's balance can't realistically overflow.
1188         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1189         unchecked {
1190             AddressData storage addressData = _addressData[from];
1191             addressData.balance -= 1;
1192             addressData.numberBurned += 1;
1193 
1194             // Keep track of who burned the token, and the timestamp of burning.
1195             TokenOwnership storage currSlot = _ownerships[tokenId];
1196             currSlot.addr = from;
1197             currSlot.startTimestamp = uint64(block.timestamp);
1198             currSlot.burned = true;
1199 
1200             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1201             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1202             uint256 nextTokenId = tokenId + 1;
1203             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1204             if (nextSlot.addr == address(0)) {
1205                 // This will suffice for checking _exists(nextTokenId),
1206                 // as a burned slot cannot contain the zero address.
1207                 if (nextTokenId != _currentIndex) {
1208                     nextSlot.addr = from;
1209                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1210                 }
1211             }
1212         }
1213 
1214         emit Transfer(from, address(0), tokenId);
1215         _afterTokenTransfers(from, address(0), tokenId, 1);
1216 
1217         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1218         unchecked {
1219             _burnCounter++;
1220         }
1221     }
1222 
1223     /**
1224      * @dev Approve `to` to operate on `tokenId`
1225      *
1226      * Emits a {Approval} event.
1227      */
1228     function _approve(
1229         address to,
1230         uint256 tokenId,
1231         address owner
1232     ) private {
1233         _tokenApprovals[tokenId] = to;
1234         emit Approval(owner, to, tokenId);
1235     }
1236 
1237     /**
1238      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1239      *
1240      * @param from address representing the previous owner of the given token ID
1241      * @param to target address that will receive the tokens
1242      * @param tokenId uint256 ID of the token to be transferred
1243      * @param _data bytes optional data to send along with the call
1244      * @return bool whether the call correctly returned the expected magic value
1245      */
1246     function _checkContractOnERC721Received(
1247         address from,
1248         address to,
1249         uint256 tokenId,
1250         bytes memory _data
1251     ) private returns (bool) {
1252         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1253             return retval == IERC721Receiver(to).onERC721Received.selector;
1254         } catch (bytes memory reason) {
1255             if (reason.length == 0) {
1256                 revert TransferToNonERC721ReceiverImplementer();
1257             } else {
1258                 assembly {
1259                     revert(add(32, reason), mload(reason))
1260                 }
1261             }
1262         }
1263     }
1264 
1265     /**
1266      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1267      * And also called before burning one token.
1268      *
1269      * startTokenId - the first token id to be transferred
1270      * quantity - the amount to be transferred
1271      *
1272      * Calling conditions:
1273      *
1274      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1275      * transferred to `to`.
1276      * - When `from` is zero, `tokenId` will be minted for `to`.
1277      * - When `to` is zero, `tokenId` will be burned by `from`.
1278      * - `from` and `to` are never both zero.
1279      */
1280     function _beforeTokenTransfers(
1281         address from,
1282         address to,
1283         uint256 startTokenId,
1284         uint256 quantity
1285     ) internal virtual {}
1286 
1287     /**
1288      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1289      * minting.
1290      * And also called after one token has been burned.
1291      *
1292      * startTokenId - the first token id to be transferred
1293      * quantity - the amount to be transferred
1294      *
1295      * Calling conditions:
1296      *
1297      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1298      * transferred to `to`.
1299      * - When `from` is zero, `tokenId` has been minted for `to`.
1300      * - When `to` is zero, `tokenId` has been burned by `from`.
1301      * - `from` and `to` are never both zero.
1302      */
1303     function _afterTokenTransfers(
1304         address from,
1305         address to,
1306         uint256 startTokenId,
1307         uint256 quantity
1308     ) internal virtual {}
1309 }
1310 
1311 // File: @openzeppelin/contracts/access/Ownable.sol
1312 
1313 
1314 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1315 
1316 pragma solidity ^0.8.0;
1317 
1318 
1319 /**
1320  * @dev Contract module which provides a basic access control mechanism, where
1321  * there is an account (an owner) that can be granted exclusive access to
1322  * specific functions.
1323  *
1324  * By default, the owner account will be the one that deploys the contract. This
1325  * can later be changed with {transferOwnership}.
1326  *
1327  * This module is used through inheritance. It will make available the modifier
1328  * `onlyOwner`, which can be applied to your functions to restrict their use to
1329  * the owner.
1330  */
1331 abstract contract Ownable is Context {
1332     address private _owner;
1333 
1334     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1335 
1336     /**
1337      * @dev Initializes the contract setting the deployer as the initial owner.
1338      */
1339     constructor() {
1340         _transferOwnership(_msgSender());
1341     }
1342 
1343     /**
1344      * @dev Returns the address of the current owner.
1345      */
1346     function owner() public view virtual returns (address) {
1347         return _owner;
1348     }
1349 
1350     /**
1351      * @dev Throws if called by any account other than the owner.
1352      */
1353     modifier onlyOwner() {
1354         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1355         _;
1356     }
1357 
1358     /**
1359      * @dev Leaves the contract without owner. It will not be possible to call
1360      * `onlyOwner` functions anymore. Can only be called by the current owner.
1361      *
1362      * NOTE: Renouncing ownership will leave the contract without an owner,
1363      * thereby removing any functionality that is only available to the owner.
1364      */
1365     function renounceOwnership() public virtual onlyOwner {
1366         _transferOwnership(address(0));
1367     }
1368 
1369     /**
1370      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1371      * Can only be called by the current owner.
1372      */
1373     function transferOwnership(address newOwner) public virtual onlyOwner {
1374         require(newOwner != address(0), "Ownable: new owner is the zero address");
1375         _transferOwnership(newOwner);
1376     }
1377 
1378     /**
1379      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1380      * Internal function without access restriction.
1381      */
1382     function _transferOwnership(address newOwner) internal virtual {
1383         address oldOwner = _owner;
1384         _owner = newOwner;
1385         emit OwnershipTransferred(oldOwner, newOwner);
1386     }
1387 }
1388 
1389 
1390 
1391 pragma solidity ^0.8.0;
1392 
1393 
1394 
1395 contract GoblinRocks is ERC721A, Ownable {
1396 	using Strings for uint;
1397 
1398 	uint public constant MINT_PRICE = 0.005 ether;
1399 	uint public constant MAX_NFT_PER_TRAN = 10;
1400 	uint public constant MAX_FREE = 2;
1401 	address private immutable SPLITTER_ADDRESS;
1402 	uint public maxSupply = 4000;
1403 
1404 	bool public isPaused;
1405     bool public isMetadataFinal;
1406     string private _baseURL;
1407 	string public prerevealURL = '';
1408 	mapping(address => uint) private _walletMintedCount;
1409 
1410 	constructor(address splitterAddress)
1411     // Name
1412 	ERC721A('GoblinRocks', 'GROCKS') {
1413         SPLITTER_ADDRESS = splitterAddress;
1414     }
1415 
1416 	function _baseURI() internal view override returns (string memory) {
1417 		return _baseURL;
1418 	}
1419 
1420 	function _startTokenId() internal pure override returns (uint) {
1421 		return 1;
1422 	}
1423 
1424 	function contractURI() public pure returns (string memory) {
1425 		return "";
1426 	}
1427 
1428     function finalizeMetadata() external onlyOwner {
1429         isMetadataFinal = true;
1430     }
1431 
1432 	function reveal(string memory url) external onlyOwner {
1433         require(!isMetadataFinal, "Metadata is finalized");
1434 		_baseURL = url;
1435 	}
1436 
1437     function mintedCount(address owner) external view returns (uint) {
1438         return _walletMintedCount[owner];
1439     }
1440 
1441 	function setPause(bool value) external onlyOwner {
1442 		isPaused = value;
1443 	}
1444 
1445 	function withdraw() external onlyOwner {
1446 		uint balance = address(this).balance;
1447 		require(balance > 0, 'No balance');
1448 		payable(SPLITTER_ADDRESS).transfer(balance);
1449 	}
1450 
1451 	function airdrop(address to, uint count) external onlyOwner {
1452 		require(
1453 			_totalMinted() + count <= maxSupply,
1454 			'Exceeds max supply'
1455 		);
1456 		_safeMint(to, count);
1457 	}
1458 
1459 	function reduceSupply(uint newMaxSupply) external onlyOwner {
1460 		maxSupply = newMaxSupply;
1461 	}
1462 
1463 	function tokenURI(uint tokenId)
1464 		public
1465 		view
1466 		override
1467 		returns (string memory)
1468 	{
1469         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1470 
1471         return bytes(_baseURI()).length > 0 
1472             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1473             : prerevealURL;
1474 	}
1475 
1476 	function mint(uint count) external payable {
1477 		require(!isPaused, 'Sales are off');
1478 		require(count <= MAX_NFT_PER_TRAN,'Exceeds NFT per transaction limit');
1479 		require(_totalMinted() + count <= maxSupply,'Exceeds max supply');
1480 
1481         uint payForCount = count;
1482         uint mintedSoFar = _walletMintedCount[msg.sender];
1483         if(mintedSoFar < MAX_FREE) {
1484             uint remainingFreeMints = MAX_FREE - mintedSoFar;
1485             if(count > remainingFreeMints) {
1486                 payForCount = count - remainingFreeMints;
1487             }
1488             else {
1489                 payForCount = 0;
1490             }
1491         }
1492 
1493 		require(
1494 			msg.value >= payForCount * MINT_PRICE,
1495 			'Ether value sent is not sufficient'
1496 		);
1497 
1498 		_walletMintedCount[msg.sender] += count;
1499 		_safeMint(msg.sender, count);
1500 	}
1501 }