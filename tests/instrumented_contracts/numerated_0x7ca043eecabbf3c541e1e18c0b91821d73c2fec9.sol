1 // SPDX-License-Identifier: MIT
2 
3 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 
11 // File: @openzeppelin/contracts/utils/Strings.sol
12 
13 
14 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev String operations.
20  */
21 library Strings {
22     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
23 
24     /**
25      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
26      */
27     function toString(uint256 value) internal pure returns (string memory) {
28         // Inspired by OraclizeAPI's implementation - MIT licence
29         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
30 
31         if (value == 0) {
32             return "0";
33         }
34         uint256 temp = value;
35         uint256 digits;
36         while (temp != 0) {
37             digits++;
38             temp /= 10;
39         }
40         bytes memory buffer = new bytes(digits);
41         while (value != 0) {
42             digits -= 1;
43             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
44             value /= 10;
45         }
46         return string(buffer);
47     }
48 
49     /**
50      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
51      */
52     function toHexString(uint256 value) internal pure returns (string memory) {
53         if (value == 0) {
54             return "0x00";
55         }
56         uint256 temp = value;
57         uint256 length = 0;
58         while (temp != 0) {
59             length++;
60             temp >>= 8;
61         }
62         return toHexString(value, length);
63     }
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
67      */
68     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
69         bytes memory buffer = new bytes(2 * length + 2);
70         buffer[0] = "0";
71         buffer[1] = "x";
72         for (uint256 i = 2 * length + 1; i > 1; --i) {
73             buffer[i] = _HEX_SYMBOLS[value & 0xf];
74             value >>= 4;
75         }
76         require(value == 0, "Strings: hex length insufficient");
77         return string(buffer);
78     }
79 }
80 
81 // File: @openzeppelin/contracts/utils/Address.sol
82 
83 
84 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
85 
86 pragma solidity ^0.8.1;
87 
88 /**
89  * @dev Collection of functions related to the address type
90  */
91 library Address {
92     /**
93      * @dev Returns true if `account` is a contract.
94      *
95      * [IMPORTANT]
96      * ====
97      * It is unsafe to assume that an address for which this function returns
98      * false is an externally-owned account (EOA) and not a contract.
99      *
100      * Among others, `isContract` will return false for the following
101      * types of addresses:
102      *
103      *  - an externally-owned account
104      *  - a contract in construction
105      *  - an address where a contract will be created
106      *  - an address where a contract lived, but was destroyed
107      * ====
108      *
109      * [IMPORTANT]
110      * ====
111      * You shouldn't rely on `isContract` to protect against flash loan attacks!
112      *
113      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
114      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
115      * constructor.
116      * ====
117      */
118     function isContract(address account) internal view returns (bool) {
119         // This method relies on extcodesize/address.code.length, which returns 0
120         // for contracts in construction, since the code is only stored at the end
121         // of the constructor execution.
122 
123         return account.code.length > 0;
124     }
125 
126     /**
127      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
128      * `recipient`, forwarding all available gas and reverting on errors.
129      *
130      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
131      * of certain opcodes, possibly making contracts go over the 2300 gas limit
132      * imposed by `transfer`, making them unable to receive funds via
133      * `transfer`. {sendValue} removes this limitation.
134      *
135      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
136      *
137      * IMPORTANT: because control is transferred to `recipient`, care must be
138      * taken to not create reentrancy vulnerabilities. Consider using
139      * {ReentrancyGuard} or the
140      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
141      */
142     function sendValue(address payable recipient, uint256 amount) internal {
143         require(address(this).balance >= amount, "Address: insufficient balance");
144 
145         (bool success, ) = recipient.call{value: amount}("");
146         require(success, "Address: unable to send value, recipient may have reverted");
147     }
148 
149     /**
150      * @dev Performs a Solidity function call using a low level `call`. A
151      * plain `call` is an unsafe replacement for a function call: use this
152      * function instead.
153      *
154      * If `target` reverts with a revert reason, it is bubbled up by this
155      * function (like regular Solidity function calls).
156      *
157      * Returns the raw returned data. To convert to the expected return value,
158      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
159      *
160      * Requirements:
161      *
162      * - `target` must be a contract.
163      * - calling `target` with `data` must not revert.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
168         return functionCall(target, data, "Address: low-level call failed");
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
173      * `errorMessage` as a fallback revert reason when `target` reverts.
174      *
175      * _Available since v3.1._
176      */
177     function functionCall(
178         address target,
179         bytes memory data,
180         string memory errorMessage
181     ) internal returns (bytes memory) {
182         return functionCallWithValue(target, data, 0, errorMessage);
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
187      * but also transferring `value` wei to `target`.
188      *
189      * Requirements:
190      *
191      * - the calling contract must have an ETH balance of at least `value`.
192      * - the called Solidity function must be `payable`.
193      *
194      * _Available since v3.1._
195      */
196     function functionCallWithValue(
197         address target,
198         bytes memory data,
199         uint256 value
200     ) internal returns (bytes memory) {
201         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
206      * with `errorMessage` as a fallback revert reason when `target` reverts.
207      *
208      * _Available since v3.1._
209      */
210     function functionCallWithValue(
211         address target,
212         bytes memory data,
213         uint256 value,
214         string memory errorMessage
215     ) internal returns (bytes memory) {
216         require(address(this).balance >= value, "Address: insufficient balance for call");
217         require(isContract(target), "Address: call to non-contract");
218 
219         (bool success, bytes memory returndata) = target.call{value: value}(data);
220         return verifyCallResult(success, returndata, errorMessage);
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
230         return functionStaticCall(target, data, "Address: low-level static call failed");
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
235      * but performing a static call.
236      *
237      * _Available since v3.3._
238      */
239     function functionStaticCall(
240         address target,
241         bytes memory data,
242         string memory errorMessage
243     ) internal view returns (bytes memory) {
244         require(isContract(target), "Address: static call to non-contract");
245 
246         (bool success, bytes memory returndata) = target.staticcall(data);
247         return verifyCallResult(success, returndata, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
257         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
262      * but performing a delegate call.
263      *
264      * _Available since v3.4._
265      */
266     function functionDelegateCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal returns (bytes memory) {
271         require(isContract(target), "Address: delegate call to non-contract");
272 
273         (bool success, bytes memory returndata) = target.delegatecall(data);
274         return verifyCallResult(success, returndata, errorMessage);
275     }
276 
277     /**
278      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
279      * revert reason using the provided one.
280      *
281      * _Available since v4.3._
282      */
283     function verifyCallResult(
284         bool success,
285         bytes memory returndata,
286         string memory errorMessage
287     ) internal pure returns (bytes memory) {
288         if (success) {
289             return returndata;
290         } else {
291             // Look for revert reason and bubble it up if present
292             if (returndata.length > 0) {
293                 // The easiest way to bubble the revert reason is using memory via assembly
294 
295                 assembly {
296                     let returndata_size := mload(returndata)
297                     revert(add(32, returndata), returndata_size)
298                 }
299             } else {
300                 revert(errorMessage);
301             }
302         }
303     }
304 }
305 
306 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
307 
308 
309 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
310 
311 pragma solidity ^0.8.0;
312 
313 /**
314  * @title ERC721 token receiver interface
315  * @dev Interface for any contract that wants to support safeTransfers
316  * from ERC721 asset contracts.
317  */
318 interface IERC721Receiver {
319     /**
320      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
321      * by `operator` from `from`, this function is called.
322      *
323      * It must return its Solidity selector to confirm the token transfer.
324      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
325      *
326      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
327      */
328     function onERC721Received(
329         address operator,
330         address from,
331         uint256 tokenId,
332         bytes calldata data
333     ) external returns (bytes4);
334 }
335 
336 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
337 
338 
339 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @dev Interface of the ERC165 standard, as defined in the
345  * https://eips.ethereum.org/EIPS/eip-165[EIP].
346  *
347  * Implementers can declare support of contract interfaces, which can then be
348  * queried by others ({ERC165Checker}).
349  *
350  * For an implementation, see {ERC165}.
351  */
352 interface IERC165 {
353     /**
354      * @dev Returns true if this contract implements the interface defined by
355      * `interfaceId`. See the corresponding
356      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
357      * to learn more about how these ids are created.
358      *
359      * This function call must use less than 30 000 gas.
360      */
361     function supportsInterface(bytes4 interfaceId) external view returns (bool);
362 }
363 
364 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
365 
366 
367 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
368 
369 pragma solidity ^0.8.0;
370 
371 
372 /**
373  * @dev Implementation of the {IERC165} interface.
374  *
375  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
376  * for the additional interface id that will be supported. For example:
377  *
378  * ```solidity
379  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
380  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
381  * }
382  * ```
383  *
384  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
385  */
386 abstract contract ERC165 is IERC165 {
387     /**
388      * @dev See {IERC165-supportsInterface}.
389      */
390     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
391         return interfaceId == type(IERC165).interfaceId;
392     }
393 }
394 
395 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
396 
397 
398 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 
403 /**
404  * @dev Required interface of an ERC721 compliant contract.
405  */
406 interface IERC721 is IERC165 {
407     /**
408      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
409      */
410     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
411 
412     /**
413      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
414      */
415     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
416 
417     /**
418      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
419      */
420     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
421 
422     /**
423      * @dev Returns the number of tokens in ``owner``'s account.
424      */
425     function balanceOf(address owner) external view returns (uint256 balance);
426 
427     /**
428      * @dev Returns the owner of the `tokenId` token.
429      *
430      * Requirements:
431      *
432      * - `tokenId` must exist.
433      */
434     function ownerOf(uint256 tokenId) external view returns (address owner);
435 
436     /**
437      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
438      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
439      *
440      * Requirements:
441      *
442      * - `from` cannot be the zero address.
443      * - `to` cannot be the zero address.
444      * - `tokenId` token must exist and be owned by `from`.
445      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
446      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
447      *
448      * Emits a {Transfer} event.
449      */
450     function safeTransferFrom(
451         address from,
452         address to,
453         uint256 tokenId
454     ) external;
455 
456     /**
457      * @dev Transfers `tokenId` token from `from` to `to`.
458      *
459      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
460      *
461      * Requirements:
462      *
463      * - `from` cannot be the zero address.
464      * - `to` cannot be the zero address.
465      * - `tokenId` token must be owned by `from`.
466      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
467      *
468      * Emits a {Transfer} event.
469      */
470     function transferFrom(
471         address from,
472         address to,
473         uint256 tokenId
474     ) external;
475 
476     /**
477      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
478      * The approval is cleared when the token is transferred.
479      *
480      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
481      *
482      * Requirements:
483      *
484      * - The caller must own the token or be an approved operator.
485      * - `tokenId` must exist.
486      *
487      * Emits an {Approval} event.
488      */
489     function approve(address to, uint256 tokenId) external;
490 
491     /**
492      * @dev Returns the account approved for `tokenId` token.
493      *
494      * Requirements:
495      *
496      * - `tokenId` must exist.
497      */
498     function getApproved(uint256 tokenId) external view returns (address operator);
499 
500     /**
501      * @dev Approve or remove `operator` as an operator for the caller.
502      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
503      *
504      * Requirements:
505      *
506      * - The `operator` cannot be the caller.
507      *
508      * Emits an {ApprovalForAll} event.
509      */
510     function setApprovalForAll(address operator, bool _approved) external;
511 
512     /**
513      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
514      *
515      * See {setApprovalForAll}
516      */
517     function isApprovedForAll(address owner, address operator) external view returns (bool);
518 
519     /**
520      * @dev Safely transfers `tokenId` token from `from` to `to`.
521      *
522      * Requirements:
523      *
524      * - `from` cannot be the zero address.
525      * - `to` cannot be the zero address.
526      * - `tokenId` token must exist and be owned by `from`.
527      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
528      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
529      *
530      * Emits a {Transfer} event.
531      */
532     function safeTransferFrom(
533         address from,
534         address to,
535         uint256 tokenId,
536         bytes calldata data
537     ) external;
538 }
539 
540 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
541 
542 
543 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 
548 /**
549  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
550  * @dev See https://eips.ethereum.org/EIPS/eip-721
551  */
552 interface IERC721Metadata is IERC721 {
553     /**
554      * @dev Returns the token collection name.
555      */
556     function name() external view returns (string memory);
557 
558     /**
559      * @dev Returns the token collection symbol.
560      */
561     function symbol() external view returns (string memory);
562 
563     /**
564      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
565      */
566     function tokenURI(uint256 tokenId) external view returns (string memory);
567 }
568 
569 // File: @openzeppelin/contracts/utils/Context.sol
570 
571 
572 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 /**
577  * @dev Provides information about the current execution context, including the
578  * sender of the transaction and its data. While these are generally available
579  * via msg.sender and msg.data, they should not be accessed in such a direct
580  * manner, since when dealing with meta-transactions the account sending and
581  * paying for execution may not be the actual sender (as far as an application
582  * is concerned).
583  *
584  * This contract is only required for intermediate, library-like contracts.
585  */
586 abstract contract Context {
587     function _msgSender() internal view virtual returns (address) {
588         return msg.sender;
589     }
590 
591     function _msgData() internal view virtual returns (bytes calldata) {
592         return msg.data;
593     }
594 }
595 
596 // File: contracts/erc721a.sol
597 
598 
599 
600 // Creator: Chiru Labs
601 
602 
603 
604 pragma solidity ^0.8.4;
605 
606 
607 
608 
609 
610 
611 
612 
613 
614 
615 error ApprovalCallerNotOwnerNorApproved();
616 
617 error ApprovalQueryForNonexistentToken();
618 
619 error ApproveToCaller();
620 
621 error ApprovalToCurrentOwner();
622 
623 error BalanceQueryForZeroAddress();
624 
625 error MintToZeroAddress();
626 
627 error MintZeroQuantity();
628 
629 error OwnerQueryForNonexistentToken();
630 
631 error TransferCallerNotOwnerNorApproved();
632 
633 error TransferFromIncorrectOwner();
634 
635 error TransferToNonERC721ReceiverImplementer();
636 
637 error TransferToZeroAddress();
638 
639 error URIQueryForNonexistentToken();
640 
641 
642 
643 /**
644 
645  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
646 
647  * the Metadata extension. Built to optimize for lower gas during batch mints.
648 
649  *
650 
651  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
652 
653  *
654 
655  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
656 
657  *
658 
659  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
660 
661  */
662 
663 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
664 
665     using Address for address;
666 
667     using Strings for uint256;
668 
669 
670 
671     // Compiler will pack this into a single 256bit word.
672 
673     struct TokenOwnership {
674 
675         // The address of the owner.
676 
677         address addr;
678 
679         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
680 
681         uint64 startTimestamp;
682 
683         // Whether the token has been burned.
684 
685         bool burned;
686 
687     }
688 
689 
690 
691     // Compiler will pack this into a single 256bit word.
692 
693     struct AddressData {
694 
695         // Realistically, 2**64-1 is more than enough.
696 
697         uint64 balance;
698 
699         // Keeps track of mint count with minimal overhead for tokenomics.
700 
701         uint64 numberMinted;
702 
703         // Keeps track of burn count with minimal overhead for tokenomics.
704 
705         uint64 numberBurned;
706 
707         // For miscellaneous variable(s) pertaining to the address
708 
709         // (e.g. number of whitelist mint slots used).
710 
711         // If there are multiple variables, please pack them into a uint64.
712 
713         uint64 aux;
714 
715     }
716 
717 
718 
719     // The tokenId of the next token to be minted.
720 
721     uint256 internal _currentIndex;
722 
723 
724 
725     // The number of tokens burned.
726 
727     uint256 internal _burnCounter;
728 
729 
730 
731     // Token name
732 
733     string private _name;
734 
735 
736 
737     // Token symbol
738 
739     string private _symbol;
740 
741 
742 
743     // Mapping from token ID to ownership details
744 
745     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
746 
747     mapping(uint256 => TokenOwnership) internal _ownerships;
748 
749 
750 
751     // Mapping owner address to address data
752 
753     mapping(address => AddressData) private _addressData;
754 
755 
756 
757     // Mapping from token ID to approved address
758 
759     mapping(uint256 => address) private _tokenApprovals;
760 
761 
762 
763     // Mapping from owner to operator approvals
764 
765     mapping(address => mapping(address => bool)) private _operatorApprovals;
766 
767 
768 
769     constructor(string memory name_, string memory symbol_) {
770 
771         _name = name_;
772 
773         _symbol = symbol_;
774 
775         _currentIndex = _startTokenId();
776 
777     }
778 
779 
780 
781     /**
782 
783      * To change the starting tokenId, please override this function.
784 
785      */
786 
787     function _startTokenId() internal view virtual returns (uint256) {
788 
789         return 1;
790 
791     }
792 
793 
794 
795     /**
796 
797      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
798 
799      */
800 
801     function totalSupply() public view returns (uint256) {
802 
803         // Counter underflow is impossible as _burnCounter cannot be incremented
804 
805         // more than _currentIndex - _startTokenId() times
806 
807         unchecked {
808 
809             return _currentIndex - _burnCounter - _startTokenId();
810 
811         }
812 
813     }
814 
815 
816 
817     /**
818 
819      * Returns the total amount of tokens minted in the contract.
820 
821      */
822 
823     function _totalMinted() internal view returns (uint256) {
824 
825         // Counter underflow is impossible as _currentIndex does not decrement,
826 
827         // and it is initialized to _startTokenId()
828 
829         unchecked {
830 
831             return _currentIndex - _startTokenId();
832 
833         }
834 
835     }
836 
837 
838 
839     /**
840 
841      * @dev See {IERC165-supportsInterface}.
842 
843      */
844 
845     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
846 
847         return
848 
849             interfaceId == type(IERC721).interfaceId ||
850 
851             interfaceId == type(IERC721Metadata).interfaceId ||
852 
853             super.supportsInterface(interfaceId);
854 
855     }
856 
857 
858 
859     /**
860 
861      * @dev See {IERC721-balanceOf}.
862 
863      */
864 
865     function balanceOf(address owner) public view override returns (uint256) {
866 
867         if (owner == address(0)) revert BalanceQueryForZeroAddress();
868 
869         return uint256(_addressData[owner].balance);
870 
871     }
872 
873 
874 
875     /**
876 
877      * Returns the number of tokens minted by `owner`.
878 
879      */
880 
881     function _numberMinted(address owner) internal view returns (uint256) {
882 
883         return uint256(_addressData[owner].numberMinted);
884 
885     }
886 
887 
888 
889     /**
890 
891      * Returns the number of tokens burned by or on behalf of `owner`.
892 
893      */
894 
895     function _numberBurned(address owner) internal view returns (uint256) {
896 
897         return uint256(_addressData[owner].numberBurned);
898 
899     }
900 
901 
902 
903     /**
904 
905      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
906 
907      */
908 
909     function _getAux(address owner) internal view returns (uint64) {
910 
911         return _addressData[owner].aux;
912 
913     }
914 
915 
916 
917     /**
918 
919      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
920 
921      * If there are multiple variables, please pack them into a uint64.
922 
923      */
924 
925     function _setAux(address owner, uint64 aux) internal {
926 
927         _addressData[owner].aux = aux;
928 
929     }
930 
931 
932 
933     /**
934 
935      * Gas spent here starts off proportional to the maximum mint batch size.
936 
937      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
938 
939      */
940 
941     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
942 
943         uint256 curr = tokenId;
944 
945 
946 
947         unchecked {
948 
949             if (_startTokenId() <= curr && curr < _currentIndex) {
950 
951                 TokenOwnership memory ownership = _ownerships[curr];
952 
953                 if (!ownership.burned) {
954 
955                     if (ownership.addr != address(0)) {
956 
957                         return ownership;
958 
959                     }
960 
961                     // Invariant:
962 
963                     // There will always be an ownership that has an address and is not burned
964 
965                     // before an ownership that does not have an address and is not burned.
966 
967                     // Hence, curr will not underflow.
968 
969                     while (true) {
970 
971                         curr--;
972 
973                         ownership = _ownerships[curr];
974 
975                         if (ownership.addr != address(0)) {
976 
977                             return ownership;
978 
979                         }
980 
981                     }
982 
983                 }
984 
985             }
986 
987         }
988 
989         revert OwnerQueryForNonexistentToken();
990 
991     }
992 
993 
994 
995     /**
996 
997      * @dev See {IERC721-ownerOf}.
998 
999      */
1000 
1001     function ownerOf(uint256 tokenId) public view override returns (address) {
1002 
1003         return _ownershipOf(tokenId).addr;
1004 
1005     }
1006 
1007 
1008 
1009     /**
1010 
1011      * @dev See {IERC721Metadata-name}.
1012 
1013      */
1014 
1015     function name() public view virtual override returns (string memory) {
1016 
1017         return _name;
1018 
1019     }
1020 
1021 
1022 
1023     /**
1024 
1025      * @dev See {IERC721Metadata-symbol}.
1026 
1027      */
1028 
1029     function symbol() public view virtual override returns (string memory) {
1030 
1031         return _symbol;
1032 
1033     }
1034 
1035 
1036 
1037     /**
1038 
1039      * @dev See {IERC721Metadata-tokenURI}.
1040 
1041      */
1042 
1043     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1044 
1045         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1046 
1047 
1048 
1049         string memory baseURI = _baseURI();
1050 
1051         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1052 
1053     }
1054 
1055 
1056 
1057     /**
1058 
1059      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1060 
1061      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1062 
1063      * by default, can be overriden in child contracts.
1064 
1065      */
1066 
1067     function _baseURI() internal view virtual returns (string memory) {
1068 
1069         return '';
1070 
1071     }
1072 
1073 
1074 
1075     /**
1076 
1077      * @dev See {IERC721-approve}.
1078 
1079      */
1080 
1081     function approve(address to, uint256 tokenId) public override {
1082 
1083         address owner = ERC721A.ownerOf(tokenId);
1084 
1085         if (to == owner) revert ApprovalToCurrentOwner();
1086 
1087 
1088 
1089         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1090 
1091             revert ApprovalCallerNotOwnerNorApproved();
1092 
1093         }
1094 
1095 
1096 
1097         _approve(to, tokenId, owner);
1098 
1099     }
1100 
1101 
1102 
1103     /**
1104 
1105      * @dev See {IERC721-getApproved}.
1106 
1107      */
1108 
1109     function getApproved(uint256 tokenId) public view override returns (address) {
1110 
1111         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1112 
1113 
1114 
1115         return _tokenApprovals[tokenId];
1116 
1117     }
1118 
1119 
1120 
1121     /**
1122 
1123      * @dev See {IERC721-setApprovalForAll}.
1124 
1125      */
1126 
1127     function setApprovalForAll(address operator, bool approved) public virtual override {
1128 
1129         if (operator == _msgSender()) revert ApproveToCaller();
1130 
1131 
1132 
1133         _operatorApprovals[_msgSender()][operator] = approved;
1134 
1135         emit ApprovalForAll(_msgSender(), operator, approved);
1136 
1137     }
1138 
1139 
1140 
1141     /**
1142 
1143      * @dev See {IERC721-isApprovedForAll}.
1144 
1145      */
1146 
1147     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1148 
1149         return _operatorApprovals[owner][operator];
1150 
1151     }
1152 
1153 
1154 
1155     /**
1156 
1157      * @dev See {IERC721-transferFrom}.
1158 
1159      */
1160 
1161     function transferFrom(
1162 
1163         address from,
1164 
1165         address to,
1166 
1167         uint256 tokenId
1168 
1169     ) public virtual override {
1170 
1171         _transfer(from, to, tokenId);
1172 
1173     }
1174 
1175 
1176 
1177     /**
1178 
1179      * @dev See {IERC721-safeTransferFrom}.
1180 
1181      */
1182 
1183     function safeTransferFrom(
1184 
1185         address from,
1186 
1187         address to,
1188 
1189         uint256 tokenId
1190 
1191     ) public virtual override {
1192 
1193         safeTransferFrom(from, to, tokenId, '');
1194 
1195     }
1196 
1197 
1198 
1199     /**
1200 
1201      * @dev See {IERC721-safeTransferFrom}.
1202 
1203      */
1204 
1205     function safeTransferFrom(
1206 
1207         address from,
1208 
1209         address to,
1210 
1211         uint256 tokenId,
1212 
1213         bytes memory _data
1214 
1215     ) public virtual override {
1216 
1217         _transfer(from, to, tokenId);
1218 
1219         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1220 
1221             revert TransferToNonERC721ReceiverImplementer();
1222 
1223         }
1224 
1225     }
1226 
1227 
1228 
1229     /**
1230 
1231      * @dev Returns whether `tokenId` exists.
1232 
1233      *
1234 
1235      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1236 
1237      *
1238 
1239      * Tokens start existing when they are minted (`_mint`),
1240 
1241      */
1242 
1243     function _exists(uint256 tokenId) internal view returns (bool) {
1244 
1245         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1246 
1247             !_ownerships[tokenId].burned;
1248 
1249     }
1250 
1251 
1252 
1253     function _safeMint(address to, uint256 quantity) internal {
1254 
1255         _safeMint(to, quantity, '');
1256 
1257     }
1258 
1259 
1260 
1261     /**
1262 
1263      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1264 
1265      *
1266 
1267      * Requirements:
1268 
1269      *
1270 
1271      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1272 
1273      * - `quantity` must be greater than 0.
1274 
1275      *
1276 
1277      * Emits a {Transfer} event.
1278 
1279      */
1280 
1281     function _safeMint(
1282 
1283         address to,
1284 
1285         uint256 quantity,
1286 
1287         bytes memory _data
1288 
1289     ) internal {
1290 
1291         _mint(to, quantity, _data, true);
1292 
1293     }
1294 
1295 
1296 
1297     /**
1298 
1299      * @dev Mints `quantity` tokens and transfers them to `to`.
1300 
1301      *
1302 
1303      * Requirements:
1304 
1305      *
1306 
1307      * - `to` cannot be the zero address.
1308 
1309      * - `quantity` must be greater than 0.
1310 
1311      *
1312 
1313      * Emits a {Transfer} event.
1314 
1315      */
1316 
1317     function _mint(
1318 
1319         address to,
1320 
1321         uint256 quantity,
1322 
1323         bytes memory _data,
1324 
1325         bool safe
1326 
1327     ) internal {
1328 
1329         uint256 startTokenId = _currentIndex;
1330 
1331         if (to == address(0)) revert MintToZeroAddress();
1332 
1333         if (quantity == 0) revert MintZeroQuantity();
1334 
1335 
1336 
1337         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1338 
1339 
1340 
1341         // Overflows are incredibly unrealistic.
1342 
1343         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1344 
1345         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1346 
1347         unchecked {
1348 
1349             _addressData[to].balance += uint64(quantity);
1350 
1351             _addressData[to].numberMinted += uint64(quantity);
1352 
1353 
1354 
1355             _ownerships[startTokenId].addr = to;
1356 
1357             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1358 
1359 
1360 
1361             uint256 updatedIndex = startTokenId;
1362 
1363             uint256 end = updatedIndex + quantity;
1364 
1365 
1366 
1367             if (safe && to.isContract()) {
1368 
1369                 do {
1370 
1371                     emit Transfer(address(0), to, updatedIndex);
1372 
1373                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1374 
1375                         revert TransferToNonERC721ReceiverImplementer();
1376 
1377                     }
1378 
1379                 } while (updatedIndex != end);
1380 
1381                 // Reentrancy protection
1382 
1383                 if (_currentIndex != startTokenId) revert();
1384 
1385             } else {
1386 
1387                 do {
1388 
1389                     emit Transfer(address(0), to, updatedIndex++);
1390 
1391                 } while (updatedIndex != end);
1392 
1393             }
1394 
1395             _currentIndex = updatedIndex;
1396 
1397         }
1398 
1399         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1400 
1401     }
1402 
1403 
1404 
1405     /**
1406 
1407      * @dev Transfers `tokenId` from `from` to `to`.
1408 
1409      *
1410 
1411      * Requirements:
1412 
1413      *
1414 
1415      * - `to` cannot be the zero address.
1416 
1417      * - `tokenId` token must be owned by `from`.
1418 
1419      *
1420 
1421      * Emits a {Transfer} event.
1422 
1423      */
1424 
1425     function _transfer(
1426 
1427         address from,
1428 
1429         address to,
1430 
1431         uint256 tokenId
1432 
1433     ) private {
1434 
1435         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1436 
1437 
1438 
1439         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1440 
1441 
1442 
1443         bool isApprovedOrOwner = (_msgSender() == from ||
1444 
1445             isApprovedForAll(from, _msgSender()) ||
1446 
1447             getApproved(tokenId) == _msgSender());
1448 
1449 
1450 
1451         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1452 
1453         if (to == address(0)) revert TransferToZeroAddress();
1454 
1455 
1456 
1457         _beforeTokenTransfers(from, to, tokenId, 1);
1458 
1459 
1460 
1461         // Clear approvals from the previous owner
1462 
1463         _approve(address(0), tokenId, from);
1464 
1465 
1466 
1467         // Underflow of the sender's balance is impossible because we check for
1468 
1469         // ownership above and the recipient's balance can't realistically overflow.
1470 
1471         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1472 
1473         unchecked {
1474 
1475             _addressData[from].balance -= 1;
1476 
1477             _addressData[to].balance += 1;
1478 
1479 
1480 
1481             TokenOwnership storage currSlot = _ownerships[tokenId];
1482 
1483             currSlot.addr = to;
1484 
1485             currSlot.startTimestamp = uint64(block.timestamp);
1486 
1487 
1488 
1489             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1490 
1491             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1492 
1493             uint256 nextTokenId = tokenId + 1;
1494 
1495             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1496 
1497             if (nextSlot.addr == address(0)) {
1498 
1499                 // This will suffice for checking _exists(nextTokenId),
1500 
1501                 // as a burned slot cannot contain the zero address.
1502 
1503                 if (nextTokenId != _currentIndex) {
1504 
1505                     nextSlot.addr = from;
1506 
1507                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1508 
1509                 }
1510 
1511             }
1512 
1513         }
1514 
1515 
1516 
1517         emit Transfer(from, to, tokenId);
1518 
1519         _afterTokenTransfers(from, to, tokenId, 1);
1520 
1521     }
1522 
1523 
1524 
1525     /**
1526 
1527      * @dev This is equivalent to _burn(tokenId, false)
1528 
1529      */
1530 
1531     function _burn(uint256 tokenId) internal virtual {
1532 
1533         _burn(tokenId, false);
1534 
1535     }
1536 
1537 
1538 
1539     /**
1540 
1541      * @dev Destroys `tokenId`.
1542 
1543      * The approval is cleared when the token is burned.
1544 
1545      *
1546 
1547      * Requirements:
1548 
1549      *
1550 
1551      * - `tokenId` must exist.
1552 
1553      *
1554 
1555      * Emits a {Transfer} event.
1556 
1557      */
1558 
1559     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1560 
1561         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1562 
1563 
1564 
1565         address from = prevOwnership.addr;
1566 
1567 
1568 
1569         if (approvalCheck) {
1570 
1571             bool isApprovedOrOwner = (_msgSender() == from ||
1572 
1573                 isApprovedForAll(from, _msgSender()) ||
1574 
1575                 getApproved(tokenId) == _msgSender());
1576 
1577 
1578 
1579             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1580 
1581         }
1582 
1583 
1584 
1585         _beforeTokenTransfers(from, address(0), tokenId, 1);
1586 
1587 
1588 
1589         // Clear approvals from the previous owner
1590 
1591         _approve(address(0), tokenId, from);
1592 
1593 
1594 
1595         // Underflow of the sender's balance is impossible because we check for
1596 
1597         // ownership above and the recipient's balance can't realistically overflow.
1598 
1599         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1600 
1601         unchecked {
1602 
1603             AddressData storage addressData = _addressData[from];
1604 
1605             addressData.balance -= 1;
1606 
1607             addressData.numberBurned += 1;
1608 
1609 
1610 
1611             // Keep track of who burned the token, and the timestamp of burning.
1612 
1613             TokenOwnership storage currSlot = _ownerships[tokenId];
1614 
1615             currSlot.addr = from;
1616 
1617             currSlot.startTimestamp = uint64(block.timestamp);
1618 
1619             currSlot.burned = true;
1620 
1621 
1622 
1623             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1624 
1625             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1626 
1627             uint256 nextTokenId = tokenId + 1;
1628 
1629             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1630 
1631             if (nextSlot.addr == address(0)) {
1632 
1633                 // This will suffice for checking _exists(nextTokenId),
1634 
1635                 // as a burned slot cannot contain the zero address.
1636 
1637                 if (nextTokenId != _currentIndex) {
1638 
1639                     nextSlot.addr = from;
1640 
1641                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1642 
1643                 }
1644 
1645             }
1646 
1647         }
1648 
1649 
1650 
1651         emit Transfer(from, address(0), tokenId);
1652 
1653         _afterTokenTransfers(from, address(0), tokenId, 1);
1654 
1655 
1656 
1657         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1658 
1659         unchecked {
1660 
1661             _burnCounter++;
1662 
1663         }
1664 
1665     }
1666 
1667 
1668 
1669     /**
1670 
1671      * @dev Approve `to` to operate on `tokenId`
1672 
1673      *
1674 
1675      * Emits a {Approval} event.
1676 
1677      */
1678 
1679     function _approve(
1680 
1681         address to,
1682 
1683         uint256 tokenId,
1684 
1685         address owner
1686 
1687     ) private {
1688 
1689         _tokenApprovals[tokenId] = to;
1690 
1691         emit Approval(owner, to, tokenId);
1692 
1693     }
1694 
1695 
1696 
1697     /**
1698 
1699      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1700 
1701      *
1702 
1703      * @param from address representing the previous owner of the given token ID
1704 
1705      * @param to target address that will receive the tokens
1706 
1707      * @param tokenId uint256 ID of the token to be transferred
1708 
1709      * @param _data bytes optional data to send along with the call
1710 
1711      * @return bool whether the call correctly returned the expected magic value
1712 
1713      */
1714 
1715     function _checkContractOnERC721Received(
1716 
1717         address from,
1718 
1719         address to,
1720 
1721         uint256 tokenId,
1722 
1723         bytes memory _data
1724 
1725     ) private returns (bool) {
1726 
1727         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1728 
1729             return retval == IERC721Receiver(to).onERC721Received.selector;
1730 
1731         } catch (bytes memory reason) {
1732 
1733             if (reason.length == 0) {
1734 
1735                 revert TransferToNonERC721ReceiverImplementer();
1736 
1737             } else {
1738 
1739                 assembly {
1740 
1741                     revert(add(32, reason), mload(reason))
1742 
1743                 }
1744 
1745             }
1746 
1747         }
1748 
1749     }
1750 
1751 
1752 
1753     /**
1754 
1755      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1756 
1757      * And also called before burning one token.
1758 
1759      *
1760 
1761      * startTokenId - the first token id to be transferred
1762 
1763      * quantity - the amount to be transferred
1764 
1765      *
1766 
1767      * Calling conditions:
1768 
1769      *
1770 
1771      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1772 
1773      * transferred to `to`.
1774 
1775      * - When `from` is zero, `tokenId` will be minted for `to`.
1776 
1777      * - When `to` is zero, `tokenId` will be burned by `from`.
1778 
1779      * - `from` and `to` are never both zero.
1780 
1781      */
1782 
1783     function _beforeTokenTransfers(
1784 
1785         address from,
1786 
1787         address to,
1788 
1789         uint256 startTokenId,
1790 
1791         uint256 quantity
1792 
1793     ) internal virtual {}
1794 
1795 
1796 
1797     /**
1798 
1799      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1800 
1801      * minting.
1802 
1803      * And also called after one token has been burned.
1804 
1805      *
1806 
1807      * startTokenId - the first token id to be transferred
1808 
1809      * quantity - the amount to be transferred
1810 
1811      *
1812 
1813      * Calling conditions:
1814 
1815      *
1816 
1817      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1818 
1819      * transferred to `to`.
1820 
1821      * - When `from` is zero, `tokenId` has been minted for `to`.
1822 
1823      * - When `to` is zero, `tokenId` has been burned by `from`.
1824 
1825      * - `from` and `to` are never both zero.
1826 
1827      */
1828 
1829     function _afterTokenTransfers(
1830 
1831         address from,
1832 
1833         address to,
1834 
1835         uint256 startTokenId,
1836 
1837         uint256 quantity
1838 
1839     ) internal virtual {}
1840 
1841 }
1842 // File: @openzeppelin/contracts/access/Ownable.sol
1843 
1844 
1845 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1846 
1847 pragma solidity ^0.8.0;
1848 
1849 
1850 /**
1851  * @dev Contract module which provides a basic access control mechanism, where
1852  * there is an account (an owner) that can be granted exclusive access to
1853  * specific functions.
1854  *
1855  * By default, the owner account will be the one that deploys the contract. This
1856  * can later be changed with {transferOwnership}.
1857  *
1858  * This module is used through inheritance. It will make available the modifier
1859  * `onlyOwner`, which can be applied to your functions to restrict their use to
1860  * the owner.
1861  */
1862 abstract contract Ownable is Context {
1863     address private _owner;
1864 
1865     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1866 
1867     /**
1868      * @dev Initializes the contract setting the deployer as the initial owner.
1869      */
1870     constructor() {
1871         _transferOwnership(_msgSender());
1872     }
1873 
1874     /**
1875      * @dev Returns the address of the current owner.
1876      */
1877     function owner() public view virtual returns (address) {
1878         return _owner;
1879     }
1880 
1881     /**
1882      * @dev Throws if called by any account other than the owner.
1883      */
1884     modifier onlyOwner() {
1885         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1886         _;
1887     }
1888 
1889     /**
1890      * @dev Leaves the contract without owner. It will not be possible to call
1891      * `onlyOwner` functions anymore. Can only be called by the current owner.
1892      *
1893      * NOTE: Renouncing ownership will leave the contract without an owner,
1894      * thereby removing any functionality that is only available to the owner.
1895      */
1896     function renounceOwnership() public virtual onlyOwner {
1897         _transferOwnership(address(0));
1898     }
1899 
1900     /**
1901      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1902      * Can only be called by the current owner.
1903      */
1904     function transferOwnership(address newOwner) public virtual onlyOwner {
1905         require(newOwner != address(0), "Ownable: new owner is the zero address");
1906         _transferOwnership(newOwner);
1907     }
1908 
1909     /**
1910      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1911      * Internal function without access restriction.
1912      */
1913     function _transferOwnership(address newOwner) internal virtual {
1914         address oldOwner = _owner;
1915         _owner = newOwner;
1916         emit OwnershipTransferred(oldOwner, newOwner);
1917     }
1918 }
1919 
1920 // File: contracts/contract.sol
1921 
1922 
1923 pragma solidity ^0.8.4;
1924 
1925 
1926 contract RebelCupidz is Ownable, ERC721A  {
1927 
1928     using Strings for uint256;
1929 
1930     string private _baseTokenURI;
1931 
1932     uint256 public cost = 0.006 ether;
1933     uint256 public maxSupply = 5555;
1934    
1935     uint256 public maxPaidMintPerWallet = 10;
1936     uint256 public maxFreeMintPerWallet = 2;
1937 
1938     uint256 public totalFreeMintsAllowed=1555;
1939     uint256 public freeNFTsMinted=0;
1940     bool public paused = true;
1941 
1942     constructor() ERC721A("RebelCupidz", "RebelCupidz") {}
1943 
1944     modifier mintCompliance(uint256 _mintAmount) {
1945         require(_mintAmount > 0 , "Invalid mint amount!");
1946         require(totalMinted() + _mintAmount <= maxSupply, "Max supply exceeded!");
1947         _;
1948     }
1949 
1950     function freeMint(uint64 _mintAmount) public mintCompliance(_mintAmount) {
1951         require(!paused, "The contract is paused!");
1952         uint64 freeAmountMinted = getFreeAmountMinted(msg.sender);
1953 
1954         require(freeAmountMinted + _mintAmount <= maxFreeMintPerWallet, "Free Mint limit exceeded." );
1955         require(freeNFTsMinted + _mintAmount <= totalFreeMintsAllowed, "Total Free Mints allowed exceeded." );
1956         
1957         _safeMint(msg.sender, _mintAmount);
1958         freeNFTsMinted+=_mintAmount;
1959         setFreeAmountMinted(msg.sender,freeAmountMinted+_mintAmount);
1960     }
1961 
1962     function mint(uint64 _mintAmount) public payable mintCompliance(_mintAmount) {
1963         require(!paused, "The contract is paused!");
1964        
1965         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1966         require(numberMinted(msg.sender) + _mintAmount <= maxPaidMintPerWallet, "Mint limit exceeded." );
1967         
1968         _safeMint(msg.sender, _mintAmount);
1969     }
1970 
1971     function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1972         _safeMint(_receiver, _mintAmount);
1973     }
1974     
1975     function getFreeAmountMinted(address owner) public view returns (uint64) {
1976         return _getAux(owner);
1977     }
1978 
1979     function setFreeAmountMinted(address owner, uint64 aux) internal {
1980         _setAux(owner, aux);
1981     }
1982 
1983 
1984     function walletOfOwner(address _owner)
1985         public
1986         view
1987         returns (uint256[] memory)
1988     {
1989         uint256 ownerTokenCount = balanceOf(_owner);
1990         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1991         uint256 currentTokenId = 1;
1992         uint256 ownedTokenIndex = 0;
1993 
1994         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1995         address currentTokenOwner = ownerOf(currentTokenId);
1996 
1997         if (currentTokenOwner == _owner) {
1998             ownedTokenIds[ownedTokenIndex] = currentTokenId;
1999             ownedTokenIndex++;
2000         }
2001 
2002         currentTokenId++;
2003         }
2004 
2005         return ownedTokenIds;
2006     }
2007 
2008     function tokenURI(uint256 _tokenId)
2009 
2010         public
2011         view
2012         virtual
2013         override
2014         returns (string memory)
2015 
2016     {
2017 
2018         require(
2019         _exists(_tokenId),
2020         "ERC721Metadata: URI query for nonexistent token"
2021         );
2022 
2023         string memory currentBaseURI = _baseURI();
2024 
2025         return bytes(currentBaseURI).length > 0
2026 
2027             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
2028 
2029             : "";
2030     }
2031 
2032     function numberMinted(address owner) public view returns (uint256) {
2033         return _numberMinted(owner);
2034     }
2035 
2036     function totalMinted() public view returns (uint256) {
2037         return _totalMinted();
2038     }
2039 
2040     function exists(uint256 tokenId) public view returns (bool) {
2041         return _exists(tokenId);
2042     }
2043 
2044     function burn(uint256 tokenId, bool approvalCheck) public {
2045         _burn(tokenId, approvalCheck);
2046     }
2047 
2048     function _baseURI() internal view virtual override returns (string memory) {
2049         return _baseTokenURI;
2050     }
2051 
2052     function setBaseURI(string calldata baseURI) external onlyOwner {
2053         _baseTokenURI = baseURI;
2054     }
2055 
2056     function setPaused(bool _state) public onlyOwner {
2057         paused = _state;
2058     }
2059 
2060     function setCost(uint256 _cost) public onlyOwner {
2061         cost = _cost;
2062     }
2063 
2064     function setTotalFreeMintsAllowed(uint256 _totalFreeMinstAllowed) public onlyOwner {
2065         totalFreeMintsAllowed = _totalFreeMinstAllowed;
2066     }
2067 
2068     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
2069         maxSupply = _maxSupply;
2070     }
2071 
2072     function setMaxFreeMintPerWallet(uint256 _maxFreeMintPerWallet) public onlyOwner {
2073         maxFreeMintPerWallet = _maxFreeMintPerWallet;
2074     }
2075 
2076     function setMaxPaidMintPerWallet(uint256 _maxPaidMintPerWallet) public onlyOwner {
2077         maxPaidMintPerWallet = _maxPaidMintPerWallet;
2078     }
2079 
2080     function withdraw() public onlyOwner {
2081         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2082         require(os);
2083     }
2084 
2085 }