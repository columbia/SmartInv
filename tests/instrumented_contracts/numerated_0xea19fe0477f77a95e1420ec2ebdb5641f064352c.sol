1 // SPDX-License-Identifier: MIT
2 // File: contracts/Goldbirds.sol
3 
4 
5 // File: contracts/ETHvillages.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Interface of the ERC165 standard, as defined in the
14  * https://eips.ethereum.org/EIPS/eip-165[EIP].
15  *
16  * Implementers can declare support of contract interfaces, which can then be
17  * queried by others ({ERC165Checker}).
18  *
19  * For an implementation, see {ERC165}.
20  */
21 interface IERC165 {
22     /**
23      * @dev Returns true if this contract implements the interface defined by
24      * `interfaceId`. See the corresponding
25      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
26      * to learn more about how these ids are created.
27      *
28      * This function call must use less than 30 000 gas.
29      */
30     function supportsInterface(bytes4 interfaceId) external view returns (bool);
31 }
32 
33 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(
45         address indexed from,
46         address indexed to,
47         uint256 indexed tokenId
48     );
49 
50     /**
51      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
52      */
53     event Approval(
54         address indexed owner,
55         address indexed approved,
56         uint256 indexed tokenId
57     );
58 
59     /**
60      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
61      */
62     event ApprovalForAll(
63         address indexed owner,
64         address indexed operator,
65         bool approved
66     );
67 
68     /**
69      * @dev Returns the number of tokens in ``owner``'s account.
70      */
71     function balanceOf(address owner) external view returns (uint256 balance);
72 
73     /**
74      * @dev Returns the owner of the `tokenId` token.
75      *
76      * Requirements:
77      *
78      * - `tokenId` must exist.
79      */
80     function ownerOf(uint256 tokenId) external view returns (address owner);
81 
82     /**
83      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
84      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must exist and be owned by `from`.
91      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
92      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
93      *
94      * Emits a {Transfer} event.
95      */
96     function safeTransferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Transfers `tokenId` token from `from` to `to`.
104      *
105      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
106      *
107      * Requirements:
108      *
109      * - `from` cannot be the zero address.
110      * - `to` cannot be the zero address.
111      * - `tokenId` token must be owned by `from`.
112      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transferFrom(
117         address from,
118         address to,
119         uint256 tokenId
120     ) external;
121 
122     /**
123      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
124      * The approval is cleared when the token is transferred.
125      *
126      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
127      *
128      * Requirements:
129      *
130      * - The caller must own the token or be an approved operator.
131      * - `tokenId` must exist.
132      *
133      * Emits an {Approval} event.
134      */
135     function approve(address to, uint256 tokenId) external;
136 
137     /**
138      * @dev Returns the account approved for `tokenId` token.
139      *
140      * Requirements:
141      *
142      * - `tokenId` must exist.
143      */
144     function getApproved(uint256 tokenId)
145         external
146         view
147         returns (address operator);
148 
149     /**
150      * @dev Approve or remove `operator` as an operator for the caller.
151      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
152      *
153      * Requirements:
154      *
155      * - The `operator` cannot be the caller.
156      *
157      * Emits an {ApprovalForAll} event.
158      */
159     function setApprovalForAll(address operator, bool _approved) external;
160 
161     /**
162      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
163      *
164      * See {setApprovalForAll}
165      */
166     function isApprovedForAll(address owner, address operator)
167         external
168         view
169         returns (bool);
170 
171     /**
172      * @dev Safely transfers `tokenId` token from `from` to `to`.
173      *
174      * Requirements:
175      *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178      * - `tokenId` token must exist and be owned by `from`.
179      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
180      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181      *
182      * Emits a {Transfer} event.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId,
188         bytes calldata data
189     ) external;
190 }
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
219 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
225  * @dev See https://eips.ethereum.org/EIPS/eip-721
226  */
227 interface IERC721Metadata is IERC721 {
228     /**
229      * @dev Returns the token collection name.
230      */
231     function name() external view returns (string memory);
232 
233     /**
234      * @dev Returns the token collection symbol.
235      */
236     function symbol() external view returns (string memory);
237 
238     /**
239      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
240      */
241     function tokenURI(uint256 tokenId) external view returns (string memory);
242 }
243 
244 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
245 
246 pragma solidity ^0.8.0;
247 
248 /**
249  * @dev Implementation of the {IERC165} interface.
250  *
251  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
252  * for the additional interface id that will be supported. For example:
253  *
254  * ```solidity
255  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
256  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
257  * }
258  * ```
259  *
260  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
261  */
262 abstract contract ERC165 is IERC165 {
263     /**
264      * @dev See {IERC165-supportsInterface}.
265      */
266     function supportsInterface(bytes4 interfaceId)
267         public
268         view
269         virtual
270         override
271         returns (bool)
272     {
273         return interfaceId == type(IERC165).interfaceId;
274     }
275 }
276 
277 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @dev Collection of functions related to the address type
283  */
284 library Address {
285     /**
286      * @dev Returns true if `account` is a contract.
287      *
288      * [IMPORTANT]
289      * ====
290      * It is unsafe to assume that an address for which this function returns
291      * false is an externally-owned account (EOA) and not a contract.
292      *
293      * Among others, `isContract` will return false for the following
294      * types of addresses:
295      *
296      *  - an externally-owned account
297      *  - a contract in construction
298      *  - an address where a contract will be created
299      *  - an address where a contract lived, but was destroyed
300      * ====
301      */
302     function isContract(address account) internal view returns (bool) {
303         // This method relies on extcodesize, which returns 0 for contracts in
304         // construction, since the code is only stored at the end of the
305         // constructor execution.
306 
307         uint256 size;
308         assembly {
309             size := extcodesize(account)
310         }
311         return size > 0;
312     }
313 
314     /**
315      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
316      * `recipient`, forwarding all available gas and reverting on errors.
317      *
318      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
319      * of certain opcodes, possibly making contracts go over the 2300 gas limit
320      * imposed by `transfer`, making them unable to receive funds via
321      * `transfer`. {sendValue} removes this limitation.
322      *
323      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
324      *
325      * IMPORTANT: because control is transferred to `recipient`, care must be
326      * taken to not create reentrancy vulnerabilities. Consider using
327      * {ReentrancyGuard} or the
328      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
329      */
330     function sendValue(address payable recipient, uint256 amount) internal {
331         require(
332             address(this).balance >= amount,
333             "Address: insufficient balance"
334         );
335 
336         (bool success, ) = recipient.call{value: amount}("");
337         require(
338             success,
339             "Address: unable to send value, recipient may have reverted"
340         );
341     }
342 
343     /**
344      * @dev Performs a Solidity function call using a low level `call`. A
345      * plain `call` is an unsafe replacement for a function call: use this
346      * function instead.
347      *
348      * If `target` reverts with a revert reason, it is bubbled up by this
349      * function (like regular Solidity function calls).
350      *
351      * Returns the raw returned data. To convert to the expected return value,
352      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
353      *
354      * Requirements:
355      *
356      * - `target` must be a contract.
357      * - calling `target` with `data` must not revert.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data)
362         internal
363         returns (bytes memory)
364     {
365         return functionCall(target, data, "Address: low-level call failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
370      * `errorMessage` as a fallback revert reason when `target` reverts.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(
375         address target,
376         bytes memory data,
377         string memory errorMessage
378     ) internal returns (bytes memory) {
379         return functionCallWithValue(target, data, 0, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but also transferring `value` wei to `target`.
385      *
386      * Requirements:
387      *
388      * - the calling contract must have an ETH balance of at least `value`.
389      * - the called Solidity function must be `payable`.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(
394         address target,
395         bytes memory data,
396         uint256 value
397     ) internal returns (bytes memory) {
398         return
399             functionCallWithValue(
400                 target,
401                 data,
402                 value,
403                 "Address: low-level call with value failed"
404             );
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
409      * with `errorMessage` as a fallback revert reason when `target` reverts.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(
414         address target,
415         bytes memory data,
416         uint256 value,
417         string memory errorMessage
418     ) internal returns (bytes memory) {
419         require(
420             address(this).balance >= value,
421             "Address: insufficient balance for call"
422         );
423         require(isContract(target), "Address: call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.call{value: value}(
426             data
427         );
428         return verifyCallResult(success, returndata, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but performing a static call.
434      *
435      * _Available since v3.3._
436      */
437     function functionStaticCall(address target, bytes memory data)
438         internal
439         view
440         returns (bytes memory)
441     {
442         return
443             functionStaticCall(
444                 target,
445                 data,
446                 "Address: low-level static call failed"
447             );
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
452      * but performing a static call.
453      *
454      * _Available since v3.3._
455      */
456     function functionStaticCall(
457         address target,
458         bytes memory data,
459         string memory errorMessage
460     ) internal view returns (bytes memory) {
461         require(isContract(target), "Address: static call to non-contract");
462 
463         (bool success, bytes memory returndata) = target.staticcall(data);
464         return verifyCallResult(success, returndata, errorMessage);
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
469      * but performing a delegate call.
470      *
471      * _Available since v3.4._
472      */
473     function functionDelegateCall(address target, bytes memory data)
474         internal
475         returns (bytes memory)
476     {
477         return
478             functionDelegateCall(
479                 target,
480                 data,
481                 "Address: low-level delegate call failed"
482             );
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
487      * but performing a delegate call.
488      *
489      * _Available since v3.4._
490      */
491     function functionDelegateCall(
492         address target,
493         bytes memory data,
494         string memory errorMessage
495     ) internal returns (bytes memory) {
496         require(isContract(target), "Address: delegate call to non-contract");
497 
498         (bool success, bytes memory returndata) = target.delegatecall(data);
499         return verifyCallResult(success, returndata, errorMessage);
500     }
501 
502     /**
503      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
504      * revert reason using the provided one.
505      *
506      * _Available since v4.3._
507      */
508     function verifyCallResult(
509         bool success,
510         bytes memory returndata,
511         string memory errorMessage
512     ) internal pure returns (bytes memory) {
513         if (success) {
514             return returndata;
515         } else {
516             // Look for revert reason and bubble it up if present
517             if (returndata.length > 0) {
518                 // The easiest way to bubble the revert reason is using memory via assembly
519 
520                 assembly {
521                     let returndata_size := mload(returndata)
522                     revert(add(32, returndata), returndata_size)
523                 }
524             } else {
525                 revert(errorMessage);
526             }
527         }
528     }
529 }
530 
531 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 /**
536  * @dev Provides information about the current execution context, including the
537  * sender of the transaction and its data. While these are generally available
538  * via msg.sender and msg.data, they should not be accessed in such a direct
539  * manner, since when dealing with meta-transactions the account sending and
540  * paying for execution may not be the actual sender (as far as an application
541  * is concerned).
542  *
543  * This contract is only required for intermediate, library-like contracts.
544  */
545 abstract contract Context {
546     function _msgSender() internal view virtual returns (address) {
547         return msg.sender;
548     }
549 
550     function _msgData() internal view virtual returns (bytes calldata) {
551         return msg.data;
552     }
553 }
554 
555 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 /**
560  * @dev String operations.
561  */
562 library Strings {
563     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
564 
565     /**
566      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
567      */
568     function toString(uint256 value) internal pure returns (string memory) {
569         // Inspired by OraclizeAPI's implementation - MIT licence
570         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
571 
572         if (value == 0) {
573             return "0";
574         }
575         uint256 temp = value;
576         uint256 digits;
577         while (temp != 0) {
578             digits++;
579             temp /= 10;
580         }
581         bytes memory buffer = new bytes(digits);
582         while (value != 0) {
583             digits -= 1;
584             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
585             value /= 10;
586         }
587         return string(buffer);
588     }
589 
590     /**
591      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
592      */
593     function toHexString(uint256 value) internal pure returns (string memory) {
594         if (value == 0) {
595             return "0x00";
596         }
597         uint256 temp = value;
598         uint256 length = 0;
599         while (temp != 0) {
600             length++;
601             temp >>= 8;
602         }
603         return toHexString(value, length);
604     }
605 
606     /**
607      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
608      */
609     function toHexString(uint256 value, uint256 length)
610         internal
611         pure
612         returns (string memory)
613     {
614         bytes memory buffer = new bytes(2 * length + 2);
615         buffer[0] = "0";
616         buffer[1] = "x";
617         for (uint256 i = 2 * length + 1; i > 1; --i) {
618             buffer[i] = _HEX_SYMBOLS[value & 0xf];
619             value >>= 4;
620         }
621         require(value == 0, "Strings: hex length insufficient");
622         return string(buffer);
623     }
624 }
625 
626 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
627 
628 pragma solidity ^0.8.0;
629 
630 /**
631  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
632  * @dev See https://eips.ethereum.org/EIPS/eip-721
633  */
634 interface IERC721Enumerable is IERC721 {
635     /**
636      * @dev Returns the total amount of tokens stored by the contract.
637      */
638     function totalSupply() external view returns (uint256);
639 
640     /**
641      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
642      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
643      */
644     function tokenOfOwnerByIndex(address owner, uint256 index)
645         external
646         view
647         returns (uint256 tokenId);
648 
649     /**
650      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
651      * Use along with {totalSupply} to enumerate all tokens.
652      */
653     function tokenByIndex(uint256 index) external view returns (uint256);
654 }
655 
656 pragma solidity ^0.8.0;
657 
658 /**
659  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
660  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
661  *
662  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
663  *
664  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
665  *
666  * Does not support burning tokens to address(0).
667  */
668 contract ERC721A is
669   Context,
670   ERC165,
671   IERC721,
672   IERC721Metadata,
673   IERC721Enumerable
674 {
675   using Address for address;
676   using Strings for uint256;
677 
678   struct TokenOwnership {
679     address addr;
680     uint64 startTimestamp;
681   }
682 
683   struct AddressData {
684     uint128 balance;
685     uint128 numberMinted;
686   }
687 
688   uint256 private currentIndex = 0;
689 
690   uint256 internal immutable collectionSize;
691   uint256 internal immutable maxBatchSize;
692 
693   // Token name
694   string private _name;
695 
696   // Token symbol
697   string private _symbol;
698 
699   // Mapping from token ID to ownership details
700   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
701   mapping(uint256 => TokenOwnership) private _ownerships;
702 
703   // Mapping owner address to address data
704   mapping(address => AddressData) private _addressData;
705 
706   // Mapping from token ID to approved address
707   mapping(uint256 => address) private _tokenApprovals;
708 
709   // Mapping from owner to operator approvals
710   mapping(address => mapping(address => bool)) private _operatorApprovals;
711 
712   /**
713    * @dev
714    * `maxBatchSize` refers to how much a minter can mint at a time.
715    * `collectionSize_` refers to how many tokens are in the collection.
716    */
717   constructor(
718     string memory name_,
719     string memory symbol_,
720     uint256 maxBatchSize_,
721     uint256 collectionSize_
722   ) {
723     require(
724       collectionSize_ > 0,
725       "ERC721A: collection must have a nonzero supply"
726     );
727     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
728     _name = name_;
729     _symbol = symbol_;
730     maxBatchSize = maxBatchSize_;
731     collectionSize = collectionSize_;
732   }
733 
734   /**
735    * @dev See {IERC721Enumerable-totalSupply}.
736    */
737   function totalSupply() public view override returns (uint256) {
738     return currentIndex;
739   }
740 
741   /**
742    * @dev See {IERC721Enumerable-tokenByIndex}.
743    */
744   function tokenByIndex(uint256 index) public view override returns (uint256) {
745     require(index < totalSupply(), "ERC721A: global index out of bounds");
746     return index;
747   }
748 
749   /**
750    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
751    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
752    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
753    */
754   function tokenOfOwnerByIndex(address owner, uint256 index)
755     public
756     view
757     override
758     returns (uint256)
759   {
760     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
761     uint256 numMintedSoFar = totalSupply();
762     uint256 tokenIdsIdx = 0;
763     address currOwnershipAddr = address(0);
764     for (uint256 i = 0; i < numMintedSoFar; i++) {
765       TokenOwnership memory ownership = _ownerships[i];
766       if (ownership.addr != address(0)) {
767         currOwnershipAddr = ownership.addr;
768       }
769       if (currOwnershipAddr == owner) {
770         if (tokenIdsIdx == index) {
771           return i;
772         }
773         tokenIdsIdx++;
774       }
775     }
776     revert("ERC721A: unable to get token of owner by index");
777   }
778 
779   /**
780    * @dev See {IERC165-supportsInterface}.
781    */
782   function supportsInterface(bytes4 interfaceId)
783     public
784     view
785     virtual
786     override(ERC165, IERC165)
787     returns (bool)
788   {
789     return
790       interfaceId == type(IERC721).interfaceId ||
791       interfaceId == type(IERC721Metadata).interfaceId ||
792       interfaceId == type(IERC721Enumerable).interfaceId ||
793       super.supportsInterface(interfaceId);
794   }
795 
796   /**
797    * @dev See {IERC721-balanceOf}.
798    */
799   function balanceOf(address owner) public view override returns (uint256) {
800     require(owner != address(0), "ERC721A: balance query for the zero address");
801     return uint256(_addressData[owner].balance);
802   }
803 
804   function _numberMinted(address owner) internal view returns (uint256) {
805     require(
806       owner != address(0),
807       "ERC721A: number minted query for the zero address"
808     );
809     return uint256(_addressData[owner].numberMinted);
810   }
811 
812   function ownershipOf(uint256 tokenId)
813     internal
814     view
815     returns (TokenOwnership memory)
816   {
817     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
818 
819     uint256 lowestTokenToCheck;
820     if (tokenId >= maxBatchSize) {
821       lowestTokenToCheck = tokenId - maxBatchSize + 1;
822     }
823 
824     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
825       TokenOwnership memory ownership = _ownerships[curr];
826       if (ownership.addr != address(0)) {
827         return ownership;
828       }
829     }
830 
831     revert("ERC721A: unable to determine the owner of token");
832   }
833 
834   /**
835    * @dev See {IERC721-ownerOf}.
836    */
837   function ownerOf(uint256 tokenId) public view override returns (address) {
838     return ownershipOf(tokenId).addr;
839   }
840 
841   /**
842    * @dev See {IERC721Metadata-name}.
843    */
844   function name() public view virtual override returns (string memory) {
845     return _name;
846   }
847 
848   /**
849    * @dev See {IERC721Metadata-symbol}.
850    */
851   function symbol() public view virtual override returns (string memory) {
852     return _symbol;
853   }
854 
855   /**
856    * @dev See {IERC721Metadata-tokenURI}.
857    */
858   function tokenURI(uint256 tokenId)
859     public
860     view
861     virtual
862     override
863     returns (string memory)
864   {
865     require(
866       _exists(tokenId),
867       "ERC721Metadata: URI query for nonexistent token"
868     );
869 
870     string memory baseURI = _baseURI();
871     return
872       bytes(baseURI).length > 0
873         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
874         : "";
875   }
876 
877   /**
878    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
879    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
880    * by default, can be overriden in child contracts.
881    */
882   function _baseURI() internal view virtual returns (string memory) {
883     return "";
884   }
885 
886   /**
887    * @dev See {IERC721-approve}.
888    */
889   function approve(address to, uint256 tokenId) public override {
890     address owner = ERC721A.ownerOf(tokenId);
891     require(to != owner, "ERC721A: approval to current owner");
892 
893     require(
894       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
895       "ERC721A: approve caller is not owner nor approved for all"
896     );
897 
898     _approve(to, tokenId, owner);
899   }
900 
901   /**
902    * @dev See {IERC721-getApproved}.
903    */
904   function getApproved(uint256 tokenId) public view override returns (address) {
905     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
906 
907     return _tokenApprovals[tokenId];
908   }
909 
910   /**
911    * @dev See {IERC721-setApprovalForAll}.
912    */
913   function setApprovalForAll(address operator, bool approved) public override {
914     require(operator != _msgSender(), "ERC721A: approve to caller");
915 
916     _operatorApprovals[_msgSender()][operator] = approved;
917     emit ApprovalForAll(_msgSender(), operator, approved);
918   }
919 
920   /**
921    * @dev See {IERC721-isApprovedForAll}.
922    */
923   function isApprovedForAll(address owner, address operator)
924     public
925     view
926     virtual
927     override
928     returns (bool)
929   {
930     return _operatorApprovals[owner][operator];
931   }
932 
933   /**
934    * @dev See {IERC721-transferFrom}.
935    */
936   function transferFrom(
937     address from,
938     address to,
939     uint256 tokenId
940   ) public override {
941     _transfer(from, to, tokenId);
942   }
943 
944   /**
945    * @dev See {IERC721-safeTransferFrom}.
946    */
947   function safeTransferFrom(
948     address from,
949     address to,
950     uint256 tokenId
951   ) public override {
952     safeTransferFrom(from, to, tokenId, "");
953   }
954 
955   /**
956    * @dev See {IERC721-safeTransferFrom}.
957    */
958   function safeTransferFrom(
959     address from,
960     address to,
961     uint256 tokenId,
962     bytes memory _data
963   ) public override {
964     _transfer(from, to, tokenId);
965     require(
966       _checkOnERC721Received(from, to, tokenId, _data),
967       "ERC721A: transfer to non ERC721Receiver implementer"
968     );
969   }
970 
971   /**
972    * @dev Returns whether `tokenId` exists.
973    *
974    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
975    *
976    * Tokens start existing when they are minted (`_mint`),
977    */
978   function _exists(uint256 tokenId) internal view returns (bool) {
979     return tokenId < currentIndex;
980   }
981 
982   function _safeMint(address to, uint256 quantity) internal {
983     _safeMint(to, quantity, "");
984   }
985 
986   /**
987    * @dev Mints `quantity` tokens and transfers them to `to`.
988    *
989    * Requirements:
990    *
991    * - there must be `quantity` tokens remaining unminted in the total collection.
992    * - `to` cannot be the zero address.
993    * - `quantity` cannot be larger than the max batch size.
994    *
995    * Emits a {Transfer} event.
996    */
997   function _safeMint(
998     address to,
999     uint256 quantity,
1000     bytes memory _data
1001   ) internal {
1002     uint256 startTokenId = currentIndex;
1003     require(to != address(0), "ERC721A: mint to the zero address");
1004     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1005     require(!_exists(startTokenId), "ERC721A: token already minted");
1006     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1007 
1008     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1009 
1010     AddressData memory addressData = _addressData[to];
1011     _addressData[to] = AddressData(
1012       addressData.balance + uint128(quantity),
1013       addressData.numberMinted + uint128(quantity)
1014     );
1015     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1016 
1017     uint256 updatedIndex = startTokenId;
1018 
1019     for (uint256 i = 0; i < quantity; i++) {
1020       emit Transfer(address(0), to, updatedIndex);
1021       require(
1022         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1023         "ERC721A: transfer to non ERC721Receiver implementer"
1024       );
1025       updatedIndex++;
1026     }
1027 
1028     currentIndex = updatedIndex;
1029     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1030   }
1031 
1032   /**
1033    * @dev Transfers `tokenId` from `from` to `to`.
1034    *
1035    * Requirements:
1036    *
1037    * - `to` cannot be the zero address.
1038    * - `tokenId` token must be owned by `from`.
1039    *
1040    * Emits a {Transfer} event.
1041    */
1042   function _transfer(
1043     address from,
1044     address to,
1045     uint256 tokenId
1046   ) private {
1047     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1048 
1049     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1050       getApproved(tokenId) == _msgSender() ||
1051       isApprovedForAll(prevOwnership.addr, _msgSender()));
1052 
1053     require(
1054       isApprovedOrOwner,
1055       "ERC721A: transfer caller is not owner nor approved"
1056     );
1057 
1058     require(
1059       prevOwnership.addr == from,
1060       "ERC721A: transfer from incorrect owner"
1061     );
1062     require(to != address(0), "ERC721A: transfer to the zero address");
1063 
1064     _beforeTokenTransfers(from, to, tokenId, 1);
1065 
1066     // Clear approvals from the previous owner
1067     _approve(address(0), tokenId, prevOwnership.addr);
1068 
1069     _addressData[from].balance -= 1;
1070     _addressData[to].balance += 1;
1071     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1072 
1073     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1074     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1075     uint256 nextTokenId = tokenId + 1;
1076     if (_ownerships[nextTokenId].addr == address(0)) {
1077       if (_exists(nextTokenId)) {
1078         _ownerships[nextTokenId] = TokenOwnership(
1079           prevOwnership.addr,
1080           prevOwnership.startTimestamp
1081         );
1082       }
1083     }
1084 
1085     emit Transfer(from, to, tokenId);
1086     _afterTokenTransfers(from, to, tokenId, 1);
1087   }
1088 
1089   /**
1090    * @dev Approve `to` to operate on `tokenId`
1091    *
1092    * Emits a {Approval} event.
1093    */
1094   function _approve(
1095     address to,
1096     uint256 tokenId,
1097     address owner
1098   ) private {
1099     _tokenApprovals[tokenId] = to;
1100     emit Approval(owner, to, tokenId);
1101   }
1102 
1103   uint256 public nextOwnerToExplicitlySet = 0;
1104 
1105   /**
1106    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1107    */
1108   function _setOwnersExplicit(uint256 quantity) internal {
1109     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1110     require(quantity > 0, "quantity must be nonzero");
1111     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1112     if (endIndex > collectionSize - 1) {
1113       endIndex = collectionSize - 1;
1114     }
1115     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1116     require(_exists(endIndex), "not enough minted yet for this cleanup");
1117     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1118       if (_ownerships[i].addr == address(0)) {
1119         TokenOwnership memory ownership = ownershipOf(i);
1120         _ownerships[i] = TokenOwnership(
1121           ownership.addr,
1122           ownership.startTimestamp
1123         );
1124       }
1125     }
1126     nextOwnerToExplicitlySet = endIndex + 1;
1127   }
1128 
1129   /**
1130    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1131    * The call is not executed if the target address is not a contract.
1132    *
1133    * @param from address representing the previous owner of the given token ID
1134    * @param to target address that will receive the tokens
1135    * @param tokenId uint256 ID of the token to be transferred
1136    * @param _data bytes optional data to send along with the call
1137    * @return bool whether the call correctly returned the expected magic value
1138    */
1139   function _checkOnERC721Received(
1140     address from,
1141     address to,
1142     uint256 tokenId,
1143     bytes memory _data
1144   ) private returns (bool) {
1145     if (to.isContract()) {
1146       try
1147         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1148       returns (bytes4 retval) {
1149         return retval == IERC721Receiver(to).onERC721Received.selector;
1150       } catch (bytes memory reason) {
1151         if (reason.length == 0) {
1152           revert("ERC721A: transfer to non ERC721Receiver implementer");
1153         } else {
1154           assembly {
1155             revert(add(32, reason), mload(reason))
1156           }
1157         }
1158       }
1159     } else {
1160       return true;
1161     }
1162   }
1163 
1164   /**
1165    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1166    *
1167    * startTokenId - the first token id to be transferred
1168    * quantity - the amount to be transferred
1169    *
1170    * Calling conditions:
1171    *
1172    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1173    * transferred to `to`.
1174    * - When `from` is zero, `tokenId` will be minted for `to`.
1175    */
1176   function _beforeTokenTransfers(
1177     address from,
1178     address to,
1179     uint256 startTokenId,
1180     uint256 quantity
1181   ) internal virtual {}
1182 
1183   /**
1184    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1185    * minting.
1186    *
1187    * startTokenId - the first token id to be transferred
1188    * quantity - the amount to be transferred
1189    *
1190    * Calling conditions:
1191    *
1192    * - when `from` and `to` are both non-zero.
1193    * - `from` and `to` are never both zero.
1194    */
1195   function _afterTokenTransfers(
1196     address from,
1197     address to,
1198     uint256 startTokenId,
1199     uint256 quantity
1200   ) internal virtual {}
1201 }
1202 
1203 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1204 
1205 pragma solidity ^0.8.0;
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
1222     event OwnershipTransferred(
1223         address indexed previousOwner,
1224         address indexed newOwner
1225     );
1226 
1227     /**
1228      * @dev Initializes the contract setting the deployer as the initial owner.
1229      */
1230     constructor() {
1231         _transferOwnership(_msgSender());
1232     }
1233 
1234     /**
1235      * @dev Returns the address of the current owner.
1236      */
1237     function owner() public view virtual returns (address) {
1238         return _owner;
1239     }
1240 
1241     /**
1242      * @dev Throws if called by any account other than the owner.
1243      */
1244     modifier onlyOwner() {
1245         require(owner() == _msgSender(), "You are not the owner");
1246         _;
1247     }
1248 
1249     /**
1250      * @dev Leaves the contract without owner. It will not be possible to call
1251      * `onlyOwner` functions anymore. Can only be called by the current owner.
1252      *
1253      * NOTE: Renouncing ownership will leave the contract without an owner,
1254      * thereby removing any functionality that is only available to the owner.
1255      */
1256     function renounceOwnership() public virtual onlyOwner {
1257         _transferOwnership(address(0));
1258     }
1259 
1260     /**
1261      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1262      * Can only be called by the current owner.
1263      */
1264     function transferOwnership(address newOwner) public virtual onlyOwner {
1265         require(
1266             newOwner != address(0),
1267             "Ownable: new owner is the zero address"
1268         );
1269         _transferOwnership(newOwner);
1270     }
1271 
1272     /**
1273      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1274      * Internal function without access restriction.
1275      */
1276     function _transferOwnership(address newOwner) internal virtual {
1277         address oldOwner = _owner;
1278         _owner = newOwner;
1279         emit OwnershipTransferred(oldOwner, newOwner);
1280     }
1281 }
1282 
1283 
1284 pragma solidity ^0.8.0;
1285 
1286 contract Goldbirds is ERC721A, Ownable {
1287     uint256 public NFT_PRICE = 0 ether;
1288     uint256 public MAX_SUPPLY = 5000;
1289     uint256 public MAX_MINTS = 5;
1290     string public baseURI = "ipfs://QmcmqWPmWJz97HohLSqdrC1bQbaKKy1wtu3RGhoxFAkKNw/";
1291     string public baseExtension = ".json";
1292      bool public paused = false;
1293     
1294     constructor() ERC721A("Goldbirds", "GOLDBRD", MAX_MINTS, MAX_SUPPLY) {  
1295     }
1296     
1297 
1298     function Mint(uint256 numTokens) public payable {
1299         require(!paused, "Paused");
1300         require(numTokens > 0 && numTokens <= MAX_MINTS);
1301         require(totalSupply() + numTokens <= MAX_SUPPLY);
1302         require(MAX_MINTS >= numTokens, "Excess max per paid tx");
1303         require(msg.value >= numTokens * NFT_PRICE, "Invalid funds provided");
1304         _safeMint(msg.sender, numTokens);
1305     }
1306 
1307     function DevsMint(uint256 numTokens) public payable onlyOwner {
1308         _safeMint(msg.sender, numTokens);
1309     }
1310 
1311 
1312     function pause(bool _state) public onlyOwner {
1313         paused = _state;
1314     }
1315 
1316     function setBaseURI(string memory newBaseURI) public onlyOwner {
1317         baseURI = newBaseURI;
1318     }
1319     function tokenURI(uint256 _tokenId)
1320         public
1321         view
1322         override
1323         returns (string memory)
1324     {
1325         require(_exists(_tokenId), "That token doesn't exist");
1326         return
1327             bytes(baseURI).length > 0
1328                 ? string(
1329                     abi.encodePacked(
1330                         baseURI,
1331                         Strings.toString(_tokenId),
1332                         baseExtension
1333                     )
1334                 )
1335                 : "";
1336     }
1337 
1338     function setPrice(uint256 newPrice) public onlyOwner {
1339         NFT_PRICE = newPrice;
1340     }
1341 
1342     function setMaxMints(uint256 newMax) public onlyOwner {
1343         MAX_MINTS = newMax;
1344     }
1345 
1346     function _baseURI() internal view virtual override returns (string memory) {
1347         return baseURI;
1348     }
1349 
1350     function withdrawMoney() external onlyOwner {
1351       (bool success, ) = msg.sender.call{value: address(this).balance}("");
1352       require(success, "WITHDRAW FAILED!");
1353     }
1354 }