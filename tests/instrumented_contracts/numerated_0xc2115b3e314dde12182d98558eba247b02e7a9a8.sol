1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-06
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-07-02
7 */
8 
9 // SPDX-License-Identifier: MIT
10 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Interface of the ERC165 standard, as defined in the
16  * https://eips.ethereum.org/EIPS/eip-165[EIP].
17  *
18  * Implementers can declare support of contract interfaces, which can then be
19  * queried by others ({ERC165Checker}).
20  *
21  * For an implementation, see {ERC165}.
22  */
23 interface IERC165 {
24     /**
25      * @dev Returns true if this contract implements the interface defined by
26      * `interfaceId`. See the corresponding
27      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
28      * to learn more about how these ids are created.
29      *
30      * This function call must use less than 30 000 gas.
31      */
32     function supportsInterface(bytes4 interfaceId) external view returns (bool);
33 }
34 
35 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
46     event Transfer(
47         address indexed from,
48         address indexed to,
49         uint256 indexed tokenId
50     );
51 
52     /**
53      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
54      */
55     event Approval(
56         address indexed owner,
57         address indexed approved,
58         uint256 indexed tokenId
59     );
60 
61     /**
62      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
63      */
64     event ApprovalForAll(
65         address indexed owner,
66         address indexed operator,
67         bool approved
68     );
69 
70     /**
71      * @dev Returns the number of tokens in ``owner``'s account.
72      */
73     function balanceOf(address owner) external view returns (uint256 balance);
74 
75     /**
76      * @dev Returns the owner of the `tokenId` token.
77      *
78      * Requirements:
79      *
80      * - `tokenId` must exist.
81      */
82     function ownerOf(uint256 tokenId) external view returns (address owner);
83 
84     /**
85      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
86      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must exist and be owned by `from`.
93      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
94      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
95      *
96      * Emits a {Transfer} event.
97      */
98     function safeTransferFrom(
99         address from,
100         address to,
101         uint256 tokenId
102     ) external;
103 
104     /**
105      * @dev Transfers `tokenId` token from `from` to `to`.
106      *
107      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
108      *
109      * Requirements:
110      *
111      * - `from` cannot be the zero address.
112      * - `to` cannot be the zero address.
113      * - `tokenId` token must be owned by `from`.
114      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transferFrom(
119         address from,
120         address to,
121         uint256 tokenId
122     ) external;
123 
124     /**
125      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
126      * The approval is cleared when the token is transferred.
127      *
128      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
129      *
130      * Requirements:
131      *
132      * - The caller must own the token or be an approved operator.
133      * - `tokenId` must exist.
134      *
135      * Emits an {Approval} event.
136      */
137     function approve(address to, uint256 tokenId) external;
138 
139     /**
140      * @dev Returns the account approved for `tokenId` token.
141      *
142      * Requirements:
143      *
144      * - `tokenId` must exist.
145      */
146     function getApproved(uint256 tokenId)
147         external
148         view
149         returns (address operator);
150 
151     /**
152      * @dev Approve or remove `operator` as an operator for the caller.
153      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
154      *
155      * Requirements:
156      *
157      * - The `operator` cannot be the caller.
158      *
159      * Emits an {ApprovalForAll} event.
160      */
161     function setApprovalForAll(address operator, bool _approved) external;
162 
163     /**
164      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
165      *
166      * See {setApprovalForAll}
167      */
168     function isApprovedForAll(address owner, address operator)
169         external
170         view
171         returns (bool);
172 
173     /**
174      * @dev Safely transfers `tokenId` token from `from` to `to`.
175      *
176      * Requirements:
177      *
178      * - `from` cannot be the zero address.
179      * - `to` cannot be the zero address.
180      * - `tokenId` token must exist and be owned by `from`.
181      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
182      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
183      *
184      * Emits a {Transfer} event.
185      */
186     function safeTransferFrom(
187         address from,
188         address to,
189         uint256 tokenId,
190         bytes calldata data
191     ) external;
192 }
193 
194 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @title ERC721 token receiver interface
200  * @dev Interface for any contract that wants to support safeTransfers
201  * from ERC721 asset contracts.
202  */
203 interface IERC721Receiver {
204     /**
205      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
206      * by `operator` from `from`, this function is called.
207      *
208      * It must return its Solidity selector to confirm the token transfer.
209      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
210      *
211      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
212      */
213     function onERC721Received(
214         address operator,
215         address from,
216         uint256 tokenId,
217         bytes calldata data
218     ) external returns (bytes4);
219 }
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
246 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
247 
248 pragma solidity ^0.8.0;
249 
250 /**
251  * @dev Implementation of the {IERC165} interface.
252  *
253  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
254  * for the additional interface id that will be supported. For example:
255  *
256  * ```solidity
257  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
258  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
259  * }
260  * ```
261  *
262  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
263  */
264 abstract contract ERC165 is IERC165 {
265     /**
266      * @dev See {IERC165-supportsInterface}.
267      */
268     function supportsInterface(bytes4 interfaceId)
269         public
270         view
271         virtual
272         override
273         returns (bool)
274     {
275         return interfaceId == type(IERC165).interfaceId;
276     }
277 }
278 
279 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
280 
281 pragma solidity ^0.8.0;
282 
283 /**
284  * @dev Collection of functions related to the address type
285  */
286 library Address {
287     /**
288      * @dev Returns true if `account` is a contract.
289      *
290      * [IMPORTANT]
291      * ====
292      * It is unsafe to assume that an address for which this function returns
293      * false is an externally-owned account (EOA) and not a contract.
294      *
295      * Among others, `isContract` will return false for the following
296      * types of addresses:
297      *
298      *  - an externally-owned account
299      *  - a contract in construction
300      *  - an address where a contract will be created
301      *  - an address where a contract lived, but was destroyed
302      * ====
303      */
304     function isContract(address account) internal view returns (bool) {
305         // This method relies on extcodesize, which returns 0 for contracts in
306         // construction, since the code is only stored at the end of the
307         // constructor execution.
308 
309         uint256 size;
310         assembly {
311             size := extcodesize(account)
312         }
313         return size > 0;
314     }
315 
316     /**
317      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
318      * `recipient`, forwarding all available gas and reverting on errors.
319      *
320      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
321      * of certain opcodes, possibly making contracts go over the 2300 gas limit
322      * imposed by `transfer`, making them unable to receive funds via
323      * `transfer`. {sendValue} removes this limitation.
324      *
325      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
326      *
327      * IMPORTANT: because control is transferred to `recipient`, care must be
328      * taken to not create reentrancy vulnerabilities. Consider using
329      * {ReentrancyGuard} or the
330      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
331      */
332     function sendValue(address payable recipient, uint256 amount) internal {
333         require(
334             address(this).balance >= amount,
335             "Address: insufficient balance"
336         );
337 
338         (bool success, ) = recipient.call{value: amount}("");
339         require(
340             success,
341             "Address: unable to send value, recipient may have reverted"
342         );
343     }
344 
345     /**
346      * @dev Performs a Solidity function call using a low level `call`. A
347      * plain `call` is an unsafe replacement for a function call: use this
348      * function instead.
349      *
350      * If `target` reverts with a revert reason, it is bubbled up by this
351      * function (like regular Solidity function calls).
352      *
353      * Returns the raw returned data. To convert to the expected return value,
354      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
355      *
356      * Requirements:
357      *
358      * - `target` must be a contract.
359      * - calling `target` with `data` must not revert.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(address target, bytes memory data)
364         internal
365         returns (bytes memory)
366     {
367         return functionCall(target, data, "Address: low-level call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
372      * `errorMessage` as a fallback revert reason when `target` reverts.
373      *
374      * _Available since v3.1._
375      */
376     function functionCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         return functionCallWithValue(target, data, 0, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but also transferring `value` wei to `target`.
387      *
388      * Requirements:
389      *
390      * - the calling contract must have an ETH balance of at least `value`.
391      * - the called Solidity function must be `payable`.
392      *
393      * _Available since v3.1._
394      */
395     function functionCallWithValue(
396         address target,
397         bytes memory data,
398         uint256 value
399     ) internal returns (bytes memory) {
400         return
401             functionCallWithValue(
402                 target,
403                 data,
404                 value,
405                 "Address: low-level call with value failed"
406             );
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
411      * with `errorMessage` as a fallback revert reason when `target` reverts.
412      *
413      * _Available since v3.1._
414      */
415     function functionCallWithValue(
416         address target,
417         bytes memory data,
418         uint256 value,
419         string memory errorMessage
420     ) internal returns (bytes memory) {
421         require(
422             address(this).balance >= value,
423             "Address: insufficient balance for call"
424         );
425         require(isContract(target), "Address: call to non-contract");
426 
427         (bool success, bytes memory returndata) = target.call{value: value}(
428             data
429         );
430         return verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
435      * but performing a static call.
436      *
437      * _Available since v3.3._
438      */
439     function functionStaticCall(address target, bytes memory data)
440         internal
441         view
442         returns (bytes memory)
443     {
444         return
445             functionStaticCall(
446                 target,
447                 data,
448                 "Address: low-level static call failed"
449             );
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454      * but performing a static call.
455      *
456      * _Available since v3.3._
457      */
458     function functionStaticCall(
459         address target,
460         bytes memory data,
461         string memory errorMessage
462     ) internal view returns (bytes memory) {
463         require(isContract(target), "Address: static call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.staticcall(data);
466         return verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but performing a delegate call.
472      *
473      * _Available since v3.4._
474      */
475     function functionDelegateCall(address target, bytes memory data)
476         internal
477         returns (bytes memory)
478     {
479         return
480             functionDelegateCall(
481                 target,
482                 data,
483                 "Address: low-level delegate call failed"
484             );
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
489      * but performing a delegate call.
490      *
491      * _Available since v3.4._
492      */
493     function functionDelegateCall(
494         address target,
495         bytes memory data,
496         string memory errorMessage
497     ) internal returns (bytes memory) {
498         require(isContract(target), "Address: delegate call to non-contract");
499 
500         (bool success, bytes memory returndata) = target.delegatecall(data);
501         return verifyCallResult(success, returndata, errorMessage);
502     }
503 
504     /**
505      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
506      * revert reason using the provided one.
507      *
508      * _Available since v4.3._
509      */
510     function verifyCallResult(
511         bool success,
512         bytes memory returndata,
513         string memory errorMessage
514     ) internal pure returns (bytes memory) {
515         if (success) {
516             return returndata;
517         } else {
518             // Look for revert reason and bubble it up if present
519             if (returndata.length > 0) {
520                 // The easiest way to bubble the revert reason is using memory via assembly
521 
522                 assembly {
523                     let returndata_size := mload(returndata)
524                     revert(add(32, returndata), returndata_size)
525                 }
526             } else {
527                 revert(errorMessage);
528             }
529         }
530     }
531 }
532 
533 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 /**
538  * @dev Provides information about the current execution context, including the
539  * sender of the transaction and its data. While these are generally available
540  * via msg.sender and msg.data, they should not be accessed in such a direct
541  * manner, since when dealing with meta-transactions the account sending and
542  * paying for execution may not be the actual sender (as far as an application
543  * is concerned).
544  *
545  * This contract is only required for intermediate, library-like contracts.
546  */
547 abstract contract Context {
548     function _msgSender() internal view virtual returns (address) {
549         return msg.sender;
550     }
551 
552     function _msgData() internal view virtual returns (bytes calldata) {
553         return msg.data;
554     }
555 }
556 
557 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 /**
562  * @dev String operations.
563  */
564 library Strings {
565     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
566 
567     /**
568      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
569      */
570     function toString(uint256 value) internal pure returns (string memory) {
571         // Inspired by OraclizeAPI's implementation - MIT licence
572         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
573 
574         if (value == 0) {
575             return "0";
576         }
577         uint256 temp = value;
578         uint256 digits;
579         while (temp != 0) {
580             digits++;
581             temp /= 10;
582         }
583         bytes memory buffer = new bytes(digits);
584         while (value != 0) {
585             digits -= 1;
586             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
587             value /= 10;
588         }
589         return string(buffer);
590     }
591 
592     /**
593      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
594      */
595     function toHexString(uint256 value) internal pure returns (string memory) {
596         if (value == 0) {
597             return "0x00";
598         }
599         uint256 temp = value;
600         uint256 length = 0;
601         while (temp != 0) {
602             length++;
603             temp >>= 8;
604         }
605         return toHexString(value, length);
606     }
607 
608     /**
609      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
610      */
611     function toHexString(uint256 value, uint256 length)
612         internal
613         pure
614         returns (string memory)
615     {
616         bytes memory buffer = new bytes(2 * length + 2);
617         buffer[0] = "0";
618         buffer[1] = "x";
619         for (uint256 i = 2 * length + 1; i > 1; --i) {
620             buffer[i] = _HEX_SYMBOLS[value & 0xf];
621             value >>= 4;
622         }
623         require(value == 0, "Strings: hex length insufficient");
624         return string(buffer);
625     }
626 }
627 
628 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
629 
630 pragma solidity ^0.8.0;
631 
632 /**
633  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
634  * @dev See https://eips.ethereum.org/EIPS/eip-721
635  */
636 interface IERC721Enumerable is IERC721 {
637     /**
638      * @dev Returns the total amount of tokens stored by the contract.
639      */
640     function totalSupply() external view returns (uint256);
641 
642     /**
643      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
644      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
645      */
646     function tokenOfOwnerByIndex(address owner, uint256 index)
647         external
648         view
649         returns (uint256 tokenId);
650 
651     /**
652      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
653      * Use along with {totalSupply} to enumerate all tokens.
654      */
655     function tokenByIndex(uint256 index) external view returns (uint256);
656 }
657 
658 pragma solidity ^0.8.0;
659 
660 /**
661  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
662  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
663  *
664  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
665  *
666  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
667  *
668  * Does not support burning tokens to address(0).
669  */
670 contract ERC721A is
671   Context,
672   ERC165,
673   IERC721,
674   IERC721Metadata,
675   IERC721Enumerable
676 {
677   using Address for address;
678   using Strings for uint256;
679 
680   struct TokenOwnership {
681     address addr;
682     uint64 startTimestamp;
683   }
684 
685   struct AddressData {
686     uint128 balance;
687     uint128 numberMinted;
688   }
689 
690   uint256 private currentIndex = 0;
691 
692   uint256 internal immutable collectionSize;
693   uint256 internal immutable maxBatchSize;
694 
695   // Token name
696   string private _name;
697 
698   // Token symbol
699   string private _symbol;
700 
701   // Mapping from token ID to ownership details
702   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
703   mapping(uint256 => TokenOwnership) private _ownerships;
704 
705   // Mapping owner address to address data
706   mapping(address => AddressData) private _addressData;
707 
708   // Mapping from token ID to approved address
709   mapping(uint256 => address) private _tokenApprovals;
710 
711   // Mapping from owner to operator approvals
712   mapping(address => mapping(address => bool)) private _operatorApprovals;
713 
714   /**
715    * @dev
716    * `maxBatchSize` refers to how much a minter can mint at a time.
717    * `collectionSize_` refers to how many tokens are in the collection.
718    */
719   constructor(
720     string memory name_,
721     string memory symbol_,
722     uint256 maxBatchSize_,
723     uint256 collectionSize_
724   ) {
725     require(
726       collectionSize_ > 0,
727       "ERC721A: collection must have a nonzero supply"
728     );
729     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
730     _name = name_;
731     _symbol = symbol_;
732     maxBatchSize = maxBatchSize_;
733     collectionSize = collectionSize_;
734   }
735 
736   /**
737    * @dev See {IERC721Enumerable-totalSupply}.
738    */
739   function totalSupply() public view override returns (uint256) {
740     return currentIndex;
741   }
742 
743   /**
744    * @dev See {IERC721Enumerable-tokenByIndex}.
745    */
746   function tokenByIndex(uint256 index) public view override returns (uint256) {
747     require(index < totalSupply(), "ERC721A: global index out of bounds");
748     return index;
749   }
750 
751   /**
752    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
753    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
754    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
755    */
756   function tokenOfOwnerByIndex(address owner, uint256 index)
757     public
758     view
759     override
760     returns (uint256)
761   {
762     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
763     uint256 numMintedSoFar = totalSupply();
764     uint256 tokenIdsIdx = 0;
765     address currOwnershipAddr = address(0);
766     for (uint256 i = 0; i < numMintedSoFar; i++) {
767       TokenOwnership memory ownership = _ownerships[i];
768       if (ownership.addr != address(0)) {
769         currOwnershipAddr = ownership.addr;
770       }
771       if (currOwnershipAddr == owner) {
772         if (tokenIdsIdx == index) {
773           return i;
774         }
775         tokenIdsIdx++;
776       }
777     }
778     revert("ERC721A: unable to get token of owner by index");
779   }
780 
781   /**
782    * @dev See {IERC165-supportsInterface}.
783    */
784   function supportsInterface(bytes4 interfaceId)
785     public
786     view
787     virtual
788     override(ERC165, IERC165)
789     returns (bool)
790   {
791     return
792       interfaceId == type(IERC721).interfaceId ||
793       interfaceId == type(IERC721Metadata).interfaceId ||
794       interfaceId == type(IERC721Enumerable).interfaceId ||
795       super.supportsInterface(interfaceId);
796   }
797 
798   /**
799    * @dev See {IERC721-balanceOf}.
800    */
801   function balanceOf(address owner) public view override returns (uint256) {
802     require(owner != address(0), "ERC721A: balance query for the zero address");
803     return uint256(_addressData[owner].balance);
804   }
805 
806   function _numberMinted(address owner) internal view returns (uint256) {
807     require(
808       owner != address(0),
809       "ERC721A: number minted query for the zero address"
810     );
811     return uint256(_addressData[owner].numberMinted);
812   }
813 
814   function ownershipOf(uint256 tokenId)
815     internal
816     view
817     returns (TokenOwnership memory)
818   {
819     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
820 
821     uint256 lowestTokenToCheck;
822     if (tokenId >= maxBatchSize) {
823       lowestTokenToCheck = tokenId - maxBatchSize + 1;
824     }
825 
826     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
827       TokenOwnership memory ownership = _ownerships[curr];
828       if (ownership.addr != address(0)) {
829         return ownership;
830       }
831     }
832 
833     revert("ERC721A: unable to determine the owner of token");
834   }
835 
836   /**
837    * @dev See {IERC721-ownerOf}.
838    */
839   function ownerOf(uint256 tokenId) public view override returns (address) {
840     return ownershipOf(tokenId).addr;
841   }
842 
843   /**
844    * @dev See {IERC721Metadata-name}.
845    */
846   function name() public view virtual override returns (string memory) {
847     return _name;
848   }
849 
850   /**
851    * @dev See {IERC721Metadata-symbol}.
852    */
853   function symbol() public view virtual override returns (string memory) {
854     return _symbol;
855   }
856 
857   /**
858    * @dev See {IERC721Metadata-tokenURI}.
859    */
860   function tokenURI(uint256 tokenId)
861     public
862     view
863     virtual
864     override
865     returns (string memory)
866   {
867     require(
868       _exists(tokenId),
869       "ERC721Metadata: URI query for nonexistent token"
870     );
871 
872     string memory baseURI = _baseURI();
873     return
874       bytes(baseURI).length > 0
875         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
876         : "";
877   }
878 
879   /**
880    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
881    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
882    * by default, can be overriden in child contracts.
883    */
884   function _baseURI() internal view virtual returns (string memory) {
885     return "";
886   }
887 
888   /**
889    * @dev See {IERC721-approve}.
890    */
891   function approve(address to, uint256 tokenId) public override {
892     address owner = ERC721A.ownerOf(tokenId);
893     require(to != owner, "ERC721A: approval to current owner");
894 
895     require(
896       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
897       "ERC721A: approve caller is not owner nor approved for all"
898     );
899 
900     _approve(to, tokenId, owner);
901   }
902 
903   /**
904    * @dev See {IERC721-getApproved}.
905    */
906   function getApproved(uint256 tokenId) public view override returns (address) {
907     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
908 
909     return _tokenApprovals[tokenId];
910   }
911 
912   /**
913    * @dev See {IERC721-setApprovalForAll}.
914    */
915   function setApprovalForAll(address operator, bool approved) public override {
916     require(operator != _msgSender(), "ERC721A: approve to caller");
917 
918     _operatorApprovals[_msgSender()][operator] = approved;
919     emit ApprovalForAll(_msgSender(), operator, approved);
920   }
921 
922   /**
923    * @dev See {IERC721-isApprovedForAll}.
924    */
925   function isApprovedForAll(address owner, address operator)
926     public
927     view
928     virtual
929     override
930     returns (bool)
931   {
932     return _operatorApprovals[owner][operator];
933   }
934 
935   /**
936    * @dev See {IERC721-transferFrom}.
937    */
938   function transferFrom(
939     address from,
940     address to,
941     uint256 tokenId
942   ) public override {
943     _transfer(from, to, tokenId);
944   }
945 
946   /**
947    * @dev See {IERC721-safeTransferFrom}.
948    */
949   function safeTransferFrom(
950     address from,
951     address to,
952     uint256 tokenId
953   ) public override {
954     safeTransferFrom(from, to, tokenId, "");
955   }
956 
957   /**
958    * @dev See {IERC721-safeTransferFrom}.
959    */
960   function safeTransferFrom(
961     address from,
962     address to,
963     uint256 tokenId,
964     bytes memory _data
965   ) public override {
966     _transfer(from, to, tokenId);
967     require(
968       _checkOnERC721Received(from, to, tokenId, _data),
969       "ERC721A: transfer to non ERC721Receiver implementer"
970     );
971   }
972 
973   /**
974    * @dev Returns whether `tokenId` exists.
975    *
976    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
977    *
978    * Tokens start existing when they are minted (`_mint`),
979    */
980   function _exists(uint256 tokenId) internal view returns (bool) {
981     return tokenId < currentIndex;
982   }
983 
984   function _safeMint(address to, uint256 quantity) internal {
985     _safeMint(to, quantity, "");
986   }
987 
988   /**
989    * @dev Mints `quantity` tokens and transfers them to `to`.
990    *
991    * Requirements:
992    *
993    * - there must be `quantity` tokens remaining unminted in the total collection.
994    * - `to` cannot be the zero address.
995    * - `quantity` cannot be larger than the max batch size.
996    *
997    * Emits a {Transfer} event.
998    */
999   function _safeMint(
1000     address to,
1001     uint256 quantity,
1002     bytes memory _data
1003   ) internal {
1004     uint256 startTokenId = currentIndex;
1005     require(to != address(0), "ERC721A: mint to the zero address");
1006     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1007     require(!_exists(startTokenId), "ERC721A: token already minted");
1008     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1009 
1010     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1011 
1012     AddressData memory addressData = _addressData[to];
1013     _addressData[to] = AddressData(
1014       addressData.balance + uint128(quantity),
1015       addressData.numberMinted + uint128(quantity)
1016     );
1017     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1018 
1019     uint256 updatedIndex = startTokenId;
1020 
1021     for (uint256 i = 0; i < quantity; i++) {
1022       emit Transfer(address(0), to, updatedIndex);
1023       require(
1024         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1025         "ERC721A: transfer to non ERC721Receiver implementer"
1026       );
1027       updatedIndex++;
1028     }
1029 
1030     currentIndex = updatedIndex;
1031     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1032   }
1033 
1034   /**
1035    * @dev Transfers `tokenId` from `from` to `to`.
1036    *
1037    * Requirements:
1038    *
1039    * - `to` cannot be the zero address.
1040    * - `tokenId` token must be owned by `from`.
1041    *
1042    * Emits a {Transfer} event.
1043    */
1044   function _transfer(
1045     address from,
1046     address to,
1047     uint256 tokenId
1048   ) private {
1049     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1050 
1051     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1052       getApproved(tokenId) == _msgSender() ||
1053       isApprovedForAll(prevOwnership.addr, _msgSender()));
1054 
1055     require(
1056       isApprovedOrOwner,
1057       "ERC721A: transfer caller is not owner nor approved"
1058     );
1059 
1060     require(
1061       prevOwnership.addr == from,
1062       "ERC721A: transfer from incorrect owner"
1063     );
1064     require(to != address(0), "ERC721A: transfer to the zero address");
1065 
1066     _beforeTokenTransfers(from, to, tokenId, 1);
1067 
1068     // Clear approvals from the previous owner
1069     _approve(address(0), tokenId, prevOwnership.addr);
1070 
1071     _addressData[from].balance -= 1;
1072     _addressData[to].balance += 1;
1073     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1074 
1075     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1076     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1077     uint256 nextTokenId = tokenId + 1;
1078     if (_ownerships[nextTokenId].addr == address(0)) {
1079       if (_exists(nextTokenId)) {
1080         _ownerships[nextTokenId] = TokenOwnership(
1081           prevOwnership.addr,
1082           prevOwnership.startTimestamp
1083         );
1084       }
1085     }
1086 
1087     emit Transfer(from, to, tokenId);
1088     _afterTokenTransfers(from, to, tokenId, 1);
1089   }
1090 
1091   /**
1092    * @dev Approve `to` to operate on `tokenId`
1093    *
1094    * Emits a {Approval} event.
1095    */
1096   function _approve(
1097     address to,
1098     uint256 tokenId,
1099     address owner
1100   ) private {
1101     _tokenApprovals[tokenId] = to;
1102     emit Approval(owner, to, tokenId);
1103   }
1104 
1105   uint256 public nextOwnerToExplicitlySet = 0;
1106 
1107   /**
1108    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1109    */
1110   function _setOwnersExplicit(uint256 quantity) internal {
1111     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1112     require(quantity > 0, "quantity must be nonzero");
1113     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1114     if (endIndex > collectionSize - 1) {
1115       endIndex = collectionSize - 1;
1116     }
1117     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1118     require(_exists(endIndex), "not enough minted yet for this cleanup");
1119     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1120       if (_ownerships[i].addr == address(0)) {
1121         TokenOwnership memory ownership = ownershipOf(i);
1122         _ownerships[i] = TokenOwnership(
1123           ownership.addr,
1124           ownership.startTimestamp
1125         );
1126       }
1127     }
1128     nextOwnerToExplicitlySet = endIndex + 1;
1129   }
1130 
1131   /**
1132    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1133    * The call is not executed if the target address is not a contract.
1134    *
1135    * @param from address representing the previous owner of the given token ID
1136    * @param to target address that will receive the tokens
1137    * @param tokenId uint256 ID of the token to be transferred
1138    * @param _data bytes optional data to send along with the call
1139    * @return bool whether the call correctly returned the expected magic value
1140    */
1141   function _checkOnERC721Received(
1142     address from,
1143     address to,
1144     uint256 tokenId,
1145     bytes memory _data
1146   ) private returns (bool) {
1147     if (to.isContract()) {
1148       try
1149         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1150       returns (bytes4 retval) {
1151         return retval == IERC721Receiver(to).onERC721Received.selector;
1152       } catch (bytes memory reason) {
1153         if (reason.length == 0) {
1154           revert("ERC721A: transfer to non ERC721Receiver implementer");
1155         } else {
1156           assembly {
1157             revert(add(32, reason), mload(reason))
1158           }
1159         }
1160       }
1161     } else {
1162       return true;
1163     }
1164   }
1165 
1166   /**
1167    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1168    *
1169    * startTokenId - the first token id to be transferred
1170    * quantity - the amount to be transferred
1171    *
1172    * Calling conditions:
1173    *
1174    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1175    * transferred to `to`.
1176    * - When `from` is zero, `tokenId` will be minted for `to`.
1177    */
1178   function _beforeTokenTransfers(
1179     address from,
1180     address to,
1181     uint256 startTokenId,
1182     uint256 quantity
1183   ) internal virtual {}
1184 
1185   /**
1186    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1187    * minting.
1188    *
1189    * startTokenId - the first token id to be transferred
1190    * quantity - the amount to be transferred
1191    *
1192    * Calling conditions:
1193    *
1194    * - when `from` and `to` are both non-zero.
1195    * - `from` and `to` are never both zero.
1196    */
1197   function _afterTokenTransfers(
1198     address from,
1199     address to,
1200     uint256 startTokenId,
1201     uint256 quantity
1202   ) internal virtual {}
1203 }
1204 
1205 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1206 
1207 pragma solidity ^0.8.0;
1208 
1209 /**
1210  * @dev Contract module which provides a basic access control mechanism, where
1211  * there is an account (an owner) that can be granted exclusive access to
1212  * specific functions.
1213  *
1214  * By default, the owner account will be the one that deploys the contract. This
1215  * can later be changed with {transferOwnership}.
1216  *
1217  * This module is used through inheritance. It will make available the modifier
1218  * `onlyOwner`, which can be applied to your functions to restrict their use to
1219  * the owner.
1220  */
1221 abstract contract Ownable is Context {
1222     address private _owner;
1223 
1224     event OwnershipTransferred(
1225         address indexed previousOwner,
1226         address indexed newOwner
1227     );
1228 
1229     /**
1230      * @dev Initializes the contract setting the deployer as the initial owner.
1231      */
1232     constructor() {
1233         _transferOwnership(_msgSender());
1234     }
1235 
1236     /**
1237      * @dev Returns the address of the current owner.
1238      */
1239     function owner() public view virtual returns (address) {
1240         return _owner;
1241     }
1242 
1243     /**
1244      * @dev Throws if called by any account other than the owner.
1245      */
1246     modifier onlyOwner() {
1247         require(owner() == _msgSender(), "You are not the owner");
1248         _;
1249     }
1250 
1251     /**
1252      * @dev Leaves the contract without owner. It will not be possible to call
1253      * `onlyOwner` functions anymore. Can only be called by the current owner.
1254      *
1255      * NOTE: Renouncing ownership will leave the contract without an owner,
1256      * thereby removing any functionality that is only available to the owner.
1257      */
1258     function renounceOwnership() public virtual onlyOwner {
1259         _transferOwnership(address(0));
1260     }
1261 
1262     /**
1263      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1264      * Can only be called by the current owner.
1265      */
1266     function transferOwnership(address newOwner) public virtual onlyOwner {
1267         require(
1268             newOwner != address(0),
1269             "Ownable: new owner is the zero address"
1270         );
1271         _transferOwnership(newOwner);
1272     }
1273 
1274     /**
1275      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1276      * Internal function without access restriction.
1277      */
1278     function _transferOwnership(address newOwner) internal virtual {
1279         address oldOwner = _owner;
1280         _owner = newOwner;
1281         emit OwnershipTransferred(oldOwner, newOwner);
1282     }
1283 }
1284 
1285 
1286 pragma solidity ^0.8.0;
1287 
1288 contract DiamondHandsDao is ERC721A, Ownable {
1289     uint256 public NFT_PRICE = 0 ether;
1290     uint256 public MAX_SUPPLY = 3000;
1291     uint256 public MAX_MINTS = 250;
1292     string public baseURI = "ipfs://";
1293     string public baseExtension = ".json";
1294      bool public paused = true;   
1295     
1296     constructor() ERC721A("Diamond Hands DAO", "DMND", MAX_MINTS, MAX_SUPPLY) {  
1297     }
1298     
1299 
1300     function Mint(uint256 numTokens) public payable {
1301         require(!paused, "Paused");
1302         require(numTokens == 1);
1303         require(totalSupply() + numTokens <= MAX_SUPPLY);
1304         require(MAX_MINTS >= numTokens, "Excess max per paid tx");
1305         _safeMint(msg.sender, numTokens);
1306     }
1307 
1308     function DevsMint(uint256 numTokens) public payable onlyOwner {
1309         _safeMint(msg.sender, numTokens);
1310     }
1311 
1312 
1313     function pause(bool _state) public onlyOwner {
1314         paused = _state;
1315     }
1316 
1317     function setBaseURI(string memory newBaseURI) public onlyOwner {
1318         baseURI = newBaseURI;
1319     }
1320     function tokenURI(uint256 _tokenId)
1321         public
1322         view
1323         override
1324         returns (string memory)
1325     {
1326         require(_exists(_tokenId), "That token doesn't exist");
1327         return
1328             bytes(baseURI).length > 0
1329                 ? string(
1330                     abi.encodePacked(
1331                         baseURI,
1332                         Strings.toString(_tokenId),
1333                         baseExtension
1334                     )
1335                 )
1336                 : "";
1337     }
1338 
1339     function setPrice(uint256 newPrice) public onlyOwner {
1340         NFT_PRICE = newPrice;
1341     }
1342 
1343     function setMaxMints(uint256 newMax) public onlyOwner {
1344         MAX_MINTS = newMax;
1345     }
1346 
1347     function _baseURI() internal view virtual override returns (string memory) {
1348         return baseURI;
1349     }
1350 
1351     function withdrawMoney() external onlyOwner {
1352       (bool success, ) = msg.sender.call{value: address(this).balance}("");
1353       require(success, "WITHDRAW FAILED!");
1354     }
1355 }