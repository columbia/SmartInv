1 // Sources flattened with hardhat v2.10.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.0
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
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
31 
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.0
33 
34 
35 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId,
89         bytes calldata data
90     ) external;
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
101      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
102      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
103      *
104      * Emits a {Transfer} event.
105      */
106     function safeTransferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Transfers `tokenId` token from `from` to `to`.
114      *
115      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
116      *
117      * Requirements:
118      *
119      * - `from` cannot be the zero address.
120      * - `to` cannot be the zero address.
121      * - `tokenId` token must be owned by `from`.
122      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transferFrom(
127         address from,
128         address to,
129         uint256 tokenId
130     ) external;
131 
132     /**
133      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
134      * The approval is cleared when the token is transferred.
135      *
136      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
137      *
138      * Requirements:
139      *
140      * - The caller must own the token or be an approved operator.
141      * - `tokenId` must exist.
142      *
143      * Emits an {Approval} event.
144      */
145     function approve(address to, uint256 tokenId) external;
146 
147     /**
148      * @dev Approve or remove `operator` as an operator for the caller.
149      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
150      *
151      * Requirements:
152      *
153      * - The `operator` cannot be the caller.
154      *
155      * Emits an {ApprovalForAll} event.
156      */
157     function setApprovalForAll(address operator, bool _approved) external;
158 
159     /**
160      * @dev Returns the account approved for `tokenId` token.
161      *
162      * Requirements:
163      *
164      * - `tokenId` must exist.
165      */
166     function getApproved(uint256 tokenId) external view returns (address operator);
167 
168     /**
169      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
170      *
171      * See {setApprovalForAll}
172      */
173     function isApprovedForAll(address owner, address operator) external view returns (bool);
174 }
175 
176 
177 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.7.0
178 
179 
180 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
181 
182 pragma solidity ^0.8.0;
183 
184 /**
185  * @title ERC721 token receiver interface
186  * @dev Interface for any contract that wants to support safeTransfers
187  * from ERC721 asset contracts.
188  */
189 interface IERC721Receiver {
190     /**
191      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
192      * by `operator` from `from`, this function is called.
193      *
194      * It must return its Solidity selector to confirm the token transfer.
195      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
196      *
197      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
198      */
199     function onERC721Received(
200         address operator,
201         address from,
202         uint256 tokenId,
203         bytes calldata data
204     ) external returns (bytes4);
205 }
206 
207 
208 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.7.0
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
217  * @dev See https://eips.ethereum.org/EIPS/eip-721
218  */
219 interface IERC721Metadata is IERC721 {
220     /**
221      * @dev Returns the token collection name.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the token collection symbol.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
232      */
233     function tokenURI(uint256 tokenId) external view returns (string memory);
234 }
235 
236 
237 // File @openzeppelin/contracts/utils/Address.sol@v4.7.0
238 
239 
240 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
241 
242 pragma solidity ^0.8.1;
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      *
265      * [IMPORTANT]
266      * ====
267      * You shouldn't rely on `isContract` to protect against flash loan attacks!
268      *
269      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
270      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
271      * constructor.
272      * ====
273      */
274     function isContract(address account) internal view returns (bool) {
275         // This method relies on extcodesize/address.code.length, which returns 0
276         // for contracts in construction, since the code is only stored at the end
277         // of the constructor execution.
278 
279         return account.code.length > 0;
280     }
281 
282     /**
283      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
284      * `recipient`, forwarding all available gas and reverting on errors.
285      *
286      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
287      * of certain opcodes, possibly making contracts go over the 2300 gas limit
288      * imposed by `transfer`, making them unable to receive funds via
289      * `transfer`. {sendValue} removes this limitation.
290      *
291      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
292      *
293      * IMPORTANT: because control is transferred to `recipient`, care must be
294      * taken to not create reentrancy vulnerabilities. Consider using
295      * {ReentrancyGuard} or the
296      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         (bool success, ) = recipient.call{value: amount}("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain `call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324         return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(
334         address target,
335         bytes memory data,
336         string memory errorMessage
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, 0, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but also transferring `value` wei to `target`.
344      *
345      * Requirements:
346      *
347      * - the calling contract must have an ETH balance of at least `value`.
348      * - the called Solidity function must be `payable`.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value
356     ) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(
367         address target,
368         bytes memory data,
369         uint256 value,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         require(isContract(target), "Address: call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.call{value: value}(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
386         return functionStaticCall(target, data, "Address: low-level static call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
391      * but performing a static call.
392      *
393      * _Available since v3.3._
394      */
395     function functionStaticCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal view returns (bytes memory) {
400         require(isContract(target), "Address: static call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.staticcall(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
413         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418      * but performing a delegate call.
419      *
420      * _Available since v3.4._
421      */
422     function functionDelegateCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         require(isContract(target), "Address: delegate call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.delegatecall(data);
430         return verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
435      * revert reason using the provided one.
436      *
437      * _Available since v4.3._
438      */
439     function verifyCallResult(
440         bool success,
441         bytes memory returndata,
442         string memory errorMessage
443     ) internal pure returns (bytes memory) {
444         if (success) {
445             return returndata;
446         } else {
447             // Look for revert reason and bubble it up if present
448             if (returndata.length > 0) {
449                 // The easiest way to bubble the revert reason is using memory via assembly
450                 /// @solidity memory-safe-assembly
451                 assembly {
452                     let returndata_size := mload(returndata)
453                     revert(add(32, returndata), returndata_size)
454                 }
455             } else {
456                 revert(errorMessage);
457             }
458         }
459     }
460 }
461 
462 
463 // File @openzeppelin/contracts/utils/Context.sol@v4.7.0
464 
465 
466 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @dev Provides information about the current execution context, including the
472  * sender of the transaction and its data. While these are generally available
473  * via msg.sender and msg.data, they should not be accessed in such a direct
474  * manner, since when dealing with meta-transactions the account sending and
475  * paying for execution may not be the actual sender (as far as an application
476  * is concerned).
477  *
478  * This contract is only required for intermediate, library-like contracts.
479  */
480 abstract contract Context {
481     function _msgSender() internal view virtual returns (address) {
482         return msg.sender;
483     }
484 
485     function _msgData() internal view virtual returns (bytes calldata) {
486         return msg.data;
487     }
488 }
489 
490 
491 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.0
492 
493 
494 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 /**
499  * @dev String operations.
500  */
501 library Strings {
502     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
503     uint8 private constant _ADDRESS_LENGTH = 20;
504 
505     /**
506      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
507      */
508     function toString(uint256 value) internal pure returns (string memory) {
509         // Inspired by OraclizeAPI's implementation - MIT licence
510         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
511 
512         if (value == 0) {
513             return "0";
514         }
515         uint256 temp = value;
516         uint256 digits;
517         while (temp != 0) {
518             digits++;
519             temp /= 10;
520         }
521         bytes memory buffer = new bytes(digits);
522         while (value != 0) {
523             digits -= 1;
524             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
525             value /= 10;
526         }
527         return string(buffer);
528     }
529 
530     /**
531      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
532      */
533     function toHexString(uint256 value) internal pure returns (string memory) {
534         if (value == 0) {
535             return "0x00";
536         }
537         uint256 temp = value;
538         uint256 length = 0;
539         while (temp != 0) {
540             length++;
541             temp >>= 8;
542         }
543         return toHexString(value, length);
544     }
545 
546     /**
547      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
548      */
549     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
550         bytes memory buffer = new bytes(2 * length + 2);
551         buffer[0] = "0";
552         buffer[1] = "x";
553         for (uint256 i = 2 * length + 1; i > 1; --i) {
554             buffer[i] = _HEX_SYMBOLS[value & 0xf];
555             value >>= 4;
556         }
557         require(value == 0, "Strings: hex length insufficient");
558         return string(buffer);
559     }
560 
561     /**
562      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
563      */
564     function toHexString(address addr) internal pure returns (string memory) {
565         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
566     }
567 }
568 
569 
570 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.0
571 
572 
573 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
574 
575 pragma solidity ^0.8.0;
576 
577 /**
578  * @dev Implementation of the {IERC165} interface.
579  *
580  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
581  * for the additional interface id that will be supported. For example:
582  *
583  * ```solidity
584  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
585  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
586  * }
587  * ```
588  *
589  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
590  */
591 abstract contract ERC165 is IERC165 {
592     /**
593      * @dev See {IERC165-supportsInterface}.
594      */
595     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
596         return interfaceId == type(IERC165).interfaceId;
597     }
598 }
599 
600 
601 // File contracts/ERC721A.sol
602 
603 
604 // Creator: Chiru Labs
605 
606 pragma solidity ^0.8.4;
607 
608 
609 
610 
611 
612 
613 
614 error ApprovalCallerNotOwnerNorApproved();
615 error ApprovalQueryForNonexistentToken();
616 error ApproveToCaller();
617 error ApprovalToCurrentOwner();
618 error BalanceQueryForZeroAddress();
619 error MintToZeroAddress();
620 error MintZeroQuantity();
621 error OwnerQueryForNonexistentToken();
622 error TransferCallerNotOwnerNorApproved();
623 error TransferFromIncorrectOwner();
624 error TransferToNonERC721ReceiverImplementer();
625 error TransferToZeroAddress();
626 error URIQueryForNonexistentToken();
627 
628 /**
629  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
630  * the Metadata extension. Built to optimize for lower gas during batch mints.
631  *
632  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
633  *
634  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
635  *
636  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
637  */
638 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
639     using Address for address;
640     using Strings for uint256;
641 
642     // Compiler will pack this into a single 256bit word.
643     struct TokenOwnership {
644         // The address of the owner.
645         address addr;
646         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
647         uint64 startTimestamp;
648         // Whether the token has been burned.
649         bool burned;
650     }
651 
652     // Compiler will pack this into a single 256bit word.
653     struct AddressData {
654         // Realistically, 2**64-1 is more than enough.
655         uint64 balance;
656         // Keeps track of mint count with minimal overhead for tokenomics.
657         uint64 numberMinted;
658         // Keeps track of burn count with minimal overhead for tokenomics.
659         uint64 numberBurned;
660         // For miscellaneous variable(s) pertaining to the address
661         // (e.g. number of whitelist mint slots used).
662         // If there are multiple variables, please pack them into a uint64.
663         uint64 aux;
664     }
665 
666     // The tokenId of the next token to be minted.
667     uint256 internal _currentIndex;
668 
669     // The number of tokens burned.
670     uint256 internal _burnCounter;
671 
672     // Token name
673     string private _name;
674 
675     // Token symbol
676     string private _symbol;
677 
678     // Mapping from token ID to ownership details
679     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
680     mapping(uint256 => TokenOwnership) internal _ownerships;
681 
682     // Mapping owner address to address data
683     mapping(address => AddressData) private _addressData;
684 
685     // Mapping from token ID to approved address
686     mapping(uint256 => address) private _tokenApprovals;
687 
688     // Mapping from owner to operator approvals
689     mapping(address => mapping(address => bool)) internal _operatorApprovals;
690 
691     constructor(string memory name_, string memory symbol_) {
692         _name = name_;
693         _symbol = symbol_;
694         _currentIndex = _startTokenId();
695     }
696 
697     /**
698      * To change the starting tokenId, please override this function.
699      */
700     function _startTokenId() internal view virtual returns (uint256) {
701         return 0;
702     }
703 
704     /**
705      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
706      */
707     function totalSupply() public view returns (uint256) {
708         // Counter underflow is impossible as _burnCounter cannot be incremented
709         // more than _currentIndex - _startTokenId() times
710         unchecked {
711             return _currentIndex - _burnCounter - _startTokenId();
712         }
713     }
714 
715     /**
716      * Returns the total amount of tokens minted in the contract.
717      */
718     function _totalMinted() internal view returns (uint256) {
719         // Counter underflow is impossible as _currentIndex does not decrement,
720         // and it is initialized to _startTokenId()
721         unchecked {
722             return _currentIndex - _startTokenId();
723         }
724     }
725 
726     /**
727      * @dev See {IERC165-supportsInterface}.
728      */
729     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
730         return
731             interfaceId == type(IERC721).interfaceId ||
732             interfaceId == type(IERC721Metadata).interfaceId ||
733             super.supportsInterface(interfaceId);
734     }
735 
736     /**
737      * @dev See {IERC721-balanceOf}.
738      */
739     function balanceOf(address owner) public view override returns (uint256) {
740         if (owner == address(0)) revert BalanceQueryForZeroAddress();
741         return uint256(_addressData[owner].balance);
742     }
743 
744     /**
745      * Returns the number of tokens minted by `owner`.
746      */
747     function _numberMinted(address owner) internal view returns (uint256) {
748         return uint256(_addressData[owner].numberMinted);
749     }
750 
751     /**
752      * Returns the number of tokens burned by or on behalf of `owner`.
753      */
754     function _numberBurned(address owner) internal view returns (uint256) {
755         return uint256(_addressData[owner].numberBurned);
756     }
757 
758     /**
759      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
760      */
761     function _getAux(address owner) internal view returns (uint64) {
762         return _addressData[owner].aux;
763     }
764 
765     /**
766      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
767      * If there are multiple variables, please pack them into a uint64.
768      */
769     function _setAux(address owner, uint64 aux) internal {
770         _addressData[owner].aux = aux;
771     }
772 
773     /**
774      * Gas spent here starts off proportional to the maximum mint batch size.
775      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
776      */
777     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
778         uint256 curr = tokenId;
779 
780         unchecked {
781             if (_startTokenId() <= curr && curr < _currentIndex) {
782                 TokenOwnership memory ownership = _ownerships[curr];
783                 if (!ownership.burned) {
784                     if (ownership.addr != address(0)) {
785                         return ownership;
786                     }
787                     // Invariant:
788                     // There will always be an ownership that has an address and is not burned
789                     // before an ownership that does not have an address and is not burned.
790                     // Hence, curr will not underflow.
791                     while (true) {
792                         curr--;
793                         ownership = _ownerships[curr];
794                         if (ownership.addr != address(0)) {
795                             return ownership;
796                         }
797                     }
798                 }
799             }
800         }
801         revert OwnerQueryForNonexistentToken();
802     }
803 
804     /**
805      * @dev See {IERC721-ownerOf}.
806      */
807     function ownerOf(uint256 tokenId) public view override returns (address) {
808         return _ownershipOf(tokenId).addr;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-name}.
813      */
814     function name() public view virtual override returns (string memory) {
815         return _name;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-symbol}.
820      */
821     function symbol() public view virtual override returns (string memory) {
822         return _symbol;
823     }
824 
825     /**
826      * @dev See {IERC721Metadata-tokenURI}.
827      */
828     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
829         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
830 
831         string memory baseURI = _baseURI();
832         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
833     }
834 
835     /**
836      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
837      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
838      * by default, can be overriden in child contracts.
839      */
840     function _baseURI() internal view virtual returns (string memory) {
841         return '';
842     }
843 
844     /**
845      * @dev See {IERC721-approve}.
846      */
847     function approve(address to, uint256 tokenId) public  virtual {}
848 
849     /**
850      * @dev See {IERC721-getApproved}.
851      */
852     function getApproved(uint256 tokenId) public view override returns (address) {
853         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
854 
855         return _tokenApprovals[tokenId];
856     }
857 
858     /**
859      * @dev See {IERC721-setApprovalForAll}.
860      */
861     function setApprovalForAll(address operator, bool approved) public virtual  {}
862 
863     /**
864      * @dev See {IERC721-isApprovedForAll}.
865      */
866     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
867         return _operatorApprovals[owner][operator];
868     }
869 
870     /**
871      * @dev See {IERC721-transferFrom}.
872      */
873     function transferFrom(
874         address from,
875         address to,
876         uint256 tokenId
877     ) public virtual override {
878         _transfer(from, to, tokenId);
879     }
880 
881     /**
882      * @dev See {IERC721-safeTransferFrom}.
883      */
884     function safeTransferFrom(
885         address from,
886         address to,
887         uint256 tokenId
888     ) public virtual override {
889         safeTransferFrom(from, to, tokenId, '');
890     }
891 
892     /**
893      * @dev See {IERC721-safeTransferFrom}.
894      */
895     function safeTransferFrom(
896         address from,
897         address to,
898         uint256 tokenId,
899         bytes memory _data
900     ) public virtual override {
901         _transfer(from, to, tokenId);
902         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
903             revert TransferToNonERC721ReceiverImplementer();
904         }
905     }
906 
907     /**
908      * @dev Returns whether `tokenId` exists.
909      *
910      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
911      *
912      * Tokens start existing when they are minted (`_mint`),
913      */
914     function _exists(uint256 tokenId) internal view returns (bool) {
915         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
916     }
917 
918     /**
919      * @dev Equivalent to `_safeMint(to, quantity, '')`.
920      */
921     function _safeMint(address to, uint256 quantity) internal {
922         _safeMint(to, quantity, '');
923     }
924 
925     /**
926      * @dev Safely mints `quantity` tokens and transfers them to `to`.
927      *
928      * Requirements:
929      *
930      * - If `to` refers to a smart contract, it must implement
931      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
932      * - `quantity` must be greater than 0.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _safeMint(
937         address to,
938         uint256 quantity,
939         bytes memory _data
940     ) internal {
941         uint256 startTokenId = _currentIndex;
942         if (to == address(0)) revert MintToZeroAddress();
943         if (quantity == 0) revert MintZeroQuantity();
944 
945         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
946 
947         // Overflows are incredibly unrealistic.
948         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
949         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
950         unchecked {
951             _addressData[to].balance += uint64(quantity);
952             _addressData[to].numberMinted += uint64(quantity);
953 
954             _ownerships[startTokenId].addr = to;
955             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
956 
957             uint256 updatedIndex = startTokenId;
958             uint256 end = updatedIndex + quantity;
959 
960             if (to.isContract()) {
961                 do {
962                     emit Transfer(address(0), to, updatedIndex);
963                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
964                         revert TransferToNonERC721ReceiverImplementer();
965                     }
966                 } while (updatedIndex != end);
967                 // Reentrancy protection
968                 if (_currentIndex != startTokenId) revert();
969             } else {
970                 do {
971                     emit Transfer(address(0), to, updatedIndex++);
972                 } while (updatedIndex != end);
973             }
974             _currentIndex = updatedIndex;
975         }
976         _afterTokenTransfers(address(0), to, startTokenId, quantity);
977     }
978 
979     /**
980      * @dev Mints `quantity` tokens and transfers them to `to`.
981      *
982      * Requirements:
983      *
984      * - `to` cannot be the zero address.
985      * - `quantity` must be greater than 0.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _mint(address to, uint256 quantity) internal {
990         uint256 startTokenId = _currentIndex;
991         if (to == address(0)) revert MintToZeroAddress();
992         if (quantity == 0) revert MintZeroQuantity();
993 
994         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
995 
996         // Overflows are incredibly unrealistic.
997         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
998         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
999         unchecked {
1000             _addressData[to].balance += uint64(quantity);
1001             _addressData[to].numberMinted += uint64(quantity);
1002 
1003             _ownerships[startTokenId].addr = to;
1004             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1005 
1006             uint256 updatedIndex = startTokenId;
1007             uint256 end = updatedIndex + quantity;
1008 
1009             do {
1010                 emit Transfer(address(0), to, updatedIndex++);
1011             } while (updatedIndex != end);
1012 
1013             _currentIndex = updatedIndex;
1014         }
1015         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1016     }
1017 
1018     /**
1019      * @dev Transfers `tokenId` from `from` to `to`.
1020      *
1021      * Requirements:
1022      *
1023      * - `to` cannot be the zero address.
1024      * - `tokenId` token must be owned by `from`.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _transfer(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) private {
1033         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1034 
1035         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1036 
1037         bool isApprovedOrOwner = (_msgSender() == from ||
1038             isApprovedForAll(from, _msgSender()) ||
1039             getApproved(tokenId) == _msgSender());
1040 
1041         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1042         if (to == address(0)) revert TransferToZeroAddress();
1043 
1044         _beforeTokenTransfers(from, to, tokenId, 1);
1045 
1046         // Clear approvals from the previous owner
1047         _approve(address(0), tokenId, from);
1048 
1049         // Underflow of the sender's balance is impossible because we check for
1050         // ownership above and the recipient's balance can't realistically overflow.
1051         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1052         unchecked {
1053             _addressData[from].balance -= 1;
1054             _addressData[to].balance += 1;
1055 
1056             TokenOwnership storage currSlot = _ownerships[tokenId];
1057             currSlot.addr = to;
1058             currSlot.startTimestamp = uint64(block.timestamp);
1059 
1060             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1061             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1062             uint256 nextTokenId = tokenId + 1;
1063             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1064             if (nextSlot.addr == address(0)) {
1065                 // This will suffice for checking _exists(nextTokenId),
1066                 // as a burned slot cannot contain the zero address.
1067                 if (nextTokenId != _currentIndex) {
1068                     nextSlot.addr = from;
1069                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1070                 }
1071             }
1072         }
1073 
1074         emit Transfer(from, to, tokenId);
1075         _afterTokenTransfers(from, to, tokenId, 1);
1076     }
1077 
1078     /**
1079      * @dev Equivalent to `_burn(tokenId, false)`.
1080      */
1081     function _burn(uint256 tokenId) internal virtual {
1082         _burn(tokenId, false);
1083     }
1084 
1085     /**
1086      * @dev Destroys `tokenId`.
1087      * The approval is cleared when the token is burned.
1088      *
1089      * Requirements:
1090      *
1091      * - `tokenId` must exist.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1096         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1097 
1098         address from = prevOwnership.addr;
1099 
1100         if (approvalCheck) {
1101             bool isApprovedOrOwner = (_msgSender() == from ||
1102                 isApprovedForAll(from, _msgSender()) ||
1103                 getApproved(tokenId) == _msgSender());
1104 
1105             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1106         }
1107 
1108         _beforeTokenTransfers(from, address(0), tokenId, 1);
1109 
1110         // Clear approvals from the previous owner
1111         _approve(address(0), tokenId, from);
1112 
1113         // Underflow of the sender's balance is impossible because we check for
1114         // ownership above and the recipient's balance can't realistically overflow.
1115         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1116         unchecked {
1117             AddressData storage addressData = _addressData[from];
1118             addressData.balance -= 1;
1119             addressData.numberBurned += 1;
1120 
1121             // Keep track of who burned the token, and the timestamp of burning.
1122             TokenOwnership storage currSlot = _ownerships[tokenId];
1123             currSlot.addr = from;
1124             currSlot.startTimestamp = uint64(block.timestamp);
1125             currSlot.burned = true;
1126 
1127             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1128             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1129             uint256 nextTokenId = tokenId + 1;
1130             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1131             if (nextSlot.addr == address(0)) {
1132                 // This will suffice for checking _exists(nextTokenId),
1133                 // as a burned slot cannot contain the zero address.
1134                 if (nextTokenId != _currentIndex) {
1135                     nextSlot.addr = from;
1136                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1137                 }
1138             }
1139         }
1140 
1141         emit Transfer(from, address(0), tokenId);
1142         _afterTokenTransfers(from, address(0), tokenId, 1);
1143 
1144         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1145         unchecked {
1146             _burnCounter++;
1147         }
1148     }
1149 
1150     /**
1151      * @dev Approve `to` to operate on `tokenId`
1152      *
1153      * Emits a {Approval} event.
1154      */
1155     function _approve(
1156         address to,
1157         uint256 tokenId,
1158         address owner
1159     ) internal {
1160         _tokenApprovals[tokenId] = to;
1161         emit Approval(owner, to, tokenId);
1162     }
1163 
1164     /**
1165      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1166      *
1167      * @param from address representing the previous owner of the given token ID
1168      * @param to target address that will receive the tokens
1169      * @param tokenId uint256 ID of the token to be transferred
1170      * @param _data bytes optional data to send along with the call
1171      * @return bool whether the call correctly returned the expected magic value
1172      */
1173     function _checkContractOnERC721Received(
1174         address from,
1175         address to,
1176         uint256 tokenId,
1177         bytes memory _data
1178     ) private returns (bool) {
1179         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1180             return retval == IERC721Receiver(to).onERC721Received.selector;
1181         } catch (bytes memory reason) {
1182             if (reason.length == 0) {
1183                 revert TransferToNonERC721ReceiverImplementer();
1184             } else {
1185                 assembly {
1186                     revert(add(32, reason), mload(reason))
1187                 }
1188             }
1189         }
1190     }
1191 
1192     /**
1193      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1194      * And also called before burning one token.
1195      *
1196      * startTokenId - the first token id to be transferred
1197      * quantity - the amount to be transferred
1198      *
1199      * Calling conditions:
1200      *
1201      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1202      * transferred to `to`.
1203      * - When `from` is zero, `tokenId` will be minted for `to`.
1204      * - When `to` is zero, `tokenId` will be burned by `from`.
1205      * - `from` and `to` are never both zero.
1206      */
1207     function _beforeTokenTransfers(
1208         address from,
1209         address to,
1210         uint256 startTokenId,
1211         uint256 quantity
1212     ) internal virtual {}
1213 
1214     /**
1215      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1216      * minting.
1217      * And also called after one token has been burned.
1218      *
1219      * startTokenId - the first token id to be transferred
1220      * quantity - the amount to be transferred
1221      *
1222      * Calling conditions:
1223      *
1224      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1225      * transferred to `to`.
1226      * - When `from` is zero, `tokenId` has been minted for `to`.
1227      * - When `to` is zero, `tokenId` has been burned by `from`.
1228      * - `from` and `to` are never both zero.
1229      */
1230     function _afterTokenTransfers(
1231         address from,
1232         address to,
1233         uint256 startTokenId,
1234         uint256 quantity
1235     ) internal virtual {}
1236 }
1237 
1238 
1239 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.0
1240 
1241 
1242 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1243 
1244 pragma solidity ^0.8.0;
1245 
1246 /**
1247  * @dev Contract module which provides a basic access control mechanism, where
1248  * there is an account (an owner) that can be granted exclusive access to
1249  * specific functions.
1250  *
1251  * By default, the owner account will be the one that deploys the contract. This
1252  * can later be changed with {transferOwnership}.
1253  *
1254  * This module is used through inheritance. It will make available the modifier
1255  * `onlyOwner`, which can be applied to your functions to restrict their use to
1256  * the owner.
1257  */
1258 abstract contract Ownable is Context {
1259     address private _owner;
1260 
1261     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1262 
1263     /**
1264      * @dev Initializes the contract setting the deployer as the initial owner.
1265      */
1266     constructor() {
1267         _transferOwnership(_msgSender());
1268     }
1269 
1270     /**
1271      * @dev Throws if called by any account other than the owner.
1272      */
1273     modifier onlyOwner() {
1274         _checkOwner();
1275         _;
1276     }
1277 
1278     /**
1279      * @dev Returns the address of the current owner.
1280      */
1281     function owner() public view virtual returns (address) {
1282         return _owner;
1283     }
1284 
1285     /**
1286      * @dev Throws if the sender is not the owner.
1287      */
1288     function _checkOwner() internal view virtual {
1289         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1290     }
1291 
1292     /**
1293      * @dev Leaves the contract without owner. It will not be possible to call
1294      * `onlyOwner` functions anymore. Can only be called by the current owner.
1295      *
1296      * NOTE: Renouncing ownership will leave the contract without an owner,
1297      * thereby removing any functionality that is only available to the owner.
1298      */
1299     function renounceOwnership() public virtual onlyOwner {
1300         _transferOwnership(address(0));
1301     }
1302 
1303     /**
1304      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1305      * Can only be called by the current owner.
1306      */
1307     function transferOwnership(address newOwner) public virtual onlyOwner {
1308         require(newOwner != address(0), "Ownable: new owner is the zero address");
1309         _transferOwnership(newOwner);
1310     }
1311 
1312     /**
1313      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1314      * Internal function without access restriction.
1315      */
1316     function _transferOwnership(address newOwner) internal virtual {
1317         address oldOwner = _owner;
1318         _owner = newOwner;
1319         emit OwnershipTransferred(oldOwner, newOwner);
1320     }
1321 }
1322 
1323 
1324 // File contracts/MerkleProof.sol
1325 
1326 
1327 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1328 
1329 pragma solidity ^0.8.0;
1330 
1331 /**
1332  * @dev These functions deal with verification of Merkle Trees proofs.
1333  *
1334  * The proofs can be generated using the JavaScript library
1335  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1336  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1337  *
1338  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1339  */
1340 library MerkleProof {
1341     /**
1342      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1343      * defined by `root`. For this, a `proof` must be provided, containing
1344      * sibling hashes on the branch from the leaf to the root of the tree. Each
1345      * pair of leaves and each pair of pre-images are assumed to be sorted.
1346      */
1347     function verify(
1348         bytes32[] memory proof,
1349         bytes32 root,
1350         bytes32 leaf
1351     ) internal pure returns (bool) {
1352         return processProof(proof, leaf) == root;
1353     }
1354 
1355     /**
1356      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1357      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1358      * hash matches the root of the tree. When processing the proof, the pairs
1359      * of leafs & pre-images are assumed to be sorted.
1360      *
1361      * _Available since v4.4._
1362      */
1363     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1364         bytes32 computedHash = leaf;
1365         for (uint256 i = 0; i < proof.length; i++) {
1366             bytes32 proofElement = proof[i];
1367             if (computedHash <= proofElement) {
1368                 // Hash(current computed hash + current element of the proof)
1369                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1370             } else {
1371                 // Hash(current element of the proof + current computed hash)
1372                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1373             }
1374         }
1375         return computedHash;
1376     }
1377 }
1378 
1379 
1380 // File contracts/Floaties.sol
1381 
1382 // SPDX-License-Identifier: Unlicense
1383 pragma solidity ^0.8.9;
1384 
1385 
1386 
1387 contract Floaties is ERC721A, Ownable {
1388     string private _baseTokenURI;
1389     bytes32 public merkleRoot;
1390 
1391     mapping(address => bool) public bannedExchanges;
1392     mapping(address => uint256) public whitelistMints;
1393 
1394     bool public saleIsActive = false;
1395     bool public whitelistSaleIsActive = false;
1396 
1397     uint256 public maxAmount = 3333;
1398     uint256 public maxPerMint = 8;
1399     uint256 public maxPerWhitelist = 8;
1400     uint256 public nftPrice = 0.07 ether;
1401 
1402     uint256 public whitelistLength = 0;
1403 
1404     address private mktWallet = 0xd6544adA9811B74899EB7aAEE742a8B9f552C5Cf;
1405     address private lowIQWallet = 0xe4446D52e2bdB3E31470643Ab1753a4c2aEee3eA;
1406     address private devWallet = 0x5f55F579beB3beaD4163604a630731556B52a9f0;
1407     address private artWallet = 0xa64c09B57d311f0a9240b75f6Ead51f83D1732EA;
1408     address private copyWallet = 0xB09e818F51E054eB50b570ED476951aB0F974b14;
1409     address private ideaWallet = 0x9114B6E313A29fd8eCe8Ca8fE7A834024434DA18;
1410 
1411     constructor(bytes32 merkleRoot_) ERC721A("Floaties", "FLOATIES") {
1412         merkleRoot = merkleRoot_;
1413         bannedExchanges[0x1E0049783F008A0085193E00003D00cd54003c71] = true;
1414         bannedExchanges[0xF849de01B080aDC3A814FaBE1E2087475cF2E354] = true;
1415         bannedExchanges[0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e] = true;
1416     }
1417 
1418     receive() external payable {}
1419 
1420     function _baseURI() internal view virtual override returns (string memory) {
1421         return _baseTokenURI;
1422     }
1423 
1424     function setBaseURI(string calldata baseURI) external onlyOwner {
1425         _baseTokenURI = baseURI;
1426     }
1427 
1428     function flipSaleState() public onlyOwner {
1429         saleIsActive = !saleIsActive;
1430     }
1431 
1432     function flipWhitelistSaleState() public onlyOwner {
1433         whitelistSaleIsActive = !whitelistSaleIsActive;
1434     }
1435 
1436     function mintReserveTokens(uint256 numberOfTokens) public onlyOwner {
1437         _safeMint(msg.sender, numberOfTokens);
1438         require(totalSupply() <= maxAmount, "Limit reached");
1439     }
1440 
1441     function mintNFTWhitelist(
1442         bytes32[] calldata _merkleProof,
1443         uint256 numberOfTokens
1444     ) public payable {
1445         require(whitelistSaleIsActive, "Whitelist sale is not active");
1446         require(
1447             nftPrice * numberOfTokens <= msg.value,
1448             "Ether value incorrect"
1449         );
1450         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1451         require(
1452             MerkleProof.verify(_merkleProof, merkleRoot, leaf) == true,
1453             "Incorrect Merkle Proof"
1454         );
1455 
1456         uint256 mintedSoFar = whitelistMints[msg.sender] + numberOfTokens;
1457         require(mintedSoFar <= maxPerWhitelist, "You can't mint that many");
1458 
1459         whitelistMints[msg.sender] = mintedSoFar;
1460 
1461         _safeMint(msg.sender, numberOfTokens);
1462 
1463         require(totalSupply() <= maxAmount, "Limit reached");
1464     }
1465 
1466     function mintNFT(uint256 numberOfTokens) public payable {
1467         require(saleIsActive, "Sale is not active");
1468         require(
1469             numberOfTokens <= maxPerMint,
1470             "You can't mint that many at once"
1471         );
1472         require(
1473             nftPrice * numberOfTokens <= msg.value,
1474             "Ether value sent is not correct"
1475         );
1476 
1477         _safeMint(msg.sender, numberOfTokens);
1478 
1479         require(totalSupply() <= maxAmount, "Limit reached");
1480     }
1481 
1482     function withdrawMoney() external onlyOwner {
1483         payable(msg.sender).transfer(address(this).balance);
1484     }
1485 
1486     function sendPayouts() public onlyOwner {
1487         uint256 payout = (address(this).balance * 70) / 100;
1488 
1489         uint256 dev = (payout * 1950) / 10000;
1490         uint256 art = (payout * 1750) / 10000;
1491         uint256 copy = (payout * 1750) / 10000;
1492         uint256 idea = (payout * 1750) / 10000;
1493         uint256 lowiq = (payout * 1000) / 10000;
1494         uint256 mkt = (payout * 1800) / 10000;
1495 
1496         require(payable(devWallet).send(dev));
1497         require(payable(artWallet).send(art));
1498         require(payable(copyWallet).send(copy));
1499         require(payable(mktWallet).send(mkt));
1500         require(payable(ideaWallet).send(idea));
1501         require(payable(lowIQWallet).send(lowiq));
1502     }
1503 
1504     function addBannedExchange(address account) external onlyOwner {
1505         bannedExchanges[account] = true;
1506     }
1507 
1508     function removeBannedExchange(address account) external onlyOwner {
1509         bannedExchanges[account] = false;
1510     }
1511 
1512     function approve(address to, uint256 tokenId) public override {
1513         address owner = ERC721A.ownerOf(tokenId);
1514         if (to == owner) revert ApprovalToCurrentOwner();
1515 
1516         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1517             revert ApprovalCallerNotOwnerNorApproved();
1518         }
1519         require(!bannedExchanges[to], "This exchange is not allowed.");
1520 
1521         _approve(to, tokenId, owner);
1522     }
1523 
1524     function setApprovalForAll(address operator, bool approved)
1525         public
1526         override
1527     {
1528         require(!bannedExchanges[operator], "This exchange is not allowed.");
1529 
1530         if (operator == _msgSender()) revert ApproveToCaller();
1531 
1532         _operatorApprovals[_msgSender()][operator] = approved;
1533         emit ApprovalForAll(_msgSender(), operator, approved);
1534     }
1535 
1536     function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
1537         merkleRoot = merkleRoot_;
1538     }
1539 }