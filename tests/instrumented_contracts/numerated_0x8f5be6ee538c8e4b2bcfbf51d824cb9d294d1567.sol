1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214                 /// @solidity memory-safe-assembly
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
227 
228 
229 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @title ERC721 token receiver interface
235  * @dev Interface for any contract that wants to support safeTransfers
236  * from ERC721 asset contracts.
237  */
238 interface IERC721Receiver {
239     /**
240      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
241      * by `operator` from `from`, this function is called.
242      *
243      * It must return its Solidity selector to confirm the token transfer.
244      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
245      *
246      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
247      */
248     function onERC721Received(
249         address operator,
250         address from,
251         uint256 tokenId,
252         bytes calldata data
253     ) external returns (bytes4);
254 }
255 
256 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev Interface of the ERC165 standard, as defined in the
265  * https://eips.ethereum.org/EIPS/eip-165[EIP].
266  *
267  * Implementers can declare support of contract interfaces, which can then be
268  * queried by others ({ERC165Checker}).
269  *
270  * For an implementation, see {ERC165}.
271  */
272 interface IERC165 {
273     /**
274      * @dev Returns true if this contract implements the interface defined by
275      * `interfaceId`. See the corresponding
276      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
277      * to learn more about how these ids are created.
278      *
279      * This function call must use less than 30 000 gas.
280      */
281     function supportsInterface(bytes4 interfaceId) external view returns (bool);
282 }
283 
284 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 
292 /**
293  * @dev Implementation of the {IERC165} interface.
294  *
295  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
296  * for the additional interface id that will be supported. For example:
297  *
298  * ```solidity
299  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
300  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
301  * }
302  * ```
303  *
304  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
305  */
306 abstract contract ERC165 is IERC165 {
307     /**
308      * @dev See {IERC165-supportsInterface}.
309      */
310     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
311         return interfaceId == type(IERC165).interfaceId;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
316 
317 
318 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Required interface of an ERC721 compliant contract.
325  */
326 interface IERC721 is IERC165 {
327     /**
328      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
334      */
335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
339      */
340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
341 
342     /**
343      * @dev Returns the number of tokens in ``owner``'s account.
344      */
345     function balanceOf(address owner) external view returns (uint256 balance);
346 
347     /**
348      * @dev Returns the owner of the `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function ownerOf(uint256 tokenId) external view returns (address owner);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `tokenId` token must exist and be owned by `from`.
364      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
365      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
366      *
367      * Emits a {Transfer} event.
368      */
369     function safeTransferFrom(
370         address from,
371         address to,
372         uint256 tokenId,
373         bytes calldata data
374     ) external;
375 
376     /**
377      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
378      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
379      *
380      * Requirements:
381      *
382      * - `from` cannot be the zero address.
383      * - `to` cannot be the zero address.
384      * - `tokenId` token must exist and be owned by `from`.
385      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
386      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
387      *
388      * Emits a {Transfer} event.
389      */
390     function safeTransferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Transfers `tokenId` token from `from` to `to`.
398      *
399      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
400      *
401      * Requirements:
402      *
403      * - `from` cannot be the zero address.
404      * - `to` cannot be the zero address.
405      * - `tokenId` token must be owned by `from`.
406      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(
411         address from,
412         address to,
413         uint256 tokenId
414     ) external;
415 
416     /**
417      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
418      * The approval is cleared when the token is transferred.
419      *
420      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
421      *
422      * Requirements:
423      *
424      * - The caller must own the token or be an approved operator.
425      * - `tokenId` must exist.
426      *
427      * Emits an {Approval} event.
428      */
429     function approve(address to, uint256 tokenId) external;
430 
431     /**
432      * @dev Approve or remove `operator` as an operator for the caller.
433      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
434      *
435      * Requirements:
436      *
437      * - The `operator` cannot be the caller.
438      *
439      * Emits an {ApprovalForAll} event.
440      */
441     function setApprovalForAll(address operator, bool _approved) external;
442 
443     /**
444      * @dev Returns the account approved for `tokenId` token.
445      *
446      * Requirements:
447      *
448      * - `tokenId` must exist.
449      */
450     function getApproved(uint256 tokenId) external view returns (address operator);
451 
452     /**
453      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
454      *
455      * See {setApprovalForAll}
456      */
457     function isApprovedForAll(address owner, address operator) external view returns (bool);
458 }
459 
460 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
461 
462 
463 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
470  * @dev See https://eips.ethereum.org/EIPS/eip-721
471  */
472 interface IERC721Enumerable is IERC721 {
473     /**
474      * @dev Returns the total amount of tokens stored by the contract.
475      */
476     function totalSupply() external view returns (uint256);
477 
478     /**
479      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
480      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
481      */
482     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
483 
484     /**
485      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
486      * Use along with {totalSupply} to enumerate all tokens.
487      */
488     function tokenByIndex(uint256 index) external view returns (uint256);
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
492 
493 
494 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
501  * @dev See https://eips.ethereum.org/EIPS/eip-721
502  */
503 interface IERC721Metadata is IERC721 {
504     /**
505      * @dev Returns the token collection name.
506      */
507     function name() external view returns (string memory);
508 
509     /**
510      * @dev Returns the token collection symbol.
511      */
512     function symbol() external view returns (string memory);
513 
514     /**
515      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
516      */
517     function tokenURI(uint256 tokenId) external view returns (string memory);
518 }
519 
520 // File: @openzeppelin/contracts/utils/Strings.sol
521 
522 
523 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev String operations.
529  */
530 library Strings {
531     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
532     uint8 private constant _ADDRESS_LENGTH = 20;
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
589 
590     /**
591      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
592      */
593     function toHexString(address addr) internal pure returns (string memory) {
594         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
595     }
596 }
597 
598 // File: @openzeppelin/contracts/utils/Context.sol
599 
600 
601 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @dev Provides information about the current execution context, including the
607  * sender of the transaction and its data. While these are generally available
608  * via msg.sender and msg.data, they should not be accessed in such a direct
609  * manner, since when dealing with meta-transactions the account sending and
610  * paying for execution may not be the actual sender (as far as an application
611  * is concerned).
612  *
613  * This contract is only required for intermediate, library-like contracts.
614  */
615 abstract contract Context {
616     function _msgSender() internal view virtual returns (address) {
617         return msg.sender;
618     }
619 
620     function _msgData() internal view virtual returns (bytes calldata) {
621         return msg.data;
622     }
623 }
624 
625 // File: ERC721A.sol
626 
627 
628 // Creators: locationtba.eth, 2pmflow.eth
629 
630 pragma solidity ^0.8.0;
631 
632 
633 
634 
635 
636 
637 
638 
639 
640 /**
641  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
642  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
643  *
644  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
645  *
646  * Does not support burning tokens to address(0).
647  */
648 contract ERC721A is
649   Context,
650   ERC165,
651   IERC721,
652   IERC721Metadata,
653   IERC721Enumerable
654 {
655   using Address for address;
656   using Strings for uint256;
657 
658   struct TokenOwnership {
659     address addr;
660     uint64 startTimestamp;
661   }
662 
663   struct AddressData {
664     uint128 balance;
665     uint128 numberMinted;
666   }
667 
668   uint256 private currentIndex = 0;
669 
670   uint256 internal immutable maxBatchSize;
671 
672   // Token name
673   string private _name;
674 
675   // Token symbol
676   string private _symbol;
677 
678   // Mapping from token ID to ownership details
679   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
680   mapping(uint256 => TokenOwnership) private _ownerships;
681 
682   // Mapping owner address to address data
683   mapping(address => AddressData) private _addressData;
684 
685   // Mapping from token ID to approved address
686   mapping(uint256 => address) private _tokenApprovals;
687 
688   // Mapping from owner to operator approvals
689   mapping(address => mapping(address => bool)) private _operatorApprovals;
690 
691   /**
692    * @dev
693    * `maxBatchSize` refers to how much a minter can mint at a time.
694    */
695   constructor(
696     string memory name_,
697     string memory symbol_,
698     uint256 maxBatchSize_
699   ) {
700     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
701     _name = name_;
702     _symbol = symbol_;
703     maxBatchSize = maxBatchSize_;
704   }
705 
706   /**
707    * @dev See {IERC721Enumerable-totalSupply}.
708    */
709   function totalSupply() public view override returns (uint256) {
710     return currentIndex;
711   }
712 
713   /**
714    * @dev See {IERC721Enumerable-tokenByIndex}.
715    */
716   function tokenByIndex(uint256 index) public view override returns (uint256) {
717     require(index < totalSupply(), "ERC721A: global index out of bounds");
718     return index;
719   }
720 
721   /**
722    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
723    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
724    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
725    */
726   function tokenOfOwnerByIndex(address owner, uint256 index)
727     public
728     view
729     override
730     returns (uint256)
731   {
732     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
733     uint256 numMintedSoFar = totalSupply();
734     uint256 tokenIdsIdx = 0;
735     address currOwnershipAddr = address(0);
736     for (uint256 i = 0; i < numMintedSoFar; i++) {
737       TokenOwnership memory ownership = _ownerships[i];
738       if (ownership.addr != address(0)) {
739         currOwnershipAddr = ownership.addr;
740       }
741       if (currOwnershipAddr == owner) {
742         if (tokenIdsIdx == index) {
743           return i;
744         }
745         tokenIdsIdx++;
746       }
747     }
748     revert("ERC721A: unable to get token of owner by index");
749   }
750 
751   /**
752    * @dev See {IERC165-supportsInterface}.
753    */
754   function supportsInterface(bytes4 interfaceId)
755     public
756     view
757     virtual
758     override(ERC165, IERC165)
759     returns (bool)
760   {
761     return
762       interfaceId == type(IERC721).interfaceId ||
763       interfaceId == type(IERC721Metadata).interfaceId ||
764       interfaceId == type(IERC721Enumerable).interfaceId ||
765       super.supportsInterface(interfaceId);
766   }
767 
768   /**
769    * @dev See {IERC721-balanceOf}.
770    */
771   function balanceOf(address owner) public view override returns (uint256) {
772     require(owner != address(0), "ERC721A: balance query for the zero address");
773     return uint256(_addressData[owner].balance);
774   }
775 
776   function _numberMinted(address owner) internal view returns (uint256) {
777     require(
778       owner != address(0),
779       "ERC721A: number minted query for the zero address"
780     );
781     return uint256(_addressData[owner].numberMinted);
782   }
783 
784   function ownershipOf(uint256 tokenId)
785     internal
786     view
787     returns (TokenOwnership memory)
788   {
789     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
790 
791     uint256 lowestTokenToCheck;
792     if (tokenId >= maxBatchSize) {
793       lowestTokenToCheck = tokenId - maxBatchSize + 1;
794     }
795 
796     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
797       TokenOwnership memory ownership = _ownerships[curr];
798       if (ownership.addr != address(0)) {
799         return ownership;
800       }
801     }
802 
803     revert("ERC721A: unable to determine the owner of token");
804   }
805 
806   /**
807    * @dev See {IERC721-ownerOf}.
808    */
809   function ownerOf(uint256 tokenId) public view override returns (address) {
810     return ownershipOf(tokenId).addr;
811   }
812 
813   /**
814    * @dev See {IERC721Metadata-name}.
815    */
816   function name() public view virtual override returns (string memory) {
817     return _name;
818   }
819 
820   /**
821    * @dev See {IERC721Metadata-symbol}.
822    */
823   function symbol() public view virtual override returns (string memory) {
824     return _symbol;
825   }
826 
827   /**
828    * @dev See {IERC721Metadata-tokenURI}.
829    */
830   function tokenURI(uint256 tokenId)
831     public
832     view
833     virtual
834     override
835     returns (string memory)
836   {
837     require(
838       _exists(tokenId),
839       "ERC721Metadata: URI query for nonexistent token"
840     );
841 
842     string memory baseURI = _baseURI();
843     return
844       bytes(baseURI).length > 0
845         ? string(abi.encodePacked(baseURI, tokenId.toString()))
846         : "";
847   }
848 
849   /**
850    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
851    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
852    * by default, can be overriden in child contracts.
853    */
854   function _baseURI() internal view virtual returns (string memory) {
855     return "";
856   }
857 
858   /**
859    * @dev See {IERC721-approve}.
860    */
861   function approve(address to, uint256 tokenId) public override {
862     address owner = ERC721A.ownerOf(tokenId);
863     require(to != owner, "ERC721A: approval to current owner");
864 
865     require(
866       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
867       "ERC721A: approve caller is not owner nor approved for all"
868     );
869 
870     _approve(to, tokenId, owner);
871   }
872 
873   /**
874    * @dev See {IERC721-getApproved}.
875    */
876   function getApproved(uint256 tokenId) public view override returns (address) {
877     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
878 
879     return _tokenApprovals[tokenId];
880   }
881 
882   /**
883    * @dev See {IERC721-setApprovalForAll}.
884    */
885   function setApprovalForAll(address operator, bool approved) public override {
886     require(operator != _msgSender(), "ERC721A: approve to caller");
887 
888     _operatorApprovals[_msgSender()][operator] = approved;
889     emit ApprovalForAll(_msgSender(), operator, approved);
890   }
891 
892   /**
893    * @dev See {IERC721-isApprovedForAll}.
894    */
895   function isApprovedForAll(address owner, address operator)
896     public
897     view
898     virtual
899     override
900     returns (bool)
901   {
902     return _operatorApprovals[owner][operator];
903   }
904 
905   /**
906    * @dev See {IERC721-transferFrom}.
907    */
908   function transferFrom(
909     address from,
910     address to,
911     uint256 tokenId
912   ) public override {
913     _transfer(from, to, tokenId);
914   }
915 
916   /**
917    * @dev See {IERC721-safeTransferFrom}.
918    */
919   function safeTransferFrom(
920     address from,
921     address to,
922     uint256 tokenId
923   ) public override {
924     safeTransferFrom(from, to, tokenId, "");
925   }
926 
927   /**
928    * @dev See {IERC721-safeTransferFrom}.
929    */
930   function safeTransferFrom(
931     address from,
932     address to,
933     uint256 tokenId,
934     bytes memory _data
935   ) public override {
936     _transfer(from, to, tokenId);
937     require(
938       _checkOnERC721Received(from, to, tokenId, _data),
939       "ERC721A: transfer to non ERC721Receiver implementer"
940     );
941   }
942 
943   /**
944    * @dev Returns whether `tokenId` exists.
945    *
946    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
947    *
948    * Tokens start existing when they are minted (`_mint`),
949    */
950   function _exists(uint256 tokenId) internal view returns (bool) {
951     return tokenId < currentIndex;
952   }
953 
954   function _safeMint(address to, uint256 quantity) internal {
955     _safeMint(to, quantity, "");
956   }
957 
958   /**
959    * @dev Mints `quantity` tokens and transfers them to `to`.
960    *
961    * Requirements:
962    *
963    * - `to` cannot be the zero address.
964    * - `quantity` cannot be larger than the max batch size.
965    *
966    * Emits a {Transfer} event.
967    */
968   function _safeMint(
969     address to,
970     uint256 quantity,
971     bytes memory _data
972   ) internal {
973     uint256 startTokenId = currentIndex;
974     require(to != address(0), "ERC721A: mint to the zero address");
975     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
976     require(!_exists(startTokenId), "ERC721A: token already minted");
977     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
978 
979     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
980 
981     AddressData memory addressData = _addressData[to];
982     _addressData[to] = AddressData(
983       addressData.balance + uint128(quantity),
984       addressData.numberMinted + uint128(quantity)
985     );
986     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
987 
988     uint256 updatedIndex = startTokenId;
989 
990     for (uint256 i = 0; i < quantity; i++) {
991       emit Transfer(address(0), to, updatedIndex);
992       require(
993         _checkOnERC721Received(address(0), to, updatedIndex, _data),
994         "ERC721A: transfer to non ERC721Receiver implementer"
995       );
996       updatedIndex++;
997     }
998 
999     currentIndex = updatedIndex;
1000     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1001   }
1002 
1003   /**
1004    * @dev Transfers `tokenId` from `from` to `to`.
1005    *
1006    * Requirements:
1007    *
1008    * - `to` cannot be the zero address.
1009    * - `tokenId` token must be owned by `from`.
1010    *
1011    * Emits a {Transfer} event.
1012    */
1013   function _transfer(
1014     address from,
1015     address to,
1016     uint256 tokenId
1017   ) private {
1018     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1019 
1020     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1021       getApproved(tokenId) == _msgSender() ||
1022       isApprovedForAll(prevOwnership.addr, _msgSender()));
1023 
1024     require(
1025       isApprovedOrOwner,
1026       "ERC721A: transfer caller is not owner nor approved"
1027     );
1028 
1029     require(
1030       prevOwnership.addr == from,
1031       "ERC721A: transfer from incorrect owner"
1032     );
1033     require(to != address(0), "ERC721A: transfer to the zero address");
1034 
1035     _beforeTokenTransfers(from, to, tokenId, 1);
1036 
1037     // Clear approvals from the previous owner
1038     _approve(address(0), tokenId, prevOwnership.addr);
1039 
1040     _addressData[from].balance -= 1;
1041     _addressData[to].balance += 1;
1042     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1043 
1044     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1045     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1046     uint256 nextTokenId = tokenId + 1;
1047     if (_ownerships[nextTokenId].addr == address(0)) {
1048       if (_exists(nextTokenId)) {
1049         _ownerships[nextTokenId] = TokenOwnership(
1050           prevOwnership.addr,
1051           prevOwnership.startTimestamp
1052         );
1053       }
1054     }
1055 
1056     emit Transfer(from, to, tokenId);
1057     _afterTokenTransfers(from, to, tokenId, 1);
1058   }
1059 
1060   /**
1061    * @dev Approve `to` to operate on `tokenId`
1062    *
1063    * Emits a {Approval} event.
1064    */
1065   function _approve(
1066     address to,
1067     uint256 tokenId,
1068     address owner
1069   ) private {
1070     _tokenApprovals[tokenId] = to;
1071     emit Approval(owner, to, tokenId);
1072   }
1073 
1074   uint256 public nextOwnerToExplicitlySet = 0;
1075 
1076   /**
1077    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1078    */
1079   function _setOwnersExplicit(uint256 quantity) internal {
1080     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1081     require(quantity > 0, "quantity must be nonzero");
1082     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1083     if (endIndex > currentIndex - 1) {
1084       endIndex = currentIndex - 1;
1085     }
1086     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1087     require(_exists(endIndex), "not enough minted yet for this cleanup");
1088     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1089       if (_ownerships[i].addr == address(0)) {
1090         TokenOwnership memory ownership = ownershipOf(i);
1091         _ownerships[i] = TokenOwnership(
1092           ownership.addr,
1093           ownership.startTimestamp
1094         );
1095       }
1096     }
1097     nextOwnerToExplicitlySet = endIndex + 1;
1098   }
1099 
1100   /**
1101    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1102    * The call is not executed if the target address is not a contract.
1103    *
1104    * @param from address representing the previous owner of the given token ID
1105    * @param to target address that will receive the tokens
1106    * @param tokenId uint256 ID of the token to be transferred
1107    * @param _data bytes optional data to send along with the call
1108    * @return bool whether the call correctly returned the expected magic value
1109    */
1110   function _checkOnERC721Received(
1111     address from,
1112     address to,
1113     uint256 tokenId,
1114     bytes memory _data
1115   ) private returns (bool) {
1116     if (to.isContract()) {
1117       try
1118         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1119       returns (bytes4 retval) {
1120         return retval == IERC721Receiver(to).onERC721Received.selector;
1121       } catch (bytes memory reason) {
1122         if (reason.length == 0) {
1123           revert("ERC721A: transfer to non ERC721Receiver implementer");
1124         } else {
1125           assembly {
1126             revert(add(32, reason), mload(reason))
1127           }
1128         }
1129       }
1130     } else {
1131       return true;
1132     }
1133   }
1134 
1135   /**
1136    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1137    *
1138    * startTokenId - the first token id to be transferred
1139    * quantity - the amount to be transferred
1140    *
1141    * Calling conditions:
1142    *
1143    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1144    * transferred to `to`.
1145    * - When `from` is zero, `tokenId` will be minted for `to`.
1146    */
1147   function _beforeTokenTransfers(
1148     address from,
1149     address to,
1150     uint256 startTokenId,
1151     uint256 quantity
1152   ) internal virtual {}
1153 
1154   /**
1155    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1156    * minting.
1157    *
1158    * startTokenId - the first token id to be transferred
1159    * quantity - the amount to be transferred
1160    *
1161    * Calling conditions:
1162    *
1163    * - when `from` and `to` are both non-zero.
1164    * - `from` and `to` are never both zero.
1165    */
1166   function _afterTokenTransfers(
1167     address from,
1168     address to,
1169     uint256 startTokenId,
1170     uint256 quantity
1171   ) internal virtual {}
1172 }
1173 // File: @openzeppelin/contracts/access/Ownable.sol
1174 
1175 
1176 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1177 
1178 pragma solidity ^0.8.0;
1179 
1180 
1181 /**
1182  * @dev Contract module which provides a basic access control mechanism, where
1183  * there is an account (an owner) that can be granted exclusive access to
1184  * specific functions.
1185  *
1186  * By default, the owner account will be the one that deploys the contract. This
1187  * can later be changed with {transferOwnership}.
1188  *
1189  * This module is used through inheritance. It will make available the modifier
1190  * `onlyOwner`, which can be applied to your functions to restrict their use to
1191  * the owner.
1192  */
1193 abstract contract Ownable is Context {
1194     address private _owner;
1195 
1196     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1197 
1198     /**
1199      * @dev Initializes the contract setting the deployer as the initial owner.
1200      */
1201     constructor() {
1202         _transferOwnership(_msgSender());
1203     }
1204 
1205     /**
1206      * @dev Throws if called by any account other than the owner.
1207      */
1208     modifier onlyOwner() {
1209         _checkOwner();
1210         _;
1211     }
1212 
1213     /**
1214      * @dev Returns the address of the current owner.
1215      */
1216     function owner() public view virtual returns (address) {
1217         return _owner;
1218     }
1219 
1220     /**
1221      * @dev Throws if the sender is not the owner.
1222      */
1223     function _checkOwner() internal view virtual {
1224         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1225     }
1226 
1227     /**
1228      * @dev Leaves the contract without owner. It will not be possible to call
1229      * `onlyOwner` functions anymore. Can only be called by the current owner.
1230      *
1231      * NOTE: Renouncing ownership will leave the contract without an owner,
1232      * thereby removing any functionality that is only available to the owner.
1233      */
1234     function renounceOwnership() public virtual onlyOwner {
1235         _transferOwnership(address(0));
1236     }
1237 
1238     /**
1239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1240      * Can only be called by the current owner.
1241      */
1242     function transferOwnership(address newOwner) public virtual onlyOwner {
1243         require(newOwner != address(0), "Ownable: new owner is the zero address");
1244         _transferOwnership(newOwner);
1245     }
1246 
1247     /**
1248      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1249      * Internal function without access restriction.
1250      */
1251     function _transferOwnership(address newOwner) internal virtual {
1252         address oldOwner = _owner;
1253         _owner = newOwner;
1254         emit OwnershipTransferred(oldOwner, newOwner);
1255     }
1256 }
1257 
1258 // File: KOYE.sol
1259 
1260 
1261 
1262 /*
1263 
1264 ============================================== KOYÉ ==============================================
1265 */
1266 
1267 pragma solidity >=0.8.9 <0.9.0;
1268 
1269 
1270 
1271 
1272 /**
1273  * @title KOYÉ
1274  */
1275 
1276 library MerkleProof {
1277     function verify(
1278         bytes32[] memory proof,
1279         bytes32 root,
1280         bytes32 leaf
1281     ) internal pure returns (bool) {
1282         return processProof(proof, leaf) == root;
1283     }
1284 
1285     function processProof(bytes32[] memory proof, bytes32 leaf)
1286         internal
1287         pure
1288         returns (bytes32)
1289     {
1290         bytes32 computedHash = leaf;
1291         for (uint256 i = 0; i < proof.length; i++) {
1292             computedHash = _hashPair(computedHash, proof[i]);
1293         }
1294         return computedHash;
1295     }
1296 
1297     // Sorted Pair Hash
1298     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1299         return
1300             a < b
1301                 ? keccak256(abi.encodePacked(a, b))
1302                 : keccak256(abi.encodePacked(b, a));
1303     }
1304 }
1305 
1306 contract KOYE is ERC721A, Ownable {
1307     using Strings for uint256;
1308 
1309     bool public revealed = false;
1310     bool public whitelistMintEnabled = false;
1311     bool public publicMintEnabled = false;
1312     uint256 public Price = 0.05 ether;
1313     uint256 public TotalNum = 10000;
1314     uint256 public WhiteListNum = 1700;
1315 
1316     string private _baseURIextended = "";
1317     string public hiddenMetadataUri = "ipfs://QmQ6h22qbEPGwWqFh9MP7se7F49r7S151ReDAsu7f9pnHn";
1318     address private proxyRegistryAddress;
1319 
1320     bytes32 public root = ""; //
1321     mapping(address => bool) public whitelistClaimed; //
1322 
1323     constructor() ERC721A("Mini KOYE", "MKY", 500) {}
1324 
1325     function tokenURI(uint256 _tokenId)
1326         public
1327         view
1328         virtual
1329         override
1330         returns (string memory)
1331     {
1332         if (revealed == false) {
1333             return hiddenMetadataUri;
1334         }
1335         // require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1336         string memory currentBaseURI = _baseURI();
1337         return
1338             string(
1339                 abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json")
1340             );
1341     }
1342 
1343     function setBaseURI(string memory baseURI_) external onlyOwner {
1344         _baseURIextended = baseURI_;
1345     }
1346 
1347     function _baseURI() internal view virtual override returns (string memory) {
1348         return _baseURIextended;
1349     }
1350 
1351     function setRoot(bytes32 mroot) public onlyOwner {
1352         root = mroot;
1353     }
1354 
1355     function setPrice(uint256 newPrice) public onlyOwner {
1356         Price = newPrice;
1357     }
1358 
1359     function setPublicMint(bool enable) public onlyOwner {
1360         publicMintEnabled = enable;
1361     }
1362 
1363     function setWlMint(bool enable) public onlyOwner {
1364         whitelistMintEnabled = enable;
1365     }
1366 
1367     function setRevealed(bool _state) public onlyOwner {
1368         revealed = _state;
1369     }
1370 
1371     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1372         hiddenMetadataUri = _hiddenMetadataUri;
1373     }
1374 
1375     modifier callerIsUser() {
1376         require(tx.origin == msg.sender, "The caller is another contract!");
1377         _;
1378     }
1379 
1380     function mint(uint256 numberOfTokens) external payable callerIsUser {
1381         require(publicMintEnabled, "The whitelist sale is not enabled!");
1382         require(totalSupply() + numberOfTokens <= TotalNum, "already mint out");
1383         require(
1384             (Price * numberOfTokens) <= msg.value,
1385             "Don't send under (in ETH)."
1386         );
1387         _safeMint(msg.sender, numberOfTokens);
1388     }
1389 
1390     //one wl
1391     function wlmint(bytes32[] calldata proof) external callerIsUser {
1392         require(WhiteListNum > 0, "The whitelist already mint out");
1393         require(whitelistMintEnabled, "The whitelist sale is not enabled!");
1394         require(_verify(_leaf(msg.sender), proof), "Invalid merkle proof"); //
1395         require(!whitelistClaimed[msg.sender], "Already minted!"); //
1396 
1397         WhiteListNum -= 1;
1398         whitelistClaimed[msg.sender] = true; //
1399         // mint
1400         _safeMint(msg.sender, 1);
1401     }
1402 
1403     function _leaf(address account) internal pure returns (bytes32) {
1404         return keccak256(abi.encodePacked(account));
1405     }
1406 
1407     function _verify(bytes32 leaf, bytes32[] memory proof)
1408         internal
1409         view
1410         returns (bool)
1411     {
1412         return MerkleProof.verify(proof, root, leaf);
1413     }
1414 
1415     function gift(address _to, uint256 numberOfTokens) external onlyOwner {
1416         require(totalSupply() + numberOfTokens <= TotalNum, "already mint out");
1417         _safeMint(_to, numberOfTokens);
1418     }
1419 
1420     function withdraw() public onlyOwner {
1421         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1422         require(
1423             success,
1424             "Address: unable to send value, recipient may have reverted"
1425         );
1426     }
1427 }