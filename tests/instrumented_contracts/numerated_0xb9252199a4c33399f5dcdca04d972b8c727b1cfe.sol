1 // SPDX-License-Identifier: MIT
2 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
30 
31 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(
43         address indexed from,
44         address indexed to,
45         uint256 indexed tokenId
46     );
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(
52         address indexed owner,
53         address indexed approved,
54         uint256 indexed tokenId
55     );
56 
57     /**
58      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
59      */
60     event ApprovalForAll(
61         address indexed owner,
62         address indexed operator,
63         bool approved
64     );
65 
66     /**
67      * @dev Returns the number of tokens in ``owner``'s account.
68      */
69     function balanceOf(address owner) external view returns (uint256 balance);
70 
71     /**
72      * @dev Returns the owner of the `tokenId` token.
73      *
74      * Requirements:
75      *
76      * - `tokenId` must exist.
77      */
78     function ownerOf(uint256 tokenId) external view returns (address owner);
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
136      * @dev Returns the account approved for `tokenId` token.
137      *
138      * Requirements:
139      *
140      * - `tokenId` must exist.
141      */
142     function getApproved(uint256 tokenId)
143         external
144         view
145         returns (address operator);
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
160      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
161      *
162      * See {setApprovalForAll}
163      */
164     function isApprovedForAll(address owner, address operator)
165         external
166         view
167         returns (bool);
168 
169     /**
170      * @dev Safely transfers `tokenId` token from `from` to `to`.
171      *
172      * Requirements:
173      *
174      * - `from` cannot be the zero address.
175      * - `to` cannot be the zero address.
176      * - `tokenId` token must exist and be owned by `from`.
177      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
178      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
179      *
180      * Emits a {Transfer} event.
181      */
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 tokenId,
186         bytes calldata data
187     ) external;
188 }
189 
190 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
191 
192 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
193 
194 pragma solidity ^0.8.0;
195 
196 /**
197  * @title ERC721 token receiver interface
198  * @dev Interface for any contract that wants to support safeTransfers
199  * from ERC721 asset contracts.
200  */
201 interface IERC721Receiver {
202     /**
203      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
204      * by `operator` from `from`, this function is called.
205      *
206      * It must return its Solidity selector to confirm the token transfer.
207      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
208      *
209      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
210      */
211     function onERC721Received(
212         address operator,
213         address from,
214         uint256 tokenId,
215         bytes calldata data
216     ) external returns (bytes4);
217 }
218 
219 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
220 
221 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
222 
223 pragma solidity ^0.8.0;
224 
225 /**
226  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
227  * @dev See https://eips.ethereum.org/EIPS/eip-721
228  */
229 interface IERC721Metadata is IERC721 {
230     /**
231      * @dev Returns the token collection name.
232      */
233     function name() external view returns (string memory);
234 
235     /**
236      * @dev Returns the token collection symbol.
237      */
238     function symbol() external view returns (string memory);
239 
240     /**
241      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
242      */
243     function tokenURI(uint256 tokenId) external view returns (string memory);
244 }
245 
246 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
247 
248 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
249 
250 pragma solidity ^0.8.1;
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      *
273      * [IMPORTANT]
274      * ====
275      * You shouldn't rely on `isContract` to protect against flash loan attacks!
276      *
277      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
278      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
279      * constructor.
280      * ====
281      */
282     function isContract(address account) internal view returns (bool) {
283         // This method relies on extcodesize/address.code.length, which returns 0
284         // for contracts in construction, since the code is only stored at the end
285         // of the constructor execution.
286 
287         return account.code.length > 0;
288     }
289 
290     /**
291      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
292      * `recipient`, forwarding all available gas and reverting on errors.
293      *
294      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
295      * of certain opcodes, possibly making contracts go over the 2300 gas limit
296      * imposed by `transfer`, making them unable to receive funds via
297      * `transfer`. {sendValue} removes this limitation.
298      *
299      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
300      *
301      * IMPORTANT: because control is transferred to `recipient`, care must be
302      * taken to not create reentrancy vulnerabilities. Consider using
303      * {ReentrancyGuard} or the
304      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
305      */
306     function sendValue(address payable recipient, uint256 amount) internal {
307         require(
308             address(this).balance >= amount,
309             "Address: insufficient balance"
310         );
311 
312         (bool success, ) = recipient.call{value: amount}("");
313         require(
314             success,
315             "Address: unable to send value, recipient may have reverted"
316         );
317     }
318 
319     /**
320      * @dev Performs a Solidity function call using a low level `call`. A
321      * plain `call` is an unsafe replacement for a function call: use this
322      * function instead.
323      *
324      * If `target` reverts with a revert reason, it is bubbled up by this
325      * function (like regular Solidity function calls).
326      *
327      * Returns the raw returned data. To convert to the expected return value,
328      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
329      *
330      * Requirements:
331      *
332      * - `target` must be a contract.
333      * - calling `target` with `data` must not revert.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data)
338         internal
339         returns (bytes memory)
340     {
341         return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value
373     ) internal returns (bytes memory) {
374         return
375             functionCallWithValue(
376                 target,
377                 data,
378                 value,
379                 "Address: low-level call with value failed"
380             );
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
385      * with `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(
390         address target,
391         bytes memory data,
392         uint256 value,
393         string memory errorMessage
394     ) internal returns (bytes memory) {
395         require(
396             address(this).balance >= value,
397             "Address: insufficient balance for call"
398         );
399         require(isContract(target), "Address: call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.call{value: value}(
402             data
403         );
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but performing a static call.
410      *
411      * _Available since v3.3._
412      */
413     function functionStaticCall(address target, bytes memory data)
414         internal
415         view
416         returns (bytes memory)
417     {
418         return
419             functionStaticCall(
420                 target,
421                 data,
422                 "Address: low-level static call failed"
423             );
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
428      * but performing a static call.
429      *
430      * _Available since v3.3._
431      */
432     function functionStaticCall(
433         address target,
434         bytes memory data,
435         string memory errorMessage
436     ) internal view returns (bytes memory) {
437         require(isContract(target), "Address: static call to non-contract");
438 
439         (bool success, bytes memory returndata) = target.staticcall(data);
440         return verifyCallResult(success, returndata, errorMessage);
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
445      * but performing a delegate call.
446      *
447      * _Available since v3.4._
448      */
449     function functionDelegateCall(address target, bytes memory data)
450         internal
451         returns (bytes memory)
452     {
453         return
454             functionDelegateCall(
455                 target,
456                 data,
457                 "Address: low-level delegate call failed"
458             );
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
463      * but performing a delegate call.
464      *
465      * _Available since v3.4._
466      */
467     function functionDelegateCall(
468         address target,
469         bytes memory data,
470         string memory errorMessage
471     ) internal returns (bytes memory) {
472         require(isContract(target), "Address: delegate call to non-contract");
473 
474         (bool success, bytes memory returndata) = target.delegatecall(data);
475         return verifyCallResult(success, returndata, errorMessage);
476     }
477 
478     /**
479      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
480      * revert reason using the provided one.
481      *
482      * _Available since v4.3._
483      */
484     function verifyCallResult(
485         bool success,
486         bytes memory returndata,
487         string memory errorMessage
488     ) internal pure returns (bytes memory) {
489         if (success) {
490             return returndata;
491         } else {
492             // Look for revert reason and bubble it up if present
493             if (returndata.length > 0) {
494                 // The easiest way to bubble the revert reason is using memory via assembly
495 
496                 assembly {
497                     let returndata_size := mload(returndata)
498                     revert(add(32, returndata), returndata_size)
499                 }
500             } else {
501                 revert(errorMessage);
502             }
503         }
504     }
505 }
506 
507 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
508 
509 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
510 
511 pragma solidity ^0.8.0;
512 
513 /**
514  * @dev Provides information about the current execution context, including the
515  * sender of the transaction and its data. While these are generally available
516  * via msg.sender and msg.data, they should not be accessed in such a direct
517  * manner, since when dealing with meta-transactions the account sending and
518  * paying for execution may not be the actual sender (as far as an application
519  * is concerned).
520  *
521  * This contract is only required for intermediate, library-like contracts.
522  */
523 abstract contract Context {
524     function _msgSender() internal view virtual returns (address) {
525         return msg.sender;
526     }
527 
528     function _msgData() internal view virtual returns (bytes calldata) {
529         return msg.data;
530     }
531 }
532 
533 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
534 
535 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 /**
540  * @dev String operations.
541  */
542 library Strings {
543     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
544 
545     /**
546      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
547      */
548     function toString(uint256 value) internal pure returns (string memory) {
549         // Inspired by OraclizeAPI's implementation - MIT licence
550         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
551 
552         if (value == 0) {
553             return "0";
554         }
555         uint256 temp = value;
556         uint256 digits;
557         while (temp != 0) {
558             digits++;
559             temp /= 10;
560         }
561         bytes memory buffer = new bytes(digits);
562         while (value != 0) {
563             digits -= 1;
564             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
565             value /= 10;
566         }
567         return string(buffer);
568     }
569 
570     /**
571      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
572      */
573     function toHexString(uint256 value) internal pure returns (string memory) {
574         if (value == 0) {
575             return "0x00";
576         }
577         uint256 temp = value;
578         uint256 length = 0;
579         while (temp != 0) {
580             length++;
581             temp >>= 8;
582         }
583         return toHexString(value, length);
584     }
585 
586     /**
587      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
588      */
589     function toHexString(uint256 value, uint256 length)
590         internal
591         pure
592         returns (string memory)
593     {
594         bytes memory buffer = new bytes(2 * length + 2);
595         buffer[0] = "0";
596         buffer[1] = "x";
597         for (uint256 i = 2 * length + 1; i > 1; --i) {
598             buffer[i] = _HEX_SYMBOLS[value & 0xf];
599             value >>= 4;
600         }
601         require(value == 0, "Strings: hex length insufficient");
602         return string(buffer);
603     }
604 }
605 
606 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
607 
608 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
609 
610 pragma solidity ^0.8.0;
611 
612 /**
613  * @dev Implementation of the {IERC165} interface.
614  *
615  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
616  * for the additional interface id that will be supported. For example:
617  *
618  * ```solidity
619  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
620  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
621  * }
622  * ```
623  *
624  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
625  */
626 abstract contract ERC165 is IERC165 {
627     /**
628      * @dev See {IERC165-supportsInterface}.
629      */
630     function supportsInterface(bytes4 interfaceId)
631         public
632         view
633         virtual
634         override
635         returns (bool)
636     {
637         return interfaceId == type(IERC165).interfaceId;
638     }
639 }
640 
641 // File erc721a/contracts/ERC721A.sol@v3.2.0
642 
643 // Creator: Chiru Labs
644 
645 pragma solidity ^0.8.4;
646 
647 error ApprovalCallerNotOwnerNorApproved();
648 error ApprovalQueryForNonexistentToken();
649 error ApproveToCaller();
650 error ApprovalToCurrentOwner();
651 error BalanceQueryForZeroAddress();
652 error MintToZeroAddress();
653 error MintZeroQuantity();
654 error OwnerQueryForNonexistentToken();
655 error TransferCallerNotOwnerNorApproved();
656 error TransferFromIncorrectOwner();
657 error TransferToNonERC721ReceiverImplementer();
658 error TransferToZeroAddress();
659 error URIQueryForNonexistentToken();
660 
661 /**
662  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
663  * the Metadata extension. Built to optimize for lower gas during batch mints.
664  *
665  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
666  *
667  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
668  *
669  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
670  */
671 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
672     using Address for address;
673     using Strings for uint256;
674 
675     // Compiler will pack this into a single 256bit word.
676     struct TokenOwnership {
677         // The address of the owner.
678         address addr;
679         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
680         uint64 startTimestamp;
681         // Whether the token has been burned.
682         bool burned;
683     }
684 
685     // Compiler will pack this into a single 256bit word.
686     struct AddressData {
687         // Realistically, 2**64-1 is more than enough.
688         uint64 balance;
689         // Keeps track of mint count with minimal overhead for tokenomics.
690         uint64 numberMinted;
691         // Keeps track of burn count with minimal overhead for tokenomics.
692         uint64 numberBurned;
693         // For miscellaneous variable(s) pertaining to the address
694         // (e.g. number of whitelist mint slots used).
695         // If there are multiple variables, please pack them into a uint64.
696         uint64 aux;
697     }
698 
699     // The tokenId of the next token to be minted.
700     uint256 internal _currentIndex;
701 
702     // The number of tokens burned.
703     uint256 internal _burnCounter;
704 
705     // Token name
706     string private _name;
707 
708     // Token symbol
709     string private _symbol;
710 
711     // Mapping from token ID to ownership details
712     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
713     mapping(uint256 => TokenOwnership) internal _ownerships;
714 
715     // Mapping owner address to address data
716     mapping(address => AddressData) private _addressData;
717 
718     // Mapping from token ID to approved address
719     mapping(uint256 => address) private _tokenApprovals;
720 
721     // Mapping from owner to operator approvals
722     mapping(address => mapping(address => bool)) private _operatorApprovals;
723 
724     constructor(string memory name_, string memory symbol_) {
725         _name = name_;
726         _symbol = symbol_;
727         _currentIndex = _startTokenId();
728     }
729 
730     /**
731      * To change the starting tokenId, please override this function.
732      */
733     function _startTokenId() internal view virtual returns (uint256) {
734         return 0;
735     }
736 
737     /**
738      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
739      */
740     function totalSupply() public view returns (uint256) {
741         // Counter underflow is impossible as _burnCounter cannot be incremented
742         // more than _currentIndex - _startTokenId() times
743         unchecked {
744             return _currentIndex - _burnCounter - _startTokenId();
745         }
746     }
747 
748     /**
749      * Returns the total amount of tokens minted in the contract.
750      */
751     function _totalMinted() internal view returns (uint256) {
752         // Counter underflow is impossible as _currentIndex does not decrement,
753         // and it is initialized to _startTokenId()
754         unchecked {
755             return _currentIndex - _startTokenId();
756         }
757     }
758 
759     /**
760      * @dev See {IERC165-supportsInterface}.
761      */
762     function supportsInterface(bytes4 interfaceId)
763         public
764         view
765         virtual
766         override(ERC165, IERC165)
767         returns (bool)
768     {
769         return
770             interfaceId == type(IERC721).interfaceId ||
771             interfaceId == type(IERC721Metadata).interfaceId ||
772             super.supportsInterface(interfaceId);
773     }
774 
775     /**
776      * @dev See {IERC721-balanceOf}.
777      */
778     function balanceOf(address owner) public view override returns (uint256) {
779         if (owner == address(0)) revert BalanceQueryForZeroAddress();
780         return uint256(_addressData[owner].balance);
781     }
782 
783     /**
784      * Returns the number of tokens minted by `owner`.
785      */
786     function _numberMinted(address owner) internal view returns (uint256) {
787         return uint256(_addressData[owner].numberMinted);
788     }
789 
790     /**
791      * Returns the number of tokens burned by or on behalf of `owner`.
792      */
793     function _numberBurned(address owner) internal view returns (uint256) {
794         return uint256(_addressData[owner].numberBurned);
795     }
796 
797     /**
798      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
799      */
800     function _getAux(address owner) internal view returns (uint64) {
801         return _addressData[owner].aux;
802     }
803 
804     /**
805      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
806      * If there are multiple variables, please pack them into a uint64.
807      */
808     function _setAux(address owner, uint64 aux) internal {
809         _addressData[owner].aux = aux;
810     }
811 
812     /**
813      * Gas spent here starts off proportional to the maximum mint batch size.
814      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
815      */
816     function _ownershipOf(uint256 tokenId)
817         internal
818         view
819         returns (TokenOwnership memory)
820     {
821         uint256 curr = tokenId;
822 
823         unchecked {
824             if (_startTokenId() <= curr && curr < _currentIndex) {
825                 TokenOwnership memory ownership = _ownerships[curr];
826                 if (!ownership.burned) {
827                     if (ownership.addr != address(0)) {
828                         return ownership;
829                     }
830                     // Invariant:
831                     // There will always be an ownership that has an address and is not burned
832                     // before an ownership that does not have an address and is not burned.
833                     // Hence, curr will not underflow.
834                     while (true) {
835                         curr--;
836                         ownership = _ownerships[curr];
837                         if (ownership.addr != address(0)) {
838                             return ownership;
839                         }
840                     }
841                 }
842             }
843         }
844         revert OwnerQueryForNonexistentToken();
845     }
846 
847     /**
848      * @dev See {IERC721-ownerOf}.
849      */
850     function ownerOf(uint256 tokenId) public view override returns (address) {
851         return _ownershipOf(tokenId).addr;
852     }
853 
854     /**
855      * @dev See {IERC721Metadata-name}.
856      */
857     function name() public view virtual override returns (string memory) {
858         return _name;
859     }
860 
861     /**
862      * @dev See {IERC721Metadata-symbol}.
863      */
864     function symbol() public view virtual override returns (string memory) {
865         return _symbol;
866     }
867 
868     /**
869      * @dev See {IERC721Metadata-tokenURI}.
870      */
871     function tokenURI(uint256 tokenId)
872         public
873         view
874         virtual
875         override
876         returns (string memory)
877     {
878         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
879 
880         string memory baseURI = _baseURI();
881         return
882             bytes(baseURI).length != 0
883                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
884                 : "";
885     }
886 
887     /**
888      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
889      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
890      * by default, can be overriden in child contracts.
891      */
892     function _baseURI() internal view virtual returns (string memory) {
893         return "";
894     }
895 
896     /**
897      * @dev See {IERC721-approve}.
898      */
899     function approve(address to, uint256 tokenId) public override {
900         address owner = ERC721A.ownerOf(tokenId);
901         if (to == owner) revert ApprovalToCurrentOwner();
902 
903         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
904             revert ApprovalCallerNotOwnerNorApproved();
905         }
906 
907         _approve(to, tokenId, owner);
908     }
909 
910     /**
911      * @dev See {IERC721-getApproved}.
912      */
913     function getApproved(uint256 tokenId)
914         public
915         view
916         override
917         returns (address)
918     {
919         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
920 
921         return _tokenApprovals[tokenId];
922     }
923 
924     /**
925      * @dev See {IERC721-setApprovalForAll}.
926      */
927     function setApprovalForAll(address operator, bool approved)
928         public
929         virtual
930         override
931     {
932         if (operator == _msgSender()) revert ApproveToCaller();
933 
934         _operatorApprovals[_msgSender()][operator] = approved;
935         emit ApprovalForAll(_msgSender(), operator, approved);
936     }
937 
938     /**
939      * @dev See {IERC721-isApprovedForAll}.
940      */
941     function isApprovedForAll(address owner, address operator)
942         public
943         view
944         virtual
945         override
946         returns (bool)
947     {
948         return _operatorApprovals[owner][operator];
949     }
950 
951     /**
952      * @dev See {IERC721-transferFrom}.
953      */
954     function transferFrom(
955         address from,
956         address to,
957         uint256 tokenId
958     ) public virtual override {
959         _transfer(from, to, tokenId);
960     }
961 
962     /**
963      * @dev See {IERC721-safeTransferFrom}.
964      */
965     function safeTransferFrom(
966         address from,
967         address to,
968         uint256 tokenId
969     ) public virtual override {
970         safeTransferFrom(from, to, tokenId, "");
971     }
972 
973     /**
974      * @dev See {IERC721-safeTransferFrom}.
975      */
976     function safeTransferFrom(
977         address from,
978         address to,
979         uint256 tokenId,
980         bytes memory _data
981     ) public virtual override {
982         _transfer(from, to, tokenId);
983         if (
984             to.isContract() &&
985             !_checkContractOnERC721Received(from, to, tokenId, _data)
986         ) {
987             revert TransferToNonERC721ReceiverImplementer();
988         }
989     }
990 
991     /**
992      * @dev Returns whether `tokenId` exists.
993      *
994      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
995      *
996      * Tokens start existing when they are minted (`_mint`),
997      */
998     function _exists(uint256 tokenId) internal view returns (bool) {
999         return
1000             _startTokenId() <= tokenId &&
1001             tokenId < _currentIndex &&
1002             !_ownerships[tokenId].burned;
1003     }
1004 
1005     function _safeMint(address to, uint256 quantity) internal {
1006         _safeMint(to, quantity, "");
1007     }
1008 
1009     /**
1010      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1011      *
1012      * Requirements:
1013      *
1014      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1015      * - `quantity` must be greater than 0.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function _safeMint(
1020         address to,
1021         uint256 quantity,
1022         bytes memory _data
1023     ) internal {
1024         _mint(to, quantity, _data, true);
1025     }
1026 
1027     /**
1028      * @dev Mints `quantity` tokens and transfers them to `to`.
1029      *
1030      * Requirements:
1031      *
1032      * - `to` cannot be the zero address.
1033      * - `quantity` must be greater than 0.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function _mint(
1038         address to,
1039         uint256 quantity,
1040         bytes memory _data,
1041         bool safe
1042     ) internal {
1043         uint256 startTokenId = _currentIndex;
1044         if (to == address(0)) revert MintToZeroAddress();
1045         if (quantity == 0) revert MintZeroQuantity();
1046 
1047         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1048 
1049         // Overflows are incredibly unrealistic.
1050         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1051         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1052         unchecked {
1053             _addressData[to].balance += uint64(quantity);
1054             _addressData[to].numberMinted += uint64(quantity);
1055 
1056             _ownerships[startTokenId].addr = to;
1057             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1058 
1059             uint256 updatedIndex = startTokenId;
1060             uint256 end = updatedIndex + quantity;
1061 
1062             if (safe && to.isContract()) {
1063                 do {
1064                     emit Transfer(address(0), to, updatedIndex);
1065                     if (
1066                         !_checkContractOnERC721Received(
1067                             address(0),
1068                             to,
1069                             updatedIndex++,
1070                             _data
1071                         )
1072                     ) {
1073                         revert TransferToNonERC721ReceiverImplementer();
1074                     }
1075                 } while (updatedIndex != end);
1076                 // Reentrancy protection
1077                 if (_currentIndex != startTokenId) revert();
1078             } else {
1079                 do {
1080                     emit Transfer(address(0), to, updatedIndex++);
1081                 } while (updatedIndex != end);
1082             }
1083             _currentIndex = updatedIndex;
1084         }
1085         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1086     }
1087 
1088     /**
1089      * @dev Transfers `tokenId` from `from` to `to`.
1090      *
1091      * Requirements:
1092      *
1093      * - `to` cannot be the zero address.
1094      * - `tokenId` token must be owned by `from`.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function _transfer(
1099         address from,
1100         address to,
1101         uint256 tokenId
1102     ) private {
1103         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1104 
1105         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1106 
1107         bool isApprovedOrOwner = (_msgSender() == from ||
1108             isApprovedForAll(from, _msgSender()) ||
1109             getApproved(tokenId) == _msgSender());
1110 
1111         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1112         if (to == address(0)) revert TransferToZeroAddress();
1113 
1114         _beforeTokenTransfers(from, to, tokenId, 1);
1115 
1116         // Clear approvals from the previous owner
1117         _approve(address(0), tokenId, from);
1118 
1119         // Underflow of the sender's balance is impossible because we check for
1120         // ownership above and the recipient's balance can't realistically overflow.
1121         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1122         unchecked {
1123             _addressData[from].balance -= 1;
1124             _addressData[to].balance += 1;
1125 
1126             TokenOwnership storage currSlot = _ownerships[tokenId];
1127             currSlot.addr = to;
1128             currSlot.startTimestamp = uint64(block.timestamp);
1129 
1130             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1131             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1132             uint256 nextTokenId = tokenId + 1;
1133             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1134             if (nextSlot.addr == address(0)) {
1135                 // This will suffice for checking _exists(nextTokenId),
1136                 // as a burned slot cannot contain the zero address.
1137                 if (nextTokenId != _currentIndex) {
1138                     nextSlot.addr = from;
1139                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1140                 }
1141             }
1142         }
1143 
1144         emit Transfer(from, to, tokenId);
1145         _afterTokenTransfers(from, to, tokenId, 1);
1146     }
1147 
1148     /**
1149      * @dev This is equivalent to _burn(tokenId, false)
1150      */
1151     function _burn(uint256 tokenId) internal virtual {
1152         _burn(tokenId, false);
1153     }
1154 
1155     /**
1156      * @dev Destroys `tokenId`.
1157      * The approval is cleared when the token is burned.
1158      *
1159      * Requirements:
1160      *
1161      * - `tokenId` must exist.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1166         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1167 
1168         address from = prevOwnership.addr;
1169 
1170         if (approvalCheck) {
1171             bool isApprovedOrOwner = (_msgSender() == from ||
1172                 isApprovedForAll(from, _msgSender()) ||
1173                 getApproved(tokenId) == _msgSender());
1174 
1175             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1176         }
1177 
1178         _beforeTokenTransfers(from, address(0), tokenId, 1);
1179 
1180         // Clear approvals from the previous owner
1181         _approve(address(0), tokenId, from);
1182 
1183         // Underflow of the sender's balance is impossible because we check for
1184         // ownership above and the recipient's balance can't realistically overflow.
1185         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1186         unchecked {
1187             AddressData storage addressData = _addressData[from];
1188             addressData.balance -= 1;
1189             addressData.numberBurned += 1;
1190 
1191             // Keep track of who burned the token, and the timestamp of burning.
1192             TokenOwnership storage currSlot = _ownerships[tokenId];
1193             currSlot.addr = from;
1194             currSlot.startTimestamp = uint64(block.timestamp);
1195             currSlot.burned = true;
1196 
1197             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1198             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1199             uint256 nextTokenId = tokenId + 1;
1200             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1201             if (nextSlot.addr == address(0)) {
1202                 // This will suffice for checking _exists(nextTokenId),
1203                 // as a burned slot cannot contain the zero address.
1204                 if (nextTokenId != _currentIndex) {
1205                     nextSlot.addr = from;
1206                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1207                 }
1208             }
1209         }
1210 
1211         emit Transfer(from, address(0), tokenId);
1212         _afterTokenTransfers(from, address(0), tokenId, 1);
1213 
1214         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1215         unchecked {
1216             _burnCounter++;
1217         }
1218     }
1219 
1220     /**
1221      * @dev Approve `to` to operate on `tokenId`
1222      *
1223      * Emits a {Approval} event.
1224      */
1225     function _approve(
1226         address to,
1227         uint256 tokenId,
1228         address owner
1229     ) private {
1230         _tokenApprovals[tokenId] = to;
1231         emit Approval(owner, to, tokenId);
1232     }
1233 
1234     /**
1235      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1236      *
1237      * @param from address representing the previous owner of the given token ID
1238      * @param to target address that will receive the tokens
1239      * @param tokenId uint256 ID of the token to be transferred
1240      * @param _data bytes optional data to send along with the call
1241      * @return bool whether the call correctly returned the expected magic value
1242      */
1243     function _checkContractOnERC721Received(
1244         address from,
1245         address to,
1246         uint256 tokenId,
1247         bytes memory _data
1248     ) private returns (bool) {
1249         try
1250             IERC721Receiver(to).onERC721Received(
1251                 _msgSender(),
1252                 from,
1253                 tokenId,
1254                 _data
1255             )
1256         returns (bytes4 retval) {
1257             return retval == IERC721Receiver(to).onERC721Received.selector;
1258         } catch (bytes memory reason) {
1259             if (reason.length == 0) {
1260                 revert TransferToNonERC721ReceiverImplementer();
1261             } else {
1262                 assembly {
1263                     revert(add(32, reason), mload(reason))
1264                 }
1265             }
1266         }
1267     }
1268 
1269     /**
1270      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1271      * And also called before burning one token.
1272      *
1273      * startTokenId - the first token id to be transferred
1274      * quantity - the amount to be transferred
1275      *
1276      * Calling conditions:
1277      *
1278      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1279      * transferred to `to`.
1280      * - When `from` is zero, `tokenId` will be minted for `to`.
1281      * - When `to` is zero, `tokenId` will be burned by `from`.
1282      * - `from` and `to` are never both zero.
1283      */
1284     function _beforeTokenTransfers(
1285         address from,
1286         address to,
1287         uint256 startTokenId,
1288         uint256 quantity
1289     ) internal virtual {}
1290 
1291     /**
1292      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1293      * minting.
1294      * And also called after one token has been burned.
1295      *
1296      * startTokenId - the first token id to be transferred
1297      * quantity - the amount to be transferred
1298      *
1299      * Calling conditions:
1300      *
1301      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1302      * transferred to `to`.
1303      * - When `from` is zero, `tokenId` has been minted for `to`.
1304      * - When `to` is zero, `tokenId` has been burned by `from`.
1305      * - `from` and `to` are never both zero.
1306      */
1307     function _afterTokenTransfers(
1308         address from,
1309         address to,
1310         uint256 startTokenId,
1311         uint256 quantity
1312     ) internal virtual {}
1313 }
1314 
1315 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1316 
1317 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1318 
1319 pragma solidity ^0.8.0;
1320 
1321 /**
1322  * @dev Contract module which provides a basic access control mechanism, where
1323  * there is an account (an owner) that can be granted exclusive access to
1324  * specific functions.
1325  *
1326  * By default, the owner account will be the one that deploys the contract. This
1327  * can later be changed with {transferOwnership}.
1328  *
1329  * This module is used through inheritance. It will make available the modifier
1330  * `onlyOwner`, which can be applied to your functions to restrict their use to
1331  * the owner.
1332  */
1333 abstract contract Ownable is Context {
1334     address private _owner;
1335 
1336     event OwnershipTransferred(
1337         address indexed previousOwner,
1338         address indexed newOwner
1339     );
1340 
1341     /**
1342      * @dev Initializes the contract setting the deployer as the initial owner.
1343      */
1344     constructor() {
1345         _transferOwnership(_msgSender());
1346     }
1347 
1348     /**
1349      * @dev Returns the address of the current owner.
1350      */
1351     function owner() public view virtual returns (address) {
1352         return _owner;
1353     }
1354 
1355     /**
1356      * @dev Throws if called by any account other than the owner.
1357      */
1358     modifier onlyOwner() {
1359         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1360         _;
1361     }
1362 
1363     /**
1364      * @dev Leaves the contract without owner. It will not be possible to call
1365      * `onlyOwner` functions anymore. Can only be called by the current owner.
1366      *
1367      * NOTE: Renouncing ownership will leave the contract without an owner,
1368      * thereby removing any functionality that is only available to the owner.
1369      */
1370     function renounceOwnership() public virtual onlyOwner {
1371         _transferOwnership(address(0));
1372     }
1373 
1374     /**
1375      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1376      * Can only be called by the current owner.
1377      */
1378     function transferOwnership(address newOwner) public virtual onlyOwner {
1379         require(
1380             newOwner != address(0),
1381             "Ownable: new owner is the zero address"
1382         );
1383         _transferOwnership(newOwner);
1384     }
1385 
1386     /**
1387      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1388      * Internal function without access restriction.
1389      */
1390     function _transferOwnership(address newOwner) internal virtual {
1391         address oldOwner = _owner;
1392         _owner = newOwner;
1393         emit OwnershipTransferred(oldOwner, newOwner);
1394     }
1395 }
1396 
1397 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
1398 
1399 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1400 
1401 pragma solidity ^0.8.0;
1402 
1403 /**
1404  * @dev Contract module that helps prevent reentrant calls to a function.
1405  *
1406  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1407  * available, which can be applied to functions to make sure there are no nested
1408  * (reentrant) calls to them.
1409  *
1410  * Note that because there is a single `nonReentrant` guard, functions marked as
1411  * `nonReentrant` may not call one another. This can be worked around by making
1412  * those functions `private`, and then adding `external` `nonReentrant` entry
1413  * points to them.
1414  *
1415  * TIP: If you would like to learn more about reentrancy and alternative ways
1416  * to protect against it, check out our blog post
1417  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1418  */
1419 abstract contract ReentrancyGuard {
1420     // Booleans are more expensive than uint256 or any type that takes up a full
1421     // word because each write operation emits an extra SLOAD to first read the
1422     // slot's contents, replace the bits taken up by the boolean, and then write
1423     // back. This is the compiler's defense against contract upgrades and
1424     // pointer aliasing, and it cannot be disabled.
1425 
1426     // The values being non-zero value makes deployment a bit more expensive,
1427     // but in exchange the refund on every call to nonReentrant will be lower in
1428     // amount. Since refunds are capped to a percentage of the total
1429     // transaction's gas, it is best to keep them low in cases like this one, to
1430     // increase the likelihood of the full refund coming into effect.
1431     uint256 private constant _NOT_ENTERED = 1;
1432     uint256 private constant _ENTERED = 2;
1433 
1434     uint256 private _status;
1435 
1436     constructor() {
1437         _status = _NOT_ENTERED;
1438     }
1439 
1440     /**
1441      * @dev Prevents a contract from calling itself, directly or indirectly.
1442      * Calling a `nonReentrant` function from another `nonReentrant`
1443      * function is not supported. It is possible to prevent this from happening
1444      * by making the `nonReentrant` function external, and making it call a
1445      * `private` function that does the actual work.
1446      */
1447     modifier nonReentrant() {
1448         // On the first call to nonReentrant, _notEntered will be true
1449         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1450 
1451         // Any calls to nonReentrant after this point will fail
1452         _status = _ENTERED;
1453 
1454         _;
1455 
1456         // By storing the original value once again, a refund is triggered (see
1457         // https://eips.ethereum.org/EIPS/eip-2200)
1458         _status = _NOT_ENTERED;
1459     }
1460 }
1461 
1462 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.5.0
1463 
1464 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
1465 
1466 pragma solidity ^0.8.0;
1467 
1468 /**
1469  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1470  *
1471  * These functions can be used to verify that a message was signed by the holder
1472  * of the private keys of a given address.
1473  */
1474 library ECDSA {
1475     enum RecoverError {
1476         NoError,
1477         InvalidSignature,
1478         InvalidSignatureLength,
1479         InvalidSignatureS,
1480         InvalidSignatureV
1481     }
1482 
1483     function _throwError(RecoverError error) private pure {
1484         if (error == RecoverError.NoError) {
1485             return; // no error: do nothing
1486         } else if (error == RecoverError.InvalidSignature) {
1487             revert("ECDSA: invalid signature");
1488         } else if (error == RecoverError.InvalidSignatureLength) {
1489             revert("ECDSA: invalid signature length");
1490         } else if (error == RecoverError.InvalidSignatureS) {
1491             revert("ECDSA: invalid signature 's' value");
1492         } else if (error == RecoverError.InvalidSignatureV) {
1493             revert("ECDSA: invalid signature 'v' value");
1494         }
1495     }
1496 
1497     /**
1498      * @dev Returns the address that signed a hashed message (`hash`) with
1499      * `signature` or error string. This address can then be used for verification purposes.
1500      *
1501      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1502      * this function rejects them by requiring the `s` value to be in the lower
1503      * half order, and the `v` value to be either 27 or 28.
1504      *
1505      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1506      * verification to be secure: it is possible to craft signatures that
1507      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1508      * this is by receiving a hash of the original message (which may otherwise
1509      * be too long), and then calling {toEthSignedMessageHash} on it.
1510      *
1511      * Documentation for signature generation:
1512      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1513      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1514      *
1515      * _Available since v4.3._
1516      */
1517     function tryRecover(bytes32 hash, bytes memory signature)
1518         internal
1519         pure
1520         returns (address, RecoverError)
1521     {
1522         // Check the signature length
1523         // - case 65: r,s,v signature (standard)
1524         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1525         if (signature.length == 65) {
1526             bytes32 r;
1527             bytes32 s;
1528             uint8 v;
1529             // ecrecover takes the signature parameters, and the only way to get them
1530             // currently is to use assembly.
1531             assembly {
1532                 r := mload(add(signature, 0x20))
1533                 s := mload(add(signature, 0x40))
1534                 v := byte(0, mload(add(signature, 0x60)))
1535             }
1536             return tryRecover(hash, v, r, s);
1537         } else if (signature.length == 64) {
1538             bytes32 r;
1539             bytes32 vs;
1540             // ecrecover takes the signature parameters, and the only way to get them
1541             // currently is to use assembly.
1542             assembly {
1543                 r := mload(add(signature, 0x20))
1544                 vs := mload(add(signature, 0x40))
1545             }
1546             return tryRecover(hash, r, vs);
1547         } else {
1548             return (address(0), RecoverError.InvalidSignatureLength);
1549         }
1550     }
1551 
1552     /**
1553      * @dev Returns the address that signed a hashed message (`hash`) with
1554      * `signature`. This address can then be used for verification purposes.
1555      *
1556      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1557      * this function rejects them by requiring the `s` value to be in the lower
1558      * half order, and the `v` value to be either 27 or 28.
1559      *
1560      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1561      * verification to be secure: it is possible to craft signatures that
1562      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1563      * this is by receiving a hash of the original message (which may otherwise
1564      * be too long), and then calling {toEthSignedMessageHash} on it.
1565      */
1566     function recover(bytes32 hash, bytes memory signature)
1567         internal
1568         pure
1569         returns (address)
1570     {
1571         (address recovered, RecoverError error) = tryRecover(hash, signature);
1572         _throwError(error);
1573         return recovered;
1574     }
1575 
1576     /**
1577      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1578      *
1579      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1580      *
1581      * _Available since v4.3._
1582      */
1583     function tryRecover(
1584         bytes32 hash,
1585         bytes32 r,
1586         bytes32 vs
1587     ) internal pure returns (address, RecoverError) {
1588         bytes32 s = vs &
1589             bytes32(
1590                 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
1591             );
1592         uint8 v = uint8((uint256(vs) >> 255) + 27);
1593         return tryRecover(hash, v, r, s);
1594     }
1595 
1596     /**
1597      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1598      *
1599      * _Available since v4.2._
1600      */
1601     function recover(
1602         bytes32 hash,
1603         bytes32 r,
1604         bytes32 vs
1605     ) internal pure returns (address) {
1606         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1607         _throwError(error);
1608         return recovered;
1609     }
1610 
1611     /**
1612      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1613      * `r` and `s` signature fields separately.
1614      *
1615      * _Available since v4.3._
1616      */
1617     function tryRecover(
1618         bytes32 hash,
1619         uint8 v,
1620         bytes32 r,
1621         bytes32 s
1622     ) internal pure returns (address, RecoverError) {
1623         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1624         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1625         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1626         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1627         //
1628         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1629         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1630         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1631         // these malleable signatures as well.
1632         if (
1633             uint256(s) >
1634             0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
1635         ) {
1636             return (address(0), RecoverError.InvalidSignatureS);
1637         }
1638         if (v != 27 && v != 28) {
1639             return (address(0), RecoverError.InvalidSignatureV);
1640         }
1641 
1642         // If the signature is valid (and not malleable), return the signer address
1643         address signer = ecrecover(hash, v, r, s);
1644         if (signer == address(0)) {
1645             return (address(0), RecoverError.InvalidSignature);
1646         }
1647 
1648         return (signer, RecoverError.NoError);
1649     }
1650 
1651     /**
1652      * @dev Overload of {ECDSA-recover} that receives the `v`,
1653      * `r` and `s` signature fields separately.
1654      */
1655     function recover(
1656         bytes32 hash,
1657         uint8 v,
1658         bytes32 r,
1659         bytes32 s
1660     ) internal pure returns (address) {
1661         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1662         _throwError(error);
1663         return recovered;
1664     }
1665 
1666     /**
1667      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1668      * produces hash corresponding to the one signed with the
1669      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1670      * JSON-RPC method as part of EIP-191.
1671      *
1672      * See {recover}.
1673      */
1674     function toEthSignedMessageHash(bytes32 hash)
1675         internal
1676         pure
1677         returns (bytes32)
1678     {
1679         // 32 is the length in bytes of hash,
1680         // enforced by the type signature above
1681         return
1682             keccak256(
1683                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
1684             );
1685     }
1686 
1687     /**
1688      * @dev Returns an Ethereum Signed Message, created from `s`. This
1689      * produces hash corresponding to the one signed with the
1690      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1691      * JSON-RPC method as part of EIP-191.
1692      *
1693      * See {recover}.
1694      */
1695     function toEthSignedMessageHash(bytes memory s)
1696         internal
1697         pure
1698         returns (bytes32)
1699     {
1700         return
1701             keccak256(
1702                 abi.encodePacked(
1703                     "\x19Ethereum Signed Message:\n",
1704                     Strings.toString(s.length),
1705                     s
1706                 )
1707             );
1708     }
1709 
1710     /**
1711      * @dev Returns an Ethereum Signed Typed Data, created from a
1712      * `domainSeparator` and a `structHash`. This produces hash corresponding
1713      * to the one signed with the
1714      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1715      * JSON-RPC method as part of EIP-712.
1716      *
1717      * See {recover}.
1718      */
1719     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash)
1720         internal
1721         pure
1722         returns (bytes32)
1723     {
1724         return
1725             keccak256(
1726                 abi.encodePacked("\x19\x01", domainSeparator, structHash)
1727             );
1728     }
1729 }
1730 
1731 // File contracts/MetaverseComiClub.sol
1732 
1733 pragma solidity >=0.8.9 <0.9.0;
1734 
1735 contract AnimApes is ERC721A, Ownable, ReentrancyGuard {
1736     using Strings for uint256;
1737 
1738     mapping(address => mapping(uint256 => uint256)) public nonWhitelistClaimed;
1739     mapping(address => mapping(uint256 => uint256)) public whitelistClaimed;
1740     mapping(address => mapping(uint256 => uint256))
1741         public superWhitelistClaimed;
1742     mapping(address => mapping(uint256 => uint256))
1743         public alphaWhitelistClaimed;
1744 
1745     string public uriPrefix = "";
1746     string public uriSuffix = ".json";
1747     string public hiddenMetadataUri;
1748     string private constant SIGNING_DOMAIN = "animapes";
1749     string private constant SIGNATURE_VERSION = "1";
1750     address signer = 0xa980df57d84635A598d6792c023CfA4617B96f2B;
1751 
1752     uint256 public cost = 0.07 ether;
1753     uint256 public wlCost = 0.065 ether;
1754     uint256 public superWlCost = 0.06 ether;
1755     uint256 public alphaWlCost = 0.055 ether;
1756 
1757     //Real max supply +1 to avoid double check (<=)
1758     uint256 public maxSupply = 4889;
1759     //Real max mint amounts per TX +1 to avoid double check (<=)
1760     uint256 public maxMintAmountPerTx = 3;
1761     uint256 public superWLMaxMintAmountPerTx = 4;
1762     uint256 public alphaWlMaxMintAmountPerTx = 6;
1763     //Real max mint amounts per whitelist +1 to avoid double check (<=)
1764     uint256 public maxMintAmountPerWl = 3;
1765     uint256 public maxMintAmountPerSuperWl = 4;
1766     uint256 public maxMintAmountPerAlphaWl = 6;
1767 
1768     //Real batch supply +1 to avoid double check (<=)
1769     uint256 public batchSupply = 889;
1770     uint256 public batch = 1;
1771     uint256 public batchMinted = 0;
1772 
1773     // EIP 712 Variables
1774     uint256 private immutable _CACHED_CHAIN_ID;
1775     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1776     address private immutable _CACHED_THIS;
1777 
1778     bytes32 private immutable _HASHED_NAME;
1779     bytes32 private immutable _HASHED_VERSION;
1780     bytes32 private immutable _TYPE_HASH;
1781 
1782     bool public paused = true;
1783     bool public whitelistMintEnabled = true;
1784     bool public revealed = false;
1785     bool public batchSaleEnabled = true;
1786 
1787     struct NFTVoucher {
1788         uint256 wlLevel;
1789         bytes signature;
1790     }
1791 
1792     constructor(string memory _hiddenMetadataUri) ERC721A("AnimApes", "AAP") {
1793         setHiddenMetadataUri(_hiddenMetadataUri);
1794         bytes32 hashedName = keccak256(bytes(SIGNING_DOMAIN));
1795         bytes32 hashedVersion = keccak256(bytes(SIGNATURE_VERSION));
1796         bytes32 typeHash = keccak256(
1797             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1798         );
1799         _HASHED_NAME = hashedName;
1800         _HASHED_VERSION = hashedVersion;
1801         _CACHED_CHAIN_ID = block.chainid;
1802         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(
1803             typeHash,
1804             hashedName,
1805             hashedVersion
1806         );
1807         _CACHED_THIS = address(this);
1808         _TYPE_HASH = typeHash;
1809     }
1810 
1811     function calculateCost(uint256 _mintAmount, uint256 _wlLevel)
1812         internal
1813         view
1814         returns (uint256 _cost)
1815     {
1816         if (_wlLevel == 0) {
1817             _cost = _mintAmount == (maxMintAmountPerTx - 1)
1818                 ? cost - ((cost * 5) / 100)
1819                 : cost;
1820         }
1821         if (_wlLevel == 1) {
1822             _cost = _mintAmount == (maxMintAmountPerTx - 1)
1823                 ? wlCost - ((wlCost * 5) / 100)
1824                 : wlCost;
1825         }
1826         if (_wlLevel == 2) {
1827             _cost = _mintAmount == (superWLMaxMintAmountPerTx - 1)
1828                 ? superWlCost - ((superWlCost * 5) / 100)
1829                 : superWlCost;
1830         }
1831         if (_wlLevel == 3) {
1832             _cost = _mintAmount == (alphaWlMaxMintAmountPerTx - 1)
1833                 ? alphaWlCost - ((alphaWlCost * 5) / 100)
1834                 : alphaWlCost;
1835         }
1836     }
1837 
1838     function mint(uint256 _mintAmount, NFTVoucher calldata v) public payable {
1839         require(!paused, "The contract is paused!");
1840         require(
1841             totalSupply() + _mintAmount < maxSupply,
1842             "Max supply exceeded!"
1843         );
1844         if (batchSaleEnabled == true) {
1845             require(
1846                 batchMinted + _mintAmount < batchSupply,
1847                 "Batch supply exceeded!"
1848             );
1849             batchMinted = batchMinted + _mintAmount;
1850         }
1851         uint256 wlLevel = v.wlLevel;
1852         if (whitelistMintEnabled == true) {
1853             require(wlLevel > 0, "Only Whitelist addresses allowed");
1854         }
1855 
1856         if (wlLevel == 0) {
1857             require(
1858                 _mintAmount < maxMintAmountPerTx,
1859                 "Max mint amount per TX exceded!!"
1860             );
1861             require(
1862                 nonWhitelistClaimed[msg.sender][batch] + _mintAmount <
1863                     maxMintAmountPerWl,
1864                 "Max mint amount exceded!!"
1865             );
1866             nonWhitelistClaimed[msg.sender][batch] += _mintAmount;
1867         } else {
1868             require(_verify(v) == signer, "The vaucher is not valid");
1869         }
1870 
1871         if (wlLevel == 1) {
1872             require(
1873                 _mintAmount < maxMintAmountPerTx,
1874                 "Max mint amount per TX exceded!!"
1875             );
1876             whitelistClaimed[msg.sender][batch] += _mintAmount;
1877         }
1878         if (wlLevel == 2) {
1879             require(
1880                 _mintAmount < superWLMaxMintAmountPerTx,
1881                 "Max mint amount per TX exceded!!"
1882             );
1883             require(
1884                 superWhitelistClaimed[msg.sender][batch] + _mintAmount <
1885                     maxMintAmountPerSuperWl,
1886                 "Max mint amount exceded!!"
1887             );
1888 
1889             superWhitelistClaimed[msg.sender][batch] += _mintAmount;
1890         }
1891         if (wlLevel == 3) {
1892             require(
1893                 _mintAmount < alphaWlMaxMintAmountPerTx,
1894                 "Max mint amount per TX exceded!!"
1895             );
1896             require(
1897                 alphaWhitelistClaimed[msg.sender][batch] + _mintAmount <
1898                     maxMintAmountPerAlphaWl,
1899                 "Max mint amount exceded!!"
1900             );
1901 
1902             alphaWhitelistClaimed[msg.sender][batch] += _mintAmount;
1903         }
1904 
1905         require(
1906             msg.value >= calculateCost(_mintAmount, wlLevel) * _mintAmount,
1907             "Insufficient funds!"
1908         );
1909 
1910         _safeMint(_msgSender(), _mintAmount);
1911     }
1912 
1913     function mintForAddress(uint256 _mintAmount, address _receiver)
1914         public
1915         onlyOwner
1916     {
1917         require(
1918             totalSupply() + _mintAmount <= maxSupply,
1919             "Max supply exceeded!"
1920         );
1921         _safeMint(_receiver, _mintAmount);
1922     }
1923 
1924     function walletOfOwner(address _owner)
1925         public
1926         view
1927         returns (uint256[] memory)
1928     {
1929         uint256 ownerTokenCount = balanceOf(_owner);
1930         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1931         uint256 currentTokenId = _startTokenId();
1932         uint256 ownedTokenIndex = 0;
1933         address latestOwnerAddress;
1934 
1935         while (
1936             ownedTokenIndex < ownerTokenCount && currentTokenId < _currentIndex
1937         ) {
1938             TokenOwnership memory ownership = _ownerships[currentTokenId];
1939 
1940             if (!ownership.burned) {
1941                 if (ownership.addr != address(0)) {
1942                     latestOwnerAddress = ownership.addr;
1943                 }
1944 
1945                 if (latestOwnerAddress == _owner) {
1946                     ownedTokenIds[ownedTokenIndex] = currentTokenId;
1947 
1948                     ownedTokenIndex++;
1949                 }
1950             }
1951 
1952             currentTokenId++;
1953         }
1954 
1955         return ownedTokenIds;
1956     }
1957 
1958     function _startTokenId() internal view virtual override returns (uint256) {
1959         return 1;
1960     }
1961 
1962     function tokenURI(uint256 _tokenId)
1963         public
1964         view
1965         virtual
1966         override
1967         returns (string memory)
1968     {
1969         require(
1970             _exists(_tokenId),
1971             "ERC721Metadata: URI query for nonexistent token"
1972         );
1973 
1974         string memory currentBaseURI = _baseURI();
1975         if (revealed == false) {
1976             currentBaseURI = hiddenMetadataUri;
1977         }
1978 
1979         return
1980             bytes(currentBaseURI).length > 0
1981                 ? string(
1982                     abi.encodePacked(
1983                         currentBaseURI,
1984                         _tokenId.toString(),
1985                         uriSuffix
1986                     )
1987                 )
1988                 : "";
1989     }
1990 
1991     function batchMintedForBuyer(address owner, uint256 wlLevel)
1992         public
1993         view
1994         returns (uint256 minted)
1995     {
1996         minted = 0;
1997         if (wlLevel == 0) {
1998             minted = nonWhitelistClaimed[owner][batch];
1999         }
2000         if (wlLevel == 1) {
2001             minted = whitelistClaimed[owner][batch];
2002         }
2003         if (wlLevel == 2) {
2004             minted = superWhitelistClaimed[owner][batch];
2005         }
2006         if (wlLevel == 3) {
2007             minted = alphaWhitelistClaimed[owner][batch];
2008         }
2009     }
2010 
2011     function setRevealed(bool _state) public onlyOwner {
2012         revealed = _state;
2013     }
2014 
2015     function setCost(uint256 _cost) public onlyOwner {
2016         cost = _cost;
2017     }
2018 
2019     function setWlCost(uint256 _wlCost) public onlyOwner {
2020         wlCost = _wlCost;
2021     }
2022 
2023     function setSuperWlCost(uint256 _superWlCost) public onlyOwner {
2024         superWlCost = _superWlCost;
2025     }
2026 
2027     function setAlphaWlCost(uint256 _alphaWlCost) public onlyOwner {
2028         alphaWlCost = _alphaWlCost;
2029     }
2030 
2031     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)
2032         public
2033         onlyOwner
2034     {
2035         maxMintAmountPerTx = _maxMintAmountPerTx;
2036     }
2037 
2038     function setSuperWLMaxMintAmountPerTx(uint256 _superWLMaxMintAmountPerTx)
2039         public
2040         onlyOwner
2041     {
2042         superWLMaxMintAmountPerTx = _superWLMaxMintAmountPerTx;
2043     }
2044 
2045     function setAlphaWlMaxMintAmountPerTx(uint256 _alphaWlMaxMintAmountPerTx)
2046         public
2047         onlyOwner
2048     {
2049         alphaWlMaxMintAmountPerTx = _alphaWlMaxMintAmountPerTx;
2050     }
2051 
2052     function setMaxMintAmountPerWl(uint256 _maxMintAmountPerWl)
2053         public
2054         onlyOwner
2055     {
2056         maxMintAmountPerWl = _maxMintAmountPerWl;
2057     }
2058 
2059     function setMaxMintAmountPerSuperWl(uint256 _maxMintAmountPerSuperWl)
2060         public
2061         onlyOwner
2062     {
2063         maxMintAmountPerSuperWl = _maxMintAmountPerSuperWl;
2064     }
2065 
2066     function setMaxMintAmountPerAlphaWl(uint256 _maxMintAmountPerAlphaWl)
2067         public
2068         onlyOwner
2069     {
2070         maxMintAmountPerAlphaWl = _maxMintAmountPerAlphaWl;
2071     }
2072 
2073     function setMaxMintAmountsPerTx(
2074         uint256 _maxMintAmountPerTx,
2075         uint256 _superWLMaxMintAmountPerTx,
2076         uint256 _alphaWlMaxMintAmountPerTx
2077     ) public onlyOwner {
2078         maxMintAmountPerTx = _maxMintAmountPerTx;
2079         superWLMaxMintAmountPerTx = _superWLMaxMintAmountPerTx;
2080         alphaWlMaxMintAmountPerTx = _alphaWlMaxMintAmountPerTx;
2081     }
2082 
2083     function setMaxMintAmountsPerWl(
2084         uint256 _maxMintAmountPerWl,
2085         uint256 _maxMintAmountPerSuperWl,
2086         uint256 _maxMintAmountPerAlphaWl
2087     ) public onlyOwner {
2088         maxMintAmountPerWl = _maxMintAmountPerWl;
2089         maxMintAmountPerSuperWl = _maxMintAmountPerSuperWl;
2090         maxMintAmountPerAlphaWl = _maxMintAmountPerAlphaWl;
2091     }
2092 
2093     function setSigner(address _signer) public onlyOwner {
2094         signer = _signer;
2095     }
2096 
2097     //batchSupply
2098     function setBatchSupply(uint256 _batch, uint256 _batchSupply)
2099         public
2100         onlyOwner
2101     {
2102         batch = _batch;
2103         batchSupply = _batchSupply;
2104         batchMinted = 0;
2105     }
2106 
2107     function setHiddenMetadataUri(string memory _hiddenMetadataUri)
2108         public
2109         onlyOwner
2110     {
2111         hiddenMetadataUri = _hiddenMetadataUri;
2112     }
2113 
2114     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2115         uriPrefix = _uriPrefix;
2116     }
2117 
2118     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2119         uriSuffix = _uriSuffix;
2120     }
2121 
2122     function setPaused(bool _state) public onlyOwner {
2123         paused = _state;
2124     }
2125 
2126     function setWhitelistMintEnabled(bool _state) public onlyOwner {
2127         whitelistMintEnabled = _state;
2128     }
2129 
2130     function setBatchSaleEnabled(bool _state) public onlyOwner {
2131         batchSaleEnabled = _state;
2132     }
2133 
2134     function withdraw() public onlyOwner nonReentrant {
2135         // Dev wallet
2136         (bool dev_hs, ) = payable(0xc89C51e660DB8385962Ddee0bED5C5EaE55cbdf3)
2137             .call{value: (address(this).balance * 250) / 10000}("");
2138         require(dev_hs);
2139         // Community wallet
2140         (bool hs, ) = payable(0x1644dF28AB0B927f06C9838BDEf2947088d2E758).call{
2141             value: (address(this).balance * 3000) / 10000
2142         }("");
2143         require(hs);
2144 
2145         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2146         require(os);
2147     }
2148 
2149     function _baseURI() internal view virtual override returns (string memory) {
2150         return uriPrefix;
2151     }
2152 
2153     function _hash(NFTVoucher calldata voucher)
2154         internal
2155         view
2156         returns (bytes32)
2157     {
2158         return
2159             _hashTypedDataV4(
2160                 keccak256(
2161                     abi.encode(
2162                         keccak256("NFTVoucher(uint256 wlLevel,address buyer)"),
2163                         voucher.wlLevel,
2164                         _msgSender()
2165                     )
2166                 )
2167             );
2168     }
2169 
2170     function getChainID() external view returns (uint256) {
2171         uint256 id;
2172         assembly {
2173             id := chainid()
2174         }
2175         return id;
2176     }
2177 
2178     function _verify(NFTVoucher calldata voucher)
2179         internal
2180         view
2181         returns (address)
2182     {
2183         bytes32 digest = _hash(voucher);
2184         return ECDSA.recover(digest, voucher.signature);
2185     }
2186 
2187     function _domainSeparatorV4() internal view returns (bytes32) {
2188         if (
2189             address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID
2190         ) {
2191             return _CACHED_DOMAIN_SEPARATOR;
2192         } else {
2193             return
2194                 _buildDomainSeparator(
2195                     _TYPE_HASH,
2196                     _HASHED_NAME,
2197                     _HASHED_VERSION
2198                 );
2199         }
2200     }
2201 
2202     function _buildDomainSeparator(
2203         bytes32 typeHash,
2204         bytes32 nameHash,
2205         bytes32 versionHash
2206     ) private view returns (bytes32) {
2207         return
2208             keccak256(
2209                 abi.encode(
2210                     typeHash,
2211                     nameHash,
2212                     versionHash,
2213                     block.chainid,
2214                     address(this)
2215                 )
2216             );
2217     }
2218 
2219     function _hashTypedDataV4(bytes32 structHash)
2220         internal
2221         view
2222         virtual
2223         returns (bytes32)
2224     {
2225         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
2226     }
2227 }