1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-17
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-07-13
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-07-11
11 */
12 
13 // SPDX-License-Identifier: MIT
14 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Interface of the ERC165 standard, as defined in the
20  * https://eips.ethereum.org/EIPS/eip-165[EIP].
21  *
22  * Implementers can declare support of contract interfaces, which can then be
23  * queried by others ({ERC165Checker}).
24  *
25  * For an implementation, see {ERC165}.
26  */
27 interface IERC165 {
28     /**
29      * @dev Returns true if this contract implements the interface defined by
30      * `interfaceId`. See the corresponding
31      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
32      * to learn more about how these ids are created.
33      *
34      * This function call must use less than 30 000 gas.
35      */
36     function supportsInterface(bytes4 interfaceId) external view returns (bool);
37 }
38 
39 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
40 
41 pragma solidity ^0.8.0;
42 
43 /**
44  * @dev Required interface of an ERC721 compliant contract.
45  */
46 interface IERC721 is IERC165 {
47     /**
48      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
49      */
50     event Transfer(
51         address indexed from,
52         address indexed to,
53         uint256 indexed tokenId
54     );
55 
56     /**
57      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
58      */
59     event Approval(
60         address indexed owner,
61         address indexed approved,
62         uint256 indexed tokenId
63     );
64 
65     /**
66      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
67      */
68     event ApprovalForAll(
69         address indexed owner,
70         address indexed operator,
71         bool approved
72     );
73 
74     /**
75      * @dev Returns the number of tokens in ``owner``'s account.
76      */
77     function balanceOf(address owner) external view returns (uint256 balance);
78 
79     /**
80      * @dev Returns the owner of the `tokenId` token.
81      *
82      * Requirements:
83      *
84      * - `tokenId` must exist.
85      */
86     function ownerOf(uint256 tokenId) external view returns (address owner);
87 
88     /**
89      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
90      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must exist and be owned by `from`.
97      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
98      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
99      *
100      * Emits a {Transfer} event.
101      */
102     function safeTransferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Transfers `tokenId` token from `from` to `to`.
110      *
111      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
112      *
113      * Requirements:
114      *
115      * - `from` cannot be the zero address.
116      * - `to` cannot be the zero address.
117      * - `tokenId` token must be owned by `from`.
118      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transferFrom(
123         address from,
124         address to,
125         uint256 tokenId
126     ) external;
127 
128     /**
129      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
130      * The approval is cleared when the token is transferred.
131      *
132      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
133      *
134      * Requirements:
135      *
136      * - The caller must own the token or be an approved operator.
137      * - `tokenId` must exist.
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address to, uint256 tokenId) external;
142 
143     /**
144      * @dev Returns the account approved for `tokenId` token.
145      *
146      * Requirements:
147      *
148      * - `tokenId` must exist.
149      */
150     function getApproved(uint256 tokenId)
151         external
152         view
153         returns (address operator);
154 
155     /**
156      * @dev Approve or remove `operator` as an operator for the caller.
157      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
158      *
159      * Requirements:
160      *
161      * - The `operator` cannot be the caller.
162      *
163      * Emits an {ApprovalForAll} event.
164      */
165     function setApprovalForAll(address operator, bool _approved) external;
166 
167     /**
168      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
169      *
170      * See {setApprovalForAll}
171      */
172     function isApprovedForAll(address owner, address operator)
173         external
174         view
175         returns (bool);
176 
177     /**
178      * @dev Safely transfers `tokenId` token from `from` to `to`.
179      *
180      * Requirements:
181      *
182      * - `from` cannot be the zero address.
183      * - `to` cannot be the zero address.
184      * - `tokenId` token must exist and be owned by `from`.
185      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
186      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
187      *
188      * Emits a {Transfer} event.
189      */
190     function safeTransferFrom(
191         address from,
192         address to,
193         uint256 tokenId,
194         bytes calldata data
195     ) external;
196 }
197 
198 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
199 
200 pragma solidity ^0.8.0;
201 
202 /**
203  * @title ERC721 token receiver interface
204  * @dev Interface for any contract that wants to support safeTransfers
205  * from ERC721 asset contracts.
206  */
207 interface IERC721Receiver {
208     /**
209      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
210      * by `operator` from `from`, this function is called.
211      *
212      * It must return its Solidity selector to confirm the token transfer.
213      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
214      *
215      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
216      */
217     function onERC721Received(
218         address operator,
219         address from,
220         uint256 tokenId,
221         bytes calldata data
222     ) external returns (bytes4);
223 }
224 
225 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
231  * @dev See https://eips.ethereum.org/EIPS/eip-721
232  */
233 interface IERC721Metadata is IERC721 {
234     /**
235      * @dev Returns the token collection name.
236      */
237     function name() external view returns (string memory);
238 
239     /**
240      * @dev Returns the token collection symbol.
241      */
242     function symbol() external view returns (string memory);
243 
244     /**
245      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
246      */
247     function tokenURI(uint256 tokenId) external view returns (string memory);
248 }
249 
250 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
251 
252 pragma solidity ^0.8.0;
253 
254 /**
255  * @dev Implementation of the {IERC165} interface.
256  *
257  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
258  * for the additional interface id that will be supported. For example:
259  *
260  * ```solidity
261  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
262  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
263  * }
264  * ```
265  *
266  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
267  */
268 abstract contract ERC165 is IERC165 {
269     /**
270      * @dev See {IERC165-supportsInterface}.
271      */
272     function supportsInterface(bytes4 interfaceId)
273         public
274         view
275         virtual
276         override
277         returns (bool)
278     {
279         return interfaceId == type(IERC165).interfaceId;
280     }
281 }
282 
283 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
284 
285 pragma solidity ^0.8.0;
286 
287 /**
288  * @dev Collection of functions related to the address type
289  */
290 library Address {
291     /**
292      * @dev Returns true if `account` is a contract.
293      *
294      * [IMPORTANT]
295      * ====
296      * It is unsafe to assume that an address for which this function returns
297      * false is an externally-owned account (EOA) and not a contract.
298      *
299      * Among others, `isContract` will return false for the following
300      * types of addresses:
301      *
302      *  - an externally-owned account
303      *  - a contract in construction
304      *  - an address where a contract will be created
305      *  - an address where a contract lived, but was destroyed
306      * ====
307      */
308     function isContract(address account) internal view returns (bool) {
309         // This method relies on extcodesize, which returns 0 for contracts in
310         // construction, since the code is only stored at the end of the
311         // constructor execution.
312 
313         uint256 size;
314         assembly {
315             size := extcodesize(account)
316         }
317         return size > 0;
318     }
319 
320     /**
321      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
322      * `recipient`, forwarding all available gas and reverting on errors.
323      *
324      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
325      * of certain opcodes, possibly making contracts go over the 2300 gas limit
326      * imposed by `transfer`, making them unable to receive funds via
327      * `transfer`. {sendValue} removes this limitation.
328      *
329      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
330      *
331      * IMPORTANT: because control is transferred to `recipient`, care must be
332      * taken to not create reentrancy vulnerabilities. Consider using
333      * {ReentrancyGuard} or the
334      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
335      */
336     function sendValue(address payable recipient, uint256 amount) internal {
337         require(
338             address(this).balance >= amount,
339             "Address: insufficient balance"
340         );
341 
342         (bool success, ) = recipient.call{value: amount}("");
343         require(
344             success,
345             "Address: unable to send value, recipient may have reverted"
346         );
347     }
348 
349     /**
350      * @dev Performs a Solidity function call using a low level `call`. A
351      * plain `call` is an unsafe replacement for a function call: use this
352      * function instead.
353      *
354      * If `target` reverts with a revert reason, it is bubbled up by this
355      * function (like regular Solidity function calls).
356      *
357      * Returns the raw returned data. To convert to the expected return value,
358      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
359      *
360      * Requirements:
361      *
362      * - `target` must be a contract.
363      * - calling `target` with `data` must not revert.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data)
368         internal
369         returns (bytes memory)
370     {
371         return functionCall(target, data, "Address: low-level call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
376      * `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, 0, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but also transferring `value` wei to `target`.
391      *
392      * Requirements:
393      *
394      * - the calling contract must have an ETH balance of at least `value`.
395      * - the called Solidity function must be `payable`.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(
400         address target,
401         bytes memory data,
402         uint256 value
403     ) internal returns (bytes memory) {
404         return
405             functionCallWithValue(
406                 target,
407                 data,
408                 value,
409                 "Address: low-level call with value failed"
410             );
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
415      * with `errorMessage` as a fallback revert reason when `target` reverts.
416      *
417      * _Available since v3.1._
418      */
419     function functionCallWithValue(
420         address target,
421         bytes memory data,
422         uint256 value,
423         string memory errorMessage
424     ) internal returns (bytes memory) {
425         require(
426             address(this).balance >= value,
427             "Address: insufficient balance for call"
428         );
429         require(isContract(target), "Address: call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.call{value: value}(
432             data
433         );
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(address target, bytes memory data)
444         internal
445         view
446         returns (bytes memory)
447     {
448         return
449             functionStaticCall(
450                 target,
451                 data,
452                 "Address: low-level static call failed"
453             );
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a static call.
459      *
460      * _Available since v3.3._
461      */
462     function functionStaticCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal view returns (bytes memory) {
467         require(isContract(target), "Address: static call to non-contract");
468 
469         (bool success, bytes memory returndata) = target.staticcall(data);
470         return verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but performing a delegate call.
476      *
477      * _Available since v3.4._
478      */
479     function functionDelegateCall(address target, bytes memory data)
480         internal
481         returns (bytes memory)
482     {
483         return
484             functionDelegateCall(
485                 target,
486                 data,
487                 "Address: low-level delegate call failed"
488             );
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
493      * but performing a delegate call.
494      *
495      * _Available since v3.4._
496      */
497     function functionDelegateCall(
498         address target,
499         bytes memory data,
500         string memory errorMessage
501     ) internal returns (bytes memory) {
502         require(isContract(target), "Address: delegate call to non-contract");
503 
504         (bool success, bytes memory returndata) = target.delegatecall(data);
505         return verifyCallResult(success, returndata, errorMessage);
506     }
507 
508     /**
509      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
510      * revert reason using the provided one.
511      *
512      * _Available since v4.3._
513      */
514     function verifyCallResult(
515         bool success,
516         bytes memory returndata,
517         string memory errorMessage
518     ) internal pure returns (bytes memory) {
519         if (success) {
520             return returndata;
521         } else {
522             // Look for revert reason and bubble it up if present
523             if (returndata.length > 0) {
524                 // The easiest way to bubble the revert reason is using memory via assembly
525 
526                 assembly {
527                     let returndata_size := mload(returndata)
528                     revert(add(32, returndata), returndata_size)
529                 }
530             } else {
531                 revert(errorMessage);
532             }
533         }
534     }
535 }
536 
537 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev Provides information about the current execution context, including the
543  * sender of the transaction and its data. While these are generally available
544  * via msg.sender and msg.data, they should not be accessed in such a direct
545  * manner, since when dealing with meta-transactions the account sending and
546  * paying for execution may not be the actual sender (as far as an application
547  * is concerned).
548  *
549  * This contract is only required for intermediate, library-like contracts.
550  */
551 abstract contract Context {
552     function _msgSender() internal view virtual returns (address) {
553         return msg.sender;
554     }
555 
556     function _msgData() internal view virtual returns (bytes calldata) {
557         return msg.data;
558     }
559 }
560 
561 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 /**
566  * @dev String operations.
567  */
568 library Strings {
569     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
570 
571     /**
572      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
573      */
574     function toString(uint256 value) internal pure returns (string memory) {
575         // Inspired by OraclizeAPI's implementation - MIT licence
576         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
577 
578         if (value == 0) {
579             return "0";
580         }
581         uint256 temp = value;
582         uint256 digits;
583         while (temp != 0) {
584             digits++;
585             temp /= 10;
586         }
587         bytes memory buffer = new bytes(digits);
588         while (value != 0) {
589             digits -= 1;
590             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
591             value /= 10;
592         }
593         return string(buffer);
594     }
595 
596     /**
597      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
598      */
599     function toHexString(uint256 value) internal pure returns (string memory) {
600         if (value == 0) {
601             return "0x00";
602         }
603         uint256 temp = value;
604         uint256 length = 0;
605         while (temp != 0) {
606             length++;
607             temp >>= 8;
608         }
609         return toHexString(value, length);
610     }
611 
612     /**
613      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
614      */
615     function toHexString(uint256 value, uint256 length)
616         internal
617         pure
618         returns (string memory)
619     {
620         bytes memory buffer = new bytes(2 * length + 2);
621         buffer[0] = "0";
622         buffer[1] = "x";
623         for (uint256 i = 2 * length + 1; i > 1; --i) {
624             buffer[i] = _HEX_SYMBOLS[value & 0xf];
625             value >>= 4;
626         }
627         require(value == 0, "Strings: hex length insufficient");
628         return string(buffer);
629     }
630 }
631 
632 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
633 
634 pragma solidity ^0.8.0;
635 
636 /**
637  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
638  * @dev See https://eips.ethereum.org/EIPS/eip-721
639  */
640 interface IERC721Enumerable is IERC721 {
641     /**
642      * @dev Returns the total amount of tokens stored by the contract.
643      */
644     function totalSupply() external view returns (uint256);
645 
646     /**
647      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
648      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
649      */
650     function tokenOfOwnerByIndex(address owner, uint256 index)
651         external
652         view
653         returns (uint256 tokenId);
654 
655     /**
656      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
657      * Use along with {totalSupply} to enumerate all tokens.
658      */
659     function tokenByIndex(uint256 index) external view returns (uint256);
660 }
661 
662 pragma solidity ^0.8.0;
663 
664 /**
665  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
666  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
667  *
668  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
669  *
670  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
671  *
672  * Does not support burning tokens to address(0).
673  */
674 contract ERC721A is
675   Context,
676   ERC165,
677   IERC721,
678   IERC721Metadata,
679   IERC721Enumerable
680 {
681   using Address for address;
682   using Strings for uint256;
683 
684   struct TokenOwnership {
685     address addr;
686     uint64 startTimestamp;
687   }
688 
689   struct AddressData {
690     uint128 balance;
691     uint128 numberMinted;
692   }
693 
694   uint256 private currentIndex = 0;
695 
696   uint256 internal immutable collectionSize;
697   uint256 internal immutable maxBatchSize;
698 
699   // Token name
700   string private _name;
701 
702   // Token symbol
703   string private _symbol;
704 
705   // Mapping from token ID to ownership details
706   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
707   mapping(uint256 => TokenOwnership) private _ownerships;
708 
709   // Mapping owner address to address data
710   mapping(address => AddressData) private _addressData;
711 
712   // Mapping from token ID to approved address
713   mapping(uint256 => address) private _tokenApprovals;
714 
715   // Mapping from owner to operator approvals
716   mapping(address => mapping(address => bool)) private _operatorApprovals;
717 
718   /**
719    * @dev
720    * `maxBatchSize` refers to how much a minter can mint at a time.
721    * `collectionSize_` refers to how many tokens are in the collection.
722    */
723   constructor(
724     string memory name_,
725     string memory symbol_,
726     uint256 maxBatchSize_,
727     uint256 collectionSize_
728   ) {
729     require(
730       collectionSize_ > 0,
731       "ERC721A: collection must have a nonzero supply"
732     );
733     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
734     _name = name_;
735     _symbol = symbol_;
736     maxBatchSize = maxBatchSize_;
737     collectionSize = collectionSize_;
738   }
739 
740   /**
741    * @dev See {IERC721Enumerable-totalSupply}.
742    */
743   function totalSupply() public view override returns (uint256) {
744     return currentIndex;
745   }
746 
747   /**
748    * @dev See {IERC721Enumerable-tokenByIndex}.
749    */
750   function tokenByIndex(uint256 index) public view override returns (uint256) {
751     require(index < totalSupply(), "ERC721A: global index out of bounds");
752     return index;
753   }
754 
755   /**
756    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
757    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
758    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
759    */
760   function tokenOfOwnerByIndex(address owner, uint256 index)
761     public
762     view
763     override
764     returns (uint256)
765   {
766     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
767     uint256 numMintedSoFar = totalSupply();
768     uint256 tokenIdsIdx = 0;
769     address currOwnershipAddr = address(0);
770     for (uint256 i = 0; i < numMintedSoFar; i++) {
771       TokenOwnership memory ownership = _ownerships[i];
772       if (ownership.addr != address(0)) {
773         currOwnershipAddr = ownership.addr;
774       }
775       if (currOwnershipAddr == owner) {
776         if (tokenIdsIdx == index) {
777           return i;
778         }
779         tokenIdsIdx++;
780       }
781     }
782     revert("ERC721A: unable to get token of owner by index");
783   }
784 
785   /**
786    * @dev See {IERC165-supportsInterface}.
787    */
788   function supportsInterface(bytes4 interfaceId)
789     public
790     view
791     virtual
792     override(ERC165, IERC165)
793     returns (bool)
794   {
795     return
796       interfaceId == type(IERC721).interfaceId ||
797       interfaceId == type(IERC721Metadata).interfaceId ||
798       interfaceId == type(IERC721Enumerable).interfaceId ||
799       super.supportsInterface(interfaceId);
800   }
801 
802   /**
803    * @dev See {IERC721-balanceOf}.
804    */
805   function balanceOf(address owner) public view override returns (uint256) {
806     require(owner != address(0), "ERC721A: balance query for the zero address");
807     return uint256(_addressData[owner].balance);
808   }
809 
810   function _numberMinted(address owner) internal view returns (uint256) {
811     require(
812       owner != address(0),
813       "ERC721A: number minted query for the zero address"
814     );
815     return uint256(_addressData[owner].numberMinted);
816   }
817 
818   function ownershipOf(uint256 tokenId)
819     internal
820     view
821     returns (TokenOwnership memory)
822   {
823     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
824 
825     uint256 lowestTokenToCheck;
826     if (tokenId >= maxBatchSize) {
827       lowestTokenToCheck = tokenId - maxBatchSize + 1;
828     }
829 
830     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
831       TokenOwnership memory ownership = _ownerships[curr];
832       if (ownership.addr != address(0)) {
833         return ownership;
834       }
835     }
836 
837     revert("ERC721A: unable to determine the owner of token");
838   }
839 
840   /**
841    * @dev See {IERC721-ownerOf}.
842    */
843   function ownerOf(uint256 tokenId) public view override returns (address) {
844     return ownershipOf(tokenId).addr;
845   }
846 
847   /**
848    * @dev See {IERC721Metadata-name}.
849    */
850   function name() public view virtual override returns (string memory) {
851     return _name;
852   }
853 
854   /**
855    * @dev See {IERC721Metadata-symbol}.
856    */
857   function symbol() public view virtual override returns (string memory) {
858     return _symbol;
859   }
860 
861   /**
862    * @dev See {IERC721Metadata-tokenURI}.
863    */
864   function tokenURI(uint256 tokenId)
865     public
866     view
867     virtual
868     override
869     returns (string memory)
870   {
871     require(
872       _exists(tokenId),
873       "ERC721Metadata: URI query for nonexistent token"
874     );
875 
876     string memory baseURI = _baseURI();
877     return
878       bytes(baseURI).length > 0
879         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
880         : "";
881   }
882 
883   /**
884    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
885    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
886    * by default, can be overriden in child contracts.
887    */
888   function _baseURI() internal view virtual returns (string memory) {
889     return "";
890   }
891 
892   /**
893    * @dev See {IERC721-approve}.
894    */
895   function approve(address to, uint256 tokenId) public override {
896     address owner = ERC721A.ownerOf(tokenId);
897     require(to != owner, "ERC721A: approval to current owner");
898 
899     require(
900       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
901       "ERC721A: approve caller is not owner nor approved for all"
902     );
903 
904     _approve(to, tokenId, owner);
905   }
906 
907   /**
908    * @dev See {IERC721-getApproved}.
909    */
910   function getApproved(uint256 tokenId) public view override returns (address) {
911     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
912 
913     return _tokenApprovals[tokenId];
914   }
915 
916   /**
917    * @dev See {IERC721-setApprovalForAll}.
918    */
919   function setApprovalForAll(address operator, bool approved) public override {
920     require(operator != _msgSender(), "ERC721A: approve to caller");
921 
922     _operatorApprovals[_msgSender()][operator] = approved;
923     emit ApprovalForAll(_msgSender(), operator, approved);
924   }
925 
926   /**
927    * @dev See {IERC721-isApprovedForAll}.
928    */
929   function isApprovedForAll(address owner, address operator)
930     public
931     view
932     virtual
933     override
934     returns (bool)
935   {
936     return _operatorApprovals[owner][operator];
937   }
938 
939   /**
940    * @dev See {IERC721-transferFrom}.
941    */
942   function transferFrom(
943     address from,
944     address to,
945     uint256 tokenId
946   ) public override {
947     _transfer(from, to, tokenId);
948   }
949 
950   /**
951    * @dev See {IERC721-safeTransferFrom}.
952    */
953   function safeTransferFrom(
954     address from,
955     address to,
956     uint256 tokenId
957   ) public override {
958     safeTransferFrom(from, to, tokenId, "");
959   }
960 
961   /**
962    * @dev See {IERC721-safeTransferFrom}.
963    */
964   function safeTransferFrom(
965     address from,
966     address to,
967     uint256 tokenId,
968     bytes memory _data
969   ) public override {
970     _transfer(from, to, tokenId);
971     require(
972       _checkOnERC721Received(from, to, tokenId, _data),
973       "ERC721A: transfer to non ERC721Receiver implementer"
974     );
975   }
976 
977   /**
978    * @dev Returns whether `tokenId` exists.
979    *
980    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
981    *
982    * Tokens start existing when they are minted (`_mint`),
983    */
984   function _exists(uint256 tokenId) internal view returns (bool) {
985     return tokenId < currentIndex;
986   }
987 
988   function _safeMint(address to, uint256 quantity) internal {
989     _safeMint(to, quantity, "");
990   }
991 
992   /**
993    * @dev Mints `quantity` tokens and transfers them to `to`.
994    *
995    * Requirements:
996    *
997    * - there must be `quantity` tokens remaining unminted in the total collection.
998    * - `to` cannot be the zero address.
999    * - `quantity` cannot be larger than the max batch size.
1000    *
1001    * Emits a {Transfer} event.
1002    */
1003   function _safeMint(
1004     address to,
1005     uint256 quantity,
1006     bytes memory _data
1007   ) internal {
1008     uint256 startTokenId = currentIndex;
1009     require(to != address(0), "ERC721A: mint to the zero address");
1010     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1011     require(!_exists(startTokenId), "ERC721A: token already minted");
1012     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1013 
1014     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1015 
1016     AddressData memory addressData = _addressData[to];
1017     _addressData[to] = AddressData(
1018       addressData.balance + uint128(quantity),
1019       addressData.numberMinted + uint128(quantity)
1020     );
1021     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1022 
1023     uint256 updatedIndex = startTokenId;
1024 
1025     for (uint256 i = 0; i < quantity; i++) {
1026       emit Transfer(address(0), to, updatedIndex);
1027       require(
1028         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1029         "ERC721A: transfer to non ERC721Receiver implementer"
1030       );
1031       updatedIndex++;
1032     }
1033 
1034     currentIndex = updatedIndex;
1035     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1036   }
1037 
1038   /**
1039    * @dev Transfers `tokenId` from `from` to `to`.
1040    *
1041    * Requirements:
1042    *
1043    * - `to` cannot be the zero address.
1044    * - `tokenId` token must be owned by `from`.
1045    *
1046    * Emits a {Transfer} event.
1047    */
1048   function _transfer(
1049     address from,
1050     address to,
1051     uint256 tokenId
1052   ) private {
1053     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1054 
1055     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1056       getApproved(tokenId) == _msgSender() ||
1057       isApprovedForAll(prevOwnership.addr, _msgSender()));
1058 
1059     require(
1060       isApprovedOrOwner,
1061       "ERC721A: transfer caller is not owner nor approved"
1062     );
1063 
1064     require(
1065       prevOwnership.addr == from,
1066       "ERC721A: transfer from incorrect owner"
1067     );
1068     require(to != address(0), "ERC721A: transfer to the zero address");
1069 
1070     _beforeTokenTransfers(from, to, tokenId, 1);
1071 
1072     // Clear approvals from the previous owner
1073     _approve(address(0), tokenId, prevOwnership.addr);
1074 
1075     _addressData[from].balance -= 1;
1076     _addressData[to].balance += 1;
1077     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1078 
1079     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1080     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1081     uint256 nextTokenId = tokenId + 1;
1082     if (_ownerships[nextTokenId].addr == address(0)) {
1083       if (_exists(nextTokenId)) {
1084         _ownerships[nextTokenId] = TokenOwnership(
1085           prevOwnership.addr,
1086           prevOwnership.startTimestamp
1087         );
1088       }
1089     }
1090 
1091     emit Transfer(from, to, tokenId);
1092     _afterTokenTransfers(from, to, tokenId, 1);
1093   }
1094 
1095   /**
1096    * @dev Approve `to` to operate on `tokenId`
1097    *
1098    * Emits a {Approval} event.
1099    */
1100   function _approve(
1101     address to,
1102     uint256 tokenId,
1103     address owner
1104   ) private {
1105     _tokenApprovals[tokenId] = to;
1106     emit Approval(owner, to, tokenId);
1107   }
1108 
1109   uint256 public nextOwnerToExplicitlySet = 0;
1110 
1111   /**
1112    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1113    */
1114   function _setOwnersExplicit(uint256 quantity) internal {
1115     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1116     require(quantity > 0, "quantity must be nonzero");
1117     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1118     if (endIndex > collectionSize - 1) {
1119       endIndex = collectionSize - 1;
1120     }
1121     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1122     require(_exists(endIndex), "not enough minted yet for this cleanup");
1123     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1124       if (_ownerships[i].addr == address(0)) {
1125         TokenOwnership memory ownership = ownershipOf(i);
1126         _ownerships[i] = TokenOwnership(
1127           ownership.addr,
1128           ownership.startTimestamp
1129         );
1130       }
1131     }
1132     nextOwnerToExplicitlySet = endIndex + 1;
1133   }
1134 
1135   /**
1136    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1137    * The call is not executed if the target address is not a contract.
1138    *
1139    * @param from address representing the previous owner of the given token ID
1140    * @param to target address that will receive the tokens
1141    * @param tokenId uint256 ID of the token to be transferred
1142    * @param _data bytes optional data to send along with the call
1143    * @return bool whether the call correctly returned the expected magic value
1144    */
1145   function _checkOnERC721Received(
1146     address from,
1147     address to,
1148     uint256 tokenId,
1149     bytes memory _data
1150   ) private returns (bool) {
1151     if (to.isContract()) {
1152       try
1153         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1154       returns (bytes4 retval) {
1155         return retval == IERC721Receiver(to).onERC721Received.selector;
1156       } catch (bytes memory reason) {
1157         if (reason.length == 0) {
1158           revert("ERC721A: transfer to non ERC721Receiver implementer");
1159         } else {
1160           assembly {
1161             revert(add(32, reason), mload(reason))
1162           }
1163         }
1164       }
1165     } else {
1166       return true;
1167     }
1168   }
1169 
1170   /**
1171    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1172    *
1173    * startTokenId - the first token id to be transferred
1174    * quantity - the amount to be transferred
1175    *
1176    * Calling conditions:
1177    *
1178    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1179    * transferred to `to`.
1180    * - When `from` is zero, `tokenId` will be minted for `to`.
1181    */
1182   function _beforeTokenTransfers(
1183     address from,
1184     address to,
1185     uint256 startTokenId,
1186     uint256 quantity
1187   ) internal virtual {}
1188 
1189   /**
1190    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1191    * minting.
1192    *
1193    * startTokenId - the first token id to be transferred
1194    * quantity - the amount to be transferred
1195    *
1196    * Calling conditions:
1197    *
1198    * - when `from` and `to` are both non-zero.
1199    * - `from` and `to` are never both zero.
1200    */
1201   function _afterTokenTransfers(
1202     address from,
1203     address to,
1204     uint256 startTokenId,
1205     uint256 quantity
1206   ) internal virtual {}
1207 }
1208 
1209 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1210 
1211 pragma solidity ^0.8.0;
1212 
1213 /**
1214  * @dev Contract module which provides a basic access control mechanism, where
1215  * there is an account (an owner) that can be granted exclusive access to
1216  * specific functions.
1217  *
1218  * By default, the owner account will be the one that deploys the contract. This
1219  * can later be changed with {transferOwnership}.
1220  *
1221  * This module is used through inheritance. It will make available the modifier
1222  * `onlyOwner`, which can be applied to your functions to restrict their use to
1223  * the owner.
1224  */
1225 abstract contract Ownable is Context {
1226     address private _owner;
1227 
1228     event OwnershipTransferred(
1229         address indexed previousOwner,
1230         address indexed newOwner
1231     );
1232 
1233     /**
1234      * @dev Initializes the contract setting the deployer as the initial owner.
1235      */
1236     constructor() {
1237         _transferOwnership(_msgSender());
1238     }
1239 
1240     /**
1241      * @dev Returns the address of the current owner.
1242      */
1243     function owner() public view virtual returns (address) {
1244         return _owner;
1245     }
1246 
1247     /**
1248      * @dev Throws if called by any account other than the owner.
1249      */
1250     modifier onlyOwner() {
1251         require(owner() == _msgSender(), "You are not the owner");
1252         _;
1253     }
1254 
1255     /**
1256      * @dev Leaves the contract without owner. It will not be possible to call
1257      * `onlyOwner` functions anymore. Can only be called by the current owner.
1258      *
1259      * NOTE: Renouncing ownership will leave the contract without an owner,
1260      * thereby removing any functionality that is only available to the owner.
1261      */
1262     function renounceOwnership() public virtual onlyOwner {
1263         _transferOwnership(address(0));
1264     }
1265 
1266     /**
1267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1268      * Can only be called by the current owner.
1269      */
1270     function transferOwnership(address newOwner) public virtual onlyOwner {
1271         require(
1272             newOwner != address(0),
1273             "Ownable: new owner is the zero address"
1274         );
1275         _transferOwnership(newOwner);
1276     }
1277 
1278     /**
1279      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1280      * Internal function without access restriction.
1281      */
1282     function _transferOwnership(address newOwner) internal virtual {
1283         address oldOwner = _owner;
1284         _owner = newOwner;
1285         emit OwnershipTransferred(oldOwner, newOwner);
1286     }
1287 }
1288 
1289 
1290 pragma solidity ^0.8.0;
1291 
1292 contract DESKELETONS is ERC721A, Ownable {
1293     uint256 public NFT_PRICE = 0 ether;
1294     uint256 public MAX_SUPPLY = 3000;
1295     uint256 public MAX_MINTS = 275;
1296     string public baseURI = "https://theklubrises.mypinata.cloud/ipfs/Qmbkytx83im144JV7g9sfSqufZujuBXFoP4kRx6mkM4WEG/";
1297     string public baseExtension = "";
1298      bool public paused = true;   
1299     
1300     constructor() ERC721A("DESKELETONS", "DE", MAX_MINTS, MAX_SUPPLY) {  
1301         _safeMint(_msgSender(), 1);
1302     }
1303     
1304 
1305     function FreeMint(uint256 numTokens) public payable {
1306         require(!paused, "Paused");
1307         require(numTokens <= 3 && numTokens >0);
1308         _safeMint(msg.sender, numTokens);
1309     }
1310 
1311     function ArtisttMint(uint256 numTokens) public payable onlyOwner {
1312         _safeMint(msg.sender, numTokens);
1313     }
1314 
1315 
1316     function pause(bool _state) public onlyOwner {
1317         paused = _state;
1318     }
1319 
1320     function setBaseURI(string memory newBaseURI) public onlyOwner {
1321         baseURI = newBaseURI;
1322     }
1323     function tokenURI(uint256 _tokenId)
1324         public
1325         view
1326         override
1327         returns (string memory)
1328     {
1329         require(_exists(_tokenId), "That token doesn't exist");
1330         return
1331             bytes(baseURI).length > 0
1332                 ? string(
1333                     abi.encodePacked(
1334                         baseURI,
1335                         Strings.toString(_tokenId),
1336                         baseExtension
1337                     )
1338                 )
1339                 : "";
1340     }
1341 
1342     function _baseURI() internal view virtual override returns (string memory) {
1343         return baseURI;
1344     }
1345 }