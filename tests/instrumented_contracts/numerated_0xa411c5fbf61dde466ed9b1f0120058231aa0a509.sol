1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Address.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
6 
7 pragma solidity ^0.8.1;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      *
30      * [IMPORTANT]
31      * ====
32      * You shouldn't rely on `isContract` to protect against flash loan attacks!
33      *
34      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
35      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
36      * constructor.
37      * ====
38      */
39     function isContract(address account) internal view returns (bool) {
40         // This method relies on extcodesize/address.code.length, which returns 0
41         // for contracts in construction, since the code is only stored at the end
42         // of the constructor execution.
43 
44         return account.code.length > 0;
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      */
63     function sendValue(address payable recipient, uint256 amount) internal {
64         require(address(this).balance >= amount, "Address: insufficient balance");
65 
66         (bool success, ) = recipient.call{value: amount}("");
67         require(success, "Address: unable to send value, recipient may have reverted");
68     }
69 
70     /**
71      * @dev Performs a Solidity function call using a low level `call`. A
72      * plain `call` is an unsafe replacement for a function call: use this
73      * function instead.
74      *
75      * If `target` reverts with a revert reason, it is bubbled up by this
76      * function (like regular Solidity function calls).
77      *
78      * Returns the raw returned data. To convert to the expected return value,
79      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
80      *
81      * Requirements:
82      *
83      * - `target` must be a contract.
84      * - calling `target` with `data` must not revert.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
89         return functionCall(target, data, "Address: low-level call failed");
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
94      * `errorMessage` as a fallback revert reason when `target` reverts.
95      *
96      * _Available since v3.1._
97      */
98     function functionCall(
99         address target,
100         bytes memory data,
101         string memory errorMessage
102     ) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, 0, errorMessage);
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
108      * but also transferring `value` wei to `target`.
109      *
110      * Requirements:
111      *
112      * - the calling contract must have an ETH balance of at least `value`.
113      * - the called Solidity function must be `payable`.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(
118         address target,
119         bytes memory data,
120         uint256 value
121     ) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
127      * with `errorMessage` as a fallback revert reason when `target` reverts.
128      *
129      * _Available since v3.1._
130      */
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value,
135         string memory errorMessage
136     ) internal returns (bytes memory) {
137         require(address(this).balance >= value, "Address: insufficient balance for call");
138         require(isContract(target), "Address: call to non-contract");
139 
140         (bool success, bytes memory returndata) = target.call{value: value}(data);
141         return verifyCallResult(success, returndata, errorMessage);
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
146      * but performing a static call.
147      *
148      * _Available since v3.3._
149      */
150     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
151         return functionStaticCall(target, data, "Address: low-level static call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
156      * but performing a static call.
157      *
158      * _Available since v3.3._
159      */
160     function functionStaticCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal view returns (bytes memory) {
165         require(isContract(target), "Address: static call to non-contract");
166 
167         (bool success, bytes memory returndata) = target.staticcall(data);
168         return verifyCallResult(success, returndata, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but performing a delegate call.
174      *
175      * _Available since v3.4._
176      */
177     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
178         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
183      * but performing a delegate call.
184      *
185      * _Available since v3.4._
186      */
187     function functionDelegateCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal returns (bytes memory) {
192         require(isContract(target), "Address: delegate call to non-contract");
193 
194         (bool success, bytes memory returndata) = target.delegatecall(data);
195         return verifyCallResult(success, returndata, errorMessage);
196     }
197 
198     /**
199      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
200      * revert reason using the provided one.
201      *
202      * _Available since v4.3._
203      */
204     function verifyCallResult(
205         bool success,
206         bytes memory returndata,
207         string memory errorMessage
208     ) internal pure returns (bytes memory) {
209         if (success) {
210             return returndata;
211         } else {
212             // Look for revert reason and bubble it up if present
213             if (returndata.length > 0) {
214                 // The easiest way to bubble the revert reason is using memory via assembly
215 
216                 assembly {
217                     let returndata_size := mload(returndata)
218                     revert(add(32, returndata), returndata_size)
219                 }
220             } else {
221                 revert(errorMessage);
222             }
223         }
224     }
225 }
226 
227 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
228 
229 
230 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @title ERC721 token receiver interface
236  * @dev Interface for any contract that wants to support safeTransfers
237  * from ERC721 asset contracts.
238  */
239 interface IERC721Receiver {
240     /**
241      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
242      * by `operator` from `from`, this function is called.
243      *
244      * It must return its Solidity selector to confirm the token transfer.
245      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
246      *
247      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
248      */
249     function onERC721Received(
250         address operator,
251         address from,
252         uint256 tokenId,
253         bytes calldata data
254     ) external returns (bytes4);
255 }
256 
257 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
258 
259 
260 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 /**
265  * @dev Interface of the ERC165 standard, as defined in the
266  * https://eips.ethereum.org/EIPS/eip-165[EIP].
267  *
268  * Implementers can declare support of contract interfaces, which can then be
269  * queried by others ({ERC165Checker}).
270  *
271  * For an implementation, see {ERC165}.
272  */
273 interface IERC165 {
274     /**
275      * @dev Returns true if this contract implements the interface defined by
276      * `interfaceId`. See the corresponding
277      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
278      * to learn more about how these ids are created.
279      *
280      * This function call must use less than 30 000 gas.
281      */
282     function supportsInterface(bytes4 interfaceId) external view returns (bool);
283 }
284 
285 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
286 
287 
288 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
289 
290 pragma solidity ^0.8.0;
291 
292 
293 /**
294  * @dev Implementation of the {IERC165} interface.
295  *
296  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
297  * for the additional interface id that will be supported. For example:
298  *
299  * ```solidity
300  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
301  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
302  * }
303  * ```
304  *
305  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
306  */
307 abstract contract ERC165 is IERC165 {
308     /**
309      * @dev See {IERC165-supportsInterface}.
310      */
311     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
312         return interfaceId == type(IERC165).interfaceId;
313     }
314 }
315 
316 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
317 
318 
319 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 
324 /**
325  * @dev Required interface of an ERC721 compliant contract.
326  */
327 interface IERC721 is IERC165 {
328     /**
329      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
330      */
331     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
332 
333     /**
334      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
335      */
336     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
337 
338     /**
339      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
340      */
341     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
342 
343     /**
344      * @dev Returns the number of tokens in ``owner``'s account.
345      */
346     function balanceOf(address owner) external view returns (uint256 balance);
347 
348     /**
349      * @dev Returns the owner of the `tokenId` token.
350      *
351      * Requirements:
352      *
353      * - `tokenId` must exist.
354      */
355     function ownerOf(uint256 tokenId) external view returns (address owner);
356 
357     /**
358      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
359      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
360      *
361      * Requirements:
362      *
363      * - `from` cannot be the zero address.
364      * - `to` cannot be the zero address.
365      * - `tokenId` token must exist and be owned by `from`.
366      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
367      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
368      *
369      * Emits a {Transfer} event.
370      */
371     function safeTransferFrom(
372         address from,
373         address to,
374         uint256 tokenId
375     ) external;
376 
377     /**
378      * @dev Transfers `tokenId` token from `from` to `to`.
379      *
380      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
381      *
382      * Requirements:
383      *
384      * - `from` cannot be the zero address.
385      * - `to` cannot be the zero address.
386      * - `tokenId` token must be owned by `from`.
387      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
388      *
389      * Emits a {Transfer} event.
390      */
391     function transferFrom(
392         address from,
393         address to,
394         uint256 tokenId
395     ) external;
396 
397     /**
398      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
399      * The approval is cleared when the token is transferred.
400      *
401      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
402      *
403      * Requirements:
404      *
405      * - The caller must own the token or be an approved operator.
406      * - `tokenId` must exist.
407      *
408      * Emits an {Approval} event.
409      */
410     function approve(address to, uint256 tokenId) external;
411 
412     /**
413      * @dev Returns the account approved for `tokenId` token.
414      *
415      * Requirements:
416      *
417      * - `tokenId` must exist.
418      */
419     function getApproved(uint256 tokenId) external view returns (address operator);
420 
421     /**
422      * @dev Approve or remove `operator` as an operator for the caller.
423      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
424      *
425      * Requirements:
426      *
427      * - The `operator` cannot be the caller.
428      *
429      * Emits an {ApprovalForAll} event.
430      */
431     function setApprovalForAll(address operator, bool _approved) external;
432 
433     /**
434      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
435      *
436      * See {setApprovalForAll}
437      */
438     function isApprovedForAll(address owner, address operator) external view returns (bool);
439 
440     /**
441      * @dev Safely transfers `tokenId` token from `from` to `to`.
442      *
443      * Requirements:
444      *
445      * - `from` cannot be the zero address.
446      * - `to` cannot be the zero address.
447      * - `tokenId` token must exist and be owned by `from`.
448      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
449      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
450      *
451      * Emits a {Transfer} event.
452      */
453     function safeTransferFrom(
454         address from,
455         address to,
456         uint256 tokenId,
457         bytes calldata data
458     ) external;
459 }
460 
461 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
462 
463 
464 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 
469 /**
470  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
471  * @dev See https://eips.ethereum.org/EIPS/eip-721
472  */
473 interface IERC721Enumerable is IERC721 {
474     /**
475      * @dev Returns the total amount of tokens stored by the contract.
476      */
477     function totalSupply() external view returns (uint256);
478 
479     /**
480      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
481      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
482      */
483     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
484 
485     /**
486      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
487      * Use along with {totalSupply} to enumerate all tokens.
488      */
489     function tokenByIndex(uint256 index) external view returns (uint256);
490 }
491 
492 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
493 
494 
495 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 
500 /**
501  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
502  * @dev See https://eips.ethereum.org/EIPS/eip-721
503  */
504 interface IERC721Metadata is IERC721 {
505     /**
506      * @dev Returns the token collection name.
507      */
508     function name() external view returns (string memory);
509 
510     /**
511      * @dev Returns the token collection symbol.
512      */
513     function symbol() external view returns (string memory);
514 
515     /**
516      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
517      */
518     function tokenURI(uint256 tokenId) external view returns (string memory);
519 }
520 
521 // File: @openzeppelin/contracts/utils/Strings.sol
522 
523 
524 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 /**
529  * @dev String operations.
530  */
531 library Strings {
532     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
533 
534     /**
535      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
536      */
537     function toString(uint256 value) internal pure returns (string memory) {
538         // Inspired by OraclizeAPI's implementation - MIT licence
539         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
540 
541         if (value == 0) {
542             return "0";
543         }
544         uint256 temp = value;
545         uint256 digits;
546         while (temp != 0) {
547             digits++;
548             temp /= 10;
549         }
550         bytes memory buffer = new bytes(digits);
551         while (value != 0) {
552             digits -= 1;
553             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
554             value /= 10;
555         }
556         return string(buffer);
557     }
558 
559     /**
560      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
561      */
562     function toHexString(uint256 value) internal pure returns (string memory) {
563         if (value == 0) {
564             return "0x00";
565         }
566         uint256 temp = value;
567         uint256 length = 0;
568         while (temp != 0) {
569             length++;
570             temp >>= 8;
571         }
572         return toHexString(value, length);
573     }
574 
575     /**
576      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
577      */
578     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
579         bytes memory buffer = new bytes(2 * length + 2);
580         buffer[0] = "0";
581         buffer[1] = "x";
582         for (uint256 i = 2 * length + 1; i > 1; --i) {
583             buffer[i] = _HEX_SYMBOLS[value & 0xf];
584             value >>= 4;
585         }
586         require(value == 0, "Strings: hex length insufficient");
587         return string(buffer);
588     }
589 }
590 
591 // File: @openzeppelin/contracts/utils/Context.sol
592 
593 
594 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 /**
599  * @dev Provides information about the current execution context, including the
600  * sender of the transaction and its data. While these are generally available
601  * via msg.sender and msg.data, they should not be accessed in such a direct
602  * manner, since when dealing with meta-transactions the account sending and
603  * paying for execution may not be the actual sender (as far as an application
604  * is concerned).
605  *
606  * This contract is only required for intermediate, library-like contracts.
607  */
608 abstract contract Context {
609     function _msgSender() internal view virtual returns (address) {
610         return msg.sender;
611     }
612 
613     function _msgData() internal view virtual returns (bytes calldata) {
614         return msg.data;
615     }
616 }
617 
618 // File: contracts/ERC721A2.sol
619 
620 
621 // Creator: Chiru Labs
622 
623 pragma solidity ^0.8.0;
624 
625 
626 
627 
628 
629 
630 
631 
632 
633 /**
634  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
635  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
636  *
637  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
638  *
639  * Does not support burning tokens to address(0).
640  *
641  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
642  */
643 contract ERC721A is
644     Context,
645     ERC165,
646     IERC721,
647     IERC721Metadata,
648     IERC721Enumerable
649 {
650     using Address for address;
651     using Strings for uint256;
652 
653     struct TokenOwnership {
654         address addr;
655         uint64 startTimestamp;
656     }
657 
658     struct AddressData {
659         uint128 balance;
660         uint128 numberMinted;
661     }
662 
663     uint256 internal currentIndex;
664 
665     // Token name
666     string private _name;
667 
668     // Token symbol
669     string private _symbol;
670 
671     // Mapping from token ID to ownership details
672     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
673     mapping(uint256 => TokenOwnership) internal _ownerships;
674 
675     // Mapping owner address to address data
676     mapping(address => AddressData) private _addressData;
677 
678     // Mapping from token ID to approved address
679     mapping(uint256 => address) private _tokenApprovals;
680 
681     // Mapping from owner to operator approvals
682     mapping(address => mapping(address => bool)) private _operatorApprovals;
683 
684     constructor(string memory name_, string memory symbol_) {
685         _name = name_;
686         _symbol = symbol_;
687     }
688 
689     /**
690      * @dev See {IERC721Enumerable-totalSupply}.
691      */
692     function totalSupply() public view override returns (uint256) {
693         return currentIndex;
694     }
695 
696     /**
697      * @dev See {IERC721Enumerable-tokenByIndex}.
698      */
699     function tokenByIndex(uint256 index)
700         public
701         view
702         override
703         returns (uint256)
704     {
705         require(index < totalSupply(), "ERC721A: global index out of bounds");
706         return index;
707     }
708 
709     /**
710      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
711      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
712      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
713      */
714     function tokenOfOwnerByIndex(address owner, uint256 index)
715         public
716         view
717         override
718         returns (uint256)
719     {
720         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
721         uint256 numMintedSoFar = totalSupply();
722         uint256 tokenIdsIdx;
723         address currOwnershipAddr;
724 
725         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
726         unchecked {
727             for (uint256 i; i < numMintedSoFar; i++) {
728                 TokenOwnership memory ownership = _ownerships[i];
729                 if (ownership.addr != address(0)) {
730                     currOwnershipAddr = ownership.addr;
731                 }
732                 if (currOwnershipAddr == owner) {
733                     if (tokenIdsIdx == index) {
734                         return i;
735                     }
736                     tokenIdsIdx++;
737                 }
738             }
739         }
740 
741         revert("ERC721A: unable to get token of owner by index");
742     }
743 
744     /**
745      * @dev See {IERC165-supportsInterface}.
746      */
747     function supportsInterface(bytes4 interfaceId)
748         public
749         view
750         virtual
751         override(ERC165, IERC165)
752         returns (bool)
753     {
754         return
755             interfaceId == type(IERC721).interfaceId ||
756             interfaceId == type(IERC721Metadata).interfaceId ||
757             interfaceId == type(IERC721Enumerable).interfaceId ||
758             super.supportsInterface(interfaceId);
759     }
760 
761     /**
762      * @dev See {IERC721-balanceOf}.
763      */
764     function balanceOf(address owner) public view override returns (uint256) {
765         require(
766             owner != address(0),
767             "ERC721A: balance query for the zero address"
768         );
769         return uint256(_addressData[owner].balance);
770     }
771 
772     function _numberMinted(address owner) internal view returns (uint256) {
773         require(
774             owner != address(0),
775             "ERC721A: number minted query for the zero address"
776         );
777         return uint256(_addressData[owner].numberMinted);
778     }
779 
780     /**
781      * Gas spent here starts off proportional to the maximum mint batch size.
782      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
783      */
784     function ownershipOf(uint256 tokenId)
785         internal
786         view
787         returns (TokenOwnership memory)
788     {
789         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
790 
791         unchecked {
792             for (uint256 curr = tokenId; curr >= 0; curr--) {
793                 TokenOwnership memory ownership = _ownerships[curr];
794                 if (ownership.addr != address(0)) {
795                     return ownership;
796                 }
797             }
798         }
799 
800         revert("ERC721A: unable to determine the owner of token");
801     }
802 
803     /**
804      * @dev See {IERC721-ownerOf}.
805      */
806     function ownerOf(uint256 tokenId) public view override returns (address) {
807         return ownershipOf(tokenId).addr;
808     }
809 
810     /**
811      * @dev See {IERC721Metadata-name}.
812      */
813     function name() public view virtual override returns (string memory) {
814         return _name;
815     }
816 
817     /**
818      * @dev See {IERC721Metadata-symbol}.
819      */
820     function symbol() public view virtual override returns (string memory) {
821         return _symbol;
822     }
823 
824     /**
825      * @dev See {IERC721Metadata-tokenURI}.
826      */
827     function tokenURI(uint256 tokenId)
828         public
829         view
830         virtual
831         override
832         returns (string memory)
833     {
834         require(
835             _exists(tokenId),
836             "ERC721Metadata: URI query for nonexistent token"
837         );
838 
839         string memory baseURI = _baseURI();
840         return
841             bytes(baseURI).length != 0
842                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
843                 : "";
844     }
845 
846     /**
847      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
848      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
849      * by default, can be overriden in child contracts.
850      */
851     function _baseURI() internal view virtual returns (string memory) {
852         return "";
853     }
854 
855     /**
856      * @dev See {IERC721-approve}.
857      */
858     function approve(address to, uint256 tokenId) public override {
859         address owner = ERC721A.ownerOf(tokenId);
860         require(to != owner, "ERC721A: approval to current owner");
861 
862         require(
863             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
864             "ERC721A: approve caller is not owner nor approved for all"
865         );
866 
867         _approve(to, tokenId, owner);
868     }
869 
870     /**
871      * @dev See {IERC721-getApproved}.
872      */
873     function getApproved(uint256 tokenId)
874         public
875         view
876         override
877         returns (address)
878     {
879         require(
880             _exists(tokenId),
881             "ERC721A: approved query for nonexistent token"
882         );
883 
884         return _tokenApprovals[tokenId];
885     }
886 
887     /**
888      * @dev See {IERC721-setApprovalForAll}.
889      */
890     function setApprovalForAll(address operator, bool approved)
891         public
892         override
893     {
894         require(operator != _msgSender(), "ERC721A: approve to caller");
895 
896         _operatorApprovals[_msgSender()][operator] = approved;
897         emit ApprovalForAll(_msgSender(), operator, approved);
898     }
899 
900     /**
901      * @dev See {IERC721-isApprovedForAll}.
902      */
903     function isApprovedForAll(address owner, address operator)
904         public
905         view
906         virtual
907         override
908         returns (bool)
909     {
910         return _operatorApprovals[owner][operator];
911     }
912 
913     /**
914      * @dev See {IERC721-transferFrom}.
915      */
916     function transferFrom(
917         address from,
918         address to,
919         uint256 tokenId
920     ) public virtual override {
921         _transfer(from, to, tokenId);
922     }
923 
924     /**
925      * @dev See {IERC721-safeTransferFrom}.
926      */
927     function safeTransferFrom(
928         address from,
929         address to,
930         uint256 tokenId
931     ) public virtual override {
932         safeTransferFrom(from, to, tokenId, "");
933     }
934 
935     /**
936      * @dev See {IERC721-safeTransferFrom}.
937      */
938     function safeTransferFrom(
939         address from,
940         address to,
941         uint256 tokenId,
942         bytes memory _data
943     ) public override {
944         _transfer(from, to, tokenId);
945         require(
946             _checkOnERC721Received(from, to, tokenId, _data),
947             "ERC721A: transfer to non ERC721Receiver implementer"
948         );
949     }
950 
951     /**
952      * @dev Returns whether `tokenId` exists.
953      *
954      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
955      *
956      * Tokens start existing when they are minted (`_mint`),
957      */
958     function _exists(uint256 tokenId) internal view returns (bool) {
959         return tokenId < currentIndex;
960     }
961 
962     function _safeMint(address to, uint256 quantity) internal {
963         _safeMint(to, quantity, "");
964     }
965 
966     /**
967      * @dev Safely mints `quantity` tokens and transfers them to `to`.
968      *
969      * Requirements:
970      *
971      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
972      * - `quantity` must be greater than 0.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _safeMint(
977         address to,
978         uint256 quantity,
979         bytes memory _data
980     ) internal {
981         _mint(to, quantity, _data, true);
982     }
983 
984     /**
985      * @dev Mints `quantity` tokens and transfers them to `to`.
986      *
987      * Requirements:
988      *
989      * - `to` cannot be the zero address.
990      * - `quantity` must be greater than 0.
991      *
992      * Emits a {Transfer} event.
993      */
994     function _mint(
995         address to,
996         uint256 quantity,
997         bytes memory _data,
998         bool safe
999     ) internal {
1000         uint256 startTokenId = currentIndex;
1001         require(to != address(0), "ERC721A: mint to the zero address");
1002         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1003 
1004         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1005 
1006         // Overflows are incredibly unrealistic.
1007         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1008         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1009         unchecked {
1010             _addressData[to].balance += uint128(quantity);
1011             _addressData[to].numberMinted += uint128(quantity);
1012 
1013             _ownerships[startTokenId].addr = to;
1014             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1015 
1016             uint256 updatedIndex = startTokenId;
1017 
1018             for (uint256 i; i < quantity; i++) {
1019                 emit Transfer(address(0), to, updatedIndex);
1020                 if (safe) {
1021                     require(
1022                         _checkOnERC721Received(
1023                             address(0),
1024                             to,
1025                             updatedIndex,
1026                             _data
1027                         ),
1028                         "ERC721A: transfer to non ERC721Receiver implementer"
1029                     );
1030                 }
1031 
1032                 updatedIndex++;
1033             }
1034 
1035             currentIndex = updatedIndex;
1036         }
1037 
1038         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1039     }
1040 
1041     /**
1042      * @dev Transfers `tokenId` from `from` to `to`.
1043      *
1044      * Requirements:
1045      *
1046      * - `to` cannot be the zero address.
1047      * - `tokenId` token must be owned by `from`.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _transfer(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) private {
1056         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1057 
1058         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1059             getApproved(tokenId) == _msgSender() ||
1060             isApprovedForAll(prevOwnership.addr, _msgSender()));
1061 
1062         require(
1063             isApprovedOrOwner,
1064             "ERC721A: transfer caller is not owner nor approved"
1065         );
1066 
1067         require(
1068             prevOwnership.addr == from,
1069             "ERC721A: transfer from incorrect owner"
1070         );
1071         require(to != address(0), "ERC721A: transfer to the zero address");
1072 
1073         _beforeTokenTransfers(from, to, tokenId, 1);
1074 
1075         // Clear approvals from the previous owner
1076         _approve(address(0), tokenId, prevOwnership.addr);
1077 
1078         // Underflow of the sender's balance is impossible because we check for
1079         // ownership above and the recipient's balance can't realistically overflow.
1080         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1081         unchecked {
1082             _addressData[from].balance -= 1;
1083             _addressData[to].balance += 1;
1084 
1085             _ownerships[tokenId].addr = to;
1086             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1087 
1088             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1089             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1090             uint256 nextTokenId = tokenId + 1;
1091             if (_ownerships[nextTokenId].addr == address(0)) {
1092                 if (_exists(nextTokenId)) {
1093                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1094                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1095                         .startTimestamp;
1096                 }
1097             }
1098         }
1099 
1100         emit Transfer(from, to, tokenId);
1101         _afterTokenTransfers(from, to, tokenId, 1);
1102     }
1103 
1104     /**
1105      * @dev Approve `to` to operate on `tokenId`
1106      *
1107      * Emits a {Approval} event.
1108      */
1109     function _approve(
1110         address to,
1111         uint256 tokenId,
1112         address owner
1113     ) private {
1114         _tokenApprovals[tokenId] = to;
1115         emit Approval(owner, to, tokenId);
1116     }
1117 
1118     /**
1119      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1120      * The call is not executed if the target address is not a contract.
1121      *
1122      * @param from address representing the previous owner of the given token ID
1123      * @param to target address that will receive the tokens
1124      * @param tokenId uint256 ID of the token to be transferred
1125      * @param _data bytes optional data to send along with the call
1126      * @return bool whether the call correctly returned the expected magic value
1127      */
1128     function _checkOnERC721Received(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes memory _data
1133     ) private returns (bool) {
1134         if (to.isContract()) {
1135             try
1136                 IERC721Receiver(to).onERC721Received(
1137                     _msgSender(),
1138                     from,
1139                     tokenId,
1140                     _data
1141                 )
1142             returns (bytes4 retval) {
1143                 return retval == IERC721Receiver(to).onERC721Received.selector;
1144             } catch (bytes memory reason) {
1145                 if (reason.length == 0) {
1146                     revert(
1147                         "ERC721A: transfer to non ERC721Receiver implementer"
1148                     );
1149                 } else {
1150                     assembly {
1151                         revert(add(32, reason), mload(reason))
1152                     }
1153                 }
1154             }
1155         } else {
1156             return true;
1157         }
1158     }
1159 
1160     /**
1161      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1162      *
1163      * startTokenId - the first token id to be transferred
1164      * quantity - the amount to be transferred
1165      *
1166      * Calling conditions:
1167      *
1168      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1169      * transferred to `to`.
1170      * - When `from` is zero, `tokenId` will be minted for `to`.
1171      */
1172     function _beforeTokenTransfers(
1173         address from,
1174         address to,
1175         uint256 startTokenId,
1176         uint256 quantity
1177     ) internal virtual {}
1178 
1179     /**
1180      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1181      * minting.
1182      *
1183      * startTokenId - the first token id to be transferred
1184      * quantity - the amount to be transferred
1185      *
1186      * Calling conditions:
1187      *
1188      * - when `from` and `to` are both non-zero.
1189      * - `from` and `to` are never both zero.
1190      */
1191     function _afterTokenTransfers(
1192         address from,
1193         address to,
1194         uint256 startTokenId,
1195         uint256 quantity
1196     ) internal virtual {}
1197 }
1198 
1199 // File: @openzeppelin/contracts/access/Ownable.sol
1200 
1201 
1202 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1203 
1204 pragma solidity ^0.8.0;
1205 
1206 
1207 /**
1208  * @dev Contract module which provides a basic access control mechanism, where
1209  * there is an account (an owner) that can be granted exclusive access to
1210  * specific functions.
1211  *
1212  * By default, the owner account will be the one that deploys the contract. This
1213  * can later be changed with {transferOwnership}.
1214  *
1215  * This module is used through inheritance. It will make available the modifier
1216  * `onlyOwner`, which can be applied to your functions to restrict their use to
1217  * the owner.
1218  */
1219 abstract contract Ownable is Context {
1220     address private _owner;
1221 
1222     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1223 
1224     /**
1225      * @dev Initializes the contract setting the deployer as the initial owner.
1226      */
1227     constructor() {
1228         _transferOwnership(_msgSender());
1229     }
1230 
1231     /**
1232      * @dev Returns the address of the current owner.
1233      */
1234     function owner() public view virtual returns (address) {
1235         return _owner;
1236     }
1237 
1238     /**
1239      * @dev Throws if called by any account other than the owner.
1240      */
1241     modifier onlyOwner() {
1242         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1243         _;
1244     }
1245 
1246     /**
1247      * @dev Leaves the contract without owner. It will not be possible to call
1248      * `onlyOwner` functions anymore. Can only be called by the current owner.
1249      *
1250      * NOTE: Renouncing ownership will leave the contract without an owner,
1251      * thereby removing any functionality that is only available to the owner.
1252      */
1253     function renounceOwnership() public virtual onlyOwner {
1254         _transferOwnership(address(0));
1255     }
1256 
1257     /**
1258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1259      * Can only be called by the current owner.
1260      */
1261     function transferOwnership(address newOwner) public virtual onlyOwner {
1262         require(newOwner != address(0), "Ownable: new owner is the zero address");
1263         _transferOwnership(newOwner);
1264     }
1265 
1266     /**
1267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1268      * Internal function without access restriction.
1269      */
1270     function _transferOwnership(address newOwner) internal virtual {
1271         address oldOwner = _owner;
1272         _owner = newOwner;
1273         emit OwnershipTransferred(oldOwner, newOwner);
1274     }
1275 }
1276 
1277 // File: contracts/Planktoons/Planktoons.sol
1278 
1279 
1280 pragma solidity ^0.8.0;
1281 
1282 
1283 
1284 
1285 contract Planktoons is ERC721A, Ownable {
1286     uint256 public constant PRESALE_SUPPLY = 4066;
1287     uint256 public constant RESERVED_SUPPLY = 33;
1288     uint256 public constant FREE_SUPPLY = 33;
1289     uint256 public constant MAX_SUPPLY = 4444;
1290 
1291     uint256 public PRICE = 0.0444 ether;
1292 
1293     uint256 public constant PRESALE_LIMIT = 2;
1294     uint256 public constant MINT_LIMIT = 4;
1295 
1296     bool public isPublicSaleActive = false;
1297     bool public isPreSaleActive = false;
1298     bool _revealed = false;
1299 
1300     string private baseURI = "";
1301     bytes32 presaleRoot;
1302     bytes32 freemintRoot;
1303 
1304     address public constant ADDRESS_1 =
1305         0x49B65ec0Be783CA6BBB7eD65dCB2C0a617Ae423F; //A+T
1306     address public constant ADDRESS_2 =
1307         0x5B6785402F3321E43BA4E624afb9aC80A902bd41; //R+C
1308     address public constant ADDRESS_3 =
1309         0x66691AD9065EF35AB1c70A9C99fE1d4Da9C9451A; //M
1310 
1311     mapping(address => bool) public freeMints;
1312     uint256 public freeMintCount = 0;
1313     uint256 public presaleMintCount = 0;
1314 
1315     constructor() ERC721A("Planktoons", "PLANKTOONS") {}
1316 
1317     //Essential
1318     function mint(uint256 numberOfTokens) external payable {
1319         require(msg.sender == tx.origin, "No contracts allowed");
1320         require(
1321             numberOfTokens + totalSupply() <= MAX_SUPPLY,
1322             "Not enough supply"
1323         );
1324         require(
1325             numberMinted(msg.sender) + numberOfTokens <= MINT_LIMIT,
1326             "Exceeding max mint limit"
1327         );
1328         require(isPublicSaleActive, "Public sale not active");
1329         require(msg.value >= PRICE * numberOfTokens, "Not enough ETH");
1330         _safeMint(msg.sender, numberOfTokens);
1331     }
1332 
1333     function presaleMint(uint256 numberOfTokens, bytes32[] memory proof)
1334         external
1335         payable
1336     {
1337         require(msg.sender == tx.origin, "No contracts allowed");
1338         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1339         require(
1340             verify(leaf, proof, presaleRoot),
1341             "Address is not in presale list"
1342         );
1343         require(
1344             numberOfTokens + totalSupply() <= MAX_SUPPLY,
1345             "Not enough supply"
1346         );
1347         require(
1348             numberOfTokens + presaleMintCount <= PRESALE_SUPPLY,
1349             "Not enough presale supply"
1350         );
1351         if (freeMints[msg.sender]) {
1352             require(
1353                 numberMinted(msg.sender) + numberOfTokens <= PRESALE_LIMIT + 1,
1354                 "Exceeding max presale limit"
1355             );
1356         } else {
1357             require(
1358                 numberMinted(msg.sender) + numberOfTokens <= PRESALE_LIMIT,
1359                 "Exceeding max presale limit"
1360             );
1361         }
1362         require(msg.value >= PRICE * numberOfTokens, "Not enough ETH");
1363         require(isPreSaleActive, "Presale not active");
1364         presaleMintCount += numberOfTokens;
1365         _safeMint(msg.sender, numberOfTokens);
1366     }
1367 
1368     function freeMint(bytes32[] memory proof) external {
1369         require(msg.sender == tx.origin, "No contracts allowed");
1370         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1371         require(
1372             verify(leaf, proof, freemintRoot),
1373             "Address is not in free sale list"
1374         );
1375         require(1 + totalSupply() <= MAX_SUPPLY, "Not enough supply");
1376         require(1 + freeMintCount <= FREE_SUPPLY, "Not enough free supply");
1377         require(
1378             !freeMints[msg.sender],
1379             "Address already minted their free mint"
1380         );
1381         require(isPreSaleActive, "Presale not active");
1382         freeMints[msg.sender] = true;
1383         freeMintCount += 1;
1384         _safeMint(msg.sender, 1);
1385     }
1386 
1387     function devMint(uint256 numberOfTokens) external onlyOwner {
1388         require(
1389             numberOfTokens + totalSupply() <= MAX_SUPPLY,
1390             "Not enough supply"
1391         );
1392         require(
1393             numberOfTokens + numberMinted((msg.sender)) <= RESERVED_SUPPLY,
1394             "Not enough reserved supply"
1395         );
1396         _safeMint(msg.sender, numberOfTokens);
1397     }
1398 
1399     //Essential
1400     function setBaseURI(string calldata URI) external onlyOwner {
1401         baseURI = URI;
1402     }
1403 
1404     function reveal(bool revealed, string calldata _baseURI) public onlyOwner {
1405         _revealed = revealed;
1406         baseURI = _baseURI;
1407     }
1408 
1409     //Essential
1410     function setPublicSaleStatus() external onlyOwner {
1411         isPublicSaleActive = !isPublicSaleActive;
1412     }
1413 
1414     function setPreSaleStatus() external onlyOwner {
1415         isPreSaleActive = !isPreSaleActive;
1416     }
1417 
1418     //Essential
1419 
1420     function withdraw() external onlyOwner {
1421         uint256 balance = address(this).balance;
1422         payable(ADDRESS_1).transfer((balance * 4800) / 10000);
1423         payable(ADDRESS_2).transfer((balance * 3050) / 10000);
1424         payable(ADDRESS_3).transfer((balance * 400) / 10000);
1425         payable(msg.sender).transfer(address(this).balance);
1426     }
1427 
1428     function tokenURI(uint256 tokenId)
1429         public
1430         view
1431         virtual
1432         override
1433         returns (string memory)
1434     {
1435         if (_revealed) {
1436             return string(abi.encodePacked(baseURI, Strings.toString(tokenId)));
1437         } else {
1438             return string(abi.encodePacked(baseURI));
1439         }
1440     }
1441 
1442     function tokensOfOwner(address owner)
1443         public
1444         view
1445         returns (uint256[] memory)
1446     {
1447         uint256 tokenCount = balanceOf(owner);
1448         uint256[] memory tokenIds = new uint256[](tokenCount);
1449         for (uint256 i = 0; i < tokenCount; i++) {
1450             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
1451         }
1452         return tokenIds;
1453     }
1454 
1455     function numberMinted(address owner) public view returns (uint256) {
1456         return _numberMinted(owner);
1457     }
1458 
1459     function verify(
1460         bytes32 leaf,
1461         bytes32[] memory proof,
1462         bytes32 root
1463     ) public pure returns (bool) {
1464         bytes32 computedHash = leaf;
1465 
1466         for (uint256 i = 0; i < proof.length; i++) {
1467             bytes32 proofElement = proof[i];
1468 
1469             if (computedHash <= proofElement) {
1470                 computedHash = keccak256(
1471                     abi.encodePacked(computedHash, proofElement)
1472                 );
1473             } else {
1474                 computedHash = keccak256(
1475                     abi.encodePacked(proofElement, computedHash)
1476                 );
1477             }
1478         }
1479         return computedHash == root;
1480     }
1481 
1482     function setPreSaleRoot(bytes32 _presaleRoot) external onlyOwner {
1483         presaleRoot = _presaleRoot;
1484     }
1485 
1486     function setFreeMintRoot(bytes32 _freemintRoot) external onlyOwner {
1487         freemintRoot = _freemintRoot;
1488     }
1489 
1490     function isPresaleListed(bytes32 leaf, bytes32[] memory proof)
1491         external
1492         view
1493         returns (bool)
1494     {
1495         return verify(leaf, proof, presaleRoot);
1496     }
1497 
1498     function isFreeListed(bytes32 leaf, bytes32[] memory proof)
1499         external
1500         view
1501         returns (bool)
1502     {
1503         return verify(leaf, proof, freemintRoot);
1504     }
1505 }