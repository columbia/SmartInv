1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Address.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
6 
7 pragma solidity ^0.8.0;
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
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         assembly {
37             size := extcodesize(account)
38         }
39         return size > 0;
40     }
41 
42     /**
43      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
44      * `recipient`, forwarding all available gas and reverting on errors.
45      *
46      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
47      * of certain opcodes, possibly making contracts go over the 2300 gas limit
48      * imposed by `transfer`, making them unable to receive funds via
49      * `transfer`. {sendValue} removes this limitation.
50      *
51      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
52      *
53      * IMPORTANT: because control is transferred to `recipient`, care must be
54      * taken to not create reentrancy vulnerabilities. Consider using
55      * {ReentrancyGuard} or the
56      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
57      */
58     function sendValue(address payable recipient, uint256 amount) internal {
59         require(address(this).balance >= amount, "Address: insufficient balance");
60 
61         (bool success, ) = recipient.call{value: amount}("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain `call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84         return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(
94         address target,
95         bytes memory data,
96         string memory errorMessage
97     ) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, 0, errorMessage);
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
103      * but also transferring `value` wei to `target`.
104      *
105      * Requirements:
106      *
107      * - the calling contract must have an ETH balance of at least `value`.
108      * - the called Solidity function must be `payable`.
109      *
110      * _Available since v3.1._
111      */
112     function functionCallWithValue(
113         address target,
114         bytes memory data,
115         uint256 value
116     ) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
122      * with `errorMessage` as a fallback revert reason when `target` reverts.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value,
130         string memory errorMessage
131     ) internal returns (bytes memory) {
132         require(address(this).balance >= value, "Address: insufficient balance for call");
133         require(isContract(target), "Address: call to non-contract");
134 
135         (bool success, bytes memory returndata) = target.call{value: value}(data);
136         return verifyCallResult(success, returndata, errorMessage);
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
141      * but performing a static call.
142      *
143      * _Available since v3.3._
144      */
145     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
146         return functionStaticCall(target, data, "Address: low-level static call failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(
156         address target,
157         bytes memory data,
158         string memory errorMessage
159     ) internal view returns (bytes memory) {
160         require(isContract(target), "Address: static call to non-contract");
161 
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return verifyCallResult(success, returndata, errorMessage);
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
168      * but performing a delegate call.
169      *
170      * _Available since v3.4._
171      */
172     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
178      * but performing a delegate call.
179      *
180      * _Available since v3.4._
181      */
182     function functionDelegateCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(isContract(target), "Address: delegate call to non-contract");
188 
189         (bool success, bytes memory returndata) = target.delegatecall(data);
190         return verifyCallResult(success, returndata, errorMessage);
191     }
192 
193     /**
194      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
195      * revert reason using the provided one.
196      *
197      * _Available since v4.3._
198      */
199     function verifyCallResult(
200         bool success,
201         bytes memory returndata,
202         string memory errorMessage
203     ) internal pure returns (bytes memory) {
204         if (success) {
205             return returndata;
206         } else {
207             // Look for revert reason and bubble it up if present
208             if (returndata.length > 0) {
209                 // The easiest way to bubble the revert reason is using memory via assembly
210 
211                 assembly {
212                     let returndata_size := mload(returndata)
213                     revert(add(32, returndata), returndata_size)
214                 }
215             } else {
216                 revert(errorMessage);
217             }
218         }
219     }
220 }
221 
222 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
223 
224 
225 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @title ERC721 token receiver interface
231  * @dev Interface for any contract that wants to support safeTransfers
232  * from ERC721 asset contracts.
233  */
234 interface IERC721Receiver {
235     /**
236      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
237      * by `operator` from `from`, this function is called.
238      *
239      * It must return its Solidity selector to confirm the token transfer.
240      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
241      *
242      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
243      */
244     function onERC721Received(
245         address operator,
246         address from,
247         uint256 tokenId,
248         bytes calldata data
249     ) external returns (bytes4);
250 }
251 
252 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
253 
254 
255 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
256 
257 pragma solidity ^0.8.0;
258 
259 /**
260  * @dev Interface of the ERC165 standard, as defined in the
261  * https://eips.ethereum.org/EIPS/eip-165[EIP].
262  *
263  * Implementers can declare support of contract interfaces, which can then be
264  * queried by others ({ERC165Checker}).
265  *
266  * For an implementation, see {ERC165}.
267  */
268 interface IERC165 {
269     /**
270      * @dev Returns true if this contract implements the interface defined by
271      * `interfaceId`. See the corresponding
272      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
273      * to learn more about how these ids are created.
274      *
275      * This function call must use less than 30 000 gas.
276      */
277     function supportsInterface(bytes4 interfaceId) external view returns (bool);
278 }
279 
280 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
281 
282 
283 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
284 
285 pragma solidity ^0.8.0;
286 
287 
288 /**
289  * @dev Implementation of the {IERC165} interface.
290  *
291  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
292  * for the additional interface id that will be supported. For example:
293  *
294  * ```solidity
295  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
296  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
297  * }
298  * ```
299  *
300  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
301  */
302 abstract contract ERC165 is IERC165 {
303     /**
304      * @dev See {IERC165-supportsInterface}.
305      */
306     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
307         return interfaceId == type(IERC165).interfaceId;
308     }
309 }
310 
311 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
312 
313 
314 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
315 
316 pragma solidity ^0.8.0;
317 
318 
319 /**
320  * @dev Required interface of an ERC721 compliant contract.
321  */
322 interface IERC721 is IERC165 {
323     /**
324      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
325      */
326     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
327 
328     /**
329      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
330      */
331     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
332 
333     /**
334      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
335      */
336     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
337 
338     /**
339      * @dev Returns the number of tokens in ``owner``'s account.
340      */
341     function balanceOf(address owner) external view returns (uint256 balance);
342 
343     /**
344      * @dev Returns the owner of the `tokenId` token.
345      *
346      * Requirements:
347      *
348      * - `tokenId` must exist.
349      */
350     function ownerOf(uint256 tokenId) external view returns (address owner);
351 
352     /**
353      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
354      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
355      *
356      * Requirements:
357      *
358      * - `from` cannot be the zero address.
359      * - `to` cannot be the zero address.
360      * - `tokenId` token must exist and be owned by `from`.
361      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
362      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
363      *
364      * Emits a {Transfer} event.
365      */
366     function safeTransferFrom(
367         address from,
368         address to,
369         uint256 tokenId
370     ) external;
371 
372     /**
373      * @dev Transfers `tokenId` token from `from` to `to`.
374      *
375      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
376      *
377      * Requirements:
378      *
379      * - `from` cannot be the zero address.
380      * - `to` cannot be the zero address.
381      * - `tokenId` token must be owned by `from`.
382      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
383      *
384      * Emits a {Transfer} event.
385      */
386     function transferFrom(
387         address from,
388         address to,
389         uint256 tokenId
390     ) external;
391 
392     /**
393      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
394      * The approval is cleared when the token is transferred.
395      *
396      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
397      *
398      * Requirements:
399      *
400      * - The caller must own the token or be an approved operator.
401      * - `tokenId` must exist.
402      *
403      * Emits an {Approval} event.
404      */
405     function approve(address to, uint256 tokenId) external;
406 
407     /**
408      * @dev Returns the account approved for `tokenId` token.
409      *
410      * Requirements:
411      *
412      * - `tokenId` must exist.
413      */
414     function getApproved(uint256 tokenId) external view returns (address operator);
415 
416     /**
417      * @dev Approve or remove `operator` as an operator for the caller.
418      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
419      *
420      * Requirements:
421      *
422      * - The `operator` cannot be the caller.
423      *
424      * Emits an {ApprovalForAll} event.
425      */
426     function setApprovalForAll(address operator, bool _approved) external;
427 
428     /**
429      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
430      *
431      * See {setApprovalForAll}
432      */
433     function isApprovedForAll(address owner, address operator) external view returns (bool);
434 
435     /**
436      * @dev Safely transfers `tokenId` token from `from` to `to`.
437      *
438      * Requirements:
439      *
440      * - `from` cannot be the zero address.
441      * - `to` cannot be the zero address.
442      * - `tokenId` token must exist and be owned by `from`.
443      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
444      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
445      *
446      * Emits a {Transfer} event.
447      */
448     function safeTransferFrom(
449         address from,
450         address to,
451         uint256 tokenId,
452         bytes calldata data
453     ) external;
454 }
455 
456 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 
464 /**
465  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
466  * @dev See https://eips.ethereum.org/EIPS/eip-721
467  */
468 interface IERC721Enumerable is IERC721 {
469     /**
470      * @dev Returns the total amount of tokens stored by the contract.
471      */
472     function totalSupply() external view returns (uint256);
473 
474     /**
475      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
476      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
477      */
478     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
479 
480     /**
481      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
482      * Use along with {totalSupply} to enumerate all tokens.
483      */
484     function tokenByIndex(uint256 index) external view returns (uint256);
485 }
486 
487 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
488 
489 
490 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
491 
492 pragma solidity ^0.8.0;
493 
494 
495 /**
496  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
497  * @dev See https://eips.ethereum.org/EIPS/eip-721
498  */
499 interface IERC721Metadata is IERC721 {
500     /**
501      * @dev Returns the token collection name.
502      */
503     function name() external view returns (string memory);
504 
505     /**
506      * @dev Returns the token collection symbol.
507      */
508     function symbol() external view returns (string memory);
509 
510     /**
511      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
512      */
513     function tokenURI(uint256 tokenId) external view returns (string memory);
514 }
515 
516 // File: @openzeppelin/contracts/utils/Strings.sol
517 
518 
519 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
520 
521 pragma solidity ^0.8.0;
522 
523 /**
524  * @dev String operations.
525  */
526 library Strings {
527     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
528 
529     /**
530      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
531      */
532     function toString(uint256 value) internal pure returns (string memory) {
533         // Inspired by OraclizeAPI's implementation - MIT licence
534         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
535 
536         if (value == 0) {
537             return "0";
538         }
539         uint256 temp = value;
540         uint256 digits;
541         while (temp != 0) {
542             digits++;
543             temp /= 10;
544         }
545         bytes memory buffer = new bytes(digits);
546         while (value != 0) {
547             digits -= 1;
548             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
549             value /= 10;
550         }
551         return string(buffer);
552     }
553 
554     /**
555      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
556      */
557     function toHexString(uint256 value) internal pure returns (string memory) {
558         if (value == 0) {
559             return "0x00";
560         }
561         uint256 temp = value;
562         uint256 length = 0;
563         while (temp != 0) {
564             length++;
565             temp >>= 8;
566         }
567         return toHexString(value, length);
568     }
569 
570     /**
571      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
572      */
573     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
574         bytes memory buffer = new bytes(2 * length + 2);
575         buffer[0] = "0";
576         buffer[1] = "x";
577         for (uint256 i = 2 * length + 1; i > 1; --i) {
578             buffer[i] = _HEX_SYMBOLS[value & 0xf];
579             value >>= 4;
580         }
581         require(value == 0, "Strings: hex length insufficient");
582         return string(buffer);
583     }
584 }
585 
586 // File: @openzeppelin/contracts/utils/Context.sol
587 
588 
589 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 /**
594  * @dev Provides information about the current execution context, including the
595  * sender of the transaction and its data. While these are generally available
596  * via msg.sender and msg.data, they should not be accessed in such a direct
597  * manner, since when dealing with meta-transactions the account sending and
598  * paying for execution may not be the actual sender (as far as an application
599  * is concerned).
600  *
601  * This contract is only required for intermediate, library-like contracts.
602  */
603 abstract contract Context {
604     function _msgSender() internal view virtual returns (address) {
605         return msg.sender;
606     }
607 
608     function _msgData() internal view virtual returns (bytes calldata) {
609         return msg.data;
610     }
611 }
612 
613 // File: contracts/ERC721A.sol
614 
615 
616 
617 pragma solidity ^0.8.0;
618 
619 
620 
621 
622 
623 
624 
625 
626 
627 /**
628  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
629  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
630  *
631  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
632  *
633  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
634  *
635  * Does not support burning tokens to address(0).
636  */
637 contract ERC721A is
638     Context,
639     ERC165,
640     IERC721,
641     IERC721Metadata,
642     IERC721Enumerable
643 {
644     using Address for address;
645     using Strings for uint256;
646 
647     struct TokenOwnership {
648         address addr;
649         uint64 startTimestamp;
650     }
651 
652     struct AddressData {
653         uint128 balance;
654         uint128 numberMinted;
655     }
656 
657     uint256 private currentIndex = 0;
658 
659     uint256 internal immutable collectionSize;
660     uint256 internal immutable maxBatchSize;
661 
662     // Token name
663     string private _name;
664 
665     // Token symbol
666     string private _symbol;
667 
668     // Mapping from token ID to ownership details
669     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
670     mapping(uint256 => TokenOwnership) private _ownerships;
671 
672     // Mapping owner address to address data
673     mapping(address => AddressData) private _addressData;
674 
675     // Mapping from token ID to approved address
676     mapping(uint256 => address) private _tokenApprovals;
677 
678     // Mapping from owner to operator approvals
679     mapping(address => mapping(address => bool)) private _operatorApprovals;
680 
681     /**
682      * @dev
683      * `maxBatchSize` refers to how much a minter can mint at a time.
684      * `collectionSize_` refers to how many tokens are in the collection.
685      */
686     constructor(
687         string memory name_,
688         string memory symbol_,
689         uint256 maxBatchSize_,
690         uint256 collectionSize_
691     ) {
692         require(
693             collectionSize_ > 0,
694             "ERC721A: collection must have a nonzero supply"
695         );
696         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
697         _name = name_;
698         _symbol = symbol_;
699         maxBatchSize = maxBatchSize_;
700         collectionSize = collectionSize_;
701     }
702 
703     /**
704      * @dev See {IERC721Enumerable-totalSupply}.
705      */
706     function totalSupply() public view override returns (uint256) {
707         return currentIndex;
708     }
709 
710     /**
711      * @dev See {IERC721Enumerable-tokenByIndex}.
712      */
713     function tokenByIndex(uint256 index)
714         public
715         view
716         override
717         returns (uint256)
718     {
719         require(index < totalSupply(), "ERC721A: global index out of bounds");
720         return index;
721     }
722 
723     /**
724      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
725      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
726      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
727      */
728     function tokenOfOwnerByIndex(address owner, uint256 index)
729         public
730         view
731         override
732         returns (uint256)
733     {
734         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
735         uint256 numMintedSoFar = totalSupply();
736         uint256 tokenIdsIdx = 0;
737         address currOwnershipAddr = address(0);
738         for (uint256 i = 0; i < numMintedSoFar; i++) {
739             TokenOwnership memory ownership = _ownerships[i];
740             if (ownership.addr != address(0)) {
741                 currOwnershipAddr = ownership.addr;
742             }
743             if (currOwnershipAddr == owner) {
744                 if (tokenIdsIdx == index) {
745                     return i;
746                 }
747                 tokenIdsIdx++;
748             }
749         }
750         revert("ERC721A: unable to get token of owner by index");
751     }
752 
753     /**
754      * @dev See {IERC165-supportsInterface}.
755      */
756     function supportsInterface(bytes4 interfaceId)
757         public
758         view
759         virtual
760         override(ERC165, IERC165)
761         returns (bool)
762     {
763         return
764             interfaceId == type(IERC721).interfaceId ||
765             interfaceId == type(IERC721Metadata).interfaceId ||
766             interfaceId == type(IERC721Enumerable).interfaceId ||
767             super.supportsInterface(interfaceId);
768     }
769 
770     /**
771      * @dev See {IERC721-balanceOf}.
772      */
773     function balanceOf(address owner) public view override returns (uint256) {
774         require(
775             owner != address(0),
776             "ERC721A: balance query for the zero address"
777         );
778         return uint256(_addressData[owner].balance);
779     }
780 
781     function _numberMinted(address owner) internal view returns (uint256) {
782         require(
783             owner != address(0),
784             "ERC721A: number minted query for the zero address"
785         );
786         return uint256(_addressData[owner].numberMinted);
787     }
788 
789     function ownershipOf(uint256 tokenId)
790         internal
791         view
792         returns (TokenOwnership memory)
793     {
794         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
795 
796         uint256 lowestTokenToCheck;
797         if (tokenId >= maxBatchSize) {
798             lowestTokenToCheck = tokenId - maxBatchSize + 1;
799         }
800 
801         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
802             TokenOwnership memory ownership = _ownerships[curr];
803             if (ownership.addr != address(0)) {
804                 return ownership;
805             }
806         }
807 
808         revert("ERC721A: unable to determine the owner of token");
809     }
810 
811     /**
812      * @dev See {IERC721-ownerOf}.
813      */
814     function ownerOf(uint256 tokenId) public view override returns (address) {
815         return ownershipOf(tokenId).addr;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-name}.
820      */
821     function name() public view virtual override returns (string memory) {
822         return _name;
823     }
824 
825     /**
826      * @dev See {IERC721Metadata-symbol}.
827      */
828     function symbol() public view virtual override returns (string memory) {
829         return _symbol;
830     }
831 
832     /**
833      * @dev See {IERC721Metadata-tokenURI}.
834      */
835     function tokenURI(uint256 tokenId)
836         public
837         view
838         virtual
839         override
840         returns (string memory)
841     {
842         require(
843             _exists(tokenId),
844             "ERC721Metadata: URI query for nonexistent token"
845         );
846 
847         string memory baseURI = _baseURI();
848         return
849             bytes(baseURI).length > 0
850                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
851                 : "";
852     }
853 
854     /**
855      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
856      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
857      * by default, can be overriden in child contracts.
858      */
859     function _baseURI() internal view virtual returns (string memory) {
860         return "";
861     }
862 
863     /**
864      * @dev See {IERC721-approve}.
865      */
866     function approve(address to, uint256 tokenId) public override {
867         address owner = ERC721A.ownerOf(tokenId);
868         require(to != owner, "ERC721A: approval to current owner");
869 
870         require(
871             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
872             "ERC721A: approve caller is not owner nor approved for all"
873         );
874 
875         _approve(to, tokenId, owner);
876     }
877 
878     /**
879      * @dev See {IERC721-getApproved}.
880      */
881     function getApproved(uint256 tokenId)
882         public
883         view
884         override
885         returns (address)
886     {
887         require(
888             _exists(tokenId),
889             "ERC721A: approved query for nonexistent token"
890         );
891 
892         return _tokenApprovals[tokenId];
893     }
894 
895     /**
896      * @dev See {IERC721-setApprovalForAll}.
897      */
898     function setApprovalForAll(address operator, bool approved)
899         public
900         override
901     {
902         require(operator != _msgSender(), "ERC721A: approve to caller");
903 
904         _operatorApprovals[_msgSender()][operator] = approved;
905         emit ApprovalForAll(_msgSender(), operator, approved);
906     }
907 
908     /**
909      * @dev See {IERC721-isApprovedForAll}.
910      */
911     function isApprovedForAll(address owner, address operator)
912         public
913         view
914         virtual
915         override
916         returns (bool)
917     {
918         return _operatorApprovals[owner][operator];
919     }
920 
921     /**
922      * @dev See {IERC721-transferFrom}.
923      */
924     function transferFrom(
925         address from,
926         address to,
927         uint256 tokenId
928     ) public override {
929         _transfer(from, to, tokenId);
930     }
931 
932     /**
933      * @dev See {IERC721-safeTransferFrom}.
934      */
935     function safeTransferFrom(
936         address from,
937         address to,
938         uint256 tokenId
939     ) public override {
940         safeTransferFrom(from, to, tokenId, "");
941     }
942 
943     /**
944      * @dev See {IERC721-safeTransferFrom}.
945      */
946     function safeTransferFrom(
947         address from,
948         address to,
949         uint256 tokenId,
950         bytes memory _data
951     ) public override {
952         _transfer(from, to, tokenId);
953         require(
954             _checkOnERC721Received(from, to, tokenId, _data),
955             "ERC721A: transfer to non ERC721Receiver implementer"
956         );
957     }
958 
959     /**
960      * @dev Returns whether `tokenId` exists.
961      *
962      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
963      *
964      * Tokens start existing when they are minted (`_mint`),
965      */
966     function _exists(uint256 tokenId) internal view returns (bool) {
967         return tokenId < currentIndex;
968     }
969 
970     function _safeMint(address to, uint256 quantity) internal {
971         _safeMint(to, quantity, "");
972     }
973 
974     /**
975      * @dev Mints `quantity` tokens and transfers them to `to`.
976      *
977      * Requirements:
978      *
979      * - there must be `quantity` tokens remaining unminted in the total collection.
980      * - `to` cannot be the zero address.
981      * - `quantity` cannot be larger than the max batch size.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _safeMint(
986         address to,
987         uint256 quantity,
988         bytes memory _data
989     ) internal {
990         uint256 startTokenId = currentIndex;
991         require(to != address(0), "ERC721A: mint to the zero address");
992         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
993         require(!_exists(startTokenId), "ERC721A: token already minted");
994         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
995 
996         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
997 
998         AddressData memory addressData = _addressData[to];
999         _addressData[to] = AddressData(
1000             addressData.balance + uint128(quantity),
1001             addressData.numberMinted + uint128(quantity)
1002         );
1003         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1004 
1005         uint256 updatedIndex = startTokenId;
1006 
1007         for (uint256 i = 0; i < quantity; i++) {
1008             emit Transfer(address(0), to, updatedIndex);
1009             require(
1010                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1011                 "ERC721A: transfer to non ERC721Receiver implementer"
1012             );
1013             updatedIndex++;
1014         }
1015 
1016         currentIndex = updatedIndex;
1017         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1018     }
1019 
1020     /**
1021      * @dev Transfers `tokenId` from `from` to `to`.
1022      *
1023      * Requirements:
1024      *
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must be owned by `from`.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _transfer(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) private {
1035         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1036 
1037         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1038             getApproved(tokenId) == _msgSender() ||
1039             isApprovedForAll(prevOwnership.addr, _msgSender()));
1040 
1041         require(
1042             isApprovedOrOwner,
1043             "ERC721A: transfer caller is not owner nor approved"
1044         );
1045 
1046         require(
1047             prevOwnership.addr == from,
1048             "ERC721A: transfer from incorrect owner"
1049         );
1050         require(to != address(0), "ERC721A: transfer to the zero address");
1051 
1052         _beforeTokenTransfers(from, to, tokenId, 1);
1053 
1054         // Clear approvals from the previous owner
1055         _approve(address(0), tokenId, prevOwnership.addr);
1056 
1057         _addressData[from].balance -= 1;
1058         _addressData[to].balance += 1;
1059         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1060 
1061         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1062         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1063         uint256 nextTokenId = tokenId + 1;
1064         if (_ownerships[nextTokenId].addr == address(0)) {
1065             if (_exists(nextTokenId)) {
1066                 _ownerships[nextTokenId] = TokenOwnership(
1067                     prevOwnership.addr,
1068                     prevOwnership.startTimestamp
1069                 );
1070             }
1071         }
1072 
1073         emit Transfer(from, to, tokenId);
1074         _afterTokenTransfers(from, to, tokenId, 1);
1075     }
1076 
1077     /**
1078      * @dev Approve `to` to operate on `tokenId`
1079      *
1080      * Emits a {Approval} event.
1081      */
1082     function _approve(
1083         address to,
1084         uint256 tokenId,
1085         address owner
1086     ) private {
1087         _tokenApprovals[tokenId] = to;
1088         emit Approval(owner, to, tokenId);
1089     }
1090 
1091     uint256 public nextOwnerToExplicitlySet = 0;
1092 
1093     /**
1094      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1095      */
1096     function _setOwnersExplicit(uint256 quantity) internal {
1097         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1098         require(quantity > 0, "quantity must be nonzero");
1099         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1100         if (endIndex > collectionSize - 1) {
1101             endIndex = collectionSize - 1;
1102         }
1103         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1104         require(_exists(endIndex), "not enough minted yet for this cleanup");
1105         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1106             if (_ownerships[i].addr == address(0)) {
1107                 TokenOwnership memory ownership = ownershipOf(i);
1108                 _ownerships[i] = TokenOwnership(
1109                     ownership.addr,
1110                     ownership.startTimestamp
1111                 );
1112             }
1113         }
1114         nextOwnerToExplicitlySet = endIndex + 1;
1115     }
1116 
1117     /**
1118      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1119      * The call is not executed if the target address is not a contract.
1120      *
1121      * @param from address representing the previous owner of the given token ID
1122      * @param to target address that will receive the tokens
1123      * @param tokenId uint256 ID of the token to be transferred
1124      * @param _data bytes optional data to send along with the call
1125      * @return bool whether the call correctly returned the expected magic value
1126      */
1127     function _checkOnERC721Received(
1128         address from,
1129         address to,
1130         uint256 tokenId,
1131         bytes memory _data
1132     ) private returns (bool) {
1133         if (to.isContract()) {
1134             try
1135                 IERC721Receiver(to).onERC721Received(
1136                     _msgSender(),
1137                     from,
1138                     tokenId,
1139                     _data
1140                 )
1141             returns (bytes4 retval) {
1142                 return retval == IERC721Receiver(to).onERC721Received.selector;
1143             } catch (bytes memory reason) {
1144                 if (reason.length == 0) {
1145                     revert(
1146                         "ERC721A: transfer to non ERC721Receiver implementer"
1147                     );
1148                 } else {
1149                     assembly {
1150                         revert(add(32, reason), mload(reason))
1151                     }
1152                 }
1153             }
1154         } else {
1155             return true;
1156         }
1157     }
1158 
1159     /**
1160      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1161      *
1162      * startTokenId - the first token id to be transferred
1163      * quantity - the amount to be transferred
1164      *
1165      * Calling conditions:
1166      *
1167      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1168      * transferred to `to`.
1169      * - When `from` is zero, `tokenId` will be minted for `to`.
1170      */
1171     function _beforeTokenTransfers(
1172         address from,
1173         address to,
1174         uint256 startTokenId,
1175         uint256 quantity
1176     ) internal virtual {}
1177 
1178     /**
1179      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1180      * minting.
1181      *
1182      * startTokenId - the first token id to be transferred
1183      * quantity - the amount to be transferred
1184      *
1185      * Calling conditions:
1186      *
1187      * - when `from` and `to` are both non-zero.
1188      * - `from` and `to` are never both zero.
1189      */
1190     function _afterTokenTransfers(
1191         address from,
1192         address to,
1193         uint256 startTokenId,
1194         uint256 quantity
1195     ) internal virtual {}
1196 }
1197 
1198 // File: @openzeppelin/contracts/access/Ownable.sol
1199 
1200 
1201 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1202 
1203 pragma solidity ^0.8.0;
1204 
1205 
1206 /**
1207  * @dev Contract module which provides a basic access control mechanism, where
1208  * there is an account (an owner) that can be granted exclusive access to
1209  * specific functions.
1210  *
1211  * By default, the owner account will be the one that deploys the contract. This
1212  * can later be changed with {transferOwnership}.
1213  *
1214  * This module is used through inheritance. It will make available the modifier
1215  * `onlyOwner`, which can be applied to your functions to restrict their use to
1216  * the owner.
1217  */
1218 abstract contract Ownable is Context {
1219     address private _owner;
1220 
1221     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1222 
1223     /**
1224      * @dev Initializes the contract setting the deployer as the initial owner.
1225      */
1226     constructor() {
1227         _transferOwnership(_msgSender());
1228     }
1229 
1230     /**
1231      * @dev Returns the address of the current owner.
1232      */
1233     function owner() public view virtual returns (address) {
1234         return _owner;
1235     }
1236 
1237     /**
1238      * @dev Throws if called by any account other than the owner.
1239      */
1240     modifier onlyOwner() {
1241         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1242         _;
1243     }
1244 
1245     /**
1246      * @dev Leaves the contract without owner. It will not be possible to call
1247      * `onlyOwner` functions anymore. Can only be called by the current owner.
1248      *
1249      * NOTE: Renouncing ownership will leave the contract without an owner,
1250      * thereby removing any functionality that is only available to the owner.
1251      */
1252     function renounceOwnership() public virtual onlyOwner {
1253         _transferOwnership(address(0));
1254     }
1255 
1256     /**
1257      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1258      * Can only be called by the current owner.
1259      */
1260     function transferOwnership(address newOwner) public virtual onlyOwner {
1261         require(newOwner != address(0), "Ownable: new owner is the zero address");
1262         _transferOwnership(newOwner);
1263     }
1264 
1265     /**
1266      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1267      * Internal function without access restriction.
1268      */
1269     function _transferOwnership(address newOwner) internal virtual {
1270         address oldOwner = _owner;
1271         _owner = newOwner;
1272         emit OwnershipTransferred(oldOwner, newOwner);
1273     }
1274 }
1275 
1276 // File: contracts/TotalDegenz.sol
1277 
1278 
1279 pragma solidity ^0.8.0;
1280 
1281 
1282 
1283 
1284 contract TotalDegenz is ERC721A, Ownable {
1285     constructor() ERC721A("Total Degenz", "DEGENZ", 10, 6969) {}
1286 
1287     uint256 public PRICE = 0.025 ether;
1288     uint256 public constant MINT_LIMIT = 20;
1289     uint256 public constant PRIVATE_LIMIT = 10;
1290     uint256 public constant PUBLIC_FREE = 1000;
1291     uint256 public constant PRIVATE_RESERVED = 500;
1292 
1293     uint256 public privateMintEndTime;
1294     bool public isPublicSaleActive = false;
1295 
1296     mapping(address => uint256) private privateMints;
1297     uint256 public PUBLIC_MINTED = 0;
1298     uint256 public PRIVATE_MINTED = 0;
1299 
1300     string private baseURI = "";
1301     bytes32 privateSaleRoot;
1302 
1303     address public constant ADDRESS_1 =
1304         0x188A3c584F0dE9ee0eABe04316A94A41F0867C0C; //B
1305     address public constant ADDRESS_2 =
1306         0xbC905EbFA0D1D0e636550432D497F86D602Cf643; //C
1307 
1308     //Essential
1309     function mint(uint256 numberOfTokens) external payable {
1310         require(msg.sender == tx.origin, "No contracts allowed");
1311         if (block.timestamp <= privateMintEndTime) {
1312             require(
1313                 numberOfTokens + PRIVATE_RESERVED + PUBLIC_MINTED <=
1314                     collectionSize,
1315                 "Not enough supply, private mint ongoing"
1316             );
1317         } else {
1318             require(
1319                 numberOfTokens + totalSupply() <= collectionSize,
1320                 "Not enough supply"
1321             );
1322         }
1323 
1324         require(
1325             numberMinted(msg.sender) + numberOfTokens <= MINT_LIMIT,
1326             "Exceeding max mint limit"
1327         );
1328         require(isPublicSaleActive, "Public sale not active");
1329         if (PUBLIC_MINTED + numberOfTokens > PUBLIC_FREE) {
1330             require(msg.value >= PRICE * numberOfTokens, "Not enough ETH");
1331         }
1332         PUBLIC_MINTED += numberOfTokens;
1333         _safeMint(msg.sender, numberOfTokens);
1334     }
1335 
1336     function privateMint(uint256 numberOfTokens, bytes32[] memory proof)
1337         external
1338         payable
1339     {
1340         require(msg.sender == tx.origin, "No contracts allowed");
1341         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1342         require(verify(leaf, proof), "Address is not in presale list");
1343         require(
1344             block.timestamp <= privateMintEndTime,
1345             "Private mint reservation has ended"
1346         );
1347         require(
1348             numberOfTokens + totalSupply() <= collectionSize,
1349             "Not enough supply"
1350         );
1351         require(
1352             privateMints[msg.sender] + numberOfTokens <= PRIVATE_LIMIT,
1353             "Exceeding max private sale limit"
1354         );
1355         require(
1356             numberMinted(msg.sender) + numberOfTokens <= MINT_LIMIT,
1357             "Exceeding max mint limit"
1358         );
1359         require(
1360             PRIVATE_MINTED + numberOfTokens <= PRIVATE_RESERVED,
1361             "Ran out of private reserved"
1362         );
1363         require(isPublicSaleActive, "Public sale not active");
1364         privateMints[msg.sender] += numberOfTokens;
1365         PRIVATE_MINTED += numberOfTokens;
1366         _safeMint(msg.sender, numberOfTokens);
1367     }
1368 
1369     //Essential
1370     function setBaseURI(string calldata URI) external onlyOwner {
1371         baseURI = URI;
1372     }
1373 
1374     //Essential
1375     function setPublicSaleStatus() external onlyOwner {
1376         isPublicSaleActive = !isPublicSaleActive;
1377     }
1378 
1379     function setPrivateSaleEndTime(uint256 duration) external onlyOwner {
1380         privateMintEndTime = block.timestamp + (duration);
1381     }
1382 
1383     //Essential
1384     function withdraw() external onlyOwner {
1385         uint256 balance = address(this).balance;
1386         payable(ADDRESS_1).transfer((balance * 1500) / 10000);
1387         payable(ADDRESS_2).transfer(address(this).balance);
1388     }
1389 
1390     function tokenURI(uint256 tokenId)
1391         public
1392         view
1393         virtual
1394         override
1395         returns (string memory)
1396     {
1397         require(_exists(tokenId), "Token does not exist");
1398 
1399         return string(abi.encodePacked(baseURI, Strings.toString(tokenId)));
1400     }
1401 
1402     function tokensOfOwner(address owner)
1403         public
1404         view
1405         returns (uint256[] memory)
1406     {
1407         uint256 tokenCount = balanceOf(owner);
1408         uint256[] memory tokenIds = new uint256[](tokenCount);
1409         for (uint256 i = 0; i < tokenCount; i++) {
1410             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
1411         }
1412         return tokenIds;
1413     }
1414 
1415     function numberMinted(address owner) public view returns (uint256) {
1416         return _numberMinted(owner);
1417     }
1418 
1419     function verify(bytes32 leaf, bytes32[] memory proof)
1420         public
1421         view
1422         returns (bool)
1423     {
1424         bytes32 computedHash = leaf;
1425 
1426         for (uint256 i = 0; i < proof.length; i++) {
1427             bytes32 proofElement = proof[i];
1428 
1429             if (computedHash <= proofElement) {
1430                 computedHash = keccak256(
1431                     abi.encodePacked(computedHash, proofElement)
1432                 );
1433             } else {
1434                 computedHash = keccak256(
1435                     abi.encodePacked(proofElement, computedHash)
1436                 );
1437             }
1438         }
1439         return computedHash == privateSaleRoot;
1440     }
1441 
1442     function setRoot(bytes32 _root) external onlyOwner {
1443         privateSaleRoot = _root;
1444     }
1445 
1446     function isPrivateSaleActive() external view returns (bool) {
1447         return block.timestamp <= privateMintEndTime;
1448     }
1449 
1450     function isPrivateListed(bytes32 leaf, bytes32[] memory proof)
1451         external
1452         view
1453         returns (bool)
1454     {
1455         return verify(leaf, proof);
1456     }
1457 
1458     function releaseDegenz() external onlyOwner {
1459         PRICE = 0 ether;
1460     }
1461 }