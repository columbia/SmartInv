1 // File: contracts/IERC721Receiver.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @title ERC721 token receiver interface
9  * @dev Interface for any contract that wants to support safeTransfers
10  * from ERC721 asset contracts.
11  */
12 interface IERC721Receiver {
13     /**
14      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
15      * by `operator` from `from`, this function is called.
16      *
17      * It must return its Solidity selector to confirm the token transfer.
18      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
19      *
20      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
21      */
22     function onERC721Received(
23         address operator,
24         address from,
25         uint256 tokenId,
26         bytes calldata data
27     ) external returns (bytes4);
28 }
29 
30 // File: contracts/Address.sol
31 
32 
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Collection of functions related to the address type
38  */
39 library Address {
40     /**
41      * @dev Returns true if `account` is a contract.
42      *
43      * [IMPORTANT]
44      * ====
45      * It is unsafe to assume that an address for which this function returns
46      * false is an externally-owned account (EOA) and not a contract.
47      *
48      * Among others, `isContract` will return false for the following
49      * types of addresses:
50      *
51      *  - an externally-owned account
52      *  - a contract in construction
53      *  - an address where a contract will be created
54      *  - an address where a contract lived, but was destroyed
55      * ====
56      */
57     function isContract(address account) internal view returns (bool) {
58         // This method relies on extcodesize, which returns 0 for contracts in
59         // construction, since the code is only stored at the end of the
60         // constructor execution.
61 
62         uint256 size;
63         assembly {
64             size := extcodesize(account)
65         }
66         return size > 0;
67     }
68 
69     /**
70      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
71      * `recipient`, forwarding all available gas and reverting on errors.
72      *
73      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
74      * of certain opcodes, possibly making contracts go over the 2300 gas limit
75      * imposed by `transfer`, making them unable to receive funds via
76      * `transfer`. {sendValue} removes this limitation.
77      *
78      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
79      *
80      * IMPORTANT: because control is transferred to `recipient`, care must be
81      * taken to not create reentrancy vulnerabilities. Consider using
82      * {ReentrancyGuard} or the
83      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
84      */
85     function sendValue(address payable recipient, uint256 amount) internal {
86         require(
87             address(this).balance >= amount,
88             "Address: insufficient balance"
89         );
90 
91         (bool success, ) = recipient.call{value: amount}("");
92         require(
93             success,
94             "Address: unable to send value, recipient may have reverted"
95         );
96     }
97 
98     /**
99      * @dev Performs a Solidity function call using a low level `call`. A
100      * plain `call` is an unsafe replacement for a function call: use this
101      * function instead.
102      *
103      * If `target` reverts with a revert reason, it is bubbled up by this
104      * function (like regular Solidity function calls).
105      *
106      * Returns the raw returned data. To convert to the expected return value,
107      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
108      *
109      * Requirements:
110      *
111      * - `target` must be a contract.
112      * - calling `target` with `data` must not revert.
113      *
114      * _Available since v3.1._
115      */
116     function functionCall(address target, bytes memory data)
117         internal
118         returns (bytes memory)
119     {
120         return functionCall(target, data, "Address: low-level call failed");
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
125      * `errorMessage` as a fallback revert reason when `target` reverts.
126      *
127      * _Available since v3.1._
128      */
129     function functionCall(
130         address target,
131         bytes memory data,
132         string memory errorMessage
133     ) internal returns (bytes memory) {
134         return functionCallWithValue(target, data, 0, errorMessage);
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
139      * but also transferring `value` wei to `target`.
140      *
141      * Requirements:
142      *
143      * - the calling contract must have an ETH balance of at least `value`.
144      * - the called Solidity function must be `payable`.
145      *
146      * _Available since v3.1._
147      */
148     function functionCallWithValue(
149         address target,
150         bytes memory data,
151         uint256 value
152     ) internal returns (bytes memory) {
153         return
154             functionCallWithValue(
155                 target,
156                 data,
157                 value,
158                 "Address: low-level call with value failed"
159             );
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
164      * with `errorMessage` as a fallback revert reason when `target` reverts.
165      *
166      * _Available since v3.1._
167      */
168     function functionCallWithValue(
169         address target,
170         bytes memory data,
171         uint256 value,
172         string memory errorMessage
173     ) internal returns (bytes memory) {
174         require(
175             address(this).balance >= value,
176             "Address: insufficient balance for call"
177         );
178         require(isContract(target), "Address: call to non-contract");
179 
180         (bool success, bytes memory returndata) = target.call{value: value}(
181             data
182         );
183         return verifyCallResult(success, returndata, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
188      * but performing a static call.
189      *
190      * _Available since v3.3._
191      */
192     function functionStaticCall(address target, bytes memory data)
193         internal
194         view
195         returns (bytes memory)
196     {
197         return
198             functionStaticCall(
199                 target,
200                 data,
201                 "Address: low-level static call failed"
202             );
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
207      * but performing a static call.
208      *
209      * _Available since v3.3._
210      */
211     function functionStaticCall(
212         address target,
213         bytes memory data,
214         string memory errorMessage
215     ) internal view returns (bytes memory) {
216         require(isContract(target), "Address: static call to non-contract");
217 
218         (bool success, bytes memory returndata) = target.staticcall(data);
219         return verifyCallResult(success, returndata, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but performing a delegate call.
225      *
226      * _Available since v3.4._
227      */
228     function functionDelegateCall(address target, bytes memory data)
229         internal
230         returns (bytes memory)
231     {
232         return
233             functionDelegateCall(
234                 target,
235                 data,
236                 "Address: low-level delegate call failed"
237             );
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
242      * but performing a delegate call.
243      *
244      * _Available since v3.4._
245      */
246     function functionDelegateCall(
247         address target,
248         bytes memory data,
249         string memory errorMessage
250     ) internal returns (bytes memory) {
251         require(isContract(target), "Address: delegate call to non-contract");
252 
253         (bool success, bytes memory returndata) = target.delegatecall(data);
254         return verifyCallResult(success, returndata, errorMessage);
255     }
256 
257     /**
258      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
259      * revert reason using the provided one.
260      *
261      * _Available since v4.3._
262      */
263     function verifyCallResult(
264         bool success,
265         bytes memory returndata,
266         string memory errorMessage
267     ) internal pure returns (bytes memory) {
268         if (success) {
269             return returndata;
270         } else {
271             // Look for revert reason and bubble it up if present
272             if (returndata.length > 0) {
273                 // The easiest way to bubble the revert reason is using memory via assembly
274 
275                 assembly {
276                     let returndata_size := mload(returndata)
277                     revert(add(32, returndata), returndata_size)
278                 }
279             } else {
280                 revert(errorMessage);
281             }
282         }
283     }
284 }
285 
286 // File: contracts/Strings.sol
287 
288 
289 
290 pragma solidity ^0.8.0;
291 
292 /**
293  * @dev String operations.
294  */
295 library Strings {
296     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
297 
298     /**
299      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
300      */
301     function toString(uint256 value) internal pure returns (string memory) {
302         // Inspired by OraclizeAPI's implementation - MIT licence
303         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
304 
305         if (value == 0) {
306             return "0";
307         }
308         uint256 temp = value;
309         uint256 digits;
310         while (temp != 0) {
311             digits++;
312             temp /= 10;
313         }
314         bytes memory buffer = new bytes(digits);
315         while (value != 0) {
316             digits -= 1;
317             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
318             value /= 10;
319         }
320         return string(buffer);
321     }
322 
323     /**
324      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
325      */
326     function toHexString(uint256 value) internal pure returns (string memory) {
327         if (value == 0) {
328             return "0x00";
329         }
330         uint256 temp = value;
331         uint256 length = 0;
332         while (temp != 0) {
333             length++;
334             temp >>= 8;
335         }
336         return toHexString(value, length);
337     }
338 
339     /**
340      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
341      */
342     function toHexString(uint256 value, uint256 length)
343         internal
344         pure
345         returns (string memory)
346     {
347         bytes memory buffer = new bytes(2 * length + 2);
348         buffer[0] = "0";
349         buffer[1] = "x";
350         for (uint256 i = 2 * length + 1; i > 1; --i) {
351             buffer[i] = _HEX_SYMBOLS[value & 0xf];
352             value >>= 4;
353         }
354         require(value == 0, "Strings: hex length insufficient");
355         return string(buffer);
356     }
357 }
358 
359 // File: contracts/IERC165.sol
360 
361 
362 
363 pragma solidity ^0.8.0;
364 
365 /**
366  * @dev Interface of the ERC165 standard, as defined in the
367  * https://eips.ethereum.org/EIPS/eip-165[EIP].
368  *
369  * Implementers can declare support of contract interfaces, which can then be
370  * queried by others ({ERC165Checker}).
371  *
372  * For an implementation, see {ERC165}.
373  */
374 interface IERC165 {
375     /**
376      * @dev Returns true if this contract implements the interface defined by
377      * `interfaceId`. See the corresponding
378      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
379      * to learn more about how these ids are created.
380      *
381      * This function call must use less than 30 000 gas.
382      */
383     function supportsInterface(bytes4 interfaceId) external view returns (bool);
384 }
385 
386 // File: contracts/ERC165.sol
387 
388 
389 
390 pragma solidity ^0.8.0;
391 
392 
393 /**
394  * @dev Implementation of the {IERC165} interface.
395  *
396  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
397  * for the additional interface id that will be supported. For example:
398  *
399  * ```solidity
400  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
401  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
402  * }
403  * ```
404  *
405  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
406  */
407 abstract contract ERC165 is IERC165 {
408     /**
409      * @dev See {IERC165-supportsInterface}.
410      */
411     function supportsInterface(bytes4 interfaceId)
412         public
413         view
414         virtual
415         override
416         returns (bool)
417     {
418         return interfaceId == type(IERC165).interfaceId;
419     }
420 }
421 
422 // File: contracts/IERC721.sol
423 
424 
425 
426 pragma solidity ^0.8.0;
427 
428 
429 /**
430  * @dev Required interface of an ERC721 compliant contract.
431  */
432 interface IERC721 is IERC165 {
433     /**
434      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
435      */
436     event Transfer(
437         address indexed from,
438         address indexed to,
439         uint256 indexed tokenId
440     );
441 
442     /**
443      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
444      */
445     event Approval(
446         address indexed owner,
447         address indexed approved,
448         uint256 indexed tokenId
449     );
450 
451     /**
452      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
453      */
454     event ApprovalForAll(
455         address indexed owner,
456         address indexed operator,
457         bool approved
458     );
459 
460     /**
461      * @dev Returns the number of tokens in ``owner``'s account.
462      */
463     function balanceOf(address owner) external view returns (uint256 balance);
464 
465     /**
466      * @dev Returns the owner of the `tokenId` token.
467      *
468      * Requirements:
469      *
470      * - `tokenId` must exist.
471      */
472     function ownerOf(uint256 tokenId) external view returns (address owner);
473 
474     /**
475      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
476      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
477      *
478      * Requirements:
479      *
480      * - `from` cannot be the zero address.
481      * - `to` cannot be the zero address.
482      * - `tokenId` token must exist and be owned by `from`.
483      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
484      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
485      *
486      * Emits a {Transfer} event.
487      */
488     function safeTransferFrom(
489         address from,
490         address to,
491         uint256 tokenId
492     ) external;
493 
494     /**
495      * @dev Transfers `tokenId` token from `from` to `to`.
496      *
497      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `tokenId` token must be owned by `from`.
504      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
505      *
506      * Emits a {Transfer} event.
507      */
508     function transferFrom(
509         address from,
510         address to,
511         uint256 tokenId
512     ) external;
513 
514     /**
515      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
516      * The approval is cleared when the token is transferred.
517      *
518      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
519      *
520      * Requirements:
521      *
522      * - The caller must own the token or be an approved operator.
523      * - `tokenId` must exist.
524      *
525      * Emits an {Approval} event.
526      */
527     function approve(address to, uint256 tokenId) external;
528 
529     /**
530      * @dev Returns the account approved for `tokenId` token.
531      *
532      * Requirements:
533      *
534      * - `tokenId` must exist.
535      */
536     function getApproved(uint256 tokenId)
537         external
538         view
539         returns (address operator);
540 
541     /**
542      * @dev Approve or remove `operator` as an operator for the caller.
543      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
544      *
545      * Requirements:
546      *
547      * - The `operator` cannot be the caller.
548      *
549      * Emits an {ApprovalForAll} event.
550      */
551     function setApprovalForAll(address operator, bool _approved) external;
552 
553     /**
554      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
555      *
556      * See {setApprovalForAll}
557      */
558     function isApprovedForAll(address owner, address operator)
559         external
560         view
561         returns (bool);
562 
563     /**
564      * @dev Safely transfers `tokenId` token from `from` to `to`.
565      *
566      * Requirements:
567      *
568      * - `from` cannot be the zero address.
569      * - `to` cannot be the zero address.
570      * - `tokenId` token must exist and be owned by `from`.
571      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
572      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
573      *
574      * Emits a {Transfer} event.
575      */
576     function safeTransferFrom(
577         address from,
578         address to,
579         uint256 tokenId,
580         bytes calldata data
581     ) external;
582 }
583 
584 // File: contracts/IERC721Metadata.sol
585 
586 
587 
588 pragma solidity ^0.8.0;
589 
590 
591 /**
592  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
593  * @dev See https://eips.ethereum.org/EIPS/eip-721
594  */
595 interface IERC721Metadata is IERC721 {
596     /**
597      * @dev Returns the token collection name.
598      */
599     function name() external view returns (string memory);
600 
601     /**
602      * @dev Returns the token collection symbol.
603      */
604     function symbol() external view returns (string memory);
605 
606     /**
607      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
608      */
609     function tokenURI(uint256 tokenId) external view returns (string memory);
610 }
611 
612 // File: contracts/IERC721Enumerable.sol
613 
614 
615 
616 pragma solidity ^0.8.0;
617 
618 
619 /**
620  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
621  * @dev See https://eips.ethereum.org/EIPS/eip-721
622  */
623 interface IERC721Enumerable is IERC721 {
624     /**
625      * @dev Returns the total amount of tokens stored by the contract.
626      */
627     function totalSupply() external view returns (uint256);
628 
629     /**
630      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
631      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
632      */
633     function tokenOfOwnerByIndex(address owner, uint256 index)
634         external
635         view
636         returns (uint256 tokenId);
637 
638     /**
639      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
640      * Use along with {totalSupply} to enumerate all tokens.
641      */
642     function tokenByIndex(uint256 index) external view returns (uint256);
643 }
644 
645 // File: contracts/Context.sol
646 
647 
648 
649 pragma solidity ^0.8.0;
650 
651 /**
652  * @dev Provides information about the current execution context, including the
653  * sender of the transaction and its data. While these are generally available
654  * via msg.sender and msg.data, they should not be accessed in such a direct
655  * manner, since when dealing with meta-transactions the account sending and
656  * paying for execution may not be the actual sender (as far as an application
657  * is concerned).
658  *
659  * This contract is only required for intermediate, library-like contracts.
660  */
661 abstract contract Context {
662     function _msgSender() internal view virtual returns (address) {
663         return msg.sender;
664     }
665 
666     function _msgData() internal view virtual returns (bytes calldata) {
667         return msg.data;
668     }
669 }
670 
671 // File: contracts/ERC721A.sol
672 
673 
674 pragma solidity ^0.8.0;
675 
676 
677 
678 
679 
680 
681 
682 
683 
684 error ApprovalCallerNotOwnerNorApproved();
685 error ApprovalQueryForNonexistentToken();
686 error ApproveToCaller();
687 error ApprovalToCurrentOwner();
688 error BalanceQueryForZeroAddress();
689 error MintedQueryForZeroAddress();
690 error BurnedQueryForZeroAddress();
691 error MintToZeroAddress();
692 error MintZeroQuantity();
693 error OwnerIndexOutOfBounds();
694 error OwnerQueryForNonexistentToken();
695 error TokenIndexOutOfBounds();
696 error TransferCallerNotOwnerNorApproved();
697 error TransferFromIncorrectOwner();
698 error TransferToNonERC721ReceiverImplementer();
699 error TransferToZeroAddress();
700 error URIQueryForNonexistentToken();
701 
702 /**
703  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
704  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
705  *
706  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
707  *
708  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
709  *
710  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
711  */
712 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
713     using Address for address;
714     using Strings for uint256;
715 
716     // Compiler will pack this into a single 256bit word.
717     struct TokenOwnership {
718         // The address of the owner.
719         address addr;
720         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
721         uint64 startTimestamp;
722         // Whether the token has been burned.
723         bool burned;
724     }
725 
726     // Compiler will pack this into a single 256bit word.
727     struct AddressData {
728         // Realistically, 2**64-1 is more than enough.
729         uint64 balance;
730         // Keeps track of mint count with minimal overhead for tokenomics.
731         uint64 numberMinted;
732         // Keeps track of burn count with minimal overhead for tokenomics.
733         uint64 numberBurned;
734     }
735 
736     // Compiler will pack the following 
737     // _currentIndex and _burnCounter into a single 256bit word.
738     
739     // The tokenId of the next token to be minted.
740     uint128 internal _currentIndex;
741 
742     // The number of tokens burned.
743     uint128 internal _burnCounter;
744 
745     // Token name
746     string private _name;
747 
748     // Token symbol
749     string private _symbol;
750 
751     // Mapping from token ID to ownership details
752     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
753     mapping(uint256 => TokenOwnership) internal _ownerships;
754 
755     // Mapping owner address to address data
756     mapping(address => AddressData) private _addressData;
757 
758     // Mapping from token ID to approved address
759     mapping(uint256 => address) private _tokenApprovals;
760 
761     // Mapping from owner to operator approvals
762     mapping(address => mapping(address => bool)) private _operatorApprovals;
763 
764     constructor(string memory name_, string memory symbol_) {
765         _name = name_;
766         _symbol = symbol_;
767     }
768 
769     /**
770      * @dev See {IERC721Enumerable-totalSupply}.
771      */
772     function totalSupply() public view override returns (uint256) {
773         // Counter underflow is impossible as _burnCounter cannot be incremented
774         // more than _currentIndex times
775         unchecked {
776             return _currentIndex - _burnCounter;    
777         }
778     }
779 
780     /**
781      * @dev See {IERC721Enumerable-tokenByIndex}.
782      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
783      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
784      */
785     function tokenByIndex(uint256 index) public view override returns (uint256) {
786         uint256 numMintedSoFar = _currentIndex;
787         uint256 tokenIdsIdx;
788 
789         // Counter overflow is impossible as the loop breaks when
790         // uint256 i is equal to another uint256 numMintedSoFar.
791         unchecked {
792             for (uint256 i; i < numMintedSoFar; i++) {
793                 TokenOwnership memory ownership = _ownerships[i];
794                 if (!ownership.burned) {
795                     if (tokenIdsIdx == index) {
796                         return i;
797                     }
798                     tokenIdsIdx++;
799                 }
800             }
801         }
802         revert TokenIndexOutOfBounds();
803     }
804 
805     /**
806      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
807      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
808      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
809      */
810     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
811         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
812         uint256 numMintedSoFar = _currentIndex;
813         uint256 tokenIdsIdx;
814         address currOwnershipAddr;
815 
816         // Counter overflow is impossible as the loop breaks when
817         // uint256 i is equal to another uint256 numMintedSoFar.
818         unchecked {
819             for (uint256 i; i < numMintedSoFar; i++) {
820                 TokenOwnership memory ownership = _ownerships[i];
821                 if (ownership.burned) {
822                     continue;
823                 }
824                 if (ownership.addr != address(0)) {
825                     currOwnershipAddr = ownership.addr;
826                 }
827                 if (currOwnershipAddr == owner) {
828                     if (tokenIdsIdx == index) {
829                         return i;
830                     }
831                     tokenIdsIdx++;
832                 }
833             }
834         }
835 
836         // Execution should never reach this point.
837         revert();
838     }
839 
840     /**
841      * @dev See {IERC165-supportsInterface}.
842      */
843     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
844         return
845             interfaceId == type(IERC721).interfaceId ||
846             interfaceId == type(IERC721Metadata).interfaceId ||
847             interfaceId == type(IERC721Enumerable).interfaceId ||
848             super.supportsInterface(interfaceId);
849     }
850 
851     /**
852      * @dev See {IERC721-balanceOf}.
853      */
854     function balanceOf(address owner) public view override returns (uint256) {
855         if (owner == address(0)) revert BalanceQueryForZeroAddress();
856         return uint256(_addressData[owner].balance);
857     }
858 
859     function _numberMinted(address owner) internal view returns (uint256) {
860         if (owner == address(0)) revert MintedQueryForZeroAddress();
861         return uint256(_addressData[owner].numberMinted);
862     }
863 
864     function _numberBurned(address owner) internal view returns (uint256) {
865         if (owner == address(0)) revert BurnedQueryForZeroAddress();
866         return uint256(_addressData[owner].numberBurned);
867     }
868 
869     /**
870      * Gas spent here starts off proportional to the maximum mint batch size.
871      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
872      */
873     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
874         uint256 curr = tokenId;
875 
876         unchecked {
877             if (curr < _currentIndex) {
878                 TokenOwnership memory ownership = _ownerships[curr];
879                 if (!ownership.burned) {
880                     if (ownership.addr != address(0)) {
881                         return ownership;
882                     }
883                     // Invariant: 
884                     // There will always be an ownership that has an address and is not burned 
885                     // before an ownership that does not have an address and is not burned.
886                     // Hence, curr will not underflow.
887                     while (true) {
888                         curr--;
889                         ownership = _ownerships[curr];
890                         if (ownership.addr != address(0)) {
891                             return ownership;
892                         }
893                     }
894                 }
895             }
896         }
897         revert OwnerQueryForNonexistentToken();
898     }
899 
900     /**
901      * @dev See {IERC721-ownerOf}.
902      */
903     function ownerOf(uint256 tokenId) public view override returns (address) {
904         return ownershipOf(tokenId).addr;
905     }
906 
907     /**
908      * @dev See {IERC721Metadata-name}.
909      */
910     function name() public view virtual override returns (string memory) {
911         return _name;
912     }
913 
914     /**
915      * @dev See {IERC721Metadata-symbol}.
916      */
917     function symbol() public view virtual override returns (string memory) {
918         return _symbol;
919     }
920 
921     /**
922      * @dev See {IERC721Metadata-tokenURI}.
923      */
924     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
925         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
926 
927         string memory baseURI = _baseURI();
928         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
929     }
930 
931     /**
932      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
933      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
934      * by default, can be overriden in child contracts.
935      */
936     function _baseURI() internal view virtual returns (string memory) {
937         return '';
938     }
939 
940     /**
941      * @dev See {IERC721-approve}.
942      */
943     function approve(address to, uint256 tokenId) public override {
944         address owner = ERC721A.ownerOf(tokenId);
945         if (to == owner) revert ApprovalToCurrentOwner();
946 
947         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
948             revert ApprovalCallerNotOwnerNorApproved();
949         }
950 
951         _approve(to, tokenId, owner);
952     }
953 
954     /**
955      * @dev See {IERC721-getApproved}.
956      */
957     function getApproved(uint256 tokenId) public view override returns (address) {
958         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
959 
960         return _tokenApprovals[tokenId];
961     }
962 
963     /**
964      * @dev See {IERC721-setApprovalForAll}.
965      */
966     function setApprovalForAll(address operator, bool approved) public override {
967         if (operator == _msgSender()) revert ApproveToCaller();
968 
969         _operatorApprovals[_msgSender()][operator] = approved;
970         emit ApprovalForAll(_msgSender(), operator, approved);
971     }
972 
973     /**
974      * @dev See {IERC721-isApprovedForAll}.
975      */
976     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
977         return _operatorApprovals[owner][operator];
978     }
979 
980     /**
981      * @dev See {IERC721-transferFrom}.
982      */
983     function transferFrom(
984         address from,
985         address to,
986         uint256 tokenId
987     ) public virtual override {
988         _transfer(from, to, tokenId);
989     }
990 
991     /**
992      * @dev See {IERC721-safeTransferFrom}.
993      */
994     function safeTransferFrom(
995         address from,
996         address to,
997         uint256 tokenId
998     ) public virtual override {
999         safeTransferFrom(from, to, tokenId, '');
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-safeTransferFrom}.
1004      */
1005     function safeTransferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId,
1009         bytes memory _data
1010     ) public virtual override {
1011         _transfer(from, to, tokenId);
1012         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1013             revert TransferToNonERC721ReceiverImplementer();
1014         }
1015     }
1016 
1017     /**
1018      * @dev Returns whether `tokenId` exists.
1019      *
1020      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1021      *
1022      * Tokens start existing when they are minted (`_mint`),
1023      */
1024     function _exists(uint256 tokenId) internal view returns (bool) {
1025         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1026     }
1027 
1028     function _safeMint(address to, uint256 quantity) internal {
1029         _safeMint(to, quantity, '');
1030     }
1031 
1032     /**
1033      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1034      *
1035      * Requirements:
1036      *
1037      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1038      * - `quantity` must be greater than 0.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function _safeMint(
1043         address to,
1044         uint256 quantity,
1045         bytes memory _data
1046     ) internal {
1047         _mint(to, quantity, _data, true);
1048     }
1049 
1050     /**
1051      * @dev Mints `quantity` tokens and transfers them to `to`.
1052      *
1053      * Requirements:
1054      *
1055      * - `to` cannot be the zero address.
1056      * - `quantity` must be greater than 0.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function _mint(
1061         address to,
1062         uint256 quantity,
1063         bytes memory _data,
1064         bool safe
1065     ) internal {
1066         uint256 startTokenId = _currentIndex;
1067         if (to == address(0)) revert MintToZeroAddress();
1068         if (quantity == 0) revert MintZeroQuantity();
1069 
1070         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1071 
1072         // Overflows are incredibly unrealistic.
1073         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1074         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1075         unchecked {
1076             _addressData[to].balance += uint64(quantity);
1077             _addressData[to].numberMinted += uint64(quantity);
1078 
1079             _ownerships[startTokenId].addr = to;
1080             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1081 
1082             uint256 updatedIndex = startTokenId;
1083 
1084             for (uint256 i; i < quantity; i++) {
1085                 emit Transfer(address(0), to, updatedIndex);
1086                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1087                     revert TransferToNonERC721ReceiverImplementer();
1088                 }
1089                 updatedIndex++;
1090             }
1091 
1092             _currentIndex = uint128(updatedIndex);
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
1112         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1113 
1114         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1115             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1116             getApproved(tokenId) == _msgSender());
1117 
1118         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1119         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1120         if (to == address(0)) revert TransferToZeroAddress();
1121 
1122         _beforeTokenTransfers(from, to, tokenId, 1);
1123 
1124         // Clear approvals from the previous owner
1125         _approve(address(0), tokenId, prevOwnership.addr);
1126 
1127         // Underflow of the sender's balance is impossible because we check for
1128         // ownership above and the recipient's balance can't realistically overflow.
1129         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1130         unchecked {
1131             _addressData[from].balance -= 1;
1132             _addressData[to].balance += 1;
1133 
1134             _ownerships[tokenId].addr = to;
1135             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1136 
1137             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1138             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1139             uint256 nextTokenId = tokenId + 1;
1140             if (_ownerships[nextTokenId].addr == address(0)) {
1141                 // This will suffice for checking _exists(nextTokenId),
1142                 // as a burned slot cannot contain the zero address.
1143                 if (nextTokenId < _currentIndex) {
1144                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1145                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1146                 }
1147             }
1148         }
1149 
1150         emit Transfer(from, to, tokenId);
1151         _afterTokenTransfers(from, to, tokenId, 1);
1152     }
1153 
1154     /**
1155      * @dev Destroys `tokenId`.
1156      * The approval is cleared when the token is burned.
1157      *
1158      * Requirements:
1159      *
1160      * - `tokenId` must exist.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function _burn(uint256 tokenId) internal virtual {
1165         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1166 
1167         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1168 
1169         // Clear approvals from the previous owner
1170         _approve(address(0), tokenId, prevOwnership.addr);
1171 
1172         // Underflow of the sender's balance is impossible because we check for
1173         // ownership above and the recipient's balance can't realistically overflow.
1174         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1175         unchecked {
1176             _addressData[prevOwnership.addr].balance -= 1;
1177             _addressData[prevOwnership.addr].numberBurned += 1;
1178 
1179             // Keep track of who burned the token, and the timestamp of burning.
1180             _ownerships[tokenId].addr = prevOwnership.addr;
1181             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1182             _ownerships[tokenId].burned = true;
1183 
1184             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1185             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1186             uint256 nextTokenId = tokenId + 1;
1187             if (_ownerships[nextTokenId].addr == address(0)) {
1188                 // This will suffice for checking _exists(nextTokenId),
1189                 // as a burned slot cannot contain the zero address.
1190                 if (nextTokenId < _currentIndex) {
1191                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1192                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1193                 }
1194             }
1195         }
1196 
1197         emit Transfer(prevOwnership.addr, address(0), tokenId);
1198         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1199 
1200         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1201         unchecked { 
1202             _burnCounter++;
1203         }
1204     }
1205 
1206     /**
1207      * @dev Approve `to` to operate on `tokenId`
1208      *
1209      * Emits a {Approval} event.
1210      */
1211     function _approve(
1212         address to,
1213         uint256 tokenId,
1214         address owner
1215     ) private {
1216         _tokenApprovals[tokenId] = to;
1217         emit Approval(owner, to, tokenId);
1218     }
1219 
1220     /**
1221      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1222      * The call is not executed if the target address is not a contract.
1223      *
1224      * @param from address representing the previous owner of the given token ID
1225      * @param to target address that will receive the tokens
1226      * @param tokenId uint256 ID of the token to be transferred
1227      * @param _data bytes optional data to send along with the call
1228      * @return bool whether the call correctly returned the expected magic value
1229      */
1230     function _checkOnERC721Received(
1231         address from,
1232         address to,
1233         uint256 tokenId,
1234         bytes memory _data
1235     ) private returns (bool) {
1236         if (to.isContract()) {
1237             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1238                 return retval == IERC721Receiver(to).onERC721Received.selector;
1239             } catch (bytes memory reason) {
1240                 if (reason.length == 0) {
1241                     revert TransferToNonERC721ReceiverImplementer();
1242                 } else {
1243                     assembly {
1244                         revert(add(32, reason), mload(reason))
1245                     }
1246                 }
1247             }
1248         } else {
1249             return true;
1250         }
1251     }
1252 
1253     /**
1254      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1255      * And also called before burning one token.
1256      *
1257      * startTokenId - the first token id to be transferred
1258      * quantity - the amount to be transferred
1259      *
1260      * Calling conditions:
1261      *
1262      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1263      * transferred to `to`.
1264      * - When `from` is zero, `tokenId` will be minted for `to`.
1265      * - When `to` is zero, `tokenId` will be burned by `from`.
1266      * - `from` and `to` are never both zero.
1267      */
1268     function _beforeTokenTransfers(
1269         address from,
1270         address to,
1271         uint256 startTokenId,
1272         uint256 quantity
1273     ) internal virtual {}
1274 
1275     /**
1276      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1277      * minting.
1278      * And also called after one token has been burned.
1279      *
1280      * startTokenId - the first token id to be transferred
1281      * quantity - the amount to be transferred
1282      *
1283      * Calling conditions:
1284      *
1285      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1286      * transferred to `to`.
1287      * - When `from` is zero, `tokenId` has been minted for `to`.
1288      * - When `to` is zero, `tokenId` has been burned by `from`.
1289      * - `from` and `to` are never both zero.
1290      */
1291     function _afterTokenTransfers(
1292         address from,
1293         address to,
1294         uint256 startTokenId,
1295         uint256 quantity
1296     ) internal virtual {}
1297 }
1298 // File: contracts/Ownable.sol
1299 
1300 
1301 
1302 pragma solidity ^0.8.0;
1303 
1304 
1305 /**
1306  * @dev Contract module which provides a basic access control mechanism, where
1307  * there is an account (an owner) that can be granted exclusive access to
1308  * specific functions.
1309  *
1310  * By default, the owner account will be the one that deploys the contract. This
1311  * can later be changed with {transferOwnership}.
1312  *
1313  * This module is used through inheritance. It will make available the modifier
1314  * `onlyOwner`, which can be applied to your functions to restrict their use to
1315  * the owner.
1316  */
1317 abstract contract Ownable is Context {
1318     address private _owner;
1319 
1320     event OwnershipTransferred(
1321         address indexed previousOwner,
1322         address indexed newOwner
1323     );
1324 
1325     /**
1326      * @dev Initializes the contract setting the deployer as the initial owner.
1327      */
1328     constructor() {
1329         _setOwner(_msgSender());
1330     }
1331 
1332     /**
1333      * @dev Returns the address of the current owner.
1334      */
1335     function owner() public view virtual returns (address) {
1336         return _owner;
1337     }
1338 
1339     /**
1340      * @dev Throws if called by any account other than the owner.
1341      */
1342     modifier onlyOwner() {
1343         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1344         _;
1345     }
1346 
1347     /**
1348      * @dev Leaves the contract without owner. It will not be possible to call
1349      * `onlyOwner` functions anymore. Can only be called by the current owner.
1350      *
1351      * NOTE: Renouncing ownership will leave the contract without an owner,
1352      * thereby removing any functionality that is only available to the owner.
1353      */
1354     function renounceOwnership() public virtual onlyOwner {
1355         _setOwner(address(0));
1356     }
1357 
1358     /**
1359      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1360      * Can only be called by the current owner.
1361      */
1362     function transferOwnership(address newOwner) public virtual onlyOwner {
1363         require(
1364             newOwner != address(0),
1365             "Ownable: new owner is the zero address"
1366         );
1367         _setOwner(newOwner);
1368     }
1369 
1370     function _setOwner(address newOwner) private {
1371         address oldOwner = _owner;
1372         _owner = newOwner;
1373         emit OwnershipTransferred(oldOwner, newOwner);
1374     }
1375 }
1376 
1377 // File: contracts/datatime.sol
1378 
1379 
1380 
1381 pragma solidity ^0.8.0;
1382 
1383 
1384 
1385 contract PlagueClub is ERC721A, Ownable {
1386 
1387     uint256 public price = 0.005 ether;
1388     uint256 public maxTotalSupply = 6666;
1389     uint256 public saleStartTime = 1658154600;
1390     string private baseURI;
1391     mapping(address => uint256) public freePlagueClaimed;
1392 
1393     constructor() ERC721A("Plague Club", "PLAGUE") {
1394         saleStartTime = block.timestamp;
1395     }
1396 
1397     modifier mintableSupply(uint256 _quantity) {
1398         require(
1399             _quantity > 0,
1400             "You need to mint at least 1 NFT."
1401         );
1402         require(
1403             totalSupply() + _quantity <= maxTotalSupply,
1404             "Over maximum supply."
1405         );
1406         _;
1407     }
1408 
1409     modifier saleActive() {
1410         require(
1411             saleStartTime <= block.timestamp,
1412             "Not start yet."
1413         );
1414         _;
1415     }
1416 
1417     function mintPlagues(uint256 quantity)
1418         external
1419         payable
1420         saleActive
1421         mintableSupply(quantity) 
1422     {
1423         uint256 payAmount = freePlagueClaimed[msg.sender] + quantity <= 3 ? 0: freePlagueClaimed[msg.sender] + quantity - 3;
1424 
1425         freePlagueClaimed[msg.sender] = freePlagueClaimed[msg.sender] + quantity <= 3 ? freePlagueClaimed[msg.sender] + quantity : 3;
1426         require(msg.value >= payAmount * price, "Insufficent funds.");
1427         _safeMint(msg.sender, quantity);
1428     }
1429 
1430     function setBaseURI(string memory baseURI_) external onlyOwner {
1431         baseURI = baseURI_;
1432     }
1433 
1434     function _baseURI() internal view virtual override returns (string memory) {
1435         return baseURI;
1436     }
1437 
1438 
1439     function setMintPrice(uint256 _price) external onlyOwner {
1440         price = _price;
1441     }
1442 
1443     function setSaleTime(uint256 _time) external onlyOwner {
1444         saleStartTime = _time;
1445     }
1446 
1447     function setMaxSupply(uint256 newSupply) external onlyOwner {
1448         require(newSupply < maxTotalSupply);
1449         maxTotalSupply = newSupply;
1450     }
1451 
1452 
1453     function withdraw() external onlyOwner {
1454         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1455         require(success, "Transfer failed.");
1456     }
1457 }