1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-02
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
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
190 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
191 
192 pragma solidity ^0.8.0;
193 
194 /**
195  * @title ERC721 token receiver interface
196  * @dev Interface for any contract that wants to support safeTransfers
197  * from ERC721 asset contracts.
198  */
199 interface IERC721Receiver {
200     /**
201      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
202      * by `operator` from `from`, this function is called.
203      *
204      * It must return its Solidity selector to confirm the token transfer.
205      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
206      *
207      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
208      */
209     function onERC721Received(
210         address operator,
211         address from,
212         uint256 tokenId,
213         bytes calldata data
214     ) external returns (bytes4);
215 }
216 
217 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
218 
219 pragma solidity ^0.8.0;
220 
221 /**
222  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
223  * @dev See https://eips.ethereum.org/EIPS/eip-721
224  */
225 interface IERC721Metadata is IERC721 {
226     /**
227      * @dev Returns the token collection name.
228      */
229     function name() external view returns (string memory);
230 
231     /**
232      * @dev Returns the token collection symbol.
233      */
234     function symbol() external view returns (string memory);
235 
236     /**
237      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
238      */
239     function tokenURI(uint256 tokenId) external view returns (string memory);
240 }
241 
242 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @dev Implementation of the {IERC165} interface.
248  *
249  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
250  * for the additional interface id that will be supported. For example:
251  *
252  * ```solidity
253  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
254  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
255  * }
256  * ```
257  *
258  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
259  */
260 abstract contract ERC165 is IERC165 {
261     /**
262      * @dev See {IERC165-supportsInterface}.
263      */
264     function supportsInterface(bytes4 interfaceId)
265         public
266         view
267         virtual
268         override
269         returns (bool)
270     {
271         return interfaceId == type(IERC165).interfaceId;
272     }
273 }
274 
275 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @dev Collection of functions related to the address type
281  */
282 library Address {
283     /**
284      * @dev Returns true if `account` is a contract.
285      *
286      * [IMPORTANT]
287      * ====
288      * It is unsafe to assume that an address for which this function returns
289      * false is an externally-owned account (EOA) and not a contract.
290      *
291      * Among others, `isContract` will return false for the following
292      * types of addresses:
293      *
294      *  - an externally-owned account
295      *  - a contract in construction
296      *  - an address where a contract will be created
297      *  - an address where a contract lived, but was destroyed
298      * ====
299      */
300     function isContract(address account) internal view returns (bool) {
301         // This method relies on extcodesize, which returns 0 for contracts in
302         // construction, since the code is only stored at the end of the
303         // constructor execution.
304 
305         uint256 size;
306         assembly {
307             size := extcodesize(account)
308         }
309         return size > 0;
310     }
311 
312     /**
313      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
314      * `recipient`, forwarding all available gas and reverting on errors.
315      *
316      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
317      * of certain opcodes, possibly making contracts go over the 2300 gas limit
318      * imposed by `transfer`, making them unable to receive funds via
319      * `transfer`. {sendValue} removes this limitation.
320      *
321      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
322      *
323      * IMPORTANT: because control is transferred to `recipient`, care must be
324      * taken to not create reentrancy vulnerabilities. Consider using
325      * {ReentrancyGuard} or the
326      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
327      */
328     function sendValue(address payable recipient, uint256 amount) internal {
329         require(
330             address(this).balance >= amount,
331             "Address: insufficient balance"
332         );
333 
334         (bool success, ) = recipient.call{value: amount}("");
335         require(
336             success,
337             "Address: unable to send value, recipient may have reverted"
338         );
339     }
340 
341     /**
342      * @dev Performs a Solidity function call using a low level `call`. A
343      * plain `call` is an unsafe replacement for a function call: use this
344      * function instead.
345      *
346      * If `target` reverts with a revert reason, it is bubbled up by this
347      * function (like regular Solidity function calls).
348      *
349      * Returns the raw returned data. To convert to the expected return value,
350      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
351      *
352      * Requirements:
353      *
354      * - `target` must be a contract.
355      * - calling `target` with `data` must not revert.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data)
360         internal
361         returns (bytes memory)
362     {
363         return functionCall(target, data, "Address: low-level call failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
368      * `errorMessage` as a fallback revert reason when `target` reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCall(
373         address target,
374         bytes memory data,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, 0, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but also transferring `value` wei to `target`.
383      *
384      * Requirements:
385      *
386      * - the calling contract must have an ETH balance of at least `value`.
387      * - the called Solidity function must be `payable`.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(
392         address target,
393         bytes memory data,
394         uint256 value
395     ) internal returns (bytes memory) {
396         return
397             functionCallWithValue(
398                 target,
399                 data,
400                 value,
401                 "Address: low-level call with value failed"
402             );
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
407      * with `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCallWithValue(
412         address target,
413         bytes memory data,
414         uint256 value,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         require(
418             address(this).balance >= value,
419             "Address: insufficient balance for call"
420         );
421         require(isContract(target), "Address: call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.call{value: value}(
424             data
425         );
426         return verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but performing a static call.
432      *
433      * _Available since v3.3._
434      */
435     function functionStaticCall(address target, bytes memory data)
436         internal
437         view
438         returns (bytes memory)
439     {
440         return
441             functionStaticCall(
442                 target,
443                 data,
444                 "Address: low-level static call failed"
445             );
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
450      * but performing a static call.
451      *
452      * _Available since v3.3._
453      */
454     function functionStaticCall(
455         address target,
456         bytes memory data,
457         string memory errorMessage
458     ) internal view returns (bytes memory) {
459         require(isContract(target), "Address: static call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.staticcall(data);
462         return verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
467      * but performing a delegate call.
468      *
469      * _Available since v3.4._
470      */
471     function functionDelegateCall(address target, bytes memory data)
472         internal
473         returns (bytes memory)
474     {
475         return
476             functionDelegateCall(
477                 target,
478                 data,
479                 "Address: low-level delegate call failed"
480             );
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
485      * but performing a delegate call.
486      *
487      * _Available since v3.4._
488      */
489     function functionDelegateCall(
490         address target,
491         bytes memory data,
492         string memory errorMessage
493     ) internal returns (bytes memory) {
494         require(isContract(target), "Address: delegate call to non-contract");
495 
496         (bool success, bytes memory returndata) = target.delegatecall(data);
497         return verifyCallResult(success, returndata, errorMessage);
498     }
499 
500     /**
501      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
502      * revert reason using the provided one.
503      *
504      * _Available since v4.3._
505      */
506     function verifyCallResult(
507         bool success,
508         bytes memory returndata,
509         string memory errorMessage
510     ) internal pure returns (bytes memory) {
511         if (success) {
512             return returndata;
513         } else {
514             // Look for revert reason and bubble it up if present
515             if (returndata.length > 0) {
516                 // The easiest way to bubble the revert reason is using memory via assembly
517 
518                 assembly {
519                     let returndata_size := mload(returndata)
520                     revert(add(32, returndata), returndata_size)
521                 }
522             } else {
523                 revert(errorMessage);
524             }
525         }
526     }
527 }
528 
529 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 /**
534  * @dev Provides information about the current execution context, including the
535  * sender of the transaction and its data. While these are generally available
536  * via msg.sender and msg.data, they should not be accessed in such a direct
537  * manner, since when dealing with meta-transactions the account sending and
538  * paying for execution may not be the actual sender (as far as an application
539  * is concerned).
540  *
541  * This contract is only required for intermediate, library-like contracts.
542  */
543 abstract contract Context {
544     function _msgSender() internal view virtual returns (address) {
545         return msg.sender;
546     }
547 
548     function _msgData() internal view virtual returns (bytes calldata) {
549         return msg.data;
550     }
551 }
552 
553 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 /**
558  * @dev String operations.
559  */
560 library Strings {
561     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
562 
563     /**
564      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
565      */
566     function toString(uint256 value) internal pure returns (string memory) {
567         // Inspired by OraclizeAPI's implementation - MIT licence
568         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
569 
570         if (value == 0) {
571             return "0";
572         }
573         uint256 temp = value;
574         uint256 digits;
575         while (temp != 0) {
576             digits++;
577             temp /= 10;
578         }
579         bytes memory buffer = new bytes(digits);
580         while (value != 0) {
581             digits -= 1;
582             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
583             value /= 10;
584         }
585         return string(buffer);
586     }
587 
588     /**
589      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
590      */
591     function toHexString(uint256 value) internal pure returns (string memory) {
592         if (value == 0) {
593             return "0x00";
594         }
595         uint256 temp = value;
596         uint256 length = 0;
597         while (temp != 0) {
598             length++;
599             temp >>= 8;
600         }
601         return toHexString(value, length);
602     }
603 
604     /**
605      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
606      */
607     function toHexString(uint256 value, uint256 length)
608         internal
609         pure
610         returns (string memory)
611     {
612         bytes memory buffer = new bytes(2 * length + 2);
613         buffer[0] = "0";
614         buffer[1] = "x";
615         for (uint256 i = 2 * length + 1; i > 1; --i) {
616             buffer[i] = _HEX_SYMBOLS[value & 0xf];
617             value >>= 4;
618         }
619         require(value == 0, "Strings: hex length insufficient");
620         return string(buffer);
621     }
622 }
623 
624 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
625 
626 pragma solidity ^0.8.0;
627 
628 /**
629  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
630  * @dev See https://eips.ethereum.org/EIPS/eip-721
631  */
632 interface IERC721Enumerable is IERC721 {
633     /**
634      * @dev Returns the total amount of tokens stored by the contract.
635      */
636     function totalSupply() external view returns (uint256);
637 
638     /**
639      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
640      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
641      */
642     function tokenOfOwnerByIndex(address owner, uint256 index)
643         external
644         view
645         returns (uint256 tokenId);
646 
647     /**
648      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
649      * Use along with {totalSupply} to enumerate all tokens.
650      */
651     function tokenByIndex(uint256 index) external view returns (uint256);
652 }
653 
654 pragma solidity ^0.8.0;
655 
656 /**
657  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
658  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
659  *
660  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
661  *
662  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
663  *
664  * Does not support burning tokens to address(0).
665  */
666 contract ERC721A is
667   Context,
668   ERC165,
669   IERC721,
670   IERC721Metadata,
671   IERC721Enumerable
672 {
673   using Address for address;
674   using Strings for uint256;
675 
676   struct TokenOwnership {
677     address addr;
678     uint64 startTimestamp;
679   }
680 
681   struct AddressData {
682     uint128 balance;
683     uint128 numberMinted;
684   }
685 
686   uint256 private currentIndex = 0;
687 
688   uint256 internal immutable collectionSize;
689   uint256 internal immutable maxBatchSize;
690 
691   // Token name
692   string private _name;
693 
694   // Token symbol
695   string private _symbol;
696 
697   // Mapping from token ID to ownership details
698   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
699   mapping(uint256 => TokenOwnership) private _ownerships;
700 
701   // Mapping owner address to address data
702   mapping(address => AddressData) private _addressData;
703 
704   // Mapping from token ID to approved address
705   mapping(uint256 => address) private _tokenApprovals;
706 
707   // Mapping from owner to operator approvals
708   mapping(address => mapping(address => bool)) private _operatorApprovals;
709 
710   /**
711    * @dev
712    * `maxBatchSize` refers to how much a minter can mint at a time.
713    * `collectionSize_` refers to how many tokens are in the collection.
714    */
715   constructor(
716     string memory name_,
717     string memory symbol_,
718     uint256 maxBatchSize_,
719     uint256 collectionSize_
720   ) {
721     require(
722       collectionSize_ > 0,
723       "ERC721A: collection must have a nonzero supply"
724     );
725     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
726     _name = name_;
727     _symbol = symbol_;
728     maxBatchSize = maxBatchSize_;
729     collectionSize = collectionSize_;
730   }
731 
732   /**
733    * @dev See {IERC721Enumerable-totalSupply}.
734    */
735   function totalSupply() public view override returns (uint256) {
736     return currentIndex;
737   }
738 
739   /**
740    * @dev See {IERC721Enumerable-tokenByIndex}.
741    */
742   function tokenByIndex(uint256 index) public view override returns (uint256) {
743     require(index < totalSupply(), "ERC721A: global index out of bounds");
744     return index;
745   }
746 
747   /**
748    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
749    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
750    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
751    */
752   function tokenOfOwnerByIndex(address owner, uint256 index)
753     public
754     view
755     override
756     returns (uint256)
757   {
758     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
759     uint256 numMintedSoFar = totalSupply();
760     uint256 tokenIdsIdx = 0;
761     address currOwnershipAddr = address(0);
762     for (uint256 i = 0; i < numMintedSoFar; i++) {
763       TokenOwnership memory ownership = _ownerships[i];
764       if (ownership.addr != address(0)) {
765         currOwnershipAddr = ownership.addr;
766       }
767       if (currOwnershipAddr == owner) {
768         if (tokenIdsIdx == index) {
769           return i;
770         }
771         tokenIdsIdx++;
772       }
773     }
774     revert("ERC721A: unable to get token of owner by index");
775   }
776 
777   /**
778    * @dev See {IERC165-supportsInterface}.
779    */
780   function supportsInterface(bytes4 interfaceId)
781     public
782     view
783     virtual
784     override(ERC165, IERC165)
785     returns (bool)
786   {
787     return
788       interfaceId == type(IERC721).interfaceId ||
789       interfaceId == type(IERC721Metadata).interfaceId ||
790       interfaceId == type(IERC721Enumerable).interfaceId ||
791       super.supportsInterface(interfaceId);
792   }
793 
794   /**
795    * @dev See {IERC721-balanceOf}.
796    */
797   function balanceOf(address owner) public view override returns (uint256) {
798     require(owner != address(0), "ERC721A: balance query for the zero address");
799     return uint256(_addressData[owner].balance);
800   }
801 
802   function _numberMinted(address owner) internal view returns (uint256) {
803     require(
804       owner != address(0),
805       "ERC721A: number minted query for the zero address"
806     );
807     return uint256(_addressData[owner].numberMinted);
808   }
809 
810   function ownershipOf(uint256 tokenId)
811     internal
812     view
813     returns (TokenOwnership memory)
814   {
815     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
816 
817     uint256 lowestTokenToCheck;
818     if (tokenId >= maxBatchSize) {
819       lowestTokenToCheck = tokenId - maxBatchSize + 1;
820     }
821 
822     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
823       TokenOwnership memory ownership = _ownerships[curr];
824       if (ownership.addr != address(0)) {
825         return ownership;
826       }
827     }
828 
829     revert("ERC721A: unable to determine the owner of token");
830   }
831 
832   /**
833    * @dev See {IERC721-ownerOf}.
834    */
835   function ownerOf(uint256 tokenId) public view override returns (address) {
836     return ownershipOf(tokenId).addr;
837   }
838 
839   /**
840    * @dev See {IERC721Metadata-name}.
841    */
842   function name() public view virtual override returns (string memory) {
843     return _name;
844   }
845 
846   /**
847    * @dev See {IERC721Metadata-symbol}.
848    */
849   function symbol() public view virtual override returns (string memory) {
850     return _symbol;
851   }
852 
853   /**
854    * @dev See {IERC721Metadata-tokenURI}.
855    */
856   function tokenURI(uint256 tokenId)
857     public
858     view
859     virtual
860     override
861     returns (string memory)
862   {
863     require(
864       _exists(tokenId),
865       "ERC721Metadata: URI query for nonexistent token"
866     );
867 
868     string memory baseURI = _baseURI();
869     return
870       bytes(baseURI).length > 0
871         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
872         : "";
873   }
874 
875   /**
876    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
877    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
878    * by default, can be overriden in child contracts.
879    */
880   function _baseURI() internal view virtual returns (string memory) {
881     return "";
882   }
883 
884   /**
885    * @dev See {IERC721-approve}.
886    */
887   function approve(address to, uint256 tokenId) public override {
888     address owner = ERC721A.ownerOf(tokenId);
889     require(to != owner, "ERC721A: approval to current owner");
890 
891     require(
892       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
893       "ERC721A: approve caller is not owner nor approved for all"
894     );
895 
896     _approve(to, tokenId, owner);
897   }
898 
899   /**
900    * @dev See {IERC721-getApproved}.
901    */
902   function getApproved(uint256 tokenId) public view override returns (address) {
903     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
904 
905     return _tokenApprovals[tokenId];
906   }
907 
908   /**
909    * @dev See {IERC721-setApprovalForAll}.
910    */
911   function setApprovalForAll(address operator, bool approved) public override {
912     require(operator != _msgSender(), "ERC721A: approve to caller");
913 
914     _operatorApprovals[_msgSender()][operator] = approved;
915     emit ApprovalForAll(_msgSender(), operator, approved);
916   }
917 
918   /**
919    * @dev See {IERC721-isApprovedForAll}.
920    */
921   function isApprovedForAll(address owner, address operator)
922     public
923     view
924     virtual
925     override
926     returns (bool)
927   {
928     return _operatorApprovals[owner][operator];
929   }
930 
931   /**
932    * @dev See {IERC721-transferFrom}.
933    */
934   function transferFrom(
935     address from,
936     address to,
937     uint256 tokenId
938   ) public override {
939     _transfer(from, to, tokenId);
940   }
941 
942   /**
943    * @dev See {IERC721-safeTransferFrom}.
944    */
945   function safeTransferFrom(
946     address from,
947     address to,
948     uint256 tokenId
949   ) public override {
950     safeTransferFrom(from, to, tokenId, "");
951   }
952 
953   /**
954    * @dev See {IERC721-safeTransferFrom}.
955    */
956   function safeTransferFrom(
957     address from,
958     address to,
959     uint256 tokenId,
960     bytes memory _data
961   ) public override {
962     _transfer(from, to, tokenId);
963     require(
964       _checkOnERC721Received(from, to, tokenId, _data),
965       "ERC721A: transfer to non ERC721Receiver implementer"
966     );
967   }
968 
969   /**
970    * @dev Returns whether `tokenId` exists.
971    *
972    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
973    *
974    * Tokens start existing when they are minted (`_mint`),
975    */
976   function _exists(uint256 tokenId) internal view returns (bool) {
977     return tokenId < currentIndex;
978   }
979 
980   function _safeMint(address to, uint256 quantity) internal {
981     _safeMint(to, quantity, "");
982   }
983 
984   /**
985    * @dev Mints `quantity` tokens and transfers them to `to`.
986    *
987    * Requirements:
988    *
989    * - there must be `quantity` tokens remaining unminted in the total collection.
990    * - `to` cannot be the zero address.
991    * - `quantity` cannot be larger than the max batch size.
992    *
993    * Emits a {Transfer} event.
994    */
995   function _safeMint(
996     address to,
997     uint256 quantity,
998     bytes memory _data
999   ) internal {
1000     uint256 startTokenId = currentIndex;
1001     require(to != address(0), "ERC721A: mint to the zero address");
1002     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1003     require(!_exists(startTokenId), "ERC721A: token already minted");
1004     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1005 
1006     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1007 
1008     AddressData memory addressData = _addressData[to];
1009     _addressData[to] = AddressData(
1010       addressData.balance + uint128(quantity),
1011       addressData.numberMinted + uint128(quantity)
1012     );
1013     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1014 
1015     uint256 updatedIndex = startTokenId;
1016 
1017     for (uint256 i = 0; i < quantity; i++) {
1018       emit Transfer(address(0), to, updatedIndex);
1019       require(
1020         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1021         "ERC721A: transfer to non ERC721Receiver implementer"
1022       );
1023       updatedIndex++;
1024     }
1025 
1026     currentIndex = updatedIndex;
1027     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1028   }
1029 
1030   /**
1031    * @dev Transfers `tokenId` from `from` to `to`.
1032    *
1033    * Requirements:
1034    *
1035    * - `to` cannot be the zero address.
1036    * - `tokenId` token must be owned by `from`.
1037    *
1038    * Emits a {Transfer} event.
1039    */
1040   function _transfer(
1041     address from,
1042     address to,
1043     uint256 tokenId
1044   ) private {
1045     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1046 
1047     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1048       getApproved(tokenId) == _msgSender() ||
1049       isApprovedForAll(prevOwnership.addr, _msgSender()));
1050 
1051     require(
1052       isApprovedOrOwner,
1053       "ERC721A: transfer caller is not owner nor approved"
1054     );
1055 
1056     require(
1057       prevOwnership.addr == from,
1058       "ERC721A: transfer from incorrect owner"
1059     );
1060     require(to != address(0), "ERC721A: transfer to the zero address");
1061 
1062     _beforeTokenTransfers(from, to, tokenId, 1);
1063 
1064     // Clear approvals from the previous owner
1065     _approve(address(0), tokenId, prevOwnership.addr);
1066 
1067     _addressData[from].balance -= 1;
1068     _addressData[to].balance += 1;
1069     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1070 
1071     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1072     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1073     uint256 nextTokenId = tokenId + 1;
1074     if (_ownerships[nextTokenId].addr == address(0)) {
1075       if (_exists(nextTokenId)) {
1076         _ownerships[nextTokenId] = TokenOwnership(
1077           prevOwnership.addr,
1078           prevOwnership.startTimestamp
1079         );
1080       }
1081     }
1082 
1083     emit Transfer(from, to, tokenId);
1084     _afterTokenTransfers(from, to, tokenId, 1);
1085   }
1086 
1087   /**
1088    * @dev Approve `to` to operate on `tokenId`
1089    *
1090    * Emits a {Approval} event.
1091    */
1092   function _approve(
1093     address to,
1094     uint256 tokenId,
1095     address owner
1096   ) private {
1097     _tokenApprovals[tokenId] = to;
1098     emit Approval(owner, to, tokenId);
1099   }
1100 
1101   uint256 public nextOwnerToExplicitlySet = 0;
1102 
1103   /**
1104    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1105    */
1106   function _setOwnersExplicit(uint256 quantity) internal {
1107     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1108     require(quantity > 0, "quantity must be nonzero");
1109     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1110     if (endIndex > collectionSize - 1) {
1111       endIndex = collectionSize - 1;
1112     }
1113     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1114     require(_exists(endIndex), "not enough minted yet for this cleanup");
1115     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1116       if (_ownerships[i].addr == address(0)) {
1117         TokenOwnership memory ownership = ownershipOf(i);
1118         _ownerships[i] = TokenOwnership(
1119           ownership.addr,
1120           ownership.startTimestamp
1121         );
1122       }
1123     }
1124     nextOwnerToExplicitlySet = endIndex + 1;
1125   }
1126 
1127   /**
1128    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1129    * The call is not executed if the target address is not a contract.
1130    *
1131    * @param from address representing the previous owner of the given token ID
1132    * @param to target address that will receive the tokens
1133    * @param tokenId uint256 ID of the token to be transferred
1134    * @param _data bytes optional data to send along with the call
1135    * @return bool whether the call correctly returned the expected magic value
1136    */
1137   function _checkOnERC721Received(
1138     address from,
1139     address to,
1140     uint256 tokenId,
1141     bytes memory _data
1142   ) private returns (bool) {
1143     if (to.isContract()) {
1144       try
1145         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1146       returns (bytes4 retval) {
1147         return retval == IERC721Receiver(to).onERC721Received.selector;
1148       } catch (bytes memory reason) {
1149         if (reason.length == 0) {
1150           revert("ERC721A: transfer to non ERC721Receiver implementer");
1151         } else {
1152           assembly {
1153             revert(add(32, reason), mload(reason))
1154           }
1155         }
1156       }
1157     } else {
1158       return true;
1159     }
1160   }
1161 
1162   /**
1163    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1164    *
1165    * startTokenId - the first token id to be transferred
1166    * quantity - the amount to be transferred
1167    *
1168    * Calling conditions:
1169    *
1170    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1171    * transferred to `to`.
1172    * - When `from` is zero, `tokenId` will be minted for `to`.
1173    */
1174   function _beforeTokenTransfers(
1175     address from,
1176     address to,
1177     uint256 startTokenId,
1178     uint256 quantity
1179   ) internal virtual {}
1180 
1181   /**
1182    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1183    * minting.
1184    *
1185    * startTokenId - the first token id to be transferred
1186    * quantity - the amount to be transferred
1187    *
1188    * Calling conditions:
1189    *
1190    * - when `from` and `to` are both non-zero.
1191    * - `from` and `to` are never both zero.
1192    */
1193   function _afterTokenTransfers(
1194     address from,
1195     address to,
1196     uint256 startTokenId,
1197     uint256 quantity
1198   ) internal virtual {}
1199 }
1200 
1201 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1202 
1203 pragma solidity ^0.8.0;
1204 
1205 /**
1206  * @dev Contract module which provides a basic access control mechanism, where
1207  * there is an account (an owner) that can be granted exclusive access to
1208  * specific functions.
1209  *
1210  * By default, the owner account will be the one that deploys the contract. This
1211  * can later be changed with {transferOwnership}.
1212  *
1213  * This module is used through inheritance. It will make available the modifier
1214  * `onlyOwner`, which can be applied to your functions to restrict their use to
1215  * the owner.
1216  */
1217 abstract contract Ownable is Context {
1218     address private _owner;
1219 
1220     event OwnershipTransferred(
1221         address indexed previousOwner,
1222         address indexed newOwner
1223     );
1224 
1225     /**
1226      * @dev Initializes the contract setting the deployer as the initial owner.
1227      */
1228     constructor() {
1229         _transferOwnership(_msgSender());
1230     }
1231 
1232     /**
1233      * @dev Returns the address of the current owner.
1234      */
1235     function owner() public view virtual returns (address) {
1236         return _owner;
1237     }
1238 
1239     /**
1240      * @dev Throws if called by any account other than the owner.
1241      */
1242     modifier onlyOwner() {
1243         require(owner() == _msgSender(), "You are not the owner");
1244         _;
1245     }
1246 
1247     /**
1248      * @dev Leaves the contract without owner. It will not be possible to call
1249      * `onlyOwner` functions anymore. Can only be called by the current owner.
1250      *
1251      * NOTE: Renouncing ownership will leave the contract without an owner,
1252      * thereby removing any functionality that is only available to the owner.
1253      */
1254     function renounceOwnership() public virtual onlyOwner {
1255         _transferOwnership(address(0));
1256     }
1257 
1258     /**
1259      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1260      * Can only be called by the current owner.
1261      */
1262     function transferOwnership(address newOwner) public virtual onlyOwner {
1263         require(
1264             newOwner != address(0),
1265             "Ownable: new owner is the zero address"
1266         );
1267         _transferOwnership(newOwner);
1268     }
1269 
1270     /**
1271      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1272      * Internal function without access restriction.
1273      */
1274     function _transferOwnership(address newOwner) internal virtual {
1275         address oldOwner = _owner;
1276         _owner = newOwner;
1277         emit OwnershipTransferred(oldOwner, newOwner);
1278     }
1279 }
1280 
1281 
1282 pragma solidity ^0.8.0;
1283 
1284 contract AzraGames is ERC721A, Ownable {
1285     uint256 public NFT_PRICE = 0 ether;
1286     uint256 public MAX_SUPPLY = 5555;
1287     uint256 public MAX_MINTS = 500;
1288     string public baseURI = "";
1289     string public baseExtension = ".json";
1290      bool public paused = false;
1291     
1292     constructor() ERC721A("Azra Games: The Hopeful", "AZRA", MAX_MINTS, MAX_SUPPLY) {  
1293     }
1294     
1295 
1296     function Mint(uint256 numTokens) public payable {
1297         require(!paused, "Paused");
1298         require(numTokens > 0 && numTokens <= MAX_MINTS);
1299         require(totalSupply() + numTokens <= MAX_SUPPLY);
1300         require(MAX_MINTS >= numTokens, "Excess max per paid tx");
1301         require(msg.value >= numTokens * NFT_PRICE, "Invalid funds provided");
1302         _safeMint(msg.sender, numTokens);	
1303     }
1304 
1305     function DevsMint(uint256 numTokens) public payable onlyOwner {
1306         _safeMint(msg.sender, numTokens);
1307     }
1308 
1309 
1310     function pause(bool _state) public onlyOwner {
1311         paused = _state;
1312     }
1313 
1314     function setBaseURI(string memory newBaseURI) public onlyOwner {
1315         baseURI = newBaseURI;
1316     }
1317     function tokenURI(uint256 _tokenId)
1318         public
1319         view
1320         override
1321         returns (string memory)
1322     {
1323         require(_exists(_tokenId), "That token doesn't exist");
1324         return
1325             bytes(baseURI).length > 0
1326                 ? string(
1327                     abi.encodePacked(
1328                         baseURI,
1329                         Strings.toString(_tokenId),
1330                         baseExtension
1331                     )
1332                 )
1333                 : "";
1334     }
1335 
1336     function setPrice(uint256 newPrice) public onlyOwner {
1337         NFT_PRICE = newPrice;
1338     }
1339 
1340     function setMaxMints(uint256 newMax) public onlyOwner {
1341         MAX_MINTS = newMax;
1342     }
1343 
1344     function _baseURI() internal view virtual override returns (string memory) {
1345         return baseURI;
1346     }
1347 
1348     function withdrawMoney() external onlyOwner {
1349       (bool success, ) = msg.sender.call{value: address(this).balance}("");
1350       require(success, "WITHDRAW FAILED!");
1351     }
1352 }