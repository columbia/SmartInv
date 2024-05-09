1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-17
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Implementation of the {IERC165} interface.
36  *
37  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
38  * for the additional interface id that will be supported. For example:
39  *
40  * ```solidity
41  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
42  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
43  * }
44  * ```
45  *
46  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
47  */
48 abstract contract ERC165 is IERC165 {
49     /**
50      * @dev See {IERC165-supportsInterface}.
51      */
52     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
53         return interfaceId == type(IERC165).interfaceId;
54     }
55 }
56 
57 
58 pragma solidity ^0.8.0;
59 
60 /**
61  * @dev Collection of functions related to the address type
62  */
63 library Address {
64     /**
65      * @dev Returns true if `account` is a contract.
66      *
67      * [IMPORTANT]
68      * ====
69      * It is unsafe to assume that an address for which this function returns
70      * false is an externally-owned account (EOA) and not a contract.
71      *
72      * Among others, `isContract` will return false for the following
73      * types of addresses:
74      *
75      *  - an externally-owned account
76      *  - a contract in construction
77      *  - an address where a contract will be created
78      *  - an address where a contract lived, but was destroyed
79      * ====
80      */
81     function isContract(address account) internal view returns (bool) {
82         // This method relies on extcodesize, which returns 0 for contracts in
83         // construction, since the code is only stored at the end of the
84         // constructor execution.
85 
86         uint256 size;
87         assembly {
88             size := extcodesize(account)
89         }
90         return size > 0;
91     }
92 
93     /**
94      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
95      * `recipient`, forwarding all available gas and reverting on errors.
96      *
97      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
98      * of certain opcodes, possibly making contracts go over the 2300 gas limit
99      * imposed by `transfer`, making them unable to receive funds via
100      * `transfer`. {sendValue} removes this limitation.
101      *
102      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
103      *
104      * IMPORTANT: because control is transferred to `recipient`, care must be
105      * taken to not create reentrancy vulnerabilities. Consider using
106      * {ReentrancyGuard} or the
107      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
108      */
109     function sendValue(address payable recipient, uint256 amount) internal {
110         require(address(this).balance >= amount, "Address: insufficient balance");
111 
112         (bool success, ) = recipient.call{value: amount}("");
113         require(success, "Address: unable to send value, recipient may have reverted");
114     }
115 
116     /**
117      * @dev Performs a Solidity function call using a low level `call`. A
118      * plain `call` is an unsafe replacement for a function call: use this
119      * function instead.
120      *
121      * If `target` reverts with a revert reason, it is bubbled up by this
122      * function (like regular Solidity function calls).
123      *
124      * Returns the raw returned data. To convert to the expected return value,
125      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
126      *
127      * Requirements:
128      *
129      * - `target` must be a contract.
130      * - calling `target` with `data` must not revert.
131      *
132      * _Available since v3.1._
133      */
134     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
135         return functionCall(target, data, "Address: low-level call failed");
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
140      * `errorMessage` as a fallback revert reason when `target` reverts.
141      *
142      * _Available since v3.1._
143      */
144     function functionCall(
145         address target,
146         bytes memory data,
147         string memory errorMessage
148     ) internal returns (bytes memory) {
149         return functionCallWithValue(target, data, 0, errorMessage);
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
154      * but also transferring `value` wei to `target`.
155      *
156      * Requirements:
157      *
158      * - the calling contract must have an ETH balance of at least `value`.
159      * - the called Solidity function must be `payable`.
160      *
161      * _Available since v3.1._
162      */
163     function functionCallWithValue(
164         address target,
165         bytes memory data,
166         uint256 value
167     ) internal returns (bytes memory) {
168         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
173      * with `errorMessage` as a fallback revert reason when `target` reverts.
174      *
175      * _Available since v3.1._
176      */
177     function functionCallWithValue(
178         address target,
179         bytes memory data,
180         uint256 value,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         require(address(this).balance >= value, "Address: insufficient balance for call");
184         require(isContract(target), "Address: call to non-contract");
185 
186         (bool success, bytes memory returndata) = target.call{value: value}(data);
187         return _verifyCallResult(success, returndata, errorMessage);
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
192      * but performing a static call.
193      *
194      * _Available since v3.3._
195      */
196     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
197         return functionStaticCall(target, data, "Address: low-level static call failed");
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
202      * but performing a static call.
203      *
204      * _Available since v3.3._
205      */
206     function functionStaticCall(
207         address target,
208         bytes memory data,
209         string memory errorMessage
210     ) internal view returns (bytes memory) {
211         require(isContract(target), "Address: static call to non-contract");
212 
213         (bool success, bytes memory returndata) = target.staticcall(data);
214         return _verifyCallResult(success, returndata, errorMessage);
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
219      * but performing a delegate call.
220      *
221      * _Available since v3.4._
222      */
223     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
224         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
229      * but performing a delegate call.
230      *
231      * _Available since v3.4._
232      */
233     function functionDelegateCall(
234         address target,
235         bytes memory data,
236         string memory errorMessage
237     ) internal returns (bytes memory) {
238         require(isContract(target), "Address: delegate call to non-contract");
239 
240         (bool success, bytes memory returndata) = target.delegatecall(data);
241         return _verifyCallResult(success, returndata, errorMessage);
242     }
243 
244     function _verifyCallResult(
245         bool success,
246         bytes memory returndata,
247         string memory errorMessage
248     ) private pure returns (bytes memory) {
249         if (success) {
250             return returndata;
251         } else {
252             // Look for revert reason and bubble it up if present
253             if (returndata.length > 0) {
254                 // The easiest way to bubble the revert reason is using memory via assembly
255 
256                 assembly {
257                     let returndata_size := mload(returndata)
258                     revert(add(32, returndata), returndata_size)
259                 }
260             } else {
261                 revert(errorMessage);
262             }
263         }
264     }
265 }
266 
267 
268 
269 
270 
271 
272 
273 
274 pragma solidity ^0.8.0;
275 
276 /**
277  * @title ERC721 token receiver interface
278  * @dev Interface for any contract that wants to support safeTransfers
279  * from ERC721 asset contracts.
280  */
281 interface IERC721Receiver {
282     /**
283      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
284      * by `operator` from `from`, this function is called.
285      *
286      * It must return its Solidity selector to confirm the token transfer.
287      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
288      *
289      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
290      */
291     function onERC721Received(
292         address operator,
293         address from,
294         uint256 tokenId,
295         bytes calldata data
296     ) external returns (bytes4);
297 }
298 
299 
300 
301 
302 pragma solidity ^0.8.0;
303 
304 
305 /**
306  * @dev Required interface of an ERC721 compliant contract.
307  */
308 interface IERC721 is IERC165 {
309     /**
310      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
311      */
312     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
313 
314     /**
315      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
316      */
317     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
318 
319     /**
320      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
321      */
322     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
323 
324     /**
325      * @dev Returns the number of tokens in ``owner``'s account.
326      */
327     function balanceOf(address owner) external view returns (uint256 balance);
328 
329     /**
330      * @dev Returns the owner of the `tokenId` token.
331      *
332      * Requirements:
333      *
334      * - `tokenId` must exist.
335      */
336     function ownerOf(uint256 tokenId) external view returns (address owner);
337 
338     /**
339      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
340      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
341      *
342      * Requirements:
343      *
344      * - `from` cannot be the zero address.
345      * - `to` cannot be the zero address.
346      * - `tokenId` token must exist and be owned by `from`.
347      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
348      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
349      *
350      * Emits a {Transfer} event.
351      */
352     function safeTransferFrom(
353         address from,
354         address to,
355         uint256 tokenId
356     ) external;
357 
358     /**
359      * @dev Transfers `tokenId` token from `from` to `to`.
360      *
361      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
362      *
363      * Requirements:
364      *
365      * - `from` cannot be the zero address.
366      * - `to` cannot be the zero address.
367      * - `tokenId` token must be owned by `from`.
368      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
369      *
370      * Emits a {Transfer} event.
371      */
372     function transferFrom(
373         address from,
374         address to,
375         uint256 tokenId
376     ) external;
377 
378     /**
379      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
380      * The approval is cleared when the token is transferred.
381      *
382      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
383      *
384      * Requirements:
385      *
386      * - The caller must own the token or be an approved operator.
387      * - `tokenId` must exist.
388      *
389      * Emits an {Approval} event.
390      */
391     function approve(address to, uint256 tokenId) external;
392 
393     /**
394      * @dev Returns the account approved for `tokenId` token.
395      *
396      * Requirements:
397      *
398      * - `tokenId` must exist.
399      */
400     function getApproved(uint256 tokenId) external view returns (address operator);
401 
402     /**
403      * @dev Approve or remove `operator` as an operator for the caller.
404      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
405      *
406      * Requirements:
407      *
408      * - The `operator` cannot be the caller.
409      *
410      * Emits an {ApprovalForAll} event.
411      */
412     function setApprovalForAll(address operator, bool _approved) external;
413 
414     /**
415      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
416      *
417      * See {setApprovalForAll}
418      */
419     function isApprovedForAll(address owner, address operator) external view returns (bool);
420 
421     /**
422      * @dev Safely transfers `tokenId` token from `from` to `to`.
423      *
424      * Requirements:
425      *
426      * - `from` cannot be the zero address.
427      * - `to` cannot be the zero address.
428      * - `tokenId` token must exist and be owned by `from`.
429      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
430      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
431      *
432      * Emits a {Transfer} event.
433      */
434     function safeTransferFrom(
435         address from,
436         address to,
437         uint256 tokenId,
438         bytes calldata data
439     ) external;
440 }
441 
442 
443 pragma solidity ^0.8.0;
444 
445 
446 /**
447  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
448  * @dev See https://eips.ethereum.org/EIPS/eip-721
449  */
450 interface IERC721Metadata is IERC721 {
451     /**
452      * @dev Returns the token collection name.
453      */
454     function name() external view returns (string memory);
455 
456     /**
457      * @dev Returns the token collection symbol.
458      */
459     function symbol() external view returns (string memory);
460 
461     /**
462      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
463      */
464     function tokenURI(uint256 tokenId) external view returns (string memory);
465 }
466 
467 
468 pragma solidity ^0.8.0;
469 
470 
471 /**
472  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
473  * @dev See https://eips.ethereum.org/EIPS/eip-721
474  */
475 interface IERC721Enumerable is IERC721 {
476     /**
477      * @dev Returns the total amount of tokens stored by the contract.
478      */
479     function totalSupply() external view returns (uint256);
480 
481     /**
482      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
483      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
484      */
485     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
486 
487     /**
488      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
489      * Use along with {totalSupply} to enumerate all tokens.
490      */
491     function tokenByIndex(uint256 index) external view returns (uint256);
492 }
493 
494 pragma solidity ^0.8.0;
495 
496 /*
497  * @dev Provides information about the current execution context, including the
498  * sender of the transaction and its data. While these are generally available
499  * via msg.sender and msg.data, they should not be accessed in such a direct
500  * manner, since when dealing with meta-transactions the account sending and
501  * paying for execution may not be the actual sender (as far as an application
502  * is concerned).
503  *
504  * This contract is only required for intermediate, library-like contracts.
505  */
506 abstract contract Context {
507     function _msgSender() internal view virtual returns (address) {
508         return msg.sender;
509     }
510 
511     function _msgData() internal view virtual returns (bytes calldata) {
512         return msg.data;
513     }
514 }
515 
516 
517 pragma solidity ^0.8.0;
518 
519 /**
520  * @dev String operations.
521  */
522 library Strings {
523     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
524 
525     /**
526      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
527      */
528     function toString(uint256 value) internal pure returns (string memory) {
529         // Inspired by OraclizeAPI's implementation - MIT licence
530         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
531 
532         if (value == 0) {
533             return "0";
534         }
535         uint256 temp = value;
536         uint256 digits;
537         while (temp != 0) {
538             digits++;
539             temp /= 10;
540         }
541         bytes memory buffer = new bytes(digits);
542         while (value != 0) {
543             digits -= 1;
544             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
545             value /= 10;
546         }
547         return string(buffer);
548     }
549 
550     /**
551      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
552      */
553     function toHexString(uint256 value) internal pure returns (string memory) {
554         if (value == 0) {
555             return "0x00";
556         }
557         uint256 temp = value;
558         uint256 length = 0;
559         while (temp != 0) {
560             length++;
561             temp >>= 8;
562         }
563         return toHexString(value, length);
564     }
565 
566     /**
567      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
568      */
569     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
570         bytes memory buffer = new bytes(2 * length + 2);
571         buffer[0] = "0";
572         buffer[1] = "x";
573         for (uint256 i = 2 * length + 1; i > 1; --i) {
574             buffer[i] = _HEX_SYMBOLS[value & 0xf];
575             value >>= 4;
576         }
577         require(value == 0, "Strings: hex length insufficient");
578         return string(buffer);
579     }
580 }
581 
582 
583 pragma solidity ^0.8.0;
584 
585 
586 /**
587  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
588  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
589  *
590  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
591  *
592  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
593  *
594  * Does not support burning tokens to address(0).
595  */
596 contract ERC721A is
597   Context,
598   ERC165,
599   IERC721,
600   IERC721Metadata,
601   IERC721Enumerable
602 {
603   using Address for address;
604   using Strings for uint256;
605 
606   struct TokenOwnership {
607     address addr;
608     uint64 startTimestamp;
609   }
610 
611   struct AddressData {
612     uint128 balance;
613     uint128 numberMinted;
614   }
615 
616   uint256 private currentIndex = 0;
617 
618   uint256 internal  collectionSize;
619   uint256 internal  collectionSizeFree;
620   uint256 internal  maxBatchSize;
621 
622   // Token name
623   string private _name;
624 
625   // Token symbol
626   string private _symbol;
627 
628   // Mapping from token ID to ownership details
629   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
630   mapping(uint256 => TokenOwnership) private _ownerships;
631 
632   // Mapping owner address to address data
633   mapping(address => AddressData) private _addressData;
634 
635   // Mapping from token ID to approved address
636   mapping(uint256 => address) private _tokenApprovals;
637 
638   // Mapping from owner to operator approvals
639   mapping(address => mapping(address => bool)) private _operatorApprovals;
640 
641   /**
642    * @dev
643    * `maxBatchSize` refers to how much a minter can mint at a time.
644    * `collectionSize_` refers to how many tokens are in the collection.
645    */
646   constructor(
647     string memory name_,
648     string memory symbol_,
649     uint256 maxBatchSize_,
650     uint256 collectionSize_,
651     uint256 collectionSizeFree_
652   ) {
653     require(
654       collectionSize_ > 0,
655       "ERC721A: collection must have a nonzero supply"
656     );
657     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
658     _name = name_;
659     _symbol = symbol_;
660     maxBatchSize = maxBatchSize_;
661     collectionSize = collectionSize_;
662     collectionSizeFree = collectionSizeFree_;
663   }
664 
665   /**
666    * @dev See {IERC721Enumerable-totalSupply}.
667    */
668   function totalSupply() public view override returns (uint256) {
669     return currentIndex;
670   }
671 
672   /**
673    * @dev See {IERC721Enumerable-tokenByIndex}.
674    */
675   function tokenByIndex(uint256 index) public view override returns (uint256) {
676     require(index < totalSupply(), "ERC721A: global index out of bounds");
677     return index;
678   }
679 
680   /**
681    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
682    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
683    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
684    */
685   function tokenOfOwnerByIndex(address owner, uint256 index)
686     public
687     view
688     override
689     returns (uint256)
690   {
691     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
692     uint256 numMintedSoFar = totalSupply();
693     uint256 tokenIdsIdx = 0;
694     address currOwnershipAddr = address(0);
695     for (uint256 i = 0; i < numMintedSoFar; i++) {
696       TokenOwnership memory ownership = _ownerships[i];
697       if (ownership.addr != address(0)) {
698         currOwnershipAddr = ownership.addr;
699       }
700       if (currOwnershipAddr == owner) {
701         if (tokenIdsIdx == index) {
702           return i;
703         }
704         tokenIdsIdx++;
705       }
706     }
707     revert("ERC721A: unable to get token of owner by index");
708   }
709 
710   /**
711    * @dev See {IERC165-supportsInterface}.
712    */
713   function supportsInterface(bytes4 interfaceId)
714     public
715     view
716     virtual
717     override(ERC165, IERC165)
718     returns (bool)
719   {
720     return
721       interfaceId == type(IERC721).interfaceId ||
722       interfaceId == type(IERC721Metadata).interfaceId ||
723       interfaceId == type(IERC721Enumerable).interfaceId ||
724       super.supportsInterface(interfaceId);
725   }
726 
727   /**
728    * @dev See {IERC721-balanceOf}.
729    */
730   function balanceOf(address owner) public view override returns (uint256) {
731     require(owner != address(0), "ERC721A: balance query for the zero address");
732     return uint256(_addressData[owner].balance);
733   }
734 
735   function _numberMinted(address owner) internal view returns (uint256) {
736     require(
737       owner != address(0),
738       "ERC721A: number minted query for the zero address"
739     );
740     return uint256(_addressData[owner].numberMinted);
741   }
742 
743   function ownershipOf(uint256 tokenId)
744     internal
745     view
746     returns (TokenOwnership memory)
747   {
748     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
749 
750     uint256 lowestTokenToCheck;
751     if (tokenId >= maxBatchSize) {
752       lowestTokenToCheck = tokenId - maxBatchSize + 1;
753     }
754 
755     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
756       TokenOwnership memory ownership = _ownerships[curr];
757       if (ownership.addr != address(0)) {
758         return ownership;
759       }
760     }
761 
762     revert("ERC721A: unable to determine the owner of token");
763   }
764 
765   /**
766    * @dev See {IERC721-ownerOf}.
767    */
768   function ownerOf(uint256 tokenId) public view override returns (address) {
769     return ownershipOf(tokenId).addr;
770   }
771 
772   /**
773    * @dev See {IERC721Metadata-name}.
774    */
775   function name() public view virtual override returns (string memory) {
776     return _name;
777   }
778 
779   /**
780    * @dev See {IERC721Metadata-symbol}.
781    */
782   function symbol() public view virtual override returns (string memory) {
783     return _symbol;
784   }
785 
786   /**
787    * @dev See {IERC721Metadata-tokenURI}.
788    */
789   function tokenURI(uint256 tokenId)
790     public
791     view
792     virtual
793     override
794     returns (string memory)
795   {
796     require(
797       _exists(tokenId),
798       "ERC721Metadata: URI query for nonexistent token"
799     );
800 
801     string memory baseURI = _baseURI();
802     return
803       bytes(baseURI).length > 0
804         ? string(abi.encodePacked(baseURI, tokenId.toString()))
805         : "";
806   }
807 
808   /**
809    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
810    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
811    * by default, can be overriden in child contracts.
812    */
813   function _baseURI() internal view virtual returns (string memory) {
814     return "";
815   }
816 
817   /**
818    * @dev See {IERC721-approve}.
819    */
820   function approve(address to, uint256 tokenId) public override {
821     address owner = ERC721A.ownerOf(tokenId);
822     require(to != owner, "ERC721A: approval to current owner");
823 
824     require(
825       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
826       "ERC721A: approve caller is not owner nor approved for all"
827     );
828 
829     _approve(to, tokenId, owner);
830   }
831 
832   /**
833    * @dev See {IERC721-getApproved}.
834    */
835   function getApproved(uint256 tokenId) public view override returns (address) {
836     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
837 
838     return _tokenApprovals[tokenId];
839   }
840 
841   /**
842    * @dev See {IERC721-setApprovalForAll}.
843    */
844   function setApprovalForAll(address operator, bool approved) public override {
845     require(operator != _msgSender(), "ERC721A: approve to caller");
846 
847     _operatorApprovals[_msgSender()][operator] = approved;
848     emit ApprovalForAll(_msgSender(), operator, approved);
849   }
850 
851   /**
852    * @dev See {IERC721-isApprovedForAll}.
853    */
854   function isApprovedForAll(address owner, address operator)
855     public
856     view
857     virtual
858     override
859     returns (bool)
860   {
861     return _operatorApprovals[owner][operator];
862   }
863 
864   /**
865    * @dev See {IERC721-transferFrom}.
866    */
867   function transferFrom(
868     address from,
869     address to,
870     uint256 tokenId
871   ) public override {
872     _transfer(from, to, tokenId);
873   }
874 
875   /**
876    * @dev See {IERC721-safeTransferFrom}.
877    */
878   function safeTransferFrom(
879     address from,
880     address to,
881     uint256 tokenId
882   ) public override {
883     safeTransferFrom(from, to, tokenId, "");
884   }
885 
886   /**
887    * @dev See {IERC721-safeTransferFrom}.
888    */
889   function safeTransferFrom(
890     address from,
891     address to,
892     uint256 tokenId,
893     bytes memory _data
894   ) public override {
895     _transfer(from, to, tokenId);
896     require(
897       _checkOnERC721Received(from, to, tokenId, _data),
898       "ERC721A: transfer to non ERC721Receiver implementer"
899     );
900   }
901 
902   /**
903    * @dev Returns whether `tokenId` exists.
904    *
905    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
906    *
907    * Tokens start existing when they are minted (`_mint`),
908    */
909   function _exists(uint256 tokenId) internal view returns (bool) {
910     return tokenId < currentIndex;
911   }
912 
913   function _safeMint(address to, uint256 quantity) internal {
914     _safeMint(to, quantity, "");
915   }
916 
917   /**
918    * @dev Mints `quantity` tokens and transfers them to `to`.
919    *
920    * Requirements:
921    *
922    * - there must be `quantity` tokens remaining unminted in the total collection.
923    * - `to` cannot be the zero address.
924    * - `quantity` cannot be larger than the max batch size.
925    *
926    * Emits a {Transfer} event.
927    */
928   function _safeMint(
929     address to,
930     uint256 quantity,
931     bytes memory _data
932   ) internal {
933     uint256 startTokenId = currentIndex;
934     require(to != address(0), "ERC721A: mint to the zero address");
935     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
936     require(!_exists(startTokenId), "ERC721A: token already minted");
937     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
938 
939     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
940 
941     AddressData memory addressData = _addressData[to];
942     _addressData[to] = AddressData(
943       addressData.balance + uint128(quantity),
944       addressData.numberMinted + uint128(quantity)
945     );
946     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
947 
948     uint256 updatedIndex = startTokenId;
949 
950     for (uint256 i = 0; i < quantity; i++) {
951       emit Transfer(address(0), to, updatedIndex);
952       require(
953         _checkOnERC721Received(address(0), to, updatedIndex, _data),
954         "ERC721A: transfer to non ERC721Receiver implementer"
955       );
956       updatedIndex++;
957     }
958 
959     currentIndex = updatedIndex;
960     _afterTokenTransfers(address(0), to, startTokenId, quantity);
961   }
962 
963   /**
964    * @dev Transfers `tokenId` from `from` to `to`.
965    *
966    * Requirements:
967    *
968    * - `to` cannot be the zero address.
969    * - `tokenId` token must be owned by `from`.
970    *
971    * Emits a {Transfer} event.
972    */
973   function _transfer(
974     address from,
975     address to,
976     uint256 tokenId
977   ) private {
978     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
979 
980     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
981       getApproved(tokenId) == _msgSender() ||
982       isApprovedForAll(prevOwnership.addr, _msgSender()));
983 
984     require(
985       isApprovedOrOwner,
986       "ERC721A: transfer caller is not owner nor approved"
987     );
988 
989     require(
990       prevOwnership.addr == from,
991       "ERC721A: transfer from incorrect owner"
992     );
993     require(to != address(0), "ERC721A: transfer to the zero address");
994 
995     _beforeTokenTransfers(from, to, tokenId, 1);
996 
997     // Clear approvals from the previous owner
998     _approve(address(0), tokenId, prevOwnership.addr);
999 
1000     _addressData[from].balance -= 1;
1001     _addressData[to].balance += 1;
1002     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1003 
1004     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1005     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1006     uint256 nextTokenId = tokenId + 1;
1007     if (_ownerships[nextTokenId].addr == address(0)) {
1008       if (_exists(nextTokenId)) {
1009         _ownerships[nextTokenId] = TokenOwnership(
1010           prevOwnership.addr,
1011           prevOwnership.startTimestamp
1012         );
1013       }
1014     }
1015 
1016     emit Transfer(from, to, tokenId);
1017     _afterTokenTransfers(from, to, tokenId, 1);
1018   }
1019 
1020   /**
1021    * @dev Approve `to` to operate on `tokenId`
1022    *
1023    * Emits a {Approval} event.
1024    */
1025   function _approve(
1026     address to,
1027     uint256 tokenId,
1028     address owner
1029   ) private {
1030     _tokenApprovals[tokenId] = to;
1031     emit Approval(owner, to, tokenId);
1032   }
1033 
1034   uint256 public nextOwnerToExplicitlySet = 0;
1035 
1036   /**
1037    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1038    */
1039   function _setOwnersExplicit(uint256 quantity) internal {
1040     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1041     require(quantity > 0, "quantity must be nonzero");
1042     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1043     if (endIndex > collectionSize - 1) {
1044       endIndex = collectionSize - 1;
1045     }
1046     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1047     require(_exists(endIndex), "not enough minted yet for this cleanup");
1048     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1049       if (_ownerships[i].addr == address(0)) {
1050         TokenOwnership memory ownership = ownershipOf(i);
1051         _ownerships[i] = TokenOwnership(
1052           ownership.addr,
1053           ownership.startTimestamp
1054         );
1055       }
1056     }
1057     nextOwnerToExplicitlySet = endIndex + 1;
1058   }
1059 
1060   /**
1061    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1062    * The call is not executed if the target address is not a contract.
1063    *
1064    * @param from address representing the previous owner of the given token ID
1065    * @param to target address that will receive the tokens
1066    * @param tokenId uint256 ID of the token to be transferred
1067    * @param _data bytes optional data to send along with the call
1068    * @return bool whether the call correctly returned the expected magic value
1069    */
1070   function _checkOnERC721Received(
1071     address from,
1072     address to,
1073     uint256 tokenId,
1074     bytes memory _data
1075   ) private returns (bool) {
1076     if (to.isContract()) {
1077       try
1078         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1079       returns (bytes4 retval) {
1080         return retval == IERC721Receiver(to).onERC721Received.selector;
1081       } catch (bytes memory reason) {
1082         if (reason.length == 0) {
1083           revert("ERC721A: transfer to non ERC721Receiver implementer");
1084         } else {
1085           assembly {
1086             revert(add(32, reason), mload(reason))
1087           }
1088         }
1089       }
1090     } else {
1091       return true;
1092     }
1093   }
1094 
1095   /**
1096    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1097    *
1098    * startTokenId - the first token id to be transferred
1099    * quantity - the amount to be transferred
1100    *
1101    * Calling conditions:
1102    *
1103    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1104    * transferred to `to`.
1105    * - When `from` is zero, `tokenId` will be minted for `to`.
1106    */
1107   function _beforeTokenTransfers(
1108     address from,
1109     address to,
1110     uint256 startTokenId,
1111     uint256 quantity
1112   ) internal virtual {}
1113 
1114   /**
1115    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1116    * minting.
1117    *
1118    * startTokenId - the first token id to be transferred
1119    * quantity - the amount to be transferred
1120    *
1121    * Calling conditions:
1122    *
1123    * - when `from` and `to` are both non-zero.
1124    * - `from` and `to` are never both zero.
1125    */
1126   function _afterTokenTransfers(
1127     address from,
1128     address to,
1129     uint256 startTokenId,
1130     uint256 quantity
1131   ) internal virtual {}
1132 }
1133 
1134 
1135 pragma solidity ^0.8.0;
1136 
1137 /**
1138  * @dev Contract module that helps prevent reentrant calls to a function.
1139  *
1140  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1141  * available, which can be applied to functions to make sure there are no nested
1142  * (reentrant) calls to them.
1143  *
1144  * Note that because there is a single `nonReentrant` guard, functions marked as
1145  * `nonReentrant` may not call one another. This can be worked around by making
1146  * those functions `private`, and then adding `external` `nonReentrant` entry
1147  * points to them.
1148  *
1149  * TIP: If you would like to learn more about reentrancy and alternative ways
1150  * to protect against it, check out our blog post
1151  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1152  */
1153 abstract contract ReentrancyGuard {
1154     // Booleans are more expensive than uint256 or any type that takes up a full
1155     // word because each write operation emits an extra SLOAD to first read the
1156     // slot's contents, replace the bits taken up by the boolean, and then write
1157     // back. This is the compiler's defense against contract upgrades and
1158     // pointer aliasing, and it cannot be disabled.
1159 
1160     // The values being non-zero value makes deployment a bit more expensive,
1161     // but in exchange the refund on every call to nonReentrant will be lower in
1162     // amount. Since refunds are capped to a percentage of the total
1163     // transaction's gas, it is best to keep them low in cases like this one, to
1164     // increase the likelihood of the full refund coming into effect.
1165     uint256 private constant _NOT_ENTERED = 1;
1166     uint256 private constant _ENTERED = 2;
1167 
1168     uint256 private _status;
1169 
1170     constructor() {
1171         _status = _NOT_ENTERED;
1172     }
1173 
1174     /**
1175      * @dev Prevents a contract from calling itself, directly or indirectly.
1176      * Calling a `nonReentrant` function from another `nonReentrant`
1177      * function is not supported. It is possible to prevent this from happening
1178      * by making the `nonReentrant` function external, and make it call a
1179      * `private` function that does the actual work.
1180      */
1181     modifier nonReentrant() {
1182         // On the first call to nonReentrant, _notEntered will be true
1183         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1184 
1185         // Any calls to nonReentrant after this point will fail
1186         _status = _ENTERED;
1187 
1188         _;
1189 
1190         // By storing the original value once again, a refund is triggered (see
1191         // https://eips.ethereum.org/EIPS/eip-2200)
1192         _status = _NOT_ENTERED;
1193     }
1194 }
1195 
1196 
1197 pragma solidity ^0.8.0;
1198 
1199 
1200 /**
1201  * @dev Contract module which provides a basic access control mechanism, where
1202  * there is an account (an owner) that can be granted exclusive access to
1203  * specific functions.
1204  *
1205  * By default, the owner account will be the one that deploys the contract. This
1206  * can later be changed with {transferOwnership}.
1207  *
1208  * This module is used through inheritance. It will make available the modifier
1209  * `onlyOwner`, which can be applied to your functions to restrict their use to
1210  * the owner.
1211  */
1212 abstract contract Ownable is Context {
1213     address private _owner;
1214 
1215     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1216 
1217     /**
1218      * @dev Initializes the contract setting the deployer as the initial owner.
1219      */
1220     constructor() {
1221         _setOwner(_msgSender());
1222     }
1223 
1224     /**
1225      * @dev Returns the address of the current owner.
1226      */
1227     function owner() public view virtual returns (address) {
1228         return _owner;
1229     }
1230 
1231     /**
1232      * @dev Throws if called by any account other than the owner.
1233      */
1234     modifier onlyOwner() {
1235         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1236         _;
1237     }
1238 
1239     /**
1240      * @dev Leaves the contract without owner. It will not be possible to call
1241      * `onlyOwner` functions anymore. Can only be called by the current owner.
1242      *
1243      * NOTE: Renouncing ownership will leave the contract without an owner,
1244      * thereby removing any functionality that is only available to the owner.
1245      */
1246     function renounceOwnership() public virtual onlyOwner {
1247         _setOwner(address(0));
1248     }
1249 
1250     /**
1251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1252      * Can only be called by the current owner.
1253      */
1254     function transferOwnership(address newOwner) public virtual onlyOwner {
1255         require(newOwner != address(0), "Ownable: new owner is the zero address");
1256         _setOwner(newOwner);
1257     }
1258 
1259     function _setOwner(address newOwner) private {
1260         address oldOwner = _owner;
1261         _owner = newOwner;
1262         emit OwnershipTransferred(oldOwner, newOwner);
1263     }
1264 }
1265 
1266 
1267 pragma solidity ^0.8.0;
1268 
1269 
1270 contract FuruGirls is Ownable, ERC721A, ReentrancyGuard {
1271   uint256 public maxPerAddressDuringMint;
1272   uint256 public amountForDevs;
1273   uint256 public price = 0.005 ether;
1274   uint256 public freemintAmount = 2;
1275   uint256 public mintAmount = 10;
1276 
1277   struct SaleConfig {
1278     uint64 publicPrice;
1279   }
1280 
1281   SaleConfig public saleConfig;
1282 
1283   mapping(address => uint256) public allowlist;
1284 
1285   constructor(
1286     uint256 maxBatchSize_,
1287     uint256 collectionSize_,
1288     uint256 collectionSizeFree_,
1289     uint256 amountForDevs_
1290   ) ERC721A("Furu Girls", "FG", maxBatchSize_, collectionSize_, collectionSizeFree_) {
1291     maxPerAddressDuringMint = 20;
1292     amountForDevs = amountForDevs_;
1293     
1294   }
1295 
1296   modifier callerIsUser() {
1297     require(tx.origin == msg.sender, "The caller is another contract");
1298     _;
1299   }
1300 
1301   function webmint(uint256 quantity)
1302     external
1303     payable
1304     callerIsUser
1305   {
1306       require(quantity <= mintAmount, "Too many minted at once");
1307       require(msg.value >= price * quantity, "Need to send more ETH.");
1308     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1309     _safeMint(msg.sender, quantity);
1310     
1311   }
1312 
1313 
1314   function mint(uint256 quantity) external payable {address _caller = _msgSender();
1315      
1316         require(quantity > 0, "No 0 mints");
1317         require(tx.origin == _caller, "No contracts"); 
1318 
1319         if(collectionSizeFree >= totalSupply())
1320 
1321         {require(freemintAmount >= quantity , "Excess max per free tx");} 
1322 
1323 
1324      else
1325      
1326      {require(mintAmount >= quantity , "Excess max per paid tx");
1327      
1328      require(msg.value >= price * quantity, "Need to send more ETH.");
1329      
1330      }
1331     
1332     _safeMint(msg.sender, quantity);
1333 
1334      }
1335 
1336   function seedAllowlist(address[] memory addresses, uint256[] memory numSlots)
1337     external
1338     onlyOwner
1339   {
1340     require(
1341       addresses.length == numSlots.length,
1342       "addresses does not match numSlots length"
1343     );
1344     for (uint256 i = 0; i < addresses.length; i++) {
1345       allowlist[addresses[i]] = numSlots[i];
1346     }
1347   }
1348 
1349   // For marketing etc.
1350   function Mint(uint256 quantity) external onlyOwner {
1351     
1352      require(totalSupply() + quantity <= amountForDevs, "reached max supply");
1353     _safeMint(msg.sender, quantity);
1354   }
1355     
1356 
1357   // // metadata URI
1358   string private _baseTokenURI;
1359 
1360   function _baseURI() internal view virtual override returns (string memory) {
1361     return _baseTokenURI;
1362   }
1363 
1364   function setBaseURI(string calldata baseURI) external onlyOwner {
1365     _baseTokenURI = baseURI;
1366   }
1367 
1368   function withdrawMoney() external onlyOwner nonReentrant {
1369     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1370     require(success, "Transfer failed.");
1371   }
1372 
1373   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1374     _setOwnersExplicit(quantity);
1375   }
1376 
1377   function numberMinted(address owner) public view returns (uint256) {
1378     return _numberMinted(owner);
1379   }
1380 
1381   function getOwnershipData(uint256 tokenId)
1382     external
1383     view
1384     returns (TokenOwnership memory)
1385   {
1386     return ownershipOf(tokenId);
1387   }
1388 
1389 function setprice(uint256 _newprice) public onlyOwner {
1390 	    price = _newprice;
1391 	}
1392 
1393   function setfreemints(uint256 _newfreemints) public onlyOwner {
1394 	    collectionSizeFree = _newfreemints;
1395 	}
1396 
1397     function setcollectionSize(uint256 _newcollectionSize) public onlyOwner {
1398 	    collectionSize = _newcollectionSize;
1399 	}
1400 
1401     function setamountForDevs(uint256 _newamountForDevs) public onlyOwner {
1402 	    amountForDevs = _newamountForDevs;
1403 	}
1404 
1405     function setfreemintAmount(uint256 _newfreemintAmount) public onlyOwner {
1406 	    freemintAmount = _newfreemintAmount;
1407 	}
1408 
1409     function setmintAmount(uint256 _newmintAmount) public onlyOwner {
1410 	    mintAmount = _newmintAmount;
1411 	}
1412 
1413 
1414 }