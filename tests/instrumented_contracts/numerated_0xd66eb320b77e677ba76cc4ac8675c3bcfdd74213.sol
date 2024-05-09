1 // File: pepecard.sol
2 
3 
4 /**
5  *Submitted for verification at Etherscan.io on 2022-06-29
6 */
7 
8 // File: @openzeppelin/contracts/utils/Strings.sol
9 
10 
11 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev String operations.
17  */
18 library Strings {
19     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
20 
21     /**
22      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
23      */
24     function toString(uint256 value) internal pure returns (string memory) {
25         // Inspired by OraclizeAPI's implementation - MIT licence
26         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
27 
28         if (value == 0) {
29             return "0";
30         }
31         uint256 temp = value;
32         uint256 digits;
33         while (temp != 0) {
34             digits++;
35             temp /= 10;
36         }
37         bytes memory buffer = new bytes(digits);
38         while (value != 0) {
39             digits -= 1;
40             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
41             value /= 10;
42         }
43         return string(buffer);
44     }
45 
46     /**
47      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
48      */
49     function toHexString(uint256 value) internal pure returns (string memory) {
50         if (value == 0) {
51             return "0x00";
52         }
53         uint256 temp = value;
54         uint256 length = 0;
55         while (temp != 0) {
56             length++;
57             temp >>= 8;
58         }
59         return toHexString(value, length);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
64      */
65     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
66         bytes memory buffer = new bytes(2 * length + 2);
67         buffer[0] = "0";
68         buffer[1] = "x";
69         for (uint256 i = 2 * length + 1; i > 1; --i) {
70             buffer[i] = _HEX_SYMBOLS[value & 0xf];
71             value >>= 4;
72         }
73         require(value == 0, "Strings: hex length insufficient");
74         return string(buffer);
75     }
76 }
77 
78 // File: @openzeppelin/contracts/utils/Address.sol
79 
80 
81 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
82 
83 pragma solidity ^0.8.1;
84 
85 /**
86  * @dev Collection of functions related to the address type
87  */
88 library Address {
89     /**
90      * @dev Returns true if `account` is a contract.
91      *
92      * [IMPORTANT]
93      * ====
94      * It is unsafe to assume that an address for which this function returns
95      * false is an externally-owned account (EOA) and not a contract.
96      *
97      * Among others, `isContract` will return false for the following
98      * types of addresses:
99      *
100      *  - an externally-owned account
101      *  - a contract in construction
102      *  - an address where a contract will be created
103      *  - an address where a contract lived, but was destroyed
104      * ====
105      *
106      * [IMPORTANT]
107      * ====
108      * You shouldn't rely on `isContract` to protect against flash loan attacks!
109      *
110      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
111      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
112      * constructor.
113      * ====
114      */
115     function isContract(address account) internal view returns (bool) {
116         // This method relies on extcodesize/address.code.length, which returns 0
117         // for contracts in construction, since the code is only stored at the end
118         // of the constructor execution.
119 
120         return account.code.length > 0;
121     }
122 
123     /**
124      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
125      * `recipient`, forwarding all available gas and reverting on errors.
126      *
127      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
128      * of certain opcodes, possibly making contracts go over the 2300 gas limit
129      * imposed by `transfer`, making them unable to receive funds via
130      * `transfer`. {sendValue} removes this limitation.
131      *
132      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
133      *
134      * IMPORTANT: because control is transferred to `recipient`, care must be
135      * taken to not create reentrancy vulnerabilities. Consider using
136      * {ReentrancyGuard} or the
137      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
138      */
139     function sendValue(address payable recipient, uint256 amount) internal {
140         require(address(this).balance >= amount, "Address: insufficient balance");
141 
142         (bool success, ) = recipient.call{value: amount}("");
143         require(success, "Address: unable to send value, recipient may have reverted");
144     }
145 
146     /**
147      * @dev Performs a Solidity function call using a low level `call`. A
148      * plain `call` is an unsafe replacement for a function call: use this
149      * function instead.
150      *
151      * If `target` reverts with a revert reason, it is bubbled up by this
152      * function (like regular Solidity function calls).
153      *
154      * Returns the raw returned data. To convert to the expected return value,
155      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
156      *
157      * Requirements:
158      *
159      * - `target` must be a contract.
160      * - calling `target` with `data` must not revert.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
165         return functionCall(target, data, "Address: low-level call failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
170      * `errorMessage` as a fallback revert reason when `target` reverts.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(
175         address target,
176         bytes memory data,
177         string memory errorMessage
178     ) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, 0, errorMessage);
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
184      * but also transferring `value` wei to `target`.
185      *
186      * Requirements:
187      *
188      * - the calling contract must have an ETH balance of at least `value`.
189      * - the called Solidity function must be `payable`.
190      *
191      * _Available since v3.1._
192      */
193     function functionCallWithValue(
194         address target,
195         bytes memory data,
196         uint256 value
197     ) internal returns (bytes memory) {
198         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
203      * with `errorMessage` as a fallback revert reason when `target` reverts.
204      *
205      * _Available since v3.1._
206      */
207     function functionCallWithValue(
208         address target,
209         bytes memory data,
210         uint256 value,
211         string memory errorMessage
212     ) internal returns (bytes memory) {
213         require(address(this).balance >= value, "Address: insufficient balance for call");
214         require(isContract(target), "Address: call to non-contract");
215 
216         (bool success, bytes memory returndata) = target.call{value: value}(data);
217         return verifyCallResult(success, returndata, errorMessage);
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
222      * but performing a static call.
223      *
224      * _Available since v3.3._
225      */
226     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
227         return functionStaticCall(target, data, "Address: low-level static call failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
232      * but performing a static call.
233      *
234      * _Available since v3.3._
235      */
236     function functionStaticCall(
237         address target,
238         bytes memory data,
239         string memory errorMessage
240     ) internal view returns (bytes memory) {
241         require(isContract(target), "Address: static call to non-contract");
242 
243         (bool success, bytes memory returndata) = target.staticcall(data);
244         return verifyCallResult(success, returndata, errorMessage);
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
249      * but performing a delegate call.
250      *
251      * _Available since v3.4._
252      */
253     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
254         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
259      * but performing a delegate call.
260      *
261      * _Available since v3.4._
262      */
263     function functionDelegateCall(
264         address target,
265         bytes memory data,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         require(isContract(target), "Address: delegate call to non-contract");
269 
270         (bool success, bytes memory returndata) = target.delegatecall(data);
271         return verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     /**
275      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
276      * revert reason using the provided one.
277      *
278      * _Available since v4.3._
279      */
280     function verifyCallResult(
281         bool success,
282         bytes memory returndata,
283         string memory errorMessage
284     ) internal pure returns (bytes memory) {
285         if (success) {
286             return returndata;
287         } else {
288             // Look for revert reason and bubble it up if present
289             if (returndata.length > 0) {
290                 // The easiest way to bubble the revert reason is using memory via assembly
291 
292                 assembly {
293                     let returndata_size := mload(returndata)
294                     revert(add(32, returndata), returndata_size)
295                 }
296             } else {
297                 revert(errorMessage);
298             }
299         }
300     }
301 }
302 
303 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
304 
305 
306 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 /**
311  * @title ERC721 token receiver interface
312  * @dev Interface for any contract that wants to support safeTransfers
313  * from ERC721 asset contracts.
314  */
315 interface IERC721Receiver {
316     /**
317      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
318      * by `operator` from `from`, this function is called.
319      *
320      * It must return its Solidity selector to confirm the token transfer.
321      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
322      *
323      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
324      */
325     function onERC721Received(
326         address operator,
327         address from,
328         uint256 tokenId,
329         bytes calldata data
330     ) external returns (bytes4);
331 }
332 
333 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
334 
335 
336 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
337 
338 pragma solidity ^0.8.0;
339 
340 /**
341  * @dev Interface of the ERC165 standard, as defined in the
342  * https://eips.ethereum.org/EIPS/eip-165[EIP].
343  *
344  * Implementers can declare support of contract interfaces, which can then be
345  * queried by others ({ERC165Checker}).
346  *
347  * For an implementation, see {ERC165}.
348  */
349 interface IERC165 {
350     /**
351      * @dev Returns true if this contract implements the interface defined by
352      * `interfaceId`. See the corresponding
353      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
354      * to learn more about how these ids are created.
355      *
356      * This function call must use less than 30 000 gas.
357      */
358     function supportsInterface(bytes4 interfaceId) external view returns (bool);
359 }
360 
361 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
362 
363 
364 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
365 
366 pragma solidity ^0.8.0;
367 
368 
369 /**
370  * @dev Implementation of the {IERC165} interface.
371  *
372  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
373  * for the additional interface id that will be supported. For example:
374  *
375  * ```solidity
376  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
377  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
378  * }
379  * ```
380  *
381  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
382  */
383 abstract contract ERC165 is IERC165 {
384     /**
385      * @dev See {IERC165-supportsInterface}.
386      */
387     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
388         return interfaceId == type(IERC165).interfaceId;
389     }
390 }
391 
392 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
393 
394 
395 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 
400 /**
401  * @dev Required interface of an ERC721 compliant contract.
402  */
403 interface IERC721 is IERC165 {
404     /**
405      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
406      */
407     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
408 
409     /**
410      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
411      */
412     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
413 
414     /**
415      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
416      */
417     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
418 
419     /**
420      * @dev Returns the number of tokens in ``owner``'s account.
421      */
422     function balanceOf(address owner) external view returns (uint256 balance);
423 
424     /**
425      * @dev Returns the owner of the `tokenId` token.
426      *
427      * Requirements:
428      *
429      * - `tokenId` must exist.
430      */
431     function ownerOf(uint256 tokenId) external view returns (address owner);
432 
433     /**
434      * @dev Safely transfers `tokenId` token from `from` to `to`.
435      *
436      * Requirements:
437      *
438      * - `from` cannot be the zero address.
439      * - `to` cannot be the zero address.
440      * - `tokenId` token must exist and be owned by `from`.
441      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
442      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
443      *
444      * Emits a {Transfer} event.
445      */
446     function safeTransferFrom(
447         address from,
448         address to,
449         uint256 tokenId,
450         bytes calldata data
451     ) external;
452 
453     /**
454      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
455      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
456      *
457      * Requirements:
458      *
459      * - `from` cannot be the zero address.
460      * - `to` cannot be the zero address.
461      * - `tokenId` token must exist and be owned by `from`.
462      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
463      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
464      *
465      * Emits a {Transfer} event.
466      */
467     function safeTransferFrom(
468         address from,
469         address to,
470         uint256 tokenId
471     ) external;
472 
473     /**
474      * @dev Transfers `tokenId` token from `from` to `to`.
475      *
476      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
477      *
478      * Requirements:
479      *
480      * - `from` cannot be the zero address.
481      * - `to` cannot be the zero address.
482      * - `tokenId` token must be owned by `from`.
483      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
484      *
485      * Emits a {Transfer} event.
486      */
487     function transferFrom(
488         address from,
489         address to,
490         uint256 tokenId
491     ) external;
492 
493     /**
494      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
495      * The approval is cleared when the token is transferred.
496      *
497      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
498      *
499      * Requirements:
500      *
501      * - The caller must own the token or be an approved operator.
502      * - `tokenId` must exist.
503      *
504      * Emits an {Approval} event.
505      */
506     function approve(address to, uint256 tokenId) external;
507 
508     /**
509      * @dev Approve or remove `operator` as an operator for the caller.
510      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
511      *
512      * Requirements:
513      *
514      * - The `operator` cannot be the caller.
515      *
516      * Emits an {ApprovalForAll} event.
517      */
518     function setApprovalForAll(address operator, bool _approved) external;
519 
520     /**
521      * @dev Returns the account approved for `tokenId` token.
522      *
523      * Requirements:
524      *
525      * - `tokenId` must exist.
526      */
527     function getApproved(uint256 tokenId) external view returns (address operator);
528 
529     /**
530      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
531      *
532      * See {setApprovalForAll}
533      */
534     function isApprovedForAll(address owner, address operator) external view returns (bool);
535 }
536 
537 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 
545 /**
546  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
547  * @dev See https://eips.ethereum.org/EIPS/eip-721
548  */
549 interface IERC721Metadata is IERC721 {
550     /**
551      * @dev Returns the token collection name.
552      */
553     function name() external view returns (string memory);
554 
555     /**
556      * @dev Returns the token collection symbol.
557      */
558     function symbol() external view returns (string memory);
559 
560     /**
561      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
562      */
563     function tokenURI(uint256 tokenId) external view returns (string memory);
564 }
565 
566 // File: erc721a/contracts/IERC721A.sol
567 
568 
569 // ERC721A Contracts v3.3.0
570 // Creator: Chiru Labs
571 
572 pragma solidity ^0.8.4;
573 
574 
575 
576 /**
577  * @dev Interface of an ERC721A compliant contract.
578  */
579 interface IERC721A is IERC721, IERC721Metadata {
580     /**
581      * The caller must own the token or be an approved operator.
582      */
583     error ApprovalCallerNotOwnerNorApproved();
584 
585     /**
586      * The token does not exist.
587      */
588     error ApprovalQueryForNonexistentToken();
589 
590     /**
591      * The caller cannot approve to their own address.
592      */
593     error ApproveToCaller();
594 
595     /**
596      * The caller cannot approve to the current owner.
597      */
598     error ApprovalToCurrentOwner();
599 
600     /**
601      * Cannot query the balance for the zero address.
602      */
603     error BalanceQueryForZeroAddress();
604 
605     /**
606      * Cannot mint to the zero address.
607      */
608     error MintToZeroAddress();
609 
610     /**
611      * The quantity of tokens minted must be more than zero.
612      */
613     error MintZeroQuantity();
614 
615     /**
616      * The token does not exist.
617      */
618     error OwnerQueryForNonexistentToken();
619 
620     /**
621      * The caller must own the token or be an approved operator.
622      */
623     error TransferCallerNotOwnerNorApproved();
624 
625     /**
626      * The token must be owned by `from`.
627      */
628     error TransferFromIncorrectOwner();
629 
630     /**
631      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
632      */
633     error TransferToNonERC721ReceiverImplementer();
634 
635     /**
636      * Cannot transfer to the zero address.
637      */
638     error TransferToZeroAddress();
639 
640     /**
641      * The token does not exist.
642      */
643     error URIQueryForNonexistentToken();
644 
645     // Compiler will pack this into a single 256bit word.
646     struct TokenOwnership {
647         // The address of the owner.
648         address addr;
649         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
650         uint64 startTimestamp;
651         // Whether the token has been burned.
652         bool burned;
653     }
654 
655     // Compiler will pack this into a single 256bit word.
656     struct AddressData {
657         // Realistically, 2**64-1 is more than enough.
658         uint64 balance;
659         // Keeps track of mint count with minimal overhead for tokenomics.
660         uint64 numberMinted;
661         // Keeps track of burn count with minimal overhead for tokenomics.
662         uint64 numberBurned;
663         // For miscellaneous variable(s) pertaining to the address
664         // (e.g. number of whitelist mint slots used).
665         // If there are multiple variables, please pack them into a uint64.
666         uint64 aux;
667     }
668 
669     /**
670      * @dev Returns the total amount of tokens stored by the contract.
671      * 
672      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
673      */
674     function totalSupply() external view returns (uint256);
675 }
676 
677 // File: @openzeppelin/contracts/utils/Context.sol
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 /**
685  * @dev Provides information about the current execution context, including the
686  * sender of the transaction and its data. While these are generally available
687  * via msg.sender and msg.data, they should not be accessed in such a direct
688  * manner, since when dealing with meta-transactions the account sending and
689  * paying for execution may not be the actual sender (as far as an application
690  * is concerned).
691  *
692  * This contract is only required for intermediate, library-like contracts.
693  */
694 abstract contract Context {
695     function _msgSender() internal view virtual returns (address) {
696         return msg.sender;
697     }
698 
699     function _msgData() internal view virtual returns (bytes calldata) {
700         return msg.data;
701     }
702 }
703 
704 // File: erc721a/contracts/ERC721A.sol
705 
706 
707 // ERC721A Contracts v3.3.0
708 // Creator: Chiru Labs
709 
710 pragma solidity ^0.8.4;
711 
712 
713 
714 
715 
716 
717 
718 /**
719  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
720  * the Metadata extension. Built to optimize for lower gas during batch mints.
721  *
722  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
723  *
724  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
725  *
726  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
727  */
728 contract ERC721A is Context, ERC165, IERC721A {
729     using Address for address;
730     using Strings for uint256;
731 
732     // The tokenId of the next token to be minted.
733     uint256 internal _currentIndex;
734 
735     // The number of tokens burned.
736     uint256 internal _burnCounter;
737 
738     // Token name
739     string private _name;
740 
741     // Token symbol
742     string private _symbol;
743 
744     // Mapping from token ID to ownership details
745     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
746     mapping(uint256 => TokenOwnership) internal _ownerships;
747 
748     // Mapping owner address to address data
749     mapping(address => AddressData) private _addressData;
750 
751     // Mapping from token ID to approved address
752     mapping(uint256 => address) private _tokenApprovals;
753 
754     // Mapping from owner to operator approvals
755     mapping(address => mapping(address => bool)) private _operatorApprovals;
756 
757     constructor(string memory name_, string memory symbol_) {
758         _name = name_;
759         _symbol = symbol_;
760         _currentIndex = _startTokenId();
761     }
762 
763     /**
764      * To change the starting tokenId, please override this function.
765      */
766     function _startTokenId() internal view virtual returns (uint256) {
767         return 0;
768     }
769 
770     /**
771      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
772      */
773     function totalSupply() public view override returns (uint256) {
774         // Counter underflow is impossible as _burnCounter cannot be incremented
775         // more than _currentIndex - _startTokenId() times
776         unchecked {
777             return _currentIndex - _burnCounter - _startTokenId();
778         }
779     }
780 
781     /**
782      * Returns the total amount of tokens minted in the contract.
783      */
784     function _totalMinted() internal view returns (uint256) {
785         // Counter underflow is impossible as _currentIndex does not decrement,
786         // and it is initialized to _startTokenId()
787         unchecked {
788             return _currentIndex - _startTokenId();
789         }
790     }
791 
792     /**
793      * @dev See {IERC165-supportsInterface}.
794      */
795     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
796         return
797             interfaceId == type(IERC721).interfaceId ||
798             interfaceId == type(IERC721Metadata).interfaceId ||
799             super.supportsInterface(interfaceId);
800     }
801 
802     /**
803      * @dev See {IERC721-balanceOf}.
804      */
805     function balanceOf(address owner) public view override returns (uint256) {
806         if (owner == address(0)) revert BalanceQueryForZeroAddress();
807         return uint256(_addressData[owner].balance);
808     }
809 
810     /**
811      * Returns the number of tokens minted by `owner`.
812      */
813     function _numberMinted(address owner) internal view returns (uint256) {
814         return uint256(_addressData[owner].numberMinted);
815     }
816 
817     /**
818      * Returns the number of tokens burned by or on behalf of `owner`.
819      */
820     function _numberBurned(address owner) internal view returns (uint256) {
821         return uint256(_addressData[owner].numberBurned);
822     }
823 
824     /**
825      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
826      */
827     function _getAux(address owner) internal view returns (uint64) {
828         return _addressData[owner].aux;
829     }
830 
831     /**
832      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
833      * If there are multiple variables, please pack them into a uint64.
834      */
835     function _setAux(address owner, uint64 aux) internal {
836         _addressData[owner].aux = aux;
837     }
838 
839     /**
840      * Gas spent here starts off proportional to the maximum mint batch size.
841      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
842      */
843     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
844         uint256 curr = tokenId;
845 
846         unchecked {
847             if (_startTokenId() <= curr) if (curr < _currentIndex) {
848                 TokenOwnership memory ownership = _ownerships[curr];
849                 if (!ownership.burned) {
850                     if (ownership.addr != address(0)) {
851                         return ownership;
852                     }
853                     // Invariant:
854                     // There will always be an ownership that has an address and is not burned
855                     // before an ownership that does not have an address and is not burned.
856                     // Hence, curr will not underflow.
857                     while (true) {
858                         curr--;
859                         ownership = _ownerships[curr];
860                         if (ownership.addr != address(0)) {
861                             return ownership;
862                         }
863                     }
864                 }
865             }
866         }
867         revert OwnerQueryForNonexistentToken();
868     }
869 
870     /**
871      * @dev See {IERC721-ownerOf}.
872      */
873     function ownerOf(uint256 tokenId) public view override returns (address) {
874         return _ownershipOf(tokenId).addr;
875     }
876 
877     /**
878      * @dev See {IERC721Metadata-name}.
879      */
880     function name() public view virtual override returns (string memory) {
881         return _name;
882     }
883 
884     /**
885      * @dev See {IERC721Metadata-symbol}.
886      */
887     function symbol() public view virtual override returns (string memory) {
888         return _symbol;
889     }
890 
891     /**
892      * @dev See {IERC721Metadata-tokenURI}.
893      */
894     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
895         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
896 
897         string memory baseURI = _baseURI();
898         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
899     }
900 
901     /**
902      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
903      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
904      * by default, can be overriden in child contracts.
905      */
906     function _baseURI() internal view virtual returns (string memory) {
907         return '';
908     }
909 
910     /**
911      * @dev See {IERC721-approve}.
912      */
913     function approve(address to, uint256 tokenId) public override {
914         address owner = ERC721A.ownerOf(tokenId);
915         if (to == owner) revert ApprovalToCurrentOwner();
916 
917         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
918             revert ApprovalCallerNotOwnerNorApproved();
919         }
920 
921         _approve(to, tokenId, owner);
922     }
923 
924     /**
925      * @dev See {IERC721-getApproved}.
926      */
927     function getApproved(uint256 tokenId) public view override returns (address) {
928         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
929 
930         return _tokenApprovals[tokenId];
931     }
932 
933     /**
934      * @dev See {IERC721-setApprovalForAll}.
935      */
936     function setApprovalForAll(address operator, bool approved) public virtual override {
937         if (operator == _msgSender()) revert ApproveToCaller();
938 
939         _operatorApprovals[_msgSender()][operator] = approved;
940         emit ApprovalForAll(_msgSender(), operator, approved);
941     }
942 
943     /**
944      * @dev See {IERC721-isApprovedForAll}.
945      */
946     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
947         return _operatorApprovals[owner][operator];
948     }
949 
950     /**
951      * @dev See {IERC721-transferFrom}.
952      */
953     function transferFrom(
954         address from,
955         address to,
956         uint256 tokenId
957     ) public virtual override {
958         _transfer(from, to, tokenId);
959     }
960 
961     /**
962      * @dev See {IERC721-safeTransferFrom}.
963      */
964     function safeTransferFrom(
965         address from,
966         address to,
967         uint256 tokenId
968     ) public virtual override {
969         safeTransferFrom(from, to, tokenId, '');
970     }
971 
972     /**
973      * @dev See {IERC721-safeTransferFrom}.
974      */
975     function safeTransferFrom(
976         address from,
977         address to,
978         uint256 tokenId,
979         bytes memory _data
980     ) public virtual override {
981         _transfer(from, to, tokenId);
982         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
983             revert TransferToNonERC721ReceiverImplementer();
984         }
985     }
986 
987     /**
988      * @dev Returns whether `tokenId` exists.
989      *
990      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
991      *
992      * Tokens start existing when they are minted (`_mint`),
993      */
994     function _exists(uint256 tokenId) internal view returns (bool) {
995         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
996     }
997 
998     /**
999      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1000      */
1001     function _safeMint(address to, uint256 quantity) internal {
1002         _safeMint(to, quantity, '');
1003     }
1004 
1005     /**
1006      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1007      *
1008      * Requirements:
1009      *
1010      * - If `to` refers to a smart contract, it must implement
1011      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1012      * - `quantity` must be greater than 0.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _safeMint(
1017         address to,
1018         uint256 quantity,
1019         bytes memory _data
1020     ) internal {
1021         uint256 startTokenId = _currentIndex;
1022         if (to == address(0)) revert MintToZeroAddress();
1023         if (quantity == 0) revert MintZeroQuantity();
1024 
1025         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1026 
1027         // Overflows are incredibly unrealistic.
1028         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1029         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1030         unchecked {
1031             _addressData[to].balance += uint64(quantity);
1032             _addressData[to].numberMinted += uint64(quantity);
1033 
1034             _ownerships[startTokenId].addr = to;
1035             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1036 
1037             uint256 updatedIndex = startTokenId;
1038             uint256 end = updatedIndex + quantity;
1039 
1040             if (to.isContract()) {
1041                 do {
1042                     emit Transfer(address(0), to, updatedIndex);
1043                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1044                         revert TransferToNonERC721ReceiverImplementer();
1045                     }
1046                 } while (updatedIndex < end);
1047                 // Reentrancy protection
1048                 if (_currentIndex != startTokenId) revert();
1049             } else {
1050                 do {
1051                     emit Transfer(address(0), to, updatedIndex++);
1052                 } while (updatedIndex < end);
1053             }
1054             _currentIndex = updatedIndex;
1055         }
1056         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1057     }
1058 
1059     /**
1060      * @dev Mints `quantity` tokens and transfers them to `to`.
1061      *
1062      * Requirements:
1063      *
1064      * - `to` cannot be the zero address.
1065      * - `quantity` must be greater than 0.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function _mint(address to, uint256 quantity) internal {
1070         uint256 startTokenId = _currentIndex;
1071         if (to == address(0)) revert MintToZeroAddress();
1072         if (quantity == 0) revert MintZeroQuantity();
1073 
1074         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1075 
1076         // Overflows are incredibly unrealistic.
1077         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1078         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1079         unchecked {
1080             _addressData[to].balance += uint64(quantity);
1081             _addressData[to].numberMinted += uint64(quantity);
1082 
1083             _ownerships[startTokenId].addr = to;
1084             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1085 
1086             uint256 updatedIndex = startTokenId;
1087             uint256 end = updatedIndex + quantity;
1088 
1089             do {
1090                 emit Transfer(address(0), to, updatedIndex++);
1091             } while (updatedIndex < end);
1092 
1093             _currentIndex = updatedIndex;
1094         }
1095         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1096     }
1097 
1098     /**
1099      * @dev Transfers `tokenId` from `from` to `to`.
1100      *
1101      * Requirements:
1102      *
1103      * - `to` cannot be the zero address.
1104      * - `tokenId` token must be owned by `from`.
1105      *
1106      * Emits a {Transfer} event.
1107      */
1108     function _transfer(
1109         address from,
1110         address to,
1111         uint256 tokenId
1112     ) private {
1113         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1114 
1115         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1116 
1117         bool isApprovedOrOwner = (_msgSender() == from ||
1118             isApprovedForAll(from, _msgSender()) ||
1119             getApproved(tokenId) == _msgSender());
1120 
1121         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1122         if (to == address(0)) revert TransferToZeroAddress();
1123 
1124         _beforeTokenTransfers(from, to, tokenId, 1);
1125 
1126         // Clear approvals from the previous owner
1127         _approve(address(0), tokenId, from);
1128 
1129         // Underflow of the sender's balance is impossible because we check for
1130         // ownership above and the recipient's balance can't realistically overflow.
1131         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1132         unchecked {
1133             _addressData[from].balance -= 1;
1134             _addressData[to].balance += 1;
1135 
1136             TokenOwnership storage currSlot = _ownerships[tokenId];
1137             currSlot.addr = to;
1138             currSlot.startTimestamp = uint64(block.timestamp);
1139 
1140             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1141             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1142             uint256 nextTokenId = tokenId + 1;
1143             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1144             if (nextSlot.addr == address(0)) {
1145                 // This will suffice for checking _exists(nextTokenId),
1146                 // as a burned slot cannot contain the zero address.
1147                 if (nextTokenId != _currentIndex) {
1148                     nextSlot.addr = from;
1149                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1150                 }
1151             }
1152         }
1153 
1154         emit Transfer(from, to, tokenId);
1155         _afterTokenTransfers(from, to, tokenId, 1);
1156     }
1157 
1158     /**
1159      * @dev Equivalent to `_burn(tokenId, false)`.
1160      */
1161     function _burn(uint256 tokenId) internal virtual {
1162         _burn(tokenId, false);
1163     }
1164 
1165     /**
1166      * @dev Destroys `tokenId`.
1167      * The approval is cleared when the token is burned.
1168      *
1169      * Requirements:
1170      *
1171      * - `tokenId` must exist.
1172      *
1173      * Emits a {Transfer} event.
1174      */
1175     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1176         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1177 
1178         address from = prevOwnership.addr;
1179 
1180         if (approvalCheck) {
1181             bool isApprovedOrOwner = (_msgSender() == from ||
1182                 isApprovedForAll(from, _msgSender()) ||
1183                 getApproved(tokenId) == _msgSender());
1184 
1185             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1186         }
1187 
1188         _beforeTokenTransfers(from, address(0), tokenId, 1);
1189 
1190         // Clear approvals from the previous owner
1191         _approve(address(0), tokenId, from);
1192 
1193         // Underflow of the sender's balance is impossible because we check for
1194         // ownership above and the recipient's balance can't realistically overflow.
1195         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1196         unchecked {
1197             AddressData storage addressData = _addressData[from];
1198             addressData.balance -= 1;
1199             addressData.numberBurned += 1;
1200 
1201             // Keep track of who burned the token, and the timestamp of burning.
1202             TokenOwnership storage currSlot = _ownerships[tokenId];
1203             currSlot.addr = from;
1204             currSlot.startTimestamp = uint64(block.timestamp);
1205             currSlot.burned = true;
1206 
1207             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1208             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1209             uint256 nextTokenId = tokenId + 1;
1210             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1211             if (nextSlot.addr == address(0)) {
1212                 // This will suffice for checking _exists(nextTokenId),
1213                 // as a burned slot cannot contain the zero address.
1214                 if (nextTokenId != _currentIndex) {
1215                     nextSlot.addr = from;
1216                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1217                 }
1218             }
1219         }
1220 
1221         emit Transfer(from, address(0), tokenId);
1222         _afterTokenTransfers(from, address(0), tokenId, 1);
1223 
1224         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1225         unchecked {
1226             _burnCounter++;
1227         }
1228     }
1229 
1230     /**
1231      * @dev Approve `to` to operate on `tokenId`
1232      *
1233      * Emits a {Approval} event.
1234      */
1235     function _approve(
1236         address to,
1237         uint256 tokenId,
1238         address owner
1239     ) private {
1240         _tokenApprovals[tokenId] = to;
1241         emit Approval(owner, to, tokenId);
1242     }
1243 
1244     /**
1245      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1246      *
1247      * @param from address representing the previous owner of the given token ID
1248      * @param to target address that will receive the tokens
1249      * @param tokenId uint256 ID of the token to be transferred
1250      * @param _data bytes optional data to send along with the call
1251      * @return bool whether the call correctly returned the expected magic value
1252      */
1253     function _checkContractOnERC721Received(
1254         address from,
1255         address to,
1256         uint256 tokenId,
1257         bytes memory _data
1258     ) private returns (bool) {
1259         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1260             return retval == IERC721Receiver(to).onERC721Received.selector;
1261         } catch (bytes memory reason) {
1262             if (reason.length == 0) {
1263                 revert TransferToNonERC721ReceiverImplementer();
1264             } else {
1265                 assembly {
1266                     revert(add(32, reason), mload(reason))
1267                 }
1268             }
1269         }
1270     }
1271 
1272     /**
1273      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1274      * And also called before burning one token.
1275      *
1276      * startTokenId - the first token id to be transferred
1277      * quantity - the amount to be transferred
1278      *
1279      * Calling conditions:
1280      *
1281      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1282      * transferred to `to`.
1283      * - When `from` is zero, `tokenId` will be minted for `to`.
1284      * - When `to` is zero, `tokenId` will be burned by `from`.
1285      * - `from` and `to` are never both zero.
1286      */
1287     function _beforeTokenTransfers(
1288         address from,
1289         address to,
1290         uint256 startTokenId,
1291         uint256 quantity
1292     ) internal virtual {}
1293 
1294     /**
1295      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1296      * minting.
1297      * And also called after one token has been burned.
1298      *
1299      * startTokenId - the first token id to be transferred
1300      * quantity - the amount to be transferred
1301      *
1302      * Calling conditions:
1303      *
1304      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1305      * transferred to `to`.
1306      * - When `from` is zero, `tokenId` has been minted for `to`.
1307      * - When `to` is zero, `tokenId` has been burned by `from`.
1308      * - `from` and `to` are never both zero.
1309      */
1310     function _afterTokenTransfers(
1311         address from,
1312         address to,
1313         uint256 startTokenId,
1314         uint256 quantity
1315     ) internal virtual {}
1316 }
1317 
1318 // File: @openzeppelin/contracts/access/Ownable.sol
1319 
1320 
1321 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1322 
1323 pragma solidity ^0.8.0;
1324 
1325 
1326 /**
1327  * @dev Contract module which provides a basic access control mechanism, where
1328  * there is an account (an owner) that can be granted exclusive access to
1329  * specific functions.
1330  *
1331  * By default, the owner account will be the one that deploys the contract. This
1332  * can later be changed with {transferOwnership}.
1333  *
1334  * This module is used through inheritance. It will make available the modifier
1335  * `onlyOwner`, which can be applied to your functions to restrict their use to
1336  * the owner.
1337  */
1338 abstract contract Ownable is Context {
1339     address private _owner;
1340 
1341     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1342 
1343     /**
1344      * @dev Initializes the contract setting the deployer as the initial owner.
1345      */
1346     constructor() {
1347         _transferOwnership(_msgSender());
1348     }
1349 
1350     /**
1351      * @dev Returns the address of the current owner.
1352      */
1353     function owner() public view virtual returns (address) {
1354         return _owner;
1355     }
1356 
1357     /**
1358      * @dev Throws if called by any account other than the owner.
1359      */
1360     modifier onlyOwner() {
1361         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1362         _;
1363     }
1364 
1365     /**
1366      * @dev Leaves the contract without owner. It will not be possible to call
1367      * `onlyOwner` functions anymore. Can only be called by the current owner.
1368      *
1369      * NOTE: Renouncing ownership will leave the contract without an owner,
1370      * thereby removing any functionality that is only available to the owner.
1371      */
1372     function renounceOwnership() public virtual onlyOwner {
1373         _transferOwnership(address(0));
1374     }
1375 
1376     /**
1377      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1378      * Can only be called by the current owner.
1379      */
1380     function transferOwnership(address newOwner) public virtual onlyOwner {
1381         require(newOwner != address(0), "Ownable: new owner is the zero address");
1382         _transferOwnership(newOwner);
1383     }
1384 
1385     /**
1386      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1387      * Internal function without access restriction.
1388      */
1389     function _transferOwnership(address newOwner) internal virtual {
1390         address oldOwner = _owner;
1391         _owner = newOwner;
1392         emit OwnershipTransferred(oldOwner, newOwner);
1393     }
1394 }
1395 
1396 
1397 
1398 pragma solidity ^0.8.0;
1399 
1400 
1401 
1402 contract PEPECARD is ERC721A, Ownable {
1403 	using Strings for uint;
1404 
1405 	uint public constant MINT_PRICE = 0.003 ether;
1406 	uint public constant MAX_NFT_PER_TRAN = 10;
1407     uint public constant MAX_PER_WALLET = 11;
1408 	address private immutable SPLITTER_ADDRESS;
1409 	uint public maxSupply = 5555;
1410 
1411 	bool public isPaused;
1412     bool public isMetadataFinal;
1413     string private _baseURL;
1414 	string public prerevealURL = '';
1415 	mapping(address => uint) private _walletMintedCount;
1416 
1417 	constructor(address splitterAddress)
1418     // Name
1419 	ERC721A('PEPE CARD : BACK TO BEGIN', 'PPCD') {
1420         SPLITTER_ADDRESS = splitterAddress;
1421     }
1422 
1423 	function _baseURI() internal view override returns (string memory) {
1424 		return _baseURL;
1425 	}
1426 
1427 	function _startTokenId() internal pure override returns (uint) {
1428 		return 1;
1429 	}
1430 
1431 	function contractURI() public pure returns (string memory) {
1432 		return "";
1433 	}
1434 
1435     function finalizeMetadata() external onlyOwner {
1436         isMetadataFinal = true;
1437     }
1438 
1439 	function reveal(string memory url) external onlyOwner {
1440         require(!isMetadataFinal, "Metadata is finalized");
1441 		_baseURL = url;
1442 	}
1443 
1444     function mintedCount(address owner) external view returns (uint) {
1445         return _walletMintedCount[owner];
1446     }
1447 
1448 	function setPause(bool value) external onlyOwner {
1449 		isPaused = value;
1450 	}
1451 
1452 	function withdraw() external onlyOwner {
1453 		uint balance = address(this).balance;
1454 		require(balance > 0, 'No balance');
1455 		payable(SPLITTER_ADDRESS).transfer(balance);
1456 	}
1457 
1458 	function airdrop(address to, uint count) external onlyOwner {
1459 		require(
1460 			_totalMinted() + count <= maxSupply,
1461 			'Exceeds max supply'
1462 		);
1463 		_safeMint(to, count);
1464 	}
1465 
1466 	function reduceSupply(uint newMaxSupply) external onlyOwner {
1467 		maxSupply = newMaxSupply;
1468 	}
1469 
1470 	function tokenURI(uint tokenId)
1471 		public
1472 		view
1473 		override
1474 		returns (string memory)
1475 	{
1476         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1477 
1478         return bytes(_baseURI()).length > 0 
1479             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1480             : prerevealURL;
1481 	}
1482 
1483 	function mint(uint count) external payable {
1484 		require(!isPaused, 'Sales are off');
1485 		require(count <= MAX_NFT_PER_TRAN,'Exceeds NFT per transaction limit');
1486 		require(_totalMinted() + count <= maxSupply,'Exceeds max supply');
1487         require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET,'Exceeds max per wallet');
1488 
1489         uint payForCount = count;
1490         uint mintedSoFar = _walletMintedCount[msg.sender];
1491         if(mintedSoFar < 1) {
1492             uint remainingFreeMints = 1 - mintedSoFar;
1493             if(count > remainingFreeMints) {
1494                 payForCount = count - remainingFreeMints;
1495             }
1496             else {
1497                 payForCount = 0;
1498             }
1499         }
1500 
1501 		require(
1502 			msg.value >= payForCount * MINT_PRICE,
1503 			'Ether value sent is not sufficient'
1504 		);
1505 
1506 		_walletMintedCount[msg.sender] += count;
1507 		_safeMint(msg.sender, count);
1508 	}
1509 }