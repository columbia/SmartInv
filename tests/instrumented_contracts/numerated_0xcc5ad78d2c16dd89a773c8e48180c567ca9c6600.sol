1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      */
99     function isContract(address account) internal view returns (bool) {
100         // This method relies on extcodesize, which returns 0 for contracts in
101         // construction, since the code is only stored at the end of the
102         // constructor execution.
103 
104         uint256 size;
105         assembly {
106             size := extcodesize(account)
107         }
108         return size > 0;
109     }
110 
111     /**
112      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
113      * `recipient`, forwarding all available gas and reverting on errors.
114      *
115      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
116      * of certain opcodes, possibly making contracts go over the 2300 gas limit
117      * imposed by `transfer`, making them unable to receive funds via
118      * `transfer`. {sendValue} removes this limitation.
119      *
120      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
121      *
122      * IMPORTANT: because control is transferred to `recipient`, care must be
123      * taken to not create reentrancy vulnerabilities. Consider using
124      * {ReentrancyGuard} or the
125      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
126      */
127     function sendValue(address payable recipient, uint256 amount) internal {
128         require(address(this).balance >= amount, "Address: insufficient balance");
129 
130         (bool success, ) = recipient.call{value: amount}("");
131         require(success, "Address: unable to send value, recipient may have reverted");
132     }
133 
134     /**
135      * @dev Performs a Solidity function call using a low level `call`. A
136      * plain `call` is an unsafe replacement for a function call: use this
137      * function instead.
138      *
139      * If `target` reverts with a revert reason, it is bubbled up by this
140      * function (like regular Solidity function calls).
141      *
142      * Returns the raw returned data. To convert to the expected return value,
143      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
144      *
145      * Requirements:
146      *
147      * - `target` must be a contract.
148      * - calling `target` with `data` must not revert.
149      *
150      * _Available since v3.1._
151      */
152     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
153         return functionCall(target, data, "Address: low-level call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
158      * `errorMessage` as a fallback revert reason when `target` reverts.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         return functionCallWithValue(target, data, 0, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but also transferring `value` wei to `target`.
173      *
174      * Requirements:
175      *
176      * - the calling contract must have an ETH balance of at least `value`.
177      * - the called Solidity function must be `payable`.
178      *
179      * _Available since v3.1._
180      */
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value
185     ) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
191      * with `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         require(address(this).balance >= value, "Address: insufficient balance for call");
202         require(isContract(target), "Address: call to non-contract");
203 
204         (bool success, bytes memory returndata) = target.call{value: value}(data);
205         return verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
215         return functionStaticCall(target, data, "Address: low-level static call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal view returns (bytes memory) {
229         require(isContract(target), "Address: static call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.staticcall(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a delegate call.
238      *
239      * _Available since v3.4._
240      */
241     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
242         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a delegate call.
248      *
249      * _Available since v3.4._
250      */
251     function functionDelegateCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal returns (bytes memory) {
256         require(isContract(target), "Address: delegate call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.delegatecall(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
264      * revert reason using the provided one.
265      *
266      * _Available since v4.3._
267      */
268     function verifyCallResult(
269         bool success,
270         bytes memory returndata,
271         string memory errorMessage
272     ) internal pure returns (bytes memory) {
273         if (success) {
274             return returndata;
275         } else {
276             // Look for revert reason and bubble it up if present
277             if (returndata.length > 0) {
278                 // The easiest way to bubble the revert reason is using memory via assembly
279 
280                 assembly {
281                     let returndata_size := mload(returndata)
282                     revert(add(32, returndata), returndata_size)
283                 }
284             } else {
285                 revert(errorMessage);
286             }
287         }
288     }
289 }
290 
291 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
292 
293 
294 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
295 
296 pragma solidity ^0.8.0;
297 
298 /**
299  * @title ERC721 token receiver interface
300  * @dev Interface for any contract that wants to support safeTransfers
301  * from ERC721 asset contracts.
302  */
303 interface IERC721Receiver {
304     /**
305      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
306      * by `operator` from `from`, this function is called.
307      *
308      * It must return its Solidity selector to confirm the token transfer.
309      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
310      *
311      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
312      */
313     function onERC721Received(
314         address operator,
315         address from,
316         uint256 tokenId,
317         bytes calldata data
318     ) external returns (bytes4);
319 }
320 
321 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
322 
323 
324 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
325 
326 pragma solidity ^0.8.0;
327 
328 /**
329  * @dev Interface of the ERC165 standard, as defined in the
330  * https://eips.ethereum.org/EIPS/eip-165[EIP].
331  *
332  * Implementers can declare support of contract interfaces, which can then be
333  * queried by others ({ERC165Checker}).
334  *
335  * For an implementation, see {ERC165}.
336  */
337 interface IERC165 {
338     /**
339      * @dev Returns true if this contract implements the interface defined by
340      * `interfaceId`. See the corresponding
341      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
342      * to learn more about how these ids are created.
343      *
344      * This function call must use less than 30 000 gas.
345      */
346     function supportsInterface(bytes4 interfaceId) external view returns (bool);
347 }
348 
349 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
350 
351 
352 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev Implementation of the {IERC165} interface.
359  *
360  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
361  * for the additional interface id that will be supported. For example:
362  *
363  * ```solidity
364  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
365  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
366  * }
367  * ```
368  *
369  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
370  */
371 abstract contract ERC165 is IERC165 {
372     /**
373      * @dev See {IERC165-supportsInterface}.
374      */
375     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
376         return interfaceId == type(IERC165).interfaceId;
377     }
378 }
379 
380 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
381 
382 
383 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 
388 /**
389  * @dev Required interface of an ERC721 compliant contract.
390  */
391 interface IERC721 is IERC165 {
392     /**
393      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
394      */
395     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
396 
397     /**
398      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
399      */
400     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
404      */
405     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
406 
407     /**
408      * @dev Returns the number of tokens in ``owner``'s account.
409      */
410     function balanceOf(address owner) external view returns (uint256 balance);
411 
412     /**
413      * @dev Returns the owner of the `tokenId` token.
414      *
415      * Requirements:
416      *
417      * - `tokenId` must exist.
418      */
419     function ownerOf(uint256 tokenId) external view returns (address owner);
420 
421     /**
422      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
423      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must exist and be owned by `from`.
430      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
432      *
433      * Emits a {Transfer} event.
434      */
435     function safeTransferFrom(
436         address from,
437         address to,
438         uint256 tokenId
439     ) external;
440 
441     /**
442      * @dev Transfers `tokenId` token from `from` to `to`.
443      *
444      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
445      *
446      * Requirements:
447      *
448      * - `from` cannot be the zero address.
449      * - `to` cannot be the zero address.
450      * - `tokenId` token must be owned by `from`.
451      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
452      *
453      * Emits a {Transfer} event.
454      */
455     function transferFrom(
456         address from,
457         address to,
458         uint256 tokenId
459     ) external;
460 
461     /**
462      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
463      * The approval is cleared when the token is transferred.
464      *
465      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
466      *
467      * Requirements:
468      *
469      * - The caller must own the token or be an approved operator.
470      * - `tokenId` must exist.
471      *
472      * Emits an {Approval} event.
473      */
474     function approve(address to, uint256 tokenId) external;
475 
476     /**
477      * @dev Returns the account approved for `tokenId` token.
478      *
479      * Requirements:
480      *
481      * - `tokenId` must exist.
482      */
483     function getApproved(uint256 tokenId) external view returns (address operator);
484 
485     /**
486      * @dev Approve or remove `operator` as an operator for the caller.
487      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
488      *
489      * Requirements:
490      *
491      * - The `operator` cannot be the caller.
492      *
493      * Emits an {ApprovalForAll} event.
494      */
495     function setApprovalForAll(address operator, bool _approved) external;
496 
497     /**
498      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
499      *
500      * See {setApprovalForAll}
501      */
502     function isApprovedForAll(address owner, address operator) external view returns (bool);
503 
504     /**
505      * @dev Safely transfers `tokenId` token from `from` to `to`.
506      *
507      * Requirements:
508      *
509      * - `from` cannot be the zero address.
510      * - `to` cannot be the zero address.
511      * - `tokenId` token must exist and be owned by `from`.
512      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
513      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
514      *
515      * Emits a {Transfer} event.
516      */
517     function safeTransferFrom(
518         address from,
519         address to,
520         uint256 tokenId,
521         bytes calldata data
522     ) external;
523 }
524 
525 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 
533 /**
534  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
535  * @dev See https://eips.ethereum.org/EIPS/eip-721
536  */
537 interface IERC721Enumerable is IERC721 {
538     /**
539      * @dev Returns the total amount of tokens stored by the contract.
540      */
541     function totalSupply() external view returns (uint256);
542 
543     /**
544      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
545      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
546      */
547     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
548 
549     /**
550      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
551      * Use along with {totalSupply} to enumerate all tokens.
552      */
553     function tokenByIndex(uint256 index) external view returns (uint256);
554 }
555 
556 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 
564 /**
565  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
566  * @dev See https://eips.ethereum.org/EIPS/eip-721
567  */
568 interface IERC721Metadata is IERC721 {
569     /**
570      * @dev Returns the token collection name.
571      */
572     function name() external view returns (string memory);
573 
574     /**
575      * @dev Returns the token collection symbol.
576      */
577     function symbol() external view returns (string memory);
578 
579     /**
580      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
581      */
582     function tokenURI(uint256 tokenId) external view returns (string memory);
583 }
584 
585 // File: @openzeppelin/contracts/utils/Context.sol
586 
587 
588 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
589 
590 pragma solidity ^0.8.0;
591 
592 /**
593  * @dev Provides information about the current execution context, including the
594  * sender of the transaction and its data. While these are generally available
595  * via msg.sender and msg.data, they should not be accessed in such a direct
596  * manner, since when dealing with meta-transactions the account sending and
597  * paying for execution may not be the actual sender (as far as an application
598  * is concerned).
599  *
600  * This contract is only required for intermediate, library-like contracts.
601  */
602 abstract contract Context {
603     function _msgSender() internal view virtual returns (address) {
604         return msg.sender;
605     }
606 
607     function _msgData() internal view virtual returns (bytes calldata) {
608         return msg.data;
609     }
610 }
611 
612 // File: contracts/ERC721A.sol
613 
614 
615 
616 pragma solidity ^0.8.0;
617 
618 
619 
620 
621 
622 
623 
624 
625 
626 /**
627  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
628  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
629  *
630  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
631  *
632  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
633  *
634  * Does not support burning tokens to address(0).
635  */
636 contract ERC721A is
637   Context,
638   ERC165,
639   IERC721,
640   IERC721Metadata,
641   IERC721Enumerable
642 {
643   using Address for address;
644   using Strings for uint256;
645 
646   struct TokenOwnership {
647     address addr;
648     uint64 startTimestamp;
649   }
650 
651   struct AddressData {
652     uint128 balance;
653     uint128 numberMinted;
654   }
655 
656   uint256 private currentIndex = 0;
657 
658   uint256 internal immutable collectionSize;
659   uint256 internal immutable maxBatchSize;
660 
661   // Token name
662   string private _name;
663 
664   // Token symbol
665   string private _symbol;
666 
667   // Mapping from token ID to ownership details
668   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
669   mapping(uint256 => TokenOwnership) private _ownerships;
670 
671   // Mapping owner address to address data
672   mapping(address => AddressData) private _addressData;
673 
674   // Mapping from token ID to approved address
675   mapping(uint256 => address) private _tokenApprovals;
676 
677   // Mapping from owner to operator approvals
678   mapping(address => mapping(address => bool)) private _operatorApprovals;
679 
680   /**
681    * @dev
682    * `maxBatchSize` refers to how much a minter can mint at a time.
683    * `collectionSize_` refers to how many tokens are in the collection.
684    */
685   constructor(
686     string memory name_,
687     string memory symbol_,
688     uint256 maxBatchSize_,
689     uint256 collectionSize_
690   ) {
691     require(
692       collectionSize_ > 0,
693       "ERC721A: collection must have a nonzero supply"
694     );
695     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
696     _name = name_;
697     _symbol = symbol_;
698     maxBatchSize = maxBatchSize_;
699     collectionSize = collectionSize_;
700   }
701 
702   /**
703    * @dev See {IERC721Enumerable-totalSupply}.
704    */
705   function totalSupply() public view override returns (uint256) {
706     return currentIndex;
707   }
708 
709   /**
710    * @dev See {IERC721Enumerable-tokenByIndex}.
711    */
712   function tokenByIndex(uint256 index) public view override returns (uint256) {
713     require(index < totalSupply(), "ERC721A: global index out of bounds");
714     return index;
715   }
716 
717   /**
718    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
719    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
720    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
721    */
722   function tokenOfOwnerByIndex(address owner, uint256 index)
723     public
724     view
725     override
726     returns (uint256)
727   {
728     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
729     uint256 numMintedSoFar = totalSupply();
730     uint256 tokenIdsIdx = 0;
731     address currOwnershipAddr = address(0);
732     for (uint256 i = 0; i < numMintedSoFar; i++) {
733       TokenOwnership memory ownership = _ownerships[i];
734       if (ownership.addr != address(0)) {
735         currOwnershipAddr = ownership.addr;
736       }
737       if (currOwnershipAddr == owner) {
738         if (tokenIdsIdx == index) {
739           return i;
740         }
741         tokenIdsIdx++;
742       }
743     }
744     revert("ERC721A: unable to get token of owner by index");
745   }
746 
747   /**
748    * @dev See {IERC165-supportsInterface}.
749    */
750   function supportsInterface(bytes4 interfaceId)
751     public
752     view
753     virtual
754     override(ERC165, IERC165)
755     returns (bool)
756   {
757     return
758       interfaceId == type(IERC721).interfaceId ||
759       interfaceId == type(IERC721Metadata).interfaceId ||
760       interfaceId == type(IERC721Enumerable).interfaceId ||
761       super.supportsInterface(interfaceId);
762   }
763 
764   /**
765    * @dev See {IERC721-balanceOf}.
766    */
767   function balanceOf(address owner) public view override returns (uint256) {
768     require(owner != address(0), "ERC721A: balance query for the zero address");
769     return uint256(_addressData[owner].balance);
770   }
771 
772   function _numberMinted(address owner) internal view returns (uint256) {
773     require(
774       owner != address(0),
775       "ERC721A: number minted query for the zero address"
776     );
777     return uint256(_addressData[owner].numberMinted);
778   }
779 
780   function ownershipOf(uint256 tokenId)
781     internal
782     view
783     returns (TokenOwnership memory)
784   {
785     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
786 
787     uint256 lowestTokenToCheck;
788     if (tokenId >= maxBatchSize) {
789       lowestTokenToCheck = tokenId - maxBatchSize + 1;
790     }
791 
792     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
793       TokenOwnership memory ownership = _ownerships[curr];
794       if (ownership.addr != address(0)) {
795         return ownership;
796       }
797     }
798 
799     revert("ERC721A: unable to determine the owner of token");
800   }
801 
802   /**
803    * @dev See {IERC721-ownerOf}.
804    */
805   function ownerOf(uint256 tokenId) public view override returns (address) {
806     return ownershipOf(tokenId).addr;
807   }
808 
809   /**
810    * @dev See {IERC721Metadata-name}.
811    */
812   function name() public view virtual override returns (string memory) {
813     return _name;
814   }
815 
816   /**
817    * @dev See {IERC721Metadata-symbol}.
818    */
819   function symbol() public view virtual override returns (string memory) {
820     return _symbol;
821   }
822 
823   /**
824    * @dev See {IERC721Metadata-tokenURI}.
825    */
826   function tokenURI(uint256 tokenId)
827     public
828     view
829     virtual
830     override
831     returns (string memory)
832   {
833     require(
834       _exists(tokenId),
835       "ERC721Metadata: URI query for nonexistent token"
836     );
837 
838     string memory baseURI = _baseURI();
839     return
840       bytes(baseURI).length > 0
841         ? string(abi.encodePacked(baseURI, tokenId.toString()))
842         : "";
843   }
844 
845   /**
846    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
847    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
848    * by default, can be overriden in child contracts.
849    */
850   function _baseURI() internal view virtual returns (string memory) {
851     return "";
852   }
853 
854   /**
855    * @dev See {IERC721-approve}.
856    */
857   function approve(address to, uint256 tokenId) public override {
858     address owner = ERC721A.ownerOf(tokenId);
859     require(to != owner, "ERC721A: approval to current owner");
860 
861     require(
862       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
863       "ERC721A: approve caller is not owner nor approved for all"
864     );
865 
866     _approve(to, tokenId, owner);
867   }
868 
869   /**
870    * @dev See {IERC721-getApproved}.
871    */
872   function getApproved(uint256 tokenId) public view override returns (address) {
873     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
874 
875     return _tokenApprovals[tokenId];
876   }
877 
878   /**
879    * @dev See {IERC721-setApprovalForAll}.
880    */
881   function setApprovalForAll(address operator, bool approved) public override {
882     require(operator != _msgSender(), "ERC721A: approve to caller");
883 
884     _operatorApprovals[_msgSender()][operator] = approved;
885     emit ApprovalForAll(_msgSender(), operator, approved);
886   }
887 
888   /**
889    * @dev See {IERC721-isApprovedForAll}.
890    */
891   function isApprovedForAll(address owner, address operator)
892     public
893     view
894     virtual
895     override
896     returns (bool)
897   {
898     return _operatorApprovals[owner][operator];
899   }
900 
901   /**
902    * @dev See {IERC721-transferFrom}.
903    */
904   function transferFrom(
905     address from,
906     address to,
907     uint256 tokenId
908   ) public override {
909     _transfer(from, to, tokenId);
910   }
911 
912   /**
913    * @dev See {IERC721-safeTransferFrom}.
914    */
915   function safeTransferFrom(
916     address from,
917     address to,
918     uint256 tokenId
919   ) public override {
920     safeTransferFrom(from, to, tokenId, "");
921   }
922 
923   /**
924    * @dev See {IERC721-safeTransferFrom}.
925    */
926   function safeTransferFrom(
927     address from,
928     address to,
929     uint256 tokenId,
930     bytes memory _data
931   ) public override {
932     _transfer(from, to, tokenId);
933     require(
934       _checkOnERC721Received(from, to, tokenId, _data),
935       "ERC721A: transfer to non ERC721Receiver implementer"
936     );
937   }
938 
939   /**
940    * @dev Returns whether `tokenId` exists.
941    *
942    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
943    *
944    * Tokens start existing when they are minted (`_mint`),
945    */
946   function _exists(uint256 tokenId) internal view returns (bool) {
947     return tokenId < currentIndex;
948   }
949 
950   function _safeMint(address to, uint256 quantity) internal {
951     _safeMint(to, quantity, "");
952   }
953 
954   /**
955    * @dev Mints `quantity` tokens and transfers them to `to`.
956    *
957    * Requirements:
958    *
959    * - there must be `quantity` tokens remaining unminted in the total collection.
960    * - `to` cannot be the zero address.
961    * - `quantity` cannot be larger than the max batch size.
962    *
963    * Emits a {Transfer} event.
964    */
965   function _safeMint(
966     address to,
967     uint256 quantity,
968     bytes memory _data
969   ) internal {
970     uint256 startTokenId = currentIndex;
971     require(to != address(0), "ERC721A: mint to the zero address");
972     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
973     require(!_exists(startTokenId), "ERC721A: token already minted");
974     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
975 
976     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
977 
978     AddressData memory addressData = _addressData[to];
979     _addressData[to] = AddressData(
980       addressData.balance + uint128(quantity),
981       addressData.numberMinted + uint128(quantity)
982     );
983     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
984 
985     uint256 updatedIndex = startTokenId;
986 
987     for (uint256 i = 0; i < quantity; i++) {
988       emit Transfer(address(0), to, updatedIndex);
989       require(
990         _checkOnERC721Received(address(0), to, updatedIndex, _data),
991         "ERC721A: transfer to non ERC721Receiver implementer"
992       );
993       updatedIndex++;
994     }
995 
996     currentIndex = updatedIndex;
997     _afterTokenTransfers(address(0), to, startTokenId, quantity);
998   }
999 
1000   /**
1001    * @dev Transfers `tokenId` from `from` to `to`.
1002    *
1003    * Requirements:
1004    *
1005    * - `to` cannot be the zero address.
1006    * - `tokenId` token must be owned by `from`.
1007    *
1008    * Emits a {Transfer} event.
1009    */
1010   function _transfer(
1011     address from,
1012     address to,
1013     uint256 tokenId
1014   ) private {
1015     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1016 
1017     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1018       getApproved(tokenId) == _msgSender() ||
1019       isApprovedForAll(prevOwnership.addr, _msgSender()));
1020 
1021     require(
1022       isApprovedOrOwner,
1023       "ERC721A: transfer caller is not owner nor approved"
1024     );
1025 
1026     require(
1027       prevOwnership.addr == from,
1028       "ERC721A: transfer from incorrect owner"
1029     );
1030     require(to != address(0), "ERC721A: transfer to the zero address");
1031 
1032     _beforeTokenTransfers(from, to, tokenId, 1);
1033 
1034     // Clear approvals from the previous owner
1035     _approve(address(0), tokenId, prevOwnership.addr);
1036 
1037     _addressData[from].balance -= 1;
1038     _addressData[to].balance += 1;
1039     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1040 
1041     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1042     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1043     uint256 nextTokenId = tokenId + 1;
1044     if (_ownerships[nextTokenId].addr == address(0)) {
1045       if (_exists(nextTokenId)) {
1046         _ownerships[nextTokenId] = TokenOwnership(
1047           prevOwnership.addr,
1048           prevOwnership.startTimestamp
1049         );
1050       }
1051     }
1052 
1053     emit Transfer(from, to, tokenId);
1054     _afterTokenTransfers(from, to, tokenId, 1);
1055   }
1056 
1057   /**
1058    * @dev Approve `to` to operate on `tokenId`
1059    *
1060    * Emits a {Approval} event.
1061    */
1062   function _approve(
1063     address to,
1064     uint256 tokenId,
1065     address owner
1066   ) private {
1067     _tokenApprovals[tokenId] = to;
1068     emit Approval(owner, to, tokenId);
1069   }
1070 
1071   uint256 public nextOwnerToExplicitlySet = 0;
1072 
1073   /**
1074    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1075    */
1076   function _setOwnersExplicit(uint256 quantity) internal {
1077     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1078     require(quantity > 0, "quantity must be nonzero");
1079     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1080     if (endIndex > collectionSize - 1) {
1081       endIndex = collectionSize - 1;
1082     }
1083     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1084     require(_exists(endIndex), "not enough minted yet for this cleanup");
1085     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1086       if (_ownerships[i].addr == address(0)) {
1087         TokenOwnership memory ownership = ownershipOf(i);
1088         _ownerships[i] = TokenOwnership(
1089           ownership.addr,
1090           ownership.startTimestamp
1091         );
1092       }
1093     }
1094     nextOwnerToExplicitlySet = endIndex + 1;
1095   }
1096 
1097   /**
1098    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1099    * The call is not executed if the target address is not a contract.
1100    *
1101    * @param from address representing the previous owner of the given token ID
1102    * @param to target address that will receive the tokens
1103    * @param tokenId uint256 ID of the token to be transferred
1104    * @param _data bytes optional data to send along with the call
1105    * @return bool whether the call correctly returned the expected magic value
1106    */
1107   function _checkOnERC721Received(
1108     address from,
1109     address to,
1110     uint256 tokenId,
1111     bytes memory _data
1112   ) private returns (bool) {
1113     if (to.isContract()) {
1114       try
1115         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1116       returns (bytes4 retval) {
1117         return retval == IERC721Receiver(to).onERC721Received.selector;
1118       } catch (bytes memory reason) {
1119         if (reason.length == 0) {
1120           revert("ERC721A: transfer to non ERC721Receiver implementer");
1121         } else {
1122           assembly {
1123             revert(add(32, reason), mload(reason))
1124           }
1125         }
1126       }
1127     } else {
1128       return true;
1129     }
1130   }
1131 
1132   /**
1133    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1134    *
1135    * startTokenId - the first token id to be transferred
1136    * quantity - the amount to be transferred
1137    *
1138    * Calling conditions:
1139    *
1140    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1141    * transferred to `to`.
1142    * - When `from` is zero, `tokenId` will be minted for `to`.
1143    */
1144   function _beforeTokenTransfers(
1145     address from,
1146     address to,
1147     uint256 startTokenId,
1148     uint256 quantity
1149   ) internal virtual {}
1150 
1151   /**
1152    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1153    * minting.
1154    *
1155    * startTokenId - the first token id to be transferred
1156    * quantity - the amount to be transferred
1157    *
1158    * Calling conditions:
1159    *
1160    * - when `from` and `to` are both non-zero.
1161    * - `from` and `to` are never both zero.
1162    */
1163   function _afterTokenTransfers(
1164     address from,
1165     address to,
1166     uint256 startTokenId,
1167     uint256 quantity
1168   ) internal virtual {}
1169 }
1170 // File: @openzeppelin/contracts/access/Ownable.sol
1171 
1172 
1173 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1174 
1175 pragma solidity ^0.8.0;
1176 
1177 
1178 /**
1179  * @dev Contract module which provides a basic access control mechanism, where
1180  * there is an account (an owner) that can be granted exclusive access to
1181  * specific functions.
1182  *
1183  * By default, the owner account will be the one that deploys the contract. This
1184  * can later be changed with {transferOwnership}.
1185  *
1186  * This module is used through inheritance. It will make available the modifier
1187  * `onlyOwner`, which can be applied to your functions to restrict their use to
1188  * the owner.
1189  */
1190 abstract contract Ownable is Context {
1191     address private _owner;
1192 
1193     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1194 
1195     /**
1196      * @dev Initializes the contract setting the deployer as the initial owner.
1197      */
1198     constructor() {
1199         _transferOwnership(_msgSender());
1200     }
1201 
1202     /**
1203      * @dev Returns the address of the current owner.
1204      */
1205     function owner() public view virtual returns (address) {
1206         return _owner;
1207     }
1208 
1209     /**
1210      * @dev Throws if called by any account other than the owner.
1211      */
1212     modifier onlyOwner() {
1213         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1214         _;
1215     }
1216 
1217     /**
1218      * @dev Leaves the contract without owner. It will not be possible to call
1219      * `onlyOwner` functions anymore. Can only be called by the current owner.
1220      *
1221      * NOTE: Renouncing ownership will leave the contract without an owner,
1222      * thereby removing any functionality that is only available to the owner.
1223      */
1224     function renounceOwnership() public virtual onlyOwner {
1225         _transferOwnership(address(0));
1226     }
1227 
1228     /**
1229      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1230      * Can only be called by the current owner.
1231      */
1232     function transferOwnership(address newOwner) public virtual onlyOwner {
1233         require(newOwner != address(0), "Ownable: new owner is the zero address");
1234         _transferOwnership(newOwner);
1235     }
1236 
1237     /**
1238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1239      * Internal function without access restriction.
1240      */
1241     function _transferOwnership(address newOwner) internal virtual {
1242         address oldOwner = _owner;
1243         _owner = newOwner;
1244         emit OwnershipTransferred(oldOwner, newOwner);
1245     }
1246 }
1247 
1248 // File: contracts/egirldao.sol
1249 
1250 
1251 pragma solidity ^0.8.0;
1252 
1253 //import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
1254 
1255 
1256 contract egirldao is Ownable, ERC721A {
1257     uint256 public constant MAX_SUPPLY = 1095;
1258     uint256 public constant FREE_MINT_AMOUNT = 200;
1259     uint256 public constant MINT_LIMIT = 5;
1260 
1261     uint256 public mintPrice = 0.02 ether;
1262     uint256 public currentSupply;
1263     string public baseURI;
1264 
1265     constructor() ERC721A("egirldao", "EGIRL", MINT_LIMIT, MAX_SUPPLY) {}
1266 
1267     function setBaseURI(string calldata _base) external onlyOwner {
1268         baseURI = _base;
1269     }
1270 
1271     function _baseURI() internal view virtual override returns (string memory) {
1272         return baseURI;
1273     }
1274 
1275     function lowerPrice(uint256 _new) external onlyOwner {
1276         require(_new < mintPrice, "egirldao: new price must be lower than previous price");
1277         mintPrice = _new;
1278     }
1279 
1280     function mint(uint256 _amount) external payable {
1281         uint256 supply = currentSupply;
1282 
1283         require(supply + _amount < MAX_SUPPLY, "egirldao: mint would exceed total supply");
1284         require(_amount > 0 && _amount <= MINT_LIMIT, "egirldao: mint amount too high");
1285         require(msg.value >= (mintPrice * _amount), "egirldao: insufficient eth sent");
1286 
1287         currentSupply += _amount;
1288 
1289         _safeMint(msg.sender, _amount);
1290     }
1291 
1292     function freeMint() external {
1293         uint256 supply = currentSupply;
1294         
1295         require(supply < FREE_MINT_AMOUNT, "egirldao: free mints exhausted");
1296 
1297         currentSupply += 1;
1298 
1299         _safeMint(msg.sender, 1);
1300     }
1301 
1302     function withdraw() external onlyOwner {
1303         payable(msg.sender).transfer(address(this).balance);
1304     }
1305 }