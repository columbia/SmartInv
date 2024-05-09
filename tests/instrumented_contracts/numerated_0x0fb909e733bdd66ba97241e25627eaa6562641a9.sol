1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 /**
27  * @dev Required interface of an ERC721 compliant contract.
28  */
29 interface IERC721 is IERC165 {
30     /**
31      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
32      */
33     event Transfer(
34         address indexed from,
35         address indexed to,
36         uint256 indexed tokenId
37     );
38 
39     /**
40      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
41      */
42     event Approval(
43         address indexed owner,
44         address indexed approved,
45         uint256 indexed tokenId
46     );
47 
48     /**
49      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
50      */
51     event ApprovalForAll(
52         address indexed owner,
53         address indexed operator,
54         bool approved
55     );
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
73      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId
89     ) external;
90 
91     /**
92      * @dev Transfers `tokenId` token from `from` to `to`.
93      *
94      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must be owned by `from`.
101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
113      * The approval is cleared when the token is transferred.
114      *
115      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
116      *
117      * Requirements:
118      *
119      * - The caller must own the token or be an approved operator.
120      * - `tokenId` must exist.
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId)
134         external
135         view
136         returns (address operator);
137 
138     /**
139      * @dev Approve or remove `operator` as an operator for the caller.
140      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
141      *
142      * Requirements:
143      *
144      * - The `operator` cannot be the caller.
145      *
146      * Emits an {ApprovalForAll} event.
147      */
148     function setApprovalForAll(address operator, bool _approved) external;
149 
150     /**
151      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
152      *
153      * See {setApprovalForAll}
154      */
155     function isApprovedForAll(address owner, address operator)
156         external
157         view
158         returns (bool);
159 
160     /**
161      * @dev Safely transfers `tokenId` token from `from` to `to`.
162      *
163      * Requirements:
164      *
165      * - `from` cannot be the zero address.
166      * - `to` cannot be the zero address.
167      * - `tokenId` token must exist and be owned by `from`.
168      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
169      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
170      *
171      * Emits a {Transfer} event.
172      */
173     function safeTransferFrom(
174         address from,
175         address to,
176         uint256 tokenId,
177         bytes calldata data
178     ) external;
179 }
180 
181 /**
182  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
183  * @dev See https://eips.ethereum.org/EIPS/eip-721
184  */
185 interface IERC721Enumerable is IERC721 {
186     /**
187      * @dev Returns the total amount of tokens stored by the contract.
188      */
189     function totalSupply() external view returns (uint256);
190 
191     /**
192      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
193      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
194      */
195     function tokenOfOwnerByIndex(address owner, uint256 index)
196         external
197         view
198         returns (uint256 tokenId);
199 
200     /**
201      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
202      * Use along with {totalSupply} to enumerate all tokens.
203      */
204     function tokenByIndex(uint256 index) external view returns (uint256);
205 }
206 
207 /**
208  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
209  * @dev See https://eips.ethereum.org/EIPS/eip-721
210  */
211 interface IERC721Metadata is IERC721 {
212     /**
213      * @dev Returns the token collection name.
214      */
215     function name() external view returns (string memory);
216 
217     /**
218      * @dev Returns the token collection symbol.
219      */
220     function symbol() external view returns (string memory);
221 
222     /**
223      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
224      */
225     function tokenURI(uint256 tokenId) external view returns (string memory);
226 }
227 
228 /**
229  * @title ERC721 token receiver interface
230  * @dev Interface for any contract that wants to support safeTransfers
231  * from ERC721 asset contracts.
232  */
233 interface IERC721Receiver {
234     /**
235      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
236      * by `operator` from `from`, this function is called.
237      *
238      * It must return its Solidity selector to confirm the token transfer.
239      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
240      *
241      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
242      */
243     function onERC721Received(
244         address operator,
245         address from,
246         uint256 tokenId,
247         bytes calldata data
248     ) external returns (bytes4);
249 }
250 
251 /**
252  * @dev Collection of functions related to the address type
253  */
254 library Address {
255     /**
256      * @dev Returns true if `account` is a contract.
257      *
258      * [IMPORTANT]
259      * ====
260      * It is unsafe to assume that an address for which this function returns
261      * false is an externally-owned account (EOA) and not a contract.
262      *
263      * Among others, `isContract` will return false for the following
264      * types of addresses:
265      *
266      *  - an externally-owned account
267      *  - a contract in construction
268      *  - an address where a contract will be created
269      *  - an address where a contract lived, but was destroyed
270      * ====
271      */
272     function isContract(address account) internal view returns (bool) {
273         // This method relies on extcodesize, which returns 0 for contracts in
274         // construction, since the code is only stored at the end of the
275         // constructor execution.
276 
277         uint256 size;
278         assembly {
279             size := extcodesize(account)
280         }
281         return size > 0;
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(
302             address(this).balance >= amount,
303             "Address: insufficient balance"
304         );
305 
306         (bool success, ) = recipient.call{value: amount}("");
307         require(
308             success,
309             "Address: unable to send value, recipient may have reverted"
310         );
311     }
312 
313     /**
314      * @dev Performs a Solidity function call using a low level `call`. A
315      * plain `call` is an unsafe replacement for a function call: use this
316      * function instead.
317      *
318      * If `target` reverts with a revert reason, it is bubbled up by this
319      * function (like regular Solidity function calls).
320      *
321      * Returns the raw returned data. To convert to the expected return value,
322      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
323      *
324      * Requirements:
325      *
326      * - `target` must be a contract.
327      * - calling `target` with `data` must not revert.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data)
332         internal
333         returns (bytes memory)
334     {
335         return functionCall(target, data, "Address: low-level call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
340      * `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(
345         address target,
346         bytes memory data,
347         string memory errorMessage
348     ) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, 0, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but also transferring `value` wei to `target`.
355      *
356      * Requirements:
357      *
358      * - the calling contract must have an ETH balance of at least `value`.
359      * - the called Solidity function must be `payable`.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(
364         address target,
365         bytes memory data,
366         uint256 value
367     ) internal returns (bytes memory) {
368         return
369             functionCallWithValue(
370                 target,
371                 data,
372                 value,
373                 "Address: low-level call with value failed"
374             );
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
379      * with `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         require(
390             address(this).balance >= value,
391             "Address: insufficient balance for call"
392         );
393         require(isContract(target), "Address: call to non-contract");
394 
395         (bool success, bytes memory returndata) = target.call{value: value}(
396             data
397         );
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but performing a static call.
404      *
405      * _Available since v3.3._
406      */
407     function functionStaticCall(address target, bytes memory data)
408         internal
409         view
410         returns (bytes memory)
411     {
412         return
413             functionStaticCall(
414                 target,
415                 data,
416                 "Address: low-level static call failed"
417             );
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
422      * but performing a static call.
423      *
424      * _Available since v3.3._
425      */
426     function functionStaticCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal view returns (bytes memory) {
431         require(isContract(target), "Address: static call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.staticcall(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a delegate call.
440      *
441      * _Available since v3.4._
442      */
443     function functionDelegateCall(address target, bytes memory data)
444         internal
445         returns (bytes memory)
446     {
447         return
448             functionDelegateCall(
449                 target,
450                 data,
451                 "Address: low-level delegate call failed"
452             );
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
457      * but performing a delegate call.
458      *
459      * _Available since v3.4._
460      */
461     function functionDelegateCall(
462         address target,
463         bytes memory data,
464         string memory errorMessage
465     ) internal returns (bytes memory) {
466         require(isContract(target), "Address: delegate call to non-contract");
467 
468         (bool success, bytes memory returndata) = target.delegatecall(data);
469         return verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     /**
473      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
474      * revert reason using the provided one.
475      *
476      * _Available since v4.3._
477      */
478     function verifyCallResult(
479         bool success,
480         bytes memory returndata,
481         string memory errorMessage
482     ) internal pure returns (bytes memory) {
483         if (success) {
484             return returndata;
485         } else {
486             // Look for revert reason and bubble it up if present
487             if (returndata.length > 0) {
488                 // The easiest way to bubble the revert reason is using memory via assembly
489 
490                 assembly {
491                     let returndata_size := mload(returndata)
492                     revert(add(32, returndata), returndata_size)
493                 }
494             } else {
495                 revert(errorMessage);
496             }
497         }
498     }
499 }
500 
501 /**
502  * @dev String operations.
503  */
504 library Strings {
505     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
506 
507     /**
508      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
509      */
510     function toString(uint256 value) internal pure returns (string memory) {
511         // Inspired by OraclizeAPI's implementation - MIT licence
512         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
513 
514         if (value == 0) {
515             return "0";
516         }
517         uint256 temp = value;
518         uint256 digits;
519         while (temp != 0) {
520             digits++;
521             temp /= 10;
522         }
523         bytes memory buffer = new bytes(digits);
524         while (value != 0) {
525             digits -= 1;
526             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
527             value /= 10;
528         }
529         return string(buffer);
530     }
531 
532     /**
533      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
534      */
535     function toHexString(uint256 value) internal pure returns (string memory) {
536         if (value == 0) {
537             return "0x00";
538         }
539         uint256 temp = value;
540         uint256 length = 0;
541         while (temp != 0) {
542             length++;
543             temp >>= 8;
544         }
545         return toHexString(value, length);
546     }
547 
548     /**
549      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
550      */
551     function toHexString(uint256 value, uint256 length)
552         internal
553         pure
554         returns (string memory)
555     {
556         bytes memory buffer = new bytes(2 * length + 2);
557         buffer[0] = "0";
558         buffer[1] = "x";
559         for (uint256 i = 2 * length + 1; i > 1; --i) {
560             buffer[i] = _HEX_SYMBOLS[value & 0xf];
561             value >>= 4;
562         }
563         require(value == 0, "Strings: hex length insufficient");
564         return string(buffer);
565     }
566 }
567 
568 /**
569  * @dev Provides information about the current execution context, including the
570  * sender of the transaction and its data. While these are generally available
571  * via msg.sender and msg.data, they should not be accessed in such a direct
572  * manner, since when dealing with meta-transactions the account sending and
573  * paying for execution may not be the actual sender (as far as an application
574  * is concerned).
575  *
576  * This contract is only required for intermediate, library-like contracts.
577  */
578 abstract contract Context {
579     function _msgSender() internal view virtual returns (address) {
580         return msg.sender;
581     }
582 
583     function _msgData() internal view virtual returns (bytes calldata) {
584         return msg.data;
585     }
586 }
587 
588 /**
589  * @dev Implementation of the {IERC165} interface.
590  *
591  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
592  * for the additional interface id that will be supported. For example:
593  *
594  * ```solidity
595  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
596  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
597  * }
598  * ```
599  *
600  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
601  */
602 abstract contract ERC165 is IERC165 {
603     /**
604      * @dev See {IERC165-supportsInterface}.
605      */
606     function supportsInterface(bytes4 interfaceId)
607         public
608         view
609         virtual
610         override
611         returns (bool)
612     {
613         return interfaceId == type(IERC165).interfaceId;
614     }
615 }
616 
617 /**
618  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
619  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
620  *
621  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
622  *
623  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
624  *
625  * Does not support burning tokens to address(0).
626  */
627 contract ERC721A is
628     Context,
629     ERC165,
630     IERC721,
631     IERC721Metadata,
632     IERC721Enumerable
633 {
634     using Address for address;
635     using Strings for uint256;
636 
637     struct TokenOwnership {
638         address addr;
639         uint64 startTimestamp;
640     }
641 
642     struct AddressData {
643         uint128 balance;
644         uint128 numberMinted;
645     }
646 
647     uint256 private nextIndexId = 1;
648 
649     uint256 internal immutable collectionSize;
650     uint256 internal immutable maxBatchSize;
651 
652     // Token name
653     string private _name;
654 
655     // Token symbol
656     string private _symbol;
657 
658     // Mapping from token ID to ownership details
659     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
660     mapping(uint256 => TokenOwnership) private _ownerships;
661 
662     // Mapping owner address to address data
663     mapping(address => AddressData) private _addressData;
664 
665     // Mapping from token ID to approved address
666     mapping(uint256 => address) private _tokenApprovals;
667 
668     // Mapping from owner to operator approvals
669     mapping(address => mapping(address => bool)) private _operatorApprovals;
670 
671     /**
672      * @dev
673      * `maxBatchSize` refers to how much a minter can mint at a time.
674      * `collectionSize_` refers to how many tokens are in the collection.
675      */
676     constructor(
677         string memory name_,
678         string memory symbol_,
679         uint256 maxBatchSize_,
680         uint256 collectionSize_
681     ) {
682         require(
683             collectionSize_ > 0,
684             "ERC721A: collection must have a nonzero supply"
685         );
686         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
687         _name = name_;
688         _symbol = symbol_;
689         maxBatchSize = maxBatchSize_;
690         collectionSize = collectionSize_;
691     }
692 
693     /**
694      * @dev See {IERC721Enumerable-totalSupply}.
695      */
696     function totalSupply() public view override returns (uint256) {
697         return nextIndexId - 1;
698     }
699 
700     /**
701      * @dev See {IERC721Enumerable-tokenByIndex}.
702      */
703     function tokenByIndex(uint256 index)
704         public
705         view
706         override
707         returns (uint256)
708     {
709         require(index < totalSupply(), "ERC721A: global index out of bounds");
710         return index;
711     }
712 
713     /**
714      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
715      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
716      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
717      */
718     function tokenOfOwnerByIndex(address owner, uint256 index)
719         public
720         view
721         override
722         returns (uint256)
723     {
724         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
725         uint256 numMintedSoFar = totalSupply();
726         uint256 tokenIdsIdx = 0;
727         address currOwnershipAddr = address(0);
728         for (uint256 i = 0; i < numMintedSoFar; i++) {
729             TokenOwnership memory ownership = _ownerships[i];
730             if (ownership.addr != address(0)) {
731                 currOwnershipAddr = ownership.addr;
732             }
733             if (currOwnershipAddr == owner) {
734                 if (tokenIdsIdx == index) {
735                     return i;
736                 }
737                 tokenIdsIdx++;
738             }
739         }
740         revert("ERC721A: unable to get token of owner by index");
741     }
742 
743     /**
744      * @dev See {IERC165-supportsInterface}.
745      */
746     function supportsInterface(bytes4 interfaceId)
747         public
748         view
749         virtual
750         override(ERC165, IERC165)
751         returns (bool)
752     {
753         return
754             interfaceId == type(IERC721).interfaceId ||
755             interfaceId == type(IERC721Metadata).interfaceId ||
756             interfaceId == type(IERC721Enumerable).interfaceId ||
757             super.supportsInterface(interfaceId);
758     }
759 
760     /**
761      * @dev See {IERC721-balanceOf}.
762      */
763     function balanceOf(address owner) public view override returns (uint256) {
764         require(
765             owner != address(0),
766             "ERC721A: balance query for the zero address"
767         );
768         return uint256(_addressData[owner].balance);
769     }
770 
771     function _numberMinted(address owner) internal view returns (uint256) {
772         require(
773             owner != address(0),
774             "ERC721A: number minted query for the zero address"
775         );
776         return uint256(_addressData[owner].numberMinted);
777     }
778 
779     function ownershipOf(uint256 tokenId)
780         internal
781         view
782         returns (TokenOwnership memory)
783     {
784         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
785 
786         uint256 lowestTokenToCheck;
787         if (tokenId >= maxBatchSize) {
788             lowestTokenToCheck = tokenId - maxBatchSize + 1;
789         }
790 
791         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
792             TokenOwnership memory ownership = _ownerships[curr];
793             if (ownership.addr != address(0)) {
794                 return ownership;
795             }
796         }
797 
798         revert("ERC721A: unable to determine the owner of token");
799     }
800 
801     /**
802      * @dev See {IERC721-ownerOf}.
803      */
804     function ownerOf(uint256 tokenId) public view override returns (address) {
805         return ownershipOf(tokenId).addr;
806     }
807 
808     /**
809      * @dev See {IERC721Metadata-name}.
810      */
811     function name() public view virtual override returns (string memory) {
812         return _name;
813     }
814 
815     /**
816      * @dev See {IERC721Metadata-symbol}.
817      */
818     function symbol() public view virtual override returns (string memory) {
819         return _symbol;
820     }
821 
822     /**
823      * @dev See {IERC721Metadata-tokenURI}.
824      */
825     function tokenURI(uint256 tokenId)
826         public
827         view
828         virtual
829         override
830         returns (string memory)
831     {
832         require(
833             _exists(tokenId),
834             "ERC721Metadata: URI query for nonexistent token"
835         );
836 
837         string memory baseURI = _baseURI();
838         return
839             bytes(baseURI).length > 0
840                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
841                 : "";
842     }
843 
844     /**
845      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
846      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
847      * by default, can be overriden in child contracts.
848      */
849     function _baseURI() internal view virtual returns (string memory) {
850         return "";
851     }
852 
853     /**
854      * @dev See {IERC721-approve}.
855      */
856     function approve(address to, uint256 tokenId) public override {
857         address owner = ERC721A.ownerOf(tokenId);
858         require(to != owner, "ERC721A: approval to current owner");
859 
860         require(
861             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
862             "ERC721A: approve caller is not owner nor approved for all"
863         );
864 
865         _approve(to, tokenId, owner);
866     }
867 
868     /**
869      * @dev See {IERC721-getApproved}.
870      */
871     function getApproved(uint256 tokenId)
872         public
873         view
874         override
875         returns (address)
876     {
877         require(
878             _exists(tokenId),
879             "ERC721A: approved query for nonexistent token"
880         );
881 
882         return _tokenApprovals[tokenId];
883     }
884 
885     /**
886      * @dev See {IERC721-setApprovalForAll}.
887      */
888     function setApprovalForAll(address operator, bool approved)
889         public
890         override
891     {
892         require(operator != _msgSender(), "ERC721A: approve to caller");
893 
894         _operatorApprovals[_msgSender()][operator] = approved;
895         emit ApprovalForAll(_msgSender(), operator, approved);
896     }
897 
898     /**
899      * @dev See {IERC721-isApprovedForAll}.
900      */
901     function isApprovedForAll(address owner, address operator)
902         public
903         view
904         virtual
905         override
906         returns (bool)
907     {
908         return _operatorApprovals[owner][operator];
909     }
910 
911     /**
912      * @dev See {IERC721-transferFrom}.
913      */
914     function transferFrom(
915         address from,
916         address to,
917         uint256 tokenId
918     ) public override {
919         _transfer(from, to, tokenId);
920     }
921 
922     /**
923      * @dev See {IERC721-safeTransferFrom}.
924      */
925     function safeTransferFrom(
926         address from,
927         address to,
928         uint256 tokenId
929     ) public override {
930         safeTransferFrom(from, to, tokenId, "");
931     }
932 
933     /**
934      * @dev See {IERC721-safeTransferFrom}.
935      */
936     function safeTransferFrom(
937         address from,
938         address to,
939         uint256 tokenId,
940         bytes memory _data
941     ) public override {
942         _transfer(from, to, tokenId);
943         require(
944             _checkOnERC721Received(from, to, tokenId, _data),
945             "ERC721A: transfer to non ERC721Receiver implementer"
946         );
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
957         return tokenId < nextIndexId ;
958     }
959 
960     /**
961      * @dev Mints `quantity` tokens and transfers them to `to`.
962      *
963      * Requirements:
964      *
965      * - there must be `quantity` tokens remaining unminted in the total collection.
966      * - `to` cannot be the zero address.
967      * - `quantity` cannot be larger than the max batch size.
968      *
969      * Emits a {Transfer} event.
970      */
971     function _safeMint(address to, uint256 quantity) internal {
972         uint256 startTokenId = nextIndexId;
973         require(to != address(0), "ERC721A: mint to the zero address");
974         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
975         require(!_exists(startTokenId), "ERC721A: token already minted");
976         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
977 
978         AddressData memory addressData = _addressData[to];
979         _addressData[to] = AddressData(
980             addressData.balance + uint128(quantity),
981             addressData.numberMinted + uint128(quantity)
982         );
983         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
984 
985         uint256 updatedIndex = startTokenId;
986 
987         for (uint256 i = 0; i < quantity; i++) {
988             emit Transfer(address(0), to, updatedIndex);
989             updatedIndex++;
990         }
991 
992         nextIndexId = updatedIndex;
993     }
994 
995     /**
996      * @dev Transfers `tokenId` from `from` to `to`.
997      *
998      * Requirements:
999      *
1000      * - `to` cannot be the zero address.
1001      * - `tokenId` token must be owned by `from`.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _transfer(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) private {
1010         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1011 
1012         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1013             getApproved(tokenId) == _msgSender() ||
1014             isApprovedForAll(prevOwnership.addr, _msgSender()));
1015 
1016         require(
1017             isApprovedOrOwner,
1018             "ERC721A: transfer caller is not owner nor approved"
1019         );
1020 
1021         require(
1022             prevOwnership.addr == from,
1023             "ERC721A: transfer from incorrect owner"
1024         );
1025         require(to != address(0), "ERC721A: transfer to the zero address");
1026 
1027         // Clear approvals from the previous owner
1028         _approve(address(0), tokenId, prevOwnership.addr);
1029 
1030         _addressData[from].balance -= 1;
1031         _addressData[to].balance += 1;
1032         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1033 
1034         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1035         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1036         uint256 nextTokenId = tokenId + 1;
1037         if (_ownerships[nextTokenId].addr == address(0)) {
1038             if (_exists(nextTokenId)) {
1039                 _ownerships[nextTokenId] = TokenOwnership(
1040                     prevOwnership.addr,
1041                     prevOwnership.startTimestamp
1042                 );
1043             }
1044         }
1045 
1046         emit Transfer(from, to, tokenId);
1047     }
1048 
1049     /**
1050      * @dev Approve `to` to operate on `tokenId`
1051      *
1052      * Emits a {Approval} event.
1053      */
1054     function _approve(
1055         address to,
1056         uint256 tokenId,
1057         address owner
1058     ) private {
1059         _tokenApprovals[tokenId] = to;
1060         emit Approval(owner, to, tokenId);
1061     }
1062 
1063     uint256 public nextOwnerToExplicitlySet = 0;
1064 
1065     /**
1066      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1067      */
1068     function _setOwnersExplicit(uint256 quantity) internal {
1069         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1070         require(quantity > 0, "quantity must be nonzero");
1071         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1072         if (endIndex > collectionSize - 1) {
1073             endIndex = collectionSize - 1;
1074         }
1075         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1076         require(_exists(endIndex), "not enough minted yet for this cleanup");
1077         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1078             if (_ownerships[i].addr == address(0)) {
1079                 TokenOwnership memory ownership = ownershipOf(i);
1080                 _ownerships[i] = TokenOwnership(
1081                     ownership.addr,
1082                     ownership.startTimestamp
1083                 );
1084             }
1085         }
1086         nextOwnerToExplicitlySet = endIndex + 1;
1087     }
1088 
1089     /**
1090      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1091      * The call is not executed if the target address is not a contract.
1092      *
1093      * @param from address representing the previous owner of the given token ID
1094      * @param to target address that will receive the tokens
1095      * @param tokenId uint256 ID of the token to be transferred
1096      * @param _data bytes optional data to send along with the call
1097      * @return bool whether the call correctly returned the expected magic value
1098      */
1099     function _checkOnERC721Received(
1100         address from,
1101         address to,
1102         uint256 tokenId,
1103         bytes memory _data
1104     ) private returns (bool) {
1105         if (to.isContract()) {
1106             try
1107                 IERC721Receiver(to).onERC721Received(
1108                     _msgSender(),
1109                     from,
1110                     tokenId,
1111                     _data
1112                 )
1113             returns (bytes4 retval) {
1114                 return retval == IERC721Receiver(to).onERC721Received.selector;
1115             } catch (bytes memory reason) {
1116                 if (reason.length == 0) {
1117                     revert(
1118                         "ERC721A: transfer to non ERC721Receiver implementer"
1119                     );
1120                 } else {
1121                     assembly {
1122                         revert(add(32, reason), mload(reason))
1123                     }
1124                 }
1125             }
1126         } else {
1127             return true;
1128         }
1129     }
1130 }
1131 
1132 /**
1133  * @dev Contract module which provides a basic access control mechanism, where
1134  * there is an account (an owner) that can be granted exclusive access to
1135  * specific functions.
1136  *
1137  * By default, the owner account will be the one that deploys the contract. This
1138  * can later be changed with {transferOwnership}.
1139  *
1140  * This module is used through inheritance. It will make available the modifier
1141  * `onlyOwner`, which can be applied to your functions to restrict their use to
1142  * the owner.
1143  */
1144 abstract contract Ownable is Context {
1145     address private _owner;
1146 
1147     event OwnershipTransferred(
1148         address indexed previousOwner,
1149         address indexed newOwner
1150     );
1151 
1152     /**
1153      * @dev Initializes the contract setting the deployer as the initial owner.
1154      */
1155     constructor() {
1156         _transferOwnership(_msgSender());
1157     }
1158 
1159     /**
1160      * @dev Returns the address of the current owner.
1161      */
1162     function owner() public view virtual returns (address) {
1163         return _owner;
1164     }
1165 
1166     /**
1167      * @dev Throws if called by any account other than the owner.
1168      */
1169     modifier onlyOwner() {
1170         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1171         _;
1172     }
1173 
1174     /**
1175      * @dev Leaves the contract without owner. It will not be possible to call
1176      * `onlyOwner` functions anymore. Can only be called by the current owner.
1177      *
1178      * NOTE: Renouncing ownership will leave the contract without an owner,
1179      * thereby removing any functionality that is only available to the owner.
1180      */
1181     function renounceOwnership() public virtual onlyOwner {
1182         _transferOwnership(address(0));
1183     }
1184 
1185     /**
1186      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1187      * Can only be called by the current owner.
1188      */
1189     function transferOwnership(address newOwner) public virtual onlyOwner {
1190         require(
1191             newOwner != address(0),
1192             "Ownable: new owner is the zero address"
1193         );
1194         _transferOwnership(newOwner);
1195     }
1196 
1197     /**
1198      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1199      * Internal function without access restriction.
1200      */
1201     function _transferOwnership(address newOwner) internal virtual {
1202         address oldOwner = _owner;
1203         _owner = newOwner;
1204         emit OwnershipTransferred(oldOwner, newOwner);
1205     }
1206 }
1207 
1208 contract MonsterFrens is ERC721A, Ownable {
1209     using Address for address;
1210 
1211     struct Account {
1212         bool isWhitelisted;
1213         uint256 confirmedMints;
1214     }
1215 
1216     mapping(address => Account) public accountInfo;
1217 
1218     uint256 public constant MAX_SUPPLY = 8888;
1219     uint256 public constant PUBLIC_SUPPLY = 8555;
1220     uint256 public constant GIFT_SUPPLY = 333;
1221 
1222     uint256 public constant WHITELIST_LIMIT = 4;
1223     uint256 public constant DISCOUNT_PRICE = 0.04 ether;
1224     uint256 public constant PRICE = 0.05 ether;
1225 
1226     bool public isDiscountActive;
1227     bool public isPresaleActive;
1228     bool public isPublicActive;
1229 
1230     //metadata prefix
1231     string public baseTokenURI;
1232 
1233     modifier onlyWallets() {
1234         require(tx.origin == msg.sender, "must be a wallet");
1235 
1236         _;
1237     }
1238 
1239     constructor(string memory newBaseURI)
1240         ERC721A("Monster Frens", "MFR", 4, MAX_SUPPLY)
1241     {
1242         setBaseURI(newBaseURI);
1243     }
1244 
1245     function setWhitelistedAddresses(address[] calldata accounts)
1246         external
1247         onlyOwner
1248         returns (bool)
1249     {
1250         uint256 offset = accounts.length;
1251 
1252         for (uint256 i = 0; i < offset; i++) {
1253             accountInfo[accounts[i]].isWhitelisted = true;
1254         }
1255         return true;
1256     }
1257 
1258     function setPresaleStatus(bool isActive) external onlyOwner returns (bool) {
1259         isPresaleActive = isActive;
1260         return true;
1261     }
1262 
1263     function setPublicStatus(bool isActive) external onlyOwner returns (bool) {
1264         isPublicActive = isActive;
1265         return true;
1266     }
1267 
1268     function mintPresale(uint256 amount)
1269         external
1270         payable
1271         onlyWallets
1272         returns (bool)
1273     {
1274         uint256 supply = totalSupply();
1275 
1276         require(isPresaleActive, "private sale not activated");
1277         require(
1278             accountInfo[msg.sender].confirmedMints + amount <= WHITELIST_LIMIT,
1279             "Max mint limit reached"
1280         );
1281         require(amount <= WHITELIST_LIMIT, "min amount exceeds limit");
1282         require(
1283             accountInfo[msg.sender].isWhitelisted,
1284             "caller not whitelisted"
1285         );
1286         require(
1287             supply + amount <= PUBLIC_SUPPLY,
1288             "amount exceeds available supply"
1289         );
1290         require(
1291             msg.value == DISCOUNT_PRICE * amount,
1292             "incorrect ETH amount sent"
1293         );
1294 
1295         accountInfo[msg.sender].confirmedMints += amount;
1296         _safeMint(msg.sender, amount);
1297         return true;
1298     }
1299 
1300     function mintPublic(uint256 amount)
1301         external
1302         payable
1303         onlyWallets
1304         returns (bool)
1305     {
1306         uint256 supply = totalSupply();
1307 
1308         require(isPublicActive, "public sale not activated");
1309         require(
1310             amount > 0 && amount <= maxBatchSize,
1311             "amount exceeds batch limit"
1312         );
1313         require(
1314             supply + amount <= PUBLIC_SUPPLY,
1315             "amount exceeds available supply"
1316         );
1317         require(msg.value == PRICE * amount, "incorrect ETH amount sent");
1318 
1319         _safeMint(msg.sender, amount);
1320         return true;
1321     }
1322 
1323     function airdrop(address to, uint256 amount)
1324         external
1325         onlyOwner
1326         returns (bool)
1327     {
1328         uint256 supply = totalSupply();
1329 
1330         require(supply + amount <= MAX_SUPPLY, "amount exceeds max supply");
1331 
1332         _safeMint(to, amount);
1333         return true;
1334     }
1335 
1336     function withdrawTeam() external onlyOwner returns (bool) {
1337         uint256 balance = address(this).balance;
1338 
1339         require(balance > 0, "no funds to withdraw");
1340         //transfer funds
1341         payable(msg.sender).transfer(balance);
1342         return true;
1343     }
1344 
1345     function setBaseURI(string memory baseURI) public onlyOwner returns (bool) {
1346         baseTokenURI = baseURI;
1347         return true;
1348     }
1349 
1350     function _baseURI() internal view virtual override returns (string memory) {
1351         return baseTokenURI;
1352     }
1353 }