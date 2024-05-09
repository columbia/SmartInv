1 // SPDX-License-Identifier: MIT
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-05-26
5 */
6 
7 // File: @openzeppelin/contracts/utils/Strings.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev String operations.
16  */
17 library Strings {
18     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
19 
20     /**
21      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
22      */
23     function toString(uint256 value) internal pure returns (string memory) {
24         // Inspired by OraclizeAPI's implementation - MIT licence
25         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
26 
27         if (value == 0) {
28             return "0";
29         }
30         uint256 temp = value;
31         uint256 digits;
32         while (temp != 0) {
33             digits++;
34             temp /= 10;
35         }
36         bytes memory buffer = new bytes(digits);
37         while (value != 0) {
38             digits -= 1;
39             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
40             value /= 10;
41         }
42         return string(buffer);
43     }
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
47      */
48     function toHexString(uint256 value) internal pure returns (string memory) {
49         if (value == 0) {
50             return "0x00";
51         }
52         uint256 temp = value;
53         uint256 length = 0;
54         while (temp != 0) {
55             length++;
56             temp >>= 8;
57         }
58         return toHexString(value, length);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
63      */
64     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
65         bytes memory buffer = new bytes(2 * length + 2);
66         buffer[0] = "0";
67         buffer[1] = "x";
68         for (uint256 i = 2 * length + 1; i > 1; --i) {
69             buffer[i] = _HEX_SYMBOLS[value & 0xf];
70             value >>= 4;
71         }
72         require(value == 0, "Strings: hex length insufficient");
73         return string(buffer);
74     }
75 }
76 
77 // File: @openzeppelin/contracts/utils/Address.sol
78 
79 
80 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
81 
82 pragma solidity ^0.8.1;
83 
84 /**
85  * @dev Collection of functions related to the address type
86  */
87 library Address {
88     /**
89      * @dev Returns true if `account` is a contract.
90      *
91      * [IMPORTANT]
92      * ====
93      * It is unsafe to assume that an address for which this function returns
94      * false is an externally-owned account (EOA) and not a contract.
95      *
96      * Among others, `isContract` will return false for the following
97      * types of addresses:
98      *
99      *  - an externally-owned account
100      *  - a contract in construction
101      *  - an address where a contract will be created
102      *  - an address where a contract lived, but was destroyed
103      * ====
104      *
105      * [IMPORTANT]
106      * ====
107      * You shouldn't rely on `isContract` to protect against flash loan attacks!
108      *
109      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
110      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
111      * constructor.
112      * ====
113      */
114     function isContract(address account) internal view returns (bool) {
115         // This method relies on extcodesize/address.code.length, which returns 0
116         // for contracts in construction, since the code is only stored at the end
117         // of the constructor execution.
118 
119         return account.code.length > 0;
120     }
121 
122     /**
123      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
124      * `recipient`, forwarding all available gas and reverting on errors.
125      *
126      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
127      * of certain opcodes, possibly making contracts go over the 2300 gas limit
128      * imposed by `transfer`, making them unable to receive funds via
129      * `transfer`. {sendValue} removes this limitation.
130      *
131      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
132      *
133      * IMPORTANT: because control is transferred to `recipient`, care must be
134      * taken to not create reentrancy vulnerabilities. Consider using
135      * {ReentrancyGuard} or the
136      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
137      */
138     function sendValue(address payable recipient, uint256 amount) internal {
139         require(address(this).balance >= amount, "Address: insufficient balance");
140 
141         (bool success, ) = recipient.call{value: amount}("");
142         require(success, "Address: unable to send value, recipient may have reverted");
143     }
144 
145     /**
146      * @dev Performs a Solidity function call using a low level `call`. A
147      * plain `call` is an unsafe replacement for a function call: use this
148      * function instead.
149      *
150      * If `target` reverts with a revert reason, it is bubbled up by this
151      * function (like regular Solidity function calls).
152      *
153      * Returns the raw returned data. To convert to the expected return value,
154      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
155      *
156      * Requirements:
157      *
158      * - `target` must be a contract.
159      * - calling `target` with `data` must not revert.
160      *
161      * _Available since v3.1._
162      */
163     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
164         return functionCall(target, data, "Address: low-level call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
169      * `errorMessage` as a fallback revert reason when `target` reverts.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(
174         address target,
175         bytes memory data,
176         string memory errorMessage
177     ) internal returns (bytes memory) {
178         return functionCallWithValue(target, data, 0, errorMessage);
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
183      * but also transferring `value` wei to `target`.
184      *
185      * Requirements:
186      *
187      * - the calling contract must have an ETH balance of at least `value`.
188      * - the called Solidity function must be `payable`.
189      *
190      * _Available since v3.1._
191      */
192     function functionCallWithValue(
193         address target,
194         bytes memory data,
195         uint256 value
196     ) internal returns (bytes memory) {
197         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
202      * with `errorMessage` as a fallback revert reason when `target` reverts.
203      *
204      * _Available since v3.1._
205      */
206     function functionCallWithValue(
207         address target,
208         bytes memory data,
209         uint256 value,
210         string memory errorMessage
211     ) internal returns (bytes memory) {
212         require(address(this).balance >= value, "Address: insufficient balance for call");
213         require(isContract(target), "Address: call to non-contract");
214 
215         (bool success, bytes memory returndata) = target.call{value: value}(data);
216         return verifyCallResult(success, returndata, errorMessage);
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
221      * but performing a static call.
222      *
223      * _Available since v3.3._
224      */
225     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
226         return functionStaticCall(target, data, "Address: low-level static call failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
231      * but performing a static call.
232      *
233      * _Available since v3.3._
234      */
235     function functionStaticCall(
236         address target,
237         bytes memory data,
238         string memory errorMessage
239     ) internal view returns (bytes memory) {
240         require(isContract(target), "Address: static call to non-contract");
241 
242         (bool success, bytes memory returndata) = target.staticcall(data);
243         return verifyCallResult(success, returndata, errorMessage);
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
248      * but performing a delegate call.
249      *
250      * _Available since v3.4._
251      */
252     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
253         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
258      * but performing a delegate call.
259      *
260      * _Available since v3.4._
261      */
262     function functionDelegateCall(
263         address target,
264         bytes memory data,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         require(isContract(target), "Address: delegate call to non-contract");
268 
269         (bool success, bytes memory returndata) = target.delegatecall(data);
270         return verifyCallResult(success, returndata, errorMessage);
271     }
272 
273     /**
274      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
275      * revert reason using the provided one.
276      *
277      * _Available since v4.3._
278      */
279     function verifyCallResult(
280         bool success,
281         bytes memory returndata,
282         string memory errorMessage
283     ) internal pure returns (bytes memory) {
284         if (success) {
285             return returndata;
286         } else {
287             // Look for revert reason and bubble it up if present
288             if (returndata.length > 0) {
289                 // The easiest way to bubble the revert reason is using memory via assembly
290 
291                 assembly {
292                     let returndata_size := mload(returndata)
293                     revert(add(32, returndata), returndata_size)
294                 }
295             } else {
296                 revert(errorMessage);
297             }
298         }
299     }
300 }
301 
302 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
303 
304 
305 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
306 
307 pragma solidity ^0.8.0;
308 
309 /**
310  * @title ERC721 token receiver interface
311  * @dev Interface for any contract that wants to support safeTransfers
312  * from ERC721 asset contracts.
313  */
314 interface IERC721Receiver {
315     /**
316      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
317      * by `operator` from `from`, this function is called.
318      *
319      * It must return its Solidity selector to confirm the token transfer.
320      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
321      *
322      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
323      */
324     function onERC721Received(
325         address operator,
326         address from,
327         uint256 tokenId,
328         bytes calldata data
329     ) external returns (bytes4);
330 }
331 
332 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
333 
334 
335 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @dev Interface of the ERC165 standard, as defined in the
341  * https://eips.ethereum.org/EIPS/eip-165[EIP].
342  *
343  * Implementers can declare support of contract interfaces, which can then be
344  * queried by others ({ERC165Checker}).
345  *
346  * For an implementation, see {ERC165}.
347  */
348 interface IERC165 {
349     /**
350      * @dev Returns true if this contract implements the interface defined by
351      * `interfaceId`. See the corresponding
352      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
353      * to learn more about how these ids are created.
354      *
355      * This function call must use less than 30 000 gas.
356      */
357     function supportsInterface(bytes4 interfaceId) external view returns (bool);
358 }
359 
360 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
361 
362 
363 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 
368 /**
369  * @dev Implementation of the {IERC165} interface.
370  *
371  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
372  * for the additional interface id that will be supported. For example:
373  *
374  * ```solidity
375  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
376  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
377  * }
378  * ```
379  *
380  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
381  */
382 abstract contract ERC165 is IERC165 {
383     /**
384      * @dev See {IERC165-supportsInterface}.
385      */
386     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
387         return interfaceId == type(IERC165).interfaceId;
388     }
389 }
390 
391 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
392 
393 
394 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
395 
396 pragma solidity ^0.8.0;
397 
398 
399 /**
400  * @dev Required interface of an ERC721 compliant contract.
401  */
402 interface IERC721 is IERC165 {
403     /**
404      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
405      */
406     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
407 
408     /**
409      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
410      */
411     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
412 
413     /**
414      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
415      */
416     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
417 
418     /**
419      * @dev Returns the number of tokens in ``owner``'s account.
420      */
421     function balanceOf(address owner) external view returns (uint256 balance);
422 
423     /**
424      * @dev Returns the owner of the `tokenId` token.
425      *
426      * Requirements:
427      *
428      * - `tokenId` must exist.
429      */
430     function ownerOf(uint256 tokenId) external view returns (address owner);
431 
432     /**
433      * @dev Safely transfers `tokenId` token from `from` to `to`.
434      *
435      * Requirements:
436      *
437      * - `from` cannot be the zero address.
438      * - `to` cannot be the zero address.
439      * - `tokenId` token must exist and be owned by `from`.
440      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
441      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
442      *
443      * Emits a {Transfer} event.
444      */
445     function safeTransferFrom(
446         address from,
447         address to,
448         uint256 tokenId,
449         bytes calldata data
450     ) external;
451 
452     /**
453      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
454      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
455      *
456      * Requirements:
457      *
458      * - `from` cannot be the zero address.
459      * - `to` cannot be the zero address.
460      * - `tokenId` token must exist and be owned by `from`.
461      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
462      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
463      *
464      * Emits a {Transfer} event.
465      */
466     function safeTransferFrom(
467         address from,
468         address to,
469         uint256 tokenId
470     ) external;
471 
472     /**
473      * @dev Transfers `tokenId` token from `from` to `to`.
474      *
475      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
476      *
477      * Requirements:
478      *
479      * - `from` cannot be the zero address.
480      * - `to` cannot be the zero address.
481      * - `tokenId` token must be owned by `from`.
482      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
483      *
484      * Emits a {Transfer} event.
485      */
486     function transferFrom(
487         address from,
488         address to,
489         uint256 tokenId
490     ) external;
491 
492     /**
493      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
494      * The approval is cleared when the token is transferred.
495      *
496      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
497      *
498      * Requirements:
499      *
500      * - The caller must own the token or be an approved operator.
501      * - `tokenId` must exist.
502      *
503      * Emits an {Approval} event.
504      */
505     function approve(address to, uint256 tokenId) external;
506 
507     /**
508      * @dev Approve or remove `operator` as an operator for the caller.
509      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
510      *
511      * Requirements:
512      *
513      * - The `operator` cannot be the caller.
514      *
515      * Emits an {ApprovalForAll} event.
516      */
517     function setApprovalForAll(address operator, bool _approved) external;
518 
519     /**
520      * @dev Returns the account approved for `tokenId` token.
521      *
522      * Requirements:
523      *
524      * - `tokenId` must exist.
525      */
526     function getApproved(uint256 tokenId) external view returns (address operator);
527 
528     /**
529      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
530      *
531      * See {setApprovalForAll}
532      */
533     function isApprovedForAll(address owner, address operator) external view returns (bool);
534 }
535 
536 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
537 
538 
539 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 
544 /**
545  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
546  * @dev See https://eips.ethereum.org/EIPS/eip-721
547  */
548 interface IERC721Metadata is IERC721 {
549     /**
550      * @dev Returns the token collection name.
551      */
552     function name() external view returns (string memory);
553 
554     /**
555      * @dev Returns the token collection symbol.
556      */
557     function symbol() external view returns (string memory);
558 
559     /**
560      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
561      */
562     function tokenURI(uint256 tokenId) external view returns (string memory);
563 }
564 
565 // File: erc721a/contracts/IERC721A.sol
566 
567 
568 // ERC721A Contracts v3.3.0
569 // Creator: Chiru Labs
570 
571 pragma solidity ^0.8.4;
572 
573 
574 
575 /**
576  * @dev Interface of an ERC721A compliant contract.
577  */
578 interface IERC721A is IERC721, IERC721Metadata {
579     /**
580      * The caller must own the token or be an approved operator.
581      */
582     error ApprovalCallerNotOwnerNorApproved();
583 
584     /**
585      * The token does not exist.
586      */
587     error ApprovalQueryForNonexistentToken();
588 
589     /**
590      * The caller cannot approve to their own address.
591      */
592     error ApproveToCaller();
593 
594     /**
595      * The caller cannot approve to the current owner.
596      */
597     error ApprovalToCurrentOwner();
598 
599     /**
600      * Cannot query the balance for the zero address.
601      */
602     error BalanceQueryForZeroAddress();
603 
604     /**
605      * Cannot mint to the zero address.
606      */
607     error MintToZeroAddress();
608 
609     /**
610      * The quantity of tokens minted must be more than zero.
611      */
612     error MintZeroQuantity();
613 
614     /**
615      * The token does not exist.
616      */
617     error OwnerQueryForNonexistentToken();
618 
619     /**
620      * The caller must own the token or be an approved operator.
621      */
622     error TransferCallerNotOwnerNorApproved();
623 
624     /**
625      * The token must be owned by `from`.
626      */
627     error TransferFromIncorrectOwner();
628 
629     /**
630      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
631      */
632     error TransferToNonERC721ReceiverImplementer();
633 
634     /**
635      * Cannot transfer to the zero address.
636      */
637     error TransferToZeroAddress();
638 
639     /**
640      * The token does not exist.
641      */
642     error URIQueryForNonexistentToken();
643 
644     // Compiler will pack this into a single 256bit word.
645     struct TokenOwnership {
646         // The address of the owner.
647         address addr;
648         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
649         uint64 startTimestamp;
650         // Whether the token has been burned.
651         bool burned;
652     }
653 
654     // Compiler will pack this into a single 256bit word.
655     struct AddressData {
656         // Realistically, 2**64-1 is more than enough.
657         uint64 balance;
658         // Keeps track of mint count with minimal overhead for tokenomics.
659         uint64 numberMinted;
660         // Keeps track of burn count with minimal overhead for tokenomics.
661         uint64 numberBurned;
662         // For miscellaneous variable(s) pertaining to the address
663         // (e.g. number of whitelist mint slots used).
664         // If there are multiple variables, please pack them into a uint64.
665         uint64 aux;
666     }
667 
668     /**
669      * @dev Returns the total amount of tokens stored by the contract.
670      * 
671      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
672      */
673     function totalSupply() external view returns (uint256);
674 }
675 
676 // File: @openzeppelin/contracts/utils/Context.sol
677 
678 
679 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 /**
684  * @dev Provides information about the current execution context, including the
685  * sender of the transaction and its data. While these are generally available
686  * via msg.sender and msg.data, they should not be accessed in such a direct
687  * manner, since when dealing with meta-transactions the account sending and
688  * paying for execution may not be the actual sender (as far as an application
689  * is concerned).
690  *
691  * This contract is only required for intermediate, library-like contracts.
692  */
693 abstract contract Context {
694     function _msgSender() internal view virtual returns (address) {
695         return msg.sender;
696     }
697 
698     function _msgData() internal view virtual returns (bytes calldata) {
699         return msg.data;
700     }
701 }
702 
703 // File: erc721a/contracts/ERC721A.sol
704 
705 
706 // ERC721A Contracts v3.3.0
707 // Creator: Chiru Labs
708 
709 pragma solidity ^0.8.4;
710 
711 
712 
713 
714 
715 
716 
717 /**
718  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
719  * the Metadata extension. Built to optimize for lower gas during batch mints.
720  *
721  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
722  *
723  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
724  *
725  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
726  */
727 contract ERC721A is Context, ERC165, IERC721A {
728     using Address for address;
729     using Strings for uint256;
730 
731     // The tokenId of the next token to be minted.
732     uint256 internal _currentIndex;
733 
734     // The number of tokens burned.
735     uint256 internal _burnCounter;
736 
737     // Token name
738     string private _name;
739 
740     // Token symbol
741     string private _symbol;
742 
743     // Mapping from token ID to ownership details
744     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
745     mapping(uint256 => TokenOwnership) internal _ownerships;
746 
747     // Mapping owner address to address data
748     mapping(address => AddressData) private _addressData;
749 
750     // Mapping from token ID to approved address
751     mapping(uint256 => address) private _tokenApprovals;
752 
753     // Mapping from owner to operator approvals
754     mapping(address => mapping(address => bool)) private _operatorApprovals;
755 
756     constructor(string memory name_, string memory symbol_) {
757         _name = name_;
758         _symbol = symbol_;
759         _currentIndex = _startTokenId();
760     }
761 
762     /**
763      * To change the starting tokenId, please override this function.
764      */
765     function _startTokenId() internal view virtual returns (uint256) {
766         return 0;
767     }
768 
769     /**
770      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
771      */
772     function totalSupply() public view override returns (uint256) {
773         // Counter underflow is impossible as _burnCounter cannot be incremented
774         // more than _currentIndex - _startTokenId() times
775         unchecked {
776             return _currentIndex - _burnCounter - _startTokenId();
777         }
778     }
779 
780     /**
781      * Returns the total amount of tokens minted in the contract.
782      */
783     function _totalMinted() internal view returns (uint256) {
784         // Counter underflow is impossible as _currentIndex does not decrement,
785         // and it is initialized to _startTokenId()
786         unchecked {
787             return _currentIndex - _startTokenId();
788         }
789     }
790 
791     /**
792      * @dev See {IERC165-supportsInterface}.
793      */
794     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
795         return
796             interfaceId == type(IERC721).interfaceId ||
797             interfaceId == type(IERC721Metadata).interfaceId ||
798             super.supportsInterface(interfaceId);
799     }
800 
801     /**
802      * @dev See {IERC721-balanceOf}.
803      */
804     function balanceOf(address owner) public view override returns (uint256) {
805         if (owner == address(0)) revert BalanceQueryForZeroAddress();
806         return uint256(_addressData[owner].balance);
807     }
808 
809     /**
810      * Returns the number of tokens minted by `owner`.
811      */
812     function _numberMinted(address owner) internal view returns (uint256) {
813         return uint256(_addressData[owner].numberMinted);
814     }
815 
816     /**
817      * Returns the number of tokens burned by or on behalf of `owner`.
818      */
819     function _numberBurned(address owner) internal view returns (uint256) {
820         return uint256(_addressData[owner].numberBurned);
821     }
822 
823     /**
824      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
825      */
826     function _getAux(address owner) internal view returns (uint64) {
827         return _addressData[owner].aux;
828     }
829 
830     /**
831      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
832      * If there are multiple variables, please pack them into a uint64.
833      */
834     function _setAux(address owner, uint64 aux) internal {
835         _addressData[owner].aux = aux;
836     }
837 
838     /**
839      * Gas spent here starts off proportional to the maximum mint batch size.
840      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
841      */
842     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
843         uint256 curr = tokenId;
844 
845         unchecked {
846             if (_startTokenId() <= curr) if (curr < _currentIndex) {
847                 TokenOwnership memory ownership = _ownerships[curr];
848                 if (!ownership.burned) {
849                     if (ownership.addr != address(0)) {
850                         return ownership;
851                     }
852                     // Invariant:
853                     // There will always be an ownership that has an address and is not burned
854                     // before an ownership that does not have an address and is not burned.
855                     // Hence, curr will not underflow.
856                     while (true) {
857                         curr--;
858                         ownership = _ownerships[curr];
859                         if (ownership.addr != address(0)) {
860                             return ownership;
861                         }
862                     }
863                 }
864             }
865         }
866         revert OwnerQueryForNonexistentToken();
867     }
868 
869     /**
870      * @dev See {IERC721-ownerOf}.
871      */
872     function ownerOf(uint256 tokenId) public view override returns (address) {
873         return _ownershipOf(tokenId).addr;
874     }
875 
876     /**
877      * @dev See {IERC721Metadata-name}.
878      */
879     function name() public view virtual override returns (string memory) {
880         return _name;
881     }
882 
883     /**
884      * @dev See {IERC721Metadata-symbol}.
885      */
886     function symbol() public view virtual override returns (string memory) {
887         return _symbol;
888     }
889 
890     /**
891      * @dev See {IERC721Metadata-tokenURI}.
892      */
893     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
894         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
895 
896         string memory baseURI = _baseURI();
897         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
898     }
899 
900     /**
901      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
902      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
903      * by default, can be overriden in child contracts.
904      */
905     function _baseURI() internal view virtual returns (string memory) {
906         return '';
907     }
908 
909     /**
910      * @dev See {IERC721-approve}.
911      */
912     function approve(address to, uint256 tokenId) public override {
913         address owner = ERC721A.ownerOf(tokenId);
914         if (to == owner) revert ApprovalToCurrentOwner();
915 
916         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
917             revert ApprovalCallerNotOwnerNorApproved();
918         }
919 
920         _approve(to, tokenId, owner);
921     }
922 
923     /**
924      * @dev See {IERC721-getApproved}.
925      */
926     function getApproved(uint256 tokenId) public view override returns (address) {
927         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
928 
929         return _tokenApprovals[tokenId];
930     }
931 
932     /**
933      * @dev See {IERC721-setApprovalForAll}.
934      */
935     function setApprovalForAll(address operator, bool approved) public virtual override {
936         if (operator == _msgSender()) revert ApproveToCaller();
937 
938         _operatorApprovals[_msgSender()][operator] = approved;
939         emit ApprovalForAll(_msgSender(), operator, approved);
940     }
941 
942     /**
943      * @dev See {IERC721-isApprovedForAll}.
944      */
945     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
946         return _operatorApprovals[owner][operator];
947     }
948 
949     /**
950      * @dev See {IERC721-transferFrom}.
951      */
952     function transferFrom(
953         address from,
954         address to,
955         uint256 tokenId
956     ) public virtual override {
957         _transfer(from, to, tokenId);
958     }
959 
960     /**
961      * @dev See {IERC721-safeTransferFrom}.
962      */
963     function safeTransferFrom(
964         address from,
965         address to,
966         uint256 tokenId
967     ) public virtual override {
968         safeTransferFrom(from, to, tokenId, '');
969     }
970 
971     /**
972      * @dev See {IERC721-safeTransferFrom}.
973      */
974     function safeTransferFrom(
975         address from,
976         address to,
977         uint256 tokenId,
978         bytes memory _data
979     ) public virtual override {
980         _transfer(from, to, tokenId);
981         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
982             revert TransferToNonERC721ReceiverImplementer();
983         }
984     }
985 
986     /**
987      * @dev Returns whether `tokenId` exists.
988      *
989      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
990      *
991      * Tokens start existing when they are minted (`_mint`),
992      */
993     function _exists(uint256 tokenId) internal view returns (bool) {
994         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
995     }
996 
997     /**
998      * @dev Equivalent to `_safeMint(to, quantity, '')`.
999      */
1000     function _safeMint(address to, uint256 quantity) internal {
1001         _safeMint(to, quantity, '');
1002     }
1003 
1004     /**
1005      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1006      *
1007      * Requirements:
1008      *
1009      * - If `to` refers to a smart contract, it must implement
1010      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1011      * - `quantity` must be greater than 0.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _safeMint(
1016         address to,
1017         uint256 quantity,
1018         bytes memory _data
1019     ) internal {
1020         uint256 startTokenId = _currentIndex;
1021         if (to == address(0)) revert MintToZeroAddress();
1022         if (quantity == 0) revert MintZeroQuantity();
1023 
1024         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1025 
1026         // Overflows are incredibly unrealistic.
1027         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1028         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1029         unchecked {
1030             _addressData[to].balance += uint64(quantity);
1031             _addressData[to].numberMinted += uint64(quantity);
1032 
1033             _ownerships[startTokenId].addr = to;
1034             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1035 
1036             uint256 updatedIndex = startTokenId;
1037             uint256 end = updatedIndex + quantity;
1038 
1039             if (to.isContract()) {
1040                 do {
1041                     emit Transfer(address(0), to, updatedIndex);
1042                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1043                         revert TransferToNonERC721ReceiverImplementer();
1044                     }
1045                 } while (updatedIndex < end);
1046                 // Reentrancy protection
1047                 if (_currentIndex != startTokenId) revert();
1048             } else {
1049                 do {
1050                     emit Transfer(address(0), to, updatedIndex++);
1051                 } while (updatedIndex < end);
1052             }
1053             _currentIndex = updatedIndex;
1054         }
1055         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1056     }
1057 
1058     /**
1059      * @dev Mints `quantity` tokens and transfers them to `to`.
1060      *
1061      * Requirements:
1062      *
1063      * - `to` cannot be the zero address.
1064      * - `quantity` must be greater than 0.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _mint(address to, uint256 quantity) internal {
1069         uint256 startTokenId = _currentIndex;
1070         if (to == address(0)) revert MintToZeroAddress();
1071         if (quantity == 0) revert MintZeroQuantity();
1072 
1073         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1074 
1075         // Overflows are incredibly unrealistic.
1076         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1077         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1078         unchecked {
1079             _addressData[to].balance += uint64(quantity);
1080             _addressData[to].numberMinted += uint64(quantity);
1081 
1082             _ownerships[startTokenId].addr = to;
1083             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1084 
1085             uint256 updatedIndex = startTokenId;
1086             uint256 end = updatedIndex + quantity;
1087 
1088             do {
1089                 emit Transfer(address(0), to, updatedIndex++);
1090             } while (updatedIndex < end);
1091 
1092             _currentIndex = updatedIndex;
1093         }
1094         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1095     }
1096 
1097     /**
1098      * @dev Transfers `tokenId` from `from` to `to`.
1099      *
1100      * Requirements:
1101      *
1102      * - `to` cannot be the zero address.
1103      * - `tokenId` token must be owned by `from`.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _transfer(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) private {
1112         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1113 
1114         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1115 
1116         bool isApprovedOrOwner = (_msgSender() == from ||
1117             isApprovedForAll(from, _msgSender()) ||
1118             getApproved(tokenId) == _msgSender());
1119 
1120         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1121         if (to == address(0)) revert TransferToZeroAddress();
1122 
1123         _beforeTokenTransfers(from, to, tokenId, 1);
1124 
1125         // Clear approvals from the previous owner
1126         _approve(address(0), tokenId, from);
1127 
1128         // Underflow of the sender's balance is impossible because we check for
1129         // ownership above and the recipient's balance can't realistically overflow.
1130         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1131         unchecked {
1132             _addressData[from].balance -= 1;
1133             _addressData[to].balance += 1;
1134 
1135             TokenOwnership storage currSlot = _ownerships[tokenId];
1136             currSlot.addr = to;
1137             currSlot.startTimestamp = uint64(block.timestamp);
1138 
1139             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1140             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1141             uint256 nextTokenId = tokenId + 1;
1142             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1143             if (nextSlot.addr == address(0)) {
1144                 // This will suffice for checking _exists(nextTokenId),
1145                 // as a burned slot cannot contain the zero address.
1146                 if (nextTokenId != _currentIndex) {
1147                     nextSlot.addr = from;
1148                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1149                 }
1150             }
1151         }
1152 
1153         emit Transfer(from, to, tokenId);
1154         _afterTokenTransfers(from, to, tokenId, 1);
1155     }
1156 
1157     /**
1158      * @dev Equivalent to `_burn(tokenId, false)`.
1159      */
1160     function _burn(uint256 tokenId) internal virtual {
1161         _burn(tokenId, false);
1162     }
1163 
1164     /**
1165      * @dev Destroys `tokenId`.
1166      * The approval is cleared when the token is burned.
1167      *
1168      * Requirements:
1169      *
1170      * - `tokenId` must exist.
1171      *
1172      * Emits a {Transfer} event.
1173      */
1174     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1175         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1176 
1177         address from = prevOwnership.addr;
1178 
1179         if (approvalCheck) {
1180             bool isApprovedOrOwner = (_msgSender() == from ||
1181                 isApprovedForAll(from, _msgSender()) ||
1182                 getApproved(tokenId) == _msgSender());
1183 
1184             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1185         }
1186 
1187         _beforeTokenTransfers(from, address(0), tokenId, 1);
1188 
1189         // Clear approvals from the previous owner
1190         _approve(address(0), tokenId, from);
1191 
1192         // Underflow of the sender's balance is impossible because we check for
1193         // ownership above and the recipient's balance can't realistically overflow.
1194         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1195         unchecked {
1196             AddressData storage addressData = _addressData[from];
1197             addressData.balance -= 1;
1198             addressData.numberBurned += 1;
1199 
1200             // Keep track of who burned the token, and the timestamp of burning.
1201             TokenOwnership storage currSlot = _ownerships[tokenId];
1202             currSlot.addr = from;
1203             currSlot.startTimestamp = uint64(block.timestamp);
1204             currSlot.burned = true;
1205 
1206             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1207             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1208             uint256 nextTokenId = tokenId + 1;
1209             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1210             if (nextSlot.addr == address(0)) {
1211                 // This will suffice for checking _exists(nextTokenId),
1212                 // as a burned slot cannot contain the zero address.
1213                 if (nextTokenId != _currentIndex) {
1214                     nextSlot.addr = from;
1215                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1216                 }
1217             }
1218         }
1219 
1220         emit Transfer(from, address(0), tokenId);
1221         _afterTokenTransfers(from, address(0), tokenId, 1);
1222 
1223         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1224         unchecked {
1225             _burnCounter++;
1226         }
1227     }
1228 
1229     /**
1230      * @dev Approve `to` to operate on `tokenId`
1231      *
1232      * Emits a {Approval} event.
1233      */
1234     function _approve(
1235         address to,
1236         uint256 tokenId,
1237         address owner
1238     ) private {
1239         _tokenApprovals[tokenId] = to;
1240         emit Approval(owner, to, tokenId);
1241     }
1242 
1243     /**
1244      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1245      *
1246      * @param from address representing the previous owner of the given token ID
1247      * @param to target address that will receive the tokens
1248      * @param tokenId uint256 ID of the token to be transferred
1249      * @param _data bytes optional data to send along with the call
1250      * @return bool whether the call correctly returned the expected magic value
1251      */
1252     function _checkContractOnERC721Received(
1253         address from,
1254         address to,
1255         uint256 tokenId,
1256         bytes memory _data
1257     ) private returns (bool) {
1258         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1259             return retval == IERC721Receiver(to).onERC721Received.selector;
1260         } catch (bytes memory reason) {
1261             if (reason.length == 0) {
1262                 revert TransferToNonERC721ReceiverImplementer();
1263             } else {
1264                 assembly {
1265                     revert(add(32, reason), mload(reason))
1266                 }
1267             }
1268         }
1269     }
1270 
1271     /**
1272      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1273      * And also called before burning one token.
1274      *
1275      * startTokenId - the first token id to be transferred
1276      * quantity - the amount to be transferred
1277      *
1278      * Calling conditions:
1279      *
1280      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1281      * transferred to `to`.
1282      * - When `from` is zero, `tokenId` will be minted for `to`.
1283      * - When `to` is zero, `tokenId` will be burned by `from`.
1284      * - `from` and `to` are never both zero.
1285      */
1286     function _beforeTokenTransfers(
1287         address from,
1288         address to,
1289         uint256 startTokenId,
1290         uint256 quantity
1291     ) internal virtual {}
1292 
1293     /**
1294      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1295      * minting.
1296      * And also called after one token has been burned.
1297      *
1298      * startTokenId - the first token id to be transferred
1299      * quantity - the amount to be transferred
1300      *
1301      * Calling conditions:
1302      *
1303      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1304      * transferred to `to`.
1305      * - When `from` is zero, `tokenId` has been minted for `to`.
1306      * - When `to` is zero, `tokenId` has been burned by `from`.
1307      * - `from` and `to` are never both zero.
1308      */
1309     function _afterTokenTransfers(
1310         address from,
1311         address to,
1312         uint256 startTokenId,
1313         uint256 quantity
1314     ) internal virtual {}
1315 }
1316 
1317 // File: @openzeppelin/contracts/access/Ownable.sol
1318 
1319 
1320 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1321 
1322 pragma solidity ^0.8.0;
1323 
1324 
1325 /**
1326  * @dev Contract module which provides a basic access control mechanism, where
1327  * there is an account (an owner) that can be granted exclusive access to
1328  * specific functions.
1329  *
1330  * By default, the owner account will be the one that deploys the contract. This
1331  * can later be changed with {transferOwnership}.
1332  *
1333  * This module is used through inheritance. It will make available the modifier
1334  * `onlyOwner`, which can be applied to your functions to restrict their use to
1335  * the owner.
1336  */
1337 abstract contract Ownable is Context {
1338     address private _owner;
1339 
1340     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1341 
1342     /**
1343      * @dev Initializes the contract setting the deployer as the initial owner.
1344      */
1345     constructor() {
1346         _transferOwnership(_msgSender());
1347     }
1348 
1349     /**
1350      * @dev Returns the address of the current owner.
1351      */
1352     function owner() public view virtual returns (address) {
1353         return _owner;
1354     }
1355 
1356     /**
1357      * @dev Throws if called by any account other than the owner.
1358      */
1359     modifier onlyOwner() {
1360         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1361         _;
1362     }
1363 
1364     /**
1365      * @dev Leaves the contract without owner. It will not be possible to call
1366      * `onlyOwner` functions anymore. Can only be called by the current owner.
1367      *
1368      * NOTE: Renouncing ownership will leave the contract without an owner,
1369      * thereby removing any functionality that is only available to the owner.
1370      */
1371     function renounceOwnership() public virtual onlyOwner {
1372         _transferOwnership(address(0));
1373     }
1374 
1375     /**
1376      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1377      * Can only be called by the current owner.
1378      */
1379     function transferOwnership(address newOwner) public virtual onlyOwner {
1380         require(newOwner != address(0), "Ownable: new owner is the zero address");
1381         _transferOwnership(newOwner);
1382     }
1383 
1384     /**
1385      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1386      * Internal function without access restriction.
1387      */
1388     function _transferOwnership(address newOwner) internal virtual {
1389         address oldOwner = _owner;
1390         _owner = newOwner;
1391         emit OwnershipTransferred(oldOwner, newOwner);
1392     }
1393 }
1394 
1395 
1396 pragma solidity ^0.8.0;
1397 
1398 
1399 contract TGC is ERC721A, Ownable {
1400 	using Strings for uint;
1401 
1402 	uint public constant MINT_PRICE = 0.005 ether;
1403 	uint public constant MAX_NFT_PER_TRAN = 20;
1404 	address private immutable SPLITTER_ADDRESS;
1405 	uint public maxSupply = 6969;
1406 
1407 	bool public isPaused;
1408     bool public isMetadataFinal;
1409     string private _baseURL;
1410 	string public prerevealURL = '';
1411 	mapping(address => uint) private _walletMintedCount;
1412 
1413 	constructor(address splitterAddress)
1414 	ERC721A('The Goblin Culture', 'TGC') {
1415         SPLITTER_ADDRESS = splitterAddress;
1416     }
1417 
1418 	function _baseURI() internal view override returns (string memory) {
1419 		return _baseURL;
1420 	}
1421 
1422 	function _startTokenId() internal pure override returns (uint) {
1423 		return 1;
1424 	}
1425 
1426 	function contractURI() public pure returns (string memory) {
1427 		return "";
1428 	}
1429 
1430     function finalizeMetadata() external onlyOwner {
1431         isMetadataFinal = true;
1432     }
1433 
1434 	function reveal(string memory url) external onlyOwner {
1435         require(!isMetadataFinal, "Metadata is finalized");
1436 		_baseURL = url;
1437 	}
1438 
1439     function mintedCount(address owner) external view returns (uint) {
1440         return _walletMintedCount[owner];
1441     }
1442 
1443 	function setPause(bool value) external onlyOwner {
1444 		isPaused = value;
1445 	}
1446 
1447 	function withdraw() external onlyOwner {
1448 		uint balance = address(this).balance;
1449 		require(balance > 0, 'No balance');
1450 		payable(SPLITTER_ADDRESS).transfer(balance);
1451 	}
1452 
1453 	function airdrop(address to, uint count) external onlyOwner {
1454 		require(
1455 			_totalMinted() + count <= maxSupply,
1456 			'Exceeds max supply'
1457 		);
1458 		_safeMint(to, count);
1459 	}
1460 
1461 	function reduceSupply(uint newMaxSupply) external onlyOwner {
1462 		maxSupply = newMaxSupply;
1463 	}
1464 
1465 	function tokenURI(uint tokenId)
1466 		public
1467 		view
1468 		override
1469 		returns (string memory)
1470 	{
1471         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1472 
1473         return bytes(_baseURI()).length > 0 
1474             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1475             : prerevealURL;
1476 	}
1477 
1478 	function mint(uint count) external payable {
1479 		require(!isPaused, 'Sales are off');
1480 		require(count <= MAX_NFT_PER_TRAN,'Exceeds NFT per transaction limit');
1481 		require(_totalMinted() + count <= maxSupply,'Exceeds max supply');
1482 
1483         //Free Mints
1484         uint payForCount = count;
1485         uint mintedSoFar = _walletMintedCount[msg.sender];
1486         if(mintedSoFar < 2) {
1487             uint remainingFreeMints = 2 - mintedSoFar;
1488             if(count > remainingFreeMints) {
1489                 payForCount = count - remainingFreeMints;
1490             }
1491             else {
1492                 payForCount = 0;
1493             }
1494         }
1495 
1496 		require(
1497 			msg.value >= payForCount * MINT_PRICE,
1498 			'Ether value sent is not sufficient'
1499 		);
1500 
1501 		_walletMintedCount[msg.sender] += count;
1502 		_safeMint(msg.sender, count);
1503 	}
1504 }