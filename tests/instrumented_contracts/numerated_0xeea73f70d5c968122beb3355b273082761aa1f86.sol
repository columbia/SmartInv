1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-01
3  */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/utils/Strings.sol
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev String operations.
14  */
15 library Strings {
16     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length)
63         internal
64         pure
65         returns (string memory)
66     {
67         bytes memory buffer = new bytes(2 * length + 2);
68         buffer[0] = "0";
69         buffer[1] = "x";
70         for (uint256 i = 2 * length + 1; i > 1; --i) {
71             buffer[i] = _HEX_SYMBOLS[value & 0xf];
72             value >>= 4;
73         }
74         require(value == 0, "Strings: hex length insufficient");
75         return string(buffer);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Address.sol
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
140         require(
141             address(this).balance >= amount,
142             "Address: insufficient balance"
143         );
144 
145         (bool success, ) = recipient.call{value: amount}("");
146         require(
147             success,
148             "Address: unable to send value, recipient may have reverted"
149         );
150     }
151 
152     /**
153      * @dev Performs a Solidity function call using a low level `call`. A
154      * plain `call` is an unsafe replacement for a function call: use this
155      * function instead.
156      *
157      * If `target` reverts with a revert reason, it is bubbled up by this
158      * function (like regular Solidity function calls).
159      *
160      * Returns the raw returned data. To convert to the expected return value,
161      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
162      *
163      * Requirements:
164      *
165      * - `target` must be a contract.
166      * - calling `target` with `data` must not revert.
167      *
168      * _Available since v3.1._
169      */
170     function functionCall(address target, bytes memory data)
171         internal
172         returns (bytes memory)
173     {
174         return functionCall(target, data, "Address: low-level call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
179      * `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, 0, errorMessage);
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193      * but also transferring `value` wei to `target`.
194      *
195      * Requirements:
196      *
197      * - the calling contract must have an ETH balance of at least `value`.
198      * - the called Solidity function must be `payable`.
199      *
200      * _Available since v3.1._
201      */
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value
206     ) internal returns (bytes memory) {
207         return
208             functionCallWithValue(
209                 target,
210                 data,
211                 value,
212                 "Address: low-level call with value failed"
213             );
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
218      * with `errorMessage` as a fallback revert reason when `target` reverts.
219      *
220      * _Available since v3.1._
221      */
222     function functionCallWithValue(
223         address target,
224         bytes memory data,
225         uint256 value,
226         string memory errorMessage
227     ) internal returns (bytes memory) {
228         require(
229             address(this).balance >= value,
230             "Address: insufficient balance for call"
231         );
232         require(isContract(target), "Address: call to non-contract");
233 
234         (bool success, bytes memory returndata) = target.call{value: value}(
235             data
236         );
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a static call.
243      *
244      * _Available since v3.3._
245      */
246     function functionStaticCall(address target, bytes memory data)
247         internal
248         view
249         returns (bytes memory)
250     {
251         return
252             functionStaticCall(
253                 target,
254                 data,
255                 "Address: low-level static call failed"
256             );
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
261      * but performing a static call.
262      *
263      * _Available since v3.3._
264      */
265     function functionStaticCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal view returns (bytes memory) {
270         require(isContract(target), "Address: static call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.staticcall(data);
273         return verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but performing a delegate call.
279      *
280      * _Available since v3.4._
281      */
282     function functionDelegateCall(address target, bytes memory data)
283         internal
284         returns (bytes memory)
285     {
286         return
287             functionDelegateCall(
288                 target,
289                 data,
290                 "Address: low-level delegate call failed"
291             );
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
296      * but performing a delegate call.
297      *
298      * _Available since v3.4._
299      */
300     function functionDelegateCall(
301         address target,
302         bytes memory data,
303         string memory errorMessage
304     ) internal returns (bytes memory) {
305         require(isContract(target), "Address: delegate call to non-contract");
306 
307         (bool success, bytes memory returndata) = target.delegatecall(data);
308         return verifyCallResult(success, returndata, errorMessage);
309     }
310 
311     /**
312      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
313      * revert reason using the provided one.
314      *
315      * _Available since v4.3._
316      */
317     function verifyCallResult(
318         bool success,
319         bytes memory returndata,
320         string memory errorMessage
321     ) internal pure returns (bytes memory) {
322         if (success) {
323             return returndata;
324         } else {
325             // Look for revert reason and bubble it up if present
326             if (returndata.length > 0) {
327                 // The easiest way to bubble the revert reason is using memory via assembly
328 
329                 assembly {
330                     let returndata_size := mload(returndata)
331                     revert(add(32, returndata), returndata_size)
332                 }
333             } else {
334                 revert(errorMessage);
335             }
336         }
337     }
338 }
339 
340 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
341 
342 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @title ERC721 token receiver interface
348  * @dev Interface for any contract that wants to support safeTransfers
349  * from ERC721 asset contracts.
350  */
351 interface IERC721Receiver {
352     /**
353      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
354      * by `operator` from `from`, this function is called.
355      *
356      * It must return its Solidity selector to confirm the token transfer.
357      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
358      *
359      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
360      */
361     function onERC721Received(
362         address operator,
363         address from,
364         uint256 tokenId,
365         bytes calldata data
366     ) external returns (bytes4);
367 }
368 
369 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
370 
371 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
372 
373 pragma solidity ^0.8.0;
374 
375 /**
376  * @dev Interface of the ERC165 standard, as defined in the
377  * https://eips.ethereum.org/EIPS/eip-165[EIP].
378  *
379  * Implementers can declare support of contract interfaces, which can then be
380  * queried by others ({ERC165Checker}).
381  *
382  * For an implementation, see {ERC165}.
383  */
384 interface IERC165 {
385     /**
386      * @dev Returns true if this contract implements the interface defined by
387      * `interfaceId`. See the corresponding
388      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
389      * to learn more about how these ids are created.
390      *
391      * This function call must use less than 30 000 gas.
392      */
393     function supportsInterface(bytes4 interfaceId) external view returns (bool);
394 }
395 
396 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
397 
398 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 /**
403  * @dev Implementation of the {IERC165} interface.
404  *
405  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
406  * for the additional interface id that will be supported. For example:
407  *
408  * ```solidity
409  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
410  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
411  * }
412  * ```
413  *
414  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
415  */
416 abstract contract ERC165 is IERC165 {
417     /**
418      * @dev See {IERC165-supportsInterface}.
419      */
420     function supportsInterface(bytes4 interfaceId)
421         public
422         view
423         virtual
424         override
425         returns (bool)
426     {
427         return interfaceId == type(IERC165).interfaceId;
428     }
429 }
430 
431 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
432 
433 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
434 
435 pragma solidity ^0.8.0;
436 
437 /**
438  * @dev Required interface of an ERC721 compliant contract.
439  */
440 interface IERC721 is IERC165 {
441     /**
442      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
443      */
444     event Transfer(
445         address indexed from,
446         address indexed to,
447         uint256 indexed tokenId
448     );
449 
450     /**
451      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
452      */
453     event Approval(
454         address indexed owner,
455         address indexed approved,
456         uint256 indexed tokenId
457     );
458 
459     /**
460      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
461      */
462     event ApprovalForAll(
463         address indexed owner,
464         address indexed operator,
465         bool approved
466     );
467 
468     /**
469      * @dev Returns the number of tokens in ``owner``'s account.
470      */
471     function balanceOf(address owner) external view returns (uint256 balance);
472 
473     /**
474      * @dev Returns the owner of the `tokenId` token.
475      *
476      * Requirements:
477      *
478      * - `tokenId` must exist.
479      */
480     function ownerOf(uint256 tokenId) external view returns (address owner);
481 
482     /**
483      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
484      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
485      *
486      * Requirements:
487      *
488      * - `from` cannot be the zero address.
489      * - `to` cannot be the zero address.
490      * - `tokenId` token must exist and be owned by `from`.
491      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
492      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
493      *
494      * Emits a {Transfer} event.
495      */
496     function safeTransferFrom(
497         address from,
498         address to,
499         uint256 tokenId
500     ) external;
501 
502     /**
503      * @dev Transfers `tokenId` token from `from` to `to`.
504      *
505      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
506      *
507      * Requirements:
508      *
509      * - `from` cannot be the zero address.
510      * - `to` cannot be the zero address.
511      * - `tokenId` token must be owned by `from`.
512      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
513      *
514      * Emits a {Transfer} event.
515      */
516     function transferFrom(
517         address from,
518         address to,
519         uint256 tokenId
520     ) external;
521 
522     /**
523      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
524      * The approval is cleared when the token is transferred.
525      *
526      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
527      *
528      * Requirements:
529      *
530      * - The caller must own the token or be an approved operator.
531      * - `tokenId` must exist.
532      *
533      * Emits an {Approval} event.
534      */
535     function approve(address to, uint256 tokenId) external;
536 
537     /**
538      * @dev Returns the account approved for `tokenId` token.
539      *
540      * Requirements:
541      *
542      * - `tokenId` must exist.
543      */
544     function getApproved(uint256 tokenId)
545         external
546         view
547         returns (address operator);
548 
549     /**
550      * @dev Approve or remove `operator` as an operator for the caller.
551      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
552      *
553      * Requirements:
554      *
555      * - The `operator` cannot be the caller.
556      *
557      * Emits an {ApprovalForAll} event.
558      */
559     function setApprovalForAll(address operator, bool _approved) external;
560 
561     /**
562      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
563      *
564      * See {setApprovalForAll}
565      */
566     function isApprovedForAll(address owner, address operator)
567         external
568         view
569         returns (bool);
570 
571     /**
572      * @dev Safely transfers `tokenId` token from `from` to `to`.
573      *
574      * Requirements:
575      *
576      * - `from` cannot be the zero address.
577      * - `to` cannot be the zero address.
578      * - `tokenId` token must exist and be owned by `from`.
579      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
580      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
581      *
582      * Emits a {Transfer} event.
583      */
584     function safeTransferFrom(
585         address from,
586         address to,
587         uint256 tokenId,
588         bytes calldata data
589     ) external;
590 }
591 
592 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
593 
594 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 /**
599  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
600  * @dev See https://eips.ethereum.org/EIPS/eip-721
601  */
602 interface IERC721Enumerable is IERC721 {
603     /**
604      * @dev Returns the total amount of tokens stored by the contract.
605      */
606     function totalSupply() external view returns (uint256);
607 
608     /**
609      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
610      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
611      */
612     function tokenOfOwnerByIndex(address owner, uint256 index)
613         external
614         view
615         returns (uint256);
616 
617     /**
618      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
619      * Use along with {totalSupply} to enumerate all tokens.
620      */
621     function tokenByIndex(uint256 index) external view returns (uint256);
622 }
623 
624 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
625 
626 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
627 
628 pragma solidity ^0.8.0;
629 
630 /**
631  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
632  * @dev See https://eips.ethereum.org/EIPS/eip-721
633  */
634 interface IERC721Metadata is IERC721 {
635     /**
636      * @dev Returns the token collection name.
637      */
638     function name() external view returns (string memory);
639 
640     /**
641      * @dev Returns the token collection symbol.
642      */
643     function symbol() external view returns (string memory);
644 
645     /**
646      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
647      */
648     function tokenURI(uint256 tokenId) external view returns (string memory);
649 }
650 
651 // File: @openzeppelin/contracts/utils/Context.sol
652 
653 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
654 
655 pragma solidity ^0.8.0;
656 
657 /**
658  * @dev Provides information about the current execution context, including the
659  * sender of the transaction and its data. While these are generally available
660  * via msg.sender and msg.data, they should not be accessed in such a direct
661  * manner, since when dealing with meta-transactions the account sending and
662  * paying for execution may not be the actual sender (as far as an application
663  * is concerned).
664  *
665  * This contract is only required for intermediate, library-like contracts.
666  */
667 abstract contract Context {
668     function _msgSender() internal view virtual returns (address) {
669         return msg.sender;
670     }
671 
672     function _msgData() internal view virtual returns (bytes calldata) {
673         return msg.data;
674     }
675 }
676 
677 // File: erc721a/contracts/ERC721A.sol
678 
679 // Creator: Chiru Labs
680 
681 pragma solidity ^0.8.4;
682 
683 error ApprovalCallerNotOwnerNorApproved();
684 error ApprovalQueryForNonexistentToken();
685 error ApproveToCaller();
686 error ApprovalToCurrentOwner();
687 error BalanceQueryForZeroAddress();
688 error MintedQueryForZeroAddress();
689 error BurnedQueryForZeroAddress();
690 error MintToZeroAddress();
691 error MintZeroQuantity();
692 error OwnerIndexOutOfBounds();
693 error OwnerQueryForNonexistentToken();
694 error TokenIndexOutOfBounds();
695 error TransferCallerNotOwnerNorApproved();
696 error TransferFromIncorrectOwner();
697 error TransferToNonERC721ReceiverImplementer();
698 error TransferToZeroAddress();
699 error URIQueryForNonexistentToken();
700 
701 /**
702  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
703  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
704  *
705  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
706  *
707  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
708  *
709  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
710  */
711 contract ERC721A is
712     Context,
713     ERC165,
714     IERC721,
715     IERC721Metadata,
716     IERC721Enumerable
717 {
718     using Address for address;
719     using Strings for uint256;
720 
721     // Compiler will pack this into a single 256bit word.
722     struct TokenOwnership {
723         // The address of the owner.
724         address addr;
725         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
726         uint64 startTimestamp;
727         // Whether the token has been burned.
728         bool burned;
729     }
730 
731     // Compiler will pack this into a single 256bit word.
732     struct AddressData {
733         // Realistically, 2**64-1 is more than enough.
734         uint64 balance;
735         // Keeps track of mint count with minimal overhead for tokenomics.
736         uint64 numberMinted;
737         // Keeps track of burn count with minimal overhead for tokenomics.
738         uint64 numberBurned;
739     }
740 
741     // Compiler will pack the following
742     // _currentIndex and _burnCounter into a single 256bit word.
743 
744     // The tokenId of the next token to be minted.
745     uint128 internal _currentIndex;
746 
747     // The number of tokens burned.
748     uint128 internal _burnCounter;
749 
750     // Token name
751     string private _name;
752 
753     // Token symbol
754     string private _symbol;
755 
756     // Mapping from token ID to ownership details
757     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
758     mapping(uint256 => TokenOwnership) internal _ownerships;
759 
760     // Mapping owner address to address data
761     mapping(address => AddressData) private _addressData;
762 
763     // Mapping from token ID to approved address
764     mapping(uint256 => address) private _tokenApprovals;
765 
766     // Mapping from owner to operator approvals
767     mapping(address => mapping(address => bool)) private _operatorApprovals;
768 
769     constructor(string memory name_, string memory symbol_) {
770         _name = name_;
771         _symbol = symbol_;
772     }
773 
774     /**
775      * @dev See {IERC721Enumerable-totalSupply}.
776      */
777     function totalSupply() public view override returns (uint256) {
778         // Counter underflow is impossible as _burnCounter cannot be incremented
779         // more than _currentIndex times
780         unchecked {
781             return _currentIndex - _burnCounter;
782         }
783     }
784 
785     /**
786      * @dev See {IERC721Enumerable-tokenByIndex}.
787      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
788      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
789      */
790     function tokenByIndex(uint256 index)
791         public
792         view
793         override
794         returns (uint256)
795     {
796         uint256 numMintedSoFar = _currentIndex;
797         uint256 tokenIdsIdx;
798 
799         // Counter overflow is impossible as the loop breaks when
800         // uint256 i is equal to another uint256 numMintedSoFar.
801         unchecked {
802             for (uint256 i; i < numMintedSoFar; i++) {
803                 TokenOwnership memory ownership = _ownerships[i];
804                 if (!ownership.burned) {
805                     if (tokenIdsIdx == index) {
806                         return i;
807                     }
808                     tokenIdsIdx++;
809                 }
810             }
811         }
812         revert TokenIndexOutOfBounds();
813     }
814 
815     /**
816      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
817      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
818      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
819      */
820     function tokenOfOwnerByIndex(address owner, uint256 index)
821         public
822         view
823         override
824         returns (uint256)
825     {
826         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
827         uint256 numMintedSoFar = _currentIndex;
828         uint256 tokenIdsIdx;
829         address currOwnershipAddr;
830 
831         // Counter overflow is impossible as the loop breaks when
832         // uint256 i is equal to another uint256 numMintedSoFar.
833         unchecked {
834             for (uint256 i; i < numMintedSoFar; i++) {
835                 TokenOwnership memory ownership = _ownerships[i];
836                 if (ownership.burned) {
837                     continue;
838                 }
839                 if (ownership.addr != address(0)) {
840                     currOwnershipAddr = ownership.addr;
841                 }
842                 if (currOwnershipAddr == owner) {
843                     if (tokenIdsIdx == index) {
844                         return i;
845                     }
846                     tokenIdsIdx++;
847                 }
848             }
849         }
850 
851         // Execution should never reach this point.
852         revert();
853     }
854 
855     /**
856      * @dev See {IERC165-supportsInterface}.
857      */
858     function supportsInterface(bytes4 interfaceId)
859         public
860         view
861         virtual
862         override(ERC165, IERC165)
863         returns (bool)
864     {
865         return
866             interfaceId == type(IERC721).interfaceId ||
867             interfaceId == type(IERC721Metadata).interfaceId ||
868             interfaceId == type(IERC721Enumerable).interfaceId ||
869             super.supportsInterface(interfaceId);
870     }
871 
872     /**
873      * @dev See {IERC721-balanceOf}.
874      */
875     function balanceOf(address owner) public view override returns (uint256) {
876         if (owner == address(0)) revert BalanceQueryForZeroAddress();
877         return uint256(_addressData[owner].balance);
878     }
879 
880     function _numberMinted(address owner) internal view returns (uint256) {
881         if (owner == address(0)) revert MintedQueryForZeroAddress();
882         return uint256(_addressData[owner].numberMinted);
883     }
884 
885     function _numberBurned(address owner) internal view returns (uint256) {
886         if (owner == address(0)) revert BurnedQueryForZeroAddress();
887         return uint256(_addressData[owner].numberBurned);
888     }
889 
890     /**
891      * Gas spent here starts off proportional to the maximum mint batch size.
892      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
893      */
894     function ownershipOf(uint256 tokenId)
895         internal
896         view
897         returns (TokenOwnership memory)
898     {
899         uint256 curr = tokenId;
900 
901         unchecked {
902             if (curr < _currentIndex) {
903                 TokenOwnership memory ownership = _ownerships[curr];
904                 if (!ownership.burned) {
905                     if (ownership.addr != address(0)) {
906                         return ownership;
907                     }
908                     // Invariant:
909                     // There will always be an ownership that has an address and is not burned
910                     // before an ownership that does not have an address and is not burned.
911                     // Hence, curr will not underflow.
912                     while (true) {
913                         curr--;
914                         ownership = _ownerships[curr];
915                         if (ownership.addr != address(0)) {
916                             return ownership;
917                         }
918                     }
919                 }
920             }
921         }
922         revert OwnerQueryForNonexistentToken();
923     }
924 
925     /**
926      * @dev See {IERC721-ownerOf}.
927      */
928     function ownerOf(uint256 tokenId) public view override returns (address) {
929         return ownershipOf(tokenId).addr;
930     }
931 
932     /**
933      * @dev See {IERC721Metadata-name}.
934      */
935     function name() public view virtual override returns (string memory) {
936         return _name;
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-symbol}.
941      */
942     function symbol() public view virtual override returns (string memory) {
943         return _symbol;
944     }
945 
946     /**
947      * @dev See {IERC721Metadata-tokenURI}.
948      */
949     function tokenURI(uint256 tokenId)
950         public
951         view
952         virtual
953         override
954         returns (string memory)
955     {
956         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
957 
958         string memory baseURI = _baseURI();
959         return
960             bytes(baseURI).length != 0
961                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
962                 : "";
963     }
964 
965     /**
966      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
967      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
968      * by default, can be overriden in child contracts.
969      */
970     function _baseURI() internal view virtual returns (string memory) {
971         return "";
972     }
973 
974     /**
975      * @dev See {IERC721-approve}.
976      */
977     function approve(address to, uint256 tokenId) public override {
978         address owner = ERC721A.ownerOf(tokenId);
979         if (to == owner) revert ApprovalToCurrentOwner();
980 
981         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
982             revert ApprovalCallerNotOwnerNorApproved();
983         }
984 
985         _approve(to, tokenId, owner);
986     }
987 
988     /**
989      * @dev See {IERC721-getApproved}.
990      */
991     function getApproved(uint256 tokenId)
992         public
993         view
994         override
995         returns (address)
996     {
997         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
998 
999         return _tokenApprovals[tokenId];
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-setApprovalForAll}.
1004      */
1005     function setApprovalForAll(address operator, bool approved)
1006         public
1007         override
1008     {
1009         if (operator == _msgSender()) revert ApproveToCaller();
1010 
1011         _operatorApprovals[_msgSender()][operator] = approved;
1012         emit ApprovalForAll(_msgSender(), operator, approved);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-isApprovedForAll}.
1017      */
1018     function isApprovedForAll(address owner, address operator)
1019         public
1020         view
1021         virtual
1022         override
1023         returns (bool)
1024     {
1025         return _operatorApprovals[owner][operator];
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-transferFrom}.
1030      */
1031     function transferFrom(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) public virtual override {
1036         _transfer(from, to, tokenId);
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-safeTransferFrom}.
1041      */
1042     function safeTransferFrom(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) public virtual override {
1047         safeTransferFrom(from, to, tokenId, "");
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-safeTransferFrom}.
1052      */
1053     function safeTransferFrom(
1054         address from,
1055         address to,
1056         uint256 tokenId,
1057         bytes memory _data
1058     ) public virtual override {
1059         _transfer(from, to, tokenId);
1060         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1061             revert TransferToNonERC721ReceiverImplementer();
1062         }
1063     }
1064 
1065     /**
1066      * @dev Returns whether `tokenId` exists.
1067      *
1068      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1069      *
1070      * Tokens start existing when they are minted (`_mint`),
1071      */
1072     function _exists(uint256 tokenId) internal view returns (bool) {
1073         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1074     }
1075 
1076     function _safeMint(address to, uint256 quantity) internal {
1077         _safeMint(to, quantity, "");
1078     }
1079 
1080     /**
1081      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1082      *
1083      * Requirements:
1084      *
1085      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1086      * - `quantity` must be greater than 0.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function _safeMint(
1091         address to,
1092         uint256 quantity,
1093         bytes memory _data
1094     ) internal {
1095         _mint(to, quantity, _data, true);
1096     }
1097 
1098     /**
1099      * @dev Mints `quantity` tokens and transfers them to `to`.
1100      *
1101      * Requirements:
1102      *
1103      * - `to` cannot be the zero address.
1104      * - `quantity` must be greater than 0.
1105      *
1106      * Emits a {Transfer} event.
1107      */
1108     function _mint(
1109         address to,
1110         uint256 quantity,
1111         bytes memory _data,
1112         bool safe
1113     ) internal {
1114         uint256 startTokenId = _currentIndex;
1115         if (to == address(0)) revert MintToZeroAddress();
1116         if (quantity == 0) revert MintZeroQuantity();
1117 
1118         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1119 
1120         // Overflows are incredibly unrealistic.
1121         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1122         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1123         unchecked {
1124             _addressData[to].balance += uint64(quantity);
1125             _addressData[to].numberMinted += uint64(quantity);
1126 
1127             _ownerships[startTokenId].addr = to;
1128             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1129 
1130             uint256 updatedIndex = startTokenId;
1131 
1132             for (uint256 i; i < quantity; i++) {
1133                 emit Transfer(address(0), to, updatedIndex);
1134                 if (
1135                     safe &&
1136                     !_checkOnERC721Received(address(0), to, updatedIndex, _data)
1137                 ) {
1138                     revert TransferToNonERC721ReceiverImplementer();
1139                 }
1140                 updatedIndex++;
1141             }
1142 
1143             _currentIndex = uint128(updatedIndex);
1144         }
1145         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1146     }
1147 
1148     /**
1149      * @dev Transfers `tokenId` from `from` to `to`.
1150      *
1151      * Requirements:
1152      *
1153      * - `to` cannot be the zero address.
1154      * - `tokenId` token must be owned by `from`.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function _transfer(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) private {
1163         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1164 
1165         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1166             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1167             getApproved(tokenId) == _msgSender());
1168 
1169         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1170         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1171         if (to == address(0)) revert TransferToZeroAddress();
1172 
1173         _beforeTokenTransfers(from, to, tokenId, 1);
1174 
1175         // Clear approvals from the previous owner
1176         _approve(address(0), tokenId, prevOwnership.addr);
1177 
1178         // Underflow of the sender's balance is impossible because we check for
1179         // ownership above and the recipient's balance can't realistically overflow.
1180         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1181         unchecked {
1182             _addressData[from].balance -= 1;
1183             _addressData[to].balance += 1;
1184 
1185             _ownerships[tokenId].addr = to;
1186             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1187 
1188             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1189             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1190             uint256 nextTokenId = tokenId + 1;
1191             if (_ownerships[nextTokenId].addr == address(0)) {
1192                 // This will suffice for checking _exists(nextTokenId),
1193                 // as a burned slot cannot contain the zero address.
1194                 if (nextTokenId < _currentIndex) {
1195                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1196                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1197                         .startTimestamp;
1198                 }
1199             }
1200         }
1201 
1202         emit Transfer(from, to, tokenId);
1203         _afterTokenTransfers(from, to, tokenId, 1);
1204     }
1205 
1206     /**
1207      * @dev Destroys `tokenId`.
1208      * The approval is cleared when the token is burned.
1209      *
1210      * Requirements:
1211      *
1212      * - `tokenId` must exist.
1213      *
1214      * Emits a {Transfer} event.
1215      */
1216     function _burn(uint256 tokenId) internal virtual {
1217         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1218 
1219         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1220 
1221         // Clear approvals from the previous owner
1222         _approve(address(0), tokenId, prevOwnership.addr);
1223 
1224         // Underflow of the sender's balance is impossible because we check for
1225         // ownership above and the recipient's balance can't realistically overflow.
1226         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1227         unchecked {
1228             _addressData[prevOwnership.addr].balance -= 1;
1229             _addressData[prevOwnership.addr].numberBurned += 1;
1230 
1231             // Keep track of who burned the token, and the timestamp of burning.
1232             _ownerships[tokenId].addr = prevOwnership.addr;
1233             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1234             _ownerships[tokenId].burned = true;
1235 
1236             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1237             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1238             uint256 nextTokenId = tokenId + 1;
1239             if (_ownerships[nextTokenId].addr == address(0)) {
1240                 // This will suffice for checking _exists(nextTokenId),
1241                 // as a burned slot cannot contain the zero address.
1242                 if (nextTokenId < _currentIndex) {
1243                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1244                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1245                         .startTimestamp;
1246                 }
1247             }
1248         }
1249 
1250         emit Transfer(prevOwnership.addr, address(0), tokenId);
1251         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1252 
1253         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1254         unchecked {
1255             _burnCounter++;
1256         }
1257     }
1258 
1259     /**
1260      * @dev Approve `to` to operate on `tokenId`
1261      *
1262      * Emits a {Approval} event.
1263      */
1264     function _approve(
1265         address to,
1266         uint256 tokenId,
1267         address owner
1268     ) private {
1269         _tokenApprovals[tokenId] = to;
1270         emit Approval(owner, to, tokenId);
1271     }
1272 
1273     /**
1274      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1275      * The call is not executed if the target address is not a contract.
1276      *
1277      * @param from address representing the previous owner of the given token ID
1278      * @param to target address that will receive the tokens
1279      * @param tokenId uint256 ID of the token to be transferred
1280      * @param _data bytes optional data to send along with the call
1281      * @return bool whether the call correctly returned the expected magic value
1282      */
1283     function _checkOnERC721Received(
1284         address from,
1285         address to,
1286         uint256 tokenId,
1287         bytes memory _data
1288     ) private returns (bool) {
1289         if (to.isContract()) {
1290             try
1291                 IERC721Receiver(to).onERC721Received(
1292                     _msgSender(),
1293                     from,
1294                     tokenId,
1295                     _data
1296                 )
1297             returns (bytes4 retval) {
1298                 return retval == IERC721Receiver(to).onERC721Received.selector;
1299             } catch (bytes memory reason) {
1300                 if (reason.length == 0) {
1301                     revert TransferToNonERC721ReceiverImplementer();
1302                 } else {
1303                     assembly {
1304                         revert(add(32, reason), mload(reason))
1305                     }
1306                 }
1307             }
1308         } else {
1309             return true;
1310         }
1311     }
1312 
1313     /**
1314      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1315      * And also called before burning one token.
1316      *
1317      * startTokenId - the first token id to be transferred
1318      * quantity - the amount to be transferred
1319      *
1320      * Calling conditions:
1321      *
1322      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1323      * transferred to `to`.
1324      * - When `from` is zero, `tokenId` will be minted for `to`.
1325      * - When `to` is zero, `tokenId` will be burned by `from`.
1326      * - `from` and `to` are never both zero.
1327      */
1328     function _beforeTokenTransfers(
1329         address from,
1330         address to,
1331         uint256 startTokenId,
1332         uint256 quantity
1333     ) internal virtual {}
1334 
1335     /**
1336      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1337      * minting.
1338      * And also called after one token has been burned.
1339      *
1340      * startTokenId - the first token id to be transferred
1341      * quantity - the amount to be transferred
1342      *
1343      * Calling conditions:
1344      *
1345      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1346      * transferred to `to`.
1347      * - When `from` is zero, `tokenId` has been minted for `to`.
1348      * - When `to` is zero, `tokenId` has been burned by `from`.
1349      * - `from` and `to` are never both zero.
1350      */
1351     function _afterTokenTransfers(
1352         address from,
1353         address to,
1354         uint256 startTokenId,
1355         uint256 quantity
1356     ) internal virtual {}
1357 }
1358 
1359 // File: @openzeppelin/contracts/access/Ownable.sol
1360 
1361 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1362 
1363 pragma solidity ^0.8.0;
1364 
1365 /**
1366  * @dev Contract module which provides a basic access control mechanism, where
1367  * there is an account (an owner) that can be granted exclusive access to
1368  * specific functions.
1369  *
1370  * By default, the owner account will be the one that deploys the contract. This
1371  * can later be changed with {transferOwnership}.
1372  *
1373  * This module is used through inheritance. It will make available the modifier
1374  * `onlyOwner`, which can be applied to your functions to restrict their use to
1375  * the owner.
1376  */
1377 abstract contract Ownable is Context {
1378     address private _owner;
1379 
1380     event OwnershipTransferred(
1381         address indexed previousOwner,
1382         address indexed newOwner
1383     );
1384 
1385     /**
1386      * @dev Initializes the contract setting the deployer as the initial owner.
1387      */
1388     constructor() {
1389         _transferOwnership(_msgSender());
1390     }
1391 
1392     /**
1393      * @dev Returns the address of the current owner.
1394      */
1395     function owner() public view virtual returns (address) {
1396         return _owner;
1397     }
1398 
1399     /**
1400      * @dev Throws if called by any account other than the owner.
1401      */
1402     modifier onlyOwner() {
1403         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1404         _;
1405     }
1406 
1407     /**
1408      * @dev Leaves the contract without owner. It will not be possible to call
1409      * `onlyOwner` functions anymore. Can only be called by the current owner.
1410      *
1411      * NOTE: Renouncing ownership will leave the contract without an owner,
1412      * thereby removing any functionality that is only available to the owner.
1413      */
1414     function renounceOwnership() public virtual onlyOwner {
1415         _transferOwnership(address(0));
1416     }
1417 
1418     /**
1419      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1420      * Can only be called by the current owner.
1421      */
1422     function transferOwnership(address newOwner) public virtual onlyOwner {
1423         require(
1424             newOwner != address(0),
1425             "Ownable: new owner is the zero address"
1426         );
1427         _transferOwnership(newOwner);
1428     }
1429 
1430     /**
1431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1432      * Internal function without access restriction.
1433      */
1434     function _transferOwnership(address newOwner) internal virtual {
1435         address oldOwner = _owner;
1436         _owner = newOwner;
1437         emit OwnershipTransferred(oldOwner, newOwner);
1438     }
1439 }
1440 
1441 // File: contract.sol
1442 interface IStaking {
1443     function mint(address _to, uint256 _amount) external;
1444 }
1445 
1446 pragma solidity ^0.8.4;
1447 
1448 contract Digit_mfers is Ownable, ERC721A {
1449     using Strings for uint256;
1450     IStaking public StakingContract;
1451     string private _tokenBaseURI =
1452         "https://storageapi.fleek.co/b701e2b3-d1dc-4c52-9586-8d26ee95b05d-bucket/FMD/";
1453     uint256 public DM_MAX = 5000;
1454     uint256 public DM_PRICE_free = 0 ether;
1455     uint256 public DM_PRICE = 0.0069 ether;
1456     uint256 public DM_PER_MINT = 20;
1457     uint256 public tokenMintsCounter;
1458     bool public publicLive;
1459     bool public stakingLive;
1460     uint256 public earningRate = 0.0001157407406 ether;
1461     mapping(uint256 => uint256) public tokensLastClaimBlock;
1462     mapping(address => uint256[]) public balanceIds;
1463 
1464     constructor() ERC721A("Digit mfers", "DM") {}
1465 
1466     modifier callerIsUser() {
1467         require(tx.origin == msg.sender, "The caller is another contract");
1468         _;
1469     }
1470 
1471     function gift(address[] calldata receivers) external onlyOwner {
1472         require(tokenMintsCounter + receivers.length <= DM_MAX, "EXCEED_MAX");
1473         for (uint256 i = 0; i < receivers.length; i++) {
1474             tokensLastClaimBlock[tokenMintsCounter] = block.number;
1475             balanceIds[receivers[i]].push(tokenMintsCounter);
1476             tokenMintsCounter++;
1477             _safeMint(receivers[i], 1);
1478         }
1479     }
1480 
1481     function founderMint(uint256 tokenQuantity) external onlyOwner {
1482         require(tokenMintsCounter + tokenQuantity <= DM_MAX, "EXCEED_MAX");
1483         tokensLastClaimBlock[tokenMintsCounter] = block.number;
1484         balanceIds[msg.sender].push(tokenMintsCounter);
1485         tokenMintsCounter++;
1486         _safeMint(msg.sender, tokenQuantity);
1487     }
1488 
1489     function mint(uint256 tokenQuantity) external payable callerIsUser {
1490         require(publicLive, "MINT_CLOSED");
1491         require(tokenMintsCounter + tokenQuantity <= DM_MAX, "EXCEED_MAX");
1492         require(tokenQuantity <= DM_PER_MINT, "EXCEED_PER_MINT");
1493         require(
1494             (DM_PRICE * tokenQuantity <= msg.value &&
1495                 tokenMintsCounter >= 1000) ||
1496                 (DM_PRICE_free * tokenQuantity <= msg.value &&
1497                     tokenMintsCounter < 1000),
1498             "INSUFFICIENT_ETH"
1499         );
1500         for (uint256 index = 0; index < tokenQuantity; index++) {
1501             tokensLastClaimBlock[tokenMintsCounter] = block.number;
1502             balanceIds[msg.sender].push(tokenMintsCounter);
1503             tokenMintsCounter++;
1504         }
1505         _safeMint(msg.sender, tokenQuantity);
1506     }
1507 
1508     function withdraw() external onlyOwner {
1509         payable(0xa4F213f5e49D9a423Bb280024B577053b23B6974).transfer(
1510             address(this).balance / 20
1511         );
1512         payable(0x3445544E92EF4a2708000A08D20F14B24BA460F1).transfer(
1513             address(this).balance
1514         );
1515     }
1516 
1517     function togglePublicMintStatus() external onlyOwner {
1518         publicLive = !publicLive;
1519     }
1520 
1521     function toggleStakingStatus() external onlyOwner {
1522         stakingLive = !stakingLive;
1523     }
1524 
1525     function setPrice(uint256 newPrice) external onlyOwner {
1526         DM_PRICE = newPrice;
1527     }
1528 
1529     function setPrice_500(uint256 newPrice) external onlyOwner {
1530         DM_PRICE_free = newPrice;
1531     }
1532 
1533     function setMax(uint256 newCount) external onlyOwner {
1534         DM_MAX = newCount;
1535     }
1536 
1537     function _baseURI() internal view virtual override returns (string memory) {
1538         return _tokenBaseURI;
1539     }
1540 
1541     function setBaseURI(string calldata baseURI) external onlyOwner {
1542         _tokenBaseURI = baseURI;
1543     }
1544 
1545     function tokenURI(uint256 tokenId)
1546         public
1547         view
1548         override(ERC721A)
1549         returns (string memory)
1550     {
1551         require(_exists(tokenId), "Cannot query non-existent token");
1552 
1553         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1554     }
1555 
1556     function claimStakingRewards() external {
1557         require(stakingLive, "STAKING_CLOSED");
1558         uint256 totalRewards = 0;
1559 
1560         for (
1561             uint256 index = 0;
1562             index < balanceIds[msg.sender].length;
1563             index++
1564         ) {
1565             require(
1566                 tokensLastClaimBlock[balanceIds[msg.sender][index]] > 0,
1567                 "WRONG_BLOCK_NUMBER"
1568             );
1569             totalRewards =
1570                 totalRewards +
1571                 earningRate *
1572                 (block.number -
1573                     (tokensLastClaimBlock[balanceIds[msg.sender][index]]));
1574             tokensLastClaimBlock[balanceIds[msg.sender][index]] = block.number;
1575         }
1576 
1577         StakingContract.mint(msg.sender, totalRewards);
1578     }
1579 
1580     function setEarningRate(uint256 rate) external onlyOwner {
1581         earningRate = rate;
1582     }
1583 
1584     function setStakingContract(address contractAddress) external onlyOwner {
1585         StakingContract = IStaking(contractAddress);
1586     }
1587 
1588     function transferFrom(
1589         address from,
1590         address to,
1591         uint256 tokenId
1592     ) public override {
1593         for (uint256 index = 0; index < balanceIds[from].length; index++) {
1594             if (balanceIds[from][index] == tokenId) {
1595                 balanceIds[from][index] = balanceIds[from][
1596                     balanceIds[from].length - 1
1597                 ];
1598                 balanceIds[from].pop();
1599             }
1600         }
1601         balanceIds[to].push(tokenId);
1602         tokensLastClaimBlock[tokenId] = block.number;
1603         ERC721A.transferFrom(from, to, tokenId);
1604     }
1605 
1606     function safeTransferFrom(
1607         address from,
1608         address to,
1609         uint256 tokenId,
1610         bytes memory data
1611     ) public override {
1612         for (uint256 index = 0; index < balanceIds[from].length; index++) {
1613             if (balanceIds[from][index] == tokenId) {
1614                 balanceIds[from][index] = balanceIds[from][
1615                     balanceIds[from].length - 1
1616                 ];
1617                 balanceIds[from].pop();
1618             }
1619         }
1620         balanceIds[to].push(tokenId);
1621         tokensLastClaimBlock[tokenId] = block.number;
1622         ERC721A.safeTransferFrom(from, to, tokenId, data);
1623     }
1624 
1625     receive() external payable {}
1626 }