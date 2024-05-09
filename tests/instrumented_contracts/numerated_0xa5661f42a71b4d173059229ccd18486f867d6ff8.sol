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
291 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
292 
293 
294 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
295 
296 pragma solidity ^0.8.0;
297 
298 /**
299  * @dev Interface of the ERC165 standard, as defined in the
300  * https://eips.ethereum.org/EIPS/eip-165[EIP].
301  *
302  * Implementers can declare support of contract interfaces, which can then be
303  * queried by others ({ERC165Checker}).
304  *
305  * For an implementation, see {ERC165}.
306  */
307 interface IERC165 {
308     /**
309      * @dev Returns true if this contract implements the interface defined by
310      * `interfaceId`. See the corresponding
311      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
312      * to learn more about how these ids are created.
313      *
314      * This function call must use less than 30 000 gas.
315      */
316     function supportsInterface(bytes4 interfaceId) external view returns (bool);
317 }
318 
319 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
320 
321 
322 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
323 
324 pragma solidity ^0.8.0;
325 
326 
327 /**
328  * @dev Implementation of the {IERC165} interface.
329  *
330  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
331  * for the additional interface id that will be supported. For example:
332  *
333  * ```solidity
334  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
335  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
336  * }
337  * ```
338  *
339  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
340  */
341 abstract contract ERC165 is IERC165 {
342     /**
343      * @dev See {IERC165-supportsInterface}.
344      */
345     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
346         return interfaceId == type(IERC165).interfaceId;
347     }
348 }
349 
350 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
351 
352 
353 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 
358 /**
359  * @dev Required interface of an ERC721 compliant contract.
360  */
361 interface IERC721 is IERC165 {
362     /**
363      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
364      */
365     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
366 
367     /**
368      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
369      */
370     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
371 
372     /**
373      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
374      */
375     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
376 
377     /**
378      * @dev Returns the number of tokens in ``owner``'s account.
379      */
380     function balanceOf(address owner) external view returns (uint256 balance);
381 
382     /**
383      * @dev Returns the owner of the `tokenId` token.
384      *
385      * Requirements:
386      *
387      * - `tokenId` must exist.
388      */
389     function ownerOf(uint256 tokenId) external view returns (address owner);
390 
391     /**
392      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
393      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
394      *
395      * Requirements:
396      *
397      * - `from` cannot be the zero address.
398      * - `to` cannot be the zero address.
399      * - `tokenId` token must exist and be owned by `from`.
400      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
401      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
402      *
403      * Emits a {Transfer} event.
404      */
405     function safeTransferFrom(
406         address from,
407         address to,
408         uint256 tokenId
409     ) external;
410 
411     /**
412      * @dev Transfers `tokenId` token from `from` to `to`.
413      *
414      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
415      *
416      * Requirements:
417      *
418      * - `from` cannot be the zero address.
419      * - `to` cannot be the zero address.
420      * - `tokenId` token must be owned by `from`.
421      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
422      *
423      * Emits a {Transfer} event.
424      */
425     function transferFrom(
426         address from,
427         address to,
428         uint256 tokenId
429     ) external;
430 
431     /**
432      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
433      * The approval is cleared when the token is transferred.
434      *
435      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
436      *
437      * Requirements:
438      *
439      * - The caller must own the token or be an approved operator.
440      * - `tokenId` must exist.
441      *
442      * Emits an {Approval} event.
443      */
444     function approve(address to, uint256 tokenId) external;
445 
446     /**
447      * @dev Returns the account approved for `tokenId` token.
448      *
449      * Requirements:
450      *
451      * - `tokenId` must exist.
452      */
453     function getApproved(uint256 tokenId) external view returns (address operator);
454 
455     /**
456      * @dev Approve or remove `operator` as an operator for the caller.
457      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
458      *
459      * Requirements:
460      *
461      * - The `operator` cannot be the caller.
462      *
463      * Emits an {ApprovalForAll} event.
464      */
465     function setApprovalForAll(address operator, bool _approved) external;
466 
467     /**
468      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
469      *
470      * See {setApprovalForAll}
471      */
472     function isApprovedForAll(address owner, address operator) external view returns (bool);
473 
474     /**
475      * @dev Safely transfers `tokenId` token from `from` to `to`.
476      *
477      * Requirements:
478      *
479      * - `from` cannot be the zero address.
480      * - `to` cannot be the zero address.
481      * - `tokenId` token must exist and be owned by `from`.
482      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
483      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
484      *
485      * Emits a {Transfer} event.
486      */
487     function safeTransferFrom(
488         address from,
489         address to,
490         uint256 tokenId,
491         bytes calldata data
492     ) external;
493 }
494 
495 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 
503 /**
504  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
505  * @dev See https://eips.ethereum.org/EIPS/eip-721
506  */
507 interface IERC721Enumerable is IERC721 {
508     /**
509      * @dev Returns the total amount of tokens stored by the contract.
510      */
511     function totalSupply() external view returns (uint256);
512 
513     /**
514      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
515      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
516      */
517     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
518 
519     /**
520      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
521      * Use along with {totalSupply} to enumerate all tokens.
522      */
523     function tokenByIndex(uint256 index) external view returns (uint256);
524 }
525 
526 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
527 
528 
529 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
536  * @dev See https://eips.ethereum.org/EIPS/eip-721
537  */
538 interface IERC721Metadata is IERC721 {
539     /**
540      * @dev Returns the token collection name.
541      */
542     function name() external view returns (string memory);
543 
544     /**
545      * @dev Returns the token collection symbol.
546      */
547     function symbol() external view returns (string memory);
548 
549     /**
550      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
551      */
552     function tokenURI(uint256 tokenId) external view returns (string memory);
553 }
554 
555 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
556 
557 
558 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @title ERC721 token receiver interface
564  * @dev Interface for any contract that wants to support safeTransfers
565  * from ERC721 asset contracts.
566  */
567 interface IERC721Receiver {
568     /**
569      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
570      * by `operator` from `from`, this function is called.
571      *
572      * It must return its Solidity selector to confirm the token transfer.
573      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
574      *
575      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
576      */
577     function onERC721Received(
578         address operator,
579         address from,
580         uint256 tokenId,
581         bytes calldata data
582     ) external returns (bytes4);
583 }
584 
585 // File: @openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol
586 
587 
588 // OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)
589 
590 pragma solidity ^0.8.0;
591 
592 
593 /**
594  * @dev Implementation of the {IERC721Receiver} interface.
595  *
596  * Accepts all token transfers.
597  * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
598  */
599 contract ERC721Holder is IERC721Receiver {
600     /**
601      * @dev See {IERC721Receiver-onERC721Received}.
602      *
603      * Always returns `IERC721Receiver.onERC721Received.selector`.
604      */
605     function onERC721Received(
606         address,
607         address,
608         uint256,
609         bytes memory
610     ) public virtual override returns (bytes4) {
611         return this.onERC721Received.selector;
612     }
613 }
614 
615 // File: @openzeppelin/contracts/utils/Context.sol
616 
617 
618 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
619 
620 pragma solidity ^0.8.0;
621 
622 /**
623  * @dev Provides information about the current execution context, including the
624  * sender of the transaction and its data. While these are generally available
625  * via msg.sender and msg.data, they should not be accessed in such a direct
626  * manner, since when dealing with meta-transactions the account sending and
627  * paying for execution may not be the actual sender (as far as an application
628  * is concerned).
629  *
630  * This contract is only required for intermediate, library-like contracts.
631  */
632 abstract contract Context {
633     function _msgSender() internal view virtual returns (address) {
634         return msg.sender;
635     }
636 
637     function _msgData() internal view virtual returns (bytes calldata) {
638         return msg.data;
639     }
640 }
641 
642 // File: Haroburu/ERC721A.sol
643 
644 
645 
646 pragma solidity ^0.8.0;
647 
648 
649 
650 
651 
652 
653 
654 
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
914 
915     _operatorApprovals[_msgSender()][operator] = approved;
916     emit ApprovalForAll(_msgSender(), operator, approved);
917   }
918 
919   /**
920    * @dev See {IERC721-isApprovedForAll}.
921    */
922   function isApprovedForAll(address owner, address operator)
923     public
924     view
925     virtual
926     override
927     returns (bool)
928   {
929     return _operatorApprovals[owner][operator];
930   }
931 
932   /**
933    * @dev See {IERC721-transferFrom}.
934    */
935   function transferFrom(
936     address from,
937     address to,
938     uint256 tokenId
939   ) public override {
940     _transfer(from, to, tokenId);
941   }
942 
943   /**
944    * @dev See {IERC721-safeTransferFrom}.
945    */
946   function safeTransferFrom(
947     address from,
948     address to,
949     uint256 tokenId
950   ) public override {
951     safeTransferFrom(from, to, tokenId, "");
952   }
953 
954   /**
955    * @dev See {IERC721-safeTransferFrom}.
956    */
957   function safeTransferFrom(
958     address from,
959     address to,
960     uint256 tokenId,
961     bytes memory _data
962   ) public override {
963     _transfer(from, to, tokenId);
964     require(
965       _checkOnERC721Received(from, to, tokenId, _data),
966       "ERC721A: transfer to non ERC721Receiver implementer"
967     );
968   }
969 
970   /**
971    * @dev Returns whether `tokenId` exists.
972    *
973    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
974    *
975    * Tokens start existing when they are minted (`_mint`),
976    */
977   function _exists(uint256 tokenId) internal view returns (bool) {
978     return tokenId < currentIndex;
979   }
980 
981   function _safeMint(address to, uint256 quantity) internal {
982     _safeMint(to, quantity, "");
983   }
984 
985   /**
986    * @dev Mints `quantity` tokens and transfers them to `to`.
987    *
988    * Requirements:
989    *
990    * - there must be `quantity` tokens remaining unminted in the total collection.
991    * - `to` cannot be the zero address.
992    * - `quantity` cannot be larger than the max batch size.
993    *
994    * Emits a {Transfer} event.
995    */
996   function _safeMint(
997     address to,
998     uint256 quantity,
999     bytes memory _data
1000   ) internal {
1001     uint256 startTokenId = currentIndex;
1002     require(to != address(0), "ERC721A: mint to the zero address");
1003     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1004     require(!_exists(startTokenId), "ERC721A: token already minted");
1005     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1006 
1007     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1008 
1009     AddressData memory addressData = _addressData[to];
1010     _addressData[to] = AddressData(
1011       addressData.balance + uint128(quantity),
1012       addressData.numberMinted + uint128(quantity)
1013     );
1014     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1015 
1016     uint256 updatedIndex = startTokenId;
1017 
1018     for (uint256 i = 0; i < quantity; i++) {
1019       emit Transfer(address(0), to, updatedIndex);
1020       require(
1021         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1022         "ERC721A: transfer to non ERC721Receiver implementer"
1023       );
1024       updatedIndex++;
1025     }
1026 
1027     currentIndex = updatedIndex;
1028     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1029   }
1030 
1031   /**
1032    * @dev Transfers `tokenId` from `from` to `to`.
1033    *
1034    * Requirements:
1035    *
1036    * - `to` cannot be the zero address.
1037    * - `tokenId` token must be owned by `from`.
1038    *
1039    * Emits a {Transfer} event.
1040    */
1041   function _transfer(
1042     address from,
1043     address to,
1044     uint256 tokenId
1045   ) private {
1046     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1047 
1048     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1049       getApproved(tokenId) == _msgSender() ||
1050       isApprovedForAll(prevOwnership.addr, _msgSender()));
1051 
1052     require(
1053       isApprovedOrOwner,
1054       "ERC721A: transfer caller is not owner nor approved"
1055     );
1056 
1057     require(
1058       prevOwnership.addr == from,
1059       "ERC721A: transfer from incorrect owner"
1060     );
1061     require(to != address(0), "ERC721A: transfer to the zero address");
1062 
1063     _beforeTokenTransfers(from, to, tokenId, 1);
1064 
1065     // Clear approvals from the previous owner
1066     _approve(address(0), tokenId, prevOwnership.addr);
1067 
1068     _addressData[from].balance -= 1;
1069     _addressData[to].balance += 1;
1070     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1071 
1072     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1073     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1074     uint256 nextTokenId = tokenId + 1;
1075     if (_ownerships[nextTokenId].addr == address(0)) {
1076       if (_exists(nextTokenId)) {
1077         _ownerships[nextTokenId] = TokenOwnership(
1078           prevOwnership.addr,
1079           prevOwnership.startTimestamp
1080         );
1081       }
1082     }
1083 
1084     emit Transfer(from, to, tokenId);
1085     _afterTokenTransfers(from, to, tokenId, 1);
1086   }
1087 
1088   /**
1089    * @dev Approve `to` to operate on `tokenId`
1090    *
1091    * Emits a {Approval} event.
1092    */
1093   function _approve(
1094     address to,
1095     uint256 tokenId,
1096     address owner
1097   ) private {
1098     _tokenApprovals[tokenId] = to;
1099     emit Approval(owner, to, tokenId);
1100   }
1101 
1102   uint256 public nextOwnerToExplicitlySet = 0;
1103 
1104   /**
1105    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1106    */
1107   function _setOwnersExplicit(uint256 quantity) internal {
1108     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1109     require(quantity > 0, "quantity must be nonzero");
1110     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1111     if (endIndex > collectionSize - 1) {
1112       endIndex = collectionSize - 1;
1113     }
1114     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1115     require(_exists(endIndex), "not enough minted yet for this cleanup");
1116     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1117       if (_ownerships[i].addr == address(0)) {
1118         TokenOwnership memory ownership = ownershipOf(i);
1119         _ownerships[i] = TokenOwnership(
1120           ownership.addr,
1121           ownership.startTimestamp
1122         );
1123       }
1124     }
1125     nextOwnerToExplicitlySet = endIndex + 1;
1126   }
1127 
1128   /**
1129    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1130    * The call is not executed if the target address is not a contract.
1131    *
1132    * @param from address representing the previous owner of the given token ID
1133    * @param to target address that will receive the tokens
1134    * @param tokenId uint256 ID of the token to be transferred
1135    * @param _data bytes optional data to send along with the call
1136    * @return bool whether the call correctly returned the expected magic value
1137    */
1138   function _checkOnERC721Received(
1139     address from,
1140     address to,
1141     uint256 tokenId,
1142     bytes memory _data
1143   ) private returns (bool) {
1144     if (to.isContract()) {
1145       try
1146         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1147       returns (bytes4 retval) {
1148         return retval == IERC721Receiver(to).onERC721Received.selector;
1149       } catch (bytes memory reason) {
1150         if (reason.length == 0) {
1151           revert("ERC721A: transfer to non ERC721Receiver implementer");
1152         } else {
1153           assembly {
1154             revert(add(32, reason), mload(reason))
1155           }
1156         }
1157       }
1158     } else {
1159       return true;
1160     }
1161   }
1162 
1163   /**
1164    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1165    *
1166    * startTokenId - the first token id to be transferred
1167    * quantity - the amount to be transferred
1168    *
1169    * Calling conditions:
1170    *
1171    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1172    * transferred to `to`.
1173    * - When `from` is zero, `tokenId` will be minted for `to`.
1174    */
1175   function _beforeTokenTransfers(
1176     address from,
1177     address to,
1178     uint256 startTokenId,
1179     uint256 quantity
1180   ) internal virtual {}
1181 
1182   /**
1183    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1184    * minting.
1185    *
1186    * startTokenId - the first token id to be transferred
1187    * quantity - the amount to be transferred
1188    *
1189    * Calling conditions:
1190    *
1191    * - when `from` and `to` are both non-zero.
1192    * - `from` and `to` are never both zero.
1193    */
1194   function _afterTokenTransfers(
1195     address from,
1196     address to,
1197     uint256 startTokenId,
1198     uint256 quantity
1199   ) internal virtual {}
1200 }
1201 // File: @openzeppelin/contracts/access/Ownable.sol
1202 
1203 
1204 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1205 
1206 pragma solidity ^0.8.0;
1207 
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
1224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1225 
1226     /**
1227      * @dev Initializes the contract setting the deployer as the initial owner.
1228      */
1229     constructor() {
1230         _transferOwnership(_msgSender());
1231     }
1232 
1233     /**
1234      * @dev Returns the address of the current owner.
1235      */
1236     function owner() public view virtual returns (address) {
1237         return _owner;
1238     }
1239 
1240     /**
1241      * @dev Throws if called by any account other than the owner.
1242      */
1243     modifier onlyOwner() {
1244         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1245         _;
1246     }
1247 
1248     /**
1249      * @dev Leaves the contract without owner. It will not be possible to call
1250      * `onlyOwner` functions anymore. Can only be called by the current owner.
1251      *
1252      * NOTE: Renouncing ownership will leave the contract without an owner,
1253      * thereby removing any functionality that is only available to the owner.
1254      */
1255     function renounceOwnership() public virtual onlyOwner {
1256         _transferOwnership(address(0));
1257     }
1258 
1259     /**
1260      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1261      * Can only be called by the current owner.
1262      */
1263     function transferOwnership(address newOwner) public virtual onlyOwner {
1264         require(newOwner != address(0), "Ownable: new owner is the zero address");
1265         _transferOwnership(newOwner);
1266     }
1267 
1268     /**
1269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1270      * Internal function without access restriction.
1271      */
1272     function _transferOwnership(address newOwner) internal virtual {
1273         address oldOwner = _owner;
1274         _owner = newOwner;
1275         emit OwnershipTransferred(oldOwner, newOwner);
1276     }
1277 }
1278 
1279 // File: Haroburu/Haroburu.sol
1280 
1281 
1282 /*
1283 */
1284 pragma solidity ^0.8.0;
1285 
1286 
1287 
1288 
1289 
1290 contract Haroburu is ERC721Holder,ERC721A, Ownable {
1291     IERC721 public nft;
1292     uint256 public immutable maxPerAddressDuringMint;
1293 
1294     string public PROVENANCE;
1295     bool public saleIsActive = false;
1296     string private _baseURIextended;
1297 
1298     bool public isAllowListActive = false;
1299     uint256 public constant MAX_PUBLIC_MINT = 2;
1300     uint256 public constant PRICE_PER_TOKEN = 0.048 ether;
1301     uint256 public constant PUBLIC_PRICE_PER_TOKEN = 0.058 ether;
1302 
1303     mapping(address => uint8) private _allowList;
1304     mapping(address => uint8) private _allowList2;
1305     mapping(address => uint8) private _allowList3;
1306     mapping(address => uint8) private _allowList4;
1307 
1308     constructor(
1309     uint256 maxBatchSize_,
1310     uint256 collectionSize_
1311     ) ERC721A("Haroburu", "HAROBURU", maxBatchSize_, collectionSize_) {
1312         maxPerAddressDuringMint = maxBatchSize_;
1313         nft = IERC721(this);
1314     
1315     }
1316 
1317     function setIsAllowListActive(bool _isAllowListActive) external onlyOwner {
1318         isAllowListActive = _isAllowListActive;
1319     }
1320 
1321     function setAllowList(address[] calldata addresses, uint8 numAllowedToMint) external onlyOwner {
1322         for (uint256 i = 0; i < addresses.length; i++) {
1323             _allowList[addresses[i]] = numAllowedToMint;
1324         }
1325     }
1326 
1327     function setAllowList2(address[] calldata addresses, uint8 numAllowedToMint) external onlyOwner {
1328         for (uint256 i = 0; i < addresses.length; i++) {
1329             _allowList2[addresses[i]] = numAllowedToMint;
1330         }
1331     }
1332 
1333     function setAllowList3(address[] calldata addresses, uint8 numAllowedToMint) external onlyOwner {
1334         for (uint256 i = 0; i < addresses.length; i++) {
1335             _allowList3[addresses[i]] = numAllowedToMint;
1336         }
1337     }
1338 
1339     function setAllowList4(address[] calldata addresses, uint8 numAllowedToMint) external onlyOwner {
1340         for (uint256 i = 0; i < addresses.length; i++) {
1341             _allowList4[addresses[i]] = numAllowedToMint;
1342         }
1343     }
1344 
1345     function numAvailableToMintPool(address addr) external view returns (uint8) {
1346         return _allowList[addr];
1347     }
1348 
1349     function numAvailableToMintPool2(address addr) external view returns (uint8) {
1350         return _allowList2[addr];
1351     }
1352     
1353     function numAvailableToMintPool3(address addr) external view returns (uint8) {
1354         return _allowList3[addr];
1355     }
1356     function numAvailableToMintPool4(address addr) external view returns (uint8) {
1357         return _allowList4[addr];
1358     }
1359 
1360     function mintAllowList(uint8 numberOfTokens) external payable {
1361         require(isAllowListActive, "Allow list is not active");
1362         require(numberOfTokens <= _allowList[msg.sender], "Exceeded max available to purchase");
1363         require(totalSupply() + numberOfTokens <= collectionSize, "Purchase would exceed max tokens");
1364         require(PRICE_PER_TOKEN * numberOfTokens <= msg.value, "Ether value sent is not correct");
1365 
1366         _allowList[msg.sender] -= numberOfTokens;
1367         _safeMint(msg.sender, numberOfTokens);
1368     }
1369 
1370     function mintAllowList2(uint8 numberOfTokens) external payable {
1371         require(isAllowListActive, "Allow list is not active");
1372         require(numberOfTokens <= _allowList2[msg.sender], "Exceeded max available to purchase");
1373         require(totalSupply() + numberOfTokens <= collectionSize, "Purchase would exceed max tokens");
1374         require(PRICE_PER_TOKEN * numberOfTokens <= msg.value, "Ether value sent is not correct");
1375 
1376         _allowList2[msg.sender] -= numberOfTokens;
1377         _safeMint(msg.sender, numberOfTokens);
1378     }
1379 
1380     function mintAllowList3(uint8 numberOfTokens) external payable {
1381         require(isAllowListActive, "Allow list is not active");
1382         require(numberOfTokens <= _allowList3[msg.sender], "Exceeded max available to purchase");
1383         require(totalSupply() + numberOfTokens <= collectionSize, "Purchase would exceed max tokens");
1384         require(PRICE_PER_TOKEN * numberOfTokens <= msg.value, "Ether value sent is not correct");
1385 
1386         _allowList3[msg.sender] -= numberOfTokens;
1387         _safeMint(msg.sender, numberOfTokens);
1388     }
1389 
1390     function mintAllowList4(uint8 numberOfTokens) external payable {
1391         require(isAllowListActive, "Allow list is not active");
1392         require(numberOfTokens <= _allowList4[msg.sender], "Exceeded max available to purchase");
1393         require(totalSupply() + numberOfTokens <= collectionSize, "Purchase would exceed max tokens");
1394         require(PRICE_PER_TOKEN * numberOfTokens <= msg.value, "Ether value sent is not correct");
1395 
1396         _allowList4[msg.sender] -= numberOfTokens;
1397         _safeMint(msg.sender, numberOfTokens);
1398     }
1399 
1400     function setBaseURI(string memory baseURI_) external onlyOwner() {
1401         _baseURIextended = baseURI_;
1402     }
1403 
1404     function _baseURI() internal view virtual override returns (string memory) {
1405         return _baseURIextended;
1406     }
1407 
1408     function setProvenance(string memory provenance) public onlyOwner {
1409         PROVENANCE = provenance;
1410     }
1411 
1412     function reserve(uint256 numberOfTokens, address to) public onlyOwner {
1413       _safeMint(to, numberOfTokens);
1414     }
1415 
1416     function setSaleState(bool newState) public onlyOwner {
1417         saleIsActive = newState;
1418     }
1419 
1420     function mint(uint numberOfTokens) public payable {
1421         require(saleIsActive, "Sale must be active to mint tokens");
1422         require(numberOfTokens <= MAX_PUBLIC_MINT, "Exceeded max token purchase");
1423         require(totalSupply() + numberOfTokens <= collectionSize, "Purchase would exceed max tokens");
1424         require(PUBLIC_PRICE_PER_TOKEN * numberOfTokens <= msg.value, "Ether value sent is not correct");
1425 
1426         _safeMint(msg.sender, numberOfTokens);
1427     }
1428 
1429     function withdraw() public onlyOwner {
1430         uint balance = address(this).balance;
1431         payable(msg.sender).transfer(balance);
1432     }
1433 
1434         /**
1435     @dev tokenId to staking start time (0 = not staking).
1436      */
1437     mapping(uint256 => uint256) private stakingStarted;
1438 
1439     /**
1440     @dev Cumulative per-token staking, excluding the current period.
1441      */
1442     mapping(uint256 => uint256) private stakingTotal;
1443 
1444 
1445     function stakingPeriod(uint256 tokenId)
1446         external
1447         view
1448         returns (
1449             bool staking,
1450             uint256 current,
1451             uint256 total
1452         )
1453     {
1454         uint256 start = stakingStarted[tokenId];
1455         if (start != 0) {
1456             staking = true;
1457             current = block.timestamp - start;
1458         }
1459         total = current + stakingTotal[tokenId];
1460     }
1461 
1462     /**
1463     @dev MUST only be modified by safeTransferWhileStaking(); if set to 2 then
1464     the _beforeTokenTransfer() block while staking is disabled.
1465      */
1466     uint256 private stakingTransfer = 1;
1467 
1468     /**
1469     @notice Transfer a token between addresses while the Moonbird is minting,
1470     thus not resetting the staking period.
1471      */
1472     function safeTransferWhileStaking(
1473         address from,
1474         address to,
1475         uint256 tokenId
1476     ) external {
1477         require(ownerOf(tokenId) == _msgSender(), "Haroburu: Only owner");
1478         stakingTransfer = 2;
1479         safeTransferFrom(from, to, tokenId);
1480         stakingTransfer = 1;
1481     }
1482 
1483     /**
1484     @dev Block transfers while staking.
1485      */
1486     function _beforeTokenTransfers(
1487         address,
1488         address,
1489         uint256 startTokenId,
1490         uint256 quantity
1491     ) internal view override {
1492         uint256 tokenId = startTokenId;
1493         for (uint256 end = tokenId + quantity; tokenId < end; ++tokenId) {
1494             require(
1495                 stakingStarted[tokenId] == 0 || stakingTransfer == 2,
1496                 "Haroburus: staking"
1497             );
1498         }
1499     }
1500 
1501     /**
1502     @dev Emitted when a Haroburu begins staking.
1503      */
1504     event Staked(uint256 indexed tokenId);
1505 
1506     /**
1507     @dev Emitted when a Haroburu stops staking; either through standard means or
1508     by expulsion.
1509      */
1510     event Unstaked(uint256 indexed tokenId);
1511 
1512     /**
1513     @dev Emitted when a Haroburu is expelled from the staked.
1514      */
1515     event Expelled(uint256 indexed tokenId);
1516 
1517     /**
1518     @notice Whether staking is currently allowed.
1519     @dev If false then staking is blocked, but staking is always allowed.
1520      */
1521     bool public stakingOpen = false;
1522 
1523     /**
1524     @notice Turn the `stakingOpen` flag.
1525      */
1526     function setStakingOpen(bool open) external onlyOwner {
1527         stakingOpen = open;
1528     }
1529 
1530     /**
1531     @notice Changes the Haroburu's staking status.
1532     */
1533     function staking(uint256 tokenId) public
1534     {
1535         uint256 start = stakingStarted[tokenId];
1536         if (start == 0) {
1537             require(stakingOpen, "Haroburus: staking closed");
1538             stakingStarted[tokenId] = block.timestamp;
1539             emit Staked(tokenId);
1540         } else {
1541             stakingTotal[tokenId] += block.timestamp - start;
1542             stakingStarted[tokenId] = 0;
1543             emit Unstaked(tokenId);
1544         }
1545     }
1546 
1547     /**
1548     @notice Changes the Haroburus' staking statuss (what's the plural of status?
1549     statii? statuses? status? The plural of sheep is sheep; maybe it's also the
1550     plural of status).
1551     @dev Changes the Haroburus' staking sheep (see @notice).
1552      */
1553     function staking(uint256[] calldata tokenIds) external {
1554         uint256 n = tokenIds.length;
1555         for (uint256 i = 0; i < n; ++i) {
1556             staking(tokenIds[i]);
1557         }
1558     }
1559 
1560     function expelFromStake(uint256 tokenId) external {
1561         require(ownerOf(tokenId) == _msgSender(), "Haroburu: Only owner");
1562         require(stakingStarted[tokenId] != 0, "Haroburus: not staked");
1563         stakingTotal[tokenId] += block.timestamp - stakingStarted[tokenId];
1564         stakingStarted[tokenId] = 0;
1565         emit Unstaked(tokenId);
1566         emit Expelled(tokenId);
1567     }
1568 
1569 
1570 }