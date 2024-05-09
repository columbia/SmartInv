1 // SPDX-License-Identifier: MIT
2 // File: contracts/CrashLanders.sol
3 
4 /**
5  *Submitted for verification at Etherscan.io on 2022-08-22
6 */
7 
8 // File: contracts/ETHvillages.sol
9 
10 
11 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev Interface of the ERC165 standard, as defined in the
17  * https://eips.ethereum.org/EIPS/eip-165[EIP].
18  *
19  * Implementers can declare support of contract interfaces, which can then be
20  * queried by others ({ERC165Checker}).
21  *
22  * For an implementation, see {ERC165}.
23  */
24 interface IERC165 {
25     /**
26      * @dev Returns true if this contract implements the interface defined by
27      * `interfaceId`. See the corresponding
28      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
29      * to learn more about how these ids are created.
30      *
31      * This function call must use less than 30 000 gas.
32      */
33     function supportsInterface(bytes4 interfaceId) external view returns (bool);
34 }
35 
36 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Required interface of an ERC721 compliant contract.
42  */
43 interface IERC721 is IERC165 {
44     /**
45      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
46      */
47     event Transfer(
48         address indexed from,
49         address indexed to,
50         uint256 indexed tokenId
51     );
52 
53     /**
54      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
55      */
56     event Approval(
57         address indexed owner,
58         address indexed approved,
59         uint256 indexed tokenId
60     );
61 
62     /**
63      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
64      */
65     event ApprovalForAll(
66         address indexed owner,
67         address indexed operator,
68         bool approved
69     );
70 
71     /**
72      * @dev Returns the number of tokens in ``owner``'s account.
73      */
74     function balanceOf(address owner) external view returns (uint256 balance);
75 
76     /**
77      * @dev Returns the owner of the `tokenId` token.
78      *
79      * Requirements:
80      *
81      * - `tokenId` must exist.
82      */
83     function ownerOf(uint256 tokenId) external view returns (address owner);
84 
85     /**
86      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
87      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must exist and be owned by `from`.
94      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
95      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
96      *
97      * Emits a {Transfer} event.
98      */
99     function safeTransferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Transfers `tokenId` token from `from` to `to`.
107      *
108      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
109      *
110      * Requirements:
111      *
112      * - `from` cannot be the zero address.
113      * - `to` cannot be the zero address.
114      * - `tokenId` token must be owned by `from`.
115      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transferFrom(
120         address from,
121         address to,
122         uint256 tokenId
123     ) external;
124 
125     /**
126      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
127      * The approval is cleared when the token is transferred.
128      *
129      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
130      *
131      * Requirements:
132      *
133      * - The caller must own the token or be an approved operator.
134      * - `tokenId` must exist.
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address to, uint256 tokenId) external;
139 
140     /**
141      * @dev Returns the account approved for `tokenId` token.
142      *
143      * Requirements:
144      *
145      * - `tokenId` must exist.
146      */
147     function getApproved(uint256 tokenId)
148         external
149         view
150         returns (address operator);
151 
152     /**
153      * @dev Approve or remove `operator` as an operator for the caller.
154      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
155      *
156      * Requirements:
157      *
158      * - The `operator` cannot be the caller.
159      *
160      * Emits an {ApprovalForAll} event.
161      */
162     function setApprovalForAll(address operator, bool _approved) external;
163 
164     /**
165      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
166      *
167      * See {setApprovalForAll}
168      */
169     function isApprovedForAll(address owner, address operator)
170         external
171         view
172         returns (bool);
173 
174     /**
175      * @dev Safely transfers `tokenId` token from `from` to `to`.
176      *
177      * Requirements:
178      *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181      * - `tokenId` token must exist and be owned by `from`.
182      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
183      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
184      *
185      * Emits a {Transfer} event.
186      */
187     function safeTransferFrom(
188         address from,
189         address to,
190         uint256 tokenId,
191         bytes calldata data
192     ) external;
193 }
194 
195 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @title ERC721 token receiver interface
201  * @dev Interface for any contract that wants to support safeTransfers
202  * from ERC721 asset contracts.
203  */
204 interface IERC721Receiver {
205     /**
206      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
207      * by `operator` from `from`, this function is called.
208      *
209      * It must return its Solidity selector to confirm the token transfer.
210      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
211      *
212      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
213      */
214     function onERC721Received(
215         address operator,
216         address from,
217         uint256 tokenId,
218         bytes calldata data
219     ) external returns (bytes4);
220 }
221 
222 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
223 
224 pragma solidity ^0.8.0;
225 
226 /**
227  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
228  * @dev See https://eips.ethereum.org/EIPS/eip-721
229  */
230 interface IERC721Metadata is IERC721 {
231     /**
232      * @dev Returns the token collection name.
233      */
234     function name() external view returns (string memory);
235 
236     /**
237      * @dev Returns the token collection symbol.
238      */
239     function symbol() external view returns (string memory);
240 
241     /**
242      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
243      */
244     function tokenURI(uint256 tokenId) external view returns (string memory);
245 }
246 
247 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
248 
249 pragma solidity ^0.8.0;
250 
251 /**
252  * @dev Implementation of the {IERC165} interface.
253  *
254  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
255  * for the additional interface id that will be supported. For example:
256  *
257  * ```solidity
258  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
259  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
260  * }
261  * ```
262  *
263  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
264  */
265 abstract contract ERC165 is IERC165 {
266     /**
267      * @dev See {IERC165-supportsInterface}.
268      */
269     function supportsInterface(bytes4 interfaceId)
270         public
271         view
272         virtual
273         override
274         returns (bool)
275     {
276         return interfaceId == type(IERC165).interfaceId;
277     }
278 }
279 
280 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
281 
282 pragma solidity ^0.8.0;
283 
284 /**
285  * @dev Collection of functions related to the address type
286  */
287 library Address {
288     /**
289      * @dev Returns true if `account` is a contract.
290      *
291      * [IMPORTANT]
292      * ====
293      * It is unsafe to assume that an address for which this function returns
294      * false is an externally-owned account (EOA) and not a contract.
295      *
296      * Among others, `isContract` will return false for the following
297      * types of addresses:
298      *
299      *  - an externally-owned account
300      *  - a contract in construction
301      *  - an address where a contract will be created
302      *  - an address where a contract lived, but was destroyed
303      * ====
304      */
305     function isContract(address account) internal view returns (bool) {
306         // This method relies on extcodesize, which returns 0 for contracts in
307         // construction, since the code is only stored at the end of the
308         // constructor execution.
309 
310         uint256 size;
311         assembly {
312             size := extcodesize(account)
313         }
314         return size > 0;
315     }
316 
317     /**
318      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
319      * `recipient`, forwarding all available gas and reverting on errors.
320      *
321      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
322      * of certain opcodes, possibly making contracts go over the 2300 gas limit
323      * imposed by `transfer`, making them unable to receive funds via
324      * `transfer`. {sendValue} removes this limitation.
325      *
326      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
327      *
328      * IMPORTANT: because control is transferred to `recipient`, care must be
329      * taken to not create reentrancy vulnerabilities. Consider using
330      * {ReentrancyGuard} or the
331      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
332      */
333     function sendValue(address payable recipient, uint256 amount) internal {
334         require(
335             address(this).balance >= amount,
336             "Address: insufficient balance"
337         );
338 
339         (bool success, ) = recipient.call{value: amount}("");
340         require(
341             success,
342             "Address: unable to send value, recipient may have reverted"
343         );
344     }
345 
346     /**
347      * @dev Performs a Solidity function call using a low level `call`. A
348      * plain `call` is an unsafe replacement for a function call: use this
349      * function instead.
350      *
351      * If `target` reverts with a revert reason, it is bubbled up by this
352      * function (like regular Solidity function calls).
353      *
354      * Returns the raw returned data. To convert to the expected return value,
355      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
356      *
357      * Requirements:
358      *
359      * - `target` must be a contract.
360      * - calling `target` with `data` must not revert.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(address target, bytes memory data)
365         internal
366         returns (bytes memory)
367     {
368         return functionCall(target, data, "Address: low-level call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
373      * `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, 0, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but also transferring `value` wei to `target`.
388      *
389      * Requirements:
390      *
391      * - the calling contract must have an ETH balance of at least `value`.
392      * - the called Solidity function must be `payable`.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(
397         address target,
398         bytes memory data,
399         uint256 value
400     ) internal returns (bytes memory) {
401         return
402             functionCallWithValue(
403                 target,
404                 data,
405                 value,
406                 "Address: low-level call with value failed"
407             );
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
412      * with `errorMessage` as a fallback revert reason when `target` reverts.
413      *
414      * _Available since v3.1._
415      */
416     function functionCallWithValue(
417         address target,
418         bytes memory data,
419         uint256 value,
420         string memory errorMessage
421     ) internal returns (bytes memory) {
422         require(
423             address(this).balance >= value,
424             "Address: insufficient balance for call"
425         );
426         require(isContract(target), "Address: call to non-contract");
427 
428         (bool success, bytes memory returndata) = target.call{value: value}(
429             data
430         );
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but performing a static call.
437      *
438      * _Available since v3.3._
439      */
440     function functionStaticCall(address target, bytes memory data)
441         internal
442         view
443         returns (bytes memory)
444     {
445         return
446             functionStaticCall(
447                 target,
448                 data,
449                 "Address: low-level static call failed"
450             );
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
455      * but performing a static call.
456      *
457      * _Available since v3.3._
458      */
459     function functionStaticCall(
460         address target,
461         bytes memory data,
462         string memory errorMessage
463     ) internal view returns (bytes memory) {
464         require(isContract(target), "Address: static call to non-contract");
465 
466         (bool success, bytes memory returndata) = target.staticcall(data);
467         return verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
472      * but performing a delegate call.
473      *
474      * _Available since v3.4._
475      */
476     function functionDelegateCall(address target, bytes memory data)
477         internal
478         returns (bytes memory)
479     {
480         return
481             functionDelegateCall(
482                 target,
483                 data,
484                 "Address: low-level delegate call failed"
485             );
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
490      * but performing a delegate call.
491      *
492      * _Available since v3.4._
493      */
494     function functionDelegateCall(
495         address target,
496         bytes memory data,
497         string memory errorMessage
498     ) internal returns (bytes memory) {
499         require(isContract(target), "Address: delegate call to non-contract");
500 
501         (bool success, bytes memory returndata) = target.delegatecall(data);
502         return verifyCallResult(success, returndata, errorMessage);
503     }
504 
505     /**
506      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
507      * revert reason using the provided one.
508      *
509      * _Available since v4.3._
510      */
511     function verifyCallResult(
512         bool success,
513         bytes memory returndata,
514         string memory errorMessage
515     ) internal pure returns (bytes memory) {
516         if (success) {
517             return returndata;
518         } else {
519             // Look for revert reason and bubble it up if present
520             if (returndata.length > 0) {
521                 // The easiest way to bubble the revert reason is using memory via assembly
522 
523                 assembly {
524                     let returndata_size := mload(returndata)
525                     revert(add(32, returndata), returndata_size)
526                 }
527             } else {
528                 revert(errorMessage);
529             }
530         }
531     }
532 }
533 
534 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 /**
539  * @dev Provides information about the current execution context, including the
540  * sender of the transaction and its data. While these are generally available
541  * via msg.sender and msg.data, they should not be accessed in such a direct
542  * manner, since when dealing with meta-transactions the account sending and
543  * paying for execution may not be the actual sender (as far as an application
544  * is concerned).
545  *
546  * This contract is only required for intermediate, library-like contracts.
547  */
548 abstract contract Context {
549     function _msgSender() internal view virtual returns (address) {
550         return msg.sender;
551     }
552 
553     function _msgData() internal view virtual returns (bytes calldata) {
554         return msg.data;
555     }
556 }
557 
558 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @dev String operations.
564  */
565 library Strings {
566     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
567 
568     /**
569      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
570      */
571     function toString(uint256 value) internal pure returns (string memory) {
572         // Inspired by OraclizeAPI's implementation - MIT licence
573         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
574 
575         if (value == 0) {
576             return "0";
577         }
578         uint256 temp = value;
579         uint256 digits;
580         while (temp != 0) {
581             digits++;
582             temp /= 10;
583         }
584         bytes memory buffer = new bytes(digits);
585         while (value != 0) {
586             digits -= 1;
587             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
588             value /= 10;
589         }
590         return string(buffer);
591     }
592 
593     /**
594      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
595      */
596     function toHexString(uint256 value) internal pure returns (string memory) {
597         if (value == 0) {
598             return "0x00";
599         }
600         uint256 temp = value;
601         uint256 length = 0;
602         while (temp != 0) {
603             length++;
604             temp >>= 8;
605         }
606         return toHexString(value, length);
607     }
608 
609     /**
610      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
611      */
612     function toHexString(uint256 value, uint256 length)
613         internal
614         pure
615         returns (string memory)
616     {
617         bytes memory buffer = new bytes(2 * length + 2);
618         buffer[0] = "0";
619         buffer[1] = "x";
620         for (uint256 i = 2 * length + 1; i > 1; --i) {
621             buffer[i] = _HEX_SYMBOLS[value & 0xf];
622             value >>= 4;
623         }
624         require(value == 0, "Strings: hex length insufficient");
625         return string(buffer);
626     }
627 }
628 
629 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 /**
634  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
635  * @dev See https://eips.ethereum.org/EIPS/eip-721
636  */
637 interface IERC721Enumerable is IERC721 {
638     /**
639      * @dev Returns the total amount of tokens stored by the contract.
640      */
641     function totalSupply() external view returns (uint256);
642 
643     /**
644      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
645      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
646      */
647     function tokenOfOwnerByIndex(address owner, uint256 index)
648         external
649         view
650         returns (uint256 tokenId);
651 
652     /**
653      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
654      * Use along with {totalSupply} to enumerate all tokens.
655      */
656     function tokenByIndex(uint256 index) external view returns (uint256);
657 }
658 
659 pragma solidity ^0.8.0;
660 
661 /**
662  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
663  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
664  *
665  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
666  *
667  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
668  *
669  * Does not support burning tokens to address(0).
670  */
671 contract ERC721A is
672   Context,
673   ERC165,
674   IERC721,
675   IERC721Metadata,
676   IERC721Enumerable
677 {
678   using Address for address;
679   using Strings for uint256;
680 
681   struct TokenOwnership {
682     address addr;
683     uint64 startTimestamp;
684   }
685 
686   struct AddressData {
687     uint128 balance;
688     uint128 numberMinted;
689   }
690 
691   uint256 private currentIndex = 0;
692 
693   uint256 internal immutable collectionSize;
694   uint256 internal immutable maxBatchSize;
695 
696   // Token name
697   string private _name;
698 
699   // Token symbol
700   string private _symbol;
701 
702   // Mapping from token ID to ownership details
703   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
704   mapping(uint256 => TokenOwnership) private _ownerships;
705 
706   // Mapping owner address to address data
707   mapping(address => AddressData) private _addressData;
708 
709   // Mapping from token ID to approved address
710   mapping(uint256 => address) private _tokenApprovals;
711 
712   // Mapping from owner to operator approvals
713   mapping(address => mapping(address => bool)) private _operatorApprovals;
714 
715   /**
716    * @dev
717    * `maxBatchSize` refers to how much a minter can mint at a time.
718    * `collectionSize_` refers to how many tokens are in the collection.
719    */
720   constructor(
721     string memory name_,
722     string memory symbol_,
723     uint256 maxBatchSize_,
724     uint256 collectionSize_
725   ) {
726     require(
727       collectionSize_ > 0,
728       "ERC721A: collection must have a nonzero supply"
729     );
730     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
731     _name = name_;
732     _symbol = symbol_;
733     maxBatchSize = maxBatchSize_;
734     collectionSize = collectionSize_;
735   }
736 
737   /**
738    * @dev See {IERC721Enumerable-totalSupply}.
739    */
740   function totalSupply() public view override returns (uint256) {
741     return currentIndex;
742   }
743 
744   /**
745    * @dev See {IERC721Enumerable-tokenByIndex}.
746    */
747   function tokenByIndex(uint256 index) public view override returns (uint256) {
748     require(index < totalSupply(), "ERC721A: global index out of bounds");
749     return index;
750   }
751 
752   /**
753    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
754    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
755    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
756    */
757   function tokenOfOwnerByIndex(address owner, uint256 index)
758     public
759     view
760     override
761     returns (uint256)
762   {
763     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
764     uint256 numMintedSoFar = totalSupply();
765     uint256 tokenIdsIdx = 0;
766     address currOwnershipAddr = address(0);
767     for (uint256 i = 0; i < numMintedSoFar; i++) {
768       TokenOwnership memory ownership = _ownerships[i];
769       if (ownership.addr != address(0)) {
770         currOwnershipAddr = ownership.addr;
771       }
772       if (currOwnershipAddr == owner) {
773         if (tokenIdsIdx == index) {
774           return i;
775         }
776         tokenIdsIdx++;
777       }
778     }
779     revert("ERC721A: unable to get token of owner by index");
780   }
781 
782   /**
783    * @dev See {IERC165-supportsInterface}.
784    */
785   function supportsInterface(bytes4 interfaceId)
786     public
787     view
788     virtual
789     override(ERC165, IERC165)
790     returns (bool)
791   {
792     return
793       interfaceId == type(IERC721).interfaceId ||
794       interfaceId == type(IERC721Metadata).interfaceId ||
795       interfaceId == type(IERC721Enumerable).interfaceId ||
796       super.supportsInterface(interfaceId);
797   }
798 
799   /**
800    * @dev See {IERC721-balanceOf}.
801    */
802   function balanceOf(address owner) public view override returns (uint256) {
803     require(owner != address(0), "ERC721A: balance query for the zero address");
804     return uint256(_addressData[owner].balance);
805   }
806 
807   function _numberMinted(address owner) internal view returns (uint256) {
808     require(
809       owner != address(0),
810       "ERC721A: number minted query for the zero address"
811     );
812     return uint256(_addressData[owner].numberMinted);
813   }
814 
815   function ownershipOf(uint256 tokenId)
816     internal
817     view
818     returns (TokenOwnership memory)
819   {
820     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
821 
822     uint256 lowestTokenToCheck;
823     if (tokenId >= maxBatchSize) {
824       lowestTokenToCheck = tokenId - maxBatchSize + 1;
825     }
826 
827     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
828       TokenOwnership memory ownership = _ownerships[curr];
829       if (ownership.addr != address(0)) {
830         return ownership;
831       }
832     }
833 
834     revert("ERC721A: unable to determine the owner of token");
835   }
836 
837   /**
838    * @dev See {IERC721-ownerOf}.
839    */
840   function ownerOf(uint256 tokenId) public view override returns (address) {
841     return ownershipOf(tokenId).addr;
842   }
843 
844   /**
845    * @dev See {IERC721Metadata-name}.
846    */
847   function name() public view virtual override returns (string memory) {
848     return _name;
849   }
850 
851   /**
852    * @dev See {IERC721Metadata-symbol}.
853    */
854   function symbol() public view virtual override returns (string memory) {
855     return _symbol;
856   }
857 
858   /**
859    * @dev See {IERC721Metadata-tokenURI}.
860    */
861   function tokenURI(uint256 tokenId)
862     public
863     view
864     virtual
865     override
866     returns (string memory)
867   {
868     require(
869       _exists(tokenId),
870       "ERC721Metadata: URI query for nonexistent token"
871     );
872 
873     string memory baseURI = _baseURI();
874     return
875       bytes(baseURI).length > 0
876         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
877         : "";
878   }
879 
880   /**
881    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
882    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
883    * by default, can be overriden in child contracts.
884    */
885   function _baseURI() internal view virtual returns (string memory) {
886     return "";
887   }
888 
889   /**
890    * @dev See {IERC721-approve}.
891    */
892   function approve(address to, uint256 tokenId) public override {
893     address owner = ERC721A.ownerOf(tokenId);
894     require(to != owner, "ERC721A: approval to current owner");
895 
896     require(
897       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
898       "ERC721A: approve caller is not owner nor approved for all"
899     );
900 
901     _approve(to, tokenId, owner);
902   }
903 
904   /**
905    * @dev See {IERC721-getApproved}.
906    */
907   function getApproved(uint256 tokenId) public view override returns (address) {
908     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
909 
910     return _tokenApprovals[tokenId];
911   }
912 
913   /**
914    * @dev See {IERC721-setApprovalForAll}.
915    */
916   function setApprovalForAll(address operator, bool approved) public override {
917     require(operator != _msgSender(), "ERC721A: approve to caller");
918 
919     _operatorApprovals[_msgSender()][operator] = approved;
920     emit ApprovalForAll(_msgSender(), operator, approved);
921   }
922 
923   /**
924    * @dev See {IERC721-isApprovedForAll}.
925    */
926   function isApprovedForAll(address owner, address operator)
927     public
928     view
929     virtual
930     override
931     returns (bool)
932   {
933     return _operatorApprovals[owner][operator];
934   }
935 
936   /**
937    * @dev See {IERC721-transferFrom}.
938    */
939   function transferFrom(
940     address from,
941     address to,
942     uint256 tokenId
943   ) public override {
944     _transfer(from, to, tokenId);
945   }
946 
947   /**
948    * @dev See {IERC721-safeTransferFrom}.
949    */
950   function safeTransferFrom(
951     address from,
952     address to,
953     uint256 tokenId
954   ) public override {
955     safeTransferFrom(from, to, tokenId, "");
956   }
957 
958   /**
959    * @dev See {IERC721-safeTransferFrom}.
960    */
961   function safeTransferFrom(
962     address from,
963     address to,
964     uint256 tokenId,
965     bytes memory _data
966   ) public override {
967     _transfer(from, to, tokenId);
968     require(
969       _checkOnERC721Received(from, to, tokenId, _data),
970       "ERC721A: transfer to non ERC721Receiver implementer"
971     );
972   }
973 
974   /**
975    * @dev Returns whether `tokenId` exists.
976    *
977    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
978    *
979    * Tokens start existing when they are minted (`_mint`),
980    */
981   function _exists(uint256 tokenId) internal view returns (bool) {
982     return tokenId < currentIndex;
983   }
984 
985   function _safeMint(address to, uint256 quantity) internal {
986     _safeMint(to, quantity, "");
987   }
988 
989   /**
990    * @dev Mints `quantity` tokens and transfers them to `to`.
991    *
992    * Requirements:
993    *
994    * - there must be `quantity` tokens remaining unminted in the total collection.
995    * - `to` cannot be the zero address.
996    * - `quantity` cannot be larger than the max batch size.
997    *
998    * Emits a {Transfer} event.
999    */
1000   function _safeMint(
1001     address to,
1002     uint256 quantity,
1003     bytes memory _data
1004   ) internal {
1005     uint256 startTokenId = currentIndex;
1006     require(to != address(0), "ERC721A: mint to the zero address");
1007     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1008     require(!_exists(startTokenId), "ERC721A: token already minted");
1009     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1010 
1011     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1012 
1013     AddressData memory addressData = _addressData[to];
1014     _addressData[to] = AddressData(
1015       addressData.balance + uint128(quantity),
1016       addressData.numberMinted + uint128(quantity)
1017     );
1018     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1019 
1020     uint256 updatedIndex = startTokenId;
1021 
1022     for (uint256 i = 0; i < quantity; i++) {
1023       emit Transfer(address(0), to, updatedIndex);
1024       require(
1025         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1026         "ERC721A: transfer to non ERC721Receiver implementer"
1027       );
1028       updatedIndex++;
1029     }
1030 
1031     currentIndex = updatedIndex;
1032     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1033   }
1034 
1035   /**
1036    * @dev Transfers `tokenId` from `from` to `to`.
1037    *
1038    * Requirements:
1039    *
1040    * - `to` cannot be the zero address.
1041    * - `tokenId` token must be owned by `from`.
1042    *
1043    * Emits a {Transfer} event.
1044    */
1045   function _transfer(
1046     address from,
1047     address to,
1048     uint256 tokenId
1049   ) private {
1050     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1051 
1052     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1053       getApproved(tokenId) == _msgSender() ||
1054       isApprovedForAll(prevOwnership.addr, _msgSender()));
1055 
1056     require(
1057       isApprovedOrOwner,
1058       "ERC721A: transfer caller is not owner nor approved"
1059     );
1060 
1061     require(
1062       prevOwnership.addr == from,
1063       "ERC721A: transfer from incorrect owner"
1064     );
1065     require(to != address(0), "ERC721A: transfer to the zero address");
1066 
1067     _beforeTokenTransfers(from, to, tokenId, 1);
1068 
1069     // Clear approvals from the previous owner
1070     _approve(address(0), tokenId, prevOwnership.addr);
1071 
1072     _addressData[from].balance -= 1;
1073     _addressData[to].balance += 1;
1074     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1075 
1076     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1077     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1078     uint256 nextTokenId = tokenId + 1;
1079     if (_ownerships[nextTokenId].addr == address(0)) {
1080       if (_exists(nextTokenId)) {
1081         _ownerships[nextTokenId] = TokenOwnership(
1082           prevOwnership.addr,
1083           prevOwnership.startTimestamp
1084         );
1085       }
1086     }
1087 
1088     emit Transfer(from, to, tokenId);
1089     _afterTokenTransfers(from, to, tokenId, 1);
1090   }
1091 
1092   /**
1093    * @dev Approve `to` to operate on `tokenId`
1094    *
1095    * Emits a {Approval} event.
1096    */
1097   function _approve(
1098     address to,
1099     uint256 tokenId,
1100     address owner
1101   ) private {
1102     _tokenApprovals[tokenId] = to;
1103     emit Approval(owner, to, tokenId);
1104   }
1105 
1106   uint256 public nextOwnerToExplicitlySet = 0;
1107 
1108   /**
1109    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1110    */
1111   function _setOwnersExplicit(uint256 quantity) internal {
1112     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1113     require(quantity > 0, "quantity must be nonzero");
1114     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1115     if (endIndex > collectionSize - 1) {
1116       endIndex = collectionSize - 1;
1117     }
1118     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1119     require(_exists(endIndex), "not enough minted yet for this cleanup");
1120     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1121       if (_ownerships[i].addr == address(0)) {
1122         TokenOwnership memory ownership = ownershipOf(i);
1123         _ownerships[i] = TokenOwnership(
1124           ownership.addr,
1125           ownership.startTimestamp
1126         );
1127       }
1128     }
1129     nextOwnerToExplicitlySet = endIndex + 1;
1130   }
1131 
1132   /**
1133    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1134    * The call is not executed if the target address is not a contract.
1135    *
1136    * @param from address representing the previous owner of the given token ID
1137    * @param to target address that will receive the tokens
1138    * @param tokenId uint256 ID of the token to be transferred
1139    * @param _data bytes optional data to send along with the call
1140    * @return bool whether the call correctly returned the expected magic value
1141    */
1142   function _checkOnERC721Received(
1143     address from,
1144     address to,
1145     uint256 tokenId,
1146     bytes memory _data
1147   ) private returns (bool) {
1148     if (to.isContract()) {
1149       try
1150         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1151       returns (bytes4 retval) {
1152         return retval == IERC721Receiver(to).onERC721Received.selector;
1153       } catch (bytes memory reason) {
1154         if (reason.length == 0) {
1155           revert("ERC721A: transfer to non ERC721Receiver implementer");
1156         } else {
1157           assembly {
1158             revert(add(32, reason), mload(reason))
1159           }
1160         }
1161       }
1162     } else {
1163       return true;
1164     }
1165   }
1166 
1167   /**
1168    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1169    *
1170    * startTokenId - the first token id to be transferred
1171    * quantity - the amount to be transferred
1172    *
1173    * Calling conditions:
1174    *
1175    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1176    * transferred to `to`.
1177    * - When `from` is zero, `tokenId` will be minted for `to`.
1178    */
1179   function _beforeTokenTransfers(
1180     address from,
1181     address to,
1182     uint256 startTokenId,
1183     uint256 quantity
1184   ) internal virtual {}
1185 
1186   /**
1187    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1188    * minting.
1189    *
1190    * startTokenId - the first token id to be transferred
1191    * quantity - the amount to be transferred
1192    *
1193    * Calling conditions:
1194    *
1195    * - when `from` and `to` are both non-zero.
1196    * - `from` and `to` are never both zero.
1197    */
1198   function _afterTokenTransfers(
1199     address from,
1200     address to,
1201     uint256 startTokenId,
1202     uint256 quantity
1203   ) internal virtual {}
1204 }
1205 
1206 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1207 
1208 pragma solidity ^0.8.0;
1209 
1210 /**
1211  * @dev Contract module which provides a basic access control mechanism, where
1212  * there is an account (an owner) that can be granted exclusive access to
1213  * specific functions.
1214  *
1215  * By default, the owner account will be the one that deploys the contract. This
1216  * can later be changed with {transferOwnership}.
1217  *
1218  * This module is used through inheritance. It will make available the modifier
1219  * `onlyOwner`, which can be applied to your functions to restrict their use to
1220  * the owner.
1221  */
1222 abstract contract Ownable is Context {
1223     address private _owner;
1224 
1225     event OwnershipTransferred(
1226         address indexed previousOwner,
1227         address indexed newOwner
1228     );
1229 
1230     /**
1231      * @dev Initializes the contract setting the deployer as the initial owner.
1232      */
1233     constructor() {
1234         _transferOwnership(_msgSender());
1235     }
1236 
1237     /**
1238      * @dev Returns the address of the current owner.
1239      */
1240     function owner() public view virtual returns (address) {
1241         return _owner;
1242     }
1243 
1244     /**
1245      * @dev Throws if called by any account other than the owner.
1246      */
1247     modifier onlyOwner() {
1248         require(owner() == _msgSender(), "You are not the owner");
1249         _;
1250     }
1251 
1252     /**
1253      * @dev Leaves the contract without owner. It will not be possible to call
1254      * `onlyOwner` functions anymore. Can only be called by the current owner.
1255      *
1256      * NOTE: Renouncing ownership will leave the contract without an owner,
1257      * thereby removing any functionality that is only available to the owner.
1258      */
1259     function renounceOwnership() public virtual onlyOwner {
1260         _transferOwnership(address(0));
1261     }
1262 
1263     /**
1264      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1265      * Can only be called by the current owner.
1266      */
1267     function transferOwnership(address newOwner) public virtual onlyOwner {
1268         require(
1269             newOwner != address(0),
1270             "Ownable: new owner is the zero address"
1271         );
1272         _transferOwnership(newOwner);
1273     }
1274 
1275     /**
1276      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1277      * Internal function without access restriction.
1278      */
1279     function _transferOwnership(address newOwner) internal virtual {
1280         address oldOwner = _owner;
1281         _owner = newOwner;
1282         emit OwnershipTransferred(oldOwner, newOwner);
1283     }
1284 }
1285 
1286 
1287 pragma solidity ^0.8.0;
1288 
1289 contract CrashLanders is ERC721A, Ownable {
1290     uint256 public NFT_PRICE = 0 ether;
1291     uint256 public MAX_SUPPLY = 6000;
1292     uint256 public MAX_MINTS = 10;
1293     string public baseURI = "ipfs:///";
1294     string public baseExtension = ".json";
1295      bool public paused = true;
1296     
1297     constructor() ERC721A("Crash Landers", "CRASH", MAX_MINTS, MAX_SUPPLY) {  
1298     }
1299     
1300 
1301     function Mint(uint256 numTokens) public payable {
1302         require(!paused, "Paused");
1303         require(numTokens > 0 && numTokens <= MAX_MINTS);
1304         require(totalSupply() + numTokens <= MAX_SUPPLY);
1305         require(MAX_MINTS >= numTokens, "Excess max per paid tx");
1306         require(msg.value >= numTokens * NFT_PRICE, "Invalid funds provided");
1307         _safeMint(msg.sender, numTokens);
1308     }
1309 
1310     function DevsMint(uint256 numTokens) public payable onlyOwner {
1311         _safeMint(msg.sender, numTokens);
1312     }
1313 
1314 
1315     function pause(bool _state) public onlyOwner {
1316         paused = _state;
1317     }
1318 
1319     function setBaseURI(string memory newBaseURI) public onlyOwner {
1320         baseURI = newBaseURI;
1321     }
1322     function tokenURI(uint256 _tokenId)
1323         public
1324         view
1325         override
1326         returns (string memory)
1327     {
1328         require(_exists(_tokenId), "That token doesn't exist");
1329         return
1330             bytes(baseURI).length > 0
1331                 ? string(
1332                     abi.encodePacked(
1333                         baseURI,
1334                         Strings.toString(_tokenId),
1335                         baseExtension
1336                     )
1337                 )
1338                 : "";
1339     }
1340 
1341     function setPrice(uint256 newPrice) public onlyOwner {
1342         NFT_PRICE = newPrice;
1343     }
1344 
1345     function setMaxMints(uint256 newMax) public onlyOwner {
1346         MAX_MINTS = newMax;
1347     }
1348 
1349     function _baseURI() internal view virtual override returns (string memory) {
1350         return baseURI;
1351     }
1352 
1353     function withdrawMoney() external onlyOwner {
1354       (bool success, ) = msg.sender.call{value: address(this).balance}("");
1355       require(success, "WITHDRAW FAILED!");
1356     }
1357 }